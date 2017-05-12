----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.05.2017 20:42:13
-- Design Name: 
-- Module Name: controller - Behavioral
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

entity controller is
      Port (
      clk: in STD_LOGIC;
      Led: out STD_LOGIC_VECTOR (5 downto 0);
      DataIn: in STD_LOGIC;
      DataClk: out STD_LOGIC;
      DataLatch_out: out STD_LOGIC
      );
end controller;

architecture Behavioral of controller is

--component controller_clock is
--Port (  clk_in1 : in std_logic;
--        clk_out1 : out std_logic;
--        reset : in STD_LOGIC;
--        locked : out STD_LOGIC
--      );
--end component;

-- signals to create the FRAME_CLOCK and the CONTROLLER_CLOCK
constant FRAME_LATCH : natural := 1666666;

-- Controller_clk frequency = 83333 HZ
constant FRAME_CONTROLLER : natural := 1200;

signal controller_clk_cnt : natural range 0 to FRAME_CONTROLLER / 2 := 0;

signal data_latch_cnt : natural range 0 to FRAME_CONTROLLER-1 := 0;

signal latch_clk_cnt : natural range 0 to FRAME_LATCH / 2 := 0;

signal frame_clk, controller_clk: STD_LOGIC := '0';

signal DataLatch : STD_LOGIC;



--buttons on the controller
signal SnesA, SnesB, SnesY, SnesX, SnesRP, SnesLP, SnesUP, SnesDP, SnesSelect, SnesStart, SnesR, SnesL: STD_LOGIC := '0';

signal data_counter : natural range 0 to 17;




begin


--creatong the 60HZ clock from the 60MHZ of the clocking wizard
--process(input_clk)
--begin
--    if rising_edge(input_clk) then
--        if latch_clk_cnt = FRAME_LATCH / 2 then
--            latch_clk_cnt <= 0;
--            frame_clk <= not frame_clk;
--        else
--            latch_clk_cnt <= latch_clk_cnt +1;
--        end if;
--    end if;
--end process;

process(clk)
begin
    if rising_edge(clk) then
        if latch_clk_cnt = FRAME_LATCH / 2 then
            latch_clk_cnt <= 0;
            frame_clk <= not frame_clk;
        else
            latch_clk_cnt <= latch_clk_cnt +1;
        end if;
    end if;
end process;


--creating the clock for the input of the controller
process(clk, frame_clk)
begin
    if rising_edge(clk) then
        if controller_clk_cnt = FRAME_CONTROLLER / 2 then
            controller_clk_cnt <= 0;
            controller_clk <= not controller_clk;
        else
            controller_clk_cnt <= controller_clk_cnt +1;
        end if;
    end if;
    if rising_edge(frame_clk) then
        controller_clk <= '1';
        controller_clk_cnt <= 0;
    end if;
end process;

DataClk <= controller_clk;

process(clk, frame_clk, controller_clk, data_counter)
begin
    if rising_edge(frame_clk) then
        DataLatch <= '1';
    end if;
    if rising_edge(clk) and DataLatch = '1' then
        if data_latch_cnt = FRAME_CONTROLLER-1 then
            data_latch_cnt <= 0;
            DataLatch <= '0';
        else
            data_latch_cnt <= data_latch_cnt +1;
        end if;
    end if;
    
--    if rising_edge(controller_clk) and data_counter = 1 then
--        DataLatch <= '0';
--    end if;
end process;

--creating the buttons' ids based on the clock
process(controller_clk, DataLatch)
begin
    if rising_edge(controller_clk) and DataLatch = '1' and data_counter = 0 then
        data_counter <= 1;
    end if;
    if rising_edge(controller_clk) then
        data_counter <= data_counter + 1;
        if data_counter = 17 then
            data_counter <= 0;
        end if;
    end if;
end process;


DataLatch_out <= DataLatch;

--assigning values to input based on id

SnesB <= '1' when data_counter = 2 and DataIn = '1'
         else '0' when data_counter = 2 and DataIn = '0';
SnesY <= '1' when data_counter = 3 and DataIn = '1'
          else '0' when data_counter = 3  and DataIn = '0';
SnesSelect <= '1' when data_counter = 4 and DataIn = '1'
                else '0' when data_counter = 4 and DataIn = '0';
SnesStart <= '1' when data_counter = 5 and DataIn = '1'
            else '0' when data_counter = 5 and DataIn = '0';
SnesUP <= '1' when data_counter = 6 and DataIn = '1'
         else '0' when data_counter = 6 and DataIn = '0';
SnesDP <= '1' when data_counter = 7 and DataIn = '1'
          else '0' when data_counter = 7 and DataIn = '0';
SnesLP <= '1' when data_counter = 8 and DataIn = '1'
            else '0' when data_counter = 8 and DataIn = '0';
SnesRP <= '1' when data_counter = 9 and DataIn = '1'
         else '0' when data_counter = 9 and DataIn = '0';
SnesA <= '1' when data_counter = 10 and DataIn = '1'
        else '0' when data_counter = 10 and DataIn = '0';
SnesX <= '1' when data_counter = 11 and DataIn = '1'
         else '0' when data_counter = 11 and DataIn = '0';
SnesL <= '1' when data_counter = 12 and DataIn = '1'
      else '0' when data_counter = 12 and DataIn = '0';
SnesR <= '1' when data_counter = 13 and DataIn = '1'
       else '0' when data_counter = 13 and DataIn = '0';

--light up the leds corresponding to the input

Led(0) <= SnesA;
Led(1) <= SnesB;
Led(2) <= SnesX;
Led(3) <= SnesY;
Led(4) <= SnesL;
Led(5) <= SnesR;


--inst_controller_clock : controller_clock
--port map
--(   clk_in1     => clk,
--    clk_out1    => input_clk,
--    reset => '1',
--    locked => open
--);

end Behavioral;
