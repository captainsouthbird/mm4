	.byte $08	; Priority / loop setting

	.byte SCMDBIT_NOTELEN | SCMDBIT_TRANSPOSE	; Serial commands
	.byte $BF	; Note length
	.byte $03	; Transpose value
	.byte $04	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQFINEOFFSET_SET	; Sequential commands
	.byte $00, $C0, $0F, $FF	; Sequential command parameters
	.byte $42	; Note value
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQFINEOFFSET_SET	; Sequential commands
	.byte $05, $C0, $0F, $00	; Sequential command parameters
	.byte $42	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $29	; Note length
	.byte $1D	; -> Sound_RestTimer
	.byte SCHAN_SQUARE1 | SCHAN_SQUARE2	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQFINEOFFSET_SET	; Sequential commands
	.byte $02, $C0, $0E, $FE	; Sequential command parameters
	.byte $4B	; Note value
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQFINEOFFSET_SET	; Sequential commands
	.byte $02, $00, $0F, $00	; Sequential command parameters
	.byte $4B	; Note value

	.byte $FF	; Terminator
