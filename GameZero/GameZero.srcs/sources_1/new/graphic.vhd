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
--use IEEE.STD_LOGIC_ARITH.ALL;
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
    Port (  pixel_clk: in STD_LOGIC;
            start : in std_logic;
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
            GreenGoblin_lives, Wolvie_lives : in std_logic_vector (2 downto 0);  -- 4 maximum lives
            sbam_pos : in std_logic_vector (18 downto 0);
            Wolvie_won_pos, GreenGoblin_won_pos : in std_logic_vector (18 downto 0);
            Heart_pos : in std_logic_vector (18 downto 0);
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
           map_row : out std_logic_vector (8 downto 0);
           map_col : out std_logic_vector (9 downto 0);
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
    addra : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END component;



-- Constants
constant PLAYER_SIZE : natural := 75;
constant SCREEN_WIDTH : natural := 640;
constant SCREEN_HEIGHT : natural := 480;
constant WALL : natural := 20;  -- Width of the wall at the borders of the screen
constant BROM_DEPTH : natural := 17;  -- Bits needed to address a specific pixel in BROM
constant BROM_PEDANA_DEPTH : natural := 18;  -- Bits needed to address a specific pixel in BROM PEDANA
constant PEDANA_WIDTH : natural := 200;
constant PEDANA_HEIGHT : natural := 100;
constant LIFE_SIZE : natural := 48;
constant LBAR_WIDTH : natural := 96;
constant LBAR_HEIGHT : natural := 16;
constant HEAD_SIZE : natural := 32;
constant SBAM_SIZE : natural := 48;
constant FINAL_IMG_WIDTH : natural := 400;
constant FINAL_IMG_HEIGHT : natural := 200;


-- BACKGROUND COLOR !!
constant BG_COLOR : std_logic_vector (11 downto 0) := "011100110000";

-- Position for lives
constant W_HEAD_POS : std_logic_vector (18 downto 0) := "0000111100000011110";
constant GG_HEAD_POS : std_logic_vector (18 downto 0) := "0000111101001000010";
constant W_LBAR_POS : std_logic_vector (18 downto 0) := "0010001100000011110";
constant GG_LBAR_POS : std_logic_vector (18 downto 0) := "0010001101000000010";

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

constant LBAR_OFFSET_1 : natural := 64608;
constant LBAR_OFFSET_2 : natural := 66144;
constant LBAR_OFFSET_3 : natural := 67680;
constant LBAR_OFFSET_4 : natural := 69216;
constant LBAR_OFFSET_5 : natural := 70752;

constant WHEAD_OFFSET : natural := 72288;
constant GGHEAD_OFFSET : natural := 73312;

constant WWON_OFFSET : natural := 74336;
constant GGWON_OFFSET : natural := 154336;


signal reset_graphic : std_logic := '0';

--Signals for the vga
signal pixel_in : std_logic_vector (11 downto 0) := (others => '0');
--signal counter_h, counter_v : std_logic_vector (9 downto 0) := (others => '0');
signal counter_v : natural range 0 to 524;
signal counter_h : natural range 0 to 799;

--Signals for current row and column in map
--signal map_row : std_logic_vector (8 downto 0) := (others => '0');
--signal map_col : std_logic_vector (9 downto 0) := (others => '0');
signal map_row : natural range 0 to 479;
signal map_col : natural range 0 to 679;
signal map_row_vect : std_logic_vector (8 downto 0);
signal map_col_vect : std_logic_vector (9 downto 0);

-- General signals for objects
signal player_enable, player_colored, util_enable, util_colored : std_logic := '0';


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
signal Wolvie_Life_enable, GreenGoblin_Life_enable, Wolvie_Life_colored, GreenGoblin_Life_colored: std_logic := '0';
signal Wolvie_life_cnt, GreenGoblin_life_cnt : std_logic_vector (2 downto 0) := "101";
signal Wolvie_Life_cntV, GreenGoblin_Life_cntV : natural range 0 to LBAR_HEIGHT -1 := 0;
signal Wolvie_Life_cntH, GreenGoblin_Life_cntH : natural range 0 to LBAR_WIDTH -1 := 0;
signal Wolvie_life_address, GreenGoblin_life_address : natural range 0 to LBAR_WIDTH * LBAR_HEIGHT -1;
signal Wolvie_life_offset, GreenGoblin_life_offset : natural range LBAR_OFFSET_1 to LBAR_OFFSET_5;

signal Wolvie_head_enable, GreenGoblin_head_enable : std_logic := '0';
signal Wolvie_head_colored, GreenGoblin_head_colored : std_logic := '0';
signal Wolvie_head_cntV, Wolvie_head_cntH, GreenGoblin_head_cntV, GreenGoblin_head_cntH : natural range 0 to HEAD_SIZE -1 := 0;
signal Wolvie_head_address, GreenGoblin_head_address : natural range 0 to HEAD_SIZE * HEAD_SIZE -1;


-- Sbam
signal Sbam_enable, Sbam_colored : std_logic := '0';
signal Sbam_cntV, Sbam_cntH : natural range 0 to SBAM_SIZE-1;
signal Sbam_address : natural range 0 to SBAM_SIZE * SBAM_SIZE -1;

-- Heart
signal Heart_enable, Heart_colored : std_logic := '0';
signal Heart_cntV, Heart_cntH : natural range 0 to LIFE_SIZE-1;
signal Heart_address : natural range 0 to LIFE_SIZE * LIFE_SIZE -1;

-- final images
signal Wolvie_won_enable, Wolvie_won_colored : std_logic := '0';
signal GreenGoblin_won_enable, GreenGoblin_won_colored : std_logic := '0';
signal Wolvie_won_cntV, GreenGoblin_won_cntV : natural range 0 to FINAL_IMG_HEIGHT-1; 
signal Wolvie_won_cntH, GreenGoblin_won_cntH : natural range 0 to FINAL_IMG_WIDTH-1;
signal Wolvie_won_address, GreenGoblin_won_address : natural range 0 to FINAL_IMG_WIDTH * FINAL_IMG_HEIGHT -1;

-- BROM signals
signal brom_addr : STD_LOGIC_VECTOR(16 DOWNTO 0);
signal brom_pixel_out : STD_LOGIC_VECTOR(11 DOWNTO 0);
signal brom_util_addr : STD_LOGIC_VECTOR(17 DOWNTO 0);
signal brom_util_pixel_out : STD_LOGIC_VECTOR(11 DOWNTO 0);

begin

-- process to create map_row and map_col (Actual position in the screen)
process(pixel_clk)
begin
    if rising_edge(pixel_clk) then
        if start = '0' then
            map_row <= to_integer(unsigned(map_row_vect));
            map_col <= to_integer(unsigned(map_col_vect));
        else
            map_row <= 0;
            map_col <= 0;
        end if;
    end if;
end process;

--process(pixel_clk, map_row, map_col)
--begin
--    if rising_edge(pixel_clk) then
--        if map_row = 0 and map_col = 0 then
--            BG_pixel <= BG_COLOR;
--        end if; 
--    end if;
--end process;

-- Two processes to sync the BG 
process(pixel_clk)
begin
    if rising_edge(pixel_clk) and start = '0' then
        if counter_h = 799 then
            counter_h <= 0;
        elsif counter_h < SCREEN_WIDTH then
            counter_h <= counter_h +1;
--            map_col <= map_col +1;
        else
            counter_h <= counter_h +1;
        end if;
    end if;
end process;

process(pixel_clk)
begin
    if rising_edge(pixel_clk) and start = '0' then
        if counter_h = 799 and counter_v < 524  and counter_v >= SCREEN_HEIGHT then
            counter_v <= counter_v +1;
        elsif counter_h = 799 and counter_v = 524 then
            counter_v <= 0;
--            map_row <= 0;
            BG_pixel <= BG_COLOR;  -- RESET BACKGROUND COLOR !!!
        elsif counter_h = 799 and counter_v < SCREEN_HEIGHT then
            counter_v <= counter_v +1;
--            map_row <= map_row +1;
            
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

reset_graphic <= '1' when map_row = 0 and map_col = 0
                    else '0';

---------------------------------------

---     GREEN GOBLIN processing

---------------------------------------


process(map_col)
begin
    if GreenGoblin_enable = '1' then
        GreenGoblin_cntH <= map_col - to_integer(unsigned (GreenGoblin_pos (9 downto 0)));
        GreenGoblin_cntV <= map_row - to_integer(unsigned (GreenGoblin_pos(18 downto 10)));
    end if;
end process;


process(pixel_clk, GreenGoblin_pos, map_row, map_col)
begin
    if rising_edge(pixel_clk) then
        if (map_row - unsigned(GreenGoblin_pos(18 downto 10))) < PLAYER_SIZE and (map_col - unsigned(GreenGoblin_pos(9 downto 0))) < PLAYER_SIZE then
            GreenGoblin_enable <= '1';
        else
            GreenGoblin_enable <= '0';
        end if;
    end if;
end process;

-- Defining the address in rom of the Green Goblin
--GreenGoblin_address <= GreenGoblin_cntV * PLAYER_SIZE + GreenGoblin_cntH when GreenGoblin_reversed = '0'
--                        else GreenGoblin_cntV * PLAYER_SIZE + PLAYER_SIZE -1 - GreenGoblin_cntH;  -- Picking up the right pixel from BROM
process(pixel_clk, GreenGoblin_reversed, GreenGoblin_cntH, GreenGoblin_cntV)
begin
    if rising_edge(pixel_clk) then
        if GreenGoblin_reversed = '0' then
            GreenGoblin_address <= GreenGoblin_cntV * PLAYER_SIZE + GreenGoblin_cntH;
        else
            GreenGoblin_address <= GreenGoblin_cntV * PLAYER_SIZE + PLAYER_SIZE -1 - GreenGoblin_cntH;
        end if;
    end if;
end process;

-- Defining the offset of the Goblin accroding to the image input
--GreenGoblin_offset <= GG_OFFSET_1 when GreenGoblin_image = "000"
--                    else GG_OFFSET_2 when GreenGoblin_image = "001"
--                    else GG_OFFSET_3 when GreenGoblin_image = "010"
--                    else GG_OFFSET_4 when GreenGoblin_image = "011"
--                    else GG_OFFSET_5 when GreenGoblin_image = "100";

process(pixel_clk, GreenGoblin_image)
begin
    if rising_edge(pixel_clk) then
        if GreenGoblin_image = "000" then
            GreenGoblin_offset <= GG_OFFSET_1;
        elsif GreenGoblin_image = "001" then
            GreenGoblin_offset <= GG_OFFSET_2;
        elsif GreenGoblin_image = "010" then
            GreenGoblin_offset <= GG_OFFSET_3;
        elsif GreenGoblin_image = "011" then
            GreenGoblin_offset <= GG_OFFSET_4;
        elsif GreenGoblin_image = "100" then
            GreenGoblin_offset <= GG_OFFSET_5;
        end if;
    end if;
end process;                                       

                    
---------------------------------------

---   WOLVERINE processing

---------------------------------------

-- Handling the counter for Wolverine
process(map_col)
begin
    if Wolvie_enable = '1' then
        Wolvie_cntH <= map_col - to_integer(unsigned (Wolvie_pos (9 downto 0)));
        Wolvie_cntV <= map_row - to_integer(unsigned (Wolvie_pos(18 downto 10)));
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
process(map_col)
begin
    if Pedana1_enable = '1' then
        Pedana1_cntH <= map_col - to_integer(unsigned (Pedana1_pos (9 downto 0)));
        Pedana1_cntV <= map_row - to_integer(unsigned (Pedana1_pos(18 downto 10)));
    end if;
end process;

-- Handling the counter for the Pedana 2
process(map_col)
begin
    if Pedana2_enable = '1' then
        Pedana2_cntH <= map_col - to_integer(unsigned (Pedana2_pos (9 downto 0)));
        Pedana2_cntV <= map_row - to_integer(unsigned (Pedana2_pos(18 downto 10)));
    end if;
end process;

-- Handling the counter for the Pedana 3
process(map_col)
begin
    if Pedana3_enable = '1' then
        Pedana3_cntH <= map_col - to_integer(unsigned (Pedana3_pos (9 downto 0)));
        Pedana3_cntV <= map_row - to_integer(unsigned (Pedana3_pos(18 downto 10)));
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

-- Handling the counter for Wolverine Life BAR
process(map_col)
begin
    if Wolvie_life_enable = '1' then
        Wolvie_life_cntH <= map_col - to_integer(unsigned (W_LBAR_POS (9 downto 0)));
        Wolvie_life_cntV <= map_row - to_integer(unsigned (W_LBAR_POS(18 downto 10)));
    end if;
end process;

-- Handling the counter for Wolverine HEAD
process(map_col)
begin
    if Wolvie_head_enable = '1' then
        Wolvie_head_cntH <= map_col - to_integer(unsigned (W_HEAD_POS (9 downto 0)));
        Wolvie_head_cntV <= map_row - to_integer(unsigned (W_HEAD_POS(18 downto 10)));
    end if;
end process;


---- Handling the counter for Green Goblin Life BAR
process(map_col)
begin
    if GreenGoblin_life_enable = '1' then
        GreenGoblin_life_cntH <= map_col - to_integer(unsigned (GG_LBAR_POS (9 downto 0)));
        GreenGoblin_life_cntV <= map_row - to_integer(unsigned (GG_LBAR_POS(18 downto 10)));
    end if;
end process;

-- Handling the counter for Green Goblin HEAD
process(map_col)
begin
    if GreenGoblin_head_enable = '1' then
        GreenGoblin_head_cntH <= map_col - to_integer(unsigned (GG_HEAD_POS (9 downto 0)));
        GreenGoblin_head_cntV <= map_row - to_integer(unsigned (GG_HEAD_POS(18 downto 10)));
    end if;
end process;


-- Defining the enable for Wolverine life BAR
Wolvie_Life_enable <= '1' when (map_row - W_LBAR_POS(18 downto 10)) < LBAR_HEIGHT and 
                               (map_col - W_LBAR_POS(9 downto 0)) < (LBAR_WIDTH)
                        else '0';
-- Defining the enable for GreenGoblin life BAR
GreenGoblin_Life_enable <= '1' when (map_row - GG_LBAR_POS(18 downto 10)) < LBAR_HEIGHT and 
                               (map_col - GG_LBAR_POS(9 downto 0)) < (LBAR_WIDTH)
                        else '0';
                        
-- Defining the enable for Wolverine Head
Wolvie_head_enable <= '1' when (map_row - W_HEAD_POS(18 downto 10)) < HEAD_SIZE and 
                               (map_col - W_HEAD_POS(9 downto 0)) < HEAD_SIZE
                        else '0';
-- Defining the enable for GreenGoblin Head
GreenGoblin_head_enable <= '1' when (map_row - GG_HEAD_POS(18 downto 10)) < HEAD_SIZE and 
                               (map_col - GG_HEAD_POS(9 downto 0)) < HEAD_SIZE
                        else '0';
                        


-- Defining the address in memory for Wolverine life BAR
Wolvie_life_address <= Wolvie_life_cntV * LBAR_WIDTH + Wolvie_life_cntH;
-- Defining the address in memory for Green Goblin life BAR
GreenGoblin_life_address <= GreenGoblin_life_cntV * LBAR_WIDTH + LBAR_WIDTH -1 - GreenGoblin_life_cntH;

-- Defining the address in memory for Wolverine Head
Wolvie_head_address <= Wolvie_head_cntV * HEAD_SIZE + Wolvie_head_cntH;
-- Defining the address in memory for Green Goblin Head
GreenGoblin_head_address <= GreenGoblin_head_cntV * HEAD_SIZE + HEAD_SIZE -1 - GreenGoblin_head_cntH;


-- Defining the offset for the life Bar according to the image
Wolvie_life_offset <= LBAR_OFFSET_1 when Wolvie_lives = "100"
                        else LBAR_OFFSET_2 when Wolvie_lives = "011"
                        else LBAR_OFFSET_3 when Wolvie_lives = "010"
                        else LBAR_OFFSET_4 when Wolvie_lives = "001"
                        else LBAR_OFFSET_5 when Wolvie_lives = "000";
                        
GreenGoblin_life_offset <= LBAR_OFFSET_1 when GreenGoblin_lives = "100"
                        else LBAR_OFFSET_2 when GreenGoblin_lives = "011"
                        else LBAR_OFFSET_3 when GreenGoblin_lives = "010"
                        else LBAR_OFFSET_4 when GreenGoblin_lives = "001"
                        else LBAR_OFFSET_5 when GreenGoblin_lives = "000";
 

------------------------------------------------------------------------

-- Projecting the SBAM image

-------------------------------------------------------------------------

-- Handling the counter for the SBAM image
process(map_col)
begin
    if Sbam_enable = '1' then
        Sbam_cntH <= map_col - to_integer(unsigned (Sbam_pos (9 downto 0)));
        Sbam_cntV <= map_row - to_integer(unsigned (Sbam_pos (18 downto 10)));
    end if;
end process;

-- defining the sbam image enabler
Sbam_enable <=  '0' when Sbam_pos = "0000000000000000000"
                else '1' when (map_row - Sbam_pos(18 downto 10)) < SBAM_SIZE and (map_col - Sbam_pos(9 downto 0)) < SBAM_SIZE
                else '0';

-- Defining the address in rom of the Sbam image
Sbam_address <= Sbam_cntV * SBAM_SIZE + Sbam_cntH;


------------------------------------------------------------------------

-- Projecting the HEART image

-------------------------------------------------------------------------

-- Handling the counter for the HEART image
process(map_col)
begin
    if Heart_enable = '1' then
        Heart_cntH <= map_col - to_integer(unsigned (Heart_pos (9 downto 0)));
        Heart_cntV <= map_row - to_integer(unsigned (Heart_pos (18 downto 10)));
    end if;
end process;

-- defining the Heart image enabler
Heart_enable <=  '0' when Heart_pos = "0000000000000000000"
                else '1' when (map_row - Heart_pos(18 downto 10)) < LIFE_SIZE and (map_col - Heart_pos(9 downto 0)) < LIFE_SIZE
                else '0';

-- Defining the address in rom of the Heart image
Heart_address <= Heart_cntV * LIFE_SIZE + Heart_cntH;



------------------------------------------------------------------------

-- Projecting the final images

-------------------------------------------------------------------------

-- Handling the counter for the Wolvie won image
process(map_col)
begin
    if Wolvie_won_enable = '1' then
        Wolvie_won_cntH <= map_col - to_integer(unsigned (Wolvie_won_pos (9 downto 0)));
        Wolvie_won_cntV <= map_row - to_integer(unsigned (Wolvie_won_pos (18 downto 10)));
    end if;
end process;

-- defining the Wolvie_won image enabler
Wolvie_won_enable <=  '0' when Wolvie_won_pos = "0000000000000000000"
                        else '1' when (map_row - Wolvie_won_pos(18 downto 10)) < FINAL_IMG_HEIGHT and (map_col - Wolvie_won_pos(9 downto 0)) < FINAL_IMG_WIDTH
                        else '0';

-- Defining the address in rom of the Wolvie_won image
Wolvie_won_address <= Wolvie_won_cntV * FINAL_IMG_WIDTH + Wolvie_won_cntH;


process(map_col)
begin
    if GreenGoblin_won_enable = '1' then
        GreenGoblin_won_cntH <= map_col - to_integer(unsigned (GreenGoblin_won_pos (9 downto 0)));
        GreenGoblin_won_cntV <= map_row - to_integer(unsigned (GreenGoblin_won_pos (18 downto 10)));
    end if;
end process;

-- defining the GreenGoblin_won image enabler
GreenGoblin_won_enable <=  '0' when GreenGoblin_won_pos = "0000000000000000000"
                        else '1' when (map_row - GreenGoblin_won_pos(18 downto 10)) < FINAL_IMG_HEIGHT and (map_col - GreenGoblin_won_pos(9 downto 0)) < FINAL_IMG_WIDTH
                        else '0';

-- Defining the address in rom of the GreenGoblin_won image
GreenGoblin_won_address <= GreenGoblin_won_cntV * FINAL_IMG_WIDTH + GreenGoblin_won_cntH;

------------------------------------------------------------------------

-- Multiplexing the address to be given to the rom

-------------------------------------------------------------------------

process(pixel_clk)
begin
    if rising_edge(pixel_clk) and start = '0' then
        if GreenGoblin_enable = '1' then
            brom_addr <= std_logic_vector(to_unsigned(GreenGoblin_address + GreenGoblin_offset, BROM_DEPTH));
        elsif Wolvie_enable = '1' then
            brom_addr <= std_logic_vector(to_unsigned(Wolvie_address + Wolvie_offset, BROM_DEPTH));
        end if;
    end if;
end process;

        
process(pixel_clk)
begin
    if rising_edge(pixel_clk) and start = '0' then
        if Wolvie_won_enable = '1' then
            brom_util_addr <= std_logic_vector(to_unsigned(Wolvie_won_address + WWON_OFFSET, BROM_PEDANA_DEPTH));
        elsif GreenGoblin_won_enable = '1' then
            brom_util_addr <= std_logic_vector(to_unsigned(GreenGoblin_won_address + GGWON_OFFSET, BROM_PEDANA_DEPTH));
        elsif Sbam_enable = '1' then
            brom_util_addr <= std_logic_vector(to_unsigned(Sbam_address + SBAM_OFFSET, BROM_PEDANA_DEPTH));
        elsif Heart_enable = '1' then
            brom_util_addr <= std_logic_vector(to_unsigned(Heart_address + LIFE_OFFSET, BROM_PEDANA_DEPTH));
        elsif Wolvie_life_enable = '1' then
             brom_util_addr <= std_logic_vector(to_unsigned(Wolvie_life_address + Wolvie_life_offset, BROM_PEDANA_DEPTH));
        elsif GreenGoblin_life_enable = '1' then
            brom_util_addr <= std_logic_vector(to_unsigned(GreenGoblin_life_address + GreenGoblin_life_offset, BROM_PEDANA_DEPTH));
        elsif GreenGoblin_head_enable = '1' then
            brom_util_addr <= std_logic_vector(to_unsigned(GreenGoblin_head_address + GGHEAD_OFFSET, BROM_PEDANA_DEPTH));
        elsif Wolvie_head_enable = '1' then
            brom_util_addr <= std_logic_vector(to_unsigned(Wolvie_head_address + WHEAD_OFFSET, BROM_PEDANA_DEPTH));
        elsif Pedana1_enable = '1' then
            brom_util_addr <= std_logic_vector(to_unsigned(Pedana1_address + Pedana1_offset, BROM_PEDANA_DEPTH));
        elsif Pedana2_enable = '1' then
            brom_util_addr <= std_logic_vector(to_unsigned(Pedana2_address + Pedana2_offset, BROM_PEDANA_DEPTH));
        elsif Pedana3_enable = '1' then
            brom_util_addr <= std_logic_vector(to_unsigned(Pedana3_address + Pedana3_offset, BROM_PEDANA_DEPTH));
        end if;
    end if;
end process;



-- Computing the enabler and the colored signals
player_enable <= GreenGoblin_enable or Wolvie_enable;  -- Logical OR among all the possible objects
util_enable <= Pedana1_enable or Pedana2_enable or Pedana3_enable or Wolvie_life_enable or GreenGoblin_life_enable 
                or Wolvie_head_enable or GreenGoblin_head_enable or Heart_enable;

player_colored <= '0' when brom_pixel_out = "111111111111"
                    else '1';
util_colored <= '0' when brom_util_pixel_out = "111111111111" and util_enable = '1'
                    else '1';
                    
Wolvie_won_colored <= '0' when brom_util_pixel_out = "111111111111" and Wolvie_won_enable = '1'
                        else '1';
GreenGoblin_won_colored <= '0' when brom_util_pixel_out = "111111111111" and GreenGoblin_won_enable = '1'
                        else '1';
Sbam_colored <= '0' when brom_util_pixel_out = "111111111111" and Sbam_enable = '1'
                        else '1';
------------------------------------------------------------------------

-- Multiplexing the pixel to be given to the vga according to the enablers

-------------------------------------------------------------------------


process (pixel_clk)
begin
    if rising_edge(pixel_clk) and start = '0' then
        if Wolvie_won_colored = '1' and Wolvie_won_enable = '1' then
            pixel_in <= brom_util_pixel_out;
        elsif GreenGoblin_won_colored = '1' and GreenGoblin_won_enable = '1' then
            pixel_in <= brom_util_pixel_out;
        elsif Sbam_colored = '1' and Sbam_enable = '1' then
            pixel_in <= brom_util_pixel_out;
        elsif (Heart_enable = '1' and Pedana1_enable = '1') or (Heart_enable = '1' and Pedana1_enable = '1') or (Heart_enable = '1' and Pedana1_enable = '1') then
            if util_colored = '0' then
                pixel_in <= BG_pixel;
            else
                pixel_in <= brom_util_pixel_out;
            end if;   
        elsif player_enable = '1' and player_colored = '1' then
            pixel_in <= brom_pixel_out;
        elsif util_enable = '1' and util_colored = '1' then
            pixel_in <= brom_util_pixel_out;
        elsif map_row < WALL or map_col < WALL or map_col > SCREEN_WIDTH - WALL -1 or map_row > SCREEN_HEIGHT - WALL -1 then
            pixel_in <= "001100110011";
        else
            pixel_in <= BG_pixel;
        end if;
    end if;
end process;

 



-- Instantiation of components

inst_vga : vga
port map (
    pixel_clk   => pixel_clk,
    pixel       => pixel_in,
    reset       => start,
    map_row     => map_row_vect,
    map_col     => map_col_vect,
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
