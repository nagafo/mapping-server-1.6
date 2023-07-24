local PI = math.pi
-- Dont use editor_main:import! the script will not work corretly.
local map = {}
map.xmlFile = "amt.xml"
map.current = nil

-- Here generation of elements and attaching is handled
addEvent("onRequestGenerate", true)
addEventHandler("onRequestGenerate", getRootElement(),
function(element, rotX, rotY, rotZ, loops, radius, objects, offset, center, dir, addX, addY, addZ, conX, conY, conZ)
	outputDebugString("AMT: server generating elements.")
	local elements = {}
	local rot = 360/objects
	local off = 0
	local inter = 0
	local relOff = offset/objects
	conX = conX / math.floor(objects*loops)
	conY = conY / math.floor(objects*loops)
	conZ = conZ / math.floor(objects*loops)
	for l = 1, math.ceil(loops) do
		for i = 1, objects do
			local nrx, nry, nrz = rotX, rotY, rotZ
			local index = #elements + 1
			elements[index] = {}
			off = off + relOff
			local nx, ny, nz, rx, ry, rz = 0, 0, 0, 0, 0, 0
			-- if center == top
			if(center == 1)then
				-- if dir == forward
				if(dir == 5)then
					nx = off
					ny = cos(rot*i - 90)*radius
					nz = sin(rot*i - 90)*radius + radius
					rx, ry, rz = rot*i, 0, 0
				end
				-- if dir == backward
				if(dir == 6)then
					nx = -off
					ny = -cos(rot*i - 90)*radius
					nz = sin(rot*i - 90)*radius + radius
					rx, ry, rz = -rot*i, 0, 0
				end
				-- if dir == left
				if(dir == 3)then
					nx = -cos(rot*i - 90)*radius
					ny = off
					nz = sin(rot*i - 90)*radius + radius
					rx, ry, rz = 0, rot*i, 0
				end
				-- if dir == right
				if(dir == 4)then
					nx = cos(rot*i - 90)*radius
					ny = -off
					nz = sin(rot*i - 90)*radius + radius
					rx, ry, rz = 0, -rot*i, 0
				end
			end
			-- if center == down
			if(center == 2)then
				-- if dir == forward
				if(dir == 5)then
					nx = -off
					ny = cos(rot*i - 90)*radius
					nz = -sin(rot*i - 90)*radius - radius
					rx, ry, rz = -rot*i, 0, 0
				end
				-- if dir == backward
				if(dir == 6)then
					nx = off
					ny = -cos(rot*i - 90)*radius
					nz = -sin(rot*i - 90)*radius - radius
					rx, ry, rz = rot*i, 0, 0
				end
				-- if dir == left
				if(dir == 3)then
					nx = -cos(rot*i - 90)*radius
					ny = -off
					nz = -sin(rot*i - 90)*radius - radius
					rx, ry, rz = 0, -rot*i, 0
				end
				-- if dir == right
				if(dir == 4)then
					nx = cos(rot*i - 90)*radius
					ny = off
					nz = -sin(rot*i - 90)*radius - radius
					rx, ry, rz = 0, rot*i, 0
				end
			end
			-- if center == left
			if(center == 3)then
				-- if dir == forward
				if(dir == 5)then
					nx = -sin(rot*i - 90)*radius - radius
					ny = cos(rot*i - 90)*radius
					nz = off
					rx, ry, rz = 0, 0, rot*i
				end
				-- if dir == backward
				if(dir == 6)then
					nx = -sin(rot*i - 90)*radius - radius
					ny = -cos(rot*i - 90)*radius
					nz = -off
					rx, ry, rz = 0, 0, -rot*i
				end
				-- if dir == top
				if(dir == 1)then
					nx = -sin(rot*i - 90)*radius - radius
					ny = -off
					nz = cos(rot*i - 90)*radius
					rx, ry, rz = 0, -rot*i, 0
				end
				-- if dir == bottom
				if(dir == 2)then
					nx = -sin(rot*i - 90)*radius - radius
					ny = off
					nz = -cos(rot*i - 90)*radius
					rx, ry, rz = 0, rot*i, 0
				end
			end
			-- if center == right
			if(center == 4)then
				-- if dir == forward
				if(dir == 5)then
					nx = sin(rot*i - 90)*radius + radius
					ny = cos(rot*i - 90)*radius
					nz = -off
					rx, ry, rz = 0, 0, -rot*i
				end
				-- if dir == backward
				if(dir == 6)then
					nx = sin(rot*i - 90)*radius + radius
					ny = -cos(rot*i - 90)*radius
					nz = off
					rx, ry, rz = 0, 0, rot*i
				end
				-- if dir == top
				if(dir == 1)then
					nx = sin(rot*i - 90)*radius + radius
					ny = off
					nz = cos(rot*i - 90)*radius
					rx, ry, rz = 0, rot*i, 0
				end
				-- if dir == bottom
				if(dir == 2)then
					nx = sin(rot*i - 90)*radius + radius
					ny = -off
					nz = -cos(rot*i - 90)*radius
					rx, ry, rz = 0, -rot*i, 0
				end
			end
			-- if center == forward
			if(center == 5)then
				-- if dir == up
				if(dir == 1)then
					nx = -off
					ny = sin(rot*i - 90)*radius + radius
					nz = cos(rot*i - 90)*radius
					rx, ry, rz = -rot*i, 0, 0
				end
				-- if dir == down
				if(dir == 2)then
					nx = -off
					ny = sin(rot*i - 90)*radius + radius
					nz = -cos(rot*i - 90)*radius
					rx, ry, rz = rot*i, 0, 0
				end
				-- if dir == left
				if(dir == 3)then
					nx = -cos(rot*i - 90)*radius
					ny = sin(rot*i - 90)*radius + radius
					nz = -off
					rx, ry, rz = 0, 0, -rot*i
				end
				-- if dir == right
				if(dir == 4)then
					nx = cos(rot*i - 90)*radius
					ny = sin(rot*i - 90)*radius + radius
					nz = off
					rx, ry, rz = 0, 0, rot*i
				end
			end
			-- if center == backward
			if(center == 6)then
				-- if dir == up
				if(dir == 1)then
					nx = off
					ny = -sin(rot*i - 90)*radius - radius
					nz = cos(rot*i - 90)*radius
					rx, ry, rz = rot*i, 0, 0
				end
				-- if dir == down
				if(dir == 2)then
					nx = off
					ny = -sin(rot*i - 90)*radius - radius
					nz = -cos(rot*i - 90)*radius
					rx, ry, rz = -rot*i, 0, 0
				end
				-- if dir == left
				if(dir == 3)then
					nx = -cos(rot*i - 90)*radius
					ny = -sin(rot*i - 90)*radius - radius
					nz = off
					rx, ry, rz = 0, 0, rot*i
				end
				-- if dir == right
				if(dir == 4)then
					nx = cos(rot*i - 90)*radius
					ny = -sin(rot*i - 90)*radius - radius
					nz = -off
					rx, ry, rz = 0, 0, -rot*i
				end
			end
			nrx, nry, nrz = rotateX(nrx, nry, nrz, rx)
			nrx, nry, nrz = rotateY(nrx, nry, nrz, ry)
			nrx, nry, nrz = rotateZ(nrx, nry, nrz, rz)
			local newElement = exports.edf:edfCloneElement(element)
			local newID = "AMT "..getElementModel(newElement).." ("..getElementCount(newElement)..")"
			exports.edf:edfSetElementProperty(newElement, "id", newID)
			setElementID(newElement, newID)
			--attachElements(newElement, element, nx, ny, nz, rx, ry, rz)
			--local ox, oy, oz, orx, ory, orz = getElementAttachedOffsets(newElement)
			elements[index].source = element
			elements[index].element = newElement
			elements[index].posX = nx
			elements[index].posY = ny
			elements[index].posZ = nz
			
			elements[index].rotX = nrx
			elements[index].rotY = nry
			elements[index].rotZ = nrz
			
			elements[index].sourceX = rotX
			elements[index].sourceY = rotY
			elements[index].sourceZ = rotZ
			
			elements[index].source_rotX, elements[index].source_rotY, elements[index].source_rotZ = getElementRotation(element)
			if(inter >= math.floor(objects*loops))then
				break
			end
			inter = inter + 1
		end
	end
	outputDebugString("AMT: object generated: "..inter-1)
	-- Send back the generated elements to the creator client.
	triggerClientEvent(source, "sendBackRequestedElements", source, elements, rotX + addX, rotY + addY, rotZ + addZ)
end)

