library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_driver is
    generic (
        G_REFRESH : positive := 100_000
    );
    port (
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        data_in    : in  STD_LOGIC_VECTOR(6 downto 0);
        data_valid : in  STD_LOGIC;
        led_out    : out STD_LOGIC_VECTOR(15 downto 0);
        seg        : out STD_LOGIC_VECTOR(6 downto 0);
        an         : out STD_LOGIC_VECTOR(7 downto 0);
        dp         : out STD_LOGIC
    );
end led_driver;

architecture Behavioral of led_driver is

    function encode_seg(d : integer range 0 to 15) return STD_LOGIC_VECTOR is
    begin
        case d is
            when 0  => return "1000000"; -- 0
            when 1  => return "1111001"; -- 1
            when 2  => return "0100100"; -- 2
            when 3  => return "0110000"; -- 3
            when 4  => return "0011001"; -- 4
            when 5  => return "0010010"; -- 5
            when 6  => return "0000010"; -- 6
            when 7  => return "1111000"; -- 7
            when 8  => return "0000000"; -- 8
            when 9  => return "0010000"; -- 9
            when 10 => return "0100001"; -- 'd'
            when 11 => return "0000011"; -- 'b'
            when others => return "1111111"; 
        end case;
    end function;

    signal led_reg : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

    type digit_arr_t is array(0 to 7) of integer range 0 to 15;
    signal digits : digit_arr_t := (0, 0, 11, 10, 15, 15, 15, 15);

    signal refresh_cnt : integer range 0 to G_REFRESH-1 := 0;
    signal digit_sel   : integer range 0 to 7 := 0;

begin

    -- =========================================================================
    -- Proces 1: LED bargraf + 7-seg digits pri data_valid
    -- Stupnica: 54-120 dB rovnomerne cez 16 LED, krok ~4 dB
    -- =========================================================================
    process(clk)
        variable val      : integer range 0 to 127;
        variable hundreds : integer range 0 to 1;
        variable tens_v   : integer range 0 to 9;
        variable units_v  : integer range 0 to 9;
        variable tmp      : integer range 0 to 127;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                led_reg <= (others => '0');
                digits  <= (0, 0, 11, 10, 15, 15, 15, 15);

            elsif data_valid = '1' then
                val := to_integer(unsigned(data_in));

                -- LED bargraf: stupnica 54-120 dB, krok ~4 dB na LED
                if val > 54  then led_reg(0)  <= '1'; else led_reg(0)  <= '0'; end if;
                if val > 58  then led_reg(1)  <= '1'; else led_reg(1)  <= '0'; end if;
                if val > 62  then led_reg(2)  <= '1'; else led_reg(2)  <= '0'; end if;
                if val > 66  then led_reg(3)  <= '1'; else led_reg(3)  <= '0'; end if;
                if val > 70  then led_reg(4)  <= '1'; else led_reg(4)  <= '0'; end if;
                if val > 75  then led_reg(5)  <= '1'; else led_reg(5)  <= '0'; end if;
                if val > 79  then led_reg(6)  <= '1'; else led_reg(6)  <= '0'; end if;
                if val > 83  then led_reg(7)  <= '1'; else led_reg(7)  <= '0'; end if;
                if val > 87  then led_reg(8)  <= '1'; else led_reg(8)  <= '0'; end if;
                if val > 91  then led_reg(9)  <= '1'; else led_reg(9)  <= '0'; end if;
                if val > 95  then led_reg(10) <= '1'; else led_reg(10) <= '0'; end if;
                if val > 99  then led_reg(11) <= '1'; else led_reg(11) <= '0'; end if;
                if val > 104 then led_reg(12) <= '1'; else led_reg(12) <= '0'; end if;
                if val > 108 then led_reg(13) <= '1'; else led_reg(13) <= '0'; end if;
                if val > 112 then led_reg(14) <= '1'; else led_reg(14) <= '0'; end if;
                if val > 116 then led_reg(15) <= '1'; else led_reg(15) <= '0'; end if;

                
                tmp      := val;
                hundreds := tmp / 100;
                tmp      := tmp mod 100;
                tens_v   := tmp / 10;
                units_v  := tmp mod 10;

              
                digits(7) <= 15;         -- blank
                digits(6) <= 15;         -- blank
                digits(5) <= 10;         -- 'd'
                digits(4) <= 11;         -- 'b'
                digits(3) <= hundreds;   -- stovky 
                digits(2) <= tens_v;     -- desiatky
                digits(1) <= units_v;    -- jednotky
                digits(0) <= 15;         -- blank
            end if;
        end if;
    end process;

    -- =========================================================================
    -- Proces 2: refresh counter
    -- =========================================================================
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                refresh_cnt <= 0;
                digit_sel   <= 0;
            else
                if refresh_cnt = G_REFRESH - 1 then
                    refresh_cnt <= 0;
                    if digit_sel = 7 then
                        digit_sel <= 0;
                    else
                        digit_sel <= digit_sel + 1;
                    end if;
                else
                    refresh_cnt <= refresh_cnt + 1;
                end if;
            end if;
        end if;
    end process;

    -- =========================================================================
    -- Kombinacna logika: anody a segmenty
    -- =========================================================================
    process(digit_sel, digits)
    begin
        an <= "11111111";
        case digit_sel is
            when 0 => an <= "11111110";
            when 1 => an <= "11111101";
            when 2 => an <= "11111011";
            when 3 => an <= "11110111";
            when 4 => an <= "11101111";
            when 5 => an <= "11011111";
            when 6 => an <= "10111111";
            when 7 => an <= "01111111";
            when others => an <= "11111111";
        end case;
        seg <= encode_seg(digits(digit_sel));
    end process;

    dp      <= '1';
    led_out <= led_reg;

end Behavioral;
