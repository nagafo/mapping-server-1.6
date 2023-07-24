local lPlayer = getLocalPlayer()
local updTimer
local drawingTimer 
local canRecord = true
local recording = false
local recordingStep = 1
local recordData = {}
local lx = 0
local ly = 0
local lz = 0
local pVehicleModel = -1
local tVeh

-- SETTINGS
local settingsArray = getSettings()
local onGroundColor = {tonumber(settingsArray[2]), tonumber(settingsArray[3]), tonumber(settingsArray[4]),tonumber(settingsArray[5])}
if(settingsArray[1] == "true") then settingsArray[1] = true else settingsArray[1] = false end
local onGroundSingle = settingsArray[1]
local onAirColor = {tonumber(settingsArray[7]),tonumber(settingsArray[8]),tonumber(settingsArray[9]),tonumber(settingsArray[10])}
if(settingsArray[6] == "true") then settingsArray[6] = true else settingsArray[6] = false end
local onAirSingle = settingsArray[6]
local delay = tonumber(settingsArray[12])
local minDist = tonumber(settingsArray[13])
local recordingKey = settingsArray[11]
local testKey = settingsArray[14]
if(settingsArray[15] == "true") then settingsArray[15] = true else settingsArray[15] = false end
local showPoints = settingsArray[15]

-- * Updating Recording Function * --
function updateRecording()
	if(not recording)then
		return
	end
	if(not isPedInVehicle (lPlayer))then
		output("You're not in a car. Stopping.")
		stopRecording()
		return
	end
	local pVeh = getPedOccupiedVehicle(lPlayer)
	local x,y,z = getElementPosition(pVeh)
	--getElementPosition(pVeh)
	local rx,ry,rz = getElementRotation (pVeh)
	--local sx,sy,sz = getElementVelocity(pVeh)
	--local vx,vy,vz = getVehicleTurnVelocity (pVeh)
	local dist = getDistanceBetweenPoints3D ( x,y,z, lx,ly,lz )
	if(dist > minDist)then
		table.insert(recordData, {x,y,z,isVehicleOnGround ( pVeh ),rx,ry,rz})--, sx,sy,sz,recordingStep,vx,vy,vz})
		lx = x ly = y lz = z
	end
	recordingStep = recordingStep + 1
end



-- * Drawing Stopping Function * --
function endDrawing()
	destroyElement(tVeh)
	killTimer(drawingTimer)
	-- recordData = {}
	canRecord = true
end

-- * /stopdraw * --
addCommandHandler ( "cleardraw", function()
	recordData = {}
end)

-- * Drawing Updating Function * --
local cur = 2
local drawingStep = 1
function updateDrawing()
	if(recordData[cur] == nil)then
		endDrawing()
		return
	end
	if(not tVeh)then
		endDrawing()
	end
	if(drawingStep == recordData[cur][10])then
		setElementPosition(tVeh, recordData[cur][1], recordData[cur][2], recordData[cur][3])
		setElementRotation(tVeh, recordData[cur][4], recordData[cur][5], recordData[cur][6])
		setElementVelocity(tVeh, recordData[cur][7], recordData[cur][8], recordData[cur][9])
		setElementAngularVelocity(tVeh, recordData[cur][11], recordData[cur][12], recordData[cur][13])
		cur = cur + 1
	end
	drawingStep = drawingStep + 1
end

