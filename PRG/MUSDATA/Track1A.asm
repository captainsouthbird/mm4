	.byte $07	; Priority / loop setting


Track_1A_00:	; $CD70
	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $02	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_TRIANGLE | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $35, $C0, $0F	; Sequential command parameters
	.byte $0D	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $01, $FF	; Sequential command parameters
	.byte $1B	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $00, $0D	; Sequential command parameters
	.byte $04	; Note value

	.byte $00	; Serial commands
	.byte $01	; -> Sound_RestTimer
	.byte $00	; Channel setting

	.byte SCMDBIT_LOOP	; Serial commands
	.byte $05	; Loop count
	sda2 Track_1A_00
	.byte $00	; -> Sound_RestTimer
	.byte $00	; Channel setting

	.byte $FF	; Terminator
