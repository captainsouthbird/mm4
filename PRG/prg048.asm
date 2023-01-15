	; Standard tilemap data; see format.txt in TMAPDATA for what this is comprised of.
	.incbin "PRG/TMAPDATA/TMAP10.bin"
		
	; CHECKME - UNUSED?
	.byte $FF, $57, $FF, $5F, $FF	; $B700 - $B704
	.byte $D7, $FF, $5F, $FF, $55, $FF, $75, $FF, $D5, $FF, $5D, $FF, $DD, $FF, $75, $FF	; $B705 - $B714
	.byte $75, $7F, $77, $FF, $5F, $FF, $75, $FF, $7F, $FF, $55, $FF, $FF, $FF, $FF, $FF	; $B715 - $B724
	.byte $DD, $FF, $F7, $FF, $55, $FF, $F5, $FD, $77, $FF, $D5, $FF, $9F, $FF, $5D, $FF	; $B725 - $B734
	.byte $DF, $FF, $7D, $FF, $D5, $FF, $D7, $FF, $D5, $FF, $5D, $FF, $D7, $FF, $DF, $FF	; $B735 - $B744
	.byte $57, $EF, $77, $FF, $7D, $FF, $5D, $FF, $55, $FF, $5D, $FF, $57, $FF, $55, $FD	; $B745 - $B754
	.byte $5D, $FF, $7D, $FF, $5D, $FF, $57, $FF, $5F, $FF, $55, $FF, $DD, $FF, $57, $FF	; $B755 - $B764
	.byte $7D, $FF, $FD, $FF, $D7, $DF, $FD, $FF, $FD, $FF, $7D, $FF, $DF, $FF, $7F, $FF	; $B765 - $B774
	.byte $DD, $FF, $57, $FF, $77, $FF, $F7, $FF, $F5, $FF, $FF, $FF, $77, $FF, $5F, $BF	; $B775 - $B784
	.byte $55, $FF, $75, $FF, $55, $BF, $7F, $FF, $75, $FF, $55, $DF, $D7, $FF, $7F, $FF	; $B785 - $B794
	.byte $FD, $DF, $5F, $FF, $3F, $FF, $57, $DF, $D5, $FF, $FF, $FF, $F5, $FF, $D5, $FF	; $B795 - $B7A4
	.byte $D5, $FF, $57, $FF, $D7, $FF, $7F, $FF, $77, $FF, $D7, $FF, $57, $FF, $7D, $FF	; $B7A5 - $B7B4
	.byte $DD, $FF, $77, $FF, $55, $FF, $DD, $FF, $DD, $FF, $7F, $FF, $D7, $FF, $5F, $ED	; $B7B5 - $B7C4
	.byte $D7, $FF, $5D, $FF, $55, $FF, $F5, $FF, $D7, $FF, $DF, $F7, $5F, $FF, $DD, $FF	; $B7C5 - $B7D4
	.byte $DD, $FF, $57, $FF, $5D, $FF, $D7, $FF, $D5, $FF, $D5, $FF, $7F, $FF, $F7, $FF	; $B7D5 - $B7E4
	.byte $FF, $FF, $F7, $FF, $7F, $FF, $F5, $FB, $7D, $FF, $D7, $FF, $5F, $FF, $77, $FF	; $B7E5 - $B7F4
	.byte $7F, $FF, $57, $FF, $D7, $EF, $75, $FF, $FD, $FF, $77	; $B7F5 - $B7FF


	; CHR data shoved in here!
PRG048_B800:	.incchr "CHR/48_9800.pcx"
