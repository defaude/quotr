local qName, quotr = ...

quotr.Config = {
    message = 'hello, world'
};

local logPrefix = '|cffff8000[' .. qName .. ']|r'

function quotr:log(...)
    local message = string.join(' ', logPrefix, ...)
    DEFAULT_CHAT_FRAME:AddMessage(message)
end
