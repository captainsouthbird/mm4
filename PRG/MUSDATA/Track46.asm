	.byte $00	; Music header tag
	sda2 Track_46_SQ1	; Square 1
	sda2 Track_46_SQ2	; Square 2
	sda2 Track_46_TRI	; Triangle
	sda2 Track_46_NSE	; Noise

Track_46_SQ1:
	.byte MCMD_TEMPO_SET, $02, $49
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $56, $58, $59, $5B, $5D, $5E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $48, $4A, $4C, $4D, $4F, $51
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B2
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $92
	.byte MCMD_PATCH_SET, $0D
	.byte $71, $6F
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $B1, $AF, $AD
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6F
	.byte MCMD_FREQOFFSET_SET, $64
	.byte $70
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B0
	.byte MCMD_FREQOFFSET_SET, $00
	.byte $6F, $6D
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $AF, $AD, $AB
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $AE, $6D, $6B
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $AD, $AB, $A9
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $6F, $80, $6F
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B2
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B2
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $8F, $8F, $92
	.byte MCMD_SYNTH_VOLUME_SET, $0E
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $71, $80, $71
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B4
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B4
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $91, $91, $94
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $F3
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $33
	.byte MCMD_TRACK_STOP


Track_46_SQ2:
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $52, $54, $56, $58, $59, $5B, $5D, $5E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $48, $4A, $4C, $4D
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $60
	.byte MCMD_FREQFINEOFFSET_SET, $02
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B2
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $92
	.byte MCMD_PATCH_SET, $0D
	.byte $71, $6F
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $B1, $AF, $AD
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6F
	.byte MCMD_FREQOFFSET_SET, $64
	.byte $70
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B0
	.byte MCMD_FREQOFFSET_SET, $00
	.byte $6F, $6D
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $AF, $AD, $AB
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $AE, $6D, $6B
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $AD, $AB
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $69
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $49
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte $66, $80, $66
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AB
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AB
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $86, $86, $8B
	.byte MCMD_SYNTH_VOLUME_SET, $0D
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $68, $80, $68
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AD
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AD
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $88, $88, $8D
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $EF
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $2F
	.byte MCMD_TRACK_STOP


Track_46_TRI:
	.byte MCMD_NOTEATTACKLEN_SET, $D2
	.byte MCMD_OCTAVE_SET, $04
	.byte MCMD_PATCH_SET, $00
	.byte $E0, $A1, $80, $61, $61, $81, $81
	.byte MCMD_PATCH_SET, $04
	.byte $A8
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $03
	.byte $AB, $80, $6B, $70, $90, $90
	.byte MCMD_PATCH_SET, $04
	.byte $B9
	.byte MCMD_PATCH_SET, $00
	.byte $AB, $80, $6B, $6B, $8B, $8B
	.byte MCMD_PATCH_SET, $04
	.byte $99, $99
	.byte MCMD_PATCH_SET, $00
	.byte $AB, $80, $6B, $6B, $8B, $8B, $8B, $8B, $AD, $80, $6D, $6D, $8D, $8D, $8D, $8D, $AF, $80, $6F, $6F, $8F, $8F, $8F, $8F, $AF
	.byte MCMD_TRACK_STOP


Track_46_NSE:
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $8D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte $8D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $8D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte $8D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09

Track_46_NSE_00:	; D975
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte $A8
	.byte MCMD_NOTEATTACKLEN_SET, $B4
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $68, $68, $68, $68, $68, $68
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $88, $88, $88, $88
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda2 Track_46_NSE_00
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $8D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $8D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte $8D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $8D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $8D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte $8D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte $8D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $0D
	.byte $8D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $0D

Track_46_NSE_01:	; D9B8
	.byte MCMD_TRACK_CONFIG, $00
	.byte $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $0F
	sda2 Track_46_NSE_01
	.byte $6D
	.byte MCMD_TRACK_STOP
