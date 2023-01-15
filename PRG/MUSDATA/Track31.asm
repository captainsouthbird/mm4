	.byte $07	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $02	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $2C, $80, $0F, $6E	; Sequential command parameters
	.byte $59	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $3C, $0F, $4A	; Sequential command parameters
	.byte $09	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $04	; -> Sound_RestTimer
	.byte $00	; Channel setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $37	; Note length
	.byte $09	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_NOISE	; Channel setting
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $0B	; Sequential command parameters
	.byte $59	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $07, $0F	; Sequential command parameters
	.byte $0D	; Note value

	.byte $FF	; Terminator
