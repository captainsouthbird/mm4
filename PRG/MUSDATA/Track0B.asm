	.byte $00	; Music header tag
	sda1 Track_0B_SQ1	; Square 1
	sda1 Track_0B_SQ2	; Square 2
	sda1 Track_0B_TRI	; Triangle
	sda1 Track_0B_NSE	; Noise

Track_0B_SQ1:
	.byte MCMD_TEMPO_SET, $02, $00
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $FD
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_DUTYCYCLE_SET, $80

Track_0B_SQ1_01:	; B333
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $A0, $99, $9C, $9E, $80, $5F
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A8, $A6, $84, $A6
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $81
	.byte MCMD_SET_1_5X_TIMING
	.byte $C1
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $81, $81
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda1 Track_0B_SQ1_00
	.byte $84
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $44, $45, $86
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $84
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A1
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $80
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $AD, $AD
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $ED
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A0, $A8, $A6, $A9, $A8, $A6
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $C4
	.byte MCMD_SET_1_5X_TIMING
	.byte $A6
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88, $C8
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C8
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $19
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_0B_SQ1_01

Track_0B_SQ1_00:	; B37C
	.byte $84
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $44, $45, $86
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $88
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $AD
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $80
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $AD, $AD
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $F0
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A0, $A8, $A6, $A9, $A8, $AB
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $CD
	.byte MCMD_SET_1_5X_TIMING
	.byte $AF
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8C
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $EC
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A1, $A4, $A6, $A9, $A8, $A6
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $E8
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A1, $A4, $A8, $AD, $AF, $B0
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D, $6D, $6F
	.byte MCMD_SET_1_5X_TIMING
	.byte $B0, $8D
	.byte MCMD_SET_1_5X_TIMING
	.byte $A7, $6F, $6D
	.byte MCMD_SET_1_5X_TIMING
	.byte $B0, $8D, $A7, $AD
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AF
	.byte MCMD_TEMPO_SET, $01, $EB
	.byte $AF
	.byte MCMD_TEMPO_SET, $01, $D8
	.byte $AF
	.byte MCMD_TEMPO_SET, $01, $C7
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AF
	.byte MCMD_SET_1_5X_TIMING
	.byte $A0
	.byte MCMD_SET_1_5X_TIMING
	.byte $60
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $52
	.byte MCMD_FREQOFFSET_SET, $32
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B4
	.byte MCMD_FREQOFFSET_SET, $00

Track_0B_SQ1_04:	; B3DB
	.byte MCMD_TRACK_CONFIG, $08
	.byte MCMD_TEMPO_SET, $02, $00
	.byte MCMD_PATCH_SET, $0C
	.byte $6D, $6F
Track_0B_SQ1_02:	; B3E4

	.byte MCMD_TRACK_CONFIG, $08
	.byte MCMD_SET_1_5X_TIMING
	.byte $B0, $6F, $70
	.byte MCMD_SET_1_5X_TIMING
	.byte $AF, $6D, $6F
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_0B_SQ1_02
	.byte MCMD_LOOPCNT1_JMPLAST_CFG, $08
	sda1 Track_0B_SQ1_03
	.byte MCMD_SET_1_5X_TIMING
	.byte $B0, $6F, $70, $AF, $AB
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $01
	sda1 Track_0B_SQ1_04

Track_0B_SQ1_03:	; B405
	.byte MCMD_SET_1_5X_TIMING
	.byte $B0, $6F, $70, $B2, $AB
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD
Track_0B_SQ1_05:	; B411

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_TEMPO_SET, $01, $C7
	.byte MCMD_PATCH_SET, $19
	.byte MCMD_SET_1_5X_TIMING
	.byte $A0, $99, $9C, $9E, $80, $5F
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A8, $A6, $84, $A6
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $81
	.byte MCMD_SET_1_5X_TIMING
	.byte $C1
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $81, $81, $84
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $44, $45, $86
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $84
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A1
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $80
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $AD, $AD
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD
	.byte MCMD_PATCH_SET, $19
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A0, $A8, $A6, $A9, $A8, $A6
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $C4
	.byte MCMD_SET_1_5X_TIMING
	.byte $A6
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88, $C8
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C8
	.byte MCMD_PATCH_SET, $19
	.byte MCMD_SET_1_5X_TIMING
	.byte $A0, $81, $84, $86, $80, $47
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $68
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A8, $AC, $88, $A6
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $84
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A4
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D, $81, $84
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $44, $45, $86
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $88
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $AD
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $80
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $B0, $B0
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $F0
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A0, $A8, $A6, $A9, $A8, $AB
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $CD
	.byte MCMD_SET_1_5X_TIMING
	.byte $AF
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8C, $CC
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CC
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_0B_SQ1_05
	.byte MCMD_TRACK_STOP


