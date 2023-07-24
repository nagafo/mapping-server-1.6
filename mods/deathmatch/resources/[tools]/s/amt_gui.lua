local screen_width, screen_height = guiGetScreenSize()
local PI = math.pi
local FOV = 0.01 -- Size of image relative to 3d distance
local MIN_RADIUS = 1 -- Minimal allowed radius to generate with
local generate = true -- handle generate/save button
local hElements = {}
local oldX, oldY, oldZ = 0, 0, 0 -- get difference between rotation when rotating
local currentWindow = 1
local elementList = {}
local duplicateElement = {}
local selectingElement = nil
local rotationDisabled = false
local previewElements = {}
local selectedElement = nil

local additional = {}
additional.oldRotX = nil
additional.oldRotY = nil
additional.oldRotZ = nil

local oldRotX, oldRotY, oldRotZ = nil, nil, nil
local oldPosX, oldPosY, oldPosZ = nil, nil, nil

local gui = {}
local img = {}
local KEY = {}

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
function()
	outputChatBox("#3c00ffArezu's Mapping Toolbox #FFFFFF- Press F7 to toggle", 255, 25, 25, true)
	outputChatBox("Type /des to undo, n to start recording/playing, and m to stop.", 255, 255, 255, true)
	gui.font = guiCreateFont("font/Arialic Hollow.ttf", 10)
	
	gui[1] = {}
	gui[1].window_width = 500
	gui[1].window_height = gui[1].window_width * 0.5625
	gui[1].window_x = screen_width - gui[1].window_width
	gui[1].window_y = screen_height - gui[1].window_height
	gui[1].window_title = "Arezu's Mapping Toolbox"
	gui[1].window = guiCreateWindow(gui[1].window_x, gui[1].window_y, gui[1].window_width, gui[1].window_height, gui[1].window_title, false)
	guiWindowSetMovable(gui[1].window, false)
	guiWindowSetSizable(gui[1].window, false)
	
	gui[2] = {}
	gui[2].window_width = 500
	gui[2].window_height = gui[2].window_width * 0.5625
	gui[2].window_x = screen_width - gui[2].window_width
	gui[2].window_y = screen_height - gui[2].window_height
	gui[2].window_title = "Arezu's Mapping Toolbox"
	gui[2].window = guiCreateWindow(gui[2].window_x, gui[2].window_y, gui[2].window_width, gui[2].window_height, gui[2].window_title, false)
	guiWindowSetMovable(gui[2].window, false)
	guiWindowSetSizable(gui[2].window, false)
	
	--[[
	gui[3] = {}
	gui[3].window_width = 500
	gui[3].window_height = gui[3].window_width * 0.5625
	gui[3].window_x = screen_width - gui[3].window_width
	gui[3].window_y = screen_height - gui[3].window_height
	gui[3].window_title = "Arezu's Mapping Toolbox"
	gui[3].window = guiCreateWindow(gui[3].window_x, gui[3].window_y, gui[3].window_width, gui[3].window_height, gui[3].window_title, false)
	guiWindowSetMovable(gui[3].window, false)
	guiWindowSetSizable(gui[3].window, false)
	--]]
	
	gui.generate_background = guiCreateStaticImage(0, 0, gui[1].window_width, gui[1].window_height, "img/generator_background.png", false, gui[1].window)
	gui.tab_padding = 0
	gui.tab_panel = guiCreateTabPanel(gui.tab_padding, gui.tab_padding, gui[1].window_width - gui.tab_padding*2, gui[1].window_height - gui.tab_padding*2, false, gui[1].window)
	guiSetEnabled(gui.generate_background, false)
	guiSetEnabled(gui.tab_panel, false)
	
	gui[1].title = guiCreateLabel(0, 0, 100, 50, "Generator", false, gui[1].window)
	local textExtent = guiLabelGetTextExtent(gui[1].title)
	guiSetPosition(gui[1].title, gui[1].window_width/2 - textExtent/2, 25, false)
	guiSetEnabled(gui[1].title, false)
	guiBringToFront(gui[1].title)
	guiSetFont(gui[1].title, "default-bold-small")
	
	gui[2].title = guiCreateLabel(0, 0, 100, 50, "Duplicator", false, gui[2].window)
	local textExtent = guiLabelGetTextExtent(gui[2].title)
	guiSetPosition(gui[2].title, gui[2].window_width/2 - textExtent/2, 25, false)
	guiSetEnabled(gui[2].title, false)
	guiBringToFront(gui[2].title)
	guiSetFont(gui[2].title, "default-bold-small")
	
	--[[
	gui[3].title = guiCreateLabel(0, 0, 100, 50, "Credits", false, gui[3].window)
	local textExtent = guiLabelGetTextExtent(gui[3].title)
	guiSetPosition(gui[3].title, gui[3].window_width/2 - textExtent/2, 25, false)
	guiSetEnabled(gui[3].title, false)
	guiBringToFront(gui[3].title)
	guiSetFont(gui[3].title, "default-bold-small")
	--]]
	
	gui.loops_label_title = "Loops:"
	gui.loops_label_width = 40
	gui.loops_label_height = 20
	gui.loops_label_x = 25
	gui.loops_label_y = 75
	gui.loops_label = guiCreateLabel(gui.loops_label_x, gui.loops_label_y, gui.loops_label_width, gui.loops_label_height, gui.loops_label_title, false, gui[1].window)
	guiSetEnabled(gui.loops_label, false)
	gui.loops_field_width = 50
	gui.loops_field_height = 20
	gui.loops_field_x = gui.loops_label_x + gui.loops_label_width
	gui.loops_field_y = gui.loops_label_y
	gui.loops_field = guiCreateEdit(gui.loops_field_x, gui.loops_field_y, gui.loops_field_width, gui.loops_field_height, "1", false, gui[1].window)
	
	gui.radius_label_title = "Radius:"
	gui.radius_label_width = 40
	gui.radius_label_height = 20
	gui.radius_label_x = gui.loops_field_x + gui.loops_field_width + 15
	gui.radius_label_y = gui.loops_label_y
	gui.radius_label = guiCreateLabel(gui.radius_label_x, gui.radius_label_y, gui.radius_label_width, gui.radius_label_height, gui.radius_label_title, false, gui[1].window)
	guiSetEnabled(gui.radius_label, false)
	gui.radius_field_width = 60
	gui.radius_field_height = 20
	gui.radius_field_x = gui.radius_label_x + gui.radius_label_width
	gui.radius_field_y = gui.radius_label_y
	gui.radius_field = guiCreateEdit(gui.radius_field_x, gui.radius_field_y, gui.radius_field_width, gui.radius_field_height, "50", false, gui[1].window)
	
	gui.objects_label_title = "Objects:"
	gui.objects_label_width = 50
	gui.objects_label_height = 20
	gui.objects_label_x = gui.loops_label_x
	gui.objects_label_y = gui.loops_label_y + gui.loops_label_height + 15
	gui.objects_label = guiCreateLabel(gui.objects_label_x, gui.objects_label_y, gui.objects_label_width, gui.objects_label_height, gui.objects_label_title, false, gui[1].window)
	guiSetEnabled(gui.objects_label, false)
	gui.objects_field_width = 60
	gui.objects_field_height = 20
	gui.objects_field_x = gui.objects_label_x + gui.objects_label_width
	gui.objects_field_y = gui.objects_label_y
	gui.objects_field = guiCreateEdit(gui.objects_field_x, gui.objects_field_y, gui.objects_field_width, gui.objects_field_height, "50", false, gui[1].window)
	guiSetEnabled(gui.objects_field, false)
	gui.objects_times_label = guiCreateLabel(gui.objects_field_x + gui.objects_field_width + 5, gui.objects_field_y, 50, 25, "x", false, gui[1].window)
	guiSetEnabled(gui.objects_times_label, false)
	gui.objects_times_field = guiCreateEdit(gui.objects_field_x + gui.objects_field_width + 15, gui.objects_field_y, gui.objects_field_width, gui.objects_field_height, "1", false, gui[1].window)
	
	gui.objects_auto_title = "Autocount objects"
	gui.objects_auto_width = 130
	gui.objects_auto_height = 20
	gui.objects_auto_x = gui.loops_label_x
	gui.objects_auto_y = gui.objects_label_y + gui.objects_label_height + 5
	gui.objects_auto_box = guiCreateCheckBox(gui.objects_auto_x, gui.objects_auto_y, gui.objects_auto_width, gui.objects_auto_height, gui.objects_auto_title, true, false, gui[1].window)
	
	gui.offset_label_title = "Offset:"
	gui.offset_label_width = 50
	gui.offset_label_height = 20
	gui.offset_label_x = gui.loops_label_x
	gui.offset_label_y = gui.objects_auto_y + gui.objects_auto_height + 5
	gui.offset_label = guiCreateLabel(gui.offset_label_x, gui.offset_label_y, gui.offset_label_width, gui.offset_label_height, gui.offset_label_title, false, gui[1].window)
	guiSetEnabled(gui.offset_label, false)
	gui.offset_field_width = 60
	gui.offset_field_height = 20
	gui.offset_field_x = gui.offset_label_x + gui.offset_label_width
	gui.offset_field_y = gui.offset_label_y
	gui.offset_field = guiCreateEdit(gui.offset_field_x, gui.offset_field_y, gui.offset_field_width, gui.offset_field_height, "100", false, gui[1].window)
	--addEventHandler("onClientGUIChanged", gui.offset_field, alterGeneration, false)
	
	gui.conrot_label = guiCreateLabel(300, 75, 125, 20, "Continuous rotation:", false, gui[1].window)
	guiSetEnabled(gui.conrot_label, false)
	
	gui.conrot_rotX_label = guiCreateLabel(270, 90, 50, 20, "rotX:", false, gui[1].window)
	guiSetEnabled(gui.conrot_rotX_label, false)
	gui.conrot_rotX_field = guiCreateEdit(270, 105, 50, 20, "0", false, gui[1].window)
	addEventHandler("onClientGUIChanged", gui.conrot_rotX_field, alterGeneration, false)
	
	gui.conrot_rotY_label = guiCreateLabel(340, 90, 50, 20, "rotY:", false, gui[1].window)
	guiSetEnabled(gui.conrot_rotY_label, false)
	gui.conrot_rotY_field = guiCreateEdit(340, 105, 50, 20, "0", false, gui[1].window)
	addEventHandler("onClientGUIChanged", gui.conrot_rotY_field, alterGeneration, false)
	
	gui.conrot_rotZ_label = guiCreateLabel(410, 90, 50, 20, "rotZ:", false, gui[1].window)
	guiSetEnabled(gui.conrot_rotZ_label, false)
	gui.conrot_rotZ_field = guiCreateEdit(410, 105, 50, 20, "0", false, gui[1].window)
	addEventHandler("onClientGUIChanged", gui.conrot_rotZ_field, alterGeneration, false)

	gui.gen_width = gui[1].window_width * 0.5
	gui.gen_height = 25
	gui.gen_x = gui[1].window_width/2 - gui.gen_width/2
	gui.gen_y = gui[1].window_height - gui.gen_height - 20
	gui.gen_title_generate = "Generate!"
	gui.gen_title_save = "Save"
	gui.gen_button = guiCreateButton(gui.gen_x, gui.gen_y, gui.gen_width, gui.gen_height, gui.gen_title_generate, false, gui[1].window)
	addEventHandler("onClientGUIClick", gui.gen_button, startGenerating, false)
	
	local wx, wy = guiGetPosition(gui[currentWindow].window, false)
	local wWidth, wHeight = gui[currentWindow].window_width, gui[currentWindow].window_height
	gui.left_width = 20
	gui.left_height = 20
	gui.left_x = wx + wWidth/2 - 100 - gui.left_width/2
	gui.left_y = wy + 25
	
	gui.right_width = 20
	gui.right_height = 20
	gui.right_x = wx + wWidth/2 + 100 - gui.right_width/2
	gui.right_y = wy + 25
	
	addEventHandler("onClientGUIClick", getResourceRootElement(getThisResource()), editFieldHandle)
	addEventHandler("onClientGUIChanged", getResourceRootElement(getThisResource()), updateAutocount)
	addEventHandler("onClientGUIChanged", getResourceRootElement(getThisResource()), updateAMTFields)
	bindKey("F7", "up", 
	function()
		guiSetVisible(gui[currentWindow].window, not guiGetVisible(gui[currentWindow].window))
		
		if(currentWindow == 1)then
			if not guiGetVisible(gui[currentWindow].window)then
				for i = 1, #previewElements do
					if(isElement(previewElements[i]))then
						detachElements(previewElements[i])
						if(exports.editor_main:getSelectedElement() == previewElements[i])then
							exports.editor_main:destroySelectedElement()
						else
							destroyElement(previewElements[i])
						end
					end
				end
			else
				previewUpdate()
			end
		end
	end)
	setWindow(1)
	
	local element1_width = gui[2].window_width*0.5
	local element1_height = 25
	gui.element1 = guiCreateButton(gui[2].window_width/2 - element1_width/2, 100 - element1_height/2, element1_width, element1_height, "Select 1st element", false, gui[2].window)
	addEventHandler("onClientGUIClick", gui.element1, 
		function()
			guiSetText(source, "Press on element to select...")
			selectingElement = source
		end, false)
	
	local element2_width = gui[2].window_width*0.5
	local element2_height = 25
	gui.element2 = guiCreateButton(gui[2].window_width/2 - element2_width/2, 150 - element2_height/2, element2_width, element2_height, "Select 2nd element", false, gui[2].window)
	addEventHandler("onClientGUIClick", gui.element2, 
		function()
			guiSetText(source, "Press on element to select...")
			selectingElement = source
		end, false)
		
	local amount_width = 75
	local amount_height = 20
	gui.dup_amount = guiCreateEdit(gui[2].window_width/2 - amount_width/2, 190, amount_width, amount_height, "5", false, gui[2].window)
	gui.dup_amount_title = guiCreateLabel(gui[2].window_width/2 - amount_width - 10, 190, 100, 25, "Copies: ", false, gui[2].window)
	guiSetEnabled(gui.dup_amount_title, false)
	
	gui.dup_button = guiCreateButton(gui.gen_x, gui.gen_y, gui.gen_width, gui.gen_height, "Duplicate", false, gui[2].window)
	addEventHandler("onClientGUIClick", gui.dup_button, 
		function()
			local copies = tonumber(guiGetText(gui.dup_amount))
			if(isElement(duplicateElement[1]) and isElement(duplicateElement[2]) and copies)then
				triggerServerEvent("onClientRequestDuplicate", getLocalPlayer(), duplicateElement[1], duplicateElement[2], copies)
			elseif(not copies)then
				outputChatBox("#FF2525[AMT ERROR]: #FFFFFFCopies value is not a valid number.", 255, 25, 25, true)
			else
				outputChatBox("#FF2525[AMT ERROR]: #FFFFFFYou need to select two elements first.", 255, 25, 25, true)
			end
		end, false)
		
		--[[
	gui.credit_text = guiCreateLabel(20, 50, gui[3].window_width, gui[3].window_height, 
	
	Everything in this toolbox was made by ~pS|Arezu with the exception of 
	the images which were made by ~pS|Rextox, and two functions which were 
	made by the creators of 'Editor'.
	______________________________________________________________
	
	Made with the reason of hoping players start mapping with other objects 
	than only carshades, and stops making "normal" loops and wallrides.
	And to make our server a little bit more popular :3
	
	You are free to edit this "spaghetti" code if you include credits.
	, false, gui[3].window)
	guiSetEnabled(gui.credit_text, false)
	gui.credit_button = guiCreateButton(gui[3].window_width/2 - 250/2, gui[3].window_height - 50, 250, 25, "Join Pure Skillz server", false, gui[3].window)
	addEventHandler("onClientGUIClick", gui.credit_button,
		function()
			triggerServerEvent("onRequestRedirectPlayer", getLocalPlayer())
		end, false)
		--]]
	
	--guiSetInputMode("no_binds")
	
	-- Direction images for choosing direction
	img.src = "img/cimg.png"
	img.nonSelectedColor = tocolor(255, 255, 255, 255)
	img.selectedCenterColor = tocolor(255, 0, 0, 255)
	img.selectedDirColor = tocolor(0, 255, 0, 255)
	img.selectedCenter = 1 -- Select top as default
	img.selectedDir = 5 -- Select forward as default
	img.rope_color = tocolor(46, 173, 232, 255) -- color of the lines to each directional image
	img.rope_width = 20
	img.dist = 50 -- default distance from object to draw
	img.diameter = 100 -- original width and height of the image
	
	
	-- Key settings, also settings for radius and images distance
	KEY.LARGER_RADIUS = "arrow_u"
	KEY.SMALLER_RADIUS = "arrow_d"
	KEY.RADIUS_CHANGE_SPEED = 1
	
	addEventHandler("onClientGUIChanged", getResourceRootElement(getThisResource()),
	function()
		local text = guiGetText(source)
		for i = 1, text:len() do
			local str = string.sub(text, i, i)
			if not tonumber(str) and str ~= "." and str ~= "-" then
				text = string.replace(text, i, "")
			end
		end
		guiSetText(source, text)
	end)
