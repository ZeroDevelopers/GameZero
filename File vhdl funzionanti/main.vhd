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
            SilverSurfer_pos : in std_logic_vector (18 downto 0);
            SilverSurfer_reversed : in std_logic;
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

-- signals to create the FRAME_CLOCK
constant FRAME_PIXELS : natural := 420000;
signal frame_clk_cnt : natural range 0 to FRAME_PIXELS / 2;

signal pixel_clk, frame_clk : std_logic;

-- Signals for the Green Goblin
signal GreenGoblin_pos : std_logic_vector (18 downto 0) := "1100100000000000000";
signal GreenGoblin_reversed : std_logic := '1';  -- At the normal orientation it is towrd left

-- Signals for the Silver Surfer
signal SilverSurfer_pos : std_logic_vector (18 downto 0) := "1001011000000000000";
signal SilverSurfer_reversed : std_logic := '0';  -- At the normal orientation it is towrd right

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


-- Process to move the Green Goblin

process(frame_clk, GreenGoblin_reversed)
begin
    if rising_edge(frame_clk) then
        if GreenGoblin_reversed = '0' and GreenGoblin_pos (9 downto 0) = (WALL_WIDTH) then
                GreenGoblin_reversed <= '1';
        elsif GreenGoblin_reversed = '1' and GreenGoblin_pos (9 downto 0) = (640 - 63 - WALL_WIDTH) then
            GreenGoblin_reversed <= '0';
        end if;
    end if;
end process;

process(frame_clk, GreenGoblin_reversed)
begin
    if rising_edge(frame_clk) then
        if GreenGoblin_reversed = '1' then
            GreenGoblin_pos <= GreenGoblin_pos +1;
        else
            GreenGoblin_pos <= GreenGoblin_pos -1;
        end if;
    end if;
end process;


-- Process to move the Silver Surfer

process(frame_clk, SilverSurfer_reversed)
begin
    if rising_edge(frame_clk) then
        if SilverSurfer_reversed = '1' and SilverSurfer_pos (9 downto 0) = (WALL_WIDTH) then
                SilverSurfer_reversed <= '0';
        elsif SilverSurfer_reversed = '0' and SilverSurfer_pos (9 downto 0) = (640 - 63 - WALL_WIDTH) then
            SilverSurfer_reversed <= '1';
        end if;
    end if;
end process;

process(frame_clk, SilverSurfer_reversed)
begin
    if rising_edge(frame_clk) then
        if SilverSurfer_reversed = '0' then
            SilverSurfer_pos <= SilverSurfer_pos +1;
        else
            SilverSurfer_pos <= SilverSurfer_pos -1;
        end if;
    end if;
end process;





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
    SilverSurfer_pos        => SilverSurfer_pos,
    SilverSurfer_reversed   => SilverSurfer_reversed,
    red                     => red,
    green                   => green,
    blue                    => blue,
    HS                      => HS,
    VS                      => VS
);


end Behavioral;
