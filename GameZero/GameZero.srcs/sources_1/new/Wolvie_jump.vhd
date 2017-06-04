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
          Wolvie_vert_new_pos : out STD_LOGIC_VECTOR (8 downto 0);
          Wolvie_new_image : out STD_LOGIC_VECTOR (3 downto 0);
          Wolvie_status : out STD_LOGIC;
          GreenGoblin_pos : in STD_LOGIC_VECTOR (18 downto 0);
          Pedana1_pos : in std_logic_vector (18 downto 0);  
          Pedana1_image : in std_logic_vector (1 downto 0);
          Pedana2_pos : in std_logic_vector (18 downto 0);
          Pedana2_image : in std_logic_vector (1 downto 0);
          Pedana3_pos : in std_logic_vector (18 downto 0);
          Pedana3_image : in std_logic_vector (1 downto 0)
    );
end Wolvie_jump;

architecture Behavioral of Wolvie_jump is

--general constants
constant WALL_WIDTH : natural := 20;
constant SCREEN_WIDTH : natural := 640;
constant SCREEN_HEIGHT : natural := 480;
constant PIXEL_INCREMENT : natural := 1;
constant PLAYER_SIZE : natural := 75;
constant PEDANA_WIDTH : natural := 200;
constant PEDANA_HEIGHT : natural :=100;
constant MOVEMENT_FRAMES : natural := 4;

-- Signals for Wolverine
constant W_ACTION_FRAMES : natural := 100;
signal W_action_cnt : natural range 0 to W_ACTION_FRAMES -1;


signal jump_enable : STD_LOGIC := '0';
signal rising : STD_LOGIC := '0';
signal descending : STD_LOGIC := '0';


begin


process(enable)
begin
        if enable = '1' then
            jump_enable <= '1';
        elsif W_action_cnt = W_ACTION_FRAMES -1 then
            jump_enable <= '0';
        end if;
end process;


-- process to move upward or downward wolverine
process(frame_clk, jump_enable)
begin
        if rising_edge(frame_clk)  then
            if rising = '1' AND jump_enable = '1' then
                Wolvie_vert_new_pos (8 downto 0) <= Wolvie_curr_pos (18 downto 10) - 2*PIXEL_INCREMENT;
            elsif descending = '1' then
                Wolvie_vert_new_pos (8 downto 0) <= Wolvie_curr_pos (18 downto 10) + PIXEL_INCREMENT;
            end if;
        end if;
end process;


rising <= '1' when jump_enable = '1' AND 
                   Wolvie_curr_pos (18 downto 10) - 2 > WALL_WIDTH AND
                   Wolvie_curr_pos (18 downto 10) -2 > 0
              else '0';  


descending <= '0' when  ((Wolvie_curr_pos (18 downto 10) + PLAYER_SIZE = Pedana1_pos (18 downto 10) + PEDANA_HEIGHT - 25) AND (Wolvie_curr_pos (9 downto 0) < Pedana1_pos (9 downto 0) + PEDANA_WIDTH +1) AND (Wolvie_curr_pos (9 downto 0) > Pedana1_pos (9 downto 0) -1) AND Pedana1_image = "10")OR
                        ((Wolvie_curr_pos (18 downto 10) + PLAYER_SIZE = Pedana2_pos (18 downto 10) + PEDANA_HEIGHT - 25) AND (Wolvie_curr_pos (9 downto 0) < Pedana2_pos (9 downto 0) + PEDANA_WIDTH +1) AND (Wolvie_curr_pos (9 downto 0) > Pedana2_pos (9 downto 0) -1)  AND Pedana2_image = "10")OR
                        ((Wolvie_curr_pos (18 downto 10) + PLAYER_SIZE = Pedana3_pos (18 downto 10) + PEDANA_HEIGHT - 25) AND (Wolvie_curr_pos (9 downto 0) < Pedana3_pos (9 downto 0) + PEDANA_WIDTH +1) AND (Wolvie_curr_pos (9 downto 0) > Pedana3_pos (9 downto 0) -1) AND Pedana3_image = "10")OR
                        (Wolvie_curr_pos (18 downto 10) + PLAYER_SIZE = SCREEN_HEIGHT -WALL_WIDTH)OR
                        (Wolvie_curr_pos (18 downto 10) + PLAYER_SIZE = GreenGoblin_pos (18 downto 10) AND Wolvie_curr_pos (9 downto 0) >= GreenGoblin_pos (9 downto 0) AND Wolvie_curr_pos (9 downto 0) <= GreenGoblin_pos (9 downto 0)+ PLAYER_SIZE)
                  else '1';
                  
Wolvie_status <= rising OR descending;

--process for the jumping image of wolverine

process(frame_clk)
begin
        if rising_edge(frame_clk) then
            if  W_action_cnt = W_ACTION_FRAMES -1 then
                 W_action_cnt <= 0;
            else
                if W_action_cnt = 0 then
                    Wolvie_new_image <= "1001";
                end if;
                W_action_cnt <= W_action_cnt + 1;    
                if Wolvie_curr_image = "1001" then
                    Wolvie_new_image <= "1010";
                elsif Wolvie_curr_image = "1010" OR Wolvie_curr_image = "1011" then
                    Wolvie_new_image <= "1011";
                end if;
            end if;    
        end if;
end process;

end Behavioral;
