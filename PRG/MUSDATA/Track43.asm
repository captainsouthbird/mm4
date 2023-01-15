	.byte $00	; Music header tag
	sda2 Track_43_SQ1	; Square 1
	sda2 Track_43_SQ2	; Square 2
	sda2 Track_43_TRI	; Triangle
	sda2 Track_43_NSE	; Noise

Track_43_SQ1:
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $02
	.byte MCMD_TEMPO_SET, $02, $49
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_OCTAVE_SET, $01

Track_43_SQ1_02:	; D539
	.byte MCMD_TRACK_CONFIG, $00

Track_43_SQ1_01:	; D53B
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $DB
	.byte MCMD_SET_1_5X_TIMING
	.byte $9E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6A
	.byte MCMD_SET_1_5X_TIMING
	.byte $AD, $6C, $60, $CC
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda2 Track_43_SQ1_00
	.byte $AA
	.byte MCMD_SET_1_5X_TIMING
	.byte $88, $66, $A8, $A5, $A6
	.byte MCMD_SET_1_5X_TIMING
	.byte $85, $63, $85, $63, $60, $62, $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $76, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_43_SQ1_01

Track_43_SQ1_00:	; D562
	.byte $AA
	.byte MCMD_SET_1_5X_TIMING
	.byte $88, $6A, $8C, $6A, $60, $68, $60, $6F, $60, $AF
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D, $6F, $92, $71, $60, $6F, $60, $6D, $60
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_43_SQ1_02
	.byte MCMD_TRACK_STOP


Track_43_SQ2:
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_SET_1_5X_TIMING
	.byte $60
Track_43_SQ2_05:	; D588

	.byte MCMD_TRACK_CONFIG, $00

Track_43_SQ2_04:	; D58A
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $DB
	.byte MCMD_SET_1_5X_TIMING
	.byte $9E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6A
	.byte MCMD_SET_1_5X_TIMING
	.byte $AD, $6C, $60, $CC
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda2 Track_43_SQ2_03
	.byte $AA
	.byte MCMD_SET_1_5X_TIMING
	.byte $88, $66, $A8, $A5, $A6
	.byte MCMD_SET_1_5X_TIMING
	.byte $85, $63, $85, $63, $60, $62, $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $76, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_43_SQ2_04

Track_43_SQ2_03:	; D5B1
	.byte $AA
	.byte MCMD_SET_1_5X_TIMING
	.byte $88, $6A, $8C, $6A, $60, $68, $60, $6F, $60, $AF
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D, $6F, $92, $71, $60, $6F, $60, $6D, $60
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_43_SQ2_05
	.byte MCMD_TRACK_STOP


Track_43_TRI:

Track_43_TRI_0A:	; D5CB
	.byte MCMD_TRACK_CONFIG, $00

Track_43_TRI_09:	; D5CD
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $02

Track_43_TRI_06:	; D5D5
	.byte MCMD_TRACK_CONFIG, $00
	.byte $6F, $60, $6F, $6F
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte $9D
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $6F, $6F
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_43_TRI_06

Track_43_TRI_07:	; D5EA
	.byte MCMD_TRACK_CONFIG, $00
	.byte $74, $60, $74, $74
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte $9D
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $74, $74
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_43_TRI_07
	.byte MCMD_LOOPCNT1_JMPLAST_CFG, $00
	sda2 Track_43_TRI_08
	.byte $72, $60, $72, $72
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte $9D
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $72, $72, $6D, $60, $6D, $6D
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte $9D
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $6D, $6D, $6B, $60, $6B, $6B
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte $9D
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $6B, $6B
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte $60, $9D, $79, $9D, $7D, $7D
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $01
	sda2 Track_43_TRI_09

Track_43_TRI_08:	; D63E
	.byte $72, $60, $72, $72
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte $9D
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $72, $72, $74, $60, $74, $74
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte $9D
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $74, $74, $77, $60, $77, $77
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte $9D
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $77, $77
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte $79, $9D, $79, $9D, $7D, $7D
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_43_TRI_0A
	.byte MCMD_TRACK_STOP


Track_43_NSE:
	.byte MCMD_TRACK_TRANSPOSE_SET, $03
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte MCMD_PATCH_SET, $01

Track_43_NSE_0D:	; D681
	.byte MCMD_TRACK_CONFIG, $00

Track_43_NSE_0C:	; D683
	.byte MCMD_TRACK_CONFIG, $00

Track_43_NSE_0B:	; D685
	.byte MCMD_TRACK_CONFIG, $00
	.byte $66, $60, $66, $66, $6A, $60, $66, $66
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $06
	sda2 Track_43_NSE_0B
	.byte $66, $6D, $6A, $66, $6D, $6A, $66, $6D
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $01
	sda2 Track_43_NSE_0C
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_43_NSE_0D
	.byte MCMD_TRACK_STOP
