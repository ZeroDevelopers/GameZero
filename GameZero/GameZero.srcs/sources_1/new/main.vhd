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
            W_but_left, W_but_right, W_but_mid, W_but_up : in std_logic;
            GG_but_left, GG_but_right, GG_but_mid, GG_but_up : in std_logic;
            reset : in std_logic; -- Starting position of players with all lives
            red : out STD_LOGIC_VECTOR (3 downto 0);
            green : out STD_LOGIC_VECTOR (3 downto 0);
            blue : out STD_LOGIC_vector (3 downto 0);
            HS : out STD_LOGIC;
            VS : out STD_LOGIC
            );
end main;

architecture Behavioral of main is

component graphic is
    Port (  pixel_clk: in STD_LOGIC;
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
            GreenGoblin_lives, Wolvie_lives : in std_logic_vector (2 downto 0);  -- 4 maximum lives
            red : out STD_LOGIC_VECTOR (3 downto 0);
            green : out STD_LOGIC_VECTOR (3 downto 0);
            blue : out STD_LOGIC_vector (3 downto 0);
            HS : out STD_LOGIC;
            VS : out STD_LOGIC
    );
end component;

--Component for the Wolvie movement
component Wolverine_movement is
port (  frame_clk : in std_logic;
        enable : in std_logic;
        reset : in std_logic;
        movement_type : in std_logic_vector (1 downto 0);
        GreenGoblin_pos, Pedana1_pos, Pedana2_pos, Pedana3_pos : in std_logic_vector (18 downto 0);
        Wolvie_curr_pos : in std_logic_vector (18 downto 0);
        Wolvie_curr_image : in std_logic_vector (3 downto 0);
        Wolvie_reversed_in : in std_logic;
        Wolvie_hor_new_pos : out std_logic_vector (9 downto 0);
        Wolvie_new_image : out std_logic_vector (3 downto 0);
        dec_disable : out std_logic;
        Wolvie_reversed_out : out std_logic
     );
end component;

--Component for the Wolvie attack
component Wolvie_attack is
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
end component;

-- Component for Wolverine jump

component Wolvie_jump is
Port (
       frame_clk : in STD_LOGIC; 
       enable :  in STD_LOGIC;
       reset : in std_logic;
       Wolvie_curr_pos : in std_logic_vector (18 downto 0);
       Wolvie_curr_image : in std_logic_vector (3 downto 0); 
       Wolvie_vert_new_pos : out std_logic_vector (8 downto 0);
       Wolvie_new_image : out std_logic_vector (3 downto 0);
       Wolvie_status : out STD_LOGIC;
       GreenGoblin_pos : in STD_LOGIC_VECTOR (18 downto 0);
       Pedana1_pos : in std_logic_vector (18 downto 0);  
       Pedana1_image : in std_logic_vector (1 downto 0);
       Pedana2_pos : in std_logic_vector (18 downto 0);
       Pedana2_image : in std_logic_vector (1 downto 0);
       Pedana3_pos : in std_logic_vector (18 downto 0);
       Pedana3_image : in std_logic_vector (1 downto 0)
     );
end component;

-- Component for GreenGoblin movement

component Green_Goblin_movement is
      Port (
            frame_clk : in STD_LOGIC;
            enable : in STD_LOGIC;
            movement_type: in STD_LOGIC_VECTOR (1 downto 0);
            Wolvie_pos, Pedana1_pos, Pedana2_pos, Pedana3_pos : in STD_LOGIC_VECTOR (18 downto 0);
            Green_Goblin_curr_pos : in STD_LOGIC_VECTOR (18 downto 0);
            Green_Goblin_curr_image : in STD_LOGIC_VECTOR (2 downto 0);
            dec_disable : out STD_LOGIC;
            Green_Goblin_reversed_in : in STD_LOGIC;
            Green_Goblin_reversed_out : out STD_LOGIC;
            Green_Goblin_hor_new_pos : out STD_LOGIC_VECTOR (9 downto 0);
            Green_Goblin_new_image : out STD_LOGIC_VECTOR (2 downto 0)
       );
end component;

-- Component for GreenGoblin attack

