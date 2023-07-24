addEvent("createEditorElement", true)
addEventHandler("createEditorElement", root,
	function (elements, definitions)

		if definitions then

			local usedDefinitions = tostring(definitions)
			if usedDefinitions then
				local newEDF = allEDF
				-- define all EDFs as available
				for _, definition in ipairs(newEDF.addedEDF) do
					table.insert(newEDF.availEDF, definition)
				end
				
				newEDF.addedEDF = split(usedDefinitions, 44) -- The map specifies a set of EDF to load
				table.subtract(newEDF.availEDF, newEDF.addedEDF) -- Remove the added EDFs from the available
				reloadEDFDefinitions(newEDF,true) -- Un/Load the neccessary definitions
			end

		end

		local total = #elements
		triggerClientEvent(root, "saveLoadProgressBar", root, 0, total)
		createEditorElements = coroutine.create(doCreateEditorElements)
		coroutine.resume(createEditorElements, source, elements, total, {})

	end
)	

function doCreateEditorElements(creator, elements, total, element_array)

	local tick = getTickCount()
	for k, data in pairs(elements) do

		local elementType, resourceName, parameters = data[1], data[2], data[3]

		parameters = parameters or {}
		
		if elementType and creator and getElementType(creator) == "player" and resourceName then
				
			local creatorResource = getResourceFromName(resourceName)
			local edfElement = edf.edfCreateElement(
				elementType,
				creator,
				creatorResource,
				parameters,
				true
			)
			
			if edfElement then
				setupNewElement(edfElement, creatorResource, source, false, shortcut)
				if parameters.id then
					setElementID(edfElement, parameters.id )
					setElementData(edfElement, "id", parameters.id )
					setElementData(edfElement, "me:ID", parameters.id )
				end
			end
			
			if elementType == "object" then
				
				if parameters.doublesided then
					edf.edfSetElementProperty(edfElement, "doublesided", parameters.doublesided)
				end
				if parameters.collisions then
					edf.edfSetElementProperty(edfElement, "collisions", parameters.collisions)
				end
				if parameters.breakable then
					edf.edfSetElementProperty(edfElement, "breakable", parameters.breakable)
				end		
				if parameters.scale then
					edf.edfSetElementProperty(edfElement, "scale", parameters.scale)
				end		

			elseif elementType == "vehicle" then

				if parameters.paintjob then
					edf.edfSetElementProperty(edfElement, "paintjob", parameters.paintjob)
				end
				if parameters.color then
					edf.edfSetElementProperty(edfElement, "color", parameters.color)
				end

			end

			element_array[edfElement] = elementType

			if getTickCount() - tick > 500 then

				triggerClientEvent(root, "saveLoadProgressBar", root, k, total)
				setTimer(function() coroutine.resume(createEditorElements, creator, elements, total, element_array) end, 50, 1)
				coroutine.yield()
				tick = getTickCount()

			elseif k == total then
				triggerClientEvent(root, "saveLoadProgressBar", root, false)
				triggerEvent("onEditorElementsCreated", root, creator, element_array)
			end

		else

			outputDebugString("Failed to create element got elementType: "..inspect(elementType).." creator: "..inspect(creator).." creatorResource:"..inspect(resourceName), 1, 255, 0,0)

		end

	end

end

addEvent("onEditorElementsCreated", true)