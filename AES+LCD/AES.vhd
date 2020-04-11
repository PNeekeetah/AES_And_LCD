library IEEE;
library WORK;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use WORK.AES_TYPES.all;

entity AES is

	port ( plain_in   :  in MATRIX := (16#00#,16#11#,16#22#,16#33#,16#44#,16#55#,16#66#,16#77#,16#88#,16#99#,16#AA#,16#BB#,16#CC#,16#DD#,16#EE#,16#FF#);
		      key_in   :  in MATRIX := (16#00#,16#11#,16#22#,16#33#,16#44#,16#55#,16#66#,16#77#,16#88#,16#99#,16#AA#,16#BB#,16#CC#,16#DD#,16#EE#,16#FF#);
				clk_in   :  in std_logic;
		    cipher_out : out MATRIX );

end AES;

architecture behaviour of AES is
	
	-- Define 
	type STATE is (IDL,STA,MID,FIN);
	type ACTION is (SUB,SFT,MIX,ADD,NXT,NIL);
	
	signal current_action, next_action : ACTION := NIL;
	signal current_state : STATE := IDL;
	signal next_state : STATE := IDL;
	signal rounds : U_BYTE := 0;
	signal sub_in, sub_out, shift_in, shift_out, mix_in, mix_out, addstate_in, addkey_in, addstate_out, state_mat, key_mat	: MATRIX;
	signal stop : std_logic := '0';
	
	component SubBytes         
		port ( state_in :  in MATRIX;
			   state_out : out MATRIX);
	end component;

	component ShiftRows is
		port ( state_in :  in MATRIX;
			   state_out : out MATRIX);	
	end component;
	
	component MixColumns is
		port ( state_in :  in MATRIX;
			   state_out : out MATRIX);
	end component;
	
	component AddRoundKey is
		port ( state_in :  in MATRIX;
				   key_in :  in MATRIX;
			   state_out : out MATRIX);
	end component;
	
	begin
	
	sub_g : SubBytes    port map 								(sub_in,sub_out);
	sft_g : ShiftRows   port map 						 (shift_in, shift_out);
	mix_g : MixColumns  port map 							  (mix_in, mix_out);
	add_g : AddRoundKey port map (addstate_in, addkey_in, addstate_out);
	
 	changestate : process (clk_in) is
	begin
		if (rising_edge(clk_in)) then
		case current_state is
		when IDL =>
			next_state <= STA;
			next_action <= ADD;
			if (stop = '1') then
				next_state <= IDL;
				next_action <= NIL;
			end if;
	
		when STA =>
		case current_action is 
			when ADD => 
				addstate_in <= state_mat;
				addkey_in <= key_mat;
				next_state <= STA;
				next_action <= NXT;
				
			when NXT => 
				next_state <= MID;
				next_action <= SUB;
				rounds <= 0;
				
			when others =>
				NULL;
		end case;
		
		when MID =>
		case current_action is 
			when SUB =>
				sub_in <= state_mat;
				next_state <= MID;
				next_action <= SFT;
				
			when SFT => 
				shift_in <= state_mat;
				next_state <= MID;
				next_action <= MIX;
				
			when MIX => 
				mix_in <= state_mat;
				next_state <= MID;
				next_action <= ADD;
			
			when ADD => 
				addstate_in <= state_mat;
				addkey_in <= key_mat;
				next_state <= MID;
				next_action <= NXT;
				
			when NXT =>  
				rounds <= rounds + 1;
				if (rounds < 8) then
					next_state <= MID;
					next_action <= SUB;
				else
					next_state <= FIN;
					next_action <= SUB;
				end if;
				
			when NIL => NULL;
		end case;
		
		when FIN =>
		case current_action is 
			when SUB =>
				sub_in <= state_mat;
				next_state <= FIN;
				next_action <= SFT;
			
			when SFT => 
				shift_in <= state_mat;
				next_state <= FIN;
				next_action <= ADD;
			
			when ADD => 
				addkey_in <= key_mat;
				addstate_in <= state_mat;
				next_state <= IDL;
				next_action <= NIL;
				stop <= '1';
			
			when others => NULL;
		end case;
	end case;
	end if;
	end process changestate;
	
	readmatrices : process (clk_in,sub_out,shift_out,addstate_out,mix_out,next_action) is 
		variable oldkey_v, newkey_v : MATRIX;
		variable rounds_v : U_BYTE;
	begin
	if falling_edge(clk_in) then
	case current_state is
		when IDL =>
			key_mat <= key_in;
			state_mat <= plain_in;
		
		when STA =>
		case current_action is 
			when ADD => 
				state_mat <= addstate_out;
					
			when NXT => 
				oldkey_v := key_mat;
				rounds_v := rounds;
				RoundKey(oldkey_v,rounds_v, newkey_v);
				key_mat <= newkey_v;

			when others => NULL;
		end case;
		
		when MID =>
		case current_action is 
			when ADD => 
				state_mat <= addstate_out;
				
			when SUB => 
				state_mat <= sub_out;
				
			when MIX => 
				state_mat <= mix_out;
				
			when SFT => 
				state_mat <= shift_out;
				
			when NXT => 
				oldkey_v := key_mat;
				rounds_v := rounds;
				RoundKey(oldkey_v,rounds_v, newkey_v);
				key_mat <= newkey_v;
				
			when NIL => NULL;
		end case;
		
		when FIN =>
		case current_action is 
			when SUB => 
				state_mat <= sub_out;
				
			when SFT => 
				state_mat <= shift_out;
				
			when ADD => 
				cipher_out <= addstate_out;
				
			when others => NULL;
		end case;
	end case;
	end if;
	end process readmatrices;
	
	next_select : process (next_state,next_action,clk_in) is
	begin
	if(falling_edge(clk_in))then
		current_action <= next_action;
		current_state <= next_state;
	end if;
	end process next_select;
		
end behaviour;