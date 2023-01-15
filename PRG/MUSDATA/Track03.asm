	.byte $00	; Music header tag
	sda1 Track_03_SQ1	; Square 1
	sda1 Track_03_SQ2	; Square 2
	sda1 Track_03_TRI	; Triangle
	sda1 Track_03_NSE	; Noise

Track_03_SQ1:
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $FE

Track_03_SQ1_00:	; 9788
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_TEMPO_SET, $01, $EB
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_OCTAVE_SET, $01
	.byte $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $8D, $6B, $6D, $60
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $4F, $B0
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $8D, $6B, $6C, $60, $6D, $80, $91, $70, $71, $60
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $55, $B6
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $96, $74, $70, $60, $6D, $6C, $6C, $6B, $6C, $60, $6D, $6F, $6D, $6C, $A0, $60, $6B, $6C
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte $CD
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D
	.byte MCMD_SET_1_5X_TIMING
	.byte $8F, $90
	.byte MCMD_SET_1_5X_TIMING
	.byte $94, $D2, $60, $8B, $6C
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6D, $AD
	.byte MCMD_PATCH_SET, $13
	.byte $CD
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AD
	.byte MCMD_SET_1_5X_TIMING
	.byte $90
	.byte MCMD_SET_1_5X_TIMING
	.byte $92, $93
	.byte MCMD_SET_1_5X_TIMING
	.byte $94
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D, $6B, $6C, $CD
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D
	.byte MCMD_SET_1_5X_TIMING
	.byte $8F, $90, $D7, $77
	.byte MCMD_OCTAVE_SET, $02
	.byte $8D, $8B, $68, $66, $67
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C8
	.byte MCMD_PATCH_SET, $03
	.byte $C8
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $A8
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $A8
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $A8
	.byte MCMD_SYNTH_VOLUME_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A8
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_SET_1_5X_TIMING
	.byte $86
	.byte MCMD_SET_1_5X_TIMING
	.byte $88, $89, $69, $60, $69, $80, $68, $60, $66
	.byte MCMD_SET_1_5X_TIMING
	.byte $84
	.byte MCMD_SET_1_5X_TIMING
	.byte $86, $88, $68, $60, $68, $80, $66, $60, $64, $63, $64, $63, $C6, $64, $66, $64, $69, $60
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C8
	.byte MCMD_PATCH_SET, $05
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C8
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_SET_1_5X_TIMING
	.byte $81
	.byte MCMD_SET_1_5X_TIMING
	.byte $83, $85
	.byte MCMD_SET_1_5X_TIMING
	.byte $85
	.byte MCMD_SET_1_5X_TIMING
	.byte $86, $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C9
	.byte MCMD_PATCH_SET, $13
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C9
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $97
	.byte MCMD_SET_1_5X_TIMING
	.byte $99, $9B
	.byte MCMD_SET_1_5X_TIMING
	.byte $9B
	.byte MCMD_SET_1_5X_TIMING
	.byte $9C, $9E
	.byte MCMD_TOGGLE_SINE_RESET
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $C8
	.byte MCMD_PATCH_SET, $13
	.byte $A8
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88
	.byte MCMD_PATCH_SET, $02
	.byte $66, $68
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A9
	.byte MCMD_PATCH_SET, $13
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C9
	.byte MCMD_PATCH_SET, $02
	.byte $A6
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AB
	.byte MCMD_PATCH_SET, $13
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CB
	.byte MCMD_PATCH_SET, $02
	.byte $A8
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AC
	.byte MCMD_PATCH_SET, $13
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CC
	.byte MCMD_PATCH_SET, $02
	.byte $AF, $6D, $6C, $60, $8D, $6B, $6D, $8B, $68, $66, $69, $68, $64
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $77, $74, $75, $77, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D9
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $79, $78, $79, $60, $DB, $60, $BE
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $DD
	.byte MCMD_PATCH_SET, $13
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $DD
	.byte MCMD_PATCH_SET, $02
	.byte $60, $7D, $7C, $7D
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $48, $49, $65, $63, $65, $63, $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $78, $75, $74, $75, $76, $78
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_03_SQ1_00
	.byte MCMD_TRACK_STOP


Track_03_SQ2:

