function _cURL_argument_handler(arg::String)
    option_type = match(r"\w+(?=\s+')",arg).match
    content = match(r"(?<=').+(?=')",arg).match
    content_key = match(r".+(?=: )",content).match
    content_value = match(r"(?<=: ).+",content).match
    return (option_type,content_key=>content_value)
end


function cURL_parse(command::String="",from_clipboard::Bool=false,to_clipboard::Bool=false)
    !from_clipboard && isempty(command) && return throw(ArgumentError("Void string input"))
    # trim the command
    command = replace(command, r"curl\s|\s--compressed" => "")
    components = split(command," -")
    url = components[1]
    isnothing(match(r"http:.*",url)) && throw(ArgumentError("Invalid URL"))
    if length(components) > 2

    end
    println(command)
    code = ""
    if to_clipboard
        clipboard(code)
    else
        println(code)
    end
end
