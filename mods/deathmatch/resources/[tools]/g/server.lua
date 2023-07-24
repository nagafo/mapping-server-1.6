--Search for update 
local NGTversion = getResourceInfo(resource, "version")
local waitingCov = {}

addEventHandler("onResourceStart", resourceRoot, function()
	outputChatBox("#FFA500[NGT]#FFFFFFIf you want the update check to work then please give the resource NGT admin!", root, 255, 255, 255, true)
	if (NGTversion) then
		updateCall = callRemote("http://community.mtasa.com/mta/resources.php",function(n,v) insertUpdateResultToDatabase(n,v,resource) end,"version",string.lower(getResourceName(resource)))
	end
end)

function insertUpdateResultToDatabase(name,version,resource)
	if (NGTversion) and (version) and (version ~= 0) and (version ~= "0.0") then
		update = false
		if (parseVersion(NGTversion) < parseVersion(version)) then
			update = true
		end
		if (update) then
			outputChatBox("#FFA500[NGT]#FF0000There's an update available, if you want to download it, type /ngtlink to copy the link into your clipboard(ctrl+v)!", root, 255, 255, 255, true)
		else
			outputDebugString("NGT is up-to-date")
		end
	end
end

function parseVersion(version)
	sversion = split(version,string.byte("."));
	i = 0
	if (sversion) then
		for k,v in ipairs(sversion) do
			i = i + 1
		end
	end
	i = i - 1
	if (i == -1) then
		outputDebugString("-1 detected.")
	elseif (i == 0) then
		version = version.. ".0.0"
	elseif (i == 1) then
		version = version.. ".0"
	end
	version = version:gsub("%.","")
	return version
end


--Table Functions
function table.clear( tb )
	if type( tb ) ~= "table" then
		return false
	end
	for index,elements in ipairs(tb) do
		table.remove (tb , index)
	end
	for index,elements in pairs(tb) do
		table.remove (tb , index)
	end
end 


function changemds(element,id)
	exports.edf:edfSetElementProperty(element, "model", id)
	setElementModel(element,id)
end
addEvent("changemodels",true)
addEventHandler("changemodels",root ,changemds)

function changeclds(element,state)
	exports.edf:edfSetElementProperty(element, "scale", state)
	setObjectScale(element,state)
end
addEvent("changevisibilityy",true)
addEventHandler("changevisibilityy", root,changeclds)

