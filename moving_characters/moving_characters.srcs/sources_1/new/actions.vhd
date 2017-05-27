----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2017 19:00:26
-- Design Name: 
-- Module Name: actions - Behavioral
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

entity actions is
      Port (frame_clk : in STD_LOGIC;
            switch : in STD_LOGIC;
            btnDx : in STD_LOGIC;
            btnL : in STD_LOGIC;
            btnU : in STD_LOGIC;
            btnD : in STD_LOGIC;
            GreenGoblin_pos : inout std_logic_vector (18 downto 0);
            GreenGoblin_reversed : inout std_logic;
            GreenGoblin_image : inout std_logic_vector (2 downto 0);
            Wolvie_pos : inout std_logic_vector (18 downto 0);
            Wolvie_reversed : inout std_logic;
            Wolvie_image : inout std_logic_vector (3 downto 0)
      );
end actions;

architecture Behavioral of actions is


--Constants
constant WALL_WIDTH : natural := 20;
constant SCREEN_WIDTH : natural := 640;
constant SCREEN_HEIGHT : natural := 480;


-- Signals for the Green Goblin
constant GG_ACTION_FRAMES : natural := 10;
signal GG_action_cnt : natural range 0 to GG_ACTION_FRAMES -1;

-- Signals for Wolverine
constant W_ACTION_FRAMES : natural := 10;
signal W_action_cnt : natural range 0 to W_ACTION_FRAMES -1;

--signals for movement and action
signal Mov_Right : STD_LOGIC := '0';
signal Mov_Left : STD_LOGIC := '0';
signal Jump : STD_LOGIC := '0';
signal Action : STD_LOGIC := '0';
signal dec_signal : STD_LOGIC_VECTOR (3 downto 0);
signal frames_cnt : STD_LOGIC := '0'; --this is a counter for the dec_signal to count the frame of movement, jump and action





signal frame_mov_cnt : std_logic;

begin

--counter for the enable

process(frames_cnt)
begin
    if frames_cnt = '0' then
        dec_signal(3) <= '1';
    else
        frames_cnt <= frames_cnt - 1;
    end if;
end process;

--decoder to decide the action

process(dec_signal)
begin

end process;


---- Process to move the Green Goblin

process(frame_clk, GreenGoblin_reversed, Mov_Right, Mov_Left, switch)
begin
    if rising_edge(frame_clk) then
        if switch = '1' then
            if GreenGoblin_reversed = '0' and Mov_Left = '1' then
                GreenGoblin_reversed <= '1';
            elsif GreenGoblin_reversed = '1' and Mov_Right = '1' then
                GreenGoblin_reversed <= '0';
            end if;
        end if;
    end if;
end process;

process(frame_clk, GreenGoblin_reversed, Mov_Right, Mov_Left, switch)
begin
    if rising_edge(frame_clk) then
         if switch = '1' then
             if frame_mov_cnt = '1' then
               if GreenGoblin_reversed = '1' then
                 if Mov_Left = '1' then
                    if GreenGoblin_pos (9 downto 0) <= (WALL_WIDTH) then
                        GreenGoblin_pos <= GreenGoblin_pos +2;
                    else
                        GreenGoblin_pos <= GreenGoblin_pos;
                    end if;
                 end if;         
               else
                 if Mov_Right = '1' then
                   if GreenGoblin_pos (9 downto 0) >= (640 - 63 - WALL_WIDTH) then
                      GreenGoblin_pos <= GreenGoblin_pos -2;
                   else
                      GreenGoblin_pos <= GreenGoblin_pos;
                   end if;
                 end if;    
               end if;
             else
             frame_mov_cnt <= not frame_mov_cnt;
            end if;
        end if;
    end if;
end process;

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

end Behavioral;
