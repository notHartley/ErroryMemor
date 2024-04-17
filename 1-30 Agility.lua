-- Import required modules
local API = require("api")
local UTILS = require("utils")

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

-- Add GUI related functions
local function calcProgressPercentage(skill, currentExp)
    local currentLevel = API.XPLevelTable(API.GetSkillXP(skill))
    if currentLevel == 120 then return 100 end
    local nextLevelExp = XPForLevel(currentLevel + 1)
    local currentLevelExp = XPForLevel(currentLevel)
    local progressPercentage = (currentExp - currentLevelExp) / (nextLevelExp - currentLevelExp) * 100
    return math.floor(progressPercentage)
end

local function printProgressReport(final)
    local skill = "AGILITY"
    local currentXp = API.GetSkillXP(skill)
    local elapsedMinutes = (os.time() - startTime) / 60
    local diffXp = math.abs(currentXp - startXp)
    local xpPH = round((diffXp * 60) / elapsedMinutes)
    local time = formatElapsedTime(startTime)
    local currentLevel = API.XPLevelTable(API.GetSkillXP(skill))
    IGP.radius = calcProgressPercentage(skill, API.GetSkillXP(skill)) / 100
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

-- Main Loop
API.Write_LoopyLoop(true)
local actions = {
    {WalkLog, "Walking on log", 7500}, -- Delay for WalkLog
    {ObstacleNet1, "Climbing obstacle net 1", 2600}, -- Delay for ObstacleNet1
    {TreeBranch1, "Balancing on tree branch 1", 1500}, -- Delay for TreeBranch1
    {BalancingRope, "Walking on balancing rope", 6000}, -- Delay for BalancingRope
    {TreeBranch2, "Balancing on tree branch 2", 2250}, -- Delay for TreeBranch2
    {ObstacleNet2, "Climbing obstacle net 2", 5300}, -- Delay for ObstacleNet2
    {ObstaclePipe, "Crawling through obstacle pipe", 5300} -- Delay for ObstaclePipe
}
local currentIndex = 1

-- Function to wait until animation completion with a timeout
local function waitForAnimationCompletion(timeout)
    local startTime = os.time()
    while API.IsPlayerAnimating_(0, 0) do
        idleCheck()
        API.DoRandomEvents()
        drawGUI()
        local elapsedTime = os.time() - startTime
        if elapsedTime >= timeout then
            print("Timeout reached while waiting for animation completion.")
            break
        end
        API.RandomSleep2(500, 1000, 1500) -- Adjust sleep duration as needed
    end
end

-- Function to wait until both animation and action completion
local function waitForActionCompletion(actionFunc, delay)
    waitForAnimationCompletion(10) -- Maximum wait time for animation completion (in seconds)
    actionFunc() -- Execute the action function after animation completes
    API.RandomSleep2(delay, delay + 500, delay + 1000) -- Additional delay after action completion
end

while API.Read_LoopyLoop() do
    idleCheck()
    API.DoRandomEvents()
    drawGUI()
    
    local currentAction = actions[currentIndex]
    if currentAction then
        local actionFunction = currentAction[1]
        local actionName = currentAction[2]
        local delay = currentAction[3] or 3000 -- Default delay if not specified
        print("Performing action: " .. actionName)
        waitForActionCompletion(actionFunction, delay)
        
        -- Update progress report
        printProgressReport()
        
        currentIndex = currentIndex % #actions + 1
    else
        -- All actions completed, reset to the first one
        currentIndex = 1
    end
end
