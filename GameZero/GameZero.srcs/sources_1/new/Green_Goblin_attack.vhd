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

entity Green_Goblin_attack is
    Port (
            frame_clk : in STD_LOGIC;
            enable : in STD_LOGIC;
            start : in std_logic;
            attack_reset : in std_logic;
            Wolvie_pos : in STD_LOGIC_VECTOR (18 downto 0);
            Wolvie_lives_in : in std_logic_vector(2 downto 0);
            GreenGoblin_pos : in STD_LOGIC_VECTOR (18 downto 0);
            GreenGoblin_reversed : in std_logic;
            Wolvie_lives_out : out std_logic_vector(2 downto 0);
            GreenGoblin_dec_disable : out STD_LOGIC;
            GreenGoblin_new_image : out STD_LOGIC_VECTOR (2 downto 0);
            Wolvie_attack_reset_out : out std_logic;
            Sbam_pos : out std_logic_vector(18 downto 0);
            Life_incr : in std_logic
       ); 
end Green_Goblin_attack;

architecture Behavioral of Green_Goblin_attack is

--general constants
constant WALL_WIDTH : natural := 20;
constant SCREEN_WIDTH : natural := 640;
constant SCREEN_HEIGHT : natural := 480;
constant PIXEL_INCREMENT : natural := 1;
constant PLAYER_SIZE : natural := 75;
constant PEDANA_WIDTH : natural := 200;

constant GG_ATTACK_FRAMES : natural := 10;
--constant MOV_IMG : natural := 5;
constant ATTACK_IMG : natural := 2;


-- signals
signal attack_enable : std_logic := '0';
signal attack_frame_cnt : natural range 0 to GG_ATTACK_FRAMES * ATTACK_IMG -1 := 0;  -- 4 is the number of frames for the attack
signal inRange : std_logic := '0';
signal Wolvie_attack_reset : std_logic := '0';

begin


-- Disabling the main decoder
GreenGoblin_dec_disable <= attack_enable;


process (frame_clk, enable)
begin
    if rising_edge(frame_clk) then
        if enable = '1' then
            attack_enable <= '1';
        elsif enable = '0' and attack_frame_cnt = GG_ATTACK_FRAMES * ATTACK_IMG -1 then
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
            if attack_frame_cnt = GG_ATTACK_FRAMES * ATTACK_IMG -1 then
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
        if start = '1' then
            Wolvie_lives_out <= "100";
        elsif Life_incr = '1'then
            Wolvie_lives_out <= Wolvie_lives_in + 1;    
        elsif attack_reset = '1' then
            GreenGoblin_new_image <= (others => '0');
        elsif attack_enable = '1' then
            if attack_frame_cnt < GG_ATTACK_FRAMES -1 then
                GreenGoblin_new_image <= "001";
            elsif attack_frame_cnt = GG_ATTACK_FRAMES -1 then
                GreenGoblin_new_image <= "010";
                if inRange = '1' then
                    Wolvie_lives_out <= Wolvie_lives_in -1;
                    -- Defining the position of the sbam image
                    Sbam_pos (18 downto 10) <= Wolvie_pos (18 downto 10) +13;
                    if GreenGoblin_reversed = '1' then
                        Sbam_pos(9 downto 0) <= GreenGoblin_pos(9 downto 0) - 15; 
                    else
                        Sbam_pos(9 downto 0) <= Wolvie_pos(9 downto 0) - 15;
                    end if;
                end if;
            elsif attack_frame_cnt = GG_ATTACK_FRAMES * ATTACK_IMG -1 then
                Sbam_pos <= (others => '0');
                GreenGoblin_new_image <= "000";
            end if;
        end if;
    end if;
end process;

inRange <= '1' when 
                    (Wolvie_pos (18 downto 10) >= GreenGoblin_pos (18 downto 10) - 40 and
                    Wolvie_pos (18 downto 10) <= GreenGoblin_pos (18 downto 10) + 40 and
                    Wolvie_pos (9 downto 0) >= GreenGoblin_pos (9 downto 0) - PLAYER_SIZE and
                    Wolvie_pos (9 downto 0) <= GreenGoblin_pos (9 downto 0) - PLAYER_SIZE +30 and
                    GreenGoblin_reversed = '1') or
                    (Wolvie_pos (18 downto 10) >= GreenGoblin_pos (18 downto 10) - 40 and
                    Wolvie_pos (18 downto 10) <= GreenGoblin_pos (18 downto 10) + 40 and
                    Wolvie_pos (9 downto 0) >= GreenGoblin_pos (9 downto 0) + PLAYER_SIZE -30 and
                    Wolvie_pos (9 downto 0) <= GreenGoblin_pos (9 downto 0) + PLAYER_SIZE and
                    GreenGoblin_reversed = '0')                  
           else '0';


Wolvie_attack_reset_out <= Wolvie_attack_reset;

end Behavioral;