end)

function string.replace(text, pos, char)
	return string.sub(text, 1, pos-1)..string.sub(text, pos+1, text:len())
end

function setWindow(window)
	for i = 1, #gui do
		if(gui[i].window ~= nil)then
			if(i == window)then
				guiSetVisible(gui[i].window, true)
			else
				guiSetVisible(gui[i].window, false)
			end
		end
	end
	currentWindow = window
	if(currentWindow ~= 1)then
		for i = 1, #previewElements do
			if(isElement(previewElements[i]))then
				detachElements(previewElements[i])
				if(exports.editor_main:getSelectedElement() == previewElements[i])then
					exports.editor_main:destroySelectedElement()
				else
					destroyElement(previewElements[i])
				end
			end
		end
	end
end

-- Get selected element from editor_main and only save when new element has been selected.
addEventHandler("onClientRender", getRootElement(),
function()
	if(guiGetVisible(gui[currentWindow].window))then
		local lx, ly, rx, ry = gui.left_x, gui.left_y, gui.right_x, gui.right_y
		local wColor = tocolor(255, 255, 255, 255)
		local cx, cy = 0.5, 0.5
		if(isCursorShowing())then
			cx, cy = getCursorPosition()
		end
		cx = cx * screen_width
		cy = cy * screen_height
		if(cx >= lx and cx <= lx+gui.left_width and cy >= ly and cy <= ly+gui.left_height)then
			if(getKeyState("mouse1"))then
				wColor = tocolor(255, 0, 0, 255)
			else
				wColor = tocolor(255, 75, 75, 255)
			end
		end
		dxDrawImage(lx, ly, gui.left_width, gui.left_height, "img/cimg.png", 180, 0, 0, wColor, true)
		wColor = tocolor(255, 255, 255, 255)
		if(cx >= rx and cx <= rx+gui.right_width and cy >= ry and cy <= ry+gui.right_height)then
			if(getKeyState("mouse1"))then
				wColor = tocolor(255, 0, 0, 255)
			else
				wColor = tocolor(255, 75, 75, 255)
			end
		end
		dxDrawImage(rx, ry, gui.right_width, gui.right_height, "img/cimg.png", 0, 0, 0, wColor, true)
	end
	if(not guiGetVisible(gui[currentWindow].window) or currentWindow ~= 1)then return end
	if(getKeyState(KEY.LARGER_RADIUS))then
		triggerEvent("onAMTKeyPress", getLocalPlayer(), KEY.LARGER_RADIUS)
	end
	if(getKeyState(KEY.SMALLER_RADIUS))then
		triggerEvent("onAMTKeyPress", getLocalPlayer(), KEY.SMALLER_RADIUS)
	end
	local element = exports.editor_main:getSelectedElement()
	if(element ~= false and element ~= selectedElement and isElement(element) and getElementType(element) == "object")then
		selectedElement = element
		if(not img[selectedElement])then
			img[selectedElement] = {}
			img[selectedElement].dist = 50 -- distance from object to image
			img[selectedElement].selectedCenter = img.selectedCenter
			img[selectedElement].selectedDir = img.selectedDir
			
			-- 1: UP
			-- 2: DOWN
			-- 3: LEFT
			-- 4: RIGHT
			-- 5: FORWARD
			-- 6: BACKWARD
			for i = 1, 6 do
				img[selectedElement][i] = {}
				img[selectedElement][i].diameter = img.diameter -- width and height of the image
				img[selectedElement][i].x = 0
				img[selectedElement][i].y = 0
			end
			
			-- Direction data
			img[selectedElement][1].dirX = 0
			img[selectedElement][1].dirY = 0
			img[selectedElement][1].dirZ = 1
			
			img[selectedElement][2].dirX = 0
			img[selectedElement][2].dirY = 0
			img[selectedElement][2].dirZ = -1
			
			img[selectedElement][3].dirX = -1
			img[selectedElement][3].dirY = 0
			img[selectedElement][3].dirZ = 0
			
			img[selectedElement][4].dirX = 1
			img[selectedElement][4].dirY = 0
			img[selectedElement][4].dirZ = 0
			
			img[selectedElement][5].dirX = 0
			img[selectedElement][5].dirY = 1
			img[selectedElement][5].dirZ = 0
			
			img[selectedElement][6].dirX = 0
			img[selectedElement][6].dirY = -1
			img[selectedElement][6].dirZ = 0
		end
		outputDebugString("AMT: New element selected.")
		local dist = tonumber(guiGetText(gui.radius_field)) or 50
		if(img[selectedElement] ~= nil)then
			dist = img[selectedElement].dist
		end
		--img[selectedElement].dist = tonumber(dist)
		guiSetText(gui.radius_field, tostring(dist))
		updateAutocount()
		guiSetText(gui.objects_times_field, "1")
		previewUpdate()
	end
	if(selectedElement ~= nil and guiGetVisible(gui[currentWindow].window))then
		-- if the selected element gets deleted by a resource(editor is stopped, etc)
		if(not isElement(selectedElement))then
			selectedElement = nil
			return false
		end
		local camX, camY, camZ, tarX, tarY, tarZ = getCameraMatrix()
		local s = selectedElement
		for i = 1, 6 do
			local distX, distY, distZ = img[s][i].dirX, img[s][i].dirY, img[s][i].dirZ
			local x, y, z = getTransformedElementPosition(selectedElement, distX, distY, distZ)
			local dx = camX - x
			local dy = camY - y
			local dz = camZ - z
			local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
			img[s][i].dist = dist
		end
		local posX, posY, posZ = getElementPosition(selectedElement)
		for i = 1, 6 do
			local index = i
			local distX, distY, distZ = img[s][index].dirX*img[s].dist, img[s][index].dirY*img[s].dist, img[s][index].dirZ*img[s].dist
			local x, y, z = getTransformedElementPosition(selectedElement, distX, distY, distZ)
			local x2, y2, z2 = getTransformedElementPosition(selectedElement, distX*1.001, distY*1.001, distZ*1.001)
			if(x ~= false and x2 ~= false)then
				dxDrawLine3D(posX, posY, posZ, x, y, z, img.rope_color, img.rope_width, false, 10.0)
				sx, sy, sz = getScreenFromWorldPosition(x, y, z)
				sx2, sy2, sz2 = getScreenFromWorldPosition(x2, y2, z2)
				if(sx ~= false and sx2 ~= false)then
					local rot = -math.deg(math.atan2(sx - sx2, sy - sy2)) - 90
					local color = img.nonSelectedColor
					if(i == img[s].selectedCenter)then
						color = img.selectedCenterColor
					end
					if(i == img[s].selectedDir)then
						color = img.selectedDirColor
					end
					img[s][index].x, img[s][index].y, img[s][index].diameter, img[s][index].diameter = dxDrawImage3D(x, y, z, img.diameter, img.diameter, img.src, rot, 0, 0, color, false)
				end
			end
		end
	end
end)

