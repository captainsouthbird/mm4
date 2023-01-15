	.byte $00	; Music header tag
	sda2 Track_3A_SQ1	; Square 1
	sda2 Track_3A_SQ2	; Square 2
	sda2 Track_3A_TRI	; Triangle
	sda2 Track_3A_NSE	; Noise

Track_3A_SQ1:
	.byte MCMD_TEMPO_SET, $02, $00
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $03
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0D
	.byte MCMD_PATCH_SET, $1A
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_SET_1_5X_TIMING
	.byte $BD, $7D, $7D, $7D, $60
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte $7D, $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68, $60, $6D, $60
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_SET_1_5X_TIMING
	.byte $A6, $66, $66, $66, $60
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte $66, $60, $6B, $60, $6F, $60
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C8
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C8
	.byte MCMD_TRACK_STOP


Track_3A_SQ2:
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $1A
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_FREQFINEOFFSET_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $A8, $68, $68, $68, $60
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte $61, $60, $65, $60, $68, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $AB, $6B, $6B, $6B, $60
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte $63, $60, $66, $60, $6B, $60
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD
	.byte MCMD_TRACK_STOP


Track_3A_TRI:
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $AD, $6D, $6D, $6D, $60, $68, $60, $6D, $60, $71, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $AF, $6F, $6F, $6F, $60, $6B, $60, $6F, $60, $72, $60
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D1
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D1
	.byte MCMD_TRACK_STOP


Track_3A_NSE:
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_PATCH_SET, $0D

Track_3A_NSE_00:	; D1AB
	.byte MCMD_TRACK_CONFIG, $00
	.byte $68, $60, $68, $68, $88, $88
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $68, $68, $68, $68, $68, $68
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $88, $88
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_3A_NSE_00

Track_3A_NSE_01:	; D1C1
	.byte MCMD_TRACK_CONFIG, $20
	.byte $68
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $17
	sda2 Track_3A_NSE_01
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A8
	.byte MCMD_TRACK_STOP
