-------------------------Scripts for anti FW (FORWARD)
-------------------------Creation of Markers
-------------------------Replace the 0, 0, 0 with  the X, Y, Z coordinates of your marker

antiFwMarker1 = createMarker (5339.7001953125, -945.5, 30.299999237061, "corona", 4, 255, 255, 255, 0)
antiFwMarker2 = createMarker (3169.6000976562, 335.20001220703, 1028.0999755859, "corona", 10, 255, 255, 255, 0)
antiFwMarker3 = createMarker (0, 0, 0, "corona", 6, 255, 255, 255, 0)
antiFwMarker4 = createMarker (0, 0, 0, "corona", 6, 255, 255, 255, 0)
antiFwMarker5 = createMarker (0, 0, 0, "corona", 6, 255, 255, 255, 0)

-------------------------if you need to add more, you can copy-paste the same line. Don't forget to change the marker number. You can use the following examples:
--[[
antiFwMarker6 = createMarker (0, 0, 0, "corona", 6, 255, 255, 255, 0)
antiFwMarker7 = createMarker (0, 0, 0, "corona", 6, 255, 255, 255, 0)
antiFwMarker8 = createMarker (0, 0, 0, "corona", 6, 255, 255, 255, 0)
antiFwMarker9 = createMarker (0, 0, 0, "corona", 6, 255, 255, 255, 0)
antiFwMarker10 = createMarker (0, 0, 0, "corona", 6, 255, 255, 255, 0)
--]]
------------------------------------------------------------------------------------------------------







-------------------------DON'T edit these lines below, unless you have added more than 10 markers.
-------------------------If you added more than 10 markers, you have to copy and paste the same functions, changing the antiFwMarker number only.
-------------------------You can use the following examples (Notice that the only change is the "antiFwMarker11", "antiFwMarker12"):
--[[

addEventHandler ( "onClientMarkerHit", antiFwMarker11, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if not isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiFwMarker12, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if not isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

--]]






addEventHandler ( "onClientMarkerHit", antiFwMarker1, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if not isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiFwMarker2, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if not isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiFwMarker3, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if not isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiFwMarker4, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if not isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiFwMarker5, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if not isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiFwMarker6, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if not isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiFwMarker7, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if not isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiFwMarker8, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if not isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiFwMarker9, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if not isVehicleReversing(vehicle) then
            blowVehicle ( vehicle )
        end
    end
end)

addEventHandler ( "onClientMarkerHit", antiFwMarker10, function (plr)
    local vehicle = getPedOccupiedVehicle (plr)
    if vehicle then
        if not isVehicleReversing(vehicle) then
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