function tableMax(tab)
	local max = tab[1]
	local maxIndex = 1
	for i = 1, #tab do
		if(tab[i] > max)then
			max = tab[i]
			maxIndex = i
		end
	end
	return maxIndex
end

function dxDrawImage3D(x, y, z, width, height, src, rot, px, py, color, postGUI)
	local camX, camY, camZ, tarX, tarY, tarZ = getCameraMatrix()
	local dx, dy, dz, dist = 0
	dx = camX - x
	dy = camY - y
	dz = camZ - z
	dist = math.sqrt(dx*dx + dy*dy + dz*dz)
	x, y, z = getScreenFromWorldPosition(x, y, z)
	if(x == false)then return end
	width = width / (dist * FOV)
	height = height / (dist * FOV)
	x = x - width/2
	y = y - height/2
	dxDrawImage(x, y, width, height, src, rot, px, py, color, postGUI)
	return x, y, width, height
end

addEventHandler("onClientClick", getRootElement(),
function(button, state, absX, absY, worldX, worldY, worldZ, element)
	if(state == "down" and button == "left" and selectingElement)then
		if(element)then
			if(selectingElement == gui.element1)then
				duplicateElement[1] = element
			elseif(selectingElement == gui.element2)then
				duplicateElement[2] = element
			end
			guiSetText(selectingElement, getElementID(element))
			selectingElement = nil
		else
			if(selectingElement == gui.element1)then
				guiSetText(selectingElement, "Select 1st element")
			elseif(selectingElement == gui.element2)then
				guiSetText(selectingElement, "Select 2nd element")
			end
			selectingElement = nil
		end
	end
	if(state == "down" and button == "left")then
		local nextWindow = currentWindow
		if(absX >= gui.left_x and absX <= gui.left_x+gui.left_width and absY >= gui.left_y and absY <= gui.left_y+gui.left_height)then
			nextWindow = nextWindow - 1
			if(nextWindow < 1)then nextWindow = #gui end
			setWindow(nextWindow)
		end
		if(absX >= gui.right_x and absX <= gui.right_x+gui.right_width and absY >= gui.right_y and absY <= gui.right_y+gui.right_height)then
			nextWindow = nextWindow + 1
			if(nextWindow > #gui)then nextWindow = 1 end
			setWindow(nextWindow)
		end
	end
	-- If element is not streamed, then dont care if player presses on image or not.
	if(state ~= "up" or not selectedElement)then return end
	for i = 1, 6 do
		local dx = absX - (img[selectedElement][i].x + img[selectedElement][i].diameter/2)
		local dy = absY - (img[selectedElement][i].y + img[selectedElement][i].diameter/2)
		local dist = math.sqrt(dx*dx + dy*dy)
		if(dist <= img[selectedElement][i].diameter/2)then
			triggerEvent("onClientAMTImageClick", getLocalPlayer(), i, button)
			return false
		end
	end
end)

addEvent("onAMTKeyPress", true)
addEventHandler("onAMTKeyPress", getRootElement(),
function(button)
	-- AMT has selected element, but not the editor (when object has once been marked, but then deselected)
	if(exports.editor_main:getSelectedElement() == false and selectedElement ~= nil)then
		local s = selectedElement
		if(button == KEY.LARGER_RADIUS)then
			img[s].dist = img[s].dist + KEY.RADIUS_CHANGE_SPEED
		end
		if(button == KEY.SMALLER_RADIUS)then
			img[s].dist = img[s].dist - KEY.RADIUS_CHANGE_SPEED
		end
		if(img[s].dist < MIN_RADIUS)then
			img[s].dist = MIN_RADIUS
		end
		guiSetText(gui.radius_field, tostring(img[s].dist))
		updateAutocount()
	end
end)

addEvent("onClientAMTImageClick", true)
addEventHandler("onClientAMTImageClick", getRootElement(),
function(imgIndex, button)
	-- source is the player that clicked on AMTImage (always local player)
	local s = selectedElement
	if(button == "left")then
		-- When player selectes center and selected dir is not in allowed direction, then set
		-- selected direction to another
		if(imgIndex == 1 or imgIndex == 2)then
			if(img[s].selectedDir == 1 or img[s].selectedDir == 2)then
				img[s].selectedDir = 5
			end
		end
		if(imgIndex == 3 or imgIndex == 4)then
			if(img[s].selectedDir == 3 or img[s].selectedDir == 4)then
				img[s].selectedDir = 1
			end
		end
		if(imgIndex == 5 or imgIndex == 6)then
			if(img[s].selectedDir == 5 or img[s].selectedDir == 6)then
				img[s].selectedDir = 1
			end
		end
		img[s].selectedCenter = imgIndex
		outputDebugString("AMT: center point set to "..imgIndex)
	end
	if(button == "middle")then
		if(img[s].selectedCenter == 1 or img[s].selectedCenter == 2)then
			if(imgIndex == 1 or imgIndex == 2)then return end
		end
		if(img[s].selectedCenter == 3 or img[s].selectedCenter == 4)then
			if(imgIndex == 3 or imgIndex == 4)then return end
		end
		if(img[s].selectedCenter == 5 or img[s].selectedCenter == 6)then
			if(imgIndex == 5 or imgIndex == 6)then return end
		end
		img[s].selectedDir = imgIndex
		outputDebugString("AMT: direction point set to "..imgIndex)
	end
	updateAutocount()
	previewUpdate()
end)

function updateAMTFields()
	-- we only want to change edit fields
	if(source == gui.objects_auto_box)then return end
	if(source == gui.radius_field)then
		local number = tonumber(guiGetText(source))
		if(number ~= nil)then
			img[selectedElement].dist = number
		end
		if(img[selectedElement].dist < MIN_RADIUS)then
			img[selectedElement].dist = MIN_RADIUS
		end
	end
end

-- Update autocount object edit field if its enabled
function updateAutocount()
	if(selectedElement == nil or not guiCheckBoxGetSelected(gui.objects_auto_box))then return end
	local radius = tonumber(guiGetText(gui.radius_field))
	local objects = tonumber(guiGetText(gui.objects_field))
	local offset = tonumber(guiGetText(gui.offset_field))
	if not radius or not offset then return end
	offset = offset/objects
	local side = "x"
	local center = img[selectedElement].selectedCenter
	local dir = img[selectedElement].selectedDir
	local rot = 360 / objects
	local rx, ry, rz = 0, 0, 0
	if(center == 1)then
		if(dir == 5)then
			side = "y"
			rz = -atan2(offset, cos(rot - 90)*radius)
		end
		if(dir == 6)then
			side = "y"
			rz = -atan2(-offset, -cos(rot - 90)*radius)
		end
		if(dir == 3)then
			side = "x"
			rz = atan2(offset, -cos(rot - 90)*radius)
		end
		if(dir == 4)then
			side = "x"
			rz = -atan2(offset, cos(rot - 90)*radius)
		end
	end
	if(center == 2)then
		if(dir == 5)then
			side = "y"
			diffSide = -offset
		end
		if(dir == 6)then
			side = "y"
			diffSide = offset
		end
		if(dir == 3)then
			side = "x"
			diffSide = -offset
		end
		if(dir == 4)then
			side = "x"
			diffSide = offset
		end
	end
	if(center == 3)then
		if(dir == 5)then
			side = "y"
			diffSide = offset
		end
		if(dir == 6)then
			side = "y"
			diffSide = -offset
		end
		if(dir == 1)then
			side = "z"
			diffSide = -offset
		end
		if(dir == 2)then
			side = "z"
			diffSide = offset
		end
	end
	if(center == 4)then
		if(dir == 5)then
			side = "y"
			diffSide = -offset
		end
		if(dir == 6)then
			side = "y"
			diffSide = offset
		end
		if(dir == 1)then
			side = "z"
			diffSide = offset
		end
		if(dir == 2)then
			side = "z"
			diffSide = -offset
		end
	end
	if(center == 5)then
		if(dir == 1)then
			side = "z"
			diffSide = -offset
		end
		if(dir == 2)then
			side = "z"
			diffSide = offset
		end
		if(dir == 3)then
			side = "x"
			diffSide = -offset
		end
		if(dir == 4)then
			side = "x"
			diffSide = offset
		end
	end
	if(center == 6)then
		if(dir == 1)then
			side = "z"
			diffSide = offset
		end
		if(dir == 2)then
			side = "z"
			diffSide = -offset
		end
		if(dir == 3)then
			side = "x"
			diffSide = offset
		end
		if(dir == 4)then
			side = "x"
			diffSide = -offset
		end
	end
	local length = getElementLength(selectedElement, side)
	objects = math.ceil(length*radius)
	guiSetText(gui.objects_field, tostring(objects))
	outputDebugString("AMT: autocount objects set automaticly to: "..tostring(objects))
	previewUpdate()
end

function getElementLength(element, side)
	side = string.lower(tostring(side))
	local length = 0
	local minX, minY, minZ, maxX, maxY, maxZ = getElementBoundingBox(element)
	minX, minY, minZ, maxX, maxY, maxZ = math.abs(minX), math.abs(minY), math.abs(minZ), math.abs(maxX), math.abs(maxY), math.abs(maxZ)
	--local x, y, z = (maxX + minX)/2, (maxY + minY)/2, (maxZ + minZ)/2
	if(side == "x")then
		length = PI/maxX
	end
	if(side == "y")then
		length = PI/maxY
	end
	if(side == "z")then
		length = PI/maxZ
	end
	outputDebugString("AMT: automatic element length = "..length..".")
	return length
end

function editFieldHandle()
	-- source is the gui element
	if(source == gui.objects_auto_box)then
		local selected = guiCheckBoxGetSelected(gui.objects_auto_box)
		guiSetEnabled(gui.objects_field, (not selected))
	end
end

-- Start generating loop/wallride etc...
function startGenerating()
	if(generate)then
		if(selectedElement == nil)then
			outputChatBox("[AMT ERROR]: No element has been selected!", 255, 25, 25)
			return false
		end
		local loops = tonumber(guiGetText(gui.loops_field))
		local radius = tonumber(guiGetText(gui.radius_field))
		local objects = tonumber(guiGetText(gui.objects_field))
		local times = tonumber(guiGetText(gui.objects_times_field))
		local offset = tonumber(guiGetText(gui.offset_field))
		if not loops or not radius or not objects or not offset or not times then
			outputChatBox("[AMT ERROR]: error in number value in edit fields!", 255, 25, 25)
			return false
		end
		if(radius < MIN_RADIUS)then
			outputChatBox("[AMT ERROR]: Radius is less than minimal allowed radius ("..MIN_RADIUS..")", 255, 25, 25)
			return false
		end
		if(times <= 0)then
			outputChatBox("[AMT ERROR]: objects multiplied times can not be less or equal to 0", 255, 25, 25)
			return false
		end
		objects = math.floor(objects*times)
		if(loops <= 0 or objects <= 0)then
			outputChatBox("[AMT ERROR]: loops and/or objects cant be less or equal to 0", 255, 25, 25)
			return false
		end
		
		guiSetText(gui.conrot_rotX_field, "0")
		guiSetText(gui.conrot_rotY_field, "0")
		guiSetText(gui.conrot_rotZ_field, "0")
		outputDebugString("AMT: Generating...")
		local rotX, rotY, rotZ = getElementRotation(selectedElement)
		local addX, addY, addZ = 0, 0, 0
		local conX, conY, conZ = 0, 0, 0
		triggerServerEvent("onRequestGenerate", getLocalPlayer(), selectedElement, rotX, rotY, rotZ, loops, radius, objects, offset, img[selectedElement].selectedCenter, img[selectedElement].selectedDir, addX, addY, addZ, conX, conY, conZ)
		guiSetText(gui.gen_button, gui.gen_title_save)
		generate = false
	else
		outputDebugString("AMT: saving...")
		local tData = {}
		for i = 1, #hElements do
			triggerServerEvent("onRequestUpdateElementPosition", hElements[i].element, getElementPosition(hElements[i].element))
			triggerServerEvent("onRequestUpdateElementRotation", hElements[i].element, getElementRotation(hElements[i].element))
			exports.editor_main:dropElement(false)
		end
		triggerServerEvent("onRequestUpdateElementRotation", hElements[1].source, getElementRotation(hElements[1].source))
		-- Send data to use and recreate all the objects.
		--triggerServerEvent("onRequestRecreateElements", getLocalPlayer(), tData)
		tData = {}
		hElements = {}
		guiSetText(gui.gen_button, gui.gen_title_generate)
		generate = true
		
		guiSetText(gui.conrot_rotX_field, "0")
		guiSetText(gui.conrot_rotY_field, "0")
		guiSetText(gui.conrot_rotZ_field, "0")
	end
end

-- Recieve new elements from server to handle
addEvent("sendBackRequestedElements", true)
addEventHandler("sendBackRequestedElements", getRootElement(),
function(elements)
	outputDebugString("AMT: client handle elements changed.")
	hElements = elements
	oldX, oldY, oldZ = getElementPosition(elements[1].source)
	local index = #elementList + 1
	elementList[index] = {}
	for i = 1, #hElements do
		local element = hElements[i]
		local index2 = #elementList[index]+1
		elementList[index][index2] = element.element
		local posX, posY, posZ = getTransformedElementPosition(element.source, element.posX, element.posY, element.posZ)
		local rotX, rotY, rotZ = element.rotX, element.rotY, element.rotZ
		triggerServerEvent("onRequestUpdateElementRotation", element.element, rotX, rotY, rotZ)
		triggerServerEvent("onRequestUpdateElementPosition", element.element, posX, posY, posZ)
	end
	exports.editor_main:selectElement(hElements[1].source)
	for i = 1, #previewElements do
		if(isElement(previewElements[i]))then
			detachElements(previewElements[i])
			if(exports.editor_main:getSelectedElement() == previewElements[i])then
				exports.editor_main:destroySelectedElement()
			else
				destroyElement(previewElements[i])
			end
		end
	end
end)

-- Handle generation rotation and position change when rotating element
addEventHandler("onClientRender", getRootElement(),
function()
	if #hElements == 0 or generate then return end
	local nx, ny, nz = getElementPosition(hElements[1].source)
	local rotate = {}
	rotate.slow = "lalt"
	rotate.fast = "lshift"
	rotate.key = "lctrl"
	rotate.left = "arrow_l"
	rotate.right = "arrow_r"
	rotate.forward = "arrow_u"
	rotate.backward = "arrow_d"
	rotate.upwards = "pgup"
	rotate.downwards = "pgdn"
	local doRotate = false
	local move = getKeyState("x")
	if(getKeyState(rotate.key) and exports.editor_main:getSelectedElement() == hElements[1].source)then
		doRotate = true
		exports.move_keyboard:disable()
		rotationDisabled = true
	elseif(rotationDisabled)then
		exports.move_keyboard:enable()
		rotationDisabled = false
	end
	local rotSlow, rotMedium, rotFast = exports.move_keyboard:getRotateSpeeds()
	local speed = rotMedium
	if(getKeyState(rotate.slow))then
		speed = rotSlow
	end
	if(getKeyState(rotate.fast))then
		speed = rotFast
	end
	-- only check key state once, because it may change under the loop (wont rotate for all object)
	local left, right, forward, backward, upwards, downwards = false, false, false, false, false, false
	local rotX, rotY, rotZ = getElementRotation(hElements[1].source)
	if(doRotate)then
		if(getKeyState(rotate.right))then
			right = true
			rotX, rotY, rotZ = rotateZ(rotX, rotY, rotZ, speed)
		end
		if(getKeyState(rotate.left))then
			left = true
			rotX, rotY, rotZ = rotateZ(rotX, rotY, rotZ, -speed)
		end
		
		if(getKeyState(rotate.forward))then
			forward = true
			rotX, rotY, rotZ = rotateY(rotX, rotY, rotZ, speed)
		end
		if(getKeyState(rotate.backward))then
			backward = true
			rotX, rotY, rotZ = rotateY(rotX, rotY, rotZ, -speed)
		end
			
		if(getKeyState(rotate.upwards))then
			upwards = true
			rotX, rotY, rotZ = rotateX(rotX, rotY, rotZ, speed)
		end
		if(getKeyState(rotate.downwards))then
			downwards = true
			rotX, rotY, rotZ = rotateX(rotX, rotY, rotZ, -speed)
		end
		setElementRotation(hElements[1].source, rotX, rotY, rotZ)
	end
	
	for i = 1, #hElements do
		local rotX, rotY, rotZ = getElementRotation(hElements[i].element)
		local diffX, diffY, diffZ = rotX - hElements[1].sourceX, rotY - hElements[1].sourceY, rotZ - hElements[1].sourceZ
		local posX, posY, posZ = getTransformedPosition(nx, ny, nz, hElements[1].sourceX, hElements[1].sourceY, hElements[1].sourceZ, hElements[i].posX, hElements[i].posY, hElements[i].posZ)
		--posX, posY, posZ = getTransformedElementPosition(hElements[i].source, hElements[i].posX, hElements[i].posY, hElements[i].posZ)
		setElementPosition(hElements[i].element, posX, posY, posZ)
		if(doRotate)then
			if(right)then
				rotX, rotY, rotZ = rotateZ(rotX, rotY, rotZ, speed)
				hElements[i].rotX, hElements[i].rotY, hElements[i].rotZ = rotateZ(hElements[i].rotX, hElements[i].rotY, hElements[i].rotZ, speed)
			end
			if(left)then
				rotX, rotY, rotZ = rotateZ(rotX, rotY, rotZ, -speed)
				hElements[i].rotX, hElements[i].rotY, hElements[i].rotZ = rotateZ(hElements[i].rotX, hElements[i].rotY, hElements[i].rotZ, -speed)
			end
		
			if(forward)then
				rotX, rotY, rotZ = rotateY(rotX, rotY, rotZ, speed)
				hElements[i].rotX, hElements[i].rotY, hElements[i].rotZ = rotateY(hElements[i].rotX, hElements[i].rotY, hElements[i].rotZ, speed)
			end
			if(backward)then
				rotX, rotY, rotZ = rotateY(rotX, rotY, rotZ, -speed)
				hElements[i].rotX, hElements[i].rotY, hElements[i].rotZ = rotateY(hElements[i].rotX, hElements[i].rotY, hElements[i].rotZ, -speed)
			end
			
			if(upwards)then
				rotX, rotY, rotZ = rotateX(rotX, rotY, rotZ, speed)
				hElements[i].rotX, hElements[i].rotY, hElements[i].rotZ = rotateX(hElements[i].rotX, hElements[i].rotY, hElements[i].rotZ, speed)
			end
			if(downwards)then
				rotX, rotY, rotZ = rotateX(rotX, rotY, rotZ, -speed)
				hElements[i].rotX, hElements[i].rotY, hElements[i].rotZ = rotateX(hElements[i].rotX, hElements[i].rotY, hElements[i].rotZ, -speed)
			end
			setElementRotation(hElements[i].element, rotX, rotY, rotZ)
		end
	end
end)


-- remove save option if element that was removed is the parent element for the generation
addEvent("onClientElementDestroyed", true)
addEventHandler("onClientElementDestroyed", getRootElement(),
function()
	if(source == selectedElement)then
		selectedElement = nil
	end
end)

addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()), 
function()
	if(hElements[1] ~= nil)then
		triggerServerEvent("requestDestroyElements", getLocalPlayer(), hElements)
	end
