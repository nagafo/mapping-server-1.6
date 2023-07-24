addCommandHandler("emergency",
function()
	outputChatBox("emergency save!")
	local map = xmlCreateFile("emap.map", "map")
	if not map then return end
	for k, object in ipairs(getElementsByType("object")) do
		local child = xmlCreateChild(map, "object")
		xmlNodeSetAttribute(child, "id", tostring(getElementID(object)))
		xmlNodeSetAttribute(child, "doublesided", tostring(isElementDoubleSided(object)))
		xmlNodeSetAttribute(child, "model", tostring(getElementModel(object)))
		xmlNodeSetAttribute(child, "interior", tostring(0))
		xmlNodeSetAttribute(child, "dimension", tostring(0))
		
		local posX, posY, posZ = getElementPosition(object)
		local rotX, rotY, rotZ = getElementRotation(object)
		xmlNodeSetAttribute(child, "posX", tostring(posX))
		xmlNodeSetAttribute(child, "posY", tostring(posY))
		xmlNodeSetAttribute(child, "posZ", tostring(posZ))
		
		xmlNodeSetAttribute(child, "rotX", tostring(rotX))
		xmlNodeSetAttribute(child, "rotY", tostring(rotY))
		xmlNodeSetAttribute(child, "rotZ", tostring(rotZ))
	end
	xmlSaveFile(map)
	xmlUnloadFile(map)
	outputChatBox("saved!")
end)