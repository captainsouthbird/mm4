	.byte $08	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $DC	; Note length
	.byte $05	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $3B, $C0, $0F	; Sequential command parameters
	.byte $0D	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $3B, $0B	; Sequential command parameters
	.byte $03	; Note value

	.byte $00	; Serial commands
	.byte $01	; -> Sound_RestTimer
	.byte $00	; Channel setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $53	; Note length
	.byte $56	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_NOISE	; Channel setting
	.byte SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $00	; Sequential command parameters
	.byte $0E	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $0F	; Sequential command parameters
	.byte $01	; Note value

	.byte $FF	; Terminator
