-- Import required modules
local API = require("api")
local UTILS = require("utils")

-- Internal required modules
local startTime = os.time()
local startXp = API.GetSkillXP("MINING")
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
    local skill = "MINING"
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
    IGP.string_value = "Drakolith Mining"
end

function drawGUI()
    DrawProgressBar(IGP)
end

setupGUI()

-- Variable modules
local drakolith = {113071, 113072, 113073}  -- IDs of Drakolith ores
local banite = {113140, 113141, 113142} -- IDs of Banite ores

-- Define the function to shuffle a table
local function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

-- Define the function to teleport to the Grand Exchange
local function GETeleport()
    print("Ore box is full, teleporting to Grand Exchange.")
    API.DoAction_Interface(0xffffffff, 0x9b80, 2, 1670, 45, -1, 3808)
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000) -- Add sleep after teleporting
    print("Arrived at the Grand Exchange.")
end

--Define the function to interact with the banker
local function GEBanker()
    print("Attempting to bank with Banker...")
    API.RandomSleep2(2500, 3050, 12000) -- Add sleep for teleport loading screen
    API.DoAction_NPC(0x5, 1488, {3418}, 50)
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000) -- Add sleep after opening bank
    print("Successfully opened bank.")
end

--Define the function to empty the ore box
local function BankItems()
    print("Attempting to empty ore box...")
    API.RandomSleep2(2500, 3050, 12000) -- Add sleep before trying to empty ore box
    API.DoAction_Interface(0xffffffff, 0xaef9, 2, 517, 15, 0, 3808)
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000) -- Add sleep after banking ore box
    print("Attempting to load preset 1...")
    API.TypeOnkeyboard("1")  -- Press "1" key
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000) -- Add sleep after loading preset 1
    print("Successfully emptied ore box.")
end

--Define the function to use Varrock Lodestone, I have it on my second actionbar 10th slot if that matters.
local function VarrockTeleport()
    print("Activating Varrock Lodestone...")
    API.DoAction_Interface(0x2e, 0xffffffff, 1, 1670, 136, -1, 3808)
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000) -- Add sleep after teleporting to Varrock Lodestone
    print("Arrived at Varrock Lodestone.")
end

--Define the function to walk closer to the Al Kharid dungeon entrance.
local function DrakolithWalk()
    print("Getting closer to mining dungeon...")
    local x1 = 3227 + math.random(-3, 3)
    local y1 = 3354 + math.random(-3, 3)
    local x2 = 3258 + math.random(-3, 3)
    local y2 = 3335 + math.random(-3, 3)
    local x3 = 3286 + math.random(-3, 3)
    local y3 = 3310 + math.random(-3, 3)

    API.DoAction_Tile(WPOINT.new(x1, y1, 0))
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000) -- Add sleep after moving closer to mining dungeon
    API.DoAction_Tile(WPOINT.new(x2, y2, 0))
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000) -- Add sleep after moving closer to mining dungeon
    API.DoAction_Tile(WPOINT.new(x3, y3, 0))
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(5000, 8050, 12000) -- Add sleep after moving closer to mining dungeon
    print("Mining dungeon within sight.")
end

--Define the function to enter the Al Kharid dungeon entrance. 
local function AlKharidDungeon()
    print("Climbing over rocks...")
    API.DoAction_Object1(0xb5,0,{76210},50);
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(5000, 8050, 12000) -- Add sleep after climbing the rocks outside the dungeon
    print("Accessing mining dungeon...")
    API.RandomSleep2(5000, 8050, 12000)
    API.DoAction_Object1(0x39, 0, {52860}, 50)
    API.WaitUntilMovingandAnimEnds()
    print("Returned to dungeon from banking.")
end

-- Define a function to check if the player is near a certain coordinate
local function isNearCoordinate(x, y, tolerance)
    local playerX, playerY = API.GetPlayerLocation()  -- Assuming GetPlayerLocation returns player's x and y coordinates
    local distance = math.sqrt((playerX - x)^2 + (playerY - y)^2)
    return distance <= tolerance
