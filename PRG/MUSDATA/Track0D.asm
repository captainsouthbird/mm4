	.byte $00	; Music header tag
	sda1 Track_0D_SQ1	; Square 1
	sda1 Track_0D_SQ2	; Square 2
	sda1 Track_0D_TRI	; Triangle
	sda1 Track_0D_NSE	; Noise

Track_0D_SQ1:

Track_0D_SQ1_00:	; B89F
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_TEMPO_SET, $01, $99
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $11
	.byte MCMD_OCTAVE_SET, $01
	.byte $60
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6B, $67, $6D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CE
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6E, $60, $78, $78, $60, $61, $64, $61, $66, $64, $61, $61, $60, $61, $64, $61, $45, $46, $64, $66, $68
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_0D_SQ1_00
	.byte MCMD_TRACK_STOP


Track_0D_SQ2:

Track_0D_SQ2_01:	; B8CF
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $11
	.byte MCMD_OCTAVE_SET, $02
	.byte $60, $7E, $7A
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $68
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C9
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $69, $60, $72, $72, $E0
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_0D_SQ2_01
	.byte MCMD_TRACK_STOP


Track_0D_TRI:

Track_0D_TRI_02:	; B8EC
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $02
	.byte $60, $79
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6C, $63
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C4
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $64, $60, $6D, $6D
	.byte MCMD_NOTEATTACKLEN_SET, $DC
	.byte MCMD_PATCH_SET, $0E
	.byte $6D, $60, $6D, $60, $68, $68, $60, $68, $60, $6D, $60, $6D, $68, $60, $68, $60
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_0D_TRI_02
	.byte MCMD_TRACK_STOP


Track_0D_NSE:

Track_0D_NSE_03:	; B918
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_PATCH_SET, $01
	.byte $65, $6D, $6D, $65, $68, $65, $6D, $65, $65, $65, $6D, $65, $63, $6D, $65, $6D, $65, $6D, $6D, $65, $68, $65, $6D, $65, $65, $65, $6D, $65, $68, $6D, $65, $6D
	.byte MCMD_JUMP_ALWAYS
	sda1 Track_0D_NSE_03
	.byte MCMD_TRACK_STOP
