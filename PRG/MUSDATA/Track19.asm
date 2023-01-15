	.byte $07	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $46	; Note length
	.byte $04	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $15, $0F, $7F	; Sequential command parameters
	.byte $55	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $38, $0B	; Sequential command parameters
	.byte $0D	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $20	; Note length
	.byte $0D	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $14, $00	; Sequential command parameters
	.byte $59	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $3D, $0F	; Sequential command parameters
	.byte $0E	; Note value

	.byte $FF	; Terminator