end

-- Define the function to fill the ore box
local function FillOreBox()
    print("Attempting to fill ore box...")
    API.DoAction_Interface(0x24, 0xaef9, 1, 1473, 5, 0, 3808)
    API.WaitUntilMovingandAnimEnds()
    print("Successfully filled ore box.")
end

-- Define the function to mine rocks
local function MineRock(rockID)
    API.DoAction_Object_r(0x3a, 0, {rockID}, 50, FFPOINT.new(0, 0, 0), 50)
    API.WaitUntilMovingandAnimEnds()
end

--Define the function to use Edgeville Lodestone
local function EdgevilleTeleport()
    print("Teleporting to Edgeville Lodestone...")
    API.DoAction_Interface(0x2e,0xffffffff,1,1430,181,-1,3808)
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
    API.RandomSleep2(2500, 3050, 12000)
    print("Arrived at Edgeville Lodestone...")
end

--Define the function to walk to the Edgeville Bank and use the Bank Counter
local function EdgeBank()
    print("Walking to Edgeville Bank...")
    API.DoAction_Tile(WPOINT.new(3093,3493,0))
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
    print("Accessing bank counter...")
    API.DoAction_Object1(0x5,80,{42217},50)
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
    print("Bank has been opened...")
end

--Define the function to slash the web in the wilderness after using the Edgeville lever
local function SlashWeb()
    API.DoAction_Tile(WPOINT.new(3157,3948,0))
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
    API.DoAction_Object1(0x29,0,{65346},50)
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
    API.DoAction_Object1(0x29,0,{65346},50)
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
end

--Define the function to walk from the slashed web to the Banite rocks area
local function BaniteWalk()
    API.DoAction_Tile(WPOINT.new(3100,3959,0))
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
    API.DoAction_Tile(WPOINT.new(3064,3945,0))
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
end

--Define the function to use the Edgeville Lever
local function EdgeLever()
    API.DoAction_Object1(0x29,0,{1814},50)
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
    API.RandomSleep2(5000, 3050, 12000) -- Increased minimum sleep time by 2500 milliseconds
end

--Define the function to use the Forge by the Banite rocks to bank inventory and empty ore box
local function BaniteForge()
    API.DoAction_Object1(0x29,80,{113259},50)
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(2500, 3050, 12000)
end

