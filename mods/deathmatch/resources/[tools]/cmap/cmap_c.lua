SX, SY = guiGetScreenSize();

-- Global Resource config
strResName 		= "[CMAP]";
strResColor 	= "#ffa500";
strSettingsFile	= "cmapSettings.xml"; -- Changing this will remove all settings and waypoints for everybody

-- Global Colors
BLACK = tocolor(0, 0, 0, 127);
TRANSPARENT = tocolor(0, 0, 0, 0);
BLUE = tocolor(0, 0, 255, 255);

-- Global Position and Sizes
local iDefaultMapScale = 500; -- Only change this if you want everybody who joins the server first time to have another then 500
local iDefaultMapMaxScale = 1000; -- Same as above.

-- Track updating
local tblTrack = {};
local iLastTrackUpdate = 0;
local iTrackUpdateDelay = 250; -- Increase to improve performance
local uSelectedElement = nil;

-- DO NOT CHANGE ANYTHING BELOW THIS COMMENT
iMapScale = iDefaultMapScale;
iMapMinScale = 100;
iMapMaxScale = iDefaultMapMaxScale; 
iMapRadius = SY * 0.125;
posX = SY * 0.1575;
posY = SY * 0.8;

-- Global Update values
x, y, z = getElementPosition(localPlayer);
iPlayerRot = false;
uCamTarget = false;

-- Global Settings
bShowWaypoints = true;
bShowTrack = true;
bShowPlayers = true;
bShowInfo = true;
local bShowLocalPlayerIcon = true;

-- Local Position and Sizes
local iInfoLeft = SX / 100;
local iInfoSize = iMapRadius / 12;
local iInfoTop	= posY + iMapRadius - iInfoSize * 3;

local iBlipSize = iMapRadius / 8;

-- Track objects || To add more shown objects add "[ObjectID] = true,"
local tblTrackObjects = {[3458] = true, [8558] = true, [8838] = true, [6959] = true, [8557] = true, [7657] = true,};
-- All track objects from above need a color. If none is specified for the ObjectID it will be white.
local tblTrackObjectColor = {
							invis = tocolor(0, 0, 127, 64), [3458] = tocolor(127, 127, 127, 127), [8558] = tocolor(128, 64, 0, 127),
							[8838] = tocolor(64, 128, 0, 127), [6959] = tocolor(33, 33, 33, 192), [8557] = tocolor(128, 64, 0, 127),
							[7657] = tocolor(255, 255, 0, 127),
							};

-- Info drawing
local iBarMult = 1.6;
local iBarDegrees = 100 * iBarMult;
local iBarTick = 0;
local iLastHealth = 0;
local iNewHealth = 0;


-- ******************************************************************************************************************************************************************************** --
-- Player Data --

function updateData()
	local x1, y1, z1, x2, y2, z2 = getCameraMatrix();
	iPlayerRot = 360 - findRotation(x2, y2, x1, y1);
	
	uCamTarget = getCameraTarget();
	
	if (uCamTarget) then
		local uTarget = getVehicleOccupant(uCamTarget);
		
		if (uTarget and uTarget ~= localPlayer) then
			bShowLocalPlayerIcon = false;
			setElementData(localPlayer, "camRot", false);
		else
			bShowLocalPlayerIcon = true;
			setElementData(localPlayer, "camRot", iPlayerRot);
		end
		
		x, y, z = getElementPosition(uCamTarget);
	else
		bShowLocalPlayerIcon = true;
		
		if (getElementPosition(localPlayer)) then
			setElementData(localPlayer, "camRot", iPlayerRot);
			x, y, z = getElementPosition(localPlayer);
		else
			setElementData(localPlayer, "camRot", false);
			x, y, z = 0, 0, 0; -- Avoid error shooting
		end
	end
end

