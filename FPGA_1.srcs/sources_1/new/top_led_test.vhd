----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/01/2025 07:31:51 PM
-- Design Name: 
-- Module Name: top_led_test - Behavioral
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

entity top_led_test is
    Port (
        CLK12MHZ : in  STD_LOGIC;
        btn      : in  STD_LOGIC_VECTOR(3 downto 0);
        led0,led1,led2,led3 : out std_logic 
    );
end top_led_test;

architecture Behavioral of top_led_test is

    signal led0_unused       : STD_LOGIC_VECTOR(3 downto 0);
    signal transmit_signals  : STD_LOGIC_VECTOR(3 downto 0);

    component debounce
        Port (
            CLK12MHZ : in  STD_LOGIC;
            btn      : in  STD_LOGIC;
            transmit : out STD_LOGIC;
            led0     : out STD_LOGIC
        );
    end component;

begin

    -- Instantiate debounce for each button
    debounce0: debounce
        port map (
            CLK12MHZ => CLK12MHZ,
            btn      => btn(0),
            transmit => transmit_signals(0),
            led0     => led0_unused(0)
        );

    debounce1: debounce
        port map (
            CLK12MHZ => CLK12MHZ,
            btn      => btn(1),
            transmit => transmit_signals(1),
            led0      => led0_unused(1)
        );

    debounce2: debounce
        port map (
            CLK12MHZ => CLK12MHZ,
            btn      => btn(2),
            transmit => transmit_signals(2),
            led0     => led0_unused(2)
        );

    debounce3: debounce
        port map (
            CLK12MHZ => CLK12MHZ,
            btn      => btn(3),
            transmit => transmit_signals(3),
            led0     => led0_unused(3)
        );

    -- Drive each LED directly from transmit
    led0 <= transmit_signals(0);
    led1 <= transmit_signals(1);
    led2 <= transmit_signals(2);
    led3 <= transmit_signals(3);
    
end Behavioral;
