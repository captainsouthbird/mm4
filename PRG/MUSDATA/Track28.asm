	.byte $10	; Priority / loop setting


Track_28_00:	; $CF39
	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $E9	; Note length
	.byte $06	; -> Sound_RestTimer
	.byte SCHAN_TRIANGLE | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $02, $6E	; Sequential command parameters
	.byte $2E	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $2C, $0F	; Sequential command parameters
	.byte $05	; Note value

	.byte SCMDBIT_LOOP | SCMDBIT_NOTELEN	; Serial commands
	.byte $05	; Loop count
	sda2 Track_28_00
	.byte $90	; Note length
	.byte $23	; -> Sound_RestTimer
	.byte SCHAN_TRIANGLE | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $02, $39	; Sequential command parameters
	.byte $22	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $33, $0F, $4F	; Sequential command parameters
	.byte $08	; Note value

	.byte $FF	; Terminator