function getPlayerInfo()
	local tbl = {};
	
	for _, player in pairs(getElementsByType("player")) do
		if (player ~= localPlayer) then
			local iRot = getElementData(player, "camRot");
				
			if (iRot) then
				local pX, pY, pZ = getElementPosition(player);
				local iDistance  = math.sqrt((x - pX) ^ 2 + (y - pY) ^ 2);
				local iRot 		 = iRot - iPlayerRot;
				
				local blip 		 = "player";
				
				-- Height mark
				local iColor = tocolor(255, 255, 255, 255);
				
				if (pZ > z + 25) then
					iColor = tocolor(85, 255, 85, 255);
				elseif (pZ < z - 25) then
					iColor = tocolor(255, 85, 85, 255);
				end
				
				-- Relative position
				local iRelativeRot = findRotation(x, y, pX, pY) + iPlayerRot;
				local iRadius = math.min((iDistance / iMapScale) * iMapRadius, iMapRadius * 0.98);
				
				local mapX = posX + math.sin(math.rad(iRelativeRot)) * iRadius;
				local mapY = posY + math.cos(math.rad(iRelativeRot)) * iRadius;
				
				local iTextRot = 360 - iRot;
				
				if (iDistance > iMapScale * 0.98) then
					blip = "playerFar"
					iRot = 180 - iRelativeRot;
					iTextRot = iRelativeRot;
				end
				
				local textX = mapX + math.sin(math.rad(iTextRot)) * iBlipSize * 1.25;
				local textY = mapY + math.cos(math.rad(iTextRot)) * iBlipSize * 1.25;
				
				iTextRot = iRot;
				
				local iPlayerDistance = math.floor(math.sqrt((x - pX) ^ 2 + (y - pY) ^ 2 + (z - pZ) ^ 2));
				
				iPlayerDistance = (iPlayerDistance > 0) and "("..iPlayerDistance..")" or "";
				
				table.insert(tbl, {x = mapX, y = mapY, rot = iRot, color = iColor, blip = blip, name = getPlayerName(player), textX = textX, textY = textY, textRot = iTextRot, distance = iPlayerDistance})
			end
		end
	end
	
	return tbl;
end

-- ******************************************************************************************************************************************************************************** --
-- Components --

function drawNorth()
	local iRotation = math.rad(iPlayerRot);
	
	local northX = posX + math.sin(iRotation) * iMapRadius * 1.08;
	local northY = posY + math.cos(iRotation) * iMapRadius * 1.08;
	
	dxDrawCircle(northX, northY, iMapRadius / 12, 0, 360, BLACK, BLACK)
	dxDrawText("N", northX + iMapRadius / 200, northY, northX + iMapRadius / 200, northY, tocolor(255, 255, 255, 127), 1, "default-bold", "center", "center");
end

function updateTrack()
	tblTrack = {};
	
	local iDimension = getElementDimension(localPlayer);
	
	for _, object in ipairs(getElementsByType("object")) do
		local iModel = getElementModel(object);
		
		if (tblTrackObjects[iModel]) then
			if (getElementDimension(object) == iDimension) then
				local objectX, objectY, objectZ = getElementPosition(object);
				
				if (math.sqrt((x - objectX) ^ 2 + (y - objectY) ^ 2 + (z - objectZ) ^ 2) < iMapScale) then
					local strID = getElementID(object);
					
					if (strID and not string.find(strID, "GXET")) then -- Exclude autoshade covers
						local iColor = tblTrackObjectColor[iModel];
						
						if (getObjectScale(object) == 0) then
							iColor = tblTrackObjectColor.invis;
						end
						
						table.insert(tblTrack, {x = objectX, y = objectY, color = iColor});
					end
				end
			end
		end
	end
	
	uSelectedElement = exports.editor_main:getSelectedElement();
end

function drawTrack()
	local iNow = getTickCount();
	
	if (iNow - iLastTrackUpdate > iTrackUpdateDelay) then
		updateTrack();
		iLastTrackUpdate = iNow;
	end
	
	for _, object in pairs(tblTrack) do
		local iRadius = (math.sqrt((x - object.x) ^ 2 + (y - object.y) ^ 2) / iMapScale) * iMapRadius;
		
		if (iRadius < iMapRadius) then
			local iRot = findRotation(x, y, object.x, object.y) + iPlayerRot;
			
			local x1 = posX + math.sin(math.rad(iRot)) * iRadius;
			local y1 = posY + math.cos(math.rad(iRot)) * iRadius;
			
			dxDrawCircle(x1, y1, iMapRadius / 60 + iMapRadius / 500 * (iMapMaxScale / (iMapScale * 2)), 0, 360, object.color, object.color, 8);
		end
	end
end

