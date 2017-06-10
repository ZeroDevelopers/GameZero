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

entity Green_Goblin_movement is
      Port (
            frame_clk : in STD_LOGIC;
            enable : in STD_LOGIC;
            reset : in std_logic;
            movement_type: in STD_LOGIC_VECTOR (1 downto 0);
            Wolvie_pos : in STD_LOGIC_VECTOR (18 downto 0);
            Green_Goblin_curr_pos : in STD_LOGIC_VECTOR (18 downto 0);
            Green_Goblin_curr_image : in STD_LOGIC_VECTOR (2 downto 0);
            dec_disable : out STD_LOGIC;
            Green_Goblin_reversed_in : in STD_LOGIC;
            Green_Goblin_reversed_out : out STD_LOGIC;
            Green_Goblin_hor_new_pos : out STD_LOGIC_VECTOR (9 downto 0);
            Green_Goblin_new_image : out STD_LOGIC_VECTOR (2 downto 0)
       );
end Green_Goblin_movement;


architecture Behavioral of Green_Goblin_movement is

--general constants
constant WALL_WIDTH : natural := 20;
constant SCREEN_WIDTH : natural := 640;
constant SCREEN_HEIGHT : natural := 480;
constant PIXEL_INCREMENT : natural := 1;
constant PLAYER_SIZE : natural := 75;
constant PEDANA_WIDTH : natural := 200;
constant MOVEMENT_FRAMES : natural := 4;

constant GG_START_HOR_POS : std_logic_vector(9 downto 0) := "0111101111";


--constants for mapping movement
constant RIGHT : STD_LOGIC_VECTOR (1 downto 0) := "00";
constant LEFT : STD_LOGIC_VECTOR (1 downto 0) := "01";

-- Signals for GreenGoblin
constant GG_ACTION_FRAMES : natural := 10;
signal GG_action_cnt : natural range 0 to GG_ACTION_FRAMES -1;


--enables for movements
signal movement_enable : STD_LOGIC := '0';
signal right_enable : STD_LOGIC := '0';
signal left_enable : STD_LOGIC := '0'; 




begin

--this process creates the movement enabler

process(enable, Green_Goblin_curr_image, GG_action_cnt, frame_clk)
begin 
        if rising_edge(frame_clk) then   
            if enable = '1' then    
                movement_enable <= '1';
                GG_action_cnt <= 0;
            elsif enable = '0' AND  GG_action_cnt = GG_ACTION_FRAMES -1 then
                movement_enable <= '0';
                GG_action_cnt <= 0;
            end if;
            GG_action_cnt <= GG_action_cnt +1;
        end if;
end process;


--manage reversed, image and new position of greengoblin
process(frame_clk, movement_type, movement_enable)
begin
        if rising_edge(frame_clk) AND movement_enable = '1' then
            if reset = '0' then
                Green_Goblin_hor_new_pos <= GG_START_HOR_POS;
                Green_Goblin_reversed_out <= '1';
            elsif movement_type = RIGHT and right_enable = '1' then
                Green_Goblin_hor_new_pos <= Green_Goblin_curr_pos (9 downto 0)+ PIXEL_INCREMENT;
                Green_Goblin_reversed_out <= '0';
                Green_Goblin_new_image <= "000";
            elsif movement_type = LEFT and left_enable = '1' then
                Green_Goblin_hor_new_pos <= Green_Goblin_curr_pos (9 downto 0)- PIXEL_INCREMENT;
                Green_Goblin_reversed_out <= '1';
                Green_Goblin_new_image <= "000";
            end if;
        end if;
end process;

--enables for moving left, right

left_enable <=  '0' when Green_Goblin_curr_pos (9 downto 0) - PIXEL_INCREMENT = WALL_WIDTH OR 
                         Green_Goblin_curr_pos (9 downto 0)  = 0 OR 
                         (Green_Goblin_curr_pos (9 downto 0) - PIXEL_INCREMENT <= Wolvie_pos (9 downto 0) + PLAYER_SIZE - 20 AND
                          Green_Goblin_curr_pos (9 downto 0) - PIXEL_INCREMENT >= Wolvie_pos (9 downto 0) +20 AND 
                          Green_Goblin_curr_pos (18 downto 10) + PLAYER_SIZE >= Wolvie_pos (18 downto 10) AND
                          Green_Goblin_curr_pos (18 downto 10) + PLAYER_SIZE <= Wolvie_pos (18 downto 10) + PLAYER_SIZE) OR
                         (Green_Goblin_curr_pos (9 downto 0) - PIXEL_INCREMENT <= Wolvie_pos (9 downto 0) + PLAYER_SIZE - 20 AND 
                          Green_Goblin_curr_pos (9 downto 0) - PIXEL_INCREMENT >= Wolvie_pos (9 downto 0) +20 AND
                          Green_Goblin_curr_pos (18 downto 10) <= Wolvie_pos (18 downto 10) + PLAYER_SIZE AND
                          Green_Goblin_curr_pos (18 downto 10) >= Wolvie_pos (18 downto 10)) 
                    else '1';    

right_enable <=  '0' when Green_Goblin_curr_pos (9 downto 0) + PLAYER_SIZE + PIXEL_INCREMENT = 640 - WALL_WIDTH OR 
                          (Green_Goblin_curr_pos (9 downto 0) + PIXEL_INCREMENT >= Wolvie_pos (9 downto 0) +20 AND 
                           Green_Goblin_curr_pos (9 downto 0) + PIXEL_INCREMENT <= Wolvie_pos (9 downto 0) + PLAYER_SIZE - 20 AND 
                           Green_Goblin_curr_pos (18 downto 10) + PLAYER_SIZE >= Wolvie_pos (18 downto 10) AND
                           Green_Goblin_curr_pos (18 downto 10) + PLAYER_SIZE <= Wolvie_pos (18 downto 10) + PLAYER_SIZE) OR
                          (Green_Goblin_curr_pos (9 downto 0) + PLAYER_SIZE + PIXEL_INCREMENT >= Wolvie_pos (9 downto 0) +20 AND 
                           Green_Goblin_curr_pos (9 downto 0) + PIXEL_INCREMENT <= Wolvie_pos (9 downto 0) + PLAYER_SIZE - 20 AND
                           Green_Goblin_curr_pos (18 downto 10) <= Wolvie_pos (18 downto 10) + PLAYER_SIZE AND
                           Green_Goblin_curr_pos (18 downto 10) >= Wolvie_pos (18 downto 10)) 
                     else '1';    

dec_disable <= movement_enable;

end Behavioral;
