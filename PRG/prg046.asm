	; Standard tilemap data; see format.txt in TMAPDATA for what this is comprised of.
	.incbin "PRG/TMAPDATA/TMAP0E.bin"
	
	; CHECKME - UNUSED?
	.byte $0A, $40, $20, $00, $E8, $04, $09, $04, $07, $41, $06, $00	; $B700 - $B70B
	.byte $E8, $14, $04, $10, $08, $40, $11, $00, $05, $04, $04, $00, $00, $00, $92, $00	; $B70C - $B71B
	.byte $A8, $01, $6C, $05, $A8, $40, $40, $01, $07, $00, $24, $14, $A8, $04, $08, $15	; $B71C - $B72B
	.byte $11, $04, $00, $01, $50, $01, $18, $05, $01, $00, $01, $00, $64, $10, $72, $15	; $B72C - $B73B
	.byte $01, $00, $28, $05, $E0, $51, $48, $14, $01, $00, $24, $00, $D2, $10, $E2, $08	; $B73C - $B74B
	.byte $28, $00, $00, $04, $00, $05, $44, $04, $C9, $40, $69, $00, $A6, $41, $10, $80	; $B74C - $B75B
	.byte $4A, $44, $46, $04, $80, $15, $92, $00, $21, $00, $50, $05, $49, $04, $C2, $00	; $B75C - $B76B
	.byte $48, $41, $8A, $41, $09, $00, $80, $00, $38, $00, $0C, $00, $00, $00, $80, $04	; $B76C - $B77B
	.byte $A1, $01, $A0, $00, $00, $01, $4A, $40, $04, $40, $98, $04, $10, $00, $0A, $10	; $B77C - $B78B
	.byte $4C, $51, $00, $53, $12, $44, $20, $10, $30, $14, $39, $41, $80, $01, $80, $00	; $B78C - $B79B
	.byte $82, $10, $28, $04, $CD, $40, $08, $00, $48, $00, $4A, $01, $7C, $11, $21, $10	; $B79C - $B7AB
	.byte $50, $50, $18, $00, $24, $14, $1A, $50, $20, $48, $01, $04, $40, $51, $80, $00	; $B7AC - $B7BB
	.byte $2A, $00, $00, $04, $28, $04, $03, $07, $60, $40, $80, $14, $02, $41, $08, $51	; $B7BC - $B7CB
	.byte $62, $00, $00, $00, $C0, $40, $90, $41, $00, $05, $15, $10, $12, $04, $00, $00	; $B7CC - $B7DB
	.byte $80, $14, $5A, $01, $3A, $00, $00, $10, $00, $44, $0A, $46, $42, $00, $C8, $40	; $B7DC - $B7EB
	.byte $1E, $01, $58, $00, $05, $04, $88, $40, $A1, $14, $04, $00, $31, $10, $08, $41	; $B7EC - $B7FB
	.byte $20, $01, $10, $09	; $B7FC - $B7FF


	; CHR data shoved in here!
PRG046_B800:	.incchr "CHR/46_B800.pcx"
