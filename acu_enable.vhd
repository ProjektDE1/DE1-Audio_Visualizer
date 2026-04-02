
-- vzorkovaci counter, posila en signal do akumulatoru 
-- vzorkovaci frekvence je 25,7kHz  -> podle teoremu pracujeme az s 12kHz
-- bity akumulatoru se ukladaji do 7 bitoveho registru

library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;       
use IEEE.NUMERIC_STD.ALL;

entity acu_enable is 

    generic(G_MAX : positive := 128); 
    port(
        clk    : in     STD_LOGIC; 
        rst    : in     STD_LOGIC;
        en     : out    STD_LOGIC 
    );

end acu_enable; 

architecture Behavioral of acu_enable is

    signal div_clk_counter : integer range 0 to G_MAX -1; 

begin

    process(clk) is 
    begin
        if rising_edge(clk) then
            if rst = '1'then
                en <= '0'; 
                div_clk_counter <= 0; 

            elsif div_clk_counter = (G_MAX-1) then
                en <= '1'; 
                div_clk_counter <= 0; 

            else
                div_clk_counter <= div_clk_counter + 1; 
                en <= '0'; 
            end if; 
        end if; 
    end process; 
end Behavioral; 