-- Count how many elements of same type there are in the map
function getElementCount(element)
	local model = getElementModel(element)
	local count = 0
	local elements = getElementsByType(getElementType(element))
	for i = 1, #elements do
		local tModel = getElementModel(elements[i])
		if(tModel == model)then
			count = count + 1
		end
	end
	return count
end

--[[
addEvent("onRequestRecreateElements", true)
addEventHandler("onRequestRecreateElements", getRootElement(),
function(data)
	-- source is the player that sent the data
	outputDebugString("AMT: server saving elements.")
	for i = 1, #data do
		-- first destroy, because otherwise all the objects will have same id
		if(data[i] ~= nil)then
			detachElements(data[i].element)
			destroyElement(data[i].element)
		end
	end
	for i = 1, #data do
		if(data[i] ~= nil)then
			local newElement = exports.edf:edfCloneElement(data[i].source)
			local newID = "AMT "..getElementModel(newElement).." ("..getElementCount(newElement)..")"
			exports.edf:edfSetElementProperty(newElement, "id", newID)
			setElementID(newElement, newID)
			exports.edf:edfSetElementPosition(newElement, data[i].posX, data[i].posY, data[i].posZ)
			exports.edf:edfSetElementRotation(newElement, data[i].rotX, data[i].rotY, data[i].rotZ)
		end
	end
end)
--]]

-- Update position for element so its synced with editor and works
addEvent("onRequestUpdateElementPosition", true)
addEventHandler("onRequestUpdateElementPosition", getRootElement(),
function(px, py, pz)
	-- source is the element
	exports.edf:edfSetElementPosition(source, px, py, pz)
end)

-- Update rotation for element so its synced with editor and works
addEvent("onRequestUpdateElementRotation", true)
addEventHandler("onRequestUpdateElementRotation", getRootElement(),
function(rx, ry, rz)
	-- source is the element
	exports.edf:edfSetElementRotation(source, rx, ry, rz)
end)

-- Get list with elements from client to destroy
addEvent("requestDestroyElements", true)
addEventHandler("requestDestroyElements", getRootElement(),
function(elements)
	for i = 1, #elements do
		destroyElement(elements[i])
	end
end)

addEvent("onMapOpened", true)
addEventHandler("onMapOpened", getRootElement(),
function(mapContainer, openingResource)
	-- openingResource is the map element
	map.current = ":"..getResourceName(mapContainer).."/"..map.xmlFile
	outputDebugString("AMT: xml file name saved to: "..map.current)
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

-- XYZ euler rotation to YXZ euler rotation
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

-- YXZ rotation to XYZ rotation
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