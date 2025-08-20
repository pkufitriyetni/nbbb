-- ClavnnX Script for 99 Nights in the Forest
-- Professional UI Script with all features
-- Made for mobile devices
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera
local Mouse = Player:GetMouse()
-- 🚀 CLAVNNX LOADING SCREEN - NO BLACK BACKGROUND + REAL LOGO
-- 🚀 CLAVNNX LOADING SCREEN - FIXED IMAGE + TIMING
-- 🚀 SIMPLE LOADING SCREEN THAT WORKS
local function createLoadingScreen()
  local loadingGui = Instance.new("ScreenGui")
  loadingGui.Name = "ClavnnXLoadingScreen"
  loadingGui.Parent = game.CoreGui
  loadingGui.ResetOnSpawn = false

  local container = Instance.new("Frame")
  container.Parent = loadingGui
  container.Size = UDim2.new(0, 400, 0, 200)
  container.Position = UDim2.new(0.5, -200, 0.5, -100)
  container.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
  container.BorderSizePixel = 0

  local corner = Instance.new("UICorner")
  corner.CornerRadius = UDim.new(0, 15)
  corner.Parent = container

  -- Logo TEXT (No image issues)
  local logo = Instance.new("TextLabel")
  logo.Parent = container
  logo.Size = UDim2.new(1, 0, 0, 60)
  logo.Position = UDim2.new(0, 0, 0, 20)
  logo.BackgroundTransparency = 1
  logo.Text = "ClavnnX"
  logo.TextColor3 = Color3.fromRGB(0, 150, 255)
  logo.Font = Enum.Font.GothamBold
  logo.TextSize = 36
  logo.TextXAlignment = Enum.TextXAlignment.Center

  -- Loading text
  local loadingText = Instance.new("TextLabel")
  loadingText.Parent = container
  loadingText.Size = UDim2.new(1, 0, 0, 30)
  loadingText.Position = UDim2.new(0, 0, 0, 90)
  loadingText.BackgroundTransparency = 1
  loadingText.Text = "Loading..."
  loadingText.TextColor3 = Color3.fromRGB(150, 150, 150)
  loadingText.Font = Enum.Font.Gotham
  loadingText.TextSize = 16
  loadingText.TextXAlignment = Enum.TextXAlignment.Center

  -- Progress bar
  local progressBg = Instance.new("Frame")
  progressBg.Parent = container
  progressBg.Size = UDim2.new(1, -40, 0, 6)
  progressBg.Position = UDim2.new(0, 20, 0, 140)
  progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
  progressBg.BorderSizePixel = 0

  local progressCorner = Instance.new("UICorner")
  progressCorner.CornerRadius = UDim.new(0, 3)
  progressCorner.Parent = progressBg

  local progressFill = Instance.new("Frame")
  progressFill.Parent = progressBg
  progressFill.Size = UDim2.new(0, 0, 1, 0)
  progressFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
  progressFill.BorderSizePixel = 0

  local fillCorner = Instance.new("UICorner")
  fillCorner.CornerRadius = UDim.new(0, 3)
  fillCorner.Parent = progressFill

  -- Percentage
  local percentage = Instance.new("TextLabel")
  percentage.Parent = container
  percentage.Size = UDim2.new(1, 0, 0, 20)
  percentage.Position = UDim2.new(0, 0, 0, 160)
  percentage.BackgroundTransparency = 1
  percentage.Text = "0%"
  percentage.TextColor3 = Color3.fromRGB(200, 200, 200)
  percentage.Font = Enum.Font.Gotham
  percentage.TextSize = 14
  percentage.TextXAlignment = Enum.TextXAlignment.Center

  -- Animation
  spawn(function()
  for i = 0, 100 do
    progressFill.Size = UDim2.new(i/100, 0, 1, 0)
    percentage.Text = i .. "%"
    loadingText.Text = "Loading ClavnnX... " .. i .. "%"
    wait(0.06) -- Total 6 seconds
  end

  wait(1)
  loadingGui:Destroy()
  print("✅ Loading Complete!")
  end)
end

createLoadingScreen()
-- Variables
local ClavnnXGui = nil
local MainFrame = nil
local currentTab = "Main"
local isGuiVisible = true
local isBringingItems = false

-- ========== GLOBAL VARIABLES FOR ITEM SELECTION ========== (TAMBAHKAN INI)
_G.selectedItemName = nil
_G.selectedItemButton = nil

-- Tambahkan variabel global untuk Item List System
local ItemListSystem = {
  enabled = false,
  autoUpdateEnabled = false,
  items = {},
  lastUpdateTime = 0,
  autoUpdateCountdown = 10,
  blacklistedKeywords = {"chest", "Chest", "CHEST"}, -- Case insensitive check
  updateConnection = nil,
  countdownConnection = nil
}

-- Feature toggles
local features = {
  fly = false,
  noclip = false,
  speed = false,
  infiniteJump = false,
  killAura = false,
  noFog = false,
  clearWeather = false,
  alwaysBright = false,
  alwaysNight = false,
  fullHD = false,
  fpsBoost = false,
  keyboardMode = false,
  autoFuel = false,
  autoFarm = false,
  godMode = false,
  infiniteHunger = false,
  nightVision = false,
  customFOV = false,
  espAnimals = false,
  espNpcs = false,
  espItems = false,
  hitbox = false,
  autoOpenChest = false

}
-- Settings
local settings = {
  flySpeed = 50,
  walkSpeed = 50,
  jumpPower = 50,
  killAuraRadius = 10,
  fieldOfView = 70
}
local infiniteJumpConnection = nil
-- ESP Storage
local espObjects = {}

-- ========== CHEST SYSTEM VARIABLES ========== (TAMBAHKAN INI)
local ChestSystem = {
  enabled = false,
  autoOpenEnabled = false,
  selectedChest = nil,
  chestCache = {},
  openedChests = {},
  lastAutoOpenCheck = 0,
  isScanning = false,
  teleportToChestEnabled = false
}

local ChestConnection = nil

local AUTO_OPEN_DISTANCE = 10
local AUTO_OPEN_COOLDOWN = 2
local TELEPORT_Y_OFFSET = 5

local function findAllChests()
  local chests = {}

  -- Method 1: Look in Workspace.Items.Chest
  if Workspace:FindFirstChild("Items") then
    local items = Workspace.Items
    if items:FindFirstChild("Chest") then
      for _, chest in pairs(items.Chest:GetChildren()) do
        local pos = getChestPosition(chest)
        if pos then
          table.insert(chests, {
            object = chest,
            position = pos,
            name = chest.Name
          })
        end
      end
    end
  end

  -- Method 2: Look directly in Workspace.Items
  if Workspace:FindFirstChild("Items") then
    for _, item in pairs(Workspace.Items:GetChildren()) do
      if string.lower(item.Name):find("chest") then
        local pos = getChestPosition(item)
        if pos then
          table.insert(chests, {
            object = item,
            position = pos,
            name = item.Name
          })
        end
      end
    end
  end

  -- Method 3: Scan entire workspace for objects with "chest" in name
  local function scanFolder(folder, depth)
    if depth > 3 then return end -- Limit recursion

    for _, item in pairs(folder:GetChildren()) do
      if string.lower(item.Name):find("chest") then
        local pos = getChestPosition(item)
        if pos then
          table.insert(chests, {
            object = item,
            position = pos,
            name = item.Name
          })
        end
      elseif item:IsA("Folder") or item:IsA("Model") then
        scanFolder(item, depth + 1)
      end
    end
  end

  scanFolder(Workspace, 0)

  -- Remove duplicates based on position
  local uniqueChests = {}
  local positions = {}

  for _, chest in pairs(chests) do
    local posKey = string.format("%.1f,%.1f,%.1f", chest.position.X, chest.position.Y, chest.position.Z)
    if not positions[posKey] then
      positions[posKey] = true
      table.insert(uniqueChests, chest)
    end
  end

  return uniqueChests
end

-- ========== HITBOX VARIABLES ==========
local HitboxSystem = {
  enabled = false,
  selectedTarget = nil,
  activeHitboxes = {},
  size = 5, -- Default hitbox size
  targets = {"Bunny", "Wolf", "Alpha Wolf", "Bear", "Pola Bear", "Cultish", "Alien", "Artic Fox"}
}

local HitboxConnection = nil

-- ========== NEW ESP SYSTEM ==========
local ESP = {
  Enabled = {
    animals = {},
    npcs = {},
    items = {}
  },
  Connections = {
    animals = {},
    npcs = {},
    items = {}
  },
  Objects = {
    animals = {},
    npcs = {},
    items = {}
  },
  Targets = {
    animals = {"Bunny", "Wolf", "Alpha Wolf", "Bear", "Pola Bear", "Artic Fox", "Mammoth"},
    npcs = {"Cultish", "Alien", "Pelt trader", "Furniture Trader", "Fairy", "LostChild", "LostChild2", "LostChild3", "LostChild4"},
    items = {"Bolt", "Metal Sheet", "Tyre", "Broken Fan", "Broken Radio", "Broken Microwave", "Washing Machine", "Metal Chair", "Old Car Engine", "UFO Junk", "UFO Component", "UFO Scrap", "Cultist Experiment", "Cultist Prototype", "Carrot", "Apple", "Berry", "Cake", "Morsel", "Steak", "Ribs", "Bandage", "MedKit", "Chili", "Hearty Stew", "Meat Sandwich", "Log", "Chair", "Biofuel", "Coal", "Fuel Canister", "Oil Barrel"}
  }
}

-- Kill Aura Variables
local KillAuraEnabled = false
local KillAuraConnection = nil
local KillAuraRadius = 15
local LastAttackTime = {}
local AttackCooldown = 0.5
local RemoteEvents = nil
local killCount = 0 -- TAMBAHKAN INI!

-- Target list untuk Kill Aura
local ValidTargets = {
  ["Bunny"] = true,
  ["Wolf"] = true,
  ["Alpha Wolf"] = true,
  ["Bear"] = true,
  ["Cultist"] = true,
  ["Crossbow Cultish"] = true,
  ["Pola Bear"] = true,
  ["Artic Fox"] = true,
  ["Giant Cultish"] = true
}

-- Kill counter
local targetKills = {
  ["Bunny"] = 0,
  ["Wolf"] = 0,
  ["Alpha Wolf"] = 0,
  ["Bear"] = 0,
  ["Cultist"] = 0,
  ["Crossbow Cultish"] = 0,
  ["Pola Bear"] = 0,
  ["Artic Fox"] = 0,
  ["Giant Cultish"] = 0
}
-- ========== INFINITE HUNGER VARIABLES ==========
local InfiniteHungerEnabled = false
local HungerConnection = nil
local frozenHungerValue = nil
local hungerAttributeName = nil
local originalSetAttribute = nil

-- Weather + NoFog Variables
local WeatherEnabled = false
local WeatherConnection = nil
local NoFogEnabled = false
local NoFogConnection = nil
local originalFogStart, originalFogEnd, originalFogColor = nil, nil, nil

-- Lighting Control Variables
local AlwaysBrightEnabled = false
local AlwaysNightEnabled = false
local FullHDEnabled = false
local LightingConnection = nil
local originalClockTime = nil
local originalBrightness = nil

-- ========== FPS BOOST VARIABLES ==========
local FPSBoostEnabled = false
local FPSBoostConnection = nil
local originalSettings = {}
local originalObjectSettings = {}

-- ========== NIGHT VISION & FOV VARIABLES ==========
local NightVisionEnabled = false
local NightVisionConnection = nil
local originalAmbient = nil
local originalOutdoorAmbient = nil

local CustomFOVEnabled = false
local originalFOV = nil
local currentFOV = 70

-- Auto Farm Variables (TAMBAHKAN INI!)
local AutoFarmEnabled = false
local AutoFarmConnection = nil
local TreesChopped = 0
local CurrentTargets = {}
local ProcessedTrees = {}
local FarmAttackCount = 0

-- Auto Farm Settings
local MAX_FARM_RANGE = 1000 -- 1000 studs range
local MULTI_ATTACK = 3 -- 3x attack per tree
local FARM_ATTACK_DELAY = 0.1 -- Delay between attack cycles

-- Valid tree names
local ValidTrees = {
  ["Tree"] = true,
  ["BigTree"] = true,
  ["SmallTree"] = true,
  ["OakTree"] = true,
  ["PineTree"] = true,
  ["MapleTree"] = true,
  ["tree"] = true,
  ["bigtree"] = true,
  ["smalltree"] = true
}

-- ========== GOD MODE FUNCTIONS ==========

-- Function to store original transparency values
local function StoreOriginalTransparencies(character)
  OriginalTransparencies = {}
  for _, part in pairs(character:GetChildren()) do
    if part:IsA("BasePart") then
      OriginalTransparencies[part] = part.Transparency
    elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
      OriginalTransparencies[part.Handle] = part.Handle.Transparency
    end
  end
end

-- Function to make character transparent
local function MakeCharacterTransparent(character, transparency)
  for _, part in pairs(character:GetChildren()) do
    if part:IsA("BasePart") then
      part.Transparency = transparency
    elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
      part.Handle.Transparency = transparency
    end
  end
end

-- Function to restore original transparencies
local function RestoreOriginalTransparencies(character)
  for part, transparency in pairs(OriginalTransparencies) do
    if part and part.Parent then
      part.Transparency = transparency
    end
  end
end

-- Function to copy appearance from original character
local function CopyAppearance(originalChar, cloneChar)
  pcall(
  function()
    -- Copy BodyColors
    local originalBodyColors = originalChar:FindFirstChildOfClass("BodyColors")
    if originalBodyColors then
      local cloneBodyColors = cloneChar:FindFirstChildOfClass("BodyColors")
      if not cloneBodyColors then
        cloneBodyColors = Instance.new("BodyColors")
        cloneBodyColors.Parent = cloneChar
      end
      cloneBodyColors.HeadColor = originalBodyColors.HeadColor
      cloneBodyColors.TorsoColor = originalBodyColors.TorsoColor
      cloneBodyColors.LeftArmColor = originalBodyColors.LeftArmColor
      cloneBodyColors.RightArmColor = originalBodyColors.RightArmColor
      cloneBodyColors.LeftLegColor = originalBodyColors.LeftLegColor
      cloneBodyColors.RightLegColor = originalBodyColors.RightLegColor
    end
  end
  )

  pcall(
  function()
    -- Copy Shirt
    local originalShirt = originalChar:FindFirstChildOfClass("Shirt")
    if originalShirt then
      local cloneShirt = cloneChar:FindFirstChildOfClass("Shirt")
      if not cloneShirt then
        cloneShirt = Instance.new("Shirt")
        cloneShirt.Parent = cloneChar
      end
      cloneShirt.ShirtTemplate = originalShirt.ShirtTemplate
    end
  end
  )

  pcall(
  function()
    -- Copy Pants
    local originalPants = originalChar:FindFirstChildOfClass("Pants")
    if originalPants then
      local clonePants = cloneChar:FindFirstChildOfClass("Pants")
      if not clonePants then
        clonePants = Instance.new("Pants")
        clonePants.Parent = cloneChar
      end
      clonePants.PantsTemplate = originalPants.PantsTemplate
    end
  end
  )

  pcall(
  function()
    -- Copy Animate script
    local originalAnimate = originalChar:FindFirstChild("Animate")
    if originalAnimate then
      local cloneAnimate = cloneChar:FindFirstChild("Animate")
      if cloneAnimate then
        cloneAnimate:Destroy()
      end
      local newAnimate = originalAnimate:Clone()
      newAnimate.Parent = cloneChar
    end
  end
  )
end

-- Function to anchor character in air above clone
local function AnchorCharacterAboveClone(character, cloneHRP)
  if not character or not cloneHRP then
    return
  end

  local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
  if not humanoidRootPart then
    return
  end

  -- Position character 20 studs above clone
  local abovePosition = cloneHRP.Position + Vector3.new(0, 20, 0)
  humanoidRootPart.CFrame = CFrame.new(abovePosition)

  -- Anchor all parts of the original character
  for _, part in pairs(character:GetChildren()) do
    if part:IsA("BasePart") then
      part.Anchored = true
    end
  end
end

-- Function to unanchor character
-- Function to unanchor character (FIXED VERSION)
local function UnanchorCharacter(character)
  if not character then
    print("❌ No character to unanchor")
    return
  end

  pcall(
  function()
    for _, part in pairs(character:GetChildren()) do
      if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
        part.Anchored = false
      end
    end

    -- Keep HumanoidRootPart unanchored last for proper physics
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
      humanoidRootPart.Anchored = false
      print("✅ Character unanchored successfully")
    end
  end
  )
end

-- Function to deep clone a character model
local function CloneCharacter(character)
  local clone = Instance.new("Model")
  clone.Name = "GodModeClone_" .. Player.Name

  local partMap = {}

  -- Clone all parts and accessories
  for _, child in pairs(character:GetChildren()) do
    pcall(
    function()
      if child:IsA("Accessory") or child:IsA("BasePart") then
        local newChild = child:Clone()
        newChild.Parent = clone
        if newChild:IsA("BasePart") then
          partMap[child] = newChild
        end
      elseif child:IsA("Humanoid") then
        local newHumanoid = child:Clone()
        newHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        newHumanoid.HealthDisplayDistance = 0
        newHumanoid.NameDisplayDistance = 0
        newHumanoid.Parent = clone
        partMap[child] = newHumanoid
      end
    end
    )
  end

  -- Set up parts - Clone should NOT be anchored for animations
  for _, part in pairs(clone:GetChildren()) do
    if part:IsA("BasePart") then
      part.Anchored = false
      part.CanCollide = false
    end
  end

  -- Clone Motor6D joints for proper animations
  for _, motor in pairs(character:GetDescendants()) do
    if motor:IsA("Motor6D") and partMap[motor.Part0] and partMap[motor.Part1] then
      pcall(
      function()
        local newMotor = motor:Clone()
        newMotor.Part0 = partMap[motor.Part0]
        newMotor.Part1 = partMap[motor.Part1]
        newMotor.Parent = partMap[motor.Part0]
      end
      )
    end
  end

  -- Set PrimaryPart and position
  local clonedHRP = clone:FindFirstChild("HumanoidRootPart")
  if clonedHRP then
    clone.PrimaryPart = clonedHRP
    pcall(
    function()
      clone:SetPrimaryPartCFrame(character:GetPrimaryPartCFrame())
    end
    )
    clonedHRP.Anchored = false
  end

  clone.Parent = workspace

  -- Copy appearance after clone is created
  pcall(
  function()
    CopyAppearance(character, clone)
  end
  )

  return clone
end

-- Function to sync animations between characters
local function SyncAnimations(originalHumanoid, cloneHumanoid)
  local conn =
  RunService.Heartbeat:Connect(
  function()
    if not GodModeEnabled or not originalHumanoid or not cloneHumanoid or not cloneHumanoid.Parent then
      return
    end

    pcall(
    function()
      -- Sync movement and animations
      cloneHumanoid:Move(originalHumanoid.MoveDirection, false)
      if originalHumanoid.Jump then
        cloneHumanoid.Jump = true
      end
      cloneHumanoid:ChangeState(originalHumanoid:GetState())

      -- Keep original character positioned above clone
      if ClonedHRP and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local abovePosition = ClonedHRP.Position + Vector3.new(0, 20, 0)
        Player.Character.HumanoidRootPart.CFrame = CFrame.new(abovePosition)
      end
    end
    )
  end
  )

  table.insert(GodModeConnections, conn)
end

-- Function to enable God Mode
local function EnableGodMode()
  if GodModeEnabled then
    return
  end
  GodModeEnabled = true

  -- Store original transparencies before making transparent
  StoreOriginalTransparencies(Player.Character)

  -- Create clone before moving original character
  ClonedCharacter = CloneCharacter(Player.Character)
  if not ClonedCharacter then
    showNotification("Failed to create clone!", 3)
    GodModeEnabled = false
    return
  end

  ClonedHRP = ClonedCharacter:WaitForChild("HumanoidRootPart", 5)
  ClonedHumanoid = ClonedCharacter:WaitForChildOfClass("Humanoid", 5)

  if not ClonedHRP or not ClonedHumanoid then
    showNotification("Failed to create proper clone!", 3)
    GodModeEnabled = false
    if ClonedCharacter then
      ClonedCharacter:Destroy()
    end
    return
  end

  -- Move original character 20 studs above clone and anchor it
  AnchorCharacterAboveClone(Player.Character, ClonedHRP)
  MakeCharacterTransparent(Player.Character, 1)
  Player.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

  wait(0.1)

  -- Set camera to follow clone
  Camera.CameraSubject = ClonedHumanoid

  -- Sync animations
  SyncAnimations(Player.Character.Humanoid, ClonedHumanoid)

  showNotification("God Mode enabled!", 2)
end

-- Function to disable God Mode (FIXED VERSION)
local function DisableGodMode()
  if not GodModeEnabled then
    return
  end

  print("🛑 Disabling God Mode...")

  -- Safely get current character
  local currentCharacter = Player.Character
  if not currentCharacter then
    print("❌ No character found during disable")
    GodModeEnabled = false
    return
  end

  -- Unanchor original character first
  UnanchorCharacter(currentCharacter)

  -- Restore original character visibility and humanoid settings
  local humanoid = currentCharacter:FindFirstChild("Humanoid")
  if humanoid then
    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
  end

  -- Safely restore transparencies
  pcall(
  function()
    if OriginalTransparencies and type(OriginalTransparencies) == "table" then
      for part, transparency in pairs(OriginalTransparencies) do
        if part and part.Parent and typeof(transparency) == "number" then
          part.Transparency = transparency
        end
      end
    else
      -- Fallback: restore to default transparency
      for _, part in pairs(currentCharacter:GetChildren()) do
        if part:IsA("BasePart") then
          part.Transparency = 0
        elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
          part.Handle.Transparency = 0
        end
      end
    end
  end
  )

  -- Move original character back to clone position
  local hrp = currentCharacter:FindFirstChild("HumanoidRootPart")
  if hrp and ClonedHRP and ClonedHRP.Parent then
    pcall(
    function()
      hrp.CFrame = ClonedHRP.CFrame
      print("✅ Character returned to clone position:", ClonedHRP.Position)
    end
    )
  end

  -- Restore camera to original character
  if humanoid then
    Camera.CameraSubject = humanoid
    print("📹 Camera restored to original character")
  end

  -- Safely disconnect all connections
  if GodModeConnections and type(GodModeConnections) == "table" then
    for i, conn in pairs(GodModeConnections) do
      pcall(
      function()
        if conn and typeof(conn) == "RBXScriptConnection" then
          conn:Disconnect()
        end
      end
      )
    end
  end
  GodModeConnections = {}

  -- Safely destroy clone
  if ClonedCharacter and ClonedCharacter.Parent then
    pcall(
    function()
      ClonedCharacter:Destroy()
      print("✅ Clone destroyed")
    end
    )
  end

  -- Reset all God Mode variables
  ClonedCharacter = nil
  ClonedHRP = nil
  ClonedHumanoid = nil
  OriginalTransparencies = {}
  GodModeEnabled = false

  showNotification("God Mode disabled!", 2)
  print("✅ God Mode disabled successfully")
end

-- Toggle God Mode function (FIXED VERSION)
local function toggleGodMode(enabled)
  print("🔄 Toggle God Mode:", enabled)
  features.godMode = enabled

  if enabled then
    EnableGodMode()
  else
    DisableGodMode()
  end
end

-- ========== END GOD MODE FUNCTIONS ==========

-- ========== INFINITE HUNGER FUNCTIONS ==========
-- Find hunger attribute in player
local function findHungerAttribute()
  local attrs = Player:GetAttributes()
  for name, value in pairs(attrs) do
    if type(value) == "number" and value > 100 and value < 300 then
      if string.lower(name):find("hunger") or string.lower(name):find("food") or name == "Hunger" then
        return name, value
      end
    end
  end

  for name, value in pairs(attrs) do
    if type(value) == "number" and value > 190 and value < 200 then
      return name, value
    end
  end

  return nil, nil
end

-- Toggle Infinite Hunger
local function toggleInfiniteHunger(enabled)
  features.infiniteHunger = enabled
  InfiniteHungerEnabled = enabled

  if enabled then
    local attrName, currentValue = findHungerAttribute()
    if not attrName then
      showNotification("❌ Hunger attribute not found!", 3)
      features.infiniteHunger = false
      InfiniteHungerEnabled = false
      return
    end

    hungerAttributeName = attrName
    frozenHungerValue = currentValue

    -- Freeze hunger value
    HungerConnection =
    RunService.Heartbeat:Connect(
    function()
      if InfiniteHungerEnabled and hungerAttributeName and frozenHungerValue then
        local currentValue = Player:GetAttribute(hungerAttributeName)
        if currentValue and currentValue ~= frozenHungerValue then
          Player:SetAttribute(hungerAttributeName, frozenHungerValue)
        end
      end
    end
    )

    -- Hook SetAttribute
    pcall(
    function()
      if not originalSetAttribute then
        originalSetAttribute = Player.SetAttribute
        Player.SetAttribute = function(self, name, value)
        if InfiniteHungerEnabled and name == hungerAttributeName then
          return originalSetAttribute(self, name, frozenHungerValue)
        end
        return originalSetAttribute(self, name, value)
      end
    end
  end
  )

  showNotification("🔒 Hunger frozen at " .. frozenHungerValue, 2)
