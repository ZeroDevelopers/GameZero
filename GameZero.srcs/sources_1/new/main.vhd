----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.04.2017 12:32:33
-- Design Name: 
-- Module Name: main - Behavioral
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


entity main is
    Port (  clk : in STD_LOGIC;
            red : out STD_LOGIC_VECTOR (3 downto 0);
            green : out STD_LOGIC_VECTOR (3 downto 0);
            blue : out STD_LOGIC_vector (3 downto 0);
            HS : out STD_LOGIC;
            VS : out STD_LOGIC
            );
end main;

architecture Behavioral of main is

component graphic is
    Port (  pixel_clk : in STD_LOGIC;
            GreenGoblin_pos : in std_logic_vector (18 downto 0);
            GreenGoblin_reversed : in std_logic;
            GreenGoblin_image : in std_logic_vector (2 downto 0);
            Wolvie_pos : in std_logic_vector (18 downto 0);
            Wolvie_reversed : in std_logic;
            Wolvie_image : in std_logic_vector (3 downto 0); -- The corresponding image from which we have to extract the pixels
            Pedana1_pos : in std_logic_vector (18 downto 0);  -- All the positions and frames of the "Pedana"
            Pedana1_image : in std_logic_vector (1 downto 0);
            Pedana2_pos : in std_logic_vector (18 downto 0);
            Pedana2_image : in std_logic_vector (1 downto 0);
            Pedana3_pos : in std_logic_vector (18 downto 0);
            Pedana3_image : in std_logic_vector (1 downto 0);
            red : out STD_LOGIC_VECTOR (3 downto 0);
            green : out STD_LOGIC_VECTOR (3 downto 0);
            blue : out STD_LOGIC_vector (3 downto 0);
            HS : out STD_LOGIC;
            VS : out STD_LOGIC
    );
end component;

component pixelClkGen is
Port (  clk_in1 : in std_logic;
        clk_out1 : out std_logic
      );
end component;


--Constants
constant WALL_WIDTH : natural := 20;
constant PLAYER_SIZE : natural := 64;
constant FIRE_SIZE : natural := 20;
constant DELAY : natural := 1;
constant SCREEN_WIDTH : natural := 640;
constant SCREEN_HEIGHT : natural := 480;


-- signals to create the FRAME_CLOCK
constant FRAME_PIXELS : natural := 420000;
signal frame_clk_cnt : natural range 0 to FRAME_PIXELS / 2;

signal pixel_clk, frame_clk : std_logic;
signal frame_mov_cnt : std_logic;

-- Signals for the Green Goblin
signal GreenGoblin_pos : std_logic_vector (18 downto 0) := "1100100000000010100";
signal GreenGoblin_reversed : std_logic := '1';
signal GreenGoblin_image : std_logic_vector (2 downto 0) := (others => '0');
constant GG_ACTION_FRAMES : natural := 10;
signal GG_action_cnt : natural range 0 to GG_ACTION_FRAMES -1;

-- Signals for Wolverine
signal Wolvie_pos : std_logic_vector (18 downto 0) := "1100100000101110010";
signal Wolvie_reversed : std_logic := '0';  -- At the normal orientation it is towrd right
signal Wolvie_image : std_logic_vector (3 downto 0) := "0000";
constant W_ACTION_FRAMES : natural := 10;
signal W_action_cnt : natural range 0 to W_ACTION_FRAMES -1;

-- Signals for the Pedana
signal Pedana1_pos: std_logic_vector (18 downto 0) := "0001100100011011100";
signal Pedana2_pos: std_logic_vector (18 downto 0) := "0101101000001000110";
signal Pedana3_pos: std_logic_vector (18 downto 0) := "0101101000101110010";
signal Pedana1_image : std_logic_vector(1 downto 0) := "00";
signal Pedana2_image : std_logic_vector(1 downto 0) := "01";
signal Pedana3_image : std_logic_vector(1 downto 0) := "10";
constant P_ACTION_FRAME : natural := 8;
signal P_action_cnt : natural range 0 to P_ACTION_FRAME -1;

