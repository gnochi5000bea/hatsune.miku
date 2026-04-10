local Services: { [string]: any } = setmetatable({ }, {
	__index = function(Self: any, Index: string): any
		return cloneref(game.GetService(game, Index));
	end
});

local Environment: any =
	(getgenv and function(): any
		return getgenv()
	end)
	or function(): { [string]: any }
		return {}
	end

local IsFile: (Path: string) -> boolean = isfile or function(_: string): boolean return false end
local WriteFile: (Path: string, Contents: string) -> () = writefile or function(_: string, _: string): () end
local ReadFile: (Path: string) -> string = readfile or function(_: string): string return "" end
local GetConnections: (Event: any) -> () = getconnections or function(...) return { } end
local GetUpvalue: (Upvalue: any) -> () = debug.getupvalue or function(...) end
local GetUpvalues: (Upvalue: any) -> () = debug.getupvalues or function(...) end
local LoadFile: (Path: string) -> () = loadfile or function(_: string): () end
local DetourFn: (any) -> () = hookfunction or function(_: any): () end

local Request: ((Options: any) -> any)? =
	(syn and syn.request)
	or (http and http.request)
	or request

local GetCustomAsset: (Path: string) -> string =
	getcustomasset or function(_: string): string return "" end

--// Math
local Floor: (number) -> number = math.floor
local Ceil: (number) -> number = math.ceil
local Abs: (number) -> number = math.abs
local Sign: (number) -> number =
	math.sign or function(X: number): number
		if X > 0 then
			return 1
		elseif X < 0 then
			return -1
		else
			return 0
		end
	end

local Max: (...number) -> number = math.max
local Min: (...number) -> number = math.min
local Huge: number = math.huge
local Random: (number?, number?) -> number = math.random
local RandomSeed: (number) -> () = math.randomseed or function(_: number): () end
local Rad: (number) -> number = math.rad
local Deg: (number) -> number = math.deg

local Clamp: (number, number, number) -> number =
	function(Value: number, Min: number, Max: number): number
		return (Value < Min and Min) or (Value > Max and Max) or Value
	end

local Lerp: (number, number, number) -> number =
	math.lerp or function(A: number, B: number, T: number): number
		return A + (B - A) * T
	end

local Round: (number) -> number =
	math.round or function(X: number): number
		return Floor(X + 0.5)
	end

--// Table
local Insert: <T>(Tbl: { T }, Value: T) -> () = table.insert
local Remove: <T>(Tbl: { T }, Index: number?) -> T? = table.remove
local Concat: (Tbl: { string }, Sep: string?, I: number?, J: number?) -> string = table.concat
local Sort: <T>(Tbl: { T }, Comp: ((T, T) -> boolean)?) -> () = table.sort

local TFind: <T>(Tbl: { T }, Value: T) -> number? =
	table.find or function<T>(T: { T }, V: T): number?
		for I = 1, #T do
			if T[I] == V then
				return I
			end
		end
		return nil
	end

local Clear: (Tbl: { [any]: any }) -> () =
	table.clear or function(T: { [any]: any }): ()
		for K in T do
			T[K] = nil
		end
	end

local Pack: (...any) -> { n: number, [number]: any } =
	table.pack or function(...: any): { n: number, [number]: any }
		return { n = select("#", ...), ... }
	end

--// String
local Lower: (string) -> string = string.lower
local Upper: (string) -> string = string.upper
local Find: (string, string, number?, boolean?) -> (number?, number?, ...string) = string.find
local GSub: (string, string, string | ((...any) -> string), number?) -> (string, number) = string.gsub
local Gmatch: (string, string) -> (() -> string?) = string.gmatch
local Match: (string, string, number?) -> string? = string.match
local Reverse: (string) -> string = string.reverse

local Split: (string, string) -> { string } =
	string.split or function(S: string, Sep: string): { string }
		local Out: { string } = {}
		for Part in S:gmatch("([^" .. Sep .. "]+)") do
			Insert(Out, Part)
		end
		return Out
	end

local Format: (string, ...any) -> string = string.format

--// OS / Task
local Time: () -> number = os.time
local Clock: () -> number = os.clock
local Date: (string?, number?) -> any = os.date

local Tick: () -> number = tick or Time

local Wait: (number?) -> number = (task and task.wait) or wait
local Spawn: (thread | (() -> ()), ...any) -> () = (task and task.spawn) or spawn
local Defer: ((...any) -> (), ...any) -> () =
	(task and task.defer)
	or function(F: (...any) -> (), ...: any): ()
		local Co = coroutine.create(F)
		coroutine.resume(Co, ...)
	end

local Delay: (number, (...any) -> (), ...any) -> () = (task and task.delay) or delay
local Cancel: (thread) -> () = (task and task.cancel) or function(_: thread): () end

local Vec2: (number, number) -> Vector2 = Vector2.new
local Vec3: (number, number, number) -> Vector3 = Vector3.new
local Vec3Empty: Vector3 = Vector3.zero
local UDim2New: (number, number, number, number) -> UDim2 = UDim2.new
local UDimNew: (number, number) -> UDim = UDim.new
local InstanceNew: (string) -> Instance = Instance.new
local Color3New: (number, number, number) -> Color3 = Color3.new
local Color3FromRGB: (number, number, number) -> Color3 = Color3.fromRGB
local Color3FromHSV: (number, number, number, number) -> Color3 = Color3.fromHSV
local CFrameNew: (...any) -> CFrame = CFrame.new
local CFrameAngles: (...any) -> CFrame = CFrame.Angles
local CFrameLookAt: (...any) -> CFrame = CFrame.lookAt

local ColorSequenceNew: (any) -> ColorSequence = ColorSequence.new
local ColorSequenceKeypointNew: (number, Color3) -> ColorSequenceKeypoint = ColorSequenceKeypoint.new
local NumberSequenceNew: (any) -> NumberSequence = NumberSequence.new
local NumberSequenceKeypointNew: (number, number, number?) -> NumberSequenceKeypoint =
	NumberSequenceKeypoint.new

repeat Wait() until game:IsLoaded()

local HttpService: HttpService = Services["HttpService"]
local CoreGui: CoreGui = Services["CoreGui"]
local CollectionService: CollectionService = Services["CollectionService"]
local ReplicatedStorage: ReplicatedStorage = Services["ReplicatedStorage"]
local PlayerService: Players = Services["Players"]
local UserInputService: UserInputService = Services["UserInputService"]
local VirtualInputManager: Instance = InstanceNew("VirtualInputManager")
local VirtualUser: VirtualUser = Services["VirtualUser"]
local GuiService: GuiService = Services["GuiService"]
local RunService: RunService = Services["RunService"]
local MarketplaceService: MarketplaceService = Services["MarketplaceService"]
local LogService: LogService = Services["LogService"]
local ScriptContext: ScriptContext = Services["ScriptContext"]

local LocalPlayer: Player = PlayerService.LocalPlayer
local Camera: Instance = workspace.CurrentCamera
local PlayerGui: PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ClickFishRemote: RemoteEvent = ReplicatedStorage:WaitForChild("ClickFish")
local ClickBobberRemote: RemoteEvent = ReplicatedStorage:WaitForChild("ClickBobber")
local SellFishRemote: RemoteEvent = ReplicatedStorage:WaitForChild("SellFish")
local BuyUpgradeRemote: RemoteEvent = ReplicatedStorage:WaitForChild("BuyUpgrade")
local DoPrestigeRemote: RemoteEvent = ReplicatedStorage:WaitForChild("DoPrestige")
local CrackGeodeRemote: RemoteEvent = ReplicatedStorage:WaitForChild("CrackGeode")
local BuyEquipmentRemote: RemoteEvent = ReplicatedStorage:WaitForChild("BuyEquipment")
local RemoveEquipmentRemote: RemoteEvent = ReplicatedStorage:WaitForChild("RemoveEquipment")
local ClaimExpeditionRemote: RemoteEvent = ReplicatedStorage:WaitForChild("ClaimExpedition")
local LaunchExpeditionRemote: RemoteEvent = ReplicatedStorage:WaitForChild("LaunchExpedition")
local EquipFishRemote: RemoteEvent = ReplicatedStorage:WaitForChild("EquipFish")
local UnequipFishRemote: RemoteEvent = ReplicatedStorage:WaitForChild("UnequipFish")
local PlaceTreasureDecorRemote: RemoteEvent = ReplicatedStorage:WaitForChild("PlaceTreasureDecor")
local RemoveTreasureDecorRemote: RemoteEvent = ReplicatedStorage:WaitForChild("RemoveTreasureDecor")
local GetMarketData: RemoteFunction = ReplicatedStorage:WaitForChild("GetMarketData")
local GetUpgrades: RemoteFunction = ReplicatedStorage:WaitForChild("GetUpgrades")
local GetPrestige: RemoteFunction = ReplicatedStorage:WaitForChild("GetPrestige")
local GetGeodes: RemoteFunction = ReplicatedStorage:WaitForChild("GetGeodes")
local GetFleetData: RemoteFunction = ReplicatedStorage:WaitForChild("GetFleetData")
local GetExpeditions: RemoteFunction = ReplicatedStorage:WaitForChild("GetExpeditions")
local GetStats: RemoteFunction = ReplicatedStorage:WaitForChild("GetStats")
local GetAquarium: RemoteFunction = ReplicatedStorage:WaitForChild("GetAquarium")
local BobberReward: RemoteEvent = ReplicatedStorage:WaitForChild("BobberReward")
local SellResult: RemoteEvent = ReplicatedStorage:WaitForChild("SellResult")
local UpdateStats: RemoteEvent = ReplicatedStorage:WaitForChild("UpdateStats")
local BobberUI: ModuleScript = require(LocalPlayer.PlayerScripts.Client.UI.BobberUI)
local FishOS: ScreenGui = PlayerGui:WaitForChild("FishOS")
local Desktop: TextButton = FishOS:WaitForChild("Desktop")

