__selectElement = selectElement

function selectElement(...)
	
	if selecting_blocked then

		local args = {...}
		if args[1] and isElement(args[1]) then
			return triggerEvent("onSelectionCancel", args[1])
		end

		return
	end

	return __selectElement(...)
end

function blockSelecting(state)
	selecting_blocked = state
end

addEvent("onSelectionCancel", true)
addEvent("onClientEditorBlockSelecting", true)
addEventHandler("onClientEditorBlockSelecting", root, blockSelecting)