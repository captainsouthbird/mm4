	.byte $00	; Music header tag
	sda1 Track_02_SQ1	; Square 1
	sda1 Track_02_SQ2	; Square 2
	sda1 Track_02_TRI	; Triangle
	sda1 Track_02_NSE	; Noise

Track_02_SQ1:
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_TEMPO_SET, $02, $2E
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_PATCH_SET, $09

Track_02_SQ1_00:	; 93F1
	.byte MCMD_TRACK_CONFIG, $08
	.byte $A8
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $88, $87, $86, $C5, $A8
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0
	.byte MCMD_OCTAVE_SET, $01
	.byte $74, $72, $6F
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D, $72, $6F, $6D
	.byte MCMD_SET_1_5X_TIMING
	.byte $8B, $6F, $6D, $6B
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $68
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C8, $B2
	.byte MCMD_SET_1_5X_TIMING
	.byte $93, $74, $E0, $68, $66, $68, $6B, $68, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D, $8B, $68, $66, $80, $A8, $A0, $8F, $8D, $68, $66, $80, $88, $C0, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $88, $68
	.byte MCMD_SET_1_5X_TIMING
	.byte $A8, $88, $8B, $88, $8C, $88, $66, $68, $60, $88, $C0
	.byte MCMD_SET_1_5X_TIMING
	.byte $80, $8D, $8B, $8F, $8D, $8B, $88, $66, $67, $60
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $68
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A8
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0, $8F, $8D, $90, $6F, $6D, $80, $8B, $88, $86, $66, $67, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C8
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $68, $C0, $60, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B0
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $70, $8D, $92, $90, $8F, $8D, $6E
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AF
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6F, $8B, $90, $8F, $8D, $8B, $6C
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AD
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6D, $8B, $8F, $8D, $8B, $86, $C0, $60, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B0
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $70, $8D, $92, $90, $8F, $8D, $6E
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AF
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6F, $8B, $90, $8F, $8D, $8B, $6C
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AD
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6D, $8B, $8F, $8D, $8B, $86, $C8, $C0
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_02_SQ1_00
	.byte MCMD_TRACK_STOP


Track_02_SQ2:

Track_02_SQ2_01:	; 94B2
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_FREQFINEOFFSET_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_PATCH_SET, $02
	.byte $BB
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $9B, $9A, $99, $D8, $BB
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0
	.byte MCMD_SET_1_5X_TIMING
	.byte $9B, $6F, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $9C, $70, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $BD
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $DD
	.byte MCMD_PATCH_SET, $02
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $8A, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8B
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6B, $6C
	.byte MCMD_OCTAVE_SET, $01
	.byte $C0, $A8, $AB, $80, $8B, $80, $8F, $AD, $AA, $80, $88, $66, $67, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $A8, $ED, $A8, $AA, $AB, $AF, $ED
	.byte MCMD_PATCH_SET, $03
	.byte $CF
	.byte MCMD_PATCH_SET, $02
	.byte $B3
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $51, $4F, $4D, $4C, $4A, $48, $46, $45, $43, $41, $61
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $80
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $97, $7E, $77, $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68, $C0, $CF
	.byte MCMD_PATCH_SET, $03
	.byte $D3
	.byte MCMD_PATCH_SET, $02
	.byte $8D, $8B, $68, $66, $60, $A8, $A0, $60, $6B, $6A, $68, $6B, $6A, $68, $6B, $6A, $68, $6B, $6A, $68, $6F, $68, $6A, $6B
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $88
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D, $90, $92, $90, $6F, $70, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $88
	.byte MCMD_SET_1_5X_TIMING
	.byte $8B, $8F, $90, $8F, $6E, $6F, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $87
	.byte MCMD_SET_1_5X_TIMING
	.byte $8A, $8D, $8F, $8D, $6B, $6D, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $88
	.byte MCMD_SET_1_5X_TIMING
	.byte $8A, $8B
	.byte MCMD_SET_1_5X_TIMING
	.byte $8C
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D, $8F
	.byte MCMD_SET_1_5X_TIMING
	.byte $88
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D, $90, $92, $90, $6F, $70, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $88
	.byte MCMD_SET_1_5X_TIMING
	.byte $8B, $8F, $90, $8F, $6E, $6F, $80
	.byte MCMD_SET_1_5X_TIMING
	.byte $87
	.byte MCMD_SET_1_5X_TIMING
	.byte $8A, $8D, $8F, $8D, $6B, $6D, $80, $88, $8A, $6B, $6A, $60, $A8, $A0, $60
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_02_SQ2_01
	.byte MCMD_TRACK_STOP


Track_02_TRI:

