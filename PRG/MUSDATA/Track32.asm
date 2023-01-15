	.byte $06	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $14	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $0A, $0F	; Sequential command parameters
	.byte $4A	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $0A, $0F	; Sequential command parameters
	.byte $0D	; Note value

	.byte $FF	; Terminator
