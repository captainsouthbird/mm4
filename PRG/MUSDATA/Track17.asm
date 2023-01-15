	.byte $07	; Priority / loop setting


Track_17_00:	; $CD37
	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $02, $C0, $0F	; Sequential command parameters
	.byte $4C	; Note value

	.byte $00	; Serial commands
	.byte $03	; -> Sound_RestTimer
	.byte $00	; Channel setting

	.byte SCMDBIT_LOOP	; Serial commands
	.byte $02	; Loop count
	sda2 Track_17_00
	.byte $00	; -> Sound_RestTimer
	.byte $00	; Channel setting

	.byte $FF	; Terminator
