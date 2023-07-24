
addEventHandler("onClientResourceStart", root,
function()
Marker_lol3 = createMarker (3817.6999511719, -1674.5, 81.199996948242,"corona", 5, 0,0,0,0) -- edit it
end)

function getElementSpeed(element,unit)
if (unit == nil) then unit = 15 end
if (isElement(element)) then
local x,y,z = getElementVelocity(element)
if (unit=="mph" or unit==1 or unit =='1') then
return (x^2 + y^2 + z^2) ^ 0.5 * 100
else
return (x^2 + y^2 + z^2) ^ 0.5 * 1.8 * 100
end
else
return false
end
end

function setElementSpeed(element, unit, speed)
if (unit == nil) then unit = 0 end
if (speed == nil) then speed = 0 end
speed = tonumber(speed)
local acSpeed = getElementSpeed(element, unit)
if (acSpeed~=false) then
local diff = speed/acSpeed
local x,y,z = getElementVelocity(element)
setElementVelocity(element,x*diff,y*diff,z*diff)
return true
end

return false
end

addEventHandler("onClientMarkerHit", root,
function(player)
if player ~= localPlayer then return end
if isElementWithinMarker(player, Marker_lol3) then
if(getElementSpeed(getPedOccupiedVehicle(player)," kph") < 500) then setElementSpeed(getPedOccupiedVehicle(player), "kph", 180) end
end
end)

addEventHandler("onClientResourceStart", root,
function()
Marker_lol4 = createMarker (4672.400390625, -1046.7998046875, 5.3000001907349,"corona", 5, 0,0,0,0) -- edit it
end)

function getElementSpeed(element,unit)
if (unit == nil) then unit = 15 end
if (isElement(element)) then
local x,y,z = getElementVelocity(element)
if (unit=="mph" or unit==1 or unit =='1') then
return (x^2 + y^2 + z^2) ^ 0.5 * 100
else
return (x^2 + y^2 + z^2) ^ 0.5 * 1.8 * 100
end
else
return false
end
end

function setElementSpeed(element, unit, speed)
if (unit == nil) then unit = 0 end
if (speed == nil) then speed = 0 end
speed = tonumber(speed)
local acSpeed = getElementSpeed(element, unit)
if (acSpeed~=false) then
local diff = speed/acSpeed
local x,y,z = getElementVelocity(element)
setElementVelocity(element,x*diff,y*diff,z*diff)
return true
end

return false
end

addEventHandler("onClientMarkerHit", root,
function(player)
if player ~= localPlayer then return end
if isElementWithinMarker(player, Marker_lol4) then
if(getElementSpeed(getPedOccupiedVehicle(player)," kph") < 500) then setElementSpeed(getPedOccupiedVehicle(player), "kph", 180) end
end
end)

addEventHandler("onClientResourceStart", root,
function()
Marker_lol5 = createMarker (4695, -1004.5, 5.6999998092651,"corona", 5, 0,0,0,0) -- edit it
end)

function getElementSpeed(element,unit)
if (unit == nil) then unit = 15 end
if (isElement(element)) then
local x,y,z = getElementVelocity(element)
if (unit=="mph" or unit==1 or unit =='1') then
return (x^2 + y^2 + z^2) ^ 0.5 * 100
else
return (x^2 + y^2 + z^2) ^ 0.5 * 1.8 * 100
end
else
return false
end
end

function setElementSpeed(element, unit, speed)
if (unit == nil) then unit = 0 end
if (speed == nil) then speed = 0 end
speed = tonumber(speed)
local acSpeed = getElementSpeed(element, unit)
if (acSpeed~=false) then
local diff = speed/acSpeed
local x,y,z = getElementVelocity(element)
setElementVelocity(element,x*diff,y*diff,z*diff)
return true
end

return false
end

addEventHandler("onClientMarkerHit", root,
function(player)
if player ~= localPlayer then return end
if isElementWithinMarker(player, Marker_lol5) then
if(getElementSpeed(getPedOccupiedVehicle(player)," kph") < 500) then setElementSpeed(getPedOccupiedVehicle(player), "kph", 180) end
end
end)

addEventHandler("onClientResourceStart", root,
function()
Marker_lol6 = createMarker (4717.2001953125, -973.900390625, 6.4000000953674,"corona", 5, 0,0,0,0) -- edit it
end)

function getElementSpeed(element,unit)
if (unit == nil) then unit = 15 end
if (isElement(element)) then
local x,y,z = getElementVelocity(element)
if (unit=="mph" or unit==1 or unit =='1') then
return (x^2 + y^2 + z^2) ^ 0.5 * 100
else
return (x^2 + y^2 + z^2) ^ 0.5 * 1.8 * 100
end
else
return false
end
end

function setElementSpeed(element, unit, speed)
if (unit == nil) then unit = 0 end
if (speed == nil) then speed = 0 end
speed = tonumber(speed)
local acSpeed = getElementSpeed(element, unit)
if (acSpeed~=false) then
local diff = speed/acSpeed
local x,y,z = getElementVelocity(element)
setElementVelocity(element,x*diff,y*diff,z*diff)
return true
end

return false
end

addEventHandler("onClientMarkerHit", root,
function(player)
if player ~= localPlayer then return end
if isElementWithinMarker(player, Marker_lol6) then
if(getElementSpeed(getPedOccupiedVehicle(player)," kph") < 500) then setElementSpeed(getPedOccupiedVehicle(player), "kph", 180) end
end
end)