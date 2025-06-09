----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/08/2025 07:42:22 PM
-- Design Name: 
-- Module Name: uart_receive - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity uart_receive is
    Port (
        CLK12MHZ     : in  std_logic;
        uart_txd_in  : in  std_logic;
        data_out     : out std_logic_vector(7 downto 0);
        data_ready   : out std_logic;
        reset        : in  std_logic;
        debug_led    : out std_logic_vector(3 downto 0)  --0 = button debounce
    );
end uart_receive;

architecture Behavioral of uart_receive is
    constant BAUD_RATE     : integer := 9600;
    constant CLOCK_FREQ    : integer := 12_000_000;
    constant TICKS_PER_BIT : integer := CLOCK_FREQ / BAUD_RATE;  -- 1250
    constant MID_BIT       : integer := TICKS_PER_BIT / 2;

    type state_type is (idle, start_bit, receiving, stop_bit);
    signal state        : state_type := idle;

    signal bit_counter  : unsigned(4 downto 0) := (others => '0');
    signal baud_counter : integer range 0 to TICKS_PER_BIT := 0;
    signal shiftright_register    : std_logic_vector(7 downto 0) := "11111111";
    signal data_buffer  : std_logic_vector(7 downto 0) := "11111111";
    signal ready        : std_logic := '0';
begin
    data_out <= data_buffer;
    data_ready <= ready;

    process(CLK12MHZ)
    begin
        if rising_edge(CLK12MHZ) then
            if reset = '1' then
                state        <= idle;
                bit_counter  <= (others => '0');
                baud_counter <= 0;
                ready        <= '0';
            else
                ready <= '0'; -- clear flag after one cycle

                case state is
                    when idle =>
                        if uart_txd_in = '0' then -- start bit detected
                            state <= start_bit;
                            baud_counter <= 0;
                        end if;

                    when start_bit =>
                        if baud_counter = 0 then
                            if uart_txd_in = '0' then
                                state <= receiving;
                                bit_counter <= (others => '0');
                                baud_counter <= TICKS_PER_BIT - 1;
                            else
                                state <= idle; -- false start
                            end if;
                        else
                            baud_counter <= baud_counter - 1;
                        end if;

                    when receiving =>
                        if baud_counter = 0 then
                            if bit_counter = 7 then
                                state <= stop_bit;
                                bit_counter <= (others => '0');
                                debug_led(0) <= shiftright_register(0);
                                debug_led(2) <= shiftright_register(7);
                            else
                                shiftright_register <= uart_txd_in & shiftright_register(7 downto 1); 
                                bit_counter <= bit_counter + 1;
                            end if;
                            baud_counter <= TICKS_PER_BIT - 1;
                        else
                            baud_counter <= baud_counter - 1;
                        end if;


                    when stop_bit =>
                        if baud_counter = 0 then
                            if uart_txd_in = '1' then -- stop bit OK
                                data_buffer <= shiftright_register;
                                ready <= '1';
                            end if;
                            state <= idle;
                        else
                            baud_counter <= baud_counter - 1;
                        end if;

                end case;
            end if;
        end if;
    end process;
end Behavioral;

