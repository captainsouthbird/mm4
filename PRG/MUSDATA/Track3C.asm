	.byte $00	; Music header tag
	sda2 Track_3C_SQ1	; Square 1
	sda2 Track_3C_SQ2	; Square 2
	sda2 Track_3C_TRI	; Triangle
	sda2 Track_3C_NSE	; Noise

Track_3C_SQ1:
	.byte MCMD_TEMPO_SET, $02, $66
	.byte MCMD_NOTEATTACKLEN_SET, $96
	.byte MCMD_PATCH_SET, $08
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $C0

Track_3C_SQ1_00:	; D2D0
	.byte MCMD_TRACK_CONFIG, $28
	.byte $91, $A0, $91, $95, $93
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $D0
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_3C_SQ1_00
	.byte $80
	.byte MCMD_PATCH_SET, $1B
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $82, $83, $82, $84, $82, $85, $82
	.byte MCMD_PATCH_SET, $1B
	.byte MCMD_SYNTH_VOLUME_SET, $0C
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A5, $A6, $A7, $A8, $A9, $AA
	.byte MCMD_PATCH_SET, $08
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte MCMD_NOTEATTACKLEN_SET, $96
	.byte $96, $A0, $96, $96, $96, $B6, $B6, $B6
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $F6
	.byte MCMD_TRACK_STOP


Track_3C_SQ2:
	.byte MCMD_NOTEATTACKLEN_SET, $96
	.byte MCMD_PATCH_SET, $03
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte MCMD_OCTAVE_SET, $01
	.byte MCMD_DUTYCYCLE_SET, $40

Track_3C_SQ2_01:	; D311
	.byte MCMD_TRACK_CONFIG, $28
	.byte $89, $A0, $89, $89, $89
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $C8
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_3C_SQ2_01
	.byte MCMD_PATCH_SET, $1B
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte $88, $89, $8A, $88, $89, $8A, $88, $89
	.byte MCMD_PATCH_SET, $08
	.byte MCMD_TOGGLE_TIME_SEL
	.byte MCMD_TOGGLE_OCTAVE_HIGH
	.byte $B4, $B5, $B6, $B7, $B8, $B9, $9D, $A0, $9D, $9D, $9D, $BD, $BD, $BD
	.byte MCMD_NOTEATTACKLEN_SET, $B4
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $FD
	.byte MCMD_TRACK_STOP


Track_3C_TRI:
	.byte MCMD_NOTEATTACKLEN_SET, $C8
	.byte MCMD_OCTAVE_SET, $02
	.byte MCMD_PATCH_SET, $01

Track_3C_TRI_02:	; D347
	.byte MCMD_TRACK_CONFIG, $20
	.byte $97, $A0, $97, $97, $97
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $D6
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_3C_TRI_02
	.byte $CE, $CF, $D1, $D2
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $97, $A0, $97, $97, $97, $B7, $B7, $B7
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $F7
	.byte MCMD_TRACK_STOP


Track_3C_NSE:
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte MCMD_PATCH_SET, $0D

Track_3C_NSE_03:	; D36A
	.byte MCMD_TRACK_CONFIG, $20
	.byte $8C, $A0, $8C, $8C, $8C, $8C, $8C, $8C, $8C, $8C, $8C
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $01
	sda2 Track_3C_NSE_03
	.byte MCMD_PATCH_SET, $0B
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte MCMD_SYNTH_VOLUME_SET, $0A
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $A5, $A6, $A8, $AA
	.byte MCMD_SYNTH_VOLUME_SET, $0B
	.byte $AC, $AD, $AE, $AF
	.byte MCMD_NOTEATTACKLEN_SET, $64
	.byte MCMD_PATCH_SET, $0D
	.byte MCMD_SYNTH_VOLUME_SET, $09
	.byte MCMD_TOGGLE_TIME_SEL
	.byte $8C, $A0, $8C, $8C, $8C
	.byte MCMD_NOTEATTACKLEN_SET, $50
	.byte $AC, $AC, $AC
Track_3C_NSE_04:	; D39D

	.byte MCMD_TRACK_CONFIG, $20
	.byte MCMD_SYNTH_VOLUME_SET, $05
	.byte MCMD_NOTEATTACKLEN_SET, $FF
	.byte $4C
	.byte MCMD_LOOPCNT0_INIT_UPDATE, $29
	sda2 Track_3C_NSE_04
	.byte MCMD_TRACK_STOP