end)

function getTransformedElementPosition(element, dx, dy, dz)
	local m = getElementMatrix(element)
	if not m then return false end
	local offX = dx * m[1][1] + dy * m[2][1] + dz * m[3][1] + 1 * m[4][1]
	local offY = dx * m[1][2] + dy * m[2][2] + dz * m[3][2] + 1 * m[4][2]
	local offZ = dx * m[1][3] + dy * m[2][3] + dz * m[3][3] + 1 * m[4][3]
	return offX, offY, offZ
end

function getTransformedPosition(posX, posY, posZ, rotX, rotY, rotZ, dx, dy, dz)
	local m = getMatrix(posX, posY, posZ, rotX, rotY, rotZ)
	if not m then return false end
	local offX = dx * m[1][1] + dy * m[2][1] + dz * m[3][1] + 1 * m[4][1]
	local offY = dx * m[1][2] + dy * m[2][2] + dz * m[3][2] + 1 * m[4][2]
	local offZ = dx * m[1][3] + dy * m[2][3] + dz * m[3][3] + 1 * m[4][3]
	return offX, offY, offZ
end

function getTransformedRotation(element)
	local matrix = getElementMatrix(element)
	if not matrix then return false end
	local rotX = math.deg(math.asin(matrix[2][3]))
	local rotY = math.deg(math.atan2(-matrix[1][3], matrix[3][3]))
	local rotZ = math.deg(math.atan2(-matrix[2][1], matrix[2][2]))
	return rotX, rotY, rotZ
