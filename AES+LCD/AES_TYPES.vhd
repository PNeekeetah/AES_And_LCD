library IEEE;
use IEEE.NUMERIC_STD.all;

package AES_TYPES is
	
	-- Subtypes definition 
	subtype U_BYTE is integer range 0 to 255;	
	
	-- Types definition
	type BOX is array (0 to 15, 0 to 15) of U_BYTE;
	type SCHEDULE is array (0 to 9) of U_BYTE;
	type COLUMN is array (0 to 3) of U_BYTE;
	type MATRIX is array(0 to 15) of U_BYTE;  
	type LUT is array (0 to 255) of U_BYTE;
	
	-- Constants definitions
	constant SBOX_C : BOX := ((16#63#, 16#7c#, 16#77#, 16#7b#, 16#f2#, 16#6b#, 16#6f#, 16#c5#, 16#30#, 16#01#, 16#67#, 16#2b#, 16#fe#, 16#d7#, 16#ab#, 16#76#),
								     (16#ca#, 16#82#, 16#c9#, 16#7d#, 16#fa#, 16#59#, 16#47#, 16#f0#, 16#ad#, 16#d4#, 16#a2#, 16#af#, 16#9c#, 16#a4#, 16#72#, 16#c0#),
								     (16#b7#, 16#fd#, 16#93#, 16#26#, 16#36#, 16#3f#, 16#f7#, 16#cc#, 16#34#, 16#a5#, 16#e5#, 16#f1#, 16#71#, 16#d8#, 16#31#, 16#15#),
								     (16#04#, 16#c7#, 16#23#, 16#c3#, 16#18#, 16#96#, 16#05#, 16#9a#, 16#07#, 16#12#, 16#80#, 16#e2#, 16#eb#, 16#27#, 16#b2#, 16#75#),
								     (16#09#, 16#83#, 16#2c#, 16#1a#, 16#1b#, 16#6e#, 16#5a#, 16#a0#, 16#52#, 16#3b#, 16#d6#, 16#b3#, 16#29#, 16#e3#, 16#2f#, 16#84#),
								     (16#53#, 16#d1#, 16#00#, 16#ed#, 16#20#, 16#fc#, 16#b1#, 16#5b#, 16#6a#, 16#cb#, 16#be#, 16#39#, 16#4a#, 16#4c#, 16#58#, 16#cf#),
								     (16#d0#, 16#ef#, 16#aa#, 16#fb#, 16#43#, 16#4d#, 16#33#, 16#85#, 16#45#, 16#f9#, 16#02#, 16#7f#, 16#50#, 16#3c#, 16#9f#, 16#a8#),
								     (16#51#, 16#a3#, 16#40#, 16#8f#, 16#92#, 16#9d#, 16#38#, 16#f5#, 16#bc#, 16#b6#, 16#da#, 16#21#, 16#10#, 16#ff#, 16#f3#, 16#d2#),
								     (16#cd#, 16#0c#, 16#13#, 16#ec#, 16#5f#, 16#97#, 16#44#, 16#17#, 16#c4#, 16#a7#, 16#7e#, 16#3d#, 16#64#, 16#5d#, 16#19#, 16#73#),
								     (16#60#, 16#81#, 16#4f#, 16#dc#, 16#22#, 16#2a#, 16#90#, 16#88#, 16#46#, 16#ee#, 16#b8#, 16#14#, 16#de#, 16#5e#, 16#0b#, 16#db#),
								     (16#e0#, 16#32#, 16#3a#, 16#0a#, 16#49#, 16#06#, 16#24#, 16#5c#, 16#c2#, 16#d3#, 16#ac#, 16#62#, 16#91#, 16#95#, 16#e4#, 16#79#),
								     (16#e7#, 16#c8#, 16#37#, 16#6d#, 16#8d#, 16#d5#, 16#4e#, 16#a9#, 16#6c#, 16#56#, 16#f4#, 16#ea#, 16#65#, 16#7a#, 16#ae#, 16#08#),
								     (16#ba#, 16#78#, 16#25#, 16#2e#, 16#1c#, 16#a6#, 16#b4#, 16#c6#, 16#e8#, 16#dd#, 16#74#, 16#1f#, 16#4b#, 16#bd#, 16#8b#, 16#8a#),
								     (16#70#, 16#3e#, 16#b5#, 16#66#, 16#48#, 16#03#, 16#f6#, 16#0e#, 16#61#, 16#35#, 16#57#, 16#b9#, 16#86#, 16#c1#, 16#1d#, 16#9e#),
								     (16#e1#, 16#f8#, 16#98#, 16#11#, 16#69#, 16#d9#, 16#8e#, 16#94#, 16#9b#, 16#1e#, 16#87#, 16#e9#, 16#ce#, 16#55#, 16#28#, 16#df#),
								     (16#8c#, 16#a1#, 16#89#, 16#0d#, 16#bf#, 16#e6#, 16#42#, 16#68#, 16#41#, 16#99#, 16#2d#, 16#0f#, 16#b0#, 16#54#, 16#bb#, 16#16#));
	
	constant IBOX_C : BOX := ((16#52#, 16#09#, 16#6a#, 16#d5#, 16#30#, 16#36#, 16#a5#, 16#38#, 16#bf#, 16#40#, 16#a3#, 16#9e#, 16#81#, 16#f3#, 16#d7#, 16#fb#),
								     (16#7c#, 16#e3#, 16#39#, 16#82#, 16#9b#, 16#2f#, 16#ff#, 16#87#, 16#34#, 16#8e#, 16#43#, 16#44#, 16#c4#, 16#de#, 16#e9#, 16#cb#),
								     (16#54#, 16#7b#, 16#94#, 16#32#, 16#a6#, 16#c2#, 16#23#, 16#3d#, 16#ee#, 16#4c#, 16#95#, 16#0b#, 16#42#, 16#fa#, 16#c3#, 16#4e#),
								     (16#08#, 16#2e#, 16#a1#, 16#66#, 16#28#, 16#d9#, 16#24#, 16#b2#, 16#76#, 16#5b#, 16#a2#, 16#49#, 16#6d#, 16#8b#, 16#d1#, 16#25#),
								     (16#72#, 16#f8#, 16#f6#, 16#64#, 16#86#, 16#68#, 16#98#, 16#16#, 16#d4#, 16#a4#, 16#5c#, 16#cc#, 16#5d#, 16#65#, 16#b6#, 16#92#),
								     (16#6c#, 16#70#, 16#48#, 16#50#, 16#fd#, 16#ed#, 16#b9#, 16#da#, 16#5e#, 16#15#, 16#46#, 16#57#, 16#a7#, 16#8d#, 16#9d#, 16#84#),
								     (16#90#, 16#d8#, 16#ab#, 16#00#, 16#8c#, 16#bc#, 16#d3#, 16#0a#, 16#f7#, 16#e4#, 16#58#, 16#05#, 16#b8#, 16#b3#, 16#45#, 16#06#),
								     (16#d0#, 16#2c#, 16#1e#, 16#8f#, 16#ca#, 16#3f#, 16#0f#, 16#02#, 16#c1#, 16#af#, 16#bd#, 16#03#, 16#01#, 16#13#, 16#8a#, 16#6b#),
								     (16#3a#, 16#91#, 16#11#, 16#41#, 16#4f#, 16#67#, 16#dc#, 16#ea#, 16#97#, 16#f2#, 16#cf#, 16#ce#, 16#f0#, 16#b4#, 16#e6#, 16#73#),
								     (16#96#, 16#ac#, 16#74#, 16#22#, 16#e7#, 16#ad#, 16#35#, 16#85#, 16#e2#, 16#f9#, 16#37#, 16#e8#, 16#1c#, 16#75#, 16#df#, 16#6e#),
								     (16#47#, 16#f1#, 16#1a#, 16#71#, 16#1d#, 16#29#, 16#c5#, 16#89#, 16#6f#, 16#b7#, 16#62#, 16#0e#, 16#aa#, 16#18#, 16#be#, 16#1b#),
								     (16#fc#, 16#56#, 16#3e#, 16#4b#, 16#c6#, 16#d2#, 16#79#, 16#20#, 16#9a#, 16#db#, 16#c0#, 16#fe#, 16#78#, 16#cd#, 16#5a#, 16#f4#),
								     (16#1f#, 16#dd#, 16#a8#, 16#33#, 16#88#, 16#07#, 16#c7#, 16#31#, 16#b1#, 16#12#, 16#10#, 16#59#, 16#27#, 16#80#, 16#ec#, 16#5f#),
								     (16#60#, 16#51#, 16#7f#, 16#a9#, 16#19#, 16#b5#, 16#4a#, 16#0d#, 16#2d#, 16#e5#, 16#7a#, 16#9f#, 16#93#, 16#c9#, 16#9c#, 16#ef#),
								     (16#a0#, 16#e0#, 16#3b#, 16#4d#, 16#ae#, 16#2a#, 16#f5#, 16#b0#, 16#c8#, 16#eb#, 16#bb#, 16#3c#, 16#83#, 16#53#, 16#99#, 16#61#),
								     (16#17#, 16#2b#, 16#04#, 16#7e#, 16#ba#, 16#77#, 16#d6#, 16#26#, 16#e1#, 16#69#, 16#14#, 16#63#, 16#55#, 16#21#, 16#0c#, 16#7d#));
								  
	constant RCON_C : SCHEDULE := (16#01#, 16#02#, 16#04#, 16#08#, 16#10#, 16#20#, 16#40#, 16#80#, 16#1B#, 16#36#);

	constant XTIME2_C  : LUT := (16#0#, 16#2#, 16#4#, 16#6#, 16#8#, 16#a#, 16#c#, 16#e#, 16#10#, 16#12#, 16#14#, 16#16#, 16#18#, 16#1a#, 16#1c#, 16#1e#, 16#20#, 16#22#, 16#24#, 16#26#, 16#28#, 16#2a#, 16#2c#, 16#2e#, 16#30#, 16#32#, 16#34#, 16#36#, 16#38#, 16#3a#, 16#3c#, 16#3e#, 16#40#, 16#42#, 16#44#, 16#46#, 16#48#, 16#4a#, 16#4c#, 16#4e#, 16#50#, 16#52#, 16#54#, 16#56#, 16#58#, 16#5a#, 16#5c#, 16#5e#, 16#60#, 16#62#, 16#64#, 16#66#, 16#68#, 16#6a#, 16#6c#, 16#6e#, 16#70#, 16#72#, 16#74#, 16#76#, 16#78#, 16#7a#, 16#7c#, 16#7e#, 16#80#, 16#82#, 16#84#, 16#86#, 16#88#, 16#8a#, 16#8c#, 16#8e#, 16#90#, 16#92#, 16#94#, 16#96#, 16#98#, 16#9a#, 16#9c#, 16#9e#, 16#a0#, 16#a2#, 16#a4#, 16#a6#, 16#a8#, 16#aa#, 16#ac#, 16#ae#, 16#b0#, 16#b2#, 16#b4#, 16#b6#, 16#b8#, 16#ba#, 16#bc#, 16#be#, 16#c0#, 16#c2#, 16#c4#, 16#c6#, 16#c8#, 16#ca#, 16#cc#, 16#ce#, 16#d0#, 16#d2#, 16#d4#, 16#d6#, 16#d8#, 16#da#, 16#dc#, 16#de#, 16#e0#, 16#e2#, 16#e4#, 16#e6#, 16#e8#, 16#ea#, 16#ec#, 16#ee#, 16#f0#, 16#f2#, 16#f4#, 16#f6#, 16#f8#, 16#fa#, 16#fc#, 16#fe#, 16#1b#, 16#19#, 16#1f#, 16#1d#, 16#13#, 16#11#, 16#17#, 16#15#, 16#b#, 16#9#, 16#f#, 16#d#, 16#3#, 16#1#, 16#7#, 16#5#, 16#3b#, 16#39#, 16#3f#, 16#3d#, 16#33#, 16#31#, 16#37#, 16#35#, 16#2b#, 16#29#, 16#2f#, 16#2d#, 16#23#, 16#21#, 16#27#, 16#25#, 16#5b#, 16#59#, 16#5f#, 16#5d#, 16#53#, 16#51#, 16#57#, 16#55#, 16#4b#, 16#49#, 16#4f#, 16#4d#, 16#43#, 16#41#, 16#47#, 16#45#, 16#7b#, 16#79#, 16#7f#, 16#7d#, 16#73#, 16#71#, 16#77#, 16#75#, 16#6b#, 16#69#, 16#6f#, 16#6d#, 16#63#, 16#61#, 16#67#, 16#65#, 16#9b#, 16#99#, 16#9f#, 16#9d#, 16#93#, 16#91#, 16#97#, 16#95#, 16#8b#, 16#89#, 16#8f#, 16#8d#, 16#83#, 16#81#, 16#87#, 16#85#, 16#bb#, 16#b9#, 16#bf#, 16#bd#, 16#b3#, 16#b1#, 16#b7#, 16#b5#, 16#ab#, 16#a9#, 16#af#, 16#ad#, 16#a3#, 16#a1#, 16#a7#, 16#a5#, 16#db#, 16#d9#, 16#df#, 16#dd#, 16#d3#, 16#d1#, 16#d7#, 16#d5#, 16#cb#, 16#c9#, 16#cf#, 16#cd#, 16#c3#, 16#c1#, 16#c7#, 16#c5#, 16#fb#, 16#f9#, 16#ff#, 16#fd#, 16#f3#, 16#f1#, 16#f7#, 16#f5#, 16#eb#, 16#e9#, 16#ef#, 16#ed#, 16#e3#, 16#e1#, 16#e7#, 16#e5#);
	constant XTIME3_C  : LUT := (16#0#, 16#3#, 16#6#, 16#5#, 16#c#, 16#f#, 16#a#, 16#9#, 16#18#, 16#1b#, 16#1e#, 16#1d#, 16#14#, 16#17#, 16#12#, 16#11#, 16#30#, 16#33#, 16#36#, 16#35#, 16#3c#, 16#3f#, 16#3a#, 16#39#, 16#28#, 16#2b#, 16#2e#, 16#2d#, 16#24#, 16#27#, 16#22#, 16#21#, 16#60#, 16#63#, 16#66#, 16#65#, 16#6c#, 16#6f#, 16#6a#, 16#69#, 16#78#, 16#7b#, 16#7e#, 16#7d#, 16#74#, 16#77#, 16#72#, 16#71#, 16#50#, 16#53#, 16#56#, 16#55#, 16#5c#, 16#5f#, 16#5a#, 16#59#, 16#48#, 16#4b#, 16#4e#, 16#4d#, 16#44#, 16#47#, 16#42#, 16#41#, 16#c0#, 16#c3#, 16#c6#, 16#c5#, 16#cc#, 16#cf#, 16#ca#, 16#c9#, 16#d8#, 16#db#, 16#de#, 16#dd#, 16#d4#, 16#d7#, 16#d2#, 16#d1#, 16#f0#, 16#f3#, 16#f6#, 16#f5#, 16#fc#, 16#ff#, 16#fa#, 16#f9#, 16#e8#, 16#eb#, 16#ee#, 16#ed#, 16#e4#, 16#e7#, 16#e2#, 16#e1#, 16#a0#, 16#a3#, 16#a6#, 16#a5#, 16#ac#, 16#af#, 16#aa#, 16#a9#, 16#b8#, 16#bb#, 16#be#, 16#bd#, 16#b4#, 16#b7#, 16#b2#, 16#b1#, 16#90#, 16#93#, 16#96#, 16#95#, 16#9c#, 16#9f#, 16#9a#, 16#99#, 16#88#, 16#8b#, 16#8e#, 16#8d#, 16#84#, 16#87#, 16#82#, 16#81#, 16#9b#, 16#98#, 16#9d#, 16#9e#, 16#97#, 16#94#, 16#91#, 16#92#, 16#83#, 16#80#, 16#85#, 16#86#, 16#8f#, 16#8c#, 16#89#, 16#8a#, 16#ab#, 16#a8#, 16#ad#, 16#ae#, 16#a7#, 16#a4#, 16#a1#, 16#a2#, 16#b3#, 16#b0#, 16#b5#, 16#b6#, 16#bf#, 16#bc#, 16#b9#, 16#ba#, 16#fb#, 16#f8#, 16#fd#, 16#fe#, 16#f7#, 16#f4#, 16#f1#, 16#f2#, 16#e3#, 16#e0#, 16#e5#, 16#e6#, 16#ef#, 16#ec#, 16#e9#, 16#ea#, 16#cb#, 16#c8#, 16#cd#, 16#ce#, 16#c7#, 16#c4#, 16#c1#, 16#c2#, 16#d3#, 16#d0#, 16#d5#, 16#d6#, 16#df#, 16#dc#, 16#d9#, 16#da#, 16#5b#, 16#58#, 16#5d#, 16#5e#, 16#57#, 16#54#, 16#51#, 16#52#, 16#43#, 16#40#, 16#45#, 16#46#, 16#4f#, 16#4c#, 16#49#, 16#4a#, 16#6b#, 16#68#, 16#6d#, 16#6e#, 16#67#, 16#64#, 16#61#, 16#62#, 16#73#, 16#70#, 16#75#, 16#76#, 16#7f#, 16#7c#, 16#79#, 16#7a#, 16#3b#, 16#38#, 16#3d#, 16#3e#, 16#37#, 16#34#, 16#31#, 16#32#, 16#23#, 16#20#, 16#25#, 16#26#, 16#2f#, 16#2c#, 16#29#, 16#2a#, 16#b#, 16#8#, 16#d#, 16#e#, 16#7#, 16#4#, 16#1#, 16#2#, 16#13#, 16#10#, 16#15#, 16#16#, 16#1f#, 16#1c#, 16#19#, 16#1a#);
	constant XTIME9_C  : LUT := (16#0#, 16#9#, 16#12#, 16#1b#, 16#24#, 16#2d#, 16#36#, 16#3f#, 16#48#, 16#41#, 16#5a#, 16#53#, 16#6c#, 16#65#, 16#7e#, 16#77#, 16#90#, 16#99#, 16#82#, 16#8b#, 16#b4#, 16#bd#, 16#a6#, 16#af#, 16#d8#, 16#d1#, 16#ca#, 16#c3#, 16#fc#, 16#f5#, 16#ee#, 16#e7#, 16#3b#, 16#32#, 16#29#, 16#20#, 16#1f#, 16#16#, 16#d#, 16#4#, 16#73#, 16#7a#, 16#61#, 16#68#, 16#57#, 16#5e#, 16#45#, 16#4c#, 16#ab#, 16#a2#, 16#b9#, 16#b0#, 16#8f#, 16#86#, 16#9d#, 16#94#, 16#e3#, 16#ea#, 16#f1#, 16#f8#, 16#c7#, 16#ce#, 16#d5#, 16#dc#, 16#76#, 16#7f#, 16#64#, 16#6d#, 16#52#, 16#5b#, 16#40#, 16#49#, 16#3e#, 16#37#, 16#2c#, 16#25#, 16#1a#, 16#13#, 16#8#, 16#1#, 16#e6#, 16#ef#, 16#f4#, 16#fd#, 16#c2#, 16#cb#, 16#d0#, 16#d9#, 16#ae#, 16#a7#, 16#bc#, 16#b5#, 16#8a#, 16#83#, 16#98#, 16#91#, 16#4d#, 16#44#, 16#5f#, 16#56#, 16#69#, 16#60#, 16#7b#, 16#72#, 16#5#, 16#c#, 16#17#, 16#1e#, 16#21#, 16#28#, 16#33#, 16#3a#, 16#dd#, 16#d4#, 16#cf#, 16#c6#, 16#f9#, 16#f0#, 16#eb#, 16#e2#, 16#95#, 16#9c#, 16#87#, 16#8e#, 16#b1#, 16#b8#, 16#a3#, 16#aa#, 16#ec#, 16#e5#, 16#fe#, 16#f7#, 16#c8#, 16#c1#, 16#da#, 16#d3#, 16#a4#, 16#ad#, 16#b6#, 16#bf#, 16#80#, 16#89#, 16#92#, 16#9b#, 16#7c#, 16#75#, 16#6e#, 16#67#, 16#58#, 16#51#, 16#4a#, 16#43#, 16#34#, 16#3d#, 16#26#, 16#2f#, 16#10#, 16#19#, 16#2#, 16#b#, 16#d7#, 16#de#, 16#c5#, 16#cc#, 16#f3#, 16#fa#, 16#e1#, 16#e8#, 16#9f#, 16#96#, 16#8d#, 16#84#, 16#bb#, 16#b2#, 16#a9#, 16#a0#, 16#47#, 16#4e#, 16#55#, 16#5c#, 16#63#, 16#6a#, 16#71#, 16#78#, 16#f#, 16#6#, 16#1d#, 16#14#, 16#2b#, 16#22#, 16#39#, 16#30#, 16#9a#, 16#93#, 16#88#, 16#81#, 16#be#, 16#b7#, 16#ac#, 16#a5#, 16#d2#, 16#db#, 16#c0#, 16#c9#, 16#f6#, 16#ff#, 16#e4#, 16#ed#, 16#a#, 16#3#, 16#18#, 16#11#, 16#2e#, 16#27#, 16#3c#, 16#35#, 16#42#, 16#4b#, 16#50#, 16#59#, 16#66#, 16#6f#, 16#74#, 16#7d#, 16#a1#, 16#a8#, 16#b3#, 16#ba#, 16#85#, 16#8c#, 16#97#, 16#9e#, 16#e9#, 16#e0#, 16#fb#, 16#f2#, 16#cd#, 16#c4#, 16#df#, 16#d6#, 16#31#, 16#38#, 16#23#, 16#2a#, 16#15#, 16#1c#, 16#7#, 16#e#, 16#79#, 16#70#, 16#6b#, 16#62#, 16#5d#, 16#54#, 16#4f#, 16#46#);
	constant XTIME11_C : LUT := (16#0#, 16#b#, 16#16#, 16#1d#, 16#2c#, 16#27#, 16#3a#, 16#31#, 16#58#, 16#53#, 16#4e#, 16#45#, 16#74#, 16#7f#, 16#62#, 16#69#, 16#b0#, 16#bb#, 16#a6#, 16#ad#, 16#9c#, 16#97#, 16#8a#, 16#81#, 16#e8#, 16#e3#, 16#fe#, 16#f5#, 16#c4#, 16#cf#, 16#d2#, 16#d9#, 16#7b#, 16#70#, 16#6d#, 16#66#, 16#57#, 16#5c#, 16#41#, 16#4a#, 16#23#, 16#28#, 16#35#, 16#3e#, 16#f#, 16#4#, 16#19#, 16#12#, 16#cb#, 16#c0#, 16#dd#, 16#d6#, 16#e7#, 16#ec#, 16#f1#, 16#fa#, 16#93#, 16#98#, 16#85#, 16#8e#, 16#bf#, 16#b4#, 16#a9#, 16#a2#, 16#f6#, 16#fd#, 16#e0#, 16#eb#, 16#da#, 16#d1#, 16#cc#, 16#c7#, 16#ae#, 16#a5#, 16#b8#, 16#b3#, 16#82#, 16#89#, 16#94#, 16#9f#, 16#46#, 16#4d#, 16#50#, 16#5b#, 16#6a#, 16#61#, 16#7c#, 16#77#, 16#1e#, 16#15#, 16#8#, 16#3#, 16#32#, 16#39#, 16#24#, 16#2f#, 16#8d#, 16#86#, 16#9b#, 16#90#, 16#a1#, 16#aa#, 16#b7#, 16#bc#, 16#d5#, 16#de#, 16#c3#, 16#c8#, 16#f9#, 16#f2#, 16#ef#, 16#e4#, 16#3d#, 16#36#, 16#2b#, 16#20#, 16#11#, 16#1a#, 16#7#, 16#c#, 16#65#, 16#6e#, 16#73#, 16#78#, 16#49#, 16#42#, 16#5f#, 16#54#, 16#f7#, 16#fc#, 16#e1#, 16#ea#, 16#db#, 16#d0#, 16#cd#, 16#c6#, 16#af#, 16#a4#, 16#b9#, 16#b2#, 16#83#, 16#88#, 16#95#, 16#9e#, 16#47#, 16#4c#, 16#51#, 16#5a#, 16#6b#, 16#60#, 16#7d#, 16#76#, 16#1f#, 16#14#, 16#9#, 16#2#, 16#33#, 16#38#, 16#25#, 16#2e#, 16#8c#, 16#87#, 16#9a#, 16#91#, 16#a0#, 16#ab#, 16#b6#, 16#bd#, 16#d4#, 16#df#, 16#c2#, 16#c9#, 16#f8#, 16#f3#, 16#ee#, 16#e5#, 16#3c#, 16#37#, 16#2a#, 16#21#, 16#10#, 16#1b#, 16#6#, 16#d#, 16#64#, 16#6f#, 16#72#, 16#79#, 16#48#, 16#43#, 16#5e#, 16#55#, 16#1#, 16#a#, 16#17#, 16#1c#, 16#2d#, 16#26#, 16#3b#, 16#30#, 16#59#, 16#52#, 16#4f#, 16#44#, 16#75#, 16#7e#, 16#63#, 16#68#, 16#b1#, 16#ba#, 16#a7#, 16#ac#, 16#9d#, 16#96#, 16#8b#, 16#80#, 16#e9#, 16#e2#, 16#ff#, 16#f4#, 16#c5#, 16#ce#, 16#d3#, 16#d8#, 16#7a#, 16#71#, 16#6c#, 16#67#, 16#56#, 16#5d#, 16#40#, 16#4b#, 16#22#, 16#29#, 16#34#, 16#3f#, 16#e#, 16#5#, 16#18#, 16#13#, 16#ca#, 16#c1#, 16#dc#, 16#d7#, 16#e6#, 16#ed#, 16#f0#, 16#fb#, 16#92#, 16#99#, 16#84#, 16#8f#, 16#be#, 16#b5#, 16#a8#, 16#a3#);
	constant XTIME13_C : LUT := (16#0#, 16#d#, 16#1a#, 16#17#, 16#34#, 16#39#, 16#2e#, 16#23#, 16#68#, 16#65#, 16#72#, 16#7f#, 16#5c#, 16#51#, 16#46#, 16#4b#, 16#d0#, 16#dd#, 16#ca#, 16#c7#, 16#e4#, 16#e9#, 16#fe#, 16#f3#, 16#b8#, 16#b5#, 16#a2#, 16#af#, 16#8c#, 16#81#, 16#96#, 16#9b#, 16#bb#, 16#b6#, 16#a1#, 16#ac#, 16#8f#, 16#82#, 16#95#, 16#98#, 16#d3#, 16#de#, 16#c9#, 16#c4#, 16#e7#, 16#ea#, 16#fd#, 16#f0#, 16#6b#, 16#66#, 16#71#, 16#7c#, 16#5f#, 16#52#, 16#45#, 16#48#, 16#3#, 16#e#, 16#19#, 16#14#, 16#37#, 16#3a#, 16#2d#, 16#20#, 16#6d#, 16#60#, 16#77#, 16#7a#, 16#59#, 16#54#, 16#43#, 16#4e#, 16#5#, 16#8#, 16#1f#, 16#12#, 16#31#, 16#3c#, 16#2b#, 16#26#, 16#bd#, 16#b0#, 16#a7#, 16#aa#, 16#89#, 16#84#, 16#93#, 16#9e#, 16#d5#, 16#d8#, 16#cf#, 16#c2#, 16#e1#, 16#ec#, 16#fb#, 16#f6#, 16#d6#, 16#db#, 16#cc#, 16#c1#, 16#e2#, 16#ef#, 16#f8#, 16#f5#, 16#be#, 16#b3#, 16#a4#, 16#a9#, 16#8a#, 16#87#, 16#90#, 16#9d#, 16#6#, 16#b#, 16#1c#, 16#11#, 16#32#, 16#3f#, 16#28#, 16#25#, 16#6e#, 16#63#, 16#74#, 16#79#, 16#5a#, 16#57#, 16#40#, 16#4d#, 16#da#, 16#d7#, 16#c0#, 16#cd#, 16#ee#, 16#e3#, 16#f4#, 16#f9#, 16#b2#, 16#bf#, 16#a8#, 16#a5#, 16#86#, 16#8b#, 16#9c#, 16#91#, 16#a#, 16#7#, 16#10#, 16#1d#, 16#3e#, 16#33#, 16#24#, 16#29#, 16#62#, 16#6f#, 16#78#, 16#75#, 16#56#, 16#5b#, 16#4c#, 16#41#, 16#61#, 16#6c#, 16#7b#, 16#76#, 16#55#, 16#58#, 16#4f#, 16#42#, 16#9#, 16#4#, 16#13#, 16#1e#, 16#3d#, 16#30#, 16#27#, 16#2a#, 16#b1#, 16#bc#, 16#ab#, 16#a6#, 16#85#, 16#88#, 16#9f#, 16#92#, 16#d9#, 16#d4#, 16#c3#, 16#ce#, 16#ed#, 16#e0#, 16#f7#, 16#fa#, 16#b7#, 16#ba#, 16#ad#, 16#a0#, 16#83#, 16#8e#, 16#99#, 16#94#, 16#df#, 16#d2#, 16#c5#, 16#c8#, 16#eb#, 16#e6#, 16#f1#, 16#fc#, 16#67#, 16#6a#, 16#7d#, 16#70#, 16#53#, 16#5e#, 16#49#, 16#44#, 16#f#, 16#2#, 16#15#, 16#18#, 16#3b#, 16#36#, 16#21#, 16#2c#, 16#c#, 16#1#, 16#16#, 16#1b#, 16#38#, 16#35#, 16#22#, 16#2f#, 16#64#, 16#69#, 16#7e#, 16#73#, 16#50#, 16#5d#, 16#4a#, 16#47#, 16#dc#, 16#d1#, 16#c6#, 16#cb#, 16#e8#, 16#e5#, 16#f2#, 16#ff#, 16#b4#, 16#b9#, 16#ae#, 16#a3#, 16#80#, 16#8d#, 16#9a#, 16#97#);
	constant XTIME14_C : LUT := (16#0#, 16#e#, 16#1c#, 16#12#, 16#38#, 16#36#, 16#24#, 16#2a#, 16#70#, 16#7e#, 16#6c#, 16#62#, 16#48#, 16#46#, 16#54#, 16#5a#, 16#e0#, 16#ee#, 16#fc#, 16#f2#, 16#d8#, 16#d6#, 16#c4#, 16#ca#, 16#90#, 16#9e#, 16#8c#, 16#82#, 16#a8#, 16#a6#, 16#b4#, 16#ba#, 16#db#, 16#d5#, 16#c7#, 16#c9#, 16#e3#, 16#ed#, 16#ff#, 16#f1#, 16#ab#, 16#a5#, 16#b7#, 16#b9#, 16#93#, 16#9d#, 16#8f#, 16#81#, 16#3b#, 16#35#, 16#27#, 16#29#, 16#3#, 16#d#, 16#1f#, 16#11#, 16#4b#, 16#45#, 16#57#, 16#59#, 16#73#, 16#7d#, 16#6f#, 16#61#, 16#ad#, 16#a3#, 16#b1#, 16#bf#, 16#95#, 16#9b#, 16#89#, 16#87#, 16#dd#, 16#d3#, 16#c1#, 16#cf#, 16#e5#, 16#eb#, 16#f9#, 16#f7#, 16#4d#, 16#43#, 16#51#, 16#5f#, 16#75#, 16#7b#, 16#69#, 16#67#, 16#3d#, 16#33#, 16#21#, 16#2f#, 16#5#, 16#b#, 16#19#, 16#17#, 16#76#, 16#78#, 16#6a#, 16#64#, 16#4e#, 16#40#, 16#52#, 16#5c#, 16#6#, 16#8#, 16#1a#, 16#14#, 16#3e#, 16#30#, 16#22#, 16#2c#, 16#96#, 16#98#, 16#8a#, 16#84#, 16#ae#, 16#a0#, 16#b2#, 16#bc#, 16#e6#, 16#e8#, 16#fa#, 16#f4#, 16#de#, 16#d0#, 16#c2#, 16#cc#, 16#41#, 16#4f#, 16#5d#, 16#53#, 16#79#, 16#77#, 16#65#, 16#6b#, 16#31#, 16#3f#, 16#2d#, 16#23#, 16#9#, 16#7#, 16#15#, 16#1b#, 16#a1#, 16#af#, 16#bd#, 16#b3#, 16#99#, 16#97#, 16#85#, 16#8b#, 16#d1#, 16#df#, 16#cd#, 16#c3#, 16#e9#, 16#e7#, 16#f5#, 16#fb#, 16#9a#, 16#94#, 16#86#, 16#88#, 16#a2#, 16#ac#, 16#be#, 16#b0#, 16#ea#, 16#e4#, 16#f6#, 16#f8#, 16#d2#, 16#dc#, 16#ce#, 16#c0#, 16#7a#, 16#74#, 16#66#, 16#68#, 16#42#, 16#4c#, 16#5e#, 16#50#, 16#a#, 16#4#, 16#16#, 16#18#, 16#32#, 16#3c#, 16#2e#, 16#20#, 16#ec#, 16#e2#, 16#f0#, 16#fe#, 16#d4#, 16#da#, 16#c8#, 16#c6#, 16#9c#, 16#92#, 16#80#, 16#8e#, 16#a4#, 16#aa#, 16#b8#, 16#b6#, 16#c#, 16#2#, 16#10#, 16#1e#, 16#34#, 16#3a#, 16#28#, 16#26#, 16#7c#, 16#72#, 16#60#, 16#6e#, 16#44#, 16#4a#, 16#58#, 16#56#, 16#37#, 16#39#, 16#2b#, 16#25#, 16#f#, 16#1#, 16#13#, 16#1d#, 16#47#, 16#49#, 16#5b#, 16#55#, 16#7f#, 16#71#, 16#63#, 16#6d#, 16#d7#, 16#d9#, 16#cb#, 16#c5#, 16#ef#, 16#e1#, 16#f3#, 16#fd#, 16#a7#, 16#a9#, 16#bb#, 16#b5#, 16#9f#, 16#91#, 16#83#, 16#8d#);

	-- Function definitions
	function xor4Bytes ( byte1 : U_BYTE;
							   byte2 : U_BYTE;
							   byte3 : U_BYTE;
							   byte4 : U_BYTE ) 
							   return U_BYTE;
							  
	function xorBytes ( byte1 : U_BYTE;
							  byte2 : U_BYTE ) 
							  return U_BYTE;
	
	function xtime    ( input : U_BYTE; 
							   mult : U_BYTE )  
							  return U_BYTE;
				
	function sub      ( input : U_BYTE )
						     return U_BYTE;
	
	-- Procedure definitions
	procedure RotWord  ( qword_io : inout COLUMN );
	
	procedure SubWord  ( qword_io : inout COLUMN );
	
	procedure RoundKey ( qqword_in  : in MATRIX;
							   round_in   : in U_BYTE;
								qqword_out : out MATRIX );
	
end package AES_TYPES;

package body AES_TYPES is
	
	-- Upper nibble is used as the row number and lower nibble is used as column number. These are used to retrieve the value from the SBOX
	function sub ( input : U_BYTE )
						return U_BYTE is
	begin
		return SBOX_C(to_integer(shift_right(to_unsigned(input,8),4)) , (input mod 16#10#));
	end sub;

	-- XORs 2 bytes together 
	function xorBytes ( byte1 : U_BYTE;
							  byte2 : U_BYTE ) 
							  return U_BYTE is
	begin
		return to_integer(to_unsigned(byte1,8) xor to_unsigned(byte2,8));
	end xorBytes;
	
	--XORs 4 bytes together
	function xor4Bytes ( byte1 : U_BYTE;
							   byte2 : U_BYTE;
							   byte3 : U_BYTE;
							   byte4 : U_BYTE ) 
							  return U_BYTE is
	begin
		return to_integer(to_unsigned(byte1,8) xor to_unsigned(byte2,8) xor to_unsigned(byte3,8) xor to_unsigned(byte4,8));
	end xor4Bytes;
	
	-- Uses a look up table to see the result of the multiplication between an input byte and 2,3,9,11,13 or 14
	function xtime    ( input : U_BYTE; 
							   mult : U_BYTE )  
							  return U_BYTE is  
	begin
		case mult is
			when 1  => return 			 input ;
			when 2  => return  XTIME2_C(input);
			when 3  => return  XTIME3_C(input);
			when 9  => return  XTIME9_C(input);
			when 11 => return XTIME11_C(input);
			when 13 => return XTIME13_C(input);
			when 14 => return XTIME14_C(input);
			when others => return 16#FF#;
		end case;
	end xtime;
	
	-- First element in a column is appended at the end of the column
	procedure RotWord ( qword_io : inout COLUMN ) is
		variable qwordrot_v : COLUMN;
	begin
		for i in 0 to 3 loop
			qwordrot_v(i) := qword_io((i+1) mod 4);
		end loop;
		qword_io := qwordrot_v;
	end procedure;
	
   -- Replaces each byte in a column from the key matrix with a byte from the SBOX	
	procedure SubWord ( qword_io : inout COLUMN ) is
		variable qwordsub_v : COLUMN;
	begin
		for i in 0 to 3 loop
			qwordsub_v(i) := 	sub(qword_io(i));
		end loop;
		qword_io := qwordsub_v;
	end procedure;
	
	-- Derives the next round key based on the current round key and the round number  
	procedure RoundKey ( qqword_in  : in MATRIX;
							   round_in   : in U_BYTE;
								qqword_out : out MATRIX ) is
		variable column_v : COLUMN ;
		variable matrix_v : MATRIX ;
	begin
	-- copy first column
		for i in 0 to 3 loop
			column_v(i) := qqword_in(12 + i);
		end loop;
	-- prepare initialisation vector 
		RotWord(column_v);
		SubWord(column_v);
		column_v(0) := xorBytes(column_v(0),RCON_C(round_in));
	-- create round key
		for i in 0 to 3 loop
	-- for the next columns, vector is previous column
			if (i > 0) then
				for j in 0 to 3 loop
					column_v(j) := matrix_v((i-1)*4 + j);
				end loop;
			end if;
	-- xor each previous round key with round vector
			for j in 0 to 3 loop 
				matrix_v(i*4 + j) := xorBytes(qqword_in(i*4 + j) , column_v(j));
			end loop;
	-- copy to output
		end loop;
		qqword_out := matrix_v;
	end procedure;
	
end AES_TYPES;