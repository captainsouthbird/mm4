	.byte $00	; Music header tag
	sda1 Track_09_SQ1	; Square 1
	sda1 Track_09_SQ2	; Square 2
	sda1 Track_09_TRI	; Triangle
	sda1 Track_09_NSE	; Noise

Track_09_SQ1:
	.byte MCMD_TEMPO_SET, $02, $16

Track_09_SQ1_02:	; AE01
	.byte MCMD_TRACK_CONFIG, $00

Track_09_SQ1_01:	; AE03
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $04
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_OCTAVE_SET, $01
	.byte $80
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $AA, $68, $60
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $66
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $66, $68
	.byte MCMD_SET_1_5X_TIMING
	.byte $8A
	.byte MCMD_SET_1_5X_TIMING
	.byte $86, $63
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda1 Track_09_SQ1_00
	.byte $80, $A6, $86, $68, $60, $66, $60, $68
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D
	.byte MCMD_SET_1_5X_TIMING
	.byte $CA, $A0
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_09_SQ1_01

Track_09_SQ1_00:	; AE38
	.byte $80, $A6, $86, $68, $60, $66, $60, $65
	.byte MCMD_SET_1_5X_TIMING
	.byte $81, $E3
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_PATCH_SET, $08
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $B4
	.byte MCMD_SET_1_5X_TIMING
	.byte $B8, $B9, $5A
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $BB
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $7B, $94
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $BE, $BD, $BB
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $9D
	.byte MCMD_SET_1_5X_TIMING
	.byte $99, $D4
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6D, $6F
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $50, $B1
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C8
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $B1
	.byte MCMD_SET_1_5X_TIMING
	.byte $B5, $B8, $BD, $80, $7B, $7D
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $BB, $B9, $B8
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $B9, $80
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $B9, $B8, $B9
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $EA, $AB, $80, $86
	.byte MCMD_SET_1_5X_TIMING
	.byte $86
	.byte MCMD_SET_1_5X_TIMING
	.byte $85, $86, $A2
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0, $AD, $80, $88
	.byte MCMD_SET_1_5X_TIMING
	.byte $88
	.byte MCMD_SET_1_5X_TIMING
	.byte $87, $88, $A5, $C0, $A5
	.byte MCMD_SET_1_5X_TIMING
	.byte $86
	.byte MCMD_SET_1_5X_TIMING
	.byte $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CA
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8A
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_SET_1_5X_TIMING
	.byte $87
	.byte MCMD_SET_1_5X_TIMING
	.byte $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CA
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8A
	.byte MCMD_NOTEATTACKLEN_SET, $8C
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_SET_1_5X_TIMING
	.byte $89
	.byte MCMD_SET_1_5X_TIMING
	.byte $8A, $8C
	.byte MCMD_SET_1_5X_TIMING
	.byte $8C
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D, $8F, $F1, $8F, $91, $92, $B4, $91, $AD, $E0, $8F, $91, $92, $B4, $91, $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8F
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte $CF
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AF
	.byte MCMD_PATCH_SET, $02
	.byte $80, $6F, $6F
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_09_SQ1_02
	.byte MCMD_TRACK_STOP


Track_09_SQ2:

Track_09_SQ2_05:	; AEE2
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $60
Track_09_SQ2_04:	; AEE6

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_FREQFINEOFFSET_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_OCTAVE_SET, $01
	.byte $80
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $AA, $68, $60
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $66
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $66, $68
	.byte MCMD_SET_1_5X_TIMING
	.byte $8A
	.byte MCMD_SET_1_5X_TIMING
	.byte $86, $63
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda1 Track_09_SQ2_03
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0, $80, $A6, $86, $68, $60, $66, $60, $68
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D
	.byte MCMD_SET_1_5X_TIMING
	.byte $CA, $A0
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_09_SQ2_04

Track_09_SQ2_03:	; AF1B
	.byte $C0, $80, $40
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $96
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B6, $D4, $F3
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $AC
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $AA, $A8
	.byte MCMD_SET_1_5X_TIMING
	.byte $A6, $86
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $AA, $A8, $A6
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A5
	.byte MCMD_SET_1_5X_TIMING
	.byte $A6, $88, $65, $66
	.byte MCMD_SET_1_5X_TIMING
	.byte $AD
	.byte MCMD_SET_1_5X_TIMING
	.byte $AF, $B1
	.byte MCMD_SET_1_5X_TIMING
	.byte $AC
	.byte MCMD_SET_1_5X_TIMING
	.byte $AA, $A9, $C5
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AF
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AF, $AC
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D
	.byte MCMD_SET_1_5X_TIMING
	.byte $8C, $8D
	.byte MCMD_SET_1_5X_TIMING
	.byte $8F
	.byte MCMD_SET_1_5X_TIMING
	.byte $8C, $88, $A6, $80, $86
	.byte MCMD_SET_1_5X_TIMING
	.byte $86
	.byte MCMD_SET_1_5X_TIMING
	.byte $88, $8A, $A2
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0, $A5, $80, $85
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D
	.byte MCMD_SET_1_5X_TIMING
	.byte $8F, $91, $A5, $C0, $A5, $C0
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $86
	.byte MCMD_SET_1_5X_TIMING
	.byte $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8A
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CA
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_SYNTH_VOLUME_SET, $0D
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $93
	.byte MCMD_SET_1_5X_TIMING
	.byte $94, $96
	.byte MCMD_NOTEATTACKLEN_SET, $8C
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_SET_1_5X_TIMING
	.byte $9D
	.byte MCMD_SET_1_5X_TIMING
	.byte $9E, $9F
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $89
	.byte MCMD_SET_1_5X_TIMING
	.byte $8A, $8B, $EC, $83, $85, $86, $A8, $85, $A1
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte $83, $85, $86, $A8, $85, $A1
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte $86, $88, $89, $AB, $88, $85
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $87
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte $C7
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A7, $80
	.byte MCMD_PATCH_SET, $02
	.byte $67, $67
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_09_SQ2_05
	.byte MCMD_TRACK_STOP


