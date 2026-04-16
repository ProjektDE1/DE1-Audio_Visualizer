-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 15 Apr 2026 20:36:15 GMT
-- Request id : cfwk-fed377c2-69dff6bf7d1af

library ieee;
use ieee.std_logic_1164.all;

entity tb_led_driver is
end tb_led_driver;

architecture tb of tb_led_driver is

    component led_driver
        port (clk        : in std_logic;
              rst        : in std_logic;
              data_in    : in std_logic_vector (6 downto 0);
              data_valid : in std_logic;
              led_out    : out std_logic_vector (15 downto 0));
    end component;

    signal clk        : std_logic;
    signal rst        : std_logic;
    signal data_in    : std_logic_vector (6 downto 0);
    signal data_valid : std_logic;
    signal led_out    : std_logic_vector (15 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : led_driver
    port map (clk        => clk,
              rst        => rst,
              data_in    => data_in,
              data_valid => data_valid,
              led_out    => led_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- Zaciatok
        data_in <= (others => '0');
        data_valid <= '0';

        -- rst
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 20 ns; -- Wait a bit after reset

        -- male
        data_in    <= "1000010";
        --data_in    <= "0000001";
        data_valid <= '1';
        wait for TbPeriod;     -- Hold for one clock cycle
        data_valid <= '0';     -- De-assert valid
        wait for 4 * TbPeriod; -- Gap between data

        -- stredne cca
        data_in      <= "1011010";
        --data_in    <= "0101010";
        data_valid <= '1';
        wait for TbPeriod;
        data_valid <= '0';
        wait for 4 * TbPeriod;

        -- MAX
        data_in      <= "1111000";
        --data_in    <= "1111111";
        data_valid <= '1';
        wait for TbPeriod;
        data_valid <= '0';

        
        wait for 100 * TbPeriod;

        
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_led_driver of tb_led_driver is
    for tb
    end for;
end cfg_tb_led_driver;