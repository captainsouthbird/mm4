	.byte $00	; Music header tag
	sda2 Track_14_SQ1	; Square 1
	sda2 Track_14_SQ2	; Square 2
	sda2 Track_14_TRI	; Triangle
	sda2 Track_14_NSE	; Noise

Track_14_SQ1:

Track_14_SQ1_00:	; C3CE
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_TEMPO_SET, $01, $D8
	.byte MCMD_DUTYCYCLE_SET, $C0
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_PATCH_SET, $21
	.byte MCMD_OCTAVE_SET, $01
	.byte $7D, $7D, $7B, $7B, $78, $78, $91, $80, $78, $78, $7B, $7B, $7C, $7C, $7D, $7D, $7B, $7B, $78, $78, $91, $80, $78, $78, $7B, $78, $7B, $7C
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_14_SQ1_00
	.byte MCMD_TRACK_STOP


Track_14_SQ2:

Track_14_SQ2_01:	; C3FD
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_FREQFINEOFFSET_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $40
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_SYNTH_VOLUME_SET, $0D
	.byte MCMD_PATCH_SET, $00
	.byte MCMD_OCTAVE_SET, $02
	.byte $65, $65, $63, $63
	.byte MCMD_OCTAVE_SET, $01
	.byte $6C, $6C, $85, $80, $6C, $6C, $6F, $6F, $70, $70, $71, $71, $6F, $6F, $6C, $6C, $85, $80, $6C, $6C, $6F, $6C, $6F, $70
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_14_SQ2_01
	.byte MCMD_TRACK_STOP


Track_14_TRI:

Track_14_TRI_02:	; C42D
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte MCMD_PATCH_SET, $04
	.byte MCMD_OCTAVE_SET, $02
	.byte $96, $80, $9D, $80, $80, $96, $9D, $80, $96, $80, $9D, $80, $76, $7D, $76, $76, $7D, $76, $7D, $7D
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_14_TRI_02
	.byte MCMD_TRACK_STOP


Track_14_NSE:

Track_14_NSE_05:	; C44D
	.byte MCMD_TRACK_CONFIG, $00

Track_14_NSE_04:	; C44F
	.byte MCMD_TRACK_CONFIG, $00
	.byte MCMD_SYNTH_VOLUME_SET, $08
	.byte MCMD_PATCH_SET, $01
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte $65, $65, $65, $65
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_NOTEATTACKLEN_SET, $32
	.byte MCMD_PATCH_SET, $18
	.byte $68, $60
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte MCMD_PATCH_SET, $01
	.byte $65, $60, $80
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_PATCH_SET, $01
	.byte $65, $65
	.byte MCMD_LOOPCNT0_JMPLAST_CFG, $00
	sda2 Track_14_NSE_03
	.byte MCMD_PATCH_SET, $18
	.byte MCMD_NOTEATTACKLEN_SET, $32
	.byte $68, $60, $80
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_14_NSE_04

Track_14_NSE_03:	; C47F
	.byte MCMD_NOTEATTACKLEN_SET, $FA
	.byte $68, $60, $68, $68
	.byte MCMD_JUMP_ALWAYS
	sda2 Track_14_NSE_05
	.byte MCMD_TRACK_STOP
