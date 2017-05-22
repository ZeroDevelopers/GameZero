----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.05.2017 15:44:07
-- Design Name: 
-- Module Name: Wolvie_attack - Behavioral
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

entity Wolvie_attack is
    Port (
            frame_clk : in STD_LOGIC;
            enable : in STD_LOGIC;
            attack_reset : in std_logic;
            GreenGoblin_pos : in STD_LOGIC_VECTOR (18 downto 0);
            Wolvie_pos : in STD_LOGIC_VECTOR (18 downto 0);
            Wolvie_reversed : in std_logic;
            Wolvie_curr_image : in STD_LOGIC_VECTOR (3 downto 0);
            Wolvie_dec_disable : out STD_LOGIC;
            Wolvie_new_image : out STD_LOGIC_VECTOR (3 downto 0);
            GreenGoblin_life_dec : out std_logic;
            GreenGoblin_attack_reset_out : out std_logic;
            Sbam_active_out : out std_logic
       );
end Wolvie_attack;

architecture Behavioral of Wolvie_attack is

--general constants
constant WALL_WIDTH : natural := 20;
constant SCREEN_WIDTH : natural := 640;
constant SCREEN_HEIGHT : natural := 480;
constant PIXEL_INCREMENT : natural := 1;
constant PLAYER_SIZE : natural := 75;
constant PEDANA_WIDTH : natural := 200;

constant W_ATTACK_FRAMES : natural := 5;
constant MOV_IMG : natural := 5;
constant ATTACK_IMG : natural := 4;


-- signals
signal attack_enable : std_logic := '0';
signal attack_frame_cnt : natural range 0 to W_ATTACK_FRAMES * 4 -1 := 0;  -- 4 is the number of frames for the attack
signal inRange : std_logic := '0';
signal GreenGoblin_hit, Sbam_active, GreenGoblin_attack_reset : std_logic := '0';

begin


-- Disabling the main decoder
Wolvie_dec_disable <= attack_enable;


process (frame_clk, enable)
begin
    if rising_edge(frame_clk) then
        if enable = '1' then
            attack_enable <= '1';
        elsif enable = '0' and attack_frame_cnt = W_ATTACK_FRAMES * 4 -1 then
            attack_enable <= '0';
        end if;
    end if;
end process;


-- Computing the attack counter
process(frame_clk, enable)
begin
   if rising_edge(frame_clk) then
        if attack_reset = '1' then
            attack_frame_cnt <= 0;
        end if;  
        if attack_enable = '1' then
            if attack_frame_cnt = W_ATTACK_FRAMES *4 -1 then
                attack_frame_cnt <= 0;
            else
                attack_frame_cnt <= attack_frame_cnt +1;               
            end if;
        end if;
    end if;
end process;

-- Process o define the new images
process(frame_clk, enable)
begin
   if rising_edge(frame_clk) then
        if attack_reset = '1' then
            Wolvie_new_image <= (others => '0');
        end if;  
        if attack_enable = '1' then
            if attack_frame_cnt < W_ATTACK_FRAMES -1 then
                Wolvie_new_image <= "0101";
            elsif attack_frame_cnt = W_ATTACK_FRAMES -1 then
                Wolvie_new_image <= "0110";
            elsif attack_frame_cnt = W_ATTACK_FRAMES *2 -1 then
                Wolvie_new_image <= "0111";
            elsif attack_frame_cnt = W_ATTACK_FRAMES *3 -1 then
                Wolvie_new_image <= "1000";
            elsif attack_frame_cnt = W_ATTACK_FRAMES *4 -1 then
                Wolvie_new_image <= "0000";                
            end if;
        end if;
    end if;
end process;

inRange <= '1' when (GreenGoblin_pos (18 downto 10) >= Wolvie_pos (18 downto 10) - 40 and
                    GreenGoblin_pos (18 downto 10) <= Wolvie_pos (18 downto 10) + 40 and
                    GreenGoblin_pos (9 downto 0) >= Wolvie_pos (9 downto 0) + PLAYER_SIZE and
                    GreenGoblin_pos (9 downto 0) <= Wolvie_pos (9 downto 0) + PLAYER_SIZE - 20 and
                    Wolvie_reversed = '0')  or
                    (GreenGoblin_pos (18 downto 10) >= Wolvie_pos (18 downto 10) - 40 and
                    GreenGoblin_pos (18 downto 10) <= Wolvie_pos (18 downto 10) + 40 and
                    GreenGoblin_pos (9 downto 0) >= Wolvie_pos (9 downto 0) - 20 and
                    GreenGoblin_pos (9 downto 0) <= Wolvie_pos (9 downto 0) and
                    Wolvie_reversed = '1')                   
           else '0';

process (frame_clk, GreenGoblin_pos)
begin
    if rising_edge(frame_clk) then
        if GreenGoblin_hit = '1' then
            GreenGoblin_hit <= '0';
        elsif Sbam_active = '1' and attack_frame_cnt = W_ATTACK_FRAMES *4 -1 then
            Sbam_active <= '0';
        elsif GreenGoblin_attack_reset = '1' then
            GreenGoblin_attack_reset <= '0';
        elsif attack_frame_cnt >= W_ATTACK_FRAMES * 2  and  inRange = '1' then
            GreenGoblin_hit <= '1';
            Sbam_active <= '1';
            GreenGoblin_attack_reset <= '1';
        end if;  
    end if;
end process;

sbam_active_out <= Sbam_active;
GreenGoblin_life_dec <= GreenGoblin_hit;
GreenGoblin_attack_reset_out <= GreenGoblin_attack_reset;

end Behavioral;
