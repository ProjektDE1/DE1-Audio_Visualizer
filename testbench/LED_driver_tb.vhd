library ieee;
use ieee.std_logic_1164.all;

entity tb_led_driver is
end tb_led_driver;

architecture tb of tb_led_driver is

    component led_driver
        generic (G_REFRESH : positive := 100_000);
        port (clk        : in std_logic;
              rst        : in std_logic;
              data_in    : in std_logic_vector (6 downto 0);
              data_valid : in std_logic;
              led_out    : out std_logic_vector (15 downto 0);
              seg        : out std_logic_vector (6 downto 0);
              an         : out std_logic_vector (7 downto 0);
              dp         : out std_logic);
    end component;

    signal clk        : std_logic;
    signal rst        : std_logic;
    signal data_in    : std_logic_vector (6 downto 0);
    signal data_valid : std_logic;
    signal led_out    : std_logic_vector (15 downto 0);
    signal seg        : std_logic_vector (6 downto 0);
    signal an         : std_logic_vector (7 downto 0);
    signal dp         : std_logic;

    constant TbPeriod : time := 10 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : led_driver
    generic map (
        G_REFRESH => 16
    )
    port map (clk        => clk,
              rst        => rst,
              data_in    => data_in,
              data_valid => data_valid,
              led_out    => led_out,
              seg        => seg,
              an         => an,
              dp         => dp);

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        data_in <= (others => '0');
        data_valid <= '0';

        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 20 ns;

        -- male
        data_in    <= "1000010";
        data_valid <= '1';
        wait for TbPeriod;
        data_valid <= '0';
        wait for 4 * TbPeriod;

        -- stredne cca
        data_in    <= "1011010";
        data_valid <= '1';
        wait for TbPeriod;
        data_valid <= '0';
        wait for 4 * TbPeriod;

        -- MAX
        data_in    <= "1111000";
        data_valid <= '1';
        wait for TbPeriod;
        data_valid <= '0';

        wait for 500 * TbPeriod;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_led_driver of tb_led_driver is
    for tb
    end for;
end cfg_tb_led_driver;
