library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity audio_meter_top is
    port (

        -- vstupni signaly
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        m_data      : in  STD_LOGIC;

        -- vystupni signaly
        m_clk       : out STD_LOGIC;
        m_lr_sel    : out STD_LOGIC;

        -- docasny vystup - pouze pro testovani 
        db_out      : out STD_LOGIC_VECTOR(6 downto 0);
        db_valid    : out STD_LOGIC

        --seg         : out STD_LOGIC_VECTOR(6 downto 0);
        --an          : out STD_LOGIC_VECTOR(7 downto 0);
        --dp          : out STD_LOGIC;
        --led         : out STD_LOGIC_VECTOR(15 downto 0)
    );
end audio_meter_top;

architecture Behavioral of audio_meter_top is

    component pdm_interface is
        generic (G_DIV : positive := 33);
        port (

            clk         : in std_logic;
            rst         : in std_logic;
            m_clk       : out std_logic;
            m_lr_sel    : out std_logic; 
            m_data      : in std_logic; 
            data        : out std_logic; 
            clk_en      : out std_logic
        );
    end component;


    component acumulator is
        generic (G_N : positive := 4096);
        port (

            clk         :   in  STD_LOGIC; 
            rst         :   in  STD_LOGIC; 
            clk_en      :   in  STD_LOGIC;
            data        :   in  STD_LOGIC; 
            data_valid  :   out STD_LOGIC;
            data_out    :   out STD_LOGIC_VECTOR (12 downto 0) 
        );
    end component;


    component signal_processor2 is
        generic (G_N : positive := 2048);
        port (

            clk             : in std_logic;
            rst             : in std_logic;
            data            : in std_logic_vector(12 downto 0); 
            data_valid      : in std_logic; 
            db_valid        : out std_logic; 
            db_out          : out std_logic_vector(6 downto 0)
        );
    end component;

-- space for led_driver component


    -- Signals
        -- pdm_interface
        signal wire_data        : STD_LOGIC; 
        signal wire_clk_en      : STD_LOGIC; 

        --  acumulator
        signal wire_data_valid  : STD_LOGIC; 
        signal wire_data_out    : STD_LOGIC_VECTOR (12 downto 0);

        -- signal processor 
        signal wire_db_valid    : STD_LOGIC;
        signal wire_db_out      : STD_LOGIC_VECTOR (6 downto 0);

begin

    inst_pdm_interface : pdm_interface
        generic map (
            G_DIV => 33
        )
        port map (
            clk        => clk,
            rst        => rst,
            m_clk      => m_clk, 
            m_lr_sel   => m_lr_sel, 
            m_data     => m_data, 
            data       => wire_data, 
            clk_en     => wire_clk_en
        );

    
    inst_akumulator : acumulator  
        generic map (
            G_N => 4096
        )
        port map (
            clk         => clk,
            rst         => rst, 
            clk_en      => wire_clk_en, 
            data        => wire_data, 
            data_valid  => wire_data_valid, 
            data_out    => wire_data_out
        );

    inst_signal_processor2 : signal_processor2
        generic map (
            G_N => 2048
        )
        port map (
            clk         => clk,
            rst         => rst,
            data        => wire_data_out, 
            data_valid  => wire_data_valid, 
            db_valid    => wire_db_valid,
            db_out      => wire_db_out
        );
    
    
    db_out      <= wire_db_out;
    db_valid    <= wire_db_valid;

end Behavioral;
