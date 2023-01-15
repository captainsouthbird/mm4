	.byte $00	; Music header tag
	sda2 Track_3B_SQ1	; Square 1
	sda2 Track_3B_SQ2	; Square 2
	sda2 Track_3B_TRI	; Triangle
	sda2 Track_3B_NSE	; Noise

Track_3B_SQ1:
	.byte MCMD_TEMPO_SET, $01, $80
	.byte MCMD_NOTEATTACKLEN_SET, $D2
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_SET_1_5X_TIMING
	.byte $B9, $7E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $69
	.byte MCMD_SET_1_5X_TIMING
	.byte $AC, $6B, $6C, $6D, $60, $6B, $6D, $6E, $60, $6D, $6B, $6D, $60, $6F, $60, $71, $60, $74, $60, $72, $60, $74, $75, $77, $60, $6D, $60
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B2
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B2
	.byte MCMD_TRACK_STOP


Track_3B_SQ2:
	.byte MCMD_NOTEATTACKLEN_SET, $D2
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_SET_1_5X_TIMING
	.byte $B7, $75, $72
	.byte MCMD_SET_1_5X_TIMING
	.byte $BB, $7A, $7B, $7D, $60, $7B, $7D, $7E, $60, $7D, $7B, $7D, $60, $7B, $60, $79, $60, $7D, $60, $7E, $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6D, $6D, $6D, $60, $6D, $60
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AD
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AD
	.byte MCMD_TRACK_STOP


Track_3B_TRI:
	.byte MCMD_NOTEATTACKLEN_SET, $96
	.byte MCMD_OCTAVE_SET, $03
	.byte MCMD_PATCH_SET, $01
	.byte $80
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $6D, $6D, $6D
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $8D, $92, $80
	.byte MCMD_NOTEATTACKLEN_SET, $96
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $6C, $6C, $6C
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $AC, $80
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $68, $60, $AB, $AD, $A8, $66, $60, $66, $66, $66, $60, $66, $60
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte $C6
	.byte MCMD_TRACK_STOP


Track_3B_NSE:
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte MCMD_PATCH_SET, $0D

Track_3B_NSE_01:	; D274
	.byte MCMD_TRACK_CONFIG, $00
	.byte $8D
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $68, $68, $68
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $20
	sda2 Track_3B_NSE_00
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $88, $88
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_3B_NSE_01

Track_3B_NSE_00:	; D286
	.byte MCMD_TRACK_CONFIG, $20
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $48
	.byte MCMD_LOOPCNT1_INIT_UPDATE, $0B
	sda2 Track_3B_NSE_00
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $68, $60, $68, $68, $68, $68, $68, $60, $68, $60, $68, $60, $68, $68, $68, $60, $68, $60, $68, $68, $68, $68, $68, $60
Track_3B_NSE_02:	; D2AE

	.byte MCMD_TRACK_CONFIG, $20
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $48
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $15
	sda2 Track_3B_NSE_02
	.byte MCMD_TRACK_STOP
