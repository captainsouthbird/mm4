	.byte $09	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $6F	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $2C, $C0, $0F, $40	; Sequential command parameters
	.byte $14	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $2D, $0F, $7F	; Sequential command parameters
	.byte $06	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $0B	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $2F, $08, $7F	; Sequential command parameters
	.byte $30	; Note value
	.byte SCMD_PATCH_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $2E, $FF	; Sequential command parameters
	.byte $07	; Note value

	.byte $FF	; Terminator
