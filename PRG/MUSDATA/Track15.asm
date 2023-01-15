	.byte $00	; Music header tag
	sda2 Track_15_SQ1	; Square 1
	sda2 Track_15_SQ2	; Square 2
	sda2 Track_15_TRI	; Triangle
	sda2 Track_15_NSE	; Noise

Track_15_SQ1:

Track_15_SQ1_03:	; C492
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_TEMPO_SET, $02, $00
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $FD
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0D
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte $5B
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $5C
	.byte MCMD_FREQOFFSET_SET, $64
	.byte MCMD_SET_1_5X_TIMING
	.byte $DD
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $9D
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $AF, $AD, $AC, $AD, $CC, $A5, $A8, $EA
Track_15_SQ1_00:	; C4BC

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $0F
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte MCMD_PATCH_SET, $1B
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte $A0
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $91, $8F, $8D, $8F, $80, $8C, $AD, $8F, $8D, $80, $8C, $AD, $EC, $E0, $80, $86, $88, $8A, $8C, $8D, $80, $8A, $80, $86, $88, $8A, $8C, $8D, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8C
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AC, $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CA
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8A, $E0
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_15_SQ1_00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte $A0, $B6, $B4, $B2
	.byte MCMD_SET_1_5X_TIMING
	.byte $B1
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CA
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8A, $A0, $B6, $B4, $B2, $D6
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $AF, $B1, $B2
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $B2
	.byte MCMD_SET_1_5X_TIMING
	.byte $B2, $94, $92, $D1
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $B1, $B2, $B1
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $D2, $D3, $D4
	.byte MCMD_OCTAVE_SET, $02
	.byte $CD
Track_15_SQ1_02:	; C521

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $91, $8D, $80, $8A, $8D, $80, $8F, $B1, $B1, $8F, $8D, $88, $8A
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda2 Track_15_SQ1_01
	.byte $80, $8F, $8D, $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $96, $99, $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $8C, $8D, $80, $83, $81, $91, $8F, $8D, $8A
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_15_SQ1_02

Track_15_SQ1_01:	; C550
	.byte $80, $8F, $8D, $80, $83, $85, $80, $88, $8A, $80, $8F, $8D, $91, $8F, $8D, $8A
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_15_SQ1_03
	.byte MCMD_TRACK_STOP


Track_15_SQ2:

Track_15_SQ2_0B:	; C564
	.byte MCMD_TRACK_CONFIG, $08
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $00
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte $6D, $6D, $6A, $60, $6D, $60, $6A, $6D, $60, $6D, $6A, $60, $6D, $60, $6A, $60
Track_15_SQ2_04:	; C580

	.byte MCMD_TRACK_CONFIG, $08
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $6A, $6D, $6A, $60, $6D, $60, $6A, $6D, $60, $6D, $6A, $60, $6D, $60, $6A, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda2 Track_15_SQ2_04

Track_15_SQ2_05:	; C598
	.byte MCMD_TRACK_CONFIG, $08
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte $6D, $60, $6A, $6D, $60, $6A, $6D, $71, $6A, $60, $71, $6A, $6D, $71, $6A, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda2 Track_15_SQ2_05

Track_15_SQ2_06:	; C5B0
	.byte MCMD_TRACK_CONFIG, $08
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte $6D, $60, $6A, $6D, $60, $6A, $6D, $71, $6A, $60, $71, $6A, $6D, $71, $6A, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $06
	sda2 Track_15_SQ2_06
	.byte $6D, $60, $6A, $6D, $60, $6A, $6D, $71, $6A
	.byte MCMD_PATCH_SET, $17
	.byte $6C, $6D, $6F, $71, $72, $74, $76, $6A, $6A, $66, $60, $6A, $60, $66, $6A, $60, $6A, $66, $60, $6A, $60, $66, $60, $68, $68, $65, $60, $68, $60, $65, $68, $60, $68, $65, $60, $68, $60, $65, $60
Track_15_SQ2_07:	; C5FE

	.byte MCMD_TRACK_CONFIG, $08
	.byte $6A, $6A, $66, $60, $6A, $60, $66, $6A, $60, $6A, $66, $60, $6A, $60, $66, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda2 Track_15_SQ2_07
	.byte $68, $68, $65, $60, $68, $60, $65, $68, $60, $68, $65, $60, $68, $60, $65, $60, $63, $60, $63, $63, $60, $63, $63, $60, $64, $60, $64, $64, $60, $64, $64, $60, $65, $60, $65, $65, $60, $65, $65, $60, $68, $60, $68, $68, $60, $68, $68, $60, $6D, $6D, $6A, $60, $6D, $60, $6A, $6D, $60, $6D, $6A, $60, $6D, $60, $6A, $60
Track_15_SQ2_08:	; C654

	.byte MCMD_TRACK_CONFIG, $08
	.byte $6A, $6D, $6A, $60, $6D, $60, $6A, $6D, $60, $6D, $6A, $60, $6D, $60, $6A, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda2 Track_15_SQ2_08
	.byte $6D, $6D
	.byte MCMD_OCTAVE_SET, $01
	.byte $6D, $60, $6A, $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6A, $6D, $7D, $6D
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68
	.byte MCMD_OCTAVE_SET, $02
	.byte $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6D, $60, $6A, $60, $99, $6A, $60, $99, $6A, $6D, $78, $6D, $96, $94, $96
