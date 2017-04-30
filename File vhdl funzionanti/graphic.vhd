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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity graphic is
    Port (  pixel_clk : in STD_LOGIC;
            player1_pos : in std_logic_vector (18 downto 0);
            player1_reversed : in std_logic;
            red : out STD_LOGIC_VECTOR (3 downto 0);
            green : out STD_LOGIC_VECTOR (3 downto 0);
            blue : out STD_LOGIC_vector (3 downto 0);
            HS : out STD_LOGIC;
            VS : out STD_LOGIC
    );
end graphic;

architecture Behavioral of graphic is

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

component player1_rom is
    Port ( address : in STD_LOGIC_VECTOR (11 downto 0);
           pixel_out : out STD_LOGIC_VECTOR (11 downto 0));
end component;



--Signals for the vga
signal pixel_in : std_logic_vector (11 downto 0) := (others => '0');
signal reset_vga : std_logic := '0';
signal counter_h, counter_v : std_logic_vector (9 downto 0) := (others => '0');


--Signals for the backgroung
signal map_address : std_logic_vector (18 downto 0);
signal map_pixel : std_logic_vector (11 downto 0);

--Signals for current row and column in map
signal map_row : std_logic_vector (8 downto 0) := (others => '0');
signal map_col : std_logic_vector (9 downto 0) := (others => '0');

--Signals for the player1
signal player1_address : std_logic_vector (11 downto 0);
signal player1_pixel : std_logic_vector (11 downto 0);
signal player1_row : std_logic_vector (8 downto 0) := (others => '0');
signal player1_col : std_logic_vector (9 downto 0) := (others => '0');


-- Control signals for objects
signal player1_enable : std_logic := '0';
signal player1_colored : std_logic;
signal player1_cntH : std_logic_vector (5 downto 0) := (others => '0');
signal player1_cntV : std_logic_vector (5 downto 0) := (others => '0');


begin


-- Two processes to create map_row and map_col (Actual position in the screen)
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


-- Handling the counter for player 1
process(pixel_clk, player1_enable)
begin
    if rising_edge(pixel_clk) and player1_enable = '1' then
        if (player1_cntH = 63) then
            if (player1_cntV < 63) then
                player1_cntH <= (others => '0');
                player1_cntV <= player1_cntV +1;
            else
               player1_cntH <= (others => '0');
               player1_cntV <= (others => '0');
            end if;
        else 
            player1_cntH <= player1_cntH +1;
        end if;
    end if;
end process;

-- defining the player 1 enabler
player1_enable <= '1' when (map_row - player1_pos(18 downto 10)) < 64 and (map_col - player1_pos(9 downto 0)) < 64
                    else '0';

-- Defining the address in rom of the player 1
player1_address(11 downto 6) <= player1_cntV when player1_reversed = '0'
                                else 63 - player1_cntV;
player1_address(5 downto 0) <= player1_cntH when player1_reversed = '0'
                                else 63 - player1_cntH;

-- Visibility of the player 1
player1_colored <= '0' when player1_pixel = "111111111111"
                    else '1';
  

-- Multiplexing the pixel to be given to the vga according to the enablers
pixel_in <= "111100000000" when player1_enable = '1' and player1_pixel = "000000000000"
            else player1_pixel when player1_enable = '1' and player1_colored = '1'
            else map_pixel;
            
map_address (18 downto 10) <= map_row;
map_address (9 downto 0) <= map_col;




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

inst_player1 : player1_rom
port map (
    address     => player1_address,
    pixel_out   => player1_pixel
);


end Behavioral;
