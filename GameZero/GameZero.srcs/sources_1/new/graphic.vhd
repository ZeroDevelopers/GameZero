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
            GreenGoblin_pos : in std_logic_vector (18 downto 0);
            GreenGoblin_reversed : in std_logic;
            SilverSurfer_pos : in std_logic_vector (18 downto 0);
            SilverSurfer_reversed : in std_logic;
            SilverSurfer_image : in std_logic_vector (1 downto 0); -- The corresponding image from which we have to extract the pixels
            FireBall_pos : in std_logic_vector (18 downto 0);
            FireBall_active : in std_logic;
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

--component map_rom is
--    Port ( address : in STD_LOGIC_VECTOR (18 downto 0);
--           pixel : out STD_LOGIC_VECTOR (11 downto 0));
--end component;

component GreenGoblin_rom is
    Port ( address : in STD_LOGIC_VECTOR (13 downto 0);
           pixel_out : out STD_LOGIC_VECTOR (11 downto 0));
end component;

--component SilverSurfer_rom is
--    Port ( address : in STD_LOGIC_VECTOR (11 downto 0);
--           pixel_out : out STD_LOGIC_VECTOR (11 downto 0));
--end component;

--component SilverSurfer_2_rom is
--    Port ( address : in STD_LOGIC_VECTOR (11 downto 0);
--           pixel_out : out STD_LOGIC_VECTOR (11 downto 0));
--end component;

--component SilverSurfer_3_rom is
--    Port ( address : in STD_LOGIC_VECTOR (11 downto 0);
--           pixel_out : out STD_LOGIC_VECTOR (11 downto 0));
--end component;

--component SilverSurfer_4_rom is
--    Port ( address : in STD_LOGIC_VECTOR (11 downto 0);
--           pixel_out : out STD_LOGIC_VECTOR (11 downto 0));
--end component;

--component SilverSurfer_fire_rom is
--    Port ( address : in STD_LOGIC_VECTOR (9 downto 0);
--           pixel_out : out STD_LOGIC_VECTOR (11 downto 0));
--end component;



-- Constants
constant PLAYER_SIZE : natural := 75;
constant SCREEN_WIDTH : natural := 640;
constant SCREEN_HEIGHT : natural := 480;
constant WALL : natural := 20;  -- Width of the wall at the borders of the screen
--constant FIRE_SIZE : natural := 20;

--Signals for the vga
signal pixel_in : std_logic_vector (11 downto 0) := (others => '0');
signal reset_vga : std_logic := '0';
signal counter_h, counter_v : std_logic_vector (9 downto 0) := (others => '0');


--Signals for the backgroung
--signal map_address : std_logic_vector (18 downto 0);
--signal map_pixel : std_logic_vector (11 downto 0);

--Signals for current row and column in map
signal map_row : std_logic_vector (8 downto 0) := (others => '0');
signal map_col : std_logic_vector (9 downto 0) := (others => '0');

--Signals for the GreenGoblin
signal GreenGoblin_address : std_logic_vector (13 downto 0);
signal GreenGoblin_pixel : std_logic_vector (11 downto 0);
signal GreenGoblin_row : std_logic_vector (8 downto 0) := (others => '0');
signal GreenGoblin_col : std_logic_vector (9 downto 0) := (others => '0');


--Signals for Silver Surfer
--signal SilverSurfer_address : std_logic_vector (11 downto 0);
--signal SilverSurfer_pixel, SilverSurfer_1_pixel, SilverSurfer_2_pixel, SilverSurfer_3_pixel, SilverSurfer_4_pixel : std_logic_vector (11 downto 0);
--signal SilverSurfer_row : std_logic_vector (8 downto 0) := (others => '0');
--signal SilverSurfer_col : std_logic_vector (9 downto 0) := (others => '0');

---- Signals for the Silver Surfer Fire Ball
--signal FireBall_address : std_logic_vector (9 downto 0);
--signal FireBall_pixel : std_logic_vector (11 downto 0);


-- Control signals for objects
-- Green Goblin
signal GreenGoblin_enable : std_logic := '0';
signal GreenGoblin_colored : std_logic;
signal GreenGoblin_cntH : std_logic_vector (5 downto 0) := (others => '0');
signal GreenGoblin_cntV : std_logic_vector (5 downto 0) := (others => '0');