else
  if HungerConnection then
    HungerConnection:Disconnect()
    HungerConnection = nil
  end

  -- Restore original SetAttribute
  if originalSetAttribute then
    Player.SetAttribute = originalSetAttribute
    originalSetAttribute = nil
  end

  hungerAttributeName = nil
  frozenHungerValue = nil
  showNotification("🔓 Hunger unfrozen", 2)
end
end

-- ========== WEATHER + NO FOG FUNCTIONS ==========
local Lighting = game:GetService("Lighting")

-- === CLEAR WEATHER FUNCTIONS ===
local function setClearWeather()
if workspace:GetAttribute("Weather") ~= "Clear" then
  workspace:SetAttribute("Weather", "Clear")
end
end

local function toggleClearWeather(enabled)
features.clearWeather = enabled
WeatherEnabled = enabled

if enabled then
  -- Set weather to clear immediately
  setClearWeather()

  -- Monitor weather changes and force clear
  WeatherConnection = workspace:GetAttributeChangedSignal("Weather"):Connect(function()
  if WeatherEnabled and workspace:GetAttribute("Weather") ~= "Clear" then
    setClearWeather()
  end
  end)

  showNotification("☀️ Clear Weather enabled!", 2)
else
  if WeatherConnection then
    WeatherConnection:Disconnect()
    WeatherConnection = nil
  end
  showNotification("🌧️ Weather control disabled", 2)
end
end

-- === NO FOG FUNCTIONS ===
local function applyNoFog()
-- Remove all fog completely
Lighting.FogStart = 0
Lighting.FogEnd = math.huge  -- Infinite distance
Lighting.FogColor = Color3.fromRGB(255, 255, 255)  -- White fog (invisible)

-- Additional fog removal for all possible fog sources
pcall(function()
-- Remove atmosphere effects
if Lighting:FindFirstChild("Atmosphere") then
  Lighting.Atmosphere.Density = 0
  Lighting.Atmosphere.Offset = 0
  Lighting.Atmosphere.Color = Color3.fromRGB(255, 255, 255)
  Lighting.Atmosphere.Decay = Color3.fromRGB(255, 255, 255)
  Lighting.Atmosphere.Glare = 0
  Lighting.Atmosphere.Haze = 0
end

-- Remove clouds
if Lighting:FindFirstChild("Clouds") then
  Lighting.Clouds.Enabled = false
  Lighting.Clouds.Density = 0
end
end)

-- Remove fog from terrain
pcall(function()
local terrain = workspace.Terrain
if terrain then
  terrain.ReadVoxels = function() return end
end
end)
end

local function toggleNoFog(enabled)
features.noFog = enabled
NoFogEnabled = enabled

if enabled then
  -- Snapshot nilai awal
  originalFogStart = Lighting.FogStart
  originalFogEnd = Lighting.FogEnd
  originalFogColor = Lighting.FogColor

  -- Apply no fog
  applyNoFog()
  NoFogConnection = RunService.RenderStepped:Connect(applyNoFog)

  showNotification("🌫️ No Fog enabled!", 2)
else
  if NoFogConnection then
    NoFogConnection:Disconnect()
    NoFogConnection = nil
  end

  -- Restore original values
  if typeof(originalFogStart) == "number" then
    Lighting.FogStart = originalFogStart
  end
  if typeof(originalFogEnd) == "number" then
    Lighting.FogEnd = originalFogEnd
  end
  if typeof(originalFogColor) == "Color3" then
    Lighting.FogColor = originalFogColor
  end

  -- Clear snapshot
  originalFogStart, originalFogEnd, originalFogColor = nil, nil, nil

  showNotification("🌁 No Fog disabled", 2)
end
end

-- Store original settings untuk restore nanti
local function storeOriginalFPSSettings()
if not originalSettings.stored then
  local Lighting = game:GetService("Lighting")
  local workspace = game:GetService("Workspace")

  -- Store Lighting settings
  originalSettings.GlobalShadows = Lighting.GlobalShadows
  originalSettings.FogEnd = Lighting.FogEnd
  originalSettings.FogStart = Lighting.FogStart
  originalSettings.Brightness = Lighting.Brightness
  originalSettings.EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale
  originalSettings.EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale

  -- Store Workspace settings
  originalSettings.StreamingEnabled = workspace.StreamingEnabled

  -- Store terrain settings
  local terrain = workspace.Terrain
  if terrain then
    originalSettings.WaterWaveSize = terrain.WaterWaveSize
    originalSettings.WaterWaveSpeed = terrain.WaterWaveSpeed
    originalSettings.WaterReflectance = terrain.WaterReflectance
    originalSettings.WaterTransparency = terrain.WaterTransparency
  end

  originalSettings.stored = true
  print("✅ Original FPS settings stored")
end
end

-- Store original object properties BEFORE modifying them
local function storeOriginalObjectSettings()
print("📦 Storing original object settings...")
local objectCount = 0

pcall(function()
for _, obj in pairs(workspace:GetDescendants()) do
  -- Store ParticleEmitter settings
  if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") then
    if not originalObjectSettings[obj] then
      originalObjectSettings[obj] = {
        Enabled = obj.Enabled,
        objType = "Particle"
      }
      objectCount = objectCount + 1
    end

    -- Store Explosion settings
  elseif obj:IsA("Explosion") then
    if not originalObjectSettings[obj] then
      originalObjectSettings[obj] = {
        Visible = obj.Visible,
        objType = "Explosion"
      }
      objectCount = objectCount + 1
    end

    -- Store Decal and Texture settings
  elseif obj:IsA("Decal") then
    if not originalObjectSettings[obj] then
      originalObjectSettings[obj] = {
        Transparency = obj.Transparency,
        Texture = obj.Texture,
        objType = "Decal"
      }
      objectCount = objectCount + 1
    end

  elseif obj:IsA("Texture") then
    if not originalObjectSettings[obj] then
      originalObjectSettings[obj] = {
        Transparency = obj.Transparency,
        Texture = obj.Texture,
        objType = "Texture"
      }
      objectCount = objectCount + 1
    end

    -- Store SurfaceGui settings
  elseif obj:IsA("SurfaceGui") then
    if not originalObjectSettings[obj] then
      originalObjectSettings[obj] = {
        Enabled = obj.Enabled,
        objType = "SurfaceGui"
      }
      objectCount = objectCount + 1
    end

    -- Store SpecialMesh settings
  elseif obj:IsA("SpecialMesh") then
    if not originalObjectSettings[obj] then
      originalObjectSettings[obj] = {
        TextureId = obj.TextureId,
        objType = "SpecialMesh"
      }
      objectCount = objectCount + 1
    end

    -- Store Lighting effects settings
  elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
    if not originalObjectSettings[obj] then
      originalObjectSettings[obj] = {
        Enabled = obj.Enabled,
        Brightness = obj.Brightness,
        objType = "Light"
      }
      objectCount = objectCount + 1
    end
  end
end
end)

print("✅ Stored " .. objectCount .. " object settings")
end

-- Restore original settings
local function restoreOriginalFPSSettings()
if originalSettings.stored then
  pcall(function()
  local Lighting = game:GetService("Lighting")
  local workspace = game:GetService("Workspace")

  -- Restore Lighting settings
  Lighting.GlobalShadows = originalSettings.GlobalShadows
  Lighting.FogEnd = originalSettings.FogEnd
  Lighting.FogStart = originalSettings.FogStart
  Lighting.Brightness = originalSettings.Brightness
  Lighting.EnvironmentDiffuseScale = originalSettings.EnvironmentDiffuseScale
  Lighting.EnvironmentSpecularScale = originalSettings.EnvironmentSpecularScale

  -- Restore Workspace settings
  workspace.StreamingEnabled = originalSettings.StreamingEnabled

  -- Restore terrain settings
  local terrain = workspace.Terrain
  if terrain then
    terrain.WaterWaveSize = originalSettings.WaterWaveSize
    terrain.WaterWaveSpeed = originalSettings.WaterWaveSpeed
    terrain.WaterReflectance = originalSettings.WaterReflectance
    terrain.WaterTransparency = originalSettings.WaterTransparency
  end

  print("✅ Original FPS settings restored")
  end)
end
end

-- Apply FPS optimizations
local function applyFPSOptimizations()
pcall(function()
local Lighting = game:GetService("Lighting")
local workspace = game:GetService("Workspace")

-- 1. Remove Shadows
Lighting.GlobalShadows = false

-- 2. Optimize Lighting
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0

-- 3. Optimize Workspace
workspace.StreamingEnabled = false

-- 4. Simplify Terrain (make water static and clear)
local terrain = workspace.Terrain
if terrain then
  terrain.WaterWaveSize = 0
  terrain.WaterWaveSpeed = 0
  terrain.WaterReflectance = 0
  terrain.WaterTransparency = 0.8
end
end)
end

-- Remove/Disable graphics-heavy objects
local function optimizeObjects()
print("🔧 Applying object optimizations...")
local optimizedCount = 0

pcall(function()
for _, obj in pairs(workspace:GetDescendants()) do
  -- 5. Disable Particles
  if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") then
    obj.Enabled = false
    optimizedCount = optimizedCount + 1

  elseif obj:IsA("Explosion") then
    obj.Visible = false
    optimizedCount = optimizedCount + 1

    -- 6. Remove Decals and Textures for Low Graphics Mode
  elseif obj:IsA("Decal") or obj:IsA("Texture") then
    obj.Transparency = 1
    optimizedCount = optimizedCount + 1

    -- 7. Simplify SurfaceGui
  elseif obj:IsA("SurfaceGui") then
    obj.Enabled = false
    optimizedCount = optimizedCount + 1

    -- 8. Optimize SpecialMesh
  elseif obj:IsA("SpecialMesh") then
    obj.TextureId = ""
    optimizedCount = optimizedCount + 1

    -- 9. Remove unnecessary lighting effects
  elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
    obj.Enabled = false
    optimizedCount = optimizedCount + 1
  end
end
end)

print("✅ Optimized " .. optimizedCount .. " objects")
end

-- Restore ALL graphics objects to their original state
local function restoreObjects()
print("🔄 Restoring original object settings...")
local restoredCount = 0

pcall(function()
for obj, settings in pairs(originalObjectSettings) do
  if obj and obj.Parent and settings then
    -- Restore based on object type
    if settings.objType == "Particle" then
      obj.Enabled = settings.Enabled
      restoredCount = restoredCount + 1

    elseif settings.objType == "Explosion" then
      obj.Visible = settings.Visible
      restoredCount = restoredCount + 1

    elseif settings.objType == "Decal" then
      obj.Transparency = settings.Transparency
      if settings.Texture then
        obj.Texture = settings.Texture
      end
      restoredCount = restoredCount + 1

    elseif settings.objType == "Texture" then
      obj.Transparency = settings.Transparency
      if settings.Texture then
        obj.Texture = settings.Texture
      end
      restoredCount = restoredCount + 1

    elseif settings.objType == "SurfaceGui" then
      obj.Enabled = settings.Enabled
      restoredCount = restoredCount + 1

    elseif settings.objType == "SpecialMesh" then
      obj.TextureId = settings.TextureId
      restoredCount = restoredCount + 1

    elseif settings.objType == "Light" then
      obj.Enabled = settings.Enabled
      if settings.Brightness then
        obj.Brightness = settings.Brightness
      end
      restoredCount = restoredCount + 1
    end
  end
end
end)

print("✅ Restored " .. restoredCount .. " objects")

-- Clear the stored settings after restore
originalObjectSettings = {}
end

-- Monitor and maintain FPS optimizations
local function maintainFPSOptimizations()
while FPSBoostEnabled do
  wait(3) -- Check every 3 seconds

  if FPSBoostEnabled then
    applyFPSOptimizations()
    optimizeObjects()
  end
end
end

-- Main FPS Boost Toggle Function
local function toggleFPSBoost(enabled)
features.fpsBoost = enabled
FPSBoostEnabled = enabled

if enabled then
  -- Step 1: Store ALL original settings first
  storeOriginalFPSSettings()
  storeOriginalObjectSettings()

  -- Step 2: Apply optimizations
  applyFPSOptimizations()
  optimizeObjects()

  -- Step 3: Start monitoring to maintain optimizations
  spawn(maintainFPSOptimizations)

  showNotification("🚀 FPS Boost enabled! (Low Graphics Mode)", 2)
  print("✅ FPS Boost activated - All original settings stored")

else
  -- Step 1: Stop monitoring
  FPSBoostEnabled = false

  -- Step 2: Restore ALL original settings
  restoreOriginalFPSSettings()
  restoreObjects()

  showNotification("🎨 FPS Boost disabled! (Graphics restored)", 2)
  print("✅ FPS Boost deactivated - All settings restored to original")
end
end

-- ========== END FPS BOOST FUNCTIONS ==========

-- ========== NIGHT VISION FUNCTIONS ==========

-- Store original lighting values for night vision
local function storeOriginalNightVisionSettings()
if not originalAmbient then
  local Lighting = game:GetService("Lighting")
  originalAmbient = Lighting.Ambient
  originalOutdoorAmbient = Lighting.OutdoorAmbient
  print("✅ Original Night Vision settings stored")
end
end

-- Apply night vision effect
local function applyNightVision()
local Lighting = game:GetService("Lighting")

-- Enhanced night vision - make everything visible
Lighting.Ambient = Color3.fromRGB(100, 100, 100)
Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)
Lighting.Brightness = 3

-- Optional: Reduce shadows further for better visibility
if not features.fpsBoost then -- Don't interfere with FPS Boost
  Lighting.GlobalShadows = false
end
end

-- Restore original night vision settings
local function restoreNightVisionSettings()
if originalAmbient and originalOutdoorAmbient then
  local Lighting = game:GetService("Lighting")

  Lighting.Ambient = originalAmbient
  Lighting.OutdoorAmbient = originalOutdoorAmbient

  -- Only restore brightness if other lighting features aren't active
  if not features.alwaysBright and not features.alwaysNight and not features.fullHD then
    if originalBrightness then
      Lighting.Brightness = originalBrightness
    end
  end

  -- Only restore shadows if FPS Boost isn't active
  if not features.fpsBoost and originalSettings.GlobalShadows ~= nil then
    Lighting.GlobalShadows = originalSettings.GlobalShadows
  end

  print("✅ Night Vision settings restored")
end
end

-- Toggle Night Vision
local function toggleNightVision(enabled)
features.nightVision = enabled
NightVisionEnabled = enabled

if enabled then
  -- Store original settings first
  storeOriginalNightVisionSettings()

  -- Apply night vision
  applyNightVision()

  -- Monitor and maintain night vision
  NightVisionConnection = RunService.RenderStepped:Connect(function()
  if NightVisionEnabled then
    applyNightVision()
  end
  end)

  showNotification("🌙 Night Vision enabled!", 2)
  print("✅ Night Vision activated")

else
  -- Disconnect monitoring
  if NightVisionConnection then
    NightVisionConnection:Disconnect()
    NightVisionConnection = nil
  end

  -- Restore original settings
  restoreNightVisionSettings()

  showNotification("🌅 Night Vision disabled!", 2)
  print("✅ Night Vision deactivated")
end
end

-- ========== FIELD OF VIEW (FOV) FUNCTIONS ==========

-- Store original FOV
local function storeOriginalFOV()
if not originalFOV then
  originalFOV = Camera.FieldOfView
  currentFOV = originalFOV
  print("✅ Original FOV stored:", originalFOV)
end
end

-- Apply FOV change
local function applyFOV(fov)
if Camera then
  Camera.FieldOfView = fov
  currentFOV = fov
end
end

-- Restore original FOV
local function restoreOriginalFOV()
if originalFOV then
  applyFOV(originalFOV)
  print("✅ Original FOV restored:", originalFOV)
end
end

-- FOV change callback (for slider) - HANYA JALAN KALAU CUSTOMFOV ENABLED
local function onFOVChange(value)
-- Update settings value
settings.fieldOfView = value

-- Only apply if customFOV is enabled
if features.customFOV and CustomFOVEnabled then
  applyFOV(value)
  print("🔍 FOV changed to:", value)
  showNotification("🔍 FOV set to " .. value, 1)
end
end

-- Toggle customFOV Feature (for toggle button)
local function toggleCustomFOV(enabled)
features.customFOV = enabled
CustomFOVEnabled = enabled

if enabled then
  -- Store original FOV first
  storeOriginalFOV()

  -- Apply current slider value
  applyFOV(settings.fieldOfView)

  showNotification("🔍 Field of View enabled!", 2)
  print("✅ customFOV feature activated")

else
  -- Restore original FOV
  restoreOriginalFOV()

  showNotification("🔍 Field of View disabled!", 2)
  print("✅ customFOV feature deactivated")
end
end

-- ========== END NIGHT VISION & FOV FUNCTIONS ==========

-- ========== HITBOX SYSTEM FUNCTIONS ==========

-- Find targets for hitbox
local function findHitboxTargets(targetName)
local targets = {}
local charactersFolder = workspace:FindFirstChild("Characters")

if not charactersFolder then
  return targets
end

for _, obj in pairs(charactersFolder:GetChildren()) do
  if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
    local isMatch = false
    local objName = obj.Name

    -- Special matching for Cultish and Alien (any variation)
    if targetName == "Cultish" then
      isMatch = objName:lower():find("cultish") or objName:lower():find("cultist")
    elseif targetName == "Alien" then
      isMatch = objName:lower():find("alien")
    else
      isMatch = (objName == targetName)
    end

    if isMatch then
      local hrp = obj:FindFirstChild("HumanoidRootPart")
      if hrp then
        table.insert(targets, {
          model = obj,
          hrp = hrp,
          name = objName
        })
      end
    end
  end
end

return targets
end

-- Create hitbox visualization
local function createHitboxVisualization(target, size)
local hrp = target.hrp
if not hrp then return nil end

-- Create selection box
local selectionBox = Instance.new("SelectionBox")
selectionBox.Name = "HitboxVisualization_" .. target.name
selectionBox.Parent = hrp
selectionBox.Adornee = hrp
selectionBox.Color3 = Color3.new(1, 1, 1) -- White color
selectionBox.Transparency = 0.5
selectionBox.LineThickness = 0.2

-- Resize HRP collision for larger hitbox
local originalSize = hrp.Size
hrp.Size = Vector3.new(size, size, size)

return {
  selectionBox = selectionBox,
  target = target,
  originalSize = originalSize
}
end

-- Update hitbox sizes
local function updateHitboxSizes(newSize)
HitboxSystem.size = newSize

for _, hitboxData in pairs(HitboxSystem.activeHitboxes) do
  if hitboxData and hitboxData.target and hitboxData.target.hrp and hitboxData.target.hrp.Parent then
    -- Update HRP size
    hitboxData.target.hrp.Size = Vector3.new(newSize, newSize, newSize)
  end
end
end

-- Clear all hitboxes
local function clearAllHitboxes()
for _, hitboxData in pairs(HitboxSystem.activeHitboxes) do
  if hitboxData then
    -- Restore original HRP size
    if hitboxData.target and hitboxData.target.hrp and hitboxData.target.hrp.Parent and hitboxData.originalSize then
      hitboxData.target.hrp.Size = hitboxData.originalSize
    end

    -- Remove selection box
    if hitboxData.selectionBox and hitboxData.selectionBox.Parent then
      hitboxData.selectionBox:Destroy()
    end
  end
end
HitboxSystem.activeHitboxes = {}
end

-- Create hitboxes for selected target
local function createHitboxesForTarget(targetName)
local targets = findHitboxTargets(targetName)
local created = 0

for _, target in pairs(targets) do
  local hitboxData = createHitboxVisualization(target, HitboxSystem.size)
  if hitboxData then
    table.insert(HitboxSystem.activeHitboxes, hitboxData)
    created = created + 1
  end
end

if created > 0 then
  showNotification("Hitbox: " .. created .. " " .. targetName .. " targets", 2)
end
end

-- Monitor hitbox targets (check for new spawns)
local function monitorHitboxTargets()
while HitboxSystem.enabled and HitboxSystem.selectedTarget do
  wait(2) -- Check every 2 seconds

  if HitboxSystem.enabled and HitboxSystem.selectedTarget then
    -- Clear invalid hitboxes
    for i = #HitboxSystem.activeHitboxes, 1, -1 do
      local hitboxData = HitboxSystem.activeHitboxes[i]
      if not hitboxData or not hitboxData.target or not hitboxData.target.hrp or not hitboxData.target.hrp.Parent then
        table.remove(HitboxSystem.activeHitboxes, i)
      end
    end

    -- Add new targets
    local currentTargets = findHitboxTargets(HitboxSystem.selectedTarget)
    for _, newTarget in pairs(currentTargets) do
      local alreadyExists = false
      for _, existingHitbox in pairs(HitboxSystem.activeHitboxes) do
        if existingHitbox.target and existingHitbox.target.model == newTarget.model then
          alreadyExists = true
          break
        end
      end

      if not alreadyExists then
        local hitboxData = createHitboxVisualization(newTarget, HitboxSystem.size)
        if hitboxData then
          table.insert(HitboxSystem.activeHitboxes, hitboxData)
        end
      end
    end
  end
end
end

-- Toggle hitbox system
local function toggleHitbox(enabled)
features.hitbox = enabled
HitboxSystem.enabled = enabled

if enabled then
  if not HitboxSystem.selectedTarget then
    showNotification("Select a target first!", 2)
    features.hitbox = false
    HitboxSystem.enabled = false
    return
  end

  -- Create hitboxes for selected target
  createHitboxesForTarget(HitboxSystem.selectedTarget)

  -- Start monitoring
  spawn(monitorHitboxTargets)

  showNotification("Hitbox enabled for " .. HitboxSystem.selectedTarget, 2)
else
  -- Clear all hitboxes
  clearAllHitboxes()
  showNotification("Hitbox disabled", 2)
end
end

-- Hitbox size change callback
local function onHitboxSizeChange(value)
HitboxSystem.size = value
if HitboxSystem.enabled then
  updateHitboxSizes(value)
end
end

-- ========== END HITBOX SYSTEM FUNCTIONS ==========

-- ========== FIXED ITEM LIST SCANNER SYSTEM FUNCTIONS ==========

