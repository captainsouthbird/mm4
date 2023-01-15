	.byte $09	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $28, $C0, $0F	; Sequential command parameters
	.byte $3E	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $40	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $42	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $43	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $45	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $47	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $49	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $4A	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $08	; Sequential command parameters
	.byte $3E	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $40	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $42	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $43	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $45	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $47	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $49	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $4A	; Note value

	.byte $FF	; Terminator