--showCursor(true, false)
screenW,screenH = guiGetScreenSize()
--local pindex = 0
--local mouseDown = false
-- * Drawing The Recorded Data Function * --
addEventHandler("onClientRender", getRootElement(), function ()
--	canRecord = false
--	cur = 2
--	drawingStep = 1
--	drawingTimer = setTimer(updateDrawing, delay, 0)
	for i=2,#recordData do
		if(not recording and showPoints)then
			dxDrawLine3D ( recordData[i][1], recordData[i][2], recordData[i][3], recordData[i][1]-0.1, recordData[i][2], recordData[i][3]+0.1, tocolor ( 255,255,255,255), 20 )
		end
		if(recordData[i-1][4])then
			if(not onGroundSingle)then
				dxDrawLine3D ( recordData[i-1][1], recordData[i-1][2], recordData[i-1][3], recordData[i][1], recordData[i][2], recordData[i][3], tocolor ( onGroundColor[1],onGroundColor[2], onGroundColor[3], onGroundColor[4]), 10 )
			else
				if(i%2 == 0)then
					dxDrawLine3D ( recordData[i-1][1], recordData[i-1][2], recordData[i-1][3], recordData[i][1], recordData[i][2], recordData[i][3], tocolor ( onGroundColor[1],onGroundColor[2], onGroundColor[3], onGroundColor[4] ), 10 )
				end
			end
		else
			if(not onAirSingle) then
				dxDrawLine3D ( recordData[i-1][1], recordData[i-1][2], recordData[i-1][3], recordData[i][1], recordData[i][2], recordData[i][3], tocolor ( onAirColor[1], onAirColor[2], onAirColor[3], onAirColor[4] ), 10 )
			else
				if(i%2 == 0)then
					dxDrawLine3D ( recordData[i-1][1], recordData[i-1][2], recordData[i-1][3], recordData[i][1], recordData[i][2], recordData[i][3], tocolor (  onAirColor[1], onAirColor[2], onAirColor[3], onAirColor[4] ), 10 )
				end			
			end
		end
		if(not recording and showPoints) then
			mouseDown = false
			local mx,my,x,y,z = getCursorPosition ()
			local lastIndex = 0
			local distMin = {}
			local ox,oy = getScreenFromWorldPosition ( recordData[i-1][1], recordData[i-1][2], recordData[i-1][3], 100, false)
			if(mx and ox)then
				mx = screenW * mx
				my = screenH * my
				local dist = getDistanceBetweenPoints2D ( mx,my,ox,oy)
				if(dist<30)then
					dxDrawText (string.upper(testKey), mx+10, my-10 , mx+30 ,my+12, tocolor(255,255,255), 2, "default", "center", "center" )
					if(getKeyState (testKey))then
						if(recordData[i-1][4])then
							callDrawing(pVehicleModel, {recordData[i-1][1], recordData[i-1][2], recordData[i-1][3], recordData[i-1][5], recordData[i-1][6], recordData[i-1][7]}, onGroundColor)
						else
							callDrawing(pVehicleModel, {recordData[i-1][1], recordData[i-1][2], recordData[i-1][3], recordData[i-1][5], recordData[i-1][6], recordData[i-1][7]}, onAirColor)
						end
					end
				end
			end
		end
	end
end)

function stopRecording()
	if(updTimer)then
		killTimer(updTimer)
		recordingStep = 1
	end
	recording = false
	triggerEvent ( "updateStatus", getLocalPlayer(), "State: -")
	output("Stopped recording")
end

-- * Marking Key Bind function * --
function onRecordingPress()
	recording = not recording
	if(recording == false)then
		stopRecording()
	else
		if(not isPedInVehicle (lPlayer))then
			output("Can't start recording. You have to be in a car")
			triggerEvent ( "updateStatus", getLocalPlayer(), "State: -")
			recording = false
			return
		elseif(canRecord == false)then
			output("Can't start recording when playing old record")
			triggerEvent ( "updateStatus", getLocalPlayer(), "State: -")
			recording = false
			return
		end
		updTimer = setTimer(updateRecording, delay, 0)
		if(not updTimer)then 
			if(not delay) then delay = 0 end
			output("Can't start recording. Delay value must be bigger than 50. Current: "..tostring(delay))
			stopRecording()
			return
		end
		recording = true
		pVehicleModel = getElementModel ( getPedOccupiedVehicle(lPlayer) )
		output("Recording..")
		triggerEvent ( "updateStatus", getLocalPlayer(), "State: Recording")
		recordData = {}
	end
end
bindKey(recordingKey, 'down', onRecordingPress)


addEvent ( "onClearClick", true )
addEventHandler ( "onClearClick", getRootElement(), 
function()
	if(recordData[1] == nil)then return end
	recordData = {}
	output('Trajectory lines has been cleaned successfully.')
end)

addEvent ( "onSettingsChanged", true )
addEventHandler ( "onSettingsChanged", getRootElement(), 
function(newsets)
	if(newsets[1] == "true")then newsets[1] = true else newsets[1] = false end
	onGroundSingle = newsets[1]
	onGroundColor[1] = newsets[2]
	onGroundColor[2] = newsets[3]
	onGroundColor[3] = newsets[4]
	onGroundColor[4] = newsets[5]
	if(newsets[6] == "true")then newsets[6] = true else newsets[6] = false end
	onAirSingle = newsets[6]
	onAirColor[1] = newsets[7]
	onAirColor[2] = newsets[8]
	onAirColor[3] = newsets[9]
	onAirColor[4] = newsets[10]
	unbindKey(recordingKey, 'down', onRecordingPress)
	recordingKey = newsets[11]
	bindKey(recordingKey, 'down', onRecordingPress)
	delay = tonumber(newsets[12])
	minDist = tonumber(newsets[13])
	testKey = newsets[14]
	if(newsets[15] == "true")then newsets[15] = true else newsets[15] = false end
	showPoints = newsets[15]
end)