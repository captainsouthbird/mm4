	.byte $09	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $04	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_TRIANGLE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $28, $00, $0F	; Sequential command parameters
	.byte $52	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $28, $AF	; Sequential command parameters
	.byte $5E	; Note value

	.byte $FF	; Terminator