-- Function untuk scan HANYA di Workspace > Items (NO DEEP SCAN)
local function scanWorkspaceItems()
    local itemsFound = {}
    local itemsFolder = workspace:FindFirstChild("Items")

    if not itemsFolder then
        print("❌ Items folder not found in Workspace")
        return itemsFound
    end

    print("🔍 Scanning Workspace.Items folder (NO DEEP SCAN)...")

    -- HANYA scan direct children dari Items folder (NO DEEP SCAN!)
    for _, item in pairs(itemsFolder:GetChildren()) do
        if item and item.Parent then
            local itemName = item.Name

            -- Check blacklist (case insensitive)
            local isBlacklisted = false
            if ItemListSystem and ItemListSystem.blacklistedKeywords then
                for _, keyword in pairs(ItemListSystem.blacklistedKeywords) do
                    if itemName:lower():find(keyword:lower()) then
                        isBlacklisted = true
                        break
                    end
                end
            end

            if not isBlacklisted then
                -- Count items with same name
                if itemsFound[itemName] then
                    itemsFound[itemName] = itemsFound[itemName] + 1
                else
                    itemsFound[itemName] = 1
                end
                print("✅ Found: " .. itemName)
            else
                print("❌ Blacklisted: " .. itemName)
            end
        end
    end

    print("✅ Scan complete. Found " .. tostring(#itemsFound) .. " unique items")
    return itemsFound
end

-- FIXED: Function untuk update item list UI
local function updateItemListUI(listFrame, items)
    if not listFrame or not listFrame.Parent then
        print("❌ listFrame is nil or destroyed")
        return
    end

    print("🔄 Updating UI with items...")
    
    -- Clear existing items
    for _, child in pairs(listFrame:GetChildren()) do
        if child:IsA("TextLabel") and child.Name:find("ItemEntry") then
            child:Destroy()
        end
    end

    -- Convert table to sorted array
    local sortedItems = {}
    for itemName, count in pairs(items) do
        table.insert(sortedItems, {name = itemName, count = count})
        print("📝 Adding to UI: " .. itemName .. " (x" .. count .. ")")
    end

    -- Sort alphabetically
    table.sort(sortedItems, function(a, b) return a.name < b.name end)

    -- FIXED: Simple vertical layout instead of complex grid
    local yOffset = 5
    local itemHeight = 25
    local itemSpacing = 5

    for i, itemData in ipairs(sortedItems) do
        -- Create item label with simple vertical positioning
        local itemLabel = Instance.new("TextLabel")
        itemLabel.Name = "ItemEntry_" .. i
        itemLabel.Parent = listFrame
        itemLabel.Size = UDim2.new(1, -10, 0, itemHeight)
        itemLabel.Position = UDim2.new(0, 5, 0, yOffset)
        itemLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        itemLabel.BackgroundTransparency = 0.3
        itemLabel.BorderSizePixel = 0
        itemLabel.Text = itemData.name .. " (x" .. itemData.count .. ")"
        itemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        itemLabel.TextSize = 14
        itemLabel.Font = Enum.Font.Gotham
        itemLabel.TextXAlignment = Enum.TextXAlignment.Left

        -- Add corner radius
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = itemLabel

        -- Add padding
        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 10)
        padding.PaddingRight = UDim.new(0, 10)
        padding.Parent = itemLabel

        yOffset = yOffset + itemHeight + itemSpacing
        
        print("✅ Created UI element for: " .. itemData.name)
    end

    -- Update canvas size untuk scrolling
    listFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)

    print("✅ Item list UI updated: " .. #sortedItems .. " items displayed")
end

-- FIXED: Manual update dengan better error handling
local function manualUpdateItemList(listFrame, statusLabel)
    -- Pastikan parameter ada
    if not listFrame then
        print("❌ manualUpdateItemList: listFrame is nil")
        return
    end
    
    print("🔄 Manual update started...")
    
    -- Wrap dalam pcall untuk handle error
    local success, result = pcall(function()
        local items = scanWorkspaceItems()
        
        -- Debug: Print items found
        local itemCount = 0
        for name, count in pairs(items) do
            itemCount = itemCount + 1
            print("📋 Item found: " .. name .. " (x" .. count .. ")")
        end
        print("📊 Total unique items: " .. itemCount)
        
        if ItemListSystem then
            ItemListSystem.items = items
            ItemListSystem.lastUpdateTime = tick()
        end
        
        updateItemListUI(listFrame, items)
        
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = "Last Update: " .. os.date("%H:%M:%S")
        end
        
        return true
    end)
    
    if success then
        print("✅ Manual update completed successfully")
        if showNotification then
            showNotification("Item list updated!", 2)
        end
    else
        print("❌ Manual update failed:", result)
        if showNotification then
            showNotification("Update failed: " .. tostring(result), 3)
        end
    end
end

-- Function untuk start auto update
local function startAutoUpdate(listFrame, statusLabel, countdownLabel)
    if ItemListSystem and ItemListSystem.countdownConnection then
        ItemListSystem.countdownConnection:Disconnect()
    end

    if not ItemListSystem then
        ItemListSystem = {}
    end
    
    ItemListSystem.autoUpdateCountdown = 10

    ItemListSystem.countdownConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not ItemListSystem.autoUpdateEnabled then
            return
        end

        -- Update countdown every second
        local currentTime = tick()
        local deltaTime = currentTime - (ItemListSystem.lastCountdownTime or currentTime)

        if deltaTime >= 1 then
            ItemListSystem.lastCountdownTime = currentTime
            ItemListSystem.autoUpdateCountdown = ItemListSystem.autoUpdateCountdown - 1

            if countdownLabel and countdownLabel.Parent then
                countdownLabel.Text = "Auto Update in " .. ItemListSystem.autoUpdateCountdown .. "s"
            end

            -- Auto update when countdown reaches 0
            if ItemListSystem.autoUpdateCountdown <= 0 then
                manualUpdateItemList(listFrame, statusLabel)
                ItemListSystem.autoUpdateCountdown = 10 -- Reset countdown
            end
        end
    end)
end

-- Function untuk stop auto update
local function stopAutoUpdate(countdownLabel)
    if ItemListSystem then
        ItemListSystem.autoUpdateEnabled = false

        if ItemListSystem.countdownConnection then
            ItemListSystem.countdownConnection:Disconnect()
            ItemListSystem.countdownConnection = nil
        end
    end

    if countdownLabel and countdownLabel.Parent then
        countdownLabel.Text = "Auto Update: OFF"
    end
end

-- FIXED: Create Item List Frame dengan improved functionality
local function createItemListFrame(parent)
    local container = Instance.new("Frame")
    container.Name = "ItemListContainer"
    container.Size = UDim2.new(1, 0, 0, 350)
    container.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    container.BorderSizePixel = 0
    container.Parent = parent
    container.LayoutOrder = 3 -- After bring items frame

    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 8)
    containerCorner.Parent = container

    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Position = UDim2.new(0, 0, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Item Scanner"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = container

    -- Status label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(0.5, 0, 0, 20)
    statusLabel.Position = UDim2.new(0, 10, 0, 35)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Last Update: Never"
    statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 10
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = container

    -- Countdown label
    local countdownLabel = Instance.new("TextLabel")
    countdownLabel.Name = "CountdownLabel"
    countdownLabel.Size = UDim2.new(0.5, 0, 0, 20)
    countdownLabel.Position = UDim2.new(0.5, -10, 0, 35)
    countdownLabel.BackgroundTransparency = 1
    countdownLabel.Text = "Auto Update: OFF"
    countdownLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    countdownLabel.Font = Enum.Font.Gotham
    countdownLabel.TextSize = 10
    countdownLabel.TextXAlignment = Enum.TextXAlignment.Right
    countdownLabel.Parent = container

    -- List frame (scrollable)
    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Name = "ItemListFrame"
    listFrame.Size = UDim2.new(1, -20, 1, -105) -- Space for buttons
    listFrame.Position = UDim2.new(0, 10, 0, 55)
    listFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    listFrame.BorderSizePixel = 0
    listFrame.ScrollBarThickness = 4
    listFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.Parent = container

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 6)
    listCorner.Parent = listFrame

    -- Button frame
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = "ButtonFrame"
    buttonFrame.Size = UDim2.new(1, -20, 0, 35)
    buttonFrame.Position = UDim2.new(0, 10, 1, -45)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = container

    -- Update List Button
    local updateButton = Instance.new("TextButton")
    updateButton.Name = "UpdateButton"
    updateButton.Size = UDim2.new(0.45, -5, 1, 0)
    updateButton.Position = UDim2.new(0, 0, 0, 0)
    updateButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    updateButton.Text = "Update List"
    updateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    updateButton.Font = Enum.Font.GothamBold
    updateButton.TextSize = 14
    updateButton.Parent = buttonFrame

    local updateCorner = Instance.new("UICorner")
    updateCorner.CornerRadius = UDim.new(0, 6)
    updateCorner.Parent = updateButton

    -- Auto Update Button
    local autoUpdateButton = Instance.new("TextButton")
    autoUpdateButton.Name = "AutoUpdateButton"
    autoUpdateButton.Size = UDim2.new(0.45, -5, 1, 0)
    autoUpdateButton.Position = UDim2.new(0.55, 0, 0, 0)
    autoUpdateButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    autoUpdateButton.Text = "Auto Update: OFF"
    autoUpdateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoUpdateButton.Font = Enum.Font.GothamBold
    autoUpdateButton.TextSize = 12
    autoUpdateButton.Parent = buttonFrame

    local autoCorner = Instance.new("UICorner")
    autoCorner.CornerRadius = UDim.new(0, 6)
    autoCorner.Parent = autoUpdateButton

    -- Initialize ItemListSystem if not exists
    if not ItemListSystem then
        ItemListSystem = {
            autoUpdateEnabled = false,
            blacklistedKeywords = {"Chest", "chest", "Box", "box"}, -- Default blacklist
            items = {},
            lastUpdateTime = 0
        }
    end

    -- FIXED: Update button functionality
    updateButton.MouseButton1Click:Connect(function()
        print("🔘 Update List button clicked")
        updateButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        updateButton.Text = "Updating..."
        
        spawn(function()
            wait(0.1) -- Small delay
            manualUpdateItemList(listFrame, statusLabel)
            
            wait(0.5)
            if updateButton and updateButton.Parent then
                updateButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
                updateButton.Text = "Update List"
            end
        end)
    end)

    -- FIXED: Auto update button functionality
    autoUpdateButton.MouseButton1Click:Connect(function()
        print("🔘 Auto Update button clicked")
        
        ItemListSystem.autoUpdateEnabled = not ItemListSystem.autoUpdateEnabled

        if ItemListSystem.autoUpdateEnabled then
            autoUpdateButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
            autoUpdateButton.Text = "Auto Update: ON"
            ItemListSystem.lastCountdownTime = tick()
            startAutoUpdate(listFrame, statusLabel, countdownLabel)
            print("✅ Auto update enabled")
        else
            autoUpdateButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            autoUpdateButton.Text = "Auto Update: OFF"
            stopAutoUpdate(countdownLabel)
            print("❌ Auto update disabled")
        end
    end)

    -- FIXED: Initial scan dengan delay
    spawn(function()
        wait(2) -- Give time for everything to load
        print("🔄 Starting initial scan...")
        manualUpdateItemList(listFrame, statusLabel)
    end)

    print("✅ Item List Frame created successfully")
    return container
end

-- ========== END FIXED ITEM LIST SCANNER SYSTEM FUNCTIONS ==========
-- ========== LIGHTING CONTROL FUNCTIONS ==========

-- Store original values
local function storeOriginalLightingValues()
if not originalClockTime then
  originalClockTime = Lighting.ClockTime
end
if not originalBrightness then
  originalBrightness = Lighting.Brightness
end
end

-- Restore original values
local function restoreOriginalLightingValues()
if originalClockTime then
  Lighting.ClockTime = originalClockTime
end
if originalBrightness then
  Lighting.Brightness = originalBrightness
end
end

-- === ALWAYS BRIGHT FUNCTIONS ===
local function applyAlwaysBright()
Lighting.ClockTime = 14.5
Lighting.Brightness = 15.5
end

local function toggleAlwaysBright(enabled)
features.alwaysBright = enabled
AlwaysBrightEnabled = enabled

if enabled then
  -- Disable other lighting modes first
  if AlwaysNightEnabled then
    toggleAlwaysNight(false)
  end
  if FullHDEnabled then
    toggleFullHD(false)
  end

  -- Store original values
  storeOriginalLightingValues()

  -- Apply always bright
  applyAlwaysBright()
  LightingConnection = RunService.RenderStepped:Connect(applyAlwaysBright)

  showNotification("☀️ Always Bright enabled!", 2)
else
  if LightingConnection then
    LightingConnection:Disconnect()
    LightingConnection = nil
  end

  restoreOriginalLightingValues()
  showNotification("🌅 Always Bright disabled", 2)
end
end

-- === ALWAYS NIGHT FUNCTIONS ===
local function applyAlwaysNight()
Lighting.ClockTime = 23.5
Lighting.Brightness = 0.1
end

local function toggleAlwaysNight(enabled)
features.alwaysNight = enabled
AlwaysNightEnabled = enabled

if enabled then
  -- Disable other lighting modes first
  if AlwaysBrightEnabled then
    toggleAlwaysBright(false)
  end
  if FullHDEnabled then
    toggleFullHD(false)
  end

  -- Store original values
  storeOriginalLightingValues()

  -- Apply always night
  applyAlwaysNight()
  LightingConnection = RunService.RenderStepped:Connect(applyAlwaysNight)

  showNotification("🌙 Always Night enabled!", 2)
else
  if LightingConnection then
    LightingConnection:Disconnect()
    LightingConnection = nil
  end

  restoreOriginalLightingValues()
  showNotification("🌛 Always Night disabled", 2)
end
end

-- === FULL HD FUNCTIONS ===
local function applyFullHD()
Lighting.Brightness = 15.5
end

local function toggleFullHD(enabled)
features.fullHD = enabled
FullHDEnabled = enabled

if enabled then
  -- Disable other lighting modes first
  if AlwaysBrightEnabled then
    toggleAlwaysBright(false)
  end
  if AlwaysNightEnabled then
    toggleAlwaysNight(false)
  end

  -- Store original values (only brightness for Full HD)
  if not originalBrightness then
    originalBrightness = Lighting.Brightness
  end

  -- Apply full HD (only brightness)
  applyFullHD()
  LightingConnection = RunService.RenderStepped:Connect(applyFullHD)

  showNotification("✨ Full HD enabled!", 2)
else
  if LightingConnection then
    LightingConnection:Disconnect()
    LightingConnection = nil
  end

  if originalBrightness then
    Lighting.Brightness = originalBrightness
  end
  showNotification("🔆 Full HD disabled", 2)
end
end

-- Fungsi pencarian item yang lebih baik
local function findItemBetter(itemName)
local items = {}
local checkList = {
  workspace,
  workspace:FindFirstChild("Items")
}

for _, specialFolder in pairs(workspace:GetChildren()) do
  if specialFolder:IsA("Folder") or specialFolder:IsA("Model") then
    table.insert(checkList, specialFolder)
  end
end

pcall(
function()
  table.insert(checkList, game:GetService("ReplicatedStorage"))
end
)

local function searchIn(container)
  for _, obj in pairs(container:GetDescendants()) do
    local name = obj.Name:lower()
    local target = itemName:lower()

    local isMatch = false
    if name == target then
      isMatch = true
    end
    if name:find(target) or target:find(name) then
      isMatch = true
    end
    if name:gsub("%s+", "") == target:gsub("%s+", "") then
      isMatch = true
    end

    if isMatch and (obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("Tool")) then
      -- Pastikan item tidak di dalam karakter player
      local isInCharacter = obj:IsDescendantOf(game.Players.LocalPlayer.Character)
      if not isInCharacter then
        table.insert(items, obj)
      end
    end
  end -- end untuk for
end -- end untuk function searchIn
for _, container in ipairs(checkList) do
  if container then
    searchIn(container)
  end
end

return items
end

-- ========== FIXED ESP SYSTEM ==========
-- Perbaikan untuk integrasi ke script utama
-- Ganti bagian ESP di script main Anda dengan code ini

-- ESP Storage yang sudah ada - PERBAIKAN
local ESPSystem = {
enabled = {animals = false, npcs = false, items = false},
selected = {animals = {}, npcs = {}, items = {}},
activeESP = {},
targets = {
  animals = {"Bunny", "Wolf", "Alpha Wolf", "Bear", "Pola Bear", "Artic Fox", "Mammoth"},
  npcs = {"Cultish", "Alien", "Pelt trader", "Furniture Trader", "Fairy", "LostChild", "LostChild2", "LostChild3", "LostChild4"},
  items = {"Bolt", "Metal Sheet", "Tyre", "Broken Fan", "Broken Radio", "Broken Microwave", "Washing Machine", "Metal Chair", "Old Car Engine", "UFO Junk", "UFO Component", "UFO Scrap", "Cultist Experiment", "Cultist Prototype", "Carrot", "Apple", "Berry", "Cake", "Morsel", "Steak", "Ribs", "Bandage", "MedKit", "Chili", "Hearty Stew", "Meat Sandwich", "Log", "Chair", "Biofuel", "Coal", "Fuel Canister", "Oil Barrel"}
}
}

-- Find ESP targets - PERBAIKAN untuk executor
local function findESPTargets(espType, targetName)
local objects = {}
local searchFolders = {}

-- Determine search locations
if espType == "animals" or espType == "npcs" then
  local charactersFolder = workspace:FindFirstChild("Characters")
  if charactersFolder then
    table.insert(searchFolders, charactersFolder)
  end
  -- Fallback search in workspace
  table.insert(searchFolders, workspace)
elseif espType == "items" then
  local itemsFolder = workspace:FindFirstChild("Items")
  if itemsFolder then
    table.insert(searchFolders, itemsFolder)
  end
  local mapFolder = workspace:FindFirstChild("Map")
  if mapFolder then
    table.insert(searchFolders, mapFolder)
  end
  table.insert(searchFolders, workspace)
end

-- Search for targets
for _, folder in ipairs(searchFolders) do
  if folder and folder.Parent then
    pcall(function()
    for _, obj in ipairs(folder:GetChildren()) do
      if obj and obj.Parent then
        local isMatch = false
        local objName = obj.Name

        -- Matching logic
        if targetName == "Cultish" then
          isMatch = objName:lower():find("cultish") or objName:lower():find("cultist")
        elseif targetName:find("Child") then
          isMatch = objName:find("Child") or objName == targetName
        else
          isMatch = (objName == targetName)
        end

        if isMatch then
          -- Type-specific filtering
          if espType == "animals" or espType == "npcs" then
            if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
              table.insert(objects, obj)
            end
          elseif espType == "items" then
            if obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("Tool") then
              table.insert(objects, obj)
            end
          end
        end
      end
    end

    -- Deep search untuk items yang tersembunyi
    if espType == "items" then
      for _, obj in ipairs(folder:GetDescendants()) do
        if obj and obj.Parent and obj.Name == targetName then
          if obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("Tool") then
            table.insert(objects, obj)
          end
        end
      end
    end
    end)
  end
end

print("🔍 ESP: Found " .. #objects .. " " .. targetName .. " objects")
return objects
end

-- Create ESP Visualization - FIXED VERSION
local function createESPVisualization(obj, targetName)
if not obj or not obj.Parent then
  return nil
end

local success, espData = pcall(function()
-- Find main part for ESP
local targetPart = nil
if obj:IsA("Model") then
  targetPart = obj:FindFirstChild("HumanoidRootPart") or
  obj:FindFirstChild("Trunk") or
  obj:FindFirstChild("Handle") or
  obj:FindFirstChild("Root") or
  obj.PrimaryPart

  -- If none found, get first BasePart
  if not targetPart then
    for _, part in ipairs(obj:GetChildren()) do
      if part:IsA("BasePart") then
        targetPart = part
        break
      end
    end
  end
elseif obj:IsA("BasePart") then
  targetPart = obj
end

if not targetPart or not targetPart:IsA("BasePart") then
  return nil
end

-- Create BillboardGui
local billboard = Instance.new("BillboardGui")
billboard.Name = "ESP_" .. targetName .. "_" .. tostring(obj):sub(-8)
billboard.Parent = targetPart
billboard.Size = UDim2.new(0, 200, 0, 80)
billboard.StudsOffset = Vector3.new(0, 3, 0)
billboard.AlwaysOnTop = true
billboard.LightInfluence = 0

-- Background frame
local bgFrame = Instance.new("Frame")
bgFrame.Parent = billboard
bgFrame.Size = UDim2.new(1, 0, 1, 0)
bgFrame.BackgroundColor3 = Color3.new(0, 0, 0)
bgFrame.BackgroundTransparency = 0.3
bgFrame.BorderSizePixel = 0

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 6)
bgCorner.Parent = bgFrame

-- Name label
local nameLabel = Instance.new("TextLabel")
nameLabel.Parent = bgFrame
nameLabel.Size = UDim2.new(1, -10, 0.6, 0)
nameLabel.Position = UDim2.new(0, 5, 0, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = targetName
nameLabel.TextColor3 = Color3.new(0, 0.6, 1) -- Blue
nameLabel.TextScaled = true
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextStrokeTransparency = 0
nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)

-- Distance label
local distanceLabel = Instance.new("TextLabel")
distanceLabel.Parent = bgFrame
distanceLabel.Size = UDim2.new(1, -10, 0.4, 0)
distanceLabel.Position = UDim2.new(0, 5, 0.6, 0)
distanceLabel.BackgroundTransparency = 1
distanceLabel.Text = "0m"
distanceLabel.TextColor3 = Color3.new(1, 1, 1)
distanceLabel.TextScaled = true
distanceLabel.Font = Enum.Font.Gotham
distanceLabel.TextStrokeTransparency = 0
distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)

-- Create line (Beam)
local line = nil
local attachment0 = nil
local attachment1 = nil

if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
  -- Attachment on target
  attachment0 = Instance.new("Attachment")
  attachment0.Name = "ESPTarget"
  attachment0.Parent = targetPart

  -- Attachment on player
  attachment1 = Instance.new("Attachment")
  attachment1.Name = "ESPPlayer"
  attachment1.Parent = Player.Character.HumanoidRootPart

  -- Blue beam line
  line = Instance.new("Beam")
  line.Name = "ESPLine"
  line.Parent = workspace
  line.Color = ColorSequence.new(Color3.new(0, 0.6, 1))
  line.Width0 = 0.2
  line.Width1 = 0.2
  line.Transparency = NumberSequence.new(0.3)
  line.FaceCamera = true
  line.Attachment0 = attachment0
  line.Attachment1 = attachment1
end

return {
  billboard = billboard,
  line = line,
  attachment0 = attachment0,
  attachment1 = attachment1,
  targetPart = targetPart,
  distanceLabel = distanceLabel,
  object = obj,
  targetName = targetName
}
end)

if success and espData then
  return espData
else
  print("❌ ESP: Failed to create ESP for " .. targetName)
  return nil
end
end

-- Update ESP System - FIXED
local function updateESPSystem()
if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then
  return
end

local playerPos = Player.Character.HumanoidRootPart.Position

for espKey, espList in pairs(ESPSystem.activeESP) do
  if espList and type(espList) == "table" then
    for i = #espList, 1, -1 do
      local espData = espList[i]

      -- Validate ESP data
      if not espData or not espData.object or not espData.object.Parent or
      not espData.targetPart or not espData.targetPart.Parent then
        -- Cleanup invalid ESP
        pcall(function()
        if espData then
          if espData.billboard then espData.billboard:Destroy() end
          if espData.line then espData.line:Destroy() end
          if espData.attachment0 then espData.attachment0:Destroy() end
          if espData.attachment1 then espData.attachment1:Destroy() end
        end
        end)
        table.remove(espList, i)
      else
        -- Update distance
        local distance = math.floor((playerPos - espData.targetPart.Position).Magnitude)
        if espData.distanceLabel then
          espData.distanceLabel.Text = distance .. "m"
        end

        -- Update line connection
        if espData.line and espData.attachment1 then
          if espData.attachment1.Parent ~= Player.Character.HumanoidRootPart then
            pcall(function()
            espData.attachment1.Parent = Player.Character.HumanoidRootPart
            end)
          end
        end
      end
    end
  end
end
end

-- Activate ESP for category - FIXED
local function activateESPForCategory(espType)
if not ESPSystem.enabled[espType] then
  return
end

print("🔄 ESP: Activating " .. espType)

-- Clear old ESP first
for espKey, espList in pairs(ESPSystem.activeESP) do
  if espKey:find(espType .. "_") then
    for _, espData in pairs(espList) do
      pcall(function()
      if espData.billboard then espData.billboard:Destroy() end
      if espData.line then espData.line:Destroy() end
      if espData.attachment0 then espData.attachment0:Destroy() end
      if espData.attachment1 then espData.attachment1:Destroy() end
      end)
    end
    ESPSystem.activeESP[espKey] = nil
  end
end

-- Create ESP for selected targets
local totalCreated = 0
for targetName, isSelected in pairs(ESPSystem.selected[espType]) do
  if isSelected then
    local objects = findESPTargets(espType, targetName)
    local espKey = espType .. "_" .. targetName
    ESPSystem.activeESP[espKey] = {}

    for _, obj in ipairs(objects) do
      local espData = createESPVisualization(obj, targetName)
      if espData then
        table.insert(ESPSystem.activeESP[espKey], espData)
        totalCreated = totalCreated + 1
      end
    end
  end
end

if totalCreated > 0 then
  showNotification("ESP " .. espType .. ": " .. totalCreated .. " created", 2)
end
end

-- Deactivate ESP for category
local function deactivateESPForCategory(espType)
for espKey, espList in pairs(ESPSystem.activeESP) do
  if espKey:find(espType .. "_") then
    for _, espData in pairs(espList) do
      pcall(function()
      if espData.billboard then espData.billboard:Destroy() end
      if espData.line then espData.line:Destroy() end
      if espData.attachment0 then espData.attachment0:Destroy() end
      if espData.attachment1 then espData.attachment1:Destroy() end
      end)
    end
    ESPSystem.activeESP[espKey] = nil
  end
end
end

-- FIXED ESP UI Creation - mengatasi error UIPadding
local function createCorrectESPSection(parent, title, espType, targets)
local container = Instance.new("Frame")
container.Name = title .. "Container"
container.Size = UDim2.new(1, 0, 0, 50)
container.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
container.BorderSizePixel = 0
container.Parent = parent
container.AutomaticSize = Enum.AutomaticSize.Y
container.LayoutOrder = (#parent:GetChildren())

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 8)
containerCorner.Parent = container

