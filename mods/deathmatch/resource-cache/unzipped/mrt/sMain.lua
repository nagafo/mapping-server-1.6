-- * General Variables * --
local gRoot = getRootElement()
local thisResource = getThisResource()
local thisResourceRoot = getResourceRootElement(thisResource)
local tVeh

-- * Editor Import * --
function editorImport()
	call(getResourceFromName"editor","import",thisResource)
	destroyElement(thisResourceRoot)
end
-- * Message Output * --
function message(msg, e)
	outputChatBox("[MRT]#bebebe "..msg, e, 255, 100, 100, true)
end
-- * On Resource Start * --
addEventHandler ( "onResourceStart", getResourceRootElement(thisResource), 
function()
	-- * Code Init * --
	-- * Info Output * --
	message("#FF0000Movement Recording Tool v2", gRoot)
	message("#bebebeMade by #FF0000Dr.CrazY", gRoot)
	message("#bebebePress #FFFFFFCTRL + M #bebebeto open menu.", gRoot)
end)

-- * Client Request Object Event * --
addEvent("clientRequestObject", true)
addEventHandler("clientRequestObject", getRootElement(),
function(pos, id)
	tVeh = createVehicle(id, pos[1], pos[2], pos[3], pos[4], pos[5], pos[6])
	editorImport()
	outputChatBox(tostring(tVeh))
	triggerClientEvent ( "onResponse", getRootElement(), tVeh)
end)

-- * Client Update Event * --
addEvent("clientUpdate", true)
addEventHandler("clientUpdate", getRootElement(),
function(px,py,pz,rx,ry,rz,xyn,sx,sy,sz,vx,vy,vz)
	editorImport()
	setElementPosition(tVeh, px, py, pz)
	--setVehicleRotation(tVeh, recordData[4], recordData[5], recordData[6])
	--setElementVelocity(tVeh, recordData[7], recordData[8], recordData[9])
	--setVehicleTurnVelocity(tVeh, recordData[11], recordData[12], recordData[13])
end)