component Green_Goblin_attack is
    Port (
            frame_clk : in STD_LOGIC;
            enable : in STD_LOGIC;
            attack_reset : in std_logic;
            GreenGoblin_pos : in STD_LOGIC_VECTOR (18 downto 0);
            Wolvie_pos : in STD_LOGIC_VECTOR (18 downto 0);
            GreenGoblin_reversed : in std_logic;
            GreenGoblin_curr_image : in STD_LOGIC_VECTOR (2 downto 0);
            GreenGoblin_dec_disable : out STD_LOGIC;
            GreenGoblin_new_image : out STD_LOGIC_VECTOR (2 downto 0);
            Wolvie_life_dec : out std_logic;
            Wolvie_attack_reset_out : out std_logic;
            Sbam_active_out : out std_logic
       );
end component;

-- Component for GreenGoblin jump

component Green_Goblin_jump is
    Port (
          frame_clk : in STD_LOGIC;  
          enable : in STD_LOGIC;
          GreenGoblin_curr_pos : in STD_LOGIC_VECTOR (18 downto 0);
          GreenGoblin_vert_new_pos : out STD_LOGIC_VECTOR (8 downto 0);
          GreenGoblin_new_image : out STD_LOGIC_VECTOR (2 downto 0);
          GreenGoblin_status : out STD_LOGIC;
          Wolvie_pos : in STD_LOGIC_VECTOR (18 downto 0);
          Pedana1_pos : in std_logic_vector (18 downto 0);  
          Pedana1_image : in std_logic_vector (1 downto 0);
          Pedana2_pos : in std_logic_vector (18 downto 0);
          Pedana2_image : in std_logic_vector (1 downto 0);
          Pedana3_pos : in std_logic_vector (18 downto 0);
          Pedana3_image : in std_logic_vector (1 downto 0)
    );
end component;
    
-- Generator for the pixel clk
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
constant PEDANA_WIDTH : natural := 200;

--constants for mapping movement
constant RIGHT : STD_LOGIC_VECTOR (1 downto 0) := "00";
constant LEFT : STD_LOGIC_VECTOR (1 downto 0) := "01";
constant JUMP : STD_LOGIC_VECTOR (1 downto 0) := "10";

-- Starting Positions
constant WOLVIE_START_HOR_POS : std_logic_vector(9 downto 0) := "0101111110";
constant WOLVIE_START_VERT_POS : std_logic_vector(8 downto 0) := "110000000";

-- Pedana constants for movement
constant P_ACTION_FRAME : natural := 30;
constant P_MOVING_FRAMES : natural := 600;


-- signals to create the FRAME_CLOCK
constant FRAME_PIXELS : natural := 420000;
signal frame_clk_cnt : natural range 0 to FRAME_PIXELS / 2;

signal pixel_clk, frame_clk : std_logic := '0';

-- Signals for the Green Goblin
signal GreenGoblin_lives : std_logic_vector(2 downto 0) := "100";
signal GreenGoblin_pos : std_logic_vector (18 downto 0);
signal GreenGoblin_hor_pos : STD_LOGIC_VECTOR (9 downto 0) := "0000010100";
signal GreenGoblin_vert_pos : STD_LOGIC_VECTOR (8 downto 0) := "110010000";
signal GreenGoblin_reversed_in : std_logic := '0';
signal GreenGoblin_image, GreenGoblin_mov_image, GreenGoblin_att_image, GreenGoblin_jump_image : std_logic_vector (2 downto 0) := (others => '0');
signal GreenGoblin_mov_enable, GreenGoblin_att_enable, GreenGoblin_jump_enable : std_logic;
signal GreenGoblin_mov_type : std_logic_vector (1 downto 0);
signal GreenGoblin_reversed_out : std_logic;
signal GG_dec_mov_disable, GG_dec_att_disable, GG_jump_status: std_logic;


-- Signals for Wolverine
signal Wolvie_lives : std_logic_vector(2 downto 0) := "100";
signal Wolvie_pos: std_logic_vector (18 downto 0);
signal Wolvie_hor_pos : STD_LOGIC_VECTOR (9 downto 0);
signal Wolvie_vert_pos : STD_LOGIC_VECTOR (8 downto 0);
signal Wolvie_reversed_in : std_logic := '0';  -- At the normal orientation it is towrd right
signal Wolvie_image, Wolvie_mov_image, Wolvie_att_image, Wolvie_jump_image : std_logic_vector (3 downto 0) := "0000";
-- Movement signals
signal Wolvie_mov_enable, Wolvie_att_enable, Wolvie_jump_enable : std_logic;
signal Wolvie_mov_type : std_logic_vector (1 downto 0);
signal Wolvie_reversed_out : std_logic;
signal W_dec_mov_disable, W_dec_att_disable, W_jump_status: std_logic;

