       --/---------------------------------\--
              --//         MADE BY KHLAT          \\--
             --//   SUPER-FAST PUMPKIN COLLECTOR   \\--
            --//   IF IT DOSENT WORK JUST MAKE IT   \\--
           --//    RUN FOR 5 MINUTES IF IT DOSENT    \\--
          --//     WORK THEN CHANGE CAR TO  GROUP     \\--
          --//      CAR IF IT DOSENT WORK JUMP OUT      \\--
        --//       OF THE CAR  (F) AND RELOAD CAR       \\--
      --/--------------------------------------------------\--



local Players        = game:GetService("Players")
local CollectionSvc  = game:GetService("CollectionService")
local TweenService   = game:GetService("TweenService")
local RunService     = game:GetService("RunService")
local plr   = Players.LocalPlayer
local char  = plr.Character or plr.CharacterAdded:Wait()
local root  = char:WaitForChild("HumanoidRootPart")
local hum   = char:WaitForChild("Humanoid")
local function getVehicle()
    if hum.SeatPart then
        local car = hum.SeatPart.Parent
        car.PrimaryPart = car.Body:WaitForChild("#Weight")
        return car
    end
    return nil
end
-- change the settings if you need (dont edit it if no skill nigga)
local car = getVehicle()
local TWEEN_TIME      = 0.7   -- seconds (0.1 = VERY fast, 0.3 = smooth)
local CHECK_INTERVAL  = 0.9    -- how often we look for a new target
local MIN_DISTANCE    = 8      -- ignore if already close
local HEIGHT_OFFSET   = 4      -- how high above Root to stop
local ROOT_TAG        = "FastRootTween"
local function tagRoots()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("TouchTransmitter") and obj.Parent and obj.Parent.Name == "Root" then
            local part = obj.Parent
            if part:IsA("BasePart") then
                CollectionSvc:AddTag(part, ROOT_TAG)
            end
        end
    end
end
tagRoots()
workspace.DescendantAdded:Connect(function(desc)
    if desc:IsA("TouchTransmitter") and desc.Parent and desc.Parent.Name == "Root" then
        task.wait()
        local part = desc.Parent
        if part:IsA("BasePart") then
            CollectionSvc:AddTag(part, ROOT_TAG)
        end
    end
end)
local collected = {} 
local currentTween = nil
task.spawn(function()
    while task.wait(CHECK_INTERVAL) do
        if not (char and char.Parent and hum.Health > 0) then break end
        if not car then car = getVehicle() end
        if not car then continue end
        local myPos = root.Position
        local closest, dist = nil, math.huge
        for _, part in ipairs(CollectionSvc:GetTagged(ROOT_TAG)) do
            if part and part.Parent and not collected[part] then
                local d = (myPos - part.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = part
                end
            end
        end
        if closest and dist > MIN_DISTANCE then
            collected[closest] = true
            if currentTween then
                currentTween:Cancel()
            end
            local goal = { CFrame = closest.CFrame * CFrame.new(0, HEIGHT_OFFSET, 0) }
            local tweenInfo = TweenInfo.new(
                TWEEN_TIME,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.Out,
                0,
                false,
                0
            )
            currentTween = TweenService:Create(car.PrimaryPart, tweenInfo, goal)
            currentTween:Play()
            task.spawn(function()
                currentTween.Completed:Wait()
            end)
        end
    end
end)

print("Super-fast TWEEN Root collector ACTIVE! (Time: " .. TWEEN_TIME .. "s
)")
