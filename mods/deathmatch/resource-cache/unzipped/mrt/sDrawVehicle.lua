addEvent( "requestCreateVehicle", true )addEventHandler( "requestCreateVehicle", getRootElement(), function(vID, pos,color)	local tVeh = createVehicle(vID, pos[1],pos[2],pos[3],pos[4],pos[5],pos[6])	setElementFrozen (tVeh, true)	setVehicleColor (tVeh, color[1], color[2],color[3])	setElementVisibleTo ( tVeh, getRootElement(), false)	setElementVisibleTo ( tVeh, source, true)	editorImport()end)