-- Header section
local headerFrame = Instance.new("Frame")
headerFrame.Name = "HeaderFrame"
headerFrame.Size = UDim2.new(1, 0, 0, 50)
headerFrame.BackgroundTransparency = 1
headerFrame.Parent = container

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0.4, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = title
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = headerFrame

-- ON/OFF Button
local onOffButton = Instance.new("TextButton")
onOffButton.Name = "OnOffButton"
onOffButton.Size = UDim2.new(0.2, -5, 0.6, 0)
onOffButton.Position = UDim2.new(0.4, 0, 0.2, 0)
onOffButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
onOffButton.Text = "OFF"
onOffButton.TextColor3 = Color3.fromRGB(255, 255, 255)
onOffButton.Font = Enum.Font.GothamBold
onOffButton.TextSize = 14
onOffButton.Parent = headerFrame

local onOffCorner = Instance.new("UICorner")
onOffCorner.CornerRadius = UDim.new(0, 6)
onOffCorner.Parent = onOffButton

-- Dropdown Button
local dropdownButton = Instance.new("TextButton")
dropdownButton.Name = "DropdownButton"
dropdownButton.Size = UDim2.new(0.35, -5, 0.6, 0)
dropdownButton.Position = UDim2.new(0.62, 0, 0.2, 0)
dropdownButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
dropdownButton.Text = "Select Targets ▼"
dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdownButton.Font = Enum.Font.Gotham
dropdownButton.TextSize = 12
dropdownButton.Parent = headerFrame

local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0, 6)
dropdownCorner.Parent = dropdownButton

-- Selection Frame
local selectionFrame = Instance.new("Frame")
selectionFrame.Name = "SelectionFrame"
selectionFrame.Size = UDim2.new(1, -20, 0, 0)
selectionFrame.Position = UDim2.new(0, 10, 0, 55)
selectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
selectionFrame.BorderSizePixel = 0
selectionFrame.Parent = container
selectionFrame.AutomaticSize = Enum.AutomaticSize.Y
selectionFrame.Visible = false

local selectionCorner = Instance.new("UICorner")
selectionCorner.CornerRadius = UDim.new(0, 6)
selectionCorner.Parent = selectionFrame

-- Layout for buttons
local targetLayout = Instance.new("UIListLayout")
targetLayout.Parent = selectionFrame
targetLayout.FillDirection = Enum.FillDirection.Vertical
targetLayout.SortOrder = Enum.SortOrder.LayoutOrder
targetLayout.Padding = UDim.new(0, 3)

-- FIXED: Wrap UIPadding in pcall to prevent errors
pcall(function()
local targetPadding = Instance.new("UIPadding")
targetPadding.Parent = selectionFrame
targetPadding.PaddingAll = UDim.new(0, 8)
end)

-- Create target buttons
local targetButtons = {}
for i, targetName in ipairs(targets) do
  local targetButton = Instance.new("TextButton")
  targetButton.Name = targetName .. "Button"
  targetButton.Size = UDim2.new(1, 0, 0, 35)
  targetButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
  targetButton.Text = targetName
  targetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
  targetButton.Font = Enum.Font.Gotham
  targetButton.TextSize = 14
  targetButton.Parent = selectionFrame
  targetButton.LayoutOrder = i

  local targetCorner = Instance.new("UICorner")
  targetCorner.CornerRadius = UDim.new(0, 6)
  targetCorner.Parent = targetButton

  targetButtons[targetName] = targetButton

  -- Target selection logic
  targetButton.MouseButton1Click:Connect(function()
  pcall(function()
  local isSelected = ESPSystem.selected[espType][targetName] or false
  local newState = not isSelected

  ESPSystem.selected[espType][targetName] = newState

  if newState then
    targetButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    targetButton.Text = targetName .. " ✓"
    print("✅ ESP: Selected " .. targetName)
  else
    targetButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    targetButton.Text = targetName
    print("❌ ESP: Deselected " .. targetName)
  end

  -- Update ESP if enabled
  if ESPSystem.enabled[espType] then
    activateESPForCategory(espType)
  end
  end)
  end)
end

-- ON/OFF functionality
onOffButton.MouseButton1Click:Connect(function()
pcall(function()
local newState = not ESPSystem.enabled[espType]
ESPSystem.enabled[espType] = newState

if newState then
  onOffButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
  onOffButton.Text = "ON"
  activateESPForCategory(espType)
  showNotification("ESP " .. title .. " ON", 2)
else
  onOffButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
  onOffButton.Text = "OFF"
  deactivateESPForCategory(espType)
  showNotification("ESP " .. title .. " OFF", 2)
end
end)
end)

-- Dropdown functionality
local isExpanded = false
dropdownButton.MouseButton1Click:Connect(function()
pcall(function()
isExpanded = not isExpanded
selectionFrame.Visible = isExpanded
dropdownButton.Text = "Select Targets " .. (isExpanded and "▲" or "▼")
end)
end)

return container
end

-- ========== HITBOX UI CREATION FUNCTION ==========

local function createHitboxSection(parent)
local container = Instance.new("Frame")
container.Name = "HitboxContainer"
container.Size = UDim2.new(1, 0, 0, 50)
container.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
container.BorderSizePixel = 0
container.Parent = parent
container.AutomaticSize = Enum.AutomaticSize.Y
container.LayoutOrder = (#parent:GetChildren())

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 8)
containerCorner.Parent = container

-- Header section
local headerFrame = Instance.new("Frame")
headerFrame.Name = "HeaderFrame"
headerFrame.Size = UDim2.new(1, 0, 0, 50)
headerFrame.BackgroundTransparency = 1
headerFrame.Parent = container

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0.4, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Hitbox"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = headerFrame

-- ON/OFF Button
local onOffButton = Instance.new("TextButton")
onOffButton.Name = "OnOffButton"
onOffButton.Size = UDim2.new(0.2, -5, 0.6, 0)
onOffButton.Position = UDim2.new(0.4, 0, 0.2, 0)
onOffButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
onOffButton.Text = "OFF"
onOffButton.TextColor3 = Color3.fromRGB(255, 255, 255)
onOffButton.Font = Enum.Font.GothamBold
onOffButton.TextSize = 14
onOffButton.Parent = headerFrame

local onOffCorner = Instance.new("UICorner")
onOffCorner.CornerRadius = UDim.new(0, 6)
onOffCorner.Parent = onOffButton

-- Dropdown Button
local dropdownButton = Instance.new("TextButton")
dropdownButton.Name = "DropdownButton"
dropdownButton.Size = UDim2.new(0.35, -5, 0.6, 0)
dropdownButton.Position = UDim2.new(0.62, 0, 0.2, 0)
dropdownButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
dropdownButton.Text = "Choose Target ▼"
dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdownButton.Font = Enum.Font.Gotham
dropdownButton.TextSize = 12
dropdownButton.Parent = headerFrame

local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0, 6)
dropdownCorner.Parent = dropdownButton

-- Selection Frame
local selectionFrame = Instance.new("Frame")
selectionFrame.Name = "SelectionFrame"
selectionFrame.Size = UDim2.new(1, -20, 0, 0)
selectionFrame.Position = UDim2.new(0, 10, 0, 55)
selectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
selectionFrame.BorderSizePixel = 0
selectionFrame.Parent = container
selectionFrame.AutomaticSize = Enum.AutomaticSize.Y
selectionFrame.Visible = false

local selectionCorner = Instance.new("UICorner")
selectionCorner.CornerRadius = UDim.new(0, 6)
selectionCorner.Parent = selectionFrame

-- Layout for buttons
local targetLayout = Instance.new("UIListLayout")
targetLayout.Parent = selectionFrame
targetLayout.FillDirection = Enum.FillDirection.Vertical
targetLayout.SortOrder = Enum.SortOrder.LayoutOrder
targetLayout.Padding = UDim.new(0, 3)

-- Padding
pcall(function()
local targetPadding = Instance.new("UIPadding")
targetPadding.Parent = selectionFrame
targetPadding.PaddingAll = UDim.new(0, 8)
end)

-- Create target buttons
local targetButtons = {}
for i, targetName in ipairs(HitboxSystem.targets) do
  local targetButton = Instance.new("TextButton")
  targetButton.Name = targetName .. "Button"
  targetButton.Size = UDim2.new(1, 0, 0, 35)
  targetButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
  targetButton.Text = targetName
  targetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
  targetButton.Font = Enum.Font.Gotham
  targetButton.TextSize = 14
  targetButton.Parent = selectionFrame
  targetButton.LayoutOrder = i

  local targetCorner = Instance.new("UICorner")
  targetCorner.CornerRadius = UDim.new(0, 6)
  targetCorner.Parent = targetButton

  targetButtons[targetName] = targetButton

  -- Target selection logic
  targetButton.MouseButton1Click:Connect(function()
  pcall(function()
  -- Reset all buttons
  for _, btn in pairs(targetButtons) do
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = btn.Text:gsub(" ✓", "")
  end

  -- Highlight selected button
  targetButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
  targetButton.Text = targetName .. " ✓"

  -- Set selected target
  HitboxSystem.selectedTarget = targetName
  dropdownButton.Text = "Target: " .. targetName .. " ▼"

  print("✅ Hitbox: Selected " .. targetName)
  showNotification("Selected: " .. targetName, 1)

  -- Close dropdown
  selectionFrame.Visible = false
  dropdownButton.Text = dropdownButton.Text:gsub("▲", "▼")
  end)
  end)
end

-- ON/OFF functionality
onOffButton.MouseButton1Click:Connect(function()
pcall(function()
local newState = not HitboxSystem.enabled

if newState then
  onOffButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
  onOffButton.Text = "ON"
  toggleHitbox(true)
else
  onOffButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
  onOffButton.Text = "OFF"
  toggleHitbox(false)
end
end)
end)

-- Dropdown functionality
local isExpanded = false
dropdownButton.MouseButton1Click:Connect(function()
pcall(function()
isExpanded = not isExpanded
selectionFrame.Visible = isExpanded
dropdownButton.Text = dropdownButton.Text:gsub(isExpanded and "▼" or "▲", isExpanded and "▲" or "▼")
end)
end)

return container
end

-- ========== END HITBOX UI CREATION FUNCTION ==========

-- ========== INITIALIZATION ==========
-- Ganti spawn ESP updater yang lama dengan ini:
spawn(function()
while true do
wait(0.1)
pcall(updateESPSystem)
end
end)

-- ========== EXPORT UNTUK TESTING ==========
_G.ESPDebug = {
testESP = function(targetName)
ESPSystem.enabled.animals = true
ESPSystem.selected.animals[targetName or "Bunny"] = true
activateESPForCategory("animals")
print("🧪 ESP Test: Looking for " .. (targetName or "Bunny"))
end,

clearAllESP = function()
for espType, _ in pairs(ESPSystem.enabled) do
  ESPSystem.enabled[espType] = false
  deactivateESPForCategory(espType)
end
print("🧹 ESP: All cleared")
end
}

-- Create Main GUI dengan Animasi
local function createMainGui()
-- Destroy existing GUI if exists
if ClavnnXGui then
ClavnnXGui:Destroy()
end

-- Create ScreenGui
ClavnnXGui = Instance.new("ScreenGui")
ClavnnXGui.Name = "ClavnnXGui"
ClavnnXGui.Parent = PlayerGui
ClavnnXGui.ResetOnSpawn = false
ClavnnXGui.IgnoreGuiInset = true

-- Main Frame (mulai dari posisi tersembunyi)
MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ClavnnXGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 1 -- Mulai transparan
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.1, 0, -1, 0) -- Mulai dari atas layar
MainFrame.Size = UDim2.new(0.8, 0, 0.8, 0)
MainFrame.Active = true
MainFrame.Draggable = false

-- Corner radius for main frame
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = MainFrame

-- Header
local headerFrame = Instance.new("Frame")
headerFrame.Name = "HeaderFrame"
headerFrame.Parent = MainFrame
headerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
headerFrame.BackgroundTransparency = 1 -- Mulai transparan
headerFrame.BorderSizePixel = 0
headerFrame.Size = UDim2.new(1, 0, 0.1, 0)

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = headerFrame

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = headerFrame
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0.02, 0, 0, 0)
titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "ClavnnX"
titleLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
titleLabel.TextScaled = true
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextTransparency = 1 -- Mulai transparan

-- User info
local userLabel = Instance.new("TextLabel")
userLabel.Name = "UserLabel"
userLabel.Parent = headerFrame
userLabel.BackgroundTransparency = 1
userLabel.Position = UDim2.new(0.6, 0, 0, 0)
userLabel.Size = UDim2.new(0.3, 0, 1, 0)
userLabel.Font = Enum.Font.Gotham
userLabel.Text = "Hi, " .. Player.Name
userLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
userLabel.TextScaled = true
userLabel.TextXAlignment = Enum.TextXAlignment.Right
userLabel.TextTransparency = 1 -- Mulai transparan

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = headerFrame
closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeButton.BackgroundTransparency = 1 -- Mulai transparan
closeButton.BorderSizePixel = 0
closeButton.Position = UDim2.new(0.92, 0, 0.15, 0)
closeButton.Size = UDim2.new(0.06, 0, 0.7, 0)
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.TextTransparency = 1 -- Mulai transparan

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(
function()
toggleGui()
end
)

-- Tab Bar
local tabFrame = Instance.new("Frame")
tabFrame.Name = "TabFrame"
tabFrame.Parent = MainFrame
tabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
tabFrame.BackgroundTransparency = 1 -- Mulai transparan
tabFrame.BorderSizePixel = 0
tabFrame.Position = UDim2.new(0, 0, 0.1, 0)
tabFrame.Size = UDim2.new(1, 0, 0.08, 0)

local tabLayout = Instance.new("UIListLayout")
tabLayout.Parent = tabFrame
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 2)

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Parent = MainFrame
contentFrame.BackgroundTransparency = 1
contentFrame.Position = UDim2.new(0, 0, 0.18, 0)
contentFrame.Size = UDim2.new(1, 0, 0.82, 0)

-- ✨ ANIMASI STARTUP SMOOTH
spawn(
function()
wait(0.1) -- Delay sedikit

-- Animasi slide in dari atas + fade in
local slideIn =
TweenService:Create(
MainFrame,
TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
{
  Position = UDim2.new(0.1, 0, 0.1, 0),
  BackgroundTransparency = 0.3
}
)

-- Animasi fade in untuk header
local headerFadeIn =
TweenService:Create(
headerFrame,
TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.3),
{BackgroundTransparency = 0.3}
)

-- Animasi fade in untuk tab frame
local tabFadeIn =
TweenService:Create(
tabFrame,
TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.4),
{BackgroundTransparency = 0}
)

-- Animasi text fade in
local titleFadeIn =
TweenService:Create(
titleLabel,
TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.5),
{TextTransparency = 0}
)

local userFadeIn =
TweenService:Create(
userLabel,
TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.6),
{TextTransparency = 0}
)

local closeFadeIn =
TweenService:Create(
closeButton,
TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.7),
{
  BackgroundTransparency = 0,
  TextTransparency = 0
}
)

-- Play semua animasi
slideIn:Play()
headerFadeIn:Play()
tabFadeIn:Play()
titleFadeIn:Play()
userFadeIn:Play()
closeFadeIn:Play()

-- Efek bounce kecil di akhir
slideIn.Completed:Connect(
function()
  local bounce =
  TweenService:Create(
  MainFrame,
  TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
  {Size = UDim2.new(0.82, 0, 0.82, 0)}
  )
  bounce:Play()

  bounce.Completed:Connect(
  function()
    local bounceBack =
    TweenService:Create(
    MainFrame,
    TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size = UDim2.new(0.8, 0, 0.8, 0)}
    )
    bounceBack:Play()
  end
  )
end
)
end
)

return MainFrame, tabFrame, contentFrame
end
-- Create Tab Button (Updated untuk 6 tabs)
local function createTabButton(parent, text, layoutOrder)
local button = Instance.new("TextButton")
button.Name = text .. "Tab"
button.Parent = parent
button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button.BorderSizePixel = 0
button.LayoutOrder = layoutOrder
button.Size = UDim2.new(0.155, 0, 1, 0) -- Dikurangi untuk 6 tabs
button.Font = Enum.Font.Gotham
button.Text = text
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = button

return button
end
-- Create Toggle Button
local function createToggleButton(parent, text, position, size, callback)
local button = Instance.new("TextButton")
button.Name = text .. "Toggle"
button.Parent = parent
button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
button.BorderSizePixel = 0
button.Position = position
button.Size = UDim2.new(1, 0, 0.06, 0)
button.Font = Enum.Font.Gotham
button.Text = text .. " ❌"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = false
button.TextSize = 16

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = button

local isToggled = false
button.MouseButton1Click:Connect(
function()
isToggled = not isToggled
button.BackgroundColor3 = isToggled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 60)
button.Text = text .. (isToggled and " ✅" or " ❌")
if callback then
  callback(isToggled)
end
end
)

return button
end
-- Create Slider
local function createSlider(parent, text, position, size, minValue, maxValue, defaultValue, callback)
local frame = Instance.new("Frame")
frame.Name = text .. "Slider"
frame.Parent = parent
frame.BackgroundTransparency = 1
frame.Position = position
frame.Size = size
local label = Instance.new("TextLabel")
label.Name = "Label"
label.Parent = frame
label.BackgroundTransparency = 1
label.Position = UDim2.new(0, 0, 0, 0)
label.Size = UDim2.new(1, -10, 0, 20)
label.Font = Enum.Font.GothamBold
label.Text = text .. ": " .. defaultValue
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextScaled = false
label.TextSize = 16
label.TextXAlignment = Enum.TextXAlignment.Left
local sliderFrame = Instance.new("Frame")
sliderFrame.Name = "SliderFrame"
sliderFrame.Parent = frame
sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sliderFrame.BorderSizePixel = 0
sliderFrame.Position = UDim2.new(0, 0, 0, 20)
sliderFrame.Size = UDim2.new(1, 0, 0.4, 0)
local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 6)
sliderCorner.Parent = sliderFrame
local sliderButton = Instance.new("TextButton")
sliderButton.Name = "SliderButton"
sliderButton.Parent = sliderFrame
sliderButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
sliderButton.BorderSizePixel = 0
sliderButton.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 0, 0)
sliderButton.Size = UDim2.new(0.1, 0, 1, 0)
sliderButton.Text = ""
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = sliderButton
local dragging = false
local UserInputService = game:GetService("UserInputService")
sliderButton.InputBegan:Connect(
function(input)
if input.UserInputType == Enum.UserInputType.Touch then
  dragging = true
end
end
)
UserInputService.InputEnded:Connect(
function(input)
if input.UserInputType == Enum.UserInputType.Touch then
  dragging = false
end
end
)
UserInputService.InputChanged:Connect(
function(input)
if dragging and input.UserInputType == Enum.UserInputType.Touch then
  local absSize = sliderFrame.AbsoluteSize.X
  local relX = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / absSize, 0, 1)
  local value = math.floor((relX * (maxValue - minValue)) + minValue + 0.5)
  sliderButton.Position = UDim2.new((value - minValue) / (maxValue - minValue), 0, 0, 0)
  label.Text = text .. ": " .. tostring(value)
  callback(value)
end
end
)
return frame
end
-- Create Listbox
local function createListbox(parent, text, position, size, items, callback)
local frame = Instance.new("Frame")
frame.Name = text .. "Listbox"
frame.Parent = parent
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Position = position
frame.Size = size

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local label = Instance.new("TextLabel")
label.Name = "Label"
label.Parent = frame
label.BackgroundTransparency = 1
label.Position = UDim2.new(0, 5, 0, 0)
label.Size = UDim2.new(1, -10, 0.2, 0)
label.Font = Enum.Font.GothamBold
label.Text = text
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextScaled = true
label.TextXAlignment = Enum.TextXAlignment.Left

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Parent = frame
scrollFrame.BackgroundTransparency = 1
scrollFrame.Position = UDim2.new(0, 5, 0.2, 0)
scrollFrame.Size = UDim2.new(1, -10, 0.8, 0)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #items * 30)
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)

local layout = Instance.new("UIListLayout")
layout.Parent = scrollFrame
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 2)

for i, item in ipairs(items) do
local itemButton = Instance.new("TextButton")
itemButton.Name = "Item" .. i
itemButton.Parent = scrollFrame
itemButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
itemButton.BorderSizePixel = 0
itemButton.Size = UDim2.new(1, 0, 0, 25)
itemButton.Font = Enum.Font.Gotham
itemButton.Text = item
itemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
itemButton.TextScaled = true

local itemCorner = Instance.new("UICorner")
itemCorner.CornerRadius = UDim.new(0, 4)
itemCorner.Parent = itemButton

itemButton.MouseButton1Click:Connect(
function()
  if callback then
    callback(item)
  end
end
)
end

return frame
end
-- Typewriter Effect
local function typewriterEffect(textLabel, text, speed)
textLabel.Text = ""
for i = 1, #text do
textLabel.Text = string.sub(text, 1, i)
wait(speed or 0.05)
end
end
-- Show notification
local function showNotification(text, duration)
local notification = Instance.new("Frame")
notification.Name = "Notification"
notification.Parent = ClavnnXGui
notification.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
notification.BorderSizePixel = 0
notification.Position = UDim2.new(0.5, -150, 0, -50)
notification.Size = UDim2.new(0, 300, 0, 40)

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 8)
notifCorner.Parent = notification

local notifLabel = Instance.new("TextLabel")
notifLabel.Name = "NotifLabel"
notifLabel.Parent = notification
notifLabel.BackgroundTransparency = 1
notifLabel.Size = UDim2.new(1, 0, 1, 0)
notifLabel.Font = Enum.Font.Gotham
notifLabel.Text = text
notifLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
notifLabel.TextScaled = true

-- Animate in
local tweenIn = TweenService:Create(notification, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 0.05, 0)})
tweenIn:Play()

-- Animate out after duration
wait(duration or 3)
local tweenOut = TweenService:Create(notification, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 0, -50)})
tweenOut:Play()
tweenOut.Completed:Connect(
function()
notification:Destroy()
end
)
end
-- Feature Functions
local function toggleFly(enabled)
features.fly = enabled

if enabled then
if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
  local hrp = Player.Character.HumanoidRootPart
  if not hrp:FindFirstChild("BodyVelocity") then
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = hrp
  end
end
showNotification("Fly activated!", 2)
else
if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
  local bodyVelocity = Player.Character.HumanoidRootPart:FindFirstChild("BodyVelocity")
  if bodyVelocity then
    bodyVelocity:Destroy()
  end
end
showNotification("Fly deactivated!", 2)
end
end
local function toggleNoclip(enabled)
features.noclip = enabled
if enabled then
local function noclipLoop()
  if features.noclip and Player.Character then
    for _, part in pairs(Player.Character:GetChildren()) do
      if part:IsA("BasePart") then
        part.CanCollide = false
      end
    end
  end
end
RunService.Stepped:Connect(noclipLoop)
showNotification("Noclip activated!", 2)
else
if Player.Character then
  for _, part in pairs(Player.Character:GetChildren()) do
    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
      part.CanCollide = true
    end
  end
end
showNotification("Noclip deactivated!", 2)
end
end
local function toggleSpeed(enabled)
features.speed = enabled

if enabled then
showNotification("Speed Hack ON: " .. settings.walkSpeed, 2)
else
if Player.Character and Player.Character:FindFirstChild("Humanoid") then
  Player.Character.Humanoid.WalkSpeed = 16
end
showNotification("Speed Hack OFF", 2)
end
end
-- Infinite Jump Toggle
local function toggleJump(enabled)
features.infiniteJump = enabled
if enabled then
infiniteJumpConnection =
game:GetService("UserInputService").JumpRequest:Connect(
function()
  local player = game.Players.LocalPlayer
  if player.Character and player.Character:FindFirstChild("Humanoid") then
    player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
  end
end
)
else
if infiniteJumpConnection then
  infiniteJumpConnection:Disconnect()
  infiniteJumpConnection = nil
end
end
showNotification("Infinite Jump " .. (enabled and "enabled" or "disabled"), 2)
end
local isTraveling = false -- Variabel untuk mencegah fitur dijalankan dua kali bersamaan
-- Fungsi PENCARIAN BARU yang mencari karakter berdasarkan KidId
local function findCharacterByKidId(kidId)
for _, obj in ipairs(game:GetService("Workspace"):GetChildren()) do
-- Pastikan objeknya adalah karakter (punya Humanoid)
if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
  -- Cek apakah punya properti KidId
  local idObject = obj:FindFirstChild("KidId")
  if idObject and idObject:isA("StringValue") and idObject.Value == kidId then
    return obj -- Kembalikan model karakter jika KidId cocok
  end