-- Silver Surfer
--signal SilverSurfer_enable : std_logic := '0';
--signal SilverSurfer_colored : std_logic;
--signal SilverSurfer_cntH : std_logic_vector (5 downto 0) := (others => '0');
--signal SilverSurfer_cntV : std_logic_vector (5 downto 0) := (others => '0');

---- Fire Ball
--signal FireBall_enable : std_logic := '0';
--signal FireBall_colored : std_logic;
--signal FireBall_cntH : std_logic_vector (4 downto 0) := (others => '0');
--signal FireBall_cntV : std_logic_vector (4 downto 0) := (others => '0');

begin


-- Two processes to create map_row and map_col (Actual position in the screen)
process(pixel_clk)
begin
    if rising_edge(pixel_clk) then
        if counter_h = 799 then
            counter_h <= (others => '0');
            map_col <= (others => '0');
        elsif counter_h < SCREEN_WIDTH then
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
        if counter_h = 799 and counter_v < 524  and counter_v >= SCREEN_HEIGHT then
            counter_v <= counter_v +1;
        elsif counter_h = 799 and counter_v = 524 then
            counter_v <= (others => '0');
            map_row <= (others => '0');
        elsif counter_h = 799 and counter_v < SCREEN_HEIGHT then
            counter_v <= counter_v +1;
            map_row <= map_row +1;
        end if;
    end if;
end process;


---------------------------------------

---     GREEN GOBLIN processing

---------------------------------------


-- Handling the counter for the Green Goblin
process(pixel_clk, GreenGoblin_enable)
begin
    if rising_edge(pixel_clk) and GreenGoblin_enable = '1' then
        if (GreenGoblin_cntH = PLAYER_SIZE -1) then
            if (GreenGoblin_cntV < PLAYER_SIZE -1) then
                GreenGoblin_cntH <= (others => '0');
                GreenGoblin_cntV <= GreenGoblin_cntV +1;
            else
               GreenGoblin_cntH <= (others => '0');
               GreenGoblin_cntV <= (others => '0');
            end if;
        else 
            GreenGoblin_cntH <= GreenGoblin_cntH +1;
        end if;
    end if;
end process;

-- defining the Green Goblin enabler
GreenGoblin_enable <= '1' when (map_row - GreenGoblin_pos(18 downto 10)) < PLAYER_SIZE and (map_col - GreenGoblin_pos(9 downto 0)) < PLAYER_SIZE
                    else '0';

-- Defining the address in rom of the Green Goblin
GreenGoblin_address(11 downto 6) <= GreenGoblin_cntV;
GreenGoblin_address(5 downto 0) <= GreenGoblin_cntH when GreenGoblin_reversed = '0'
                                else PLAYER_SIZE - 1 - GreenGoblin_cntH;

-- Visibility of the Green Goblin
GreenGoblin_colored <= '0' when GreenGoblin_pixel = "111111111111"
                    else '1';
                    
                    
---------------------------------------

---   SILVER SURFER processing

---------------------------------------

---- Handling the counter for Silver Surfer
--process(pixel_clk, SilverSurfer_enable)
--begin
--    if rising_edge(pixel_clk) and SilverSurfer_enable = '1' then
--        if (SilverSurfer_cntH = PLAYER_SIZE -1) then
--            if (SilverSurfer_cntV < PLAYER_SIZE -1) then
--                SilverSurfer_cntH <= (others => '0');
--                SilverSurfer_cntV <= SilverSurfer_cntV +1;
--            else
--               SilverSurfer_cntH <= (others => '0');
--               SilverSurfer_cntV <= (others => '0');
--            end if;
--        else 
--            SilverSurfer_cntH <= SilverSurfer_cntH +1;
--        end if;
--    end if;
--end process;

---- defining the Silver Srfer enabler
--SilverSurfer_enable <= '1' when (map_row - SilverSurfer_pos(18 downto 10)) < PLAYER_SIZE and (map_col - SilverSurfer_pos(9 downto 0)) < PLAYER_SIZE
--                    else '0';

