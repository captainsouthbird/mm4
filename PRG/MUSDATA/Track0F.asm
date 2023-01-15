	.byte $00	; Music header tag
	sda1 Track_0F_SQ1	; Square 1
	sda1 Track_0F_SQ2	; Square 2
	sda1 Track_0F_TRI	; Triangle
	sda1 Track_0F_NSE	; Noise

Track_0F_SQ1:
	.byte MCMD_TEMPO_SET, $02, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6D, $6D, $60, $6D, $8B
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $6F, $6F, $6F, $60, $6F, $8D
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6F
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CF
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $70, $70, $60, $70, $A0, $73, $73, $60, $73, $A0, $60, $74, $60, $92, $70, $72, $73
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte $D4
	.byte MCMD_TRACK_STOP


Track_0F_SQ2:
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_FREQFINEOFFSET_SET, $01
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $01
	.byte $7C, $7C, $60, $7C, $9B
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $9C
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $DC
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $7E, $7E, $7E, $60, $7E, $9C
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $7E
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $DE
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $7F, $7F, $60, $7F, $A0
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6A, $6A, $60, $6A, $A0, $60, $6C, $60, $8A, $68, $69, $6A
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_PATCH_SET, $03
	.byte $CC
	.byte MCMD_TRACK_STOP


Track_0F_TRI:
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $02
	.byte $D9, $60, $79, $79, $79, $79
	.byte MCMD_SET_1_5X_TIMING
	.byte $98, $D7, $60, $77, $77, $77, $77
	.byte MCMD_SET_1_5X_TIMING
	.byte $96, $73, $73, $60, $73
	.byte MCMD_PATCH_SET, $04
	.byte $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68, $88
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $76, $76, $60, $76
	.byte MCMD_PATCH_SET, $04
	.byte $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $69, $88
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $F4
	.byte MCMD_TRACK_STOP


Track_0F_NSE:
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_PATCH_SET, $01

Track_0F_NSE_00:	; BA7E
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $3C
	.byte $A8, $AD, $60
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $68, $60, $68, $6D, $60, $68, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_0F_NSE_00
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $8D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte $8D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $8D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $8D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $8D, $6D, $6D, $8D, $6D, $6D
Track_0F_NSE_01:	; BAAE

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte $4D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $0F
	sda1 Track_0F_NSE_01
	.byte MCMD_TRACK_STOP
