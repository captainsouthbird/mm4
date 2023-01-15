	.byte $00	; Music header tag
	sda2 Track_16_SQ1	; Square 1
	sda2 Track_16_SQ2	; Square 2
	sda2 Track_16_TRI	; Triangle
	sda2 Track_16_NSE	; Noise

Track_16_SQ1:

Track_16_SQ1_07:	; C822
	.byte MCMD_TRACK_CONFIG, $08
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $01
	.byte MCMD_TEMPO_SET, $02, $00
	.byte MCMD_NOTEATTACKLEN_SET, $EB
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte $73, $71, $60, $73, $60, $76, $75, $71, $A0, $60, $6E, $6F, $71, $73, $71, $60, $73, $60, $76, $75, $78, $60, $76, $60, $73, $A0
Track_16_SQ1_01:	; C84D

	.byte MCMD_TRACK_CONFIG, $48
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_PATCH_SET, $20
	.byte $4D
	.byte MCMD_FREQOFFSET_SET, $7F
	.byte MCMD_SET_1_5X_TIMING
	.byte $6E
	.byte MCMD_FREQOFFSET_SET, $00
	.byte $AE
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AE
	.byte MCMD_PATCH_SET, $20
	.byte $87, $89, $8A
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $49
	.byte MCMD_FREQOFFSET_SET, $7F
	.byte MCMD_SET_1_5X_TIMING
	.byte $6C
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8C, $AA, $A9, $AA
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $47
	.byte MCMD_FREQOFFSET_SET, $7F
	.byte MCMD_SET_1_5X_TIMING
	.byte $69
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A9, $C5
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda2 Track_16_SQ1_00
	.byte $E2
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_SQ1_01

Track_16_SQ1_00:	; C886
	.byte $CE, $AA, $AC
Track_16_SQ1_03:	; C889

	.byte MCMD_TRACK_CONFIG, $48
	.byte $49
	.byte MCMD_FREQOFFSET_SET, $7F
	.byte MCMD_SET_1_5X_TIMING
	.byte $6A
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AA
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A7, $A9, $AA
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $28
	sda2 Track_16_SQ1_02
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $C9, $C5
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_SQ1_03

Track_16_SQ1_02:	; C8A4
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $E5
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $49
	.byte MCMD_FREQOFFSET_SET, $32
	.byte MCMD_SET_1_5X_TIMING
	.byte $6A
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AA
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A7, $A9, $AA
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $C9
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6D
	.byte MCMD_FREQOFFSET_SET, $50
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6E
	.byte MCMD_FREQOFFSET_SET, $00
	.byte $8C, $8A, $89, $CA, $CC, $C5
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6F
	.byte MCMD_FREQOFFSET_SET, $1E
	.byte $71
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B1
	.byte MCMD_FREQOFFSET_SET, $00

Track_16_SQ1_05:	; C8CF
	.byte MCMD_TRACK_CONFIG, $48
	.byte MCMD_PATCH_SET, $20
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte $74
	.byte MCMD_FREQOFFSET_SET, $23
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $95
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $93, $91
	.byte MCMD_SET_1_5X_TIMING
	.byte $8E
	.byte MCMD_SET_1_5X_TIMING
	.byte $90, $91
	.byte MCMD_SET_1_5X_TIMING
	.byte $93
	.byte MCMD_SET_1_5X_TIMING
	.byte $95, $96
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $77
	.byte MCMD_FREQOFFSET_SET, $50
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $98
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $96
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda2 Track_16_SQ1_04
	.byte $95
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D3
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D3
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D1
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D1
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_SQ1_05

Track_16_SQ1_04:	; C90C
	.byte MCMD_OCTAVE_SET, $02
	.byte $8F, $EE, $CF, $D1
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $93, $73
	.byte MCMD_FREQOFFSET_SET, $78
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $71
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $75, $78, $60, $7A, $60, $7D, $9B, $75, $75, $98
Track_16_SQ1_06:	; C928

	.byte MCMD_TRACK_CONFIG, $00
	.byte $7A, $7A, $78, $7A, $75, $78, $60, $7A, $60, $7D, $9B, $75, $75, $98
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_SQ1_06
	.byte $7A, $7A, $78, $7A, $75, $78, $60, $7A, $C0
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_16_SQ1_07
	.byte MCMD_TRACK_STOP


