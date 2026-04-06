-- CLOCK DIVIDER
-- enable clocku pro dalsi soucastky, z 100MHz delame 3,03MHz

library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;       
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is

    generic(G_DIV : positive := 33); 
    port (
        clk      : in  STD_LOGIC; 
        rst      : in  STD_LOGIC; 
        clk_en   : out STD_LOGIC
    );

end clock_divider; 

architecture Behavioral of Clock_Divider is

    signal sig_cnt : integer range 0 to G_DIV-1 := 0; 

begin
    process(clk) is 
    begin
        if rising_edge(clk) then
            if rst = '1' then
                clk_en <= '0'; 
                sig_cnt <= 0; 
                
            elsif sig_cnt = G_DIV-1 then
                sig_cnt <= 0; 
                clk_en <= '1'; 

            else
                sig_cnt <= sig_cnt + 1; 
                clk_en <= '0'; 
            end if; 
        end if;
    end process;
end Behavioral; 