end

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

function getElementMatrix(element)
	local rx, ry, rz = getElementRotation(element)
	rx = math.rad(rx)
	ry = math.rad(ry)
	rz = math.rad(rz)
	local matrix = {}
	matrix[1] = {}
	matrix[1][1] = math.cos(rz)*math.cos(ry) - math.sin(rz)*math.sin(rx)*math.sin(ry)
	matrix[1][2] = math.cos(ry)*math.sin(rz) + math.cos(rz)*math.sin(rx)*math.sin(ry)
	matrix[1][3] = -math.cos(rx)*math.sin(ry)
	
	matrix[2] = {}
	matrix[2][1] = -math.cos(rx)*math.sin(rz)
	matrix[2][2] = math.cos(rz)*math.cos(rx)
	matrix[2][3] = math.sin(rx)
	
	matrix[3] = {}
	matrix[3][1] = math.cos(rz)*math.sin(ry) + math.cos(ry)*math.sin(rz)*math.sin(rx)
	matrix[3][2] = math.sin(rz)*math.sin(ry) - math.cos(rz)*math.cos(ry)*math.sin(rx)
	matrix[3][3] = math.cos(rx)*math.cos(ry)
	
	matrix[4] = {}
	matrix[4][1], matrix[4][2], matrix[4][3] = getElementPosition(element)
	
	return matrix
