Quotr = LibStub('AceAddon-3.0'):NewAddon('Quotr', 'AceConsole-3.0')
local AceGUI = LibStub("AceGUI-3.0")

-- Deliberately overriding AceConsole's print method to make it look prettier :)
function Quotr:Print(...)
    DEFAULT_CHAT_FRAME:AddMessage(string.join(' ', '|cffffc700[|cffff8000Quotr|cffffc700]', ...))
end

local channels = {
    self = 'self',
    guild = 'guild',
    raid = 'raid',
    party = 'party'
}

local defaults = {
    global = {
        channel = channels.self
    }
}

function Quotr:OnInitialize()
    self.db = LibStub('AceDB-3.0'):New('QuotrDB', defaults, true)

    self:RegisterChatCommand('quotr', 'ShowDemoFrame')
end

function Quotr:OnEnable()
    self:Print('Addon enabled.')
end

function Quotr:ShowDemoFrame()
    local textStore

    local frame = AceGUI:Create("Frame")
    frame:SetTitle("Example Frame")
    frame:SetStatusText("AceGUI-3.0 Example Container Frame")
    frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    frame:SetLayout("Flow")

    local editbox = AceGUI:Create("EditBox")
    editbox:SetLabel("Insert text:")
    editbox:SetWidth(200)
    editbox:SetCallback("OnEnterPressed", function(widget, event, text) textStore = text end)
    frame:AddChild(editbox)

    local button = AceGUI:Create("Button")
    button:SetText("Click Me!")
    button:SetWidth(200)
    button:SetCallback("OnClick", function()
        if not textStore then
            self:Print('Well, you SHOULD press enter first...')

        else
            self:Print(textStore)
        end
    end)
    frame:AddChild(button)
end