function addCover(element, sides)
	local rotX, rotY, rotZ = getElementRotation(element)
	local elements = {}
	
	
	
	--FRONT AND SHIET
	--local sides = {front=false, back=false, bot=false, left=false, right=false}
	local rot = 360/4
	local off = 0
	local relOff = 0/4
	local origElmID = getElementID(element)
	
	if sides.front then
		local newID = origElmID.."COVERCLONE(1)"
			
			local nrx, nry, nrz = rotX, rotY, rotZ
			local index = #elements + 1
			elements[index] = {}
			off = off + relOff
			local nx, ny, nz, rx = 0, 0, 0, 0
			
			nx = -off
			ny = cos(rot*1 - 90)*1.04
			nz = -sin(rot*1 - 90)*1.04 - 1.04
			rx = -rot*1
			
			nrx, nry, nrz = rotateX(nrx, nry, nrz, rx)
			nrx, nry, nrz = rotateY(nrx, nry, nrz, 0)
			nrx, nry, nrz = rotateZ(nrx, nry, nrz, 0)
			local newElement = exports.edf:edfCloneElement(element)
			exports.edf:edfSetElementProperty(newElement, "id", newID)
			setElementID(newElement, newID)
			
			elements[index].source = element
			elements[index].element = newElement
			elements[index].posX = nx
			elements[index].posY = ny
			elements[index].posZ = nz
			elements[index].rotX = nrx
			elements[index].rotY = nry
			elements[index].rotZ = nrz
	end
	if sides.bot then
		local newID = origElmID.."COVERCLONE(2)"
			
			local nrx, nry, nrz = rotX, rotY, rotZ
			local index = #elements + 1
			elements[index] = {}
			off = off + relOff
			local nx, ny, nz, rx = 0, 0, 0, 0
			
			nx = -off
			ny = cos(rot*2 - 90)*1.04
			nz = -sin(rot*2 - 90)*1.04 - 1.04
			rx = -rot*2
			
			nrx, nry, nrz = rotateX(nrx, nry, nrz, rx)
			nrx, nry, nrz = rotateY(nrx, nry, nrz, 0)
			nrx, nry, nrz = rotateZ(nrx, nry, nrz, 0)
			local newElement = exports.edf:edfCloneElement(element)
			exports.edf:edfSetElementProperty(newElement, "id", newID)
			setElementID(newElement, newID)
			
			elements[index].source = element
			elements[index].element = newElement
			elements[index].posX = nx
			elements[index].posY = ny
			elements[index].posZ = nz
			elements[index].rotX = nrx
			elements[index].rotY = nry
			elements[index].rotZ = nrz
	end
	if sides.back then
		local newID = origElmID.."COVERCLONE(3)"
			
			local nrx, nry, nrz = rotX, rotY, rotZ
			local index = #elements + 1
			elements[index] = {}
			off = off + relOff
			local nx, ny, nz, rx = 0, 0, 0, 0
			
			nx = -off
			ny = cos(rot*3 - 90)*1.04
			nz = -sin(rot*3 - 90)*1.04 - 1.04
			rx = -rot*3
			
			nrx, nry, nrz = rotateX(nrx, nry, nrz, rx)
			nrx, nry, nrz = rotateY(nrx, nry, nrz, 0)
			nrx, nry, nrz = rotateZ(nrx, nry, nrz, 0)
			local newElement = exports.edf:edfCloneElement(element)
			exports.edf:edfSetElementProperty(newElement, "id", newID)
			setElementID(newElement, newID)
			
			elements[index].source = element
			elements[index].element = newElement
			elements[index].posX = nx
			elements[index].posY = ny
			elements[index].posZ = nz
			elements[index].rotX = nrx
			elements[index].rotY = nry
			elements[index].rotZ = nrz
	end
	
	rot = 360/4
	off = 0
	relOff = 0/4
	if sides.left then
			local newID = origElmID.."COVERCLONE(4)"
			
			local nrx, nry, nrz = rotX, rotY, rotZ
			local index = #elements + 1
			elements[index] = {}
			off = off + relOff
			local nx, ny, nz, rx = 0, 0, 0, 0
			
			nx = -cos(rot*1 - 90)*18.675
			ny = -off
			nz = -sin(rot*1 - 90)*18.675 - 18.675
			rx, ry, rz = 0, -rot*1, 0
	
			
			nrx, nry, nrz = rotateX(nrx, nry, nrz, rx)
			nrx, nry, nrz = rotateY(nrx, nry, nrz, ry)
			nrx, nry, nrz = rotateZ(nrx, nry, nrz, rz)
			local newElement = exports.edf:edfCloneElement(element)
			exports.edf:edfSetElementProperty(newElement, "id", newID)
			setElementID(newElement, newID)
			
			elements[index].source = element
			elements[index].element = newElement
			elements[index].posX = nx
			elements[index].posY = ny
			elements[index].posZ = nz
			elements[index].rotX = nrx
			elements[index].rotY = nry
			elements[index].rotZ = nrz
	end
	if sides.right then
			local newID = origElmID.."COVERCLONE(4)"
			
			local nrx, nry, nrz = rotX, rotY, rotZ
			local index = #elements + 1
			elements[index] = {}
			off = off + relOff
			local nx, ny, nz, rx = 0, 0, 0, 0
			
			nx = -cos(rot*3 - 90)*18.675
			ny = -off
			nz = -sin(rot*3 - 90)*18.675 - 18.675
			rx, ry, rz = 0, -rot*3, 0
	
			
			nrx, nry, nrz = rotateX(nrx, nry, nrz, rx)
			nrx, nry, nrz = rotateY(nrx, nry, nrz, ry)
			nrx, nry, nrz = rotateZ(nrx, nry, nrz, rz)
			local newElement = exports.edf:edfCloneElement(element)
			exports.edf:edfSetElementProperty(newElement, "id", newID)
			setElementID(newElement, newID)
			
			elements[index].source = element
			elements[index].element = newElement
			elements[index].posX = nx
			elements[index].posY = ny
			elements[index].posZ = nz
			elements[index].rotX = nrx
			elements[index].rotY = nry
			elements[index].rotZ = nrz
	end
	
	triggerClientEvent(source, "sendBackRequestedElementsNGT", source, elements)
