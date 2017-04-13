LEDSFast = require "LEDSFast"
   
local d0_pin = 0   -- SW3 LED  
local d7_pin = 7   -- SW3 RELAY CH3
local d8_pin = 8   -- SW3 OUT

local d6_pin = 6   -- SW2 LED
local d5_pin = 5   -- SW2 RELAY CH2
local d4_pin = 4   -- SW2 OUT

local d3_pin = 3    -- SW1 LED
local d2_pin = 2   -- SW1 RELAY CH1
local d1_pin = 1   -- SW1 OUT

gpio.mode(d0_pin,gpio.OUTPUT)
gpio.mode(d7_pin,gpio.OUTPUT)
gpio.mode(d8_pin,gpio.INT)

gpio.mode(d6_pin,gpio.OUTPUT)
gpio.mode(d5_pin,gpio.OUTPUT)
gpio.mode(d4_pin,gpio.INT)

gpio.mode(d3_pin,gpio.OUTPUT)
gpio.mode(d2_pin,gpio.OUTPUT)
gpio.mode(d1_pin,gpio.INT)

gpio.write(d0_pin,gpio.LOW)
gpio.write(d7_pin,gpio.LOW)
gpio.write(d6_pin,gpio.LOW)
gpio.write(d5_pin,gpio.LOW)
gpio.write(d3_pin,gpio.LOW)
gpio.write(d2_pin,gpio.LOW)

print("Consultado a BD")
LEDSFast.sfast()
la_mac = wifi.sta.getmac()
lm = string.gsub(la_mac, ":", "", 5)

la_ip = wifi.sta.getip()

conn=net.createConnection(net.TCP, 0)
conn:on("connection",function(conn, payload)
conn:send("GET /my/php/nodemcu.php?mac="..lm.."&la_ip="..la_ip
        .." HEAD / HTTP/1.1\r\n"
        .. "Host: cd3307.myfoscam.org\r\n"
        .."Accept: */*\r\n"
        .."User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"
        .."\r\n\r\n")
      end)

conn:on("receive", function(conn, payload)
c=string.sub(payload,string.find(payload,"{")+1,string.find(payload,"}")-1)

print("Cadena MQTT : "..c)

conn:close()
end)

conn:connect(80,'cd3307.myfoscam.org')
    print("Raspberry OnLine")
    tmr.alarm(3,3000,1,function()
        print("Corriendo Archivo MQTT")
        tmr.delay(500000)
        print("MAC : "..la_mac)
        print("MAC Abreviada : "..lm)
        lm1 = c..""..lm.."_1"
        lm2 = c..""..lm.."_2"
        lm3 = c..""..lm.."_3"

        print(lm1)
        print(lm2)
        print(lm3)

        m = mqtt.Client(lm,120,"pi","raspberry")

        m:lwt("/lwt","offline",0,0)

        m:on("connect",function(client) print("Conectado a MQTT Server")end)
        m:on("offline",function(con) print("MQTT OffLine") tmr.alarm( 4 , 4000 , 1 , reconectar_mqtt)  end)

        m:on("message",function(conn,topic,data)
            if topic == lm1 then
                if data == "On" then
                    print("Mensaje recibido: On@"..lm1)
                    gpio.write(d2_pin,gpio.HIGH)
                    gpio.write(d3_pin,gpio.HIGH)
                end
                if data == "Off" then
                    print("Mensaje recibido: Off@"..lm1)
                    gpio.write(d2_pin,gpio.LOW)
                    gpio.write(d3_pin,gpio.LOW)
                end
                if data == "restart" then
                    print("Mensaje recibido: Reiniciado restart@"..lm1)
                    restartt()
                end
                if data == "restartfull" then
                    print("Mensaje recibido: Reiniciado restart@"..lm1)
                    restartt_full()
                end
            end
            if topic == lm2 then
                if data == "On" then
                    print("Mensaje recibido: On@"..lm2)
                    gpio.write(d5_pin,gpio.HIGH)
                    gpio.write(d6_pin,gpio.HIGH)
                end
                if data == "Off" then
                    print("Mensaje recibido: Off@"..lm2)
                    gpio.write(d5_pin,gpio.LOW)
                    gpio.write(d6_pin,gpio.LOW)
                end
            end
            if topic == lm3 then
                if data == "On" then
                    print("Mensaje recibido: On@"..lm3)
                    gpio.write(d7_pin,gpio.HIGH)
                    gpio.write(d0_pin,gpio.HIGH)
                end 
                if data == "Off" then
                    print("Mensaje recibido: Off@"..lm3)
                    gpio.write(d7_pin,gpio.LOW)
                    gpio.write(d0_pin,gpio.LOW) 
                end 
            end
        end)    

        m:connect("cd3307.myfoscam.org",1883,0, function(conn)
            print("Suscribiendo a")
            m:subscribe({[lm1]=0, [lm2]=1, [lm3]=2}, function(conn)
                print(lm1.." , "..lm2.." y "..lm3.." suscritos")
                tmr.stop(5) 
                gpio.write(d3_pin,gpio.LOW)
                gpio.write(d2_pin,gpio.LOW)
                gpio.write(d6_pin,gpio.LOW)
                gpio.write(d5_pin,gpio.LOW)
                gpio.write(d7_pin,gpio.LOW)
                gpio.write(d0_pin,gpio.LOW)
            end)
        end)

        if lm1 == nil then
            print("Esperando Cadena MQTT...")
        else
            tmr.stop(3)
        end
    end)

function por_boton1()
    if gpio.read(d1_pin) == gpio.HIGH then
        gpio.write(d2_pin,gpio.HIGH)
        gpio.write(d3_pin,gpio.HIGH)
        m:publish(lm1,"On",0,0, function(conn) print("On") end)
    else
        gpio.write(d2_pin,gpio.LOW)
        gpio.write(d3_pin,gpio.LOW)
        m:publish(lm1,"Off",0,0, function(conn) print("Off") end)
    end
end

function por_boton2()
    if gpio.read(d4_pin) == gpio.HIGH then
        gpio.write(d5_pin,gpio.HIGH)
        gpio.write(d6_pin,gpio.HIGH)
        m:publish(lm2,"On",0,0, function(conn) print("On") end)
    else
        gpio.write(d5_pin,gpio.LOW)
        gpio.write(d6_pin,gpio.LOW)
        m:publish(lm2,"Off",0,0, function(conn) print("Off") end)
    end
end

function por_boton3()
    if gpio.read(d8_pin) == gpio.HIGH then
        gpio.write(d7_pin,gpio.HIGH)
        gpio.write(d0_pin,gpio.HIGH)
        m:publish(lm3,"On",0,0, function(conn) print("On") end)
    else
        gpio.write(d7_pin,gpio.LOW)
        gpio.write(d0_pin,gpio.LOW)
        m:publish(lm3,"Off",0,0, function(conn) print("Off") end)
    end
end

function restartt()
    node.restart() 
end

function restartt_full()  
    file.remove("config.txt")
    node.restart()
end 
 
function reconectar_mqtt()
    LEDSFast.sfast()
    if(wifi.sta.status()==5) then
        m:connect("cd3307.myfoscam.org", 1883, 0, function(conn)
        m:subscribe({[lm1]=0}, function(conn)
            print(lm1.." suscrito")
        end)
        end)
        tmr.stop(4)
        tmr.stop(5)
    end
end

gpio.trig(d1_pin,"both",por_boton1)
gpio.trig(d4_pin,"both",por_boton2)
gpio.trig(d8_pin,"both",por_boton3)
