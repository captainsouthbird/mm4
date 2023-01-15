	.byte $00	; Music header tag
	sda1 Track_05_SQ1	; Square 1
	sda1 Track_05_SQ2	; Square 2
	sda1 Track_05_TRI	; Triangle
	sda1 Track_05_NSE	; Noise

Track_05_SQ1:

Track_05_SQ1_04:	; 9FB4
	.byte MCMD_TRACK_CONFIG, $08

Track_05_SQ1_01:	; 9FB6
	.byte MCMD_TRACK_CONFIG, $08
	.byte MCMD_TEMPO_SET, $02, $66
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $FA
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_NOTEATTACKLEN_SET, $EB
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_OCTAVE_SET, $02
	.byte $AD, $AD, $8B, $8D, $80, $8D, $80, $8D, $80, $8D
	.byte MCMD_FREQOFFSET_SET, $50
	.byte $90
	.byte MCMD_FREQOFFSET_SET, $00
	.byte $8D, $8B
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda1 Track_05_SQ1_00
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_05_SQ1_01

Track_05_SQ1_00:	; 9FE2
	.byte $8D, $8F
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0
	.byte MCMD_FREQOFFSET_SET, $50
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $90
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B0
	.byte MCMD_SET_1_5X_TIMING
	.byte $AF, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $ED, $C0, $80
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte $87, $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
Track_05_SQ1_03:	; 9FFE

	.byte MCMD_TRACK_CONFIG, $08
	.byte $CD, $8F, $8D, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $90, $D0
	.byte MCMD_PATCH_SET, $1A
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $90
	.byte MCMD_PATCH_SET, $17
	.byte $87, $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD, $8F, $8D, $80, $8F, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D0
	.byte MCMD_PATCH_SET, $1A
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B0
	.byte MCMD_PATCH_SET, $17
	.byte $80
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda1 Track_05_SQ1_02
	.byte $80, $8F, $90, $8F, $80, $8F, $90, $8F, $80, $8F, $90, $8F, $92, $8C, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $ED
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $B8, $98, $98
	.byte MCMD_PATCH_SET, $17
	.byte $9F
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_05_SQ1_03

Track_05_SQ1_02:	; A04C
	.byte $80, $8F, $90, $92, $80, $8F, $90, $92, $80, $8F, $90, $92, $94, $97, $80
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_OCTAVE_SET, $03
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $ED
	.byte MCMD_NOTEATTACKLEN_SET, $B4
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0, $80
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $97
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D7, $97, $B9
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $96
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $96, $94, $92, $A0, $95, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $95
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D5, $95, $97, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $94
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $94, $92, $90, $A0, $90, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $92
	.byte MCMD_SET_1_5X_TIMING
	.byte $D2
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $92
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $93
	.byte MCMD_SET_1_5X_TIMING
	.byte $D3
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $93
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $94
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $F4
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_PATCH_SET, $17
	.byte $80, $B8, $98, $98
	.byte MCMD_SET_1_5X_TIMING
	.byte $A0
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_05_SQ1_04
	.byte MCMD_TRACK_STOP


Track_05_SQ2:

Track_05_SQ2_07:	; A0AA
	.byte MCMD_TRACK_CONFIG, $00

Track_05_SQ2_06:	; A0AC
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_NOTEATTACKLEN_SET, $EB
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_TRACK_TRANSPOSE_SET, $00
	.byte $BC, $BC, $9B, $9C, $80, $9C, $80, $9C, $80, $9C
	.byte MCMD_FREQOFFSET_SET, $50
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88
	.byte MCMD_FREQOFFSET_SET, $00
	.byte $84, $83
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $08
	sda1 Track_05_SQ2_05
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $84
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_05_SQ2_06

Track_05_SQ2_05:	; A0D6
	.byte $84, $86
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A8
	.byte MCMD_SET_1_5X_TIMING
	.byte $A6, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $84
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $E4
	.byte MCMD_SET_1_5X_TIMING
	.byte $60
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte MCMD_FREQFINEOFFSET_SET, $01
	.byte $C0, $80, $87, $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD, $8F, $8D, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $90, $D0
	.byte MCMD_PATCH_SET, $1A
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $90
	.byte MCMD_PATCH_SET, $17
	.byte $87, $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD, $8F, $8D, $80, $8F, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $D0, $80, $80, $8F, $90, $8F, $80, $8F, $90, $8F, $80, $8F, $90, $8F, $92, $8C, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D, $AD, $AD, $AD
	.byte MCMD_PATCH_SET, $1A
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $4D
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $B4, $94, $94
	.byte MCMD_PATCH_SET, $02
	.byte $96, $97
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $9C
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $DC, $9E, $9C, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88, $C8
	.byte MCMD_PATCH_SET, $1A
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $96, $97
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $9C
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $DC, $9E, $9C, $80, $9E, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $C8
	.byte MCMD_PATCH_SET, $1A
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A8
	.byte MCMD_PATCH_SET, $02
	.byte $80, $80, $86, $88, $89, $80, $86, $88, $89, $80, $86, $88, $89, $8B, $8F, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $91
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $F1
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_PATCH_SET, $14
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0, $80, $83, $80, $83, $83, $80, $83, $83, $83
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $81
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $81, $81, $81, $80, $81, $81, $81
	.byte MCMD_TOGGLE_SINE_RESET
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $98
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $98, $98, $98, $80, $98, $98, $98
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $97
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $97, $97, $97, $80, $97, $97, $97
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $96
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $96, $96, $96, $96, $96, $96, $96
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $97
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $97, $97, $97, $97, $97, $97, $97
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $98
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $98, $98, $98, $98, $98, $98, $98
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $98
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $98
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_PATCH_SET, $17
	.byte $BE, $9E, $9E
	.byte MCMD_SET_1_5X_TIMING
	.byte $A0
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_05_SQ2_07
	.byte MCMD_TRACK_STOP


