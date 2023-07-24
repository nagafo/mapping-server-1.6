--[[
	If you need any help, contact me on skype: julien.gunsche
	Sincerely, nGear aka. fgtGear
]]

--Variable that you can change
local group	= "j"
autoUnselect = false
moveSelected = false

--My table, don't touch it >.<
local oldElms		= {}
local elms		 	= {}
local coverObjects	= {}

--Table Functions
function table.clear( tb )
	if type( tb ) ~= "table" then
		return false
	end
	for index,elements in ipairs(tb) do
		table.remove (tb , index)
	end
	for index,elements in pairs(tb) do
		table.remove (tb , index)
	end
end 
function table.empty( a )
    if type( a ) ~= "table" then
        return false
    end  
    return not next( a )
end
--onResourceStart do some stuff
addEventHandler("onClientResourceStart",resourceRoot,function(res)
	outputChatBox("#FFA500[NGT]#FFFFFFNGT started! Type /ngtcommands to get information about commands!",255,255,255,true)
	outputChatBox("#FFA500[NGT]#FFFFFFHold 'j' down and click on objects to select them!",255,255,255,true)

end)

addCommandHandler("ngtcommands", function()
	outputChatBox("#FFA500[NGT]#FFFFFF/change [objectname/id] to change the model of selected objects!",255,255,255,true)
	outputChatBox("#FFA500[NGT]#FFFFFF/visible [true/false] to change the visibility of selected objects!",255,255,255,true)
	outputChatBox("#FFA500[NGT]#FFFFFF/cover to cover selected objects!",255,255,255,true)
	outputChatBox("#FFA500[NGT]#FFFFFF/delete to delete selected objects!",255,255,255,true)
	outputChatBox("#FFA500[NGT]#FFFFFF/ungt to undo last action(Doesn't work for cover)!",255,255,255,true)
end)

--onResourceStop do some stuff
addEventHandler("onClientResourceStop",resourceRoot,function(res)
	if table.empty(elms) then return end
	for i,v in pairs(elms) do
		setElementAlpha(v,255)
	end
end)
--Clicking function
function onClientClicks ( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, elm )
        if button=="left" and state=="down" and getKeyState(group) then
			if ( elm ) then
				for i,v in pairs(elms) do
					if v==elm then 
						table.remove (elms , i)
						setElementAlpha(elm,255)
						detachExtra(elm)
						return
					end
				end
				if elms[1] then
					if moveSelected then
						extraAttach(elm, elms[1])
					end
					setElementAlpha(elm,155)
				else
					setElementAlpha(elm,200)
				end
				table.insert (elms,  elm)
			end
		end
end
addEventHandler ( "onClientClick", root, onClientClicks )

local tatsch = {}
function extraAttach(from, to)
	local newTach = {}
	newTach.from = from 
	newTach.to   = to
	local fX, fY, fZ = getElementPosition(from)
	local tX, tY, tZ = getElementPosition(to)
	local fRX, fRY, fRZ = getElementRotation(from)
	local tRX, tRY, tRZ = getElementRotation(to)
	local xDif = fX - tX
	local yDif = fY - tY
	local zDif = fZ - tZ
	newTach.difX = xDif
	newTach.difY = yDif
	newTach.difZ = zDif
	xDif = fRX - tRX
	yDif = fRY - tRY
	zDif = fRZ - tRZ
	newTach.difRX = xDif
	newTach.difRY = yDif
	newTach.difRZ = zDif
	table.insert(tatsch, newTach)
end

function detachExtra(elm)
	for i, t in pairs(tatsch) do 
		if t.from==elm or t.to==elm then
			table.remove(tatsch, i)
		end
	end
end

function updateTachPositions()
	if #tatsch <= 0 or not moveSelected then return end
	for i, t in pairs(tatsch) do 
		local x,y,z = getElementPosition(t.to)
		local newX, newY, newZ = x+t.difX, y+t.difY, z+t.difZ
		setElementPosition(t.from, newX, newY, newZ)
		triggerServerEvent("onRequestUpdateElementPosition", t.from,newX, newY, newZ)
		x,y,z = getElementRotation(t.to)
		newX, newY, newZ = x+t.difRX, y+t.difRY, z+t.difRZ
		setElementRotation(t.from, newX, newY, newZ)
		triggerServerEvent("onRequestUpdateElementRotation", t.from,newX, newY, newZ)
	end
