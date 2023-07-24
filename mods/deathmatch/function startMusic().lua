function startMusic()
	setRadioChannel(0)
	begin = playSound("music/beginning.mp3",true) 
	setSoundVolume(begin, 1)
end
addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),startMusic)

function makeRadioStayOff()
    setRadioChannel(0)
    cancelEvent()
end
addEventHandler("onClientPlayerRadioSwitch",getRootElement(),makeRadioStayOff)
addEventHandler("onClientPlayerVehicleEnter",getRootElement(),makeRadioStayOff)

function toggleSong()
    if not songOff then
	    setSoundVolume(song, 0)
		songOff = true
		removeEventHandler("onClientPlayerRadioSwitch",getRootElement(),makeRadioStayOff)
	else
	    setSoundVolume(song, 1)
		songOff = false
		setRadioChannel(0)
		addEventHandler("onClientPlayerRadioSwitch",getRootElement(),makeRadioStayOff)
	end
end
addCommandHandler("music",toggleSong)
bindKey("m","down","music")

function changeDistance()
	for i,object in pairs(getElementsByType("object")) do
		if isElement(object) then
		local elementID = getElementModel(object)
		engineSetModelLODDistance(elementID, 1000)
		setCloudsEnabled(false)
		end
	end
end
addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),changeDistance)

function Marker()
	marker = createMarker(5145.2998046875, -866.29998779297, 39.700000762939, "corona", 6, 0, 255, 255, 0) -- Beginning of Full Song.

end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), Marker)
local stateSong = 0
function MarkerHit(hitPlayer, matchingDimension)
	vehicle = getPedOccupiedVehicle(hitPlayer)
	if hitPlayer ~= localPlayer then return end
	--------------------------------------------------------------||
	if source == marker then
		if stateSong == 0 then
			stopSound(begin)
			song = playSound("music/song.mp3",true)
			stateSong = 1
		end
		createExplosion(2355.8837890625, -3641.4819335938, 7009.1850585938, 10)
		createExplosion(2355.8837890625, -3659.9252929688, 7009.1850585938, 10)
		
	end
	--------------------------------------------------------------||
end
addEventHandler("onClientMarkerHit", root, MarkerHit)
