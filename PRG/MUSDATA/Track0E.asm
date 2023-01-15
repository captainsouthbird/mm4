	.byte $00	; Music header tag
	sda1 Track_0E_SQ1	; Square 1
	sda1 Track_0E_SQ2	; Square 2
	sda1 Track_0E_TRI	; Triangle
	sda1 Track_0E_NSE	; Noise

Track_0E_SQ1:
	.byte MCMD_TEMPO_SET, $02, $00
	.byte MCMD_GLOBAL_TRANSPOSE_SET, $FA
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $C0
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $74, $74, $74, $73, $60, $73, $60, $72, $60, $72, $60, $70
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $B1
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $D1
	.byte MCMD_TRACK_STOP


Track_0E_SQ2:
	.byte $C0
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $72, $72, $72, $70, $60, $70, $60, $6F, $60, $6F, $60, $6C
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $AD
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $CD
	.byte MCMD_TRACK_STOP


Track_0E_TRI:
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_OCTAVE_SET, $03
	.byte $74, $74, $9D, $74, $74, $9D
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $74, $74, $74, $73, $60, $73, $60, $72, $60, $72, $60, $70
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_SET_1_5X_TIMING
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $C1
	.byte MCMD_TOGGLE_SINE_RESET
	.byte $21
	.byte MCMD_TRACK_STOP


Track_0E_NSE:
	.byte MCMD_TRACK_STOP
