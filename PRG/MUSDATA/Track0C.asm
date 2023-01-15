	.byte $00	; Music header tag
	sda1 Track_0C_SQ1	; Square 1
	sda1 Track_0C_SQ2	; Square 2
	sda1 Track_0C_TRI	; Triangle
	sda1 Track_0C_NSE	; Noise

Track_0C_SQ1:
	.byte MCMD_TEMPO_SET, $01, $EB
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0D
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6F, $6F, $80, $71, $71, $80, $72, $72, $80, $74, $72, $74
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $76, $D6
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D6
	.byte MCMD_TRACK_STOP


Track_0C_SQ2:
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0D
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $6B, $6B, $80, $6D, $6D, $80, $6E, $6E, $80, $71, $6F, $71
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $73, $D3
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D3
	.byte MCMD_TRACK_STOP


Track_0C_TRI:
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $01
	.byte $7E, $7E
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $8D
	.byte MCMD_PATCH_SET, $00
	.byte $68, $68
	.byte MCMD_PATCH_SET, $04
	.byte $8D
	.byte MCMD_PATCH_SET, $00
	.byte $69, $69
	.byte MCMD_PATCH_SET, $04
	.byte $8D
	.byte MCMD_PATCH_SET, $00
	.byte $6D, $6B, $6D
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $6F, $CF
	.byte MCMD_PATCH_SET, $10
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CF
	.byte MCMD_TRACK_STOP


Track_0C_NSE:
	.byte MCMD_TRACK_STOP
