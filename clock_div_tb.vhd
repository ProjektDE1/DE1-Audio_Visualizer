library ieee;
use ieee.std_logic_1164.all;

entity tb_clock_divider is
end tb_clock_divider;

architecture tb of tb_clock_divider is

    component clock_divider
        port (clk    : in std_logic;
              rst    : in std_logic;
              clk_en : out std_logic);
    end component;

    signal clk    : std_logic;
    signal rst    : std_logic;
    signal clk_en : std_logic;

    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin


    dut : clock_divider
    port map (clk    => clk,
              rst    => rst,
              clk_en => clk_en);


    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        
        rst <= '1';
        wait for 100 ns; 

        wait until falling_edge(clk);
        rst <= '0';
        wait for 2000 ns;

        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        
        wait for 1000 ns;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_clock_divider of tb_clock_divider is
    for tb
    end for;
end cfg_tb_clock_divider;