	.byte $07	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $01	; Note length
	.byte $3A	; -> Sound_RestTimer
	.byte SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $33, $0F	; Sequential command parameters
	.byte $0B	; Note value

	.byte $FF	; Terminator
