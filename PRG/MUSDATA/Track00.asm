	.byte $00	; Music header tag
	sda1 Track_00_SQ1	; Square 1
	sda1 Track_00_SQ2	; Square 2
	sda1 Track_00_TRI	; Triangle
	sda1 Track_00_NSE	; Noise

Track_00_SQ1:
	.byte MCMD_TEMPO_SET, $01, $EB
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $FD
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $E0, $E0
Track_00_SQ1_02:	; 8D1B

	.byte MCMD_TRACK_CONFIG, $00

Track_00_SQ1_01:	; 8D1D
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_NOTEATTACKLEN_SET, $AA
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte $BB, $7B, $7D, $60
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $BE
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $7E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $A8, $65, $63, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $81, $71, $6F, $60, $AD
	.byte MCMD_SET_1_5X_TIMING
	.byte $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $77, $79, $60
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $BB
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $7B
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $00
	sda1 Track_00_SQ1_00
	.byte $79, $7B, $60, $BD, $79, $7B, $60, $7E, $60, $7D, $60, $79, $7B, $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6F, $60, $8F, $6D, $71, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_00_SQ1_01

Track_00_SQ1_00:	; 8D63
	.byte $7E, $7D, $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $A8, $69, $6A, $60, $6A, $80, $6D, $60, $6E, $AF, $A0
	.byte MCMD_TRACK_TRANSPOSE_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_SYNTH_VOLUME_SET, $0E
	.byte MCMD_PATCH_SET, $07
	.byte $A0
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $B1
	.byte MCMD_SET_1_5X_TIMING
	.byte $8C
	.byte MCMD_SET_1_5X_TIMING
	.byte $91, $9A
	.byte MCMD_SET_1_5X_TIMING
	.byte $B8, $B6, $B5, $96
	.byte MCMD_SET_1_5X_TIMING
	.byte $B8
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D1
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $91
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $03
	.byte $B1, $B3, $B4, $B6
	.byte MCMD_SYNTH_VOLUME_SET, $0E
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_PATCH_SET, $07
	.byte $94, $80, $B4
	.byte MCMD_SET_1_5X_TIMING
	.byte $8F
	.byte MCMD_SET_1_5X_TIMING
	.byte $94, $9B
	.byte MCMD_SET_1_5X_TIMING
	.byte $BA
	.byte MCMD_SET_1_5X_TIMING
	.byte $B8, $B6, $D9, $B6, $BD
	.byte MCMD_SET_1_5X_TIMING
	.byte $B8, $80, $B8, $BA, $BB, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $94
	.byte MCMD_SET_1_5X_TIMING
	.byte $9B, $7B, $60, $7D, $60, $BD, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $96
	.byte MCMD_SET_1_5X_TIMING
	.byte $9A, $7B, $60, $7D, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $DD
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $9D, $98
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $CC
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AC
	.byte MCMD_TRACK_TRANSPOSE_SET, $02
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_00_SQ1_02
	.byte MCMD_TRACK_STOP


Track_00_SQ2:
	.byte MCMD_FREQFINEOFFSET_SET, $FF
	.byte $E0, $E0
Track_00_SQ2_06:	; 8DE0

	.byte MCMD_TRACK_CONFIG, $00

Track_00_SQ2_04:	; 8DE2
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_PATCH_SET, $02
	.byte $FE
	.byte MCMD_SET_1_5X_TIMING
	.byte $BD
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $74, $72, $60, $B1
	.byte MCMD_SET_1_5X_TIMING
	.byte $80
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte $C3, $C5
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda1 Track_00_SQ2_03
	.byte $86, $A0, $86, $60
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte $72, $60, $92, $71, $74, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_00_SQ2_04

Track_00_SQ2_03:	; 8E12
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte $66, $66
	.byte MCMD_SET_1_5X_TIMING
	.byte $80, $67, $60, $67, $A0, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $87
	.byte MCMD_TRACK_TRANSPOSE_SET, $00
	.byte MCMD_PATCH_SET, $05
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C9
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $69
	.byte MCMD_SET_1_5X_TIMING
	.byte $89
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C7
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $67
	.byte MCMD_SET_1_5X_TIMING
	.byte $87
Track_00_SQ2_05:	; 8E33

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte $80, $7D, $60, $7D
	.byte MCMD_SET_1_5X_TIMING
	.byte $9F
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_00_SQ2_05
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $A8, $AA, $AC, $AD
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CF
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6F
	.byte MCMD_SET_1_5X_TIMING
	.byte $8F
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CE
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6E
	.byte MCMD_SET_1_5X_TIMING
	.byte $8E
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CA
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6A
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $8C, $6C, $60, $6E, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $8C, $6C, $60, $6E, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CC
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6C
	.byte MCMD_SET_1_5X_TIMING
	.byte $8C
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CE
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6E
	.byte MCMD_SET_1_5X_TIMING
	.byte $8E
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CC
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6C
	.byte MCMD_SET_1_5X_TIMING
	.byte $91
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_SET_1_5X_TIMING
	.byte $93, $73, $A0, $73, $73
	.byte MCMD_SET_1_5X_TIMING
	.byte $A0
	.byte MCMD_TRACK_TRANSPOSE_SET, $02
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_00_SQ2_06
	.byte MCMD_TRACK_STOP


