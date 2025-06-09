----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/01/2025 12:58:59 AM
-- Design Name: 
-- Module Name: Top - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top is
    Port ( CLK12MHZ       : in  std_logic ;
           btn            : in  STD_LOGIC_Vector(3 downto 0);
           uart_rxd_out   : out std_logic ;
           uart_txd_in    : in std_logic  ;
           led            : out std_logic_vector(3 downto 0)  --0 = button debounce
           
              );
end Top;

architecture Behavioral of Top is
    signal transmit_out : std_logic;
    signal transmit     : std_logic;
    signal data         : std_logic_vector(7 downto 0) := "10000010";
    signal data_out     : std_logic_vector(7 downto 0) := "00000000";
    signal reset        : std_logic;
    signal data_ready   : std_logic;
--    signal transmit_on  : std_logic := '1';
    signal backup_led   : STD_LOGIC_Vector(3 downto 0);
    
    component debounce
        Port (
            CLK12MHZ : in  std_logic;
            btn      : in  std_logic;
            transmit : out std_logic;
            debug_led     : out std_logic
        );
    end component;

    component uart_transmit2
        Port (
            CLK12MHZ : in  std_logic;
            data     : in  std_logic_vector(7 downto 0);
            transmit : in  std_logic;
            reset    : in std_logic;
            uart_rxd_out : out std_logic
        );
    end component;
    
    component uart_receive
        Port (
            CLK12MHZ : in  std_logic;
            data_out     : out std_logic_vector(7 downto 0);
            data_ready   : out std_logic;
            reset    : in std_logic;
            uart_txd_in  : in  std_logic;
            debug_led     : out std_logic_vector(3 downto 0)
        );
    end component;
    


begin

    -- Debounce module
    debounce_transmit : debounce
        port map (
            CLK12MHZ   => CLK12MHZ,
            btn        => btn(0),
            transmit   => led(3),
            -- transmit => transmit,
            debug_led  => backup_led(0)
        );
    
    debounce_reset : debounce
        port map (
            CLK12MHZ   => CLK12MHZ,
            btn        => btn(1),
            transmit   => reset,
            debug_led  => backup_led(1)
        );

    -- UART transmitter
    uart_inst : uart_transmit2
        port map (
            CLK12MHZ => CLK12MHZ,
            data     => data,
            transmit => transmit,
            reset    => reset,
            uart_rxd_out       => uart_rxd_out 
        );
        
     uart_rec : uart_receive
        port map (
            CLK12MHZ     => CLK12MHZ,
            data_out     => data_out,
            data_ready   => data_ready,
            reset        => reset,
            uart_txd_in  => uart_txd_in,
            debug_led    => led
        
        );
        
     process(CLK12MHZ)
     begin
            if rising_edge(CLK12MHZ) then
                   if data_ready = '1' then
                         data <= data_out;  -- forward received byte
                         transmit <= '1';     -- trigger transmit
                         backup_led(2) <= '1';
                    else
                         transmit <= '0';
                         backup_led(2) <= '0';
                    end if;
            end if;
      end process;



end Behavioral;
