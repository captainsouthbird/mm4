	.byte $00	; Music header tag
	sda1 Track_12_SQ1	; Square 1
	sda1 Track_12_SQ2	; Square 2
	sda1 Track_12_TRI	; Triangle
	sda1 Track_12_NSE	; Noise

Track_12_SQ1:
	.byte MCMD_TEMPO_SET, $02, $66

Track_12_SQ1_00:	; BCC9
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $02
	.byte MCMD_SYNTH_VOLUME_SET, $0D
	.byte MCMD_NOTEATTACKLEN_SET, $78
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_OCTAVE_SET, $01
	.byte $80, $99, $9E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88, $80, $81, $86, $88, $80, $81, $86, $88, $8B, $89, $88, $89, $80, $82, $88, $89, $80, $82, $88, $89, $80, $82, $88, $89, $8B, $89, $88, $88, $80
	.byte MCMD_OCTAVE_SET, $01
	.byte $65, $66, $67, $68, $69, $6A, $6B, $6C, $6D, $6E, $6F, $70
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $91
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $91
	.byte MCMD_OCTAVE_SET, $02
	.byte $60, $20
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte $6D, $6E, $6D, $69, $6B, $68, $69, $66, $68, $65
	.byte MCMD_SET_1_5X_TIMING
	.byte $46
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte $92, $80, $6E, $70, $72, $70, $72, $74, $75, $74, $75, $77
	.byte MCMD_OCTAVE_SET, $02
	.byte $6D, $6C
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88, $64, $66, $68, $67, $68, $69, $68, $69, $6B, $6D, $69, $68
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $86
	.byte MCMD_FREQOFFSET_SET, $32
	.byte MCMD_PATCH_SET, $14
	.byte $66
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $61
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_FREQOFFSET_SET, $32
	.byte MCMD_TOGGLE_SINE_RESET
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $57, $59
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $79, $97, $95, $99, $97, $95
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $97
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $97, $95
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D2
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B2
	.byte MCMD_PATCH_SET, $0D
	.byte $80
	.byte MCMD_FREQOFFSET_SET, $3C
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $57, $59
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $79, $97, $95, $99, $9A, $99
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $99
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $99, $97
	.byte MCMD_TOGGLE_SINE_RESET
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C8
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $72, $74, $D5, $94, $80, $91, $92, $80
	.byte MCMD_FREQOFFSET_SET, $32
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $57, $59
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $79, $97, $95, $99, $97, $95
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $97
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $97, $95
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D2
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B2
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_FREQOFFSET_SET, $3C
	.byte $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $57, $59
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $79, $97, $95, $99, $97, $95
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $99
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $99, $9A
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D7
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B7
	.byte MCMD_NOTEATTACKLEN_SET, $AA
	.byte MCMD_PATCH_SET, $0D
	.byte $80, $9E, $9E, $9C, $9E, $9E, $9C, $9E, $80, $92, $92, $90, $92, $92, $90, $92, $80, $9E, $9E, $9C, $9E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $89, $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $66
	.byte MCMD_FREQOFFSET_SET, $5A
	.byte $46
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $41
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_12_SQ1_00
	.byte MCMD_TRACK_STOP


Track_12_SQ2:

Track_12_SQ2_03:	; BDF2
	.byte MCMD_TRACK_CONFIG, $00
	.byte $80, $20
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_NOTEATTACKLEN_SET, $78
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_OCTAVE_SET, $01
	.byte $80, $99, $9E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $88, $80, $81, $86, $88, $80, $81, $86, $88, $8B, $89, $88, $89, $80, $82, $88, $89, $80, $82, $88, $89, $80, $82, $88, $89, $8B, $89
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $68, $48
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $28
	.byte MCMD_FREQFINEOFFSET_SET, $FF
	.byte $80, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $40
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte $65, $66, $67, $68, $69, $6A, $6B, $6C, $6D, $6E, $2F
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88
	.byte MCMD_OCTAVE_SET, $02
	.byte $6D, $6E, $6D, $69, $6B, $68, $69, $66, $68, $65, $66, $67
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $95, $80, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $40
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte $7A, $7C, $7E, $7C, $7E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68, $69, $68, $69, $6B, $2D
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_TOGGLE_SINE_RESET
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $97
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $97
	.byte MCMD_PATCH_SET, $0D
	.byte $77, $79, $7A, $79, $7A, $7C, $7E, $7C, $7E
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68, $69, $6B
	.byte MCMD_FREQFINEOFFSET_SET, $00
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_FREQOFFSET_SET, $32
	.byte MCMD_PATCH_SET, $14
	.byte $6D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $69
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $95, $8D, $90, $92, $94, $92, $8D, $80, $92, $8D, $90, $89, $90, $92, $94, $80, $95, $8D, $90, $92, $94, $95, $8B, $80, $92, $90, $92, $80, $92, $90, $74, $72, $D0, $B1, $94, $95, $80, $95, $94, $92, $95, $94, $92
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $94
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $94, $92, $AD, $81, $8B, $89, $86, $84
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $89, $88, $86, $89, $88, $86
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88, $8B, $A8
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $94, $92, $90, $8D, $90
Track_12_SQ2_02:	; BED8

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_FREQFINEOFFSET_SET, $01
	.byte $99, $99, $97, $99, $99, $97
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $00
	sda1 Track_12_SQ2_01
	.byte $99, $80
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda1 Track_12_SQ2_02

