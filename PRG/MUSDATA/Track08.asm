	.byte $00	; Music header tag
	sda1 Track_08_SQ1	; Square 1
	sda1 Track_08_SQ2	; Square 2
	sda1 Track_08_TRI	; Triangle
	sda1 Track_08_NSE	; Noise

Track_08_SQ1:

Track_08_SQ1_00:	; AB10
	.byte MCMD_TRACK_CONFIG, $08
	.byte MCMD_TEMPO_SET, $01, $EB
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $F7
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte $69, $69, $60, $68, $80, $A9, $68, $60, $69, $60, $6B, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $88, $65
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0, $68, $68, $60, $65, $80, $A8, $68, $60, $69, $60, $68, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $89, $66
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte MCMD_SET_1_5X_TIMING
	.byte $8D
	.byte MCMD_SET_1_5X_TIMING
	.byte $8B
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $89
	.byte MCMD_FREQOFFSET_SET, $32
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8B
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $89, $88
	.byte MCMD_SET_1_5X_TIMING
	.byte $89
	.byte MCMD_SET_1_5X_TIMING
	.byte $88, $86, $81, $A0, $66, $68, $C9, $AB, $A4
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte MCMD_SET_1_5X_TIMING
	.byte $CD, $80
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte $6B, $6D
	.byte MCMD_PATCH_SET, $0D
	.byte $CE, $70, $60, $6E, $6D, $60, $6B, $60
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6C
	.byte MCMD_FREQOFFSET_SET, $32
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD
	.byte MCMD_FREQOFFSET_SET, $00
	.byte $6E, $60, $6D, $6B, $60, $69, $60
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6B
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $8B, $89, $88, $86, $A5, $AE, $AD, $C0, $80, $6E, $70, $D2, $74, $60, $75, $77, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $94, $D0, $72, $60, $73, $72, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $90
	.byte MCMD_SET_1_5X_TIMING
	.byte $AE, $6D, $6E, $D5, $B4, $A0, $AD, $B1
	.byte MCMD_SET_1_5X_TIMING
	.byte $92
	.byte MCMD_SET_1_5X_TIMING
	.byte $92, $92, $B4, $B1
	.byte MCMD_SET_1_5X_TIMING
	.byte $94
	.byte MCMD_SET_1_5X_TIMING
	.byte $92, $74, $75, $CD
	.byte MCMD_SET_1_5X_TIMING
	.byte $92
	.byte MCMD_SET_1_5X_TIMING
	.byte $92, $92, $B4, $B1, $F2
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_08_SQ1_00
	.byte MCMD_TRACK_STOP


Track_08_SQ2:

Track_08_SQ2_05:	; ABC4
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_PATCH_SET, $17
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte $7E, $7E, $60, $7D, $80, $BE, $7D, $60, $7E, $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $85, $61
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0, $65, $65, $60, $61, $80, $A5, $65, $60, $66, $60, $65, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $86, $61
	.byte MCMD_SET_1_5X_TIMING
	.byte $C0
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_NOTEATTACKLEN_SET, $E6
	.byte MCMD_SET_1_5X_TIMING
	.byte $89
	.byte MCMD_SET_1_5X_TIMING
	.byte $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $86
	.byte MCMD_FREQOFFSET_SET, $32
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88
	.byte MCMD_FREQOFFSET_SET, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $86, $84
	.byte MCMD_SET_1_5X_TIMING
	.byte $86
	.byte MCMD_SET_1_5X_TIMING
	.byte $85, $82
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $94, $A0, $75, $77, $DE
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $A8
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $B7
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $C9, $80
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte $62, $64
Track_08_SQ2_01:	; AC20

	.byte MCMD_TRACK_CONFIG, $00
	.byte $72, $77, $7A, $7E
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda1 Track_08_SQ2_01
	.byte $72, $77, $7A
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $72
Track_08_SQ2_02:	; AC2F

	.byte MCMD_TRACK_CONFIG, $00
	.byte $72, $75, $79, $7D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda1 Track_08_SQ2_02
	.byte $72, $75, $79, $7D
Track_08_SQ2_03:	; AC3D

	.byte MCMD_TRACK_CONFIG, $00
	.byte $71, $74, $77, $79
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_08_SQ2_03

