	.byte $08	; Priority / loop setting


Track_2C_00:	; $CFA4
	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $02	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $2C, $80, $0F, $6E	; Sequential command parameters
	.byte $59	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $3C, $0F, $4A	; Sequential command parameters
	.byte $09	; Note value

	.byte SCMDBIT_NOTELEN	; Serial commands
	.byte $FF	; Note length
	.byte $04	; -> Sound_RestTimer
	.byte $00	; Channel setting

	.byte SCMDBIT_LOOP | SCMDBIT_NOTELEN	; Serial commands
	.byte $02	; Loop count
	sda2 Track_2C_00
	.byte $FF	; Note length
	.byte $02	; -> Sound_RestTimer
	.byte SCHAN_SQUARE2 | SCHAN_NOISE	; Channel setting
	.byte SCMD_PATCH_SET | SCMD_DUTYCYCLE_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $28, $80, $0F, $6E	; Sequential command parameters
	.byte $59	; Note value
	.byte SCMD_PATCH_SET | SCMD_SYNTH_VOLUME_SET | SCMD_FREQOFFSET_SET	; Sequential commands
	.byte $3C, $0F, $4A	; Sequential command parameters
	.byte $09	; Note value

	.byte $FF	; Terminator
