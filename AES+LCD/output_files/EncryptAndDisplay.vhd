library IEEE;
library WORK;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use WORK.AES_TYPES.all;

entity tb_EncryptAndDisplay is
end entity;

architecture testbench of tb_EncryptAndDisplay is
	signal clk : std_logic := '0';
	
	component EncryptAndDisplay is 
	   PORT( 
      reset              : IN     std_logic;  -- Map this Port to a Switch within your [Port Declarations / Pin Planer]  
      clock_50           : IN     std_logic;  -- Using the DE2 50Mhz Clk, in order to Genreate the 400Hz signal... clk_count_400hz reset count value must be set to:  <= x"0F424"
      
      lcd_rs             : OUT    std_logic;
      lcd_e              : OUT    std_logic;
      lcd_rw             : OUT    std_logic;
      lcd_on             : OUT    std_logic;
      lcd_blon           : OUT    std_logic;
      
      data_bus_0         : INOUT  STD_LOGIC;
      data_bus_1         : INOUT  STD_LOGIC;
      data_bus_2         : INOUT  STD_LOGIC;
      data_bus_3         : INOUT  STD_LOGIC;
      data_bus_4         : INOUT  STD_LOGIC;
      data_bus_5         : INOUT  STD_LOGIC;
      data_bus_6         : INOUT  STD_LOGIC;
      data_bus_7         : INOUT  STD_LOGIC;
      
      LCD_CHAR_ARRAY_0    : IN    STD_LOGIC;
      LCD_CHAR_ARRAY_1    : IN    STD_LOGIC;
		LCD_CHAR_ARRAY_2 	  : IN 	 STD_LOGIC;
		LCD_CHAR_ARRAY_3 	  : IN 	 STD_LOGIC);
	end component;
	
	component frequency_divider is
		Port (clk_in : in  STD_LOGIC;
				clk_out: out STD_LOGIC);
	end component;
	
	signal clock : std_logic := '0';
	signal rs : std_logic := '0';
	signal lcdrs, lcde, lcdrw, lcdon, lcdblon, db0, db1, db2, db3,db4, db5, db6,db7, charray0, charray1,charray2, charray3: std_logic := '1';
	signal div_clock : std_logic := '0';
	begin
	FREQDOB : frequency_divider port map (clock, div_clock);
	LCDDISP : EncryptAndDisplay port map (rs,div_clock,lcdrs,lcde, lcdrw, lcdon, lcdblon, db0, db1, db2, db3,db4, db5, db6,db7, charray0, charray1,charray2,charray3);
						
	clocking : process 
	begin
		clock <= '1';
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;
	end process clocking;
	
end testbench;
