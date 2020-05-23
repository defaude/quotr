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
        position = { top = 1000, left = 60, width = 240, height = 500 }
    }
}

function Quotr:OnInitialize()
    self:Debug('OnInitialize')

    -- set up saved variables
    self.db = LibStub('AceDB-3.0'):New('QuotrDB', defaults, true)
    self.config = self.db.global

    -- set up /quotr chat command
    LibStub('AceConsole-3.0'):RegisterChatCommand('quotr', function(input)
        self:Debug('SlashCommand', input)

        if (input == nil or input == '') then
            self:ShowWindow()

        elseif (input == 'reset') then
            self:ResetConfig()

        elseif (input == 'help') then
            local function line(command, description)
                return format('|cffffffff/quotr %-8s |cffffc700%s\n', command, description)
            end

            local message = 'You can use these commands:\n\n'
            message = message .. line('', 'Shows the Quotr UI')
            message = message .. line('help', 'Shows this help message')
            message = message .. line('reset', 'Resets the configuration to the defaults')

            self:Print(message)
        end
    end)
end

function Quotr:OnDisable()
    self:Debug('OnDisable')
    self:ReleaseUI()
end
--endregion

function Quotr:ReleaseUI()
    self:Debug('ReleaseUI')

    if (self.window) then
        AceGUI:Release(self.window)
        self.window = nil
    end
end

function Quotr:ShowWindow()
    self:Debug('ShowWindow')

    if (self.window) then
        self.window:Show()

    else
        self:InitWindow()
    end
end

function Quotr:ResetConfig()
    self:Debug('ResetConfig')
    self:ReleaseUI()

    self:Debug('Resetting database')
    self.db:ResetDB()
    self.config = self.db.global

    self:ShowWindow()
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

        -- This saves the width/height and the position somehow
        w:SetStatusTable(self.config.position)
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
        self.window = w

        --region scroll group auto-height
        local function UpdateHeight(height)
            -- make some space for the dropdown above as well some padding below
            scrollGroup:SetHeight(height - 70)
        end

        -- run it once
        UpdateHeight(w.frame:GetHeight())

        -- and on every resize
        w.frame:SetScript('OnSizeChanged', function(_, _, height)
            UpdateHeight(height)
        end)
        --endregion
    end
end
--endregion
