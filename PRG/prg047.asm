	; Standard tilemap data; see format.txt in TMAPDATA for what this is comprised of.
	.incbin "PRG/TMAPDATA/TMAP0F.bin"
	
	; CHECKME - UNUSED?
	.byte $00, $7E, $42, $42	; $B700 - $B703
	.byte $42, $42, $7E, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7E, $42, $42	; $B704 - $B713
	.byte $42, $42, $7E, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7E, $42, $42	; $B714 - $B723
	.byte $42, $42, $7E, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7E, $42, $42	; $B724 - $B733
	.byte $42, $42, $7E, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7E, $42, $42	; $B734 - $B743
	.byte $42, $42, $7E, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7E, $42, $42	; $B744 - $B753
	.byte $42, $42, $7E, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7E, $42, $42	; $B754 - $B763
	.byte $42, $42, $7E, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02, $C0, $F9, $1F	; $B764 - $B773
	.byte $00, $1F, $0F, $3F, $1D, $C3, $F9, $FF, $FF, $E0, $F0, $C0, $7F, $1F, $FB, $87	; $B774 - $B783
	.byte $FF, $FF, $FF, $FF, $80, $FC, $FC, $F8, $00, $00, $00, $00, $1C, $46, $F3, $F9	; $B784 - $B793
	.byte $FF, $FF, $FE, $F8, $E3, $F9, $FC, $FE, $FF, $E0, $81, $07, $F0, $7F, $AF, $BB	; $B794 - $B7A3
	.byte $DE, $8C, $3B, $FF, $0F, $00, $A0, $7B, $BE, $73, $C4, $00, $FC, $02, $37, $F0	; $B7A4 - $B7B3
	.byte $F9, $F0, $C0, $01, $FC, $02, $37, $F0, $FF, $FF, $FF, $FE, $F0, $CF, $BF, $7F	; $B7B4 - $B7C3
	.byte $7F, $FF, $E1, $C0, $0F, $30, $40, $80, $80, $00, $1E, $3F, $FF, $3F, $DF, $E4	; $B7C4 - $B7D3
	.byte $F3, $FF, $FF, $7C, $00, $C0, $20, $1B, $0C, $00, $00, $83, $FF, $F7, $64, $F7	; $B7D4 - $B7E3
	.byte $FB, $BF, $7F, $FF, $50, $F1, $40, $92, $79, $9D, $8A, $00, $FE, $FF, $BD, $39	; $B7E4 - $B7F3
	.byte $3B, $97, $CF, $EF, $00, $89, $89, $09, $09, $81, $43, $2F	; $B7F4 - $B7FF


	; CHR data shoved in here!
PRG047_B800:	.incchr "CHR/47_B800.pcx"