----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.04.2017 18:33:57
-- Design Name: 
-- Module Name: graphic - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity graphic is
    Port (  clk : in STD_LOGIC;
            red : out STD_LOGIC_VECTOR (3 downto 0);
            green : out STD_LOGIC_VECTOR (3 downto 0);
            blue : out STD_LOGIC_vector (3 downto 0);
            HS : out STD_LOGIC;
            VS : out STD_LOGIC
    );
end graphic;

architecture Behavioral of graphic is

component pixelClkGen is
Port (  clk_in1 : in std_logic;
        clk_out1 : out std_logic
      );
end component;

component vga is
    Port ( pixel_clk : in STD_LOGIC;
           pixel : in STD_LOGIC_VECTOR (11 downto 0);
           reset : in STD_LOGIC;
           red : out STD_LOGIC_VECTOR (3 downto 0);
           green : out STD_LOGIC_VECTOR (3 downto 0);
           blue : out STD_LOGIC_vector (3 downto 0);
           HS : out STD_LOGIC;
           VS : out STD_LOGIC);
end component;

component map_rom is
    Port ( address : in STD_LOGIC_VECTOR (18 downto 0);
           pixel : out STD_LOGIC_VECTOR (11 downto 0));
end component;


--Signals
signal pixel_clk : std_logic;
signal pixel_in : std_logic_vector (11 downto 0) := (others => '0');
signal reset_vga : std_logic := '0';
signal counter_h, counter_v : std_logic_vector (9 downto 0) := (others => '0');

signal map_address : std_logic_vector (18 downto 0);
signal map_pixel : std_logic_vector (11 downto 0);
signal map_row : std_logic_vector (8 downto 0) := (others => '0');
signal map_col : std_logic_vector (9 downto 0) := (others => '0');

begin

map_address (18 downto 10) <= map_row;
map_address (9 downto 0) <= map_col;

process(pixel_clk)
begin
    if rising_edge(pixel_clk) then
        if counter_h = 799 then
            counter_h <= (others => '0');
            map_col <= (others => '0');
        elsif counter_h < 640 then
            counter_h <= counter_h +1;
            map_col <= map_col +1;
        else
            counter_h <= counter_h +1;
        end if;
    end if;
end process;

process(pixel_clk)
begin
    if rising_edge(pixel_clk) then
        if counter_h = 799 and counter_v < 524  and counter_v >= 480 then
            counter_v <= counter_v +1;
        elsif counter_h = 799 and counter_v = 524 then
            counter_v <= (others => '0');
            map_row <= (others => '0');
        elsif counter_h = 799 and counter_v < 480 then
            counter_v <= counter_v +1;
            map_row <= map_row +1;
        end if;
    end if;
end process;


pixel_in <= map_pixel;
map_address (18 downto 10) <= map_row;
map_address (9 downto 0) <= map_col;




inst_pixelClkGen : pixelClkGen
port map (  clk_in1     => clk,
            clk_out1    => pixel_clk
          );

inst_vga : vga
port map (
    pixel_clk   => pixel_clk,
    pixel       => pixel_in,
    reset       => reset_vga,
    red         => red,
    green       => green,
    blue        => blue,
    VS          => VS,
    HS          => HS
);

inst_map : map_rom
port map (
    address     => map_address,
    pixel       => map_pixel
);

end Behavioral;
