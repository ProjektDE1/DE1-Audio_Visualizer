
-- rozlozeni funkci signal procesoru s LUT a LED driveru  

library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;       
use IEEE.NUMERIC_STD.ALL;
use work.db_pkg.ALL; 

entity signal_processor2 is

    generic (G_N : positive := 2049);
    port (
        clk             : in std_logic;
        rst             : in std_logic;
        clk_en          : in std_logic; 

        data            : in std_logic_vector(12 downto 0); 
        data_valid      : in std_logic; 

        db_valid        : out std_logic; 
        db_out          : out std_logic_vector(6 downto 0)
    );
end entity;

architecture behavioral of signal_processor2 is

    -- SPL FAST podle normy 125ms
    constant TIME_CONST : integer := 12_500_000 - 1;
    
    signal current_peak : unsigned (12 downto 0) := (others => '0');
    signal time_counter : integer range 0 to 12_500_000 := 0;
    
    signal db_for_out : unsigned (6 downto 0) := (others => '0');
    
begin

    process (clk) is
        variable data_us : unsigned(12 downto 0);
        variable tmp     : unsigned(12 downto 0);
    
    begin
        
        if rising_edge(clk) then

            if rst = '1' then
                time_counter <= 0; 
                current_peak <= (others => '0' );
            else

                -- vyrovnani kolem nuly a absolutni hodnota
                if clk_en = '1' then

                    data_us := unsigned(data);

                    if data_us >= G_N then
                        tmp := data_us - G_N;
                    else
                        tmp := G_N - data_us;
                    end if;

                    if tmp > current_peak then
                        current_peak <= tmp;
                    end if;
                end if;


                -- koukneme do LUT v momente kdy mame zmereny peak za 125ms
                if time_counter = TIME_CONST then
                    time_counter <= 0; 
                    db__for_out  <= to_unsigned(SPL_LUT(to_integer(current_peak)), 7);
                    db_valid     <= '1';
                    current_peak <= (others => '0' );
                else
                    time_counter <= time_counter + 1; 
                end if;

            end if;
        end if;
    end process;

    db_out <= std_logic_vector(db_for_out);

end behavioral;