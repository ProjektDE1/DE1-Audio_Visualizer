-- vcd=result.vcd
-- accumulator rewrite for working with a moving average on a 128bit shift register

library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;       
use IEEE.NUMERIC_STD.ALL;

entity acumulator is 
 
    generic (G_N : positive := 128);

    port (
        -- component inputs
        clk         :   in  STD_LOGIC; 
        rst         :   in  STD_LOGIC; 

        -- inputs from pdm_interface
        clk_en      :   in  STD_LOGIC;
        data        :   in  STD_LOGIC; 

        -- component outputs
        data_valid  :   out STD_LOGIC;
        data_out    :   out STD_LOGIC_VECTOR (12 downto 0) 
    );

end acumulator; 

architecture Behavioral of acumulator is 

    signal shift_reg    : std_logic_vector(G_N-1 downto 0) := (others => '0');
    signal sig_sum      : unsigned(7 downto 0) := (others => '0'); 

begin 

    process (clk) is        
    begin
        if rising_edge(clk) then

            data_valid <= '0'; 

            if rst = '1' then
                data_valid   <= '0'; 
                sig_sum <= (others => '0'); 
                shift_reg <= (others => '0');
        
            -- sample comes from the microphone
            elsif clk_en = '1' then

                -- sample is moved to the MSB of the right shifted register
                shift_reg <= data & shift_reg(G_N-1 downto 1); 

                -- subtract or add data in a sum
                if data = '1' and shift_reg(0) = '0' then
                    sig_sum <= sig_sum + 1;
                elsif data = '0' and shift_reg(0) = '1' then
                    sig_sum <= sig_sum - 1; 
                end if;

                data_valid <= '1';

            end if; 

        end if; 
    end process;

    -- for the least possible impact on the architecture, expanding 8 bits to 13 bits
    -- 128  -> 10000000
    -- 4096 -> 10000000_00000
    data_out <= std_logic_vector(sig_sum) & "00000"; 
end Behavioral; 