local thunders = {"sounds/storm.mp3", "sounds/thunder.mp3", "sounds/lightning.wav", "sounds/thunder.mp3", "sounds/thunder1.wav", "sounds/thunder2.wav" }
local soundvar =  { 0.85, 1.0, 1.50, 1.25, 1.80 }
setSkyGradient(0,0,0,0,0,0)
setWaterColor(50,155,155,155)
setRainLevel(0.5)
setWaveHeight(0.5)
setMoonSize( 10 )
setWorldSoundEnabled( 4, 1, false )
setWorldSoundEnabled( 4, 4, false )
function thunder()
local weather = getWeather()
local effect = playSound(thunders[math.random(1, #thunders)])
setSoundVolume( effect, math.random(1, #soundvar ) )
setSkyGradient(255,255,255,255,255,255)
setRainLevel(0.5)
setWaveHeight(0.5)
setTimer(function()
    setSkyGradient(0,0,0,0,0,0)
end, 100,1)
end
setTimer(thunder, 10000,0)

function AndrixxClient ()
    local as = 150
    engineSetModelLODDistance(3499, as)
    engineSetModelLODDistance(3498, as)
    engineSetModelLODDistance(3458, as)
    engineSetModelLODDistance(1525, as)
    engineSetModelLODDistance(10444, as)
    engineSetModelLODDistance(3524, as)
    engineSetModelLODDistance(3877, as)
    engineSetModelLODDistance(898, as)
    engineSetModelLODDistance(899, as)
    engineSetModelLODDistance(1525, as)
    engineSetModelLODDistance(826, as)
    engineSetModelLODDistance(6235, as)

end
addEventHandler( "onClientResourceStart", resourceRoot, AndrixxClient )