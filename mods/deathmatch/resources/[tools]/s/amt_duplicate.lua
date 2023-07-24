addEvent("onClientRequestDuplicate", true)
addEventHandler("onClientRequestDuplicate", getRootElement(),
function(element1, element2, copies)
	local px, py, pz = getElementPosition(element1)
	local rx, ry, rz = getElementRotation(element1)
	local px2, py2, pz2 = getElementPosition(element2)
	local rx2, ry2, rz2 = getElementRotation(element2)
	local posDiffX, posDiffY, posDiffZ = px2 - px, py2 - py, pz2 - pz
	local rotDiffX, rotDiffY, rotDiffZ = rx2 - rx, ry2 - ry, rz2 - rz
	local model1 = getElementModel(element1)
	local model2 = getElementModel(element2)
	local elementList = {}
	for i = 1, copies do
		local newElement = exports.edf:edfCloneElement(element1)
		if(i%2 == 0)then
			setElementModel(newElement, model1)
		else
			setElementModel(newElement, model2)
		end
		local newID = "AMT "..getElementModel(newElement).." ("..getElementCount(newElement)..")"
		exports.edf:edfSetElementProperty(newElement, "id", newID)
		setElementID(newElement, newID)
		exports.edf:edfSetElementPosition(newElement, px2 + posDiffX*i, py2 + posDiffY*i, pz2 + posDiffZ*i)
		exports.edf:edfSetElementRotation(newElement, rx2 + rotDiffX*i, ry2 + rotDiffY*i, rz2 + rotDiffZ*i)
		elementList[#elementList+1] = newElement
	end
	triggerClientEvent(source, "sendBackDuplicatedElements", source, elementList)
end)

function getElementCount(element)
	local model = getElementModel(element)
	local count = 0
	local elements = getElementsByType(getElementType(element))
	for i = 1, #elements do
		local tModel = getElementModel(elements[i])
		if(tModel == model)then
			count = count + 1
		end
	end
	return count
end