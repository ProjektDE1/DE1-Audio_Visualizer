library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity tb_signal_processor is
end tb_signal_processor;
 
architecture tb of tb_signal_processor is
 
    component signal_processor
        generic (
            G_BITS    : positive := 13;
            G_REFRESH : positive := 100_000
        );
        port (clk        : in  std_logic;
              rst        : in  std_logic;
              data       : in  std_logic_vector(G_BITS-1 downto 0);
              data_valid : in  std_logic;
              spl_val    : out std_logic_vector(6 downto 0);
              led_data   : out std_logic_vector(15 downto 0);
              seg        : out std_logic_vector(6 downto 0);
              dp         : out std_logic;
              an         : out std_logic_vector(7 downto 0));
    end component;
 
    signal clk        : std_logic := '0';
    signal rst        : std_logic := '0';
    signal data       : std_logic_vector(12 downto 0) := (others => '0');
    signal data_valid : std_logic := '0';
    signal spl_val    : std_logic_vector(6 downto 0);
    signal led_data   : std_logic_vector(15 downto 0);
    signal seg        : std_logic_vector(6 downto 0);
    signal dp         : std_logic;
    signal an         : std_logic_vector(7 downto 0);
 
    constant TbPeriod : time := 10 ns;
    signal TbSimEnded : std_logic := '0';
 
begin
 
    dut : signal_processor
        generic map (
            G_BITS    => 13,
            G_REFRESH => 16
        )
        port map (
            clk        => clk,
            rst        => rst,
            data       => data,
            data_valid => data_valid,
            spl_val    => spl_val,
            led_data   => led_data,
            seg        => seg,
            dp         => dp,
            an         => an
        );
 
    clk <= not clk after TbPeriod/2 when TbSimEnded /= '1' else '0';
 
    stimuli : process
    begin
        -- reset
        rst <= '1';
        wait for 5 * TbPeriod;
        rst <= '0';
        wait for 5 * TbPeriod;
 
        -- count=64, amp=0, spl=0 
        data <= std_logic_vector(to_unsigned(64, 13));
        data_valid <= '1'; wait for TbPeriod; data_valid <= '0';
        wait for 10 * TbPeriod;
 
        -- count=70, amp=6, spl=42
        data <= std_logic_vector(to_unsigned(70, 13));
        data_valid <= '1'; wait for TbPeriod; data_valid <= '0';
        wait for 10 * TbPeriod;
 
        -- count=80, amp=16, spl=67
        data <= std_logic_vector(to_unsigned(80, 13));
        data_valid <= '1'; wait for TbPeriod; data_valid <= '0';
        wait for 10 * TbPeriod;
 
        -- count=96, amp=32, spl=83
        data <= std_logic_vector(to_unsigned(96, 13));
        data_valid <= '1'; wait for TbPeriod; data_valid <= '0';
        wait for 10 * TbPeriod;
 
        -- count=128, amp=64, spl=99 
        data <= std_logic_vector(to_unsigned(128, 13));
        data_valid <= '1'; wait for TbPeriod; data_valid <= '0';
        wait for 10 * TbPeriod;
 
        -- count=32, amp=32, spl=83 
        data <= std_logic_vector(to_unsigned(32, 13));
        data_valid <= '1'; wait for TbPeriod; data_valid <= '0';
        wait for 10 * TbPeriod;
 
        -- count=0, amp=64, spl=99 
        data <= std_logic_vector(to_unsigned(0, 13));
        data_valid <= '1'; wait for TbPeriod; data_valid <= '0';
        wait for 10 * TbPeriod;
 
        -- spat na ticho
        data <= std_logic_vector(to_unsigned(64, 13));
        data_valid <= '1'; wait for TbPeriod; data_valid <= '0';
        wait for 200 * TbPeriod;  
 
        TbSimEnded <= '1';
        wait;
    end process;
 
end tb;
