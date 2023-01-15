	.byte $00	; Music header tag
	sda1 Track_01_SQ1	; Square 1
	sda1 Track_01_SQ2	; Square 2
	sda1 Track_01_TRI	; Triangle
	sda1 Track_01_NSE	; Noise

Track_01_SQ1:
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $03
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_OCTAVE_SET, $01
	.byte $7E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $69, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $8B, $6D, $60
	.byte MCMD_TEMPO_SET, $01, $55
	.byte $B0, $B1
	.byte MCMD_TEMPO_SET, $01, $EB
	.byte $B2
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0
	.byte MCMD_PATCH_SET, $08
	.byte MCMD_NOTEATTACKLEN_SET, $96
	.byte $A0, $72, $72, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $90, $6D, $60, $6D, $60, $90, $72, $70, $60, $72
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0, $E0
Track_01_SQ1_04:	; 90B1

	.byte MCMD_TRACK_CONFIG, $00

Track_01_SQ1_01:	; 90B3
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $AA
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_PATCH_SET, $08
	.byte MCMD_SET_1_5X_TIMING
	.byte $BE, $7C, $7E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $69, $60, $68, $60, $66, $60, $64, $60, $61, $64, $60, $66
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0
	.byte MCMD_SET_1_5X_TIMING
	.byte $AB, $69, $6B, $6D, $60, $6B, $60, $69, $60, $64, $60
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda1 Track_01_SQ1_00
	.byte $66, $64, $80, $C6, $A0
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_01_SQ1_01

Track_01_SQ1_00:	; 90E7
	.byte $66, $64, $A0, $C6, $80
Track_01_SQ1_03:	; 90EC

	.byte MCMD_TRACK_CONFIG, $08
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_NOTEATTACKLEN_SET, $B4
	.byte MCMD_PATCH_SET, $0B
	.byte MCMD_SET_1_5X_TIMING
	.byte $AD, $6B, $6D, $70, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $B0
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda1 Track_01_SQ1_02
	.byte $51
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B2
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $72, $70, $72, $75, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $B2
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_01_SQ1_03

Track_01_SQ1_02:	; 9110
	.byte $92, $70, $72, $75, $60, $B2, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $92, $72
	.byte MCMD_SET_1_5X_TIMING
	.byte $B2, $8D
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $8B, $89, $88, $86, $88, $89
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $CC, $CB, $89
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $90, $72, $70, $6D, $6B, $6D, $64, $60, $86, $89, $68, $60, $64, $66, $60, $6B, $6D, $6D, $70, $6B, $6D, $6D, $70, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $92, $70, $72, $60, $75, $70, $60, $72, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $98, $77, $74, $70, $6D, $90, $2D, $2C, $2A, $28
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_01_SQ1_04
	.byte MCMD_TRACK_STOP


Track_01_SQ2:
	.byte MCMD_FREQFINEOFFSET_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $0A
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $AD, $AB, $A8, $A4
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $08
	.byte $B2
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0
	.byte MCMD_NOTEATTACKLEN_SET, $96
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte $A0, $69, $69, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $88, $64, $60, $64, $60, $88, $69, $68, $60, $69, $80, $80, $80, $80, $80, $80, $E0
Track_01_SQ2_09:	; 9195

	.byte MCMD_TRACK_CONFIG, $08

Track_01_SQ2_06:	; 9197
	.byte MCMD_TRACK_CONFIG, $08
	.byte MCMD_NOTEATTACKLEN_SET, $AA
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_PATCH_SET, $08
	.byte MCMD_SET_1_5X_TIMING
	.byte $A9, $68, $69, $6D, $60, $6B, $60, $69, $60, $68, $60, $64, $68, $60, $69
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0
	.byte MCMD_SET_1_5X_TIMING
	.byte $AF, $6D, $6F, $70, $60, $6F, $60, $6D, $60, $68, $60
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda1 Track_01_SQ2_05
	.byte $69, $68, $80, $C9, $A0
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_01_SQ2_06

Track_01_SQ2_05:	; 91CA
	.byte $69, $68, $A0, $CA, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $40
Track_01_SQ2_08:	; 91D1

	.byte MCMD_TRACK_CONFIG, $08
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_NOTEATTACKLEN_SET, $B4
	.byte MCMD_PATCH_SET, $0B
	.byte MCMD_SET_1_5X_TIMING
	.byte $AD, $6B, $6D, $70, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $B0
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda1 Track_01_SQ2_07
	.byte $51
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B2
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $72, $70, $72, $75, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $B2
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_01_SQ2_08

Track_01_SQ2_07:	; 91F5
	.byte $92, $70, $72, $75, $60, $B2, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $92, $72
	.byte MCMD_SET_1_5X_TIMING
	.byte $B2, $8D
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $8B, $89, $88, $86, $88, $89
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $CC, $CB, $69, $80, $C0, $80, $20
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_OCTAVE_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_PATCH_SET, $0C
	.byte $90, $72, $70, $6D, $6B, $6D, $64, $60, $86, $89, $68, $60, $64, $66, $60, $6B, $6D, $6D, $70, $6B, $6D, $6D, $70, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $92, $70, $72, $60, $75, $70, $60, $72, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $98, $77, $74, $70, $6D, $90, $2D, $2C, $2A, $28
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_01_SQ2_09
	.byte MCMD_TRACK_STOP


