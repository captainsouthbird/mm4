	.byte $07	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $04	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $30, $40, $0F	; Sequential command parameters
	.byte $37	; Note value
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $35, $80, $0F	; Sequential command parameters
	.byte $41	; Note value

	.byte $00	; Serial commands
	.byte $00	; -> Sound_RestTimer
	.byte $00	; Channel setting

	.byte $FF	; Terminator
