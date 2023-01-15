	; Standard tilemap data; see format.txt in TMAPDATA for what this is comprised of.
	.incbin "PRG/TMAPDATA/TMAP12.bin"
	
	; CHECKME - UNUSED?
	.byte $FF, $57, $FF	; $B700 - $B702
	.byte $57, $FF, $55, $FF, $7F, $FF, $7F, $FF, $5F, $FF, $77, $FF, $D7, $FF, $77, $FF	; $B703 - $B712
	.byte $55, $EF, $5D, $FF, $F5, $FF, $77, $FF, $57, $FF, $F7, $EF, $F5, $FF, $57, $DF	; $B713 - $B722
	.byte $F7, $FF, $FF, $FF, $57, $FF, $5D, $FF, $FF, $FF, $77, $FF, $5D, $FF, $75, $FF	; $B723 - $B732
	.byte $5F, $FF, $5D, $FF, $75, $FF, $D5, $FF, $FF, $DF, $55, $DF, $55, $FF, $F5, $FF	; $B733 - $B742
	.byte $DB, $FF, $7F, $FF, $D5, $FF, $7D, $7F, $57, $FF, $D5, $FB, $F5, $FF, $DD, $FF	; $B743 - $B752
	.byte $55, $FF, $D5, $FF, $D7, $FF, $5C, $FF, $FF, $FF, $FD, $FF, $7F, $FF, $7D, $FF	; $B753 - $B762
	.byte $FD, $FF, $5D, $FF, $F5, $FF, $FD, $FF, $7F, $FF, $7F, $FF, $59, $FF, $F5, $FF	; $B763 - $B772
	.byte $7F, $FF, $7F, $DF, $FF, $FF, $D7, $FF, $75, $FF, $75, $FF, $F7, $FF, $55, $FF	; $B773 - $B782
	.byte $5D, $FF, $F5, $FF, $57, $FF, $FE, $FF, $5D, $FF, $55, $FF, $D7, $FF, $5F, $FF	; $B783 - $B792
	.byte $57, $FB, $DE, $FF, $77, $FF, $75, $FD, $D5, $EF, $52, $7F, $5F, $FF, $75, $FF	; $B793 - $B7A2
	.byte $77, $FF, $7F, $FF, $5D, $FF, $F5, $FF, $F7, $FF, $57, $FF, $DF, $FF, $5E, $FF	; $B7A3 - $B7B2
	.byte $F7, $FF, $75, $FF, $7D, $FF, $FF, $FF, $FB, $FF, $57, $FF, $DF, $FF, $ED, $7F	; $B7B3 - $B7C2
	.byte $77, $FF, $5D, $FF, $DD, $FF, $6F, $FF, $7D, $FF, $55, $FF, $7E, $FF, $F5, $FF	; $B7C3 - $B7D2
	.byte $7F, $FF, $75, $FF, $F5, $FF, $F5, $FD, $D7, $FF, $D7, $FF, $55, $FF, $F7, $FF	; $B7D3 - $B7E2
	.byte $FF, $FF, $77, $FF, $DE, $FF, $5D, $F7, $FF, $FF, $7F, $FF, $D7, $FF, $D7, $FF	; $B7E3 - $B7F2
	.byte $7D, $FF, $DD, $FF, $DF, $FF, $DD, $FF, $F7, $FF, $F5, $FF, $77	; $B7F3 - $B7FF


	; CHR data shoved in here!
PRG050_B800:	.incchr "CHR/50_9800.pcx"
