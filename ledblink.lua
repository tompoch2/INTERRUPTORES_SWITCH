local M = {}

function M.fast()

    tmr.alarm(2, 250, 1, function ()
        if gpio.read(pin) == gpio.HIGH  then
            status = gpio.LOW
        else 
            status = gpio.HIGH
        end
        gpio.write(pin, status)
        gpio.write(pin2, status)
    end)
end  
return M

function M.slow()
    tmr.alarm(2, 500, 1, function ()
        if gpio.read(pin) == gpio.HIGH  then
            status = gpio.LOW
        else
            status = gpio.HIGH
        end
        gpio.write(pin, status)
        gpio.write(pin2, status)
    end)
end

return M