---- Sinals for the Fire Ball
--signal FireBall_active, FireBall_end, FireBall_start : std_logic := '0';
--signal FireBall_pos : std_logic_vector (18 downto 0) := "0000000000000000000";
--signal FireBall_cnt : natural := 0;


begin

-- Process to create the frame clock
process(pixel_clk)
begin
    if rising_edge(pixel_clk) then
        if frame_clk_cnt = FRAME_PIXELS / 2 then
            frame_clk_cnt <= 0;
            frame_clk <= not frame_clk;
        else
            frame_clk_cnt <= frame_clk_cnt +1;
        end if;
    end if;
end process;




---- Process to move the Green Goblin

--process(frame_clk, GreenGoblin_reversed)
--begin
--    if rising_edge(frame_clk) then
--        if GreenGoblin_reversed = '0' and GreenGoblin_pos (9 downto 0) <= (WALL_WIDTH) then
--                GreenGoblin_reversed <= '1';
--        elsif GreenGoblin_reversed = '1' and GreenGoblin_pos (9 downto 0) >= (640 - 63 - WALL_WIDTH) then
--            GreenGoblin_reversed <= '0';
--        end if;
--    end if;
--end process;

--process(frame_clk, GreenGoblin_reversed)
--begin
--    if rising_edge(frame_clk) then
--        if frame_mov_cnt = '1' then
--            if GreenGoblin_reversed = '1' then
--                GreenGoblin_pos <= GreenGoblin_pos +2;
--            else
--                GreenGoblin_pos <= GreenGoblin_pos -2;
--            end if;
--        else
--            frame_mov_cnt <= not frame_mov_cnt;
--        end if;
--    end if;
--end process;

-- Process to animate the Green Goblin
process (frame_clk)
begin
    if rising_edge(frame_clk) then
        if GG_action_cnt = GG_ACTION_FRAMES -1 then
            GG_action_cnt <= 0;
            if GreenGoblin_image < 5 then
                GreenGoblin_image <= GreenGoblin_image+1;
            else
                GreenGoblin_image <= "000";
            end if;
        else
            GG_action_cnt <= GG_action_cnt +1;   
        end if;
    end if;
end process;


-- Process to animate Wolverine
process (frame_clk)
begin
    if rising_edge(frame_clk) then
        if W_action_cnt = W_ACTION_FRAMES -1 then
            W_action_cnt <= 0;
            if Wolvie_image < 11 then
                Wolvie_image <= Wolvie_image+1;
            else
                Wolvie_image <= "0000";
            end if;
        else
            W_action_cnt <= W_action_cnt +1;   
        end if;
    end if;
end process;

-- Process to animate the pedanas ;) ahah
--process (frame_clk)
--begin
--    if rising_edge(frame_clk) then
--        if P_action_cnt = P_ACTION_FRAME -1 then
--            P_action_cnt <= 0;
--            if Pedana1_image < 3 then
--                Pedana1_image <= Pedana1_image +1;
--                Pedana2_image <= Pedana2_image +1;
--                Pedana3_image <= Pedana3_image +1;
--            else
--                Pedana1_image <= "00";
--                Pedana2_image <= "00";
--                Pedana3_image <= "00";
--            end if;
--        else
--            P_action_cnt <= P_action_cnt +1;
--        end if;
--    end if;
--end process;

---- Process to move the Silver Surfer

--process(frame_clk, SilverSurfer_reversed)
--begin
--    if rising_edge(frame_clk) then
--        if SilverSurfer_reversed = '1' and SilverSurfer_pos (9 downto 0) = (WALL_WIDTH) then
--                SilverSurfer_reversed <= '0';
--        elsif SilverSurfer_reversed = '0' and SilverSurfer_pos (9 downto 0) = (640 - 63 - WALL_WIDTH) then
--            SilverSurfer_reversed <= '1';
--        end if;
--    end if;
--end process;

--process(frame_clk, SilverSurfer_reversed)
--begin
--    if rising_edge(frame_clk) then
--        if SilverSurfer_reversed = '0' then
--            SilverSurfer_pos <= SilverSurfer_pos +1;
--        else
--            SilverSurfer_pos <= SilverSurfer_pos -1;
--        end if;
--    end if;
--end process;


