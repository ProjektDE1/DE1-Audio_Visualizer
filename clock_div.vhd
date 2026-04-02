
-- delicka clocku,  ze 100MHz delame 3MHz pro mikrofon 
library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;       
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is

    generic(G_DIV : positive := 33); 
    port (
        clk      : in  STD_LOGIC; 
        rst      : in  STD_LOGIC; 
        div_clk  : out STD_LOGIC
    );

end clock_divider; 

architecture Behavioral of Clock_Divider is

    signal sig_cnt : integer range 0 to (G_DIV/2)-1; 

begin
    process(clk) is 
    begin
        if rising_edge(clk) then
            if rst = '1' then
                div_clk <= '0'; 
                sig_cnt <= 0; 
                
            elsif sig_cnt >= 20 then
                div_clk <= not div_clk; 
                sig_cnt <= 0; 

            else
                sig_cnt <= sig_cnt + 1; 
            end if; 
        end if;
    end process;
end Behavioral; 