Track_02_TRI_02:	; 958F
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $03
	.byte $A8, $80, $83, $66, $60, $67, $68, $80, $83, $63
	.byte MCMD_SET_1_5X_TIMING
	.byte $88, $80, $83, $64, $60, $63
	.byte MCMD_OCTAVE_SET, $02
	.byte $88
	.byte MCMD_SET_1_5X_TIMING
	.byte $80, $B4, $80, $8F, $72, $60, $73, $74, $80, $8F
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68, $68, $68, $88, $60, $68, $68, $68, $88, $60, $60, $60, $88, $60, $61, $60, $60, $68, $68, $68, $68
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $B2
	.byte MCMD_SET_1_5X_TIMING
	.byte $93, $74, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $94, $92, $8F, $72, $60, $73, $74
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $73, $74, $94, $A0, $8F, $72, $60, $73, $74, $80, $8F, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $94
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $92, $8F, $72, $60, $73, $74, $A0, $94, $A0, $8F, $70, $60, $6F, $68, $A0, $94, $97, $99, $77, $9B
	.byte MCMD_SET_1_5X_TIMING
	.byte $8F, $91, $93, $94, $97, $79
	.byte MCMD_SET_1_5X_TIMING
	.byte $97, $BB, $A0, $94, $97, $99, $77, $9B
	.byte MCMD_SET_1_5X_TIMING
	.byte $8F, $91, $93, $94, $97, $74, $97
	.byte MCMD_SET_1_5X_TIMING
	.byte $94, $80, $AF, $94, $97, $99, $77, $9B
	.byte MCMD_SET_1_5X_TIMING
	.byte $8F, $91, $93, $94, $97, $96, $72, $74, $C0, $94, $97, $96, $72, $74, $C0
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D, $74, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D9
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $99
	.byte MCMD_SET_1_5X_TIMING
	.byte $8B, $6F, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D4
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $94
	.byte MCMD_SET_1_5X_TIMING
	.byte $93, $79, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $DB
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $9B
	.byte MCMD_SET_1_5X_TIMING
	.byte $94
	.byte MCMD_SET_1_5X_TIMING
	.byte $96, $97
	.byte MCMD_SET_1_5X_TIMING
	.byte $96
	.byte MCMD_SET_1_5X_TIMING
	.byte $94, $9B
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D, $74, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D9
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $99
	.byte MCMD_SET_1_5X_TIMING
	.byte $8B, $6F, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D4
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $94
	.byte MCMD_SET_1_5X_TIMING
	.byte $93, $79, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $DB
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $9B, $94, $97, $96, $72, $B4, $A0, $60
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_02_TRI_02
	.byte MCMD_TRACK_STOP


Track_02_NSE:
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte MCMD_PATCH_SET, $01

Track_02_NSE_09:	; 9683
	.byte MCMD_TRACK_CONFIG, $00

Track_02_NSE_03:	; 9685
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $66
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $6D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $69
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $6D, $6D, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $05
	sda1 Track_02_NSE_03
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $8D, $60, $65, $6D, $60, $8D, $60, $65, $6D, $60
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $6C, $6C, $6C, $6C
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $6D, $6D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte $6D, $6D, $6D, $6D, $65, $60, $6D, $60, $65, $60, $6D, $65
Track_02_NSE_04:	; 96C1

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $78
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $8D
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte MCMD_NOTEATTACKLEN_SET, $46
	.byte $88
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $07
	sda1 Track_02_NSE_04

Track_02_NSE_05:	; 96D1
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $78
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $8D
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte MCMD_NOTEATTACKLEN_SET, $46
	.byte $88
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $13
	sda1 Track_02_NSE_05
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte MCMD_NOTEATTACKLEN_SET, $9A
	.byte $8D, $86, $8D, $86, $8D, $86, $6D, $6D, $6D, $68
Track_02_NSE_06:	; 96EF

	.byte MCMD_TRACK_CONFIG, $00
	.byte $8D, $86, $8D, $86, $8D, $86, $8D, $86
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_02_NSE_06
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $6D, $6D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $07
	.byte $6D, $6D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $6D, $6D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $6D, $6D, $6D, $6D
Track_02_NSE_07:	; 9715

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $66
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $6D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $69
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $6D, $6D, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $05
	sda1 Track_02_NSE_07
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $88
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $88
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $88, $88
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $88
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $88
Track_02_NSE_08:	; 9749

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $96
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $66
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $6D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $69
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte $6D, $6D, $6D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $05
	sda1 Track_02_NSE_08
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $6D, $6D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte $6D, $6D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $6D, $6D, $6D, $6D
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte $6D, $6D, $6D, $6D
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_02_NSE_09
	.byte MCMD_TRACK_STOP
