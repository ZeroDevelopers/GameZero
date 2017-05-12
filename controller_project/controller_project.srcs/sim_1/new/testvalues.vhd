----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.05.2017 00:37:19
-- Design Name: 
-- Module Name: testvalues - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testvalues is
--   Port ( );
end testvalues;

architecture Behavioral of testvalues is
--declare components to test
     component controller 
      Port (
        clk: in STD_LOGIC;
        Led: out STD_LOGIC_VECTOR (5 downto 0);
        frame_clk_out : out STD_LOGIC;
        DataIn: in STD_LOGIC;
        DataClk: out STD_LOGIC;
        DataLatch_out: out STD_LOGIC
     );
     end component;
     
--declare internal signals

signal DataClk, DataLatch, clk, DataIn, frame_clk_out : STD_LOGIC;
signal Led : STD_LOGIC_VECTOR (5 downto 0);

begin

UUT: controller port map (
            clk => clk, 
            DataIn => DataIn,   
            Led (5) => Led(5), 
            Led (4) => Led(4),
            Led (3) => Led(3), 
            Led (2) => Led(2), 
            Led (1) => Led(1), 
            Led (0) => Led(0), 
            DataClk => DataClk, 
            DataLatch_out => DataLatch,
            frame_clk_out => frame_clk_out
      );
      
      
process
begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
end process;      

process
begin
    --wait for 101 ns;
    DataIn <= '1';
    wait;    
end process;
--    process
--    begin
--        wait for 101 ns;
--        clk <= 100;
--        wait for 18 us;
--        DataIn <= '1';
--        wait for 6 us;
--        DataIn <= '0';
--        wait for 6 us;
--        DataIn <= '1';
--        wait;
--    end process;
end Behavioral;
