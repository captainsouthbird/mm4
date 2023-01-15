	.byte $08	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $EB	; Note length
	.byte $0A	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $36, $40, $0F, $FF	; Sequential command parameters
	.byte $33	; Note value

	.byte $FF	; Terminator