end

setTimer(updateTachPositions, 1000, 0)

--Object stuff

--Changing Object's models
function changeobjects(useless,id)
	if table.empty(elms) then outputChatBox("#FFA500[NGT]#FFFFFFYou have to select atleast one Object!",255,255,255,true) return end
	local eModel = nil
	if not tonumber(id) then
		eModel = engineGetModelIDFromName(id)
	end
	if not tonumber(id) and eModel==false then outputChatBox("#FFA500[NGT]#FFFFFFType in a valid Object ID or Object Name!",255,255,255,true)return  end
	if eModel then id=eModel end
	obj=createObject(id,0,0,0)
	local ObjectChange = {}
	if obj then
		destroyElement(obj)
		for i,elmd in ipairs(elms) do 
			if elmd==nil then table.remove (elms , i) return end
			setTimer(function()
				local bleh = {"object",elmd, getElementModel(elmd)}
				triggerServerEvent("changemodels", localPlayer,elmd,id)
				table.insert(ObjectChange,bleh)
			end,100,1)
		end
		table.insert(oldElms,ObjectChange)
		if autoUnselect then
			unselectall()
		end
	else
		outputChatBox("#FFA500[NGT]#FFFFFFType in a valid Object ID or Object Name!",255,255,255,true)
	end
end

--COVAH
function addCovering()

	--COVAH ST00000FF
	local sides = {front=false, back=false, bot=false, left=false, right=false}
	if guiCheckBoxGetSelected(GUI.cover.check.front) then sides.front=true end
	if guiCheckBoxGetSelected(GUI.cover.check.back) then sides.back=true end
	if guiCheckBoxGetSelected(GUI.cover.check.bot) then sides.bot=true end
	if guiCheckBoxGetSelected(GUI.cover.check.left) then sides.left=true end
	if guiCheckBoxGetSelected(GUI.cover.check.right) then sides.right=true end
	if table.empty(elms) then outputChatBox("#FFA500[NGT]#FFFFFFYou have to select atleast one Object!",255,255,255,true) return end
	coverObjects = {}
	local done = false
	triggerServerEvent("prepareCovah", localPlayer)
	for i,elmd in ipairs(elms) do 
		if elmd==nil then table.remove (elms , i) return end
		setTimer(triggerServerEvent, 50, 1, "addCovah", localPlayer,elmd, sides)
	end
	table.insert(oldElms, coverObjects)
	setTimer(function()
		triggerServerEvent("doNextCovah", localPlayer)
	end,100,1)
	if autoUnselect then
			unselectall()
		end
end

--Changing Object's visibility
function changevisibility(useless,sState)
	if table.empty(elms) then outputChatBox("#FFA500[NGT]#FFFFFFYou have to select atleast one Object!",255,255,255,true) return end
	if sState==nil then outputChatBox("#FFA500[NGT]#FFFFFFType in a valid state(true or false) #FFA500[/visible false|true]",255,255,255,true) return end
	if sState==true then
		sState ="true"
	elseif sState==false then
		sState ="false"
	else
		sState = string.lower(sState)
	end
	if sState~="false" and sState~="true" then outputChatBox("#FFA500[NGT]#FFFFFFType in a valid state(true or false) #FFA500[/visible false|true]",255,255,255,true) return  end
	state = 0
	if(sState=="true") then
		state=1
	end
	local VisibleChange = {}
	for i,elmd in ipairs(elms) do 
		setTimer(function()
			if elmd==nil then table.remove (elms , i) return end
			setTimer(function()
				local bleh
				if exports.edf:edfGetElementProperty(elmd, "scale")==1 then
					bleh = {"visible",elmd,1}
				else--If invisible before
					bleh = {"visible",elmd,0}
				end
				triggerServerEvent("changevisibilityy", localPlayer,elmd,state)
				exports.edf:edfSetElementProperty(elmd, "scale", state)
				table.insert(VisibleChange,bleh)
			end,50,1)
		end,55,1)
	end
	if autoUnselect then
			unselectall()
		end
	table.insert(oldElms,VisibleChange)
