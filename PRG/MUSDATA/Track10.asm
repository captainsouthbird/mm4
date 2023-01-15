	.byte $00	; Music header tag
	sda1 Track_10_SQ1	; Square 1
	sda1 Track_10_SQ2	; Square 2
	sda1 Track_10_TRI	; Triangle
	sda1 Track_10_NSE	; Noise

Track_10_SQ1:
	.byte MCMD_TEMPO_SET, $02, $00
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $03

Track_10_SQ1_02:	; BAC8
	.byte MCMD_TRACK_CONFIG, $00

Track_10_SQ2_03:	; BACA
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_NOTEATTACKLEN_SET, $A5
	.byte MCMD_PATCH_SET, $26

Track_10_SQ1_01:	; BAD6
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $BB
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68, $6B
	.byte MCMD_SET_1_5X_TIMING
	.byte $AF, $6D, $6B
	.byte MCMD_SET_1_5X_TIMING
	.byte $AD, $6B, $6A, $6B, $6A, $88, $80, $68, $6A
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda1 Track_10_SQ1_00
	.byte MCMD_SET_1_5X_TIMING
	.byte $AB, $6A, $6B, $AA, $A6
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C3
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C3
	.byte MCMD_PATCH_SET, $26
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_10_SQ1_01

Track_10_SQ1_00:	; BB01
	.byte MCMD_SET_1_5X_TIMING
	.byte $AB, $6A, $6B, $AA, $A6
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C8
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C8
	.byte MCMD_PATCH_SET, $26
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_10_SQ1_02
	.byte MCMD_TRACK_STOP


Track_10_SQ2:
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_FREQFINEOFFSET_SET, $FF
	.byte MCMD_SET_1_5X_TIMING
	.byte $60
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_10_SQ2_03
	.byte MCMD_TRACK_STOP


Track_10_TRI:
	.byte MCMD_NOTEATTACKLEN_SET, $E1
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $02

Track_10_TRI_05:	; BB23
	.byte MCMD_TRACK_CONFIG, $00

Track_10_TRI_04:	; BB25
	.byte MCMD_TRACK_CONFIG, $00
	.byte $74, $74, $72, $74, $6F, $72, $60, $74, $74, $72, $74, $6F, $72, $6F, $8F, $74, $74, $72, $74, $6F, $72, $60, $6F, $74, $74, $72, $74, $6F, $72, $8F
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_10_TRI_04
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_10_TRI_05
	.byte MCMD_TRACK_STOP


Track_10_NSE:
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_PATCH_SET, $01
	.byte MCMD_OCTAVE_SET, $02

Track_10_NSE_07:	; BB55
	.byte MCMD_TRACK_CONFIG, $00

Track_10_NSE_06:	; BB57
	.byte MCMD_TRACK_CONFIG, $00
	.byte $65, $65, $65, $65, $68, $60, $67, $65, $69, $65, $65, $65, $68, $60, $67, $67, $65, $65, $65, $65
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6F, $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $67, $65, $69, $65, $65, $65
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6F, $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $67, $67
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_10_NSE_06
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_10_NSE_07
	.byte MCMD_TRACK_STOP
