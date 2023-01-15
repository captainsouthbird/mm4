	.byte $07	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $02	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $15, $0F, $7F	; Sequential command parameters
	.byte $57	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $38, $0F	; Sequential command parameters
	.byte $0A	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $06	; -> Sound_RestTimer
	.byte SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET	; Sequential commands
	.byte $3D	; Sequential command parameters
	.byte $0D	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $01	; -> Sound_RestTimer
	.byte $00	; Channel setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $10	; -> Sound_RestTimer
	.byte SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $37, $22	; Sequential command parameters
	.byte $04	; Note value

	.byte $FF	; Terminator
