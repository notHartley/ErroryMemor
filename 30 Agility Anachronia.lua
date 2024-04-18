-- Import required modules
local API = require("api")
local UTILS = require("utils")
local player = API.GetLocalPlayerName()

-- Internal required modules
local startTime = os.time()
local startXp = API.GetSkillXP("AGILITY")
local afk = os.time() -- Initialize the variable afk
local MAX_IDLE_TIME_MINUTES = 15 -- Define the maximum idle time in minutes

-- Constant modules
-- Define the function to round numbers
local function round(val, decimal)
    if decimal then
        return math.floor((val * 10 ^ decimal) + 0.5) / (10 ^ decimal)
    else
        return math.floor(val + 0.5)
    end
end

-- Define a function to format numbers with commas as thousands separator
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

-- Function to check if the player is at the specified coordinates
local function checkPlayerCoordinates(targetCoords)
    local playerPos = API.PlayerCoordfloat()
    local playerX, playerY = math.floor(playerPos.x), math.floor(playerPos.y)
    return playerX == targetCoords[1] and playerY == targetCoords[2]
end

-- Function to wait until the player reaches the target coordinates or a timeout occurs
local function waitForPlayerMovement(targetCoords)
    local startTime = os.time()
    while not checkPlayerCoordinates(targetCoords) do
        idleCheck()
        API.DoRandomEvents()
        drawGUI()
        local currentTime = os.time()
        if currentTime - startTime >= 10 then -- Adjust timeout as needed (in seconds)
            print("Timeout reached while waiting for player movement.")
            return false
        end
        API.RandomSleep2(1000, 1500, 2000) -- Adjust sleep duration as needed
    end
    return true
end

-- Add GUI related functions
local function calcProgressPercentage(skill, currentExp)
    local currentLevel = API.XPLevelTable(API.GetSkillXP(skill))
    if currentLevel == 120 then return 100 end
    local nextLevelExp = XPForLevel(currentLevel + 1)
    local currentLevelExp = XPForLevel(currentLevel)
    local progressPercentage = (currentExp - currentLevelExp) / (nextLevelExp - currentLevelExp) * 100
    return math.floor(progressPercentage)
end

-- Function to print progress report
local function printProgressReport()
    local skill = "AGILITY"
    local currentXp = API.GetSkillXP(skill)
    local elapsedMinutes = (os.time() - startTime) / 60
    local diffXp = math.abs(currentXp - startXp)
    local xpPH = round((diffXp * 60) / elapsedMinutes)
    local time = formatElapsedTime(startTime)
    local currentLevel = API.XPLevelTable(currentXp)
    IGP.radius = calcProgressPercentage(skill, currentXp) / 100
    IGP.string_value = time ..
            " | " ..
            string.lower(skill):gsub("^%l", string.upper) ..
            ": " .. currentLevel .. " | XP/H: " .. formatNumber(xpPH) .. " | XP: " .. formatNumber(diffXp)
end

local function setupGUI()
    IGP = API.CreateIG_answer()
    IGP.box_start = FFPOINT.new(5, 5, 0)
    IGP.box_name = "PROGRESSBAR"
    IGP.colour = ImColor.new(116, 2, 179)
    IGP.string_value = "1-30 Agility"
end

function drawGUI()
    DrawProgressBar(IGP)
end

setupGUI()