Track_0B_SQ2:
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_FREQFINEOFFSET_SET, $FF
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $A0, $99, $9C, $9E, $80, $5F
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A8, $A6, $84, $A6
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $81
	.byte MCMD_SET_1_5X_TIMING
	.byte $C1
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $81, $81, $84
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $44, $45, $86
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $84
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A1
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $80
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $AD, $AD
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $ED
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A0, $A8, $A6, $A9, $A8, $A6
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $C4
	.byte MCMD_SET_1_5X_TIMING
	.byte $A6
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88
	.byte MCMD_SET_1_5X_TIMING
	.byte $C8, $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $48
	.byte MCMD_SYNTH_VOLUME_SET, $0D
	.byte MCMD_PATCH_SET, $23
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $94, $99, $9C
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88, $8D, $88, $84, $81
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $94, $9B, $9E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88, $8C, $88, $86, $83
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $94, $99, $9C
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88, $8D, $88, $84, $81
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $96, $99, $9E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $8A, $8D, $8A, $86, $81
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $95, $99, $9C
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $89, $8D, $89, $84, $81
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $94, $9B, $9E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88, $8C, $88, $86, $83
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $90, $95, $99, $9C
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88, $84, $81
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $95, $68, $6C, $6F, $72, $74, $78, $7B, $7E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68, $6C, $6F, $72, $74, $78
	.byte MCMD_OCTAVE_SET, $02
	.byte $6F, $72
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88, $8D, $90, $94, $99, $94, $90, $8D, $88, $8F, $92, $94, $98, $94, $92, $8F, $88, $8D, $90, $94, $99, $94, $90, $8D, $86, $8A, $8D, $92, $96, $92, $8D, $8A, $88, $8D, $90, $94, $89, $8D, $90, $95, $8A, $8D, $90, $96, $89, $8D, $90, $95, $86, $8B, $8F, $92, $8C, $8F, $92, $97, $9B
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_PATCH_SET, $0C
	.byte $79, $7B
	.byte MCMD_OCTAVE_SET, $03
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_SET_1_5X_TIMING
	.byte $60
Track_0B_SQ2_06:	; B587

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $BC, $7B, $7C
	.byte MCMD_SET_1_5X_TIMING
	.byte $BB, $79, $7B
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_0B_SQ2_06
	.byte MCMD_SET_1_5X_TIMING
	.byte $BC, $7B, $7C, $BB, $B7
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D9
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $59
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_OCTAVE_SET, $03
	.byte $70, $72
Track_0B_SQ2_07:	; B5A6

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $B4, $72, $74
	.byte MCMD_SET_1_5X_TIMING
	.byte $B2, $70, $72
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_0B_SQ2_07
	.byte MCMD_SET_1_5X_TIMING
	.byte $B4, $72, $74, $B2, $AF
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D1
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D1
Track_0B_SQ2_08:	; B5C0

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_PATCH_SET, $23
	.byte $88, $8D, $90, $94, $99, $94, $90, $8D, $88, $8F, $92, $94, $98, $94, $92, $8F, $88, $8D, $90, $94, $99, $94, $90, $8D, $8A, $8D, $92, $96, $99, $96, $92, $8D, $89, $8D, $90, $95, $99, $95, $90, $8D, $88, $8F, $92, $94, $98, $94, $92, $8F, $84, $89, $8D, $90, $94, $90, $8D, $89
	.byte MCMD_OCTAVE_SET, $01
	.byte $68, $6C, $6F, $72, $74, $78, $7B, $7E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68, $6C, $6F, $72, $74, $78
	.byte MCMD_OCTAVE_SET, $02
	.byte $6F, $72
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_PATCH_SET, $24
	.byte $80, $81
	.byte MCMD_SET_1_5X_TIMING
	.byte $C8, $80, $88, $4B, $8C
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $4B
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $6C
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $4B
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $6C, $88, $86
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $67, $88, $86, $84, $C1
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $77, $79, $7C, $7F, $9E
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $5F
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $47
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $68, $66
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $46, $47, $88
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $86, $84, $46
	.byte MCMD_SET_1_5X_TIMING
	.byte $68, $81, $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $94, $99, $BC, $9E, $5F
	.byte MCMD_TOGGLE_SINE_RESET
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $68
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A0
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $B4, $B2, $B5, $B4, $B7
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $D9
	.byte MCMD_SET_1_5X_TIMING
	.byte $BB, $98, $E0
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_0B_SQ2_08
	.byte MCMD_TRACK_STOP


