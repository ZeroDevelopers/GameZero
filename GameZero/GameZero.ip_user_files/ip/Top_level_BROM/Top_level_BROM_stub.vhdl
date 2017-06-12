-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2016.4 (win64) Build 1756540 Mon Jan 23 19:11:23 MST 2017
-- Date        : Mon Jun 12 10:45:36 2017
-- Host        : DESKTOP-PK5D2H9 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/edoardo/Documents/GitHub/GameZero/GameZero/GameZero.srcs/sources_1/ip/Top_level_BROM/Top_level_BROM_stub.vhdl
-- Design      : Top_level_BROM
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_level_BROM is
  Port ( 
    clka : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 17 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 11 downto 0 )
  );

end Top_level_BROM;

architecture stub of Top_level_BROM is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,addra[17:0],douta[11:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_3_5,Vivado 2016.4";
begin
end;