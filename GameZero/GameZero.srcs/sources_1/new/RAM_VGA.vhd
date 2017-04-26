----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2017 17:26:12
-- Design Name: 
-- Module Name: RAM_VGA - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM_VGA is
port(
     clk   : in  std_logic;
     wen   : in  std_logic;
     datain  : in  std_logic_vector(11 downto 0);
     waddress  : in  std_logic_vector(18 downto 0);
     raddress  : in  std_logic_vector(18 downto 0);
     pixel : out std_logic_vector(11 downto 0)
     );
end entity RAM_VGA;

architecture Behavioral of RAM_VGA is

type ram is array (307199 downto 0) of std_logic_vector (11 downto 0);
signal BRAM : ram;

component BRAM_VGA_Clock
    PORT(
      clk_out1: out STD_LOGIC;
      reset: in STD_LOGIC;
      locked: out STD_LOGIC;
      clk_in1: in STD_LOGIC
    );
end component;

signal RAM_clk : STD_LOGIC := '0';

begin

--clock for the ram, freq should be twice the one of the vga (25MHZ)
inst_BRAM_VGA_Clock : BRAM_VGA_Clock
port map 
    (   clk_in1 => clk,
        clk_out1 => RAM_clk,
        locked => open,
        reset => '0'
     );


    
    
process(RAM_clk, wen)
begin
        if rising_edge(RAM_clk) then 
            if wen = '1' then
               BRAM(conv_integer(waddress)) <= datain;	 
            end if;
         end if;   
end process;

pixel <= BRAM(conv_integer(raddress));

end Behavioral;