local Library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/gnochi5000bea/hatsune.miku/refs/heads/main/ui.lua"))()

local StartupArgs = Pack((...))[1] or { };

do
	for Index, Connection in GetConnections(LogService.MessageOut) do
		if Connection and Connection.Function then
			DetourFn(Connection.Function, newcclosure(function(...)
				return;
			end));
		end;
	end;

	for Index, Connection in GetConnections(ScriptContext.Error) do
		if Connection and Connection.Function then
			DetourFn(Connection.Function, newcclosure(function(...)
				return;
			end));
		end;
	end;

	DetourFn(Services.Stats.GetMemoryUsageMbForTag, function()
		return coroutine.yield();
	end)
end;

local Miku: { [string]: any } = {
    ["Information"] = {
        ["Name"] = "hatsune.miku",
        ["Version"] = "v1.1",
        ["Discord"] = "https://discord.gg/bGrrwbSMUX"
    },
    
    ["Statistics"] = {
        ["Uptime"] = Tick(),
        ["Fish Gained"] = 0,
        ["Last Fish"] = nil
    },
    
    ["Cache"] = {
        ["_time"] = {
            ["Click"] = Tick(),
            ["Sell"] = Tick(),
            ["Upgrade"] = Tick(),
            ["Prestige"] = Tick(),
            ["Crack Geode"] = Tick(),
            ["Fleet"] = Tick(),
            ["Expedition"] = Tick(),
            ["Player Information"] = Tick(),
            ["Auto equip"] = Tick()
        },

        ["_statuses"] = {
            ["Auto-upgrade"] = false,
            ["Auto-crack geodes"] = false,
            ["Auto-fleet management"] = false,
            ["Auto-expedition"] = false,
            ["Auto-equip"] = false
        },

        ["_cache"] = {
            ["Player Data"] = {
                coins = 0,
                fish = 0,
                blackPearls = 0
            },
            ["Elements"] = {
                ["Equip status"] = nil
            }
        }
    },

    ["Game"] = {
        ["Buffs"] = {
            "Fish slowdown",
            "Offline earnings",
            "All earnings",
            "Fish per click",
            "Fish per second",
            "Black pearl value",
            "Catch bar size",
            "Market price bonus",
            "Black pearl chance",
            "Mystery drop rate",
            "Coin earnings",
            "Equipment output",
            "Dive speed",
            "Rare chance",
            "Prestige bonus"
        },
        
        ["Mappings"] = {
            ["Rarity Colors"] = {
                ["Common"] = 0xAAAAAA,
                ["Uncommon"] = 0x2ECC71,
                ["Rare"] = 0x3498DB,
                ["Epic"] = 0x9B59B6,
                ["Legendary"] = 0xFFB800,
                ["Mythic"] = 0xFF00FF
            },

            ["Buff Types"] = {
                ["Fish slowdown"] = "fishSlowdown",
                ["Offline earnings"] = "offlineEarnings",
                ["All earnings"] = "allEarnings",
                ["Fish per click"] = "fishPerClick",
                ["Fish per second"] = "fishPerSecond" or "fishPerSec",
                ["Black pearl value"] = "goldenValue",
                ["Catch bar size"] = "catchBarSize",
                ["Market price bonus"] = "marketPriceBonus",
                ["Black pearl chance"] = "goldenChance",
                ["Mystery drop rate"] = "mysteryDropRate",
                ["Coin earnings"] = "coinEarnings",
                ["Equipment output"] = "equipmentOutput",
                ["Dive speed"] = "expeditionSpeed",
                ["Rare chance"] = "rareChance",
                ["Prestige bonus"] = "prestigeMult"
            }
        }
    }
}

do
    local PlayerData = GetStats:InvokeServer()

    if PlayerData then
        for Key, Value in pairs(PlayerData) do
            if Miku["Cache"]["_cache"]["Player Data"][Key] ~= nil then
                Miku["Cache"]["_cache"]["Player Data"][Key] = Value
            end
        end
    end
end

function Miku:SendWebhook(URL, Content, Embed)
    local Time = Date("*t")
    local Body = HttpService:JSONEncode({
        ["content"] = Content,
        ["embeds"] = {
            {
                ["title"] = Embed.Title,
                ["type"] = "rich",
                ["color"] = Embed.Color,
                ["fields"] = Embed.Fields,
                ["footer"] = {
                    ["text"] = self["Information"]["Discord"] .. " | " .. Format("%04d-%02d-%02d %02d:%02d:%02d", Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec)
                }
            }
        },
        ["username"] = self["Information"]["Name"],
        ["avatar_url"] = "https://cdn.discordapp.com/icons/1201769093058002954/85baae41f933417bc723f12e4818c030.webp"
    })

    local Response = Request({
            Url = URL,
            Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = Body
    })

    return Response
end

function Miku:GetWebhookContent(Category: string): string
    if not TFind(Library:GetFlag("Pings") or {}, Category) then
        return ""
    end

    local UserId = Library:GetFlag("User id")
    if UserId == "everyone" then
        return "@everyone"
    elseif UserId == "here" then
        return "@here"
    else
        return "<@" .. UserId .. ">"
    end
end

function Miku:FormatTime(Seconds: number): string
    local Days = Floor(Seconds / 86400)
    local Hours = Floor((Seconds % 86400) / 3600)
    local Minutes = Floor((Seconds % 3600) / 60)
    local Secs = Seconds % 60

    return Format("%dd %dh %dm %ds", Days, Hours, Minutes, Secs)
end

function Miku:GenerateChangelog(Section: any, Entries: { string }, Date: string): ()
    local Colors = {
        ["+"] = "#28a745",
        ["~"] = "#ffc107",
        ["-"] = "#d73a49"
    }
    
    local Changelog = ""
    for idx, Entry in ipairs(Entries) do
        local Symbol = Entry:match("^%[(.-)%]")
        local Color = Colors[Symbol]
        
        local Line
        if Color then
            Line = Format(
                '\t<font color="%s">%s</font>',
                Color,
                Entry
            )
        else
            Line = "\t" .. Entry
        end

        if idx ~= #Entries then
            Line = Line .. "\n"
        end

        Changelog = Changelog .. Line
    end

    Section:Paragraph(Changelog)
    Section:Label(Date .. " - " .. Miku["Information"]["Discord"])
end

function Miku:PrettifyNumber(Number: number): string
    return tostring(Number):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

function Miku:PrettifyString(String: string): string
    if String == "" then
        return String
    end
    
    local Result = String:gsub("(%u)", " %1")
    Result = GSub(Result, "^%s+", "")
    Result = Result:sub(1, 1):upper() .. Result:sub(2)

    return Result
end

function Miku:FormatNumber(Number)
    local AbsoluteNumber = math.abs(Number)

    if AbsoluteNumber >= 1e12 then
        return string.format("%.2fT", Number / 1e12)
    elseif AbsoluteNumber >= 1e9 then
        return string.format("%.2fB", Number / 1e9)
    elseif AbsoluteNumber >= 1e6 then
        return string.format("%.2fM", Number / 1e6)
    elseif AbsoluteNumber >= 1e3 then
        return string.format("%.2fK", Number / 1e3)
    else
        return tostring(Number)
    end
end

function Miku:Dump(T: any, Indent: number, Seen: { [any]: boolean }): string
    Indent = Indent or 0
    Seen = Seen or {}

    local prefix = string.rep("  ", Indent)

    if type(T) == "table" then
        if Seen[T] then
            return prefix .. "<circular>"
        end
        Seen[T] = true

        local result = "{\n"
        for k, v in pairs(T) do
            local key
            if type(k) == "string" then
                key = k
            else
                key = "[" .. tostring(k) .. "]"
            end
            result = result .. prefix .. "  " .. key .. " = " .. Miku:Dump(v, Indent + 1, Seen) .. "\n"
        end
        result = result .. prefix .. "}"
        return result
    elseif type(T) == "string" then
        return '"' .. T .. '"'
    else
        return tostring(T)
    end
end

do
    if not LPH_OBFUSCATED then
        Miku["Information"]["Version"] = Miku["Information"]["Version"] .. " dev"
    end
end

