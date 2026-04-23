-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Mon, 13 Apr 2026 09:58:26 GMT
-- Request id : cfwk-fed377c2-69dcbe4289156

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_signal_processor2 is
end tb_signal_processor2;

architecture tb of tb_signal_processor2 is

    component signal_processor2
        port (clk        : in std_logic;
              rst        : in std_logic;
              data       : in std_logic_vector (12 downto 0);
              data_valid : in std_logic;
              db_valid   : out std_logic;
              db_out     : out std_logic_vector (6 downto 0));
    end component;

    signal clk        : std_logic;
    signal rst        : std_logic;
    signal data       : std_logic_vector (12 downto 0);
    signal data_valid : std_logic;
    signal db_valid   : std_logic;
    signal db_out     : std_logic_vector (6 downto 0);

    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : signal_processor2
    port map (clk        => clk,
              rst        => rst,
              data       => data,
              data_valid => data_valid,
              db_valid   => db_valid,
              db_out     => db_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process

        procedure send_data (val : integer) is
        begin

            data <= std_logic_vector(to_unsigned(val, 13));
            data_valid <= '1';
            wait for TbPeriod; 

            data_valid <= '0';

            wait for 2 us; 

        end procedure;

    begin

        data <= (others => '0');
        data_valid <= '0';

        -- Reset generation
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        wait for 100 * TbPeriod;

        send_data(2048);
        send_data(3000);
        send_data(1000);
        send_data(3900);
        send_data(2048);
        send_data(100);
        send_data(1500); 

        send_data(700); 
        send_data(5); 
        send_data(0); 
        send_data(2300); 
        send_data(4000); 
        send_data(2300); 
        send_data(3000); 
        send_data(0); 
        send_data(0); 

        wait for 20 us;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_signal_processor2 of tb_signal_processor2 is
    for tb
    end for;
end cfg_tb_signal_processor2;