local xmlFile
local node_delay
local node_length
local node_ground
local node_air
local node_record_key
local node_test_key
local node_points
local configLoaded = false
local values = {}

local function reloadSettings()
	xmlFile = xmlLoadFile ("settings/config.xml" )
	if(not xmlFile)then
		xmlFile = xmlCreateFile("settings/config.xml","config")
		node_delay = xmlCreateChild(xmlFile, "delay")
		xmlNodeSetValue (node_delay, "100" )
		node_length = xmlCreateChild(xmlFile, "length")
		xmlNodeSetValue (node_length, "2"	)
		node_ground = xmlCreateChild ( xmlFile, "ground" )
		xmlNodeSetAttribute ( node_ground, "r", 150 )
		xmlNodeSetAttribute ( node_ground, "g", 150 )
		xmlNodeSetAttribute ( node_ground, "b", 150 )
		xmlNodeSetAttribute ( node_ground, "a", 255 )
		xmlNodeSetValue (node_ground, "false" )
		node_air = xmlCreateChild (xmlFile, "air" )
		xmlNodeSetAttribute ( node_air, "r", 255 )
		xmlNodeSetAttribute ( node_air, "g", 0 )
		xmlNodeSetAttribute ( node_air, "b", 0 )
		xmlNodeSetAttribute ( node_air, "a", 150 )
		xmlNodeSetValue (node_air, "false" )
		node_record_key = xmlCreateChild (xmlFile, "record_key" )
		xmlNodeSetValue (node_record_key, "r" )
		node_test_key = xmlCreateChild (xmlFile, "test_key" )
		xmlNodeSetValue (node_test_key, "v" )
		node_points = xmlCreateChild (xmlFile, "points" )
		xmlNodeSetValue (node_points, "false" )
		configLoaded = true
	else	
		node_delay = xmlFindChild ( xmlFile, "delay", 0)
		node_length = xmlFindChild ( xmlFile, "length", 0)
		node_ground = xmlFindChild ( xmlFile, "ground", 0)
		node_air = xmlFindChild ( xmlFile, "air", 0)
		node_record_key = xmlFindChild ( xmlFile, "record_key", 0)
		node_test_key = xmlFindChild ( xmlFile, "test_key", 0)
		node_points = xmlFindChild ( xmlFile, "points", 0)
		
		if(not node_delay)then
			node_delay = xmlCreateChild(xmlFile, "delay")
			xmlNodeSetValue (node_delay, "100" )
		end
		if(not node_length)then
			node_length = xmlCreateChild(xmlFile, "length")
			xmlNodeSetValue (node_length, "2"	)
		end
		if(not node_ground)then
			node_ground = xmlCreateChild ( xmlFile, "ground" )
			xmlNodeSetAttribute ( node_ground, "r", 150 )
			xmlNodeSetAttribute ( node_ground, "g", 150 )
			xmlNodeSetAttribute ( node_ground, "b", 150 )
			xmlNodeSetAttribute ( node_ground, "a", 255 )
			xmlNodeSetValue (node_ground, "false" )
		end
		if(not node_air)then
			node_air = xmlCreateChild (xmlFile, "air" )
			xmlNodeSetAttribute ( node_air, "r", 255 )
			xmlNodeSetAttribute ( node_air, "g", 0 )
			xmlNodeSetAttribute ( node_air, "b", 0 )
			xmlNodeSetAttribute ( node_air, "a", 150 )
			xmlNodeSetValue (node_air, "false" )
		end
		if(not node_record_key)then
			node_record_key = xmlCreateChild (xmlFile, "record_key" )
			xmlNodeSetValue (node_record_key, "r" )
		end
		if(not node_test_key)then
			node_test_key = xmlCreateChild (xmlFile, "test_key" )
			xmlNodeSetValue (node_test_key, "v" )
		end
		if(not node_points)then
			node_points = xmlCreateChild (xmlFile, "points" )
			xmlNodeSetValue (node_points, "false" )
		end
	end
	xmlSaveFile(xmlFile)
end
reloadSettings()

function getSettings()
	reloadSettings()
	local settings = {}
	settings[1] = xmlNodeGetValue (node_ground)
	settings[2] = xmlNodeGetAttribute (node_ground, "r")
	settings[3] = xmlNodeGetAttribute (node_ground, "g")
	settings[4] = xmlNodeGetAttribute (node_ground, "b")
	settings[5] = xmlNodeGetAttribute (node_ground, "a")
	
	settings[6] = xmlNodeGetValue (node_air)
	settings[7] = xmlNodeGetAttribute (node_air, "r")
	settings[8] = xmlNodeGetAttribute (node_air, "g")
	settings[9] = xmlNodeGetAttribute (node_air, "b")
	settings[10] = xmlNodeGetAttribute (node_air, "a")
	
	settings[11] = xmlNodeGetValue(node_record_key)
	
	settings[12] = xmlNodeGetValue(node_delay)
	settings[13] = xmlNodeGetValue(node_length)
	
	settings[14] = xmlNodeGetValue(node_test_key)
	settings[15] = xmlNodeGetValue(node_points)
	return settings
end

function saveSettings(settings)
	reloadSettings()
	xmlNodeSetValue (node_ground, settings[1])
	xmlNodeSetAttribute (node_ground, "r", settings[2])
	xmlNodeSetAttribute (node_ground, "g", settings[3])
	xmlNodeSetAttribute (node_ground, "b", settings[4])
	xmlNodeSetAttribute (node_ground, "a", settings[5]) 
	
	xmlNodeSetValue (node_air, settings[6])
	xmlNodeSetAttribute (node_air, "r", settings[7])
	xmlNodeSetAttribute (node_air, "g", settings[8])
	xmlNodeSetAttribute (node_air, "b", settings[9])
	xmlNodeSetAttribute (node_air, "a", settings[10])
	
	xmlNodeSetValue(node_record_key, settings[11])
	
	xmlNodeSetValue(node_delay, settings[12])
	xmlNodeSetValue(node_length, settings[13])
	
	xmlNodeSetValue(node_test_key, settings[14])
	xmlNodeSetValue(node_points, settings[15])
	xmlSaveFile(xmlFile)
end

function saveSetting(s,v)
	 xmlNodeSetValue (xmlFindChild ( xmlFile, s, 0), v )
	 xmlSaveFile(xmlFile)
	 outputChatBox("Success!")
end