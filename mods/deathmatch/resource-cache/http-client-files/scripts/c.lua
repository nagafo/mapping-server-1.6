
setCloudsEnabled(false)


markers = {
    createMarker(-2489.1640625,-895.4248046875,5342.3828125, "corona", 4, 0,69,189,255),
    createMarker(-2151.69921875,-771.921875,3072.1220703125, "corona", 10, 0,69,189,255),
}


state = 0
function AndrixxClient ()
    local as = 150
    engineSetModelLODDistance(3499, as)
    engineSetModelLODDistance(3498, as)
    engineSetModelLODDistance(3458, as)
    engineSetModelLODDistance(1525, as)
    engineSetModelLODDistance(10444, as)
    engineSetModelLODDistance(3524, as)
    engineSetModelLODDistance(3877, as)
    engineSetModelLODDistance(898, as)
    engineSetModelLODDistance(899, as)
    engineSetModelLODDistance(1525, as)
    engineSetModelLODDistance(826, as)
    

end
addEventHandler( "onClientResourceStart", resourceRoot, AndrixxClient )

function boost(player)
    if getElementType(player)=="player" then
        local vehicle = getPedOccupiedVehicle(player)
        if source == markers[1]  then
        --[[ local a,b,c = getElementRotation(vehicle)
            outputChatBox(a)
            outputChatBox(b)
            outputChatBox(c)
            local a,b,c = getElementPosition(vehicle)
            outputChatBox(a)
            outputChatBox(b)
            outputChatBox(c)
            local a,b,c = getElementVelocity(vehicle)
            outputChatBox(a)
            outputChatBox(b)
            outputChatBox(c)
            local a,b,c = getElementAngularVelocity(vehicle)
            outputChatBox(a)
            outputChatBox(b)
            outputChatBox(c)]]

            setElementPosition(vehicle,-2489.1640625,-895.4248046875,5342.3828125)
            setElementVelocity(vehicle,2,
            -0,
            -1.3)      
        elseif source == markers[2]  then
            setElementPosition(vehicle,-2151.69921875,-771.921875,3072.1220703125)
            setElementVelocity(vehicle,-2,
            -0,
            -1.3)  
        end
    end
end
addEventHandler("onClientMarkerHit", resourceRoot, boost)