end

function getMatrix(posX, posY, posZ, rotX, rotY, rotZ)
	local rx, ry, rz = rotX, rotY, rotZ
	rx = math.rad(rx)
	ry = math.rad(ry)
	rz = math.rad(rz)
	local matrix = {}
	matrix[1] = {}
	matrix[1][1] = math.cos(rz)*math.cos(ry) - math.sin(rz)*math.sin(rx)*math.sin(ry)
	matrix[1][2] = math.cos(ry)*math.sin(rz) + math.cos(rz)*math.sin(rx)*math.sin(ry)
	matrix[1][3] = -math.cos(rx)*math.sin(ry)
	
	matrix[2] = {}
	matrix[2][1] = -math.cos(rx)*math.sin(rz)
	matrix[2][2] = math.cos(rz)*math.cos(rx)
	matrix[2][3] = math.sin(rx)
	
	matrix[3] = {}
	matrix[3][1] = math.cos(rz)*math.sin(ry) + math.cos(ry)*math.sin(rz)*math.sin(rx)
	matrix[3][2] = math.sin(rz)*math.sin(ry) - math.cos(rz)*math.cos(ry)*math.sin(rx)
	matrix[3][3] = math.cos(rx)*math.cos(ry)
	
	matrix[4] = {}
	matrix[4][1], matrix[4][2], matrix[4][3] = posX, posY, posZ
	
	return matrix
