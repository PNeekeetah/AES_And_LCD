transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/Nikita/Desktop/AES+LCD/AES_TYPES.vhd}
vcom -93 -work work {C:/Users/Nikita/Desktop/AES+LCD/frequency_divider.vhd}
vcom -93 -work work {C:/Users/Nikita/Desktop/AES+LCD/DE2_LCD_DISPLAY_arch.vhd}
vcom -93 -work work {C:/Users/Nikita/Desktop/AES+LCD/MixColumns.vhd}
vcom -93 -work work {C:/Users/Nikita/Desktop/AES+LCD/ShiftRows.vhd}
vcom -93 -work work {C:/Users/Nikita/Desktop/AES+LCD/SubBytes.vhd}
vcom -93 -work work {C:/Users/Nikita/Desktop/AES+LCD/AddRoundKey.vhd}
vcom -93 -work work {C:/Users/Nikita/Desktop/AES+LCD/AES.vhd}
vcom -93 -work work {C:/Users/Nikita/Desktop/AES+LCD/EncryptAndDisplay.vhd}