local function RarityToColor(Rarity)
    return Miku["Game"]["Mappings"]["Rarity Colors"][Rarity] or 0xFFFFFF
end

local function FormatModifiers(Mods)
    if not Mods or Mods.modifierCount == 0 then return "None" end

    local Result = ""
    if Mods.sheen then
        Result = Result .. "✨ " .. Mods.sheen.name .. " (+" .. (Mods.sheen.statBonus * 100) .. "% " .. Miku:PrettifyString(Mods.sheen.statType) .. ")\n"
    end

    if Mods.trait then
        Result = Result .. "⚡ " .. Mods.trait.name .. " (+" .. (Mods.trait.statBonus * 100) .. "% " .. Miku:PrettifyString(Mods.trait.statType) .. ")\n"
    end
    return Result ~= "" and Result or "None"
end

local function FormatStatBonuses(StatBonuses)
    if not StatBonuses then return "None" end
    local Result = ""
    for stat, value in pairs(StatBonuses) do
        Result = Result .. "+" .. (value * 100) .. "% " .. Miku:PrettifyString(stat) .. "\n"
    end
    return Result ~= "" and Result or "None"
end

local function OnCatch(Data, URL)
    if not Library:GetFlag("Webhook enabled") or not TFind(Library:GetFlag("Webhooks"), "Bobber reward") then return end
    if not Data.success then return end

    local category = Data.category

    if category == "mystery" then
        local fish = Data.mystery
        local mods = fish.modifiers

        local Content = Miku:GetWebhookContent("Bobber reward")

        Miku:SendWebhook(Library:GetFlag("Webhook url"), Content, {
            Title = "🐟 Mystery Fish Caught!",
            Color = RarityToColor(mods and mods.effectiveRarity or fish.rarity),
            Fields = {
                {
                    name   = "Fish",
                    value  = fish.displayName or fish.name,
                    inline = true
                },
                {
                    name   = "Rarity",
                    value  = (mods and mods.effectiveRarity) or fish.rarity,
                    inline = true
                },
                {
                    name   = "Buff",
                    value  = "+" .. Floor(fish.buff * 100) .. "% " .. Miku:PrettifyString(fish.buffType),
                    inline = false
                },
                {
                    name   = "Stat Bonuses",
                    value  = FormatStatBonuses(mods and mods.statBonuses),
                    inline = false
                },
                {
                    name   = "Modifiers",
                    value  = FormatModifiers(mods),
                    inline = false
                },
            }
        })
    elseif category == "collection" then
        local fish = Data.collection
        local mods = fish.modifiers

        local Content = Miku:GetWebhookContent("Bobber reward")

        Miku:SendWebhook(Library:GetFlag("Webhook url"), Content, {
            Title = "🎣 Collection Fish Caught!",
            Color = RarityToColor(mods and mods.effectiveRarity or fish.rarity),
            Fields = {
                {
                    name   = "Fish",
                    value  = (mods and mods.displayName) or fish.name,
                    inline = true
                },
                {
                    name   = "Rarity",
                    value  = (mods and mods.effectiveRarity) or fish.rarity,
                    inline = true
                },
                {
                    name   = "Buff",
                    value  = "+" .. Floor(fish.buff * 100) .. "% " .. Miku:PrettifyString(fish.buffType),
                    inline = false
                },
                {
                    name   = "Stat Bonuses",
                    value  = FormatStatBonuses(mods and mods.statBonuses),
                    inline = false
                },
                {
                    name   = "Modifiers",
                    value  = FormatModifiers(mods),
                    inline = false
                },
            }
        })
    elseif category == "treasure" then
        local treasure = Data.treasure

        local Content = Miku:GetWebhookContent("Bobber reward")

        Miku:SendWebhook(Library:GetFlag("Webhook url"), Content, {
            Title = "🪙 Treasure Found!",
            Color = RarityToColor(treasure.rarity or "Common"),
            Fields = {
                {
                    name   = "Item",
                    value  = treasure.name or "Unknown",
                    inline = true
                },
                {
                    name   = "Type",
                    value  = treasure.type and Miku:PrettifyString(treasure.type) or "Unknown",
                    inline = true
                },
                {
                    name   = "Amount",
                    value  = treasure.amount and Miku:PrettifyNumber(treasure.amount) or "N/A",
                    inline = true
                },
            }
        })

    elseif category == "junk" then
        local junk = Data.junk

        local Content = Miku:GetWebhookContent("Bobber reward")

        local Response = Miku:SendWebhook(Library:GetFlag("Webhook url"), Content, {
            Title = "🗑️ Junk Caught",
            Color = 0x888888,
            Fields = {
                {
                    name   = "Item",
                    value  = junk.name or "Unknown",
                    inline = true
                }
            }
        })
    end
end

local function GetBestUpgrade(UpgradeData)
    local Best = nil
    local BestRatio = 0

    for idx, Rod in ipairs(UpgradeData.rods) do
        local Maxed = Rod.level >= 10
        local Affordable = Rod.cost <= UpgradeData.coins

        if not Maxed and Affordable then
            local Ratio = Rod.fishPerClick / Rod.cost
            
            if Ratio > BestRatio then
                BestRatio = Ratio
                Best = Rod
            end
        end
    end

    return Best
end

local function GetWorstEquipment(Boat)
    local Worst = nil
    local WorstFPS = math.huge

    for idx, Equip in ipairs(Boat.equipment) do
        if Equip.fishPerSec < WorstFPS then
            WorstFPS = Equip.fishPerSec
            Worst = Equip
        end
    end

    return Worst
end

local function GetBestEquipment(Boat, Coins)
    local Best = nil
    local BestFPS = 0

    for idx, Item in ipairs(Boat.equipmentShop) do
        if Item.fishPerSec > BestFPS and Item.cost <= Coins then
            BestFPS = Item.fishPerSec
            Best = Item
        end
    end

    return Best
end

local function GetFishBuffValue(Fish, TargetStat)
    local Total = 0

    if Fish.buffType == TargetStat then
        Total = Total + (Fish.buff or 0)
    end

    if Fish.modifiers and Fish.modifiers.statBonuses then
        Total = Total + (Fish.modifiers.statBonuses[TargetStat] or 0)
    end

    return Total
end

local function GetDecorationBuffValue(Treasure, TargetStat)
    if Treasure.buffType ~= TargetStat then return 0 end

    local Base = (Treasure.buffValue or 0) * (Treasure.conditionMult or 1)
    local Enchant = Treasure.enchantmentBonus or 0

    return Base + Enchant
end

local function ProcessBoat(Boat, Coins)
    local MaxSlots  = Boat.slots.max
    local SlotsUsed = Boat.slots.used
    local BoatIndex = Boat.boatIndex

    local Best = GetBestEquipment(Boat, Coins)
    if not Best then
        Miku["Cache"]["_statuses"]["Auto-fleet management"] = false

        return
    end

    if SlotsUsed < MaxSlots then
        BuyEquipmentRemote:FireServer(BoatIndex, Best.equipIndex)
    else
        local Worst = GetWorstEquipment(Boat)

        if Worst and Worst.fishPerSec < Best.fishPerSec then
            RemoveEquipmentRemote:FireServer(BoatIndex, Worst.slotIndex)

            task.wait(0.3)

            BuyEquipmentRemote:FireServer(BoatIndex, Best.equipIndex)
        end
    end
end

local function GetBestExpedition(ExpeditionTypes, Coins)
    local Best = nil
    local BestTier = 0

    for _, Expedition in ipairs(ExpeditionTypes) do
        if Expedition.cost <= Coins and Expedition.chestTier > BestTier then
            BestTier = Expedition.chestTier
            Best = Expedition
        end
    end

    return Best
end

