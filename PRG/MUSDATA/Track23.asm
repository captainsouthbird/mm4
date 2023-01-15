	.byte $07	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $6F	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET | SCMD_FREQFINEOFFSET_SET	; Sequential commands
	.byte $35, $40, $0F, $90, $08	; Sequential command parameters
	.byte $41	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET | SCMD_FREQFINEOFFSET_SET	; Sequential commands
	.byte $31, $0F, $2A, $7F	; Sequential command parameters
	.byte $10	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $82	; Note length
	.byte $02	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_NOISE	; Channel setting
	.byte $00	; Sequential commands
	.byte $41	; Note value
	.byte $00	; Sequential commands
	.byte $10	; Note value

	.byte $FF	; Terminator
