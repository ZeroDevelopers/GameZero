----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.05.2017 12:03:02
-- Design Name: 
-- Module Name: Wolverine_movement - Behavioral
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

entity Wolverine_movement is
      Port (
            frame_clk : in STD_LOGIC;
            enable : in STD_LOGIC;
            movement_type: in STD_LOGIC_VECTOR (1 downto 0);
            GreenGoblin_pos, Pedana1_pos, Pedana2_pos, Pedana3_pos : in STD_LOGIC_VECTOR (18 downto 0);
            Wolvie_curr_pos : in STD_LOGIC_VECTOR (18 downto 0);
            Wolvie_curr_image : in STD_LOGIC_VECTOR (3 downto 0);
            dec_disable : out STD_LOGIC;
            Wolvie_reversed : out STD_LOGIC;
            Wolvie_new_pos : out STD_LOGIC_VECTOR (18 downto 0);
            Wolvie_new_image : out STD_LOGIC_VECTOR (3 downto 0)
       );
end Wolverine_movement;

architecture Behavioral of Wolverine_movement is

--general constants
constant WALL_WIDTH : natural := 20;
constant SCREEN_WIDTH : natural := 640;
constant SCREEN_HEIGHT : natural := 480;
constant PIXEL_INCREMENT : natural := 1;
constant PLAYER_SIZE : natural := 75;
constant PEDANA_WIDTH : natural := 200;



--constants for mapping movement
constant RIGHT : STD_LOGIC_VECTOR (1 downto 0) := "00";
constant LEFT : STD_LOGIC_VECTOR (1 downto 0) := "01";
constant JUMP : STD_LOGIC_VECTOR (1 downto 0) := "10";



--temporary position
signal Wolvie_tmp_pos : STD_LOGIC_VECTOR (18 downto 0); 

--enables for movements
signal right_enable, left_enable, jump_enable : STD_LOGIC;


begin

--manage reversed, image and new position of wolverine
process(frame_clk, movement_type, enable)
begin
        if rising_edge(frame_clk) AND enable = '1' then
            --Wolvie_tmp_pos <= Wolvie_curr_pos;
            if movement_type = RIGHT and right_enable = '1' then
                Wolvie_new_pos <= Wolvie_curr_pos + PIXEL_INCREMENT;
                Wolvie_reversed <= '0';
            elsif movement_type = LEFT and left_enable = '1' then
                Wolvie_new_pos <= Wolvie_curr_pos - PIXEL_INCREMENT;
                Wolvie_reversed <= '1';
            elsif movement_type = JUMP and jump_enable = '1' then 
                Wolvie_new_pos (18 downto 10) <= Wolvie_curr_pos (18 downto 10) + PIXEL_INCREMENT;
            end if;
        end if;
end process;

left_enable <=  '1' when Wolvie_curr_pos (9 downto 0) - PIXEL_INCREMENT >= WALL_WIDTH AND 
                         (Wolvie_curr_pos (9 downto 0) - PIXEL_INCREMENT >= GreenGoblin_pos (9 downto 0) + PLAYER_SIZE OR 
                         Wolvie_curr_pos (18 downto 10) + PLAYER_SIZE <= GreenGoblin_pos (18 downto 10) OR 
                         Wolvie_curr_pos (18 downto 10) - PLAYER_SIZE >= GreenGoblin_pos (18 downto 10)) AND
                        
                    else '0';    





end Behavioral;
