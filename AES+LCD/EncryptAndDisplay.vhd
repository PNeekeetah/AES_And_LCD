library IEEE;
library WORK;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use WORK.AES_TYPES.all;

entity EncryptAndDisplay is 

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
		LCD_CHAR_ARRAY_2    : IN    STD_LOGIC;
      LCD_CHAR_ARRAY_3    : IN    STD_LOGIC);
end entity;

architecture structural of EncryptAndDisplay is

	component AES is
	
		port ( plain_in   :  in MATRIX := (16#00#,16#11#,16#22#,16#33#,16#44#,16#55#,16#66#,16#77#,16#88#,16#99#,16#AA#,16#BB#,16#CC#,16#DD#,16#EE#,16#FF#);
					key_in   :  in MATRIX := (16#00#,16#11#,16#22#,16#33#,16#44#,16#55#,16#66#,16#77#,16#88#,16#99#,16#AA#,16#BB#,16#CC#,16#DD#,16#EE#,16#FF#);
					clk_in   :  in std_logic;
				 cipher_out : out MATRIX );
	
	end component;
	
	component LCD_DISPLAY_nty IS
		GENERIC( 
			num_hex_digits : integer := 2
		);
		
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
      LCD_CHAR_ARRAY_2    : IN    STD_LOGIC;
      LCD_CHAR_ARRAY_3    : IN    STD_LOGIC;
      
      Hex_Display_Data_0 : IN     STD_LOGIC;
      Hex_Display_Data_1 : IN     STD_LOGIC;
      Hex_Display_Data_2 : IN     STD_LOGIC;
      Hex_Display_Data_3 : IN     STD_LOGIC;
      Hex_Display_Data_4 : IN     STD_LOGIC;
      Hex_Display_Data_5 : IN     STD_LOGIC;
      Hex_Display_Data_6 : IN     STD_LOGIC;
      Hex_Display_Data_7 : IN     STD_LOGIC;
		ciphertext 			 : IN 	 MATRIX);
	end component;
	
	component frequency_divider is
		Port (clk_in : in  STD_LOGIC;
				clk_out: out STD_LOGIC);
	end component;
	signal buffermat : MATRIX;
	signal empty : MATRIX;
	signal cipher : MATRIX;
	signal div_clk: std_logic := '0';
begin
	DIV : frequency_divider port map (clock_50,div_clk); -- reduces frequency 10000 times - enc should take 10 millisecond rather than 1 microsecond
   ENC : AES port map (plain_in => (16#00#,16#11#,16#22#,16#33#,16#44#,16#55#,16#66#,16#77#,16#88#,16#99#,16#AA#,16#BB#,16#CC#,16#DD#,16#EE#,16#FF#), key_in => (16#00#,16#11#,16#22#,16#33#,16#44#,16#55#,16#66#,16#77#,16#88#,16#99#,16#AA#,16#BB#,16#CC#,16#DD#,16#EE#,16#FF#), clk_in => div_clk, cipher_out => buffermat);
	LCD : LCD_DISPLAY_nty port map (reset => reset,
											  clock_50 => clock_50,
											  lcd_rs => lcd_rs,
											  lcd_e => lcd_e,
											  lcd_rw => lcd_rw,
											  lcd_on => lcd_on,
											  lcd_blon => lcd_blon,
											  data_bus_0 => data_bus_0,
											  data_bus_1 => data_bus_1,
											  data_bus_2 => data_bus_2,
											  data_bus_3 => data_bus_3,
											  data_bus_4 => data_bus_4,
											  data_bus_5 => data_bus_5,
											  data_bus_6 => data_bus_6,
											  data_bus_7 => data_bus_7,
											  LCD_CHAR_ARRAY_0 => LCD_CHAR_ARRAY_0,
											  LCD_CHAR_ARRAY_1 => LCD_CHAR_ARRAY_1,
											  LCD_CHAR_ARRAY_2 => LCD_CHAR_ARRAY_2,
											  LCD_CHAR_ARRAY_3 => LCD_CHAR_ARRAY_3,
											  Hex_Display_Data_0 => '0',
											  Hex_Display_Data_1 => '0',
											  Hex_Display_Data_2 => '0',
											  Hex_Display_Data_3 => '0',
											  Hex_Display_Data_4 => '0', 
											  Hex_Display_Data_5 => '0',
											  Hex_Display_Data_6 => '0',
											  Hex_Display_Data_7 => '0',
											  ciphertext => cipher);
											  
	encproc : process (buffermat)
	begin
		cipher <= buffermat;
	end process encproc;
end structural;