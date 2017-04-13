local pin  = 3 gpio.mode(pin,gpio.OUTPUT)
local pin2 = 6 gpio.mode(pin2,gpio.OUTPUT)

gpio.write(pin, gpio.LOW)

local duracion = 500

tmr.alarm(2, duracion, 1, function ()
        if gpio.read(pin) == gpio.HIGH  then
            status = gpio.LOW
        else
            status = gpio.HIGH
        end
        gpio.write(pin, status)
        gpio.write(pin2, status)
end)

if file.open("config.txt","r") then
    print("SmartConfig Configurado")
    user = file.readline()
    pass = file.readline()

    print(user)
    print(pass)

    wifi.setmode(wifi.STATION)
    print("Configurando WIFI "..user)

    wifi.sta.config(user,pass)

    cuenta = 0
    tmr.alarm(1,2000,1,function()
            if wifi.sta.getip()== nil then
                print("Esperando autoconfiguracion, IP no disponible... Intento "..cuenta)
                cuenta = cuenta + 1

                if cuenta == 10 then
                    file.remove("config.txt")
                    node.restart()
                end
            else
                tmr.stop(0)
                tmr.stop(1)
                tmr.stop(2)
                print("Conectado a " ..user.. ", la direccion IP es " ..wifi.sta.getip())

--        dofile("mqtt4.lua")
            end
    end)

    file.close()
else
    print("Configurando SmartConfig")
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
    end)

    --wifi.stopsmart()
end
