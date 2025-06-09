----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/08/2025 06:29:16 PM
-- Design Name: 
-- Module Name: tb_uart - Behavioral
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

entity Top_tb is
end Top_tb;

architecture Behavioral of Top_tb is

    -- Component under test (DUT) ports
    signal CLK12MHZ     : std_logic := '0';
    signal btn          : std_logic_vector(3 downto 0) := (others => '0');
    signal uart_rxd_out : std_logic;
    signal led          : std_logic_vector(3 downto 0);

    -- Clock period for 12 MHz
    constant CLK_PERIOD : time := 83.333 ns;

begin

    -- Instantiate the Top module
    DUT: entity work.Top
        port map (
            CLK12MHZ     => CLK12MHZ,
            btn          => btn,
            uart_rxd_out => uart_rxd_out,
            led          => led
        );

    -- Generate 12 MHz clock
    clk_process: process
    begin
        while true loop
            CLK12MHZ <= '0';
            wait for CLK_PERIOD / 2;
            CLK12MHZ <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Wait for reset and startup
        wait for 1 ms;

        -- Simulate button 0 press (transmit trigger)
        btn(0) <= '1';
        wait for 160 ms; -- enough time to debounce
        btn(0) <= '0';
        wait for 10 ms;

        -- Wait and end
        wait for 50 ms;
        assert false report "Simulation finished" severity failure;
    end process;

end Behavioral;