Track_03_SQ2_06:	; 98B2
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_FREQFINEOFFSET_SET, $01
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_OCTAVE_SET, $01
	.byte $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $8D, $6B, $6D, $60
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $4F, $B0
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $8D, $6B, $6C, $60, $6D, $80, $8D, $6B, $6D, $60
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $52, $B2
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $90, $6D, $6B, $60, $6D, $74, $74, $72, $74, $60, $75, $77, $75, $74, $A0
	.byte MCMD_SET_1_5X_TIMING
	.byte $80
Track_03_SQ2_05:	; 98E7

	.byte MCMD_TRACK_CONFIG, $00

Track_03_SQ2_01:	; 98E9
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte $79, $7C
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68, $6B
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_03_SQ2_01

Track_03_SQ2_02:	; 98F6
	.byte MCMD_TRACK_CONFIG, $00
	.byte $77, $7B
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68, $6B
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_03_SQ2_02

Track_03_SQ2_03:	; 9901
	.byte MCMD_TRACK_CONFIG, $00
	.byte $79, $7C
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68, $6B
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_03_SQ2_03
	.byte MCMD_LOOPCNT1_JMPLAST_CFG, $08
	sda1 Track_03_SQ2_04
	.byte MCMD_SET_1_5X_TIMING
	.byte $84
	.byte MCMD_SET_1_5X_TIMING
	.byte $86, $87
	.byte MCMD_SET_1_5X_TIMING
	.byte $88
	.byte MCMD_SET_1_5X_TIMING
	.byte $81
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $77, $78
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $01
	sda1 Track_03_SQ2_05

Track_03_SQ2_04:	; 9920
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_PATCH_SET, $05
	.byte $68
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $74, $7F, $73, $7E, $72, $7D, $71, $7C, $70, $7B, $6F, $79, $6D, $77, $6B
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $89
	.byte MCMD_SET_1_5X_TIMING
	.byte $8B, $8D, $6D, $60, $6D, $80, $6B, $60, $69
	.byte MCMD_SET_1_5X_TIMING
	.byte $88
	.byte MCMD_SET_1_5X_TIMING
	.byte $89, $8B, $6B, $60, $6B, $80, $69, $60, $68
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte $A0, $60, $63, $64, $63
	.byte MCMD_SET_1_5X_TIMING
	.byte $A6, $69, $60
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D4
	.byte MCMD_PATCH_SET, $05
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D4
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte MCMD_PATCH_SET, $05
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D
	.byte MCMD_SET_1_5X_TIMING
	.byte $8C, $8B
	.byte MCMD_SET_1_5X_TIMING
	.byte $8B
	.byte MCMD_SET_1_5X_TIMING
	.byte $8A, $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C6
	.byte MCMD_PATCH_SET, $13
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C6
	.byte MCMD_PATCH_SET, $05
	.byte MCMD_SET_1_5X_TIMING
	.byte $8B
	.byte MCMD_SET_1_5X_TIMING
	.byte $8A, $89
	.byte MCMD_SET_1_5X_TIMING
	.byte $89
	.byte MCMD_SET_1_5X_TIMING
	.byte $88, $86
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C4
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C4, $A0
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $75, $79, $7E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $69, $66, $69, $6D, $72, $6D, $72, $95, $A0
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $74, $77, $7B, $7D
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68, $6B, $6F, $70, $74, $78, $74, $70, $A0
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $74, $78, $7B
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68, $66, $68, $6C, $6F, $6C, $6F, $72, $74
	.byte MCMD_PATCH_SET, $02
	.byte $61, $63, $60, $84, $77
	.byte MCMD_OCTAVE_SET, $02
	.byte $6D, $8B, $68, $66, $69, $68, $64
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $77, $74
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $75, $77, $60, $99, $72, $74, $60
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D5, $B5
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $75, $78, $79, $60, $BB, $BE
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $DD
	.byte MCMD_PATCH_SET, $13
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $DD
	.byte MCMD_PATCH_SET, $02
	.byte $71, $71, $73, $75, $78, $75, $77, $78, $60, $78, $78, $76, $74, $72, $70, $6F
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_03_SQ2_06
	.byte MCMD_TRACK_STOP


Track_03_TRI:
	.byte $80
Track_03_TRI_0A:	; 99FA

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $03
	.byte $8D, $6B, $6D, $60
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $4F, $B0
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $8D, $6B, $6C, $60, $6D, $80, $8D, $6B, $6D, $60
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $52, $B2
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $90, $6D, $6B, $60, $6D, $74, $74, $72, $74, $68, $75, $77, $75, $74
	.byte MCMD_SET_1_5X_TIMING
	.byte $80, $A8
