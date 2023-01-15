	.byte $06	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $0B	; Note length
	.byte $02	; -> Sound_RestTimer
	.byte SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $39, $0F	; Sequential command parameters
	.byte $06	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $02	; -> Sound_RestTimer
	.byte SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET	; Sequential commands
	.byte $39, $0F	; Sequential command parameters
	.byte $09	; Note value

	.byte $FF	; Terminator
