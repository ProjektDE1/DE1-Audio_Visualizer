
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity microphone is
    port (
        clk         : in  STD_LOGIC;  
        rst         : in  STD_LOGIC;
        div_clk_en  : in  STD_LOGIC;  
        mic_data_in : in  STD_LOGIC; 
        mic_clk_out : out STD_LOGIC;  
        mic_lr_sel  : out STD_LOGIC; 
        data        : out STD_LOGIC  
    );
end microphone;

architecture Behavioral of microphone is

    -- Toggle register: konvertuje 2.38 MHz enable pulse na ~1.19 MHz hodiny (50% DC)
    signal clk_tog  : STD_LOGIC := '0';
    -- Synchronizacny register pre mic_data_in (zamedzuje metastabilite)
    signal data_sync : STD_LOGIC := '0';

begin

    process(clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                clk_tog   <= '0';
                data_sync <= '0';
            else
                -- generuj 50% duty cycle PDM clock togglovanim pri kazdom enable
                if div_clk_en = '1' then
                    clk_tog <= not clk_tog;
                end if;
                -- synchronizuj PDM data (1 FF pipeline)
                data_sync <= mic_data_in;
            end if;
        end if;
    end process;

    mic_clk_out <= clk_tog;  -- ~1.19 MHz, 50% duty cycle
    mic_lr_sel  <= '0';      -- lavy kanal (data validne na narastajucej hrane)
    data        <= data_sync;

end Behavioral;
