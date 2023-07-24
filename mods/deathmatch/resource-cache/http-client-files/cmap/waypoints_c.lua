-- ******************************************************************************************************************************************************************************** --
-- Waypoints --

local strWaypointsFile 	= "cmapWayPoints.xml";
local tblWaypoints = {};

function drawWaypoints()
	for _, wp in pairs(tblWaypoints) do
		-- Drawing on minimap
		local iRadius = math.min((math.sqrt((x - wp.x) ^ 2 + (y - wp.y) ^ 2) / iMapScale) * iMapRadius, iMapRadius * 0.98);
		local iRot = findRotation(x, y, wp.x, wp.y) + iPlayerRot;
		
		local x1 = posX + math.sin(math.rad(iRot)) * iRadius;
		local y1 = posY + math.cos(math.rad(iRot)) * iRadius;
		
		dxDrawCircle(x1, y1, iMapRadius / 12, 45, 135, wp.color, TRANSPARENT, 3);
		dxDrawCircle(x1, y1, iMapRadius / 12, 225, 315, wp.color, TRANSPARENT, 3);
		dxDrawText(wp.name, x1, y1, x1, y1, tocolor(255, 255, 255, 255), 0.75, "defauld-bold", "center", "center", false, false, false, true);
		
		-- Drawing in world
		dxDrawLine3D(wp.x, wp.y, wp.z - 500, wp.x, wp.y, wp.z + 500, wp.color, 5);
		dxDrawLine3D(wp.x + 5, wp.y, wp.z, wp.x - 5, wp.y, wp.z, tocolor(255, 255, 255, 127), 5);
		dxDrawLine3D(wp.x, wp.y + 5, wp.z, wp.x, wp.y - 5, wp.z, tocolor(255, 255, 255, 127), 5);
		dxDraw3DTextScaled(wp.name, wp.x, wp.y, wp.z + 1.25, 3, "default-bold", wp.color, 2000);
		--(text, x, y, z, scale, font, color, maxDistance, colorCoded, rotation)
	end
end

