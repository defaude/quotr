local quotrName, quotr = ...

-- based on https://github.com/Mayron/CreatingWoWAddOns/blob/master/Episode%207/AuraTracker/init.lua

quotr.commands = {
    ["help"] = function()
        quotr:log("List of available commands:")
        quotr:log("|cff00cc66/" .. quotrName .. " help|r shows this help");
        quotr:log("|cff00cc66/" .. quotrName .. " hello|r prints the \"hello world\" message");
        quotr:log("|cff00cc66/" .. quotrName .. " log <your message here>|r prints your message");
    end,
    ["hello"] = function()
        quotr:printHelloWorld()
    end,
    ["log"] = function(...)
        quotr:log(tostringall(...));
    end
};

local function HandleSlashCommands(str)
    if (#str == 0) then
        -- User just entered "/quotr" with no additional args.
        quotr.commands.help();
        return;
    end

    local args = {};
    for _, arg in ipairs({ string.split(' ', str) }) do
        if (#arg > 0) then
            table.insert(args, arg);
        end
    end

    local path = quotr.commands; -- required for updating found table.

    for id, arg in ipairs(args) do
        if (#arg > 0) then -- if string length is greater than 0.
            arg = arg:lower();
            if (path[arg]) then
                if (type(path[arg]) == "function") then
                    -- all remaining args passed to our function!
                    path[arg](select(id + 1, unpack(args)));
                    return;
                elseif (type(path[arg]) == "table") then
                    path = path[arg]; -- another sub-table found!
                end

            else
                -- does not exist!
                quotr.commands.help();
                return;
            end
        end
    end
end

function quotr:addSlashCommand()
    --noinspection GlobalCreationOutsideO
    SLASH_quotr1 = '/' .. quotrName -- should be "/quotr", of course
    SlashCmdList.quotr = HandleSlashCommands
end
