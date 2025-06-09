----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/01/2025 12:30:01 AM
-- Design Name: 
-- Module Name: debounce_signals - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce is
    Port ( CLK12MHZ     : in  STD_LOGIC;
           btn          : in  STD_LOGIC;
           transmit     : out STD_LOGIC;
           debug_led    : out std_logic
           );
end debounce;

architecture Behavioral of debounce is
    constant threshold            : integer := 1000000;
    constant MAX_COUNT            : unsigned(30 downto 0) := to_unsigned(1000000000, 31);
    signal button_ff1, button_ff2 : std_logic := '0';
    signal count                  : unsigned(30 downto 0) := "0000000000000000000000000000000";
--        signal transmit               : std_logic := '0';

begin

    next_button_state: process(CLK12MHZ)
    begin
        if rising_edge(CLK12MHZ) then
            button_ff1 <= btn;
            button_ff2 <= button_ff1;
        end if;   
    end process next_button_state;
    
    debouncer: process(CLK12MHZ)
    begin
        if rising_edge(CLK12MHZ) then
            if button_ff2 = '1' then
                if count /= MAX_COUNT then
                    count <= count + 1;
                end if;
            else
                if count /= 0 then
                    count <= count - 1;
                end if;
            end if;
            
            if (count > threshold) then 
                transmit <= '1';
                debug_led <= '1';
            else
                transmit <= '0';
                debug_led <= '0';
            end if;
            
        end if;
    end process debouncer;

end Behavioral;