end

function deleteElements()
	for i,elmd in ipairs(elms) do 
		setTimer(function()
			if elmd==nil then table.remove (elms , i) return end
			setTimer(function()
				triggerServerEvent("removeCover", localPlayer, elmd)
				table.remove (elms , i) 
			end,50,1)
		end,55,1)
	end
	if autoUnselect then
			unselectall()
		end
end

function undoLastNGT()
	local tbL = #oldElms
	if tbL > 0 then
		for i,v in pairs(oldElms[tbL]) do 
			setTimer(function()
				Type,elmd,state = unpack(v)
				if elmd==nil then table.remove (oldElms[tbL] , i) return end
				if Type=="visible" then
					triggerServerEvent("changevisibilityy", localPlayer,elmd,state)
					exports.edf:edfSetElementProperty(elmd, "scale", state)
				elseif Type=="object" then
					triggerServerEvent("changemodels", localPlayer,elmd,state)	
					exports.edf:edfSetElementProperty(elmd, "model", state)
				elseif Type=="cover" then
					triggerServerEvent("removeCover", localPlayer, elmd)
				end
				if oldElms[tbL] then
					table.remove(oldElms[tbL],i)
				end
			end,55,1)
		end
		table.remove(oldElms)
		if autoUnselect then
			unselectall()
		end
	else
		outputChatBox("#FFA500[NGT]#FFFFFFThere was no action to undo!",255,255,255,true)
	end	
end

function updateCP()
	setClipboard("https://community.multitheftauto.com/index.php?p=resources&s=details&id=9217")
	outputChatBox("#FFA500[NGT]#FFFFFFCopied update link to clipboard! Paste it into your browser's adress bar!",255,255,255,true)
end

addCommandHandler("ngtlink",updateCP)		
addCommandHandler("ungt",undoLastNGT)
addCommandHandler("change",changeobjects)
addCommandHandler("visible",changevisibility)
addCommandHandler("cover",addCovering)
addCommandHandler("delete",deleteElements)

function unselectall()
	for i,elmd in ipairs(elms) do
		setTimer(function()
			setElementAlpha(elmd,255)
			table.remove(elms,i)
		end,50,1)
	end
	for i,elmd in pairs(elms) do 
		setTimer(function()
			setElementAlpha(elmd,255)
			table.remove(elms,i)
		end,50,1)
	end
	outputChatBox("#FFA500[NGT]#FFFFFFUnselected all Objects!",255,255,255,true)
end

addCommandHandler("ua",function()
	unselectall()
end)


function table.len(t)
	local i = 0 
	for l,v in pairs(t) do 
		i = i+1
	end
	return i-1
end
			
--Thanks to amt for the following functions
addEvent("sendBackRequestedElementsNGT", true)
addEventHandler("sendBackRequestedElementsNGT", getRootElement(),
function(elements)
	for i = 1, #elements do
		local element = elements[i]
		--Stuff for undo
		local bleh = {"cover", element.element}
		table.insert(coverObjects,bleh)
		--Amt stuff
		local posX, posY, posZ = getTransformedElementPosition(element.source, element.posX, element.posY, element.posZ)
		local rotX, rotY, rotZ = element.rotX, element.rotY, element.rotZ
		triggerServerEvent("onRequestUpdateElementRotation", element.element, rotX, rotY, rotZ)
		triggerServerEvent("onRequestUpdateElementPosition", element.element, posX, posY, posZ)
	end
		triggerServerEvent("doNextCovah", localPlayer)
end)

function getTransformedElementPosition(element, dx, dy, dz)
	local m = getElementMatrix(element)
	if not m then return false end
	local offX = dx * m[1][1] + dy * m[2][1] + dz * m[3][1] + 1 * m[4][1]
	local offY = dx * m[1][2] + dy * m[2][2] + dz * m[3][2] + 1 * m[4][2]
	local offZ = dx * m[1][3] + dy * m[2][3] + dz * m[3][3] + 1 * m[4][3]
	return offX, offY, offZ
end