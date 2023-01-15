	.byte $00	; Music header tag
	sda1 Track_11_SQ1	; Square 1
	sda1 Track_11_SQ2	; Square 2
	sda1 Track_11_TRI	; Triangle
	sda1 Track_11_NSE	; Noise

Track_11_SQ1:

Track_11_SQ1_01:	; BB8E
	.byte MCMD_TRACK_CONFIG, $08
	.byte MCMD_TEMPO_SET, $02, $66
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0D
	.byte MCMD_PATCH_SET, $23
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $FA
	.byte MCMD_DUTYCYCLE_SET, $C0

Track_11_SQ1_00:	; BB9F
	.byte MCMD_TRACK_CONFIG, $08
	.byte $8A, $87, $8A, $87, $8A, $87, $8A, $87, $8D, $8A, $8D, $8A, $8D, $8A, $8D, $8A
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_11_SQ1_00
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_SET_1_5X_TIMING
	.byte $A1, $64, $6A, $C7, $C8, $CA, $CD, $C1
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6D
	.byte MCMD_FREQOFFSET_SET, $64
	.byte $6E
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AE
	.byte MCMD_FREQOFFSET_SET, $00
	.byte $C2
	.byte MCMD_SET_1_5X_TIMING
	.byte $A1, $64, $6A, $C7, $C8, $CA, $CD, $CE, $CF, $D0
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_11_SQ1_01
	.byte MCMD_TRACK_STOP


Track_11_SQ2:

Track_11_SQ2_04:	; BBDA
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_FREQFINEOFFSET_SET, $01
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0D
	.byte MCMD_PATCH_SET, $23
	.byte MCMD_OCTAVE_SET, $02

Track_11_SQ2_02:	; BBE6
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte $9F, $9C, $9F, $9C, $9F, $9C, $9F, $9C
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88, $85, $88, $85, $88, $85, $88, $85
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_11_SQ2_02

Track_11_SQ2_03:	; BBFF
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_PATCH_SET, $17
	.byte $9F, $9C, $9F, $9C, $9F, $9C, $9F, $9C
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88, $85, $88, $85, $88, $85, $88, $85
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_11_SQ2_03
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_11_SQ2_04
	.byte MCMD_TRACK_STOP


Track_11_TRI:
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $03

Track_11_TRI_07:	; BC28
	.byte MCMD_TRACK_CONFIG, $00

Track_11_TRI_06:	; BC2A
	.byte MCMD_TRACK_CONFIG, $00
	.byte $8D, $8D, $8D, $8D, $8D, $8D, $8D, $8D, $8A, $8A, $8A, $8A, $8A, $8A, $8A, $8A, $8D, $8D, $8D, $8D
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $00
	sda1 Track_11_TRI_05
	.byte $8D, $8D, $8D, $8D, $90, $90, $90, $90, $90, $90, $90, $90
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda1 Track_11_TRI_06

Track_11_TRI_05:	; BC54
	.byte $8E, $8E, $8E, $8E, $8F, $8F, $8F, $8F, $90, $90, $90, $90
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_11_TRI_07
	.byte MCMD_TRACK_STOP


Track_11_NSE:
	.byte MCMD_NOTEATTACKLEN_SET, $8C
	.byte MCMD_SYNTH_VOLUME_SET, $0D
	.byte MCMD_PATCH_SET, $23

Track_11_NSE_0C:	; BC6A
	.byte MCMD_TRACK_CONFIG, $00

Track_11_NSE_08:	; BC6C
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $88
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda1 Track_11_NSE_08

Track_11_NSE_09:	; BC75
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $88
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda1 Track_11_NSE_09
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte $88, $80, $88, $80, $88, $80, $88, $80, $68, $68, $88, $68, $68, $88
Track_11_NSE_0A:	; BC8E

	.byte MCMD_TRACK_CONFIG, $00
	.byte $68
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda1 Track_11_NSE_0A
	.byte MCMD_SYNTH_VOLUME_SET, $0D

Track_11_NSE_0B:	; BC97
	.byte MCMD_TRACK_CONFIG, $00
	.byte $A8, $A8, $A8, $A8
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $06
	sda1 Track_11_NSE_0B
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $68, $68, $68, $68
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $68, $68, $68, $68
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte $68, $68, $68, $68
	.byte MCMD_SYNTH_VOLUME_SET, $0D
	.byte $68, $68, $68, $68
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_11_NSE_0C
	.byte MCMD_TRACK_STOP
