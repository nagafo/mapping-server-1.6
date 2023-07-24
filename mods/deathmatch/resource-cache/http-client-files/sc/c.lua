
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