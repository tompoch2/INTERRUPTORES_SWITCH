--local d8_pin = 8             -- SW3 OUT
--local d7_pin = 7             -- SW3 RELAY CH3
--local d0_pin = 0             -- SW3 LED    
  
--local d6_pin = 6             -- SW2 LED
--local d5_pin = 5             -- SW2 RELAY CH2
--local d4_pin = 4             -- SW2 OUT

--local d3_pin = 3             -- SW1 LED
--local d2_pin = 2             -- SW1 RELAY CH1
--local d1_pin = 1             -- SW1 OUT

--gpio.mode(d8_pin,gpio.INT)   -- SW3 OUT
--gpio.mode(d7_pin,gpio.OUTPUT)-- SW3 RELAY CH3
--gpio.mode(d0_pin,gpio.OUTPUT)-- SW3 LED
 
--gpio.mode(d6_pin,gpio.OUTPUT)-- SW2 LED
--gpio.mode(d5_pin,gpio.OUTPUT)-- SW2 RELAY CH2
--gpio.mode(d4_pin,gpio.INT)   -- SW2 OUT

--gpio.mode(d3_pin,gpio.OUTPUT)-- SW1 LED
--gpio.mode(d2_pin,gpio.OUTPUT)-- SW1 RELAY CH1
--gpio.mode(d1_pin,gpio.INT)   -- SW1 OUT

--gpio.write(d0_pin,gpio.LOW)  -- SW3 LED
--gpio.write(d7_pin,gpio.LOW)  -- SW3 RELAY CH3

--gpio.write(d6_pin,gpio.LOW)  -- SW2 LED
--gpio.write(d5_pin,gpio.LOW)  -- SW2 RELAY CH2

--gpio.write(d3_pin,gpio.LOW)  -- SW1 LED
--gpio.write(d2_pin,gpio.LOW)  -- SW1 RELAY CH1

dofile("init_sin_clave.lua")
