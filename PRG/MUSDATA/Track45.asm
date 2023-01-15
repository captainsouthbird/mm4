	.byte $00	; Music header tag
	sda2 Track_45_SQ1	; Square 1
	sda2 Track_45_SQ2	; Square 2
	sda2 Track_45_TRI	; Triangle
	sda2 Track_45_NSE	; Noise

Track_45_SQ1:
	.byte MCMD_TEMPO_SET, $02, $49

Track_45_SQ1_01:	; D6AF
	.byte MCMD_TRACK_CONFIG, $00

Track_45_SQ1_00:	; D6B1
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $05
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte $B9, $9F
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $A8, $81, $87, $88, $80, $81, $87, $88, $88, $88, $86, $84, $66, $64, $66, $67, $88, $A0, $66, $64, $66, $67, $88, $80, $8B, $8B, $88, $8B, $88, $8C, $8F
	.byte MCMD_SET_1_5X_TIMING
	.byte $B0, $6F, $70, $8F, $8D, $8B, $86
	.byte MCMD_SET_1_5X_TIMING
	.byte $B0, $6F, $70, $92, $90, $8F, $8B
	.byte MCMD_SET_1_5X_TIMING
	.byte $B4, $72, $70
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B4
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B4
	.byte MCMD_NOTEATTACKLEN_SET, $96
	.byte MCMD_PATCH_SET, $0D
	.byte $80, $8C, $8C, $88, $8C, $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8C
	.byte MCMD_FREQOFFSET_SET, $7F
	.byte MCMD_TOGGLE_SINE_RESET
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $98
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_45_SQ1_00
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_45_SQ1_01
	.byte MCMD_TRACK_STOP


Track_45_SQ2:
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_FREQFINEOFFSET_SET, $01

Track_45_SQ2_03:	; D722
	.byte MCMD_TRACK_CONFIG, $00

Track_45_SQ2_02:	; D724
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $60, $B9, $9F
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $A8, $81, $87, $88, $80, $81, $87, $88, $88, $88, $86, $84, $66, $64, $66, $67, $88, $A0, $66, $64, $66, $67, $88, $80, $8B, $8B, $88, $8B, $88, $8C, $4F
	.byte MCMD_SET_1_5X_TIMING
	.byte $A8, $66, $68, $86, $84, $83
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $97
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $A8, $66, $68, $89, $88, $86, $83
	.byte MCMD_SET_1_5X_TIMING
	.byte $B0, $6F, $6D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B0
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B0
	.byte MCMD_NOTEATTACKLEN_SET, $96
	.byte MCMD_PATCH_SET, $0C
	.byte $80, $88, $88, $83, $88, $83
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88
	.byte MCMD_FREQOFFSET_SET, $7F
	.byte MCMD_TOGGLE_SINE_RESET
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $94
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_45_SQ2_02
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_45_SQ2_03
	.byte MCMD_TRACK_STOP


Track_45_TRI:
	.byte MCMD_NOTEATTACKLEN_SET, $CD
	.byte MCMD_PATCH_SET, $00

Track_45_TRI_0D:	; D785
	.byte MCMD_TRACK_CONFIG, $00

Track_45_TRI_0C:	; D787
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_OCTAVE_SET, $03

Track_45_TRI_04:	; D78B
	.byte MCMD_TRACK_CONFIG, $00
	.byte $81, $61, $61
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda2 Track_45_TRI_04
	.byte MCMD_OCTAVE_SET, $02

Track_45_TRI_05:	; D796
	.byte MCMD_TRACK_CONFIG, $00
	.byte $8B, $6B, $6B
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda2 Track_45_TRI_05

Track_45_TRI_06:	; D79F
	.byte MCMD_TRACK_CONFIG, $00
	.byte $89, $69, $69
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda2 Track_45_TRI_06

Track_45_TRI_07:	; D7A8
	.byte MCMD_TRACK_CONFIG, $00
	.byte $88, $68, $68
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda2 Track_45_TRI_07
	.byte $68, $69, $6A, $6C
Track_45_TRI_08:	; D7B5

	.byte MCMD_TRACK_CONFIG, $00
	.byte $8D, $6D, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda2 Track_45_TRI_08

Track_45_TRI_09:	; D7BE
	.byte MCMD_TRACK_CONFIG, $00
	.byte $90, $70, $70
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda2 Track_45_TRI_09

Track_45_TRI_0A:	; D7C7
	.byte MCMD_TRACK_CONFIG, $00
	.byte $92, $72, $72
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda2 Track_45_TRI_0A

Track_45_TRI_0B:	; D7D0
	.byte MCMD_TRACK_CONFIG, $00
	.byte $94, $74, $74
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda2 Track_45_TRI_0B
	.byte $74, $72, $70, $6F
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $01
	sda2 Track_45_TRI_0C
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_45_TRI_0D
	.byte MCMD_TRACK_STOP


Track_45_NSE:
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_PATCH_SET, $01

Track_45_NSE_10:	; D7E9
	.byte MCMD_TRACK_CONFIG, $00

Track_45_NSE_0F:	; D7EB
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte $65, $60, $67, $67
	.byte MCMD_NOTEATTACKLEN_SET, $96
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $00
	sda2 Track_45_NSE_0E
	.byte $68, $60
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte $67, $67
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda2 Track_45_NSE_0F

Track_45_NSE_0E:	; D803
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte $68, $68, $68, $68
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_45_NSE_10
	.byte MCMD_TRACK_STOP
