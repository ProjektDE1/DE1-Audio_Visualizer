
--vcd=result.vcd
--vcd=result.vcd,--stop-time=5us

library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;       
use IEEE.NUMERIC_STD.ALL;

entity acumulator is 

    generic (G_BITS : positive := 8);

    port (
        clk         :   in  STD_LOGIC; 
        rst         :   in  STD_LOGIC; 
        clk_div_en  :   in  STD_LOGIC;
        data        :   in  STD_LOGIC; 
        en          :   in  STD_LOGIC; 
        data_valid  :   out STD_LOGIC; 
        data_out    :   out STD_LOGIC_VECTOR (G_BITS-1 downto 0) -- 8 bit sbernice 
    );

end acumulator; 

architecture Behavioral of acumulator is 
    -- 8 bitu -> 256
    signal sig_data_cnt : unsigned(G_BITS-1 downto 0) := (others => '0'); 
    signal data_for_out : unsigned(G_BITS-1 downto 0) := (others => '0'); 

begin 

    process (clk) is        
    begin
        if rising_edge(clk) then

            data_valid <= '0'; 

            if rst = '1' then
                data_valid   <= '0'; 
                sig_data_cnt <= (others => '0'); 
        
            -- reakce na podeleny clock 
            elsif clk_div_en = '1' then

                if en = '1' then
                    data_valid   <= '1'; 
                    data_for_out <= sig_data_cnt; 
                    
                    -- situace kdy jednicka prijde i behem enable signalu 
                    if data = '1' then
                        -- nastaveni akumulatoru 1 -> 00000001
                        sig_data_cnt <= to_unsigned(1, G_BITS); 
                    else
                        sig_data_cnt <= (others => '0');   
                    end if;

                else
                    if data = '1' then
                        sig_data_cnt <= sig_data_cnt + 1; 
                    end if;
                    data_valid <= '0'; 
                end if;
            end if; 
        end if; 
    end process;

    data_out <= std_logic_vector(data_for_out); 
end Behavioral; 