function drawSelectedElement()
	if (uSelectedElement and isElement(uSelectedElement)) then
		local objectX, objectY, objectZ = getElementPosition(uSelectedElement);
		local iRadius = math.min((math.sqrt((x - objectX) ^ 2 + (y - objectY) ^ 2) / iMapScale) * iMapRadius, iMapRadius * 0.98);
		local iRot = findRotation(x, y, objectX, objectY) + iPlayerRot;
		local x1 = posX + math.sin(math.rad(iRot)) * iRadius;
		local y1 = posY + math.cos(math.rad(iRot)) * iRadius;
		
		dxDrawCircle(x1, y1, iMapRadius / 50 * (iMapMaxScale / (iMapScale * 2) * 2), 0, 360, BLUE, BLUE, 16);
		dxDrawText(" S", x1, y1, x1, y1 + iMapRadius / 50, white, 1, "default-bold", "center", "center");
	end
end

function drawPlayers()
	local tblPlayers = getPlayerInfo();
	
	for _, player in pairs(tblPlayers) do
		dxDrawImage(player.x - iBlipSize / 2, player.y - iBlipSize / 2, iBlipSize, iBlipSize, player.blip..".png", player.rot, 0, 0, player.color);
		dxDrawText(string.gsub(player.name, "#%x%x%x%x%x%x", '') .. "\n(" .. player.distance .. ")", player.textX + 1, player.textY + 1, player.textX + 1, player.textY + 1, tocolor(0, 0, 0, 1), 0.8, "default", "center", "center", false, false, false, true, false, player.textRot);
		dxDrawText(player.name .. "\n" .. player.distance, player.textX, player.textY, player.textX, player.textY, tocolor(127, 127, 127, 255), 0.8, "default", "center", "center", false, false, false, true, false, player.textRot);
	end
end

function drawVehicleInfo()
	local uVehicle = getCameraTarget();

	if (uVehicle and getElementType(uVehicle) == "vehicle") then
		iNewHealth = math.max(0, ((getElementHealth(uVehicle) - 250) / 7.5) * iBarMult); -- Vehicle stats burning below 250 health, thats why its getting substracted
		
		if (iLastHealth == 0) then
			iLastHealth = iNewHealth;
		end

		iLastHealth = iLastHealth - (iLastHealth - iNewHealth) / 10;

		if (iLastHealth > 0.1) then
			-- Draw health amount
			local iColor = tocolor(255 - (255 * (iLastHealth / iBarDegrees)), 255 * (iLastHealth / iBarDegrees), 0, 127 + (127 * (1 - (iLastHealth / iBarDegrees))));

			dxDrawRing(posX, posY, iMapRadius * 2.02, iMapRadius * 2.02, iColor, 190, iLastHealth, 3);
			dxDrawRing(posX, posY, iMapRadius * 2.02, iMapRadius * 2.02, tocolor(127, 127, 127, 127), 190 + iLastHealth, iBarDegrees - iLastHealth, 3);
		else
			-- Red blinking
			iBarTick = iBarTick + 1;

			if (iBarTick > 10 and iBarTick <= 20) then
				dxDrawRing(posX, posY, iMapRadius * 2.02, iMapRadius * 2.02, tocolor(255, 0, 0, 255), 190, iBarDegrees, 3);

				if (iBarTick == 20) then iBarTick = 0 end
			else
				dxDrawRing(posX, posY, iMapRadius * 2.02, iMapRadius * 2.02, tocolor(127, 127, 127, 127), 190, iBarDegrees, 3);
			end
		end

		local iNos = getVehicleNitroLevel(uVehicle);

		if (iNos) then
			local iColor = tocolor(30, 85, 255, 127);

			if (isVehicleNitroRecharging(uVehicle)) then
				iColor = tocolor(115, 165, 255, 127);
			end

			iNos = math.floor(iNos * iBarDegrees);

			dxDrawRing(posX, posY, iMapRadius * 2.02, iMapRadius * 2.02, iColor, 10 + iBarDegrees - iNos, iNos, 3);
			dxDrawRing(posX, posY, iMapRadius * 2.02, iMapRadius * 2.02, tocolor(127, 127, 127, 127), 10, iBarDegrees - iNos, 3);
		else 
			dxDrawRing(posX, posY, iMapRadius * 2.02, iMapRadius * 2.02, tocolor(127, 127, 127, 127), 10, iBarDegrees, 3);
		end

		-- Speed
		local vX, vY, vZ = getElementVelocity(uVehicle);
		local iSpeed = math.floor(math.sqrt(vX ^ 2 + vY ^ 2 + vZ ^ 2) * 180);

		dxDrawText(iSpeed .. " km/h", iInfoLeft, posY + iMapRadius * 1.2, iInfoLeft, posY + iMapRadius * 1.2, tocolor(222, 222, 222, 192), 1.1, "default-bold", "left", "center");
	end
