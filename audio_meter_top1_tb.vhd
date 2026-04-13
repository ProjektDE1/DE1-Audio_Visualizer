-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Mon, 13 Apr 2026 13:19:35 GMT
-- Request id : cfwk-fed377c2-69dced67217ff

library ieee;
use ieee.std_logic_1164.all;

entity tb_audio_meter_top is
end tb_audio_meter_top;

architecture tb of tb_audio_meter_top is

    component audio_meter_top
        port (clk      : in std_logic;
              rst      : in std_logic;
              m_data   : in std_logic;
              m_clk    : out std_logic;
              m_lr_sel : out std_logic;
              db_out   : out std_logic_vector (6 downto 0);
              db_valid : out std_logic);
    end component;

    signal clk      : std_logic;
    signal rst      : std_logic;
    signal m_data   : std_logic;
    signal m_clk    : std_logic;
    signal m_lr_sel : std_logic;
    signal db_out   : std_logic_vector (6 downto 0);
    signal db_valid : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : audio_meter_top
    port map (clk      => clk,
              rst      => rst,
              m_data   => m_data,
              m_clk    => m_clk,
              m_lr_sel => m_lr_sel,
              db_out   => db_out,
              db_valid => db_valid);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    -- =========================================================
    -- PROCES 1: HLAVNI STIMULY
    -- =========================================================
    stimuli : process
    begin
        m_data <= '0';
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        report "Start simulace na 260 ms...";

        -- Zvetsili jsme cas na 260 ms, abychom chytili DVE vyhodnocovaci okna
        while now < 260 ms loop
            m_data <= '1'; wait for 330 ns;
            m_data <= '0'; wait for 330 ns;
        end loop;

        report "Simulace dorazila na 260 ms a konci.";
        TbSimEnded <= '1'; 
        wait;
    end process;


    -- =========================================================
    -- PROCES 2: NEKONECNY MONITOR
    -- =========================================================
    monitor : process
    begin
        -- Udelame nekonecnou smycku, aby nam to vypsalo kazde 125ms okno
        loop
            wait until rising_edge(clk) and db_valid = '1';
            
            report "========================================";
            report "========================================";
        end loop;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_audio_meter_top of tb_audio_meter_top is
    for tb
    end for;
end cfg_tb_audio_meter_top;