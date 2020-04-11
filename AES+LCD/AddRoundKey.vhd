library IEEE;
library WORK;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use WORK.AES_TYPES.all;

entity AddRoundKey is
	
	port (state_in :  in MATRIX ;	-- state_in is the AES state matrix
			  key_in :  in MATRIX ;	-- key_in is the round key
		  state_out : out MATRIX);	-- result of XORing the state_in with the key

end AddRoundKey;

-- 16 concurrent assignments to XOR the key bytes and state bytes 

architecture dataflow of AddRoundKey is
begin

	g_addkey : for i in 0 to 15 generate
		state_out(i) <= xorBytes(state_in(i),key_in(i)); 
	end generate g_addkey;
		
end dataflow; 


