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

entity Green_Goblin_jump is
    Port (
          frame_clk : in STD_LOGIC;  
          enable : in STD_LOGIC;
          reset : in std_logic;
          GreenGoblin_curr_pos : in STD_LOGIC_VECTOR (18 downto 0);
          GreenGoblin_vert_new_pos : out STD_LOGIC_VECTOR (8 downto 0);
          GreenGoblin_new_image : out STD_LOGIC_VECTOR (2 downto 0);
          GreenGoblin_status : out STD_LOGIC;
          Wolvie_pos : in STD_LOGIC_VECTOR (18 downto 0);
          Pedana1_pos : in std_logic_vector (18 downto 0);  
          Pedana1_image : in std_logic_vector (1 downto 0);
          Pedana2_pos : in std_logic_vector (18 downto 0);
          Pedana2_image : in std_logic_vector (1 downto 0);
          Pedana3_pos : in std_logic_vector (18 downto 0);
          Pedana3_image : in std_logic_vector (1 downto 0)
    );
end Green_Goblin_jump;


architecture Behavioral of Green_Goblin_jump is

--general constants
constant WALL_WIDTH : natural := 20;
constant SCREEN_WIDTH : natural := 640;
constant SCREEN_HEIGHT : natural := 480;
constant PIXEL_INCREMENT : natural := 1;
constant PLAYER_SIZE : natural := 75;
constant PEDANA_WIDTH : natural := 200;
constant PEDANA_HEIGHT : natural :=100;
constant MOVEMENT_FRAMES : natural := 4;

constant GG_START_VERT_POS : std_logic_vector(8 downto 0) := "110000000";

-- Signals for GreenGoblin
constant GG_ACTION_FRAMES : natural := 100;
signal GG_action_cnt : natural range 0 to GG_ACTION_FRAMES -1;


signal jump_enable : STD_LOGIC := '0';
signal rising : STD_LOGIC := '0';
signal descending : STD_LOGIC := '0';


begin


process(enable, frame_clk)
begin   
        if rising_edge(frame_clk) then
            if GG_action_cnt = GG_ACTION_FRAMES -1 then
                GG_action_cnt <= 0;
                jump_enable <= '0';
            else    
                if enable = '1' then
                    jump_enable <= '1';
                end if;
            GreenGoblin_new_image <= "000";    
            GG_action_cnt <= GG_action_cnt + 1;
            end if;
        end if;
end process;


-- process to move upward or downward greengoblin
process(frame_clk, jump_enable)
begin
        if rising_edge(frame_clk)  then
            if reset = '0' then
                GreenGoblin_vert_new_pos <= GG_START_VERT_POS;
            elsif rising = '1' AND jump_enable = '1' then
                GreenGoblin_vert_new_pos (8 downto 0) <= GreenGoblin_curr_pos (18 downto 10) - 2*PIXEL_INCREMENT;
            elsif descending = '1' then
                GreenGoblin_vert_new_pos (8 downto 0) <= GreenGoblin_curr_pos (18 downto 10) + PIXEL_INCREMENT;
            end if;
        end if;
end process;


rising <= '1' when jump_enable = '1' AND 
                   GreenGoblin_curr_pos (18 downto 10) - 2 > WALL_WIDTH AND
                   GreenGoblin_curr_pos (18 downto 10) -2 > 0
              else '0';  


descending <= '0' when  ((GreenGoblin_curr_pos (18 downto 10) + PLAYER_SIZE = Pedana1_pos (18 downto 10) + PEDANA_HEIGHT - 25) AND (GreenGoblin_curr_pos (9 downto 0) + PLAYER_SIZE/2 < Pedana1_pos (9 downto 0) + PEDANA_WIDTH +1) AND (GreenGoblin_curr_pos (9 downto 0) + PLAYER_SIZE/5 > Pedana1_pos (9 downto 0) -1) AND Pedana1_image = "10")OR
                        ((GreenGoblin_curr_pos (18 downto 10) + PLAYER_SIZE = Pedana2_pos (18 downto 10) + PEDANA_HEIGHT - 25) AND (GreenGoblin_curr_pos (9 downto 0) + PLAYER_SIZE/2 < Pedana2_pos (9 downto 0) + PEDANA_WIDTH +1) AND (GreenGoblin_curr_pos (9 downto 0) + PLAYER_SIZE/5 > Pedana2_pos (9 downto 0) -1)  AND Pedana2_image = "10")OR
                        ((GreenGoblin_curr_pos (18 downto 10) + PLAYER_SIZE = Pedana3_pos (18 downto 10) + PEDANA_HEIGHT - 25) AND (GreenGoblin_curr_pos (9 downto 0) + PLAYER_SIZE/2 < Pedana3_pos (9 downto 0) + PEDANA_WIDTH +1) AND (GreenGoblin_curr_pos (9 downto 0) + PLAYER_SIZE/5 > Pedana3_pos (9 downto 0) -1) AND Pedana3_image = "10")OR
                        (GreenGoblin_curr_pos (18 downto 10) + PLAYER_SIZE = SCREEN_HEIGHT -WALL_WIDTH)OR
                        (GreenGoblin_curr_pos (18 downto 10) + PLAYER_SIZE = Wolvie_pos (18 downto 10) -1 AND GreenGoblin_curr_pos (9 downto 0) >= Wolvie_pos (9 downto 0) +20 AND GreenGoblin_curr_pos (9 downto 0) <= Wolvie_pos (9 downto 0)+ PLAYER_SIZE -20)
                  else '1';
                  
GreenGoblin_status <= rising OR descending;


end Behavioral;
