	.byte $00	; Music header tag
	sda1 Track_06_SQ1	; Square 1
	sda1 Track_06_SQ2	; Square 2
	sda1 Track_06_TRI	; Triangle
	sda1 Track_06_NSE	; Noise

Track_06_SQ1:

Track_06_SQ1_02:	; A3B1
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_TEMPO_SET, $02, $66
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $F8
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_NOTEATTACKLEN_SET, $F0
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_OCTAVE_SET, $01

Track_06_SQ1_01:	; A3C2
	.byte MCMD_TRACK_CONFIG, $00
	.byte $A0
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $B4, $94, $93, $80, $91, $80, $94, $80, $94, $93, $80, $91, $80, $A0, $B3, $93, $91, $80, $8F
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda1 Track_06_SQ1_00
	.byte $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $B3, $B4, $93, $94
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_06_SQ1_01

Track_06_SQ1_00:	; A3E7
	.byte $80, $93, $80, $93, $94, $80, $93, $91, $C0, $80, $8F, $90, $91, $A0
	.byte MCMD_SET_1_5X_TIMING
	.byte $D8
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte $A0, $B8, $96, $94, $80, $91, $80, $91, $80, $91, $93, $AF, $91, $A0, $B8, $96, $94, $80
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D, $AC, $AA, $A8
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $87
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $87
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C5
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $85
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_NOTEATTACKLEN_SET, $D2
	.byte $80, $85, $87, $88, $87, $A3, $85
	.byte MCMD_NOTEATTACKLEN_SET, $F0
	.byte MCMD_PATCH_SET, $17
	.byte $A0
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte $A8, $88, $87, $80, $85, $80, $88, $80, $88, $87, $80, $85, $80, $A0, $A7, $87, $85, $80, $83, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $A7, $A8, $87, $88, $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $8F, $90, $91, $94, $98, $80
	.byte MCMD_OCTAVE_SET, $03
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $96
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D6, $96, $94, $93
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8F
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AF
	.byte MCMD_FREQOFFSET_SET, $50
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $98
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B9
	.byte MCMD_FREQOFFSET_SET, $00
	.byte $B6
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $98
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D8, $98, $96, $94
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $98, $D8
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D8
	.byte MCMD_PATCH_SET, $0D
	.byte $DA, $9A, $98, $97
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $93
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $93
	.byte MCMD_FREQOFFSET_SET, $50
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $9C
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $DD
	.byte MCMD_FREQOFFSET_SET, $00
	.byte $BA, $DB, $9B, $9A, $9B
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $98, $D8
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $98
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_NOTEATTACKLEN_SET, $F0
	.byte $98, $9A, $9B
	.byte MCMD_SET_1_5X_TIMING
	.byte $BB
	.byte MCMD_SET_1_5X_TIMING
	.byte $B4, $BB, $E0
	.byte MCMD_SET_1_5X_TIMING
	.byte $BD
	.byte MCMD_SET_1_5X_TIMING
	.byte $B6, $BD, $E0, $80, $9C, $9D, $9F, $80, $9C, $9D, $9F, $80, $9C, $9D, $9F, $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $8A, $8A, $80
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_06_SQ1_02
	.byte MCMD_TRACK_STOP


Track_06_SQ2:

Track_06_SQ2_05:	; A4C4
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_NOTEATTACKLEN_SET, $F0
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_OCTAVE_SET, $01

Track_06_SQ2_04:	; A4D0
	.byte MCMD_TRACK_CONFIG, $00
	.byte $A0
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $B1, $91, $8F, $80, $8C, $80, $91, $80, $91, $8F, $80, $8C, $80, $A0, $AF, $8F, $8C, $80, $8A
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda1 Track_06_SQ2_03
	.byte $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $AF, $B1, $8F, $91
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_06_SQ2_04

Track_06_SQ2_03:	; A4F5
	.byte $80, $8F, $80, $8F, $91, $80, $8F, $8C, $C0, $80, $8A, $8B, $8C, $A0
	.byte MCMD_SET_1_5X_TIMING
	.byte $D0
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte $A0, $B4, $93, $91, $80, $8C, $80, $8C, $80, $8C
	.byte MCMD_SET_1_5X_TIMING
	.byte $AA, $88, $A0, $B3, $93, $91, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8F
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8F, $AD, $AC, $AA
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8C
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8C
	.byte MCMD_SET_1_5X_TIMING
	.byte $CD, $80
	.byte MCMD_DUTYCYCLE_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $D2
	.byte MCMD_PATCH_SET, $17
	.byte $80, $88, $8A, $8C, $8C, $AC, $8C
	.byte MCMD_NOTEATTACKLEN_SET, $F0
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte $A0, $B1, $91, $8F, $80, $8C, $80, $91, $80, $91, $8F, $80, $8C, $80, $A0, $AF, $8F, $8C, $80, $8A, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $AF, $B1, $8F, $91
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0, $80
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_NOTEATTACKLEN_SET, $96
	.byte MCMD_PATCH_SET, $19
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $83
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C3, $83, $83, $85
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $87
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $87, $88
	.byte MCMD_SET_1_5X_TIMING
	.byte $AA, $A7
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C8
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C3
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A3, $A0, $8F, $8F, $A0, $C5, $85, $86, $85
	.byte MCMD_TOGGLE_SINE_RESET
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $97
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B7, $D7, $BD, $DF, $C0, $A0, $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $93, $93
	.byte MCMD_NOTEATTACKLEN_SET, $F0
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $95, $96, $98
	.byte MCMD_FREQFINEOFFSET_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $A8
	.byte MCMD_SET_1_5X_TIMING
	.byte $A8, $A8, $E0
	.byte MCMD_SET_1_5X_TIMING
	.byte $AA
	.byte MCMD_SET_1_5X_TIMING
	.byte $AA, $AA, $E0
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte $80, $8C, $8E, $90, $80, $8C, $8E, $90, $80, $8C, $8E, $90, $80, $93, $93, $80
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_06_SQ2_05
	.byte MCMD_TRACK_STOP