Track_0B_TRI:
	.byte MCMD_NOTEATTACKLEN_SET, $F0
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D, $8D, $53
	.byte MCMD_SET_1_5X_TIMING
	.byte $74, $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CC
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8C, $AC, $8C
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CB
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8B, $8B, $94, $8B
	.byte MCMD_SET_1_5X_TIMING
	.byte $AA, $8A, $AA, $86, $88, $C9
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A9, $B0, $A9
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $C8
	.byte MCMD_SET_1_5X_TIMING
	.byte $AF, $68, $6F, $C6
	.byte MCMD_SET_1_5X_TIMING
	.byte $A6, $42
	.byte MCMD_SET_1_5X_TIMING
	.byte $63
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A8, $B4, $92, $90, $A8, $A8, $8B, $8C
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D, $8D, $94, $8D
	.byte MCMD_SET_1_5X_TIMING
	.byte $8C
	.byte MCMD_SET_1_5X_TIMING
	.byte $92, $74, $75
	.byte MCMD_SET_1_5X_TIMING
	.byte $92
	.byte MCMD_SET_1_5X_TIMING
	.byte $8F, $8C
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CB
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8B, $8B, $4A
	.byte MCMD_SET_1_5X_TIMING
	.byte $6B, $8B, $C6
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A6, $AD, $84, $86
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C9
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $89, $89, $90, $89
	.byte MCMD_SET_1_5X_TIMING
	.byte $A8, $66, $68
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A6, $A8, $A8
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A6, $86
	.byte MCMD_SET_1_5X_TIMING
	.byte $A7, $87
	.byte MCMD_SET_1_5X_TIMING
	.byte $88
	.byte MCMD_SET_1_5X_TIMING
	.byte $86, $84
	.byte MCMD_SET_1_5X_TIMING
	.byte $89
	.byte MCMD_SET_1_5X_TIMING
	.byte $88, $88
	.byte MCMD_SET_1_5X_TIMING
	.byte $AD, $8D, $A6, $A6
	.byte MCMD_SET_1_5X_TIMING
	.byte $AC, $8F, $B4, $B8
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_SET_1_5X_TIMING
	.byte $B7, $90, $B5, $B7, $D6, $B6, $B2
	.byte MCMD_SET_1_5X_TIMING
	.byte $B5, $95
	.byte MCMD_SET_1_5X_TIMING
	.byte $B5, $95
	.byte MCMD_SET_1_5X_TIMING
	.byte $B6, $96
	.byte MCMD_SET_1_5X_TIMING
	.byte $BC, $99
	.byte MCMD_SET_1_5X_TIMING
	.byte $B7, $97
	.byte MCMD_SET_1_5X_TIMING
	.byte $B8, $98, $97
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $B9, $99
	.byte MCMD_SET_1_5X_TIMING
	.byte $B7, $97
	.byte MCMD_SET_1_5X_TIMING
	.byte $B9, $99
	.byte MCMD_SET_1_5X_TIMING
	.byte $B7, $97
	.byte MCMD_SET_1_5X_TIMING
	.byte $B5, $95, $B7, $B4
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B9, $79
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $74, $72, $70, $AD, $B4, $B9, $B9, $B7, $B7, $B5, $B5, $B4, $B4, $B2, $B2, $B4, $B4
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D9
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D9
Track_0B_TRI_09:	; B745

	.byte MCMD_TRACK_CONFIG, $40
	.byte MCMD_NOTEATTACKLEN_SET, $F0
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $D9
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $99, $94, $F8
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D7
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $97, $92, $F6
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D5
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $95, $90, $F4, $D3, $CF, $F4
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D9
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $99, $94, $F8, $D7, $D6, $D5, $D4
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D2
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $92, $90
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $B4, $AF, $B2, $B0, $B4, $B2
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D5
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $95, $92
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D4
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D4
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_0B_TRI_09
	.byte MCMD_TRACK_STOP


Track_0B_NSE:

Track_0B_NSE_0A:	; B78B
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_PATCH_SET, $1C
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte $A0
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $8A
	.byte MCMD_NOTEATTACKLEN_SET, $78
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $8A
	.byte MCMD_NOTEATTACKLEN_SET, $B4
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte $8A
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $8A
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $8A
	.byte MCMD_SYNTH_VOLUME_SET, $04
	.byte $8A
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda1 Track_0B_NSE_0A

Track_0B_NSE_0B:	; B7B0
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $85
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $85
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $8A
	.byte MCMD_NOTEATTACKLEN_SET, $78
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $8A
	.byte MCMD_NOTEATTACKLEN_SET, $B4
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte $8A
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $8A
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $8A
	.byte MCMD_SYNTH_VOLUME_SET, $04
	.byte $8A
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $0F
	sda1 Track_0B_NSE_0B

Track_0B_NSE_0C:	; B7D8
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte $8D, $8D
	.byte MCMD_NOTEATTACKLEN_SET, $B4
	.byte MCMD_SET_1_5X_TIMING
	.byte $88
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte $6D, $8D, $8D, $88, $8D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $06
	sda1 Track_0B_NSE_0C

Track_0B_NSE_0F:	; B7EF
	.byte MCMD_TRACK_CONFIG, $00

Track_0B_NSE_0D:	; B7F1
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_PATCH_SET, $1C
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte $A0
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $8A
	.byte MCMD_NOTEATTACKLEN_SET, $78
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $8A
	.byte MCMD_NOTEATTACKLEN_SET, $B4
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte $8A
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $8A
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $8A
	.byte MCMD_SYNTH_VOLUME_SET, $04
	.byte $8A
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $08
	sda1 Track_0B_NSE_0D

Track_0B_NSE_0E:	; B816
	.byte MCMD_TRACK_CONFIG, $00
	.byte $E0
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $06
	sda1 Track_0B_NSE_0E
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_0B_NSE_0F
	.byte $E0
	.byte MCMD_TRACK_STOP
