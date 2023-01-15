	.byte $10	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $8C	; Note length
	.byte $4B	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $44, $80, $0F	; Sequential command parameters
	.byte $2A	; Note value
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $44, $80, $0F	; Sequential command parameters
	.byte $26	; Note value

	.byte $FF	; Terminator
