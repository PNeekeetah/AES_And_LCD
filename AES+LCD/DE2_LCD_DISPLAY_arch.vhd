--
-- VHDL Architecture DE2_LCD_lib.LCD_DISPLAY_nty.LCD_DISPLAY_arch
--
-- Created:
--          by - Gerry O'Brien 
--          WWW.DIGITAL-CIRCUITRY.COM
--          at - 15:30:18 26/03/2015
--
-- using Mentor Graphics HDL Designer(TM) 2010.3 (Build 21)
--
library IEEE;
library WORK;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use WORK.AES_TYPES.all;

ENTITY LCD_DISPLAY_nty IS
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

-- Declarations

END LCD_DISPLAY_nty ;

--
ARCHITECTURE LCD_DISPLAY_arch OF LCD_DISPLAY_nty IS
  type character_string is array ( 0 to 31 ) of STD_LOGIC_VECTOR( 7 downto 0 );
  
    type BYTESMATRIX is array (0 to 31) of U_BYTE;
  
  type state_type is (hold, func_set, display_on, mode_set, print_string,
                      line2, return_home, drop_lcd_e, reset1, reset2,
                       reset3, display_off, display_clear);
                       
  signal state, next_command         : state_type;
	
  signal empty : MATRIX;
  signal line1 : MATRIX := (16#00#,16#11#,16#22#,16#33#,16#44#,16#55#,16#66#,16#77#,16#88#,16#99#,16#AA#,16#BB#,16#CC#,16#DD#,16#EE#,16#FF#);
  signal line1out : BYTESMATRIX;

  signal lcd_display_string          : character_string;
  
  signal lcd_display_string_01       : character_string;
  signal lcd_display_string_02       : character_string;
  signal lcd_display_string_03       : character_string;
  signal lcd_display_string_04       : character_string;
  signal lcd_display_string_05       : character_string;
  signal lcd_display_string_06       : character_string;
  signal lcd_display_string_07       : character_string;
  signal lcd_display_string_08       : character_string;
  signal lcd_display_string_09       : character_string;
  signal lcd_display_string_10       : character_string;
  signal lcd_display_string_11       : character_string;
  
  signal data_bus_value, next_char   : STD_LOGIC_VECTOR(7 downto 0);
  signal clk_count_400hz             : STD_LOGIC_VECTOR(19 downto 0);
  
  signal char_count                  : STD_LOGIC_VECTOR(4 downto 0);
  signal clk_400hz_enable,lcd_rw_int : std_logic;
  
  signal Hex_Display_Data            : STD_LOGIC_VECTOR(7 DOWNTO 0); 
  signal data_bus                    : STD_LOGIC_VECTOR(7 downto 0);	
  signal LCD_CHAR_ARRAY              : STD_LOGIC_VECTOR(3 DOWNTO 0);
  
  --SIGNAL SIG_ENABLE_count            : STD_LOGIC_VECTOR(19 DOWNTO 0) := "00000000000000000000";  
  --SIGNAL LCD_ENABLE_SET              : std_logic;
  --SIGNAL LCD_ENABLE_RESET            : std_logic;
  --SIGNAL ENABLE_LINE                 : std_logic := '0';
  
  procedure toByteDisplay(input : in MATRIX;
				 output:out BYTESMATRIX) is
    variable aux : MATRIX;
	 variable oux : BYTESMATRIX;
	 variable upn : U_BYTE;
	 variable don : U_BYTE; 
  begin
   aux := input;
	for i in 0 to 15 loop
	  upn := to_integer(shift_right (to_unsigned(aux(i),8),4));
	  don := aux(i) mod 16;
	  case upn is
		when 0 => oux(2*i) := 16#30#;
		when 1 => oux(2*i) := 16#31#;
		when 2 => oux(2*i) := 16#32#;
		when 3 => oux(2*i) := 16#33#;
		when 4 => oux(2*i) := 16#34#;
		when 5 => oux(2*i) := 16#35#;
		when 6 => oux(2*i) := 16#36#;
		when 7 => oux(2*i) := 16#37#;
		when 8 => oux(2*i) := 16#38#;
		when 9 => oux(2*i) := 16#39#;
		when 10 => oux(2*i) := 16#41#;
		when 11 => oux(2*i) := 16#42#;
		when 12 => oux(2*i) := 16#43#;
		when 13 => oux(2*i) := 16#44#;
		when 14 => oux(2*i) := 16#45#;
		when 15 => oux(2*i) := 16#46#;
		when others => oux(i) := 16#FF#;
     end case;
	  case don is
		when 0 => oux(2*i+1) := 16#30#;
		when 1 => oux(2*i+1) := 16#31#;
		when 2 => oux(2*i+1) := 16#32#;
		when 3 => oux(2*i+1) := 16#33#;
		when 4 => oux(2*i+1) := 16#34#;
		when 5 => oux(2*i+1) := 16#35#;
		when 6 => oux(2*i+1) := 16#36#;
		when 7 => oux(2*i+1) := 16#37#;
		when 8 => oux(2*i+1) := 16#38#;
		when 9 => oux(2*i+1) := 16#39#;
		when 10 => oux(2*i+1) := 16#41#;
		when 11 => oux(2*i+1) := 16#42#;
		when 12 => oux(2*i+1) := 16#43#;
		when 13 => oux(2*i+1) := 16#44#;
		when 14 => oux(2*i+1) := 16#45#;
		when 15 => oux(2*i+1) := 16#46#;
		when others => oux(i) := 16#FF#;
     end case;
	end loop;
	
	output := oux;
  
  end procedure;
  
BEGIN
  


--===================================================--  
-- SIGNAL STD_LOGIC_VECTORS assigned to OUTPUT PORTS 
--===================================================--    
Hex_Display_Data(0) <= Hex_Display_Data_0;
Hex_Display_Data(1) <= Hex_Display_Data_1;   
Hex_Display_Data(2) <= Hex_Display_Data_2;
Hex_Display_Data(3) <= Hex_Display_Data_3;  
Hex_Display_Data(4) <= Hex_Display_Data_4;
Hex_Display_Data(5) <= Hex_Display_Data_5;  
Hex_Display_Data(6) <= Hex_Display_Data_6;
Hex_Display_Data(7) <= Hex_Display_Data_7;  

data_bus_0 <= data_bus(0);
data_bus_1 <= data_bus(1);
data_bus_2 <= data_bus(2);
data_bus_3 <= data_bus(3);
data_bus_4 <= data_bus(4);
data_bus_5 <= data_bus(5);
data_bus_6 <= data_bus(6);
data_bus_7 <= data_bus(7);
    
LCD_CHAR_ARRAY(0) <= LCD_CHAR_ARRAY_0;
LCD_CHAR_ARRAY(1) <= LCD_CHAR_ARRAY_1;
LCD_CHAR_ARRAY(2) <= LCD_CHAR_ARRAY_2;
LCD_CHAR_ARRAY(3) <= LCD_CHAR_ARRAY_3;


 
  
 
-- ASCII hex values for LCD Display
-- Enter Live Hex Data Values from hardware here

-- LCD DISPLAYS THE FOLLOWING:

------------------------------
--| Count=XX |
--| DE2 |
------------------------------


-- Accessing the Input Switches for 2 digit HEX Display 
-------------------------------------------------------------------------
 --   x"0"&hex_display_data(7 downto 4),x"0"&hex_display_data(3 downto 0), 

--   = x"20",
-- ! = x"21",
-- " = x"22",
-- # = x"23",
-- $ = x"24",
-- % = x"25",
-- & = x"26",
-- ' = x"27",
-- ( = x"28",
-- ) = x"29",
-- * = x"2A",
-- + = x"2B",
-- , = x"2C",
-- - = x"2D",
-- . = x"2E",
-- / = x"2F",



-- 0 = x"30",
-- 1 = x"31",
-- 2 = x"32",
-- 3 = x"33",
-- 4 = x"34",
-- 5 = x"35",
-- 6 = x"36",
-- 7 = x"37",
-- 8 = x"38",
-- 9 = x"39",
-- : = x"3A",
-- ; = x"3B",
-- < = x"3C",
-- = = x"3D",
-- > = x"3E",
-- ? = x"3F",




-- Q = x"40",
-- A = x"41",
-- B = x"42",
-- C = x"43",
-- D = x"44",
-- E = x"45",
-- F = x"46",
-- G = x"47",
-- H = x"48",
-- I = x"49",
-- J = x"4A",
-- K = x"4B",
-- L = x"4C",
-- M = x"4D",
-- N = x"4E",
-- O = x"4F",



-- P = x"50",
-- Q = x"51",
-- R = x"52",
-- S = x"53",
-- T = x"54",
-- U = x"55",
-- V = x"56",
-- W = x"57",
-- X = x"58",
-- Y = x"59",
-- Z = x"5A",
-- [ = x"5B",
-- Y! = x"5C",
-- ] = x"5D",
-- ^ = x"5E",
-- _ = x"5F",



-- \ = x"60",
-- a = x"61",
-- b = x"62",
-- c = x"63",
-- d = x"64",
-- e = x"65",
-- f = x"66",
-- g = x"67",
-- h = x"68",
-- i = x"69",
-- j = x"6A",
-- k = x"6B",
-- l = x"6C",
-- m = x"6D",
-- n = x"6E",
-- o = x"6F",



-- p = x"70",
-- q = x"71",
-- r = x"72",
-- s = x"73",
-- t = x"74",
-- u = x"75",
-- v = x"76",
-- w = x"77",
-- x = x"78",
-- y = x"79",
-- z = x"7A",
-- { = x"7B",
-- | = x"7C",
-- } = x"7D",
-- -> = x"7E",
-- <- = x"7F",



   
   
   
--========================================================================================================================================================================================== 




--==========================================================================================================================================================================================    
   lcd_display_string_03 <= 
    (
-- Line 1    C    h      a     r     g     i     n      g  
          x"43",x"68",x"61",x"72",x"67",x"69",x"6E",x"67",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",
   
-- Line 2   ->     %    2     5 
          x"7E",x"25",x"32",x"35",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20" 
   );
   
   




--==========================================================================================================================================================================================   
   lcd_display_string_04 <= 
     (
-- Line 1    C    h      a     r     g     i     n      g  
          x"43",x"68",x"61",x"72",x"67",x"69",x"6E",x"67",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",
   
-- Line 2   ->     %    5     0 
          x"7E",x"25",x"35",x"30",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20" 
   );
   
   
   
   
   






--==========================================================================================================================================================================================   
   lcd_display_string_05 <= 
        (
-- Line 1    C    h      a     r     g     i     n      g  
          x"43",x"68",x"61",x"72",x"67",x"69",x"6E",x"67",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",
   
-- Line 2   ->     %    7     5 
          x"7E",x"25",x"37",x"35",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20" 
   );
   
   
    
   






--==========================================================================================================================================================================================    
   lcd_display_string_06 <= 
       (
-- Line 1    C    h      a     r     g     i     n      g  
          x"43",x"68",x"61",x"72",x"67",x"69",x"6E",x"67",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",
   
-- Line 2   ->     %    1     0      0
          x"7E",x"25",x"31",x"30",x"30",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20" 
   );
   
   
   
   






--==========================================================================================================================================================================================    
   lcd_display_string_07 <= 
   (
-- Line 1    B    a      t     t     e    r     y          L     e     v      e    l 
          x"42",x"61",x"74",x"74",x"65",x"72",x"79",x"20",x"4C",x"65",x"76",x"65",x"6C",x"20",x"20",x"20",
   
-- Line 2   ->     %    2     5 
          x"7E",x"25",x"32",x"35",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20" 
   );
   
   
   





--==========================================================================================================================================================================================    
   lcd_display_string_08 <= 
    (
--- Line 1    B    a      t     t     e    r     y          L     e     v      e    l 
          x"42",x"61",x"74",x"74",x"65",x"72",x"79",x"20",x"4C",x"65",x"76",x"65",x"6C",x"20",x"20",x"20",
   
-- Line 2   ->     %    5     0 
          x"7E",x"25",x"35",x"30",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20" 
   );
   
   
   



--==========================================================================================================================================================================================    
   lcd_display_string_09 <= 
    (
-- Line 1    B    a      t     t     e    r     y          L     e     v      e    l 
          x"42",x"61",x"74",x"74",x"65",x"72",x"79",x"20",x"4C",x"65",x"76",x"65",x"6C",x"20",x"20",x"20",
   
-- Line 2   ->     %    7     5 
          x"7E",x"25",x"37",x"35",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20" 
   );
   
   
   
   
   
   
--==========================================================================================================================================================================================    
   lcd_display_string_10 <= 
    (
-- Line 1    B    a      t     t     e    r     y          L     e     v      e    l 
          x"42",x"61",x"74",x"74",x"65",x"72",x"79",x"20",x"4C",x"65",x"76",x"65",x"6C",x"20",x"20",x"20",
   
-- Line 2   ->     %    1     0      0
          x"7E",x"25",x"31",x"30",x"30",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20" 
   );
   
   
   


   
--==========================================================================================================================================================================================    
   lcd_display_string_11 <= 
    (
-- Line 1                     B    L      U     E     T     O     O     T     H
          x"20",x"20",x"20",x"42",x"4C",x"55",x"45",x"54",x"4F",x"4F",x"54",x"48",x"20",x"20",x"20",x"20",
   
-- Line 2                C     O     N    T      R     O     L    L     E      R
          x"20",x"20",x"43",x"4F",x"4E",x"54",x"52",x"4F",x"4C",x"4C",x"45",x"52",x"20",x"20",x"0"&hex_display_data(7 downto 4),x"0"&hex_display_data(3 downto 0)
   );
   



-------------------------------------------------------------------------------------------------------
-- BIDIRECTIONAL TRI STATE LCD DATA BUS
   data_bus <= data_bus_value when lcd_rw_int = '0' else "ZZZZZZZZ";
   
-- LCD_RW PORT is assigned to it matching SIGNAL 
 lcd_rw <= lcd_rw_int;
 
 
 
 
 
 

------------------------------------ STATE MACHINE FOR LCD SCREEN MESSAGE SELECT -----------------------------
---------------------------------------------------------------------------------------------------------------
PROCESS (LCD_CHAR_ARRAY)
	variable linep : MATRIX;
	variable linebp: BYTESMATRIX;
	variable linecs: character_string;

BEGIN
  
-- get next character in display string based on the LCD_CHAR_ARRAY (switches or Multiplexer)

     CASE (LCD_CHAR_ARRAY) IS
          
          -- Bluetooth Disconnected
       WHEN "0000" =>
				 lcd_display_string_01 <= 
  (
-- Line 1    B    l     u     e    t      o     o     t     h          L      i     n     k 
          x"4d",x"6f",x"61",x"72",x"74",x"65",x"20",x"6c",x"61",x"20",x"74",x"6f",x"74",x"69",x"20",x"20",
   
-- Line 2   ->    D      I    S      C     O     N     N      E    C      T    E     D
          x"74",x"69",x"67",x"61",x"6e",x"69",x"69",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20" 
   );
	
				linep := ciphertext;
				toByteDisplay (linep,linebp);
				for i in 0 to 31 loop
					lcd_display_string_01(i) <= std_logic_vector(to_unsigned(linebp(i),8));
				end loop;
            next_char <= lcd_display_string_01(CONV_INTEGER(char_count));
                                                                          
          -- Bluetooth Connected                                                                                         
       WHEN "0001" =>
				linep := line1;
				toByteDisplay(linep,linebp);
            for i in 0 to 31 loop
					linecs(i) := std_logic_vector(to_unsigned(linebp(i),8));
				end loop;
				next_char <= linecs(CONV_INTEGER(char_count));
				
            
            -- CHARGING %25
       WHEN "0010" =>      
            next_char <= lcd_display_string_03(CONV_INTEGER(char_count));            
            
            -- CHARGING %50                                                           
       WHEN "0011" =>      
            next_char <= lcd_display_string_04(CONV_INTEGER(char_count));                                                                                                                         
        
            -- CHARGING %75
       WHEN "0100"  =>      
            next_char <= lcd_display_string_05(CONV_INTEGER(char_count));
                
            -- CHARGING %100        
       WHEN "0101" =>
           next_char <= lcd_display_string_06(CONV_INTEGER(char_count));
              
            -- Battery Level %25                                                                                           
       WHEN "0110" =>      
           next_char <= lcd_display_string_07(CONV_INTEGER(char_count));
            
           -- Battery Level %50   
       WHEN "0111" =>      
           next_char <= lcd_display_string_08(CONV_INTEGER(char_count)); 
                            
           -- Battery Level %75      
       WHEN "1000" =>      
           next_char <= lcd_display_string_09(CONV_INTEGER(char_count));
                   
           -- Battery Level %100  
       WHEN "1001" =>      
           next_char <= lcd_display_string_10(CONV_INTEGER(char_count));         
                                                                                                                              
                 --  BLUETOOTH CONTROLLER                                                                 
            WHEN OTHERS =>              
               next_char <= lcd_display_string_11(CONV_INTEGER(char_count));
                                                     
       END CASE;
END PROCESS;
   

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
  
  
--=====================================================================-- 
--======================= CLOCK #1 SIGNALS ============================--  
--=====================================================================-- 
process(clock_50)
begin
      if (rising_edge(clock_50)) then
         if (reset = '0') then
            clk_count_400hz <= x"00000";
            clk_400hz_enable <= '0';
         else
            if (clk_count_400hz <= x"0F424") then             
                   clk_count_400hz <= clk_count_400hz + 1;                                   
                   clk_400hz_enable <= '0';                
            else
                   clk_count_400hz <= x"00000";
                   clk_400hz_enable <= '1';
            end if;
         end if;
      end if;
end process;  
--==================================================================--    
  




  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
--======================== LCD DRIVER CORE ==============================--   
--                     STATE MACHINE WITH RESET                          -- 
--===================================================-----===============--  
process (clock_50, reset)
begin
 
  
        if reset = '0' then
           state <= reset1;
           data_bus_value <= x"38"; -- RESET
           next_command <= reset2;
           lcd_e <= '1';
           lcd_rs <= '0';
           lcd_rw_int <= '0';  
        
    
    
        elsif rising_edge(clock_50) then
             if clk_400hz_enable = '1' then  
                 
                 
                 
              --========================================================--                 
              -- State Machine to send commands and data to LCD DISPLAY
              --========================================================--
                 case state is
                 -- Set Function to 8-bit transfer and 2 line display with 5x8 Font size
                 -- see Hitachi HD44780 family data sheet for LCD command and timing details
                       
                       
                       
--======================= INITIALIZATION START ============================--
                       when reset1 =>
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"38"; -- EXTERNAL RESET
                            state <= drop_lcd_e;
                            next_command <= reset2;
                            char_count <= "00000";
  
                       when reset2 =>
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"38"; -- EXTERNAL RESET
                            state <= drop_lcd_e;
                            next_command <= reset3;
                            
                       when reset3 =>
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"38"; -- EXTERNAL RESET
                            state <= drop_lcd_e;
                            next_command <= func_set;
            
            
                       -- Function Set
                       --==============--
                       when func_set =>                
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"38";  -- Set Function to 8-bit transfer, 2 line display and a 5x8 Font size
                            state <= drop_lcd_e;
                            next_command <= display_off;
                            
                            
                            
                       -- Turn off Display
                       --==============-- 
                       when display_off =>
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"08"; -- Turns OFF the Display, Cursor OFF and Blinking Cursor Position OFF.......(0F = Display ON and Cursor ON, Blinking cursor position ON)
                            state <= drop_lcd_e;
                            next_command <= display_clear;
                           
                           
                       -- Clear Display 
                       --==============--
                       when display_clear =>
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"01"; -- Clears the Display    
                            state <= drop_lcd_e;
                            next_command <= display_on;
                           
                           
                           
                       -- Turn on Display and Turn off cursor
                       --===================================--
                       when display_on =>
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"0C"; -- Turns on the Display (0E = Display ON, Cursor ON and Blinking cursor OFF) 
                            state <= drop_lcd_e;
                            next_command <= mode_set;
                          
                          
                       -- Set write mode to auto increment address and move cursor to the right
                       --====================================================================--
                       when mode_set =>
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"06"; -- Auto increment address and move cursor to the right
                            state <= drop_lcd_e;
                            next_command <= print_string; 
                            
                                
--======================= INITIALIZATION END ============================--                          
                          
                          
                          
                          
--=======================================================================--                           
--               Write ASCII hex character Data to the LCD
--=======================================================================--
                       when print_string =>          
                            state <= drop_lcd_e;
                            lcd_e <= '1';
                            lcd_rs <= '1';
                            lcd_rw_int <= '0';
                          
                          
                               -- ASCII character to output
                               if (next_char(7 downto 4) /= x"0") then
                                  data_bus_value <= next_char;
                               else
                             
                                    -- Convert 4-bit value to an ASCII hex digit
                                    if next_char(3 downto 0) >9 then 
                              
                                    -- ASCII A...F
                                      data_bus_value <= x"4" & (next_char(3 downto 0)-9); 
                                    else 
                                
                                    -- ASCII 0...9
                                      data_bus_value <= x"3" & next_char(3 downto 0);
                                    end if;
                               end if;
                          
                            state <= drop_lcd_e; 
                          
                          
                            -- Loop to send out 32 characters to LCD Display (16 by 2 lines)
                               if (char_count < 31) AND (next_char /= x"fe") then
                                   char_count <= char_count +1;                            
                               else
                                   char_count <= "00000";
                               end if;
                  
                  
                  
                            -- Jump to second line?
                               if char_count = 15 then 
                                  next_command <= line2;
                   
                   
                   
                            -- Return to first line?
                               elsif (char_count = 31) or (next_char = x"fe") then
                                     next_command <= return_home;
                               else 
                                     next_command <= print_string; 
                               end if; 
                 
                 
                 
                       -- Set write address to line 2 character 1
                       --======================================--
                       when line2 =>
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"c0";
                            state <= drop_lcd_e;
                            next_command <= print_string;      
                     
                     
                       -- Return write address to first character position on line 1
                       --=========================================================--
                       when return_home =>
                            lcd_e <= '1';
                            lcd_rs <= '0';
                            lcd_rw_int <= '0';
                            data_bus_value <= x"80";
                            state <= drop_lcd_e;
                            next_command <= print_string; 
                    
                    
                       -- lcd_e will match clk_CUSTOM_hz_enable line when instructed to go LOW, however, if the clk_CUSTOM_hz_enable source clock must be a lower count value or it will reset LOW anyhow.
                       -- The next states occur at the end of each command or data transfer to the LCD
                       -- Drop LCD E line - falling edge loads inst/data to LCD controller
                       --============================================================================--
                       when drop_lcd_e =>
                            lcd_e <= '0';
                            lcd_blon <= '1';
                            lcd_on   <= '1';
                            state <= hold;
                   
                       -- Hold LCD inst/data valid after falling edge of E line
                       --====================================================--
                       when hold =>
                            state <= next_command;
                            lcd_blon <= '1';
                            lcd_on   <= '1';
                       end case;




             end if;-- CLOSING STATEMENT FOR "IF clk_400hz_enable = '1' THEN"
             
      end if;-- CLOSING STATEMENT FOR "IF reset = '0' THEN" 
      
end process;                                                            
  
END ARCHITECTURE LCD_DISPLAY_arch;

