	.byte $08	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $3C	; Note length
	.byte $06	; -> Sound_RestTimer
	.byte SCHAN_TRIANGLE | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $3D, $C4, $EE	; Sequential command parameters
	.byte $1E	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $00, $0F, $82	; Sequential command parameters
	.byte $05	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $70	; Note length
	.byte $10	; -> Sound_RestTimer
	.byte SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $01, $91	; Sequential command parameters
	.byte $09	; Note value

	.byte $FF	; Terminator