end


function startCoverProcess()
	if #waitingCov <= 0 then return end
	addCover(waitingCov[1][1],waitingCov[1][2])
	table.remove(waitingCov, 1)
end
addEvent("doNextCovah",true)
addEventHandler("doNextCovah",root, startCoverProcess)

function addCoverPrepare(elmd, liste)
	local new = {elmd, liste}
	table.insert(waitingCov, new)
end
addEvent("addCovah",true)
addEventHandler("addCovah", root,addCoverPrepare)

function prepareCover()
	waitingCov = {}
end
addEvent("prepareCovah",true)
addEventHandler("prepareCovah", root, prepareCover)

function removeCover(element)
	destroyElement(element)
end
addEvent("removeCover",true)
addEventHandler("removeCover", root, removeCover)

--Thanks to the AMT toolbox for the calculation i needed
addEvent("onRequestUpdateElementPosition", true)
addEventHandler("onRequestUpdateElementPosition", getRootElement(),
function(px, py, pz)
	exports.edf:edfSetElementPosition(source, px, py, pz)
end)

addEvent("onRequestUpdateElementRotation", true)
addEventHandler("onRequestUpdateElementRotation", getRootElement(),
function(rx, ry, rz)
	exports.edf:edfSetElementRotation(source, rx, ry, rz)
end)

function rotateX(rx, ry, rz, add)
	rx, ry, rz = convertRotationFromMTA(rx, ry, rz)
	rx = rx + add
	rx, ry, rz = convertRotationToMTA(rx, ry, rz)
	return rx, ry, rz
end

function rotateY(rx, ry, rz, add)
	return rx, ry + add, rz
end

function rotateZ(rx, ry, rz, add)
	ry = ry + 90
	rx, ry, rz = convertRotationFromMTA(rx, ry, rz)
	rx = rx - add
	rx, ry, rz = convertRotationToMTA(rx, ry, rz)
	ry = ry - 90
	return rx, ry, rz
end

function cos(deg)
	return math.cos(math.rad(deg))
end

function sin(deg)
	return math.sin(math.rad(deg))
end

function convertRotationToMTA(rx, ry, rz)
	rx, ry, rz = math.rad(rx), math.rad(ry), math.rad(rz)
	local sinX = math.sin(rx)
	local cosX = math.cos(rx)
	local sinY = math.sin(ry)
	local cosY = math.cos(ry)
	local sinZ = math.sin(rz)
	local cosZ = math.cos(rz)
	
	local newRx = math.asin(cosY * sinX)
	
	local newRy = math.atan2(sinY, cosX * cosY)
	
	local newRz = math.atan2(cosX * sinZ - cosZ * sinX * sinY,
		cosX * cosZ + sinX * sinY * sinZ)
	
	return math.deg(newRx), math.deg(newRy), math.deg(newRz)
end

function convertRotationFromMTA(rx, ry, rz)
	rx = math.rad(rx)
	ry = math.rad(ry)
	rz = math.rad(rz)
	
	local sinX = math.sin(rx)
	local cosX = math.cos(rx)
	local sinY = math.sin(ry)
	local cosY = math.cos(ry)
	local sinZ = math.sin(rz)
	local cosZ = math.cos(rz)
	
	return math.deg(math.atan2(sinX, cosX * cosY)), math.deg(math.asin(cosX * sinY)), math.deg(math.atan2(cosZ * sinX * sinY + cosY * sinZ,
		cosY * cosZ - sinX * sinY * sinZ))
end