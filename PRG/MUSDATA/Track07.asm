	.byte $00	; Music header tag
	sda1 Track_07_SQ1	; Square 1
	sda1 Track_07_SQ2	; Square 2
	sda1 Track_07_TRI	; Triangle
	sda1 Track_07_NSE	; Noise

Track_07_SQ1:
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $FC
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_TEMPO_SET, $02, $00
	.byte MCMD_NOTEATTACKLEN_SET, $AA
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $14
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_TOGGLE_SINE_RESET
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $CF
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CF
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $F7
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D7, $A0
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte $77, $6D, $80
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_PATCH_SET, $08
	.byte $EF, $ED, $EB, $8B, $80
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AE
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $AE
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AE
Track_07_SQ1_01:	; A7D9

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_PATCH_SET, $0C
	.byte $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $96, $74, $92
	.byte MCMD_SET_1_5X_TIMING
	.byte $94, $92, $91, $8D, $6B, $6D, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $8F
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $77, $79, $60, $9B
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6F, $6E, $60, $91, $80, $92, $71, $92
	.byte MCMD_SET_1_5X_TIMING
	.byte $B4, $71, $8D
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D6
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $96, $74, $76
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B7
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $77
	.byte MCMD_OCTAVE_SET, $02
	.byte $6D, $8B, $6A, $68, $60, $6A, $A0
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A8
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $68, $6A, $88, $66, $68, $60, $AA, $60, $C3
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $83, $85, $86, $87, $88, $8A
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $CB, $AA
	.byte MCMD_SET_1_5X_TIMING
	.byte $C9, $A5, $6A, $6A, $60, $6B, $60, $6B, $60, $68, $6A, $A0
	.byte MCMD_SET_1_5X_TIMING
	.byte $80, $CA
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $8A, $88, $86, $85, $86, $83
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $CB
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $8B, $8A, $88, $86, $88, $8B, $A5, $A6, $A8, $AA, $AD, $AE
Track_07_SQ1_00:	; A855

	.byte MCMD_TRACK_CONFIG, $08
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte $6F, $6F, $6D, $6F, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D, $6F
	.byte MCMD_SET_1_5X_TIMING
	.byte $A0
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda1 Track_07_SQ1_00
	.byte $6F, $6F, $6D, $6F, $60, $6F, $6D, $6F
	.byte MCMD_SET_1_5X_TIMING
	.byte $80, $72, $71
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_07_SQ1_01
	.byte MCMD_TRACK_STOP


Track_07_SQ2:
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_NOTEATTACKLEN_SET, $AA
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_PATCH_SET, $14
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_TOGGLE_SINE_RESET
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $D2
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D2
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D1
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D1
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $EF
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CF, $A0
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte $6F, $71, $80
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_PATCH_SET, $11
	.byte $80, $92, $71, $72, $60, $72, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $92, $71, $72, $60, $80, $92, $71, $72, $80, $74, $80, $94, $72, $71, $60, $80, $92, $71, $72, $80, $71, $80, $71, $72
	.byte MCMD_SET_1_5X_TIMING
	.byte $94, $92, $80
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B4
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $B4
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B4
Track_07_SQ2_03:	; A8DB

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_PATCH_SET, $11
	.byte MCMD_NOTEATTACKLEN_SET, $F0
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $92, $71, $72, $60, $71, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $91, $6F, $71, $60, $80, $8F, $6D, $6F, $60, $6F, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $8F, $6E, $71, $60
	.byte MCMD_OCTAVE_SET, $00
	.byte $80, $95, $74, $95, $D7, $74
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte $D2, $D1, $D4, $D2, $F1, $EA, $EB, $EC
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_NOTEATTACKLEN_SET, $96
	.byte $6E, $6E, $60, $6F, $60, $6F, $60, $6C, $6E
	.byte MCMD_SET_1_5X_TIMING
	.byte $80
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $56, $54, $52, $51, $4F, $4D, $4C, $4A, $48, $46, $45, $43
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_PATCH_SET, $11
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $F2
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $F2
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B1
	.byte MCMD_PATCH_SET, $0F
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D1
Track_07_SQ2_02:	; A946

	.byte MCMD_TRACK_CONFIG, $08
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte $76, $76, $74, $76, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $94, $76
	.byte MCMD_SET_1_5X_TIMING
	.byte $A0
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda1 Track_07_SQ2_02
	.byte $76, $76, $74, $76, $60, $76, $74, $76
	.byte MCMD_SET_1_5X_TIMING
	.byte $80
	.byte MCMD_OCTAVE_SET, $02
	.byte $6F, $6D
	.byte MCMD_SET_1_5X_TIMING
	.byte $88
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_07_SQ2_03
	.byte MCMD_TRACK_STOP


