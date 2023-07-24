--EDITABLE

local markers = {
	--Marker 1
	{
		x = ,
		y = -,
		z = ,
		markerType = "corona",
		markerSize = 8,
		r = 0,
		g = 0,
		b = 255,
		a = 255,
		velX = ,
		velY = ,
		velZ = ,
	},
	--Marker 2
	{
		x = 2,
		y = 2,
		z = 2,
		markerType = "corona",
		markerSize = 10,
		r = 52,
		g = 202,
		b = 158,
		a = 65,
		velX = 0,
		velY = 0,
		velZ = 1

	},
}

--DONT TOUCH
function main()
   	createJumps(getLocalPlayer())
end
addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()), main )

function createJumps(player)
	if player ~= localPlayer then
		return
	end	
	for i, v in ipairs(markers) do
		local marker = createMarker(v.x,v.y,v.z, v.markerType, v.markerSize, v.r,v.g,v.b,v.a)
	
		addEventHandler("onClientMarkerHit", marker, 
			function(hitPlayer)
				if hitPlayer == localPlayer then
					local vehicle = getPedOccupiedVehicle(localPlayer)
					if vehicle then
						setElementVelocity(getPedOccupiedVehicle(localPlayer), v.velX,v.velY,v.velZ)
					else
						setElementVelocity(localPlayer, v.velX,v.velY,v.velZ)
					end
					
				end
			end
		)
	end
end
