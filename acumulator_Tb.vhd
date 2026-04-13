-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Sun, 12 Apr 2026 13:11:53 GMT
-- Request id : cfwk-fed377c2-69db9a1981080

library ieee;
use ieee.std_logic_1164.all;

entity tb_acumulator is
end tb_acumulator;

architecture tb of tb_acumulator is

    component acumulator
        generic (
            G_N : positive := 4096
        );
        port (clk        : in std_logic;
              rst        : in std_logic;
              clk_en     : in std_logic;
              data       : in std_logic;
              data_valid : out std_logic;
              data_out   : out std_logic_vector (12 downto 0));
    end component;

    signal clk        : std_logic;
    signal rst        : std_logic;
    signal clk_en     : std_logic;
    signal data       : std_logic;
    signal data_valid : std_logic;
    signal data_out   : std_logic_vector (12 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : acumulator
    generic map (
        G_N => 4096
    )
    port map (clk        => clk,
              rst        => rst,
              clk_en     => clk_en,
              data       => data,
              data_valid => data_valid,
              data_out   => data_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
        -- Pomocná procedura pro poslání jednoho PDM bitu
        procedure send_pdm_bit(bit_val : std_logic) is
        begin
            data <= bit_val;
            clk_en <= '1';
            wait for TbPeriod;
            clk_en <= '0';
            wait for TbPeriod * 32; -- Simulace PDM hodinového taktu (cca 3.03 MHz)
        end procedure;

    begin
        -- Inicializace
        clk_en <= '0';
        data <= '0';
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for TbPeriod * 10;70

        -----------------------------------------------------------------------
        -- TEST 1: Simulace TICHA (Střída 50% : 101010...)
        -- Očekáváme, že data_out se postupně ustálí na hodnotě 2048
        -----------------------------------------------------------------------
        report "Start simulace: TICHO (50% density)";
        for i in 1 to 4096 loop
            if (i mod 2 = 0) then send_pdm_bit('1');
            else send_pdm_bit('0');
            end if;
        end loop;
        
        wait for 1 us;

        -----------------------------------------------------------------------
        -- TEST 2: Simulace MAXIMÁLNÍHO TLAKU (Samé 1)
        -- Očekáváme, že data_out poroste až k hodnotě 4096
        -----------------------------------------------------------------------
        report "Start simulace: MAX (100% density)";
        for i in 1 to 4096 loop
            send_pdm_bit('1');
        end loop;

        wait for 1 us;

        -----------------------------------------------------------------------
        -- TEST 3: Simulace MAXIMÁLNÍHO PODTLAKU (Samé 0)
        -- Očekáváme, že data_out klesne až k hodnotě 0
        -----------------------------------------------------------------------
        report "Start simulace: MIN (0% density)";
        for i in 1 to 4096 loop
            send_pdm_bit('0');
        end loop;

        wait for 10 us;

        -- Ukončení simulace
        report "Simulace dokoncena v poradku.";
        TbSimEnded <= '1';
        wait;
    end process;
end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_acumulator of tb_acumulator is
    for tb
    end for;
end cfg_tb_acumulator;