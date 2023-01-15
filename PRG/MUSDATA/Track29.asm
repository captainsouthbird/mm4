	.byte $15	; Priority / loop setting


Track_29_00:	; $CF57
	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $04	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2 | SCHAN_TRIANGLE | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $29, $40, $0F	; Sequential command parameters
	.byte $3D	; Note value
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $29, $40, $0F	; Sequential command parameters
	.byte $41	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $00	; Sequential command parameters
	.byte $00	; Note value
	.byte $00	; Sequential commands
	.byte $00	; Note value

	.byte SCMDBIT_LOOP	; Serial commands
	.byte $02	; Loop count
	sda2 Track_29_00
	.byte $00	; -> Sound_RestTimer
	.byte $00	; Channel setting

	.byte $FF	; Terminator
