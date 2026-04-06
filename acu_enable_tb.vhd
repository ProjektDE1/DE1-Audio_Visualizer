-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Mon, 06 Apr 2026 15:57:37 GMT
-- Request id : cfwk-fed377c2-69d3d7f1a74b0

library ieee;
use ieee.std_logic_1164.all;

entity tb_acu_enable is
end tb_acu_enable;

architecture tb of tb_acu_enable is

    component acu_enable
        port (clk        : in std_logic;
              rst        : in std_logic;
              clk_div_en : in std_logic;
              en         : out std_logic);
    end component;

    signal clk        : std_logic;
    signal rst        : std_logic;
    signal clk_div_en : std_logic;
    signal en         : std_logic;

    constant TbPeriod : time := 1 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : acu_enable
    port map (clk        => clk,
              rst        => rst,
              clk_div_en => clk_div_en,
              en         => en);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

   stimuli : process
    begin
        -- Inicializace
        clk_div_en <= '0';

        -- Reset sekvence
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        
        -- Chvíle pro ustálení
        wait for 2 * TbPeriod;

        -- Synchronizace se sestupnou hranou pro čisté přepínání signálů
        wait until falling_edge(clk);

        -- Pošleme sérii např. 40 impulzů clk_div_en, 
        -- abychom bezpečně překročili tvé G_BITS a viděli i přetečení/reset čítače
        for i in 1 to 200 loop
            -- Aktivace clk_div_en na jeden hodinový takt
            clk_div_en <= '1';
            wait for 1 * TbPeriod;
            
            -- Deaktivace a čekání (simuluje např. že zdrojové hodiny jsou rychlejší než ty dělené)
            clk_div_en <= '0';
            wait for 1 * TbPeriod; 
        end loop;

        -- Necháme obvod chvíli běžet bez impulzů
        wait for 10 * TbPeriod;

        -- Zastavení hodin a ukončení simulace
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_acu_enable of tb_acu_enable is
    for tb
    end for;
end cfg_tb_acu_enable;