library IEEE;
library WORK;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use WORK.AES_TYPES.all;

entity SubBytes is

	port (state_in  :  in MATRIX ;
		   state_out : out MATRIX);

end SubBytes;

-- Substitute each byte of the state matrix with its corresponding bytes from the SBOX

architecture dataflow of SubBytes is
begin
	
	g_substitute : for i in 0 to 15 generate
		state_out(i) <= sub(state_in(i));
	end generate g_substitute;
	
end dataflow; 


