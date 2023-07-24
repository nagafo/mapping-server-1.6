--
-- c_switch.lua
--

----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
--
--	To switch on:
--			triggerEvent( "switchWaterRef", root, 4 )
--
--	To switch off:
--			triggerEvent( "switchWaterRef", root, 0 )
--
----------------------------------------------------------------
----------------------------------------------------------------

--------------------------------
-- onClientResourceStart
--		Auto switch on at start
--------------------------------
addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource()),
	function()
		triggerEvent( "switchWaterRef", resourceRoot, true)
		addCommandHandler( "sWaterRef",
			function()
				triggerEvent( "switchWaterRef", resourceRoot, not wrEffectEnabled)
			end
		)
	end
)
--------------------------------
-- Switch effect on or off
--------------------------------
function switchWaterRef( wrOn )
	outputDebugString( "switchWaterRef: " .. tostring(wrOn) )
	if (wrOn) then
		enableWaterRef()
	else
		disableWaterRef()
	end
end

addEvent( "switchWaterRef", true )
addEventHandler( "switchWaterRef", resourceRoot, switchWaterRef )

addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource()),
	function()
		outputDebugString('/sDynamicSky to switch the effect')
		triggerEvent( "switchDynamicSky", resourceRoot, true )
		addCommandHandler( "sDynamicSky",
			function()
				triggerEvent( "switchDynamicSky", resourceRoot, not dsEffectEnabled )
			end
		)
	end
)


--------------------------------
-- Switch effect on or off
--------------------------------
function switchDynamicSky( dsOn )
	outputDebugString( "switchDynamicSky: " .. tostring(dsOn) )
	if dsOn then
		startDynamicSky()
	else
		stopDynamicSky()
	end
end

addEvent( "switchDynamicSky", true )
addEventHandler( "switchDynamicSky", resourceRoot, switchDynamicSky )

--------------------------------
-- onClientResourceStop
-- Stop the resource
--------------------------------
addEventHandler( "onClientResourceStop", getResourceRootElement( getThisResource()),stopDynamicSky)
