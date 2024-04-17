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
local function WalkLog()
API.DoAction_Object1(0xb5,0,{69526},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

local function ObstacleNet1()
API.DoAction_Object1(0xb5,0,{69383},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

local function TreeBranch1()
API.DoAction_Object1(0xb5,0,{69508},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

local function BalancingRope()
API.DoAction_Object1(0xb5,0,{2312},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

local function TreeBranch2()
API.DoAction_Object1(0x35,0,{69507},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

local function ObstacleNet2()
API.DoAction_Object1(0xb5,0,{69384},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

local function ObstaclePipe()
API.DoAction_Object1(0xb5,0,{69378},50)
API.CheckAnim()
API.WaitUntilMovingandAnimEnds()
end

-- Function to wait until the player has stopped moving and is not interacting with any objects
local function waitForPlayerReady()
    local startTime = os.time()
    while API.ReadPlayerMovin() or API.PlayerInterActing_() do
        idleCheck()
        API.DoRandomEvents()
        drawGUI()
        local currentTime = os.time()
        if currentTime - startTime >= 10 then -- Timeout after 10 seconds
            print("Timeout reached while waiting for player to be ready.")
            return false
        end
        API.RandomSleep2(1000, 1500, 2000) -- Adjust sleep duration as needed
    end
    return true
end

-- Main Loop
API.Write_LoopyLoop(true)
local actions = {
    {WalkLog, "Walking on log", {2483, 3437}},
    {ObstacleNet1, "Climbing obstacle net 1", {2474, 3429}},
    {TreeBranch1, "Balancing on tree branch 1", {2473, 3423}},
    {BalancingRope, "Walking on balancing rope", {2473, 3420}},
    {TreeBranch2, "Balancing on tree branch 2", {2483, 3420}},
    {ObstacleNet2, "Climbing obstacle net 2", {2487, 3417}},
    {ObstaclePipe, "Crawling through obstacle pipe", {2487, 3427}}
}
local currentIndex = 1
local previousActionIndex = nil
local retryCount = 0

-- Function to check if the player is not busy
local function isPlayerNotBusy()
    return not API.PlayerInterActing_(API.Local_PlayerInterActingWith_())
end
-- Function to wait until the player has stopped moving and is not interacting with any objects
local function waitForPlayerReady()
    local startTime = os.time()
    while API.ReadPlayerMovin() or API.PlayerInterActing_() do
        idleCheck()
        API.DoRandomEvents()
        drawGUI()
        local currentTime = os.time()
        if currentTime - startTime >= 10 then -- Timeout after 10 seconds
            print("Timeout reached while waiting for player to be ready.")
            return false
        end
        API.RandomSleep2(1000, 1500, 2000) -- Adjust sleep duration as needed
    end
    return true
end

while API.Read_LoopyLoop() do
    idleCheck()
    API.DoRandomEvents()
    drawGUI()
    printProgressReport()
    
    for _, actionData in ipairs(actions) do
        local actionFunction = actionData[1]
        local actionName = actionData[2]
        local targetCoords = actionData[3]
        
        if checkPlayerCoordinates(targetCoords) then
            if isPlayerNotBusy() then
                print("Starting action:", actionName)
                actionFunction() -- Perform the action
                
                print("Player reached target coordinates.")
                break -- Exit the loop and wait for the next iteration
            else
                print("Player is busy. Waiting...")
                API.RandomSleep2(1000, 1500, 2000) -- Wait and try again
            end
        else
            print("Player not at target coordinates for:", actionName)
        end
    end
end