local function AutoEquip(FishTargetStat, DecorationTargetStat)
    local ok, Data = pcall(function()
        return GetAquarium:InvokeServer()
    end)

    if not ok or not Data then
        Miku["Cache"]["_statuses"]["Auto-equip"] = false

        Miku["Cache"]["_cache"]["Elements"]["Equip status"]:SetText("Failed to retrieve aquarium data.")

        Wait(2)

        Miku["Cache"]["_cache"]["Elements"]["Equip status"]:SetText("Status: Idle, waiting for next cycle...")

        return
    end

    Miku["Cache"]["_cache"]["Elements"]["Equip status"]:SetText("Status: Unequipping all fish...")

    for i = #Data.equipped, 1, -1 do
        pcall(function()
            UnequipFishRemote:FireServer(i)
        end)

        Wait(0.3)
    end

    Miku["Cache"]["_cache"]["Elements"]["Equip status"]:SetText("Status: Removing all decorations...")

    for i = 1, Data.decorationSlots do
        local Slot = Data.decorations[i]
        if Slot and type(Slot) == "table" then
            pcall(function()
                RemoveTreasureDecorRemote:FireServer(i)
            end)

            Wait(0.3)
        end
    end

    local ScoredFish = {}
    local ScoredTreasures = {}

    for _, Fish in ipairs(Data.collection) do
        local Score = GetFishBuffValue(Fish, FishTargetStat)

        Insert(ScoredFish, { Fish = Fish, Score = Score })
    end
    
    for _, Treasure in ipairs(Data.treasureInventory) do
        local Score = GetDecorationBuffValue(Treasure, DecorationTargetStat)

        Insert(ScoredTreasures, { Treasure = Treasure, Score = Score })
    end

    Sort(ScoredFish, function(A, B) return A.Score > B.Score end)
    Sort(ScoredTreasures, function(A, B) return A.Score > B.Score end)

    Miku["Cache"]["_cache"]["Elements"]["Equip status"]:SetText(Format("Status: Equipping best fish for stat: %s", FishTargetStat))

    local Equipped = 0
    local EquippedIds = {}

    for _, Entry in ipairs(ScoredFish) do
        if Equipped >= Data.maxSlots then break end

        local Label = Entry.Score > 0 and Format("+%.3f %s", Entry.Score, FishTargetStat) or "fallback (no stat)"
        Miku["Cache"]["_cache"]["Elements"]["Equip status"]:SetText(Format("Status: Equipping fish '%s' (%s)", Entry.Fish.displayName or Entry.Fish.name, Label))

        pcall(function()
            EquipFishRemote:FireServer(Entry.Fish.id)
        end)

        EquippedIds[Entry.Fish.id] = true
        Equipped = Equipped + 1

        Wait(0.3)
    end

    if Equipped < Data.maxSlots then
        Miku["Cache"]["_cache"]["Elements"]["Equip status"]:SetText("Status: Not enough fish for stat, filling remaining slots with any fish...")

        for _, Fish in ipairs(Data.collection) do
            if Equipped >= Data.maxSlots then break end

            if not EquippedIds[Fish.id] then
                Miku["Cache"]["_cache"]["Elements"]["Equip status"]:SetText(Format("Status: Fallback equipping fish '%s'", Fish.displayName or Fish.name))

                pcall(function()
                    EquipFishRemote:FireServer(Fish.id)
                end)

                EquippedIds[Fish.id] = true
                Equipped = Equipped + 1

                Wait(0.3)
            end
        end
    end

    Miku["Cache"]["_cache"]["Elements"]["Equip status"]:SetText(Format("Status: Placing best decorations for stat: %s", DecorationTargetStat))

    local Placed = 0
    local PlacedIds = {}

    for _, Entry in ipairs(ScoredTreasures) do
        if Placed >= Data.decorationSlots then break end

        local SlotIndex = Placed + 1
        local Label = Entry.Score > 0 and Format("+%.3f %s", Entry.Score, DecorationTargetStat) or "fallback (no stat)"
        Miku["Cache"]["_cache"]["Elements"]["Equip status"]:SetText(Format("Status: Placing decoration '%s' (%s) in slot %d", Entry.Treasure.name, Label, SlotIndex))

        pcall(function()
            PlaceTreasureDecorRemote:FireServer(Entry.Treasure.instanceId, SlotIndex)
        end)

        PlacedIds[Entry.Treasure.instanceId] = true
        Placed = Placed + 1

        Wait(0.3)
    end

    if Placed < Data.decorationSlots then
        Miku["Cache"]["_cache"]["Elements"]["Equip status"]:SetText("Status: Not enough decorations for stat, filling remaining slots with any treasure...")

        for _, Treasure in ipairs(Data.treasureInventory) do
            if Placed >= Data.decorationSlots then break end

            if not PlacedIds[Treasure.instanceId] then
                local SlotIndex = Placed + 1
                Miku["Cache"]["_cache"]["Elements"]["Equip status"]:SetText(Format("Status: Fallback placing decoration '%s' in slot %d", Treasure.name, SlotIndex))

                pcall(function()
                    PlaceTreasureDecorRemote:FireServer(Treasure.instanceId, SlotIndex)
                end)

                PlacedIds[Treasure.instanceId] = true
                Placed = Placed + 1

                Wait(0.3)
            end
        end
    end

    Miku["Cache"]["_cache"]["Elements"]["Equip status"]:SetText(Format("Status: Done! Equipped %d/%d fish for stat: %s, %d/%d decorations for stat: %s", Equipped, Data.maxSlots, FishTargetStat, Placed, Data.decorationSlots, DecorationTargetStat))

    Wait(5)

    Miku["Cache"]["_cache"]["Elements"]["Equip status"]:SetText("Status: Idle, waiting for next cycle...")
end

