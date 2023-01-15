	.byte $00	; Music header tag
	sda1 Track_0A_SQ1	; Square 1
	sda1 Track_0A_SQ2	; Square 2
	sda1 Track_0A_TRI	; Triangle
	sda1 Track_0A_NSE	; Noise

Track_0A_SQ1:
	.byte MCMD_TEMPO_SET, $01, $69
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $F8
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_TEMPO_SET, $01, $55
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $B1, $8F, $91, $8F, $B4, $88, $AD, $8F, $8D, $AC, $A5, $AA, $8C, $8D, $88, $AD, $81
	.byte MCMD_SET_1_5X_TIMING
	.byte $AD, $6C, $6D, $8F, $8C, $8D, $8F, $B1, $8F, $91
	.byte MCMD_SET_1_5X_TIMING
	.byte $AF, $91
	.byte MCMD_SET_1_5X_TIMING
	.byte $AF, $8D, $60, $6C, $8D, $B1, $B2, $91, $92, $AE, $91
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8F
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8F
	.byte MCMD_TEMPO_SET, $01, $33
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AC
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6C
	.byte MCMD_TEMPO_SET, $01, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $A8
	.byte MCMD_TEMPO_SET, $01, $24
	.byte $B0
	.byte MCMD_SET_1_5X_TIMING
	.byte $8F, $70, $92, $90, $8F, $90
	.byte MCMD_SET_1_5X_TIMING
	.byte $B0
	.byte MCMD_SET_1_5X_TIMING
	.byte $AD, $AF, $80, $90
	.byte MCMD_SET_1_5X_TIMING
	.byte $8F, $70, $92, $90, $92, $94
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B4
	.byte MCMD_TEMPO_SET, $01, $4C
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B4
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $B1, $B2, $B4
	.byte MCMD_TEMPO_SET, $01, $69
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $B5
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $74, $75, $74
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $92, $70, $AF, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $B4
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $51
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $72, $90, $6F, $8D, $60, $6D, $6F
	.byte MCMD_SET_1_5X_TIMING
	.byte $B0, $6F, $70, $8F
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $50, $4F, $50, $4F, $50, $4F, $50, $4F, $50, $4F, $50, $4F
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8F
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8F, $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AD
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $4D
	.byte MCMD_PATCH_SET, $10
	.byte $CD
	.byte MCMD_TRACK_STOP


Track_0A_SQ2:
	.byte MCMD_SET_1_5X_TIMING
	.byte $60
	.byte MCMD_FREQFINEOFFSET_SET, $FF
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte MCMD_PATCH_SET, $0C
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $B1, $8F, $91, $8F, $B4, $88, $AD, $8F, $8D, $AC, $A5, $AA, $8C, $8D, $88, $AD, $81
	.byte MCMD_SET_1_5X_TIMING
	.byte $AD, $6C, $6D, $4F
	.byte MCMD_DUTYCYCLE_SET, $80
	.byte MCMD_NOTEATTACKLEN_SET, $F0
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_PATCH_SET, $08
	.byte MCMD_OCTAVE_SET, $02
	.byte $88, $8A, $8C
	.byte MCMD_SET_1_5X_TIMING
	.byte $A8, $88
	.byte MCMD_SET_1_5X_TIMING
	.byte $A9, $89, $AC, $AA, $A8, $AB
	.byte MCMD_SET_1_5X_TIMING
	.byte $AA, $8A
	.byte MCMD_SET_1_5X_TIMING
	.byte $A8, $8A, $86
	.byte MCMD_SET_1_5X_TIMING
	.byte $96
	.byte MCMD_SET_1_5X_TIMING
	.byte $94, $83, $AF, $83
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $B4, $B9, $BB
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $A8, $88, $66, $64, $86, $64, $63, $84, $63, $61, $63, $61
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $98, $B4, $B9, $BB
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $A8, $C1
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $AD, $AF, $B1
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $AD, $8B, $89, $68, $A6, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $AC, $88, $86, $64, $81, $61
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $74, $77, $D9, $DB, $FD
	.byte MCMD_TRACK_STOP


Track_0A_TRI:
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $03
	.byte $8D, $91, $94, $99, $8C, $91, $94, $98, $8A, $8D, $91, $96, $88, $8C, $91, $94, $86, $8A, $8D, $92, $8D, $91, $94, $91, $8F, $93, $96, $93, $94, $8F, $8D, $8C, $8D, $91, $94, $99, $8C, $91, $94, $98, $8A, $8D, $91, $96, $88, $8D, $91, $94, $86, $8A, $8D, $92, $8A, $8E, $91, $94, $83, $87, $8A, $8F, $88, $8F, $8C, $8F, $94, $99, $9C
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $92, $97, $9B, $9E, $90, $95, $99, $9C, $92, $97, $9B, $9E, $94, $99, $9C
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $92, $97, $9B, $9E, $90, $95, $99, $9C, $8D, $94, $99, $9D, $92, $95, $99, $9E, $92, $97, $9B, $9E, $92, $98, $9B, $98, $8D, $94, $9C
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $95, $99, $9C
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $97, $9B, $9E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $8B, $81, $85, $88, $8C, $CD
	.byte MCMD_TRACK_STOP


Track_0A_NSE:
	.byte MCMD_TRACK_STOP
