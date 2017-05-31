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
            GreenGoblin_image : in std_logic_vector (2 downto 0); -- The corresponding image from which we have to extract the pixels
            Wolvie_pos : in std_logic_vector (18 downto 0);
            Wolvie_reversed : in std_logic;
            Wolvie_image : in std_logic_vector (3 downto 0); -- The corresponding image from which we have to extract the pixels
            Pedana1_pos : in std_logic_vector (18 downto 0);  -- All the positions and frames of the "Pedana"
            Pedana1_image : in std_logic_vector (1 downto 0);
            Pedana2_pos : in std_logic_vector (18 downto 0);
            Pedana2_image : in std_logic_vector (1 downto 0);
            Pedana3_pos : in std_logic_vector (18 downto 0);
            Pedana3_image : in std_logic_vector (1 downto 0);
            GreenGoblin_lives, Wolvie_lives : in std_logic_vector (1 downto 0);  -- 4 maximum lives
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

component playerBROM IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END component;

component utilBROM IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END component;



-- Constants
constant PLAYER_SIZE : natural := 75;
constant SCREEN_WIDTH : natural := 640;
constant SCREEN_HEIGHT : natural := 480;
constant WALL : natural := 20;  -- Width of the wall at the borders of the screen
constant BROM_DEPTH : natural := 17;  -- Bits needed to address a specific pixel in BROM
constant BROM_PEDANA_DEPTH : natural := 16;  -- Bits needed to address a specific pixel in BROM PEDANA
constant PEDANA_WIDTH : natural := 200;
constant PEDANA_HEIGHT : natural := 100;
constant LIFE_SIZE : natural := 48;

-- BACKGROUND COLOR !!
constant BG_COLOR : std_logic_vector (11 downto 0) := "011100110000";

-- Position for lives
constant W_LIVES_POS : std_logic_vector (18 downto 0) := "0000111100000011110";
constant GG_LIVES_POS : std_logic_vector (18 downto 0) := "0000111100110100010";

-- Offsets in the BROM
-- Green Goblin
constant GG_OFFSET_1 : natural := 0;  -- Standard image
constant GG_OFFSET_2 : natural := 5625;  -- Attack 1
constant GG_OFFSET_3 : natural := 11250;  -- Attack 2
constant GG_OFFSET_4 : natural := 16875;  -- Bomb 1
constant GG_OFFSET_5 : natural := 22500;  -- Bomb 2

-- Wolverine
constant W_OFFSET_1 : natural := 28125;     -- Run 1
constant W_OFFSET_2 : natural := 33750;     -- Run 2
constant W_OFFSET_3 : natural := 39375;     -- Run 3
constant W_OFFSET_4 : natural := 45000;     -- Run 4
constant W_OFFSET_5 : natural := 50625;     -- Run 5
constant W_OFFSET_6 : natural := 56250;     -- Attack 1
constant W_OFFSET_7 : natural := 61875;     -- Attack 2
constant W_OFFSET_8 : natural := 67500;     -- Attack 3
constant W_OFFSET_9 : natural := 73125;     -- Attack 4
constant W_OFFSET_10 : natural := 78750;    -- Up
constant W_OFFSET_11 : natural := 84375;    -- Down

-- Pedana
constant P_OFFSET_1 : natural := 0;
constant P_OFFSET_2 : natural := 20000;
constant P_OFFSET_3 : natural := 40000;

-- Util
constant LIFE_OFFSET : natural := 60000;
constant SBAM_OFFSET : natural := 62304;

--Signals for the vga
signal pixel_in : std_logic_vector (11 downto 0) := (others => '0');
signal reset_vga : std_logic := '0';
signal counter_h, counter_v : std_logic_vector (9 downto 0) := (others => '0');


--Signals for current row and column in map
signal map_row : std_logic_vector (8 downto 0) := (others => '0');
signal map_col : std_logic_vector (9 downto 0) := (others => '0');

-- General signals for objects
signal player_enable, player_colored, pedana_enable, pedana_colored : std_logic := '0';


-- Signals for background
constant BG_SECTION : natural := 30;
signal BG_section_cnt : natural range 0 to BG_SECTION -1;
signal BG_pixel : std_logic_vector (11 downto 0) := BG_COLOR;  -- BACKGROUND COLOR !!!!


