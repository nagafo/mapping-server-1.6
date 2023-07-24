-- Includes

-- Variables
local settingsArray = getSettings()
local screenW,screenH = guiGetScreenSize()
local wdwW = 200 local wdwH = 100
local sW = 200 local sH = 380
-- * Creating the UI * --
local ui_wdw = guiCreateWindow (screenW-wdwW-sW , screenH/2-sH/2, sW, sH, "MRT - Settings", false)
guiWindowSetMovable (ui_wdw, false)
guiWindowSetSizable (ui_wdw, false)
local ui_btn_save = guiCreateButton ( 10,sH-60, 180, 20, "Save", false, ui_wdw)
local ui_btn_close = guiCreateButton ( 10,sH-30, 180, 20, "Close", false, ui_wdw)
guiCreateLabel ( 10, 20, 180, 20, "Line color (when in air)", false, ui_wdw)
local ui_edit_color2_r = guiCreateEdit ( 10, 40, 40, 20, settingsArray[2], false, ui_wdw) 
local ui_edit_color2_g = guiCreateEdit ( 55, 40, 40, 20, settingsArray[3], false, ui_wdw) 
local ui_edit_color2_b = guiCreateEdit ( 100, 40, 40, 20, settingsArray[4], false, ui_wdw) 
local ui_edit_color2_a = guiCreateEdit ( 145, 40, 40, 20, settingsArray[5], false, ui_wdw) 
guiSetFont ( ui_edit_color2_r, "default-small" )
guiSetFont ( ui_edit_color2_g, "default-small" )
guiSetFont ( ui_edit_color2_b, "default-small" )
guiSetFont ( ui_edit_color2_a, "default-small" )
local val1 = settingsArray[1]
if(val1 == "true")then val1 = true else val1 = false end
local ui_checkbox_line2_single = guiCreateCheckBox ( 10, 70, 180, 20, "striped", val1, false, ui_wdw)
guiCreateLabel ( 10, 100, 180, 20, "Line color (when on ground)", false, ui_wdw)
local ui_edit_color1_r = guiCreateEdit ( 10, 120, 40, 20, settingsArray[7], false, ui_wdw) 
local ui_edit_color1_g = guiCreateEdit ( 55, 120, 40, 20, settingsArray[8], false, ui_wdw) 
local ui_edit_color1_b = guiCreateEdit ( 100, 120, 40, 20, settingsArray[9], false, ui_wdw) 
local ui_edit_color1_a = guiCreateEdit ( 145, 120, 40, 20, settingsArray[10], false, ui_wdw)
guiSetFont ( ui_edit_color1_r, "default-small" )
guiSetFont ( ui_edit_color1_g, "default-small" )
guiSetFont ( ui_edit_color1_b, "default-small" )
guiSetFont ( ui_edit_color1_a, "default-small" ) 
local val2 = settingsArray[6]
if(val2 == "true")then val2 = true else val2 = false end
local ui_checkbox_line1_single = guiCreateCheckBox ( 10, 150, 180, 20, "striped", val2, false, ui_wdw)
guiCreateLabel ( 10, 180, 80, 20, "Update delay", false, ui_wdw)
local ui_edit_delay = guiCreateEdit ( 90, 180, 85, 20, settingsArray[12], false, ui_wdw) 
guiSetFont (ui_edit_delay, "default-small" ) 
guiCreateLabel ( 10, 210, 80, 20, "Line length", false, ui_wdw)
local ui_edit_length = guiCreateEdit ( 90, 210, 85, 20, settingsArray[13], false, ui_wdw) 
guiSetFont (ui_edit_length, "default-small" ) 
guiCreateLabel (10, 240, 70, 20, "Record key", false, ui_wdw)

local ui_btn_record_key = guiCreateButton ( 90, 243, 85, 15, settingsArray[11], false, ui_wdw)
guiSetFont ( ui_btn_record_key, "default-small" )

guiCreateLabel (10, 260, 70, 20, "Test key", false, ui_wdw)

local ui_btn_test_key = guiCreateButton ( 90, 263, 85, 15, settingsArray[14], false, ui_wdw)
guiSetFont ( ui_btn_test_key, "default-small" )

local val3 = settingsArray[15]
if(val3 == "true")then val3 = true else val3 = false end
local ui_checkbox_points = guiCreateCheckBox ( 90, 283, 180, 20, "Vehicle points", val3, false, ui_wdw)
guiSetFont ( ui_checkbox_points, "default-small" )

guiSetVisible(ui_wdw, false)

local function resetValues()
	local sets = getSettings()
	if(sets[1] == "true")then sets[1] = true else sets[1] = false end
	guiCheckBoxSetSelected ( ui_checkbox_line1_single, sets[1])
	if(sets[6] == "true")then sets[6] = true else sets[6] = false end
	guiCheckBoxSetSelected ( ui_checkbox_line2_single, sets[6])
	if(sets[15] == "true")then sets[15] = true else sets[15] = false end
	guiCheckBoxSetSelected ( ui_checkbox_points, sets[15])
	
	guiSetText ( ui_edit_color1_r, sets[2] )
	guiSetText ( ui_edit_color1_g, sets[3] )
	guiSetText ( ui_edit_color1_b, sets[4] )
	guiSetText ( ui_edit_color1_a, sets[5] )
	
	guiSetText ( ui_edit_color2_r, sets[7] )
	guiSetText ( ui_edit_color2_g, sets[8] )
	guiSetText ( ui_edit_color2_b, sets[9] )
	guiSetText ( ui_edit_color2_a, sets[10] )
	
	guiSetText ( ui_btn_record_key, sets[11] )
	
	guiSetText ( ui_edit_delay, sets[12] )
	guiSetText ( ui_edit_length, sets[13] )
	
	guiSetText ( ui_btn_test_key, sets[14] )