Track_09_TRI:

Track_09_TRI_09:	; AFCC
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $03

Track_09_TRI_07:	; AFD4
	.byte MCMD_TRACK_CONFIG, $00

Track_09_TRI_06:	; AFD6
	.byte MCMD_TRACK_CONFIG, $00
	.byte $63, $63, $80, $8F, $6D, $6F, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $8A, $68, $60, $65, $61
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_09_TRI_06
	.byte $61, $61, $80, $8D, $6B, $6D, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $88, $68, $60, $6B, $6C, $63, $63, $80, $8F, $6D, $6F, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $8A, $68, $60, $65, $61
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $01
	sda1 Track_09_TRI_07
	.byte $68, $68, $A0, $68, $68, $A0, $A8, $6C, $6C, $A0, $6C, $6C, $A0, $A8, $6D, $6D, $A0, $6D, $6D, $A0, $A1, $6D, $6D, $A0, $6D, $6D, $A0, $AD, $6C, $6C, $A0, $6C, $6C, $A0, $A5, $6C, $6C, $A0, $6C, $6C, $A0, $A5, $6A, $6A, $A0, $6C, $6D
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $AD, $AF, $B0
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $71, $71, $A0, $6F, $6D
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $AD, $AF, $B1
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $63, $63, $80, $8B, $6A, $6B, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $86, $64, $60, $63, $61, $63, $63, $80, $8B, $6A, $6B, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $86, $64, $60, $63, $61, $65, $65, $80, $8D, $6C, $6D, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $88, $66, $60, $65, $63, $6A, $6A, $80, $91, $6F, $71, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $8E, $6D, $60, $6A, $65
	.byte MCMD_SET_1_5X_TIMING
	.byte $86
	.byte MCMD_SET_1_5X_TIMING
	.byte $88, $8A
	.byte MCMD_PATCH_SET, $04
	.byte $71, $71, $8D, $71, $71, $8D
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $87
	.byte MCMD_SET_1_5X_TIMING
	.byte $88, $8A
	.byte MCMD_PATCH_SET, $04
	.byte $71, $71, $8D, $71, $71, $8D
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $89
	.byte MCMD_SET_1_5X_TIMING
	.byte $8A, $8C
	.byte MCMD_SET_1_5X_TIMING
	.byte $8C
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D, $8F, $B1
	.byte MCMD_PATCH_SET, $04
	.byte $79, $78, $76, $74, $72, $71, $6F, $6D, $6C, $6A, $68, $66
Track_09_TRI_08:	; B0B0

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte MCMD_PATCH_SET, $04
	.byte $8A, $6A, $6A
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda1 Track_09_TRI_08
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $B1, $B1, $76, $76, $72, $72, $6F, $6F
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8F
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CF, $80, $6F, $6F
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_09_TRI_09
	.byte MCMD_TRACK_STOP


Track_09_NSE:

Track_09_NSE_0D:	; B0D5
	.byte MCMD_TRACK_CONFIG, $00

Track_09_NSE_0A:	; B0D7
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $8C
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte MCMD_PATCH_SET, $01
	.byte $6D
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $6D, $6D, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $1B
	sda1 Track_09_NSE_0A
	.byte MCMD_NOTEATTACKLEN_SET, $C0
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $68, $80, $67, $6A, $60, $67, $6A, $60, $67, $6A, $60, $6A, $6A, $67, $6A
Track_09_NSE_0B:	; B0FC

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $BE
	.byte $65, $80, $65
	.byte MCMD_NOTEATTACKLEN_SET, $AA
	.byte $6A, $60
	.byte MCMD_NOTEATTACKLEN_SET, $BE
	.byte $66, $60, $65, $6A, $65, $60
	.byte MCMD_NOTEATTACKLEN_SET, $AA
	.byte $6A, $60
	.byte MCMD_NOTEATTACKLEN_SET, $BE
	.byte $65, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $0D
	sda1 Track_09_NSE_0B
	.byte $65, $6D, $6D, $65, $6A, $6D, $65, $6D, $6D, $6A, $65, $6D, $6A, $6D, $65, $6D, $65, $6A, $6D, $65, $6A, $6D, $65, $6D, $65, $6A, $65, $6A, $6A, $65, $65, $66
Track_09_NSE_0C:	; B13B

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $8C
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte MCMD_PATCH_SET, $01
	.byte $6D
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $6D, $6D, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $0F
	sda1 Track_09_NSE_0C
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_09_NSE_0D
	.byte MCMD_TRACK_STOP