Track_15_SQ2_0A:	; C68C

	.byte MCMD_TRACK_CONFIG, $00
	.byte $6A, $6D, $6A, $60, $6D, $60, $6A, $6D
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $00
	sda2 Track_15_SQ2_09
	.byte $60, $6D, $6A, $60, $6D, $60, $6A, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_15_SQ2_0A

Track_15_SQ2_09:	; C6A6
	.byte $99, $98, $96, $91
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_15_SQ2_0B
	.byte MCMD_TRACK_STOP


Track_15_TRI:

Track_15_TRI_16:	; C6AE
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $03
	.byte $8A, $68, $6A, $60, $65, $68, $6A
	.byte MCMD_SET_1_5X_TIMING
	.byte $80, $6A, $60, $6F, $6D, $68, $86, $66, $66, $60, $66, $66, $60, $61, $68, $66, $65, $66, $65, $81, $83, $63, $63, $60, $61, $83
	.byte MCMD_OCTAVE_SET, $02
	.byte $88, $68, $68, $89, $69, $69
	.byte MCMD_OCTAVE_SET, $03
	.byte $8A, $6A, $6A, $60, $68, $8A, $6A, $71, $6F, $6D, $6F, $6D, $6A, $68
Track_15_TRI_12:	; C6F0

	.byte MCMD_TRACK_CONFIG, $00

Track_15_TRI_0C:	; C6F2
	.byte MCMD_TRACK_CONFIG, $00
	.byte $8A, $6A, $6A
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda2 Track_15_TRI_0C

Track_15_TRI_0D:	; C6FB
	.byte MCMD_TRACK_CONFIG, $00
	.byte $88, $68, $68
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda2 Track_15_TRI_0D

Track_15_TRI_0E:	; C704
	.byte MCMD_TRACK_CONFIG, $00
	.byte $86, $66, $66
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda2 Track_15_TRI_0E

Track_15_TRI_0F:	; C70D
	.byte MCMD_TRACK_CONFIG, $00
	.byte $88, $68, $68
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda2 Track_15_TRI_0F

Track_15_TRI_10:	; C716
	.byte MCMD_TRACK_CONFIG, $00
	.byte $8A, $6A, $6A
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $05
	sda2 Track_15_TRI_10
	.byte MCMD_LOOPCNT1_JMPLAST_CFG, $00
	sda2 Track_15_TRI_11
	.byte $8A, $6A
	.byte MCMD_PATCH_SET, $04
	.byte $76, $74, $72, $6F, $68
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $01
	sda2 Track_15_TRI_12

Track_15_TRI_11:	; C732
	.byte $6A, $76, $74, $72, $66, $68, $69, $6A
Track_15_TRI_13:	; C73A

	.byte MCMD_TRACK_CONFIG, $00
	.byte $8B, $6B, $6B
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda2 Track_15_TRI_13
	.byte $8A, $6A, $6A, $8A, $6A, $6A, $60, $6A, $8A, $60, $8A, $6A
Track_15_TRI_14:	; C74F

	.byte MCMD_TRACK_CONFIG, $00
	.byte $8B, $6B, $6B
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda2 Track_15_TRI_14
	.byte $8F, $8F, $8F, $6D, $6F, $60, $6F, $60, $6F, $6F, $8D, $6D
Track_15_TRI_15:	; C764

	.byte MCMD_TRACK_CONFIG, $00
	.byte $8B, $6B, $6B
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda2 Track_15_TRI_15
	.byte $8A, $6A, $6A, $8A, $6A, $6A, $60, $6A, $8A, $60, $8A, $6A, $8B, $6B, $6B, $8B, $6B, $6B, $8C, $6C, $6C, $8C, $6C, $6C, $8D, $6D, $6D, $8D, $6D, $6D, $8E, $6E, $6E, $6E, $65, $66, $68, $8A, $68, $6A, $60, $65, $68, $6A
	.byte MCMD_SET_1_5X_TIMING
	.byte $80, $6A, $60, $6F, $6D, $68, $86, $66, $66, $60, $66, $66, $60, $6D, $74, $72, $71, $72, $71, $8D, $8F, $6F, $6F, $60, $6D, $8F, $88, $68, $68, $89, $69, $69, $8A, $6A, $6A, $60, $68, $8A, $91, $71, $8F, $6D, $8A, $8A, $68, $6A, $60, $65, $68, $6A
	.byte MCMD_SET_1_5X_TIMING
	.byte $80, $6A, $60, $6F, $6D, $68, $86, $66, $66, $60, $66, $66, $60, $6D, $74, $72, $71, $72, $71, $8D, $8F, $6F, $6F, $60, $6D, $8F, $88, $68, $68, $89, $69, $69, $8A, $6A, $6A, $60, $68, $8A, $91, $71, $8F, $6D, $8A
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_15_TRI_16
	.byte MCMD_TRACK_STOP


Track_15_NSE:

Track_15_NSE_18:	; C7FC
	.byte MCMD_TRACK_CONFIG, $00

Track_15_NSE_17:	; C7FE
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $F0
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_PATCH_SET, $01
	.byte $6D, $6D, $6D, $6D
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte $86
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $6D, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $06
	sda2 Track_15_NSE_17
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_15_NSE_18
	.byte MCMD_TRACK_STOP