Track_16_SQ2:

Track_16_SQ2_14:	; C949
	.byte MCMD_TRACK_CONFIG, $08
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_OCTAVE_SET, $01
	.byte $6A, $69, $60, $6A, $60, $6E, $6C, $6A, $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $73, $71, $73, $60, $7D, $7F
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $69, $6A, $69, $60, $6A, $60, $6E, $6C, $71, $60, $6C, $60, $6A, $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $71, $73, $60
Track_16_SQ2_08:	; C976

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6A, $6A, $6A, $6A
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_SQ2_08
	.byte $6C, $6C, $6E, $60, $80, $6A, $6A, $67, $67, $80, $65, $65, $67, $67, $65, $65, $67, $60, $80, $65, $65, $65, $65, $80
Track_16_SQ2_09:	; C99C

	.byte MCMD_TRACK_CONFIG, $00
	.byte $78
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $06
	sda2 Track_16_SQ2_09
	.byte $60, $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6A, $6A, $6A, $6A, $80, $6A, $6A, $62, $62, $65, $65, $87
Track_16_SQ2_0A:	; C9B2

	.byte MCMD_TRACK_CONFIG, $00
	.byte $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6A, $6A, $6A, $6A
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_SQ2_0A
	.byte $6C, $6C, $6E, $60, $80, $6A, $6A, $67, $67, $80, $65, $65, $67, $67, $65, $65, $67, $60, $80, $65, $65, $65, $65, $80
Track_16_SQ2_0B:	; C9D6

	.byte MCMD_TRACK_CONFIG, $00
	.byte $78
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $06
	sda2 Track_16_SQ2_0B
	.byte $60, $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6A, $6A, $6A, $6A, $80, $8F, $6F, $6F, $91, $71, $71
Track_16_SQ2_0D:	; C9EB

	.byte MCMD_TRACK_CONFIG, $00
	.byte $7F, $7F, $7B, $7B, $7F, $7F, $7B, $7B, $7A, $7A, $7A, $78, $78, $78, $7A, $7A
	.byte MCMD_LOOPCNT1_JMPLAST_CFG, $00
	sda2 Track_16_SQ2_0C
	.byte $7D, $7D, $78, $78, $7D, $7D, $78, $78, $75, $75, $76, $76, $78, $78, $7A, $7A
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $01
	sda2 Track_16_SQ2_0D

Track_16_SQ2_0C:	; CA15
	.byte MCMD_TRACK_CONFIG, $00
	.byte $78, $78, $75, $75
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda2 Track_16_SQ2_0C
	.byte $7F, $7F, $7B, $7B, $7F, $7F, $7B, $7B, $7A, $7A, $7A, $78, $78, $78, $7A, $7A, $7D, $7D, $78, $78, $7D, $7D, $78, $78
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6A, $6A, $69, $69, $67, $67, $65, $65
Track_16_SQ2_0E:	; CA40

	.byte MCMD_TRACK_CONFIG, $00
	.byte $7F, $7F, $7B, $7B
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda2 Track_16_SQ2_0E

Track_16_SQ2_0F:	; CA4A
	.byte MCMD_TRACK_CONFIG, $00
	.byte $78, $78, $75, $75
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda2 Track_16_SQ2_0F
	.byte $78, $7A, $7B, $7D
Track_16_SQ2_12:	; CA58

	.byte MCMD_TRACK_CONFIG, $08
	.byte $6E, $6A, $60, $6A, $6E, $60, $6A, $60, $6A, $6A, $60, $6A, $6E, $8A, $6A, $6E, $6A, $60, $6A, $6E, $60, $65, $60, $75, $75, $75, $73, $73, $73, $71, $71
	.byte MCMD_LOOPCNT1_JMPLAST_CFG, $08
	sda2 Track_16_SQ2_10

Track_16_SQ2_11:	; CA7D
	.byte MCMD_TRACK_CONFIG, $08
	.byte $6E, $6E, $6A, $60, $6E, $60, $6A, $60, $6E, $6E, $6A, $60, $6E, $6A, $60, $6A
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_SQ2_11
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $01
	sda2 Track_16_SQ2_12