---- Process to make the Silver Surfer fire
--process (frame_clk, SilverSurfer_image, SilverSurfer_reversed, FireBall_active)
--begin
--    if rising_edge(frame_clk) then
--        if SS_action_cnt = SS_ACTION_FRAMES -1 then
--            if SilverSurfer_image = "00" and FireBall_start = '1' then
--                FireBall_start <= '0';
--            elsif SilverSurfer_image = "11" and FireBall_start = '0' then
--                FireBall_start <= '1';
--                SilverSurfer_image <= "00";
--            else
--                if FireBall_active = '0' and SilverSurfer_fires = '1' then
--                    SilverSurfer_image <= SilverSurfer_image +1;
--                end if;
--            end if;
--            SS_action_cnt <= 0;
--        else
--            SS_action_cnt <= SS_action_cnt +1;
--        end if;
--    end if;
--end process;

----process (frame_clk, FireBall_active, SilverSurfer_pos, delay_cnt)
----begin
----    if rising_edge (frame_clk) then
----        if FireBall_active = '1' and delay_cnt = DELAY then
----            if FireBall_pos(9 downto 0) > WALL_WIDTH then
----                FireBall_active <= '0';
----                SilverSurfer_canFire <= '1';
----                delay_cnt <= 0;
----            else
----                FireBall_pos <= FireBall_pos +1;
----            end if;
----        elsif FireBall_active = '1' and delay_cnt < DELAY then
----            delay_cnt <= delay_cnt +1;
----        end if;  
----    end if;
----end process;


--FireBall_active <= '0' when FireBall_pos = "0000000000000000000"
--                    else '1';


--process(frame_clk, FireBall_active)
--begin
--    if rising_edge(frame_clk) then
--        if FireBall_active = '1' then
--            if FireBall_pos(9 downto 0) >= SCREEN_WIDTH - WALL_WIDTH - FIRE_SIZE then
--                FireBall_end <= '1';
--            else
--                FireBall_end <= '0';
--            end if;
--        end if;
--    end if;
--end process;

--process (frame_clk, FireBall_active, FireBall_end, FireBall_start)
--begin
--    if rising_edge(frame_clk) then
--        if frame_mov_cnt = '1' then
--            if FireBall_start = '1' and FireBall_active = '0' then
--                FireBall_pos <= SilverSurfer_pos + PLAYER_SIZE - FIRE_SIZE;
--            elsif FireBall_end = '1' then
--                FireBall_pos <= "0000000000000000000";
--            elsif FireBall_active = '1' then
--                FireBall_pos <= FireBall_pos +2;
--            end if;
--        end if;
--    end if;
--end process;



--process(frame_clk)
--begin
--    if rising_edge(frame_clk) then
--        if FireBall_cnt = 120 then
--            FireBall_cnt <= 0;
--            SilverSurfer_fires <= not SilverSurfer_fires;
--        else
--            FireBall_cnt <= FireBall_cnt +1;
--        end if;
--    end if;
--end process;





inst_pixelClkGen : pixelClkGen
port map
(   clk_in1     => clk,
    clk_out1    => pixel_clk
);

inst_graphic : graphic
port map
(   pixel_clk               => pixel_clk,
    GreenGoblin_pos         => GreenGoblin_pos,
    GreenGoblin_reversed    => GreenGoblin_reversed,
    GreenGoblin_image       => GreenGoblin_image,
    Wolvie_pos              => Wolvie_pos,
    Wolvie_reversed         => Wolvie_reversed,
    Wolvie_image            => Wolvie_image,
    Pedana1_pos             => Pedana1_pos,
    Pedana2_pos             => Pedana2_pos,
    Pedana3_pos             => Pedana3_pos,
    Pedana1_image           => Pedana1_image,
    Pedana2_image           => Pedana2_image,
    Pedana3_image           => Pedana3_image,
    red                     => red,
    green                   => green,
    blue                    => blue,
    HS                      => HS,
    VS                      => VS
);


end Behavioral;