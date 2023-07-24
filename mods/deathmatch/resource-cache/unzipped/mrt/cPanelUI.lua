local screenW,screenH = guiGetScreenSize()
wdwW = 200 wdwH = 130


local settingsArray = getSettings()
local recordKey = string.upper(settingsArray[11])

-- * Creating the UI * --
local ui_wdw = guiCreateWindow (screenW-wdwW , screenH/2-wdwH/2, wdwW, wdwH, "Movement Recording Tool v2", false)
local ui_btn_clean = guiCreateButton ( 10,40, 180, 20, "Clean", false, ui_wdw)
local ui_info_label = guiCreateLabel ( 10, 20, 180, 25, "Press '"..recordKey.."' to start recording.", false, ui_wdw)
local ui_status_label = guiCreateLabel ( 10, 65, 180, 25, "State: -", false, ui_wdw)
local ui_btn_settings = guiCreateButton ( 10,90, 90, 20, "Settings", false, ui_wdw)
local ui_btn_help = guiCreateButton ( 100,90, 90, 20, "Help", false, ui_wdw)
guiWindowSetMovable (ui_wdw, false)
guiWindowSetSizable (ui_wdw, false)
guiSetVisible(ui_wdw, false)

-- * Show UI function * --
function toggleUI()
	if(not getKeyState ("lctrl"))then return end
	local vis = not guiGetVisible(ui_wdw)
	--showCursor ( vis )
	guiSetVisible(ui_wdw, vis)
end
bindKey('m', 'down', toggleUI)

addEventHandler ( "onClientGUIClick", getRootElement(), 
function()
	if(source == ui_btn_clean)then
		triggerEvent ( "onClearClick", getLocalPlayer())
	elseif(source == ui_btn_settings)then
		toggleSettingsWindow()
	elseif(source == ui_btn_help)then
		output("Help is not available in this version")
	end
end)

addEvent("updateStatus",true)
addEventHandler("updateStatus", getRootElement(), 
function(st)
guiSetText (ui_status_label,st)
if(st == "State: Recording")then
	guiSetText (ui_info_label,"Press '"..recordKey.."' to stop recording.")
	guiSetEnabled(ui_btn_settings, false)
else
	guiSetText (ui_info_label,"Press '"..recordKey.."' to start recording.")
	guiSetEnabled(ui_btn_settings, true)
end
end)

addEvent ( "onSettingsChanged", true )
addEventHandler ( "onSettingsChanged", getRootElement(), 
function(newsets)
	recordKey = string.upper(newsets[11])
	guiSetText (ui_info_label,"Press '"..string.upper(recordKey).."' to start recording.")
end)