Track_01_TRI:
	.byte MCMD_TRACK_TRANSPOSE_SET, $FD
	.byte MCMD_TRACK_TRANSPOSE_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_OCTAVE_SET, $03
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0, $7D, $7D, $74, $74
Track_01_TRI_0A:	; 925C

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_TRACK_TRANSPOSE_SET, $00
	.byte MCMD_OCTAVE_SET, $03
	.byte MCMD_PATCH_SET, $00
	.byte $86, $6A, $66, $6B, $66, $60, $8C, $8C, $6C, $6D, $61, $62, $61
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_01_TRI_0A

Track_01_TRI_0F:	; 9275
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_OCTAVE_SET, $03
	.byte MCMD_PATCH_SET, $00

Track_01_TRI_0C:	; 927B
	.byte MCMD_TRACK_CONFIG, $00

Track_01_TRI_0B:	; 927D
	.byte MCMD_TRACK_CONFIG, $00
	.byte $86, $6A, $66, $6B, $66, $60, $8C, $8C, $6C, $6D, $61, $62, $61
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_01_TRI_0B
	.byte $88, $6B, $68, $6D, $68, $60, $8E, $8E, $6D, $6B, $63, $64, $65, $6B, $69, $68, $64, $61, $64, $66, $68, $60, $A6, $61, $61, $61
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $01
	sda1 Track_01_TRI_0C
	.byte MCMD_NOTEATTACKLEN_SET, $DC

Track_01_TRI_0E:	; 92B0
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $81, $68, $80, $8B, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $AC
	.byte MCMD_SET_1_5X_TIMING
	.byte $86, $69, $80, $8C, $80
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $00
	sda1 Track_01_TRI_0D
	.byte MCMD_SET_1_5X_TIMING
	.byte $AD
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_01_TRI_0E

Track_01_TRI_0D:	; 92CA
	.byte MCMD_SET_1_5X_TIMING
	.byte $A4, $C6, $C5, $C4, $C3, $86, $6A, $66, $6B, $66, $60, $8C, $8C, $6C, $6D, $63, $64, $65, $92
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0, $80
	.byte MCMD_OCTAVE_SET, $02
	.byte $8D, $6D, $6D
	.byte MCMD_PATCH_SET, $04
	.byte $99
	.byte MCMD_PATCH_SET, $00
	.byte $6D, $6D, $90, $70, $70
	.byte MCMD_PATCH_SET, $04
	.byte $99
	.byte MCMD_PATCH_SET, $00
	.byte $70, $70, $93, $73, $73
	.byte MCMD_PATCH_SET, $04
	.byte $99
	.byte MCMD_PATCH_SET, $00
	.byte $73, $73
	.byte MCMD_PATCH_SET, $04
	.byte $79, $79, $99, $79, $79, $99
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_01_TRI_0F
	.byte MCMD_TRACK_STOP


Track_01_NSE:
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte MCMD_PATCH_SET, $02
	.byte $AD, $AD, $AD
	.byte MCMD_PATCH_SET, $01
	.byte $66, $60, $66, $66
Track_01_NSE_11:	; 931C

	.byte MCMD_TRACK_CONFIG, $00
	.byte $6C
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $6D, $6D, $6C
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $66, $6C
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $6D, $6D, $6D, $6D, $6D, $6D
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $00
	sda1 Track_01_NSE_10
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $66, $6C, $6C, $6C
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_01_NSE_11

Track_01_NSE_10:	; 933E
	.byte $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $66
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $6D, $6D
Track_01_NSE_19:	; 9346

	.byte MCMD_TRACK_CONFIG, $00

Track_01_NSE_14:	; 9348
	.byte MCMD_TRACK_CONFIG, $00

Track_01_NSE_12:	; 934A
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_PATCH_SET, $01
	.byte MCMD_NOTEATTACKLEN_SET, $B4
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $6C, $6D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $66, $6C
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $6D, $6D, $6D, $6D, $6C, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $66
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $6D, $6D, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda1 Track_01_NSE_12

Track_01_NSE_13:	; 936E
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $8D
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte $6D, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda1 Track_01_NSE_13
	.byte $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $66
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $66
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $01
	sda1 Track_01_NSE_14

Track_01_NSE_16:	; 9389
	.byte MCMD_TRACK_CONFIG, $00

Track_01_NSE_15:	; 938B
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $8D
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte $6D, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $05
	sda1 Track_01_NSE_15
	.byte $6C, $6D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $66
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $6D, $6D, $6D
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $01
	sda1 Track_01_NSE_16

Track_01_NSE_18:	; 93A8
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $96
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $6C, $6D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $66
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $6D, $6D, $6D
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $00
	sda1 Track_01_NSE_17
	.byte $6C, $6D, $6D, $6D, $66, $6D, $6D, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $05
	sda1 Track_01_NSE_18

Track_01_NSE_17:	; 93CA
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte MCMD_PATCH_SET, $02
	.byte $8D, $6D, $6D, $6D, $6D, $6D, $6D
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_01_NSE_19
	.byte MCMD_TRACK_STOP