end

function alterGeneration(element)
	local conrx, conry, conrz = 0, 0, 0
	conrx = tonumber(guiGetText(gui.conrot_rotX_field))
	conry = tonumber(guiGetText(gui.conrot_rotY_field))
	conrz = tonumber(guiGetText(gui.conrot_rotZ_field))
	if not conrx or not conry or not conrz or not hElements or #hElements == 0 then return end
	conrx = conrx/#hElements
	conry = conry/#hElements
	conrz = conrz/#hElements
	
	for i = 1, #hElements do
		local rotX, rotY, rotZ = hElements[i].rotX, hElements[i].rotY, hElements[i].rotZ
		rotX, rotY, rotZ = rotateZ(rotX, rotY, rotZ, conrz*i)
		rotX, rotY, rotZ = rotateY(rotX, rotY, rotZ, conry*i)
		rotX, rotY, rotZ = rotateX(rotX, rotY, rotZ, conrx*i)
		setElementRotation(hElements[i].element, rotX, rotY, rotZ)
	end
end

--[[
function rotateRespectively(rotX, rotY, rotZ, edit)
	if(edit == gui.additional_rotX_field)then
		rotX, rotY, rotZ = rotateZ(rotX, rotY, rotZ, rz)
		rotX, rotY, rotZ = rotateY(rotX, rotY, rotZ, ry)
		rotX, rotY, rotZ = rotateX(rotX, rotY, rotZ, rx)
	end
end
--]]

