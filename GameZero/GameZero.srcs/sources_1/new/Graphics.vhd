----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.04.2017 15:02:05
-- Design Name: 
-- Module Name: Graphics - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Graphics is
     Port ( 
          clk : in STD_LOGIC;
          red : out STD_LOGIC_VECTOR (3 downto 0);
          green : out STD_LOGIC_VECTOR (3 downto 0);
          blue : out STD_LOGIC_vector (3 downto 0);
          HS : out STD_LOGIC;
          VS : out STD_LOGIC
     );
end Graphics;

architecture Behavioral of Graphics is

component BRAM_VGA_Clock
    PORT(
      clk_out1: out STD_LOGIC;
      reset: in STD_LOGIC;
      locked: out STD_LOGIC;
      clk_in1: in STD_LOGIC
    );
end component;

component vga
    port (
          pixel_clk : in STD_LOGIC;
          pixel : in STD_LOGIC_VECTOR (11 downto 0);
          reset : in std_logic;
          red : out STD_LOGIC_VECTOR (3 downto 0);
          green : out STD_LOGIC_VECTOR (3 downto 0);
          blue : out STD_LOGIC_vector (3 downto 0);
          HS : out STD_LOGIC;
          VS : out STD_LOGIC
          );
end component;

component RAM_VGA 
    port(
        clk   : in  std_logic;
        wen   : in  std_logic;
        datain  : in  std_logic_vector(11 downto 0);
        waddress  : in  std_logic_vector(18 downto 0);
        raddress  : in  std_logic_vector(18 downto 0);
        pixel : out std_logic_vector(11 downto 0)
     );
end component;


-- Declaring signals
signal pixel_clk : STD_LOGIC;
signal wen : STD_LOGIC;
signal raddress, waddress : STD_LOGIC_VECTOR(18 downto 0);
signal pixel, datain : STD_LOGIC_VECTOR(11 downto 0);


signal start, black : std_logic := '1';
signal i, n: STD_LOGIC_VECTOR (8 downto 0) := (others => '0');
signal j, m: STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
signal waddress_reg : STD_LOGIC_VECTOR(18 downto 0);
signal reset_vga : std_logic := '1';

signal blank_h_cnt : natural range 0 to 159;
signal blank_v_cnt : natural range 0 to 44;


begin

     
-- writing initial map on ram
process(pixel_clk, start)
begin
    if rising_edge(pixel_clk) then
        if start = '1' then
            waddress_reg (18 downto 10) <= i;
            waddress_reg (9 downto 0) <= j;
            
            if j = 639 then 
                if i > 50 then
                    black <= '0';
                end if;
                j <= (others => '0');
                if i = 479 then 
                    i <= (others => '0');
                    start <= '0';
                else
                    i <= i+1;
                end if;
            else
                j <= j+1;
            end if;    
        end if;
        
    end if;
end process;


-- reading from ram and wrinting on vga
process (pixel_clk)
begin
    if rising_edge(pixel_clk) then 
         if start = '0' then
              raddress (18 downto 10) <= n;
              raddress (9 downto 0) <= m;
              if m = 639 then
                  if blank_h_cnt = 159 then
                      m <= (others => '0');
                      blank_h_cnt <= 0;
                      if n = 479 then
                         if blank_v_cnt = 44 then
                              n <= (others => '0');
                              blank_v_cnt <= 0;
                         else
                              blank_v_cnt <= blank_v_cnt + 1;
                         end if;
                      else
                         n <= n + 1;
                      end if;
                  else
                       blank_h_cnt <= blank_h_cnt + 1;
                  end if;
             else
                  m <= m + 1;
             end if;
         end if;
    end if;    
end process;
         

waddress <= waddress_reg;

datain <= (others => '1') when black = '0' else 
          (others => '0');
wen <= start;  
reset_vga <= start;
                  
inst_BRAM_VGA_Clock : BRAM_VGA_Clock
port map (   
        clk_in1 => clk,
        clk_out1 => pixel_clk,
        locked => open,
        reset => '0'
     );
     
     
inst_RAM_VGA : RAM_VGA
port map ( 
    clk => pixel_clk,
    wen => wen,    
    raddress => raddress,
    waddress => waddress,
    datain => datain,
    pixel => pixel
    );
    
inst_vga : vga
port map (
    pixel_clk => pixel_clk,
    pixel => pixel,
    reset => reset_vga,
    red => red,
    green => green,
    blue => blue,
    VS => VS,
    HS => HS
);
end Behavioral;
