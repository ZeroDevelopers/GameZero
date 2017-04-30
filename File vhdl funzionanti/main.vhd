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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
            player1_pos : in std_logic_vector (18 downto 0);
            player1_reversed : in std_logic;
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


-- signals to create the FRAME_CLOCK
constant FRAME_PIXELS : natural := 420000;
signal frame_clk_cnt : natural range 0 to FRAME_PIXELS / 2;
signal pixel_clk, frame_clk : std_logic;

-- Signals for the player 1
signal player1_pos : std_logic_vector (18 downto 0);
signal player1_reversed : std_logic;

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

-- Process to move the ploayer 1
process(frame_clk, player1_reversed)
begin
    if rising_edge(frame_clk) then
        if player1_reversed = '0' and player1_pos (9 downto 0) = (640 - 63) then
                player1_reversed <= '1';
        elsif player1_reversed = '1' and player1_pos = 63 then
            player1_reversed <= '0';
        end if;
    end if;
end process;

process(frame_clk, player1_reversed)
begin
    if rising_edge(frame_clk) then
        if player1_reversed = '0' then
            player1_pos <= player1_pos +1;
        else
            player1_pos <= player1_pos -1;
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
(   pixel_clk => pixel_clk,
    player1_pos => player1_pos,
    player1_reversed => player1_reversed,
    red => red,
    green => green,
    blue => blue,
    HS => HS,
    VS => VS
);


end Behavioral;