function cos(deg)
	return math.cos(math.rad(deg))
end

function sin(deg)
	return math.sin(math.rad(deg))
end

function atan2(offX, offY)
	return math.deg(math.atan2(offX, offY))
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

addCommandHandler("des",
function()
	local index = #elementList
	if(index == 0)then
		outputChatBox("#FF2525[AMT ERROR]: #FFFFFFNothing to undo.", 255, 25, 25, true)
		return false
	end
	if not generate then
		guiSetText(gui.gen_button, gui.gen_title_generate)
		generate = true
		hElements = {}
	end
	for i = 1, #elementList[index] do
		if(elementList[index][i] == selectedElement)then
			selectedElement = nil
			break
		end
	end
	triggerServerEvent("requestDestroyElements", getLocalPlayer(), elementList[index])
	table.remove(elementList, index)
end)

addEvent("sendBackDuplicatedElements", true)
addEventHandler("sendBackDuplicatedElements", getRootElement(),
function(elements)
	outputDebugString("Saving duplicated files to element list")
	local index = #elementList+1
	elementList[index] = {}
	for i = 1, #elements do
		elementList[index][#elementList[index]+1] = elements[i]
	end
end)

function previewUpdate()
	if not generate or currentWindow ~= 1 then return end
	local radius = tonumber(guiGetText(gui.radius_field))
	local offset = tonumber(guiGetText(gui.offset_field))
	local objects = tonumber(guiGetText(gui.objects_field))
	local times = tonumber(guiGetText(gui.objects_times_field))
	local loops = tonumber(guiGetText(gui.loops_field))
	local selected = selectedElement
	if not offset or not objects or not radius or not loops or not times or times <= 0 or loops <= 0 or radius <= 0 or objects <= 0 or not selected then return end
	objects = math.floor(objects*times)
	local rot = 360/objects
	local off = 0
	local inter = 0
	local relOff = offset/objects
	local rotX, rotY, rotZ = getElementRotation(selected)
	local posX, posY, posZ = getElementPosition(selected)
	local model = getElementModel(selected)
	local center, dir = img[selected].selectedCenter, img[selected].selectedDir
	
	for i = 1, #previewElements do
		if(isElement(previewElements[i]))then
			detachElements(previewElements[i])
			if(exports.editor_main:getSelectedElement() == previewElements[i])then
				exports.editor_main:destroySelectedElement()
			else
				destroyElement(previewElements[i])
			end
		end
	end
	
	
	for l = 1, math.ceil(loops) do
		for i = 1, objects do
		
			local nrx, nry, nrz = rotX, rotY, rotZ
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
			
			if(inter >= math.ceil(objects*loops))then
				break
			end
			inter = inter + 1
			local px, py, pz = getTransformedElementPosition(selected, nx, ny, nz)
			local index = #previewElements+1
			previewElements[index] = createObject(model, px, py, pz, nrx, nry, nrz)
			setElementDimension(previewElements[index], getElementDimension(getLocalPlayer()))
			setElementAlpha(previewElements[index], 150)
			attachElements(previewElements[index], selected, nx, ny, nz, rx, ry, rz)
		end
	end
end