library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_driver is
    Port (
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        data_in    : in  STD_LOGIC_VECTOR(6 downto 0);
        data_valid : in  STD_LOGIC;
        led_out    : out STD_LOGIC_VECTOR(15 downto 0)
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

                if val > 54  then led_reg(0)  <= '1'; else led_reg(0)  <= '0'; end if;
                if val > 58  then led_reg(1)  <= '1'; else led_reg(1)  <= '0'; end if;
                if val > 62  then led_reg(2)  <= '1'; else led_reg(2)  <= '0'; end if;
                if val > 66  then led_reg(3)  <= '1'; else led_reg(3)  <= '0'; end if;
                if val > 70  then led_reg(4)  <= '1'; else led_reg(4)  <= '0'; end if;
                if val > 74  then led_reg(5)  <= '1'; else led_reg(5)  <= '0'; end if;
                if val > 78  then led_reg(6)  <= '1'; else led_reg(6)  <= '0'; end if;
                if val > 82  then led_reg(7)  <= '1'; else led_reg(7)  <= '0'; end if;
                if val > 86  then led_reg(8)  <= '1'; else led_reg(8)  <= '0'; end if;
                if val > 90  then led_reg(9)  <= '1'; else led_reg(9)  <= '0'; end if;
                if val > 94  then led_reg(10) <= '1'; else led_reg(10) <= '0'; end if;
                if val > 98  then led_reg(11) <= '1'; else led_reg(11) <= '0'; end if;
                if val > 102 then led_reg(12) <= '1'; else led_reg(12) <= '0'; end if;
                if val > 106 then led_reg(13) <= '1'; else led_reg(13) <= '0'; end if;
                if val > 112 then led_reg(14) <= '1'; else led_reg(14) <= '0'; end if;
                if val > 119 then led_reg(15) <= '1'; else led_reg(15) <= '0'; end if;

            end if;
        end if;
    end process;

    led_out <= led_reg;

end Behavioral;
