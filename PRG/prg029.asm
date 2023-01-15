	; CONTINUED FROM PRG030 (special addressing logic makes this work)

	.byte $85, $87, $85, $06, $82, $80, $85, $87, $8D, $85, $8D, $87, $85, $04, $00, $8D	; $A000 - $A00F
	.byte $85, $87, $8D, $85, $85, $87, $85, $8D, $85, $87, $8D, $85, $8D, $87, $85, $8D	; $A010 - $A01F
	.byte $85, $87, $8D, $85, $85, $87, $85, $85, $8D, $87, $85, $87, $85, $87, $85, $12	; $A020 - $A02F
	.byte $00, $C0, $42, $80, $85, $06, $37, $AB, $06, $82, $85, $8D, $87, $85, $0E, $01	; $A030 - $A03F
	.byte $C0, $0D, $80, $85, $87, $85, $87, $89, $67, $67, $85, $80, $8B, $8B, $89, $68	; $A040 - $A04F
	.byte $68, $85, $87, $85, $80, $16, $BF, $BA	; $A050 - $A057


	; CHECKME - UNUSED?
	.byte $17

PRG029_MUS_Ending2:		.include "PRG/MUSDATA/Track13.asm"
PRG029_MUS_GetWeapon:	.include "PRG/MUSDATA/Track14.asm"
PRG029_MUS_Cossack2:	.include "PRG/MUSDATA/Track15.asm"
PRG029_MUS_Wily2:		.include "PRG/MUSDATA/Track16.asm"

