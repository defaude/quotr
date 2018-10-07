local quotrName, quotr = ...

quotr.Config = {
    message = 'hello, world'
};

local logPrefix = '|cffff8000[' .. quotrName .. ']|r'

function quotr:log(...)
    local message = string.join(' ', logPrefix, ...)
    DEFAULT_CHAT_FRAME:AddMessage(message)
end

function quotr:printHelloWorld()
    quotr:log(quotr.Config.message)
end
