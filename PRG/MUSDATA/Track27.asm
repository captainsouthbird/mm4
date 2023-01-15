	.byte $07	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $0A	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET | SCMD_FREQFINEOFFSET_SET	; Sequential commands
	.byte $45, $40, $0A, $0B, $EC	; Sequential command parameters
	.byte $31	; Note value

	.byte $FF	; Terminator
