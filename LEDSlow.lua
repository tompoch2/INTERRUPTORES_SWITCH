local Z = {} 
     
local pin  = 3 gpio.mode(pin,gpio.OUTPUT) -- SW1 LED
local pin2 = 6 gpio.mode(pin2,gpio.OUTPUT)-- SW2 LED
local pin3 = 0 gpio.mode(pin3,gpio.OUTPUT)-- SW3 LED 

gpio.write(pin, gpio.LOW)

function Z.slow() 

    tmr.alarm(0, 500, 1, function ()
        if gpio.read(pin) == gpio.HIGH  then
            status = gpio.LOW
        else
            status = gpio.HIGH
        end
        gpio.write(pin, status)
        gpio.write(pin2, status)  
        gpio.write(pin3, status)
    end)
end
return Z