do
    local Window = Library:Window({
        Name = Miku["Information"]["Name"],
        Version = Miku["Information"]["Version"],
        Logo = "133647956541923", -- 135215559087473
        FadeSpeed = 0.25
    })

    local Watermark = Library:Watermark("hatsune.miku | " .. MarketplaceService:GetProductInfoAsync(game.PlaceId).Name, "133647956541923")
    Watermark:SetVisibility(false)
    local KeybindList = Library:KeybindsList()
    KeybindList:SetVisibility(false)

    do
        local Pages = {
            ["Home"] = Window:Page({
                Name = "Home", 
                Icon = "10723407389",
                Columns = 1
            }),

            ["Main"] = Window:Page({
                Name = "Main", 
                Icon = "103174889897193",
                SubPages = true,
            }),

            ["Modifications"] = Window:Page({
                Name = "Modifications", 
                Icon = "111178525804834", 
                Columns = 2
            }),

            ["Settings"] = Window:Page({
                Name = "Settings", 
                Icon = "137300573942266", 
                Columns = 2,
                SubPages = true
            })
        }

        do -- Home
            local ChangelogSection = Pages["Home"]:Section({Name = "Changelog", Icon = "", Side = 1})
            local SessionStatisticsSection = Pages["Home"]:Section({Name = "Session statistics", Icon = "", Side = 1})
            local ManagementSection = Pages["Home"]:Section({Name = "Management", Icon = "", Side = 1})

            Miku:GenerateChangelog(ChangelogSection, {
                "[+] Webhooks: Added support for bobber rewards, selling, player information updates.",
                "[+] Auto-equip: Added new auto-equip feature that equips the best fish and decorations based on target stats.",
            }, "4/9/26")

            local TimeElapsedLabel = SessionStatisticsSection:Label("Time elapsed:\n\t0d 0h 0m 0s")

            local SaveResourcesToggle
            SaveResourcesToggle = ManagementSection:Toggle({
                Name = "Save resources",
                Flag = "Save resources",
                Default = false,
                Callback = function(Value)
                    RunService:Set3dRenderingEnabled(not Value)
                end
            })
            
            SaveResourcesToggle:Keybind({
                Name = "Save resources",
                Flag = "Save resources keybind",
                Mode = "Toggle",
                Callback = function(Value)
                    SaveResourcesToggle:Set(Value)
                end
            })

            Spawn(function()
                while Wait(1) do
                    if Library.Unloaded then
                        break
                    end

                    Spawn(function()
                        TimeElapsedLabel:SetText("Time elapsed:\n\t" .. Miku:FormatTime(Floor(Tick() - Miku["Statistics"]["Uptime"])))
                    end)
                end
            end)
        end

        do -- Main
            local Subpages = {
                ["Automation"] = Pages["Main"]:SubPage({
                    Name = "Automation", 
                    Icon = "10709782230", 
                    Columns = 2
                }),

                ["Miscellaneous"] = Pages["Main"]:SubPage({
                    Name = "Miscellaneous",
                    Icon = "10709782582", 
                    Columns = 2
                }),

                ["Webhook"] = Pages["Main"]:SubPage({
                    Name = "Webhook",
                    Icon = "10734943902", 
                    Columns = 1
                })
            }

            if not LPH_OBFUSCATED then
                Subpages["Debug"] = Pages["Main"]:SubPage({
                    Name = "Debug",
                    Icon = "10734943902",
                    Columns = 1
                })
            end

            do
                local AutoFishSection = Subpages["Automation"]:Section({Name = "Auto-fish", Side = 1})
                local AutoBobberSection = Subpages["Automation"]:Section({Name = "Auto-bobber", Side = 2})
                local AutoSellSection = Subpages["Automation"]:Section({Name = "Auto-sell", Side = 1})
                local AutoEquipSection = Subpages["Automation"]:Section({Name = "Auto-equip", Side = 2})
                local MiscSection = Subpages["Automation"]:Section({Name = "Miscellaneous", Side = 1})

                local WebhookSection = Subpages["Webhook"]:Section({Name = "Webhook", Icon = "", Side = 1})

                do -- Automation
                    AutoFishSection:Toggle({
                        Name = "Enabled",
                        Flag = "Auto-fish enabled",
                        Default = false,
                        Callback = function(Value)
                            
                        end
                    })

                    AutoFishSection:Slider({
                        Name = "Click interval", 
                        Flag = "Click interval", 
                        Min = 0, 
                        Default = 0.03, 
                        Max = 1,
                        Decimals = 0.01,
                        Callback = function(Value)
                            
                        end
                    })

                    AutoBobberSection:Toggle({
                        Name = "Auto-click bobber",
                        Flag = "Auto-click bobber",
                        Default = false,
                        Callback = function(Value)
                            
                        end
                    })

                    AutoBobberSection:Toggle({
                        Name = "Auto-play minigame",
                        Flag = "Auto-play minigame",
                        Default = false,
                        Callback = function(Value)
                            BobberUI.debugAutoCatch = Value
                        end
                    })

                    AutoSellSection:Toggle({
                        Name = "Auto sell",
                        Flag = "Auto-sell enabled",
                        Default = false,
                        Callback = function(Value)
                            
                        end
                    })

                    AutoSellSection:Slider({
                        Name = "Sell threshold", 
                        Flag = "Sell threshold", 
                        Min = 0.01, 
                        Default = 2.5, 
                        Max = 3,
                        Decimals = 0.01, 
                        Callback = function(Value)
                            
                        end
                    })

                    AutoEquipSection:Toggle({
                        Name = "Enabled",
                        Flag = "Auto-equip enabled",
                        Default = false,
                        Callback = function(Value)
                            
                        end
                    })

                    AutoEquipSection:Dropdown({
                        Name = "Fish target stat",
                        Flag = "Fish target stat",
                        Items = Miku["Game"]["Buffs"],
                        Default = "",
                        MaxSize = 155,
                        Callback = function(Value)
                            
                        end
                    })

                    AutoEquipSection:Dropdown({
                        Name = "Decoration target stat",
                        Flag = "Decoration target stat",
                        Items = Miku["Game"]["Buffs"],
                        Default = "",
                        MaxSize = 155,
                        Callback = function(Value)
                            
                        end
                    })

                    AutoEquipSection:Slider({
                        Name = "Equip interval", 
                        Flag = "Auto-equip interval", 
                        Min = 1, 
                        Default = 5, 
                        Max = 60,
                        Suffix = "m",
                        Decimals = 1, 
                        Callback = function(Value)
                            
                        end
                    })

                    AutoEquipSection:Button({
                        Name = "Equip",
                        Callback = function()
                            local FishTargetStat = Miku["Game"]["Mappings"]["Buff Types"][Library:GetFlag("Fish target stat")]
                            local DecorationTargetStat = Miku["Game"]["Mappings"]["Buff Types"][Library:GetFlag("Decoration target stat")]

                            if (FishTargetStat and DecorationTargetStat) then
                                AutoEquip(FishTargetStat, DecorationTargetStat)
                            end
                        end
                    })

                    Miku["Cache"]["_cache"]["Elements"]["Equip status"] = AutoEquipSection:Label("Status: Idle, waiting for next cycle...")

                    MiscSection:Toggle({
                        Name = "Auto upgrade",
                        Flag = "Auto-upgrade enabled",
                        Default = false,
                        Callback = function(Value)
                            
                        end
                    })

                    MiscSection:Toggle({
                        Name = "Auto prestige",
                        Flag = "Auto-prestige enabled",
                        Default = false,
                        Callback = function(Value)
                            
                        end
                    })

                    MiscSection:Toggle({
                        Name = "Auto crack geodes",
                        Flag = "Auto-crack geodes enabled",
                        Default = false,
                        Callback = function(Value)
                            
                        end
                    })

                    MiscSection:Toggle({
                        Name = "Auto fleet management",
                        Flag = "Auto-fleet management enabled",
                        Default = false,
                        Callback = function(Value)
                            
                        end
                    })

                    MiscSection:Toggle({
                        Name = "Auto expeditions",
                        Flag = "Auto-expeditions enabled",
                        Default = false,
                        Callback = function(Value)
                            
                        end
                    })
                end

                do -- Miscellaneous
                    
                end

                do -- Webhook
                    WebhookSection:Toggle({
                        Name = "Enabled",
                        Flag = "Webhook enabled",
                        Default = false,
                        Callback = function(Value)
                            
                        end
                    })

                    WebhookSection:Textbox({
                        Name = "Webhook url",
                        Flag = "Webhook url",
                        Default = "",
                        Placeholder = "Enter discord webhook url here",
                        Callback = function(Value)
                            
                        end
                    })

                    WebhookSection:Textbox({
                        Name = "User id",
                        Flag = "User id",
                        Default = "",
                        Placeholder = "Enter your discord user id here",
                        Callback = function(Value)
                            
                        end
                    })

                    WebhookSection:Dropdown({
                        Name = "Webhooks",
                        Flag = "Webhooks",
                        Items = { "Bobber reward", "Sell", "Player information", "Disconnect" },
                        Default = {},
                        MaxSize = 155,
                        Multi = true,
                        Callback = function(Value)
                            
                        end
                    })

                    WebhookSection:Dropdown({
                        Name = "Pings",
                        Flag = "Pings",
                        Items = { "Bobber reward", "Sell", "Player information", "Disconnect" },
                        Default = {},
                        MaxSize = 155,
                        Multi = true,
                        Callback = function(Value)
                            
                        end
                    })

                    WebhookSection:Slider({
                        Name = "Player information interval", 
                        Flag = "Player information interval", 
                        Min = 1, 
                        Default = 10, 
                        Max = 60,
                        Suffix = "m",
                        Decimals = 1, 
                        Callback = function(Value)
                            
                        end
                    })
                end

                do
                    if not LPH_OBFUSCATED then
                        local DebugSection = Subpages["Debug"]:Section({Name = "Debug", Icon = "", Side = 1})

                        DebugSection:Toggle({
                            Name = "Set to clipboard",
                            Flag = "Set to clipboard",
                            Default = false,
                            Callback = function(Value)
                                
                            end
                        })

                        DebugSection:Button({
                            Name = "Dump market data",
                            Callback = function()
                                local MarketData = GetMarketData:InvokeServer()

                                if MarketData then
                                    print("Market data retrieved:", MarketData)
                                    
                                    local DumpedData = Miku:Dump(MarketData)

                                    if DumpedData then
                                        print("Market data dump:\n", DumpedData)

                                        if Library:GetFlag("Set to clipboard") then
                                            setclipboard(DumpedData)
                                        end
                                    else
                                        print("Failed to dump market data.")
                                    end
                                end
                            end
                        })

                        DebugSection:Button({
                            Name = "Dump upgrade data",
                            Callback = function()
                                local UpgradeData = GetUpgrades:InvokeServer()

                                if UpgradeData then
                                    print("Upgrade data retrieved:", UpgradeData)
                                    
                                    local DumpedData = Miku:Dump(UpgradeData)

                                    if DumpedData then
                                        print("Upgrade data dump:\n", DumpedData)

                                        if Library:GetFlag("Set to clipboard") then
                                            setclipboard(DumpedData)
                                        end
                                    else
                                        print("Failed to dump upgrade data.")
                                    end
                                end
                            end
                        })

                        DebugSection:Button({
                            Name = "Dump prestige data",
                            Callback = function()
                                local PrestigeData = GetPrestige:InvokeServer()

                                if PrestigeData then
                                    print("Prestige data retrieved:", PrestigeData)

                                    local DumpedData = Miku:Dump(PrestigeData)

                                    if DumpedData then
                                        print("Prestige data dump:\n", DumpedData)

                                        if Library:GetFlag("Set to clipboard") then
                                            setclipboard(DumpedData)
                                        end
                                    else
                                        print("Failed to dump prestige data.")
                                    end
                                end
                            end
                        })

                        DebugSection:Button({
                            Name = "Dump geodes data",
                            Callback = function()
                                local GeodeData = GetGeodes:InvokeServer()

                                if GeodeData then
                                    print("Geode data retrieved:", GeodeData)

                                    local DumpedData = Miku:Dump(GeodeData)

                                    if DumpedData then
                                        print("Geode data dump:\n", DumpedData)

                                        if Library:GetFlag("Set to clipboard") then
                                            setclipboard(DumpedData)
                                        end
                                    else
                                        print("Failed to dump geode data.")
                                    end
                                end
                            end
                        })

                        DebugSection:Button({
                            Name = "Dump fleet data",
                            Callback = function()
                                local FleetData = GetFleetData:InvokeServer()

                                if FleetData then
                                    print("Fleet data retrieved:", FleetData)

                                    local DumpedData = Miku:Dump(FleetData)

                                    if DumpedData then
                                        print("Fleet data dump:\n", DumpedData)

                                        if Library:GetFlag("Set to clipboard") then
                                            setclipboard(DumpedData)
                                        end
                                    else
                                        print("Failed to dump fleet data.")
                                    end
                                end
                            end
                        })

                        DebugSection:Button({
                            Name = "Dump expedition data",
                            Callback = function()
                                local ExpeditionData = GetExpeditions:InvokeServer()

                                if ExpeditionData then
                                    print("Expedition data retrieved:", ExpeditionData)

                                    local DumpedData = Miku:Dump(ExpeditionData)

                                    if DumpedData then
                                        print("Expedition data dump:\n", DumpedData)

                                        if Library:GetFlag("Set to clipboard") then
                                            setclipboard(DumpedData)
                                        end
                                    else
                                        print("Failed to dump expedition data.")
                                    end
                                end
                            end
                        })

                        DebugSection:Button({
                            Name = "Dump player data",
                            Callback = function()
                                local PlayerData = GetStats:InvokeServer()

                                if PlayerData then
                                    print("Player data retrieved:", PlayerData)

                                    local DumpedData = Miku:Dump(PlayerData)

                                    if DumpedData then
                                        print("Player data dump:\n", DumpedData)

                                        if Library:GetFlag("Set to clipboard") then
                                            setclipboard(DumpedData)
                                        end
                                    else
                                        print("Failed to dump player data.")
                                    end
                                end
                            end
                        })

                        DebugSection:Button({
                            Name = "Dump aquarium data",
                            Callback = function()
                                local AquariumData = GetAquarium:InvokeServer()

                                if AquariumData then
                                    print("Aquarium data retrieved:", AquariumData)

                                    local DumpedData = Miku:Dump(AquariumData)

                                    if DumpedData then
                                        print("Aquarium data dump:\n", DumpedData)

                                        if Library:GetFlag("Set to clipboard") then
                                            setclipboard(DumpedData)
                                        end
                                    else
                                        print("Failed to dump aquarium data.")
                                    end
                                end
                            end
                        })

                        DebugSection:Button({
                            Name = "Test player data webhook",
                            Callback = function()
                                local PlayerData = GetStats:InvokeServer()

                                if (not PlayerData) then
                                    return
                                end

                                local CachedPlayerData = Miku["Cache"]["_cache"]["Player Data"]

                                local Coins = PlayerData.coins
                                local BlackPearls = PlayerData.blackPearls
                                local Fish = PlayerData.fish

                                local ElapsedHours = (Tick() - Miku["Statistics"]["Uptime"]) / 3600

                                local SessionCoins = Coins - CachedPlayerData.coins
                                local SessionBlackPearls = BlackPearls - CachedPlayerData.blackPearls
                                local SessionFish = Miku["Statistics"]["Fish Gained"]

                                local CoinsPerHour = ElapsedHours > 0 and (Floor(SessionCoins / ElapsedHours)) or 0
                                local BlackPearlsPerHour = ElapsedHours > 0 and (Floor(SessionBlackPearls / ElapsedHours)) or 0
                                local FishPerHour = ElapsedHours > 0 and (Floor(SessionFish / ElapsedHours)) or 0

                                local Content = Miku:GetWebhookContent("Player information")

                                Miku:SendWebhook(Library:GetFlag("Webhook url"), Content, {
                                    Title = "ℹ️ Player information",
                                    Color = 0xFFFFFF,
                                    Fields = {
                                        {
                                            name   = "Coins",
                                            value  = Miku:FormatNumber(Coins),
                                            inline = true
                                        },
                                        {
                                            name   = "Coins Per Hour",
                                            value  = Miku:FormatNumber(CoinsPerHour),
                                            inline = true
                                        },
                                        {
                                            name   = "Session Coins",
                                            value  = Miku:FormatNumber(SessionCoins),
                                            inline = true
                                        },
                                        {
                                            name   = "Total Black Pearls",
                                            value  = Miku:FormatNumber(BlackPearls),
                                            inline = true
                                        },
                                        {
                                            name   = "Black Pearls Per Hour",
                                            value  = Miku:FormatNumber(BlackPearlsPerHour),
                                            inline = true
                                        },
                                        {
                                            name   = "Session Black Pearls",
                                            value  = Miku:FormatNumber(SessionBlackPearls),
                                            inline = true
                                        },
                                        {
                                            name   = "Fish Per Hour",
                                            value  = Miku:FormatNumber(FishPerHour),
                                            inline = true
                                        },
                                        {
                                            name   = "Session Fish",
                                            value  = Miku:FormatNumber(SessionFish),
                                            inline = true
                                        },
                                        {
                                            name   = "Total Fish",
                                            value  = Miku:FormatNumber(Fish),
                                            inline = true
                                        },
                                        {
                                            name   = "Prestige",
                                            value  = PlayerData.prestigeLevel and tostring(PlayerData.prestigeLevel) or "0",
                                            inline = true
                                        },
                                        {
                                            name   = "Uptime",
                                            value  = Miku:FormatTime(Floor(Tick() - Miku["Statistics"]["Uptime"])),
                                            inline = true
                                        }
                                    }
                                })
                            end
                        })
                    end
                end
            end
        end

        do -- Settings
            local Subpages = {
                ["Configs"] = Pages["Settings"]:SubPage({
                    Name = "Configs", 
                    Icon = "96491224522405", 
                    Columns = 2
                }),

                ["Theming"] = Pages["Settings"]:SubPage({
                    Name = "Theming", 
                    Icon = "103863157706913", 
                    Columns = 2
                }),

                ["Configuration"] = Pages["Settings"]:SubPage({
                    Name = "Configuration", 
                    Icon = "137300573942266", 
                    Columns = 2
                })
            }

            do -- Theming
                local ThemingSection = Subpages["Theming"]:Section({Name = "Theming", Icon = "103863157706913", Side = 1})
                local ThemingProfiles = Subpages["Theming"]:Section({Name = "Profiles", Icon = "96491224522405", Side = 2})
                local AutoloadSection = Subpages["Theming"]:Section({Name = "Autoload", Icon = "137623872962804", Side = 2})

                for Index, Value in Library.Theme do 
                    Library.ThemeColorpickers[Index] = ThemingSection:Label(Index, "Left"):Colorpicker({
                        Name = "Colorpicker",
                        Flag = "ColorpickerTheme" .. Index,
                        Default = Value,
                        Alpha = 0,
                        Callback = function(Color, Alpha)
                            Library.Theme[Index] = Color
                            Library:ChangeTheme(Index, Color)
                        end
                    })
                end

                ThemingProfiles:Dropdown({
                    Name = "Preset themes",
                    Items = { "Preset", "Halloween", "Aqua", "One Tap", "Catppuccin", "Monokai", "Dracula", "BBot", "Fatality", "Jester", "Mint", "Tokyo Night", "Material", "Dracula", "Quartz", "Nord" },
                    Default = "Preset",
                    MaxSize = 155,
                    Multi = false,
                    Callback = function(Value)
                        local ThemeData = Library.Themes[Value]

                        if not ThemeData then 
                            return
                        end

                        for Index, Value in Library.Theme do 
                            Library.Theme[Index] = ThemeData[Index]
                            Library:ChangeTheme(Index, ThemeData[Index])

                            Library.ThemeColorpickers[Index]:Set(ThemeData[Index])
                        end

                        Wait(0.3)

                        Library:Thread(function()
                            for Index, Value in Library.Theme do 
                                Library.Theme[Index] = Library.Flags["ColorpickerTheme" .. Index].Color
                                Library:ChangeTheme(Index, Library.Flags["ColorpickerTheme" .. Index].Color)
                            end    
                        end)
                    end
                })

                local ThemeSelected 
                local ThemeName

                do
                    local ThemesDropdown = ThemingProfiles:Dropdown({
                        Name = "Themes", 
                        Flag = "ThemesList", 
                        Items = { "", "", "", "", "" }, 
                        MaxSize = 155,
                        Multi = false,
                        Callback = function(Value)
                            ThemeSelected = Value
                        end
                    })

                    ThemingProfiles:Textbox({
                        Name = "Theme name", 
                        Default = "", 
                        Flag = "ThemeName", 
                        Placeholder = "Enter text", 
                        Callback = function(Value)
                            ThemeName = Value
                        end
                    })

                    ThemingProfiles:Button({
                        Name = "Save",
                        Callback = function()
                            if ThemeName and ThemeName ~= "" then
                                WriteFile(Library.Folders.Themes .. Library.FilePath .. ThemeName .. ".json", Library:GetTheme())
                                Library:RefreshThemesList(ThemesDropdown)
                            end
                        end
                    })

                    ThemingProfiles:Button({
                        Name = "Load",
                        Callback = function()
                            if ThemeSelected then
                                local Success, Result = Library:LoadTheme(ReadFile(Library.Folders.Themes .. Library.FilePath .. ThemeSelected))

                                if Success then 
                                    Library:Notification({
                                        Name = "Success",
                                        Description = "Succesfully loaded theme: ".. ThemeSelected,
                                        Duration = 5,
                                        Icon = "116339777575852",
                                        IconColor = Color3FromRGB(52, 255, 164)
                                    })

                                    Wait(0.3)

                                    Library:Thread(function()
                                        for Index, Value in Library.Theme do 
                                            Library.Theme[Index] = Library.Flags["ColorpickerTheme" .. Index].Color
                                            Library:ChangeTheme(Index, Library.Flags["ColorpickerTheme" .. Index].Color)
                                        end    
                                    end)
                                else
                                    Library:Notification({
                                        Name = "Error!",
                                        Description = "Failed to load theme, error:\n",
                                        Duration = 5,
                                        Icon = "97118059177470",
                                        IconColor = Color3FromRGB(255, 120, 120)
                                    })
                                end
                            end
                        end
                    })

                    AutoloadSection:Button({
                        Name = "Set selected theme as autoload",
                        Callback = function()
                            if ThemeSelected then 
                                WriteFile(Library.Folders.Directory .. Library.FilePath .. "AutoLoadTheme (do not modify this).json", ReadFile(Library.Folders.Themes .. Library.FilePath .. ThemeSelected))
                            end
                        end
                    })

                    AutoloadSection:Button({
                        Name = "Set current theme as autoload",
                        Callback = function()
                            if ThemeSelected then 
                                WriteFile(Library.Folders.Directory .. Library.FilePath .. "AutoLoadTheme (do not modify this).json", Library:GetTheme())
                            end
                        end
                    })

                    AutoloadSection:Button({
                        Name = "Remove autoload theme",
                        Callback = function()
                            WriteFile(Library.Folders.Directory .. Library.FilePath .. "AutoLoadTheme (do not modify this).json", "")
                        end
                    })

                    Library:RefreshThemesList(ThemesDropdown)
                end
            end

            do -- Configs
                local ConfigsSection = Subpages["Configs"]:Section({Name = "Profiles", Icon = "96491224522405", Side = 1})
                local AutoloadSection = Subpages["Configs"]:Section({Name = "Autoload", Icon = "137623872962804", Side = 2})

                local ConfigSelected 
                local ConfigName

                do
                    local ConfigsDropdown = ConfigsSection:Dropdown({
                        Name = "Configs", 
                        Flag = "ConfigsList", 
                        Items = { "", "", "", "", "" }, 
                        MaxSize = 155,
                        Multi = false,
                        Callback = function(Value)
                            ConfigSelected = Value
                        end
                    })

                    ConfigsSection:Textbox({
                        Name = "Config name", 
                        Default = "", 
                        Flag = "ConfigName", 
                        Placeholder = "Enter text", 
                        Callback = function(Value)
                            ConfigName = Value
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Create",
                        Callback = function()
                            if ConfigName and ConfigName ~= "" then
                                WriteFile(Library.Folders.Configs .. Library.FilePath .. ConfigName .. ".json", Library:GetConfig())
                                Library:RefreshConfigsList(ConfigsDropdown)

                                Library:Notification({
                                    Name = "Success",
                                    Description = "Succesfully created config: ".. ConfigName .. ".json",
                                    Duration = 5,
                                    Icon = "116339777575852",
                                    IconColor = Color3FromRGB(52, 255, 164)
                                })
                            end
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Delete", 
                        Confirm = true,
                        Callback = function()
                            if ConfigSelected then
                                Library:DeleteConfig(ConfigSelected)
                                Library:RefreshConfigsList(ConfigsDropdown)
                            end
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Load", 
                        Confirm = true,
                        Callback = function()
                            if ConfigSelected then
                                local Success, Result = Library:LoadConfig(ReadFile(Library.Folders.Configs .. Library.FilePath .. ConfigSelected))

                                if Success then 
                                    Library:Notification({
                                        Name = "Success",
                                        Description = "Succesfully loaded config: ".. ConfigSelected,
                                        Duration = 5,
                                        Icon = "116339777575852",
                                        IconColor = Color3FromRGB(52, 255, 164)
                                    })

                                    Wait(0.3)

                                    Library:Thread(function()
                                        for Index, Value in Library.Theme do 
                                            Library.Theme[Index] = Library.Flags["ColorpickerTheme" .. Index].Color
                                            Library:ChangeTheme(Index, Library.Flags["ColorpickerTheme" .. Index].Color)
                                        end    
                                    end)
                                else
                                    Library:Notification({
                                        Name = "Error!",
                                        Description = "Failed to load config, error:\n",
                                        Duration = 5,
                                        Icon = "97118059177470",
                                        IconColor = Color3FromRGB(255, 120, 120)

                                    })
                                end
                            end
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Save", 
                        Confirm = true,
                        Callback = function()
                            if ConfigSelected then
                                Library:SaveConfig(ConfigSelected)
                            end
                        end
                    })

                    ConfigsSection:Button({
                        Name = "Refresh list",
                        Callback = function()
                            Library:RefreshConfigsList(ConfigsDropdown)
                        end
                    })

                    Library:RefreshConfigsList(ConfigsDropdown)
                end

                do
                    AutoloadSection:Button({
                        Name = "Set selected config as autoload",
                        Callback = function()
                            if ConfigSelected then 
                                WriteFile(Library.Folders.Autoloads .. Library.FilePath .. LocalPlayer.Name .. "-AutoLoadConfig (do not modify this).json", ReadFile(Library.Folders.Configs .. Library.FilePath .. ConfigSelected))
                            end
                        end
                    })

                    AutoloadSection:Button({
                        Name = "Set current config as autoload",
                        Callback = function()
                            if ConfigSelected then 
                                WriteFile(Library.Folders.Autoloads .. Library.FilePath .. LocalPlayer.Name .. "-AutoLoadConfig (do not modify this).json", Library:GetConfig())
                            end
                        end
                    })

                    AutoloadSection:Button({
                        Name = "Remove autoload config",
                        Callback = function()
                            WriteFile(Library.Folders.Autoloads .. Library.FilePath .. LocalPlayer.Name .. "-AutoLoadConfig (do not modify this).json", "")
                        end
                    })
                end
            end

            do -- Configuration
                local MenuSection = Subpages["Configuration"]:Section({Name = "Menu", Icon = "93007870315593", Side = 1})
                local TweeningSection = Subpages["Configuration"]:Section({Name = "Tweening", Icon = "130045183204879", Side = 2})

                do
                    MenuSection:Label("Menu keybind", "Left"):Keybind({
                        Name = "Menu keybind",
                        Flag = "Menu keybind",
                        Mode = "Toggle",
                        Default = Library.MenuKeybind,
                        Callback = function()
                            Library.MenuKeybind = Library:GetFlag("Menu keybind").Key
                        end
                    })

                    MenuSection:Toggle({
                        Name = "Keybind list",
                        Flag = "Keybind list",
                        Default = false,
                        Callback = function(Value)
                            KeybindList:SetVisibility(Value)
                        end
                    })
                    
                    MenuSection:Toggle({
                        Name = "Watermark",
                        Flag = "Watermark",
                        Default = false,
                        Callback = function(Value)
                            Watermark:SetVisibility(Value)
                        end
                    })

                    MenuSection:Button({
                        Name = "Unload", 
                        Confirm = true,
                        Callback = function()
                            Library:Unload()
                        end
                    })
                end

                do
                    TweeningSection:Slider({
                        Name = "Time",
                        Flag = "TweenTime",
                        Default = Library.Tween.Time,
                        Min = 0,
                        Max = 5,
                        Decimals = 0.01,
                        Callback = function(Value)
                            Library.Tween.Time = Value
                        end
                    })

                    TweeningSection:Dropdown({
                        Name = "Style",
                        Flag = "TweenStyle",
                        Default = "Cubic",
                        Items = {"Linear", "Sine", "Quad", "Cubic", "Quart", "Quint", "Exponential", "Circular", "Back", "Elastic", "Bounce"},
                        MaxSize = 150,
                        Callback = function(Value)
                            Library.Tween.Style = Enum.EasingStyle[Value]
                        end
                    })

                    TweeningSection:Dropdown({
                        Name = "Direction",
                        Flag = "TweenDirection",
                        MaxSize = 55,
                        Default = "Out",
                        Items = {"In", "Out", "InOut"},
                        Callback = function(Value)
                            Library.Tween.Direction = Enum.EasingDirection[Value]
                        end
                    })
                end
            end
        end
    end
