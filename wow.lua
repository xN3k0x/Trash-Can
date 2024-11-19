repeat wait() until game:IsLoaded()
wait(8)
local Run
Run = function()
    game:service'Players'.LocalPlayer.Idled:connect(function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new(0, 0))
    end)
        
    setsimulationradius(math.huge,math.huge)

    -- // Config \\ --
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    local Config = {
        Skills = {"Z","X","C","V"},
        Stats = {"strength","health","agility"},
        Bosses = {"Eto Yoshimura","Headless","Kaneki","Juuzou"},
        Raids = {"Arima","Prime Arima","Noro","Kuzen"},
        FarRaid = {
            ["Noro"] = true,
        },
        Mobs = {
            {
                StartLvl = 1, EndLvl = 40,
                Mob = "Low Ranked Ghoul",
                Quest = game:GetService("Workspace").dialogues.LowQuest.ProximityEvent,
            },
            {
                StartLvl = 41, EndLvl = 80,
                Mob = "Medium Ranked Ghoul",
                Quest = game:GetService("Workspace").dialogues.MediumQuest.ProximityEvent
            },
            {
                StartLvl = 81, EndLvl = 180,
                Mob = "High Ranked Ghoul",
                Quest = game:GetService("Workspace").dialogues.StrongQuest.ProximityEvent
            },
            {
                StartLvl = 181, EndLvl = 300,
                Mob = "Low Ranked Aogiri",
                Quest = game:GetService("Workspace").dialogues.LowAogiriQuest.ProximityEvent
            },
            {
                StartLvl = 301, EndLvl = 400,
                Mob = "Medium Ranked Aogiri",
                Quest = game:GetService("Workspace").dialogues.MediumAogiriQuest.ProximityEvent
            },
            {
                StartLvl = 401, EndLvl = 500,
                Mob = "High Ranked Aogiri",
                Quest = game:GetService("Workspace").dialogues.HighAogiriQuest.ProximityEvent
            },
            {
                StartLvl = 501, EndLvl = 700,
                Mob = "High Ranked White Suit",
                Quest = game:GetService("Workspace").dialogues.WhiteSuitsQuest.ProximityEvent
            },
            {
                StartLvl = 701, EndLvl = 900,
                Mob = "Cleaner",
                Quest = game:GetService("Workspace").dialogues.VQuest.ProximityEvent
            },
        }
    }
    
    Config.NPC = {}
    for i,v in pairs(game:GetService("Workspace").dialogues:GetChildren()) do
        table.insert(Config.NPC,v.Name)
    end
    
    Config.Marker = {}
    for i,v in pairs(game:GetService("Workspace").GUIMarkers:GetChildren()) do
        table.insert(Config.Marker,v.BillboardGui.TextLabel.Text)
    end
    
    -- // Modules \\ --
    local LoopPrioritizer = (function()
        local LoopPrioritizer = {}
    
        function LoopPrioritizer:Create(Table)
            self.RenderStepped = game:GetService("RunService").RenderStepped
            self.Priority = {}
    
            for i = 1,#Table do
                LoopPrioritizer:Add(i,Table[i])
            end
    
            self.Connection = self.RenderStepped:Connect(function()
                local PassesPriority = {[0] = true}
                for i,v in ipairs(self.Priority) do
                    if PassesPriority[LoopPrioritizer:GetHigherPriority(i)] then
                        local Return = LoopPrioritizer:Call(v)
                        if Return then
                            PassesPriority[i] = true
                        end
                    end
                end
            end)
    
            return self
        end
    
        function LoopPrioritizer:GetHigherPriority(PriorityLevel)
            local OldPriority
            for i,v in ipairs(self.Priority) do
                if i == PriorityLevel then
                    if OldPriority then
                        return OldPriority
                    else
                        return 0
                    end
                end
                OldPriority = i
            end
        end
    
        function LoopPrioritizer:Add(PriorityLevel, Function)
            self.Priority[PriorityLevel] = Function
        end
    
        function LoopPrioritizer:Call(Function)
            local Return
            coroutine.resume(coroutine.create(function()
                Return = Function()
            end))
            return Return
        end
    
        return LoopPrioritizer
    end)()
    
    local CHR = (function()
        local CHR = {}
        local NoClipParts = {}
        local Freeze = false
        local NoClip = false
    
        function CHR:TP(CFrame)
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame
        end
    
        function CHR:Freeze()
            Freeze = true
        end
    
        function CHR:UnFreeze()
            Freeze = false
        end
    
        function CHR:Noclip()
            NoClip = true
        end
    
        function CHR:UnNoclip()
            NoClip = false
        end
    
        game:GetService("RunService").Heartbeat:Connect(function()
            if Freeze then
                local HMNDRP = LocalPlayer.Character.HumanoidRootPart
                HMNDRP.Velocity = Vector3.new(0, 0, 0)
                HMNDRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                HMNDRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
            if NoClip then
                for i,v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide == true and v.Name ~= floatName then
                        v.CanCollide = false
                        if not table.find(NoClipParts, v) then
                            table.insert(NoClipParts, v)
                        end
                    end
                end
            else
                if #NoClipParts > 0 then
                    for i,v in pairs(NoClipParts) do
                        NoClipParts.CanCollide = true
                    end
                    table.clear(NoClipParts)
                end
            end
        end)
    
        return CHR
    end)()
    
    -- // UI Library \\ --
    
    local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))()
    local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua'))()
    
    local Window = Library:CreateWindow({
        Title = "Project Ghoul | WWz",
        Center = true,
        AutoShow = false,
        TabPadding = 8
    })
    
    local Tabs = {
        ["Main"] = Window:AddTab("Main"),
        ["Credits"] = Window:AddTab("Credits"),
    }
    
    local AutoFarmGroupBox = Tabs.Main:AddLeftGroupbox('Auto Farms')
    local SelectMethod = AutoFarmGroupBox:AddDropdown('Select Method', {
        Values = {"Under","Above","Behind"},
        Default = 1,
        Multi = false,
        Text = 'Select Method',
    })
    local SelectSkills = AutoFarmGroupBox:AddDropdown('Select Skills', {
        Values = Config.Skills,
        Default = 1,
        Multi = true,
        Text = 'Select Skills',
    })
    local Distance = AutoFarmGroupBox:AddSlider('MySlider', {
        Text = 'Distance',
        Default = 16.5,
        Min = 3,
        Max = 40,
        Rounding = 1,
        Compact = false,
    })
    local AutoHit = AutoFarmGroupBox:AddToggle('Auto Hit', {
        Text = 'Auto Hit',
        Default = true,
    })
    local AutoSkill = AutoFarmGroupBox:AddToggle('Auto Skill', {
        Text = 'Auto Skill',
        Default = true,
    })
    local AutoGetQuest = AutoFarmGroupBox:AddToggle('Auto Get Quest', {
        Text = 'Auto Get Quest',
        Default = true,
    })
    local FullAutoFarm = AutoFarmGroupBox:AddToggle('Full Auto Farm', {
        Text = 'Full Auto Farm',
        Default = false,
        Callback = function(Value)
            if not Value then
                CHR:UnNoclip()
                CHR:UnFreeze()
            end
        end
    })
    
    local AutoBloodLabGroupBox = Tabs.Main:AddRightGroupbox('Auto Blood Lab')
    local AutoBloodLab = AutoBloodLabGroupBox:AddToggle('Auto Blood Labb', {
        Text = 'Auto Blood Lab',
        Default = false,
        Callback = function(Value)
            if not Value then
                CHR:UnNoclip()
                CHR:UnFreeze()
            end
        end
    })
    local AutoReplay = AutoBloodLabGroupBox:AddToggle('Auto Replay', {
        Text = 'Auto Replay',
        Default = true,
    })

    local AutoRaidsGroupBox = Tabs.Main:AddRightGroupbox('Auto Raids')
    local SelectRaids = AutoRaidsGroupBox:AddDropdown('Select Raids', {
        Values = Config.Raids,
        Default = 0,
        Multi = true,
        Text = 'Select Raids',
    })
    local AutoRaid = AutoRaidsGroupBox:AddToggle('Auto Raid', {
        Text = 'Auto Raid',
        Default = false,
        Callback = function(Value)
            if not Value then
                CHR:UnNoclip()
                CHR:UnFreeze()
            end
        end
    })

    local AutoBossesGroupBox = Tabs.Main:AddRightGroupbox('Auto Bosses')
    local SelectBosses = AutoBossesGroupBox:AddDropdown('Select Bosses', {
        Values = Config.Bosses,
        Default = 0,
        Multi = true,
        Text = 'Select Bosses',
    })
    local AutoBosses = AutoBossesGroupBox:AddToggle('Auto Bosses', {
        Text = 'Auto Bosses',
        Default = false,
        Callback = function(Value)
            if not Value then
                CHR:UnNoclip()
                CHR:UnFreeze()
            end
        end
    })
    
    local AutoStatsGroupBox = Tabs.Main:AddLeftGroupbox('Auto Stats')
    local SelectStats = AutoStatsGroupBox:AddDropdown('Select Method', {
        Values = Config.Stats,
        Default = 0,
        Multi = true,
        Text = 'Select Stats',
    })
    local AutoStats = AutoStatsGroupBox:AddToggle('Auto Stats', {
        Text = 'Auto Stats',
        Default = false,
    })
    
    local TeleportGroupBox = Tabs.Main:AddLeftGroupbox('Teleports')
    local SelectNPC = TeleportGroupBox:AddDropdown('Select NPC', {
        Values = Config.NPC,
        Default = 0,
        Multi = false,
        Text = 'Select NPC',
        Callback = function(Value)
            if Value then
                CHR:TP(game:GetService("Workspace").dialogues[Value].HumanoidRootPart.CFrame * CFrame.new(0,3,0))
            end
        end
    })
    local SelectMark = TeleportGroupBox:AddDropdown('Select Mark', {
        Values = Config.Marker,
        Default = 0,
        Multi = false,
        Text = 'Select Mark',
        Callback = function(Value)
            for i,v in pairs(game:GetService("Workspace").GUIMarkers:GetChildren()) do
                if v.BillboardGui.TextLabel.Text == Value then
                    CHR:TP(v.CFrame * CFrame.new(0,3,0))
                    break
                end
            end
        end
    })
    
    SaveManager:SetLibrary(Library)
    SaveManager:SetFolder('WWz/PG')
    SaveManager:BuildConfigSection(Tabs.Credits)
    SaveManager:LoadAutoloadConfig()
    
    -- // Run \\ --
    queue_on_teleport(game:HttpGet("https://raw.githubusercontent.com/xN3k0x/Trash-Can/refs/heads/main/wow.lua"))

    local VirtualUser = game:GetService("VirtualUser")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    
    local QuestDB = false
    local WeaponDB = false
    local SkillDB = false
    local StatDB = false
    local RaidDB = false
    local BloodLabDB = false
    
    local CurrentRaid
    local CurrentMob
    
    local function Press(KeyCode)
        VirtualInputManager:SendKeyEvent(true, KeyCode, false, nil)
        VirtualInputManager:SendKeyEvent(false, KeyCode, false, nil)
    end
    
    local function Click()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(0, 0))
    end
    
    local function GetLevel()
        return LocalPlayer.data.stats.level.Value
    end
    
    local function EquipWeapon()
        if not LocalPlayer.data.notSavable.weaponEquipped.Value then
            game:GetService("ReplicatedStorage").Events.RemoteEvent:FireServer("RequestEquip")
        end
    end
    
    local function HitandSkill()
        if AutoSkill.Value and not SkillDB then
            SkillDB = true; delay(0.6,function()SkillDB = false end)
            for i,v in pairs(SelectSkills.Value) do
                Press(Enum.KeyCode[i])
            end
        end
        if AutoHit.Value and not WeaponDB then
            WeaponDB = true; delay(0.4,function()WeaponDB = false end)
            Click()
        end
    end
    
    local function ClickOn(X,Y)
        mousemoveabs(X,Y)
        task.wait()
        mousemoveabs(X+5,Y+5)
        task.wait()
        mousemoveabs(X,Y)
        mouse1click(X,Y)
    end
    
    local function TPMob(Mob)
        if SelectMethod.Value == "Under" then
            CHR:TP(Mob.HumanoidRootPart.CFrame * CFrame.new(0,-Distance.Value,0) * CFrame.Angles(math.rad(90),0,0))
        elseif SelectMethod.Value == "Above" then
            CHR:TP(Mob.HumanoidRootPart.CFrame * CFrame.new(0,Distance.Value,0) * CFrame.Angles(math.rad(-90),0,0))
        else
            CHR:TP(Mob.HumanoidRootPart.CFrame * CFrame.new(0,0,Distance.Value))
        end
    end
    
    local function GetQuest(Data)
        if QuestDB then return end
        QuestDB = true; delay(0.5,function() QuestDB = false end)
        local Level = GetLevel()
        CHR:TP(Data.Quest.Parent.HumanoidRootPart.CFrame * CFrame.new(0,0,-2))
        if not LocalPlayer.PlayerGui:FindFirstChild("DialogGui") then
            Data.Quest:FireServer()
        else
           for i,v in ipairs(LocalPlayer.PlayerGui.DialogGui.Frame.Options:GetChildren()) do
                if v:IsA("TextButton") and string.find(v.Text,"ACCEPT") then
                    if isrbxactive() then
                        local X = v.AbsolutePosition.X+(v.AbsoluteSize.X/2)
                        local Y = v.AbsolutePosition.Y+(v.AbsoluteSize.Y/2)+80
                        ClickOn(X,Y)
                    end
                    break
                end
            end
        end
    end
    
    local Manager = LoopPrioritizer:Create({
        function() -- Auto Stats
            if AutoStats.Value and not StatDB then
                StatDB = true delay(0.2,function()StatDB = false end)
                for i,v in pairs(SelectStats.Value) do
                    if LocalPlayer.data.stats.points.Value <= 0 then break end
                    game:GetService("ReplicatedStorage").Events.RemoteEvent:FireServer("spendStatPoint", {["stat"] = i,["amount"] = 1})
                end
            end
            return true
        end,
        function() -- Auto Bosses
            if AutoBosses.Value then
                for i,v in pairs(SelectBosses.Value) do
                    if game:GetService("Workspace").NPCs.Alive:FindFirstChild(i) and game:GetService("Workspace").NPCs.Alive[i].Humanoid.Health > 0 then
                        CHR:Noclip()
                        CHR:Freeze()
                        EquipWeapon()
                        TPMob(game:GetService("Workspace").NPCs.Alive[i])
                        HitandSkill()
                        return false
                    end
                end
                return true
            else
                return true
            end
        end,
        function() -- Auto Raid
            if AutoRaid.Value then
                local IsBoss = false
                if (string.find(LocalPlayer.PlayerGui.HUD["raid_timer"].Text,"LEFT") and CurrentRaid == "Noro") or (CurrentRaid and game:GetService("Workspace").NPCs.Alive:FindFirstChild(CurrentRaid) and game:GetService("Workspace").NPCs.Alive[CurrentRaid].Humanoid.Health > 0) then
                    CHR:Noclip()
                    CHR:Freeze()
                    EquipWeapon()
                    TPMob(game:GetService("Workspace").NPCs.Alive:FindFirstChild(CurrentRaid))
                    HitandSkill()
                    IsBoss = true
                else
                    for i,v in pairs(SelectRaids.Value) do
                        if game:GetService("Workspace").GameObjects.RaidBoss[i]:FindFirstChild("Main") then
                            if not string.find(game:GetService("Workspace").GameObjects.RaidBoss[i].Main.BillboardGui.TextLabel.Text,"ON CD") then
                                CurrentRaid = i
                                CHR:TP(game:GetService("Workspace").GameObjects.RaidBoss[i].Main.CFrame * CFrame.new(0,-3,0))
                                IsBoss = true
                                break
                            end
                        else
                            CHR:TP(game:GetService("Workspace").GUIMarkers[i].CFrame)
                        end
                    end
                end
                --print(IsBoss)
                if not IsBoss then return true end
            else
                return true
            end
        end,
        function() -- Auto Blood Lab
            if AutoBloodLab.Value then
                if game:GetService("ReplicatedStorage").BloodLaboratory.Value == false then
                    if not game:GetService("Workspace").GameObjects:FindFirstChild("BloodLabRaid") then
                        CHR:TP(CFrame.new(2101.161865234375,388.61224365234375,661.4117431640625))
                    end
                    CHR:TP(game:GetService("Workspace").GameObjects.BloodLabRaid.CFrame * CFrame.new(0,-5,0))
                else
                    if BloodLabDB == false and LocalPlayer.PlayerGui:FindFirstChild("DialogGui") then
                        BloodLabDB = true delay(3,function() BloodLabDB = false end)
                        local Button
                        for i,v in ipairs(LocalPlayer.PlayerGui.DialogGui.Frame.Options:GetChildren()) do
                            if v:IsA("TextButton") then
                                if v.Text == "REPLAY" and AutoReplay.Value then
                                    Button = v
                                    break
                                elseif Button == nil then
                                    Button = v
                                end
                            end
                        end
                        local X = Button.AbsolutePosition.X+(Button.AbsoluteSize.X/2)
                        local Y = Button.AbsolutePosition.Y+(Button.AbsoluteSize.Y/2)+80
                        ClickOn(X,Y)
                    end
                    if CurrentMob and CurrentMob:FindFirstChild("Humanoid") and CurrentMob.Humanoid.Health > 0 and CurrentMob:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.Anchored = false
                        CHR:Noclip()
                        CHR:Freeze()
                        EquipWeapon()
                        TPMob(CurrentMob)
                        HitandSkill()
                    else
                        for i,v in pairs(game:GetService("Workspace").NPCs.Alive:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and v:FindFirstChild("red") then
                                CurrentMob = v
                                break
                            end
                        end
                        LocalPlayer.Character.HumanoidRootPart.Anchored = true
                    end
                end
            else
                return true
            end
        end,
        function() -- Full Auto Farm
            if FullAutoFarm.Value then
                local Level = GetLevel()
                for i,Data in ipairs(Config.Mobs) do
                    if Data.StartLvl <= Level and Data.EndLvl >= Level then
                        if (AutoGetQuest.Value and string.find(string.lower(LocalPlayer.data.questData.Value),string.lower(Data.Mob)) or (i == 3 and string.find(LocalPlayer.data.questData.Value,"Strong"))) or not AutoGetQuest.Value then
                            if CurrentMob and CurrentMob:FindFirstChild("Humanoid") and CurrentMob.Humanoid.Health > 0 then
                                CHR:Noclip()
                                CHR:Freeze()
                                EquipWeapon()
                                TPMob(CurrentMob)
                                HitandSkill()
                            else
                                for i,v in pairs(game:GetService("Workspace").NPCs.Alive:GetChildren()) do
                                    if string.find(string.lower(v.VisualName.Value),string.lower(Data.Mob)) and v.Humanoid.Health > 0 then
                                        CurrentMob = v
                                        break
                                    end
                                end
                                CHR:TP(Data.Quest.Parent.HumanoidRootPart.CFrame * CFrame.new(0,0,-2))
                            end
                        else
                            GetQuest(Data)
                        end
            
                        break
                    end
                end
            else
                return true
            end
        end,
    })
end

Run()
