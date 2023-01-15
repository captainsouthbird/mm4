	.byte $06	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $1F	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_TRIANGLE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $28, $40, $0F	; Sequential command parameters
	.byte $1C	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQFINEOFFSET_SET	; Sequential commands
	.byte $0A, $FF, $FC	; Sequential command parameters
	.byte $24	; Note value

	.byte $FF	; Terminator
