----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/28/2025 11:31:48 PM
-- Design Name: 
-- Module Name: tb_led_blink - Behavioral
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

entity tb_led_blinker is
end tb_led_blinker;

architecture sim of tb_led_blinker is
    -- Component under test
    component led_blinker is
        Port (
            CLK12MHZ : in std_logic;
            led : out std_logic_vector(0 downto 0)
        );
    end component;

    -- Signals to connect to UUT
    signal clk_tb : std_logic := '0';
    signal led_tb : std_logic;

    -- 12 MHz clock: Period = 83.333... ns
    constant CLK_PERIOD : time := 83 ns;

begin

    -- Instantiate the unit under test (UUT)
    uut: led_blinker
        port map (
            CLK12MHZ => clk_tb,
            led(0) => led_tb
        );

    -- Clock generation process
    clk_process: process
    begin
        while now < 2 sec loop
            clk_tb <= '0';
            wait for CLK_PERIOD / 2;
            clk_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

end sim;