end

-- ******************************************************************************************************************************************************************************** --
-- Rendering --

function renderMinimap()
	--local iNow = getTickCount(); -- TIME DEBUG
	setPlayerHudComponentVisible("radar", false);
	
	-- Background
	if (math.abs(x) > 8000 or math.abs(y) > 8000) then
		dxDrawCircle(posX, posY, iMapRadius, 0, 360, tocolor(255, 0, 0, 255), TRANSPARENT, 64);
		dxDrawText("WARNING!\nMAPLIMIT\nREACHED", posX, posY, posX, posY, white, 3, "default-bold", "center", "center");
	else
		dxDrawCircle(posX, posY, iMapRadius, 0, 360, BLACK, TRANSPARENT, 64);
	end
	
	-- Data updating
	updateData();
	
	-- Components drawing
	drawNorth();

	if (bShowInfo) then
		drawVehicleInfo();
		dxDrawText("Info", iInfoLeft, iInfoTop - iInfoSize, iInfoLeft, iInfoTop, tocolor(85, 255, 85, 127), 1, "default-bold", "left", "center", false, false, false, true);
	else
		dxDrawText("Info", iInfoLeft, iInfoTop - iInfoSize, iInfoLeft, iInfoTop, tocolor(255, 85, 85, 127), 1, "default-bold", "left", "center", false, false, false, true);
	end

	if (bShowTrack) then
		drawTrack();
		dxDrawText("Track", iInfoLeft, iInfoTop, iInfoLeft, iInfoTop + iInfoSize, tocolor(85, 255, 85, 127), 1, "default-bold", "left", "center", false, false, false, true);
	else
		dxDrawText("Track", iInfoLeft, iInfoTop, iInfoLeft, iInfoTop + iInfoSize, tocolor(255, 85, 85, 127), 1, "default-bold", "left", "center", false, false, false, true);
	end
	
	if (bShowPlayers) then
		drawPlayers();
		dxDrawText("Players", iInfoLeft, iInfoTop + iInfoSize, iInfoLeft, iInfoTop + iInfoSize * 2, tocolor(85, 255, 85, 127), 1, "default-bold", "left", "center", false, false, false, true);
	else
		dxDrawText("Players", iInfoLeft, iInfoTop + iInfoSize, iInfoLeft, iInfoTop + iInfoSize * 2, tocolor(255, 85, 85, 127), 1, "default-bold", "left", "center", false, false, false, true);
	end
	
	if (bShowWaypoints) then
		drawWaypoints();
		dxDrawText("Waypoints", iInfoLeft, iInfoTop + iInfoSize * 2, iInfoLeft, iInfoTop + iInfoSize * 3, tocolor(85, 255, 85, 127), 1, "default-bold", "left", "center", false, false, false, true);
	else
		dxDrawText("Waypoints", iInfoLeft, iInfoTop + iInfoSize * 2, iInfoLeft, iInfoTop + iInfoSize * 3, tocolor(255, 85, 85, 127), 1, "default-bold", "left", "center", false, false, false, true);
	end
	
	drawSelectedElement();
	
	-- Map Scale info
	dxDrawText("Map Radius: (m) \n"..iMapScale .. " / " .. iMapMaxScale, iInfoLeft, posY - iMapRadius, iInfoLeft,  posY - iMapRadius, tocolor(127, 127, 127, 150), 0.9, "default-bold", "left", "center");
	
	-- Player Icon
	if (bShowLocalPlayerIcon) then
		dxDrawImage(posX - iBlipSize / 2, posY - iBlipSize / 2, iBlipSize, iBlipSize, "player.png");
	end
	
	-- Coordinates
	dxDrawText("X: " .. math.floor(x * 10) / 10 .. " Y: " .. math.floor(y * 10) / 10 .. " Z: " .. math.floor(z * 10) / 10, posX, posY + iMapRadius * 1.2, posX, posY + iMapRadius * 1.2, tocolor(222, 222, 222, 192), 1, "default-bold", "center", "center");

	--outputChatBox(getTickCount() - iNow); -- TIME DEBUG
