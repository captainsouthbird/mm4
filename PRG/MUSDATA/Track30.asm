	.byte $06	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $04	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $2E, $C0, $0F	; Sequential command parameters
	.byte $31	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $04	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $35	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $04	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $38	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $3B	; Note value

	.byte $FF	; Terminator