-- Signals for the Pedana
signal Pedana1_pos: std_logic_vector (18 downto 0) := "0001100100011011100"; --"0001100100011011100";
signal Pedana2_pos: std_logic_vector (18 downto 0) := "0101101000001000110"; --"0101101000001000110";
signal Pedana3_pos: std_logic_vector (18 downto 0) := "1001111110101110010"; --"1001111110101110010";
signal Pedana1_image : std_logic_vector(1 downto 0) := "10";
signal Pedana2_image : std_logic_vector(1 downto 0) := "10";
signal Pedana3_image : std_logic_vector(1 downto 0) := "10";
signal P1_action_cnt, P2_action_cnt, P3_action_cnt : natural range 0 to P_ACTION_FRAME -1 := 0;
signal P_moving_cnt : natural range 0 to P_MOVING_FRAMES -1 := 0;
signal P_select : std_logic_vector (1 downto 0);
signal P_pos_tmp, P_tmp_tmp : std_logic_vector(9 downto 0);
signal P1_moving, P2_moving, P3_moving : std_logic := '0'; -- These are the enablers 
signal P1_actual_moving, P2_actual_moving, P3_actual_moving : std_logic := '0';  -- flags to determine wether finishing the animation
signal P1_closing, P2_closing, P3_closing : std_logic; 


-- Signals for the sbam
signal Sbam_enable : std_logic := '0';


-- Decoder control signals
signal W_dec_disable : std_logic;

signal GG_dec_disable : std_logic;


-- Tmp signals
signal Wolvie_attack_reset, GreenGoblin_life_dec, GreenGoblin_attack_reset, Wolvie_life_dec : std_logic := '0';



signal start : STD_LOGIC;




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



-- Decoder for Wolverine
W_dec_disable <= W_dec_mov_disable or W_dec_att_disable;  -- Logical or among all the disablers

process (frame_clk, W_dec_disable)
begin
    if rising_edge(frame_clk) then
        if W_dec_disable = '0' then
            if W_but_right = '1' then
                Wolvie_mov_enable <= '1';
                Wolvie_mov_type <= RIGHT;
            elsif W_but_left = '1' then
                Wolvie_mov_enable <= '1';
                Wolvie_mov_type <= LEFT;
           elsif W_but_mid = '1' then
                Wolvie_att_enable <= '1';
           elsif W_but_up = '1' then
                if W_jump_status = '0' then
                    Wolvie_jump_enable <= '1';
                else
                    Wolvie_jump_enable <= '0';
                end if;     
           end if;
        else
            Wolvie_att_enable <= '0';
            Wolvie_mov_enable <= '0';
            Wolvie_jump_enable <= '0';
        end if;
    end if;
end process;


--decoder for GreenGoblin
GG_dec_disable <= GG_dec_mov_disable OR GG_dec_att_disable;

process (frame_clk, GG_dec_disable)
begin
    if rising_edge(frame_clk) then
        if GG_dec_disable = '0' then
            if GG_but_right = '1' then
                GreenGoblin_mov_enable <= '1';
                GreenGoblin_mov_type <= RIGHT;
            elsif GG_but_left = '1' then
                GreenGoblin_mov_enable <= '1';
                GreenGoblin_mov_type <= LEFT;
           elsif GG_but_mid = '1' then
                GreenGoblin_att_enable <= '1';
           elsif GG_but_up = '1' AND W_jump_status = '0' then
                GreenGoblin_jump_enable <= '1'; 
           end if;
        else
            GreenGoblin_att_enable <= '0';
            GreenGoblin_mov_enable <= '0';
            GreenGoblin_jump_enable <= '0';
        end if;
    end if;
end process;


-- Choose among the different images
Wolvie_image <= Wolvie_att_image when W_dec_att_disable = '1'
                else Wolvie_jump_image when W_jump_status = '1'
                else Wolvie_mov_image when W_dec_mov_disable = '1';

GreenGoblin_image <= GreenGoblin_att_image when GG_dec_att_disable = '1'
                else GreenGoblin_jump_image when GG_jump_status = '1'
                else GreenGoblin_mov_image when GG_dec_mov_disable = '1';

                
