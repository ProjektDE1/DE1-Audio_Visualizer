----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2026 03:18:07 PM
-- Design Name: 
-- Module Name: audio_meter_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity audio_meter_top is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           mic_data_in :in STD_LOGIC; 
           mic_clk_out : out STD_LOGIC; 
           led_data : out STD_LOGIC_VECTOR (15 downto 0);
           spl_val : out STD_LOGIC_VECTOR (6 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           dp : out STD_LOGIC;
           led : out STD_LOGIC_VECTOR (15 downto 0));
end audio_meter_top;


architecture Behavioral of audio_meter_top is


component acu_enable 

    generic(G_MAX : positive := 128); 
    port(
        clk          : in     STD_LOGIC; 
        rst          : in     STD_LOGIC;
        clk_div_en   : in     STD_LOGIC; 
        en           : out    STD_LOGIC 
    );
end component;

component clock_divider 

    generic(G_DIV : positive := 33); 
    port (
        clk      : in  STD_LOGIC; 
        rst      : in  STD_LOGIC; 
        clk_en   : out STD_LOGIC
    );

end component; 

 component acumulator 

    generic (G_BITS : positive := 8);

    port (
        clk         :   in  STD_LOGIC; 
        rst         :   in  STD_LOGIC; 
        clk_div_en  :   in  STD_LOGIC;
        data        :   in  STD_LOGIC; 
        en          :   in  STD_LOGIC; 
        data_valid  :   out STD_LOGIC; 
        data_out    :   out STD_LOGIC_VECTOR (G_BITS-1 downto 0) -- 8 bit sbernice 
    );

end  component; 

component microphone 
    port (
        clk         : in  STD_LOGIC;  
        rst         : in  STD_LOGIC;
        div_clk_en  : in  STD_LOGIC;  
        mic_data_in : in  STD_LOGIC; 
        mic_clk_out : out STD_LOGIC;  
        mic_lr_sel  : out STD_LOGIC; 
        data        : out STD_LOGIC  
    );
end component;

component signal_processor
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
end component;

signal clk_en_div : STD_LOGIC;  
signal enable     : STD_LOGIC; 
signal mic_data   : STD_LOGIC; 
signal data_val   : STD_LOGIC;
signal data_out_aku : STD_LOGIC_VECTOR (7 downto 0);  -- pozdeji definovat konstantu
signal spl_val_out : STD_LOGIC_VECTOR (6 downto 0); 
signal led_data_out : STD_LOGIC_VECTOR (15 downto 0); 

begin
    
    clk_divider : clock_divider 
    generic map (G_DIV => 33)
    port map(
        clk => clk,
        rst => rst, 
        clk_en => clk_en_div 
    );
    
    acu_enabler : acu_enable
    generic map (G_MAX => 128)
    port map(
        clk => clk, 
        rst => rst, 
        clk_div_en => clk_en_div,
        en => enable
    );
    
    mic : microphone
    port map(
        clk => clk, 
        rst => rst, 
        div_clk_en => clk_en_div, 
        mic_data_in => mic_data_in, 
        mic_clk_out => mic_clk_out,
        data => mic_data
    );
    
    acumulator1 : acumulator
        generic map (G_BITS => 8)
        port map(
            clk => clk, 
            rst => rst,
            en => enable, 
            clk_div_en => clk_en_div, 
            data => mic_data, 
            data_valid => data_val, 
            data_out => data_out_aku
        ); 
        
      processor : signal_processor
      generic map (
            G_BITS => 8, 
            G_REFRESH => 100000
        )
      port map(
            clk => clk, 
            rst => rst,
            data => data_out_aku, 
            data_valid => data_val, 
            spl_val => spl_val_out, 
            led_data => led_data_out, 
            seg => seg, 
            an => an, 
            dp => dp
        );

led <= led_data_out; 

end Behavioral;