end
end
return nil -- Kembalikan nil jika tidak ditemukan
end
-- ===================================================================
-- KODE FINAL v2 (Dengan Pencarian Attribute + StringValue)
-- ===================================================================
local isTraveling = false -- Variabel untuk mencegah fitur dijalankan dua kali bersamaan
-- Fungsi PENCARIAN BARU yang mencari KidId sebagai Attribute ATAU StringValue
local function findCharacterByKidId(kidId)
for _, obj in ipairs(game:GetService("Workspace"):GetChildren()) do
if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
  -- Metode 1: Cek sebagai 'Attribute' (cara modern)
  local attributeValue = obj:GetAttribute("KidId")
  if attributeValue and attributeValue == kidId then
    return obj
  end
  -- Metode 2: Cek sebagai 'StringValue' (cara lama)
  local idObject = obj:FindFirstChild("KidId")
  if idObject and idObject:isA("StringValue") and idObject.Value == kidId then
    return obj
  end
end
end
return nil
end
-- ===================================================================
-- KODE FINAL v3 (Pencarian Canggih + Perjalanan Aman)
-- ===================================================================
local isTraveling = false -- Variabel untuk mencegah fitur dijalankan dua kali bersamaan
-- Fungsi PENCARIAN BARU (terinspirasi dari skrip yang kamu temukan)
local function findCharacterByName(nameToFind)
for _, obj in ipairs(game:GetService("Workspace"):GetDescendants()) do
-- Cari objek yang namanya mengandung nama target, dan punya Humanoid
if obj.Name:lower():find(nameToFind:lower()) and obj:FindFirstChild("HumanoidRootPart") then
  return obj -- Kembalikan model karakter jika cocok
end
end
return nil -- Kembalikan nil jika tidak ditemukan
end
-- Check if player has Axe (FIXED: Check in Inventory folder)
local function hasAxe()
-- Get Inventory folder
local Inventory = Player:FindFirstChild("Inventory")
if not Inventory then
return false, nil
end

-- Check for axe models in Inventory
for _, item in pairs(Inventory:GetChildren()) do
if item:IsA("Model") then
  -- Check by name
  if item.Name == "Old Axe" or item.Name == "Good Axe" or item.Name == "Strong Axe" then
    return true, item
  end

  -- Also check ToolName attribute
  local toolName = item:GetAttribute("ToolName")
  if toolName and (toolName:find("Axe") or toolName == "GenericAxe") then
    return true, item
  end
end
end

-- Also check if equipped in character
if Player.Character then
for _, item in pairs(Player.Character:GetChildren()) do
  if item:IsA("Tool") and (item.Name:find("Axe") or item.Name:find("axe")) then
    return true, item
  end
end
end

return false, nil
end

-- Get entity ID
local function getEntityId(entity)
-- Based on Owner attribute pattern
return "1130340392" -- From screenshot
end
local function toggleKillAura(enabled)
features.killAura = enabled
KillAuraEnabled = enabled

if enabled then
-- Initialize RemoteEvents if not already
if not RemoteEvents then
  pcall(
  function()
    RemoteEvents = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 5)
  end
  )
end

if not RemoteEvents then
  showNotification("Kill Aura: RemoteEvents not found!", 3)
  features.killAura = false
  KillAuraEnabled = false
  return
end

-- Check for axe first
local hasAxeItem = hasAxe()
if not hasAxeItem then
  features.killAura = false
  KillAuraEnabled = false
  showNotification("Kill Aura: No Axe in Inventory!", 3)
  return
end

-- Start kill aura
local ToolDamageObject = RemoteEvents:FindFirstChild("ToolDamageObject")
local DamagePlayer = RemoteEvents:FindFirstChild("DamagePlayer")

if ToolDamageObject then
  print("Using remote:", ToolDamageObject:GetFullName())
end

KillAuraConnection =
RunService.Heartbeat:Connect(
function()
  if not KillAuraEnabled or not features.killAura then
    return
  end

  -- Update character references
  local Character = Player.Character
  if not Character then
    return
  end

  local RootPart = Character:FindFirstChild("HumanoidRootPart")
  if not RootPart then
    return
  end

  -- Check if has axe
  local hasAxeItem, axeTool = hasAxe()
  if not hasAxeItem then
    return
  end

  -- Find targets in Characters folder
  local charactersFolder = workspace:FindFirstChild("Characters")
  if not charactersFolder then
    return
  end

  local targets = {}

  for _, obj in pairs(charactersFolder:GetChildren()) do
    if obj:IsA("Model") and obj ~= Character and ValidTargets[obj.Name] then
      local humanoid = obj:FindFirstChildOfClass("Humanoid")
      local rootPart = obj:FindFirstChild("HumanoidRootPart")

      if humanoid and rootPart and humanoid.Health > 0 then
        local distance = (RootPart.Position - rootPart.Position).Magnitude

        if distance <= settings.killAuraRadius then
          table.insert(
          targets,
          {
            model = obj,
            humanoid = humanoid,
            rootPart = rootPart,
            distance = distance,
            name = obj.Name
          }
          )
        end
      end
    end
  end

  -- Sort by distance
  table.sort(
  targets,
  function(a, b)
    return a.distance < b.distance
  end
  )

  -- Attack targets
  local attacked = 0

  for _, target in pairs(targets) do
    local currentTime = tick()
    local lastAttack = LastAttackTime[target.model] or 0

    -- Use cooldown from axe attributes
    local cooldown = axeTool:GetAttribute("ToolCooldown") or 0.5

    if currentTime - lastAttack >= cooldown then
      LastAttackTime[target.model] = currentTime

      -- Face target
      local lookDirection = (target.rootPart.Position - RootPart.Position).Unit
      RootPart.CFrame =
      CFrame.lookAt(RootPart.Position, RootPart.Position + lookDirection * Vector3.new(1, 0, 1))

      -- Try to attack
      if ToolDamageObject then
        pcall(
        function()
          -- Method 1: With all parameters
          ToolDamageObject:InvokeServer(
          target.model, -- Target entity
          axeTool, -- Weapon from inventory
          getEntityId(target), -- Entity ID
          RootPart.CFrame -- Attack position
          )
        end
        )

        -- Method 2: Simple call
        pcall(
        function()
          ToolDamageObject:InvokeServer(target.model)
        end
        )
      end

      -- Try DamagePlayer remote as backup
      if DamagePlayer then
        pcall(
        function()
          DamagePlayer:FireServer(target.model, axeTool:GetAttribute("WeaponDamage") or 7)
        end
        )
      end

      attacked = attacked + 1

      -- Check if target died
      task.spawn(
      function()
        local oldHealth = target.humanoid.Health
        task.wait(0.2)

        if target.humanoid.Health <= 0 or target.humanoid.Health < oldHealth then
          -- Update kill counter
          local normalizedName = target.name
          if targetKills[normalizedName] then
            targetKills[normalizedName] = targetKills[normalizedName] + 1
          end

          killCount = killCount + 1
        end
      end
      )
    end
  end
end
)

showNotification("Kill Aura enabled!", 2)
else
if KillAuraConnection then
  KillAuraConnection:Disconnect()
  KillAuraConnection = nil
end
showNotification("Kill Aura disabled!", 2)
end
end
-- ========== AUTO FARM FUNCTIONS ==========

-- Check if player has Axe for farming (simpler version)
local function hasAxeForFarm()
local Inventory = Player:FindFirstChild("Inventory")
if not Inventory then
return false, nil
end

for _, item in pairs(Inventory:GetChildren()) do
if item:IsA("Model") and (item.Name:find("Axe") or item.Name:find("axe")) then
  return true, item
end
end

if Player.Character then
for _, item in pairs(Player.Character:GetChildren()) do
  if item:IsA("Tool") and (item.Name:find("Axe") or item.Name:find("axe")) then
    return true, item
  end
end
end

return false, nil
end

-- Find ALL trees within range
local function findAllTreesInRange()
local trees = {}
local Character = Player.Character
if not Character or not Character:FindFirstChild("HumanoidRootPart") then
return trees
end

local RootPart = Character.HumanoidRootPart

for _, obj in pairs(workspace:GetDescendants()) do
if obj:IsA("Model") and obj.Parent and not ProcessedTrees[obj] then
  local name = obj.Name
  if name:lower():find("tree") or ValidTrees[name] then
    local trunk =
    obj:FindFirstChild("Trunk") or obj:FindFirstChild("Wood") or obj:FindFirstChild("Log") or
    obj:FindFirstChild("TreePart")

    if not trunk then
      for _, part in pairs(obj:GetChildren()) do
        if part:IsA("BasePart") then
          trunk = part
          break
        end
      end
    end

    if trunk and trunk:IsA("BasePart") then
      local distance = (RootPart.Position - trunk.Position).Magnitude

      if distance <= MAX_FARM_RANGE then
        table.insert(
        trees,
        {
          model = obj,
          trunk = trunk,
          name = name,
          distance = distance
        }
        )
      end
    end
  end
end
end

return trees
end

-- Attack single tree (async)
local function attackTreeAsync(tree, axeTool, rootPart)
task.spawn(
function()
for i = 1, MULTI_ATTACK do
  if not tree.model.Parent then
    break
  end

  pcall(
  function()
    RemoteEvents:WaitForChild("ToolDamageObject"):InvokeServer(
    tree.model,
    axeTool,
    "1130340392",
    rootPart.CFrame
    )
  end
  )

  FarmAttackCount = FarmAttackCount + 1
  task.wait(0.05)
end

-- Check if chopped after attacks
task.wait(0.5)
if not tree.model.Parent then
  TreesChopped = TreesChopped + 1
  ProcessedTrees[tree.model] = true
  showNotification("✅ Chopped: " .. tree.name, 1)
end
end
)
end

-- Attack ALL trees at once
local function attackAllTreesSimultaneously(trees, axeTool, rootPart)
-- Face center of all trees
if #trees > 0 then
local centerPos = Vector3.new(0, 0, 0)
for _, tree in ipairs(trees) do
  centerPos = centerPos + tree.trunk.Position
end
centerPos = centerPos / #trees

local lookDir = (centerPos - rootPart.Position).Unit
rootPart.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + lookDir * Vector3.new(1, 0, 1))
end

-- Attack all trees at once
for _, tree in ipairs(trees) do
attackTreeAsync(tree, axeTool, rootPart)
end
end

-- Main Auto Farm Toggle
local function toggleAutoFarm(enabled)
features.autoFarm = enabled
AutoFarmEnabled = enabled

if enabled then
-- Initialize RemoteEvents if not already
if not RemoteEvents then
  pcall(
  function()
    RemoteEvents = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents", 5)
  end
  )
end

if not RemoteEvents then
  showNotification("Auto Farm: RemoteEvents not found!", 3)
  features.autoFarm = false
  AutoFarmEnabled = false
  return
end

-- Check for axe
local hasAxeItem = hasAxeForFarm()
if not hasAxeItem then
  features.autoFarm = false
  AutoFarmEnabled = false
  showNotification("Auto Farm: No Axe in Inventory!", 3)
  return
end

ProcessedTrees = {} -- Reset processed trees
showNotification("Auto Farm Started! (1000 studs range)", 2)

-- Start farming
local lastAttackTime = 0

AutoFarmConnection =
RunService.Heartbeat:Connect(
function()
  if not AutoFarmEnabled then
    return
  end

  -- Attack cycle delay
  if tick() - lastAttackTime < FARM_ATTACK_DELAY then
    return
  end

  local Character = Player.Character
  if not Character then
    return
  end

  local RootPart = Character:FindFirstChild("HumanoidRootPart")
  if not RootPart then
    return
  end

  local hasAxeItem, axeTool = hasAxeForFarm()
  if not hasAxeItem then
    showNotification("Auto Farm: No axe found!", 2)
    return
  end

  -- Find ALL trees in range
  local trees = findAllTreesInRange()
  CurrentTargets = trees

  if #trees == 0 then
    ProcessedTrees = {} -- Reset if no trees
    return
  end

  -- ATTACK ALL TREES AT ONCE!
  attackAllTreesSimultaneously(trees, axeTool, RootPart)
  lastAttackTime = tick()
end
)
else
if AutoFarmConnection then
  AutoFarmConnection:Disconnect()
  AutoFarmConnection = nil
end
CurrentTargets = {}
showNotification("Auto Farm stopped!", 2)
end
end
-- Auto Farm Info (OPTIONAL)
local farmInfoLabel = Instance.new("TextLabel")
farmInfoLabel.Name = "FarmInfoLabel"
farmInfoLabel.Size = UDim2.new(1, 0, 0.05, 0)
farmInfoLabel.BackgroundTransparency = 1
farmInfoLabel.Text = "🌳 Trees: 0 | ✅ Chopped: 0"
farmInfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
farmInfoLabel.TextSize = 14
farmInfoLabel.Font = Enum.Font.Gotham
farmInfoLabel.TextXAlignment = Enum.TextXAlignment.Center
farmInfoLabel.Parent = rightFrame

-- Update farm info periodically
spawn(
function()
while true do
wait(1)
if farmInfoLabel and farmInfoLabel.Parent then
  local treeCount = #CurrentTargets
  farmInfoLabel.Text = string.format("🌳 Trees: %d | ✅ Chopped: %d", treeCount, TreesChopped)
end
end
end
)
-- Fungsi TELEPORTASI UTAMA
local function teleportToLocation(location)
local player = game:GetService("Players").LocalPlayer
local playerCharacter = player.Character
if not playerCharacter or not playerCharacter:FindFirstChild("HumanoidRootPart") then
showNotification("Character not found!", 2)
return
end

-- Logika khusus untuk Camp
if location == "Camp" then
playerCharacter:SetPrimaryPartCFrame(CFrame.new(0, 50, 0))
showNotification("Teleported to Camp", 2)
return
end

-- Peta nama tombol ke NAMA OBJEK
local targetNames = {
["Child 1"] = "Lost Child",
["Child 2"] = "Lost Child2",
["Child 3"] = "Lost Child3",
["Child 4"] = "Lost Child4"
}

local targetName = targetNames[location]
if not targetName then
return
end

-- Gunakan fungsi pencarian canggih kita
local targetObject = findCharacterByName(targetName)

if not targetObject then
showNotification("Failed to get " .. location .. "! (Lostchild hasn't spawned yet)", 3)
return
end

-- Aksi Teleportasi Langsung
showNotification("Starting teleport to " .. location, 2)
local targetCFrame = targetObject.HumanoidRootPart.CFrame
playerCharacter:SetPrimaryPartCFrame(targetCFrame * CFrame.new(0, 3, 0))
end
-- Fungsi TELEPORT TO PLAYER
local function teleportToPlayer(targetPlayerName)
local player = game:GetService("Players").LocalPlayer
local playerCharacter = player.Character
if not playerCharacter or not playerCharacter:FindFirstChild("HumanoidRootPart") then
showNotification("Character not found!", 2)
return
end

-- Cari target player berdasarkan nama
local targetPlayer = nil
for _, p in pairs(game:GetService("Players"):GetPlayers()) do
if p.Name == targetPlayerName and p ~= player then
  targetPlayer = p
  break
end
end

if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
showNotification("Player " .. targetPlayerName .. " not found!", 2)
return
end

-- Teleport ke posisi player dengan offset
showNotification("Teleporting to " .. targetPlayerName .. "...", 2)
local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
local teleportPosition = targetPosition + Vector3.new(0, 3, 0)
playerCharacter:SetPrimaryPartCFrame(CFrame.new(teleportPosition))

wait(0.5)
showNotification("Teleported to " .. targetPlayerName, 2)
end

-- Fungsi untuk mendapatkan daftar player (kecuali diri sendiri)
local function getPlayerList()
local players = {}
for _, player in pairs(game:GetService("Players"):GetPlayers()) do
if player ~= Player then
  table.insert(players, player.Name)
end
end
return players
end
-- Tambahkan fungsi ini sebelum bringItem
local function enableItemPickup(item)
pcall(
function()
-- Enable all interaction properties
if item:IsA("BasePart") then
  item.CanCollide = true
  item.CanTouch = true
  item.CanQuery = true
  item.Anchored = false
end

-- Find and enable ProximityPrompt
for _, obj in pairs(item:GetDescendants()) do
  if obj:IsA("ProximityPrompt") then
    obj.Enabled = true
    obj.MaxActivationDistance = 20
    obj.RequiresLineOfSight = false
    obj.HoldDuration = 0
  elseif obj:IsA("ClickDetector") then
    obj.MaxActivationDistance = 20
  elseif obj:IsA("BasePart") then
    obj.CanCollide = true
    obj.CanTouch = true
    obj.CanQuery = true
    obj.Anchored = false
  end
end
end
)
end
-- Tambah di atas fungsi bringItem
local function findPickupRemote()
local remotes = {}

-- Check ReplicatedStorage
pcall(
function()
local rs = game:GetService("ReplicatedStorage")
for _, obj in pairs(rs:GetDescendants()) do
  if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
    local name = obj.Name:lower()
    if name:find("pick") or name:find("drop") or name:find("item") or name:find("collect") then
      table.insert(remotes, obj)
      print("Found remote:", obj:GetFullName())
    end
  end
end
end
)

return remotes
end
-- Tambah setelah findPickupRemote
local function tryPickupItem(item)
-- Find pickup remotes
local remotes = findPickupRemote()

for _, remote in ipairs(remotes) do
pcall(
function()
  if remote:IsA("RemoteEvent") then
    remote:FireServer(item)
    remote:FireServer("Pickup", item)
    remote:FireServer(item, "Pickup")
  elseif remote:IsA("RemoteFunction") then
    remote:InvokeServer(item)
    remote:InvokeServer("Pickup", item)
  end
end
)
end
end
local function bringItem(item)
if not item or not item.Parent then
return false
end
local character = game.Players.LocalPlayer.Character
if not character or not character:FindFirstChild("HumanoidRootPart") then
return false
end
local hrp = character.HumanoidRootPart

-- Enable pickup first
enableItemPickup(item)

-- Teleport item
pcall(
function()
item.Parent = workspace
wait()

local newPos = hrp.Position + Vector3.new(0, 2, 2)

if item:IsA("Model") then
  item:MoveTo(newPos)
elseif item:IsA("BasePart") then
  item.CFrame = CFrame.new(newPos)
elseif item:IsA("Tool") and item:FindFirstChild("Handle") then
  item.Handle.CFrame = CFrame.new(newPos)
end
end
)

wait(0.2)

-- Try game's pickup system
tryPickupItem(item)

-- Try touch interest
pcall(
function()
local part = item:IsA("Model") and item.PrimaryPart or item
if part then
  firetouchinterest(hrp, part, 0)
  wait()
  firetouchinterest(hrp, part, 1)
end
end
)

return true
end
function bringAllItems(itemName)
local foundItems = findItemBetter(itemName)

local totalFound = #foundItems
print("🔍 Found", totalFound, itemName)

if totalFound == 0 then
showNotification("No " .. itemName .. " found!", 2)
return false
end

showNotification("Bringing " .. totalFound .. " " .. itemName .. "...", 2)

local successCount = 0

-- Bring all items
for j = 1, totalFound do
if not isBringingItems then
  break
end

-- Simple bring
local item = foundItems[j]
if item and item.Parent then
  bringItem(item)
  successCount = successCount + 1
end

wait(0.1) -- Small delay between items
end

showNotification("Brought " .. successCount .. " items", 2)
return successCount > 0
end

-- ========== TELEPORT TO ITEM FUNCTIONS ==========
local isTeleportingToItem = false
_G.selectedTeleportItemName = nil
_G.selectedTeleportItemButton = nil

-- Fungsi untuk mencari item pertama yang cocok untuk teleport (FIXED VERSION)
local function findFirstItemForTeleport(itemName)
    if not itemName or itemName == "" then
        print("❌ Invalid item name provided")
        return nil
    end

    local items = workspace:FindFirstChild("Items")
    if not items then
        print("❌ Items folder not found in Workspace")
        return nil
    end

    -- Scan direct children dari Items folder dengan error handling
    for _, item in pairs(items:GetChildren()) do
        pcall(function()
            if item and item.Parent and item.Name == itemName then
                local position = nil
                
                if item:IsA("Model") then
                    -- Method 1: GetPivot (modern way)
                    local success, pivot = pcall(function()
                        return item:GetPivot()
                    end)
                    if success and pivot then
                        position = pivot.Position
                    elseif item.PrimaryPart then
                        position = item.PrimaryPart.Position
                    else
                        -- Find first BasePart
                        for _, part in pairs(item:GetChildren()) do
                            if part:IsA("BasePart") then
                                position = part.Position
                                break
                            end
                        end
                    end
                elseif item:IsA("BasePart") then
                    position = item.Position
                elseif item:IsA("Tool") and item:FindFirstChild("Handle") then
                    position = item.Handle.Position
                end

                if position then
                    return {
                        object = item,
                        position = position,
                        name = item.Name
                    }
                end
            end
        end)
    end

    print("❌ No valid " .. tostring(itemName) .. " found for teleport")
    return nil
end
-- Fungsi utama teleport to item
function teleportToItem(itemName)
    if not itemName or itemName == "" then
        showNotification("No item selected!", 2)
        return false
    end

    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        showNotification("Character not found!", 2)
        return false
    end

    local hrp = character.HumanoidRootPart
    
    print("🔍 Looking for", itemName, "to teleport...")
    
    -- Cari item pertama yang cocok
    local itemData = findFirstItemForTeleport(itemName)
    
    if not itemData then
        showNotification("No " .. itemName .. " found!", 2)
        return false
    end

    -- Teleport ke posisi item dengan offset
    local teleportPosition = itemData.position + Vector3.new(0, 3, 2) -- Sedikit di atas dan di depan item
    
    pcall(function()
        hrp.CFrame = CFrame.new(teleportPosition)
    end)

    showNotification("Teleported to " .. itemName, 2)
    print("✅ Teleported to", itemName, "at position", itemData.position)
    return true
end

-- ========== CHEST SYSTEM FUNCTIONS ==========

-- Fungsi untuk mencari posisi chest
local function getChestPosition(chestObj)
if chestObj:IsA("Model") then
local success, pivot = pcall(function()
return chestObj:GetPivot()
end)
if success and pivot then
  return pivot.Position
end

if chestObj.PrimaryPart then
  return chestObj.PrimaryPart.Position
end

local part = chestObj:FindFirstChildOfClass("Part") or chestObj:FindFirstChildOfClass("MeshPart")
if part then
  return part.Position
end
elseif chestObj:IsA("BasePart") then
return chestObj.Position
end

local chestLid = chestObj:FindFirstChild("ChestLid", true)
if chestLid then
return getChestPosition(chestLid)
end

return nil
end

-- Fungsi untuk mencari semua chest di game
local function findAllChests()
local chests = {}

-- Method 1: Look in Workspace.Items.Chest
if Workspace:FindFirstChild("Items") then
local items = Workspace.Items
if items:FindFirstChild("Chest") then
  for _, chest in pairs(items.Chest:GetChildren()) do
    local pos = getChestPosition(chest)
    if pos then
      table.insert(chests, {
        object = chest,
        position = pos,
        name = chest.Name
      })
    end
  end
end
end

-- Method 2: Look directly in Workspace.Items
if Workspace:FindFirstChild("Items") then
for _, item in pairs(Workspace.Items:GetChildren()) do
  if string.lower(item.Name):find("chest") then
    local pos = getChestPosition(item)
    if pos then
      table.insert(chests, {
        object = item,
        position = pos,
        name = item.Name
      })
    end
  end
end
end

-- Method 3: Scan workspace for chest objects
local function scanFolder(folder, depth)
if depth > 3 then return end

for _, item in pairs(folder:GetChildren()) do
  if string.lower(item.Name):find("chest") then
    local pos = getChestPosition(item)
    if pos then
      table.insert(chests, {
        object = item,
        position = pos,
        name = item.Name
      })
    end
  elseif item:IsA("Folder") or item:IsA("Model") then
    scanFolder(item, depth + 1)
  end
end
end

scanFolder(Workspace, 0)

-- Remove duplicates
local uniqueChests = {}
local positions = {}

for _, chest in pairs(chests) do
local posKey = string.format("%.1f,%.1f,%.1f", chest.position.X, chest.position.Y, chest.position.Z)
if not positions[posKey] then
  positions[posKey] = true
  table.insert(uniqueChests, chest)
end
end

return uniqueChests
end

-- Fungsi untuk teleport ke chest yang dipilih
local function teleportToSelectedChest()
if not ChestSystem.selectedChest then
showNotification("No chest selected!", 2)
return
end