end

Library:Connect(RunService.Heartbeat, function(DT)
    if (Library:GetFlag("Auto-fish enabled") and (Tick() - Miku["Cache"]["_time"]["Click"] >= Library:GetFlag("Click interval"))) then
        ClickFishRemote:FireServer()
        Miku["Cache"]["_time"]["Click"] = Tick()
    end

    if (Library:GetFlag("Auto-click bobber") and Desktop:FindFirstChild("Bobber")) then
        ClickBobberRemote:FireServer()
    end

    if (Library:GetFlag("Auto-sell enabled") and (Tick() - Miku["Cache"]["_time"]["Sell"] >= 1)) then
        Miku["Cache"]["_time"]["Sell"] = Tick()

        local MarketData = GetMarketData:InvokeServer()

        if MarketData and MarketData.price and MarketData.price >= Library:GetFlag("Sell threshold") then
            SellFishRemote:FireServer(100)
        end
    end

    if (Library:GetFlag("Auto-upgrade enabled") and not Miku["Cache"]["_statuses"]["Auto-upgrade"]) then
        Miku["Cache"]["_statuses"]["Auto-upgrade"] = true

        local UpgradeData = GetUpgrades:InvokeServer()

        if UpgradeData then
            local BestUpgrade = GetBestUpgrade(UpgradeData)

            if BestUpgrade then
                BuyUpgradeRemote:FireServer(BestUpgrade.rodIndex)
            end
        end

        Miku["Cache"]["_statuses"]["Auto-upgrade"] = false
    end

    if (Library:GetFlag("Auto-prestige enabled") and (Tick() - Miku["Cache"]["_time"]["Prestige"] >= 1)) then
        Miku["Cache"]["_time"]["Prestige"] = Tick()

        local PrestigeData = GetPrestige:InvokeServer()

        if PrestigeData and PrestigeData.canPrestige then
            DoPrestigeRemote:FireServer()
        end
    end

    if (Library:GetFlag("Auto-crack geodes enabled") and not Miku["Cache"]["_statuses"]["Auto-crack geodes"]) then
        Miku["Cache"]["_statuses"]["Auto-crack geodes"] = true

        local GeodeData = GetGeodes:InvokeServer()

        if GeodeData and GeodeData.geodes and #GeodeData.geodes > 0 then
            for idx, Geode in ipairs(GeodeData.geodes) do
                if Geode and Geode.ready then
                    CrackGeodeRemote:FireServer(Geode.index)
                end
            end
        end

        Miku["Cache"]["_statuses"]["Auto-crack geodes"] = false
    end

    if (Library:GetFlag("Auto-fleet management enabled") and not Miku["Cache"]["_statuses"]["Auto-fleet management"]) then
        Miku["Cache"]["_statuses"]["Auto-fleet management"] = true

        local FleetData = GetFleetData:InvokeServer()

        if FleetData and FleetData.fleet then
            for idx, Boat in ipairs(FleetData.fleet) do
                ProcessBoat(Boat, FleetData.coins)
            end
        end

        Miku["Cache"]["_statuses"]["Auto-fleet management"] = false
    end

    if (Library:GetFlag("Auto-expeditions enabled") and not Miku["Cache"]["_statuses"]["Auto-expedition"]) then
        Miku["Cache"]["_statuses"]["Auto-expedition"] = true

        local ExpeditionData = GetExpeditions:InvokeServer()

        if ExpeditionData then
            local Coins = ExpeditionData.coins
            local Slots = ExpeditionData.slots
            local ExpeditionTypes = ExpeditionData.expeditionTypes

            if not Slots or not ExpeditionTypes then
                Miku["Cache"]["_statuses"]["Auto-expedition"] = false

                return
            end

            for SlotIndex, Slot in ipairs(Slots) do
                if SlotIndex > ExpeditionData.maxSlots then break end

                if type(Slot) == "table" and Slot.complete then
                    ClaimExpeditionRemote:FireServer(SlotIndex)

                    task.wait(0.25)

                    local BestExpedition = GetBestExpedition(ExpeditionTypes, Coins)

                    if BestExpedition then
                        LaunchExpeditionRemote:FireServer(BestExpedition.id, SlotIndex)
                    end
                elseif type(Slot) == "boolean" then
                    local BestExpedition = GetBestExpedition(ExpeditionTypes, Coins)

                    if BestExpedition then
                        LaunchExpeditionRemote:FireServer(BestExpedition.id, SlotIndex)
                    end
                end
            end
        end

        Miku["Cache"]["_statuses"]["Auto-expedition"] = false
    end

    if (Library:GetFlag("Auto-equip enabled") and not Miku["Cache"]["_statuses"]["Auto-equip"]) then
        Miku["Cache"]["_statuses"]["Auto-equip"] = true

        local FishTargetStat = Miku["Game"]["Mappings"]["Buff Types"][Library:GetFlag("Fish target stat")]
        local DecorationTargetStat = Miku["Game"]["Mappings"]["Buff Types"][Library:GetFlag("Decoration target stat")]

        if (FishTargetStat and DecorationTargetStat) then
            AutoEquip(FishTargetStat, DecorationTargetStat)
        end

        Miku["Cache"]["_statuses"]["Auto-equip"] = false
    end

    if (Library:GetFlag("Webhook enabled") and TFind(Library:GetFlag("Webhooks"), "Player information") and (Tick() - Miku["Cache"]["_time"]["Player Information"] >= Library:GetFlag("Player information interval") * 60)) then
        Miku["Cache"]["_time"]["Player Information"] = Tick()

        local PlayerData = GetStats:InvokeServer()

        if (not PlayerData) then
            return
        end

        local CachedPlayerData = Miku["Cache"]["_cache"]["Player Data"]

        local Coins = PlayerData.coins
        local BlackPearls = PlayerData.blackPearls
        local Fish = PlayerData.fish

        local ElapsedHours = (Tick() - Miku["Statistics"]["Uptime"]) / 3600

        local SessionCoins = Coins - CachedPlayerData.coins
        local SessionBlackPearls = BlackPearls - CachedPlayerData.blackPearls
        local SessionFish = Miku["Statistics"]["Fish Gained"]

        local CoinsPerHour = ElapsedHours > 0 and (Floor(SessionCoins / ElapsedHours)) or 0
        local BlackPearlsPerHour = ElapsedHours > 0 and (Floor(SessionBlackPearls / ElapsedHours)) or 0
        local FishPerHour = ElapsedHours > 0 and (Floor(SessionFish / ElapsedHours)) or 0

        local Content = Miku:GetWebhookContent("Player information")

        Miku:SendWebhook(Library:GetFlag("Webhook url"), Content, {
            Title = "ℹ️ Player information",
            Color = 0xFFFFFF,
            Fields = {
                {
                    name   = "Coins",
                    value  = Miku:FormatNumber(Coins),
                    inline = true
                },
                {
                    name   = "Coins Per Hour",
                    value  = Miku:FormatNumber(CoinsPerHour),
                    inline = true
                },
                {
                    name   = "Session Coins",
                    value  = Miku:FormatNumber(SessionCoins),
                    inline = true
                },
                {
                    name   = "Total Black Pearls",
                    value  = Miku:FormatNumber(BlackPearls),
                    inline = true
                },
                {
                    name   = "Black Pearls Per Hour",
                    value  = Miku:FormatNumber(BlackPearlsPerHour),
                    inline = true
                },
                {
                    name   = "Session Black Pearls",
                    value  = Miku:FormatNumber(SessionBlackPearls),
                    inline = true
                },
                {
                    name   = "Fish Per Hour",
                    value  = Miku:FormatNumber(FishPerHour),
                    inline = true
                },
                {
                    name   = "Session Fish",
                    value  = Miku:FormatNumber(SessionFish),
                    inline = true
                },
                {
                    name   = "Total Fish",
                    value  = Miku:FormatNumber(Fish),
                    inline = true
                },
                {
                    name   = "Prestige",
                    value  = PlayerData.prestigeLevel and tostring(PlayerData.prestigeLevel) or "0",
                    inline = true
                },
                {
                    name   = "Uptime",
                    value  = Miku:FormatTime(Floor(Tick() - Miku["Statistics"]["Uptime"])),
                    inline = true
                }
            }
        })
    end
end)

