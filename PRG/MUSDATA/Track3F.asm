	.byte $00	; Music header tag
	sda2 Track_3F_SQ1	; Square 1
	sda2 Track_3F_SQ2	; Square 2
	sda2 Track_3F_TRI	; Triangle
	sda2 Track_3F_NSE	; Noise

Track_3F_SQ1:
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $FE
	.byte MCMD_TEMPO_SET, $01, $11
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $1F
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_OCTAVE_SET, $03
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $8A, $8D
Track_3F_SQ1_01:	; D3ED

	.byte MCMD_TRACK_CONFIG, $48
	.byte $2D
	.byte MCMD_FREQOFFSET_SET, $28
	.byte $2F, $4F
	.byte MCMD_SET_1_5X_TIMING
	.byte $8F
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AF, $8D, $D1
	.byte MCMD_FREQOFFSET_SET, $00
	.byte $8A, $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $2D
	.byte MCMD_FREQOFFSET_SET, $28
	.byte $30, $50, $70
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $90
	.byte MCMD_FREQOFFSET_SET, $00
	.byte $AF, $8D, $88
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $28
	sda2 Track_3F_SQ1_00
	.byte $CA, $8A, $8D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_3F_SQ1_01

Track_3F_SQ1_00:	; D418
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $CA
	.byte MCMD_TRACK_STOP


Track_3F_SQ2:
	.byte MCMD_TRACK_STOP


Track_3F_TRI:
	.byte MCMD_TRACK_STOP


Track_3F_NSE:
	.byte MCMD_TRACK_STOP