local character = Player.Character
if not character or not character:FindFirstChild("HumanoidRootPart") then
showNotification("Character not found!", 2)
return
end

local targetPos = ChestSystem.selectedChest.position + Vector3.new(0, TELEPORT_Y_OFFSET, 0)
character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
showNotification("Teleported to " .. ChestSystem.selectedChest.name, 2)
end

-- Fungsi untuk mencoba membuka chest
local function tryOpenChest(chestData)
local now = tick()
local chestObj = chestData.object

if ChestSystem.openedChests[chestObj] and (now - ChestSystem.openedChests[chestObj]) < AUTO_OPEN_COOLDOWN then
return false
end

-- Method 1: ProximityPrompt
local prompt = chestObj:FindFirstChildOfClass("ProximityPrompt", true)
if prompt then
local success = pcall(function()
if fireproximityprompt then
  fireproximityprompt(prompt)
end
end)
if success then
  ChestSystem.openedChests[chestObj] = now
  return true
end
end

-- Method 2: ClickDetector
local detector = chestObj:FindFirstChildOfClass("ClickDetector", true)
if detector then
local success = pcall(function()
if fireclickdetector then
  fireclickdetector(detector)
end
end)
if success then
  ChestSystem.openedChests[chestObj] = now
  return true
end
end

-- Method 3: RemoteEvents
if RemoteEvents then
local remoteNames = {
  "RequestOpenItemChest",
  "OpenChest",
  "ChestOpen",
  "ItemChest",
  "OpenItemChest"
}

for _, remoteName in pairs(remoteNames) do
  local remote = RemoteEvents:FindFirstChild(remoteName)
  if remote and remote:IsA("RemoteEvent") then
    local success = pcall(function()
    remote:FireServer(chestObj)
    end)
    if success then
      ChestSystem.openedChests[chestObj] = now
      return true
    end
  end
end
end

return false
end

-- Fungsi untuk toggle auto open chest
local function toggleAutoOpenChest(enabled)
features.autoOpenChest = enabled
ChestSystem.autoOpenEnabled = enabled

if enabled then
-- Initialize RemoteEvents if needed
if not RemoteEvents then
  pcall(function()
  RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents", 5)
  end)
end

-- Initialize chest cache if needed
if #ChestSystem.chestCache == 0 then
  ChestSystem.chestCache = findAllChests()
end

ChestConnection = RunService.Heartbeat:Connect(function()
if not ChestSystem.autoOpenEnabled then return end

local character = Player.Character
if not character or not character:FindFirstChild("HumanoidRootPart") then return end

local playerPos = character.HumanoidRootPart.Position

for _, chestData in pairs(ChestSystem.chestCache) do
  pcall(function()
  if chestData.object and chestData.object.Parent then
    local distance = (playerPos - chestData.position).Magnitude
    if distance <= AUTO_OPEN_DISTANCE then
      -- Enhanced chest opening method
      local now = tick()
      if ChestSystem.openedChests[chestData.object] and
      (now - ChestSystem.openedChests[chestData.object]) < AUTO_OPEN_COOLDOWN then
        return
      end

      -- Method 1: ProximityPrompt
      local prompt = chestData.object:FindFirstChildOfClass("ProximityPrompt", true)
      if prompt then
        local success = pcall(function()
        if fireproximityprompt then
          fireproximityprompt(prompt)
        end
        end)
        if success then
          ChestSystem.openedChests[chestData.object] = now
          print("Opened chest via ProximityPrompt: " .. chestData.name)
          return
        end
      end

      -- Method 2: ClickDetector
      local detector = chestData.object:FindFirstChildOfClass("ClickDetector", true)
      if detector then
        local success = pcall(function()
        if fireclickdetector then
          fireclickdetector(detector)
        end
        end)
        if success then
          ChestSystem.openedChests[chestData.object] = now
          print("Opened chest via ClickDetector: " .. chestData.name)
          return
        end
      end

      -- Method 3: RemoteEvents
      if RemoteEvents then
        local remoteNames = {
          "RequestOpenItemChest",
          "OpenChest",
          "ChestOpen",
          "ItemChest",
          "OpenItemChest"
        }

        for _, remoteName in pairs(remoteNames) do
          local remote = RemoteEvents:FindFirstChild(remoteName)
          if remote and remote:IsA("RemoteEvent") then
            local success = pcall(function()
            remote:FireServer(chestData.object)
            end)
            if success then
              ChestSystem.openedChests[chestData.object] = now
              print("Opened chest via RemoteEvent (" .. remoteName .. "): " .. chestData.name)
              break
            end
          end
        end
      end
    end
  end
  end)
end
end)

showNotification("Auto Open Chest enabled!", 2)
else
if ChestConnection then
  ChestConnection:Disconnect()
  ChestConnection = nil
end
showNotification("Auto Open Chest disabled!", 2)
end
end
-- Persistent Feature Monitor
local function startPersistentMonitor()
spawn(
function()
while true do
  wait(0.1) -- Check every 0.1 second

  if
  Player.Character and Player.Character:FindFirstChild("Humanoid") and
  Player.Character:FindFirstChild("HumanoidRootPart")
  then
    local humanoid = Player.Character.Humanoid
    local hrp = Player.Character.HumanoidRootPart

    -- Monitor & Fix Speed
    if features.speed and humanoid.WalkSpeed ~= settings.walkSpeed then
      humanoid.WalkSpeed = settings.walkSpeed
    end

    -- Monitor & Fix Jump Power
    if settings.jumpPower > 50 and humanoid.JumpPower ~= settings.jumpPower then
      humanoid.UseJumpPower = true
      humanoid.JumpPower = settings.jumpPower
    end

    -- Monitor & Fix Fly
    if features.fly and not hrp:FindFirstChild("BodyVelocity") then
      local bodyVelocity = Instance.new("BodyVelocity")
      bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
      bodyVelocity.Velocity = Vector3.new(0, 0, 0)
      bodyVelocity.Parent = hrp
    end

    -- Monitor & Fix God Mode
    if features.godMode then
      if humanoid.MaxHealth ~= math.huge then
        humanoid.MaxHealth = math.huge
      end
      if humanoid.Health < humanoid.MaxHealth then
        humanoid.Health = humanoid.MaxHealth
      end
    end
    -- Monitor & Fix Clear Weather
    if features.clearWeather and workspace:GetAttribute("Weather") ~= "Clear" then
      setClearWeather()
    end

    -- Monitor & Fix No Fog
    if features.noFog then
      applyNoFog()
    end

    -- Monitor & Fix FPS Boost
    if features.fpsBoost then
      applyFPSOptimizations()
    end

    -- Monitor & Fix customFOV
    if features.customFOV and settings.fieldOfView then
      if Camera.FieldOfView ~= settings.fieldOfView then
        Camera.FieldOfView = settings.fieldOfView
      end
    end

    -- Monitor & Fix Hitbox
    if features.hitbox and HitboxSystem.enabled then
      -- Check if hitboxes are still valid
      for i = #HitboxSystem.activeHitboxes, 1, -1 do
        local hitboxData = HitboxSystem.activeHitboxes[i]
        if not hitboxData or not hitboxData.target or not hitboxData.target.hrp or not hitboxData.target.hrp.Parent then
          table.remove(HitboxSystem.activeHitboxes, i)
        end
      end
    end

    -- Monitor & Fix Night Vision
    if features.nightVision then
      applyNightVision()
    end

    -- Monitor & Fix Noclip
    if features.noclip then
      for _, part in pairs(Player.Character:GetChildren()) do
        if part:IsA("BasePart") and part.CanCollide then
          part.CanCollide = false
        end
      end
    end
  end
end
end
)
end

-- Detect revive/trap reset
local lastHealth = 100
local wasDeadOrDowned = false
local function detectRevive()
spawn(
function()
while true do
  wait(0.1)

  if Player.Character and Player.Character:FindFirstChild("Humanoid") then
    local humanoid = Player.Character.Humanoid
    local currentHealth = humanoid.Health

    -- Detect jika health drop drastis (trap) atau revive (health naik dari 0)
    if currentHealth > 0 and (wasDeadOrDowned or lastHealth <= 0) then
      wasDeadOrDowned = false
      wait(0.5) -- Wait for revive animation

      -- Force reapply all features
      if features.fly then
        local hrp = Player.Character.HumanoidRootPart
        if hrp and not hrp:FindFirstChild("BodyVelocity") then
          local bodyVelocity = Instance.new("BodyVelocity")
          bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
          bodyVelocity.Velocity = Vector3.new(0, 0, 0)
          bodyVelocity.Parent = hrp
        end
      end

      showNotification("Features restored after revive!", 2)
    elseif currentHealth <= 0 then
      wasDeadOrDowned = true
    end

    lastHealth = currentHealth
  end
end
end
)
end
-- Create Pages
local function createMainPage(parent)
local page = Instance.new("ScrollingFrame")
page.Name = "MainPage"
page.Parent = parent
page.Size = UDim2.new(1, 0, 1, 0)
page.BackgroundTransparency = 1
page.AutomaticCanvasSize = Enum.AutomaticSize.Y
page.Visible = false
page.ScrollBarThickness = 8
page.ScrollingDirection = Enum.ScrollingDirection.Y
page.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Tambahkan layout horizontal
local horizontalLayout = Instance.new("UIListLayout")
horizontalLayout.FillDirection = Enum.FillDirection.Horizontal
horizontalLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
horizontalLayout.SortOrder = Enum.SortOrder.LayoutOrder
horizontalLayout.Padding = UDim.new(0, 20)
horizontalLayout.Parent = page

-- Frame kiri dan kanan
local leftFrame = Instance.new("Frame")
leftFrame.Name = "LeftColumn"
leftFrame.Size = UDim2.new(0.5, -10, 0, 0)
leftFrame.AutomaticSize = Enum.AutomaticSize.Y
leftFrame.BackgroundTransparency = 1
leftFrame.Parent = page

local rightFrame = Instance.new("Frame")
rightFrame.Name = "RightColumn"
rightFrame.Size = UDim2.new(0.5, -10, 0, 0)
rightFrame.AutomaticSize = Enum.AutomaticSize.Y
rightFrame.BackgroundTransparency = 1
rightFrame.Parent = page

-- Layout vertikal dalam masing-masing kolom
for _, frame in pairs({leftFrame, rightFrame}) do
local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10)
layout.Parent = frame
end

-- 🟩 Kolom kiri (sama seperti sebelumnya)
createToggleButton(leftFrame, "Fly", UDim2.new(0, 0, 0.05, 0), UDim2.new(1, 0, 0.05, 0), toggleFly)
createToggleButton(leftFrame, "Noclip", UDim2.new(0, 0, 0.05, 0), UDim2.new(1, 0, 0.05, 0), toggleNoclip)
createToggleButton(leftFrame, "Infinite Jump", UDim2.new(0, 0, 0.05, 0), UDim2.new(1, 0, 0.05, 0), toggleJump)
createToggleButton(leftFrame, "Speed Hack", UDim2.new(0, 0, 0.05, 0), UDim2.new(1, 0, 0.05, 0), toggleSpeed)

-- Tambahan Fitur Kiri
createSlider(
leftFrame,
"WalkSpeed",
UDim2.new(0, 0, 0, 0),
UDim2.new(1, 0, 0.0, 50),
16,
100,
settings.walkSpeed,
function(value)
settings.walkSpeed = value
if features.speed and Player.Character and Player.Character:FindFirstChild("Humanoid") then
  Player.Character.Humanoid.WalkSpeed = value
end
end
)
createSlider(
leftFrame,
"JumpPower",
UDim2.new(0, 0, 0, 0),
UDim2.new(1, 0, 0, 50),
50,
200,
settings.jumpPower,
function(value)
settings.jumpPower = value
if Player.Character and Player.Character:FindFirstChild("Humanoid") then
  local humanoid = Player.Character.Humanoid
  humanoid.UseJumpPower = true
  humanoid.JumpPower = value
end
end
)

createToggleButton(leftFrame, "Kill Aura", UDim2.new(0, 0, 0.05, 0), UDim2.new(1, 0, 0.05, 0), toggleKillAura)
createSlider(
leftFrame,
"Kill Aura Radius",
UDim2.new(0, 0, 0, 0),
UDim2.new(1, 0, 0, 50),
5,
100,
settings.killAuraRadius,
function(value)
settings.killAuraRadius = value
showNotification("Kill Aura Radius set to " .. value, 2)
end
)

local radiusPresetFrame = Instance.new("Frame")
radiusPresetFrame.Size = UDim2.new(1, 0, 0, 30)
radiusPresetFrame.BackgroundTransparency = 1
radiusPresetFrame.Parent = leftFrame

local preset50 = Instance.new("TextButton")
preset50.Size = UDim2.new(0.3, 0, 1, 0)
preset50.Position = UDim2.new(0, 0, 0, 0)
preset50.Text = "50"
preset50.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
preset50.TextColor3 = Color3.fromRGB(255, 255, 255)
preset50.Parent = radiusPresetFrame
preset50.MouseButton1Click:Connect(
function()
settings.killAuraRadius = 50
showNotification("Kill Aura Radius set to 50", 2)
end
)

local preset100 = Instance.new("TextButton")
preset100.Size = UDim2.new(0.3, 0, 1, 0)
preset100.Position = UDim2.new(0.35, 0, 0, 0)
preset100.Text = "100"
preset100.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
preset100.TextColor3 = Color3.fromRGB(255, 255, 255)
preset100.Parent = radiusPresetFrame
preset100.MouseButton1Click:Connect(
function()
settings.killAuraRadius = 100
showNotification("Kill Aura Radius set to 100", 2)
end
)

local presetMax = Instance.new("TextButton")
presetMax.Size = UDim2.new(0.3, 0, 1, 0)
presetMax.Position = UDim2.new(0.7, 0, 0, 0)
presetMax.Text = "MAX"
presetMax.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
presetMax.TextColor3 = Color3.fromRGB(255, 255, 255)
presetMax.Parent = radiusPresetFrame
presetMax.MouseButton1Click:Connect(
function()
settings.killAuraRadius = 200
showNotification("Kill Aura Radius set to MAX (200)", 2)
end
)

-- Fungsi Auto Fuel
local function toggleAutoFuel(enabled)
features.autoFuel = enabled
if enabled then
  showNotification("Auto Fuel enabled!", 2)
else
  showNotification("Auto Fuel disabled!", 2)
end
end

-- 🟦 Kolom kanan - DENGAN TELEPORT BARU
createToggleButton(rightFrame, "AutoFarm", UDim2.new(0, 0, 0.05, 0), UDim2.new(1, 0, 0.05, 0), toggleAutoFarm)
createToggleButton(rightFrame, "Auto Fuel", UDim2.new(0, 0, 0.05, 0), UDim2.new(1, 0, 0.05, 0), toggleAutoFuel)
createToggleButton(rightFrame, "God Mode", UDim2.new(0, 0, 0.05, 0), UDim2.new(1, 0, 0.05, 0), toggleGodMode)
createToggleButton(
rightFrame,
"Infinite Hunger",
UDim2.new(0, 0, 0.05, 0),
UDim2.new(1, 0, 0.05, 0),
toggleInfiniteHunger
)

-- ✨ BAGIAN BARU: Container untuk kedua teleport
local teleportContainer = Instance.new("Frame")
teleportContainer.Name = "TeleportContainer"
teleportContainer.Size = UDim2.new(1, 0, 0, 200) -- Fixed height
teleportContainer.BackgroundTransparency = 1
teleportContainer.Parent = rightFrame

-- Layout horizontal untuk teleport container
local teleportLayout = Instance.new("UIListLayout")
teleportLayout.FillDirection = Enum.FillDirection.Horizontal
teleportLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
teleportLayout.SortOrder = Enum.SortOrder.LayoutOrder
teleportLayout.Padding = UDim.new(0, 10)
teleportLayout.Parent = teleportContainer

-- Teleport to Location (kiri)
local teleportItems = {"Camp", "Child 1", "Child 2", "Child 3", "Child 4"}
createListbox(
teleportContainer,
"Teleport",
UDim2.new(0, 0, 0, 0),
UDim2.new(0.48, 0, 1, 0),
teleportItems,
teleportToLocation
)

-- ✨ TELEPORT TO PLAYER (kanan) - BARU!
local playerList = getPlayerList()
if #playerList == 0 then
table.insert(playerList, "No Players")
end
createListbox(
teleportContainer,
"TP to Player",
UDim2.new(0, 0, 0, 0),
UDim2.new(0.48, 0, 1, 0),
playerList,
teleportToPlayer
)

return page
end
-- ========== CLICKABLE LISTBOX FUNCTION ==========
local function createClickableListbox(parent, text, position, size, items, callback)
local frame = Instance.new("Frame")
frame.Name = text .. "Listbox"
frame.Parent = parent
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Position = position
frame.Size = size
frame.LayoutOrder = (#parent:GetChildren())

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local label = Instance.new("TextLabel")
label.Name = "Label"
label.Parent = frame
label.BackgroundTransparency = 1
label.Position = UDim2.new(0, 5, 0, 0)
label.Size = UDim2.new(1, -10, 0.2, 0)
label.Font = Enum.Font.GothamBold
label.Text = text
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextScaled = true
label.TextXAlignment = Enum.TextXAlignment.Center

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Parent = frame
scrollFrame.BackgroundTransparency = 1
scrollFrame.Position = UDim2.new(0, 5, 0.2, 0)
scrollFrame.Size = UDim2.new(1, -10, 0.8, 0)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #items * 30)
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)

local layout = Instance.new("UIListLayout")
layout.Parent = scrollFrame
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 2)

for i, item in ipairs(items) do
local itemButton = Instance.new("TextButton")
itemButton.Name = "Item" .. i
itemButton.Parent = scrollFrame
itemButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
itemButton.BorderSizePixel = 0
itemButton.Size = UDim2.new(1, 0, 0, 25)
itemButton.Font = Enum.Font.Gotham
itemButton.Text = item
itemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
itemButton.TextScaled = true
itemButton.LayoutOrder = i

local itemCorner = Instance.new("UICorner")
itemCorner.CornerRadius = UDim.new(0, 4)
itemCorner.Parent = itemButton

itemButton.MouseButton1Click:Connect(function()
-- Reset semua button ke warna normal
for _, child in pairs(scrollFrame:GetChildren()) do
  if child:IsA("TextButton") then
    child.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
  end
end

-- Highlight selected button
itemButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)

-- Set selected item
_G.selectedItemName = item
_G.selectedItemButton = itemButton

-- Call callback if provided
if callback then
  callback(item .. " selected!")
end
end)
end

return frame
end

-- Create Chest System UI Function
local function createChestSystemUI(parent)
  local chestFrame = Instance.new("Frame")
  chestFrame.Name = "ChestSystemFrame"
  chestFrame.Size = UDim2.new(1, 0, 0, 200)
  chestFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
  chestFrame.BorderSizePixel = 0
  chestFrame.Parent = parent
  chestFrame.LayoutOrder = 1

  local chestCorner = Instance.new("UICorner")
  chestCorner.CornerRadius = UDim.new(0, 8)
  chestCorner.Parent = chestFrame

  -- Title
  local titleLabel = Instance.new("TextLabel")
  titleLabel.Name = "ChestTitleLabel"
  titleLabel.Size = UDim2.new(1, 0, 0, 30)
  titleLabel.Position = UDim2.new(0, 0, 0, 5)
  titleLabel.BackgroundTransparency = 1
  titleLabel.Text = "Chest System"
  titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
  titleLabel.Font = Enum.Font.GothamBold
  titleLabel.TextSize = 16
  titleLabel.TextXAlignment = Enum.TextXAlignment.Center
  titleLabel.Parent = chestFrame

  -- Scan Chests Button
  local scanButton = Instance.new("TextButton")
  scanButton.Name = "ScanChestsButton"
  scanButton.Size = UDim2.new(1, -20, 0, 30)
  scanButton.Position = UDim2.new(0, 10, 0, 40)
  scanButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
  scanButton.BorderSizePixel = 0
  scanButton.Text = "Scan for Chests"
  scanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
  scanButton.Font = Enum.Font.GothamBold
  scanButton.TextSize = 14
  scanButton.Parent = chestFrame

  local scanCorner = Instance.new("UICorner")
  scanCorner.CornerRadius = UDim.new(0, 6)
  scanCorner.Parent = scanButton

  -- Chest List ScrollFrame
  local chestScrollFrame = Instance.new("ScrollingFrame")
  chestScrollFrame.Name = "ChestScrollFrame"
  chestScrollFrame.Size = UDim2.new(1, -20, 0, 120)
  chestScrollFrame.Position = UDim2.new(0, 10, 0, 75)
  chestScrollFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
  chestScrollFrame.BorderSizePixel = 0
  chestScrollFrame.ScrollBarThickness = 4
  chestScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
  chestScrollFrame.Parent = chestFrame

  local scrollCorner = Instance.new("UICorner")
  scrollCorner.CornerRadius = UDim.new(0, 6)
  scrollCorner.Parent = chestScrollFrame

  local chestListLayout = Instance.new("UIListLayout")
  chestListLayout.FillDirection = Enum.FillDirection.Vertical
  chestListLayout.SortOrder = Enum.SortOrder.LayoutOrder
  chestListLayout.Padding = UDim.new(0, 2)
  chestListLayout.Parent = chestScrollFrame

  -- Function to update chest list
  local function updateChestList()
    -- Clear existing items
    for _, child in pairs(chestScrollFrame:GetChildren()) do
      if child:IsA("TextButton") then
        child:Destroy()
      end
    end

    local chests = findAllChests()
    
    if #chests == 0 then
      local noChestsLabel = Instance.new("TextLabel")
      noChestsLabel.Name = "NoChestsLabel"
      noChestsLabel.Size = UDim2.new(1, 0, 0, 25)
      noChestsLabel.BackgroundTransparency = 1
      noChestsLabel.Text = "No chests found"
      noChestsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
      noChestsLabel.Font = Enum.Font.Gotham
      noChestsLabel.TextSize = 12
      noChestsLabel.Parent = chestScrollFrame
      return
    end

    for i, chestData in ipairs(chests) do
      local chestButton = Instance.new("TextButton")
      chestButton.Name = "ChestButton" .. i
      chestButton.Size = UDim2.new(1, 0, 0, 25)
      chestButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
      chestButton.BorderSizePixel = 0
      chestButton.Text = chestData.name .. " (" .. math.floor(chestData.position.X) .. "," .. math.floor(chestData.position.Z) .. ")"
      chestButton.TextColor3 = Color3.fromRGB(255, 255, 255)
      chestButton.Font = Enum.Font.Gotham
      chestButton.TextSize = 11
      chestButton.LayoutOrder = i
      chestButton.Parent = chestScrollFrame

      local buttonCorner = Instance.new("UICorner")
      buttonCorner.CornerRadius = UDim.new(0, 4)
      buttonCorner.Parent = chestButton

      -- Teleport to chest functionality
      chestButton.MouseButton1Click:Connect(function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
          local targetPosition = chestData.position + Vector3.new(0, TELEPORT_Y_OFFSET, 0)
          player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
          showNotification("Teleported to " .. chestData.name, 2)
        end
      end)

      -- Hover effects
      chestButton.MouseEnter:Connect(function()
        chestButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
      end)

      chestButton.MouseLeave:Connect(function()
        chestButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
      end)
    end

    chestScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #chests * 27)
  end

  -- Scan button functionality
  scanButton.MouseButton1Click:Connect(function()
    scanButton.Text = "Scanning..."
    scanButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    spawn(function()
      updateChestList()
      wait(0.5)
      scanButton.Text = "Scan for Chests"
      scanButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
      showNotification("Chest scan completed", 2)
    end)
  end)

  return chestFrame
end

local function createItemPage(parent)
local page = Instance.new("ScrollingFrame")
page.Name = "ItemPage"
page.Parent = parent
page.BackgroundTransparency = 1
page.Size = UDim2.new(1, 0, 1, 0)
page.Visible = false
page.ScrollBarThickness = 8
page.ScrollingDirection = Enum.ScrollingDirection.Y
page.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Layout horizontal untuk kolom kiri-kanan
local horizontalLayout = Instance.new("UIListLayout")
horizontalLayout.FillDirection = Enum.FillDirection.Horizontal
horizontalLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
horizontalLayout.SortOrder = Enum.SortOrder.LayoutOrder
horizontalLayout.Padding = UDim.new(0, 20)
horizontalLayout.Parent = page

-- Frame kiri dan kanan
local leftFrame = Instance.new("Frame")
leftFrame.Name = "LeftColumn"
leftFrame.Size = UDim2.new(0.5, -10, 0, 0)
leftFrame.AutomaticSize = Enum.AutomaticSize.Y
leftFrame.BackgroundTransparency = 1
leftFrame.Parent = page
leftFrame.LayoutOrder = 1

