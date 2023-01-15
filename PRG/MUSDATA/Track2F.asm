	.byte $06	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $11, $80, $0F	; Sequential command parameters
	.byte $3B	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $3D	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $3F	; Note value

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
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $06	; Sequential command parameters
	.byte $3B	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $3D	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $3F	; Note value

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

	.byte $FF	; Terminator
