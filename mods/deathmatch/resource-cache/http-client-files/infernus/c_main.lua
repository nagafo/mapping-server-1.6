
txd = engineLoadTXD ( "infernus.txd" )
engineImportTXD ( txd, 411 )
dff = engineLoadDFF ( "infernus.dff" )
engineReplaceModel ( dff, 411 )

addCommandHandler("as",function() -- short for 'is component visible'
setVehicleComponentVisible(getPedOccupiedVehicle(localPlayer),"xRz Lights",false)
end
)
