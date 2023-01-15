	.byte $08	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2 | SCHAN_TRIANGLE | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $0A, $00, $08	; Sequential command parameters
	.byte $55	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $0A, $0F, $7F	; Sequential command parameters
	.byte $16	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $02, $FF	; Sequential command parameters
	.byte $20	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $30, $0F, $7F	; Sequential command parameters
	.byte $05	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2 | SCHAN_TRIANGLE | SCHAN_NOISE	; Channel setting
	.byte $00	; Sequential commands
	.byte $55	; Note value
	.byte $00	; Sequential commands
	.byte $16	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $00	; Sequential command parameters
	.byte $20	; Note value
	.byte $00	; Sequential commands
	.byte $05	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $06	; -> Sound_RestTimer
	.byte SCHAN_TRIANGLE	; Channel setting
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $00	; Sequential command parameters
	.byte $20	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2 | SCHAN_TRIANGLE | SCHAN_NOISE	; Channel setting
	.byte $00	; Sequential commands
	.byte $55	; Note value
	.byte $00	; Sequential commands
	.byte $16	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $00	; Sequential command parameters
	.byte $20	; Note value
	.byte $00	; Sequential commands
	.byte $03	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2 | SCHAN_TRIANGLE | SCHAN_NOISE	; Channel setting
	.byte $00	; Sequential commands
	.byte $55	; Note value
	.byte $00	; Sequential commands
	.byte $16	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $00	; Sequential command parameters
	.byte $20	; Note value
	.byte $00	; Sequential commands
	.byte $03	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $06	; -> Sound_RestTimer
	.byte SCHAN_TRIANGLE	; Channel setting
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $00	; Sequential command parameters
	.byte $20	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2 | SCHAN_TRIANGLE | SCHAN_NOISE	; Channel setting
	.byte $00	; Sequential commands
	.byte $55	; Note value
	.byte $00	; Sequential commands
	.byte $16	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $00	; Sequential command parameters
	.byte $20	; Note value
	.byte $00	; Sequential commands
	.byte $04	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2 | SCHAN_TRIANGLE | SCHAN_NOISE	; Channel setting
	.byte $00	; Sequential commands
	.byte $55	; Note value
	.byte $00	; Sequential commands
	.byte $16	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $00	; Sequential command parameters
	.byte $20	; Note value
	.byte $00	; Sequential commands
	.byte $04	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $06	; -> Sound_RestTimer
	.byte SCHAN_TRIANGLE	; Channel setting
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $00	; Sequential command parameters
	.byte $20	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2 | SCHAN_TRIANGLE | SCHAN_NOISE	; Channel setting
	.byte $00	; Sequential commands
	.byte $55	; Note value
	.byte $00	; Sequential commands
	.byte $16	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $00	; Sequential command parameters
	.byte $20	; Note value
	.byte $00	; Sequential commands
	.byte $03	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2 | SCHAN_TRIANGLE | SCHAN_NOISE	; Channel setting
	.byte $00	; Sequential commands
	.byte $55	; Note value
	.byte $00	; Sequential commands
	.byte $16	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $00	; Sequential command parameters
	.byte $20	; Note value
	.byte $00	; Sequential commands
	.byte $03	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $06	; -> Sound_RestTimer
	.byte SCHAN_TRIANGLE	; Channel setting
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $00	; Sequential command parameters
	.byte $20	; Note value

	.byte $FF	; Terminator