--Signals for the GreenGoblin
signal GreenGoblin_offset : natural range GG_OFFSET_1 to GG_OFFSET_5;
signal GreenGoblin_address : integer range 0 to PLAYER_SIZE * PLAYER_SIZE;  -- The address of the player is local to its map, then the offset is added in the brom_address
signal GreenGoblin_pixel : std_logic_vector (11 downto 0);


--Signals for Wolverine
signal Wolvie_offset : natural range W_OFFSET_1 to W_OFFSET_11;
signal Wolvie_address : integer range 0 to PLAYER_SIZE * PLAYER_SIZE;
signal Wolvie_pixel : std_logic_vector (11 downto 0);

--Signals for the Pedana
signal Pedana1_offset, Pedana2_offset, Pedana3_offset : natural range P_OFFSET_1 to P_OFFSET_3;
signal Pedana1_address, Pedana2_address, Pedana3_address : integer range 0 to PEDANA_WIDTH * PEDANA_HEIGHT;
signal Pedana1_pixel, Pedana2_pixel, Pedana3_pixel : std_logic_vector (11 downto 0);


-- Control signals for objects
-- Green Goblin
signal GreenGoblin_enable : std_logic := '0';
signal GreenGoblin_cntH, GreenGoblin_cntV : natural range 0 to PLAYER_SIZE -1 := 0;

-- Wolverine
signal Wolvie_enable : std_logic := '0';
signal Wolvie_cntH, Wolvie_cntV : natural range 0 to PLAYER_SIZE -1 := 0;

-- Pedana
signal Pedana1_enable, Pedana2_enable, Pedana3_enable : std_logic := '0';
signal Pedana1_cntH, Pedana2_cntH, Pedana3_cntH : natural range 0 to PEDANA_WIDTH -1 := 0;
signal Pedana1_cntV, Pedana2_cntV, Pedana3_cntV : natural range 0 to PEDANA_HEIGHT -1 := 0;

-- Lives
signal Wolvie_Life_enable, GreenGoblin_Life_enable, Life_enable, Life_colored: std_logic := '0';
signal Wolvie_life_cnt, GreenGoblin_life_cnt : std_logic_vector (1 downto 0) := "01";
signal Wolvie_Life_cntV, GreenGoblin_Life_cntV : natural range 0 to LIFE_SIZE -1 := 0;
signal Wolvie_Life_cntH, GreenGoblin_Life_cntH : natural range 0 to LIFE_SIZE -1 := 0;
signal Wolvie_life_address, GreenGoblin_life_address : natural range 0 to LIFE_SIZE * LIFE_SIZE -1;

-- BROM signals
signal brom_addr : STD_LOGIC_VECTOR(16 DOWNTO 0);
signal brom_pixel_out : STD_LOGIC_VECTOR(11 DOWNTO 0);
signal brom_util_addr : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal brom_util_pixel_out : STD_LOGIC_VECTOR(11 DOWNTO 0);

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
            BG_pixel <= BG_COLOR;  -- RESET BACKGROUND COLOR !!!
        elsif counter_h = 799 and counter_v < SCREEN_HEIGHT then
            counter_v <= counter_v +1;
            map_row <= map_row +1;
            
            -- BACKGROUND processing
            if BG_section_cnt = BG_SECTION -1 then
                BG_section_cnt <= 0;
                BG_pixel <= BG_pixel +1;
            else
                BG_section_cnt <= BG_section_cnt +1;
            end if;
            
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
                GreenGoblin_cntH <= 0;
                GreenGoblin_cntV <= GreenGoblin_cntV +1;
            else
               GreenGoblin_cntH <= 0;
               GreenGoblin_cntV <= 0;
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
GreenGoblin_address <= GreenGoblin_cntV * PLAYER_SIZE + GreenGoblin_cntH when GreenGoblin_reversed = '0'
                        else conv_integer(GreenGoblin_cntV) * PLAYER_SIZE + PLAYER_SIZE -1 - GreenGoblin_cntH;  -- Picking up the right pixel from BROM


