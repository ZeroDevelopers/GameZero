----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.04.2017 10:35:21
-- Design Name: 
-- Module Name: vga - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga is
    Port ( pixel_clk : in STD_LOGIC;
           pixel : in STD_LOGIC_VECTOR (11 downto 0);
           reset : in STD_LOGIC;
           red : out STD_LOGIC_VECTOR (3 downto 0);
           green : out STD_LOGIC_VECTOR (3 downto 0);
           blue : out STD_LOGIC_vector (3 downto 0);
           HS : out STD_LOGIC;
           VS : out STD_LOGIC);
end vga;

architecture Behavioral of vga is

constant FRAME_WIDTH : natural := 640;
constant FRAME_HEIGHT : natural := 480;

constant H_FP : natural := 16; --H front porch width (pixels)
constant H_PW : natural := 96; --H sync pulse width (pixels)
constant H_MAX : natural := 800; --H total period (pixels)

constant V_FP : natural := 10; --V front porch width (lines)
constant V_PW : natural := 2; --V sync pulse width (lines)
constant V_MAX : natural := 525; --V total period (lines)

constant H_POL : std_logic := '0';
constant V_POL : std_logic := '0';
 
signal h_sync : std_logic := not(H_POL);
signal v_sync : std_logic := not(V_POL);
signal h_counter, v_counter : std_logic_vector(9 downto 0) := (others => '0');
signal video_on, video_on_h, video_on_v : std_logic := '0';

begin

HS <= h_sync;
VS <= v_sync;

h_counter <= (others => '0') when reset = '1';
v_counter <= (others => '0') when reset = '1';

--Horizontal counting
process(pixel_clk)
begin
    if rising_edge(pixel_clk) then
        if h_counter = H_MAX -1 then
            h_counter <= (others => '0');
        else
            h_counter <= h_counter +1;
        end if;
    end if;
end process;

-- Vertical counting
process (pixel_clk)
  begin
    if (rising_edge(pixel_clk)) then
      if ((h_counter = (H_MAX - 1)) and (v_counter = (V_MAX - 1))) then
        v_counter <= (others =>'0');
      elsif (h_counter = (H_MAX - 1)) then
        v_counter <= v_counter + 1;
      end if;
    end if;
end process;

-- Horizontal sync
 process (pixel_clk)
 begin
   if (rising_edge(pixel_clk)) then
     if (h_counter >= (H_FP + FRAME_WIDTH)) and (h_counter <= (H_FP + FRAME_WIDTH + H_PW -1)) then
       h_sync <= H_POL;
     else
       h_sync <= not(H_POL);
     end if;
   end if;
end process;

 -- Vertical sync
process (pixel_clk)
begin
   if (rising_edge(pixel_clk)) then
      if (v_counter >= (V_FP + FRAME_HEIGHT)) and (v_counter <= (V_FP + FRAME_HEIGHT + V_PW - 1)) then
        v_sync <= V_POL;
      else
        v_sync <= not(V_POL);
      end if;
   end if;
end process;

video_on_h <= '1' when h_counter < 640
                  else '0';  
                  
video_on_v <= '1' when v_counter < 480
                  else '0';

video_on <= '1' when (video_on_h = '1') and (video_on_v = '1')
                else '0';

-- Writing on the screen
process(pixel_clk, video_on,  pixel)
begin
    if rising_edge(pixel_clk) then
        if video_on = '1' then
            red <= pixel(11 downto 8);
            green <= pixel(7 downto 4);
            blue <= pixel(3 downto 0);
        else
            red <= (others => '0');
            green <= (others => '0');
            blue <= (others => '0');
        end if;
    end if;
end process;

end Behavioral;
