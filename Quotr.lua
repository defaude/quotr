Quotr = LibStub('AceAddon-3.0'):NewAddon('Quotr')
local AceGUI = LibStub('AceGUI-3.0')

--region chat stuff
local chatPrefix = '|cffffc700[|cffff8000Quotr|cffffc700]'

local function doPrint(color, ...)
    local prefixWithColor = chatPrefix .. color
    local fullMessage = string.join(' ', prefixWithColor, ...)
    DEFAULT_CHAT_FRAME:AddMessage(fullMessage)
end

function Quotr:Print(...)
    doPrint('', ...)
end

function Quotr:Debug(...)
    doPrint('|cffffffff', ...)
end

function Quotr:Error(...)
    doPrint('|cffff0000', ...)
end
--endregion

--region set up
local channels = { self = 'Self', party = 'Party', raid = 'Raid', guild = 'Guild' }

local defaults = {
    global = {
        channel = 'self',
        position = { top = 700, left = 200, width = 240, height = 500 }
    }
}

function Quotr:OnInitialize()
    self:Debug('OnInitialize')

    -- set up saved variables
    self.db = LibStub('AceDB-3.0'):New('QuotrDB', defaults, true)
    self.config = self.db.global

    -- set up /quotr chat command
    LibStub('AceConsole-3.0'):RegisterChatCommand('quotr', function(input)
        Quotr:Debug('SlashCommand', input)

        if (input == nil or input == '') then
            Quotr:ShowWindow()

        elseif (input == 'reset') then
            Quotr:Error('reset not yet implemented')
        end
    end)
end

function Quotr:OnDisable()
    self:Debug('OnDisable')
    if (self.scroll) then
        AceGUI:Release(self.scroll)
        self.scroll = nil
    end

    if (self.scrollGroup) then
        AceGUI:Release(self.scrollGroup)
        self.scrollGroup = nil
    end

    if (self.window) then
        AceGUI:Release(self.window)
        self.window = nil
    end
end
--endregion

function Quotr:ShowWindow()
    if (self.window) then
        self.window:Show()

    else
        self:InitWindow()
    end
end

--region GUI Init
function Quotr:InitWindow()
    self:Debug('InitWindow')
    if (not self.window) then
        self:Debug('Creating window...')
        --region window
        local w = AceGUI:Create('Window')
        w:SetTitle('[Quotr]')
        w:SetLayout('List')

        -- This saves the position somehow
        w:SetStatusTable(self.config.position)

        -- But the width and the height must be explicitly polled for whatever reason
        w.frame:SetScript('OnSizeChanged', function(_, width, height)
            self.config.position.width = width
            self.config.position.height = height
            self:HeightUpdated()
        end)
        --endregion

        --region channel select
        local channelSelect = AceGUI:Create('Dropdown')
        channelSelect:SetList(channels)
        channelSelect:SetValue(self.config.channel)
        channelSelect:SetFullWidth(true)
        channelSelect:SetCallback('OnValueChanged', function(_, _, value)
            self:Debug('OnValueChanged', value)
            self.config.channel = value
        end)
        w:AddChild(channelSelect)
        --endregion

        --region quotes
        local scrollGroup = AceGUI:Create('InlineGroup')
        scrollGroup:SetTitle('Sounds')
        scrollGroup:SetLayout('Fill')
        scrollGroup:SetFullWidth(true)
        w:AddChild(scrollGroup)

        local scroll = AceGUI:Create('ScrollFrame')
        scroll:SetLayout('List')
        scrollGroup:AddChild(scroll)
        --endregion

        -- Store some references in the addon object
        self.scroll = scroll
        self.scrollGroup = scrollGroup
        self.window = w
        self:HeightUpdated()
    end
end

function Quotr:HeightUpdated()
    if (self.scrollGroup) then
        self.scrollGroup:SetHeight(self.config.position.height - 70)
    end
end
--endregion
