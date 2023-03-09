function _cURL_argument_handler(arg::AbstractString)
    option_type = match(r"\w+(?=\s+')",arg).match
    content = match(r"(?<=').+(?=')",arg).match
    content_key = match(r".+(?=: )",content).match
    content_value = match(r"(?<=: ).+",content).match
    return (option_type,content_key=>content_value)
end

function _generate_dict(pair_vec::Vector{<:Pair})
    dict_code = "Dict(\n"
    for pair in pair_vec
        if pair == last(pair_vec)
            dict_code *= "$pair\n)" 
        else
            dict_code *= "$pair,\n"
        end
    end
    return dict_code
end

"""
    cURL_parse(command,to_clipboard=false)

Receive a (now very specific form of) bash cURL command and translate it into a piece of julia code.

If command is not specified, clipboard content will be taken.
"""
function cURL_translate(command::String="",to_clipboard::Bool=false)
    if isempty(command)
        command = clipboard()
    end
    # trim the command
    command = replace(command, r"curl\s|\s--compressed" => "")
    components = split(command,r"\s*(\\\\)*\s+-")
    url = components[1]
    isnothing(match(r"http:.*",url)) && throw(ArgumentError("Invalid URL"))
    # generate code
    if length(components) > 2
        arguments = map(_cURL_argument_handler,components[2:end])
        headers = [x[2] for x in arguments if x[1] =="H"]
        header_dict = "headers="*_generate_dict(headers)
        request_code = "HTTP.get($url,headers=headers)"
        code = header_dict*"\n"*request_code
    else
        code = "HTTP.get($url)"
    end
    if to_clipboard
        clipboard(code)
    else
        println(code)
    end
end