Track_12_SQ2_01:	; BEEE
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $79
	.byte MCMD_FREQOFFSET_SET, $55
	.byte $59
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $55
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_12_SQ2_03
	.byte MCMD_TRACK_STOP


Track_12_TRI:
	.byte MCMD_NOTEATTACKLEN_SET, $D2
	.byte MCMD_OCTAVE_SET, $03
	.byte MCMD_PATCH_SET, $00
	.byte $86
Track_12_TRI_06:	; BF02

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $D2
	.byte MCMD_OCTAVE_SET, $03
	.byte $86, $86, $86, $86, $86, $86
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $84
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $84, $84, $84, $84, $84, $84, $84
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $82
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $82, $82, $82, $82, $82, $82, $82
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $82
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $82, $82, $82, $82, $82, $82, $82
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_NOTEATTACKLEN_SET, $EB
	.byte $8B
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0, $8E
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0, $80
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $90
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $90
	.byte MCMD_PATCH_SET, $04
	.byte $8B, $6B, $6B, $89, $68, $68, $85, $87
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_NOTEATTACKLEN_SET, $D2
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $92
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $92, $92, $92, $92, $92, $92, $92
Track_12_TRI_05:	; BF5C

	.byte MCMD_TRACK_CONFIG, $40
	.byte $92
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $92, $92, $92, $92, $92, $92, $92
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $90
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $90, $90, $90, $90, $90, $90, $90
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8E
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8E, $8E, $8E, $8E, $8E, $8E, $8E
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $00
	sda1 Track_12_TRI_04
	.byte $8E, $8D, $8D, $8E, $8E, $90, $90, $91, $92, $80, $92, $B9, $8D, $90, $95
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_12_TRI_05

Track_12_TRI_04:	; BF92
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8D, $B0, $B1, $92, $95, $92, $80, $B0, $B1, $92, $95
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $97
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $97, $95, $92, $90, $99, $97, $95
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $B2
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_12_TRI_06
	.byte MCMD_TRACK_STOP


Track_12_NSE:
	.byte MCMD_NOTEATTACKLEN_SET, $96
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_PATCH_SET, $01
	.byte $85
Track_12_NSE_0A:	; BFBA

	.byte MCMD_TRACK_CONFIG, $00
	.byte $80, $87, $8D, $85, $8D, $87, $85
Track_12_NSE_07:	; BFC3

	.byte MCMD_TRACK_CONFIG, $00
	.byte $8D, $85, $87, $8D, $85, $8D, $87, $85
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_12_NSE_07
	.byte $8D, $85, $87, $8D, $85, $8D, $87, $87, $80, $80, $85, $80, $85, $80, $85
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte $87, $80, $80
	.byte MCMD_NOTEATTACKLEN_SET, $96
	.byte $85, $80, $85, $80, $85, $87, $80, $80, $85, $80, $85, $80, $85
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte $87, $80
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $8B, $6B, $6B, $89, $68, $68, $85, $87, $85
	.byte MCMD_NOTEATTACKLEN_SET, $82
	.byte $80, $85, $87, $8D, $85, $8D, $87, $85
Track_12_NSE_09:	; C00D

	.byte MCMD_TRACK_CONFIG, $00
	.byte $8D, $85, $87, $8D, $85, $85, $87, $85, $8D, $85, $87, $8D, $85, $8D, $87, $85, $8D, $85, $87, $8D, $85, $85, $87, $85, $85, $8D, $87, $85, $87, $85, $87, $85
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $00
	sda1 Track_12_NSE_08
	.byte $80, $85
	.byte MCMD_NOTEATTACKLEN_SET, $37
	.byte $AB
	.byte MCMD_NOTEATTACKLEN_SET, $82
	.byte $85, $8D, $87, $85
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_12_NSE_09

Track_12_NSE_08:	; C042
	.byte $80, $85, $87, $85, $87, $89, $67, $67, $85, $80, $8B, $8B, $89, $68, $68, $85, $87, $85, $80
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_12_NSE_0A
	.byte MCMD_TRACK_STOP