Track_08_SQ2_04:	; AC47
	.byte MCMD_TRACK_CONFIG, $00
	.byte $74, $77, $79, $7D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_08_SQ2_04
	.byte MCMD_SET_1_5X_TIMING
	.byte $60
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte MCMD_FREQFINEOFFSET_SET, $01
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $D2, $74, $60, $75, $77, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $94, $D0, $72, $60, $73, $72, $60
	.byte MCMD_SET_1_5X_TIMING
	.byte $90
	.byte MCMD_SET_1_5X_TIMING
	.byte $AE, $6D, $6E, $D5, $B4, $80, $40, $AD, $B1
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte MCMD_FREQFINEOFFSET_SET, $00
	.byte MCMD_SET_1_5X_TIMING
	.byte $89
	.byte MCMD_SET_1_5X_TIMING
	.byte $89, $89, $AB, $A8
	.byte MCMD_SET_1_5X_TIMING
	.byte $8B
	.byte MCMD_SET_1_5X_TIMING
	.byte $89, $6B, $6D, $A4, $A5
	.byte MCMD_SET_1_5X_TIMING
	.byte $89
	.byte MCMD_SET_1_5X_TIMING
	.byte $89, $89, $AB, $A8, $E9
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_08_SQ2_05
	.byte MCMD_TRACK_STOP


Track_08_TRI:

Track_08_TRI_06:	; AC93
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $03
	.byte $8D, $8D, $6D, $6D, $60, $8D, $8D, $6D, $8D, $8D, $8D, $8D, $6D, $6D, $60, $8D, $8D, $6D, $8D, $8D, $8D, $8D, $6D, $6D, $60, $8D, $8D, $6D, $8D, $8D, $8D, $8D, $6D, $6D, $60, $8D, $8D, $6D, $8D, $8D
	.byte MCMD_OCTAVE_SET, $04
	.byte $86, $86, $8D, $66, $64, $60, $84, $64, $8B, $84, $82, $82, $89, $62, $61, $60, $81, $61, $88, $81, $82, $82, $89, $62, $64, $60, $84, $64, $8B, $84, $85, $86, $8D, $66, $66, $60, $86, $66, $8D, $86, $8B, $8B, $92, $6B, $6B, $60, $8B, $6B, $92, $6B
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $69
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $89, $89, $90, $69, $69, $60, $89, $69, $90
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $88, $88, $88, $6F, $68, $60, $88, $69, $89, $8A, $8D, $8D, $8D, $6D, $6E, $60, $8B, $6B, $8D, $80, $89, $89, $89, $89, $8B, $8B, $8B, $8B, $8D, $8D, $8D, $8D, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8E, $8F, $8F, $8F, $8F, $91, $91, $91, $91, $C0
	.byte MCMD_SET_1_5X_TIMING
	.byte $92, $72, $8D, $92
	.byte MCMD_SET_1_5X_TIMING
	.byte $90, $70, $8D, $91
	.byte MCMD_SET_1_5X_TIMING
	.byte $8E, $6E, $89, $8E, $90, $90, $91, $91
	.byte MCMD_SET_1_5X_TIMING
	.byte $92, $72, $8D, $92
	.byte MCMD_SET_1_5X_TIMING
	.byte $90, $70, $8D, $91, $72, $72, $72, $72, $60, $72, $60, $72, $60, $72, $60, $6D, $72
	.byte MCMD_SET_1_5X_TIMING
	.byte $80
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_08_TRI_06
	.byte MCMD_TRACK_STOP


Track_08_NSE:

Track_08_NSE_0D:	; AD67
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte MCMD_PATCH_SET, $01

Track_08_NSE_07:	; AD6F
	.byte MCMD_TRACK_CONFIG, $00
	.byte $8D, $86
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $0D
	sda1 Track_08_NSE_07

Track_08_NSE_08:	; AD77
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $66, $66
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte $8D
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_08_NSE_08

Track_08_NSE_09:	; AD84
	.byte MCMD_TRACK_CONFIG, $00
	.byte $86, $86, $8D, $86, $86, $60, $8D, $60, $86, $86, $86, $8D, $86, $86, $80, $8D, $86
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $03
	sda1 Track_08_NSE_09

Track_08_NSE_0A:	; AD9B
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte $8D
	.byte MCMD_SYNTH_VOLUME_SET, $06
	.byte $86
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $0D
	sda1 Track_08_NSE_0A
	.byte MCMD_NOTEATTACKLEN_SET, $78
	.byte $66, $66, $66, $66, $65, $65, $65, $65
Track_08_NSE_0B:	; ADB3

	.byte MCMD_TRACK_CONFIG, $00
	.byte $65, $60, $60, $65
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte $68, $60
	.byte MCMD_NOTEATTACKLEN_SET, $96
	.byte $65, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $02
	sda1 Track_08_NSE_0B
	.byte MCMD_NOTEATTACKLEN_SET, $78
	.byte $66, $66, $66, $66, $65, $65, $65, $65
Track_08_NSE_0C:	; ADCF

	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte $65, $60, $60, $65
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte $68, $60
	.byte MCMD_NOTEATTACKLEN_SET, $96
	.byte $65, $60
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda1 Track_08_NSE_0C
	.byte $66, $66, $66, $66, $60, $66, $60, $66, $60, $66, $60, $66, $86, $80
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_08_NSE_0D
	.byte MCMD_TRACK_STOP
