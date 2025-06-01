----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/28/2025 11:26:17 PM
-- Design Name: 
-- Module Name: led_blink - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_blinker is
    Port (
        CLK12MHZ     : in  std_logic;
        led     : out std_logic_vector(0 downto 0)
    );
end led_blinker;

architecture Behavioral of led_blinker is
    -- 20ms at 12MHz = 240,000 cycles
    constant MAX_COUNT : integer := 240000- 1;
    signal counter     : integer range 0 to MAX_COUNT := 0;
    signal led_state   : std_logic := '0';
begin
    process(CLK12MHZ)
    begin
        if rising_edge(CLK12MHZ) then
            if counter = MAX_COUNT then
                counter   <= 0;
                led_state <= not led_state;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    led(0) <= led_state;


    
end Behavioral;