-- SIGNAL_PROCESSOR2
-- centers the data from the accumulator around zero -> performs its absolute value
-- data for the LED_driver is available when db_valid == 1

-- repair of architecture
-- instead of PEAK we calculate average absolute value, 
-- which creates a low pass filter and filters out high frequency interference -> as a response to the problem with measuring min 90dB
-- average to a 19-bit register, which corresponds to 173ms at our sampling frequency -> which is close to SPL FAST 

library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;       
use IEEE.NUMERIC_STD.ALL;
use work.db_pkg.ALL; 

entity signal_processor2 is

    generic (G_N : positive := 2048);
    port (
        clk             : in std_logic;
        rst             : in std_logic;

        data            : in std_logic_vector(12 downto 0); 
        data_valid      : in std_logic; 

        db_valid        : out std_logic; 
        db_out          : out std_logic_vector(6 downto 0)
    );
end entity;

architecture behavioral of signal_processor2 is

    -- for implementation
    constant TIME_CONST : integer := 524_288 - 1;

    -- -- for testing
    -- constant TIME_CONST : integer := 7;
    
    signal db_counter   : unsigned (32 downto 0) := (others => '0');

    signal time_counter : integer range 0 to TIME_CONST := 0; 
    signal db_for_out   : unsigned (6 downto 0)  := (others => '0');
    
begin

    process (clk) is
        variable data_us : unsigned(12 downto 0);
        variable tmp     : unsigned(12 downto 0);
        variable avg_val : integer; 
    
    begin
        
        if rising_edge(clk) then

            if rst = '1' then
                db_counter      <= (others => '0');
                db_for_out      <= (others => '0'); 
                time_counter    <= 0;
                db_valid        <= '0';
            else    

                db_valid <= '0'; 

                -- zero offset and absolute value
                if data_valid = '1' then
                        
                    data_us := unsigned(data);

                    -- absolute value
                    if data_us >= G_N then
                        tmp := data_us - G_N;
                    else
                        tmp := G_N - data_us;
                    end if;

                    -- adding the value from the accumulator to the counter
                    -- resizing tmp
                    db_counter <= db_counter + resize(tmp, 33);
                    
                    -- averaging and comparing with LUT
                    if time_counter = TIME_CONST then
                        
                        -- counter division -> 12bit to ang_val only
                        -- truncation of 19 bits is the same as dividing by 524 288
                        
                        -- for implementation
                        avg_val := to_integer(db_counter(30 downto 19)); 

                        -- -- for testing
                        -- avg_val := to_integer(db_counter(30 downto 3)); 

                        -- treatment of excess
                        if avg_val > 2048 then
                            avg_val := 2048;
                        end if;
                        
                        db_for_out   <= to_unsigned(SPL_LUT(avg_val) -17 , 7);
                        db_valid     <= '1'; 

                        -- adding the current sample so we don't lose it
                        db_counter   <= resize(tmp, 33);
                        time_counter <= 0; 
                    else
                        time_counter <= time_counter + 1; 
                    end if;
                end if;
            end if;
        end if;
    end process;

    db_out <= std_logic_vector(db_for_out);

end behavioral;