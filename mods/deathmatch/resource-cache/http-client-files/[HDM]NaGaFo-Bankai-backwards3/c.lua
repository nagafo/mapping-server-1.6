setSkyGradient(0,0,0,0,0,0)
setCloudsEnabled(false)
playSound("bankai.mp3",true)
markers = {
    createMarker(-2489.1640625,-895.4248046875,5342.3828125, "corona", 4, 0,69,189,155),
    createMarker(-2151.69921875,-771.921875,3072.1220703125, "corona", 10, 0,69,189,155),
    createMarker(-2589.3525390625,-811.8857421875,2553.1560058594, "corona", 7, 0,69,189,155),
    createMarker(-2688.326171875,-865.640625,2397.1813964844, "corona", 7, 0,69,189,155),
    createMarker(-2820.537109375,-942.29296875,1840.8654785156, "corona", 10, 0,69,189,155),
    createMarker(-3179.2451171875,-1006.8271484375,1095.6922607422, "corona", 5, 0,69,189,155),
}

ped = createPed(246,-19.691999435425,0.26719999313354,11258.39453125,270)

setPedAnimation(ped,"car","Tyd2car_low")
setElementFrozen(ped,true)
setElementCollisionsEnabled(ped,false)
state = 0
function AndrixxClient ()
    local as =250
    engineSetModelLODDistance(3980, as)
    engineSetModelLODDistance(10828, as)
    engineSetModelLODDistance(9582, as)
    engineSetModelLODDistance(10755, as)
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
    engineSetModelLODDistance(4564, as)
    engineSetModelLODDistance(4563, as)
    engineSetModelLODDistance(4586, as)
    engineSetModelLODDistance(10308, as)
    engineSetModelLODDistance(4602, as)
    engineSetModelLODDistance(9907, as)
    engineSetModelLODDistance(2805, as)
    engineSetModelLODDistance(2804, as)
    engineSetModelLODDistance(2806, as)
    engineSetModelLODDistance(2371, as)
    engineSetModelLODDistance(2149, as)
    

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
        elseif source == markers[3]  then
            setElementPosition(vehicle,-2587.4196777344,
-810.33453369141,
2558.9750976562)
setElementVelocity(vehicle,-1.0114549398422,
-0.57380330562592,
-1.5235010385513)
        elseif source == markers[4]  then
            setElementPosition(vehicle,-2684.5502929688,-864.00122070312,2401.61328125)
            setElementVelocity(vehicle,-1.2825082540512,-0.64089578390121,-1.5192881822586)  
        elseif source == markers[5]  then
            setElementPosition(vehicle,-2820.537109375,-942.29296875,1840.8654785156)
            setElementVelocity(vehicle,-1.0114549398422,0,0.5235010385513)
        elseif source == markers[6]  then
            setElementPosition(vehicle,-3179.2451171875,-1006.8271484375,1095.6922607422)
            setElementVelocity(vehicle,-2,1,1)
            setElementAngularVelocity(vehicle,0,0,0)
            setElementRotation(vehicle,68.801879882812,0.2142333984375,163.55895996094)
        end
    end
end
addEventHandler("onClientMarkerHit", resourceRoot, boost)


local skybox_scale = 1200  
local object_id = 15057 

local getLastTick, getLastTock = 0,0
local skybox_shader, technique = dxCreateShader ( "shader.fx",0,0,true,"object" )

local skyBoxBoxa

function startShaderResource()
    
 if not skybox_shader then 
  outputChatBox('Could not start Skybox shader!')
  return 
 end
 local textureSkybox1= dxCreateTexture ( "textures/skybox.dds")
 dxSetShaderValue ( skybox_shader, "sSkyBoxTexture1", textureSkybox1 )
 
 dxSetShaderValue ( skybox_shader, "gBrighten", 0)

 dxSetShaderValue ( skybox_shader, "gEnAlpha", 1)

  dxSetShaderValue ( skybox_shader, "gInvertTimeCycle", 0)

  dxSetShaderValue ( skybox_shader, "animate", 0) 

  dxSetShaderValue ( skybox_shader, "rotateX", 0) 
  dxSetShaderValue ( skybox_shader, "rotateY", 0) 
  dxSetShaderValue ( skybox_shader, "rotateZ", 90) 
 dxSetShaderValue ( skybox_shader, "sResize",1,1,1) 
dxSetShaderValue ( skybox_shader, "sStretch",1,1,1) 

 engineApplyShaderToWorldTexture ( skybox_shader, "skybox_tex" )

 txd_skybox = engineLoadTXD('models/skybox_model.txd')
 engineImportTXD(txd_skybox, object_id)
 dff_skybox = engineLoadDFF('models/skybox_model.dff', object_id)
 engineReplaceModel(dff_skybox, object_id)  

 local cam_x,cam_y,cam_z = getElementPosition(getLocalPlayer())
 skyBoxBoxa = createObject ( object_id, cam_x, cam_y, cam_z, 0, 0, 0, true )
 setElementAlpha(skyBoxBoxa,1)

 setObjectScale ( skyBoxBoxa, skybox_scale )

addEventHandler ( "onClientHUDRender", getRootElement (), renderSphere ) -- draw skybox
addEventHandler ( "onClientHUDRender", getRootElement (), renderTime ) -- add timecycle 
carPed1 = createPed(257,0,0,0)
carPed2 = createPed(256,0,0,0)
carPed11 = createVehicle(481,-18.223100662231,5.8821001052856,11258.002929688,0,0,180)
carPed21 = createVehicle(481,-18.080600738525,-5.5233001708984,11258.002929688,0,0,0)
warpPedIntoVehicle ( carPed1, carPed11)
warpPedIntoVehicle ( carPed2, carPed21)
end

function stopShaderResource()
destroyElement(skyBoxBoxa)
destroyElement(skybox_shader)
skyBoxBoxa=nil
skybox_shader=nil
end

function renderTime()

  dxSetShaderValue ( skybox_shader, "gBrighten", 0)

end

function renderSphere()

 if getTickCount ( ) - getLastTock < 30  then return end

 local cam_x, cam_y, cam_z, lx, ly, lz = getCameraMatrix()
 setElementPosition ( skyBoxBoxa, cam_x, cam_y, cam_z ,false )
 getLastTock = getTickCount ()
end

setFogDistance (300)
setFarClipDistance (1500)

addEventHandler("onClientResourceStart", getResourceRootElement( getThisResource()), startShaderResource)
addEventHandler("onClientResourceStop", getResourceRootElement( getThisResource()), stopShaderResource)