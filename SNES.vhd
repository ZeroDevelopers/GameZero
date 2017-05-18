----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2017 17:41:44
-- Design Name: 
-- Module Name: SNES - Behavioral
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

entity SNES is
    Port ( clk : in STD_LOGIC);
end SNES;

architecture Behavioral of SNES is

component xadc_wiz_0 is
   port
   (
    daddr_in        : in  STD_LOGIC_VECTOR (6 downto 0);     -- Address bus for the dynamic reconfiguration port
    den_in          : in  STD_LOGIC;                         -- Enable Signal for the dynamic reconfiguration port
    di_in           : in  STD_LOGIC_VECTOR (15 downto 0);    -- Input data bus for the dynamic reconfiguration port
    dwe_in          : in  STD_LOGIC;                         -- Write Enable for the dynamic reconfiguration port
    do_out          : out  STD_LOGIC_VECTOR (15 downto 0);   -- Output data bus for dynamic reconfiguration port
    drdy_out        : out  STD_LOGIC;                        -- Data ready signal for the dynamic reconfiguration port
    dclk_in         : in  STD_LOGIC;                         -- Clock input for the dynamic reconfiguration port
    reset_in        : in  STD_LOGIC;                         -- Reset signal for the System Monitor control logic
    vauxp0          : in  STD_LOGIC;                         -- Auxiliary Channel 0
    vauxn0          : in  STD_LOGIC;
    busy_out        : out  STD_LOGIC;                        -- ADC Busy signal
    channel_out     : out  STD_LOGIC_VECTOR (4 downto 0);    -- Channel Selection Outputs
    eoc_out         : out  STD_LOGIC;                        -- End of Conversion Signal
    eos_out         : out  STD_LOGIC;                        -- End of Sequence Signal
    ot_out          : out  STD_LOGIC;                        -- Over-Temperature alarm output
    vccaux_alarm_out : out  STD_LOGIC;                        -- VCCAUX-sensor alarm output
    vccint_alarm_out : out  STD_LOGIC;                        -- VCCINT-sensor alarm output
    user_temp_alarm_out : out  STD_LOGIC;                        -- Temperature-sensor alarm output
    alarm_out       : out STD_LOGIC;                         -- OR'ed output of all the Alarms
    vp_in           : in  STD_LOGIC;                         -- Dedicated Analog Input Pair
    vn_in           : in  STD_LOGIC
    );
end component;


-- Declaring signals for the xadc component
signal address_in : std_logic_vector (6 downto 0) := (others => '0');
signal enable, ready : std_logic;
signal data_out, data_in : std_logic_vector (15 downto 0) := (others => '0');
signal vauxp, vauxn : std_logic;
constant channel : std_logic_vector (4 downto 0) := "10000";



begin

Inst_Xadc : xadc_wiz_0 
    port map 
    (
    daddr_in    => address_in,
    den_in      => enable, 
    di_in       => data_in,
    dwe_in      => '1',
    do_out      => data_out,
    drdy_out    => ready,
    dclk_in     => clk,
    reset_in    => '0',
    vauxp0      => vauxp,
    vauxn0      => vauxn,
    busy_out    => open,
    channel_out => open,
    eoc_out     => enable,
    eos_out     => open,
    ot_out      => open,
    vccaux_alarm_out    => open,
    vccint_alarm_out    => open,
    user_temp_alarm_out => open,
    alarm_out   => open,
    vp_in       => vauxp,
    vn_in       => vauxn
    );

address_in <= x"10";  -- The address of he auxiliary port 0 (to be checked)

process
begin
    if rising_edge(clk) then
        if ready = '1' then
            -- Write the code for retrivieng data
        end if;
    end if;
end process;

end Behavioral;