end

function toggleSettingsWindow()
	resetValues()
	guiSetVisible(ui_wdw, true)
end

-- Record key edit
local allowed = "abcdefghijklmnopqrsuvwxz123456789"
function checkButton(st,w)
	if(w==ui_btn_record_key and st==guiGetText(ui_btn_test_key)) then return false end
	if(w==ui_btn_test_key and st==guiGetText(ui_btn_record_key)) then return false end
	local res = false
	local len = string.len(allowed)
	for i=1,len do 
		if(st == string.sub(allowed, i, i)) then res = true end
	end
	return res
end

local waitingForKey = false
local waiter
addEventHandler("onClientKey", getRootElement(), 
function(btn,press)
	if(press and waitingForKey and checkButton(btn,waiter))then
		guiSetText(waiter, btn)
		waitingForKey = false
		guiSetEnabled(ui_btn_save, true)
		guiSetEnabled(ui_btn_close, true)
		guiSetEnabled(ui_btn_record_key, true)
		guiSetEnabled(ui_btn_test_key, true)
	end
end)

addEventHandler ( "onClientGUIClick", getRootElement(), 
function()
	if(source == ui_btn_save)then
		guiSetVisible(ui_wdw, false)
		local newsets = {}
		newsets[1] = tostring(guiCheckBoxGetSelected ( ui_checkbox_line1_single) )
		
		newsets[2] = tostring(guiGetText ( ui_edit_color1_r))
		newsets[3] = tostring(guiGetText ( ui_edit_color1_g))
		newsets[4] = tostring(guiGetText ( ui_edit_color1_b))
		newsets[5] = tostring(guiGetText ( ui_edit_color1_a))
		
		newsets[6] = tostring(guiCheckBoxGetSelected ( ui_checkbox_line2_single) )
		
		newsets[7] = tostring(guiGetText ( ui_edit_color2_r))
		newsets[8] = tostring(guiGetText ( ui_edit_color2_g))
		newsets[9] = tostring(guiGetText ( ui_edit_color2_b))
		newsets[10] = tostring(guiGetText ( ui_edit_color2_a))
		
		newsets[11] = tostring(guiGetText ( ui_btn_record_key))
		newsets[12] = tostring(guiGetText ( ui_edit_delay))
		newsets[13] = tostring(guiGetText ( ui_edit_length))
		
		if(newsets[12] and newsets[12] ~= "")then if(tonumber(newsets[12])<50)then newsets[12] = "100" end else newsets[12] = "100" end
		if(newsets[13] and newsets[13] ~= "")then if(tonumber(newsets[13])<0.5)then newsets[13] = "2" end else newsets[13] = "2" end
		
		newsets[14] = tostring(guiGetText ( ui_btn_test_key))
		
		newsets[15] = tostring(guiCheckBoxGetSelected (ui_checkbox_points) )
		saveSettings(newsets)
		triggerEvent ( "onSettingsChanged", getLocalPlayer(), newsets)
	elseif(source == ui_btn_close)then
		guiSetVisible(ui_wdw, false)
	elseif(source == ui_btn_record_key)then
		if(not waitingForKey)then
			waitingForKey = true
			guiSetText(ui_btn_record_key, "Press any key...")
			guiSetEnabled(ui_btn_record_key, false)
			guiSetEnabled(ui_btn_test_key, false)
			guiSetEnabled(ui_btn_save, false)
			guiSetEnabled(ui_btn_close, false)
			waiter = ui_btn_record_key
		end
	elseif(source == ui_btn_test_key)then
		if(not waitingForKey)then
			waitingForKey = true
			guiSetText(ui_btn_test_key, "Press any key...")
			guiSetEnabled(ui_btn_record_key, false)
			guiSetEnabled(ui_btn_test_key, false)
			guiSetEnabled(ui_btn_save, false)
			guiSetEnabled(ui_btn_close, false)
			waiter = ui_btn_test_key
		end
	end
end)

addEventHandler("onClientGUIChanged", getRootElement(), function() 
	if  source == ui_edit_color1_r or
		source == ui_edit_color1_g or
		source == ui_edit_color1_b or
		source == ui_edit_color1_a or
		source == ui_edit_color2_r or
		source == ui_edit_color2_g or
		source == ui_edit_color2_b or
		source == ui_edit_color2_a then
		local newv = tonumber(guiGetText(source))
		if(newv)then
			if(newv<0)then newv = 0 
			elseif(newv>255)then newv = 255 end
		else newv = 0 end
		guiSetText(source, tostring(newv))
	end
	if source == ui_edit_length then
		local newv = tonumber(guiGetText(source))
		if(newv)then
			if(newv<0)then newv = 0
			elseif(newv>5)then newv = 5 end
		else newv = "" end
		guiSetText(source, tostring(newv))
	end		
	if source == ui_edit_delay then
		local newv = tonumber(guiGetText(source))
		if(newv)then
			if(newv<0)then newv = 0
			elseif(newv>1000)then newv = 1000 end
		else newv = "" end
		guiSetText(source, tostring(newv))	
	end
end)