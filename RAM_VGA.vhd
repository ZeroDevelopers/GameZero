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
     pixel_out : out std_logic_vector(11 downto 0)
     );
end entity RAM_VGA;

architecture Behavioral of RAM_VGA is

type ram_row is array (0 to 639) of std_logic_vector (11 downto 0);
type ram is array(0 to 479) of ram_row;

signal row_w, row_r : ram_row;
signal BRAM : ram;


begin
    
process(clk, wen)
begin
        if rising_edge(clk) then 
            if wen = '1' then
               row_w <= BRAM(conv_integer(waddress(18 downto 10)));
               row_w(conv_integer(waddress(9 downto 0))) <= datain;
            end if;
         end if;   
end process;

row_r <= BRAM(conv_integer(raddress(18 downto 10)));
pixel_out <= row_r(conv_integer(raddress(9 downto 0)));
                     
end Behavioral;