-- Defining the offset of the Goblin accroding to the image input
GreenGoblin_offset <= GG_OFFSET_1 when GreenGoblin_image = "000"
                    else GG_OFFSET_2 when GreenGoblin_image = "001"
                    else GG_OFFSET_3 when GreenGoblin_image = "010"
                    else GG_OFFSET_4 when GreenGoblin_image = "011"
                    else GG_OFFSET_5 when GreenGoblin_image = "100";
                                        

                    
---------------------------------------

---   WOLVERINE processing

---------------------------------------

-- Handling the counter for Wolverine
process(pixel_clk, Wolvie_enable)
begin
    if rising_edge(pixel_clk) and Wolvie_enable = '1' then
        if (Wolvie_cntH = PLAYER_SIZE -1) then
            if (Wolvie_cntV < PLAYER_SIZE -1) then
                Wolvie_cntH <= 0;
                Wolvie_cntV <= Wolvie_cntV +1;
            else
               Wolvie_cntH <= 0;
               Wolvie_cntV <= 0;
            end if;
        else 
            Wolvie_cntH <= Wolvie_cntH +1;
        end if;
    end if;
end process;


-- defining the Wolverine enabler
Wolvie_enable <= '1' when (map_row - Wolvie_pos(18 downto 10)) < PLAYER_SIZE and (map_col - Wolvie_pos(9 downto 0)) < PLAYER_SIZE
                    else '0';

-- Defining the address in rom of the Wolverine
Wolvie_address <= Wolvie_cntV * PLAYER_SIZE + Wolvie_cntH when Wolvie_reversed = '0'
                    else Wolvie_cntV * PLAYER_SIZE + PLAYER_SIZE -1 - Wolvie_cntH;  -- Picking up the right pixel from BROM


-- Defining the offset of the Wolverine accroding to the image input
Wolvie_offset <= W_OFFSET_1 when Wolvie_image = "0000"
                else W_OFFSET_2 when Wolvie_image = "0001"
                else W_OFFSET_3 when Wolvie_image = "0010"
                else W_OFFSET_4 when Wolvie_image = "0011"
                else W_OFFSET_5 when Wolvie_image = "0100"
                else W_OFFSET_6 when Wolvie_image = "0101"
                else W_OFFSET_7 when Wolvie_image = "0110"
                else W_OFFSET_8 when Wolvie_image = "0111"
                else W_OFFSET_9 when Wolvie_image = "1000"
                else W_OFFSET_10 when Wolvie_image = "1001"
                else W_OFFSET_11 when Wolvie_image = "1010";
                
                
                
---------------------------------------

---   PEDANA processing

---------------------------------------

-- Handling the counter for the Pedana 1
process(pixel_clk, Pedana1_enable)
begin
    if rising_edge(pixel_clk) and Pedana1_enable = '1' then
        if (Pedana1_cntH = PEDANA_WIDTH -1) then
            if (Pedana1_cntV < PEDANA_HEIGHT -1) then
                Pedana1_cntH <= 0;
                Pedana1_cntV <= Pedana1_cntV +1;
            else
               Pedana1_cntH <= 0;
               Pedana1_cntV <= 0;
            end if;
        else 
            Pedana1_cntH <= Pedana1_cntH +1;
        end if;
    end if;
end process;

-- Handling the counter for the Pedana 2
process(pixel_clk, Pedana2_enable)
begin
    if rising_edge(pixel_clk) and Pedana2_enable = '1' then
        if (Pedana2_cntH = PEDANA_WIDTH -1) then
            if (Pedana2_cntV < PEDANA_HEIGHT -1) then
                Pedana2_cntH <= 0;
                Pedana2_cntV <= Pedana2_cntV +1;
            else
               Pedana2_cntH <= 0;
               Pedana2_cntV <= 0;
            end if;
        else 
            Pedana2_cntH <= Pedana2_cntH +1;
        end if;
    end if;
end process;

-- Handling the counter for the Pedana 3
process(pixel_clk, Pedana3_enable)
begin
    if rising_edge(pixel_clk) and Pedana3_enable = '1' then
        if (Pedana3_cntH = PEDANA_WIDTH -1) then
            if (Pedana3_cntV < PEDANA_HEIGHT -1) then
                Pedana3_cntH <= 0;
                Pedana3_cntV <= Pedana3_cntV +1;
            else
               Pedana3_cntH <= 0;
               Pedana3_cntV <= 0;
            end if;
        else 
            Pedana3_cntH <= Pedana3_cntH +1;
        end if;
    end if;
