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
            reset : in std_logic;
            movement_type: in STD_LOGIC_VECTOR (1 downto 0);
            GreenGoblin_pos, Pedana1_pos, Pedana2_pos, Pedana3_pos : in STD_LOGIC_VECTOR (18 downto 0);
            Wolvie_curr_pos : in STD_LOGIC_VECTOR (18 downto 0);
            Wolvie_curr_image : in STD_LOGIC_VECTOR (3 downto 0);
            dec_disable : out STD_LOGIC;
            Wolvie_reversed_in : in STD_LOGIC;
            Wolvie_reversed_out : out STD_LOGIC;
            Wolvie_hor_new_pos : out STD_LOGIC_VECTOR (9 downto 0);
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
constant MOVEMENT_FRAMES : natural := 4;

constant WOLVIE_START_HOR_POS : std_logic_vector(9 downto 0) := "0101111110";


--constants for mapping movement
constant RIGHT : STD_LOGIC_VECTOR (1 downto 0) := "00";
constant LEFT : STD_LOGIC_VECTOR (1 downto 0) := "01";

-- Signals for Wolverine
constant W_ACTION_FRAMES : natural := 10;
signal W_action_cnt : natural range 0 to W_ACTION_FRAMES -1;


--enables for movements
signal movement_enable : STD_LOGIC := '0';
signal right_enable : STD_LOGIC := '0';
signal left_enable : STD_LOGIC := '0'; 


begin

--this process creates the movement enabler

process(enable, Wolvie_curr_image)
begin 
        if enable = '1' then
            movement_enable <= '1';
        elsif enable = '0' AND  W_action_cnt = W_ACTION_FRAMES -1 then
            movement_enable <= '0';
        end if;
end process;





--manage reversed, image and new position of wolverine
process(frame_clk, movement_type, movement_enable)
begin
        if rising_edge(frame_clk) then
            if reset = '0' then
                Wolvie_hor_new_pos <= WOLVIE_START_HOR_POS;
            elsif movement_type = RIGHT and right_enable = '1' AND movement_enable = '1' then
                Wolvie_hor_new_pos <= Wolvie_curr_pos (9 downto 0)+ PIXEL_INCREMENT;
                Wolvie_reversed_out <= '0';
            elsif movement_type = LEFT and left_enable = '1' AND movement_enable = '1' then
                Wolvie_hor_new_pos <= Wolvie_curr_pos (9 downto 0)- PIXEL_INCREMENT;
                Wolvie_reversed_out <= '1';
            end if;
        end if;
end process;

--enables for moving left, right

left_enable <=  '0' when Wolvie_curr_pos (9 downto 0) - PIXEL_INCREMENT = WALL_WIDTH OR 
                         Wolvie_curr_pos (9 downto 0)  = 0 OR 
                         (Wolvie_curr_pos (9 downto 0) - PIXEL_INCREMENT <= GreenGoblin_pos (9 downto 0) + PLAYER_SIZE AND
                          Wolvie_curr_pos (9 downto 0) - PIXEL_INCREMENT >= GreenGoblin_pos (9 downto 0) AND 
                          Wolvie_curr_pos (18 downto 10) + PLAYER_SIZE >= GreenGoblin_pos (18 downto 10) AND
                          Wolvie_curr_pos (18 downto 10) + PLAYER_SIZE <= GreenGoblin_pos (18 downto 10) + PLAYER_SIZE) OR
                         (Wolvie_curr_pos (9 downto 0) - PIXEL_INCREMENT <= GreenGoblin_pos (9 downto 0) + PLAYER_SIZE AND 
                          Wolvie_curr_pos (9 downto 0) - PIXEL_INCREMENT >= GreenGoblin_pos (9 downto 0) AND
                          Wolvie_curr_pos (18 downto 10) <= GreenGoblin_pos (18 downto 10) + PLAYER_SIZE AND
                          Wolvie_curr_pos (18 downto 10) >= GreenGoblin_pos (18 downto 10)) 
                    else '1';    

right_enable <=  '0' when Wolvie_curr_pos (9 downto 0) + PLAYER_SIZE + PIXEL_INCREMENT >= 640 - WALL_WIDTH OR 
                          (Wolvie_curr_pos (9 downto 0) + PIXEL_INCREMENT >= GreenGoblin_pos (9 downto 0) AND 
                           Wolvie_curr_pos (9 downto 0) + PIXEL_INCREMENT <= GreenGoblin_pos (9 downto 0) + PLAYER_SIZE AND 
                           Wolvie_curr_pos (18 downto 10) + PLAYER_SIZE >= GreenGoblin_pos (18 downto 10) AND
                           Wolvie_curr_pos (18 downto 10) + PLAYER_SIZE <= GreenGoblin_pos (18 downto 10) + PLAYER_SIZE) OR
                          (Wolvie_curr_pos (9 downto 0) + PLAYER_SIZE + PIXEL_INCREMENT >= GreenGoblin_pos (9 downto 0) AND 
                           Wolvie_curr_pos (9 downto 0) + PIXEL_INCREMENT <= GreenGoblin_pos (9 downto 0) + PLAYER_SIZE AND
                           Wolvie_curr_pos (18 downto 10) <= GreenGoblin_pos (18 downto 10) + PLAYER_SIZE AND
                           Wolvie_curr_pos (18 downto 10) >= GreenGoblin_pos (18 downto 10)) 
                     else '1';    

--process to modify the image of wolverine in movement

process(frame_clk, enable)
begin
       if rising_edge(frame_clk) then    
            if movement_enable = '1' then
                if W_action_cnt = W_ACTION_FRAMES -1 then
                    W_action_cnt <= 0;
                    if Wolvie_curr_image + 1 < MOVEMENT_FRAMES then
                        Wolvie_new_image <= Wolvie_curr_image + 1;
                    else
                        Wolvie_new_image <= (others => '0');    
                    end if;
                else
                    W_action_cnt <= W_action_cnt +1;    
                end if;
            end if;
        end if;
end process;


dec_disable <= movement_enable;

end Behavioral;