PRG029_SFX_Bright:			.include "PRG/MUSDATA/Track17.asm"
PRG029_SFX_ToadRain:		.include "PRG/MUSDATA/Track18.asm"
PRG029_SFX_RingBoomerang:	.include "PRG/MUSDATA/Track19.asm"
PRG029_SFX_DrillBomb:		.include "PRG/MUSDATA/Track1A.asm"
PRG029_SFX_PharaohShot:		.include "PRG/MUSDATA/Track1B.asm"
PRG029_SFX_CossackLightning:	.include "PRG/MUSDATA/Track1C.asm"
PRG029_SFX_PathDraw:		.include "PRG/MUSDATA/Track1D.asm"
PRG029_SFX_WaterSplash:		.include "PRG/MUSDATA/Track1E.asm"
PRG029_SFX_1Up:				.include "PRG/MUSDATA/Track1F.asm"
PRG029_SFX_20:				.include "PRG/MUSDATA/Track20.asm"	; Unused
PRG029_SFX_PlayerShot:		.include "PRG/MUSDATA/Track21.asm"
PRG029_SFX_MegaBusterCharge:	.include "PRG/MUSDATA/Track22.asm"
PRG029_SFX_PlayerLand:		.include "PRG/MUSDATA/Track23.asm"
PRG029_SFX_PlayerHurt:		.include "PRG/MUSDATA/Track24.asm"
PRG029_SFX_RobotDeath:		.include "PRG/MUSDATA/Track25.asm"
PRG029_SFX_EnemyHit:		.include "PRG/MUSDATA/Track26.asm"
PRG029_SFX_MegaBusterHold:	.include "PRG/MUSDATA/Track27.asm"
PRG029_SFX_Explosion:		.include "PRG/MUSDATA/Track28.asm"
PRG029_SFX_EnergyGain:		.include "PRG/MUSDATA/Track29.asm"
PRG029_SFX_MenuConfirm:		.include "PRG/MUSDATA/Track2A.asm"
PRG029_SFX_ShotDeflect:		.include "PRG/MUSDATA/Track2B.asm"
PRG029_SFX_BossGate:		.include "PRG/MUSDATA/Track2C.asm"
PRG029_SFX_PasswordError:	.include "PRG/MUSDATA/Track2D.asm"
PRG029_SFX_MenuSelect:		.include "PRG/MUSDATA/Track2E.asm"
PRG029_SFX_PasswordCorrect:	.include "PRG/MUSDATA/Track2F.asm"
PRG029_SFX_WeaponMenu:		.include "PRG/MUSDATA/Track30.asm"
PRG029_SFX_GrasshopperHop:	.include "PRG/MUSDATA/Track31.asm"
PRG029_SFX_WireAdapter:		.include "PRG/MUSDATA/Track32.asm"
PRG029_SFX_TeleportLanding:	.include "PRG/MUSDATA/Track33.asm"
PRG029_SFX_34:				.include "PRG/MUSDATA/Track34.asm"	; Unused
PRG029_SFX_LetterType:		.include "PRG/MUSDATA/Track35.asm"
PRG029_SFX_36:				.include "PRG/MUSDATA/Track36.asm"	; Unused
PRG029_SFX_BigExplosion:	.include "PRG/MUSDATA/Track37.asm"
PRG029_SFX_38:				.include "PRG/MUSDATA/Track38.asm"	; Unused
PRG029_SFX_DisappearingBlock:	.include "PRG/MUSDATA/Track39.asm"
PRG029_MUS_SpecialItem:			.include "PRG/MUSDATA/Track3A.asm"
PRG029_MUS_WilyFortressIntro:	.include "PRG/MUSDATA/Track3B.asm"
PRG029_MUS_CossackFortIntro:	.include "PRG/MUSDATA/Track3C.asm"
PRG029_SFX_PlayerMBustShot:		.include "PRG/MUSDATA/Track3D.asm"
PRG029_SFX_PharaohShotCharged:	.include "PRG/MUSDATA/Track3E.asm"
PRG029_MUS_ProtoWhistle:		.include "PRG/MUSDATA/Track3F.asm"
PRG029_SFX_WilyShip:		.include "PRG/MUSDATA/Track40.asm"
PRG029_SFX_TeleportOut:		.include "PRG/MUSDATA/Track41.asm"
PRG029_SFX_42:				.include "PRG/MUSDATA/Track42.asm"	; Unused
PRG029_MUS_IntroStoryTrain:	.include "PRG/MUSDATA/Track43.asm"
PRG029_MUS_FinalBoss:		.include "PRG/MUSDATA/Track45.asm"
PRG029_MUS_FinalVictory:	.include "PRG/MUSDATA/Track46.asm"


	; CHECKME - UNUSED?
	.byte $81	; $B9BD - $B9C1
	.byte $08, $04, $A8, $08, $00, $09, $03, $AB, $80, $6B, $70, $90, $90, $08, $04, $B9	; $B9C2 - $B9D1
	.byte $08, $00, $AB, $80, $6B, $6B, $8B, $8B, $08, $04, $99, $99, $08, $00, $AB, $80	; $B9D2 - $B9E1
	.byte $6B, $6B, $8B, $8B, $8B, $8B, $AD, $80, $6D, $6D, $8D, $8D, $8D, $8D, $AF, $80	; $B9E2 - $B9F1
	.byte $6F, $6F, $8F, $8F, $8F, $8F, $AF, $17, $06, $64, $08, $0D, $07, $06, $8D, $6D	; $B9F2 - $BA01
	.byte $6D, $07, $07, $8D, $6D, $6D, $07, $09, $8D, $6D, $6D, $07, $0B, $8D, $6D, $6D	; $BA02 - $BA11
	.byte $07, $09, $04, $00, $06, $64, $A8, $06, $B4, $00, $68, $68, $68, $68, $68, $68	; $BA12 - $BA21
	.byte $06, $64, $00, $88, $88, $88, $88, $0E, $02, $DA, $14, $07, $05, $8D, $6D, $6D	; $BA22 - $BA31
	.byte $07, $06, $8D, $6D, $6D, $07, $07, $8D, $6D, $6D, $07, $08, $8D, $6D, $6D, $07	; $BA32 - $BA41
	.byte $0A, $8D, $6D, $6D, $07, $0B, $8D, $6D, $6D, $07, $0C, $8D, $6D, $6D, $07, $0D	; $BA42 - $BA51
	.byte $8D, $6D, $6D, $07, $0D, $04, $00, $6D, $0E, $0F, $DA, $57, $6D, $17, $82, $19	; $BA52 - $BA61
	.byte $00, $00, $28, $50, $02, $9E, $22, $A9, $A8, $1F, $20, $09, $22, $2D, $20, $54	; $BA62 - $BA71
	.byte $00, $38, $20, $06, $88, $8D, $00, $20, $A2, $8C, $22, $0E, $02, $57, $88, $A4	; $BA72 - $BA81
	.byte $10, $EA, $88, $0E, $00, $EC, $22, $AE, $A8, $B1, $E0, $B0, $20, $98, $A0, $12	; $BA82 - $BA91
	.byte $2A, $34, $88, $E8, $02, $40, $28, $A3, $82, $C9, $20, $26, $20, $2B, $20, $96	; $BA92 - $BAA1
	.byte $28, $0A, $80, $E3, $00, $95, $08, $D2, $CA, $70, $08, $72, $22, $75, $02, $14	; $BAA2 - $BAB1
	.byte $22, $00, $02, $4B, $AA, $54, $A2, $20, $88, $1E, $82, $92, $80, $08, $A2, $73	; $BAB2 - $BAC1
	.byte $02, $50, $26, $BD, $28, $CF, $22, $08, $20, $72, $AA, $7F, $00, $76, $20, $02	; $BAC2 - $BAD1
	.byte $22, $E9, $0A, $19, $2A, $4B, $A0, $38, $88, $C6, $02, $A7, $28, $43, $20, $4C	; $BAD2 - $BAE1
	.byte $02, $5A, $20, $1A, $A0, $20, $00, $00, $80, $9B, $9A, $85, $20, $22, $02, $18	; $BAE2 - $BAF1
	.byte $20, $C4, $00, $52, $0A, $23, $80, $21, $00, $42, $02, $25, $02, $02, $80, $80	; $BAF2 - $BB01
	.byte $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $81, $81, $81	; $BB02 - $BB11
	.byte $81, $81, $81, $81, $81, $81, $81, $81, $81, $81, $81, $81, $81, $81, $82, $82	; $BB12 - $BB21
	.byte $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82, $82	; $BB22 - $BB31
	.byte $82, $82, $82, $82, $82, $82, $82, $83, $83, $83, $83, $83, $83, $83, $83, $83	; $BB32 - $BB41
	.byte $84, $84, $84, $84, $84, $84, $84, $84, $84, $85, $85, $85, $85, $85, $85, $85	; $BB42 - $BB51
	.byte $85, $85, $85, $85, $85, $85, $8A, $66, $A3, $63, $20, $D4, $00, $5B, $08, $00	; $BB52 - $BB61
	.byte $22, $CD, $0A, $1A, $8A, $0A, $01, $34, $81, $03, $88, $00, $0A, $22, $80, $00	; $BB62 - $BB71
	.byte $02, $3D, $80, $B8, $00, $34, $20, $A9, $80, $90, $00, $11, $28, $21, $21, $61	; $BB72 - $BB81
	.byte $02, $DA, $2A, $C3, $24, $C1, $AA, $1B, $8A, $6E, $88, $3A, $02, $92, $2A, $45	; $BB82 - $BB91
	.byte $02, $35, $80, $EF, $08, $E2, $AA, $6B, $00, $78, $22, $BC, $00, $5F, $00, $8A	; $BB92 - $BBA1
	.byte $C0, $CD, $08, $45, $A2, $1E, $06, $F9, $8A, $90, $81, $18, $88, $18, $20, $34	; $BBA2 - $BBB1
	.byte $02, $23, $0A, $1D, $A2, $AA, $08, $20, $A8, $19, $80, $81, $80, $07, $08, $06	; $BBB2 - $BBC1
	.byte $02, $0E, $08, $9B, $82, $98, $AA, $32, $0A, $3C, $8A, $0D, $00, $29, $A8, $22	; $BBC2 - $BBD1
	.byte $28, $E7, $02, $51, $88, $52, $28, $79, $0C, $0C, $A2, $93, $80, $3C, $20, $B4	; $BBD2 - $BBE1
	.byte $28, $10, $82, $43, $0A, $04, $12, $06, $8A, $A0, $80, $00, $00, $00, $00, $43	; $BBE2 - $BBF1
	.byte $00, $62, $0A, $02, $02, $05, $80, $02, $08, $08, $00, $00, $20, $00, $44, $58	; $BBF2 - $BC01
	.byte $6C, $7E, $90, $9E, $AC, $BA, $C8, $D8, $E8, $FA, $0C, $22, $38, $50, $68, $7E	; $BC02 - $BC11
	.byte $94, $A8, $BC, $D2, $E8, $F0, $F8, $0E, $24, $2A, $30, $46, $5C, $6E, $80, $88	; $BC12 - $BC21
	.byte $90, $92, $94, $A6, $B8, $C6, $D4, $E6, $F8, $0E, $24, $46, $68, $8C, $B0, $C2	; $BC22 - $BC31
	.byte $D4, $D6, $D8, $DA, $DC, $E0, $04, $14, $17, $04, $20, $01, $41, $00, $12, $00	; $BC32 - $BC41
	.byte $3F, $44, $03, $14, $5C, $05, $19, $05, $06, $15, $30, $44, $70, $01, $12, $00	; $BC42 - $BC51
	.byte $39, $10, $00, $00, $20, $14, $06, $40, $80, $00, $00, $40, $08, $01, $80, $00	; $BC52 - $BC61
	.byte $A2, $00, $08, $00, $9A, $00, $04, $50, $32, $05, $08, $50, $00, $14, $24, $55	; $BC62 - $BC71
	.byte $09, $04, $24, $01, $C0, $40, $12, $00, $00, $04, $84, $04, $04, $00, $DA, $10	; $BC72 - $BC81
	.byte $62, $00, $13, $50, $C4, $01, $00, $45, $03, $10, $83, $41, $62, $10, $01, $10	; $BC82 - $BC91
	.byte $21, $50, $3C, $04, $90, $00, $40, $80, $40, $00, $C8, $00, $00, $41, $0B, $44	; $BC92 - $BCA1
	.byte $12, $50, $04, $00, $4A, $10, $40, $10, $3B, $01, $28, $41, $20, $10, $81, $11	; $BCA2 - $BCB1
	.byte $21, $01, $20, $10, $2D, $15, $0E, $01, $40, $00, $25, $04, $00, $01, $C9, $08	; $BCB2 - $BCC1
	.byte $43, $10, $18, $41, $41, $00, $E6, $14, $1A, $55, $53, $00, $41, $00, $8D, $55	; $BCC2 - $BCD1
	.byte $14, $04, $01, $40, $59, $44, $13, $00, $56, $00, $21, $00, $00, $00, $0B, $44	; $BCD2 - $BCE1
	.byte $24, $04, $84, $40, $01, $45, $23, $04, $25, $00, $10, $04, $20, $10, $0A, $11	; $BCE2 - $BCF1
	.byte $30, $10, $30, $00, $10, $04, $45, $15, $20, $00, $08, $44, $0B, $40, $85, $85	; $BCF2 - $BD01
	.byte $85, $85, $85, $85, $85, $85, $85, $85, $85, $85, $86, $86, $86, $86, $86, $86	; $BD02 - $BD11
	.byte $86, $86, $86, $86, $86, $86, $86, $87, $87, $87, $87, $87, $87, $87, $87, $87	; $BD12 - $BD21
	.byte $87, $87, $87, $87, $87, $87, $87, $87, $87, $88, $88, $88, $88, $88, $88, $88	; $BD22 - $BD31
	.byte $88, $88, $88, $88, $88, $88, $48, $11, $80, $40, $12, $40, $03, $11, $D8, $04	; $BD32 - $BD41
	.byte $0C, $11, $DD, $15, $13, $04, $6A, $54, $4C, $44, $6B, $14, $80, $14, $12, $10	; $BD42 - $BD51
	.byte $88, $00, $28, $00, $0C, $00, $41, $05, $30, $00, $80, $01, $02, $04, $C8, $14	; $BD52 - $BD61
	.byte $B0, $10, $CC, $00, $1A, $40, $20, $40, $83, $10, $10, $01, $B0, $40, $95, $05	; $BD62 - $BD71
	.byte $06, $00, $E0, $00, $E0, $50, $00, $00, $E8, $00, $C0, $00, $3C, $10, $00, $10	; $BD72 - $BD81
	.byte $09, $14, $04, $40, $9C, $00, $08, $50, $B1, $40, $08, $00, $20, $11, $A2, $00	; $BD82 - $BD91
	.byte $10, $01, $21, $04, $1A, $11, $01, $41, $08, $05, $49, $10, $25, $14, $10, $11	; $BD92 - $BDA1
	.byte $58, $00, $B6, $40, $44, $50, $86, $51, $A4, $00, $C0, $40, $88, $04, $3C, $11	; $BDA2 - $BDB1
	.byte $00, $10, $20, $44, $94, $50, $00, $40, $20, $00, $10, $00, $66, $00, $59, $00	; $BDB2 - $BDC1
	.byte $04, $01, $43, $05, $D0, $00, $81, $01, $56, $14, $2B, $00, $FB, $00, $81, $00	; $BDC2 - $BDD1
	.byte $71, $10, $18, $00, $04, $00, $80, $00, $0C, $10, $98, $04, $20, $00, $0A, $10	; $BDD2 - $BDE1
	.byte $ED, $00, $02, $11, $50, $00, $22, $50, $84, $45, $15, $01, $00, $01, $20, $04	; $BDE2 - $BDF1
	.byte $91, $54, $00, $40, $C0, $01, $00, $11, $80, $01, $04, $00, $10, $40, $E4, $E4	; $BDF2 - $BE01
	.byte $F1, $FE, $01, $07, $FE, $0D, $10, $13, $16, $1A, $1E, $21, $25, $29, $2D, $30	; $BE02 - $BE11
	.byte $3C, $42, $49, $1A, $1E, $4D, $53, $56, $5D, $61, $65, $69, $6D, $71, $74, $7C	; $BE12 - $BE21
	.byte $7F, $82, $87, $8B, $8F, $92, $98, $B6, $D4, $D8, $E4, $E7, $E7, $EF, $F5, $F9	; $BE22 - $BE31
	.byte $FF, $FF, $FF, $FF, $FF, $FF, $0B, $40, $64, $00, $00, $00, $01, $11, $CC, $11	; $BE32 - $BE41
	.byte $B2, $04, $8A, $05, $40, $00, $58, $10, $90, $44, $04, $50, $4C, $40, $68, $01	; $BE42 - $BE51
	.byte $A4, $04, $01, $00, $11, $00, $80, $00, $00, $54, $C4, $40, $00, $00, $06, $10	; $BE52 - $BE61
	.byte $40, $00, $34, $40, $98, $00, $B0, $00, $36, $00, $80, $41, $A8, $40, $D4, $00	; $BE62 - $BE71
	.byte $08, $05, $00, $00, $95, $01, $10, $00, $F0, $40, $18, $00, $08, $04, $10, $00	; $BE72 - $BE81
	.byte $80, $15, $4B, $50, $90, $11, $42, $01, $20, $10, $0A, $11, $88, $10, $01, $04	; $BE82 - $BE91
	.byte $83, $04, $01, $04, $02, $40, $06, $40, $00, $44, $18, $44, $00, $40, $48, $10	; $BE92 - $BEA1
	.byte $B8, $14, $19, $44, $00, $04, $24, $00, $20, $44, $08, $00, $00, $00, $8C, $00	; $BEA2 - $BEB1
	.byte $28, $50, $00, $40, $28, $00, $00, $04, $00, $10, $00, $40, $01, $40, $92, $04	; $BEB2 - $BEC1
	.byte $18, $40, $01, $10, $17, $40, $68, $00, $02, $00, $00, $00, $61, $01, $1C, $01	; $BEC2 - $BED1
	.byte $08, $14, $40, $41, $00, $40, $30, $04, $22, $11, $10, $05, $66, $01, $51, $40	; $BED2 - $BEE1
	.byte $34, $04, $11, $10, $81, $00, $28, $11, $80, $01, $B1, $00, $20, $45, $C0, $40	; $BEE2 - $BEF1
	.byte $A8, $00, $02, $00, $01, $01, $40, $00, $00, $44, $44, $40, $14, $40, $88, $88	; $BEF2 - $BF01
	.byte $88, $88, $89, $89, $88, $89, $89, $89, $89, $89, $89, $89, $89, $89, $89, $89	; $BF02 - $BF11
	.byte $89, $89, $89, $89, $89, $89, $89, $89, $89, $89, $89, $89, $89, $89, $89, $89	; $BF12 - $BF21
	.byte $89, $89, $89, $89, $89, $89, $89, $89, $89, $89, $89, $89, $89, $89, $89, $89	; $BF22 - $BF31
	.byte $89, $89, $89, $89, $89, $89, $A4, $01, $40, $01, $02, $04, $00, $00, $6D, $01	; $BF32 - $BF41
	.byte $10, $05, $99, $01, $15, $00, $DE, $00, $D1, $01, $07, $02, $88, $00, $8C, $00	; $BF42 - $BF51
	.byte $40, $50, $B0, $15, $41, $10, $00, $44, $20, $40, $26, $10, $42, $00, $28, $00	; $BF52 - $BF61
	.byte $50, $00, $16, $00, $4A, $00, $14, $50, $E2, $01, $02, $01, $A6, $40, $12, $10	; $BF62 - $BF71
	.byte $8D, $01, $04, $10, $82, $01, $48, $00, $51, $00, $00, $00, $42, $10, $42, $40	; $BF72 - $BF81
	.byte $8A, $41, $06, $40, $D5, $54, $4A, $04, $12, $01, $58, $05, $98, $00, $02, $04	; $BF82 - $BF91
	.byte $00, $01, $0C, $41, $51, $01, $23, $40, $20, $40, $22, $04, $00, $00, $F0, $41	; $BF92 - $BFA1
	.byte $30, $00, $0A, $15, $91, $50, $89, $01, $B8, $00, $1A, $00, $1A, $00, $98, $10	; $BFA2 - $BFB1
	.byte $02, $54, $C1, $40, $12, $00, $C0, $40, $12, $10, $80, $10, $A2, $00, $A1, $00	; $BFB2 - $BFC1
	.byte $4A, $11, $CD, $00, $0F, $00, $84, $40, $A9, $00, $85, $45, $84, $10, $B1, $00	; $BFC2 - $BFD1
	.byte $92, $10, $04, $40, $10, $05, $4D, $11, $00, $00, $20, $01, $40, $10, $18, $40	; $BFD2 - $BFE1
	.byte $4A, $41, $50, $00, $30, $40, $21, $50, $71, $04, $84, $44, $68, $11, $91, $40	; $BFE2 - $BFF1
	.byte $20, $00, $21, $00, $82, $41, $9A, $00, $05, $10, $10, $10, $80, $00	; $BFF2 - $BFFF


