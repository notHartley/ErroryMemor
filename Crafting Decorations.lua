-- Crafting Decorations by notHartley v1.0 12/03/2024
local API = require("api")
API.SetMaxIdleTime(5)

-- IDs
local unfinishedCrate = 128787
local decorationBench = 128793
local workInProgressDecoration = 56169
local unfinishedDecoration = 56168
local finishedCrate = 128788
local finishedDecoration = 56170

-- Function to check and deposit finished decoration
local function checkAndDepositFinishedDecoration()
    if API.InvItemcount_1(finishedDecoration) > 0 then
        print("Finished Decoration detected, so depositing finished decoration...")
        API.DoAction_Object1(0x29, API.OFF_ACT_GeneralObject_route0, {finishedCrate}, 50)
        API.WaitUntilMovingandAnimEnds()
    end
end

-- Function to create decoration on bench
local function createDecoration()
    if API.InvItemcount_1(workInProgressDecoration) > 0 or API.InvItemcount_1(unfinishedDecoration) > 0 then
        print("Unfinished or in-progress decoration detected, so creating decoration on the bench...")
        API.DoAction_Object1(0xae, API.OFF_ACT_GeneralObject_route0, {decorationBench}, 50)
        API.WaitUntilMovingandAnimEnds()
    end
end

-- Function to take unfinished decoration
local function takeUnfinishedDecoration()
    if API.InvItemcount_1(workInProgressDecoration) == 0 and 
       API.InvItemcount_1(unfinishedDecoration) == 0 and 
       API.InvItemcount_1(finishedDecoration) == 0 then
        print("No decoration detected, so taking unfinished decoration...")
        API.DoAction_Object1(0x2d, API.OFF_ACT_GeneralObject_route0, {unfinishedCrate}, 50)
        API.WaitUntilMovingandAnimEnds()
    end
end

-- Main loop
API.SetDrawLogs(true)
API.GetTrackedSkills(true)
API.SetDrawTrackedSkills(true)
API.Write_LoopyLoop(true)

while API.Read_LoopyLoop() do
    checkAndDepositFinishedDecoration()
    createDecoration()
    takeUnfinishedDecoration()
end