-- Main loop environment
local scriptJustInitiated = true -- Initialize the variable to track script initiation
API.Write_LoopyLoop(true)
local lastGuiUpdateTime = os.time()
while(API.Read_LoopyLoop()) do
    -- Update GUI every second
    if os.time() - lastGuiUpdateTime >= 1 then
        drawGUI()
        lastGuiUpdateTime = os.time()
    end
    
    idleCheck()
    printProgressReport()
    API.DoRandomEvents()

    -- Check if the script has just initiated
    if scriptJustInitiated then
        -- Perform initial setup
        local Cselect = API.ScriptDialogWindow2("Mining", {
            "Drakolith Mining",
            "Banite Mining"  -- Added "Banite Mining" option
        }, "Start", "Close").Name;

        if "Drakolith Mining" == Cselect then
            GETeleport()
            GEBanker()
            BankItems()
            VarrockTeleport()
            DrakolithWalk()
            AlKharidDungeon()
            scriptJustInitiated = false  -- Update scriptJustInitiated after the initial setup
            -- Drakolith Mining actions
            if API.InvFull_() then
                if UTILS.getAmountInOrebox(UTILS.ORES.DRAKOLITH) < 120 then
                    FillOreBox()
                else
                    GETeleport()
                    GEBanker()
                    BankItems()
                    VarrockTeleport()
                    DrakolithWalk()
                    AlKharidDungeon()
                end
            else
                if API.Invfreecount_() > 0 then
                    print("idle check")
                    if not API.IsPlayerAnimating_(player, 3) then
                        API.RandomSleep2(1500, 6050, 2000)        
                        if not API.IsPlayerAnimating_(player, 2) then
                            print("idle so start mining...")
                            -- Shuffle the ore IDs
                            drakolith = shuffle(drakolith)
                            -- Mine the first ore in the shuffled list
                            MineRock(drakolith[1])
                            -- Wait until the mining animation ends before proceeding
                            API.WaitUntilMovingandAnimEnds()

                            -- Check for sparkling rocks while mining is idle
                            local foundSparkling = API.FindHl(0x3a, 0, drakolith, 50, { 7165, 7164 })
                            if foundSparkling then
                                print("Sparkle found")
                                MineRock(foundSparkling)  -- Mine the sparkling rock
                            end
                        end
                    end
                else
                    print(API.LocalPlayer_HoverProgress())
                    while API.LocalPlayer_HoverProgress() <= 90 do
                        print("no stamina..")
                        print(API.LocalPlayer_HoverProgress())
                        -- Try to find and mine a sparkling rock
                        local foundSparkling = API.FindHl(0x3a, 0, drakolith, 50, { 7165, 7164 })
                        if  foundSparkling then
                            print("Sparkle found")
                            MineRock(foundSparkling)  -- Mine the sparkling rock
                            API.RandomSleep2(2500, 3050, 12000)
                        else
                            -- If no sparkling rock was found, mine the first ore in the shuffled list
                            print("No Sparkle found")
                            MineRock(drakolith[1])
                            API.RandomSleep2(2500, 3050, 12000)
                        end
                    end
                end
            end
        elseif "Banite Mining" == Cselect then  -- Added condition for Banite Mining
            EdgevilleTeleport()
            EdgeBank()
            BankItems()
            EdgeLever()
            SlashWeb()
            BaniteWalk()
            scriptJustInitiated = false
        end
    else
        -- Banite Mining actions
        if API.InvFull_() then
            if UTILS.getAmountInOrebox(UTILS.ORES.BANITE) < 120 then
                FillOreBox()
            else
                BaniteForge()
            end
        else
            if API.Invfreecount_() > 0 then
                print("idle check")
                if not API.IsPlayerAnimating_(player, 3) then
                    API.RandomSleep2(1500, 6050, 2000)        
                    if not API.IsPlayerAnimating_(player, 2) then
                        print("idle so start mining...")
                        -- Shuffle the ore IDs
                        banite = shuffle(banite)
                        -- Mine the first ore in the shuffled list
                        MineRock(banite[1])
                        -- Wait until the mining animation ends before proceeding
                        API.WaitUntilMovingandAnimEnds()

                        -- Check for sparkling rocks while mining is idle
                        local foundSparkling = API.FindHl(0x3a, 0, banite, 50, { 7165, 7164 })
                        if foundSparkling then
                            print("Sparkle found")
                            MineRock(foundSparkling)  -- Mine the sparkling rock
                        end
                    end
                end
            else
                print(API.LocalPlayer_HoverProgress())
                while API.LocalPlayer_HoverProgress() <= 90 do
                    print("no stamina..")
                    print(API.LocalPlayer_HoverProgress())
                    -- Try to find and mine a sparkling rock
                    local foundSparkling = API.FindHl(0x3a, 0, banite, 50, { 7165, 7164 })
                    if  foundSparkling then
                        print("Sparkle found")
                        MineRock(foundSparkling)  -- Mine the sparkling rock
                        API.RandomSleep2(2500, 3050, 12000)
                    else
                        -- If no sparkling rock was found, mine the first ore in the shuffled list
                        print("No Sparkle found")
                        MineRock(banite[1])
                        API.RandomSleep2(2500, 3050, 12000)
                    end
                end
            end
        end
    end

    API.RandomSleep2(500, 3050, 12000)
end
