	.byte $06	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $06	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $38, $C0, $0F, $FF	; Sequential command parameters
	.byte $40	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $38, $06, $7F	; Sequential command parameters
	.byte $10	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $01	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2	; Channel setting
	.byte $00	; Sequential commands
	.byte $48	; Note value

	.byte $FF	; Terminator
