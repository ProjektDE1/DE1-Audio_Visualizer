-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Sun, 12 Apr 2026 10:53:17 GMT
-- Request id : cfwk-fed377c2-69db799dbf9f9

library ieee;
use ieee.std_logic_1164.all;

entity tb_pdm_interface is
end tb_pdm_interface;

architecture tb of tb_pdm_interface is

    component pdm_interface
        generic (G_DIV : positive := 33);
        
        port (clk      : in std_logic;
              rst      : in std_logic;
              m_clk    : out std_logic;
              m_lr_sel : out std_logic;
              m_data   : in std_logic;
              data     : out std_logic;
              clk_en   : out std_logic);
    end component;

    signal clk      : std_logic;
    signal rst      : std_logic;
    signal m_clk    : std_logic;
    signal m_lr_sel : std_logic;
    signal m_data   : std_logic;
    signal data     : std_logic;
    signal clk_en   : std_logic;

    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : pdm_interface

    generic map (
        G_DIV => 33
    )

    port map (clk      => clk,
              rst      => rst,
              m_clk    => m_clk,
              m_lr_sel => m_lr_sel,
              m_data   => m_data,
              data     => data,
              clk_en   => clk_en);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    
    -- microphone simulation procedure
    procedure send_mic_data (bit_val : std_logic) is
    begin

        wait until falling_edge(m_clk); 
        wait for 20 ns; 
        m_data <= bit_val; 
        
    end procedure;

    begin

        m_data <= '0';

        -- Reset generation
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        send_mic_data('1'); 
        send_mic_data('0'); 
        send_mic_data('1'); 
        send_mic_data('0'); 
        send_mic_data('1'); 
        send_mic_data('1'); 
        send_mic_data('0'); 
        send_mic_data('1'); 
        send_mic_data('0'); 

        wait for 10 us;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_pdm_interface of tb_pdm_interface is
    for tb
    end for;
end cfg_tb_pdm_interface;