process(frame_clk)
begin   
        if rising_edge(frame_clk) then
            if reset = '0' then
                GreenGoblin_pos (18 downto 0) <= "1100100000000010100";
                Wolvie_pos <= "1100000000101111110";
            else 
                Wolvie_pos (18 downto 10) <= Wolvie_vert_pos (8 downto 0);
                Wolvie_pos (9 downto 0) <= Wolvie_hor_pos (9 downto 0);
                GreenGoblin_pos (18 downto 10) <= GreenGoblin_vert_pos (8 downto 0);
                GreenGoblin_pos (9 downto 0) <= GreenGoblin_hor_pos (9 downto 0);
            end if;        
        end if;
end process;

-- Defining the "random" position of pedanas
process (frame_clk, GreenGoblin_pos, Wolvie_pos)
begin
    if rising_edge(frame_clk) then
        if P_moving_cnt = P_MOVING_FRAMES -1 then
            P_moving_cnt <= 0;
            
            P_select <= GreenGoblin_pos(1 downto 0) XOR Wolvie_pos(1 downto 0) XOR Wolvie_pos(10 downto 9) XOR GreenGoblin_pos(10 downto 9);
            if P_select = "11" then
                P_select <= "00";
            end if;
            
            -- Selection of the next position for the pedana selected
            P_pos_tmp <= (GreenGoblin_pos(9 downto 0) OR Wolvie_pos(9 downto 0)) XOR Wolvie_pos(18 downto 9) XOR GreenGoblin_pos(18 downto 9);
            
            if P_select = "00" then   
                P1_moving <= '1';
            elsif P_select = "01" then
                P2_moving <= '1';
            elsif P_select = "10" then
                P3_moving <= '1';
            end if;
        else
            P_moving_cnt <= P_moving_cnt +1;
            P1_moving <= '0';
            P2_moving <= '0';
            P3_moving <= '0';
        end if;
    end if;
end process;



-----------------------------------------
-- Processes to move the pedanas ;) ahah
-----------------------------------------

process (frame_clk)
begin
    if rising_edge(frame_clk) and (P1_moving = '1' or P1_actual_moving = '1')  then
        if (P1_moving = '1') then
            P1_actual_moving <= '1';
            Pedana1_image <= "01";  -- Start closing the selected pedana
            P1_closing <= '1';
        end if;
        if P1_action_cnt = P_ACTION_FRAME -1 then
            P1_action_cnt <= 0;
            if Pedana1_image = "10" then
                P1_actual_moving <= '0';
            elsif Pedana1_image = "00" and P1_closing = '0' then
                Pedana1_image <= "01";
            elsif Pedana1_image = "01" and P1_closing = '0' then
                Pedana1_image <= "10";
            elsif Pedana1_image = "01" and P1_closing = '1' then
                Pedana1_image <= "00";
            elsif Pedana1_image = "00" and P1_closing = '1' then
                P1_closing <= '0';
                if P_pos_tmp < WALL_WIDTH  OR  P_pos_tmp + PEDANA_WIDTH + WALL_WIDTH > SCREEN_WIDTH then
                    Pedana1_pos (9 downto 0) <= "0010110100";
                else
                    Pedana1_pos (9 downto 0) <= P_pos_tmp;
                end if;
            end if;
        else
            P1_action_cnt <= P1_action_cnt +1;
        end if;
    end if;
end process;

process (frame_clk)
begin
    if rising_edge(frame_clk) and (P2_moving = '1' or P2_actual_moving = '1')  then
        if (P2_moving = '1') then
            P2_actual_moving <= '1';
            Pedana2_image <= "01";  -- Start closing the selected pedana
            P2_closing <= '1';
        end if;
        if P2_action_cnt = P_ACTION_FRAME -1 then
            P2_action_cnt <= 0;
           if Pedana2_image = "10" then
                P2_actual_moving <= '0';
            elsif Pedana2_image = "00" and P2_closing = '0' then
                Pedana2_image <= "01";
            elsif Pedana2_image = "01" and P2_closing = '0' then
                Pedana2_image <= "10";
            elsif Pedana2_image = "01" and P2_closing = '1' then
                Pedana2_image <= "00";
            elsif Pedana2_image = "00" and P2_closing = '1' then
                P2_closing <= '0';
                if P_pos_tmp < WALL_WIDTH  OR  P_pos_tmp + PEDANA_WIDTH + WALL_WIDTH > SCREEN_WIDTH then
                    Pedana2_pos (9 downto 0) <= "0010110100";
                else
                    Pedana2_pos (9 downto 0) <= P_pos_tmp;
                end if;
            end if;
        else
            P2_action_cnt <= P2_action_cnt +1;
        end if;
    end if;
