LEDFast = require "LEDFast" 
LEDSlow = require "LEDSlow" 
   
function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end
 
function ltrim(s)
  return (s:gsub("^%s*", ""))
end

function rtrim(s)
  local n = #s
  while n > 0 and s:find("^%s", n) do n = n - 1 end 
  return s:sub(1, n)
end

if file.open("config.txt","r") then
    LEDSlow.slow()
    print("SmartConfig Configurado")
    user = file.readline()
    pass = file.readline()

    userr = trim(user)
    print(userr)
    passs = trim(pass)
    print(passs)

    wifi.setmode(wifi.STATION)
    print("Configurando WIFI "..userr)

    wifi.sta.config(userr,passs)

    cuenta = 0
    tmr.alarm(1,2000,1,function()
            if wifi.sta.getip()== nil then
                print("Esperando a "..userr.. ", IP no disponible... Intento "..cuenta)
                cuenta = cuenta + 1

                if cuenta == 10 then
                    file.remove("config.txt")
                    node.restart()
                end
            else
                tmr.stop(0)
                tmr.stop(1)
                tmr.stop(2)
                print("Conectado a " ..userr.. ", la direccion IP es " ..wifi.sta.getip())

        dofile("mqtt4.lua") 
            end
    end)
 
    file.close()
else
    print("SmartConfig")
    LEDFast.fast()
    wifi.setmode(wifi.STATION)
    wifi.startsmart(0,
        function(ssid,password)
            print(string.format("Exito SSID: %s; PASSWORD: %s", ssid, password))
            if file.open("config.txt", "w") then
                cade1 = ssid
                file.writeline(cade1)
                cade2 = password
                file.writeline(cade2)
                file.close()
            end

            print("Reiniciando Dispositivo")
            node.restart()
    end)
end
