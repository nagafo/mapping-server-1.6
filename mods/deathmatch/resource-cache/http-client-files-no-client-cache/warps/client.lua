local cache = {}
local timer = false

function unfrezee()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle then
		local to_load = cache[#cache]
		if to_load then
			setElementFrozen(vehicle, false)
			if to_load.nitro[1] then
				addVehicleUpgrade(vehicle, 1010)
				setVehicleNitroLevel(vehicle, to_load.nitro[3])
				setVehicleNitroActivated(vehicle, to_load.nitro[2])
			end
			setElementVelocity(vehicle, unpack(to_load.velocity))
			setElementAngularVelocity(vehicle, unpack(to_load.turn_velocity))
		end
	end
end

function load()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle then
		local to_load = cache[#cache]
		if to_load then
			setElementPosition(vehicle, unpack(to_load.position))
			setElementRotation(vehicle, unpack(to_load.rotation))
			setElementModel(vehicle, to_load.model)
			setElementHealth(vehicle, to_load.health)
			setGameSpeed(to_load.game_speed)
			setElementFrozen(vehicle, true)
			if timer and isTimer(timer) then killTimer(timer) end
			timer = setTimer(unfrezee, 1000, 1)
			outputChatBox("[Training] The #FFFFFFlast warp#306EFF has been #FFFFFFloaded#306EFF.", 48, 110, 255, true)
		end
	end
end

function save()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle then
		local to_save = {}
		to_save.position = {getElementPosition(vehicle)}
		to_save.rotation = {getElementRotation(vehicle)}
		to_save.velocity = {getElementVelocity(vehicle)}
		to_save.turn_velocity = {getElementAngularVelocity(vehicle)}
		to_save.model = getElementModel(vehicle)
		to_save.health = getElementHealth(vehicle)
		to_save.nitro = {getVehicleUpgradeOnSlot(vehicle, 8), isVehicleNitroActivated(vehicle),  getVehicleNitroLevel(vehicle)}
		to_save.game_speed = getGameSpeed()
		table.insert(cache, to_save)
		outputChatBox("[Training] New #FFFFFFwarp#306EFF has been #FFFFFFcreated#306EFF.", 48, 110, 255, true)
	end
end

function delete()
	local last_saved = #cache
	local last_warp = cache[last_saved]
	if last_saved and last_warp then
		table.remove(cache, last_saved)
		outputChatBox("[Training] The #FFFFFFlast warp#306EFF has been #FFFFFFcleared#306EFF.", 48, 110, 255, true)
	end
end

outputChatBox("[Training] Use #FFFFFF/sw #306EFFto save your position", 48, 110, 255, true)
outputChatBox("[Training] Use #FFFFFF/lw #306EFFto load your saved position", 48, 110, 255, true)
outputChatBox("[Training] Use #FFFFFF/dw #306EFFto delete your saved position", 48, 110, 255, true)
outputChatBox("[Training] Bind commands to a key: #FFFFFF/bind [key] [command]#306EFF. Example: #FFFFFF/bind 1 sw", 48, 110, 255, true)

addCommandHandler("lw", load)
addCommandHandler("sw", save)
addCommandHandler("dw", delete)