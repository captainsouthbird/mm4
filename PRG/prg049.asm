	; Standard tilemap data; see format.txt in TMAPDATA for what this is comprised of.
	.incbin "PRG/TMAPDATA/TMAP11.bin"
	
	; CHECKME - UNUSED?
	.byte $00, $00, $00	; $B700 - $B702
	.byte $00, $40, $00, $08, $00, $6B, $78, $6B, $78, $7F, $00, $0F, $00, $00, $04, $00	; $B703 - $B712
	.byte $04, $02, $00, $00, $00, $B0, $3C, $BC, $37, $F2, $0A, $FA, $03, $00, $20, $00	; $B713 - $B722
	.byte $20, $40, $00, $00, $00, $0D, $3C, $3D, $EC, $4F, $50, $5F, $C0, $00, $00, $00	; $B723 - $B732
	.byte $00, $02, $00, $08, $00, $D6, $1E, $D6, $1E, $FE, $00, $F8, $00, $C0, $45, $87	; $B733 - $B742
	.byte $DC, $70, $26, $67, $03, $3F, $BB, $FF, $FF, $FF, $D9, $98, $FF, $73, $EF, $DF	; $B743 - $B752
	.byte $D0, $50, $40, $63, $BF, $FC, $F0, $E0, $EF, $EF, $FF, $FF, $FF, $CF, $E3, $02	; $B753 - $B762
	.byte $84, $3F, $76, $AC, $B0, $3F, $1F, $FF, $7F, $FF, $CF, $DF, $FF, $0E, $FF, $F1	; $B763 - $B772
	.byte $F7, $1E, $19, $6E, $DE, $FF, $FF, $FF, $FF, $FF, $FE, $F1, $E1, $DF, $BB, $96	; $B773 - $B782
	.byte $80, $C1, $C6, $7D, $C8, $E0, $C4, $E9, $FF, $FF, $FF, $FE, $FF, $93, $17, $77	; $B783 - $B792
	.byte $F6, $78, $DF, $0C, $19, $7C, $F8, $F8, $F9, $9F, $3F, $FF, $FE, $73, $BE, $9A	; $B793 - $B7A2
	.byte $37, $EF, $D0, $40, $23, $FF, $7F, $7D, $F8, $F0, $EF, $FF, $FF, $8C, $CF, $1F	; $B7A3 - $B7B2
	.byte $7A, $20, $7F, $E7, $FF, $FF, $3F, $FE, $FD, $FF, $FF, $FF, $FF, $F3, $E1, $E7	; $B7B3 - $B7C2
	.byte $FC, $DB, $D7, $F3, $F8, $FF, $FF, $FF, $FF, $FC, $F8, $FC, $FF, $E6, $F1, $FF	; $B7C3 - $B7D2
	.byte $EC, $DB, $97, $91, $DB, $F9, $FF, $FF, $FF, $FC, $F8, $FE, $FF, $F3, $ED, $CD	; $B7D3 - $B7E2
	.byte $C6, $24, $23, $CD, $F7, $FF, $F3, $F3, $F9, $FB, $FF, $FE, $F8, $27, $07, $C2	; $B7E3 - $B7F2
	.byte $8C, $C9, $E6, $7D, $C8, $F8, $F8, $FD, $F3, $F7, $FF, $FE, $FF	; $B7F3 - $B7FF


	; CHR data shoved in here!
PRG049_B800:	.incchr "CHR/49_B800.pcx"