end process;

process (frame_clk)
begin
    if rising_edge(frame_clk) and (P3_moving = '1' or P3_actual_moving = '1')  then
        if (P3_moving = '1') then
            P3_actual_moving <= '1';
            Pedana3_image <= "01";  -- Start closing the selected pedana
            P3_closing <= '1';
        end if;
        if P3_action_cnt = P_ACTION_FRAME -1 then
            P3_action_cnt <= 0;
            if Pedana3_image = "10" then
                P3_actual_moving <= '0';
            elsif Pedana3_image = "00" and P3_closing = '0' then
                Pedana3_image <= "01";
            elsif Pedana3_image = "01" and P3_closing = '0' then
                Pedana3_image <= "10";
            elsif Pedana3_image = "01" and P3_closing = '1' then
                Pedana3_image <= "00";
            elsif Pedana3_image = "00" and P3_closing = '1' then
                P3_closing <= '0';
               if P_pos_tmp < WALL_WIDTH  OR  P_pos_tmp + PEDANA_WIDTH + WALL_WIDTH > SCREEN_WIDTH then
                    Pedana3_pos (9 downto 0) <= "0010110100";
                else
                    Pedana3_pos (9 downto 0) <= P_pos_tmp;
                end if;
            end if;
        else
            P3_action_cnt <= P3_action_cnt +1;
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

---- Process to animate the Green Goblin
--process (frame_clk)
--begin
--    if rising_edge(frame_clk) then
--        if GG_action_cnt = GG_ACTION_FRAMES -1 then
--            GG_action_cnt <= 0;
--            if GreenGoblin_image < 5 then
--                GreenGoblin_image <= GreenGoblin_image+1;
--            else
--                GreenGoblin_image <= "000";
--            end if;
--        else
--            GG_action_cnt <= GG_action_cnt +1;   
--        end if;
--    end if;
--end process;


---- Process to animate Wolverine
--process (frame_clk)
--begin
--    if rising_edge(frame_clk) then
--        if W_action_cnt = W_ACTION_FRAMES -1 then
--            W_action_cnt <= 0;
--            if Wolvie_image < 11 then
--                Wolvie_image <= Wolvie_image+1;
--            else
--                Wolvie_image <= "0000";
--            end if;
--        else
--            W_action_cnt <= W_action_cnt +1;   
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
    GreenGoblin_reversed    => GreenGoblin_reversed_in,
    GreenGoblin_image       => GreenGoblin_image,
    Wolvie_pos              => Wolvie_pos,
    Wolvie_reversed         => Wolvie_reversed_out,
    Wolvie_image            => Wolvie_image,
    Pedana1_pos             => Pedana1_pos,
    Pedana2_pos             => Pedana2_pos,
    Pedana3_pos             => Pedana3_pos,
    Pedana1_image           => Pedana1_image,
    Pedana2_image           => Pedana2_image,
    Pedana3_image           => Pedana3_image,
    Wolvie_lives            => Wolvie_lives,
    GreenGoblin_lives       => GreenGoblin_lives,
    red                     => red,
    green                   => green,
    blue                    => blue,
    HS                      => HS,
    VS                      => VS
);




inst_Wolvie_mov : Wolverine_movement
port map 
(   frame_clk           => frame_clk,
    enable              => wolvie_mov_enable,
    reset               => reset,
    movement_type       => wolvie_mov_type,
    GreenGoblin_pos     => GreenGoblin_pos,
    Pedana1_pos         => Pedana1_pos,
    Pedana2_pos         => Pedana2_pos,
    Pedana3_pos         => Pedana3_pos,
    Wolvie_curr_pos     => Wolvie_pos,
    Wolvie_curr_image   => Wolvie_image,
    Wolvie_reversed_in  => Wolvie_reversed_in,
    dec_disable         => W_dec_mov_disable,
    Wolvie_reversed_out => Wolvie_reversed_out,
    Wolvie_hor_new_pos      => Wolvie_hor_pos,
    Wolvie_new_image    => Wolvie_mov_image
);



