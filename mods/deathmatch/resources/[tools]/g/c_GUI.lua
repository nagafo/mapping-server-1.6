--Variables
GUI 		= {}
local sX, sY 	= guiGetScreenSize()
local cShow		= 0
local ngtOpen   = true
local setOpen   = false
--0=model, 1=visibility, 2=delete, 3=cover

--Initialize
addEventHandler("onClientResourceStart", resourceRoot, function()
	--Main window
		GUI.main = {}
		GUI.main.window = guiCreateWindow(0, sY/2+(150), 400, 150, "NGT: Main", false)
		
	--Main Buttons 400x150
		GUI.main.buttons = {}
		GUI.main.buttons.action = guiCreateButton(150, 120, 100, 20, "Action", false, GUI.main.window)
		GUI.main.buttons.undo = guiCreateButton(290, 120, 100, 20, "Undo", false, GUI.main.window)
		GUI.main.buttons.settings = guiCreateButton(0, 120, 100, 20, "Settings", false, GUI.main.window)
		GUI.main.buttons.next = guiCreateButton(290, 20, 100, 20, "Next", false, GUI.main.window)
		GUI.main.buttons.prev = guiCreateButton(0, 20, 100, 20, "Previous", false, GUI.main.window)
		GUI.main.buttons.UA = guiCreateButton(290, 90, 100, 20, "Unselect all", false, GUI.main.window)
		--Switch
		addEventHandler("onClientGUIClick", GUI.main.buttons.next, showNextPrevGUI, false)
		addEventHandler("onClientGUIClick", GUI.main.buttons.prev, showNextPrevGUI, false)
		--Actions
		addEventHandler("onClientGUIClick", GUI.main.buttons.undo, undoLastNGT, false)
		addEventHandler("onClientGUIClick", GUI.main.buttons.UA, unselectall, false)
		addEventHandler("onClientGUIClick", GUI.main.buttons.settings, showHideSettings, false)
		addEventHandler("onClientGUIClick", GUI.main.buttons.action, doAction, false)
	--Main labels
		GUI.main.labels = {}
		GUI.main.labels.current = guiCreateLabel(140, 20, 160, 60, "Action: Change Model", false, GUI.main.window)
		
	--Change model(DEFAULT FIRST)
		--Edit fields
		GUI.model = {}
		GUI.model.edits = {}
		GUI.model.edits.id = guiCreateEdit(140, 40, 120, 20, "Model", false, GUI.main.window)
		guiEditSetMaxLength(GUI.model.edits.id, 5)
		
	--Visibility(2nd)
		--Checkbox
		GUI.vis = {}
		GUI.vis.check = {}
		GUI.vis.check.hide = guiCreateCheckBox(140, 40, 120, 20, "Visible?", true, false, GUI.main.window)
		hide(1)
	--Delete
		--Label
		GUI.del = {}
		GUI.del.label = {}
		GUI.del.label.click = guiCreateLabel(100, 40, 380, 60, "Click 'action' to remove selected objects", false, GUI.main.window)
		hide(2)
	--Cover, YAY
		GUI.cover = {}
		GUI.cover.check = {}
		GUI.cover.check.front = guiCreateCheckBox(20, 40, 120, 20, "Front?", true, false, GUI.main.window)
		GUI.cover.check.back = guiCreateCheckBox(20, 60, 120, 20, "Back?", true, false, GUI.main.window)
		GUI.cover.check.bot = guiCreateCheckBox(20, 80, 120, 20, "Bottom?", true, false, GUI.main.window)
		GUI.cover.check.left = guiCreateCheckBox(90, 40, 120, 20, "Left?", true, false, GUI.main.window)
		GUI.cover.check.right = guiCreateCheckBox(90, 60, 120, 20, "Right?", true, false, GUI.main.window)
		hide(3)
		
	--Settings windoe
	GUI.settings = {}
	GUI.settings.window = guiCreateWindow(0, sY/2+50, 200, 100, "NGT: Settings", false)
	GUI.settings.desselect = guiCreateCheckBox(10, 20, 200, 20, "Auto-unselect?", false, false, GUI.settings.window)--desban pls
	GUI.settings.move = guiCreateCheckBox(10, 40, 200, 20, "Move selected objects?", false, false, GUI.settings.window)
	guiSetVisible(GUI.settings.window, false)
	addEventHandler("onClientGUIClick", GUI.settings.desselect, clickSetting, false)
	addEventHandler("onClientGUIClick", GUI.settings.move, clickSetting, false)
	
	loadXML()
	if moveSelected then guiCheckBoxSetSelected(GUI.settings.move, true) end
	if autoUnselect then guiCheckBoxSetSelected(GUI.settings.desselect, true) end
end)

function clickSetting()--Stupid way, but im too lazy to rewrite this shit now
	autoUnselect = guiCheckBoxGetSelected(GUI.settings.desselect)
	moveSelected = guiCheckBoxGetSelected(GUI.settings.move)
	saveXML()
