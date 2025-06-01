----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/30/2025 11:49:57 PM
-- Design Name: 
-- Module Name: 7seg - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity seven_seg is
  Port (
        CLK12MHZ     : in  std_logic;
        sw           : in  std_logic_vector(3 downto 0);
        led          : out std_logic_vector(0 downto 0);
        jc           : out std_logic_vector(3 downto 0); -- lower 4 bits of digit
        jd           : out std_logic_vector(3 downto 0)  -- upper 3 bits of digit and cs
    );
end seven_seg;

architecture Behavioral of seven_seg is

    -- 20ms at 12MHz = 240,000 cycles
    constant MAX_COUNT : integer := 240000- 1;
    signal counter     : integer range 0 to MAX_COUNT := 0;
    signal led_state   : std_logic := '0';
    signal digit        : std_logic_vector(6 downto 0);
    
begin
    -- 20ms for 50hz refresh rate --
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
    
    digitSelect: process (led_state, sw)
    begin
    case (led_state) is
        when '0' => 
            jd(3) <= led_state;
            case (sw) is
                when "0000" => digit <= "0111111"; --0
                when "0001" => digit <= "0000110"; --1
                when "0010" => digit <= "1011011"; --2
                when "0011" => digit <= "1001111"; --3
                when "0100" => digit <= "1100110"; --4
                when "0101" => digit <= "1101101"; --5
                when "0110" => digit <= "1111101"; --6
                when "0111" => digit <= "0000111"; --7
                when "1000" => digit <= "1111111"; --8
                when "1001" => digit <= "1101111"; --9
                when "1010" => digit <= "0111111"; --10
                when "1011" => digit <= "0000110"; --11
                when "1100" => digit <= "1011011"; --12
                when "1101" => digit <= "1001111"; --13
                when "1110" => digit <= "1100110"; --14
                when "1111" => digit <= "1101101"; --15
                when others => digit <= "1111001"; --error
             end case;
        when '1' =>
            case (sw) is
                when "0000" => digit <= "0111111"; --0
                when "0001" => digit <= "0111111"; --0
                when "0010" => digit <= "0111111"; --0
                when "0011" => digit <= "0111111"; --0
                when "0100" => digit <= "0111111"; --0
                when "0101" => digit <= "0111111"; --0
                when "0110" => digit <= "0111111"; --0
                when "0111" => digit <= "0111111"; --0
                when "1000" => digit <= "0111111"; --0
                when "1001" => digit <= "0111111"; --0
                when "1010" => digit <= "0000110"; --1
                when "1011" => digit <= "0000110"; --1
                when "1100" => digit <= "0000110"; --1
                when "1101" => digit <= "0000110"; --1
                when "1110" => digit <= "0000110"; --1
                when "1111" => digit <= "0000110"; --1
                when others => digit <= "1111001"; --error
              end case;
          
    end case;
    -- display the digit;
    jc <= digit(3 downto 0);
    jd <= led_state & digit(6 downto 4);
    end process digitSelect;

end Behavioral;