Track_07_TRI:
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $04
	.byte $63, $63, $83, $80, $63, $63, $83
	.byte MCMD_SET_1_5X_TIMING
	.byte $A0, $61, $61, $81, $80, $61, $61, $81
	.byte MCMD_SET_1_5X_TIMING
	.byte $A0
	.byte MCMD_OCTAVE_SET, $03
	.byte $6B, $6B, $8B, $80, $6B, $6B, $8B
	.byte MCMD_SET_1_5X_TIMING
	.byte $A0, $6B, $6B, $8B, $80, $6B, $6B, $8B, $80, $6B
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D, $6F, $6F, $8F, $76, $6F, $60, $6F, $60, $6F, $60, $6F, $96, $8F, $6D, $6D, $8D, $74, $6D, $60, $6D, $60, $6D, $60, $6D, $94, $8D, $6B, $6B, $8B, $72, $6B, $60, $6B, $60, $6B, $60, $6B, $92, $8B, $6A, $6A, $8A, $71, $6A, $60, $6A, $60, $6A, $60, $6A, $6A, $6C, $6D, $6E
Track_07_TRI_04:	; A9DA

	.byte MCMD_TRACK_CONFIG, $00
	.byte $6F, $6F, $8F, $76, $6F, $60, $6D, $60, $6D, $60, $6D, $94, $8D, $6B, $6B, $8B, $72, $6B, $60, $6A, $60, $6A, $60, $6A, $91, $8A, $6F, $6F, $8F, $76, $6F, $60, $6D, $60, $6D, $60, $6D, $94, $8D, $6B, $6B, $8B, $72, $6B, $60, $6A, $60, $6A, $60, $6A, $91, $8A, $68, $68, $88, $68, $74, $60, $66, $60, $66, $60, $66, $92, $66, $66, $68, $68, $88, $68, $74, $60, $66, $60, $66, $60, $65, $91, $65, $65, $66, $72, $86, $66, $66, $86, $67, $73, $87, $67, $67, $87, $68, $68, $88, $6F, $68, $60, $69, $60, $69, $60, $6A, $8B, $8C, $6C, $65, $60, $8C, $6C, $65, $6C, $6D, $66, $60, $8D, $6D, $66, $6D, $6E, $6E, $8E, $76, $6E, $60, $6E, $60, $6E, $60, $6E, $8F, $91, $6F, $6F, $8F, $76, $6F, $60, $6F, $60, $6F, $60, $6F, $96, $8F, $6B, $6B, $8B, $72, $6B, $60, $6A, $60, $6A, $60, $6A, $91, $8A, $6B, $6B, $8B, $72, $6B, $60, $6A, $60, $6A, $60, $6A, $91, $8A, $6F, $6F, $8F, $80, $6F, $6F, $8F
	.byte MCMD_SET_1_5X_TIMING
	.byte $A0, $6D, $6D, $8D, $80, $6D, $6D, $8D
	.byte MCMD_SET_1_5X_TIMING
	.byte $A0, $6B, $6B, $8B, $80, $6B, $6B, $8B
	.byte MCMD_SET_1_5X_TIMING
	.byte $A0, $6B, $6B, $8B, $80, $6B, $6B, $8B, $80, $6B
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_07_TRI_04
	.byte MCMD_TRACK_STOP


Track_07_NSE:
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte MCMD_PATCH_SET, $01

Track_07_NSE_05:	; AAB5
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $78
	.byte $6D, $60
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $6D, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $0F
	sda1 Track_07_NSE_05

Track_07_NSE_07:	; AAC3
	.byte MCMD_TRACK_CONFIG, $00

Track_07_NSE_06:	; AAC5
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $78
	.byte $6D, $60
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $6D, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda1 Track_07_NSE_06
	.byte $67, $6D, $6D, $6D
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $03
	sda1 Track_07_NSE_07

Track_07_NSE_0B:	; AADB
	.byte MCMD_TRACK_CONFIG, $00

Track_07_NSE_08:	; AADD
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $78
	.byte $67
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $6D, $6D, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $33
	sda1 Track_07_NSE_08

Track_07_NSE_0A:	; AAEB
	.byte MCMD_TRACK_CONFIG, $00

Track_07_NSE_09:	; AAED
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $78
	.byte $6D, $60
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $6D, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda1 Track_07_NSE_09
	.byte $67, $6D, $6D, $6D
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $03
	sda1 Track_07_NSE_0A
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_07_NSE_0B
	.byte MCMD_TRACK_STOP
