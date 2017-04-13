local pin = 3 
local pin2 = 6
local status = gpio.LOW
local duration = 500

tmr.alarm(0, duration, 1, function ()
    if status == gpio.LOW then
        status = gpio.HIGH
    else
        status = gpio.LOW
    end
    gpio.write(pin, status)
    gpio.write(pin2, status)
end)
  
print("Configurando WIFI")
 
wifi.setmode(wifi.STATION)
wifi.sta.config("CARLITA2","carlandrea")
--wifi.sta.config("INFORMATICA","VTRlabo15")

tmr.alarm(1,2000,1,function()
    if wifi.sta.getip()== nil then           
        print("Esperando autoconfiguracion, IP no disponible...")
    else 
        tmr.stop(0)
        tmr.stop(1)
        tmr.stop(2)        
        print("Conectado a CARLITA, la direccion IP es " ..wifi.sta.getip())        
--        print("Conectado a INFORMATICA, la direccion IP es " ..wifi.sta.getip())        
          
        dofile("mqtt4.lua") 
    end
end)