Library:Connect(BobberReward.OnClientEvent, function(Data)
    OnCatch(Data)
end)

Library:Connect(SellResult.OnClientEvent, function(Data)
    if not Library:GetFlag("Webhook enabled") or not TFind(Library:GetFlag("Webhooks"), "Sell") then return end

    local MarketPrice = Data.price or 0
    local FishSold = Data.fishSold or 0
    local CoinsEarned = Data.coinsEarned or 0

    if (not MarketPrice or not FishSold or not CoinsEarned) then
        return
    end

    local Content = Miku:GetWebhookContent("Sell")

    Miku:SendWebhook(Library:GetFlag("Webhook url"), Content, {
        Title = "💰 Sell result",
        Color = 0xFFFFFF,
        Fields = {
            {
                name   = "Market Price",
                value  = "$" .. tostring(MarketPrice),
                inline = true
            },
            {
                name   = "Fish Sold",
                value  = Miku:PrettifyNumber(FishSold),
                inline = true
            },
            {
                name   = "Coins Earned",
                value  = Miku:FormatNumber(CoinsEarned),
                inline = true
            }
        }
    })
end)

Library:Connect(UpdateStats.OnClientEvent, function(Data)
    if Data.fish then
        local LastFish = Miku["Statistics"]["Last Fish"]

        if LastFish ~= nil then
            local Delta = Data.fish - LastFish

            if Delta > 0 then
                Miku["Statistics"]["Fish Gained"] = Miku["Statistics"]["Fish Gained"] + Delta
            end
        end

        Miku["Statistics"]["Last Fish"] = Data.fish
    end
end)

Library:Connect(GuiService.ErrorMessageChanged, function(Message)
    if Message == "DisconnectClientRequest" then return end

    if Library:GetFlag("Webhook enabled") and TFind(Library:GetFlag("Webhooks") or {}, "Disconnect") then
        local Content = Miku:GetWebhookContent("Disconnect")

        Miku:SendWebhook(Library:GetFlag("Webhook url"), Content, {
            ["title"] = "Disconnected",
            ["color"] = 0xFF0000,
            ["fields"] = {
                {
                    ["name"] = "**Reason:**",
                    ["value"] = Message,
                    ["inline"] = false
                }
            }
        })
    end
end, "Disconnect handler")

Library:Connect(LocalPlayer.Idled, function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vec2(0, 0))
end, "Anti afk")

Library:Init()