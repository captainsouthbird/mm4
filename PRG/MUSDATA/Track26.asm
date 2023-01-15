	.byte $09	; Priority / loop setting

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $C8	; Note length
	.byte $1C	; -> Sound_RestTimer
	.byte SCHAN_TRIANGLE | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $00, $7D, $FF	; Sequential command parameters
	.byte $12	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $32, $0F, $FF	; Sequential command parameters
	.byte $0E	; Note value

	.byte $FF	; Terminator
