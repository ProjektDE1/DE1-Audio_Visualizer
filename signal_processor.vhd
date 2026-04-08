
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity signal_processor is
    generic (
        G_BITS      : positive := 13;      
        G_REFRESH   : positive := 100_000  
    );
    port (
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        data       : in  STD_LOGIC_VECTOR(G_BITS-1 downto 0);
        data_valid : in  STD_LOGIC;
        spl_val    : out STD_LOGIC_VECTOR(6 downto 0);  
        led_data   : out STD_LOGIC_VECTOR(15 downto 0); 
        seg        : out STD_LOGIC_VECTOR(6 downto 0);   
        dp         : out STD_LOGIC;
        an         : out STD_LOGIC_VECTOR(7 downto 0)
    );
end signal_processor;

architecture Behavioral of signal_processor is

    -- -------------------------------------------------------------------------
    -- LUT 0-64 pre spl 0-99
    -- -------------------------------------------------------------------------
    type lut_t is array(0 to 64) of integer range 0 to 99;
    constant SPL_LUT : lut_t := (
         0,  16,  26,  33,  38,  42,  46,  49,  52,  55,
        57,  59,  61,  63,  64,  66,  67,  69,  70,  71,
        72,  73,  74,  75,  76,  77,  78,  79,  80,  81,
        81,  82,  83,  84,  84,  85,  86,  86,  87,  87,
        88,  89,  89,  90,  90,  91,  91,  92,  92,  93,
        93,  94,  94,  95,  95,  95,  96,  96,  97,  97,
        97,  98,  98,  99,  99
    );

    -- -------------------------------------------------------------------------
    -- 7 segmentovka  
    -- -------------------------------------------------------------------------
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

    signal sig_spl   : integer range 0 to 99 := 0;
    signal sig_leds  : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

    signal refresh_cnt : integer range 0 to G_REFRESH-1 := 0;
    signal digit_sel   : integer range 0 to 7 := 0;

    type digit_arr_t is array(0 to 7) of integer range 0 to 15;
    signal digits : digit_arr_t := (15, 15, 15, 15, 10, 11, 0, 0);

begin

    -- =========================================================================
    -- LUT konverzia
    -- =========================================================================
    process(clk) is
        variable count_v : integer range 0 to 8191 := 0;
        variable amp_v   : integer range 0 to 64   := 0;
        variable spl_v   : integer range 0 to 99   := 0;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sig_spl  <= 0;
                sig_leds <= (others => '0');
                digits   <= (15, 15, 15, 15, 10, 11, 0, 0);

            elsif data_valid = '1' then
                count_v := to_integer(unsigned(data));
                if count_v > 128 then
                    count_v := 128;
                end if;

               
                if count_v >= 64 then
                    amp_v := count_v - 64;
                else
                    amp_v := 64 - count_v;
                end if;

                -- LUT lookup
                spl_v   := SPL_LUT(amp_v);
                sig_spl <= spl_v;


                digits(7) <= 15;
                digits(6) <= 15;
                digits(5) <= 15;
                digits(4) <= 15;
                digits(3) <= 10;            -- d
                digits(2) <= 11;            -- b
                digits(1) <= spl_v / 10;    -- desiatky
                digits(0) <= spl_v mod 10;  -- jednotky

               
                for i in 0 to 15 loop
                    if spl_v > i * 6 then
                        sig_leds(i) <= '1';
                    else
                        sig_leds(i) <= '0';
                    end if;
                end loop;
            end if;
        end if;
    end process;

    -- =========================================================================
    -- Multiplex 7 segment displej
    -- =========================================================================
    process(clk) is
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
    process(digit_sel, digits) is
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

    dp <= '0'; 


    spl_val  <= std_logic_vector(to_unsigned(sig_spl, 7));
    led_data <= sig_leds;

end Behavioral;