Track_06_TRI:

Track_06_TRI_15:	; A5B9
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $04

Track_06_TRI_08:	; A5BF
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $D2

Track_06_TRI_06:	; A5C3
	.byte MCMD_TRACK_CONFIG, $00
	.byte $85, $65, $65
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda1 Track_06_TRI_06

Track_06_TRI_07:	; A5CC
	.byte MCMD_TRACK_CONFIG, $00
	.byte $83, $63, $63
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $06
	sda1 Track_06_TRI_07
	.byte $83, $65, $65
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $01
	sda1 Track_06_TRI_08
	.byte $85, $80, $A5, $C0, $A0
	.byte MCMD_OCTAVE_SET, $03
	.byte MCMD_SET_1_5X_TIMING
	.byte $D4
Track_06_TRI_09:	; A5E5

	.byte MCMD_TRACK_CONFIG, $00
	.byte $91, $71, $71
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda1 Track_06_TRI_09

Track_06_TRI_0A:	; A5EE
	.byte MCMD_TRACK_CONFIG, $00
	.byte $8F, $6F, $6F
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda1 Track_06_TRI_0A

Track_06_TRI_0B:	; A5F7
	.byte MCMD_TRACK_CONFIG, $00
	.byte $8D, $6D, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_06_TRI_0B
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte $85, $91, $93, $94, $8C, $8C, $8F
	.byte MCMD_NOTEATTACKLEN_SET, $D2
	.byte $91
Track_06_TRI_0C:	; A60C

	.byte MCMD_TRACK_CONFIG, $00
	.byte $91, $71, $71
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda1 Track_06_TRI_0C

Track_06_TRI_0D:	; A615
	.byte MCMD_TRACK_CONFIG, $00
	.byte $8F, $6F, $6F
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $06
	sda1 Track_06_TRI_0D
	.byte $8F, $71, $71
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $93
Track_06_TRI_0E:	; A626

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_PATCH_SET, $00
	.byte $93, $93
	.byte MCMD_PATCH_SET, $04
	.byte $B9
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_06_TRI_0E

Track_06_TRI_0F:	; A633
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_PATCH_SET, $00
	.byte $94, $94
	.byte MCMD_PATCH_SET, $04
	.byte $B9
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_06_TRI_0F

Track_06_TRI_10:	; A640
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_PATCH_SET, $00
	.byte $97, $97
	.byte MCMD_PATCH_SET, $04
	.byte $B9
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_06_TRI_10

Track_06_TRI_11:	; A64D
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_PATCH_SET, $00
	.byte $98, $98
	.byte MCMD_PATCH_SET, $04
	.byte $B9
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_06_TRI_11

Track_06_TRI_12:	; A65A
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_PATCH_SET, $00
	.byte $8C, $6C, $6C
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda1 Track_06_TRI_12

Track_06_TRI_13:	; A665
	.byte MCMD_TRACK_CONFIG, $00
	.byte $8E, $6E, $6E
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda1 Track_06_TRI_13

Track_06_TRI_14:	; A66E
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_PATCH_SET, $00
	.byte $8C, $8C
	.byte MCMD_PATCH_SET, $04
	.byte $BD
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda1 Track_06_TRI_14
	.byte MCMD_PATCH_SET, $00
	.byte $8F, $8F, $8F, $90
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_06_TRI_15
	.byte MCMD_TRACK_STOP


Track_06_NSE:

Track_06_NSE_1D:	; A685
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $32
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_PATCH_SET, $18

Track_06_NSE_16:	; A68D
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $63, $80, $60
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $68, $80, $60
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $63, $60, $63, $60
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $68, $60, $80
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda1 Track_06_NSE_16
	.byte $65, $80, $60, $65, $80, $60, $65, $60
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $01
	.byte $65, $65, $65, $65, $65, $65
Track_06_NSE_17:	; A6BA

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $32
	.byte MCMD_PATCH_SET, $18
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $65, $80, $60
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $63, $80, $60
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $65, $60, $65, $60
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $63, $80, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $05
	sda1 Track_06_NSE_17
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $8D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $8D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte $8D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $0F
	.byte $8D, $6D, $6D
Track_06_NSE_18:	; A6EF

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_PATCH_SET, $18
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $63, $80, $60
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $68, $80, $60
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $63, $60, $63, $60
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $68, $60, $80
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_06_NSE_18
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $63, $80, $60
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $68, $80, $60
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $63, $60, $63, $60
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $68, $60, $8D
Track_06_NSE_19:	; A721

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $8D
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $8D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $1F
	sda1 Track_06_NSE_19

Track_06_NSE_1B:	; A72D
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $32
	.byte MCMD_PATCH_SET, $18
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $63, $80, $60
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $68, $80, $60
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $63, $60, $63, $60
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $68, $60, $80
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $65, $60
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $63, $60
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $65, $60
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $63, $60
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $65, $60
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $00
	sda1 Track_06_NSE_1A
	.byte $65, $60, $65, $60, $65, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_06_NSE_1B

Track_06_NSE_1A:	; A76A
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $01
	.byte $65, $65, $65, $65, $65, $65
Track_06_NSE_1C:	; A774

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $B4
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $8D
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte $86, $86, $86
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_06_NSE_1C
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_06_NSE_1D
	.byte MCMD_TRACK_STOP