function waypointAction(cmd, action, wpName, arg1, arg2, arg3, arg4)
	if (action == "add" or action == "set") then
		if (not (wpName) or not tostring(wpName)) then
			return outputChatBox(strResColor..strResName.." #ffffffError: Invalid or missing waypoint name", 255, 255, 255, true);
		end
		
		local r, g, b, a = checkColors(arg1, arg2, arg3, arg4);
		
		if not (r) then	return end
		
		if (tblWaypoints[string.lower(wpName)]) then
			outputChatBox(strResColor..strResName.." #ffffffError: Waypoint '#c4c4c4" .. wpName .. "#ffffff' already exist", 255, 255, 255, true);
			return
		end
		
		local pX, pY, pZ = getElementPosition(localPlayer);
		
		table.insert(tblWaypoints, {x = pX, y = pY, z = pZ, name = wpName, color = tocolor(tonumber(r), tonumber(g), tonumber(b), tonumber(a))});
		outputChatBox(strResColor..strResName.." #ffffffWaypoint '#c4c4c4" .. wpName .. "#ffffff' added", 255, 255, 255, true);
		
	elseif (action == "delete" or action == "del") then
		if (not (wpName) or not tostring(wpName)) then
			return outputChatBox(strResColor..strResName.." #ffffffError: Invalid or missing waypoint name", 255, 255, 255, true);
		end
		
		local iWaypointID = findWayPointID(wpName); 
		
		if (not iWaypointID) then
			outputChatBox(strResColor..strResName.." #ffffffError: Waypoint '#c4c4c4" .. wpName .. "#ffffff' doesn't exist", 255, 255, 255, true);
			return
		end
		
		table.remove(tblWaypoints, iWaypointID);
		
		outputChatBox(strResColor..strResName.." #ffffffWaypoint '#c4c4c4" .. wpName .. "#ffffff' deleted", 255, 255, 255, true);
	elseif (action == "list") then
		local i = 0;
		
		outputChatBox(strResColor..strResName.." #ffffff === Waypoint List === ", 255, 255, 255, true);
		
		for _, wp in pairs(tblWaypoints) do
			i = i + 1;
			
			outputChatBox(strResColor..strResName.." #ffffff#" .. i .. ": #c4c4c4" .. wp.name .. "#ffffff - Location: #c4c4c4X:#ffffff " .. math.floor(wp.x * 1000) / 1000 .. " #c4c4c4Y:#ffffff " .. math.floor(wp.y * 1000) / 1000 .. " #c4c4c4Z:#ffffff " .. math.floor(wp.z * 1000) / 1000, 255, 255, 255, true);
		end
	elseif (action == "warp") then
		if (not (wpName) or not tostring(wpName)) then
			return outputChatBox(strResColor..strResName.." #ffffffError: Invalid or missing waypoint name", 255, 255, 255, true);
		end
		
		local iWaypointID = findWayPointID(wpName);
		
		if (not iWaypointID) then
			outputChatBox(strResColor..strResName.." #ffffffError: Waypoint '#c4c4c4" .. wpName .. "#ffffff' doesn't exist", 255, 255, 255, true);
			return
		end		
		
		local x1, y1, z1, x2, y2, z2 = getCameraMatrix();

		local endX = tblWaypoints[iWaypointID].x + (x2 - x1);
		local endY = tblWaypoints[iWaypointID].y + (y2 - y1);
		local endZ = tblWaypoints[iWaypointID].z + (z2 - z1);
		
		setCameraMatrix(tblWaypoints[iWaypointID].x,tblWaypoints[iWaypointID].y,tblWaypoints[iWaypointID].z, endX, endY, endZ);
		outputChatBox(strResColor..strResName.." #ffffffTeleported to waypoint: '#c4c4c4" .. wpName .. "#ffffff'", 255, 255, 255, true);
		
	elseif (action == "move") then
		if (not (wpName) or not tostring(wpName)) then
			return outputChatBox(strResColor..strResName.." #ffffffError: Invalid or missing waypoint name", 255, 255, 255, true);
		end
		
		local iWaypointID = findWayPointID(wpName);
		
		if (not iWaypointID) then
			outputChatBox(strResColor..strResName.." #ffffffError: Waypoint '#c4c4c4" .. wpName .. "#ffffff' doesn't exist", 255, 255, 255, true);
			return
		end

		tblWaypoints[iWaypointID].x, tblWaypoints[iWaypointID].y, tblWaypoints[iWaypointID].z = getElementPosition(localPlayer);
		
		outputChatBox(strResColor..strResName.." #ffffffWaypoint: '#c4c4c4" .. wpName .. "#ffffff' moved", 255, 255, 255, true);
		
	elseif (action == "help") then
		outputChatBox("");
		outputChatBox(strResColor..strResName .. " === Ceeser's Map Waypoint Help ===", 255, 255, 255, true);
		outputChatBox(strResColor..strResName .. " #ffffffSet a waypoint using #c4c4c4/wp #ffffff(#c4c4c4set #ffffff|| #c4c4c4add#ffffff) #c4c4c4[name] [red] [green] [blue] [alpha]", 255, 255, 255, true);
		outputChatBox(strResColor..strResName .. " #ffffffDelete a waypoint using #c4c4c4/wp #ffffff(#c4c4c4del #ffffff|| #c4c4c4delete#ffffff) #c4c4c4[name]", 255, 255, 255, true);
		outputChatBox(strResColor..strResName .. " #ffffffMove a waypoint using #c4c4c4/wp move [name]", 255, 255, 255, true);
		outputChatBox(strResColor..strResName .. " #ffffffWarp to a waypoint using #c4c4c4/wp warp [name]", 255, 255, 255, true);
		outputChatBox(strResColor..strResName .. " #ffffffList all waypoints using #c4c4c4/wp list", 255, 255, 255, true);
	end
end
addCommandHandler("wp", waypointAction);

function saveWayPoints()
	if (fileExists(strWaypointsFile)) then
		fileDelete(strWaypointsFile);
	end
	
	local uFile = xmlCreateFile(strWaypointsFile, "waypoints");
	
	for _, wp in pairs(tblWaypoints) do
		local uChild = xmlCreateChild(uFile, "waypoint");
		
		for attribute, value in pairs(wp) do
			xmlNodeSetAttribute(uChild, attribute, value);
		end
	end
	
	xmlSaveFile(uFile);
	xmlUnloadFile(uFile);
end

function loadWayPoints()
	if not (fileExists(strWaypointsFile)) then
		return
	end
	
	local uFile = xmlLoadFile(strWaypointsFile);
	
	if (uFile) then
		local tblChildren = xmlNodeGetChildren(uFile);
		
		for _, child in pairs(tblChildren) do
			table.insert(tblWaypoints, xmlNodeGetAttributes(child));
		end
	end
end

function findWayPointID(strName)
	for i, wp in pairs(tblWaypoints) do
		if (wp.name == strName) then
			return i;
		end
	end
	
	return false;
end