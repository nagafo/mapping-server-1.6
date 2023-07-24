-------------------------Scripts for anti BW (BACKWARD)
-------------------------Creation of Markers
-------------------------Replace the 0, 0, 0 with  the X, Y, Z coordinates of your marker

antiBwMarker1 = createMarker (0, 0, 0, "corona", 6, 255, 255, 255, 0)
antiBwMarker2 = createMarker (0, 0, 0, "corona", 6, 255, 255, 255, 0)
antiBwMarker3 = createMarker (0, 0, 0, "corona", 6, 255, 255, 255, 0)
antiBwMarker4 = createMarker (0, 0, 0, "corona", 6, 255, 255, 255, 0)
antiBwMarker5 = createMarker (0, 0, 0, "corona", 6, 255, 255, 255, 0)

-------------------------if you need to add more, you can copy-paste the same line. Don't forget to change the marker number. You can use the following examples:
--[[
antiBwMarker6 = createMarker (0, 0, 0, "corona", 6, 255, 255, 255, 0)
antiBwMarker7 = createMarker (0, 0, 0, "corona", 6, 255, 255, 255, 0)
antiBwMarker8 = createMarker (0, 0, 0, "corona", 6, 255, 255, 255, 0)
antiBwMarker9 = createMarker (0, 0, 0, "corona", 6, 255, 255, 255, 0)
antiBwMarker10 = createMarker (0, 0, 0, "corona", 6, 255, 255, 255, 0)
--]]
------------------------------------------------------------------------------------------------------







-------------------------DON'T edit these lines below, unless you have added more than 10 markers.
-------------------------If you added more than 10 markers, you have to copy and paste the same functions, changing the antiBwMarker number only.
-------------------------You can use the following examples (Notice that the only change is the "antiBwMarker11", "antiBwMarker12"):
--[[

addEventHandler ( "onClientMarkerHit", antiBwMarker11, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiBwMarker12, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

--]]






addEventHandler ( "onClientMarkerHit", antiBwMarker1, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiBwMarker2, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiBwMarker3, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiBwMarker4, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiBwMarker5, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiBwMarker6, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiBwMarker7, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiBwMarker8, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiBwMarker9, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiBwMarker10, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)
















-------------------------------------------------------------
-------------------------IGNORE THIS-------------------------

function isVehicleReversing(theVehicle)
    local getMatrix = getElementMatrix (theVehicle)
    local getVelocity = Vector3 (getElementVelocity(theVehicle))
    local getVectorDirection = (getVelocity.x * getMatrix[2][1]) + (getVelocity.y * getMatrix[2][2]) + (getVelocity.z * getMatrix[2][3]) 
    if (getVectorDirection >= 0) then
        return false
    end
    return true
end