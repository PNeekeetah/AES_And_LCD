library IEEE;
library WORK;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use WORK.AES_TYPES.all;

entity ShiftRows is

	port ( state_in :  in MATRIX ;
		   state_out : out MATRIX);

end ShiftRows;

-- Since it's not a bidimensional matrix, this is how the mapping is done
-- (matrix representation for illustration purpose) -> formula is f(i) = 5*i mod 16
-- 0  4  8 12  ->  0  4  8 12
-- 1  5  9 13  ->  5  9 13  1
-- 2  6 10 14  -> 10 14  2  6
-- 3  7 11 15  -> 15  3  7 11

architecture dataflow of ShiftRows is
	signal transfer : MATRIX;
begin
	
	shift_g : for i in 0 to 15 generate
			transfer(i) <= state_in(5*i mod 16);
	end generate shift_g;
	state_out <= transfer;
	
end dataflow;
