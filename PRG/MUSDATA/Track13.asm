	.byte $00	; Music header tag
	sda2 Track_13_SQ1	; Square 1
	sda2 Track_13_SQ2	; Square 2
	sda2 Track_13_TRI	; Triangle
	sda2 Track_13_NSE	; Noise

Track_13_SQ1:

Track_13_SQ1_03:	; C062
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_TEMPO_SET, $02, $2E
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $FC
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte $E0
Track_13_SQ1_02:	; C074

	.byte MCMD_TRACK_CONFIG, $08

Track_13_SQ1_01:	; C076
	.byte MCMD_TRACK_CONFIG, $08
	.byte $8D, $6D, $6D, $8D, $6D, $6D, $8D, $6F
	.byte MCMD_SET_1_5X_TIMING
	.byte $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8B, $CB
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AB
	.byte MCMD_PATCH_SET, $0D
	.byte $8B
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda2 Track_13_SQ1_00
	.byte $A9, $89, $86, $80, $86, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A8, $88, $89
	.byte MCMD_SET_1_5X_TIMING
	.byte $AB
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_13_SQ1_01

Track_13_SQ1_00:	; C0A4
	.byte $A9, $89, $8B, $80, $8B, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D, $CD
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $01
	sda2 Track_13_SQ1_02
	.byte MCMD_NOTEATTACKLEN_SET, $B4
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte $80, $8D, $88, $85, $91, $8D, $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $94
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $94, $92, $91, $8F, $91, $92, $80, $8B, $80, $8B, $86, $83, $AF, $8B, $88, $6B, $6A, $66, $6F, $6B, $66, $72, $71
	.byte MCMD_SET_1_5X_TIMING
	.byte $AF, $80, $80, $6A, $6D, $6A, $65, $81, $6A, $6D, $6A, $65, $81, $6A, $6D, $75, $76, $75, $76, $75, $76, $75, $71, $AD, $A0
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $84, $89, $8D, $89, $8D, $90, $8D, $90
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D5
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $B5
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte $B5
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $B5
	.byte MCMD_SYNTH_VOLUME_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B5
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte $8D, $6D, $6D, $8D, $6D, $6D, $8D, $6F
	.byte MCMD_SET_1_5X_TIMING
	.byte $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8B
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_SET_1_5X_TIMING
	.byte $CB
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8B, $8B, $A9, $89, $86, $80, $86, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A8, $88, $89
	.byte MCMD_SET_1_5X_TIMING
	.byte $AB, $8D, $6D, $6D, $8D, $6D, $6D, $8D, $6F
	.byte MCMD_SET_1_5X_TIMING
	.byte $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8B
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_SET_1_5X_TIMING
	.byte $CB
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8B
	.byte MCMD_PATCH_SET, $0D
	.byte $8B, $88, $88, $86, $88, $80, $85, $86, $88, $80, $85, $86, $88, $80, $85, $86, $88
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_13_SQ1_03
	.byte MCMD_TRACK_STOP


Track_13_SQ2:

Track_13_SQ2_07:	; C166
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte $E0
Track_13_SQ2_06:	; C173

	.byte MCMD_TRACK_CONFIG, $08

Track_13_SQ2_05:	; C175
	.byte MCMD_TRACK_CONFIG, $08
	.byte $88, $68, $68, $88, $68, $68, $88, $6A
	.byte MCMD_SET_1_5X_TIMING
	.byte $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $86, $C6
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A6
	.byte MCMD_PATCH_SET, $0D
	.byte $86
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda2 Track_13_SQ2_04
	.byte $A4, $84, $81, $80, $83, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $85
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A5, $85, $86
	.byte MCMD_SET_1_5X_TIMING
	.byte $A8
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_13_SQ2_05

Track_13_SQ2_04:	; C1A3
	.byte $A4, $84, $81, $80, $83, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $85, $C5
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C5
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $01
	sda2 Track_13_SQ2_06
	.byte MCMD_SET_1_5X_TIMING
	.byte $60
	.byte MCMD_NOTEATTACKLEN_SET, $B4
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_FREQFINEOFFSET_SET, $FF
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $80, $8D, $88, $85, $91, $8D, $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $94
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $94, $92, $91, $8F, $91, $92, $80, $8B, $80, $8B, $86, $83, $AF, $8B, $88, $6B, $6A, $66, $6F, $6B, $66, $72, $71
	.byte MCMD_SET_1_5X_TIMING
	.byte $AF, $80, $80, $6A, $6D, $6A, $65, $81, $6A, $6D, $6A, $65, $81, $6A, $6D, $75, $76, $75, $76, $75, $76, $75, $71, $AD, $A0
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $84, $89, $8D, $89, $8D, $90, $8D, $90
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D5
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $B5
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte $B5
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $B5
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $95
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $55
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_FREQFINEOFFSET_SET, $00
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte $88, $68, $68, $88, $68, $68, $88, $6A
	.byte MCMD_SET_1_5X_TIMING
	.byte $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $86
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_SET_1_5X_TIMING
	.byte $C6
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $86, $86, $A4, $84, $81, $80, $83, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $85
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A5, $85, $86
	.byte MCMD_SET_1_5X_TIMING
	.byte $A8, $88, $68, $68, $88, $68, $68, $88, $6A
	.byte MCMD_SET_1_5X_TIMING
	.byte $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $86
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_SET_1_5X_TIMING
	.byte $C6
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $86
	.byte MCMD_PATCH_SET, $0D
	.byte $86
	.byte MCMD_FREQFINEOFFSET_SET, $01
	.byte $88, $88, $86, $88, $80, $88, $8B, $8D, $80, $88, $8B, $8D, $80, $88, $8B, $8D
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_13_SQ2_07
	.byte MCMD_TRACK_STOP