end
addEventHandler("onClientRender", root, renderMinimap);

-- ******************************************************************************************************************************************************************************** --
-- Settings --

function zoomMinimap(strKey, bState)
	if (bState) then
		if (strKey == "num_add") then
			iMapScale = math.max(iMapMinScale, iMapScale - 25);
			updateTrack();
			
		elseif (strKey == "num_sub") then
			iMapScale = math.min(iMapScale + 25, iMapMaxScale);
			updateTrack();
			
		elseif (getKeyState("lshift")) then
			if (strKey == "mouse_wheel_up") then
				iMapScale = math.max(iMapMinScale, iMapScale - 25);
				updateTrack();
				
			elseif (strKey == "mouse_wheel_down") then
				iMapScale = math.min(iMapScale + 25, iMapMaxScale);
				updateTrack();
			end	
		end
	end
end
addEventHandler("onClientKey", root, zoomMinimap);

function mapSettings(cmd, subCmd, strState)
	if (subCmd == "info") then
		if (strState == "show" or strState == "true") then
			bShowInfo = true;
		elseif (strState == "hide" or strState == "false") then
			bShowInfo = false;
		elseif (strState == "toggle") then
			bShowInfo = not bShowInfo;
		end
		
		outputChatBox(strResColor..strResName .. "#ffffff Vehicle Info is now "..((bShowInfo) and "#aaffaavisible" or "#ffaaaahidden"), 255, 255, 255, true);

	elseif (subCmd == "track") then
		if (strState == "show" or strState == "true") then
			bShowTrack = true;
		elseif (strState == "hide" or strState == "false") then
			bShowTrack = false;
		elseif (strState == "toggle") then
			bShowTrack = not bShowTrack;
		end
		
		outputChatBox(strResColor..strResName .. "#ffffff Track is now "..((bShowTrack) and "#aaffaavisible" or "#ffaaaahidden"), 255, 255, 255, true);
		
	
	elseif (subCmd == "players") then
		if (strState == "show" or strState == "true") then
			bShowPlayers = true;
		elseif (strState == "hide" or strState == "false") then
			bShowPlayers = false;
		elseif (strState == "toggle") then
			bShowPlayers = not bShowPlayers;
		end
		
		outputChatBox(strResColor..strResName .. "#ffffff Players are now "..((bShowPlayers) and "#aaffaavisible" or "#ffaaaahidden"), 255, 255, 255, true);
		
	elseif (subCmd == "waypoints") then
		if (strState == "show" or strState == "true") then
			bShowWaypoints = true;
		elseif (strState == "hide" or strState == "false") then
			bShowWaypoints = false;
		elseif (strState == "toggle") then
			bShowWaypoints = not bShowWaypoints;
		end		
		
		outputChatBox(strResColor..strResName .. "#ffffff Waypoints are now "..((bShowWaypoints) and "#aaffaavisible" or "#ffaaaahidden"), 255, 255, 255, true);
		
	elseif (subCmd == "reset") then
		if (strState == "scale") then
			iMapScale = iDefaultMapScale;
			iMapMaxScale = iDefaultMapMaxScale;
			
			outputChatBox(strResColor..strResName .. "#ffffff Scales have been reset", 255, 255, 255, true);
			
		elseif (strState == "waypoints") then
			tblWaypoints = {};
			
			outputChatBox(strResColor..strResName .. "#ffffff Waypoints have been reset", 255, 255, 255, true);
			
		elseif (strState == "all") then
			iMapScale = iDefaultMapScale;
			iMapMaxScale = iDefaultMapMaxScale;
			tblWaypoints = {};
			bShowInfo = true;
			bShowTrack = true;
			bShowPlayers = true;
			bShowWaypoints = true;
			
			outputChatBox(strResColor..strResName .. "#ffffff Everything have been reset", 255, 255, 255, true);
		end
		
	elseif (subCmd == "maxscale") then
			if (not tonumber(strState)) then
				return outputChatBox(strResColor..strResName .. "#ffffffError: Invalid map max scale: #c4c4c4" .. strState, 255, 255, 255, true);
			end
			
			if (tonumber(strState) <= iMapMinScale) then
				return outputChatBox(strResColor..strResName .. " Attempted iMapMaxScale: #c4c4c4" .. strState .. " #ffffffcan't be equal or lower than iMapMinScale: #c4c4c4" .. iMapMinScale, 255, 255, 255, true);
			end
			
			iMapMaxScale = tonumber(strState);
			
			if (iMapScale > iMapMaxScale) then
				iMapScale = iMapMaxScale;
			end
			
			outputChatBox(strResColor..strResName .. "#ffffff Max map scale set to #c4c4c4"..strState, 255, 255, 255, true);
			
			if (iMapMaxScale >= 2000) then
				outputChatBox(strResColor..strResName .. "#ffffff Warning: A high map scale may cause lagg. In that case reduce it again or don't zoom out that far", 255, 255, 255, true);
			end

	elseif (subCmd == "help") then
		outputChatBox("");
		outputChatBox(strResColor..strResName .. " === Ceeser's Map Help ===", 255, 255, 255, true);
		outputChatBox(strResColor..strResName .. " #ffffffFor zooming you can use: #c4c4c4num_add#ffffff, #c4c4c4num_sub#ffffff or #c4c4c4lshift + scroll", 255, 255, 255, true);
		outputChatBox(strResColor..strResName .. " #ffffffThe texts at the left bottom of the map indicate if the feature is dis-/enabled", 255, 255, 255, true);
		outputChatBox(strResColor..strResName .. " #ffffffChange settings using these commands:", 255, 255, 255, true);
		outputChatBox(strResColor..strResName .. " #c4c4c4/cmap #ffffff(#c4c4c4info#ffffff || #c4c4c4track#ffffff || #c4c4c4players#ffffff || #c4c4c4waypoints#ffffff) (#c4c4c4show#ffffff || #c4c4c4hide#ffffff || #c4c4c4toggle#ffffff)", 255, 255, 255, true);
		outputChatBox(strResColor..strResName .. " #c4c4c4/cmap reset #ffffff(#c4c4c4scale#ffffff || #c4c4c4all#ffffff)", 255, 255, 255, true);
		outputChatBox(strResColor..strResName .. " #c4c4c4/cmap maxscale [value]", 255, 255, 255, true);
		outputChatBox(strResColor..strResName .. " #ffffffType '#c4c4c4/wp help#ffffff' for waypoints help", 255, 255, 255, true);
	end
