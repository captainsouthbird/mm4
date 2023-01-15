	.byte $07	; Priority / loop setting

	.byte SCMDBIT_NOTELEN | SCMDBIT_TRANSPOSE	; Serial commands
	.byte $FF	; Note length
	.byte $F1	; Transpose value
	.byte $30	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_TRIANGLE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $28, $80, $0F, $8B	; Sequential command parameters
	.byte $21	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $28, $FF, $8D	; Sequential command parameters
	.byte $2D	; Note value

	.byte $FF	; Terminator