end process;


-- defining the Pedana enabler
Pedana1_enable <= '1' when (map_row - Pedana1_pos(18 downto 10)) < PEDANA_HEIGHT and (map_col - Pedana1_pos(9 downto 0)) < PEDANA_WIDTH
                    else '0';
Pedana2_enable <= '1' when (map_row - Pedana2_pos(18 downto 10)) < PEDANA_HEIGHT and (map_col - Pedana2_pos(9 downto 0)) < PEDANA_WIDTH
                    else '0';
Pedana3_enable <= '1' when (map_row - Pedana3_pos(18 downto 10)) < PEDANA_HEIGHT and (map_col - Pedana3_pos(9 downto 0)) < PEDANA_WIDTH
                    else '0';

-- Defining the address in rom of the Pedana
Pedana1_address <= Pedana1_cntV * PEDANA_WIDTH + Pedana1_cntH; 
Pedana2_address <= Pedana2_cntV * PEDANA_WIDTH + Pedana2_cntH;
Pedana3_address <= Pedana3_cntV * PEDANA_WIDTH + Pedana3_cntH;

-- Defining the pedana offset
Pedana1_offset <= P_OFFSET_1 when Pedana1_image = "00"
                    else P_OFFSET_2 when Pedana1_image = "01"
                    else P_OFFSET_3 when Pedana1_image = "10";

Pedana2_offset <= P_OFFSET_2 when Pedana2_image = "01"
                   else P_OFFSET_1 when Pedana2_image = "00"
                   else P_OFFSET_3 when Pedana2_image = "10";
                    
Pedana3_offset <= P_OFFSET_1 when Pedana3_image = "00"
                    else P_OFFSET_2 when Pedana3_image = "01"
                    else P_OFFSET_3 when Pedana3_image = "10";        


---------------------------------------

---   LIVES processing

---------------------------------------

-- Handling the counter for Wolverine Life
--process(pixel_clk, Wolvie_Life_enable, Wolvie_lives)
--begin
--    if rising_edge(pixel_clk) and Wolvie_Life_enable = '1' then
--        if Wolvie_Life_cntH = LIFE_SIZE -1 then  
--            if Wolvie_life_cnt < Wolvie_lives then
--                Wolvie_life_cnt <= Wolvie_life_cnt +1;
--            else
--                if Wolvie_life_cntV < LIFE_SIZE -1 then
--                    Wolvie_life_cntV <= Wolvie_life_cntV +1;
--                else
--                    Wolvie_life_cntV <= 0;
--                end if; 
--                Wolvie_life_cnt <= "01";               
--            end if;
--            Wolvie_life_cntH <= 0;
--        else
--            Wolvie_life_cntH <= Wolvie_cntH +1;
--        end if;      
--    end if;
--end process;

process(pixel_clk, Wolvie_life_enable)
begin
    if rising_edge(pixel_clk) and Wolvie_life_enable = '1' then
        if (Wolvie_life_cntH = LIFE_SIZE -1) then
            if (Wolvie_life_cntV < LIFE_SIZE -1) then
                Wolvie_life_cntH <= 0;
                Wolvie_life_cntV <= Wolvie_life_cntV +1;
            else
               Wolvie_life_cntH <= 0;
               Wolvie_life_cntV <= 0;
            end if;
        else 
            Wolvie_life_cntH <= Wolvie_life_cntH +1;
        end if;
    end if;
end process;

-- Handling the counter for Green Goblin Lives
process(pixel_clk, GreenGoblin_Life_enable, GreenGoblin_lives)
begin
    if rising_edge(pixel_clk) and GreenGoblin_Life_enable = '1' then
        if GreenGoblin_Life_cntH = LIFE_SIZE -1 then
            if GreenGoblin_life_cnt < GreenGoblin_lives then
                GreenGoblin_life_cnt <= GreenGoblin_life_cnt +1;
            else
                if GreenGoblin_life_cntV < LIFE_SIZE -1 then
                    GreenGoblin_life_cntV <= GreenGoblin_life_cntV +1;
                else
                    GreenGoblin_life_cntV <= 0;
                end if; 
                GreenGoblin_life_cnt <= "01";               
            end if;
            GreenGoblin_life_cntH <= 0;
        else
            GreenGoblin_life_cntH <= GreenGoblin_cntH +1;
        end if;      
    end if;
