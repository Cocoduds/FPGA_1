----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/09/2025 11:18:36 PM
-- Design Name: 
-- Module Name: rec_tb - Behavioral
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

entity uart_receive_tb is
end uart_receive_tb;

architecture tb of uart_receive_tb is
    constant CLK_PERIOD : time := 83.333 ns;  -- 12 MHz clock
    signal CLK12MHZ     : std_logic := '0';
    signal uart_txd_in  : std_logic := '1';
    signal data_out     : std_logic_vector(7 downto 0);
    signal data_ready   : std_logic;
    signal reset        : std_logic := '1';
    signal debug_led    : std_logic_vector(3 downto 0);

    component uart_receive
        Port (
            CLK12MHZ     : in  std_logic;
            uart_txd_in  : in  std_logic;
            data_out     : out std_logic_vector(7 downto 0);
            data_ready   : out std_logic;
            reset        : in  std_logic;
            debug_led    : out std_logic_vector(3 downto 0)
        );
    end component;

begin
    -- Clock generation
    clk_process : process
    begin
        while true loop
            CLK12MHZ <= '0';
            wait for CLK_PERIOD / 2;
            CLK12MHZ <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Instantiate DUT
    uut: uart_receive
        port map (
            CLK12MHZ    => CLK12MHZ,
            uart_txd_in => uart_txd_in,
            data_out    => data_out,
            data_ready  => data_ready,
            reset       => reset,
            debug_led   => debug_led
        );

    -- Stimulus process
    stim_proc: process
        -- Constants
        constant TICKS_PER_BIT : integer := 12000000 / 9600;
        constant BIT_TIME : time := CLK_PERIOD * TICKS_PER_BIT;

        -- UART transmit task
        procedure uart_send_byte(signal uart_line : out std_logic; byte : std_logic_vector(7 downto 0)) is
        begin
            uart_line <= '0'; -- Start bit
            wait for BIT_TIME;

            for i in 0 to 7 loop
                uart_line <= byte(i); -- LSB first
                wait for BIT_TIME;
            end loop;

            uart_line <= '1'; -- Stop bit
            wait for BIT_TIME;
        end procedure;
        
    begin
        -- Initial conditions
        uart_txd_in <= '1';
        reset <= '1';
        wait for 10 * CLK_PERIOD;
        reset <= '0';

        wait for 100 us;  -- Let the UART settle

        uart_send_byte(uart_txd_in, "01000001"); -- Send 'A'
        wait for 2 ms;

        uart_send_byte(uart_txd_in, "01100001"); -- Send 'a'
        wait for 2 ms;

        uart_send_byte(uart_txd_in, "00110001"); -- Send '1'
        wait for 2 ms;

        wait; -- Finish simulation
    end process;

end tb;