Track_16_SQ2_10:	; CA97
	.byte MCMD_TRACK_CONFIG, $08
	.byte $6A, $6A, $6A, $60, $6A, $60, $6A, $6A, $60, $6A, $60, $6A, $6A, $60, $6A, $6A
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_SQ2_10

Track_16_SQ2_13:	; CAAD
	.byte MCMD_TRACK_CONFIG, $08
	.byte MCMD_PATCH_SET, $17
	.byte $6A, $6A, $69, $6A, $65, $69, $60, $6A, $60, $6E, $8C, $65, $65, $89
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda2 Track_16_SQ2_13
	.byte $6A, $6A, $69, $6A, $65, $69, $60, $6A, $C0
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_16_SQ2_14
	.byte MCMD_TRACK_STOP


Track_16_TRI:

Track_16_TRI_21:	; CAD0
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $03
	.byte $67, $67, $65, $67, $62, $65, $60, $67, $60, $6A, $89, $62, $62, $85, $67, $67, $65, $67, $62, $65, $60, $67, $60, $6A, $89, $62, $62, $65, $66
Track_16_TRI_16:	; CAF5

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_OCTAVE_SET, $02
	.byte $67, $73, $87, $87, $89, $8A, $6C, $6A, $6E, $91, $71, $6C, $78, $8C, $8C, $8E, $8F, $71, $6C, $6E, $8F, $6F, $6E, $7A, $8E, $8E, $8E, $8E, $7A, $6E, $7A, $8E, $6E, $73, $73, $71, $73, $6E, $71, $60, $73
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $00
	sda2 Track_16_TRI_15
	.byte $60, $76, $95, $6E, $6E, $71, $72
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_TRI_16

Track_16_TRI_15:	; CB31
	.byte $98, $78, $78, $9A, $7A, $7A
Track_16_TRI_1B:	; CB37

	.byte MCMD_TRACK_CONFIG, $00

Track_16_TRI_17:	; CB39
	.byte MCMD_TRACK_CONFIG, $00
	.byte $6F, $6F, $6F, $6F, $6F, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_TRI_17
	.byte $7B, $6F, $60, $6F
Track_16_TRI_18:	; CB49

	.byte MCMD_TRACK_CONFIG, $00
	.byte $6E, $6E, $6E, $6E, $6E, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_TRI_18
	.byte $7A, $6E, $60, $6E
	.byte MCMD_LOOPCNT1_JMPLAST_CFG, $00
	sda2 Track_16_TRI_19

Track_16_TRI_1A:	; CB5D
	.byte MCMD_TRACK_CONFIG, $00
	.byte $6F, $6F, $6F, $6F, $6F, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_TRI_1A
	.byte $7B, $6F, $60, $6F, $6E, $6E, $6E, $6E, $6E, $60, $7A, $6E, $73, $6E, $6E, $60, $7A, $8E, $6E
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $01
	sda2 Track_16_TRI_1B

Track_16_TRI_19:	; CB80
	.byte MCMD_TRACK_CONFIG, $00
	.byte $6C, $6C, $6C, $6C, $6C, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_TRI_19
	.byte $78, $6C, $60, $6C
Track_16_TRI_1C:	; CB90

	.byte MCMD_TRACK_CONFIG, $00
	.byte $71, $71, $71, $71, $71, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_TRI_1C
	.byte $7D, $71, $71, $72
Track_16_TRI_1D:	; CBA0

	.byte MCMD_TRACK_CONFIG, $00
	.byte $73, $73, $71, $73, $6E, $71, $60, $73, $60, $76, $95, $6E, $6E, $91
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_TRI_1D

Track_16_TRI_1E:	; CBB4
	.byte MCMD_TRACK_CONFIG, $00
	.byte $6F, $6F, $6F, $6F, $6F, $60, $6F, $6F, $6F, $60, $76, $60, $73, $8E, $6E
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_TRI_1E

