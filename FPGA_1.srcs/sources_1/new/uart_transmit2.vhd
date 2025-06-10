----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/08/2025 07:25:40 PM
-- Design Name: 
-- Module Name: uart_transmit2 - Behavioral
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

entity uart_transmit2 is
  Port (
        CLK12MHZ     : in  std_logic;
        data         : in  std_logic_vector(7 downto 0);
        transmit     : in  std_logic;
        reset        : in  std_logic;
        uart_rxd_out : out std_logic                    -- FPGA to PC
--        uart_txd_in  : in  std_logic
    );
end uart_transmit2;

architecture Behavioral of uart_transmit2 is
    constant BAUD_RATE      : integer := 9600;
    constant CLOCK_FREQ     : integer := 12_000_000;
    constant TICKS_PER_BIT  : integer := CLOCK_FREQ / BAUD_RATE;
    
    signal bit_counter         : unsigned(3 downto 0) := (others => '0');
    signal baudrate_counter    : unsigned(11 downto 0) := (others => '0');           --counter = clock / baudrate
    signal shiftright_register : std_logic_vector(9 downto 0) := (others => '1');    -- bits that will be transmited
    signal busy                : std_logic := '0';
    signal uart_out            : std_logic := '1';
    
begin
    uart_rxd_out <= uart_out;

    process(CLK12MHZ)
    begin
        if rising_edge(CLK12MHZ) then
            if reset = '1' then
                busy             <= '0';
                baudrate_counter <= (others => '0');
                bit_counter      <= (others => '0');
                shiftright_register        <= (others => '1');
                uart_out         <= '1';
            else
                if busy = '0' then
                    if transmit = '1' then
                        shiftright_register <= '1' & data & '0';  -- start bit, data bits, stop bit
                        busy <= '1';
                        baudrate_counter <= (others => '0');
                        bit_counter <= (others => '0');
                    end if;
                else
                    if baudrate_counter = to_unsigned(TICKS_PER_BIT - 1, baudrate_counter'length) then
                        uart_out <= shiftright_register (0);
                        shiftright_register  <= '1' & shiftright_register (9 downto 1);  -- shift right
                        bit_counter <= bit_counter + 1;
                        baudrate_counter <= (others => '0');

                        if bit_counter = 9 then
                            busy <= '0';  -- done sending 10 bits
                        end if;
                    else
                        baudrate_counter <= baudrate_counter + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
                

end Behavioral;
