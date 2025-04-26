--[[
local _p = game:WaitForChild("Players")
local _plr = _p.ChildAdded:Wait()
if _plr == _p.LocalPlayer then
	_plr.ChildAdded:Connect(function(cccc)
		if c.Name == "PlayerScriptsLoader" then
			c.Disabled = true
		end
	end)
end
]]
local originalMouseSensitivity = nil
local originalTouchSensitivity = nil
local player = game:GetService("Players").LocalPlayer

-- Function to store original values
local function storeOriginalValues()
    originalMouseSensitivity = MOUSE_SENSITIVITY
    originalTouchSensitivity = TOUCH_SENSITIVTY
end

-- Function to reset to original values
local function resetSensitivity()
    if originalMouseSensitivity then
        MOUSE_SENSITIVITY = originalMouseSensitivity
    end
    if originalTouchSensitivity then
        TOUCH_SENSITIVTY = originalTouchSensitivity
    end
end

-- Function to apply your custom sensitivity
local function applyCustomSensitivity()
    -- Modify these values to your desired sensitivity
    MOUSE_SENSITIVITY = Vector2.new(0.003 * math.pi, 0.002 * math.pi) -- Example increased sensitivity
    TOUCH_SENSITIVTY = Vector2.new(0.012 * math.pi, 0.0045 * math.pi) -- Example increased sensitivity
end

-- Character added/removed handlers
local function onCharacterAdded(character)
    -- Wait for humanoid to exist
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Apply custom sensitivity when character is ready
    applyCustomSensitivity()
    
    -- Track death
    humanoid.Died:Connect(function()
        resetSensitivity()
    end)
end

local function onCharacterRemoving(character)
    resetSensitivity()
end

-- Initial setup
storeOriginalValues()

-- Connect events
player.CharacterAdded:Connect(onCharacterAdded)
player.CharacterRemoving:Connect(onCharacterRemoving)

-- Handle initial character if it exists
if player.Character then
    onCharacterAdded(player.Character)
end

repeat wait()
a = pcall(function()
	game:WaitForChild("Players").LocalPlayer:WaitForChild("PlayerScripts").ChildAdded:Connect(function(c)
		if c.Name == "PlayerScriptsLoader"then
			c.Disabled = true
		end
	end)
	end)
	if a == true then break end
until true == false
game:WaitForChild("Players").LocalPlayer:WaitForChild("PlayerScripts").ChildAdded:Connect(function(c)
	if c.Name == "PlayerScriptsLoader"then
		c.Disabled = true
	end
end)


function _CameraUI()
	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	
	local LocalPlayer = Players.LocalPlayer
	if not LocalPlayer then
		Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		LocalPlayer = Players.LocalPlayer
	end
	
	local function waitForChildOfClass(parent, class)
		local child = parent:FindFirstChildOfClass(class)
		while not child or child.ClassName ~= class do
			child = parent.ChildAdded:Wait()
		end
		return child
	end
	
	local PlayerGui = waitForChildOfClass(LocalPlayer, "PlayerGui")
	
	local TOAST_OPEN_SIZE = UDim2.new(0, 326, 0, 58)
	local TOAST_CLOSED_SIZE = UDim2.new(0, 80, 0, 58)
	local TOAST_BACKGROUND_COLOR = Color3.fromRGB(32, 32, 32)
	local TOAST_BACKGROUND_TRANS = 0.4
	local TOAST_FOREGROUND_COLOR = Color3.fromRGB(200, 200, 200)
	local TOAST_FOREGROUND_TRANS = 0
	
	-- Convenient syntax for creating a tree of instanes
	local function create(className)
		return function(props)
			local inst = Instance.new(className)
			local parent = props.Parent
			props.Parent = nil
			for name, val in pairs(props) do
				if type(name) == "string" then
					inst[name] = val
				else
					val.Parent = inst
				end
			end
			-- Only set parent after all other properties are initialized
			inst.Parent = parent
			return inst
		end
	end
	
	local initialized = false
	
	local uiRoot
	local toast
	local toastIcon
	local toastUpperText
	local toastLowerText
	
	local function initializeUI()
		assert(not initialized)
	
		uiRoot = create("ScreenGui"){
			Name = "RbxCameraUI",
			AutoLocalize = false,
			Enabled = true,
			DisplayOrder = -1, -- Appears behind default developer UI
			IgnoreGuiInset = false,
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	
			create("ImageLabel"){
				Name = "Toast",
				Visible = false,
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(0.5, 0, 0, 8),
				Size = TOAST_CLOSED_SIZE,
				Image = "rbxasset://textures/ui/Camera/CameraToast9Slice.png",
				ImageColor3 = TOAST_BACKGROUND_COLOR,
				ImageRectSize = Vector2.new(6, 6),
				ImageTransparency = 1,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(3, 3, 3, 3),
				ClipsDescendants = true,
	
				create("Frame"){
					Name = "IconBuffer",
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(0, 80, 1, 0),
	
					create("ImageLabel"){
						Name = "Icon",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(0, 48, 0, 48),
						ZIndex = 2,
						Image = "rbxasset://textures/ui/Camera/CameraToastIcon.png",
						ImageColor3 = TOAST_FOREGROUND_COLOR,
						ImageTransparency = 1,
					}
				},
	
				create("Frame"){
					Name = "TextBuffer",
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 80, 0, 0),
					Size = UDim2.new(1, -80, 1, 0),
					ClipsDescendants = true,
	
					create("TextLabel"){
						Name = "Upper",
						AnchorPoint = Vector2.new(0, 1),
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 0, 0.5, 0),
						Size = UDim2.new(1, 0, 0, 19),
						Font = Enum.Font.GothamSemibold,
						Text = "Camera control enabled",
						TextColor3 = TOAST_FOREGROUND_COLOR,
						TextTransparency = 1,
						TextSize = 19,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
					},
	
					create("TextLabel"){
						Name = "Lower",
						AnchorPoint = Vector2.new(0, 0),
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 0, 0.5, 3),
						Size = UDim2.new(1, 0, 0, 15),
						Font = Enum.Font.Gotham,
						Text = "Right mouse button to toggle",
						TextColor3 = TOAST_FOREGROUND_COLOR,
						TextTransparency = 1,
						TextSize = 15,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
					},
				},
			},
	
			Parent = PlayerGui,
		}
	
		toast = uiRoot.Toast
		toastIcon = toast.IconBuffer.Icon
		toastUpperText = toast.TextBuffer.Upper
		toastLowerText = toast.TextBuffer.Lower
	
		initialized = true
	end
	
	local CameraUI = {}
	
	do
		-- Instantaneously disable the toast or enable for opening later on. Used when switching camera modes.
		function CameraUI.setCameraModeToastEnabled(enabled)
			if not enabled and not initialized then
				return
			end
	
			if not initialized then
				initializeUI()
			end
	
			toast.Visible = enabled
			if not enabled then
				CameraUI.setCameraModeToastOpen(false)
			end
		end
	
		local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
		-- Tween the toast in or out. Toast must be enabled with setCameraModeToastEnabled.
		function CameraUI.setCameraModeToastOpen(open)
			assert(initialized)
	
			TweenService:Create(toast, tweenInfo, {
				Size = open and TOAST_OPEN_SIZE or TOAST_CLOSED_SIZE,
				ImageTransparency = open and TOAST_BACKGROUND_TRANS or 1,
			}):Play()
	
			TweenService:Create(toastIcon, tweenInfo, {
				ImageTransparency = open and TOAST_FOREGROUND_TRANS or 1,
			}):Play()
	
			TweenService:Create(toastUpperText, tweenInfo, {
				TextTransparency = open and TOAST_FOREGROUND_TRANS or 1,
			}):Play()
	
			TweenService:Create(toastLowerText, tweenInfo, {
				TextTransparency = open and TOAST_FOREGROUND_TRANS or 1,
			}):Play()
		end
	end
	
	return CameraUI
end

function _CameraToggleStateController()
	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")
	local GameSettings = UserSettings():GetService("UserGameSettings")
	
	local LocalPlayer = Players.LocalPlayer
	if not LocalPlayer then
		Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		LocalPlayer = Players.LocalPlayer
	end
	
	local Mouse = LocalPlayer:GetMouse()
	
	local Input = _CameraInput()
	local CameraUI = _CameraUI()
	
	local lastTogglePan = false
	local lastTogglePanChange = tick()
	
	local CROSS_MOUSE_ICON = "rbxasset://textures/Cursors/CrossMouseIcon.png"
	
	local lockStateDirty = false
	local wasTogglePanOnTheLastTimeYouWentIntoFirstPerson = false
	local lastFirstPerson = false
	
	CameraUI.setCameraModeToastEnabled(false)
	
	return function(isFirstPerson)
		local togglePan = Input.getTogglePan()
		local toastTimeout = 3
	
		if isFirstPerson and togglePan ~= lastTogglePan then
			lockStateDirty = true
		end
	
		if lastTogglePan ~= togglePan or tick() - lastTogglePanChange > toastTimeout then
			local doShow = togglePan and tick() - lastTogglePanChange < toastTimeout
	
			CameraUI.setCameraModeToastOpen(doShow)
	
			if togglePan then
				lockStateDirty = false
			end
			lastTogglePanChange = tick()
			lastTogglePan = togglePan
		end
	
		if isFirstPerson ~= lastFirstPerson then
			if isFirstPerson then
				wasTogglePanOnTheLastTimeYouWentIntoFirstPerson = Input.getTogglePan()
				Input.setTogglePan(true)
			elseif not lockStateDirty then
				Input.setTogglePan(wasTogglePanOnTheLastTimeYouWentIntoFirstPerson)
			end
		end
	
		if isFirstPerson then
			if Input.getTogglePan() then
				Mouse.Icon = CROSS_MOUSE_ICON
				UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
				--GameSettings.RotationType = Enum.RotationType.CameraRelative
			else
				Mouse.Icon = ""
				UserInputService.MouseBehavior = Enum.MouseBehavior.Default
				--GameSettings.RotationType = Enum.RotationType.CameraRelative
			end
	
		elseif Input.getTogglePan() then
			Mouse.Icon = CROSS_MOUSE_ICON
			UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
			GameSettings.RotationType = Enum.RotationType.MovementRelative
	
		elseif Input.getHoldPan() then
			Mouse.Icon = ""
			UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
			GameSettings.RotationType = Enum.RotationType.MovementRelative
	
		else
			Mouse.Icon = ""
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
			GameSettings.RotationType = Enum.RotationType.MovementRelative
		end
	
		lastFirstPerson = isFirstPerson
	end
end

function _CameraInput()
	local UserInputService = game:GetService("UserInputService")
	
	local MB_TAP_LENGTH = 0.3 -- length of time for a short mouse button tap to be registered
	
	local rmbDown, rmbUp
	do
		local rmbDownBindable = Instance.new("BindableEvent")
		local rmbUpBindable = Instance.new("BindableEvent")
	
		rmbDown = rmbDownBindable.Event
		rmbUp = rmbUpBindable.Event
	
		UserInputService.InputBegan:Connect(function(input, gpe)
			if not gpe and input.UserInputType == Enum.UserInputType.MouseButton2 then
				rmbDownBindable:Fire()
			end
		end)
	
		UserInputService.InputEnded:Connect(function(input, gpe)
			if input.UserInputType == Enum.UserInputType.MouseButton2 then
				rmbUpBindable:Fire()
			end
		end)
	end
	
	local holdPan = false
	local togglePan = false
	local lastRmbDown = 0 -- tick() timestamp of the last right mouse button down event
	
	local CameraInput = {}
	
	function CameraInput.getHoldPan()
		return holdPan
	end
	
	function CameraInput.getTogglePan()
		return togglePan
	end
	
	function CameraInput.getPanning()
		return togglePan or holdPan
	end
	
	function CameraInput.setTogglePan(value)
		togglePan = value
	end
	
	local cameraToggleInputEnabled = false
	local rmbDownConnection
	local rmbUpConnection
	
	function CameraInput.enableCameraToggleInput()
		if cameraToggleInputEnabled then
			return
		end
		cameraToggleInputEnabled = true
	
		holdPan = false
		togglePan = false
	
		if rmbDownConnection then
			rmbDownConnection:Disconnect()
		end
	
		if rmbUpConnection then
			rmbUpConnection:Disconnect()
		end
	
		rmbDownConnection = rmbDown:Connect(function()
			holdPan = true
			lastRmbDown = tick()
		end)
	
		rmbUpConnection = rmbUp:Connect(function()
			holdPan = false
			if tick() - lastRmbDown < MB_TAP_LENGTH and (togglePan or UserInputService:GetMouseDelta().Magnitude < 2) then
				togglePan = not togglePan
			end
		end)
	end
	
	function CameraInput.disableCameraToggleInput()
		if not cameraToggleInputEnabled then
			return
		end
		cameraToggleInputEnabled = false
	
		if rmbDownConnection then
			rmbDownConnection:Disconnect()
			rmbDownConnection = nil
		end
		if rmbUpConnection then
			rmbUpConnection:Disconnect()
			rmbUpConnection = nil
		end
	end
	
	return CameraInput
end

