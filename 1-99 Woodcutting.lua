-- Import required modules
local API = require("api")
local UTILS = require("utils")

-- Internal required modules
local startTime = os.time()
local startXp = API.GetSkillXP("WOODCUTTING")
local afk = os.time()
local MAX_IDLE_TIME_MINUTES = 15

-- Define tree IDs
local tree = {38783, 38760} -- 1-9
local oak = {38731, 38732} -- 10-19
local willow = {38616, 38627, 58006} -- 20-39
local maple = {51843} -- 40-57
local eucalyptus = {70066, 70068, 70071} -- 58-67
local ivy = {86561, 86562, 86563, 86564} -- 67-99

-- Constant functions

-- Define the function to round numbers
local function round(val, decimal)
    if decimal then
        return math.floor((val * 10 ^ decimal) + 0.5) / (10 ^ decimal)
    else
        return math.floor(val + 0.5)
    end
end

-- Define the function to format numbers with commas as thousands separator
local function formatNumberWithCommas(amount)
    local formatted = tostring(amount)
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k == 0) then
            break
        end
    end
    return formatted
end

-- Define the function to format large numbers
function formatNumber(num)
    if num >= 1e6 then
        return string.format("%.1fM", num / 1e6)
    elseif num >= 1e3 then
        return string.format("%.1fK", num / 1e3)
    else
        return tostring(num)
    end
end

-- Define a function to format elapsed time to [hh:mm:ss]
local function formatElapsedTime(startTime)
    local currentTime = os.time()
    local elapsedTime = currentTime - startTime
    local hours = math.floor(elapsedTime / 3600)
    local minutes = math.floor((elapsedTime % 3600) / 60)
    local seconds = elapsedTime % 60
    return string.format("[%02d:%02d:%02d]", hours, minutes, seconds)
end

-- Define the idle check function
local function idleCheck()
    local timeDiff = os.difftime(os.time(), afk)
    local randomTime = math.random((MAX_IDLE_TIME_MINUTES * 60) * 0.6, (MAX_IDLE_TIME_MINUTES * 60) * 0.9)

    if timeDiff > randomTime then
        print("Eternal Mode Continuing.")
        API.PIdle2()
        afk = os.time()
    end
end

local function GrandExchange()
    print("Teleporting to Grand Exchange")
    API.WaitUntilMovingandAnimEnds()
    API.DoAction_Interface(0xffffffff, 0x9b80, 2, 1670, 45, -1, 3808)
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
    print("Teleported to Grand Exchange")
end

local function Yanille()
    print("Teleporting to Yanille")
    API.WaitUntilMovingandAnimEnds()
    API.DoAction_Interface(0x2e, 0xffffffff, 1, 1670, 123, -1, 3808)
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
    print("Teleported to Yanille")
end

local function Draynor()
    print("Teleporting to Draynor")
    API.WaitUntilMovingandAnimEnds()
    API.DoAction_Interface(0x2e, 0xffffffff, 1, 1670, 19, -1, 3808)
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
    print("Teleported to Draynor")
end

local function Seers()
    print("Teleporting to Seer's Village")
    API.WaitUntilMovingandAnimEnds()
    API.DoAction_Interface(0x2e, 0xffffffff, 1, 1670, 71, -1, 3808)
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
    print("Teleported to Seer's Village")
end

local function Ooglog()
    print("Teleporting to Oo'glog")
    API.WaitUntilMovingandAnimEnds()
    API.DoAction_Interface(0x2e, 0xffffffff, 1, 1670, 97, -1, 3808)
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
    print("Teleported to Oo'glog")
end

local function Ivywalk()
    print("Walking to some Ivy")
    API.WaitUntilMovingandAnimEnds()
    API.DoAction_Tile(WPOINT.new(3199, 3501, 0))
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
    print("Near some Ivy")
end

local function Willowwalk()
    print("Walking to some Willow")
    API.WaitUntilMovingandAnimEnds()
    API.DoAction_Tile(WPOINT.new(3075, 3245, 0))
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
    print("Near some Willow")
end

local function Maplewalk()
    print("Walking to some Maple")
    API.WaitUntilMovingandAnimEnds()
    API.DoAction_Tile(WPOINT.new(2726,3479,0))
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
    print("Near some Maple")
end

local function Loadpreset()
    print("Loading your last preset")
    API.WaitUntilMovingandAnimEnds()
    API.DoAction_NPC(0x33, 1888, {3418}, 50)
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
    print("Last preset loaded")
end

local function Chop()
    print("Attempting to chop tree")
    local skill = "WOODCUTTING"
    local currentExp = API.GetSkillXP(skill)
    local currentLevel = API.XPLevelTable(currentExp)
    local treeID

    if currentLevel >= 1 and currentLevel <= 9 then
        treeID = tree[1]
    elseif currentLevel >= 10 and currentLevel <= 19 then
        treeID = oak[1]
    elseif currentLevel >= 20 and currentLevel <= 39 then
        treeID = willow[1]
    elseif currentLevel >= 40 and currentLevel <= 57 then
        treeID = maple[1]
    elseif currentLevel >= 58 and currentLevel <= 67 then
        treeID = eucalyptus[1]
    else
        treeID = ivy[1]
    end

    API.DoAction_Object1(0x3b, 0, {treeID}, 50)
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
    print("Chopped tree")
end

local function Inventorycheck()
    if API.InvFull_() then
	print("Inventory full, banking")
        GrandExchange()
        Loadpreset()
	print("Banked, back to it")
    end
end

local scriptJustInitiated = true
local inventoryFull = false

-- Main loop
API.Write_LoopyLoop(true)
while(API.Read_LoopyLoop()) do
    idleCheck()
    API.DoRandomEvents()

    local currentLevel = API.XPLevelTable(API.GetSkillXP("WOODCUTTING"))

    if scriptJustInitiated or inventoryFull then
        if currentLevel >= 1 and currentLevel <= 9 then
            GrandExchange()
            Chop()
        elseif currentLevel >= 10 and currentLevel <= 19 then
            Yanille()
            Chop()
        elseif currentLevel >= 20 and currentLevel <= 39 then
            Seers()
            Chop()
        elseif currentLevel >= 40 and currentLevel <= 57 then
            Seers()
            Maplewalk()
            Chop()
        elseif currentLevel >= 58 and currentLevel <= 67 then
            Ooglog()
            Chop()
        elseif currentLevel >= 68 then
            GrandExchange()
            ivywalk()
            Chop()
        end
        scriptJustInitiated = false
        if inventoryFull then
            print("Inventory full flag set to false")
            inventoryFull = false
        end
    else
        Chop()
    end

    Inventorycheck() -- Check inventory after each action

    if API.InvFull_() then
        if not inventoryFull then
            print("Inventory full flag set to true")
            inventoryFull = true
        end
    else
        if inventoryFull then
            print("Inventory full flag set to false")
            inventoryFull = false
        end
    end
end