local rightFrame = Instance.new("Frame")
rightFrame.Name = "RightColumn"
rightFrame.Size = UDim2.new(0.5, -10, 0, 0)
rightFrame.AutomaticSize = Enum.AutomaticSize.Y
rightFrame.BackgroundTransparency = 1
rightFrame.Parent = page
rightFrame.LayoutOrder = 2

-- Layout vertikal untuk masing-masing kolom
for _, frame in pairs({leftFrame, rightFrame}) do
local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10)
layout.Parent = frame
end

-- ========== KOLOM KIRI: TELEPORT TO ITEM ==========
createChestSystemUI(leftFrame)

-- ========== TELEPORT TO ITEM FRAME (BARU) ==========
local teleportItemsFrame = Instance.new("Frame")
teleportItemsFrame.Name = "TeleportItemsFrame"
teleportItemsFrame.Size = UDim2.new(1, 0, 0, 300)
teleportItemsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
teleportItemsFrame.BorderSizePixel = 0
teleportItemsFrame.Parent = leftFrame
teleportItemsFrame.LayoutOrder = 2

local teleportFrameCorner = Instance.new("UICorner")
teleportFrameCorner.CornerRadius = UDim.new(0, 8)
teleportFrameCorner.Parent = teleportItemsFrame

-- Title untuk teleport items
local teleportTitleLabel = Instance.new("TextLabel")
teleportTitleLabel.Name = "TeleportTitleLabel"
teleportTitleLabel.Size = UDim2.new(1, 0, 0, 30)
teleportTitleLabel.Position = UDim2.new(0, 0, 0, 5)
teleportTitleLabel.BackgroundTransparency = 1
teleportTitleLabel.Text = "Teleport to Item"
teleportTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportTitleLabel.Font = Enum.Font.GothamBold
teleportTitleLabel.TextSize = 16
teleportTitleLabel.TextXAlignment = Enum.TextXAlignment.Center
teleportTitleLabel.Parent = teleportItemsFrame

-- Categories frame untuk teleport
local teleportCategoriesFrame = Instance.new("Frame")
teleportCategoriesFrame.Name = "TeleportCategoriesFrame"
teleportCategoriesFrame.Size = UDim2.new(1, -10, 1, -70)
teleportCategoriesFrame.Position = UDim2.new(0, 5, 0, 35)
teleportCategoriesFrame.BackgroundTransparency = 1
teleportCategoriesFrame.Parent = teleportItemsFrame

-- Layout for teleport categories
local teleportCategoriesLayout = Instance.new("UIListLayout")
teleportCategoriesLayout.FillDirection = Enum.FillDirection.Horizontal
teleportCategoriesLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
teleportCategoriesLayout.SortOrder = Enum.SortOrder.LayoutOrder
teleportCategoriesLayout.Padding = UDim.new(0, 5)
teleportCategoriesLayout.Parent = teleportCategoriesFrame

-- Helper function untuk membuat teleport listbox (FIXED VERSION)
local function createTeleportListbox(parent, title, position, size, items, callback)
    if not parent or not items or #items == 0 then
        print("❌ createTeleportListbox: Invalid parameters")
        return nil
    end

    local frame = Instance.new("Frame")
    frame.Name = title .. "TeleportListbox"
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderSizePixel = 0
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.Size = size or UDim2.new(0.32, 0, 1, 0)
    frame.LayoutOrder = #parent:GetChildren()

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 5, 0, 0)
    label.Size = UDim2.new(1, -10, 0, 25)
    label.Font = Enum.Font.GothamBold
    label.Text = title or "Items"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Center

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Parent = frame
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.Position = UDim2.new(0, 5, 0, 30)
    scrollFrame.Size = UDim2.new(1, -10, 1, -35)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #items * 27)
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)

    local layout = Instance.new("UIListLayout")
    layout.Parent = scrollFrame
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 2)

    -- Safe item creation with error handling
    for i, item in ipairs(items) do
        pcall(function()
            local itemButton = Instance.new("TextButton")
            itemButton.Name = "TeleportItem" .. i
            itemButton.Parent = scrollFrame
            itemButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            itemButton.BorderSizePixel = 0
            itemButton.Size = UDim2.new(1, 0, 0, 25)
            itemButton.Font = Enum.Font.Gotham
            itemButton.Text = tostring(item) -- Convert to string safely
            itemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            itemButton.TextSize = 12
            itemButton.LayoutOrder = i

            local itemCorner = Instance.new("UICorner")
            itemCorner.CornerRadius = UDim.new(0, 4)
            itemCorner.Parent = itemButton

            itemButton.MouseButton1Click:Connect(function()
                pcall(function()
                    -- Reset all buttons in this category
                    for _, btn in pairs(scrollFrame:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                        end
                    end

                    -- Highlight selected button
                    itemButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)

                    -- Set global selection for teleport
                    _G.selectedTeleportItemName = item
                    _G.selectedTeleportItemButton = itemButton

                    showNotification("Selected for teleport: " .. tostring(item), 1)

                    if callback then
                        callback("Selected: " .. tostring(item), 1)
                    end
                end)
            end)
        end)
    end

    return frame
end

-- Helper function untuk membuat teleport listbox
local function createTeleportListbox(parent, title, position, size, items, callback)
local frame = Instance.new("Frame")
frame.Name = title .. "TeleportListbox"
frame.Parent = parent
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Position = position
frame.Size = size
frame.LayoutOrder = #parent:GetChildren()

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local label = Instance.new("TextLabel")
label.Name = "Label"
label.Parent = frame
label.BackgroundTransparency = 1
label.Position = UDim2.new(0, 5, 0, 0)
label.Size = UDim2.new(1, -10, 0, 25)
label.Font = Enum.Font.GothamBold
label.Text = title
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextSize = 14
label.TextXAlignment = Enum.TextXAlignment.Center

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Parent = frame
scrollFrame.BackgroundTransparency = 1
scrollFrame.Position = UDim2.new(0, 5, 0, 30)
scrollFrame.Size = UDim2.new(1, -10, 1, -35)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #items * 27)
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)

local layout = Instance.new("UIListLayout")
layout.Parent = scrollFrame
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 2)

for i, item in ipairs(items) do
  local itemButton = Instance.new("TextButton")
  itemButton.Name = "TeleportItem" .. i
  itemButton.Parent = scrollFrame
  itemButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
  itemButton.BorderSizePixel = 0
  itemButton.Size = UDim2.new(1, 0, 0, 25)
  itemButton.Font = Enum.Font.Gotham
  itemButton.Text = item
  itemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
  itemButton.TextSize = 12

  local itemCorner = Instance.new("UICorner")
  itemCorner.CornerRadius = UDim.new(0, 4)
  itemCorner.Parent = itemButton

  itemButton.MouseButton1Click:Connect(function()
  -- Reset all buttons in this category
  for _, btn in pairs(scrollFrame:GetChildren()) do
    if btn:IsA("TextButton") then
      btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
  end

  -- Highlight selected button
  itemButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)

  -- Set global selection for teleport
  _G.selectedTeleportItemName = item
  _G.selectedTeleportItemButton = itemButton

  showNotification("Selected for teleport: " .. item, 1)

  if callback then
    callback("Selected: " .. item, 1)
  end
  end)
end

return frame
end

-- Food Items untuk teleport
local foodItems = {
"Berry", "Carrot", "Cooked Morsel", "Cooked Steak", "Morsel", "Steak",
"Apple", "Cake", "Ribs", "Chili", "Hearty Stew", "Meat Sandwich", "Bandage", "MedKit"
}
createTeleportListbox(
teleportCategoriesFrame,
"Food",
UDim2.new(0, 0, 0, 0),
UDim2.new(0.32, 0, 1, 0),
foodItems,
showNotification
)

-- Weapons untuk teleport
local weaponItems = {
"Revolver", "Revolver Ammo", "Rifle", "Rifle Ammo", "Spear",
"Strong Axe", "Good Axe", "Strong Flashlight"
}
createTeleportListbox(
teleportCategoriesFrame,
"Weapons",
UDim2.new(0, 0, 0, 0),
UDim2.new(0.32, 0, 1, 0),
weaponItems,
showNotification
)

-- Resources untuk teleport
local resourceItems = {
"Coal", "Fuel Canister", "Oil Barrel", "Log", "Tyre", "Chair",
"Sheet Metal", "Bolt", "Broken Fan", "Broken Radio", "Broken Microwave",
"Washing Machine", "Metal Chair", "Old Car Engine",
"UFO Component", "UFO Scrap", "UFO Junk", "Cultist Experiment", "Cultist Prototype"
}
createTeleportListbox(
teleportCategoriesFrame,
"Resources",
UDim2.new(0, 0, 0, 0),
UDim2.new(0.32, 0, 1, 0),
resourceItems,
showNotification
)

-- TELEPORT Button Frame
local teleportButtonFrame = Instance.new("Frame")
teleportButtonFrame.Name = "TeleportButtonFrame"
teleportButtonFrame.Size = UDim2.new(1, -10, 0, 35)
teleportButtonFrame.Position = UDim2.new(0, 5, 1, -40)
teleportButtonFrame.BackgroundTransparency = 1
teleportButtonFrame.Parent = teleportItemsFrame

-- TELEPORT Button
local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(1, 0, 1, 0)
teleportButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0) -- Orange color
teleportButton.Text = "TELEPORT TO ITEM"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.GothamBold
teleportButton.TextSize = 16
teleportButton.Parent = teleportButtonFrame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 6)
teleportCorner.Parent = teleportButton

-- Teleport Button functionality
teleportButton.MouseButton1Click:Connect(function()
if not _G.selectedTeleportItemName then
showNotification("Select an item first!", 2)
return
end

isTeleportingToItem = true
local itemName = _G.selectedTeleportItemName
showNotification("Teleporting to " .. itemName .. "...", 2)

spawn(function()
local success = teleportToItem(itemName)
if success then
if _G.selectedTeleportItemButton then
  _G.selectedTeleportItemButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
  wait(0.1)
  _G.selectedTeleportItemButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
end
showNotification("Teleported to " .. itemName .. " successfully!", 2)
else
if _G.selectedTeleportItemButton then
  _G.selectedTeleportItemButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
  wait(0.5)
  _G.selectedTeleportItemButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
end
showNotification("Failed to teleport to " .. itemName, 2)
end
isTeleportingToItem = false
end)
end)

-- ========== KOLOM KANAN: AUTO OPEN CHEST + ITEM BRINGERS ==========

-- Auto Open Chest toggle button
createToggleButton(rightFrame, "Auto Open Chest", UDim2.new(0, 0, 0.05, 0), UDim2.new(1, 0, 0.05, 0), toggleAutoOpenChest)

-- Bring Items Frame (dengan improved design) - SISANYA SAMA SEPERTI SEBELUMNYA
local bringItemsFrame = Instance.new("Frame")
bringItemsFrame.Name = "BringItemsFrame"
bringItemsFrame.Size = UDim2.new(1, 0, 0, 300) -- Increased height
bringItemsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
bringItemsFrame.BorderSizePixel = 0
bringItemsFrame.Parent = rightFrame
bringItemsFrame.LayoutOrder = 2

local bringFrameCorner = Instance.new("UICorner")
bringFrameCorner.CornerRadius = UDim.new(0, 8)
bringFrameCorner.Parent = bringItemsFrame

-- Title untuk bring items
local bringTitleLabel = Instance.new("TextLabel")
bringTitleLabel.Name = "BringTitleLabel"
bringTitleLabel.Size = UDim2.new(1, 0, 0, 30)
bringTitleLabel.Position = UDim2.new(0, 0, 0, 5)
bringTitleLabel.BackgroundTransparency = 1
bringTitleLabel.Text = "Item Bringer"
bringTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
bringTitleLabel.Font = Enum.Font.GothamBold
bringTitleLabel.TextSize = 16
bringTitleLabel.TextXAlignment = Enum.TextXAlignment.Center
bringTitleLabel.Parent = bringItemsFrame

-- Item categories (improved layout)
local categoriesFrame = Instance.new("Frame")
categoriesFrame.Name = "CategoriesFrame"
categoriesFrame.Size = UDim2.new(1, -10, 1, -70) -- Space for title and buttons
categoriesFrame.Position = UDim2.new(0, 5, 0, 35)
categoriesFrame.BackgroundTransparency = 1
categoriesFrame.Parent = bringItemsFrame

-- Layout for categories
local categoriesLayout = Instance.new("UIListLayout")
categoriesLayout.FillDirection = Enum.FillDirection.Horizontal
categoriesLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
categoriesLayout.SortOrder = Enum.SortOrder.LayoutOrder
categoriesLayout.Padding = UDim.new(0, 5)
categoriesLayout.Parent = categoriesFrame

-- Food Items
createClickableListbox(
categoriesFrame,
"Food",
UDim2.new(0, 0, 0, 0),
UDim2.new(0.32, 0, 1, 0),
foodItems,
showNotification
)

-- Weapons
createClickableListbox(
categoriesFrame,
"Weapons",
UDim2.new(0, 0, 0, 0),
UDim2.new(0.32, 0, 1, 0),
weaponItems,
showNotification
)

-- Resources / Misc Items
createClickableListbox(
categoriesFrame,
"Resources",
UDim2.new(0, 0, 0, 0),
UDim2.new(0.32, 0, 1, 0),
resourceItems,
showNotification
)

-- Button Frame untuk BRING dan STOP (di bawah categories)
local buttonFrame = Instance.new("Frame")
buttonFrame.Name = "ButtonFrame"
buttonFrame.Size = UDim2.new(1, -10, 0, 35)
buttonFrame.Position = UDim2.new(0, 5, 1, -40)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = bringItemsFrame

-- Layout untuk buttons
local buttonLayout = Instance.new("UIListLayout")
buttonLayout.FillDirection = Enum.FillDirection.Horizontal
buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
buttonLayout.Padding = UDim.new(0, 10)
buttonLayout.Parent = buttonFrame

-- BRING Button (improved design)
local bringButton = Instance.new("TextButton")
bringButton.Name = "BringButton"
bringButton.Size = UDim2.new(0.45, 0, 1, 0)
bringButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
bringButton.Text = "BRING ITEM"
bringButton.TextColor3 = Color3.fromRGB(255, 255, 255)
bringButton.Font = Enum.Font.GothamBold
bringButton.TextSize = 16
bringButton.Parent = buttonFrame

local bringCorner = Instance.new("UICorner")
bringCorner.CornerRadius = UDim.new(0, 6)
bringCorner.Parent = bringButton

-- STOP Button (improved design)
local stopButton = Instance.new("TextButton")
stopButton.Name = "StopButton"
stopButton.Size = UDim2.new(0.45, 0, 1, 0)
stopButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
stopButton.Text = "STOP"
stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopButton.Font = Enum.Font.GothamBold
stopButton.TextSize = 16
stopButton.Parent = buttonFrame

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 6)
stopCorner.Parent = stopButton

-- Button functionality (same as before)
bringButton.MouseButton1Click:Connect(function()
if not _G.selectedItemName then
showNotification("Select an item first!", 2)
return
end

isBringingItems = true
local itemName = _G.selectedItemName
showNotification("Bringing " .. itemName .. "...", 2)

spawn(function()
local success = bringAllItems(itemName)
if success then
if _G.selectedItemButton then
  _G.selectedItemButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
  wait(0.1)
  _G.selectedItemButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
end
showNotification(itemName .. " brought successfully!", 2)
else
if _G.selectedItemButton then
  _G.selectedItemButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
  wait(0.5)
  _G.selectedItemButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
end
showNotification("Failed to bring " .. itemName, 2)
end
isBringingItems = false
end)
end)

stopButton.MouseButton1Click:Connect(function()
isBringingItems = false
showNotification("Stopped bringing items", 2)
end)

createItemListFrame(rightFrame)

return page
end
local function createVisualPage(parent)
local page = Instance.new("Frame")
page.Name = "VisualPage"
page.Parent = parent
page.BackgroundTransparency = 1
page.Size = UDim2.new(1, 0, 1, 0)
page.Visible = false

-- FIXED: Create main container frame
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Parent = page
mainContainer.Size = UDim2.new(1, 0, 1, 0)
mainContainer.BackgroundTransparency = 1

-- FIXED: Horizontal layout for columns
local mainLayout = Instance.new("UIListLayout")
mainLayout.Parent = mainContainer
mainLayout.FillDirection = Enum.FillDirection.Horizontal
mainLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
mainLayout.VerticalAlignment = Enum.VerticalAlignment.Top
mainLayout.Padding = UDim.new(0, 20)

-- FIXED: Left column with ScrollingFrame
local leftColumn = Instance.new("ScrollingFrame")
leftColumn.Name = "LeftColumn"
leftColumn.Size = UDim2.new(0.45, 0, 1, 0)
leftColumn.BackgroundTransparency = 1
leftColumn.Parent = mainContainer
leftColumn.LayoutOrder = 1
leftColumn.ScrollBarThickness = 6
leftColumn.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
leftColumn.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Layout for left column
local leftLayout = Instance.new("UIListLayout")
leftLayout.Parent = leftColumn
leftLayout.FillDirection = Enum.FillDirection.Vertical
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
leftLayout.Padding = UDim.new(0, 10)

-- FIXED: Right column with ScrollingFrame
local rightColumn = Instance.new("ScrollingFrame")
rightColumn.Name = "RightColumn"
rightColumn.Size = UDim2.new(0.45, 0, 1, 0)
rightColumn.BackgroundTransparency = 1
rightColumn.Parent = mainContainer
rightColumn.LayoutOrder = 2
rightColumn.ScrollBarThickness = 6
rightColumn.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
rightColumn.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Layout for right column
local rightLayout = Instance.new("UIListLayout")
rightLayout.Parent = rightColumn
rightLayout.FillDirection = Enum.FillDirection.Vertical
rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
rightLayout.Padding = UDim.new(0, 10)

-- ===== LEFT COLUMN: LIGHTING CONTROLS + FOV =====
createToggleButton(leftColumn, "Always Bright", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 40), toggleAlwaysBright)
createToggleButton(leftColumn, "Always Night", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 40), toggleAlwaysNight)
createToggleButton(leftColumn, "Full HD", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 40), toggleFullHD)
createToggleButton(leftColumn, "Field of View", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 40), toggleCustomFOV)

createSlider(
leftColumn,
"FOV Value",
UDim2.new(0, 0, 0, 0),
UDim2.new(1, 0, 0, 60),
30, 120,
settings.fieldOfView,
onFOVChange
)

-- HITBOX SECTION - Tambahkan setelah FOV slider
createHitboxSection(leftColumn)

-- Hitbox Size Slider
createSlider(
leftColumn,
"Hitbox Value",
UDim2.new(0, 0, 0, 0),
UDim2.new(1, 0, 0, 60),
1, 50,
HitboxSystem.size,
onHitboxSizeChange
)

-- ===== RIGHT COLUMN: WEATHER + FOG + ESP =====
local visualToggles = {
{name = "Clear Weather", flag = "clearWeather", callback = toggleClearWeather},
{name = "No Fog", flag = "noFog", callback = toggleNoFog},
{name = "FPS Boost", flag = "fpsBoost", callback = toggleFPSBoost},
{name = "Night Vision", flag = "nightVision", callback = toggleNightVision},
}

for _, data in ipairs(visualToggles) do
createToggleButton(rightColumn, data.name, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 40), function(enabled)
features[data.flag] = enabled
if data.callback then
  data.callback(enabled)
else
  showNotification(data.name .. " " .. (enabled and "enabled" or "disabled"), 2)
end
end)
end

createCorrectESPSection(rightColumn, "ESP Animals", "animals", ESPSystem.targets.animals)
createCorrectESPSection(rightColumn, "ESP NPCs", "npcs", ESPSystem.targets.npcs)
createCorrectESPSection(rightColumn, "ESP Items", "items", ESPSystem.targets.items)

return page
end
local function createInfoPage(parent)
local page = Instance.new("Frame")
page.Name = "InfoPage"
page.Parent = parent
page.BackgroundTransparency = 1
page.Size = UDim2.new(1, 0, 1, 0)
page.Visible = false

-- Main Info Frame
local infoFrame = Instance.new("Frame")
infoFrame.Name = "InfoFrame"
infoFrame.Parent = page
infoFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
infoFrame.BorderSizePixel = 0
infoFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
infoFrame.Size = UDim2.new(0.9, 0, 0.9, 0)

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 12)
infoCorner.Parent = infoFrame

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = infoFrame
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 0, 0.05, 0)
titleLabel.Size = UDim2.new(1, 0, 0.15, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "ClavnnX"
titleLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
titleLabel.TextScaled = true

-- Welcome message with typewriter effect
local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Name = "WelcomeLabel"
welcomeLabel.Parent = infoFrame
welcomeLabel.BackgroundTransparency = 1
welcomeLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
welcomeLabel.Size = UDim2.new(0.9, 0, 0.1, 0)
welcomeLabel.Font = Enum.Font.Gotham
welcomeLabel.Text = ""
welcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
welcomeLabel.TextScaled = true
welcomeLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Description
local descLabel = Instance.new("TextLabel")
descLabel.Name = "DescLabel"
descLabel.Parent = infoFrame
descLabel.BackgroundTransparency = 1
descLabel.Position = UDim2.new(0.05, 0, 0.4, 0)
descLabel.Size = UDim2.new(0.9, 0, 0.3, 0)
descLabel.Font = Enum.Font.Gotham
descLabel.Text =
"Professional script for 99 Nights in the ForestnnFeatures:n• Advanced movement systemn• Item managementn• ESP systemn• Player utilitiesn• Mobile optimized"
descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
descLabel.TextScaled = true
descLabel.TextXAlignment = Enum.TextXAlignment.Left
descLabel.TextYAlignment = Enum.TextYAlignment.Top

-- Credits
local creditsLabel = Instance.new("TextLabel")
creditsLabel.Name = "CreditsLabel"
creditsLabel.Parent = infoFrame
creditsLabel.BackgroundTransparency = 1
creditsLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
creditsLabel.Size = UDim2.new(0.9, 0, 0.2, 0)
creditsLabel.Font = Enum.Font.Gotham
creditsLabel.Text =
"Created by: ClavnnX TeamnVersion: 1.0.0nGame: 99 Nights in the ForestnOptimized for mobile devices"
creditsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
creditsLabel.TextScaled = true
creditsLabel.TextXAlignment = Enum.TextXAlignment.Left
creditsLabel.TextYAlignment = Enum.TextYAlignment.Top

-- Start typewriter effect
spawn(
function()
typewriterEffect(welcomeLabel, "Welcome back, survivor! Ready to dominate the forest?", 0.03)
end
)

return page
end
local function createSettingsPage(parent)
local page = Instance.new("Frame")
page.Name = "SettingsPage"
page.Parent = parent
page.BackgroundTransparency = 1
page.Size = UDim2.new(1, 0, 1, 0)
page.Visible = false

-- GUI Settings Frame
local guiSettingsFrame = Instance.new("Frame")
guiSettingsFrame.Name = "GUISettingsFrame"
guiSettingsFrame.Parent = page
guiSettingsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
guiSettingsFrame.BorderSizePixel = 0
guiSettingsFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
guiSettingsFrame.Size = UDim2.new(0.4, 0, 0.9, 0)

local guiSettingsCorner = Instance.new("UICorner")
guiSettingsCorner.CornerRadius = UDim.new(0, 8)
guiSettingsCorner.Parent = guiSettingsFrame

local guiSettingsLabel = Instance.new("TextLabel")
guiSettingsLabel.Name = "GUISettingsLabel"
guiSettingsLabel.Parent = guiSettingsFrame
guiSettingsLabel.BackgroundTransparency = 1
guiSettingsLabel.Position = UDim2.new(0, 10, 0, 0)
guiSettingsLabel.Size = UDim2.new(1, -20, 0.1, 0)
guiSettingsLabel.Font = Enum.Font.GothamBold
guiSettingsLabel.Text = "GUI Settings"
guiSettingsLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
guiSettingsLabel.TextScaled = true
guiSettingsLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Reset All Features Button
local resetButton = Instance.new("TextButton")
resetButton.Name = "ResetButton"
resetButton.Parent = guiSettingsFrame
resetButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
resetButton.BorderSizePixel = 0
resetButton.Position = UDim2.new(0.05, 0, 0.15, 0)
resetButton.Size = UDim2.new(0.9, 0, 0.1, 0)
resetButton.Font = Enum.Font.Gotham
resetButton.Text = "Reset All Features"
resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resetButton.TextScaled = true

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 6)
resetCorner.Parent = resetButton

