	; Standard tilemap data; see format.txt in TMAPDATA for what this is comprised of.
	.incbin "PRG/TMAPDATA/TMAP14.bin"
	
	; CHECKME - UNUSED?
	.byte $B7, $55, $DA, $55, $AC, $14, $DE, $55, $F7, $15, $C6, $54, $FF, $45	; $B700 - $B70D
	.byte $7F, $11, $5F, $55, $17, $15, $BB, $44, $7B, $15, $66, $41, $9D, $45, $A2, $45	; $B70E - $B71D
	.byte $B2, $01, $FF, $55, $F0, $55, $D7, $54, $7A, $54, $F2, $55, $D3, $45, $5E, $45	; $B71E - $B72D
	.byte $BF, $54, $6F, $11, $D8, $44, $F4, $41, $DB, $15, $4A, $40, $7B, $14, $01, $03	; $B72E - $B73D
	.byte $70, $04, $CE, $55, $FE, $D1, $DA, $55, $B7, $47, $7F, $45, $BF, $01, $71, $15	; $B73E - $B74D
	.byte $A7, $45, $9B, $55, $AD, $54, $C0, $41, $67, $41, $FF, $55, $92, $45, $BE, $05	; $B74E - $B75D
	.byte $E5, $45, $FE, $51, $7A, $55, $EB, $15, $53, $55, $ED, $11, $BF, $15, $9F, $55	; $B75E - $B76D
	.byte $E9, $15, $D6, $45, $76, $44, $57, $14, $6C, $45, $FD, $11, $4C, $55, $BC, $10	; $B76E - $B77D
	.byte $D9, $10, $FF, $11, $CF, $54, $EE, $45, $F8, $45, $0B, $55, $FE, $15, $FD, $51	; $B77E - $B78D
	.byte $BF, $40, $EA, $05, $5C, $44, $8F, $50, $CE, $41, $3F, $58, $A6, $05, $18, $40	; $B78E - $B79D
	.byte $CB, $11, $77, $55, $F7, $57, $B9, $44, $DF, $75, $3F, $55, $3B, $54, $FC, $45	; $B79E - $B7AD
	.byte $DD, $15, $E9, $15, $7F, $41, $FD, $50, $F4, $54, $FF, $44, $29, $45, $C1, $55	; $B7AE - $B7BD
	.byte $B8, $14, $6A, $05, $6D, $45, $5F, $57, $5D, $55, $FD, $95, $E3, $54, $7B, $50	; $B7BE - $B7CD
	.byte $F5, $C5, $FE, $55, $F3, $46, $FB, $06, $9E, $41, $FC, $55, $32, $51, $6E, $14	; $B7CE - $B7DD
	.byte $ED, $45, $ED, $15, $DF, $51, $7B, $55, $77, $11, $81, $D5, $F7, $55, $8E, $D5	; $B7DE - $B7ED
	.byte $4E, $05, $ED, $55, $D7, $55, $B1, $45, $DB, $45, $F3, $55, $2E, $55, $C7, $41	; $B7EE - $B7FD
	.byte $92, $C0, $08, $12, $00, $91, $08, $19, $00, $71, $C2, $47, $00, $02, $02, $91	; $B7FE - $B80D
	.byte $08, $55, $00, $22, $00, $41, $A0, $50, $08, $A0, $8A, $2A, $80, $2C, $02, $71	; $B80E - $B81D
	.byte $80, $4B, $08, $09, $28, $00, $00, $5A, $00, $01, $08, $10, $0A, $5C, $A0, $10	; $B81E - $B82D
	.byte $A0, $00, $00, $0C, $28, $02, $08, $06, $20, $B1, $08, $10, $00, $B3, $80, $23	; $B82E - $B83D
	.byte $22, $21, $08, $40, $82, $8C, $00, $0C, $26, $95, $00, $43, $A8, $CB, $02, $D4	; $B83E - $B84D
	.byte $88, $01, $02, $8E, $00, $93, $28, $20, $02, $23, $00, $69, $80, $7D, $08, $28	; $B84E - $B85D
	.byte $00, $07, $80, $40, $08, $C0, $02, $A4, $28, $48, $08, $AD, $20, $E1, $80, $80	; $B85E - $B86D
	.byte $88, $B8, $08, $4B, $80, $09, $00, $0A, $00, $CD, $80, $09, $A8, $E5, $28, $19	; $B86E - $B87D
	.byte $88, $35, $04, $00, $22, $0E, $00, $0C, $20, $1F, $80, $29, $00, $99, $80, $06	; $B87E - $B88D
	.byte $00, $01, $00, $26, $A0, $08, $80, $08, $00, $13, $A8, $1A, $A8, $88, $A0, $48	; $B88E - $B89D
	.byte $20, $00, $20, $81, $00, $1B, $AA, $1A, $08, $58, $08, $09, $20, $F1, $A0, $04	; $B89E - $B8AD
	.byte $02, $16, $28, $23, $A0, $00, $A0, $96, $00, $EA, $08, $4D, $08, $82, $88, $74	; $B8AE - $B8BD
	.byte $0A, $91, $80, $BB, $AA, $D4, $0A, $16, $82, $57, $80, $40, $08, $28, $02, $00	; $B8BE - $B8CD
	.byte $02, $80, $8A, $08, $20, $A1, $00, $2A, $00, $38, $0A, $89, $82, $12, $02, $21	; $B8CE - $B8DD
	.byte $2A, $7E, $00, $94, $08, $A6, $00, $13, $22, $A0, $20, $C2, $82, $23, $20, $26	; $B8DE - $B8ED
	.byte $08, $12, $88, $04, $28, $22, $08, $4C, $20, $77, $02, $1B, $00, $14, $82, $75	; $B8EE - $B8FD
	.byte $A8, $15, $00, $60, $A2, $32, $28, $A0, $40, $10, $20, $04, $80, $E5, $A0, $40	; $B8FE - $B90D
	.byte $00, $39, $88, $42, $00, $13, $80, $20, $A0, $B6, $22, $28, $28, $61, $82, $0C	; $B90E - $B91D
	.byte $28, $01, $80, $A8, $82, $E8, $22, $4A, $08, $C4, $00, $28, $08, $12, $A8, $AA	; $B91E - $B92D
	.byte $82, $92, $08, $08, $AA, $20, $02, $8F, $02, $42, $AA, $5A, $08, $85, $20, $A5	; $B92E - $B93D
	.byte $0A, $08, $02, $C8, $00, $20, $08, $2D, $88, $74, $28, $C0, $00, $A0, $08, $9C	; $B93E - $B94D
	.byte $28, $2C, $02, $27, $82, $03, $28, $15, $08, $40, $0A, $A3, $20, $2A, $A0, $02	; $B94E - $B95D
	.byte $28, $01, $82, $02, $08, $64, $28, $C4, $20, $44, $60, $21, $82, $98, $06, $8C	; $B95E - $B96D
	.byte $20, $50, $10, $59, $AB, $45, $80, $84, $02, $6E, $22, $D4, $08, $10, $A2, $61	; $B96E - $B97D
	.byte $20, $C2, $20, $CC, $00, $7C, $20, $04, $8A, $2B, $80, $1E, $2A, $30, $20, $04	; $B97E - $B98D
	.byte $08, $41, $04, $10, $00, $00, $00, $00, $2A, $0B, $00, $00, $20, $81, $A8, $3C	; $B98E - $B99D
	.byte $20, $0A, $88, $16, $20, $48, $00, $E1, $00, $09, $00, $6C, $80, $3F, $80, $87	; $B99E - $B9AD
	.byte $00, $48, $02, $44, $02, $59, $80, $05, $22, $A8, $20, $D4, $02, $A8, $22, $40	; $B9AE - $B9BD
	.byte $02, $06, $88, $00, $02, $02, $28, $96, $20, $2A, $28, $D3, $20, $F5, $08, $08	; $B9BE - $B9CD
	.byte $A0, $86, $00, $48, $A8, $61, $00, $9B, $80, $00, $A8, $39, $00, $D1, $08, $0A	; $B9CE - $B9DD
	.byte $82, $C4, $02, $25, $00, $87, $88, $58, $00, $A0, $8A, $E8, $00, $FA, $00, $88	; $B9DE - $B9ED
	.byte $A0, $0B, $02, $55, $08, $91, $0A, $E4, $2A, $16, $A0, $12, $08, $9C, $88, $5B	; $B9EE - $B9FD
	.byte $20, $FA, $08, $01, $00, $24, $80, $11, $28, $0D, $00, $08, $00, $04, $00, $64	; $B9FE - $BA0D
	.byte $02, $51, $00, $00, $00, $A3, $40, $A2, $A2, $41, $00, $4B, $28, $80, $0A, $14	; $BA0E - $BA1D
	.byte $28, $C8, $20, $C5, $02, $04, $02, $08, $80, $01, $08, $06, $00, $05, $60, $1C	; $BA1E - $BA2D
	.byte $00, $20, $00, $04, $20, $AB, $02, $29, $2A, $11, $8A, $7F, $88, $80, $80, $03	; $BA2E - $BA3D
	.byte $02, $26, $20, $08, $80, $A0, $10, $8E, $00, $C1, $00, $1C, $22, $10, $80, $51	; $BA3E - $BA4D
	.byte $88, $11, $08, $48, $08, $24, $A0, $F9, $08, $00, $22, $10, $08, $09, $88, $80	; $BA4E - $BA5D
	.byte $20, $02, $00, $C1, $20, $25, $20, $75, $22, $B1, $02, $8B, $A2, $40, $08, $C4	; $BA5E - $BA6D
	.byte $02, $12, $20, $00, $80, $11, $90, $C4, $2A, $12, $88, $A2, $80, $4C, $00, $28	; $BA6E - $BA7D
	.byte $80, $14, $02, $60, $02, $09, $2A, $02, $00, $20, $20, $20, $00, $61, $88, $81	; $BA7E - $BA8D
	.byte $8A, $9D, $02, $E1, $00, $00, $2A, $42, $20, $A6, $28, $20, $80, $12, $88, $34	; $BA8E - $BA9D
	.byte $82, $11, $02, $AA, $06, $C6, $22, $03, $20, $00, $02, $00, $00, $2C, $A2, $4A	; $BA9E - $BAAD
	.byte $80, $28, $00, $04, $28, $D5, $A0, $E0, $80, $42, $28, $32, $24, $70, $88, $B0	; $BAAE - $BABD
	.byte $00, $1C, $A0, $50, $22, $10, $00, $06, $82, $83, $2A, $13, $20, $00, $28, $00	; $BABE - $BACD
	.byte $08, $0D, $00, $00, $80, $41, $00, $45, $A2, $00, $00, $48, $A0, $1E, $0A, $30	; $BACE - $BADD
	.byte $00, $0C, $28, $1E, $02, $3A, $00, $10, $20, $60, $20, $A9, $22, $F1, $8A, $68	; $BADE - $BAED
	.byte $2A, $A8, $02, $28, $03, $15, $18, $02, $00, $74, $02, $3B, $03, $68, $88, $36	; $BAEE - $BAFD
	.byte $28, $3A, $08, $72, $81, $04, $80, $44, $00, $85, $20, $00, $8A, $0A, $20, $80	; $BAFE - $BB0D
	.byte $02, $72, $82, $46, $20, $10, $20, $24, $04, $08, $20, $01, $00, $D0, $0A, $D9	; $BB0E - $BB1D
	.byte $08, $96, $12, $00, $01, $B7, $80, $96, $00, $CD, $00, $80, $00, $60, $A0, $24	; $BB1E - $BB2D
	.byte $00, $43, $80, $41, $28, $00, $00, $2D, $0A, $BE, $22, $91, $08, $20, $08, $67	; $BB2E - $BB3D
	.byte $02, $07, $80, $6C, $09, $F1, $80, $EA, $20, $07, $00, $CE, $02, $F4, $A0, $1A	; $BB3E - $BB4D
	.byte $08, $71, $00, $20, $30, $00, $A0, $96, $88, $9A, $9B, $28, $00, $14, $18, $14	; $BB4E - $BB5D
	.byte $0A, $35, $A8, $D4, $02, $5D, $20, $09, $00, $A4, $80, $49, $00, $09, $A0, $A6	; $BB5E - $BB6D
	.byte $00, $0C, $A0, $30, $02, $00, $68, $60, $A0, $40, $02, $DE, $80, $B8, $8A, $80	; $BB6E - $BB7D
	.byte $01, $0D, $08, $14, $20, $D4, $20, $29, $20, $88, $80, $A4, $82, $41, $08, $88	; $BB7E - $BB8D
	.byte $00, $95, $80, $00, $A1, $13, $A0, $07, $28, $00, $02, $2C, $20, $40, $00, $C0	; $BB8E - $BB9D
	.byte $0A, $80, $80, $91, $02, $04, $88, $0D, $28, $80, $80, $D1, $20, $CE, $08, $C1	; $BB9E - $BBAD
	.byte $80, $48, $22, $81, $28, $BC, $0A, $07, $03, $30, $A0, $00, $C8, $A1, $A0, $86	; $BBAE - $BBBD
	.byte $00, $91, $80, $10, $22, $01, $00, $BC, $2A, $10, $28, $04, $00, $14, $20, $57	; $BBBE - $BBCD
	.byte $08, $E9, $0A, $40, $28, $0A, $00, $50, $08, $86, $28, $1E, $00, $11, $80, $04	; $BBCE - $BBDD
	.byte $02, $50, $8A, $35, $A2, $5D, $08, $CC, $00, $22, $0A, $AC, $00, $69, $82, $00	; $BBDE - $BBED
	.byte $A2, $05, $20, $2C, $08, $2A, $08, $99, $0A, $A1, $10, $C2, $08, $97, $0A, $EC	; $BBEE - $BBFD
	.byte $08, $45, $AF, $57, $DF, $55, $FE, $55, $EF, $71, $FE, $54, $57, $1D, $74, $50	; $BBFE - $BC0D
	.byte $F6, $55, $EC, $C7, $B7, $54, $A6, $04, $4F, $55, $F5, $51, $CF, $14, $3C, $D4	; $BC0E - $BC1D
	.byte $FA, $47, $FF, $55, $97, $65, $B7, $51, $BE, $7D, $7E, $C5, $FF, $57, $DF, $57	; $BC1E - $BC2D
	.byte $FB, $44, $FF, $54, $2F, $51, $EF, $4F, $CF, $54, $FE, $D5, $EB, $55, $B6, $17	; $BC2E - $BC3D
	.byte $A9, $7D, $FE, $55, $BF, $51, $FF, $94, $7B, $41, $BF, $5D, $1F, $51, $FF, $15	; $BC3E - $BC4D
	.byte $F7, $55, $BE, $51, $B1, $56, $FB, $44, $A7, $55, $DF, $11, $C8, $55, $FF, $10	; $BC4E - $BC5D
	.byte $90, $15, $F5, $7D, $BF, $37, $DF, $C7, $FF, $51, $7E, $59, $8F, $15, $D5, $51	; $BC5E - $BC6D
	.byte $FF, $27, $BD, $55, $DE, $45, $5F, $15, $FC, $75, $F3, $54, $63, $15, $EF, $51	; $BC6E - $BC7D
	.byte $BF, $14, $77, $11, $2A, $55, $DF, $55, $D9, $55, $FD, $55, $67, $15, $BD, $A1	; $BC7E - $BC8D
	.byte $FE, $76, $7F, $41, $AB, $41, $F5, $44, $69, $75, $FB, $51, $F9, $41, $EC, $45	; $BC8E - $BC9D
	.byte $AF, $55, $FA, $15, $F7, $55, $FF, $55, $F5, $55, $FF, $5D, $FD, $61, $FF, $51	; $BC9E - $BCAD
	.byte $7F, $75, $7F, $55, $F7, $75, $7D, $54, $F1, $55, $77, $55, $E5, $75, $3B, $55	; $BCAE - $BCBD
	.byte $FF, $D5, $FD, $D5, $EF, $57, $DD, $55, $DD, $54, $EE, $37, $E7, $D4, $CF, $51	; $BCBE - $BCCD
	.byte $FF, $55, $E7, $55, $FF, $15, $7F, $15, $2E, $55, $CD, $74, $DE, $15, $59, $15	; $BCCE - $BCDD
	.byte $DF, $54, $FB, $54, $6D, $15, $FF, $C7, $FD, $7D, $D5, $D5, $7F, $13, $BF, $D5	; $BCDE - $BCED
	.byte $FB, $75, $DB, $51, $FE, $55, $BD, $51, $5F, $5F, $F7, $1E, $DF, $05, $EF, $55	; $BCEE - $BCFD
	.byte $FF, $17, $FF, $55, $9F, $45, $7F, $64, $46, $45, $EA, $55, $FE, $55, $7E, $50	; $BCFE - $BD0D
	.byte $FD, $1C, $FC, $45, $A5, $51, $B3, $01, $FF, $D1, $27, $9D, $FD, $14, $BF, $50	; $BD0E - $BD1D
	.byte $2E, $D5, $FE, $55, $5F, $51, $F7, $64, $7F, $55, $DB, $C5, $AF, $51, $EA, $54	; $BD1E - $BD2D
	.byte $EF, $53, $FF, $D5, $F7, $7C, $7D, $15, $DF, $01, $B7, $05, $AA, $54, $67, $B5	; $BD2E - $BD3D
	.byte $E4, $55, $FF, $51, $FB, $55, $F1, $5D, $FB, $55, $B7, $45, $DF, $55, $FE, $D4	; $BD3E - $BD4D
	.byte $FF, $55, $EF, $15, $E7, $5D, $BF, $45, $EB, $15, $BA, $D5, $3F, $11, $9D, $75	; $BD4E - $BD5D
	.byte $A7, $55, $72, $E5, $FF, $55, $EF, $55, $BF, $45, $F6, $4D, $F7, $55, $9E, $01	; $BD5E - $BD6D
	.byte $7F, $45, $77, $55, $E9, $D7, $BB, $44, $6E, $55, $D6, $5D, $E8, $14, $E7, $55	; $BD6E - $BD7D
	.byte $FE, $14, $16, $45, $EF, $10, $7F, $11, $BF, $55, $DF, $55, $FF, $D0, $FD, $05	; $BD7E - $BD8D
	.byte $FF, $55, $FD, $01, $A9, $D5, $0F, $47, $17, $5D, $8F, $04, $E9, $45, $BB, $D7	; $BD8E - $BD9D
	.byte $FE, $45, $FF, $45, $FF, $15, $F7, $51, $6F, $55, $7F, $55, $DF, $34, $DF, $55	; $BD9E - $BDAD
	.byte $F3, $51, $FE, $0C, $7E, $75, $FB, $55, $BB, $1D, $FD, $55, $EF, $54, $6F, $71	; $BDAE - $BDBD
	.byte $DF, $57, $FD, $55, $FF, $55, $FF, $D7, $FC, $D5, $AF, $55, $FF, $55, $DF, $55	; $BDBE - $BDCD
	.byte $F3, $51, $FF, $55, $70, $D5, $FD, $7C, $7D, $45, $F7, $05, $E2, $54, $DB, $5C	; $BDCE - $BDDD
	.byte $4F, $50, $FE, $14, $EF, $C5, $FE, $75, $D5, $5D, $15, $55, $FD, $45, $15, $95	; $BDDE - $BDED
	.byte $DF, $D4, $7E, $15, $EF, $55, $BF, $15, $FF, $56, $BF, $15, $7D, $55, $7F, $4D	; $BDEE - $BDFD
	.byte $EF, $01, $DA, $55, $B0, $55, $FA, $55, $FF, $54, $6F, $55, $FF, $15, $3E, $45	; $BDFE - $BE0D
	.byte $3F, $0D, $FC, $65, $EB, $5D, $F3, $55, $75, $57, $D5, $55, $F8, $1D, $79, $44	; $BE0E - $BE1D
	.byte $25, $55, $FF, $57, $FB, $4D, $BF, $D1, $E3, $54, $FB, $13, $FF, $D5, $7F, $5B	; $BE1E - $BE2D
	.byte $FF, $51, $FF, $5D, $7D, $45, $F7, $41, $D4, $44, $D5, $15, $FB, $15, $AF, $51	; $BE2E - $BE3D
	.byte $7F, $54, $FF, $45, $DF, $14, $FA, $D1, $6D, $15, $3D, $55, $FF, $55, $BE, $55	; $BE3E - $BE4D
	.byte $B9, $51, $FB, $45, $BE, $55, $FF, $5D, $DF, $D5, $B7, $54, $DE, $51, $BF, $55	; $BE4E - $BE5D
	.byte $DB, $31, $EF, $D5, $BF, $55, $EB, $17, $DB, $55, $BF, $75, $DF, $D4, $FF, $55	; $BE5E - $BE6D
	.byte $35, $57, $FF, $55, $FB, $75, $7B, $54, $C3, $55, $FF, $01, $E7, $53, $F7, $45	; $BE6E - $BE7D
	.byte $7F, $D0, $F6, $D8, $AF, $C7, $F7, $5C, $FF, $55, $DE, $55, $BF, $19, $D6, $14	; $BE7E - $BE8D
	.byte $BE, $D5, $FD, $55, $C5, $15, $B9, $50, $FF, $11, $CB, $04, $67, $D1, $69, $44	; $BE8E - $BE9D
	.byte $FF, $45, $FE, $54, $EB, $57, $FF, $51, $FF, $51, $BB, $4D, $FE, $55, $FF, $34	; $BE9E - $BEAD
	.byte $FB, $55, $BF, $57, $FF, $54, $EF, $45, $6F, $5C, $7F, $44, $FE, $55, $D5, $54	; $BEAE - $BEBD
	.byte $BE, $55, $FF, $54, $FF, $55, $EF, $13, $FD, $55, $F7, $5E, $D7, $57, $FF, $54	; $BEBE - $BECD
	.byte $FF, $41, $FD, $71, $FF, $15, $F3, $55, $F7, $55, $DF, $55, $F9, $17, $BC, $55	; $BECE - $BEDD
	.byte $EE, $45, $63, $55, $FE, $15, $FB, $55, $FB, $54, $CF, $D1, $BE, $15, $77, $5D	; $BEDE - $BEED
	.byte $BF, $D5, $FB, $55, $7F, $71, $AE, $51, $FF, $13, $FB, $40, $D3, $14, $7E, $55	; $BEEE - $BEFD
	.byte $F7, $B5, $F7, $45, $9F, $13, $DF, $11, $7F, $55, $FB, $05, $BF, $45, $DE, $19	; $BEFE - $BF0D
	.byte $7F, $15, $AE, $54, $D3, $49, $3F, $D5, $FD, $55, $4D, $19, $7B, $57, $FF, $50	; $BF0E - $BF1D
	.byte $DA, $50, $BF, $4C, $BF, $65, $CF, $56, $FF, $D5, $BE, $55, $FF, $55, $76, $D4	; $BF1E - $BF2D
	.byte $FB, $55, $7A, $54, $F6, $71, $F7, $54, $DD, $54, $3A, $55, $EF, $55, $BB, $F7	; $BF2E - $BF3D
	.byte $FA, $51, $EE, $57, $FC, $15, $F6, $C5, $FF, $75, $1F, $55, $DB, $41, $FE, $45	; $BF3E - $BF4D
	.byte $BE, $45, $DF, $C5, $FF, $11, $B9, $10, $FF, $05, $7F, $15, $FB, $11, $EC, $05	; $BF4E - $BF5D
	.byte $DC, $55, $FF, $45, $DD, $55, $EE, $D4, $EF, $75, $B7, $57, $74, $56, $FB, $5D	; $BF5E - $BF6D
	.byte $EF, $5F, $9E, $55, $77, $50, $FF, $51, $FF, $55, $FF, $54, $BE, $5D, $FF, $47	; $BF6E - $BF7D
	.byte $FD, $50, $FF, $57, $EF, $45, $FB, $50, $EE, $55, $EB, $40, $BA, $15, $FF, $55	; $BF7E - $BF8D
	.byte $BE, $15, $B7, $55, $FE, $50, $AD, $54, $DA, $D1, $7D, $4F, $9D, $D5, $EF, $55	; $BF8E - $BF9D
	.byte $FF, $54, $FB, $15, $FD, $65, $CF, $91, $DE, $27, $DF, $50, $DB, $55, $F7, $03	; $BF9E - $BFAD
	.byte $3B, $55, $EE, $55, $F7, $45, $BF, $55, $FC, $55, $EF, $55, $67, $55, $B7, $D9	; $BFAE - $BFBD
	.byte $BF, $14, $F7, $55, $7F, $55, $AF, $7D, $37, $57, $FF, $55, $7F, $55, $EF, $51	; $BFBE - $BFCD
	.byte $8A, $00, $7B, $17, $BF, $15, $7F, $50, $FC, $41, $FF, $D4, $EB, $55, $FD, $15	; $BFCE - $BFDD
	.byte $BD, $55, $DB, $54, $FF, $7C, $FF, $44, $7F, $55, $BF, $15, $FF, $54, $F7, $55	; $BFDE - $BFED
	.byte $FF, $41, $FB, $55, $BF, $50, $FB, $5C, $8F, $05, $FD, $D4, $BF, $70, $EF, $50	; $BFEE - $BFFD
	.byte $FF, $50	; $BFFE - $BFFF


