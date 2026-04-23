-- connecting microphone and clock divider components
-- communication and reading data from MEMS microphone
-- division of the main clock signal
-- 3.03MHz pulses for accumulator and 50% duty cycle clock for microphone

library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;       
use IEEE.NUMERIC_STD.ALL;

entity pdm_interface is

    generic (G_DIV : positive := 33);

    port (
        -- component inputs
        clk         : in std_logic;
        rst         : in std_logic;

        -- outputs for MEMS microphone
        m_clk       : out std_logic;
        m_lr_sel    : out std_logic; 

        -- inputs from MEMS microphone 
        m_data      : in std_logic; 

        -- component outputs
        data        : out std_logic; 
        clk_en      : out std_logic

    );
end entity;

architecture Behavioral of pdm_interface is

    signal sig_cnt : integer range 0 to G_DIV-1 := 0; 
    signal data_sync : STD_LOGIC := '0'; 
    signal clk_tog  : STD_LOGIC := '0';

begin
    process(clk) is 
    begin
        if rising_edge(clk) then

            if rst = '1' then
                clk_en <= '0'; 
                sig_cnt <= 0; 
                data_sync <= '0';
                clk_tog <= '0'; 

            else
                data_sync <= m_data; 
                
                -- generation of enabling signal for accumulator f = 3.03 MHz
                if sig_cnt = G_DIV-1 then
                    sig_cnt <= 0;
                    clk_en <= '1';
                else
                    sig_cnt <= sig_cnt + 1; 
                    clk_en <= '0';
                end if;

                -- generating a signal with a 50% duty cycle for a microphone f = 3.03 MHz
                if sig_cnt < (G_DIV / 2) then
                    clk_tog <= '1'; 
                else
                    clk_tog <= '0';   
                end if;

            end if; 
        end if;
    end process;

    m_clk <= clk_tog; 
    m_lr_sel <= '0';
    data <= data_sync;  


end Behavioral;