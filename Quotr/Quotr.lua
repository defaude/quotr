Quotr = LibStub('AceAddon-3.0'):NewAddon('Quotr', 'AceConsole-3.0')

-- Deliberately overriding AceConsole's print method to make it look prettier :)
function Quotr:Print(...)
    DEFAULT_CHAT_FRAME:AddMessage(string.join(' ', '|cffffc700[|cffff8000Quotr|cffffc700]', ...))
end

local channels = {
    guild = 'guild',
    raid = 'raid',
    party = 'party'
}

local defaults = {
    global = {
        channel = channels.guild
    }
}

function Quotr:OnInitialize()
    self.db = LibStub('AceDB-3.0'):New('QuotrDB', defaults, true)
end

function Quotr:OnEnable()
    self:Print('Addon enabled.')
end