resetButton.MouseButton1Click:Connect(
function()
-- Disable God Mode first if active
if GodModeEnabled then
  DisableGodMode()
end

for k, v in pairs(features) do
  features[k] = false
end
-- Recreate GUI to reflect changes
if ClavnnXGui then
  ClavnnXGui:Destroy()
end
setupGui()
showNotification("All features reset!", 2)
end
)

return page
end
--=== START PAGE USER (FIXED - SEMUA DALAM 1 FRAME) ===
-- Fixed dark theme colors
local userPageColors = {
background = Color3.fromRGB(25, 25, 25),
frameBackground = Color3.fromRGB(35, 35, 35),
textPrimary = Color3.fromRGB(255, 255, 255),
textSecondary = Color3.fromRGB(200, 200, 200),
accent = Color3.fromRGB(0, 150, 255),
avatarBackground = Color3.fromRGB(0, 0, 0)
}

-- Helper functions
local function getAccountAge()
return Player.AccountAge .. " days"
end

local function getCurrentDate()
local months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
local days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}

local currentTime = os.time()
local dateTable = os.date("*t", currentTime)

local dayName = days[dateTable.wday]
local day = string.format("%02d", dateTable.day)
local month = string.format("%02d", dateTable.month)
local year = dateTable.year

return dayName .. " - " .. day .. "/" .. month .. "/" .. year
end

-- FPS Counter
local currentFPS = 0
local fpsConnection = nil

local function startFPSCounter()
if fpsConnection then return end

local lastTime = tick()
local frames = 0

fpsConnection = RunService.RenderStepped:Connect(function()
frames = frames + 1
local currentTime = tick()

if currentTime - lastTime >= 1 then
currentFPS = math.floor(frames / (currentTime - lastTime))
frames = 0
lastTime = currentTime
end
end)
end

local function getPing()
local success, ping = pcall(function()
return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
end)
return success and ping or "0 ms"
end

local function getServerName()
local success, name = pcall(function()
return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)
return success and name or "99 Nights in the Forest"
end

-- Create User Page Function (SEMUA DALAM 1 FRAME)
local function createUserPage(parent)
local page = Instance.new("Frame")
page.Name = "UserPage"
page.Parent = parent
page.BackgroundTransparency = 1
page.Size = UDim2.new(1, 0, 1, 0)
page.Visible = false

-- ✅ FRAME UTAMA TUNGGAL (Welcome + Avatar + User Info + FPS/Ping + Disclaimer + Server)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainUserFrame"
mainFrame.Parent = page
mainFrame.Size = UDim2.new(1, -20, 1, -20) -- Full page dengan margin kecil
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = userPageColors.frameBackground
mainFrame.BorderSizePixel = 0

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- 1. ✅ WELCOME TEXT (BAGIAN ATAS DALAM FRAME)
local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Name = "WelcomeTitle"
welcomeLabel.Parent = mainFrame
welcomeLabel.Size = UDim2.new(1, -30, 0, 40)
welcomeLabel.Position = UDim2.new(0, 15, 0, 15)
welcomeLabel.BackgroundTransparency = 1
welcomeLabel.Text = ""
welcomeLabel.TextColor3 = userPageColors.accent
welcomeLabel.Font = Enum.Font.GothamBold
welcomeLabel.TextSize = 22
welcomeLabel.TextXAlignment = Enum.TextXAlignment.Center

-- 2. ✅ AVATAR (KIRI BAWAH WELCOME)
local avatarFrame = Instance.new("Frame")
avatarFrame.Name = "AvatarFrame"
avatarFrame.Parent = mainFrame
avatarFrame.Size = UDim2.new(0, 70, 0, 70)
avatarFrame.Position = UDim2.new(0, 20, 0, 70)
avatarFrame.BackgroundColor3 = userPageColors.avatarBackground -- HITAM
avatarFrame.BorderSizePixel = 0

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(0, 6)
avatarCorner.Parent = avatarFrame

local avatarImage = Instance.new("ImageLabel")
avatarImage.Name = "AvatarImage"
avatarImage.Parent = avatarFrame
avatarImage.Size = UDim2.new(1, -4, 1, -4)
avatarImage.Position = UDim2.new(0, 2, 0, 2)
avatarImage.BackgroundTransparency = 1
avatarImage.ScaleType = Enum.ScaleType.Crop

local avatarImageCorner = Instance.new("UICorner")
avatarImageCorner.CornerRadius = UDim.new(0, 4)
avatarImageCorner.Parent = avatarImage

-- Load avatar
spawn(function()
local success, thumbnailUrl = pcall(function()
return Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)
if success then
avatarImage.Image = thumbnailUrl
end
end)

-- 3. ✅ USER INFO (TENGAH, SEBELAH AVATAR)
local userInfoFrame = Instance.new("Frame")
userInfoFrame.Name = "UserInfoFrame"
userInfoFrame.Parent = mainFrame
userInfoFrame.Size = UDim2.new(0, 180, 0, 70)
userInfoFrame.Position = UDim2.new(0, 105, 0, 70)
userInfoFrame.BackgroundTransparency = 1

-- User Name
local userLabel = Instance.new("TextLabel")
userLabel.Name = "UserLabel"
userLabel.Parent = userInfoFrame
userLabel.Size = UDim2.new(1, 0, 0, 20)
userLabel.Position = UDim2.new(0, 0, 0, 0)
userLabel.BackgroundTransparency = 1
userLabel.Text = "User: " .. Player.Name
userLabel.TextColor3 = userPageColors.textPrimary
userLabel.Font = Enum.Font.GothamBold
userLabel.TextSize = 14
userLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Days
local daysLabel = Instance.new("TextLabel")
daysLabel.Name = "DaysLabel"
daysLabel.Parent = userInfoFrame
daysLabel.Size = UDim2.new(1, 0, 0, 16)
daysLabel.Position = UDim2.new(0, 0, 0, 20)
daysLabel.BackgroundTransparency = 1
daysLabel.Text = "Days: " .. getAccountAge()
daysLabel.TextColor3 = userPageColors.textSecondary
daysLabel.Font = Enum.Font.Gotham
daysLabel.TextSize = 12
daysLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Date
local dateLabel = Instance.new("TextLabel")
dateLabel.Name = "DateLabel"
dateLabel.Parent = userInfoFrame
dateLabel.Size = UDim2.new(1, 0, 0, 16)
dateLabel.Position = UDim2.new(0, 0, 0, 36)
dateLabel.BackgroundTransparency = 1
dateLabel.Text = getCurrentDate()
dateLabel.TextColor3 = userPageColors.textSecondary
dateLabel.Font = Enum.Font.Gotham
dateLabel.TextSize = 12
dateLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Contact Dev
local contactLabel = Instance.new("TextLabel")
contactLabel.Name = "ContactLabel"
contactLabel.Parent = userInfoFrame
contactLabel.Size = UDim2.new(1, 0, 0, 14)
contactLabel.Position = UDim2.new(0, 0, 0, 52)
contactLabel.BackgroundTransparency = 1
contactLabel.Text = "Contact: clavnnxteam@gmail.com"
contactLabel.TextColor3 = userPageColors.accent
contactLabel.Font = Enum.Font.Gotham
contactLabel.TextSize = 10
contactLabel.TextXAlignment = Enum.TextXAlignment.Center

-- 4. ✅ FPS & PING (POJOK KANAN ATAS)
local statusFrame = Instance.new("Frame")
statusFrame.Name = "StatusFrame"
statusFrame.Parent = mainFrame
statusFrame.Size = UDim2.new(0, 100, 0, 60)
statusFrame.Position = UDim2.new(1, -115, 0, 70)
statusFrame.BackgroundTransparency = 1

-- FPS
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "FPSLabel"
fpsLabel.Parent = statusFrame
fpsLabel.Size = UDim2.new(1, 0, 0, 25)
fpsLabel.Position = UDim2.new(0, 0, 0, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 60"
fpsLabel.TextColor3 = userPageColors.textPrimary
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 12
fpsLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Ping
local pingLabel = Instance.new("TextLabel")
pingLabel.Name = "PingLabel"
pingLabel.Parent = statusFrame
pingLabel.Size = UDim2.new(1, 0, 0, 25)
pingLabel.Position = UDim2.new(0, 0, 0, 25)
pingLabel.BackgroundTransparency = 1
pingLabel.Text = "Ping: " .. getPing()
pingLabel.TextColor3 = userPageColors.textPrimary
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextSize = 12
pingLabel.TextXAlignment = Enum.TextXAlignment.Center

-- 5. ✅ DISCLAIMER (BAWAH AVATAR, BERJEJER KANAN)
local disclaimerLabel = Instance.new("TextLabel")
disclaimerLabel.Name = "DisclaimerLabel"
disclaimerLabel.Parent = mainFrame
disclaimerLabel.Size = UDim2.new(1, -40, 0, 70)
disclaimerLabel.Position = UDim2.new(0, 20, 0, 155)
disclaimerLabel.BackgroundTransparency = 1
disclaimerLabel.Text = "⚠️ Disclaimer: This script is for personal use and entertainment only. Use responsibly. Excessive use may cause lag, crashes, or unwanted effects. Developer is not responsible for any issues, bans, or consequences."
disclaimerLabel.TextColor3 = userPageColors.textSecondary
disclaimerLabel.Font = Enum.Font.Gotham
disclaimerLabel.TextSize = 10
disclaimerLabel.TextXAlignment = Enum.TextXAlignment.Left
disclaimerLabel.TextYAlignment = Enum.TextYAlignment.Top
disclaimerLabel.TextWrapped = true

-- 6. ✅ SERVER INFO (BAGIAN BAWAH DALAM FRAME YANG SAMA)
local serverLabel = Instance.new("TextLabel")
serverLabel.Name = "ServerLabel"
serverLabel.Parent = mainFrame
serverLabel.Size = UDim2.new(1, -40, 0, 25)
serverLabel.Position = UDim2.new(0, 20, 1, -40) -- Dari bawah frame
serverLabel.BackgroundTransparency = 1
serverLabel.Text = "Server: " .. getServerName()
serverLabel.TextColor3 = userPageColors.textPrimary
serverLabel.Font = Enum.Font.Gotham
serverLabel.TextSize = 12
serverLabel.TextXAlignment = Enum.TextXAlignment.Center
serverLabel.TextYAlignment = Enum.TextYAlignment.Center

-- ✅ TYPEWRITER EFFECT untuk Welcome
spawn(function()
wait(0.5)
typewriterEffect(welcomeLabel, "Welcome, " .. Player.Name .. " 👋", 0.05)
end)

-- ✅ UPDATE FPS & PING REAL-TIME
spawn(function()
while page.Parent do
wait(1)
if fpsLabel and fpsLabel.Parent then
  fpsLabel.Text = "FPS: " .. currentFPS
end
if pingLabel and pingLabel.Parent then
  pingLabel.Text = "Ping: " .. getPing()
end
end
end)

return page
end

-- Start FPS Counter
startFPSCounter()
--=== END PAGE USER ===
-- GUI Visibility Toggle dengan Animasi
local function toggleGui()
if not MainFrame then
return
end

isGuiVisible = not isGuiVisible

if isGuiVisible then
-- Show animation - slide in dari atas (TETAP SAMA seperti aslinya)
MainFrame.Visible = true
MainFrame.Position = UDim2.new(0.1, 0, -1, 0)
MainFrame.BackgroundTransparency = 1

local showTween =
TweenService:Create(
MainFrame,
TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
{
  Position = UDim2.new(0.1, 0, 0.1, 0),
  BackgroundTransparency = 0.3
}
)
showTween:Play()
else
-- 🎯 ENHANCED HIDE ANIMATION (Yang ditingkatkan)

-- Step 1: Scale down sedikit + rotate
local prepareHide =
TweenService:Create(
MainFrame,
TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
{
  Size = UDim2.new(0.75, 0, 0.75, 0),
  Rotation = -5
}
)

prepareHide:Play()
prepareHide.Completed:Connect(
function()
  -- Step 2: Slide out ke atas + fade out + scale down lebih lanjut
  local hideAnimation =
  TweenService:Create(
  MainFrame,
  TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
  {
    Position = UDim2.new(0.1, 0, -1.2, 0), -- Slide keluar lebih jauh
    BackgroundTransparency = 1, -- Fade out
    Size = UDim2.new(0.5, 0, 0.5, 0), -- Scale down lagi
    Rotation = -10 -- Rotate lebih
  }
  )

  hideAnimation:Play()
  hideAnimation.Completed:Connect(
  function()
    MainFrame.Visible = false

    -- Reset properties untuk show berikutnya
    MainFrame.Size = UDim2.new(0.8, 0, 0.8, 0)
    MainFrame.Rotation = 0
    MainFrame.BackgroundTransparency = 0.3
  end
  )
end
)
end
end
-- Main GUI Setup dengan Smooth Tab Transitions
local function setupGui()
local mainFrame, tabFrame, contentFrame = createMainGui()

-- Tambahkan User tab di posisi pertama
local userTab = createTabButton(tabFrame, "User", 1)
local mainTab = createTabButton(tabFrame, "Main", 2)
local itemTab = createTabButton(tabFrame, "Items", 3)
local visualTab = createTabButton(tabFrame, "Visual", 4)
local infoTab = createTabButton(tabFrame, "Info", 5)
local settingsTab = createTabButton(tabFrame, "Settings", 6)

-- Tambahkan User page
local userPage = createUserPage(contentFrame)
local mainPage = createMainPage(contentFrame)
local itemPage = createItemPage(contentFrame)
local visualPage = createVisualPage(contentFrame)
local infoPage = createInfoPage(contentFrame)
local settingsPage = createSettingsPage(contentFrame)

-- Store semua pages dan tabs
local allPages = {
["User"] = userPage,
["Main"] = mainPage,
["Items"] = itemPage,
["Visual"] = visualPage,
["Info"] = infoPage,
["Settings"] = settingsPage
}

local allTabs = {
["User"] = userTab,
["Main"] = mainTab,
["Items"] = itemTab,
["Visual"] = visualTab,
["Info"] = infoTab,
["Settings"] = settingsTab
}

-- Variables untuk animasi
local isTransitioning = false
local currentPage = nil

-- ✨ FUNGSI SMOOTH PAGE TRANSITION
local function showPage(pageName)
if isTransitioning then
  return
end
if currentTab == pageName then
  return
end

isTransitioning = true
local targetPage = allPages[pageName]
local targetTab = allTabs[pageName]

if not targetPage or not targetTab then
  isTransitioning = false
  return
end

-- Update tab colors dengan animasi
for name, tab in pairs(allTabs) do
  local targetColor = (name == pageName) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 40)
  local tabTween =
  TweenService:Create(
  tab,
  TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
  {BackgroundColor3 = targetColor}
  )
  tabTween:Play()
end

-- Hide all pages first
for _, page in pairs(allPages) do
  page.Visible = false
end

-- Show target page with animation
targetPage.Visible = true
targetPage.Position = UDim2.new(1.2, 0, 0, 0)

local slideIn =
TweenService:Create(
targetPage,
TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
{Position = UDim2.new(0, 0, 0, 0)}
)

slideIn:Play()
slideIn.Completed:Connect(
function()
  isTransitioning = false
end
)

currentPage = targetPage
currentTab = pageName
end

-- ✨ FUNGSI HOVER EFFECTS UNTUK TABS
local function addTabHoverEffects(tab, tabName)
tab.MouseEnter:Connect(
function()
  if currentTab ~= tabName then
    local hoverTween =
    TweenService:Create(
    tab,
    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {Size = UDim2.new(0.17, 0, 1.05, 0)}
    )
    hoverTween:Play()
  end
end
)

tab.MouseLeave:Connect(
function()
  if currentTab ~= tabName then
    local leaveTween =
    TweenService:Create(
    tab,
    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {Size = UDim2.new(0.155, 0, 1, 0)}  -- Updated size untuk 6 tabs
    )
    leaveTween:Play()
  end
end
)
end

-- Apply hover effects
for name, tab in pairs(allTabs) do
addTabHoverEffects(tab, name)
end

-- Connect tab click events
userTab.MouseButton1Click:Connect(function() showPage("User") end)
mainTab.MouseButton1Click:Connect(function() showPage("Main") end)
itemTab.MouseButton1Click:Connect(function() showPage("Items") end)
visualTab.MouseButton1Click:Connect(function() showPage("Visual") end)
infoTab.MouseButton1Click:Connect(function() showPage("Info") end)
settingsTab.MouseButton1Click:Connect(function() showPage("Settings") end)

-- ✨ SHOW USER PAGE IMMEDIATELY (DEFAULT)
spawn(
function()
wait(0.2)

-- Set current values
currentTab = "User"
currentPage = userPage

-- Set user tab active
userTab.BackgroundColor3 = Color3.fromRGB(0, 150, 255)

-- Show user page
userPage.Visible = true
userPage.Position = UDim2.new(0, 0, 0, 0)

-- Hide others
mainPage.Visible = false
itemPage.Visible = false
visualPage.Visible = false
infoPage.Visible = false
settingsPage.Visible = false

print("✅ User page displayed successfully!")
end
)
end
-- Main execution
Player.CharacterAdded:Connect(
function(character)
-- Wait for 1 second to ensure the character is fully loaded
wait(1)

-- Reset feature toggles to false on respawn
for k, v in pairs(features) do
features[k] = false
end
-- Reset Kill Aura specific
KillAuraEnabled = false
if KillAuraConnection then
KillAuraConnection:Disconnect()
KillAuraConnection = nil
end

-- Clear attack timers
LastAttackTime = {}
-- Reset Auto Farm
AutoFarmEnabled = false
if AutoFarmConnection then
AutoFarmConnection:Disconnect()
AutoFarmConnection = nil
end
ProcessedTrees = {}
CurrentTargets = {}
TreesChopped = 0
FarmAttackCount = 0

WeatherEnabled = false
if WeatherConnection then
WeatherConnection:Disconnect()
WeatherConnection = nil
end

-- Reset No Fog
NoFogEnabled = false
if NoFogConnection then
NoFogConnection:Disconnect()
NoFogConnection = nil
end
originalFogStart, originalFogEnd, originalFogColor = nil, nil, nil

-- Reset FPS Boost
FPSBoostEnabled = false
if FPSBoostConnection then
FPSBoostConnection:Disconnect()
FPSBoostConnection = nil
end
originalSettings = {}

-- Reset customFOV & Night Vision
CustomFOVEnabled = false  -- ✅ VARIABLE NAME SESUAI
if originalFOV then
Camera.FieldOfView = originalFOV
end

NightVisionEnabled = false
if NightVisionConnection then
NightVisionConnection:Disconnect()
NightVisionConnection = nil
end
originalAmbient, originalOutdoorAmbient = nil, nil

-- Reset God Mode specific
if GodModeEnabled then
DisableGodMode()
end
GodModeEnabled = false
GodModeConnections = {}
OriginalTransparencies = {}
ClonedCharacter = nil
ClonedHRP = nil
ClonedHumanoid = nil

-- Reset Infinite Hunger
InfiniteHungerEnabled = false
if HungerConnection then
HungerConnection:Disconnect()
HungerConnection = nil
end
if originalSetAttribute then
Player.SetAttribute = originalSetAttribute
originalSetAttribute = nil
end
hungerAttributeName = nil
frozenHungerValue = nil

-- Reset ESP system
ESPSystem.enabled = {animals = false, npcs = false, items = false}
ESPSystem.selected = {animals = {}, npcs = {}, items = {}}
-- Clean up active ESP
for espKey, espList in pairs(ESPSystem.activeESP) do
if espList then
  for _, espData in pairs(espList) do
    pcall(function()
    if espData.billboard then espData.billboard:Destroy() end
    if espData.line then espData.line:Destroy() end
    if espData.attachment0 then espData.attachment0:Destroy() end
    if espData.attachment1 then espData.attachment1:Destroy() end
    end)
  end
end
end
ESPSystem.activeESP = {}

-- Reset Hitbox system
HitboxSystem.enabled = false
HitboxSystem.selectedTarget = nil
if HitboxConnection then
HitboxConnection:Disconnect()
HitboxConnection = nil
end
clearAllHitboxes()

-- Reset Item List System
ItemListSystem.autoUpdateEnabled = false
if ItemListSystem.countdownConnection then
ItemListSystem.countdownConnection:Disconnect()
ItemListSystem.countdownConnection = nil
end
ItemListSystem.items = {}

-- Recreate GUI to reflect initial state
if ClavnnXGui then
ClavnnXGui:Destroy()
end
setupGui()
end
)

Player.CharacterAdded:Connect(
function(character)
wait(1)
if settings.jumpPower then
local hum = character:WaitForChild("Humanoid", 3)
if hum then
  hum.JumpPower = settings.jumpPower
end
end
end
)
wait(7.5) -- Simple wait - loading takes 6 seconds + 1.5 buffer
print("🎯 ClavnnX Main GUI Starting...")
-- Initial GUI setup
setupGui()
-- Start persistent monitors
startPersistentMonitor()
detectRevive()
-- Show ready notification
showNotification("ClavnnX Ready - Features will persist!", 3)
task.spawn(
function()
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
-- 🔵 Buat ScreenGui khusus tombol
local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "ToggleClavnnXGui"
toggleGui.ResetOnSpawn = false
toggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
toggleGui.Parent = playerGui
-- 🟦 Tombol Show/Hide
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleClavnnXButton"
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(1, -50, 0.5, -20)
toggleButton.AnchorPoint = Vector2.new(1, 0.5)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
toggleButton.BackgroundTransparency = 0
toggleButton.Text = "CLX"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.ZIndex = 999
toggleButton.Active = true
toggleButton.Draggable = true
toggleButton.Parent = toggleGui -- ✅ Parent ke ScreenGui!
-- 🔘 Tambahkan lingkaran
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = toggleButton
-- ⚙️ Fungsi show/hide GUI
toggleButton.MouseButton1Click:Connect(
function()
local gui = playerGui:FindFirstChild("ClavnnXGui")
if gui then
  gui.Enabled = not gui.Enabled
end
end
)
print("✅ Toggle button berhasil dibuat")
end
)
-- Cleanup on exit
game.Players.PlayerRemoving:Connect(
function(player)
if player == Player then
if ClavnnXGui then
  ClavnnXGui:Destroy()
end
end
end
)
-- Update player list secara otomatis
spawn(
function()
while wait(5) do -- Update setiap 5 detik
-- Update hanya jika GUI sudah dibuat dan tab Main sedang aktif
if ClavnnXGui and currentTab == "Main" then
  pcall(
  function()
    -- Cari teleport container
    local mainPage =
    ClavnnXGui:FindFirstChild("MainFrame"):FindFirstChild("ContentFrame"):FindFirstChild(
    "MainPage"
    )
    if mainPage then
      local rightColumn = mainPage:FindFirstChild("RightColumn")
      if rightColumn then
        local teleportContainer = rightColumn:FindFirstChild("TeleportContainer")
        if teleportContainer then
          -- Cari listbox "TP to Player"
          for _, child in pairs(teleportContainer:GetChildren()) do
            if child:IsA("Frame") and child.Name:find("TP to Player") then
              local scrollFrame = child:FindFirstChild("ScrollFrame")
              if scrollFrame then
                -- Hapus tombol lama
                for _, btn in pairs(scrollFrame:GetChildren()) do
                  if btn:IsA("TextButton") then
                    btn:Destroy()
                  end
                end

                -- Buat tombol baru dengan daftar player terbaru
                local playerList = getPlayerList()
                if #playerList == 0 then
                  playerList = {"No Players"}
                end

                for i, playerName in ipairs(playerList) do
                  local itemButton = Instance.new("TextButton")
                  itemButton.Name = "Item" .. i
                  itemButton.Parent = scrollFrame
                  itemButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                  itemButton.BorderSizePixel = 0
                  itemButton.Size = UDim2.new(1, 0, 0, 25)
                  itemButton.Font = Enum.Font.Gotham
                  itemButton.Text = playerName
                  itemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                  itemButton.TextScaled = true

                  local itemCorner = Instance.new("UICorner")
                  itemCorner.CornerRadius = UDim.new(0, 4)
                  itemCorner.Parent = itemButton

                  -- Event click untuk teleport
                  if playerName ~= "No Players" then
                    itemButton.MouseButton1Click:Connect(
                    function()
                      teleportToPlayer(playerName)
                    end
                    )
                  end
                end

                -- Update canvas size
                scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #playerList * 27)
              end
              break
            end
          end
        end
      end
    end
  end
  )
end
end
end
)
print("ClavnnX Script loaded successfully!")
print("Made for 99 Nights in the Forest")
print("Optimized for mobile devices")
print("Version: 1.0")
print("Toggle button dibuat:", toggleButton)