Track_13_TRI:

Track_13_TRI_0D:	; C26E
	.byte MCMD_TRACK_CONFIG, $08
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_OCTAVE_SET, $02
	.byte $A8, $88, $6D, $6D, $6D, $6A, $6A, $6A, $68, $68, $66, $65
	.byte MCMD_OCTAVE_SET, $04
	.byte MCMD_PATCH_SET, $00

Track_13_TRI_08:	; C286
	.byte MCMD_TRACK_CONFIG, $00
	.byte $81, $61, $61
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $17
	sda2 Track_13_TRI_08
	.byte $81, $61, $61, $81, $83, $63, $63, $83, $83
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $81
Track_13_TRI_09:	; C29A

	.byte MCMD_TRACK_CONFIG, $00
	.byte $81, $61, $61
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $1C
	sda2 Track_13_TRI_09
	.byte $81, $83, $83, $63, $63, $83
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $85
Track_13_TRI_0A:	; C2AB

	.byte MCMD_TRACK_CONFIG, $00
	.byte $85, $65, $65
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda2 Track_13_TRI_0A
	.byte $81, $80
	.byte MCMD_NOTEATTACKLEN_SET, $AA
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_OCTAVE_SET, $03
	.byte $B4, $A0, $B1, $A0, $B4, $80
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $AD, $8B, $80
	.byte MCMD_NOTEATTACKLEN_SET, $AA
	.byte MCMD_PATCH_SET, $04
	.byte $B4, $A0, $B1, $A0, $B4, $80
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $AB, $8A, $80
	.byte MCMD_NOTEATTACKLEN_SET, $AA
	.byte MCMD_PATCH_SET, $04
	.byte $B4, $A0, $B1, $A0, $B4, $80
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $AA
Track_13_TRI_0B:	; C2E6

	.byte MCMD_TRACK_CONFIG, $00
	.byte $89, $69, $69
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $05
	sda2 Track_13_TRI_0B
	.byte $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $AB
Track_13_TRI_0C:	; C2F2

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $8D, $6D, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $17
	sda2 Track_13_TRI_0C
	.byte $8D, $8D, $8D, $8D, $80, $8D, $8D, $8D, $80, $8D, $8D, $8D, $80, $8D, $8D, $8D
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_13_TRI_0D
	.byte MCMD_TRACK_STOP


Track_13_NSE:

Track_13_NSE_13:	; C311
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_PATCH_SET, $01
	.byte MCMD_OCTAVE_SET, $02
	.byte $6D, $80, $60, $6D, $60
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $6A, $6A, $6A, $68, $68, $68, $67, $67, $65, $67
Track_13_NSE_0E:	; C32C

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte $65, $60, $80, $67, $60, $80, $65, $60, $65, $60, $67, $60, $67, $60, $80, $65, $60, $67, $60, $80, $65, $65, $65, $65, $67, $80, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda2 Track_13_NSE_0E

Track_13_NSE_0F:	; C351
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte MCMD_NOTEATTACKLEN_SET, $8C
	.byte $6D, $60
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $6D, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $17
	sda2 Track_13_NSE_0F
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $6D, $60, $6D, $6D, $68, $60, $65, $68, $65, $65, $65, $60, $68, $60, $65, $68, $65, $65, $6A, $6A, $6A, $66, $66, $66, $65, $60, $65, $80, $65, $65, $66
Track_13_NSE_10:	; C386

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte $65, $80, $60, $67, $80, $60, $65, $60, $65, $60, $67, $60, $67, $60, $80, $65, $60, $67, $60, $80, $65, $65, $65, $65, $67, $60, $80
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda2 Track_13_NSE_10
	.byte $65, $60, $6D, $60, $67, $60, $6D, $60
Track_13_NSE_11:	; C3B1

	.byte MCMD_TRACK_CONFIG, $00
	.byte $67, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda2 Track_13_NSE_11

Track_13_NSE_12:	; C3B9
	.byte MCMD_TRACK_CONFIG, $00
	.byte $67, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda2 Track_13_NSE_12
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_13_NSE_13
	.byte MCMD_TRACK_STOP