--main functions
local function cliffFace1()
API.DoAction_Object1(0xb5,0,{113738},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

local function cliffFace2()
API.DoAction_Object1(0xb5,0,{113737},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

local function ruinedTemple1()
API.DoAction_Object1(0xb5,0,{113736},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

local function ruinedTemple2()
API.DoAction_Object1(0xb5,0,{113735},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

local function caveEntrance()
API.DoAction_Object1(0xb5,0,{113734},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

local function crossRoots()
API.DoAction_Object1(0xb5,0,{113733},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

local function ruinedTemple3()
API.DoAction_Object1(0xb5,0,{113732},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

local function ruinedTemple4()
API.DoAction_Object1(0xb5,0,{113731},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

local function ruinedTemple5()
API.DoAction_Object1(0xb5,0,{113730},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

local function ruinedTemple6()
API.DoAction_Object1(0xb5,0,{113729},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

local function ruinedTemple7()
API.DoAction_Object1(0xb5,0,{113728},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

local function traverseBones1()
API.DoAction_Object1(0xb5,0,{113727},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

local function crossSpine()
API.DoAction_Object1(0xb5,0,{113726},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

local function traverseBones2()
API.DoAction_Object1(0xb5,0,{113725},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

-- Main Loop
API.Write_LoopyLoop(true)

local beginner = {
    {cliffFace1, "Traversing the cliff", {5428, 2383}}, -- If player is at 5428,2383, then cliffFace1()
    {cliffFace2, "Traversing the cliff", {5428, 2386}}, -- If player is at 5428,2386, then cliffFace2()
    {ruinedTemple1, "Crossing the temple", {5426, 2390}}, -- If player is at 2474, 3429, then ruinedTemple1() 
    {ruinedTemple2, "Crossing the temple", {5425, 2403}}, -- If player is at 2473, 3423, then ruinedTemple2() 
    {caveEntrance, "Crawling through the cave", {5431, 2413}}, -- If player is at 2473, 3420, then caveEntrance()
    {crossRoots, "Crossing the roots", {5482, 2456}}, -- If player is at 2483, 3420, then crossRoots()
    {crossRoots, "Crossing the roots", {5491, 2456}}, -- If player is at 2487, 3417, then crossRoots()
    {caveEntrance, "Crawling through the cave", {5484, 2456}}, -- If player is at 2487, 3427, then caveEntrance()
    {ruinedTemple2, "Crossing the temple", {5431, 2417}}, -- If player is at 5431, 2417, then ruinedTemple2()
    {ruinedTemple1, "Crossing the temple", {5431, 2407}}, -- If player is at 5431, 2407, then ruinedTemple1()
    {cliffFace2, "Traversing the cliff", {5425, 2397}}, -- If player is at 5425, 2397, then cliffFace2()
    {cliffFace1, "Traversing the cliff", {5426, 2387}}, -- If player is at 5436, 2387, then cliffFace1()
}

local novice = {
    {cliffFace1, "Traversing the cliff", {5428, 2383}}, -- If player is at 5428,2383, then cliffFace1()
    {cliffFace2, "Traversing the cliff", {5428, 2386}}, -- If player is at 5428,2386, then cliffFace2()
    {ruinedTemple1, "Crossing the temple", {5426, 2390}}, -- If player is at 2474, 3429, then ruinedTemple1() 
    {ruinedTemple2, "Crossing the temple", {5425, 2403}}, -- If player is at 2473, 3423, then ruinedTemple2() 
    {caveEntrance, "Crawling through the cave", {5431, 2413}}, -- If player is at 2473, 3420, then caveEntrance()
    {crossRoots, "Crossing the roots", {5482, 2456}}, -- If player is at 2483, 3420, then crossRoots()
    {ruinedTemple3, "Crossing the temple", {5491, 2456}}, -- If player is at 5491,2456, then ruinedTemple3()
    {ruinedTemple4, "Crossing the temple", {5505, 2466}}, -- If player is at 5505,2466, then ruinedTemple4() 
    {ruinedTemple5, "Crossing the temple", {5505, 2476}}, -- If player is at 5505,2476, then ruinedTemple5() 
    {ruinedTemple6, "Crossing the temple", {5505, 2481}}, -- If player is at 5505,2481, then ruinedTemple6() 
    {ruinedTemple7, "Crossing the temple", {5532, 2492}}, -- If player is at 5532,2492, then ruinedTemple7()
    {traverseBones1, "Traversing the bones", {5544, 2492}}, -- If player is at 5544,2492, then traverseBones1()
    {crossSpine, "Crossing the spine", {5571, 2452}}, -- If player is at 5571,2452, then crossSpine()
    {traverseBones2, "Traversing the bones", {5581, 2453}}, -- If player is at 5581,2453, then traverseBones2()
    {traverseBones2, "Traversing the bones", {5591, 2452}}, -- If player is at 5591,2452, then traverseBones2()
    {crossSpine, "Crossing the spine", {5584, 2452}}, -- If player is at 5584,2452, then crossSpine()
    {traverseBones1, "Traversing the bones", {5574, 2453}}, -- If player is at 5574,2453, then traverseBones1()
    {ruinedTemple7, "Crossing the temple", {5564, 2452}}, -- If player is at 5564,2452, then ruinedTemple7()
    {ruinedTemple6, "Crossing the temple", {5536, 2492}}, -- If player is at 5536,2492, then ruinedTemple6()
    {ruinedTemple5, "Crossing the temple", {5528, 2492}}, -- If player is at 5528,2492, then ruinedTemple5()
    {ruinedTemple4, "Crossing the temple", {5505, 2478}}, -- If player is at 5505,2478, then ruinedTemple4()
    {ruinedTemple3, "Crossing the temple", {5505, 2468}}, -- If player is at 5505,2468, then ruinedTemple3()
    {crossRoots, "Crossing the roots", {5505, 2462}}, -- If player is at 5505,2462, then crossRoots()
    {caveEntrance, "Crawling through the cave", {5484, 2456}}, -- If player is at 2487, 3427, then caveEntrance()
    {ruinedTemple2, "Crossing the temple", {5431, 2417}}, -- If player is at 5431, 2417, then ruinedTemple2()
    {ruinedTemple1, "Crossing the temple", {5431, 2407}}, -- If player is at 5431, 2407, then ruinedTemple1()
    {cliffFace2, "Traversing the cliff", {5425, 2397}}, -- If player is at 5425, 2397, then cliffFace2()
    {cliffFace1, "Traversing the cliff", {5426, 2387}} -- If player is at 5436, 2387, then cliffFace1()
}

local currentLevel = API.XPLevelTable(API.GetSkillXP("AGILITY"))

local actions = beginner
if currentLevel >= 50 and currentLevel <= 69 then
    actions = novice
end

local function executeAction(actionData)
    local actionFunction = actionData[1]
    local actionName = actionData[2]
    local targetCoords = actionData[3]
    
    print("Starting action:", actionName)
    actionFunction() -- Perform the action
    print("Player reached target coordinates.")
end

while API.Read_LoopyLoop() do
    idleCheck()
    API.DoRandomEvents()
    drawGUI()
    printProgressReport()
    
    local playerPos = API.PlayerCoordfloat()
    local playerX, playerY = math.floor(playerPos.x), math.floor(playerPos.y)
    
    for _, actionData in ipairs(actions) do
        local targetCoords = actionData[3]
        if playerX == targetCoords[1] and playerY == targetCoords[2] then
            executeAction(actionData)
            break
        end
    end
    
    API.RandomSleep2(1000, 1500, 2000) -- Adjust sleep duration as needed
end