end
addCommandHandler("cmap", mapSettings);

function loadSettings()
	if not (fileExists(strSettingsFile)) then
		return
	end
	
	local uFile = xmlLoadFile(strSettingsFile);
	
	bShowInfo = (xmlNodeGetAttribute(uFile, "showInfo") == "true") and true or false;
	bShowTrack = (xmlNodeGetAttribute(uFile, "showTrack") == "true") and true or false;
	bShowPlayers = (xmlNodeGetAttribute(uFile, "showPlayers") == "true") and true or false;
	bShowWaypoints = (xmlNodeGetAttribute(uFile, "showWaypoints") == "true") and true or false;
	iMapScale = (tonumber(xmlNodeGetAttribute(uFile, "mapScale")));
	iMapMaxScale = (tonumber(xmlNodeGetAttribute(uFile, "mapMaxScale")));
	
	xmlUnloadFile(uFile);
end

function saveSettings()
	if (fileExists(strSettingsFile)) then
		fileDelete(strSettingsFile);
	end
	
	local uFile = xmlCreateFile(strSettingsFile, "cmap");
	
	xmlNodeSetAttribute(uFile, "showInfo", tostring(bShowInfo));
	xmlNodeSetAttribute(uFile, "showTrack", tostring(bShowTrack));
	xmlNodeSetAttribute(uFile, "showPlayers", tostring(bShowPlayers));
	xmlNodeSetAttribute(uFile, "showWaypoints", tostring(bShowWaypoints));
	xmlNodeSetAttribute(uFile, "mapScale", tostring(iMapScale));
	xmlNodeSetAttribute(uFile, "mapMaxScale", tostring(iMapMaxScale));
	
	xmlSaveFile(uFile);
	xmlUnloadFile(uFile);
end

-- ******************************************************************************************************************************************************************************** --
-- Start and Stop --

function onResourceStart()
	loadSettings();
	loadWayPoints();
	
	outputChatBox(strResColor..strResName .. "#ffffff Started. Type '#c4c4c4/cmap help#ffffff' for help", 255, 255, 255, true)
end
addEventHandler("onClientResourceStart", resourceRoot, onResourceStart);

