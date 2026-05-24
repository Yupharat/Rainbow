setfpscap(15)

local Players  = game:GetService("Players")
local RS       = game:GetService("ReplicatedStorage")
local LP       = Players.LocalPlayer

repeat task.wait() until LP.Character

-- Histo edition — cap ที่ Prehistoric (ไม่ไป Shinrin)
if game.PlaceId == 4869039553 then
    return
end

----------------------------------------------------
-- WORLD ORDER (Histo: stop at Prehistoric — ไม่รวม Shinrin)
----------------------------------------------------
local WORLD_ORDER = {
    { name = "Lobby",       placeId = 3475397644 },
    { name = "Undercity",   placeId = 4601778915 },
    { name = "Grassland",   placeId = 3475419198 },
    { name = "Jungle",      placeId = 3475422608 },
    { name = "Volcano",     placeId = 3487210751 },
    { name = "Tundra",      placeId = 3623549100 },
    { name = "Ocean",       placeId = 3737848045 },
    { name = "Desert",      placeId = 3752680052 },
    { name = "Fantasy",     placeId = 4174118306 },
    { name = "Toxic",       placeId = 4728805070 },
    { name = "Prehistoric", placeId = 4869039553 },
}

local function isWorldUnlocked(name)
    local worlds = LP:FindFirstChild("Data") and LP.Data:FindFirstChild("Worlds")
    if not worlds then return false end
    local w = worlds:FindFirstChild(name)
    return w and w.Value == true
end

if not isWorldUnlocked("Grassland") then
    print("Tutorial ยังไม่เสร็จ → SkipAllTutorial")
    local SetRemote = RS.Remotes:WaitForChild("SetTutorialStageRemote")
    local function set(s)
        local ok, res = pcall(function() return SetRemote:InvokeServer(s) end)
        print("SetStage:", s, "→", ok and tostring(res) or "FAIL")
        task.wait(0.2)
    end
    set("HatchingEggs")
    set("GrowingDragon")
    set("SkillsIntroduction")
    set("NextWorld")
    set("Complete")
    print("✅ Tutorial skipped")
    task.wait(1)
end

local tpRemote = RS.Remotes:WaitForChild("WorldTeleportRemote")

local function tpTo(world)
    print("🚀 TP ไป", world.name)
    while true do
        local ok, err = pcall(function()
            tpRemote:InvokeServer(world.placeId, {})
        end)
        if ok then break end
        warn("เซิฟเวอร์เต็ม ลองใหม่ใน 3 วิ... (" .. tostring(err) .. ")")
        task.wait(3)
    end
end

local function getHighest()
    -- Cap ที่ Prehistoric: ถึงแม้ Shinrin จะ unlock แล้ว ก็ไม่ไป
    local h = WORLD_ORDER[1]
    for _, w in ipairs(WORLD_ORDER) do
        if isWorldUnlocked(w.name) then h = w end
    end
    return h
end

while true do
    local highest = getHighest()
    print("🏆 Highest (Histo cap):", highest.name)

    if game.PlaceId ~= highest.placeId then
        tpTo(highest)
        task.wait(5)
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Yupharat/Rainbow/main/ca"))()

        while true do
            local newHighest = getHighest()
            if newHighest.placeId ~= game.PlaceId then
                tpTo(newHighest)
                break
            end
            task.wait(5)
        end
    end
end
