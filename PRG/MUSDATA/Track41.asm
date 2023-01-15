	.byte $09	; Priority / loop setting

	.byte SCMDBIT_NOTELEN | SCMDBIT_TRANSPOSE	; Serial commands
	.byte $FF	; Note length
	.byte $01	; Transpose value
	.byte $03	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET | SCMD_FREQFINEOFFSET_SET	; Sequential commands
	.byte $42, $40, $0F, $7F, $ED	; Sequential command parameters
	.byte $39	; Note value
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET | SCMD_FREQFINEOFFSET_SET	; Sequential commands
	.byte $42, $40, $0F, $FF, $ED	; Sequential command parameters
	.byte $32	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $07	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET | SCMD_FREQFINEOFFSET_SET	; Sequential commands
	.byte $41, $80, $0F, $7F, $ED	; Sequential command parameters
	.byte $31	; Note value
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET | SCMD_FREQFINEOFFSET_SET	; Sequential commands
	.byte $40, $00, $0F, $FF, $ED	; Sequential command parameters
	.byte $3D	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $07	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2	; Channel setting
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $0D	; Sequential command parameters
	.byte $31	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $0D	; Sequential command parameters
	.byte $3D	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $07	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2	; Channel setting
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $0B	; Sequential command parameters
	.byte $31	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $0B	; Sequential command parameters
	.byte $3D	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $07	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2	; Channel setting
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $09	; Sequential command parameters
	.byte $31	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $09	; Sequential command parameters
	.byte $3D	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $07	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2	; Channel setting
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $07	; Sequential command parameters
	.byte $31	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $07	; Sequential command parameters
	.byte $3D	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $07	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2	; Channel setting
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $05	; Sequential command parameters
	.byte $31	; Note value
	.byte SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $05	; Sequential command parameters
	.byte $3D	; Note value

	.byte $FF	; Terminator