end process;


-- Defining the enable for Wolverine lives
Wolvie_Life_enable <= '1' when (map_row - W_LIVES_POS(18 downto 10)) < LIFE_SIZE and 
                               (map_col - W_LIVES_POS(9 downto 0)) < (LIFE_SIZE)
                        else '0';
-- Defining the enable for GreenGoblin lives
GreenGoblin_Life_enable <= '1' when (map_row - GG_LIVES_POS(18 downto 10)) < LIFE_SIZE and 
                               (map_col - GG_LIVES_POS(9 downto 0)) < (LIFE_SIZE * conv_integer(GreenGoblin_lives))
                        else '0';

-- Defining the address in memory for Wolverine lives
Wolvie_life_address <= Wolvie_life_cntV * LIFE_SIZE + Wolvie_life_cntH;
-- Defining the address in memory for Green Goblin lives
GreenGoblin_life_address <= GreenGoblin_life_cntV * LIFE_SIZE + GreenGoblin_life_cntH;

 


------------------------------------------------------------------------

-- Multiplexing the address to be given to the rom

-------------------------------------------------------------------------

brom_addr <= std_logic_vector(to_unsigned(GreenGoblin_address + GreenGoblin_offset, BROM_DEPTH)) when GreenGoblin_enable = '1'
            else std_logic_vector(to_unsigned(Wolvie_address + Wolvie_offset, BROM_DEPTH)) when Wolvie_enable = '1';
            
brom_util_addr <=   std_logic_vector(to_unsigned(Wolvie_life_address + LIFE_OFFSET, BROM_PEDANA_DEPTH)) when Wolvie_life_enable = '1'
                    else std_logic_vector(to_unsigned(GreenGoblin_life_address + LIFE_OFFSET, BROM_PEDANA_DEPTH)) when GreenGoblin_life_enable = '1'
                    else std_logic_vector(to_unsigned(Pedana1_address + Pedana1_offset, BROM_PEDANA_DEPTH)) when Pedana1_enable = '1'
                    else std_logic_vector(to_unsigned(Pedana2_address + Pedana2_offset, BROM_PEDANA_DEPTH)) when Pedana2_enable = '1'
                    else std_logic_vector(to_unsigned(Pedana3_address + Pedana3_offset, BROM_PEDANA_DEPTH)) when Pedana3_enable = '1';

-- Computing the enabler and the colored signals
player_enable <= GreenGoblin_enable or Wolvie_enable;  -- Logical OR among all the possible objects
pedana_enable <= Pedana1_enable or Pedana2_enable or Pedana3_enable;
Life_enable <= Wolvie_life_enable or GreenGoblin_life_enable;

player_colored <= '0' when brom_pixel_out = "111111111111"
                    else '1';
pedana_colored <= '0' when brom_util_pixel_out = "111111111111" and Pedana_enable = '1'
                    else '1';
Life_colored <= '0' when brom_util_pixel_out = "111111111111" and Life_enable = '1'
                    else '1';
------------------------------------------------------------------------

-- Multiplexing the pixel to be given to the vga according to the enablers

-------------------------------------------------------------------------

pixel_in <= brom_pixel_out when player_enable = '1' and player_colored = '1'
            else brom_util_pixel_out when (pedana_enable = '1' and pedana_colored = '1') or (Life_enable = '1' and Life_colored = '1')
            else "001100110011" when map_row < WALL or map_col < WALL or map_col > SCREEN_WIDTH - WALL -1 or map_row > SCREEN_HEIGHT - WALL -1
            else BG_pixel; -- Projecting the background in the final project
            



-- Instantiation of components

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

inst_brom_player : playerBROM
port map
(   clka    => pixel_clk,
    addra   => brom_addr,
    douta   => brom_pixel_out
);

inst_brom_util : utilBROM
port map
(   clka    => pixel_clk,
    addra   => brom_util_addr,
    douta   => brom_util_pixel_out
);


end Behavioral;