Track_00_TRI:
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $02
	.byte $A0
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6D, $6D, $6D, $6D, $68, $68, $68, $68, $63, $63, $60, $63
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $03
	.byte $60, $61, $63, $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6D, $6E, $60, $74, $73, $6F, $6D, $6F, $6A, $76, $7A, $7B
Track_00_TRI_0B:	; 8EBA

	.byte MCMD_TRACK_CONFIG, $00

Track_00_TRI_08:	; 8EBC
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte $6F, $60, $6F, $60, $96, $6F, $6F, $60, $6F, $60, $6F, $96, $8F, $6D, $60, $6D, $60, $94, $6D, $6D, $60, $6D, $60, $6D, $94, $8D, $6B, $60, $6B, $60, $92, $6B, $6B, $60, $6C, $60, $6D, $94, $91
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $00
	sda1 Track_00_TRI_07
	.byte $72, $60, $76, $60, $94, $71, $72, $60, $6F, $60, $6F, $60, $6F, $6F, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_00_TRI_08

Track_00_TRI_07:	; 8EFE
	.byte $6F, $60, $72, $80, $71, $60, $71, $B3
	.byte MCMD_PATCH_SET, $04
	.byte $9D, $60, $75
Track_00_TRI_09:	; 8F0B

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_TRACK_TRANSPOSE_SET, $00
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $91, $71, $60, $71, $80, $71, $7B, $7D, $60, $7B, $7D, $60, $6F
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_00_TRI_09

Track_00_TRI_0A:	; 8F23
	.byte MCMD_TRACK_CONFIG, $00
	.byte $8D, $60, $6D, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $8F
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda1 Track_00_TRI_0A
	.byte $68, $71, $70, $71, $73, $94, $68
	.byte MCMD_SET_1_5X_TIMING
	.byte $94, $74, $60, $74, $80, $74, $7E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68, $60, $66, $68, $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $72
	.byte MCMD_SET_1_5X_TIMING
	.byte $93, $73, $60, $73, $80, $73, $7D, $7F, $60, $7D, $7F, $60, $73
	.byte MCMD_SET_1_5X_TIMING
	.byte $8A, $6A, $60, $6A, $80, $6A, $74, $76, $60, $74, $76, $60, $6A
	.byte MCMD_SET_1_5X_TIMING
	.byte $91, $71, $60, $71, $80, $71, $7B, $7D, $60, $7B, $7D, $60, $6F
	.byte MCMD_SET_1_5X_TIMING
	.byte $94, $74, $60, $74, $80, $74, $7E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68, $60, $66, $68, $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $72
	.byte MCMD_SET_1_5X_TIMING
	.byte $96, $76, $60, $76, $80, $76
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68, $6A, $60, $68, $6A, $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $76
	.byte MCMD_SET_1_5X_TIMING
	.byte $8C, $6C, $60, $6C, $80, $6C, $76, $78, $60, $76, $78, $60, $6C
	.byte MCMD_SET_1_5X_TIMING
	.byte $8C, $78, $A0, $60, $77, $78, $6C, $6D, $6E, $6F, $71
	.byte MCMD_TRACK_TRANSPOSE_SET, $02
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_00_TRI_0B
	.byte MCMD_TRACK_STOP


Track_00_NSE:
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte MCMD_PATCH_SET, $01
	.byte $E0
	.byte MCMD_NOTEATTACKLEN_SET, $B4
	.byte $AA, $AA, $AA
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $68, $68, $68, $68
Track_00_NSE_14:	; 8FC0

	.byte MCMD_TRACK_CONFIG, $00

Track_00_NSE_0F:	; 8FC2
	.byte MCMD_TRACK_CONFIG, $00

Track_00_NSE_0D:	; 8FC4
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $6D, $6D, $6D, $6D
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $8D
Track_00_NSE_0C:	; 8FD3

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $96
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte $6D
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $68
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda1 Track_00_NSE_0C
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $86
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $6D, $6D
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $02
	sda1 Track_00_NSE_0D

Track_00_NSE_0E:	; 8FEE
	.byte MCMD_TRACK_CONFIG, $00
	.byte $66, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_00_NSE_0E
	.byte $6D, $6D, $6D, $65, $6D, $6B, $6A, $68
	.byte MCMD_LOOPCNT2_INIT_UPDATE, $01
	sda1 Track_00_NSE_0F

Track_00_NSE_10:	; 9002
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $A0
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $6D, $6D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $6D, $60
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $66, $6A
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $6D
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $60, $6A, $60
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $6D
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $60, $6A, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda1 Track_00_NSE_10

Track_00_NSE_11:	; 9028
	.byte MCMD_TRACK_CONFIG, $00
	.byte $67, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_00_NSE_11
	.byte $66, $69, $60, $6D, $66, $6A, $68, $66
Track_00_NSE_12:	; 9038

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $A0
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $6D, $6D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $6D, $60
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $66, $6A
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $6D
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $60, $6A, $60
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $6D
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $60, $6A, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $06
	sda1 Track_00_NSE_12
	.byte $67, $6D, $60, $6D, $66, $6B, $66, $6D, $66, $6D
Track_00_NSE_13:	; 9068

	.byte MCMD_TRACK_CONFIG, $00
	.byte $67
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $05
	sda1 Track_00_NSE_13
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_00_NSE_14
	.byte MCMD_TRACK_STOP
