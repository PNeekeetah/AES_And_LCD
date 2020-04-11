library IEEE;
library WORK;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use WORK.AES_TYPES.all;

entity MixColumns is

	port ( state_in :  in MATRIX ;
		   state_out : out MATRIX);

end MixColumns;

-- Each column of the state matrix is multiplied with the matrix defined by the signal "multiplication"

architecture dataflow of MixColumns is

	type MULTMATRIX is array (0 to 3, 0 to 3) of U_BYTE; 
	signal multiplication : MULTMATRIX := ((2,3,1,1),
														(1,2,3,1),
														(1,1,2,3),
														(3,1,1,2));

begin

	mixrows_g : for i in 0 to 3 generate
		mixcols_g : for j in 0 to 3 generate
			state_out(4*i + j) <= xor4Bytes(xtime(state_in(4*i),multiplication(j,0)),xtime(state_in(4*i + 1),multiplication(j,1)),xtime(state_in(4*i + 2),multiplication(j,2)),xtime(state_in(4*i + 3),multiplication(j,3)));
		end generate mixcols_g;
	end generate mixrows_g;	

 
end dataflow;