Track_05_TRI:

Track_05_TRI_0F:	; A1D5
	.byte MCMD_TRACK_CONFIG, $00

Track_05_TRI_08:	; A1D7
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $03
	.byte $8D, $8D, $8B, $8D, $80, $8D, $8B, $8D, $80, $8D, $8B, $8D, $90, $8D, $8B
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_05_TRI_08
	.byte MCMD_NOTEATTACKLEN_SET, $B4
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B1, $BD, $91, $91, $9D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $91
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $91, $80, $BD, $7D, $7D, $7D, $7D, $78, $78
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D, $8D, $90, $90, $92, $94, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D, $8D, $90, $8D, $90, $8D, $8B
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
Track_05_TRI_0B:	; A224

	.byte MCMD_TRACK_CONFIG, $00
	.byte $8D, $8D, $90, $90, $92, $94, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D, $8D, $90, $8D, $90, $8D, $8B
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D, $8D, $90, $90, $92, $94, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D, $8D, $90, $8D, $90, $8D, $8B, $8C
	.byte MCMD_LOOPCNT1_JMPLAST_CFG, $00
	sda1 Track_05_TRI_09

Track_05_TRI_0A:	; A250
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_PATCH_SET, $04
	.byte $94
	.byte MCMD_PATCH_SET, $00
	.byte $8F, $8F, $8F
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda1 Track_05_TRI_0A
	.byte MCMD_PATCH_SET, $04
	.byte $94, $94, $80
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D, $8D, $90, $90, $92, $94, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D, $B2, $92, $92, $93, $90
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $01
	sda1 Track_05_TRI_0B

Track_05_TRI_09:	; A27E
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_PATCH_SET, $04
	.byte $91
	.byte MCMD_PATCH_SET, $00
	.byte $8F, $8E, $8F
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda1 Track_05_TRI_09
	.byte MCMD_PATCH_SET, $04
	.byte $99, $99, $96
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D, $8D, $90, $90, $92, $94, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D, $B2, $92, $92, $93, $90
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8F
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8F, $94, $94, $80, $94, $94, $94
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $92
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $92, $92, $92, $80, $92, $92, $92
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $91
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $91, $91, $91, $80, $91, $91, $91
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $90
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $90, $90, $90, $80, $90, $90, $90
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8F
Track_05_TRI_0C:	; A2D0

	.byte MCMD_TRACK_CONFIG, $00
	.byte $8F
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $06
	sda1 Track_05_TRI_0C
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $90
Track_05_TRI_0D:	; A2D9

	.byte MCMD_TRACK_CONFIG, $00
	.byte $90
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $06
	sda1 Track_05_TRI_0D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $91
Track_05_TRI_0E:	; A2E2

	.byte MCMD_TRACK_CONFIG, $00
	.byte $91
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $05
	sda1 Track_05_TRI_0E
	.byte $92
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $93
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $93, $B4, $94, $94, $80, $AC
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_05_TRI_0F
	.byte MCMD_TRACK_STOP


Track_05_NSE:

Track_05_NSE_18:	; A2F7
	.byte MCMD_TRACK_CONFIG, $00

Track_05_NSE_10:	; A2F9
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte MCMD_PATCH_SET, $01
	.byte $88
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $88
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $0F
	sda1 Track_05_NSE_10
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $88, $C0, $80, $88
	.byte MCMD_PATCH_SET, $18
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AD
	.byte MCMD_PATCH_SET, $01
	.byte $88
	.byte MCMD_PATCH_SET, $18
	.byte $AD
	.byte MCMD_PATCH_SET, $01
	.byte $88
	.byte MCMD_PATCH_SET, $18
	.byte $8D
	.byte MCMD_PATCH_SET, $01
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88
Track_05_NSE_11:	; A325

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte MCMD_PATCH_SET, $18
	.byte $88
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $88
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $05
	sda1 Track_05_NSE_11
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $68, $68, $8D, $68, $68, $8D
Track_05_NSE_14:	; A33D

	.byte MCMD_TRACK_CONFIG, $00

Track_05_NSE_12:	; A33F
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_PATCH_SET, $01
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte $85, $80
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $88, $80
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_05_NSE_12
	.byte $80
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte $85
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $88, $80
	.byte MCMD_LOOPCNT1_JMPLAST_CFG, $00
	sda1 Track_05_NSE_13
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte $85, $80
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $88
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $85
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $07
	sda1 Track_05_NSE_14

Track_05_NSE_13:	; A36A
	.byte $66, $66, $8A, $66, $66
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8A
Track_05_NSE_15:	; A371

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $8D
	.byte MCMD_SYNTH_VOLUME_SET, $04
	.byte $8D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $0F
	sda1 Track_05_NSE_15

Track_05_NSE_17:	; A37D
	.byte MCMD_TRACK_CONFIG, $00

Track_05_NSE_16:	; A37F
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte $85, $80
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $8A, $80
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_05_NSE_16
	.byte $80
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte $85
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $8A, $80
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte $85, $80
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $8A
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $85
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $01
	sda1 Track_05_NSE_17
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_05_NSE_18
	.byte MCMD_TRACK_STOP
