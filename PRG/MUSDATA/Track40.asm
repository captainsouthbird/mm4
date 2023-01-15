	.byte $06	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $0A	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_TRIANGLE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQFINEOFFSET_SET	; Sequential commands
	.byte $3F, $00, $0F, $07	; Sequential command parameters
	.byte $58	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $3F, $FF	; Sequential command parameters
	.byte $4C	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $0A	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_TRIANGLE	; Channel setting
	.byte $00	; Sequential commands
	.byte $58	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $00	; Sequential command parameters
	.byte $4C	; Note value

	.byte $FF	; Terminator