---- Defining the address in rom of Silver Surfer
--SilverSurfer_address(11 downto 6) <= SilverSurfer_cntV;
--SilverSurfer_address(5 downto 0) <= SilverSurfer_cntH when SilverSurfer_reversed = '0'
--                                else PLAYER_SIZE - 1 - SilverSurfer_cntH;

---- Choosing among the different images
--SilverSurfer_pixel <= SilverSurfer_1_pixel when SilverSurfer_image = "00"
--                    else SilverSurfer_2_pixel when SilverSurfer_image = "01"
--                    else SilverSurfer_3_pixel when SilverSurfer_image = "10"
--                    else SilverSurfer_4_pixel when SilverSurfer_image = "11";
                    
---- Visibility of Silver Surfer
--SilverSurfer_colored <= '0' when SilverSurfer_pixel = "111111111111"
--                    else '1';
                    

-----------------------------------------

-----   FIRE BALL processing

-----------------------------------------
--process(pixel_clk, FireBall_enable)
--begin
--    if rising_edge(pixel_clk) and FireBall_enable = '1' then
--        if (FireBall_cntH = FIRE_SIZE -1) then
--            if (FireBall_cntV < FIRE_SIZE -1) then
--                FireBall_cntH <= (others => '0');
--                FireBall_cntV <= FireBall_cntV +1;
--            else
--               FireBall_cntH <= (others => '0');
--               FireBall_cntV <= (others => '0');
--            end if;
--        else 
--            FireBall_cntH <= FireBall_cntH +1;
--        end if;
--    end if;
--end process;

---- defining the Fire Ball enabler
--FireBall_enable <= '1' when FireBall_active = '1' and (map_row - FireBall_pos(18 downto 10)) < FIRE_SIZE and (map_col - FireBall_pos(9 downto 0)) < FIRE_SIZE
--                    else '0';

---- Defining the address in rom of Silver Surfer
--FireBall_address(9 downto 5) <= FireBall_cntV;
--FireBall_address(4 downto 0) <= FireBall_cntH when SilverSurfer_reversed = '0'  -- When Silver Surfer is reversed I need also the image of the ball to be reversed
--                                else FIRE_SIZE - 1 - FireBall_cntH;

                    
---- Visibility of Silver Surfer
--FireBall_colored <= '0' when FireBall_pixel = "111111111111"
--                    else '1';            

  
------------------------------------------------------------------------

-- Multiplexing the pixel to be given to the vga according to the enablers

-------------------------------------------------------------------------

pixel_in <= GreenGoblin_pixel when GreenGoblin_enable = '1' and GreenGoblin_colored = '1'
            --else SilverSurfer_pixel when SilverSurfer_enable = '1' and SilverSurfer_colored = '1'
            --else FireBall_pixel when FireBall_enable = '1' and FireBall_colored = '1'
            else "001100110011" when map_row < WALL or map_col < WALL or map_col > SCREEN_WIDTH - WALL -1 or map_row > SCREEN_HEIGHT - WALL -1
            else "000000001111"; -- Projecting the background in the final project
            
--map_address (18 downto 10) <= map_row;
--map_address (9 downto 0) <= map_col;




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

--inst_map : map_rom
--port map (
--    address     => map_address,
--    pixel       => map_pixel
--);

inst_GreenGoblin : GreenGoblin_rom
port map (
    address     => GreenGoblin_address,
    pixel_out   => GreenGoblin_pixel
);

--inst_SilverSurfer : SilverSurfer_rom
--port map (
--    address     => SilverSurfer_address,
--    pixel_out   => SilverSurfer_1_pixel
--);

--inst_SilverSurfer_2 : SilverSurfer_2_rom
--port map (
--    address     => SilverSurfer_address,
--    pixel_out   => SilverSurfer_2_pixel
--);

--inst_SilverSurfer_3 : SilverSurfer_3_rom
--port map (
--    address     => SilverSurfer_address,
--    pixel_out   => SilverSurfer_3_pixel
--);

--inst_SilverSurfer_4 : SilverSurfer_4_rom
--port map (
--    address     => SilverSurfer_address,
--    pixel_out   => SilverSurfer_4_pixel
--);

--inst_SilverSurfer_fire : SilverSurfer_fire_rom
--port map (
--    address     => FireBall_address,
--    pixel_out   => FireBall_pixel
--);


end Behavioral;
