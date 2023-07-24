--
-- c_water.lua
--

addEventHandler( "onClientResourceStart", resourceRoot,
	function()

		-- Version check
		if getVersion ().sortable < "1.1.0" then
			outputChatBox( "Resource is not compatible with this client." )
			return
		end

		-- Create shader
		local myShader, tec = dxCreateShader ( "water.fx" )

		if not myShader then
			outputChatBox( "Could not create shader. Please use debugscript 3" )
		else
			outputChatBox( "Using technique " .. tec )

			-- Set textures
			local textureVol = dxCreateTexture ( "images/smallnoise3d.dds" );
			local textureCube = dxCreateTexture ( "images/cube_env256.dds" );
			dxSetShaderValue ( myShader, "microflakeNMapVol_Tex", textureVol );
			dxSetShaderValue ( myShader, "showroomMapCube_Tex", textureCube );

			-- Apply to global txd 13
			engineApplyShaderToWorldTexture ( myShader, "waterclear256" )

			-- Update water color incase it gets changed by persons unknown
			
			if myShader then
				local r,g,b,a = getWaterColor()
				dxSetShaderValue ( myShader, "gWaterColor", 0/255, 25/255, 25/255, 0.7 );
			end
		end
	end
)
