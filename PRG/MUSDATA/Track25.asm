	.byte $15	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $0E	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $2A, $80, $0F, $7F	; Sequential command parameters
	.byte $3E	; Note value
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $2A, $40, $0F, $7F	; Sequential command parameters
	.byte $3E	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $0E	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2	; Channel setting
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $0C	; Sequential command parameters
	.byte $3E	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $0C	; Sequential command parameters
	.byte $3E	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $0E	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2	; Channel setting
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $09	; Sequential command parameters
	.byte $3E	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $09	; Sequential command parameters
	.byte $3E	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $0E	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2	; Channel setting
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $06	; Sequential command parameters
	.byte $3E	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $06	; Sequential command parameters
	.byte $3E	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $0E	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2	; Channel setting
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $03	; Sequential command parameters
	.byte $3E	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $03	; Sequential command parameters
	.byte $3E	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $0E	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2	; Channel setting
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $01	; Sequential command parameters
	.byte $3E	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $01	; Sequential command parameters
	.byte $3E	; Note value

	.byte $FF	; Terminator