function onResourceStop()
	saveSettings();
	saveWayPoints();
end
addEventHandler("onClientResourceStop", resourceRoot, onResourceStop);

-- ******************************************************************************************************************************************************************************** --
-- Utilities --

function checkColors(r, g, b, a)
	if (not r) then r = 255 end
	if (not g) then g = 255 end
	if (not b) then b = 255 end
	if (not a) then a = 255 end
	
	if (not tonumber(r)) then
		outputChatBox(strResColor..strResName.." #ffffffError: Invalid red color: #ff0000" .. r .. " #00ff00" .. g .. " #0000ff" .. b, 255, 255, 255, true);
		return false;
	end
	
	if (not tonumber(g)) then
		outputChatBox(strResColor..strResName.." #ffffffError: Invalid green color: #ff0000" .. r .. " #00ff00" .. g .. " #0000ff" .. b, 255, 255, 255, true);
		return false;	
	end
	
	if (not tonumber(b)) then
		outputChatBox(strResColor..strResName.." #ffffffError: Invalid blue color: #ff0000" .. r .. " #00ff00" .. g .. " #0000ff" .. b, 255, 255, 255, true);
		return false;	
	end
	
	if (not tonumber(a)) then
		outputChatBox(strResColor..strResName.." #ffffffError: Invalid alpha: " .. a, 255, 255, 255, true);
		return false;	
	end
	
	r = math.max(0, math.min(tonumber(r), 255));
	g = math.max(0, math.min(tonumber(g), 255));
	b = math.max(0, math.min(tonumber(b), 255));
	a = math.max(0, math.min(tonumber(a), 255));
	
	return  r, g, b, a;
end

function findRotation(x1, y1, x2, y2)
    local t = -math.deg(math.atan2( x2 - x1, y2 - y1 ));
    return t < 0 and t + 360 or t;
end

function dxDraw3DTextScaled(text, textX, textY, textZ, scale, font, color, maxDistance, colorCoded, rotation)
	if not (x and y and z) then
		outputDebugString("dxDraw3DText: One of the world coordinates is missing", 1)
		return false;
	end

	if not (scale) then
		scale = 2;
	end
	
	if not (font) then
		font = "default";
	end
	
	if not (color) then
		color = tocolor(255, 255, 255, 255);
	end
	
	if not (maxDistance) then
		maxDistance = 12;
	end
	
	if not (colorCoded) then
		colorCoded = false;
	end
	
	if not (rotation) then
		rotation = 0
	end
	
	local x, y, z = getElementPosition(localPlayer);
	local distance = math.sqrt((x - textX) ^ 2 + (y - textY) ^ 2 + (z - textZ) ^ 2);
	
	if (distance <= maxDistance) then
		local x, y = getScreenFromWorldPosition(textX, textY, textZ);
		
		if (x and y) then
			dxDrawText( text, x + 2, y + 2, _, _, tocolor(0, 0, 0, 127), scale * (100 / distance), font, "center", "center", false, false, false, colorCoded, true, rotation);
			dxDrawText( text, x, y, _, _, color, scale * (100 / distance), font, "center", "center", false, false, false, colorCoded, true, rotation);
			return true
		end
	end
end

function dxDrawRing( x, y, width, height, color, angleStart, angleSweep, borderWidth )
	height = height or width
	color = color or tocolor(255,255,255)
	borderWidth = borderWidth or 1e9
	angleStart = angleStart or 0
	angleSweep = angleSweep or 360 - angleStart
	if ( angleSweep < 360 ) then
		angleEnd = math.fmod( angleStart + angleSweep, 360 ) + 0
	else
		angleStart = 0
		angleEnd = 360
	end
	x = x - width / 2
	y = y - height / 2
	if not circleShader then
		circleShader = dxCreateShader ( "circle.fx" )
	end
	dxSetShaderValue ( circleShader, "sCircleWidthInPixel", width );
	dxSetShaderValue ( circleShader, "sCircleHeightInPixel", height );
	dxSetShaderValue ( circleShader, "sBorderWidthInPixel", borderWidth );
	dxSetShaderValue ( circleShader, "sAngleStart", math.rad( angleStart ) - math.pi );
	dxSetShaderValue ( circleShader, "sAngleEnd", math.rad( angleEnd ) - math.pi );
	dxDrawImage( x, y, width, height, circleShader, 0, 0, 0, color )
end