Track_03_TRI_08:	; 9A29

	.byte MCMD_TRACK_CONFIG, $00
	.byte $6D, $60, $6D, $60, $90, $6D, $6D, $60, $6D, $60, $6D, $90, $8D, $6B, $60, $6B, $60, $8F, $6B, $6B, $60, $6B, $60, $6B, $8F, $8B, $6D, $60, $6D, $60, $90, $6D, $6D, $60, $6D, $60, $70, $92, $94
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $00
	sda1 Track_03_TRI_07
	.byte MCMD_SET_1_5X_TIMING
	.byte $90
	.byte MCMD_SET_1_5X_TIMING
	.byte $92, $93
	.byte MCMD_SET_1_5X_TIMING
	.byte $94
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D, $6B, $6C
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_03_TRI_08

Track_03_TRI_07:	; 9A65
	.byte MCMD_PATCH_SET, $04
	.byte $9D, $9D, $9C, $9C, $91, $91, $90, $90
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $92
	.byte MCMD_SET_1_5X_TIMING
	.byte $95, $79, $6D, $7C, $60, $7C, $60, $7B, $79, $8D, $60, $6D, $70, $74, $77, $77, $76, $74, $60, $6D, $70, $74, $77, $77, $76, $74
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte $6F, $6F, $60, $6F, $72, $72, $60, $72, $75, $75, $60, $75, $78, $78, $60, $78
Track_03_TRI_09:	; 9AA0

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte $68, $74, $68, $68, $74, $68, $74, $74
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_03_TRI_09
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D, $68, $60, $6D, $6D, $6D
	.byte MCMD_SET_1_5X_TIMING
	.byte $94
	.byte MCMD_SET_1_5X_TIMING
	.byte $92, $91, $B2, $AD
	.byte MCMD_SET_1_5X_TIMING
	.byte $97
	.byte MCMD_SET_1_5X_TIMING
	.byte $95, $94, $B2, $AB
	.byte MCMD_SET_1_5X_TIMING
	.byte $92
	.byte MCMD_SET_1_5X_TIMING
	.byte $90, $8F, $B0, $A4
	.byte MCMD_SET_1_5X_TIMING
	.byte $90
	.byte MCMD_SET_1_5X_TIMING
	.byte $8F, $8D
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C9
	.byte MCMD_PATCH_SET, $13
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A9
	.byte MCMD_PATCH_SET, $04
	.byte $99, $80
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CB
	.byte MCMD_PATCH_SET, $13
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AB
	.byte MCMD_PATCH_SET, $04
	.byte $99, $80
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CC
	.byte MCMD_PATCH_SET, $13
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AC
	.byte MCMD_PATCH_SET, $04
	.byte $99, $80, $E0
	.byte MCMD_PATCH_SET, $00
	.byte $72, $60, $72, $60, $90, $72, $72, $60, $72, $60, $72, $90, $92, $74, $60, $74, $60, $92, $74, $74, $60, $74, $60, $74, $92, $94
	.byte MCMD_PATCH_SET, $04
	.byte $6D, $6D, $99, $6D, $6D, $99, $60, $56, $56, $74, $70, $72, $70, $6D, $6B, $94, $94, $79, $74, $60, $74, $60, $74, $74, $74, $74, $74, $74, $74, $99
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_03_TRI_0A
	.byte MCMD_TRACK_STOP


Track_03_NSE:

Track_03_NSE_0C:	; 9B36
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte MCMD_PATCH_SET, $01
	.byte $65, $6D, $6D, $65, $67, $6D, $65, $67, $6D, $65, $6D, $65, $67, $6D, $6D, $65, $65, $6D, $6D, $65, $67, $6D, $65, $6D, $6D, $65, $6D, $65, $67, $6D, $6D, $65, $65, $6D, $6D, $65, $67, $6D, $65, $67, $6D, $65, $6D, $65, $67, $6D, $6D, $65
Track_03_NSE_0B:	; 9B6E

	.byte MCMD_TRACK_CONFIG, $00
	.byte $65, $6D, $6D, $65, $67, $6D, $65, $67, $6D, $65, $6D, $65, $67, $6D, $6D, $65, $65, $6D, $6D, $65, $67, $6D, $65, $67, $6D, $65, $6D, $65, $67, $6D, $6D, $65
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $0B
	sda1 Track_03_NSE_0B
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_03_NSE_0C
	.byte MCMD_TRACK_STOP
