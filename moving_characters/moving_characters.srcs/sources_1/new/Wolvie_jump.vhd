----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.05.2017 15:39:56
-- Design Name: 
-- Module Name: Wolvie_jump - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Wolvie_jump is
    Port (
          frame_clk : in STD_LOGIC;  
          enable : in STD_LOGIC;
          Wolvie_curr_pos : in STD_LOGIC_VECTOR (18 downto 0);
          Wolvie_curr_image : in STD_LOGIC_VECTOR (3 downto 0);
          Wolvie_new_pos : out STD_LOGIC_VECTOR (18 downto 0);
          Wolvie_new_image : out STD_LOGIC_VECTOR (3 downto 0);
          Pedana1_pos : in std_logic_vector (18 downto 0);  
          Pedana1_image : in std_logic_vector (1 downto 0);
          Pedana2_pos : in std_logic_vector (18 downto 0);
          Pedana2_image : in std_logic_vector (1 downto 0);
          Pedana3_pos : in std_logic_vector (18 downto 0);
          Pedana3_image : in std_logic_vector (1 downto 0)
    );
end Wolvie_jump;

architecture Behavioral of Wolvie_jump is

signal jump_enable : STD_LOGIC;
signal rising : STD_LOGIC;
signal descending : STD_LOGIC;

begin


process(enable)
begin
        if enable = '1' then
            jump_enable <= '1';
        end if;
end process;


-- process to move upward or downward wolverine
process(frame_clk, jump_enable)
begin
        if rising_edge(frame_clk)  then
            if rising = '1' AND jump_enable = '1' then
                Wolvie_new_pos (18 downto 10) <= Wolvie_curr_pos (18 downto 10) + 1;
            elsif descending = '1' then
                Wolvie_new_pos (18 downto 10) <= Wolvie_curr_pos (18 downto 10) - 1;
            end if;
        end if;
end process;


rising <= '1' when 
              else '0';  


descending <= '1' when
                  else '0';

end Behavioral;