function _BaseCamera()
	--[[
		BaseCamera - Abstract base class for camera control modules
		2018 Camera Update - AllYourBlox
	--]]
	
	--[[ Local Constants ]]--
	local UNIT_Z = Vector3.new(0,0,1)
	local X1_Y0_Z1 = Vector3.new(1,0,1)	--Note: not a unit vector, used for projecting onto XZ plane
	
	local THUMBSTICK_DEADZONE = 0.2
	local DEFAULT_DISTANCE = 12.5	-- Studs
	local PORTRAIT_DEFAULT_DISTANCE = 25		-- Studs
	local FIRST_PERSON_DISTANCE_THRESHOLD = 1.0 -- Below this value, snap into first person
	
	local CAMERA_ACTION_PRIORITY = Enum.ContextActionPriority.Default.Value
	
	-- Note: DotProduct check in CoordinateFrame::lookAt() prevents using values within about
	-- 8.11 degrees of the +/- Y axis, that's why these limits are currently 80 degrees
	local MIN_Y = math.rad(-80)
	local MAX_Y = math.rad(80)
	
	local TOUCH_ADJUST_AREA_UP = math.rad(30)
	local TOUCH_ADJUST_AREA_DOWN = math.rad(-15)
	
	local TOUCH_SENSITIVTY_ADJUST_MAX_Y = 2.1
	local TOUCH_SENSITIVTY_ADJUST_MIN_Y = 0.5
	
	local VR_ANGLE = math.rad(15)
	local VR_LOW_INTENSITY_ROTATION = Vector2.new(math.rad(15), 0)
	local VR_HIGH_INTENSITY_ROTATION = Vector2.new(math.rad(45), 0)
	local VR_LOW_INTENSITY_REPEAT = 0.1
	local VR_HIGH_INTENSITY_REPEAT = 0.4
	
	local ZERO_VECTOR2 = Vector2.new(0,0)
	local ZERO_VECTOR3 = Vector3.new(0,0,0)
	
	local TOUCH_SENSITIVTY = Vector2.new(0.00945 * math.pi, 0.003375 * math.pi)
	local MOUSE_SENSITIVITY = Vector2.new( 0.002 * math.pi, 0.0015 * math.pi )
	
	local SEAT_OFFSET = Vector3.new(0,5,0)
	local VR_SEAT_OFFSET = Vector3.new(0,4,0)
	local HEAD_OFFSET = Vector3.new(0,1.5,0)
	local R15_HEAD_OFFSET = Vector3.new(0, 1.5, 0)
	local R15_HEAD_OFFSET_NO_SCALING = Vector3.new(0, 2, 0)
	local HUMANOID_ROOT_PART_SIZE = Vector3.new(2, 2, 1)
	
	local GAMEPAD_ZOOM_STEP_1 = 0
	local GAMEPAD_ZOOM_STEP_2 = 10
	local GAMEPAD_ZOOM_STEP_3 = 20
	
	local PAN_SENSITIVITY = 20
	local ZOOM_SENSITIVITY_CURVATURE = 0.5
	
	local abs = math.abs
	local sign = math.sign
	
	local FFlagUserCameraToggle do
		local success, result = pcall(function()
			return UserSettings():IsUserFeatureEnabled("UserCameraToggle")
		end)
		FFlagUserCameraToggle = success and result
	end
	
	local FFlagUserDontAdjustSensitvityForPortrait do
		local success, result = pcall(function()
			return UserSettings():IsUserFeatureEnabled("UserDontAdjustSensitvityForPortrait")
		end)
		FFlagUserDontAdjustSensitvityForPortrait = success and result
	end
	
	local FFlagUserFixZoomInZoomOutDiscrepancy do
		local success, result = pcall(function()
			return UserSettings():IsUserFeatureEnabled("UserFixZoomInZoomOutDiscrepancy")
		end)
		FFlagUserFixZoomInZoomOutDiscrepancy = success and result
	end
	
	local Util = _CameraUtils()
	local ZoomController = _ZoomController()
	local CameraToggleStateController = _CameraToggleStateController()
	local CameraInput = _CameraInput()
	local CameraUI = _CameraUI()
	
	--[[ Roblox Services ]]--
	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")
	local StarterGui = game:GetService("StarterGui")
	local GuiService = game:GetService("GuiService")
	local ContextActionService = game:GetService("ContextActionService")
	local VRService = game:GetService("VRService")
	local UserGameSettings = UserSettings():GetService("UserGameSettings")
	
	local player = Players.LocalPlayer 
	
	--[[ The Module ]]--
	local BaseCamera = {}
	BaseCamera.__index = BaseCamera
	
	function BaseCamera.new()
		local self = setmetatable({}, BaseCamera)
	
		-- So that derived classes have access to this
		self.FIRST_PERSON_DISTANCE_THRESHOLD = FIRST_PERSON_DISTANCE_THRESHOLD
	
		self.cameraType = nil
		self.cameraMovementMode = nil
	
		self.lastCameraTransform = nil
		self.rotateInput = ZERO_VECTOR2
		self.userPanningCamera = false
		self.lastUserPanCamera = tick()
	
		self.humanoidRootPart = nil
		self.humanoidCache = {}
	
		-- Subject and position on last update call
		self.lastSubject = nil
		self.lastSubjectPosition = Vector3.new(0,5,0)
	
		-- These subject distance members refer to the nominal camera-to-subject follow distance that the camera
		-- is trying to maintain, not the actual measured value.
		-- The default is updated when screen orientation or the min/max distances change,
		-- to be sure the default is always in range and appropriate for the orientation.
		self.defaultSubjectDistance = math.clamp(DEFAULT_DISTANCE, player.CameraMinZoomDistance, player.CameraMaxZoomDistance)
		self.currentSubjectDistance = math.clamp(DEFAULT_DISTANCE, player.CameraMinZoomDistance, player.CameraMaxZoomDistance)
	
		self.inFirstPerson = false
		self.inMouseLockedMode = false
		self.portraitMode = false
		self.isSmallTouchScreen = false
	
		-- Used by modules which want to reset the camera angle on respawn.
		self.resetCameraAngle = true
	
		self.enabled = false
	
		-- Input Event Connections
		self.inputBeganConn = nil
		self.inputChangedConn = nil
		self.inputEndedConn = nil
	
		self.startPos = nil
		self.lastPos = nil
		self.panBeginLook = nil
	
		self.panEnabled = true
		self.keyPanEnabled = true
		self.distanceChangeEnabled = true
	
		self.PlayerGui = nil
	
		self.cameraChangedConn = nil
		self.viewportSizeChangedConn = nil
	
		self.boundContextActions = {}
	
		-- VR Support
		self.shouldUseVRRotation = false
		self.VRRotationIntensityAvailable = false
		self.lastVRRotationIntensityCheckTime = 0
		self.lastVRRotationTime = 0
		self.vrRotateKeyCooldown = {}
		self.cameraTranslationConstraints = Vector3.new(1, 1, 1)
		self.humanoidJumpOrigin = nil
		self.trackingHumanoid = nil
		self.cameraFrozen = false
		self.subjectStateChangedConn = nil
	
		-- Gamepad support
		self.activeGamepad = nil
		self.gamepadPanningCamera = false
		self.lastThumbstickRotate = nil
		self.numOfSeconds = 0.7
		self.currentSpeed = 0
		self.maxSpeed = 6
		self.vrMaxSpeed = 4
		self.lastThumbstickPos = Vector2.new(0,0)
		self.ySensitivity = 0.65
		self.lastVelocity = nil
		self.gamepadConnectedConn = nil
		self.gamepadDisconnectedConn = nil
		self.currentZoomSpeed = 1.0
		self.L3ButtonDown = false
		self.dpadLeftDown = false
		self.dpadRightDown = false
	
		-- Touch input support
		self.isDynamicThumbstickEnabled = false
		self.fingerTouches = {}
		self.dynamicTouchInput = nil
		self.numUnsunkTouches = 0
		self.inputStartPositions = {}
		self.inputStartTimes = {}
		self.startingDiff = nil
		self.pinchBeginZoom = nil
		self.userPanningTheCamera = false
		self.touchActivateConn = nil
	
		-- Mouse locked formerly known as shift lock mode
		self.mouseLockOffset = ZERO_VECTOR3
	
		-- [[ NOTICE ]] --
		-- Initialization things used to always execute at game load time, but now these camera modules are instantiated
		-- when needed, so the code here may run well after the start of the game
	
		if player.Character then
			self:OnCharacterAdded(player.Character)
		end
	
		player.CharacterAdded:Connect(function(char)
			self:OnCharacterAdded(char)
		end)
	
		if self.cameraChangedConn then self.cameraChangedConn:Disconnect() end
		self.cameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
			self:OnCurrentCameraChanged()
		end)
		self:OnCurrentCameraChanged()
	
		if self.playerCameraModeChangeConn then self.playerCameraModeChangeConn:Disconnect() end
		self.playerCameraModeChangeConn = player:GetPropertyChangedSignal("CameraMode"):Connect(function()
			self:OnPlayerCameraPropertyChange()
		end)
	
		if self.minDistanceChangeConn then self.minDistanceChangeConn:Disconnect() end
		self.minDistanceChangeConn = player:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function()
			self:OnPlayerCameraPropertyChange()
		end)
	
		if self.maxDistanceChangeConn then self.maxDistanceChangeConn:Disconnect() end
		self.maxDistanceChangeConn = player:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
			self:OnPlayerCameraPropertyChange()
		end)
	
		if self.playerDevTouchMoveModeChangeConn then self.playerDevTouchMoveModeChangeConn:Disconnect() end
		self.playerDevTouchMoveModeChangeConn = player:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function()
			self:OnDevTouchMovementModeChanged()
		end)
		self:OnDevTouchMovementModeChanged() -- Init
	
		if self.gameSettingsTouchMoveMoveChangeConn then self.gameSettingsTouchMoveMoveChangeConn:Disconnect() end
		self.gameSettingsTouchMoveMoveChangeConn = UserGameSettings:GetPropertyChangedSignal("TouchMovementMode"):Connect(function()
			self:OnGameSettingsTouchMovementModeChanged()
		end)
		self:OnGameSettingsTouchMovementModeChanged() -- Init
	
		UserGameSettings:SetCameraYInvertVisible()
		UserGameSettings:SetGamepadCameraSensitivityVisible()
	
		self.hasGameLoaded = game:IsLoaded()
		if not self.hasGameLoaded then
			self.gameLoadedConn = game.Loaded:Connect(function()
				self.hasGameLoaded = true
				self.gameLoadedConn:Disconnect()
				self.gameLoadedConn = nil
			end)
		end
	
		self:OnPlayerCameraPropertyChange()
	
		return self
	end
	
	function BaseCamera:GetModuleName()
		return "BaseCamera"
	end
	
	function BaseCamera:OnCharacterAdded(char)
		self.resetCameraAngle = self.resetCameraAngle or self:GetEnabled()
		self.humanoidRootPart = nil
		if UserInputService.TouchEnabled then
			self.PlayerGui = player:WaitForChild("PlayerGui")
			for _, child in ipairs(char:GetChildren()) do
				if child:IsA("Tool") then
					self.isAToolEquipped = true
				end
			end
			char.ChildAdded:Connect(function(child)
				if child:IsA("Tool") then
					self.isAToolEquipped = true
				end
			end)
			char.ChildRemoved:Connect(function(child)
				if child:IsA("Tool") then
					self.isAToolEquipped = false
				end
			end)
		end
	end
	
	function BaseCamera:GetHumanoidRootPart()
		if not self.humanoidRootPart then
			if player.Character then
				local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					self.humanoidRootPart = humanoid.RootPart
				end
			end
		end
		return self.humanoidRootPart
	end
	
	function BaseCamera:GetBodyPartToFollow(humanoid, isDead)
		-- If the humanoid is dead, prefer the head part if one still exists as a sibling of the humanoid
		if humanoid:GetState() == Enum.HumanoidStateType.Dead then
			local character = humanoid.Parent
			if character and character:IsA("Model") then
				return character:FindFirstChild("Head") or humanoid.RootPart
			end
		end
	
		return humanoid.RootPart
	end
	
	function BaseCamera:GetSubjectPosition()
		local result = self.lastSubjectPosition
		local camera = game.Workspace.CurrentCamera
		local cameraSubject = camera and camera.CameraSubject
	
		if cameraSubject then
			if cameraSubject:IsA("Humanoid") then
				local humanoid = cameraSubject
				local humanoidIsDead = humanoid:GetState() == Enum.HumanoidStateType.Dead
	
				if VRService.VREnabled and humanoidIsDead and humanoid == self.lastSubject then
					result = self.lastSubjectPosition
				else
					local bodyPartToFollow = humanoid.RootPart
	
					-- If the humanoid is dead, prefer their head part as a follow target, if it exists
					if humanoidIsDead then
						if humanoid.Parent and humanoid.Parent:IsA("Model") then
							bodyPartToFollow = humanoid.Parent:FindFirstChild("Head") or bodyPartToFollow
						end
					end
	
					if bodyPartToFollow and bodyPartToFollow:IsA("BasePart") then
						local heightOffset
						if humanoid.RigType == Enum.HumanoidRigType.R15 then
							if humanoid.AutomaticScalingEnabled then
								heightOffset = R15_HEAD_OFFSET
								if bodyPartToFollow == humanoid.RootPart then
									local rootPartSizeOffset = (humanoid.RootPart.Size.Y/2) - (HUMANOID_ROOT_PART_SIZE.Y/2)
									heightOffset = heightOffset + Vector3.new(0, rootPartSizeOffset, 0)
								end
							else
								heightOffset = R15_HEAD_OFFSET_NO_SCALING
							end
						else
							heightOffset = HEAD_OFFSET
						end
	
						if humanoidIsDead then
							heightOffset = ZERO_VECTOR3
						end
	
						result = bodyPartToFollow.CFrame.p + bodyPartToFollow.CFrame:vectorToWorldSpace(heightOffset + humanoid.CameraOffset)
					end
				end
	
			elseif cameraSubject:IsA("VehicleSeat") then
				local offset = SEAT_OFFSET
				if VRService.VREnabled then
					offset = VR_SEAT_OFFSET
				end
				result = cameraSubject.CFrame.p + cameraSubject.CFrame:vectorToWorldSpace(offset)
			elseif cameraSubject:IsA("SkateboardPlatform") then
				result = cameraSubject.CFrame.p + SEAT_OFFSET
			elseif cameraSubject:IsA("BasePart") then
				result = cameraSubject.CFrame.p
			elseif cameraSubject:IsA("Model") then
				if cameraSubject.PrimaryPart then
					result = cameraSubject:GetPrimaryPartCFrame().p
				else
					result = cameraSubject:GetModelCFrame().p
				end
			end
		else
			-- cameraSubject is nil
			-- Note: Previous RootCamera did not have this else case and let self.lastSubject and self.lastSubjectPosition
			-- both get set to nil in the case of cameraSubject being nil. This function now exits here to preserve the
			-- last set valid values for these, as nil values are not handled cases
			return
		end
	
		self.lastSubject = cameraSubject
		self.lastSubjectPosition = result
	
		return result
	end
	
	function BaseCamera:UpdateDefaultSubjectDistance()
		if self.portraitMode then
			self.defaultSubjectDistance = math.clamp(PORTRAIT_DEFAULT_DISTANCE, player.CameraMinZoomDistance, player.CameraMaxZoomDistance)
		else
			self.defaultSubjectDistance = math.clamp(DEFAULT_DISTANCE, player.CameraMinZoomDistance, player.CameraMaxZoomDistance)
		end
	end
	
	function BaseCamera:OnViewportSizeChanged()
		local camera = game.Workspace.CurrentCamera
		local size = camera.ViewportSize
		self.portraitMode = size.X < size.Y
		self.isSmallTouchScreen = UserInputService.TouchEnabled and (size.Y < 500 or size.X < 700)
	
		self:UpdateDefaultSubjectDistance()
	end
	
	-- Listener for changes to workspace.CurrentCamera
	function BaseCamera:OnCurrentCameraChanged()
		if UserInputService.TouchEnabled then
			if self.viewportSizeChangedConn then
				self.viewportSizeChangedConn:Disconnect()
				self.viewportSizeChangedConn = nil
			end
	
			local newCamera = game.Workspace.CurrentCamera
	
			if newCamera then
				self:OnViewportSizeChanged()
				self.viewportSizeChangedConn = newCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
					self:OnViewportSizeChanged()
				end)
			end
		end
	
		-- VR support additions
		if self.cameraSubjectChangedConn then
			self.cameraSubjectChangedConn:Disconnect()
			self.cameraSubjectChangedConn = nil
		end
	
		local camera = game.Workspace.CurrentCamera
		if camera then
			self.cameraSubjectChangedConn = camera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
				self:OnNewCameraSubject()
			end)
			self:OnNewCameraSubject()
		end
	end
	
	function BaseCamera:OnDynamicThumbstickEnabled()
		if UserInputService.TouchEnabled then
			self.isDynamicThumbstickEnabled = true
		end
	end
	
	function BaseCamera:OnDynamicThumbstickDisabled()
		self.isDynamicThumbstickEnabled = false
	end
	
	function BaseCamera:OnGameSettingsTouchMovementModeChanged()
		if player.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice then
			if (UserGameSettings.TouchMovementMode == Enum.TouchMovementMode.DynamicThumbstick
				or UserGameSettings.TouchMovementMode == Enum.TouchMovementMode.Default) then
				self:OnDynamicThumbstickEnabled()
			else
				self:OnDynamicThumbstickDisabled()
			end
		end
	end
	
	function BaseCamera:OnDevTouchMovementModeChanged()
		if player.DevTouchMovementMode.Name == "DynamicThumbstick" then
			self:OnDynamicThumbstickEnabled()
		else
			self:OnGameSettingsTouchMovementModeChanged()
		end
	end
	
	function BaseCamera:OnPlayerCameraPropertyChange()
		-- This call forces re-evaluation of player.CameraMode and clamping to min/max distance which may have changed
		self:SetCameraToSubjectDistance(self.currentSubjectDistance)
	end
	
	function BaseCamera:GetCameraHeight()
		if VRService.VREnabled and not self.inFirstPerson then
			return math.sin(VR_ANGLE) * self.currentSubjectDistance
		end
		return 0
	end
	
	function BaseCamera:InputTranslationToCameraAngleChange(translationVector, sensitivity)
		if not FFlagUserDontAdjustSensitvityForPortrait then
			local camera = game.Workspace.CurrentCamera
			if camera and camera.ViewportSize.X > 0 and camera.ViewportSize.Y > 0 and (camera.ViewportSize.Y > camera.ViewportSize.X) then
				-- Screen has portrait orientation, swap X and Y sensitivity
				return translationVector * Vector2.new( sensitivity.Y, sensitivity.X)
			end
		end
		return translationVector * sensitivity
	end
	
	function BaseCamera:Enable(enable)
		if self.enabled ~= enable then
			self.enabled = enable
			if self.enabled then
				self:ConnectInputEvents()
				self:BindContextActions()
	
				if player.CameraMode == Enum.CameraMode.LockFirstPerson then
					self.currentSubjectDistance = 0.5
					if not self.inFirstPerson then
						self:EnterFirstPerson()
					end
				end
			else
				self:DisconnectInputEvents()
				self:UnbindContextActions()
				-- Clean up additional event listeners and reset a bunch of properties
				self:Cleanup()
			end
		end
	end
	
	function BaseCamera:GetEnabled()
		return self.enabled
	end
	
	function BaseCamera:OnInputBegan(input, processed)
		if input.UserInputType == Enum.UserInputType.Touch then
			self:OnTouchBegan(input, processed)
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			self:OnMouse2Down(input, processed)
		elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
			self:OnMouse3Down(input, processed)
		end
	end
	
	function BaseCamera:OnInputChanged(input, processed)
		if input.UserInputType == Enum.UserInputType.Touch then
			self:OnTouchChanged(input, processed)
		elseif input.UserInputType == Enum.UserInputType.MouseMovement then
			self:OnMouseMoved(input, processed)
		end
	end
	
	function BaseCamera:OnInputEnded(input, processed)
		if input.UserInputType == Enum.UserInputType.Touch then
			self:OnTouchEnded(input, processed)
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			self:OnMouse2Up(input, processed)
		elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
			self:OnMouse3Up(input, processed)
		end
	end
	
	function BaseCamera:OnPointerAction(wheel, pan, pinch, processed)
		if processed then
			return
		end
	
		if pan.Magnitude > 0 then
			local inversionVector = Vector2.new(1, UserGameSettings:GetCameraYInvertValue())
			local rotateDelta = self:InputTranslationToCameraAngleChange(PAN_SENSITIVITY*pan, MOUSE_SENSITIVITY)*inversionVector
			self.rotateInput = self.rotateInput + rotateDelta
		end
	
		local zoom = self.currentSubjectDistance
		local zoomDelta = -(wheel + pinch)
	
		if abs(zoomDelta) > 0 then
			local newZoom
			if self.inFirstPerson and zoomDelta > 0 then
				newZoom = FIRST_PERSON_DISTANCE_THRESHOLD
			else
				if FFlagUserFixZoomInZoomOutDiscrepancy then
					if (zoomDelta > 0) then
						newZoom = zoom + zoomDelta*(1 + zoom*ZOOM_SENSITIVITY_CURVATURE)
					else
						newZoom = (zoom + zoomDelta) / (1 - zoomDelta*ZOOM_SENSITIVITY_CURVATURE)
					end
				else
					newZoom = zoom + zoomDelta*(1 + zoom*ZOOM_SENSITIVITY_CURVATURE)
				end
			end
	
			self:SetCameraToSubjectDistance(newZoom)
		end
	end
	
	function BaseCamera:ConnectInputEvents()
		self.pointerActionConn = UserInputService.PointerAction:Connect(function(wheel, pan, pinch, processed)
			self:OnPointerAction(wheel, pan, pinch, processed)
		end)
	
		self.inputBeganConn = UserInputService.InputBegan:Connect(function(input, processed)
			self:OnInputBegan(input, processed)
		end)
	
		self.inputChangedConn = UserInputService.InputChanged:Connect(function(input, processed)
			self:OnInputChanged(input, processed)
		end)
	
		self.inputEndedConn = UserInputService.InputEnded:Connect(function(input, processed)
			self:OnInputEnded(input, processed)
		end)
	
		self.menuOpenedConn = GuiService.MenuOpened:connect(function()
			self:ResetInputStates()
		end)
	
		self.gamepadConnectedConn = UserInputService.GamepadDisconnected:connect(function(gamepadEnum)
			if self.activeGamepad ~= gamepadEnum then return end
			self.activeGamepad = nil
			self:AssignActivateGamepad()
		end)
	
		self.gamepadDisconnectedConn = UserInputService.GamepadConnected:connect(function(gamepadEnum)
			if self.activeGamepad == nil then
				self:AssignActivateGamepad()
			end
		end)
	
		self:AssignActivateGamepad()
		if not FFlagUserCameraToggle then
			self:UpdateMouseBehavior()
		end
	end
	
	function BaseCamera:BindContextActions()
		self:BindGamepadInputActions()
		self:BindKeyboardInputActions()
	end
	
	function BaseCamera:AssignActivateGamepad()
		local connectedGamepads = UserInputService:GetConnectedGamepads()
		if #connectedGamepads > 0 then
			for i = 1, #connectedGamepads do
				if self.activeGamepad == nil then
					self.activeGamepad = connectedGamepads[i]
				elseif connectedGamepads[i].Value < self.activeGamepad.Value then
					self.activeGamepad = connectedGamepads[i]
				end
			end
		end
	
		if self.activeGamepad == nil then -- nothing is connected, at least set up for gamepad1
			self.activeGamepad = Enum.UserInputType.Gamepad1
		end
	end
	
	function BaseCamera:DisconnectInputEvents()
		if self.inputBeganConn then
			self.inputBeganConn:Disconnect()
			self.inputBeganConn = nil
		end
		if self.inputChangedConn then
			self.inputChangedConn:Disconnect()
			self.inputChangedConn = nil
		end
		if self.inputEndedConn then
			self.inputEndedConn:Disconnect()
			self.inputEndedConn = nil
		end
	end
	
	function BaseCamera:UnbindContextActions()
		for i = 1, #self.boundContextActions do
			ContextActionService:UnbindAction(self.boundContextActions[i])
		end
		self.boundContextActions = {}
	end
	
	function BaseCamera:Cleanup()
		if self.pointerActionConn then
			self.pointerActionConn:Disconnect()
			self.pointerActionConn = nil
		end
		if self.menuOpenedConn then
			self.menuOpenedConn:Disconnect()
			self.menuOpenedConn = nil
		end
		if self.mouseLockToggleConn then
			self.mouseLockToggleConn:Disconnect()
			self.mouseLockToggleConn = nil
		end
		if self.gamepadConnectedConn then
			self.gamepadConnectedConn:Disconnect()
			self.gamepadConnectedConn = nil
		end
		if self.gamepadDisconnectedConn then
			self.gamepadDisconnectedConn:Disconnect()
			self.gamepadDisconnectedConn = nil
		end
		if self.subjectStateChangedConn then
			self.subjectStateChangedConn:Disconnect()
			self.subjectStateChangedConn = nil
		end
		if self.viewportSizeChangedConn then
			self.viewportSizeChangedConn:Disconnect()
			self.viewportSizeChangedConn = nil
		end
		if self.touchActivateConn then
			self.touchActivateConn:Disconnect()
			self.touchActivateConn = nil
		end
	
		self.turningLeft = false
		self.turningRight = false
		self.lastCameraTransform = nil
		self.lastSubjectCFrame = nil
		self.userPanningTheCamera = false
		self.rotateInput = Vector2.new()
		self.gamepadPanningCamera = Vector2.new(0,0)
	
		-- Reset input states
		self.startPos = nil
		self.lastPos = nil
		self.panBeginLook = nil
		self.isRightMouseDown = false
		self.isMiddleMouseDown = false
	
		self.fingerTouches = {}
		self.dynamicTouchInput = nil
		self.numUnsunkTouches = 0
	
		self.startingDiff = nil
		self.pinchBeginZoom = nil
	
		-- Unlock mouse for example if right mouse button was being held down
		if UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		end
	end
	
	-- This is called when settings menu is opened
	function BaseCamera:ResetInputStates()
		self.isRightMouseDown = false
		self.isMiddleMouseDown = false
		self:OnMousePanButtonReleased() -- this function doesn't seem to actually need parameters
	
		if UserInputService.TouchEnabled then
			--[[menu opening was causing serious touch issues
			this should disable all active touch events if
			they're active when menu opens.]]
			for inputObject in pairs(self.fingerTouches) do
				self.fingerTouches[inputObject] = nil
			end
			self.dynamicTouchInput = nil
			self.panBeginLook = nil
			self.startPos = nil
			self.lastPos = nil
			self.userPanningTheCamera = false
			self.startingDiff = nil
			self.pinchBeginZoom = nil
			self.numUnsunkTouches = 0
		end
	end
	
	function BaseCamera:GetGamepadPan(name, state, input)
		if input.UserInputType == self.activeGamepad and input.KeyCode == Enum.KeyCode.Thumbstick2 then
	--		if self.L3ButtonDown then
	--			-- L3 Thumbstick is depressed, right stick controls dolly in/out
	--			if (input.Position.Y > THUMBSTICK_DEADZONE) then
	--				self.currentZoomSpeed = 0.96
	--			elseif (input.Position.Y < -THUMBSTICK_DEADZONE) then
	--				self.currentZoomSpeed = 1.04
	--			else
	--				self.currentZoomSpeed = 1.00
	--			end
	--		else
				if state == Enum.UserInputState.Cancel then
					self.gamepadPanningCamera = ZERO_VECTOR2
					return
				end
	
				local inputVector = Vector2.new(input.Position.X, -input.Position.Y)
				if inputVector.magnitude > THUMBSTICK_DEADZONE then
					self.gamepadPanningCamera = Vector2.new(input.Position.X, -input.Position.Y)
				else
					self.gamepadPanningCamera = ZERO_VECTOR2
				end
			--end
			return Enum.ContextActionResult.Sink
		end
		return Enum.ContextActionResult.Pass
	end
	
	function BaseCamera:DoKeyboardPanTurn(name, state, input)
		if not self.hasGameLoaded and VRService.VREnabled then
			return Enum.ContextActionResult.Pass
		end
	
		if state == Enum.UserInputState.Cancel then
			self.turningLeft = false
			self.turningRight = false
			return Enum.ContextActionResult.Sink
		end
	
		if self.panBeginLook == nil and self.keyPanEnabled then
			if input.KeyCode == Enum.KeyCode.Left then
				self.turningLeft = state == Enum.UserInputState.Begin
			elseif input.KeyCode == Enum.KeyCode.Right then
				self.turningRight = state == Enum.UserInputState.Begin
			end
			return Enum.ContextActionResult.Sink
		end
		return Enum.ContextActionResult.Pass
	end
	
	function BaseCamera:DoPanRotateCamera(rotateAngle)
		local angle = Util.RotateVectorByAngleAndRound(self:GetCameraLookVector() * Vector3.new(1,0,1), rotateAngle, math.pi*0.25)
		if angle ~= 0 then
			self.rotateInput = self.rotateInput + Vector2.new(angle, 0)
			self.lastUserPanCamera = tick()
			self.lastCameraTransform = nil
		end
	end
	
	function BaseCamera:DoGamepadZoom(name, state, input)
		if input.UserInputType == self.activeGamepad then
			if input.KeyCode == Enum.KeyCode.ButtonR3 then
				if state == Enum.UserInputState.Begin then
					if self.distanceChangeEnabled then
						local dist = self:GetCameraToSubjectDistance()
	
						if dist > (GAMEPAD_ZOOM_STEP_2 + GAMEPAD_ZOOM_STEP_3)/2 then
							self:SetCameraToSubjectDistance(GAMEPAD_ZOOM_STEP_2)
						elseif dist > (GAMEPAD_ZOOM_STEP_1 + GAMEPAD_ZOOM_STEP_2)/2 then
							self:SetCameraToSubjectDistance(GAMEPAD_ZOOM_STEP_1)
						else
							self:SetCameraToSubjectDistance(GAMEPAD_ZOOM_STEP_3)
						end
					end
				end
			elseif input.KeyCode == Enum.KeyCode.DPadLeft then
				self.dpadLeftDown = (state == Enum.UserInputState.Begin)
			elseif input.KeyCode == Enum.KeyCode.DPadRight then
				self.dpadRightDown = (state == Enum.UserInputState.Begin)
			end
	
			if self.dpadLeftDown then
				self.currentZoomSpeed = 1.04
			elseif self.dpadRightDown then
				self.currentZoomSpeed = 0.96
			else
				self.currentZoomSpeed = 1.00
			end
			return Enum.ContextActionResult.Sink
		end
		return Enum.ContextActionResult.Pass
	--	elseif input.UserInputType == self.activeGamepad and input.KeyCode == Enum.KeyCode.ButtonL3 then
	--		if (state == Enum.UserInputState.Begin) then
	--			self.L3ButtonDown = true
	--		elseif (state == Enum.UserInputState.End) then
	--			self.L3ButtonDown = false
	--			self.currentZoomSpeed = 1.00
	--		end
	--	end
	end
	
	function BaseCamera:DoKeyboardZoom(name, state, input)
		if not self.hasGameLoaded and VRService.VREnabled then
			return Enum.ContextActionResult.Pass
		end
	
		if state ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end
	
		if self.distanceChangeEnabled and player.CameraMode ~= Enum.CameraMode.LockFirstPerson then
			if input.KeyCode == Enum.KeyCode.I then
				self:SetCameraToSubjectDistance( self.currentSubjectDistance - 5 )
			elseif input.KeyCode == Enum.KeyCode.O then
				self:SetCameraToSubjectDistance( self.currentSubjectDistance + 5 )
			end
			return Enum.ContextActionResult.Sink
		end
		return Enum.ContextActionResult.Pass
	end
	
	function BaseCamera:BindAction(actionName, actionFunc, createTouchButton, ...)
		table.insert(self.boundContextActions, actionName)
		ContextActionService:BindActionAtPriority(actionName, actionFunc, createTouchButton,
			CAMERA_ACTION_PRIORITY, ...)
	end
	
	function BaseCamera:BindGamepadInputActions()
		self:BindAction("BaseCameraGamepadPan", function(name, state, input) return self:GetGamepadPan(name, state, input) end,
			false, Enum.KeyCode.Thumbstick2)
		self:BindAction("BaseCameraGamepadZoom", function(name, state, input) return self:DoGamepadZoom(name, state, input) end,
			false, Enum.KeyCode.DPadLeft, Enum.KeyCode.DPadRight, Enum.KeyCode.ButtonR3)
	end
	
	function BaseCamera:BindKeyboardInputActions()
		self:BindAction("BaseCameraKeyboardPanArrowKeys", function(name, state, input) return self:DoKeyboardPanTurn(name, state, input) end,
			false, Enum.KeyCode.Left, Enum.KeyCode.Right)
		self:BindAction("BaseCameraKeyboardZoom", function(name, state, input) return self:DoKeyboardZoom(name, state, input) end,
			false, Enum.KeyCode.I, Enum.KeyCode.O)
	end
	
	local function isInDynamicThumbstickArea(input)
		local playerGui = player:FindFirstChildOfClass("PlayerGui")
		local touchGui = playerGui and playerGui:FindFirstChild("TouchGui")
		local touchFrame = touchGui and touchGui:FindFirstChild("TouchControlFrame")
		local thumbstickFrame = touchFrame and touchFrame:FindFirstChild("DynamicThumbstickFrame")
	
		if not thumbstickFrame then
			return false
		end
	
		local frameCornerTopLeft = thumbstickFrame.AbsolutePosition
		local frameCornerBottomRight = frameCornerTopLeft + thumbstickFrame.AbsoluteSize
		if input.Position.X >= frameCornerTopLeft.X and input.Position.Y >= frameCornerTopLeft.Y then
			if input.Position.X <= frameCornerBottomRight.X and input.Position.Y <= frameCornerBottomRight.Y then
				return true
			end
		end
	
		return false
	end
	
	---Adjusts the camera Y touch Sensitivity when moving away from the center and in the TOUCH_SENSITIVTY_ADJUST_AREA
	function BaseCamera:AdjustTouchSensitivity(delta, sensitivity)
		local cameraCFrame = game.Workspace.CurrentCamera and game.Workspace.CurrentCamera.CFrame
		if not cameraCFrame then
			return sensitivity
		end
		local currPitchAngle = cameraCFrame:ToEulerAnglesYXZ()
	
		local multiplierY = TOUCH_SENSITIVTY_ADJUST_MAX_Y
		if currPitchAngle > TOUCH_ADJUST_AREA_UP and delta.Y < 0 then
			local fractionAdjust = (currPitchAngle - TOUCH_ADJUST_AREA_UP)/(MAX_Y - TOUCH_ADJUST_AREA_UP)
			fractionAdjust = 1 - (1 - fractionAdjust)^3
			multiplierY = TOUCH_SENSITIVTY_ADJUST_MAX_Y - fractionAdjust * (
				TOUCH_SENSITIVTY_ADJUST_MAX_Y - TOUCH_SENSITIVTY_ADJUST_MIN_Y)
		elseif currPitchAngle < TOUCH_ADJUST_AREA_DOWN and delta.Y > 0 then
			local fractionAdjust = (currPitchAngle - TOUCH_ADJUST_AREA_DOWN)/(MIN_Y - TOUCH_ADJUST_AREA_DOWN)
			fractionAdjust = 1 - (1 - fractionAdjust)^3
			multiplierY = TOUCH_SENSITIVTY_ADJUST_MAX_Y - fractionAdjust * (
				TOUCH_SENSITIVTY_ADJUST_MAX_Y - TOUCH_SENSITIVTY_ADJUST_MIN_Y)
		end
	
		return Vector2.new(
			sensitivity.X,
			sensitivity.Y * multiplierY
		)
	end
	
	function BaseCamera:OnTouchBegan(input, processed)
		local canUseDynamicTouch = self.isDynamicThumbstickEnabled and not processed
		if canUseDynamicTouch then
			if self.dynamicTouchInput == nil and isInDynamicThumbstickArea(input) then
				-- First input in the dynamic thumbstick area should always be ignored for camera purposes
				-- Even if the dynamic thumbstick does not process it immediately
				self.dynamicTouchInput = input
				return
			end
			self.fingerTouches[input] = processed
			self.inputStartPositions[input] = input.Position
			self.inputStartTimes[input] = tick()
			self.numUnsunkTouches = self.numUnsunkTouches + 1
		end
	end
	
	function BaseCamera:OnTouchChanged(input, processed)
		if self.fingerTouches[input] == nil then
			if self.isDynamicThumbstickEnabled then
				return
			end
			self.fingerTouches[input] = processed
			if not processed then
				self.numUnsunkTouches = self.numUnsunkTouches + 1
			end
		end
	
		if self.numUnsunkTouches == 1 then
			if self.fingerTouches[input] == false then
				self.panBeginLook = self.panBeginLook or self:GetCameraLookVector()
				self.startPos = self.startPos or input.Position
				self.lastPos = self.lastPos or self.startPos
				self.userPanningTheCamera = true
	
				local delta = input.Position - self.lastPos
				delta = Vector2.new(delta.X, delta.Y * UserGameSettings:GetCameraYInvertValue())
				if self.panEnabled then
					local adjustedTouchSensitivity = TOUCH_SENSITIVTY
					self:AdjustTouchSensitivity(delta, TOUCH_SENSITIVTY)
	
					local desiredXYVector = self:InputTranslationToCameraAngleChange(delta, adjustedTouchSensitivity)
					self.rotateInput = self.rotateInput + desiredXYVector
				end
				self.lastPos = input.Position
			end
		else
			self.panBeginLook = nil
			self.startPos = nil
			self.lastPos = nil
			self.userPanningTheCamera = false
		end
		if self.numUnsunkTouches == 2 then
			local unsunkTouches = {}
			for touch, wasSunk in pairs(self.fingerTouches) do
				if not wasSunk then
					table.insert(unsunkTouches, touch)
				end
			end
			if #unsunkTouches == 2 then
				local difference = (unsunkTouches[1].Position - unsunkTouches[2].Position).magnitude
				if self.startingDiff and self.pinchBeginZoom then
					local scale = difference / math.max(0.01, self.startingDiff)
					local clampedScale = math.clamp(scale, 0.1, 10)
					if self.distanceChangeEnabled then
						self:SetCameraToSubjectDistance(self.pinchBeginZoom / clampedScale)
					end
				else
					self.startingDiff = difference
					self.pinchBeginZoom = self:GetCameraToSubjectDistance()
				end
			end
		else
			self.startingDiff = nil
			self.pinchBeginZoom = nil
		end
	end
	
	function BaseCamera:OnTouchEnded(input, processed)
		if input == self.dynamicTouchInput then
			self.dynamicTouchInput = nil
			return
		end
	
		if self.fingerTouches[input] == false then
			if self.numUnsunkTouches == 1 then
				self.panBeginLook = nil
				self.startPos = nil
				self.lastPos = nil
				self.userPanningTheCamera = false
			elseif self.numUnsunkTouches == 2 then
				self.startingDiff = nil
				self.pinchBeginZoom = nil
			end
		end
	
		if self.fingerTouches[input] ~= nil and self.fingerTouches[input] == false then
			self.numUnsunkTouches = self.numUnsunkTouches - 1
		end
		self.fingerTouches[input] = nil
		self.inputStartPositions[input] = nil
		self.inputStartTimes[input] = nil
	end
	
	function BaseCamera:OnMouse2Down(input, processed)
		if processed then return end
	
		self.isRightMouseDown = true
		self:OnMousePanButtonPressed(input, processed)
	end
	
	function BaseCamera:OnMouse2Up(input, processed)
		self.isRightMouseDown = false
		self:OnMousePanButtonReleased(input, processed)
	end
	
	function BaseCamera:OnMouse3Down(input, processed)
		if processed then return end
	
		self.isMiddleMouseDown = true
		self:OnMousePanButtonPressed(input, processed)
	end
	
	function BaseCamera:OnMouse3Up(input, processed)
		self.isMiddleMouseDown = false
		self:OnMousePanButtonReleased(input, processed)
	end
	
	function BaseCamera:OnMouseMoved(input, processed)
		if not self.hasGameLoaded and VRService.VREnabled then
			return
		end
	
		local inputDelta = input.Delta
		inputDelta = Vector2.new(inputDelta.X, inputDelta.Y * UserGameSettings:GetCameraYInvertValue())
	
		local isInputPanning = FFlagUserCameraToggle and CameraInput.getPanning()
		local isBeginLook = self.startPos and self.lastPos and self.panBeginLook
		local isPanning = isBeginLook or self.inFirstPerson or self.inMouseLockedMode or isInputPanning
	
		if self.panEnabled and isPanning then
			local desiredXYVector = self:InputTranslationToCameraAngleChange(inputDelta, MOUSE_SENSITIVITY)
			self.rotateInput = self.rotateInput + desiredXYVector
		end
	
		if self.startPos and self.lastPos and self.panBeginLook then
			self.lastPos = self.lastPos + input.Delta
		end
	end
	
	function BaseCamera:OnMousePanButtonPressed(input, processed)
		if processed then return end
		if not FFlagUserCameraToggle then
			self:UpdateMouseBehavior()
		end
		self.panBeginLook = self.panBeginLook or self:GetCameraLookVector()
		self.startPos = self.startPos or input.Position
		self.lastPos = self.lastPos or self.startPos
		self.userPanningTheCamera = true
	end
	
	function BaseCamera:OnMousePanButtonReleased(input, processed)
		if not FFlagUserCameraToggle then
			self:UpdateMouseBehavior()
		end
		if not (self.isRightMouseDown or self.isMiddleMouseDown) then
			self.panBeginLook = nil
			self.startPos = nil
			self.lastPos = nil
			self.userPanningTheCamera = false
		end
	end
	
	function BaseCamera:UpdateMouseBehavior()
		if FFlagUserCameraToggle and self.isCameraToggle then
			CameraUI.setCameraModeToastEnabled(true)
			CameraInput.enableCameraToggleInput()
			CameraToggleStateController(self.inFirstPerson)
		else
			if FFlagUserCameraToggle then
				CameraUI.setCameraModeToastEnabled(false)
				CameraInput.disableCameraToggleInput()
			end
			-- first time transition to first person mode or mouse-locked third person
			if self.inFirstPerson or self.inMouseLockedMode then
				--UserGameSettings.RotationType = Enum.RotationType.CameraRelative
				UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
			else
				UserGameSettings.RotationType = Enum.RotationType.MovementRelative
				if self.isRightMouseDown or self.isMiddleMouseDown then
					UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
				else
					UserInputService.MouseBehavior = Enum.MouseBehavior.Default
				end
			end
		end
	end
	
	function BaseCamera:UpdateForDistancePropertyChange()
		-- Calling this setter with the current value will force checking that it is still
		-- in range after a change to the min/max distance limits
		self:SetCameraToSubjectDistance(self.currentSubjectDistance)
	end
	
	function BaseCamera:SetCameraToSubjectDistance(desiredSubjectDistance)
		local lastSubjectDistance = self.currentSubjectDistance
	
		-- By default, camera modules will respect LockFirstPerson and override the currentSubjectDistance with 0
		-- regardless of what Player.CameraMinZoomDistance is set to, so that first person can be made
		-- available by the developer without needing to allow players to mousewheel dolly into first person.
		-- Some modules will override this function to remove or change first-person capability.
		if player.CameraMode == Enum.CameraMode.LockFirstPerson then
			self.currentSubjectDistance = 0.5
			if not self.inFirstPerson then
				self:EnterFirstPerson()
			end
		else
			local newSubjectDistance = math.clamp(desiredSubjectDistance, player.CameraMinZoomDistance, player.CameraMaxZoomDistance)
			if newSubjectDistance < FIRST_PERSON_DISTANCE_THRESHOLD then
				self.currentSubjectDistance = 0.5
				if not self.inFirstPerson then
					self:EnterFirstPerson()
				end
			else
				self.currentSubjectDistance = newSubjectDistance
				if self.inFirstPerson then
					self:LeaveFirstPerson()
				end
			end
		end
	
		-- Pass target distance and zoom direction to the zoom controller
		ZoomController.SetZoomParameters(self.currentSubjectDistance, math.sign(desiredSubjectDistance - lastSubjectDistance))
	
		-- Returned only for convenience to the caller to know the outcome
		return self.currentSubjectDistance
	end
	
	function BaseCamera:SetCameraType( cameraType )
		--Used by derived classes
		self.cameraType = cameraType
	end
	
	function BaseCamera:GetCameraType()
		return self.cameraType
	end
	
	-- Movement mode standardized to Enum.ComputerCameraMovementMode values
	function BaseCamera:SetCameraMovementMode( cameraMovementMode )
		self.cameraMovementMode = cameraMovementMode
	end
	
	function BaseCamera:GetCameraMovementMode()
		return self.cameraMovementMode
	end
	
	function BaseCamera:SetIsMouseLocked(mouseLocked)
		self.inMouseLockedMode = mouseLocked
		if not FFlagUserCameraToggle then
			self:UpdateMouseBehavior()
		end
	end
	
	function BaseCamera:GetIsMouseLocked()
		return self.inMouseLockedMode
	end
	
	function BaseCamera:SetMouseLockOffset(offsetVector)
		self.mouseLockOffset = offsetVector
	end
	
	function BaseCamera:GetMouseLockOffset()
		return self.mouseLockOffset
	end
	
	function BaseCamera:InFirstPerson()
		return self.inFirstPerson
	end
	
	function BaseCamera:EnterFirstPerson()
		-- Overridden in ClassicCamera, the only module which supports FirstPerson
	end
	
	function BaseCamera:LeaveFirstPerson()
		-- Overridden in ClassicCamera, the only module which supports FirstPerson
	end
	
	-- Nominal distance, set by dollying in and out with the mouse wheel or equivalent, not measured distance
	function BaseCamera:GetCameraToSubjectDistance()
		return self.currentSubjectDistance
	end
	
	-- Actual measured distance to the camera Focus point, which may be needed in special circumstances, but should
	-- never be used as the starting point for updating the nominal camera-to-subject distance (self.currentSubjectDistance)
	-- since that is a desired target value set only by mouse wheel (or equivalent) input, PopperCam, and clamped to min max camera distance
	function BaseCamera:GetMeasuredDistanceToFocus()
		local camera = game.Workspace.CurrentCamera
		if camera then
			return (camera.CoordinateFrame.p - camera.Focus.p).magnitude
		end
		return nil
	end
	
	function BaseCamera:GetCameraLookVector()
		return game.Workspace.CurrentCamera and game.Workspace.CurrentCamera.CFrame.lookVector or UNIT_Z
	end
	
	-- Replacements for RootCamera:RotateCamera() which did not actually rotate the camera
	-- suppliedLookVector is not normally passed in, it's used only by Watch camera
	function BaseCamera:CalculateNewLookCFrame(suppliedLookVector)
		local currLookVector = suppliedLookVector or self:GetCameraLookVector()
		local currPitchAngle = math.asin(currLookVector.y)
		local yTheta = math.clamp(self.rotateInput.y, -MAX_Y + currPitchAngle, -MIN_Y + currPitchAngle)
		local constrainedRotateInput = Vector2.new(self.rotateInput.x, yTheta)
		local startCFrame = CFrame.new(ZERO_VECTOR3, currLookVector)
		local newLookCFrame = CFrame.Angles(0, -constrainedRotateInput.x, 0) * startCFrame * CFrame.Angles(-constrainedRotateInput.y,0,0)
		return newLookCFrame
	end
	function BaseCamera:CalculateNewLookVector(suppliedLookVector)
		local newLookCFrame = self:CalculateNewLookCFrame(suppliedLookVector)
		return newLookCFrame.lookVector
	end
	
	function BaseCamera:CalculateNewLookVectorVR()
		local subjectPosition = self:GetSubjectPosition()
		local vecToSubject = (subjectPosition - game.Workspace.CurrentCamera.CFrame.p)
		local currLookVector = (vecToSubject * X1_Y0_Z1).unit
		local vrRotateInput = Vector2.new(self.rotateInput.x, 0)
		local startCFrame = CFrame.new(ZERO_VECTOR3, currLookVector)
		local yawRotatedVector = (CFrame.Angles(0, -vrRotateInput.x, 0) * startCFrame * CFrame.Angles(-vrRotateInput.y,0,0)).lookVector
		return (yawRotatedVector * X1_Y0_Z1).unit
	end
	
	function BaseCamera:GetHumanoid()
		local character = player and player.Character
		if character then
			local resultHumanoid = self.humanoidCache[player]
			if resultHumanoid and resultHumanoid.Parent == character then
				return resultHumanoid
			else
				self.humanoidCache[player] = nil -- Bust Old Cache
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					self.humanoidCache[player] = humanoid
				end
				return humanoid
			end
		end
		return nil
	end
	
	function BaseCamera:GetHumanoidPartToFollow(humanoid, humanoidStateType)
		if humanoidStateType == Enum.HumanoidStateType.Dead then
			local character = humanoid.Parent
			if character then
				return character:FindFirstChild("Head") or humanoid.Torso
			else
				return humanoid.Torso
			end
		else
			return humanoid.Torso
		end
	end
	
	function BaseCamera:UpdateGamepad()
		local gamepadPan = self.gamepadPanningCamera
		if gamepadPan and (self.hasGameLoaded or not VRService.VREnabled) then
			gamepadPan = Util.GamepadLinearToCurve(gamepadPan)
			local currentTime = tick()
			if gamepadPan.X ~= 0 or gamepadPan.Y ~= 0 then
				self.userPanningTheCamera = true
			elseif gamepadPan == ZERO_VECTOR2 then
				self.lastThumbstickRotate = nil
				if self.lastThumbstickPos == ZERO_VECTOR2 then
					self.currentSpeed = 0
				end
			end
	
			local finalConstant = 0
	
			if self.lastThumbstickRotate then
				if VRService.VREnabled then
					self.currentSpeed = self.vrMaxSpeed
				else
					local elapsedTime = (currentTime - self.lastThumbstickRotate) * 10
					self.currentSpeed = self.currentSpeed + (self.maxSpeed * ((elapsedTime*elapsedTime)/self.numOfSeconds))
	
					if self.currentSpeed > self.maxSpeed then self.currentSpeed = self.maxSpeed end
	
					if self.lastVelocity then
						local velocity = (gamepadPan - self.lastThumbstickPos)/(currentTime - self.lastThumbstickRotate)
						local velocityDeltaMag = (velocity - self.lastVelocity).magnitude
	
						if velocityDeltaMag > 12 then
							self.currentSpeed = self.currentSpeed * (20/velocityDeltaMag)
							if self.currentSpeed > self.maxSpeed then self.currentSpeed = self.maxSpeed end
						end
					end
				end
	
				finalConstant = UserGameSettings.GamepadCameraSensitivity * self.currentSpeed
				self.lastVelocity = (gamepadPan - self.lastThumbstickPos)/(currentTime - self.lastThumbstickRotate)
			end
	
			self.lastThumbstickPos = gamepadPan
			self.lastThumbstickRotate = currentTime
	
			return Vector2.new( gamepadPan.X * finalConstant, gamepadPan.Y * finalConstant * self.ySensitivity * UserGameSettings:GetCameraYInvertValue())
		end
	
		return ZERO_VECTOR2
	end
	
	-- [[ VR Support Section ]] --
	
	function BaseCamera:ApplyVRTransform()
		if not VRService.VREnabled then
			return
		end
	
		--we only want this to happen in first person VR
		local rootJoint = self.humanoidRootPart and self.humanoidRootPart:FindFirstChild("RootJoint")
		if not rootJoint then
			return
		end
	
		local cameraSubject = game.Workspace.CurrentCamera.CameraSubject
		local isInVehicle = cameraSubject and cameraSubject:IsA("VehicleSeat")
	
		if self.inFirstPerson and not isInVehicle then
			local vrFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
			local vrRotation = vrFrame - vrFrame.p
			rootJoint.C0 = CFrame.new(vrRotation:vectorToObjectSpace(vrFrame.p)) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
		else
			rootJoint.C0 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
		end
	end
	
	function BaseCamera:IsInFirstPerson()
		return self.inFirstPerson
	end
	
	function BaseCamera:ShouldUseVRRotation()
		if not VRService.VREnabled then
			return false
		end
	
		if not self.VRRotationIntensityAvailable and tick() - self.lastVRRotationIntensityCheckTime < 1 then
			return false
		end
	
		local success, vrRotationIntensity = pcall(function() return StarterGui:GetCore("VRRotationIntensity") end)
		self.VRRotationIntensityAvailable = success and vrRotationIntensity ~= nil
		self.lastVRRotationIntensityCheckTime = tick()
	
		self.shouldUseVRRotation = success and vrRotationIntensity ~= nil and vrRotationIntensity ~= "Smooth"
	
		return self.shouldUseVRRotation
	end
	
	function BaseCamera:GetVRRotationInput()
		local vrRotateSum = ZERO_VECTOR2
		local success, vrRotationIntensity = pcall(function() return StarterGui:GetCore("VRRotationIntensity") end)
	
		if not success then
			return
		end
	
		local vrGamepadRotation = self.GamepadPanningCamera or ZERO_VECTOR2
		local delayExpired = (tick() - self.lastVRRotationTime) >= self:GetRepeatDelayValue(vrRotationIntensity)
	
		if math.abs(vrGamepadRotation.x) >= self:GetActivateValue() then
			if (delayExpired or not self.vrRotateKeyCooldown[Enum.KeyCode.Thumbstick2]) then
				local sign = 1
				if vrGamepadRotation.x < 0 then
					sign = -1
				end
				vrRotateSum = vrRotateSum + self:GetRotateAmountValue(vrRotationIntensity) * sign
				self.vrRotateKeyCooldown[Enum.KeyCode.Thumbstick2] = true
			end
		elseif math.abs(vrGamepadRotation.x) < self:GetActivateValue() - 0.1 then
			self.vrRotateKeyCooldown[Enum.KeyCode.Thumbstick2] = nil
		end
		if self.turningLeft then
			if delayExpired or not self.vrRotateKeyCooldown[Enum.KeyCode.Left] then
				vrRotateSum = vrRotateSum - self:GetRotateAmountValue(vrRotationIntensity)
				self.vrRotateKeyCooldown[Enum.KeyCode.Left] = true
			end
		else
			self.vrRotateKeyCooldown[Enum.KeyCode.Left] = nil
		end
		if self.turningRight then
			if (delayExpired or not self.vrRotateKeyCooldown[Enum.KeyCode.Right]) then
				vrRotateSum = vrRotateSum + self:GetRotateAmountValue(vrRotationIntensity)
				self.vrRotateKeyCooldown[Enum.KeyCode.Right] = true
			end
		else
			self.vrRotateKeyCooldown[Enum.KeyCode.Right] = nil
		end
	
		if vrRotateSum ~= ZERO_VECTOR2 then
			self.lastVRRotationTime = tick()
		end
	
		return vrRotateSum
	end
	
	function BaseCamera:CancelCameraFreeze(keepConstraints)
		if not keepConstraints then
			self.cameraTranslationConstraints = Vector3.new(self.cameraTranslationConstraints.x, 1, self.cameraTranslationConstraints.z)
		end
		if self.cameraFrozen then
			self.trackingHumanoid = nil
			self.cameraFrozen = false
		end
	end
	
	function BaseCamera:StartCameraFreeze(subjectPosition, humanoidToTrack)
		if not self.cameraFrozen then
			self.humanoidJumpOrigin = subjectPosition
			self.trackingHumanoid = humanoidToTrack
			self.cameraTranslationConstraints = Vector3.new(self.cameraTranslationConstraints.x, 0, self.cameraTranslationConstraints.z)
			self.cameraFrozen = true
		end
	end
	
	function BaseCamera:OnNewCameraSubject()
		if self.subjectStateChangedConn then
			self.subjectStateChangedConn:Disconnect()
			self.subjectStateChangedConn = nil
		end
	
		local humanoid = workspace.CurrentCamera and workspace.CurrentCamera.CameraSubject
		if self.trackingHumanoid ~= humanoid then
			self:CancelCameraFreeze()
		end
		if humanoid and humanoid:IsA("Humanoid") then
			self.subjectStateChangedConn = humanoid.StateChanged:Connect(function(oldState, newState)
				if VRService.VREnabled and newState == Enum.HumanoidStateType.Jumping and not self.inFirstPerson then
					self:StartCameraFreeze(self:GetSubjectPosition(), humanoid)
				elseif newState ~= Enum.HumanoidStateType.Jumping and newState ~= Enum.HumanoidStateType.Freefall then
					self:CancelCameraFreeze(true)
				end
			end)
		end
	end
	
	function BaseCamera:GetVRFocus(subjectPosition, timeDelta)
		local lastFocus = self.LastCameraFocus or subjectPosition
		if not self.cameraFrozen then
			self.cameraTranslationConstraints = Vector3.new(self.cameraTranslationConstraints.x, math.min(1, self.cameraTranslationConstraints.y + 0.42 * timeDelta), self.cameraTranslationConstraints.z)
		end
	
		local newFocus
		if self.cameraFrozen and self.humanoidJumpOrigin and self.humanoidJumpOrigin.y > lastFocus.y then
			newFocus = CFrame.new(Vector3.new(subjectPosition.x, math.min(self.humanoidJumpOrigin.y, lastFocus.y + 5 * timeDelta), subjectPosition.z))
		else
			newFocus = CFrame.new(Vector3.new(subjectPosition.x, lastFocus.y, subjectPosition.z):lerp(subjectPosition, self.cameraTranslationConstraints.y))
		end
	
		if self.cameraFrozen then
			-- No longer in 3rd person
			if self.inFirstPerson then -- not VRService.VREnabled
				self:CancelCameraFreeze()
			end
			-- This case you jumped off a cliff and want to keep your character in view
			-- 0.5 is to fix floating point error when not jumping off cliffs
			if self.humanoidJumpOrigin and subjectPosition.y < (self.humanoidJumpOrigin.y - 0.5) then
				self:CancelCameraFreeze()
			end
		end
	
		return newFocus
	end
	
	function BaseCamera:GetRotateAmountValue(vrRotationIntensity)
		vrRotationIntensity = vrRotationIntensity or StarterGui:GetCore("VRRotationIntensity")
		if vrRotationIntensity then
			if vrRotationIntensity == "Low" then
				return VR_LOW_INTENSITY_ROTATION
			elseif vrRotationIntensity == "High" then
				return VR_HIGH_INTENSITY_ROTATION
			end
		end
		return ZERO_VECTOR2
	end
	
	function BaseCamera:GetRepeatDelayValue(vrRotationIntensity)
		vrRotationIntensity = vrRotationIntensity or StarterGui:GetCore("VRRotationIntensity")
		if vrRotationIntensity then
			if vrRotationIntensity == "Low" then
				return VR_LOW_INTENSITY_REPEAT
			elseif vrRotationIntensity == "High" then
				return VR_HIGH_INTENSITY_REPEAT
			end
		end
		return 0
	end
	
	function BaseCamera:Update(dt)
		error("BaseCamera:Update() This is a virtual function that should never be getting called.", 2)
	end
	
	BaseCamera.UpCFrame = CFrame.new()
	
	function BaseCamera:UpdateUpCFrame(cf)
		self.UpCFrame = cf
	end
	local ZERO = Vector3.new(0, 0, 0)
	function BaseCamera:CalculateNewLookCFrame(suppliedLookVector)
		local currLookVector = suppliedLookVector or self:GetCameraLookVector()
		currLookVector = self.UpCFrame:VectorToObjectSpace(currLookVector)
		
		local currPitchAngle = math.asin(currLookVector.y)
		local yTheta = math.clamp(self.rotateInput.y, -MAX_Y + currPitchAngle, -MIN_Y + currPitchAngle)
		local constrainedRotateInput = Vector2.new(self.rotateInput.x, yTheta)
		local startCFrame = CFrame.new(ZERO, currLookVector)
		local newLookCFrame = CFrame.Angles(0, -constrainedRotateInput.x, 0) * startCFrame * CFrame.Angles(-constrainedRotateInput.y,0,0)
		
		return newLookCFrame
	end
	
	return BaseCamera
end

function _BaseOcclusion()
	--[[ The Module ]]--
	local BaseOcclusion = {}
	BaseOcclusion.__index = BaseOcclusion
	setmetatable(BaseOcclusion, {
		__call = function(_, ...)
			return BaseOcclusion.new(...)
		end
	})
	
	function BaseOcclusion.new()
		local self = setmetatable({}, BaseOcclusion)
		return self
	end
	
	-- Called when character is added
	function BaseOcclusion:CharacterAdded(char, player)
	end
	
	-- Called when character is about to be removed
	function BaseOcclusion:CharacterRemoving(char, player)
	end
	
	function BaseOcclusion:OnCameraSubjectChanged(newSubject)
	end
	
	--[[ Derived classes are required to override and implement all of the following functions ]]--
	function BaseOcclusion:GetOcclusionMode()
		-- Must be overridden in derived classes to return an Enum.DevCameraOcclusionMode value
		warn("BaseOcclusion GetOcclusionMode must be overridden by derived classes")
		return nil
	end
	
	function BaseOcclusion:Enable(enabled)
		warn("BaseOcclusion Enable must be overridden by derived classes")
	end
	
	function BaseOcclusion:Update(dt, desiredCameraCFrame, desiredCameraFocus)
		warn("BaseOcclusion Update must be overridden by derived classes")
		return desiredCameraCFrame, desiredCameraFocus
	end
	
	return BaseOcclusion
end

function _Popper()
	
	local Players = game:GetService("Players")
	
	local camera = game.Workspace.CurrentCamera
	
	local min = math.min
	local tan = math.tan
	local rad = math.rad
	local inf = math.huge
	local ray = Ray.new
	
	local function getTotalTransparency(part)
		return 1 - (1 - part.Transparency)*(1 - part.LocalTransparencyModifier)
	end
	
	local function eraseFromEnd(t, toSize)
		for i = #t, toSize + 1, -1 do
			t[i] = nil
		end
	end
	
	local nearPlaneZ, projX, projY do
		local function updateProjection()
			local fov = rad(camera.FieldOfView)
			local view = camera.ViewportSize
			local ar = view.X/view.Y
	
			projY = 2*tan(fov/2)
			projX = ar*projY
		end
	
		camera:GetPropertyChangedSignal("FieldOfView"):Connect(updateProjection)
		camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateProjection)
	
		updateProjection()
	
		nearPlaneZ = camera.NearPlaneZ
		camera:GetPropertyChangedSignal("NearPlaneZ"):Connect(function()
			nearPlaneZ = camera.NearPlaneZ
		end)
	end
	
	local blacklist = {} do
		local charMap = {}
	
		local function refreshIgnoreList()
			local n = 1
			blacklist = {}
			for _, character in pairs(charMap) do
				blacklist[n] = character
				n = n + 1
			end
		end
	
		local function playerAdded(player)
			local function characterAdded(character)
				charMap[player] = character
				refreshIgnoreList()
			end
			local function characterRemoving()
				charMap[player] = nil
				refreshIgnoreList()
			end
	
			player.CharacterAdded:Connect(characterAdded)
			player.CharacterRemoving:Connect(characterRemoving)
			if player.Character then
				characterAdded(player.Character)
			end
		end
	
		local function playerRemoving(player)
			charMap[player] = nil
			refreshIgnoreList()
		end
	
		Players.PlayerAdded:Connect(playerAdded)
		Players.PlayerRemoving:Connect(playerRemoving)
	
		for _, player in ipairs(Players:GetPlayers()) do
			playerAdded(player)
		end
		refreshIgnoreList()
	end
	
	--------------------------------------------------------------------------------------------
	-- Popper uses the level geometry find an upper bound on subject-to-camera distance.
	--
	-- Hard limits are applied immediately and unconditionally. They are generally caused
	-- when level geometry intersects with the near plane (with exceptions, see below).
	--
	-- Soft limits are only applied under certain conditions.
	-- They are caused when level geometry occludes the subject without actually intersecting
	-- with the near plane at the target distance.
	--
	-- Soft limits can be promoted to hard limits and hard limits can be demoted to soft limits.
	-- We usually don"t want the latter to happen.
	--
	-- A soft limit will be promoted to a hard limit if an obstruction
	-- lies between the current and target camera positions.
	--------------------------------------------------------------------------------------------
	
	local subjectRoot
	local subjectPart
	
	camera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
		local subject = camera.CameraSubject
		if subject:IsA("Humanoid") then
			subjectPart = subject.RootPart
		elseif subject:IsA("BasePart") then
			subjectPart = subject
		else
			subjectPart = nil
		end
	end)
	
	local function canOcclude(part)
		-- Occluders must be:
		-- 1. Opaque
		-- 2. Interactable
		-- 3. Not in the same assembly as the subject
	
		return
			getTotalTransparency(part) < 0.25 and
			part.CanCollide and
			subjectRoot ~= (part:GetRootPart() or part) and
			not part:IsA("TrussPart")
	end
	
	-- Offsets for the volume visibility test
	local SCAN_SAMPLE_OFFSETS = {
		Vector2.new( 0.4, 0.0),
		Vector2.new(-0.4, 0.0),
		Vector2.new( 0.0,-0.4),
		Vector2.new( 0.0, 0.4),
		Vector2.new( 0.0, 0.2),
	}
	
	--------------------------------------------------------------------------------
	-- Piercing raycasts
	
	local function getCollisionPoint(origin, dir)
		local originalSize = #blacklist
		repeat
			local hitPart, hitPoint = workspace:FindPartOnRayWithIgnoreList(
				ray(origin, dir), blacklist, false, true
			)
	
			if hitPart then
				if hitPart.CanCollide then
					eraseFromEnd(blacklist, originalSize)
					return hitPoint, true
				end
				blacklist[#blacklist + 1] = hitPart
			end
		until not hitPart
	
		eraseFromEnd(blacklist, originalSize)
		return origin + dir, false
	end
	
	--------------------------------------------------------------------------------
	
	local function queryPoint(origin, unitDir, dist, lastPos)
		debug.profilebegin("queryPoint")
	
		local originalSize = #blacklist
	
		dist = dist + nearPlaneZ
		local target = origin + unitDir*dist
	
		local softLimit = inf
		local hardLimit = inf
		local movingOrigin = origin
	
		repeat
			local entryPart, entryPos = workspace:FindPartOnRayWithIgnoreList(ray(movingOrigin, target - movingOrigin), blacklist, false, true)
	
			if entryPart then
				if canOcclude(entryPart) then
					local wl = {entryPart}
					local exitPart = workspace:FindPartOnRayWithWhitelist(ray(target, entryPos - target), wl, true)
	
					local lim = (entryPos - origin).Magnitude
	
					if exitPart then
						local promote = false
						if lastPos then
							promote =
								workspace:FindPartOnRayWithWhitelist(ray(lastPos, target - lastPos), wl, true) or
								workspace:FindPartOnRayWithWhitelist(ray(target, lastPos - target), wl, true)
						end
	
						if promote then
							-- Ostensibly a soft limit, but the camera has passed through it in the last frame, so promote to a hard limit.
							hardLimit = lim
						elseif dist < softLimit then
							-- Trivial soft limit
							softLimit = lim
						end
					else
						-- Trivial hard limit
						hardLimit = lim
					end
				end
	
				blacklist[#blacklist + 1] = entryPart
				movingOrigin = entryPos - unitDir*1e-3
			end
		until hardLimit < inf or not entryPart
	
		eraseFromEnd(blacklist, originalSize)
	
		debug.profileend()
		return softLimit - nearPlaneZ, hardLimit - nearPlaneZ
	end
	
	local function queryViewport(focus, dist)
		debug.profilebegin("queryViewport")
	
		local fP =  focus.p
		local fX =  focus.rightVector
		local fY =  focus.upVector
		local fZ = -focus.lookVector
	
		local viewport = camera.ViewportSize
	
		local hardBoxLimit = inf
		local softBoxLimit = inf
	
		-- Center the viewport on the PoI, sweep points on the edge towards the target, and take the minimum limits
		for viewX = 0, 1 do
			local worldX = fX*((viewX - 0.5)*projX)
	
			for viewY = 0, 1 do
				local worldY = fY*((viewY - 0.5)*projY)
	
				local origin = fP + nearPlaneZ*(worldX + worldY)
				local lastPos = camera:ViewportPointToRay(
					viewport.x*viewX,
					viewport.y*viewY
				).Origin
	
				local softPointLimit, hardPointLimit = queryPoint(origin, fZ, dist, lastPos)
	
				if hardPointLimit < hardBoxLimit then
					hardBoxLimit = hardPointLimit
				end
				if softPointLimit < softBoxLimit then
					softBoxLimit = softPointLimit
				end
			end
		end
		debug.profileend()
	
		return softBoxLimit, hardBoxLimit
	end
	
	local function testPromotion(focus, dist, focusExtrapolation)
		debug.profilebegin("testPromotion")
	
		local fP = focus.p
		local fX = focus.rightVector
		local fY = focus.upVector
		local fZ = -focus.lookVector
	
		do
			-- Dead reckoning the camera rotation and focus
			debug.profilebegin("extrapolate")
	
			local SAMPLE_DT = 0.0625
			local SAMPLE_MAX_T = 1.25
	
			local maxDist = (getCollisionPoint(fP, focusExtrapolation.posVelocity*SAMPLE_MAX_T) - fP).Magnitude
			-- Metric that decides how many samples to take
			local combinedSpeed = focusExtrapolation.posVelocity.magnitude
	
			for dt = 0, min(SAMPLE_MAX_T, focusExtrapolation.rotVelocity.magnitude + maxDist/combinedSpeed), SAMPLE_DT do
				local cfDt = focusExtrapolation.extrapolate(dt) -- Extrapolated CFrame at time dt
	
				if queryPoint(cfDt.p, -cfDt.lookVector, dist) >= dist then
					return false
				end
			end
	
			debug.profileend()
		end
	
		do
			-- Test screen-space offsets from the focus for the presence of soft limits
			debug.profilebegin("testOffsets")
	
			for _, offset in ipairs(SCAN_SAMPLE_OFFSETS) do
				local scaledOffset = offset
				local pos = getCollisionPoint(fP, fX*scaledOffset.x + fY*scaledOffset.y)
				if queryPoint(pos, (fP + fZ*dist - pos).Unit, dist) == inf then
					return false
				end
			end
	
			debug.profileend()
		end
	
		debug.profileend()
		return true
	end
	
	local function Popper(focus, targetDist, focusExtrapolation)
		debug.profilebegin("popper")
	
		subjectRoot = subjectPart and subjectPart:GetRootPart() or subjectPart
	
		local dist = targetDist
		local soft, hard = queryViewport(focus, targetDist)
		if hard < dist then
			dist = hard
		end
		if soft < dist and testPromotion(focus, targetDist, focusExtrapolation) then
			dist = soft
		end
	
		subjectRoot = nil
	
		debug.profileend()
		return dist
	end
	
	return Popper
end

function _ZoomController()
	local ZOOM_STIFFNESS = 4.5
	local ZOOM_DEFAULT = 12.5
	local ZOOM_ACCELERATION = 0.0375
	
	local MIN_FOCUS_DIST = 0.5
	local DIST_OPAQUE = 1
	
	local Popper = _Popper()
	
	local clamp = math.clamp
	local exp = math.exp
	local min = math.min
	local max = math.max
	local pi = math.pi
	
	local cameraMinZoomDistance, cameraMaxZoomDistance do
		local Player = game:GetService("Players").LocalPlayer
	
		local function updateBounds()
			cameraMinZoomDistance = Player.CameraMinZoomDistance
			cameraMaxZoomDistance = Player.CameraMaxZoomDistance
		end
	
		updateBounds()
	
		Player:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(updateBounds)
		Player:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(updateBounds)
	end
	
	local ConstrainedSpring = {} do
		ConstrainedSpring.__index = ConstrainedSpring
	
		function ConstrainedSpring.new(freq, x, minValue, maxValue)
			x = clamp(x, minValue, maxValue)
			return setmetatable({
				freq = freq, -- Undamped frequency (Hz)
				x = x, -- Current position
				v = 0, -- Current velocity
				minValue = minValue, -- Minimum bound
				maxValue = maxValue, -- Maximum bound
				goal = x, -- Goal position
			}, ConstrainedSpring)
		end
	
		function ConstrainedSpring:Step(dt)
			local freq = self.freq*2*pi -- Convert from Hz to rad/s
			local x = self.x
			local v = self.v
			local minValue = self.minValue
			local maxValue = self.maxValue
			local goal = self.goal
	
			-- Solve the spring ODE for position and velocity after time t, assuming critical damping:
			--   2*f*x'[t] + x''[t] = f^2*(g - x[t])
			-- Knowns are x[0] and x'[0].
			-- Solve for x[t] and x'[t].
	
			local offset = goal - x
			local step = freq*dt
			local decay = exp(-step)
	
			local x1 = goal + (v*dt - offset*(step + 1))*decay
			local v1 = ((offset*freq - v)*step + v)*decay
	
			-- Constrain
			if x1 < minValue then
				x1 = minValue
				v1 = 0
			elseif x1 > maxValue then
				x1 = maxValue
				v1 = 0
			end
	
			self.x = x1
			self.v = v1
	
			return x1
		end
	end
	
	local zoomSpring = ConstrainedSpring.new(ZOOM_STIFFNESS, ZOOM_DEFAULT, MIN_FOCUS_DIST, cameraMaxZoomDistance)
	
	local function stepTargetZoom(z, dz, zoomMin, zoomMax)
		z = clamp(z + dz*(1 + z*ZOOM_ACCELERATION), zoomMin, zoomMax)
		if z < DIST_OPAQUE then
			z = dz <= 0 and zoomMin or DIST_OPAQUE
		end
		return z
	end
	
	local zoomDelta = 0
	
	local Zoom = {} do
		function Zoom.Update(renderDt, focus, extrapolation)
			local poppedZoom = math.huge
	
			if zoomSpring.goal > DIST_OPAQUE then
				-- Make a pessimistic estimate of zoom distance for this step without accounting for poppercam
				local maxPossibleZoom = max(
					zoomSpring.x,
					stepTargetZoom(zoomSpring.goal, zoomDelta, cameraMinZoomDistance, cameraMaxZoomDistance)
				)
	
				-- Run the Popper algorithm on the feasible zoom range, [MIN_FOCUS_DIST, maxPossibleZoom]
				poppedZoom = Popper(
					focus*CFrame.new(0, 0, MIN_FOCUS_DIST),
					maxPossibleZoom - MIN_FOCUS_DIST,
					extrapolation
				) + MIN_FOCUS_DIST
			end
	
			zoomSpring.minValue = MIN_FOCUS_DIST
			zoomSpring.maxValue = min(cameraMaxZoomDistance, poppedZoom)
	
			return zoomSpring:Step(renderDt)
		end
	
		function Zoom.SetZoomParameters(targetZoom, newZoomDelta)
			zoomSpring.goal = targetZoom
			zoomDelta = newZoomDelta
		end
	end
	
	return Zoom
end

function _MouseLockController()
	--[[ Constants ]]--
	local DEFAULT_MOUSE_LOCK_CURSOR = "rbxasset://textures/MouseLockedCursor.png"
	
	local CONTEXT_ACTION_NAME = "MouseLockSwitchAction"
	local MOUSELOCK_ACTION_PRIORITY = Enum.ContextActionPriority.Default.Value
	
	--[[ Services ]]--
	local PlayersService = game:GetService("Players")
	local ContextActionService = game:GetService("ContextActionService")
	local Settings = UserSettings()	-- ignore warning
	local GameSettings = Settings.GameSettings
	local Mouse = PlayersService.LocalPlayer:GetMouse()
	
	--[[ The Module ]]--
	local MouseLockController = {}
	MouseLockController.__index = MouseLockController
	
	function MouseLockController.new()
		local self = setmetatable({}, MouseLockController)
	
		self.isMouseLocked = false
		self.savedMouseCursor = nil
		self.boundKeys = {Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift} -- defaults
	
		self.mouseLockToggledEvent = Instance.new("BindableEvent")
	
		local boundKeysObj = script:FindFirstChild("BoundKeys")
		if (not boundKeysObj) or (not boundKeysObj:IsA("StringValue")) then
			-- If object with correct name was found, but it's not a StringValue, destroy and replace
			if boundKeysObj then
				boundKeysObj:Destroy()
			end
	
			boundKeysObj = Instance.new("StringValue")
			boundKeysObj.Name = "BoundKeys"
			boundKeysObj.Value = "LeftShift,RightShift"
			boundKeysObj.Parent = script
		end
	
		if boundKeysObj then
			boundKeysObj.Changed:Connect(function(value)
				self:OnBoundKeysObjectChanged(value)
			end)
			self:OnBoundKeysObjectChanged(boundKeysObj.Value) -- Initial setup call
		end
	
		-- Watch for changes to user's ControlMode and ComputerMovementMode settings and update the feature availability accordingly
		GameSettings.Changed:Connect(function(property)
			if property == "ControlMode" or property == "ComputerMovementMode" then
				self:UpdateMouseLockAvailability()
			end
		end)
	
		-- Watch for changes to DevEnableMouseLock and update the feature availability accordingly
		PlayersService.LocalPlayer:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function()
			self:UpdateMouseLockAvailability()
		end)
	
		-- Watch for changes to DevEnableMouseLock and update the feature availability accordingly
		PlayersService.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function()
			self:UpdateMouseLockAvailability()
		end)
	
		self:UpdateMouseLockAvailability()
	
		return self
	end
	
	function MouseLockController:GetIsMouseLocked()
		return self.isMouseLocked
	end
	
	function MouseLockController:GetBindableToggleEvent()
		return self.mouseLockToggledEvent.Event
	end
	
	function MouseLockController:GetMouseLockOffset()
		local offsetValueObj = script:FindFirstChild("CameraOffset")
		if offsetValueObj and offsetValueObj:IsA("Vector3Value") then
			return offsetValueObj.Value
		else
			-- If CameraOffset object was found but not correct type, destroy
			if offsetValueObj then
				offsetValueObj:Destroy()
			end
			offsetValueObj = Instance.new("Vector3Value")
			offsetValueObj.Name = "CameraOffset"
			offsetValueObj.Value = Vector3.new(1.75,0,0) -- Legacy Default Value
			offsetValueObj.Parent = script
		end
	
		if offsetValueObj and offsetValueObj.Value then
			return offsetValueObj.Value
		end
	
		return Vector3.new(1.75,0,0)
	end
	
	function MouseLockController:UpdateMouseLockAvailability()
		local devAllowsMouseLock = PlayersService.LocalPlayer.DevEnableMouseLock
		local devMovementModeIsScriptable = PlayersService.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
		local userHasMouseLockModeEnabled = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch
		local userHasClickToMoveEnabled =  GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove
		local MouseLockAvailable = devAllowsMouseLock and userHasMouseLockModeEnabled and not userHasClickToMoveEnabled and not devMovementModeIsScriptable
	
		if MouseLockAvailable~=self.enabled then
			self:EnableMouseLock(MouseLockAvailable)
		end
	end
	
	function MouseLockController:OnBoundKeysObjectChanged(newValue)
		self.boundKeys = {} -- Overriding defaults, note: possibly with nothing at all if boundKeysObj.Value is "" or contains invalid values
		for token in string.gmatch(newValue,"[^%s,]+") do
			for _, keyEnum in pairs(Enum.KeyCode:GetEnumItems()) do
				if token == keyEnum.Name then
					self.boundKeys[#self.boundKeys+1] = keyEnum
					break
				end
			end
		end
		self:UnbindContextActions()
		self:BindContextActions()
	end
	
	--[[ Local Functions ]]--
	function MouseLockController:OnMouseLockToggled()
		self.isMouseLocked = not self.isMouseLocked
	
		if self.isMouseLocked then
			local cursorImageValueObj = script:FindFirstChild("CursorImage")
			if cursorImageValueObj and cursorImageValueObj:IsA("StringValue") and cursorImageValueObj.Value then
				self.savedMouseCursor = Mouse.Icon
				Mouse.Icon = cursorImageValueObj.Value
			else
				if cursorImageValueObj then
					cursorImageValueObj:Destroy()
				end
				cursorImageValueObj = Instance.new("StringValue")
				cursorImageValueObj.Name = "CursorImage"
				cursorImageValueObj.Value = DEFAULT_MOUSE_LOCK_CURSOR
				cursorImageValueObj.Parent = script
				self.savedMouseCursor = Mouse.Icon
				Mouse.Icon = DEFAULT_MOUSE_LOCK_CURSOR
			end
		else
			if self.savedMouseCursor then
				Mouse.Icon = self.savedMouseCursor
				self.savedMouseCursor = nil
			end
		end
	
		self.mouseLockToggledEvent:Fire()
	end
	
	function MouseLockController:DoMouseLockSwitch(name, state, input)
		if state == Enum.UserInputState.Begin then
			self:OnMouseLockToggled()
			return Enum.ContextActionResult.Sink
		end
		return Enum.ContextActionResult.Pass
	end
	
	function MouseLockController:BindContextActions()
		ContextActionService:BindActionAtPriority(CONTEXT_ACTION_NAME, function(name, state, input)
			return self:DoMouseLockSwitch(name, state, input)
		end, false, MOUSELOCK_ACTION_PRIORITY, unpack(self.boundKeys))
	end
	
	function MouseLockController:UnbindContextActions()
		ContextActionService:UnbindAction(CONTEXT_ACTION_NAME)
	end
	
	function MouseLockController:IsMouseLocked()
		return self.enabled and self.isMouseLocked
	end
	
	function MouseLockController:EnableMouseLock(enable)
		if enable ~= self.enabled then
	
			self.enabled = enable
	
			if self.enabled then
				-- Enabling the mode
				self:BindContextActions()
			else
				-- Disabling
				-- Restore mouse cursor
				if Mouse.Icon~="" then
					Mouse.Icon = ""
				end
	
				self:UnbindContextActions()
	
				-- If the mode is disabled while being used, fire the event to toggle it off
				if self.isMouseLocked then
					self.mouseLockToggledEvent:Fire()
				end
	
				self.isMouseLocked = false
			end
	
		end
	end
	
	return MouseLockController
end

function _TransparencyController()
	
	local MAX_TWEEN_RATE = 2.8 -- per second
	
	local Util = _CameraUtils()
	
	--[[ The Module ]]--
	local TransparencyController = {}
	TransparencyController.__index = TransparencyController
	
	function TransparencyController.new()
		local self = setmetatable({}, TransparencyController)
	
		self.lastUpdate = tick()
		self.transparencyDirty = false
		self.enabled = false
		self.lastTransparency = nil
	
		self.descendantAddedConn, self.descendantRemovingConn = nil, nil
		self.toolDescendantAddedConns = {}
		self.toolDescendantRemovingConns = {}
		self.cachedParts = {}
	
		return self
	end
	
	
	function TransparencyController:HasToolAncestor(object)
		if object.Parent == nil then return false end
		return object.Parent:IsA('Tool') or self:HasToolAncestor(object.Parent)
	end
	
	function TransparencyController:IsValidPartToModify(part)
		if part:IsA('BasePart') or part:IsA('Decal') then
			return not self:HasToolAncestor(part)
		end
		return false
	end
	
	function TransparencyController:CachePartsRecursive(object)
		if object then
			if self:IsValidPartToModify(object) then
				self.cachedParts[object] = true
				self.transparencyDirty = true
			end
			for _, child in pairs(object:GetChildren()) do
				self:CachePartsRecursive(child)
			end
		end
	end
	
	function TransparencyController:TeardownTransparency()
		for child, _ in pairs(self.cachedParts) do
			child.LocalTransparencyModifier = 0
		end
		self.cachedParts = {}
		self.transparencyDirty = true
		self.lastTransparency = nil
	
		if self.descendantAddedConn then
			self.descendantAddedConn:disconnect()
			self.descendantAddedConn = nil
		end
		if self.descendantRemovingConn then
			self.descendantRemovingConn:disconnect()
			self.descendantRemovingConn = nil
		end
		for object, conn in pairs(self.toolDescendantAddedConns) do
			conn:Disconnect()
			self.toolDescendantAddedConns[object] = nil
		end
		for object, conn in pairs(self.toolDescendantRemovingConns) do
			conn:Disconnect()
			self.toolDescendantRemovingConns[object] = nil
		end
	end
	
	function TransparencyController:SetupTransparency(character)
		self:TeardownTransparency()
	
		if self.descendantAddedConn then self.descendantAddedConn:disconnect() end
		self.descendantAddedConn = character.DescendantAdded:Connect(function(object)
			-- This is a part we want to invisify
			if self:IsValidPartToModify(object) then
				self.cachedParts[object] = true
				self.transparencyDirty = true
			-- There is now a tool under the character
			elseif object:IsA('Tool') then
				if self.toolDescendantAddedConns[object] then self.toolDescendantAddedConns[object]:Disconnect() end
				self.toolDescendantAddedConns[object] = object.DescendantAdded:Connect(function(toolChild)
					self.cachedParts[toolChild] = nil
					if toolChild:IsA('BasePart') or toolChild:IsA('Decal') then
						-- Reset the transparency
						toolChild.LocalTransparencyModifier = 0
					end
				end)
				if self.toolDescendantRemovingConns[object] then self.toolDescendantRemovingConns[object]:disconnect() end
				self.toolDescendantRemovingConns[object] = object.DescendantRemoving:Connect(function(formerToolChild)
					wait() -- wait for new parent
					if character and formerToolChild and formerToolChild:IsDescendantOf(character) then
						if self:IsValidPartToModify(formerToolChild) then
							self.cachedParts[formerToolChild] = true
							self.transparencyDirty = true
						end
					end
				end)
			end
		end)
		if self.descendantRemovingConn then self.descendantRemovingConn:disconnect() end
		self.descendantRemovingConn = character.DescendantRemoving:connect(function(object)
			if self.cachedParts[object] then
				self.cachedParts[object] = nil
				-- Reset the transparency
				object.LocalTransparencyModifier = 0
			end
		end)
		self:CachePartsRecursive(character)
	end
	
	
	function TransparencyController:Enable(enable)
		if self.enabled ~= enable then
			self.enabled = enable
			self:Update()
		end
	end
	
	function TransparencyController:SetSubject(subject)
		local character = nil
		if subject and subject:IsA("Humanoid") then
			character = subject.Parent
		end
		if subject and subject:IsA("VehicleSeat") and subject.Occupant then
			character = subject.Occupant.Parent
		end
		if character then
			self:SetupTransparency(character)
		else
			self:TeardownTransparency()
		end
	end
	
	function TransparencyController:Update()
		local instant = false
		local now = tick()
		local currentCamera = workspace.CurrentCamera
	
		if currentCamera then
			local transparency = 0
			if not self.enabled then
				instant = true
			else
				local distance = (currentCamera.Focus.p - currentCamera.CoordinateFrame.p).magnitude
				transparency = (distance<2) and (1.0-(distance-0.5)/1.5) or 0 --(7 - distance) / 5
				if transparency < 0.5 then
					transparency = 0
				end
	
				if self.lastTransparency then
					local deltaTransparency = transparency - self.lastTransparency
	
					-- Don't tween transparency if it is instant or your character was fully invisible last frame
					if not instant and transparency < 1 and self.lastTransparency < 0.95 then
						local maxDelta = MAX_TWEEN_RATE * (now - self.lastUpdate)
						deltaTransparency = math.clamp(deltaTransparency, -maxDelta, maxDelta)
					end
					transparency = self.lastTransparency + deltaTransparency
				else
					self.transparencyDirty = true
				end
	
				transparency = math.clamp(Util.Round(transparency, 2), 0, 1)
			end
	
			if self.transparencyDirty or self.lastTransparency ~= transparency then
				for child, _ in pairs(self.cachedParts) do
					child.LocalTransparencyModifier = transparency
				end
				self.transparencyDirty = false
				self.lastTransparency = transparency
			end
		end
		self.lastUpdate = now
	end
	
	return TransparencyController
end

function _Poppercam()
	local ZoomController =  _ZoomController()
	
	local TransformExtrapolator = {} do
		TransformExtrapolator.__index = TransformExtrapolator
	
		local CF_IDENTITY = CFrame.new()
	
		local function cframeToAxis(cframe)
			local axis, angle = cframe:toAxisAngle()
			return axis*angle
		end
	
		local function axisToCFrame(axis)
			local angle = axis.magnitude
			if angle > 1e-5 then
				return CFrame.fromAxisAngle(axis, angle)
			end
			return CF_IDENTITY
		end
	
		local function extractRotation(cf)
			local _, _, _, xx, yx, zx, xy, yy, zy, xz, yz, zz = cf:components()
			return CFrame.new(0, 0, 0, xx, yx, zx, xy, yy, zy, xz, yz, zz)
		end
	
		function TransformExtrapolator.new()
			return setmetatable({
				lastCFrame = nil,
			}, TransformExtrapolator)
		end
	
		function TransformExtrapolator:Step(dt, currentCFrame)
			local lastCFrame = self.lastCFrame or currentCFrame
			self.lastCFrame = currentCFrame
	
			local currentPos = currentCFrame.p
			local currentRot = extractRotation(currentCFrame)
	
			local lastPos = lastCFrame.p
			local lastRot = extractRotation(lastCFrame)
	
			-- Estimate velocities from the delta between now and the last frame
			-- This estimation can be a little noisy.
			local dp = (currentPos - lastPos)/dt
			local dr = cframeToAxis(currentRot*lastRot:inverse())/dt
	
			local function extrapolate(t)
				local p = dp*t + currentPos
				local r = axisToCFrame(dr*t)*currentRot
				return r + p
			end
	
			return {
				extrapolate = extrapolate,
				posVelocity = dp,
				rotVelocity = dr,
			}
		end
	
		function TransformExtrapolator:Reset()
			self.lastCFrame = nil
		end
	end
	
	--[[ The Module ]]--
	local BaseOcclusion = _BaseOcclusion()
	local Poppercam = setmetatable({}, BaseOcclusion)
	Poppercam.__index = Poppercam
	
	function Poppercam.new()
		local self = setmetatable(BaseOcclusion.new(), Poppercam)
		self.focusExtrapolator = TransformExtrapolator.new()
		return self
	end
	
	function Poppercam:GetOcclusionMode()
		return Enum.DevCameraOcclusionMode.Zoom
	end
	
	function Poppercam:Enable(enable)
		self.focusExtrapolator:Reset()
	end
	
	function Poppercam:Update(renderDt, desiredCameraCFrame, desiredCameraFocus, cameraController)
		local rotatedFocus = CFrame.new(desiredCameraFocus.p, desiredCameraCFrame.p)*CFrame.new(
			0, 0, 0,
			-1, 0, 0,
			0, 1, 0,
			0, 0, -1
		)
		local extrapolation = self.focusExtrapolator:Step(renderDt, rotatedFocus)
		local zoom = ZoomController.Update(renderDt, rotatedFocus, extrapolation)
		return rotatedFocus*CFrame.new(0, 0, zoom), desiredCameraFocus
	end
	
	-- Called when character is added
	function Poppercam:CharacterAdded(character, player)
	end
	
	-- Called when character is about to be removed
	function Poppercam:CharacterRemoving(character, player)
	end
	
	function Poppercam:OnCameraSubjectChanged(newSubject)
	end
	
	local ZoomController = _ZoomController()
	
	function Poppercam:Update(renderDt, desiredCameraCFrame, desiredCameraFocus, cameraController)
		local rotatedFocus = desiredCameraFocus * (desiredCameraCFrame - desiredCameraCFrame.p)
		local extrapolation = self.focusExtrapolator:Step(renderDt, rotatedFocus)
		local zoom = ZoomController.Update(renderDt, rotatedFocus, extrapolation)
		return rotatedFocus*CFrame.new(0, 0, zoom), desiredCameraFocus
	end
	
	return Poppercam
end

function _Invisicam()
	
	--[[ Top Level Roblox Services ]]--
	local PlayersService = game:GetService("Players")
	
	--[[ Constants ]]--
	local ZERO_VECTOR3 = Vector3.new(0,0,0)
	local USE_STACKING_TRANSPARENCY = true	-- Multiple items between the subject and camera get transparency values that add up to TARGET_TRANSPARENCY
	local TARGET_TRANSPARENCY = 0.75 -- Classic Invisicam's Value, also used by new invisicam for parts hit by head and torso rays
	local TARGET_TRANSPARENCY_PERIPHERAL = 0.5 -- Used by new SMART_CIRCLE mode for items not hit by head and torso rays
	
	local MODE = {
		--CUSTOM = 1, 		-- Retired, unused
		LIMBS = 2, 			-- Track limbs
		MOVEMENT = 3, 		-- Track movement
		CORNERS = 4, 		-- Char model corners
		CIRCLE1 = 5, 		-- Circle of casts around character
		CIRCLE2 = 6, 		-- Circle of casts around character, camera relative
		LIMBMOVE = 7, 		-- LIMBS mode + MOVEMENT mode
		SMART_CIRCLE = 8, 	-- More sample points on and around character
		CHAR_OUTLINE = 9,	-- Dynamic outline around the character
	}
	
	local LIMB_TRACKING_SET = {
		-- Body parts common to R15 and R6
		['Head'] = true,
	
		-- Body parts unique to R6
		['Left Arm'] = true,
		['Right Arm'] = true,
		['Left Leg'] = true,
		['Right Leg'] = true,
	
		-- Body parts unique to R15
		['LeftLowerArm'] = true,
		['RightLowerArm'] = true,
		['LeftUpperLeg'] = true,
		['RightUpperLeg'] = true
	}
	
	local CORNER_FACTORS = {
		Vector3.new(1,1,-1),
		Vector3.new(1,-1,-1),
		Vector3.new(-1,-1,-1),
		Vector3.new(-1,1,-1)
	}
	
	local CIRCLE_CASTS = 10
	local MOVE_CASTS = 3
	local SMART_CIRCLE_CASTS = 24
	local SMART_CIRCLE_INCREMENT = 2.0 * math.pi / SMART_CIRCLE_CASTS
	local CHAR_OUTLINE_CASTS = 24
	
	-- Used to sanitize user-supplied functions
	local function AssertTypes(param, ...)
		local allowedTypes = {}
		local typeString = ''
		for _, typeName in pairs({...}) do
			allowedTypes[typeName] = true
			typeString = typeString .. (typeString == '' and '' or ' or ') .. typeName
		end
		local theType = type(param)
		assert(allowedTypes[theType], typeString .. " type expected, got: " .. theType)
	end
	
	-- Helper function for Determinant of 3x3, not in CameraUtils for performance reasons
	local function Det3x3(a,b,c,d,e,f,g,h,i)
		return (a*(e*i-f*h)-b*(d*i-f*g)+c*(d*h-e*g))
	end
	
	-- Smart Circle mode needs the intersection of 2 rays that are known to be in the same plane
	-- because they are generated from cross products with a common vector. This function is computing
	-- that intersection, but it's actually the general solution for the point halfway between where
	-- two skew lines come nearest to each other, which is more forgiving.
	local function RayIntersection(p0, v0, p1, v1)
		local v2 = v0:Cross(v1)
		local d1 = p1.x - p0.x
		local d2 = p1.y - p0.y
		local d3 = p1.z - p0.z
		local denom = Det3x3(v0.x,-v1.x,v2.x,v0.y,-v1.y,v2.y,v0.z,-v1.z,v2.z)
	
		if (denom == 0) then
			return ZERO_VECTOR3 -- No solution (rays are parallel)
		end
	
		local t0 = Det3x3(d1,-v1.x,v2.x,d2,-v1.y,v2.y,d3,-v1.z,v2.z) / denom
		local t1 = Det3x3(v0.x,d1,v2.x,v0.y,d2,v2.y,v0.z,d3,v2.z) / denom
		local s0 = p0 + t0 * v0
		local s1 = p1 + t1 * v1
		local s = s0 + 0.5 * ( s1 - s0 )
	
		-- 0.25 studs is a threshold for deciding if the rays are
		-- close enough to be considered intersecting, found through testing 
		if (s1-s0).Magnitude < 0.25 then
			return s
		else
			return ZERO_VECTOR3
		end
	end
	
	
	
	--[[ The Module ]]--
	local BaseOcclusion = _BaseOcclusion()
	local Invisicam = setmetatable({}, BaseOcclusion)
	Invisicam.__index = Invisicam
	
	function Invisicam.new()
		local self = setmetatable(BaseOcclusion.new(), Invisicam)
	
		self.char = nil
		self.humanoidRootPart = nil
		self.torsoPart = nil
		self.headPart = nil
	
		self.childAddedConn = nil
		self.childRemovedConn = nil
	
		self.behaviors = {} 	-- Map of modes to behavior fns
		self.behaviors[MODE.LIMBS] = self.LimbBehavior
		self.behaviors[MODE.MOVEMENT] = self.MoveBehavior
		self.behaviors[MODE.CORNERS] = self.CornerBehavior
		self.behaviors[MODE.CIRCLE1] = self.CircleBehavior
		self.behaviors[MODE.CIRCLE2] = self.CircleBehavior
		self.behaviors[MODE.LIMBMOVE] = self.LimbMoveBehavior
		self.behaviors[MODE.SMART_CIRCLE] = self.SmartCircleBehavior
		self.behaviors[MODE.CHAR_OUTLINE] = self.CharacterOutlineBehavior
	
		self.mode = MODE.SMART_CIRCLE
		self.behaviorFunction = self.SmartCircleBehavior
	
		self.savedHits = {} 	-- Objects currently being faded in/out
		self.trackedLimbs = {}	-- Used in limb-tracking casting modes
	
		self.camera = game.Workspace.CurrentCamera
	
		self.enabled = false
		return self
	end
	
	function Invisicam:Enable(enable)
		self.enabled = enable
	
		if not enable then
			self:Cleanup()
		end
	end
	
	function Invisicam:GetOcclusionMode()
		return Enum.DevCameraOcclusionMode.Invisicam
	end
	
	--[[ Module functions ]]--
	function Invisicam:LimbBehavior(castPoints)
		for limb, _ in pairs(self.trackedLimbs) do
			castPoints[#castPoints + 1] = limb.Position
		end
	end
	
	function Invisicam:MoveBehavior(castPoints)
		for i = 1, MOVE_CASTS do
			local position, velocity = self.humanoidRootPart.Position, self.humanoidRootPart.Velocity
			local horizontalSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude / 2
			local offsetVector = (i - 1) * self.humanoidRootPart.CFrame.lookVector * horizontalSpeed
			castPoints[#castPoints + 1] = position + offsetVector
		end
	end
	
	function Invisicam:CornerBehavior(castPoints)
		local cframe = self.humanoidRootPart.CFrame
		local centerPoint = cframe.p
		local rotation = cframe - centerPoint
		local halfSize = self.char:GetExtentsSize() / 2 --NOTE: Doesn't update w/ limb animations
		castPoints[#castPoints + 1] = centerPoint
		for i = 1, #CORNER_FACTORS do
			castPoints[#castPoints + 1] = centerPoint + (rotation * (halfSize * CORNER_FACTORS[i]))
		end
	end
	
	function Invisicam:CircleBehavior(castPoints)
		local cframe
		if self.mode == MODE.CIRCLE1 then
			cframe = self.humanoidRootPart.CFrame
		else
			local camCFrame = self.camera.CoordinateFrame
			cframe = camCFrame …