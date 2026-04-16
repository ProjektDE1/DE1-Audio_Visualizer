library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_driver is
    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        data_in  : in  STD_LOGIC_VECTOR (6 downto 0); -- db_out z procesora
        data_valid : in STD_LOGIC;                    -- db_valid z procesora
        led_out  : out STD_LOGIC_VECTOR (15 downto 0)
    );
end led_driver;

architecture Behavioral of led_driver is
    signal led_reg : std_logic_vector(15 downto 0) := (others => '0');
begin

    process(clk)
        variable val : integer range 0 to 127;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                led_reg <= (others => '0');
            elsif data_valid = '1' then
                val := to_integer(unsigned(data_in));
                
                -- podla mainu som tam dal ze to ma byt po 6db
                led_reg(0)  <= '1' when val > 54    else '0'; -- zaklad
                led_reg(1)  <= '1' when val > 58    else '0'; -- +4db podle LuT
                led_reg(2)  <= '1' when val > 62    else '0'; 
                led_reg(3)  <= '1' when val > 66    else '0';
                led_reg(4)  <= '1' when val > 70    else '0';
                led_reg(5)  <= '1' when val > 74    else '0';
                led_reg(6)  <= '1' when val > 78    else '0';
                led_reg(7)  <= '1' when val > 82    else '0';
                led_reg(8)  <= '1' when val > 86    else '0';
                led_reg(9)  <= '1' when val > 90    else '0';
                led_reg(10) <= '1' when val > 94    else '0';
                led_reg(11) <= '1' when val > 98    else '0';
                led_reg(12) <= '1' when val > 102   else '0';
                led_reg(13) <= '1' when val > 106   else '0';
                led_reg(14) <= '1' when val > 112   else '0';
                led_reg(15) <= '1' when val > 119   else '0';
            end if;
        end if;
    end process;

    led_out <= led_reg;

end Behavioral;