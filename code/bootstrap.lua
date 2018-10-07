local quotrName, quotr = ...

function quotr:init(_, name)
    if name ~= quotrName then return end
    quotr:log(quotr.Config.message)
end

-- create anonymous frame to register for global events
local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", quotr.init);
