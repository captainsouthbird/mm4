	.byte $06	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $04	; -> Sound_RestTimer
	.byte SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $28, $0F, $7F	; Sequential command parameters
	.byte $06	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $16	; -> Sound_RestTimer
	.byte SCHAN_NOISE	; Channel setting
	.byte SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $3C	; Sequential command parameters
	.byte $10	; Note value

	.byte $FF	; Terminator