end

function showNextPrevGUI()
	if source==GUI.main.buttons.next then
		hide(cShow)
		cShow = cShow + 1
		if cShow > 3 then cShow = 0 end
		show(cShow)
	elseif source==GUI.main.buttons.prev then
		hide(cShow)
		cShow = cShow - 1
		if cShow < 0 then cShow = 3 end
		show(cShow)
	end
end

function hide(id)
	if id==0 then
		for i,tbl in pairs(GUI.model) do 
			for i, gui in pairs(tbl) do 
				guiSetVisible(gui, false)
			end
		end
	elseif id==1 then
		for i,tbl in pairs(GUI.vis) do 
			for i, gui in pairs(tbl) do 
				guiSetVisible(gui, false)
			end
		end
	elseif id==2 then
		for i,tbl in pairs(GUI.del) do 
			for i, gui in pairs(tbl) do 
				guiSetVisible(gui, false)
			end
		end
	elseif id==3 then
		for i,tbl in pairs(GUI.cover) do 
			for i, gui in pairs(tbl) do 
				guiSetVisible(gui, false)
			end
		end
	end
end

function show(id)
	if id==0 then
		for i,tbl in pairs(GUI.model) do 
			for i, gui in pairs(tbl) do 
				guiSetVisible(gui, true)
			end
		end
		guiSetText(GUI.main.labels.current, "Action: Change Model")
	elseif id==1 then
		for i,tbl in pairs(GUI.vis) do 
			for i, gui in pairs(tbl) do 
				guiSetVisible(gui, true)
			end
		end
		guiSetText(GUI.main.labels.current, "Action: Visibility")
	elseif id==2 then
		for i,tbl in pairs(GUI.del) do 
			for i, gui in pairs(tbl) do 
				guiSetVisible(gui, true)
			end
		end
		guiSetText(GUI.main.labels.current, "Action: Delete")
	elseif id==3 then
		for i,tbl in pairs(GUI.cover) do 
			for i, gui in pairs(tbl) do 
				guiSetVisible(gui, true)
			end
		end
		guiSetText(GUI.main.labels.current, "Action: Cover")
	end
end

function showHideSettings()
	setOpen   = not setOpen
	guiSetVisible(GUI.settings.window, setOpen)
end

function doAction()
	if guiGetVisible(GUI.model.edits.id) then--Model open
		changeobjects(_, guiGetText(GUI.model.edits.id))
	elseif guiGetVisible(GUI.vis.check.hide) then--Visible open
		changevisibility(_, guiCheckBoxGetSelected(GUI.vis.check.hide))
	elseif guiGetVisible(GUI.del.label.click) then--delete open
		deleteElements()
	elseif guiGetVisible(GUI.cover.check.front) then--Cover open
		addCovering()
	end
end

function openNGTGUI()
	ngtOpen = not ngtOpen
	guiSetVisible(GUI.main.window, ngtOpen)
	if not ngtOpen then
		guiSetVisible(GUI.settings.window, false)
	else
		guiSetVisible(GUI.settings.window, setOpen)
	end
end
addCommandHandler("openNGT",openNGTGUI)
bindKey("F10","down","openNGT")

function saveXML()
	local xml = xmlLoadFile("playerSettings3.xml")
	if xml then
		if not autoUnselect then
			xmlNodeSetValue(xmlFindChild(xml, "unselect",0), "0")
		else
			xmlNodeSetValue(xmlFindChild(xml, "unselect",0), "1")
		end
		if not moveSelected then
			xmlNodeSetValue(xmlFindChild(xml, "automove",0), "0")
		else
			xmlNodeSetValue(xmlFindChild(xml, "automove",0), "1")
		end
		xmlSaveFile(xml)
		xmlUnloadFile(xml)
	else
		createXML(1)
	end
end

function loadXML()
	local xml = xmlLoadFile("playerSettings3.xml")
	if xml then
		local sel = xmlNodeGetValue(xmlFindChild(xml, "unselect",0))
		local move = xmlNodeGetValue(xmlFindChild(xml, "automove",0))
		if move=="0" then
			moveSelected = false
		else
			moveSelected = true
		end
		if sel=="0" then
			autoUnselect = false
		else
			autoUnselect = true
		end
		xmlUnloadFile(xml)
	else
		createXML(2)
	end
end

function createXML(caller)
	local xml = xmlCreateFile("playerSettings3.xml", "options")
	xmlNodeSetValue(xmlCreateChild(xml, "unselect"), "0")
	xmlNodeSetValue(xmlCreateChild(xml, "automove"), "0")
	xmlSaveFile(xml)
	xmlUnloadFile(xml)
	if caller==2 then loadXML() else saveXML() end
end

addEventHandler("onClientResourceStop", resourceRoot, saveXML)