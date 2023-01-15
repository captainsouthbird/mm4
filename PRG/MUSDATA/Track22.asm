	.byte $07	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $08	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET | SCMD_FREQFINEOFFSET_SET	; Sequential commands
	.byte $45, $40, $0C, $C8, $00	; Sequential command parameters
	.byte $24	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $07	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $25	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $07	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $26	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $07	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $27	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $07	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $28	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $07	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $29	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $07	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $2A	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $07	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $2B	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $07	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $0A	; Sequential command parameters
	.byte $2C	; Note value

	.byte $FF	; Terminator
