local quotrName, quotr = ...

function quotr:ADDON_LOADED(_, name)
    if name ~= quotrName then return end

    quotr:printHelloWorld()
    quotr:addSlashCommand()
end

-- create anonymous frame to register for global events
local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", quotr.ADDON_LOADED);
