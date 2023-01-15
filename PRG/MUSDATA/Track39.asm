	.byte $08	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $2F	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_TRIANGLE | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $28, $80, $0F, $87	; Sequential command parameters
	.byte $21	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $28, $FF, $87	; Sequential command parameters
	.byte $2D	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $28, $0F, $88	; Sequential command parameters
	.byte $0C	; Note value

	.byte $FF	; Terminator
