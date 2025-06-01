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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_transmit is
  Port (
        CLK12MHZ     : in  std_logic;
        data         : in  std_logic_vector(9 downto 0);
        transmit     : in  std_logic;
        reset        : in  std_logic;
        uart_rxd_out : out std_logic                    -- FPGA to PC
--        uart_txd_in  : in  std_logic
    );
end uart_transmit;

architecture Behavioral of uart_transmit is
    constant BAUD_RATE      : integer := 9600;
    constant CLOCK_FREQ     : integer := 12_000_000;
    constant TICKS_PER_BIT  : integer := CLOCK_FREQ / BAUD_RATE;
    
    signal bit_counter         : unsigned(3 downto 0);
    signal baudrate_counter    : unsigned(11 downto 0);   --counter = clock / baudrate
    signal shiftright_register : std_logic_vector(9 downto 0);    -- bits that will be transmited
    signal state, next_state   : std_logic;
    signal shift               : std_logic;
    signal load                : std_logic;                       --load signal to start loading data to shiftright_register, add start & stop bits
    signal clear               : std_logic;                       --reset bit_counter
    
begin
    uart: process(CLK12MHZ)
    begin
        if rising_edge(CLK12MHZ) then
            if reset = '1' then
                state <= '0';
                bit_counter <= to_unsigned(0, bit_counter'length);
                baudrate_counter <= to_unsigned(0, baudrate_counter'length);
            else 
                baudrate_counter <= baudrate_counter +1;
                if baudrate_counter = 1249 then
                    state <= next_state;                                          -- change state from idle to transmit
                    baudrate_counter <= to_unsigned(0, baudrate_counter'length);  --reset baudrate counter
                    if load = '1' then
                        shiftright_register <= '1' & data & '1';                   --load data into register
                    end if;
                    if clear = '1' then
                        bit_counter <= to_unsigned(0, bit_counter'length);
                    end if;
                    if  shift = '1' then
                        shiftright_register <= std_logic_vector(shift_right(unsigned(shiftright_register), 1));
                    end if;
                    bit_counter <= bit_counter + 1;
                 end if;
            end if;
         end if;     
    end process uart;
    
    mealy: process(CLK12MHZ) 
    begin
        if rising_edge(CLK12MHZ) then
            load <= '0';
            shift <= '0';
            clear <= '0';
            uart_rxd_out <= '1';  
                     
            case (state) is
                when '0' =>
                    if transmit = '1' then
                        next_state <= '1';
                        load <= '1';
                        shift <= '0';
                        clear <= '0';
                    else
                        next_state <= '0';
                        uart_rxd_out <= '1';
                    end if;
                    
                when '1' =>
                    if bit_counter = 10 then
                        next_state <= '0';
                        clear <= '1';
                    else
                        next_state <= '1';
                        uart_rxd_out <= shiftright_register(0);
                        shift <= '1';         
                    end if;
            end case;   
        end if;
    end process mealy;                     
                

end Behavioral;