inst_Wolvie_att : Wolvie_attack
port map 
(   frame_clk           => frame_clk,
    enable              => wolvie_att_enable,
    attack_reset        => Wolvie_attack_reset,
    GreenGoblin_pos     => GreenGoblin_pos,
    Wolvie_pos          => Wolvie_pos,
    Wolvie_curr_image   => Wolvie_image,
    Wolvie_reversed     => Wolvie_reversed_in,
    Wolvie_dec_disable  => W_dec_att_disable,
    Wolvie_new_image    => Wolvie_att_image,
    GreenGoblin_life_dec    => GreenGoblin_life_dec,
    GreenGoblin_attack_reset_out    => GreenGoblin_attack_reset,
    Sbam_active_out     => Sbam_enable
);




inst_Wolvie_jump : Wolvie_jump
port map
(   frame_clk           => frame_clk,
    enable              => Wolvie_jump_enable,
    reset               => reset,
    Wolvie_vert_new_pos      => Wolvie_vert_pos,
    Wolvie_new_image    => Wolvie_jump_image,
    Wolvie_curr_pos     => Wolvie_pos,
    Wolvie_curr_image   => Wolvie_image,
    Wolvie_status       => W_jump_status,
    GreenGoblin_pos     => GreenGoblin_pos,
    Pedana1_pos         => Pedana1_pos,
    Pedana1_image       => Pedana1_image,
    Pedana2_pos         => Pedana2_pos,
    Pedana2_image       => Pedana2_image,
    Pedana3_pos         => Pedana3_pos,
    Pedana3_image       => Pedana3_image
);




inst_Green_Goblin_mov : Green_Goblin_movement
port map 
(   frame_clk           => frame_clk,
    enable              => GreenGoblin_mov_enable,
    movement_type       => GreenGoblin_mov_type,
    Wolvie_pos          => Wolvie_pos,
    Pedana1_pos         => Pedana1_pos,
    Pedana2_pos         => Pedana2_pos,
    Pedana3_pos         => Pedana3_pos,
    Green_Goblin_curr_pos     => GreenGoblin_pos,
    Green_Goblin_curr_image   => GreenGoblin_image,
    Green_Goblin_reversed_in  => GreenGoblin_reversed_in,
    dec_disable         => GG_dec_mov_disable,
    Green_Goblin_reversed_out => GreenGoblin_reversed_out,
    Green_Goblin_hor_new_pos      => GreenGoblin_hor_pos,
    Green_Goblin_new_image    => GreenGoblin_mov_image
);




inst_Green_Goblin_att : Green_Goblin_attack
port map 
(   frame_clk           => frame_clk,
    enable              => GreenGoblin_att_enable,
    attack_reset        => GreenGoblin_attack_reset,
    GreenGoblin_pos     => GreenGoblin_pos,
    Wolvie_pos          => Wolvie_pos,
    GreenGoblin_curr_image   => GreenGoblin_image,
    GreenGoblin_reversed     => GreenGoblin_reversed_in,
    GreenGoblin_dec_disable  => GG_dec_att_disable,
    GreenGoblin_new_image    => GreenGoblin_att_image,
    Wolvie_life_dec    => GreenGoblin_life_dec,
    Wolvie_attack_reset_out    => Wolvie_attack_reset,
    Sbam_active_out     => Sbam_enable
);




inst_Green_Goblin_jump : Green_Goblin_jump
port map
(   frame_clk           => frame_clk,
    enable              => GreenGoblin_jump_enable,
    GreenGoblin_vert_new_pos      => GreenGoblin_vert_pos,
    GreenGoblin_new_image    => GreenGoblin_jump_image,
    GreenGoblin_curr_pos     => GreenGoblin_pos,
    GreenGoblin_status       => GG_jump_status,
    Wolvie_pos          => Wolvie_pos,
    Pedana1_pos         => Pedana1_pos,
    Pedana1_image       => Pedana1_image,
    Pedana2_pos         => Pedana2_pos,
    Pedana2_image       => Pedana2_image,
    Pedana3_pos         => Pedana3_pos,
    Pedana3_image       => Pedana3_image
);


end Behavioral;