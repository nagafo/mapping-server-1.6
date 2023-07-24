setSkyGradient(0,0,0,0,0,0)
setCloudsEnabled(false)
song = playSound("song.mp3",true)
setSoundVolume(song,1)

eelements = {3499,10444,3749,2898,1525}
for k,v in ipairs(eelements) do
    engineSetModelLODDistance ( v, 300 )
end

markers = {
    createMarker(2065.6000976563,-1294.0999755859,3184.1999511719,"corona",4,255,0,0,255),
    createMarker(2407.8999023438,-1133.1999511719,2391.6000976563,"corona",4,255,255,0,0),
    createMarker(2745.1000976563,-1294.4000244141,2756.3000488281,"corona",3,255,255,0,255),
    createMarker(1599.9000244141,-1216.1999511719,1005.9000244141,"corona",20,255,255,0,255),
    createMarker(1413.1999511719,-2021.8000488281,4166.8999023438,"corona",20,255,255,0,255),
    createMarker(1217.5999755859,-2374.6000976563,3321.3999023438,"corona",4,255,255,0,255),
    createMarker(1351.9000244141,-1167.5999755859,2044.8000488281,"corona",4,122,255,0,255),
    createMarker(1514,-1005.299987793,1442.0999755859,"corona",8,122,255,0,255),
}
function AndrixxClient ()
    txd = engineLoadTXD("M.txd") 
    engineImportTXD(txd, 1525 )
    engineSetModelLODDistance(3499, 300)
    engineSetModelLODDistance(3498, 300)

    engineSetModelLODDistance(10444, 300)
    engineSetModelLODDistance(3524, 300)
end
addEventHandler( "onClientResourceStart", resourceRoot, AndrixxClient )

addEventHandler("onClientMarkerHit",root,function(hitPlayer)
    if hitPlayer == localPlayer then
        if isPlayerInVehicle(hitPlayer) then
            car = getPedOccupiedVehicle(hitPlayer)
            if source == markers[1] then 
                setElementVelocity(car,0,0,0)
                setElementAngularVelocity(car,0,0,0)
                setElementRotation(car,0,0,90)
                local u = Vector3(getElementPosition(markers[1]))
                setElementPosition(car,u.x,u.y,u.z)
                setElementVelocity(car,2,0,0.5)
                setElementAngularVelocity(car,0.1,0.1,0)
            elseif source == markers[2] then
                setElementVelocity(car,0,0,0)
                setElementAngularVelocity(car,0,0,0)
                setElementRotation(car,70,0,90)
                setElementPosition(car,1476.1999511719,-1762.1999511719,4063.3000488281)
            elseif source == markers[3] then
                local u = Vector3(getElementRotation(car))
                if u.x >= 70 and u.x <= 110 and u.y >= 25 and u.y <= 55 and u.z >= 160 and u.z <= 200 then
                    return
                else 
                    blowVehicle(car)
                end
            elseif source == markers[4] then 
                setElementVelocity(car,0,0,0)
                setElementAngularVelocity(car,0,0,0)
                setElementRotation(car,0,0,100)
                setElementPosition(car,1723.0999755859,-1966.9000244141,4177.7001953125)
            elseif source == markers[5] then 
                setElementVelocity(car,0,0,0)
                setElementAngularVelocity(car,0,0,0)
                setElementRotation(car,0,0,130)
                local u = Vector3(getElementPosition(markers[5]))
                setElementPosition(car,u.x,u.y,u.z)
                setElementVelocity(car,0,-1.5,0.1)
            elseif source == markers[6] then
                local u = Vector3(getElementRotation(car))
                if  u.y >= 60 and u.y <= 110 then
                    return
                else 
                    blowVehicle(car)
                end
            elseif source == markers[7] then
                local u = Vector3(getElementRotation(car))
                if  u.y >= 310 and u.y <= 359 then
                    return
                else 
                    blowVehicle(car)
                end
            elseif source == markers[8] then
                local u = Vector3(getElementRotation(car))
                if  u.z >= 0 and u.z <= 40 then
                    return
                else 
                    blowVehicle(car)
                end
            
            end
        end
    end
end)


addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
function()
	txd = engineLoadTXD ( "carshade.txd" )
	engineImportTXD ( txd, 2898 )
	dff = engineLoadDFF ( "tiny_shade.dff", 0 )
	engineReplaceModel ( dff, 2898 )
	col = engineLoadCOL ( "tiny_shade.col" )
    engineReplaceCOL ( col, 2898 )

end
)
--[[
addEventHandler("onClientRender",root,function()
    if isPedInVehicle(localPlayer) then
    local a,b,c = getElementRotation(getPedOccupiedVehicle(localPlayer))
    local a = math.floor(a)
    local b = math.floor(b)
    local c = math.floor(c)
    dxDrawText("X: "..a.." Y:"..b.." Z:"..c,100,400)
    end
end)
]]

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