Track_16_TRI_1F:	; CBC9
	.byte MCMD_TRACK_CONFIG, $00
	.byte $73, $73, $71, $73, $6E, $71, $60, $73, $60, $76, $95, $6E, $6E, $91
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_TRI_1F
	.byte $6F, $6F, $6F, $6F, $6F, $60, $6F, $6F, $6F, $60, $76, $60, $73, $8E, $6F, $71, $71, $71, $71, $71, $60, $71, $71, $71, $60, $78, $60, $71, $71, $71, $72
Track_16_TRI_20:	; CBFC

	.byte MCMD_TRACK_CONFIG, $00
	.byte $73, $73, $71, $73, $6E, $71, $60, $73, $60, $76, $95, $6E, $6E, $91
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda2 Track_16_TRI_20
	.byte $73, $73, $71, $73, $6E, $71, $60, $73, $C0
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_16_TRI_21
	.byte MCMD_TRACK_STOP


Track_16_NSE:

Track_16_NSE_2C:	; CC1D
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_PATCH_SET, $01
	.byte $65, $65, $65, $60, $66, $60, $65, $65, $60, $65, $65, $60, $66, $80, $65, $65, $65, $65, $60, $66, $60, $65, $65, $60, $65, $65, $60, $66, $65, $66, $65
Track_16_NSE_22:	; CC44

	.byte MCMD_TRACK_CONFIG, $00
	.byte $65, $65, $65, $60, $66, $60, $65, $60, $65, $60, $65, $65, $86, $80
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda2 Track_16_NSE_22

Track_16_NSE_24:	; CC58
	.byte MCMD_TRACK_CONFIG, $00
	.byte $65, $60, $65, $65, $66, $60, $80, $65, $6F, $80, $66, $80, $65
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $00
	sda2 Track_16_NSE_23
	.byte $65, $60, $65, $65, $66, $60, $80, $65, $6F, $60, $68, $66, $60, $80
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_NSE_24

Track_16_NSE_23:	; CC7D
	.byte $65, $60, $65, $65, $66, $6F, $60, $6C, $65, $6F, $6C, $60, $66, $60, $66, $66
Track_16_NSE_26:	; CC8D

	.byte MCMD_TRACK_CONFIG, $00
	.byte $65, $60, $65, $65, $66, $60, $80, $65, $6F, $60, $65, $66, $80, $65
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $00
	sda2 Track_16_NSE_25
	.byte $65, $60, $65, $65, $66, $60, $80, $65, $6F, $60, $68, $66, $80, $66
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_NSE_26

Track_16_NSE_25:	; CCB3
	.byte $65, $6F, $65, $6C, $66, $60, $68, $68, $65, $4F, $4F, $60, $68, $66, $66, $66, $66
Track_16_NSE_27:	; CCC4

	.byte MCMD_TRACK_CONFIG, $00
	.byte $65, $65, $65, $65, $66, $60, $80
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda2 Track_16_NSE_27

Track_16_NSE_28:	; CCD1
	.byte MCMD_TRACK_CONFIG, $00
	.byte $65, $65, $65, $65, $66, $60, $65, $65, $60, $65, $65, $65, $66, $80, $65
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_NSE_28

Track_16_NSE_29:	; CCE6
	.byte MCMD_TRACK_CONFIG, $00
	.byte $65, $65, $65, $65, $66, $60, $80
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda2 Track_16_NSE_29

Track_16_NSE_2A:	; CCF3
	.byte MCMD_TRACK_CONFIG, $00
	.byte $65, $65, $65, $65, $66, $60, $65, $65, $60, $65, $65, $65, $66, $80, $65
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_16_NSE_2A

Track_16_NSE_2B:	; CD08
	.byte MCMD_TRACK_CONFIG, $00
	.byte $65, $65, $65, $65, $66, $80, $65, $60, $65, $65, $65, $66, $60, $80
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda2 Track_16_NSE_2B
	.byte $66, $66, $65, $65, $66, $65, $60, $66, $60, $80, $41, $41
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $43
	.byte MCMD_SYNTH_VOLUME_SET, $0F
	.byte MCMD_PATCH_SET, $22
	.byte $63
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $60, $80
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_16_NSE_2C
	.byte MCMD_TRACK_STOP
