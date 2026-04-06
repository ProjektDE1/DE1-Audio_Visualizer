-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Mon, 06 Apr 2026 16:52:09 GMT
-- Request id : cfwk-fed377c2-69d3e4b977094

library ieee;
use ieee.std_logic_1164.all;

entity tb_acumulator is
end tb_acumulator;

architecture tb of tb_acumulator is

    constant G_BITS : positive := 8;

    component acumulator
        generic (G_BITS : positive := 8);
        port (clk        : in std_logic;
              rst        : in std_logic;
              clk_div_en : in std_logic;
              data       : in std_logic;
              en         : in std_logic;
              data_valid : out std_logic;
              data_out   : out std_logic_vector (G_BITS-1 downto 0));
    end component;

    signal clk        : std_logic;
    signal rst        : std_logic;
    signal clk_div_en : std_logic;
    signal data       : std_logic;
    signal en         : std_logic;
    signal data_valid : std_logic;
    signal data_out   : std_logic_vector (G_BITS-1 downto 0);

    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : acumulator
    generic map (G_BITS => G_BITS)
    port map (clk        => clk,
              rst        => rst,
              clk_div_en => clk_div_en,
              data       => data,
              en         => en,
              data_valid => data_valid,
              data_out   => data_out);

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        clk_div_en <= '0';
        data <= '0';
        en <= '0';

        -- Reset sekvence
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        
        -- Počkáme na bezpečné ustálení a sesynchronizujeme se se sestupnou hranou
        wait for 2 * TbPeriod;
        wait until falling_edge(clk);

        for i in 1 to 32 loop
            clk_div_en <= '1';
            
            -- Střídání jedniček a nul
            if (i mod 2 = 0) then
                data <= '1';
            else
                data <= '0';
            end if;
            
            wait for 1 * TbPeriod;
            clk_div_en <= '0';
            wait for 3 * TbPeriod; 
        end loop;

        -- Vyčtení dat a reset akumulátoru (konec vzorkovacího okna)
        clk_div_en <= '1';
        en <= '1';
        wait for 1 * TbPeriod;
        en <= '0';
        clk_div_en <= '0';
        
        wait for 5 * TbPeriod; -- Pauza mezi snímky

        ------------------------------------------------------------------
        -- TEST 2: Maximální amplituda / Clipping (PDM signál 111111...)
        ------------------------------------------------------------------
        -- Očekáváme, že čítač započítá všechny přicházející vzorky
        for i in 1 to 16 loop
            clk_div_en <= '1';
            data <= '1'; -- Stále log. 1
            wait for 1 * TbPeriod;
            clk_div_en <= '0';
            wait for 3 * TbPeriod;
        end loop;

        -- Vyčtení dat a reset akumulátoru
        clk_div_en <= '1';
        en <= '1';
        wait for 1 * TbPeriod;
        en <= '0';
        clk_div_en <= '0';

        wait for 10 * TbPeriod;

        -- Zastavení hodin a čisté ukončení simulace
        TbSimEnded <= '1';
        wait;
    end process;

end tb;