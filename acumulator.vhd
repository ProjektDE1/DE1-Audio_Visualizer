
-- vcd=result.vcd
-- prepis akumulatoru pro praci s klouzavym prumerem na posuvnem registru o delce 4096bit 

library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;       
use IEEE.NUMERIC_STD.ALL;

entity acumulator is 

    -- 4096
    -- dynamicky rozsah 66dB 
    -- Min. hladina 54dB. max. hladina 120dB = 0dBFS pro MEMS mikrofon na desce
    generic (G_N : positive := 4096);

    port (
        -- signaly pro komponentu
        clk         :   in  STD_LOGIC; 
        rst         :   in  STD_LOGIC; 

        -- vstupy z pdm_interface
        clk_en      :   in  STD_LOGIC;
        data        :   in  STD_LOGIC; 

        -- vystup z komponenty
        data_valid  :   out STD_LOGIC;
        data_out    :   out STD_LOGIC_VECTOR (12 downto 0) 
    );

end acumulator; 

architecture Behavioral of acumulator is 

    signal shift_reg    : std_logic_vector(G_N-1 downto 0) := (others => '0');
    signal sig_sum      : unsigned(12 downto 0) := (others => '0'); 

begin 

    process (clk) is        
    begin
        if rising_edge(clk) then

            data_valid <= '0'; 

            if rst = '1' then
                data_valid   <= '0'; 
                sig_sum <= (others => '0'); 
                shift_reg <= (others => '0');
        
            -- z mikrofonu prichazi vzorek 
            elsif clk_en = '1' then

                -- vzorek v data dame na zacatek registru a posuneme ho 
                shift_reg <= data & shift_reg(G_N-1 downto 1); 

                -- odcitame nebo pricitame data v souctu 
                if data = '1' and shift_reg(0) = '0' then
                    sig_sum <= sig_sum + 1;
                elsif data = '0' and shift_reg(0) = '1' then
                    sig_sum <= sig_sum - 1; 
                end if;

                data_valid <= '1';

            end if; 

        end if; 
    end process;

    data_out <= std_logic_vector(sig_sum); 
end Behavioral; 