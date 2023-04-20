	; !!NOTE!!: Continued from PRG062, DO NOT PUT ANYTHING ABOVE THIS LINE UNLESS YOU MOVE THIS TABLE SO IT DOESN'T STRADDLE ANYMORE	

	.byte                         13, 13, 13, 13, 13, 13, 13, 13, 13, 13	; Sprite indexes $06-$0F
	.byte 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55	; Sprite indexes $10-$1F
	.byte 55, 55, 55, 55, 55, 55, 55, 13, 55, 13, 55, 55, 55, 55, 55, 55	; Sprite indexes $20-$2F
	.byte 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55	; Sprite indexes $30-$3F
	.byte 55, 55, 55, 55, 55, 13, 11, 55, 55, 15, 15, 55, 55, 11, 55, 55	; Sprite indexes $40-$4F
	.byte 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 15, 55, 55	; Sprite indexes $50-$5F
	.byte 11, 55, 55, 55, 55, 55, 55, 13, 55, 55, 55, 55, 55, 55, 55, 13	; Sprite indexes $60-$6F
	.byte 55, 15, 15, 55, 55, 15, 15, 15, 55, 15, 15, 15, 15, 15, 15, 15	; Sprite indexes $70-$7F
	.byte 55, 15, 15, 55, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15	; Sprite indexes $80-$8F
	.byte 55, 15, 13, 13, 55, 13, 13, 13, 55, 55, 13, 13, 13, 55, 15, 15	; Sprite indexes $90-$9F
	.byte 15, 15, 15, 13, 13, 13, 13, 15, 15, 15, 55, 13, 13, 13, 13, 13	; Sprite indexes $A0-$AF
	.byte 13, 15, 13, 13, 13, 13, 13, 13, 15, 11, 11, 13, 11, 11, 11, 13	; Sprite indexes $B0-$BF
	.byte 13, 55, 13, 55, 11, 11, 55, 11, 55, 55, 11, 11, 15, 55, 55, 13	; Sprite indexes $C0-$CF

	; CHECKME - UNUSED?
	.byte 13, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55	; Sprite indexes $D0-$DF
	.byte 13, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55	; Sprite indexes $E0-$EF
	.byte 13, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55, 55	; Sprite indexes $F0-$FF



	; Performs the graphical effect of the rainbow platform appearing/disappearing
PRG063_RingManRainbowPlatGfx:
	LDA <TileMap_Index
	CMP #TMAP_RINGMAN
	BNE PRG063_E12D	; If this isn't Ring Man, jump to PRG063_E12D (RTS)

	; Ring Man only... for the rainbow platforms (hereafter "RMRPs")

	; Since this is Ring Man only, this will always install page 36 @ $A000
	ORA #32
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

	LDA <CommitGBuf_Flag
	ORA <CommitGBuf_FlagV
	BNE PRG063_E12D	; If something is already queued, jump to PRG063_E12D (RTS)

	STA <Temp_Var17	; Temp_Var17 = 0
	
	TAX	; X = 0
	
	LDY #$03	; X = 3 (4 RMRPs max)
	STY <Temp_Var16	; Temp_Var16 = 3
PRG063_E114:
	LDY <Temp_Var16	; Y = loop index
	
	LDA RingManRainbowPlat_Data+$00,Y
	BPL PRG063_E122	; If this RMRP is not active, jump to PRG063_E122

	AND #$40
	BEQ PRG063_E122	; If this RMRP is not updating, jump to PRG063_E122

	JSR PRG063_RMRPUpdate

PRG063_E122:
	DEC <Temp_Var16	; Temp_Var16--
	BPL PRG063_E114	; While more RMRPs to do, loop!

	; Mark for updates
	LDA <Temp_Var17
	STA Graphics_Buffer+$00,X
	STA <CommitGBuf_Flag

PRG063_E12D:
	RTS	; $E12D


PRG063_RMRPUpdate:
	; Clear update flag
	LDA RingManRainbowPlat_Data+$00,Y
	AND #~$40
	STA RingManRainbowPlat_Data+$00,Y
	
	LDA RingManRainbowPlat_VL+$00,Y	; $E136
	AND #$1F	; $E139
	STA <Temp_Var2	; $E13B
	
	JSR PRG063_E1BF	; $E13D

	BCC PRG063_E179	; $E140

	; VRAM High address
	LDA RingManRainbowPlat_VH+$00,Y
	STA Graphics_Buffer+$00,X
	STA Graphics_Buffer+$04,X
	
	LDA RingManRainbowPlat_VL+$00,Y	; $E14B
	STA Graphics_Buffer+$01,X	; $E14E
	ORA #$20	; $E151
	STA Graphics_Buffer+$05,X	; $E153
	
	LDA #$00	; $E156
	STA Graphics_Buffer+$02,X	; $E158
	STA Graphics_Buffer+$06,X	; $E15B
	
	LDA RingManRainbowPlat_Cnt+$00,Y	; $E15E
	TAY	; $E161
	
	LDA TileLayout_Patterns,Y	; $E162
	STA Graphics_Buffer+$03,X	; $E165
	
	LDA TileLayout_Patterns+$0200,Y
	STA Graphics_Buffer+$07,X	; $E16B
	
	LDA #$FF	; $E16E
	STA <Temp_Var17	; $E170
	
	TXA	; $E172
	ADD #$08	; $E173
	TAX	; $E176
	
	LDY <Temp_Var16	; $E177

PRG063_E179:
	LDA RingManRainbowPlat_VL+$00,Y	; $E179
	AND #$1F	; $E17C
	ORA #$01	; $E17E
	STA <Temp_Var2	; $E180
	
	JSR PRG063_E1BF	; $E182

	BCC PRG063_E1BE	; $E185

	LDA RingManRainbowPlat_VH+$00,Y	; $E187
	STA Graphics_Buffer+$00,X	; $E18A
	STA Graphics_Buffer+$04,X	; $E18D
	
	LDA RingManRainbowPlat_VL+$00,Y	; $E190
	ORA #$01	; $E193
	STA Graphics_Buffer+$01,X	; $E195
	
	ORA #$20	; $E198
	STA Graphics_Buffer+$05,X	; $E19A
	
	LDA #$00	; $E19D
	STA Graphics_Buffer+$02,X	; $E19F
	STA Graphics_Buffer+$06,X	; $E1A2
	
	LDA RingManRainbowPlat_Cnt+$00,Y	; $E1A5
	TAY	; $E1A8
	
	LDA TileLayout_Patterns+$0100,Y
	STA Graphics_Buffer+$03,X	; $E1AC
	
	LDA TileLayout_Patterns+$0300,Y
	STA Graphics_Buffer+$07,X	; $E1B2
	
	LDA #$FF	; $E1B5
	STA <Temp_Var17	; $E1B7
	
	TXA	; $E1B9
	ADD #$08	; $E1BA
	TAX	; $E1BD

PRG063_E1BE:
	RTS	; $E1BE


PRG063_E1BF:
	LDA <Level_SegCurData
	AND #$C0	; $E1C1
	BNE PRG063_E20A	; $E1C3

	LDA <Horz_Scroll
	LSR A
	LSR A
	LSR A
	STA <Temp_Var0	; Temp_Var0 = Horz_Scroll / 8
	
	LDA <Temp_Var2	; $E1CC
	SUB <Temp_Var0	; $E1CE
	
	LDA RingManRainbowPlat_Data+$00,Y	; $E1D1
	AND #$3F	; $E1D4
	STA <Temp_Var1	; $E1D6
	
	SBC <Current_Screen	; $E1D8
	BCC PRG063_E20C	; $E1DA

	BEQ PRG063_E1F8	; $E1DC

	CMP #$01	; $E1DE
	BNE PRG063_E20C	; $E1E0

	LDA <Temp_Var2	; $E1E2
	CMP <ScreenUpd_CurCol	; $E1E4
	BEQ PRG063_E204	; $E1E6

	LDA <RAM_0023
	AND #$01
	BNE PRG063_E20C

	INC <Temp_Var2
	LDA <Temp_Var2
	CMP <ScreenUpd_CurCol
	BEQ PRG063_E20A
	BNE PRG063_E20C

	
PRG063_E1F8:
	LDA <Temp_Var2	; $E1F8
	CMP <Temp_Var0	; $E1FA
	BEQ PRG063_E20C	; $E1FC

	LDA <Temp_Var2	; $E1FE
	CMP <ScreenUpd_CurCol	; $E200
	BNE PRG063_E20A	; $E202


PRG063_E204:
	LDA <Temp_Var1	; $E204
	CMP <MetaBlk_CurScreen	; $E206
	BNE PRG063_E20C	; $E208


PRG063_E20A:
	SEC	; $E20A
	RTS	; $E20B


PRG063_E20C:
	CLC	; $E20C
	RTS	; $E20D

	; CHECKME - UNUSED?
	SEC
	LDA <CommitGBuf_FlagV
	ORA <CommitGBuf_Flag
	BNE PRG063_E261
	LDA #$08
	STA Graphics_Buffer+$00
	LDA Spr_Y+$00,X
	AND #$F0
	ASL A
	ROL Graphics_Buffer+$00
	ASL A
	ROL Graphics_Buffer+$00
	STA Graphics_Buffer+$01
	LDA Spr_X+$00,X
	AND #$F0
	LSR A
	LSR A
	LSR A
	ORA Graphics_Buffer+$01
	STA Graphics_Buffer+$01
	ORA #$20
	STA Graphics_Buffer+$06
	LDA #$01
	STA Graphics_Buffer+$02
	STA Graphics_Buffer+$07
	LDA Graphics_Buffer+$00
	STA Graphics_Buffer+$05
	LDA #$00
	STA Graphics_Buffer+$03
	STA Graphics_Buffer+$04
	STA Graphics_Buffer+$08
	STA Graphics_Buffer+$09
	LDA #$FF
	STA Graphics_Buffer+$0A
	STA <CommitGBuf_Flag
	CLC


PRG063_E261:
	RTS	; $E261


	; Copies one the 32x32 metablocks to the graphics buffer
	; and queues buffer commit
PRG063_CopyMetaBlockToGBuf:
	LDA <CommitGBuf_Flag	; $E262
	ORA <CommitGBuf_FlagV	; $E264
	BNE PRG063_E261	; If CommitGBuf_Flag or CommitGBuf_FlagV are not zero (not committing graphics), jump to PRG063_E261

	LDA <RAM_001D	; $E268
	BPL PRG063_E261	; $E26A

	AND #$7F	; $E26C
	STA <RAM_001D	; $E26E
	AND #$3F	; $E270
	STA <MetaBlk_Index	; $E272
	
	LDY #$00	; $E274
	LDA <RAM_001D	; $E276
	AND #$40	; $E278
	BEQ PRG063_E286	; $E27A

	LDY #$04	; $E27C
	LDA <Level_SegCurData	; $E27E
	AND #$20	; $E280
	BEQ PRG063_E286	; $E282

	LDY #$08	; $E284

PRG063_E286:
	STY <Temp_Var16	; $E286
	
	LDA <MetaBlk_Index	; $E288
	PHA	; $E28A
	AND #$07	; $E28B
	ASL A	; $E28D
	ASL A	; $E28E
	STA Graphics_Buffer+$01	; $E28F
	LDA #$02	; $E292
	STA Graphics_Buffer+$00	; $E294
	
	PLA	; $E297
	AND #$F8	; $E298
	ASL A	; $E29A
	ROL Graphics_Buffer+$00	; $E29B
	ASL A	; $E29E
	ROL Graphics_Buffer+$00	; $E29F
	ASL A	; $E2A2
	ROL Graphics_Buffer+$00	; $E2A3
	ASL A	; $E2A6
	ROL Graphics_Buffer+$00	; $E2A7
	ORA Graphics_Buffer+$01	; $E2AA
	STA Graphics_Buffer+$01	; $E2AD
	ADD #$20	; $E2B0
	STA Graphics_Buffer+$08	; $E2B3
	ADC #$20	; $E2B6
	STA Graphics_Buffer+$0F	; $E2B8
	ADC #$20	; $E2BB
	STA Graphics_Buffer+$16	; $E2BD
	
	
	LDA <MetaBlk_Index	; $E2C0
	ORA #$C0	; $E2C2
	STA Graphics_Buffer+$1D	; $E2C4
	LDA Graphics_Buffer+$00	; $E2C7
	ORA <Temp_Var16	; $E2CA
	STA Graphics_Buffer+$00	; $E2CC
	STA Graphics_Buffer+$07	; $E2CF
	STA Graphics_Buffer+$0E	; $E2D2
	STA Graphics_Buffer+$15	; $E2D5
	ORA #$03	; $E2D8
	STA Graphics_Buffer+$1C	; $E2DA
	LDA #$03	; $E2DD
	STA Graphics_Buffer+$02	; $E2DF
	STA Graphics_Buffer+$09	; $E2E2
	STA Graphics_Buffer+$10	; $E2E5
	STA Graphics_Buffer+$17	; $E2E8
	
	LDA #$00	; $E2EB
	STA Graphics_Buffer+$1E	; $E2ED
	LDY <CommitBG_ScrSel	; $E2F0
	JSR PRG062_SetMetaBlkAddr	; $E2F2

	JSR PRG062_FillPatternBuffer	; $E2F5

	LDX #$03	; $E2F8

PRG063_E2FA:
	LDA Pattern_Buffer,X	; $E2FA
	STA Graphics_Buffer+$03,X	; $E2FD
	LDA Pattern_Buffer+4,X	; $E300
	STA Graphics_Buffer+$0A,X	; $E303
	LDA Pattern_Buffer+8,X	; $E306
	STA Graphics_Buffer+$11,X	; $E309
	LDA Pattern_Buffer+12,X	; $E30C
	STA Graphics_Buffer+$18,X	; $E30F
	DEX	; $E312
	BPL PRG063_E2FA	; $E313

	LDA <Temp_Var16	; $E315
	STA Graphics_Buffer+$1F	; $E317
	STX Graphics_Buffer+$20	; $E31A
	LDA <MetaBlk_Index	; $E31D
	AND #$3F	; $E31F
	CMP #$38	; $E321
	BLT PRG063_E330	; $E323

	LDX #$04	; $E325

PRG063_E327:
	LDA Graphics_Buffer+$1C,X	; $E327
	STA Graphics_Buffer+$0E,X	; $E32A
	DEX	; $E32D
	BPL PRG063_E327	; $E32E


PRG063_E330:
	STX <CommitGBuf_Flag	; $E330
	RTS	; $E332


PRG063_E333:
	; CommitBG_Flag = 0
	LDA #$00
	STA <CommitBG_Flag
	
	LDA <Temp_Var16
	ORA #$03		; $23xx, $27xx, $2Bxx, $2Fxx
	STA Graphics_Buffer+$00
	LDA #$C0	; Root of attribute data for specified nametable
	STA Graphics_Buffer+$01
	
	; Writing $40 bytes (full screen of attribute data)
	; Attribute data is specified in Level_ScreenTileModData
	LDY #$3F
	STY Graphics_Buffer+$02
PRG063_E348:
	LDA Level_ScreenTileModData+$00,Y
	STA Graphics_Buffer+$03,Y
	
	LDA #$00
	STA Level_ScreenTileModData+$00,Y
	
	DEY	; Y--
	BPL PRG063_E348	; While Y >= 0, loop

	STY Graphics_Buffer+$43	; $FF terminator at end
	STY <CommitGBuf_Flag	; Commit graphics buffer

PRG063_E35B:
	RTS	; $E35B


PRG063_E35C:
	LDA <CommitGBuf_Flag
	ORA <CommitGBuf_FlagV
	BNE PRG063_E35B	; If any commits pending, jump to PRG063_E35B (RTS)

	; Temp_Var16 = 4 ($x4xx PPU addr)
	LDA #$04
	STA <Temp_Var16
	
	LDA <Level_SegCurData
	AND #($40 | $80)
	BNE PRG063_E36E	; $E36A

	ASL <Temp_Var16	; Temp_Var16 = 8 ($x8xx PPU addr)

PRG063_E36E:
	LDA <Temp_Var16
	ORA #$20	; ($24xx/$28xx PPU addr)
	STA <Temp_Var16
	
	LDA <CommitBG_Flag
	BEQ PRG063_E35B	; If CommitBG_Flag = 0, jump to PRG063_E35B (RTS)

	CMP #$40
	BEQ PRG063_E333	; If CommitBG_Flag = $40, jump to PRG063_E333 (commit attribute data in all 64 bytes of Level_ScreenTileModData)

	AND #$7F
	STA <CommitBG_Flag	; Strip bit 7; remaining bits specify a value for MetaBlk_Index
	
	LDY <CommitBG_ScrSel
	JSR PRG062_SetMetaBlkAddr

	LDA <CommitBG_Flag
	STA <MetaBlk_Index
	
	PHA	; Save MetaBlk_Index
	
	AND #$07
	ASL A
	ASL A
	STA Graphics_Buffer+$01
	
	LDA #$02
	STA Graphics_Buffer+$00
	
	PLA	; Restore MetaBlk_Index
	
	AND #$F8
	ASL A
	ROL Graphics_Buffer+$00
	ASL A
	ROL Graphics_Buffer+$00
	ASL A
	ROL Graphics_Buffer+$00
	ASL A
	ROL Graphics_Buffer+$00
	ORA Graphics_Buffer+$01
	STA Graphics_Buffer+$01
	
	ADD #$20
	STA Graphics_Buffer+$14
	
	ADC #$20
	STA Graphics_Buffer+$27
	
	ADC #$20
	STA Graphics_Buffer+$3A
	
	LDA Graphics_Buffer+$00
	ORA <Temp_Var16
	STA Graphics_Buffer+$00
	STA Graphics_Buffer+$13
	STA Graphics_Buffer+$26
	STA Graphics_Buffer+$39
	
	LDA #$0F
	STA Graphics_Buffer+$02
	STA Graphics_Buffer+$15
	STA Graphics_Buffer+$28
	STA Graphics_Buffer+$3B

PRG063_E3DE:
	JSR PRG062_FillPatternBuffer

	LDA <MetaBlk_Index	; $E3E1
	AND #$03	; $E3E3
	TAX	; $E3E5
	
	LDY PRG063_VRAMAttrHBase,X	; $E3E6
	LDX #$00	; $E3E9

PRG063_E3EB:
	LDA Pattern_Buffer,X	; $E3EB
	STA Graphics_Buffer+$00,Y	; $E3EE
	
	INY	; $E3F1
	INX	; $E3F2
	TXA	; $E3F3
	AND #$03	; $E3F4
	BNE PRG063_E3EB	; $E3F6

	TYA	; $E3F8
	ADD #$0F	; $E3F9
	PHA	; $E3FC
	
	LDY <MetaBlk_Index	; $E3FD
	
	LDA <Temp_Var16	; $E3FF
	STA Level_ScreenTileModData+$00,Y	; $E401
	
	PLA	; $E404
	TAY	; $E405
	CPY #$4C	; $E406
	BLT PRG063_E3EB	; $E408

	INC <CommitBG_Flag	; $E40A
	INC <MetaBlk_Index	; $E40C
	LDA <MetaBlk_Index	; $E40E
	AND #$03	; $E410
	BNE PRG063_E3DE	; $E412

	LDA #$FF	; $E414
	STA Graphics_Buffer+$4C	; $E416
	
	LDY <MetaBlk_Index	; $E419
	CPY #$39	; $E41B
	BLT PRG063_E422	; $E41D

	STA Graphics_Buffer+$26	; $E41F

PRG063_E422:
	STA <CommitGBuf_Flag	; $E422
	RTS	; $E424


PRG063_VRAMAttrHBase:
	; $23xx, $27xx, $2Bxx, $2Fxx
	.byte $03, $07, $0B, $0F



PRG063_BrightManLightDarkFX:
	;	- $00: Bright
	;	- $01: Darkening
	;	- $40: Dark
	;	- $80: Brightening up

	LDA Level_LightDarkCtl
	BEQ PRG063_E468	; If not shrouded in darkness / transitioning, jump to PRG063_E468 (RTS)

	BMI PRG063_E469	; If brightening up, jump to PRG063_E469

	AND #$40
	BNE PRG063_E468	; If fully dark, jump to PRG063_E468 (RTS)

	; Darkening...

	LDA Level_LightDarkTransCnt
	BNE PRG063_E465	; If still ticking, jump to PRG063_E465

	; Ticked out, darken palette
	LDY #$0F
PRG063_E43B:
	LDA PalData_2,Y
	SUB Level_LightDarkTransLevel
	BPL PRG063_E446

	; Minimum dark
	LDA #$0F

PRG063_E446:
	STA PalData_1,Y
	
	DEY	; $E449
	BPL PRG063_E43B	; $E44A

	; Commit palette
	STY <CommitPal_Flag
	
	; Level_LightDarkTransCnt = 5
	LDA #$05
	STA Level_LightDarkTransCnt
	
	LDA Level_LightDarkTransLevel
	ADD #$10
	STA Level_LightDarkTransLevel
	
	CMP #$50
	BNE PRG063_E465	; If not at maximum darkness level, jump to PRG063_E465

	; Level_LightDarkCtl = $40 
	LDA #$40
	STA Level_LightDarkCtl

PRG063_E465:
	DEC Level_LightDarkTransCnt	; Level_LightDarkTransCnt--

PRG063_E468:
	RTS	; $E468


PRG063_E469:
	LDA Level_LightDarkTransCnt
	BNE PRG063_E498	; If still ticking, jump to PRG063_E498

	; Ticked out, brighten palette
	LDY #$0F	; $E46E
PRG063_E470:
	LDA PalData_2,Y
	SUB Level_LightDarkTransLevel
	BPL PRG063_E47B

	; Minimum dark
	LDA #$0F

PRG063_E47B:
	STA PalData_1,Y
	DEY
	BPL PRG063_E470

	; Commit palette
	STY <CommitPal_Flag

	; Level_LightDarkTransCnt = 5
	LDA #$05
	STA Level_LightDarkTransCnt
	
	LDA Level_LightDarkTransLevel
	SUB #$10
	STA Level_LightDarkTransLevel
	BCS PRG063_E498

	; Level_LightDarkCtl = 0 (back to full brightness)
	LDA #$00
	STA Level_LightDarkCtl

PRG063_E498:
	DEC Level_LightDarkTransCnt	; $E498
	RTS	; $E49B


	; This alters nametable data for when a chunk of level appears after flipping
	; a switch in Drill Man. What is that about anyway?
PRG063_DrillManUpdScrlForSw:
	LDA <RAM_001E	; $E49C
	BEQ PRG063_E4DC	; $E49E

	LDA <TileMap_Index
	CMP #TMAP_DRILLMAN
	BNE PRG063_E4DC	; If this is not Drill Man, jump to PRG063_E4DC (RTS)

	LDA <CommitGBuf_Flag
	ORA <CommitGBuf_FlagV
	BNE PRG063_E4DC	; If any commits pending, jump to PRG063_E4DC (RTS)

	LDA #$23	; $E4AC
	STA Graphics_Buffer+$00	; $E4AE
	LDA #$E0	; $E4B1
	STA Graphics_Buffer+$01	; $E4B3
	
	; Chunk to make appear in Drill Man
	LDY #$1F
	STY Graphics_Buffer+$02

PRG063_E4BB:
	LDA Pattern_AttrBuffer+$20,Y	; $E4BB
	STA Graphics_Buffer+$03,Y	; $E4BE
	
	DEY	; $E4C1
	BPL PRG063_E4BB	; $E4C2

	STY Graphics_Buffer+$23	; $FF Terminator
	STY <CommitGBuf_Flag	; Commit graphics buffer
	
	
	LDY #$03	; $E4C9
	LDA #$0F	; $E4CB

PRG063_E4CD:
	STA PalData_1+8,Y	; $E4CD
	STA PalData_2+8,Y	; $E4D0
	DEY	; $E4D3
	BPL PRG063_E4CD	; $E4D4

	STY <CommitPal_Flag	; $E4D6
	
	LDA #$00	; $E4D8
	STA <RAM_001E	; $E4DA

PRG063_E4DC:
	RTS	; $E4DC


PRG063_DustManCrusherBustBlock:
	LDX DustManCrsh_BlkShotOutScr
	BEQ PRG063_E4DC	; If no Dust Man block has been shot out, jump to PRG063_E4DC (RTS)

	LDY PRG063_DustManCrushBlkDatOff-$0C,X	; Starting index for screen
PRG063_E4E5:
	LDA PRG063_DustManCrushBlkDat,Y
	BMI PRG063_E4DC	; If terminator to block list, jump to PRG063_E4DC (RTS)

	CMP DustManCrsh_BlkShotOutMeta
	BEQ PRG063_E4F3	; If matched the metablock, jump to PRG063_E4F3

	INY
	INY
	BNE PRG063_E4E5	; Loop!


PRG063_E4F3:
	LDA <CommitGBuf_Flag
	ORA <CommitGBuf_FlagV
	BNE PRG063_E4DC	; If other commits pending, jump to PRG063_E4DC (RTS)

	STA DustManCrsh_BlkShotOutScr	; Clear DustManCrsh_BlkShotOutScr
	
	; Compute offset to column
	LDA PRG063_DustManCrushBlkDat+$01,Y
	ORA DustManCrsh_BlkShotOutCol
	
	PHA
	
	; Bit select to set on Level_ScreenTileModData
	AND #$07
	TAX
	
	PLA
	
	; Compute offset into Level_ScreenTileModData
	LSR A
	LSR A
	LSR A
	TAY
	
	; Set Level_ScreenTileModData bit pertaining to the block shot out
	LDA Level_ScreenTileModData+$00,Y
	ORA PRG063_IndexToBit,X
	STA Level_ScreenTileModData+$00,Y
	
	LDA DustManCrsh_BlkShotOutMeta
	PHA	; Save DustManCrsh_BlkShotOutMeta
	
	; Incomplete graphics buffer address
	AND #$07
	ASL A
	ASL A
	STA Graphics_Buffer+$01
	LDA #$02
	STA Graphics_Buffer+$00
	
	PLA	; Restore DustManCrsh_BlkShotOutMeta
	AND #$F8
	
	; Computing proper graphics buffer address
	ASL A
	ROL Graphics_Buffer+$00
	ASL A
	ROL Graphics_Buffer+$00
	ASL A
	ROL Graphics_Buffer+$00
	ASL A
	ROL Graphics_Buffer+$00
	ORA Graphics_Buffer+$01
	STA Graphics_Buffer+$01
	
	LDA Graphics_Buffer+$00
	STA Graphics_Buffer+$05
	
	; Offset address for column
	LDY DustManCrsh_BlkShotOutCol
	LDA Graphics_Buffer+$01
	ORA PRG063_DustManCrushBlk_BaseVA,Y
	STA Graphics_Buffer+$01
	
	; Lower row address
	ORA #$20
	STA Graphics_Buffer+$06

	; 2 patterns to commit per row
	LDA #$01
	STA Graphics_Buffer+$02
	STA Graphics_Buffer+$07
	
	; Clear patterns
	LDA #$00
	STA Graphics_Buffer+$03
	STA Graphics_Buffer+$04
	STA Graphics_Buffer+$08
	
PRG063_E567:
	STA Graphics_Buffer+$09
	
	; Terminator
	LDA #$FF
	STA Graphics_Buffer+$0A
	
	STA <CommitGBuf_Flag	; Commit graphics buffer
	
	RTS	; $E571

PRG063_DustManCrushBlkDatOff:
	.byte (PRG063_DustManCrushBlkDat_0C - PRG063_DustManCrushBlkDat)	; Screen $0C
	.byte (PRG063_DustManCrushBlkDat_0D - PRG063_DustManCrushBlkDat)	; Screen $0D
	.byte (PRG063_DustManCrushBlkDat_0E - PRG063_DustManCrushBlkDat)	; Screen $0E
	.byte (PRG063_DustManCrushBlkDat_0F - PRG063_DustManCrushBlkDat)	; Screen $0F
	.byte (PRG063_DustManCrushBlkDat_10 - PRG063_DustManCrushBlkDat)	; Screen $10
	
PRG063_DustManCrushBlkDat:
PRG063_DustManCrushBlkDat_0C:
	.byte $FF
	
PRG063_DustManCrushBlkDat_0D:
	.byte $1A, $00
	.byte $22, $04
	.byte $2A, $08
	.byte $1B, $0C
	.byte $23, $10
	.byte $2B, $14
	.byte $1C, $18
	.byte $24, $1C
	.byte $2C, $20
	.byte $1D, $24
	.byte $25, $28
	.byte $2D, $2C
	.byte $FF
	
PRG063_DustManCrushBlkDat_0E:
	.byte $1A, $30
	.byte $22, $34
	.byte $2A, $38
	.byte $1B, $3C
	.byte $23, $40
	.byte $2B, $44
	.byte $1C, $48
	.byte $24, $4C
	.byte $2C, $50
	.byte $1D, $54
	.byte $25, $58
	.byte $2D, $5C
	.byte $FF
	
PRG063_DustManCrushBlkDat_0F:
	.byte $1A, $60
	.byte $22, $64
	.byte $2A, $68
	.byte $1B, $6C
	.byte $23, $70
	.byte $2B, $74
	.byte $FF
	
PRG063_DustManCrushBlkDat_10:
	.byte $18, $78
	.byte $20, $7C
	.byte $28, $80
	.byte $19, $84
	.byte $21, $88
	.byte $29, $8C
	.byte $FF
	
PRG063_DustManCrushBlk_BaseVA:
	.byte $00, $02, $40, $42



	; Loads the graphics and palette needed for the transporter and draws the new segment
	; 'A' is the desired segment
PRG063_LoadGfxPalForTrans:
	STA <Temp_Var16	; Desired screen -> Temp_Var16
	
	; Backup pages @ $8000/$A000
	LDA <MMC3_Page8000_Req
	PHA
	LDA <MMC3_PageA000_Req
	PHA
	
	; Set bank 32-52
	LDA <TileMap_Index
	ORA #32
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

	LDY <MetaBlk_CurScreen	; Y = MetaBlk_CurScreen
	
	; Set spawn hint values for the screen
	LDA Level_LayoutObjHintByScr,Y
	STA <RAM_009E
	STA <RAM_009F
	
	; Vertical mirroring
	LDA #$01
	STA MMC3_MIRROR
	
	LDA #$01
	STA <RAM_0023	; $E5E9
	STA <Level_LastScrollDir
	
	LDY <Temp_Var16	; Y = Temp_Var16 (desired segment)
	
	LDA Level_SegmentDefs,Y
	AND #$20
	BNE PRG063_E604	; If horizontal mirroring requested, jump to PRG063_E604
	
	; Vertical mirroring

	LDA #$08	; $E5F6
	STA <RAM_0023	; $E5F8
	
	; Horizontal mirroring
	LDA #$00
	STA MMC3_MIRROR
	
	LDA Level_SegmentDefs,Y
	AND #$C0	; $E602

PRG063_E604:
	ORA <Temp_Var16			; OR in the screen
	STA <Level_SegCurData	; -> Level_SegCurData
	
	LDA Level_SegmentDefs,Y
	AND #$0F
	STA <Level_SegTotalRelScreen
	
	LDA #$00
	STA <Level_SegCurrentRelScreen
	
	LDA #$00
	STA <ScreenUpd_CurCol
	
	; Current screen before redraw (so we know when we're on target)
	LDA <MetaBlk_CurScreen
	STA <Temp_Var15

PRG063_E61B:
	JSR PRG062_SetMBA_DrawColumn
	JSR PRG063_UpdateOneFrame

	LDA <MetaBlk_CurScreen
	CMP <Temp_Var15
	BNE PRG063_E635	; If fully drawn new screen, jump to PRG063_E635

	INC <ScreenUpd_CurCol	; Next column
	
	LDA <ScreenUpd_CurCol
	AND #$1F				; Cap 0-31
	STA <ScreenUpd_CurCol	
	BNE PRG063_E61B			; If haven't come full circle, loop

	INC <MetaBlk_CurScreen	; Advance screen
	BNE PRG063_E61B	; Jump (technically always) to PRG063_E61B


PRG063_E635:
	LDA <Level_SegCurData	; $E635
	AND #$C0	; $E637
	BEQ PRG063_E63F	; $E639

	LDA <Temp_Var15	; $E63B
	STA <MetaBlk_CurScreen	; $E63D

PRG063_E63F:
	JSR PRG062_DisableDisplay
	JSR PRG062_LoadPalAndGfxForSeg

	; Screens $A, $D, and $E are boss rooms during the boss rush in Wily's Fortress
	LDA <Current_Screen
	CMP #$0A
	BEQ PRG063_E653

	CMP #$0D
	BEQ PRG063_E653

	CMP #$0E
	BNE PRG063_E65B		; If not a boss rush boss room, jump to PRG063_E65B


PRG063_E653:
	LDY <WilyTrans_CurPortal
	
	; Load proper graphics/palette for this robot master
	LDA PRG063_TransporterBossGfxReq,Y
	JSR PRG062_CHRRAMDynLoadPalSeg


PRG063_E65B:
	; Load graphics/palette for the segment
	JSR PRG062_CHRRAMDynLoadCHRSeg

	LDA <CommitGBuf_Flag
	BEQ PRG063_E668	; If not committing graphics, jump to PRG063_E668

	; Attempt to commit graphics
	JSR PRG062_CommitGfxBuffer_ClrFlag
	JMP PRG063_E65B	; Jump to PRG063_E65B


PRG063_E668:
	LDA #$00
	STA <CommitPal_Flag
	STA <Object_ReqBGSwitch
	JSR PRG062_EnableDisplay

	; Restore banks at $8000/$A000
	PLA
	STA <MMC3_PageA000_Req
	PLA
	STA <MMC3_Page8000_Req
	JMP PRG063_SetPRGBanks


PRG063_TransporterBossGfxReq:
	; Dynamic graphics/palette load for robot master
	.byte $2B, $2D, $28, $2A, $2E, $2C, $27, $29



PRG063_DoBossGateOpen:
	; Set bank 32 - 52
	LDA <TileMap_Index
	ORA #32
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

	; General_Counter = 0
	LDA #$00
	STA <General_Counter
	
	; Bottom of gate upper left address
	LDA Level_BossGateBaseVADDR
	STA Graphics_Buffer+$00
	STA Graphics_Buffer+$05
	
	LDA Level_BossGateBaseVADDR+1
	STA Graphics_Buffer+$01
	ORA #$20
	STA Graphics_Buffer+$06	; Lower left
	
	; 2 patterns to substitute per gate tile
	LDA #$01
	STA Graphics_Buffer+$02
	STA Graphics_Buffer+$07
	
	; Attribute VRAM ADDR high $23x
	LDA #$23
	STA Graphics_Buffer+$0A
	
	; Attribute VRAM ADDR low
	LDA Level_BossGateBaseAttrVADDRL
	STA <Temp_Var3
	ORA #$C0
	STA Graphics_Buffer+$0B
	
	; Attr mask select
	LDA Level_BossGateBaseAttrMask
	STA <Temp_Var4
	
	; Single attribute byte to change
	LDA #$00
	STA Graphics_Buffer+$0C
	
	; Boss gate tick sound
	LDA #SFX_BOSSGATEOPEN
	JSR PRG063_QueueMusSnd

	; Temp_Var2 = 4 (number of gate replacement tile loops)
	LDA #$04
	STA <Temp_Var2
	
	LDY #$00	; Y = 0
PRG063_E6CF:
	; Get tile to use to replace this gate tile
	LDX Level_BossGateReplaceTiles,Y
	
	; Tile to replace as gate opens
	LDA TileLayout_Patterns,X
	STA Graphics_Buffer+$03
	LDA TileLayout_Patterns+$0100,X
	STA Graphics_Buffer+$04
	LDA TileLayout_Patterns+$0200,X
	STA Graphics_Buffer+$08
	LDA TileLayout_Patterns+$0300,X
	STA Graphics_Buffer+$09
	

	; Replace attribute mask select (expected 0 to 3)
	LDX <Temp_Var4
	
	; Mask for attribute used for gate tile
	LDA PRG063_AttrGateMask,X
	STA <Temp_Var5
	
	LDX <Temp_Var3	; X = relative low offset into attribute data
	
	; Push attribute update 
	LDA Pattern_AttrBuffer,X
	AND <Temp_Var5					; Mask for palette
	ORA Level_BossGateAttrBytes,Y
	STA Graphics_Buffer+$0D	
	STA Pattern_AttrBuffer,X
	
	; Terminator in graphics buffer
	LDA #$FF
	STA Graphics_Buffer+$0E
	
	STA <CommitGBuf_Flag

PRG063_E708:

	; Update
	LDA #$00
	STA <DisFlag_NMIAndDisplay
	JSR PRG063_UpdateOneFrame

	INC <DisFlag_NMIAndDisplay
	
	INC <General_Counter
	LDA <General_Counter
	AND #$03
	BNE PRG063_E708

	INY	; Y++ (next part of the gate)
	DEC <Temp_Var2	; Temp_Var2-- (one less gate tile)
	BEQ PRG063_E750	; If Temp_Var2 = 0, jump to PRG063_E750 (RTS)
	
	; Finished updating gate tile...

	; Adjust for next gate tile going upward
	LDA Graphics_Buffer+$01
	SUB #$40
	STA Graphics_Buffer+$01
	ORA #$20
	STA Graphics_Buffer+$06
	LDA Graphics_Buffer+$00
	SBC #$00
	STA Graphics_Buffer+$00
	STA Graphics_Buffer+$05
	
	LDA <Temp_Var4
	EOR #$02
	STA <Temp_Var4
	
	CMP #$03
	BNE PRG063_E6CF

	LDA <Temp_Var3
	SUB #$08
	STA <Temp_Var3
	
	ORA #$C0
	STA Graphics_Buffer+$0B
	JMP PRG063_E6CF


PRG063_E750:
	RTS	; $E750


PRG063_DoBossGateClose:
	; Set bank 32 - 52
	LDA <TileMap_Index
	ORA #32
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

	; Top of gate upper right address
	LDA Level_BossGateCBaseVADDR
	STA Graphics_Buffer+$00	; $E75D
	STA Graphics_Buffer+$04	; $E760
	
	; Top of gate lower right address
	LDA Level_BossGateCBaseVADDR+1
	STA Graphics_Buffer+$01
	ORA #$20
	STA Graphics_Buffer+$05
	
	; 1 patterns to substitute per gate tile (only doing right half)
	LDA #$00
	STA Graphics_Buffer+$02
	STA Graphics_Buffer+$06
	
	; General_Counter = 0
	STA <General_Counter
	
	; Attribute VRAM ADDR high $23x
	LDA #$23
	STA Graphics_Buffer+$08
	
	; Attribute VRAM ADDR low
	LDA Level_BossGateCBaseAttrVADDRL
	STA <Temp_Var3
	ORA #$C0
	STA Graphics_Buffer+$09
	
	; Attr mask select
	LDA Level_BossGateCBaseAttrMask
	STA <Temp_Var4
	
	; Single attribute byte to change
	LDA #$00
	STA Graphics_Buffer+$0A
	
	; Boss gate tick sound
	LDA #SFX_BOSSGATEOPEN
	JSR PRG063_QueueMusSnd

	; Temp_Var2 = 4 (number of gate replacement tile loops)
	LDA #$04
	STA <Temp_Var2
	
	LDY #$00	; Y = 0
PRG063_E79C:
	LDX Level_BossGateCReplaceTiles,Y
	
	; Tile to replace as gate opens
	LDA TileLayout_Patterns+$0100,X
	STA Graphics_Buffer+$03
	LDA TileLayout_Patterns+$0300,X
	STA Graphics_Buffer+$07
	
	; Replace attribute mask select (expected 0 to 3)
	LDX <Temp_Var4
	
	; Mask for attribute used for gate tile
	LDA PRG063_AttrGateMask,X
	STA <Temp_Var5
	
	LDX <Temp_Var3	; X = relative low offset into attribute data
	
	; Push attribute update 
	LDA Pattern_AttrBuffer,X
	AND <Temp_Var5					; Mask for palette
	ORA Level_BossGateCAttrBytes,Y
	STA Graphics_Buffer+$0B	
	STA Pattern_AttrBuffer,X
	
	; Terminator in graphics buffer
	LDA #$FF
	STA Graphics_Buffer+$0C
	
	STA <CommitGBuf_Flag

PRG063_E7C9:
	; Update
	LDA #$00
	STA <DisFlag_NMIAndDisplay
	JSR PRG063_UpdateOneFrame

	INC <DisFlag_NMIAndDisplay
	INC <General_Counter
	LDA <General_Counter
	AND #$03
	BNE PRG063_E7C9

	INY	; Y++ (next part of the gate)
	DEC <Temp_Var2	; Temp_Var2-- (one less gate tile)
	BEQ PRG063_E80F	; If Temp_Var2 = 0, jump to PRG063_E80F (RTS)

	; Finished updating gate tile...

	; Adjust for next gate tile going upward
	LDA Graphics_Buffer+$01
	ADD #$40
	STA Graphics_Buffer+$01
	ORA #$20
	STA Graphics_Buffer+$05
	LDA Graphics_Buffer+$00
	ADC #$00
	STA Graphics_Buffer+$00
	STA Graphics_Buffer+$04
	LDA <Temp_Var4
	EOR #$02
	STA <Temp_Var4
	BNE PRG063_E79C

	LDA <Temp_Var3
	ADD #$08
	STA <Temp_Var3
	ORA #$C0
	STA Graphics_Buffer+$09
	JMP PRG063_E79C


PRG063_E80F:
	RTS	; $E80F


PRG063_AttrGateMask:
	.byte %11111100		; 0
	.byte %11110011		; 1
	.byte %11001111		; 2
	.byte %00111111		; 3


	; CHECKME - UNUSED?
	.byte $00, $81, $82, $00, $00, $00, $00, $01, $00, $10, $02, $08, $90, $01, $02, $45	; $E814 - $E823
	.byte $00, $00, $00, $A0, $20, $00, $20, $00, $80, $04, $08, $20, $A0, $81, $0A, $02	; $E824 - $E833
	.byte $00, $4D, $08, $A4, $00, $0A, $0A, $01, $00, $54, $00, $04, $00, $81, $02, $8A	; $E834 - $E843
	.byte $20, $00, $20, $60, $20, $44, $20, $00, $00, $08, $88, $18, $00, $04, $02, $08	; $E844 - $E853
	.byte $00, $80, $00, $11, $00, $80, $00, $80, $00, $20, $02, $C0, $00, $00, $00, $31	; $E854 - $E863
	.byte $00, $00, $00, $80, $80, $20, $20, $00, $A8, $10, $00, $20, $00, $00, $00, $0C	; $E864 - $E873
	.byte $00, $00, $08, $80, $2A, $21, $00, $80, $20, $24, $00, $60, $80, $01, $00, $00	; $E874 - $E883
	.byte $08, $00, $20, $01, $00, $02, $00, $11, $00, $00, $20, $01, $80, $00, $00, $08	; $E884 - $E893
	.byte $20, $04, $00, $00, $88, $20, $00, $94, $00, $28, $00, $80, $20, $00, $00, $00	; $E894 - $E8A3
	.byte $00, $36, $00, $08, $08, $01, $08, $80, $0A, $A4, $00, $00, $00, $09, $20, $22	; $E8A4 - $E8B3
	.byte $08, $01, $02, $82, $28, $50, $00, $01, $88, $80, $80, $0C, $02, $00, $00, $84	; $E8B4 - $E8C3
	.byte $28, $08, $80, $80, $00, $24, $02, $50, $80, $10, $20, $02, $08, $88, $20, $05	; $E8C4 - $E8D3
	.byte $02, $88, $00, $1A, $00, $02, $08, $21, $00, $11, $00, $80, $00, $00, $00, $80	; $E8D4 - $E8E3
	.byte $02, $A0, $00, $00, $20, $1C, $00, $11, $02, $1A, $00, $80, $00, $04, $88, $02	; $E8E4 - $E8F3
	.byte $00, $24, $28, $90, $22, $08, $20, $80, $08, $04, $A8, $01, $00, $08, $22, $01	; $E8F4 - $E903
	.byte $00, $30, $00, $10, $20, $20, $08, $00, $08, $21, $00, $00, $00, $04, $00, $00	; $E904 - $E913
	.byte $00, $80, $00, $1A, $00, $42, $00, $08, $80, $00, $00, $0C, $02, $00, $02, $00	; $E914 - $E923
	.byte $02, $34, $00, $10, $02, $00, $00, $01, $08, $80, $00, $10, $00, $00, $00, $9A	; $E924 - $E933
	.byte $80, $02, $0A, $30, $00, $00, $02, $A8, $00, $11, $00, $3D, $00, $10, $00, $04	; $E934 - $E943
	.byte $08, $00, $00, $10, $00, $3C, $00, $00, $80, $60, $02, $00, $20, $04, $00, $08	; $E944 - $E953
	.byte $08, $00, $00, $00, $A0, $00, $00, $02, $00, $14, $08, $60, $00, $00, $00, $40	; $E954 - $E963
	.byte $02, $01, $08, $90, $00, $24, $00, $0C, $00, $22, $88, $20, $02, $00, $00, $23	; $E964 - $E973
	.byte $00, $00, $20, $08, $00, $02, $00, $02, $00, $51, $00, $AD, $20, $10, $00, $04	; $E974 - $E983
	.byte $00, $01, $08, $84, $00, $40, $A8, $92, $00, $01, $00, $08, $00, $01, $0A, $00	; $E984 - $E993
	.byte $80, $1A, $08, $80, $02, $80, $80, $81, $00, $00, $80, $40, $00, $58, $00, $00	; $E994 - $E9A3
	.byte $00, $00, $02, $CA, $00, $00, $00, $48, $00, $06, $20, $04, $80, $05, $00, $02	; $E9A4 - $E9B3
	.byte $88, $88, $00, $03, $00, $C2, $00, $00, $08, $00, $02, $48, $00, $10, $00, $01	; $E9B4 - $E9C3
	.byte $00, $01, $00, $B0, $02, $00, $00, $04, $20, $00, $00, $00, $A0, $2C, $00, $01	; $E9C4 - $E9D3
	.byte $80, $A1, $00, $21, $00, $00, $80, $20, $08, $04, $02, $C5, $80, $24, $88, $40	; $E9D4 - $E9E3
	.byte $20, $25, $08, $04, $00, $20, $02, $05, $80, $00, $20, $50, $80, $80, $02, $03	; $E9E4 - $E9F3
	.byte $20, $A3, $80, $40, $82, $67, $02, $30, $00, $90, $00, $20, $00, $00, $00, $00	; $E9F4 - $EA03
	.byte $02, $00, $20, $00, $00, $00, $28, $00, $00, $00, $00, $20, $08, $00, $00, $00	; $EA04 - $EA13
	.byte $08, $00, $00, $05, $02, $00, $02, $88, $02, $82, $00, $82, $02, $14, $00, $20	; $EA14 - $EA23
	.byte $22, $10, $A0, $15, $00, $20, $20, $41, $00, $02, $08, $43, $00, $00, $00, $09	; $EA24 - $EA33
	.byte $00, $00, $08, $00, $00, $01, $08, $00, $88, $01, $00, $22, $00, $00, $00, $10	; $EA34 - $EA43
	.byte $20, $40, $00, $24, $28, $80, $00, $90, $00, $13, $00, $80, $00, $00, $08, $61	; $EA44 - $EA53
	.byte $80, $22, $00, $00, $00, $80, $00, $49, $00, $0C, $00, $40, $00, $04, $A2, $00	; $EA54 - $EA63
	.byte $00, $04, $02, $01, $02, $20, $02, $40, $00, $80, $00, $01, $00, $04, $00, $40	; $EA64 - $EA73
	.byte $80, $40, $00, $00, $02, $00, $08, $22, $00, $00, $00, $48, $02, $06, $00, $14	; $EA74 - $EA83
	.byte $00, $01, $A0, $04, $88, $01, $20, $00, $20, $28, $A2, $10, $00, $00, $00, $02	; $EA84 - $EA93
	.byte $A0, $00, $00, $10, $00, $00, $02, $10, $80, $58, $00, $40, $00, $09, $00, $22	; $EA94 - $EAA3
	.byte $00, $00, $00, $85, $00, $18, $20, $08, $00, $18, $00, $80, $00, $50, $28, $09	; $EAA4 - $EAB3
	.byte $00, $02, $00, $51, $0A, $00, $00, $CA, $00, $00, $88, $02, $00, $40, $2A, $10	; $EAB4 - $EAC3
	.byte $00, $00, $00, $0C, $20, $40, $00, $29, $22, $00, $00, $20, $00, $40, $82, $18	; $EAC4 - $EAD3
	.byte $00, $46, $A0, $10, $00, $10, $28, $28, $20, $00, $00, $01, $08, $01, $02, $01	; $EAD4 - $EAE3
	.byte $00, $03, $00, $04, $08, $00, $00, $10, $80, $00, $00, $10, $08, $01, $00, $40	; $EAE4 - $EAF3
	.byte $00, $02, $00, $A5, $00, $4A, $00, $01, $02, $40, $08, $00, $80, $04, $00, $17	; $EAF4 - $EB03
	.byte $20, $06, $0A, $00, $00, $10, $00, $00, $00, $44, $00, $80, $00, $00, $02, $30	; $EB04 - $EB13
	.byte $20, $00, $20, $48, $00, $0C, $00, $00, $00, $00, $00, $00, $00, $05, $00, $00	; $EB14 - $EB23
	.byte $40, $00, $80, $04, $00, $00, $00, $00, $02, $00, $02, $14, $00, $88, $00, $1C	; $EB24 - $EB33
	.byte $08, $18, $80, $80, $20, $00, $00, $08, $00, $41, $80, $20, $00, $04, $28, $08	; $EB34 - $EB43
	.byte $02, $10, $20, $00, $22, $25, $00, $02, $80, $25, $00, $81, $00, $00, $00, $00	; $EB44 - $EB53
	.byte $00, $40, $00, $0C, $0A, $20, $00, $00, $00, $00, $00, $00, $02, $2C, $80, $08	; $EB54 - $EB63
	.byte $00, $01, $20, $28, $00, $89, $00, $80, $20, $10, $00, $21, $20, $30, $20, $0B	; $EB64 - $EB73
	.byte $02, $11, $00, $64, $20, $82, $00, $00, $00, $80, $80, $08, $82, $10, $20, $80	; $EB74 - $EB83
	.byte $08, $00, $00, $20, $00, $00, $20, $00, $80, $08, $A0, $10, $00, $10, $00, $68	; $EB84 - $EB93
	.byte $00, $00, $00, $01, $00, $02, $80, $02, $00, $00, $80, $01, $80, $0C, $08, $00	; $EB94 - $EBA3
	.byte $A0, $82, $00, $08, $00, $04, $20, $00, $00, $20, $02, $10, $00, $10, $20, $01	; $EBA4 - $EBB3
	.byte $08, $09, $00, $40, $80, $02, $20, $20, $00, $00, $00, $22, $00, $42, $08, $22	; $EBB4 - $EBC3
	.byte $00, $00, $08, $02, $00, $00, $08, $04, $00, $20, $00, $80, $00, $00, $0A, $10	; $EBC4 - $EBD3
	.byte $00, $20, $00, $00, $22, $0C, $00, $20, $08, $42, $A0, $0D, $88, $01, $02, $20	; $EBD4 - $EBE3
	.byte $20, $10, $20, $40, $00, $00, $00, $04, $00, $00, $80, $00, $0A, $18, $08, $80	; $EBE4 - $EBF3
	.byte $08, $40, $00, $02, $00, $00, $02, $10, $00, $24, $00, $20, $BE, $15, $DC, $30	; $EBF4 - $EC03
	.byte $01, $00, $DD, $10, $27, $40, $AC, $14, $22, $01, $48, $40, $21, $41, $34, $40	; $EC04 - $EC13
	.byte $62, $00, $11, $10, $05, $10, $0B, $04, $0D, $41, $08, $15, $C0, $01, $22, $54	; $EC14 - $EC23
	.byte $8A, $54, $48, $01, $19, $50, $B3, $14, $08, $11, $A0, $04, $90, $06, $2D, $01	; $EC24 - $EC33
	.byte $A3, $10, $53, $0D, $88, $01, $31, $11, $84, $10, $40, $10, $40, $00, $C4, $51	; $EC34 - $EC43
	.byte $E8, $40, $30, $50, $41, $44, $84, $00, $50, $90, $CB, $11, $00, $04, $83, $00	; $EC44 - $EC53
	.byte $80, $B0, $04, $15, $04, $10, $15, $48, $04, $00, $00, $00, $9C, $04, $20, $14	; $EC54 - $EC63
	.byte $21, $41, $08, $14, $24, $41, $2E, $01, $0B, $54, $00, $00, $84, $14, $8A, $00	; $EC64 - $EC73
	.byte $05, $44, $24, $00, $21, $04, $0C, $51, $0A, $45, $08, $80, $0B, $11, $2D, $45	; $EC74 - $EC83
	.byte $8A, $50, $02, $54, $00, $00, $01, $54, $C2, $14, $C0, $00, $9C, $41, $5F, $42	; $EC84 - $EC93
	.byte $80, $40, $41, $00, $58, $05, $A2, $00, $87, $04, $DB, $10, $D0, $50, $C3, $41	; $EC94 - $ECA3
	.byte $01, $04, $E4, $15, $C0, $00, $B0, $44, $88, $04, $3A, $10, $24, $00, $C4, $00	; $ECA4 - $ECB3
	.byte $18, $44, $81, $44, $A1, $01, $08, $10, $40, $04, $90, $01, $C9, $14, $52, $00	; $ECB4 - $ECC3
	.byte $17, $44, $00, $15, $7E, $01, $50, $05, $32, $01, $56, $01, $2C, $05, $08, $05	; $ECC4 - $ECD3
	.byte $3B, $00, $10, $44, $23, $04, $10, $01, $50, $00, $14, $10, $C3, $04, $04, $11	; $ECD4 - $ECE3
	.byte $6A, $E1, $09, $04, $08, $94, $56, $45, $00, $41, $08, $55, $0E, $41, $31, $44	; $ECE4 - $ECF3
	.byte $37, $80, $03, $54, $B4, $41, $0B, $44, $00, $00, $04, $40, $90, $44, $93, $55	; $ECF4 - $ED03
	.byte $2D, $05, $C3, $00, $EA, $40, $05, $44, $18, $44, $9C, $14, $86, $05, $EA, $50	; $ED04 - $ED13
	.byte $96, $10, $81, $00, $9E, $14, $88, $00, $54, $10, $2D, $04, $82, $21, $5C, $05	; $ED14 - $ED23
	.byte $2F, $00, $9B, $41, $65, $00, $9E, $04, $62, $01, $C7, $80, $23, $00, $61, $01	; $ED24 - $ED33
	.byte $EB, $04, $1A, $01, $18, $00, $00, $00, $F4, $10, $88, $14, $F2, $54, $DF, $01	; $ED34 - $ED43
	.byte $6E, $11, $55, $05, $02, $14, $82, $51, $B2, $40, $05, $45, $66, $48, $2F, $50	; $ED44 - $ED53
	.byte $00, $00, $1C, $04, $28, $00, $40, $00, $11, $01, $18, $41, $06, $54, $3A, $44	; $ED54 - $ED63
	.byte $0C, $41, $BC, $05, $3A, $00, $82, $11, $C4, $11, $63, $34, $A3, $90, $27, $11	; $ED64 - $ED73
	.byte $82, $10, $B0, $50, $46, $41, $81, $14, $93, $54, $9F, $41, $BA, $44, $98, $04	; $ED74 - $ED83
	.byte $03, $05, $BC, $10, $20, $44, $03, $40, $05, $00, $60, $0D, $99, $04, $C8, $10	; $ED84 - $ED93
	.byte $08, $44, $2C, $00, $01, $41, $48, $51, $00, $00, $40, $40, $E4, $15, $20, $50	; $ED94 - $EDA3
	.byte $2C, $04, $67, $04, $98, $45, $CA, $04, $65, $14, $1A, $51, $14, $40, $E6, $50	; $EDA4 - $EDB3
	.byte $B2, $10, $DC, $04, $00, $00, $20, $54, $10, $05, $80, $10, $ED, $14, $36, $01	; $EDB4 - $EDC3
	.byte $8C, $10, $46, $04, $14, $D4, $28, $40, $20, $11, $84, $45, $35, $14, $79, $05	; $EDC4 - $EDD3
	.byte $6A, $00, $06, $00, $A0, $00, $09, $11, $04, $00, $64, $50, $21, $15, $82, $01	; $EDD4 - $EDE3
	.byte $0B, $50, $CC, $10, $42, $51, $4D, $54, $F8, $15, $11, $10, $A2, $14, $C5, $44	; $EDE4 - $EDF3
	.byte $03, $48, $14, $11, $00, $14, $48, $00, $C8, $00, $18, $14, $12, $54, $21, $01	; $EDF4 - $EE03
	.byte $25, $90, $94, $15, $6E, $00, $E3, $10, $00, $40, $20, $44, $11, $10, $41, $41	; $EE04 - $EE13
	.byte $A4, $41, $21, $10, $3A, $05, $02, $00, $2C, $00, $14, $41, $31, $44, $FB, $41	; $EE14 - $EE23
	.byte $6E, $40, $34, $00, $87, $05, $13, $00, $24, $10, $23, $00, $49, $45, $44, $70	; $EE24 - $EE33
	.byte $04, $40, $23, $10, $84, $05, $60, $10, $88, $44, $46, $00, $0D, $51, $1B, $65	; $EE34 - $EE43
	.byte $0B, $45, $02, $40, $E0, $40, $A6, $04, $21, $01, $01, $40, $12, $41, $4D, $01	; $EE44 - $EE53
	.byte $22, $10, $10, $01, $22, $40, $28, $00, $10, $04, $8D, $C0, $C4, $51, $05, $11	; $EE54 - $EE63
	.byte $63, $09, $20, $00, $63, $40, $84, $00, $44, $01, $0A, $51, $80, $01, $C4, $01	; $EE64 - $EE73
	.byte $68, $01, $00, $50, $06, $11, $00, $16, $80, $40, $04, $44, $C0, $55, $A1, $58	; $EE74 - $EE83
	.byte $63, $55, $7C, $40, $DE, $40, $5D, $81, $82, $50, $A6, $10, $AC, $00, $05, $01	; $EE84 - $EE93
	.byte $A2, $40, $80, $04, $80, $01, $02, $04, $03, $55, $0A, $40, $DF, $40, $C1, $61	; $EE94 - $EEA3
	.byte $30, $51, $9A, $01, $05, $41, $9B, $00, $71, $51, $45, $17, $A0, $04, $1B, $40	; $EEA4 - $EEB3
	.byte $92, $24, $31, $10, $A2, $00, $6A, $01, $08, $00, $0A, $41, $15, $70, $5A, $14	; $EEB4 - $EEC3
	.byte $9C, $05, $88, $14, $E4, $41, $AD, $14, $30, $40, $61, $84, $06, $81, $8C, $40	; $EEC4 - $EED3
	.byte $A5, $14, $10, $44, $C1, $04, $35, $04, $00, $00, $08, $01, $BF, $50, $00, $41	; $EED4 - $EEE3
	.byte $32, $00, $18, $01, $36, $05, $EA, $04, $A1, $15, $94, $18, $30, $50, $34, $52	; $EEE4 - $EEF3
	.byte $70, $04, $81, $00, $90, $44, $1D, $C0, $10, $80, $84, $00, $99, $00, $A2, $95	; $EEF4 - $EF03
	.byte $2C, $54, $0B, $45, $27, $20, $84, $00, $53, $14, $0E, $15, $83, $50, $C4, $00	; $EF04 - $EF13
	.byte $A0, $00, $8A, $04, $D4, $10, $05, $05, $06, $00, $02, $54, $3D, $40, $14, $45	; $EF14 - $EF23
	.byte $3B, $11, $C2, $05, $62, $05, $D4, $40, $A1, $11, $3B, $00, $73, $00, $96, $40	; $EF24 - $EF33
	.byte $06, $04, $0D, $11, $A0, $11, $21, $51, $80, $04, $05, $41, $A6, $10, $B4, $40	; $EF34 - $EF43
	.byte $06, $21, $E6, $00, $C5, $40, $98, $10, $40, $50, $45, $41, $E0, $54, $71, $05	; $EF44 - $EF53
	.byte $A8, $44, $08, $44, $2C, $00, $84, $40, $24, $40, $12, $00, $76, $55, $48, $94	; $EF54 - $EF63
	.byte $3A, $41, $F8, $00, $D0, $81, $18, $80, $F2, $41, $FC, $A3, $11, $05, $60, $05	; $EF64 - $EF73
	.byte $00, $00, $80, $44, $32, $90, $3E, $12, $00, $03, $50, $40, $06, $15, $2B, $51	; $EF74 - $EF83
	.byte $12, $54, $09, $55, $88, $14, $25, $00, $00, $04, $D5, $14, $C2, $04, $19, $40	; $EF84 - $EF93
	.byte $C4, $04, $40, $01, $15, $00, $E0, $05, $1A, $11, $0A, $40, $00, $10, $98, $45	; $EF94 - $EFA3
	.byte $98, $40, $A2, $45, $22, $11, $21, $31, $6F, $41, $40, $54, $77, $10, $2B, $01	; $EFA4 - $EFB3
	.byte $06, $50, $4A, $55, $22, $00, $18, $00, $49, $14, $C0, $00, $DC, $01, $8B, $45	; $EFB4 - $EFC3
	.byte $0B, $40, $10, $44, $05, $04, $62, $0C, $56, $49, $E5, $40, $09, $40, $40, $01	; $EFC4 - $EFD3
	.byte $71, $54, $00, $00, $80, $51, $C2, $40, $08, $C0, $2D, $04, $A6, $50, $BC, $41	; $EFD4 - $EFE3
	.byte $FE, $51, $32, $01, $45, $11, $80, $40, $04, $00, $0B, $14, $08, $55, $01, $00	; $EFE4 - $EFF3
	.byte $1B, $54, $3C, $01, $42, $04, $85, $40, $E7, $00, $23, $40	; $EFF4 - $EFFF



PRG063_DoObjHorzMovement_ToR:
	; Object facing right
	
	; Set hflip
	LDA Spr_Flags+$00,X
	ORA #SPR_HFLIP
	STA Spr_Flags+$00,X
	
	CPX #$00
	BNE PRG063_F016	; If this is not the Player, jump to PRG063_F016

	; Player only...

	; Player X -> Temp_Var2
	LDA Spr_X+$00
	STA <Temp_Var2
	
	; Player Spr_XHi -> Temp_Var3
	LDA Spr_XHi+$00
	STA <Temp_Var3

PRG063_F016:
	JSR PRG063_ApplyXVelocity

	CPX #$00
	BNE PRG063_F032	; If this is not the Player, jump to PRG063_F032

	; Player only...

	JSR PRG063_ObjDetCarryIfHit
	BCC PRG063_F032	; If Player is not touching this, jump to PRG063_F032

	JSR PRG063_F8F9	; $F022

	JSR PRG063_F02A	; $F025

	SEC	; $F028
	RTS	; $F029


PRG063_F02A:
	BCC PRG063_F032	; $F02A

	BEQ PRG063_F032	; $F02C

	INY	; $F02E
	JMP PRG063_F079	; $F02F


PRG063_F032:
	JSR PRG062_ObjDetWallAttrs

	CLC	; Clear carry (if didn't hit wall)
	
	LDA <Temp_Var16
	AND #TILEATTR_SOLID
	BEQ PRG063_F048	; If didn't hit wall, jump to PRG063_F048 (RTS)

	CPX #$00
	BNE PRG063_F044	; If not Player object, jump to PRG063_F044

	; Set Player_HitWallR_Flag
	LDA <Level_TileAttrsDetected+$00
	STA <Player_HitWallR_Flag

PRG063_F044:

	; "Pop" out of wall that's to the right
	JSR PRG062_WallR_PopOut

	SEC	; Set carry (hit wall)

PRG063_F048:
	RTS	; $F048


PRG063_DoObjHorzMovement_ToL:
	; Object facing left
	
	; Set hflip
	LDA Spr_Flags+$00,X
	AND #~SPR_HFLIP
	STA Spr_Flags+$00,X
	
	CPX #$00
	BNE PRG063_F05F	; If not Player object, jump to PRG063_F05F

	; Player only...

	; Player X -> Temp_Var2
	LDA Spr_X+$00
	STA <Temp_Var2
	
	; Player Spr_XHi -> Temp_Var3
	LDA Spr_XHi+$00
	STA <Temp_Var3

PRG063_F05F:
	JSR PRG063_ApplyXVelocityRev	; $F05F

	CPX #$00
	BNE PRG063_F079	; If not Player object, jump to PRG063_F079

	; Player only...

	JSR PRG063_ObjDetCarryIfHit
	BCC PRG063_F079	; If Player is not touching this, jump to PRG063_F079

	JSR PRG063_F90D	; $F06B

	JSR PRG063_F073	; $F06E

	SEC	; $F071
	RTS	; $F072


PRG063_F073:
	BCS PRG063_F079	; $F073

	DEY	; $F075
	JMP PRG063_F032	; $F076


PRG063_F079:
	JSR PRG062_ObjDetWallAttrs
	
	CLC	; Clear carry (if didn't hit wall)
	
	LDA <Temp_Var16
	AND #TILEATTR_SOLID
	BEQ PRG063_F087	; If didn't hit wall, jump to PRG063_F087 (RTS)

	; "Pop" out of wall that's to the left
	JSR PRG062_WallL_PopOut

	SEC	; Set carry (hit wall)

PRG063_F087:
	RTS	; $F087


PRG063_ObjMoveVert_HitFloor:
	; Object facing down...

	CPX #$00
	BNE PRG063_F096	; If this is not the Player, jump to PRG063_F096

	; Player only...

	; Player Y -> Temp_Var2
	LDA Spr_Y+$00
	STA <Temp_Var2
	
	; Player Spr_XHi -> Temp_Var3
	LDA Spr_XHi+$00
	STA <Temp_Var3

PRG063_F096:
	JSR PRG063_ApplyYVelRev_BottomCutoff	; Apply Y velocity

	CPX #$00	; $F099
	BNE PRG063_F0B2	; $F09B

	JSR PRG063_PlayerObjectHitTest	; $F09D

	BCC PRG063_F0B2	; $F0A0

	; CHECKME - UNUSED?
	JSR PRG063_CalcObjectRelYDiffRev
	JSR PRG063_F0AA
	SEC
	RTS

PRG063_F0AA:	
	BCC PRG063_F0B2
	BEQ PRG063_F0B2
	INY
	JMP PRG063_F0E9


PRG063_F0B2:
	JSR PRG062_ObjDetFloorAttrs	; $F0B2

	CLC	; $F0B5
	LDA <Temp_Var16		; almagamation result from PRG062_ObjDetFloorAttrs
	AND #TILEATTR_SOLID
	BEQ PRG063_F0C0	; $F0BA

	JSR PRG062_ObjOffsetYToTileTop	; $F0BC

	SEC	; $F0BF

PRG063_F0C0:
	RTS	; $F0C0


PRG063_DoObjVertMoveUpOnly:
	CPX #$00	; $F0C1
	BNE PRG063_F0CF	; $F0C3

	; Player only...

	; Player Y -> Temp_Var2
	LDA Spr_Y+$00
	STA <Temp_Var2
	
	; Player Spr_XHi -> Temp_Var3
	LDA Spr_XHi+$00
	STA <Temp_Var3

PRG063_F0CF:
	JSR PRG063_ApplyYVel_TopCutoff2	; $F0CF

	CPX #$00	; $F0D2
	BNE PRG063_F0E9	; $F0D4

	JSR PRG063_PlayerObjectHitTest	; $F0D6

	BCC PRG063_F0E9	; $F0D9

	; CHECKME - UNUSED?

	JSR PRG063_CalcObjectRelYDiff
	JSR PRG063_F0E3
	SEC
	RTS

PRG063_F0E3:
	BCS PRG063_F0E9
	DEY
	JMP PRG063_F0B2


PRG063_F0E9:
	JSR PRG062_ObjDetFloorAttrs

	CLC
	LDA <Temp_Var16		; almagamation result from PRG062_ObjDetFloorAttrs
	AND #TILEATTR_SOLID
	BEQ PRG063_F0F7	; If not specifically solid, jump to PRG063_F0F7 (RTS)

	JSR PRG062_ObjOffsetYToTileTopRev

	SEC	; $F0F6

PRG063_F0F7:
	RTS	; $F0F7


	; Does vertical object movement, including interaction with things that disturb
	; that movement like water, Pharaoh Man's quicksand, etc.
PRG063_DoObjVertMovement:
	CPX #$00
	BNE PRG063_F174	; If this is not the Player, jump to PRG063_F174

	; Player only...

	; Spr_Var4 = 0
	STX Spr_Var4+$00
	
	; Backup 'Y' value
	TYA
	PHA	

	; Detect floors
	LDY #$02	; Y = 2 (index into PRG062_TDetFloorOffSpread)
	JSR PRG062_ObjDetFloorAttrs

	LDA <Level_TileAttr_GreatestDet
	CMP <Player_LastTileAttr
	BEQ PRG063_F152	; If Player hasn't changed environment, jump to PRG063_F152

	CMP #TILEATTR_WATER
	BNE PRG063_F116	; If Player did not encounter water, jump to PRG063_F116

	; Player has encountered water...

	LDA <Player_LastTileAttr
	BNE PRG063_F152	; If Player detected something else (?) previously, jump to PRG063_F152

	BEQ PRG063_F120	; Otherwise, jump to PRG063_F120 (water splash)


PRG063_F116:
	LDA <Player_LastTileAttr
	CMP #TILEATTR_WATER
	BNE PRG063_F152	; If Player was not previously in water, jump to PRG063_F152

	LDA <Level_TileAttr_GreatestDet
	BNE PRG063_F152	; If Player hasn't left water (i.e. we only detected air / $00), jump to PRG063_F152

	; Player has left water and is now in open air...

PRG063_F120:
	LDA Spr_SlotID+$05
	BNE PRG063_F152		; If something is in sprite slot 5, jump to PRG063_F152

	; Slot 5 is empty...

	; Water splash sound!
	LDA #SFX_WATERSPLASH
	JSR PRG063_QueueMusSnd

	; Copy Player's sprite data into slot 5
	LDY #$05
	LDA #SPRANM2_WATERSPLASH
	JSR PRG063_CopySprSlotSetAnim

	LDA <Level_TileAttr_GreatestDet	; $F131
	CMP #TILEATTR_WATER	; $F133
	BEQ PRG063_F140	; $F135

	; Splash Y += 16
	LDA Spr_Y+$05
	ADD #16
	STA Spr_Y+$05

PRG063_F140:
	; Align splash to tile
	LDA Spr_Y+$05
	AND #$F0
	STA Spr_Y+$05
	STA Level_RasterYOff	; $F148
	
	LDA #SPRSLOTID_WATERSPLASH
	STA Spr_SlotID+$05
	BNE PRG063_F168	; Jump (technically always) to PRG063_F168


PRG063_F152:
	
	; Update Player_LastTileAttr
	LDA <Level_TileAttr_GreatestDet
	STA <Player_LastTileAttr
	
	CMP #TILEATTR_WATER
	BNE PRG063_F164	; If Player did not encounter water, jump to PRG063_F164

	LDA <Player_WaterPhysFudge
	BNE PRG063_F168	; If Player_WaterPhysFudge > 0, jump to PRG063_F168

	; Reset Player_WaterPhysFudge to 3

	; Player_WaterPhysFudge = 3
	LDA #$03
	STA <Player_WaterPhysFudge
	
	BNE PRG063_F168	; Jump (technically always) to PRG063_F168


PRG063_F164:
	; Player not in water

	; Player_WaterPhysFudge = 0
	LDA #$00
	STA <Player_WaterPhysFudge

PRG063_F168:

	; Restore 'Y' input
	PLA
	TAY
	
	; Spr_Y -> Temp_Var2
	LDA Spr_Y+$00
	STA <Temp_Var2
	
	; Spr_XHi -> Temp_Var3
	LDA Spr_XHi+$00
	STA <Temp_Var3

PRG063_F174:
	LDA Spr_YVel+$00,X
	BMI PRG063_F17C	; If Y velocity is negative, jump to PRG063_F17C
	
	; Y velocity >= 0

	JMP PRG063_F1FD	; Jump to PRG063_F1FD


PRG063_F17C:
	; Y velocity < 0 (object is "falling")

	JSR PRG063_ApplyYVel_BottomCutoff

	CPX #$00
	BNE PRG063_F1B0	; If this is not the Player, jump to PRG063_F1B0

	; Player only...

	JSR PRG063_PlayerObjectHitTest

	BCC PRG063_F1B0	; If no collision, jump to PRG063_F1B0

	LDY <Temp_Var1	; Object index
	
	LDA Spr_CurrentAnim+$00,Y		; (This seems like an ugly way to check, but oh well)
	CMP #SPRANM2_RUSHJET
	BNE PRG063_F194	; If Player didn't contact Rush Jet, jump to PRG063_F194

	INC Spr_Var4+$00	; Player riding Rush Jet

PRG063_F194:
	LDY <Temp_Var0	; Restore 'Y' from PRG063_PlayerObjectHitTest's backup
	
	JSR PRG063_CalcObjectRelYDiffRev

	JSR PRG063_F1A8	; $F199

	; Force Y velocity to $FE
	LDA #$00
	STA Spr_YVelFrac+$00,X
	LDA #$FE
	STA Spr_YVel+$00,X
	
	BNE PRG063_F1FB	; Jump (technically always) to PRG063_F1FB (set carry, return)


PRG063_F1A8:
	BCC PRG063_F1B0
	BEQ PRG063_F1B0

	INY	; Y++ (next tile detection spread index into PRG062_TDetFloorOffSpread)
	JMP PRG063_F0E9	; Jump to PRG063_F0E9 (loop around)


PRG063_F1B0:
	JSR PRG063_ObjApplyGravity

	JSR PRG062_ObjDetFloorAttrs

	LDA <Level_TileAttr_GreatestDet
	CMP #TILEATTR_LADDERTOP
	BNE PRG063_F1C4	; If this is not the top of a ladder, jump to PRG063_F1C4

	; Essentially this makes the top of a ladder only solid for the first half
	LDA <Temp_Var17	; Object offset Y (Spr_Y + Y offset from tile spread fed to PRG062_ObjDetFloorAttrs)
	AND #$0F		; Relative within tile
	CMP #$08	
	BLT PRG063_F1F5	; If < 8 (upper half of ladder tope tile), jump to PRG063_F1F5 (treat as solid)


PRG063_F1C4:
	LDA <Temp_Var16		; The amalgamation of all attributes from PRG062_ObjDetFloorAttrs
	AND #TILEATTR_SOLID
	BNE PRG063_F1F5		; If solid floor not detected, jump to PRG063_F1F5

	CPX #$00
	BNE PRG063_F22B	; If this is not the Player, jump to PRG063_F22B

	; Player only...

	LDA <TileMap_Index
	CMP #TMAP_PHARAOHMAN
	BNE PRG063_F22B		; If this is not Pharaoh Man, jump to PRG063_F22B

	LDA <Level_TileAttr_GreatestDet
	CMP #TILEATTR_QUICKSAND_SNOW
	BNE PRG063_F22B		; If this is not Pharaoh Man's quicksand, jump to PRG063_F22B

	; Pharaoh Man's quicksand...

	; Slightly lower movement speed than usual
	LDA <Player_HCurSpeedFrac
	SUB #$80
	STA Spr_XVelFrac+$00
	LDA <Player_HCurSpeed
	SBC #$00
	STA Spr_XVel+$00
	
	; Sink velocity
	LDA #$DE
	STA Spr_YVelFrac+$00
	LDA #$FF
	STA Spr_YVel+$00
	
	BNE PRG063_F1FB	; Jump (technically always) to PRG063_F1FB


PRG063_F1F5:
	JSR PRG062_ObjOffsetYToTileTop
	JSR PRG063_SetObjYVelToMinus1


PRG063_F1FB:
	SEC	; Set carry
	RTS	; $F1FC


PRG063_F1FD:
	; Y velocity >= 0 (object is "rising")

	INY	; Y++
	JSR PRG063_ApplyYVel_TopCutoff

	CPX #$00
	BNE PRG063_F219	; If this is not the player object, jump to PRG063_F219

	; Player object only...

	JSR PRG063_PlayerObjectHitTest	; Collision test against object

	BCC PRG063_F219	; If no collision, jump to PRG063_F219

	JSR PRG063_CalcObjectRelYDiff	; Calculate Player Y difference

	JSR PRG063_F213	; $F20D

	JMP PRG063_F228	; $F210


PRG063_F213:
	BCS PRG063_F219	; If carry from Player Y, object Y diff, jump to PRG063_F219

	DEY	; Y--
	JMP PRG063_F0B2	; Jump to PRG063_F0B2


PRG063_F219:
	JSR PRG063_ObjApplyGravity

	JSR PRG062_ObjDetFloorAttrs	; $F21C

	LDA <Temp_Var16
	AND #TILEATTR_SOLID
	BEQ PRG063_F22B	

	JSR PRG062_ObjOffsetYToTileTopRev	; $F225


PRG063_F228:
	JSR PRG063_SetObjYVelToMinus1	; $F228


PRG063_F22B:
	CLC	; Clear carry (no solid floor)
	RTS	


PRG063_ApplyXVelocity:

	; Apply X velocity with fractional component
	LDA Spr_XVelFracAccum+$00,X
	ADD Spr_XVelFrac+$00,X
	STA Spr_XVelFracAccum+$00,X
	LDA Spr_X+$00,X
	ADC Spr_XVel+$00,X
	STA Spr_X+$00,X
	BCC PRG063_F24A

	LDA Spr_XHi+$00,X
	ADC #$00
	STA Spr_XHi+$00,X

PRG063_F24A:
	RTS	; $F24A


PRG063_ApplyXVelocityRev:

	; Apply X velocity with fractional component
	LDA Spr_XVelFracAccum+$00,X
	SUB Spr_XVelFrac+$00,X
	STA Spr_XVelFracAccum+$00,X
	LDA Spr_X+$00,X
	SBC Spr_XVel+$00,X
	STA Spr_X+$00,X
	BCS PRG063_F268

	LDA Spr_XHi+$00,X
	SBC #$00
	STA Spr_XHi+$00,X

PRG063_F268:
	RTS	; $F268


	; REVERSED version of PRG063_ApplyYVel_BottomCutoff
	; i.e. Y velocity direction is reversed (normally positive moves up, but in this case it moves down)
PRG063_ApplyYVelRev_BottomCutoff:
	
	; Apply Y velocity with fractional component
	LDA Spr_YVelFracAccum+$00,X
	ADD Spr_YVelFrac+$00,X
	STA Spr_YVelFracAccum+$00,X
	LDA Spr_Y+$00,X
	ADC Spr_YVel+$00,X
	STA Spr_Y+$00,X
	
	; 16 pixel limit
	CMP #$F0
	BLT PRG063_F288	; If sprite Y < $F0, jump to PRG063_F288 (RTS)

	; Too low, Spr_YHi = 1
	ADC #$0F
	STA Spr_Y+$00,X
	INC Spr_YHi+$00,X

PRG063_F288:
	RTS	; $F288


	; Applies Y Velocity to vertically move object, looking to see if they've crossed the upper vertical threshold of the screen
	; NOTE: Appears to be exactly identical PRG063_ApplyYVel_TopCutoff, but called in different places
PRG063_ApplyYVel_TopCutoff2:

	; Apply Y velocity with fractional component in reverse
	LDA Spr_YVelFracAccum+$00,X
	SUB Spr_YVelFrac+$00,X
	STA Spr_YVelFracAccum+$00,X
	LDA Spr_Y+$00,X
	SBC Spr_YVel+$00,X
	STA Spr_Y+$00,X
	
	BCS PRG063_F2A6	; If didn't go below zero, jump to PRG063_F2A6

	; Too high, Spr_YHi = -1
	SBC #$0F
	STA Spr_Y+$00,X
	DEC Spr_YHi+$00,X

PRG063_F2A6:
	RTS	; $F2A6



	; Simplified vertical movement which applies Y velocity, respects the vertical screen cut-off logic,
	; and applies gravity afterwards
PRG063_DoMoveSimpleVert:
	LDA Spr_YVel+$00,X
	BPL PRG063_F2B2

	JSR PRG063_ApplyYVel_BottomCutoff

	JMP PRG063_ObjApplyGravity


PRG063_F2B2:
	JSR PRG063_ApplyYVel_TopCutoff

	JMP PRG063_ObjApplyGravity


	; Applies Y Velocity to vertically move object, looking to see if they've crossed the lower vertical threshold of the screen
PRG063_ApplyYVel_BottomCutoff:

	; Apply Y velocity with fractional component
	LDA Spr_YVelFracAccum+$00,X
	SUB Spr_YVelFrac+$00,X
	STA Spr_YVelFracAccum+$00,X
	LDA Spr_Y+$00,X
	SBC Spr_YVel+$00,X
	STA Spr_Y+$00,X
	
	; 16 pixel height limit
	CMP #$F0
	BLT PRG063_F2D7

	; Too low, Spr_YHi = 1
	ADC #$0F
	STA Spr_Y+$00,X
	INC Spr_YHi+$00,X

PRG063_F2D7:
	RTS	; $F2D7


	; Applies Y Velocity to vertically move object, looking to see if they've crossed the upper vertical threshold of the screen
	; NOTE: Appears to be exactly identical PRG063_ApplyYVel_TopCutoff2, but called in different places
PRG063_ApplyYVel_TopCutoff:

	; Apply Y velocity with fractional component
	LDA Spr_YVelFracAccum+$00,X
	SUB Spr_YVelFrac+$00,X
	STA Spr_YVelFracAccum+$00,X
	LDA Spr_Y+$00,X
	SBC Spr_YVel+$00,X
	STA Spr_Y+$00,X
	BCS PRG063_F2F5

	; too high, Spr_YHi = -1
	SBC #$0F
	STA Spr_Y+$00,X
	DEC Spr_YHi+$00,X

PRG063_F2F5:
	RTS	; $F2F5


PRG063_ObjApplyGravity:
	LDA <Player_WaterPhysFudge
	BEQ PRG063_ObjApplyGravity_Cont	; If Player_WaterPhysFudge = 0, jump to PRG063_ObjApplyGravity_Cont

	CPX #$00
	BNE PRG063_ObjApplyGravity_Cont	; If this is not the Player, jump to PRG063_ObjApplyGravity_Cont

	; Decrement Player_WaterPhysFudge, if not zero, then do not adjust player's Y velocity (causes "floatiness" in water)
	DEC <Player_WaterPhysFudge
	BNE PRG063_F323		; Jump (technically always) to PRG063_F323 (RTS)


PRG063_ObjApplyGravity_Cont:

	; Apply Y velocity with fractional component in reverse
	LDA Spr_YVelFrac+$00,X
	SUB <Gravity
	STA Spr_YVelFrac+$00,X
	LDA Spr_YVel+$00,X
	SBC #$00
	STA Spr_YVel+$00,X
	BPL PRG063_F323

	CMP #$F9
	BGE PRG063_F323

	LDA #$F9
	STA Spr_YVel+$00,X
	LDA #$00
	STA Spr_YVelFrac+$00,X

PRG063_F323:
	RTS	; $F323


PRG063_SetObjYVelToMinus1:
	LDA #$00
	STA Spr_YVelFrac+$00,X
	LDA #$FF
	STA Spr_YVel+$00,X

PRG063_F32E:
	RTS	; $F32E


PRG063_MovePlayerWithObj:
	LDA <Player_State
	CMP #PLAYERSTATE_WIREADAPTER
	BEQ PRG063_F32E		; If Player state is rising by Wire Adapter, jump to PRG063_F32E (RTS)

	LDA Spr_FaceDir+$00,X
	BEQ PRG063_F32E	; If direction indeterminate, jump to PRG063_F32E (RTS)

	LDA Spr_XVelFrac+$00,X
	ORA Spr_XVel+$00,X
	BEQ PRG063_F3C0		; If object is not moving horizontally, jump to PRG063_F3C0 (RTS)

	LDA Spr_SlotID+$00,X
	CMP #SPRSLOTID_SUBBOSS_MOBY
	BEQ PRG063_F37C			; If slot ID = SPRSLOTID_SUBBOSS_MOBY, jump to PRG063_F37C

	JSR PRG063_CalcObjXDiffFromPlayer
	STA <Temp_Var0	; -> Temp_Var0
	
	LDA Spr_Flags2+$00,X
	AND #%00111111
	TAY	; Y = bounding box index
	
	LDA PRG063_ObjBoundBoxWidth,Y	; $F354
	SUB <Temp_Var0	; $F357
	CMP #$04	; $F35A
	BLT PRG063_F3C0	; $F35C

	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BEQ PRG063_F372	; $F363

	LDA Spr_XVelFracAccum+$00,X	; $F365
	SUB Spr_XVelFrac+$00,X	; $F368
	STA Spr_XVelFracAccum+$00	; $F36C
	JMP PRG063_F37C	; $F36F


PRG063_F372:
	LDA Spr_XVelFracAccum+$00,X	; $F372
	ADD Spr_XVelFrac+$00,X	; $F375
	STA Spr_XVelFracAccum+$00	; $F379

PRG063_F37C:
	STX <Temp_Var15	; Backup 'X' -> Temp_Var15
	
	; Backup Player's sprite flags / facing direction
	LDA Spr_Flags+$00
	PHA
	LDA Spr_FaceDir+$00
	PHA
	
	; Copy object's X velocity to Player
	LDA Spr_XVelFrac+$00,X
	STA Spr_XVelFrac+$00
	LDA Spr_XVel+$00,X
	STA Spr_XVel+$00
	
	; Copy object's facing direction to Player
	LDA Spr_FaceDir+$00,X
	STA Spr_FaceDir+$00	
	
	LDY #$00	; Y = 0 (if not sliding)
	
	LDA <Player_State
	CMP #PLAYERSTATE_SLIDING
	BNE PRG063_F3A2	; If Player is not sliding, jump to PRG063_F3A2

	LDY #$04	; Y = 4 (if sliding)

PRG063_F3A2:
	
	; Backup current pages
	LDA <MMC3_Page8000_Req
	PHA
	LDA <MMC3_PageA000_Req
	PHA
	
	LDX #$00	; X = 0 (Player object)
	JSR PRG063_DoObjMoveSetFaceDir	; Move Player at object's speed
	
	; Restore prior pages
	PLA
	STA <MMC3_PageA000_Req
	PLA
	STA <MMC3_Page8000_Req
	
	; Reset them
	JSR PRG063_SetPRGBanks

	; Restore Player's sprite flags / facing direction
	PLA
	STA Spr_FaceDir+$00
	PLA
	STA Spr_Flags+$00
	
	LDX <Temp_Var15	; Restore 'X'

PRG063_F3C0:
	RTS	; $F3C0


PRG063_PlayerHitFloorAlign:
	STX <Temp_Var15	; Backup 'X' -> Temp_Var15
	
	LDY #$00	; Y = 0 (if not sliding)
	
	LDA <Player_State
	CMP #PLAYERSTATE_SLIDING
	BNE PRG063_F3CD	; If Player is not sliding, jump to PRG063_F3CD

	LDY #$04	; Y = 4 (if sliding)

PRG063_F3CD:
	; Backup current pages
	LDA <MMC3_Page8000_Req
	PHA
	LDA <MMC3_PageA000_Req
	PHA
	
	LDX #$00	; X = 0 (Player object)
	JSR PRG062_ObjDetFloorAttrs	; $F3D5

	LDA <Temp_Var16
	AND #TILEATTR_SOLID
	BEQ PRG063_F3E1	; If Player didn't impact solid, jump to PRG063_F3E1

	JSR PRG062_ObjOffsetYToTileTop

PRG063_F3E1:
	; Restore prior pages
	PLA
	STA <MMC3_PageA000_Req
	PLA
	STA <MMC3_Page8000_Req

	; Reset them
	JSR PRG063_SetPRGBanks

	LDX <Temp_Var15	; Restore 'X'
	
	RTS	; $F3EC


	; Carry is cleared at start
	; Object must be going left/right and up/down as defined by Spr_FaceDir; a missing direction causes the subroutine to return early
	; Initialize 'Y' before calling this!
	; Y will be incremented if object is facing left
	; Y will be incremented if object is facing up
	;
	; If object is Player (X = 0), Temp_Var2 = Spr_Y  Temp_Var3 = Spr_XHi
PRG063_DoObjMoveSetFaceDir:
	CLC	; Clear carry
	
	LDA Spr_FaceDir+$00,X
	AND #(SPRDIR_LEFT | SPRDIR_RIGHT)
	BEQ PRG063_F445	; If left/right direction is not set, jump to PRG063_F445 (RTS)

	AND #SPRDIR_RIGHT
	BEQ PRG063_F3FC	; If direction is left, jump to PRG063_F3FC

	; Object facing right

	JMP PRG063_DoObjHorzMovement_ToR	; Jump to PRG063_DoObjHorzMovement_ToR


PRG063_F3FC:
	; Object facing left

	INY	; Y++ for facing left
	JMP PRG063_DoObjHorzMovement_ToL	; Jump to PRG063_DoObjHorzMovement_ToL


PRG063_DoMoveVertOnly:
	; Object facing right

	CLC	; Clear carry
	
	LDA Spr_FaceDir+$00,X
	AND #(SPRDIR_DOWN | SPRDIR_UP)
	BEQ PRG063_F445	; If up/down direction is not set, jump to PRG063_F445 (RTS)

	AND #SPRDIR_DOWN
	BEQ PRG063_F40F	; If object is direction set up, jump to PRG063_F40F

	; Object direction down...

	JMP PRG063_ObjMoveVert_HitFloor	; Jump to PRG063_ObjMoveVert_HitFloor


PRG063_F40F:
	; Object direction up

	INY	; Y++
	JMP PRG063_DoObjVertMoveUpOnly	; $F410

	; Simpler version of PRG063_DoObjMoveSetFaceDir
	; Sets/clears Spr_Flags SPR_HFLIP depending on left/right direction
	; Applies Y velocity "forward" if down or "reverse" if up
PRG063_ApplyVelSetFaceDir:
	LDA Spr_FaceDir+$00,X
	AND #(SPRDIR_LEFT | SPRDIR_RIGHT)
	BEQ PRG063_F445	; If left/right direction is not set, jump to PRG063_F445 (RTS)

	AND #SPRDIR_RIGHT
	BEQ PRG063_F429	; If direction is not right, jump to PRG063_F429

	; Direction is right...

	; Set HFlip
	LDA Spr_Flags+$00,X
	ORA #SPR_HFLIP
	STA Spr_Flags+$00,X
	
	JMP PRG063_ApplyXVelocity	; Jump to PRG063_ApplyXVelocity


PRG063_F429:
	; Direction is left

	; Clear HFlip
	LDA Spr_Flags+$00,X
	AND #~SPR_HFLIP
	STA Spr_Flags+$00,X
	
	JMP PRG063_ApplyXVelocityRev	; Jump to PRG063_ApplyXVelocityRev


PRG063_DoMoveVertOnlyH16:
	LDA Spr_FaceDir+$00,X
	AND #(SPRDIR_UP | SPRDIR_DOWN)
	BEQ PRG063_F445	; If up/down direction is not set, jump to PRG063_F445 (RTS)

	AND #SPRDIR_DOWN
	BEQ PRG063_F442	; If direction is up, jump to PRG063_F442

	; Direction is down...

	JMP PRG063_ApplyYVelRev_BottomCutoff	; Jump to PRG063_ApplyYVelRev_BottomCutoff


PRG063_F442:
	; Direction is up...

	JMP PRG063_ApplyYVel_TopCutoff2	; Jump to PRG063_ApplyYVel_TopCutoff2


PRG063_F445:
	RTS	; $F445


PRG063_SetSpriteAnim:
	STA Spr_CurrentAnim+$00,X

	LDA #$00
	STA Spr_Frame+$00,X
	STA Spr_AnimTicks+$00,X
	
	RTS	; $F451


PRG063_CopySprSlotSetAnim:
	PHA	; $F452
	LDA Spr_X+$00,X	; $F453
	STA Spr_X+$00,Y	; $F456
	LDA Spr_XHi+$00,X	; $F459
	STA Spr_XHi+$00,Y	; $F45C
	LDA Spr_Y+$00,X	; $F45F
	STA Spr_Y+$00,Y	; $F462
	LDA Spr_YHi+$00,X	; $F465
	STA Spr_YHi+$00,Y	; $F468

PRG063_F46B:
	LDA Spr_Flags+$00,X
	AND #SPR_HFLIP
	ORA #(SPRFL1_SCREENREL | SPRFL1_ONSCREEN)
	STA Spr_Flags+$00,Y
	
	LDA #$00	; $F475
	STA Spr_Var1+$00,Y	; $F477
	STA Spr_Var2+$00,Y	; $F47A
	STA Spr_Var3+$00,Y	; $F47D
	STA Spr_Var4+$00,Y	; $F480
	STA Spr_Var5+$00,Y	; $F483
	STA Spr_Var6+$00,Y	; $F486
	STA Spr_Var7+$00,Y	; $F489
	STA Spr_Var8+$00,Y	; $F48C
	
	PLA	; $F48F

PRG063_SetSpriteAnimY:
	STA Spr_CurrentAnim+$00,Y
	
	LDA #$00
	STA Spr_Frame+$00,Y
	STA Spr_AnimTicks+$00,Y
	
	RTS	; $F49B


	; 'A' = type of projectile (sprite animation)
	; 'X' = source object sprite slot firing the shot
	; 'Y' = target sprite slot where the projectile will be
	; Temp_Var16 = shot offset index
PRG063_InitProjectile:
	PHA	; Save 'A' (sprite animation)
	
	STX <Temp_Var0	; Backup X -> Temp_Var0
	
	LDX <Temp_Var16	; X = Temp_Var16
	
	; Copy projectile offsets -> Temp_Var1-4
	LDA PRG063_ProjXOffset,X
	STA <Temp_Var1
	LDA PRG063_ProjXHiOffset,X
	STA <Temp_Var2
	LDA PRG063_ProjYOffset,X
	STA <Temp_Var3
	LDA PRG063_ProjYHiOffset,X
	STA <Temp_Var4
	
	LDX <Temp_Var0	; X = sprite slot target
	
	; Projectile X position
	LDA Spr_X+$00,X
	ADD <Temp_Var1
	STA Spr_X+$00,Y
	LDA Spr_XHi+$00,X
	ADC <Temp_Var2
	STA Spr_XHi+$00,Y
	
	; Projectile Y position
	LDA Spr_Y+$00,X
	ADD <Temp_Var3
	STA Spr_Y+$00,Y
	LDA Spr_YHi+$00,X
	ADC <Temp_Var4
	STA Spr_YHi+$00,Y
	
	JMP PRG063_F46B	; Jump to PRG063_F46B (copy rest of data besides X/Y positions)


PRG063_SetObjFacePlayer:
	; Face right until proven incorrect...
	LDA #SPRDIR_RIGHT
	STA Spr_FaceDir+$00,X
	
	LDA Spr_X+$00,X
	SUB Spr_X+$00
	LDA Spr_XHi+$00,X
	SBC Spr_XHi+$00	
	BCC PRG063_F4F5	

	; Gotta face left!
	LDA #SPRDIR_LEFT
	STA Spr_FaceDir+$00,X

PRG063_F4F5:
	RTS	; $F4F5


PRG063_SetObjFlipForFaceDir:
	LDA Spr_FaceDir+$00,X
	ROR A
	ROR A
	ROR A
	AND #SPR_HFLIP
	STA <Temp_Var0	; Temp_Var0 holds appropriate sprite flip bit based on facing direction
	
	; Set HFLIP
	LDA Spr_Flags+$00,X
	AND #~SPR_HFLIP
	ORA <Temp_Var0
	STA Spr_Flags+$00,X
	
	RTS	; $F50A


PRG063_ProjXOffset:
	.byte $F1	; $00
	.byte $10	; $01
	.byte $00	; $02
	.byte $00	; $03
	.byte $0C	; $04
	.byte $14	; $05
	.byte $18	; $06
	.byte $18	; $07
	.byte $18	; $08
	.byte $14	; $09
	.byte $0C	; $0A
	.byte $10	; $0B
	.byte $10	; $0C
	.byte $F0	; $0D
	.byte $F0	; $0E
	.byte $00	; $0F
	.byte $EE	; $10
	.byte $DC	; $11
	.byte $24	; $12
	.byte $F4	; $13
	.byte $EC	; $14
	.byte $E8	; $15
	.byte $E8	; $16
	.byte $E8	; $17
	.byte $EC	; $18
	.byte $F4	; $19
	.byte $F0	; $1A
	.byte $10	; $1B
	.byte $00	; $1C
	.byte $F8	; $1D
	.byte $10	; $1E
	.byte $0C	; $1F
	.byte $F4	; $20
	.byte $F0	; $21
	.byte $10	; $22
	.byte $F4	; $23
	.byte $0C	; $24
	.byte $F0	; $25
	.byte $10	; $26
	.byte $EC	; $27
	.byte $0C	; $28
	.byte $F0	; $29
	.byte $10	; $2A
	.byte $E8	; $2B
	.byte $18	; $2C
	.byte $F0	; $2D
	.byte $10	; $2E
	.byte $F0	; $2F
	.byte $10	; $30
	.byte $FC	; $31
	.byte $04	; $32
	.byte $FC	; $33
	.byte $04	; $34
	.byte $FC	; $35
	.byte $04	; $36
	.byte $FC	; $37
	.byte $04	; $38
	.byte $F8	; $39
	.byte $08	; $3A
	.byte $D8	; $3B
	.byte $08	; $3C
	.byte $EC	; $3D
	.byte $14	; $3E
	.byte $05	; $3F
	.byte $FB	; $40
	.byte $00	; $41
	.byte $F8	; $42
	.byte $08	; $43
	.byte $F4	; $44
	.byte $0C	; $45
	.byte $E8	; $46
	.byte $18	; $47
	.byte $F8	; $48
	.byte $08	; $49
	.byte $E4	; $4A
	.byte $1C	; $4B
	.byte $F4	; $4C
	.byte $0C	; $4D
	.byte $08	; $4E
	.byte $F8	; $4F
	.byte $F0	; $50
	.byte $10	; $51
	.byte $E0	; $52
	.byte $20	; $53
	.byte $00	; $54
	.byte $EC	; $55
	.byte $14	; $56
	.byte $00	; $57
	.byte $14	; $58
	.byte $00	; $59
	.byte $EC	; $5A
	.byte $EC	; $5B
	.byte $14	; $5C
	.byte $14	; $5D
	.byte $14	; $5E
	.byte $14	; $5F
	.byte $EC	; $60
	.byte $EC	; $61
	.byte $EC	; $62
	.byte $08	; $63
	.byte $F8	; $64
	.byte $F8	; $65
	.byte $08	; $66
	.byte $D8	; $67
	
	
PRG063_ProjXHiOffset:
	.byte $FF	; $00
	.byte $00	; $01
	.byte $00	; $02
	.byte $00	; $03
	.byte $00	; $04
	.byte $00	; $05
	.byte $00	; $06
	.byte $00	; $07
	.byte $00	; $08
	.byte $00	; $09
	.byte $00	; $0A
	.byte $00	; $0B
	.byte $00	; $0C
	.byte $FF	; $0D
	.byte $FF	; $0E
	.byte $00	; $0F
	.byte $FF	; $10
	.byte $FF	; $11
	.byte $00	; $12
	.byte $FF	; $13
	.byte $FF	; $14
	.byte $FF	; $15
	.byte $FF	; $16
	.byte $FF	; $17
	.byte $FF	; $18
	.byte $FF	; $19
	.byte $FF	; $1A
	.byte $00	; $1B
	.byte $00	; $1C
	.byte $FF	; $1D
	.byte $00	; $1E
	.byte $00	; $1F
	.byte $FF	; $20
	.byte $FF	; $21
	.byte $00	; $22
	.byte $FF	; $23
	.byte $00	; $24
	.byte $FF	; $25
	.byte $00	; $26
	.byte $FF	; $27
	.byte $00	; $28
	.byte $FF	; $29
	.byte $00	; $2A
	.byte $FF	; $2B
	.byte $00	; $2C
	.byte $FF	; $2D
	.byte $00	; $2E
	.byte $FF	; $2F
	.byte $00	; $30
	.byte $FF	; $31
	.byte $00	; $32
	.byte $FF	; $33
	.byte $00	; $34
	.byte $FF	; $35
	.byte $00	; $36
	.byte $FF	; $37
	.byte $00	; $38
	.byte $FF	; $39
	.byte $00	; $3A
	.byte $FF	; $3B
	.byte $00	; $3C
	.byte $FF	; $3D
	.byte $00	; $3E
	.byte $00	; $3F
	.byte $FF	; $40
	.byte $00	; $41
	.byte $FF	; $42
	.byte $00	; $43
	.byte $FF	; $44
	.byte $00	; $45
	.byte $FF	; $46
	.byte $00	; $47
	.byte $FF	; $48
	.byte $00	; $49
	.byte $FF	; $4A
	.byte $00	; $4B
	.byte $FF	; $4C
	.byte $00	; $4D
	.byte $00	; $4E
	.byte $FF	; $4F
	.byte $FF	; $50
	.byte $00	; $51
	.byte $FF	; $52
	.byte $00	; $53
	.byte $00	; $54
	.byte $FF	; $55
	.byte $00	; $56
	.byte $00	; $57
	.byte $00	; $58
	.byte $00	; $59
	.byte $FF	; $5A
	.byte $FF	; $5B
	.byte $00	; $5C
	.byte $00	; $5D
	.byte $00	; $5E
	.byte $00	; $5F
	.byte $FF	; $60
	.byte $FF	; $61
	.byte $FF	; $62
	.byte $00	; $63
	.byte $FF	; $64
	.byte $FF	; $65
	.byte $00	; $66
	.byte $FF	; $67


PRG063_ProjYOffset:
	.byte $FF	; $00
	.byte $FF	; $01
	.byte $F0	; $02
	.byte $FA	; $03
	.byte $EC	; $04
	.byte $EC	; $05
	.byte $F4	; $06
	.byte $00	; $07
	.byte $08	; $08
	.byte $10	; $09
	.byte $14	; $0A
	.byte $F8	; $0B
	.byte $08	; $0C
	.byte $F8	; $0D
	.byte $08	; $0E
	.byte $10	; $0F
	.byte $0C	; $10
	.byte $04	; $11
	.byte $04	; $12
	.byte $14	; $13
	.byte $10	; $14
	.byte $08	; $15
	.byte $00	; $16
	.byte $F4	; $17
	.byte $EC	; $18
	.byte $EC	; $19
	.byte $02	; $1A
	.byte $02	; $1B
	.byte $00	; $1C
	.byte $08	; $1D
	.byte $10	; $1E
	.byte $F4	; $1F
	.byte $0C	; $20
	.byte $00	; $21
	.byte $00	; $22
	.byte $F4	; $23
	.byte $0C	; $24
	.byte $10	; $25
	.byte $F4	; $26
	.byte $F0	; $27
	.byte $10	; $28
	.byte $EC	; $29
	.byte $EC	; $2A
	.byte $00	; $2B
	.byte $00	; $2C
	.byte $04	; $2D
	.byte $04	; $2E
	.byte $FC	; $2F
	.byte $FC	; $30
	.byte $E8	; $31
	.byte $E8	; $32
	.byte $F8	; $33
	.byte $F8	; $34
	.byte $08	; $35
	.byte $08	; $36
	.byte $18	; $37
	.byte $18	; $38
	.byte $00	; $39
	.byte $00	; $3A
	.byte $18	; $3B
	.byte $E0	; $3C
	.byte $F8	; $3D
	.byte $F8	; $3E
	.byte $F0	; $3F
	.byte $F0	; $40
	.byte $E4	; $41
	.byte $FA	; $42
	.byte $FA	; $43
	.byte $F0	; $44
	.byte $F0	; $45
	.byte $FC	; $46
	.byte $FC	; $47
	.byte $F4	; $48
	.byte $F4	; $49
	.byte $02	; $4A
	.byte $02	; $4B
	.byte $04	; $4C
	.byte $04	; $4D
	.byte $04	; $4E
	.byte $04	; $4F
	.byte $08	; $50
	.byte $08	; $51
	.byte $14	; $52
	.byte $14	; $53
	.byte $14	; $54
	.byte $14	; $55
	.byte $14	; $56
	.byte $EC	; $57
	.byte $00	; $58
	.byte $14	; $59
	.byte $00	; $5A
	.byte $EC	; $5B
	.byte $EC	; $5C
	.byte $EC	; $5D
	.byte $14	; $5E
	.byte $14	; $5F
	.byte $14	; $60
	.byte $14	; $61
	.byte $EC	; $62
	.byte $E4	; $63
	.byte $E4	; $64
	.byte $1C	; $65
	.byte $1C	; $66
	.byte $10	; $67
	
	
PRG063_ProjYHiOffset:
	.byte $FF	; $00
	.byte $FF	; $01
	.byte $FF	; $02
	.byte $FF	; $03
	.byte $FF	; $04
	.byte $FF	; $05
	.byte $FF	; $06
	.byte $00	; $07
	.byte $00	; $08
	.byte $00	; $09
	.byte $00	; $0A
	.byte $FF	; $0B
	.byte $00	; $0C
	.byte $FF	; $0D
	.byte $00	; $0E
	.byte $00	; $0F
	.byte $00	; $10
	.byte $00	; $11
	.byte $00	; $12
	.byte $00	; $13
	.byte $00	; $14
	.byte $00	; $15
	.byte $00	; $16
	.byte $FF	; $17
	.byte $FF	; $18
	.byte $FF	; $19
	.byte $00	; $1A
	.byte $00	; $1B
	.byte $00	; $1C
	.byte $00	; $1D
	.byte $00	; $1E
	.byte $FF	; $1F
	.byte $00	; $20
	.byte $00	; $21
	.byte $00	; $22
	.byte $FF	; $23
	.byte $00	; $24
	.byte $00	; $25
	.byte $FF	; $26
	.byte $FF	; $27
	.byte $00	; $28
	.byte $FF	; $29
	.byte $FF	; $2A
	.byte $00	; $2B
	.byte $00	; $2C
	.byte $00	; $2D
	.byte $00	; $2E
	.byte $FF	; $2F
	.byte $FF	; $30
	.byte $FF	; $31
	.byte $FF	; $32
	.byte $FF	; $33
	.byte $FF	; $34
	.byte $00	; $35
	.byte $00	; $36
	.byte $00	; $37
	.byte $00	; $38
	.byte $00	; $39
	.byte $00	; $3A
	.byte $00	; $3B
	.byte $FF	; $3C
	.byte $FF	; $3D
	.byte $FF	; $3E
	.byte $FF	; $3F
	.byte $FF	; $40
	.byte $FF	; $41
	.byte $FF	; $42
	.byte $FF	; $43
	.byte $FF	; $44
	.byte $FF	; $45
	.byte $FF	; $46
	.byte $FF	; $47
	.byte $FF	; $48
	.byte $FF	; $49
	.byte $00	; $4A
	.byte $00	; $4B
	.byte $00	; $4C
	.byte $00	; $4D
	.byte $00	; $4E
	.byte $00	; $4F
	.byte $00	; $50
	.byte $00	; $51
	.byte $00	; $52
	.byte $00	; $53
	.byte $00	; $54
	.byte $00	; $55
	.byte $00	; $56
	.byte $FF	; $57
	.byte $00	; $58
	.byte $00	; $59
	.byte $00	; $5A
	.byte $FF	; $5B
	.byte $FF	; $5C
	.byte $FF	; $5D
	.byte $00	; $5E
	.byte $00	; $5F
	.byte $00	; $60
	.byte $00	; $61
	.byte $FF	; $62
	.byte $FF	; $63
	.byte $FF	; $64
	.byte $00	; $65
	.byte $00	; $66
	.byte $00	; $67


PRG063_FlipObjDirAndSpr:
	
	; Flip left/right facing
	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_RIGHT | SPRDIR_LEFT)
	STA Spr_FaceDir+$00,X
	
	; Reverse sprite horz flip
	LDA Spr_Flags+$00,X
	EOR #SPR_HFLIP
	STA Spr_Flags+$00,X
	
	RTS	; $F6BB


PRG063_QueueMusSnd_SetMus_Cur:
	STA <Mus_Cur	; Store music queue -> Mus_Cur

PRG063_QueueMusSnd:
	STX <Temp_Var0	; Backup 'X' -> Temp_Var0
	
	LDX <MusSnd_TriggerCurIdx	; X = current queue index
	
	STA <Temp_Var1	; Input val -> Temp_Var1
	
	LDA <Sound_Trigger,X
	CMP #$88
	BNE PRG063_F6D4	; If sound trigger slot is not idle, jump to PRG063_F6D4

	; Store trigger
	LDA <Temp_Var1
	STA <Sound_Trigger,X
	
	INX		; Advance queue index
	TXA
	AND #$07	; Wrap 0-7
	STA <MusSnd_TriggerCurIdx	; -> MusSnd_TriggerCurIdx

PRG063_F6D4:
	LDX <Temp_Var0	; Restore
	
	RTS	; $F6D6


	; Returns an absolute Y value of distance.
	; Note that if Player is above object, carry will be clear
PRG063_CalcObjYDiffFromPlayer:
	; A - B --> Negative, carry clear; positive, carry set
	; So if PY = 32 and OY = 64 (Player above), negative result, carry clear

	LDA Spr_Y+$00
	SUB Spr_Y+$00,X
	BCS PRG063_F6E5

	; Player above object, carry clear
	EOR #$FF
	ADC #$01
	CLC

PRG063_F6E5:
	RTS	; $F6E5


	; Returns an absolute X value of distance.
	; Note that if Player is to the left, carry will be clear
PRG063_CalcObjXDiffFromPlayer:

	; A - B --> Negative, carry clear; positive, carry set
	; So if PX = 32 and OX = 64 (Player left), negative result, carry clear

	LDA Spr_X+$00
	SUB Spr_X+$00,X
	PHA
	LDA Spr_XHi+$00
	SBC Spr_XHi+$00,X
	PLA
	BCS PRG063_F6FC

	; If Player is to left of object, negate it
	EOR #$FF
	ADC #$01
	CLC		; note that carry clear no matter what

PRG063_F6FC:
	RTS	; $F6FC


PRG063_AimTowardsPlayer:
	LDA Spr_Y+$00
	STA <Temp_Var0
	
	LDA Spr_X+$00
	STA <Temp_Var1
	
	LDA Spr_XHi+$00
	STA <Temp_Var2
	
	JMP PRG063_F71E	; Jump to PRG063_F71E


PRG063_AimTowardsObject:
	; Object Y -> Temp_Var0
	LDA Spr_Y+$00,Y
	STA <Temp_Var0
	
	; Object X -> Temp_Var1
	LDA Spr_X+$00,Y
	STA <Temp_Var1
	
	; Object XHi -> Temp_Var2
	LDA Spr_XHi+$00,Y
	STA <Temp_Var2

PRG063_F71E:
	LDY #$00	; Y = 0
	
	LDA <Temp_Var0	; Input Object Y
	SUB Spr_Y+$00,X	; Diff against current Object Y
	
	LDY #$00	; Y = 0
	BCS PRG063_F730	; If didn't underflow, jump to PRG063_F730

	; Negate difference
	EOR #$FF
	ADC #$01
	
	LDY #$04	; Y = 4

PRG063_F730:
	STA <Temp_Var0	; Y difference -> Temp_Var0
	
	LDA <Temp_Var1	; Input Object X
	SUB Spr_X+$00,X	; Diff against current Object X
	PHA
	LDA <Temp_Var2	; Input Object XHi
	SBC Spr_XHi+$00,X	; Diff against current Object XHi
	PLA
	BCS PRG063_F747	; If didn't underflow, jump to PRG063_F747

	; Negate
	EOR #$FF
	ADC #$01
	
	; Y = 2 or 6
	INY
	INY

PRG063_F747:
	STA <Temp_Var1	; X difference -> Temp_Var1
	
	CMP <Temp_Var0
	BGE PRG063_F756	; If the X difference is greater than the Y difference, jump to PRG063_F756

	; Swap Temp_Var0 / Temp_Var1 (so Temp_Var1 is always greater)
	PHA
	LDA <Temp_Var0
	STA <Temp_Var1
	PLA
	STA <Temp_Var0
	
	INY	; Y = 3 or 7

PRG063_F756:

	; Temp_Var2 = 0
	LDA #$00
	STA <Temp_Var2
	
	LDA <Temp_Var1
	LSR A
	LSR A
	
	CMP <Temp_Var0
	BGE PRG063_F76B	; If (Temp_Var1 / 4) >= Temp_Var0, jump to PRG063_F76B

	INC <Temp_Var2	; Temp_Var2++
	
	ASL A	; $F764
	CMP <Temp_Var0	; $F765
	BGE PRG063_F76B	; $F767

	INC <Temp_Var2	; $F769

PRG063_F76B:
	
	TYA
	ASL A
	ASL A
	ADD <Temp_Var2
	TAY		; Y = (Y * 4) + Temp_Var2
	
	LDA PRG063_F776,Y	
	RTS	; $F775


PRG063_F776:
	;                     V - unused values
	.byte $04, $05, $06, $04	; $00-$03
	.byte $08, $07, $06, $04	; $04-$07
	.byte $0C, $0B, $0A, $04	; $08-$0B
	.byte $08, $09, $0A, $04	; $0C-$0F
	.byte $04, $03, $02, $04	; $10-$13
	.byte $00, $01, $02, $04	; $14-$17
	.byte $0C, $0D, $0E, $04	; $18-$1B
	.byte $00, $0F, $0E, $04	; $1C-$1F


PRG063_Aim_FaceDir:
	.byte SPRDIR_UP						; $00	SPRAIM_ANG_0	Up
	.byte SPRDIR_UP | SPRDIR_RIGHT		; $01	SPRAIM_ANG_22
	.byte SPRDIR_UP | SPRDIR_RIGHT		; $02 	SPRAIM_ANG_45	Up-Right
	.byte SPRDIR_UP | SPRDIR_RIGHT		; $03	SPRAIM_ANG_67
	.byte SPRDIR_RIGHT					; $04	SPRAIM_ANG_90	Right
	.byte SPRDIR_DOWN | SPRDIR_RIGHT	; $05	SPRAIM_ANG_112
	.byte SPRDIR_DOWN | SPRDIR_RIGHT	; $06	SPRAIM_ANG_135	Down-Right
	.byte SPRDIR_DOWN | SPRDIR_RIGHT	; $07	SPRAIM_ANG_157
	.byte SPRDIR_DOWN					; $08	SPRAIM_ANG_180	Down
	.byte SPRDIR_DOWN | SPRDIR_LEFT		; $09	SPRAIM_ANG_202
	.byte SPRDIR_DOWN | SPRDIR_LEFT		; $0A	SPRAIM_ANG_225	Down-left
	.byte SPRDIR_DOWN | SPRDIR_LEFT		; $0B	SPRAIM_ANG_247
	.byte SPRDIR_LEFT					; $0C	SPRAIM_ANG_270	Left
	.byte SPRDIR_UP | SPRDIR_LEFT		; $0D	SPRAIM_ANG_292
	.byte SPRDIR_UP | SPRDIR_LEFT		; $0E	SPRAIM_ANG_315	Up-Left
	.byte SPRDIR_UP | SPRDIR_LEFT		; $0F	SPRAIM_ANG_337
	

PRG063_Aim2Plyr_SetDir_Var4:
	JSR PRG063_AimTowardsPlayer
	STA <Temp_Var0
	TAY
	
	LDA Spr_Var4+$00,X
	ADD #$08	; Spr_Var4 + 8
	AND #$0F	; Cap $0-$F
	SUB <Temp_Var0	; - Temp_Var0
	AND #$0F	; Cap $0-$F
	SUB #$08	; - 8
	
	BEQ PRG063_F7D7	; $F7BC
	BCS PRG063_F7C5	; $F7BE

	INC Spr_Var4+$00,X	; $F7C0
	BNE PRG063_F7C8	; $F7C3


PRG063_F7C5:
	DEC Spr_Var4+$00,X	; $F7C5

PRG063_F7C8:
	LDA Spr_Var4+$00,X	; $F7C8
	AND #$0F	; $F7CB
	STA Spr_Var4+$00,X	; $F7CD
	TAY	; $F7D0
	
	; Set direction towards Player
	LDA PRG063_Aim_FaceDir,Y
	STA Spr_FaceDir+$00,X

PRG063_F7D7:
	RTS	; $F7D7


	; Carry is set if Player and object collided, or clear if not
PRG063_PlayerObjectHitTest:
	LDA Spr_Flags+$00,X
	BPL PRG063_F841	; If object is not on-screen, jump to PRG063_F841 (clear carry, exit)

	; Backup 'Y' ->  Temp_Var0
	STY <Temp_Var0
	
	; Temp_Var1 = $17 (final object index)
	LDY #$17
	STY <Temp_Var1
	
PRG063_F7E3:
	LDA Spr_SlotID+$00,Y
	BEQ PRG063_F839	; If this object slot is empty, jump to PRG063_F839 (skip to next object)

	LDA Spr_YHi+$00,Y
	BNE PRG063_F839	; If this object is off-screen vertically, jump to PRG063_F839 (skip to next object)

	; Not vertically off-screen...

	LDA Spr_Flags+$00,Y
	AND #SPRFL1_NODRAW
	BNE PRG063_F839	; If Spr_Flags bit $04 is set (object not being drawn), jump to PRG063_F839 (skip to next object)

	LDA Spr_Flags+$00,Y
	AND #(SPRFL1_OBJSOLID | SPRFL1_NOHITMOVEVERT)
	BEQ PRG063_F839	; If object is not solid OR vertical-move-hit-disabled, jump to PRG063_F839 (skip to next object)

	; Object is solid OR vertical-move-hit-disabled

	AND #SPRFL1_NOHITMOVEVERT
	BEQ PRG063_F804	; If not vertical-move-hit-disabled, jump to PRG063_F804

	; vertical-move-hit-disabled...

	LDA Spr_YVel+$00,X
	BPL PRG063_F839	; If object is moving upward, jump to PRG063_F839 (skip to next object)


PRG063_F804:
	JSR PRG063_CalcPlayerRelXDiff	; Calculate Player X difference -> Temp_Var16

	BNE PRG063_F839	; If object is out of range X-wise from Player, jump to PRG063_F839 (skip to next object)

	; Temp_Var17 -> difference of Player Y with object bounding box
	; Temp_Var18 -> Bounding box height
	JSR PRG063_CalcObjYDiffBBox

	BCC PRG063_F815	; Computed difference OK, jump to PRG063_F815

	LDA Spr_Flags+$00,Y
	AND #SPRFL1_NOHITMOVEVERT
	BNE PRG063_F839	; If Spr_Flags bit $01 is set (FIXME), jump to PRG063_F839 (skip to next object)


PRG063_F815:
	LDA Spr_Flags2+$00,Y
	AND #$3F
	TAY	; Y = object's bounding box index
	
	LDA <Temp_Var16	; Player X diff against object
	CMP PRG063_ObjBoundBoxWidth,Y
	BGE PRG063_F839	; If out of range, jump to PRG063_F839 (skip to next object)

	SEC
	
	LDA <Temp_Var18	; Bounding box height
	SBC <Temp_Var17	; difference of Player Y with object bounding box
	BCC PRG063_F839	; If out of range, jump to PRG063_F839 (skip to next object)

	STA <Temp_Var17	; Remaining difference -> Temp_Var17
	
	CMP #$08
	BLT PRG063_F833	; If difference < 8, jump to PRG063_F833

	; Set difference to 8
	LDA #$08
	STA <Temp_Var17

PRG063_F833:
	LDY <Temp_Var1	; Useless operation because of next line...
	LDY <Temp_Var0	; Restore 'Y'
	
	SEC	; Set carry (object intersection)
	RTS	; $F838


PRG063_F839:
	DEC <Temp_Var1	; Temp_Var1-- (object index)
	LDY <Temp_Var1	; Y = Temp_Var1
	BNE PRG063_F7E3	; If Temp_Var1 > 0, loop!

	LDY <Temp_Var0	; Restore 'Y'

PRG063_F841:
	CLC	; Clear carry
	RTS	; $F842


PRG063_ObjDetCarryIfHit:
	LDA Spr_Flags+$00,X
	BPL PRG063_F898	; If object not on-screen, jump to PRG063_F898 (clear carry, exit)

	; Backup 'Y' into Temp_Var0
	STY <Temp_Var0


	; Temp_Var1 = $17 (final object index)
	LDY #$17
	STY <Temp_Var1
	
PRG063_F84E:
	LDA Spr_SlotID+$00,Y
	BEQ PRG063_F890	; If this object slot is empty, jump to PRG063_F890 (skip to next object)

	LDA Spr_YHi+$00,Y
	BNE PRG063_F890	; If this object is off-screen vertically, jump to PRG063_F890 (skip to next object)

	LDA Spr_Flags+$00,Y
	AND #SPRFL1_NODRAW
	BNE PRG063_F890	; If Spr_Flags bit $04 is set (object not being drawn), jump to PRG063_F890 (skip to next object)

	LDA Spr_Flags+$00,Y
	AND #SPRFL1_OBJSOLID
	BEQ PRG063_F890	; If Spr_Flags bit $02 is not set (object is solid), jump to PRG063_F890 (skip to next object)


	JSR PRG063_CalcPlayerRelXDiff	; Calculate Player X difference -> Temp_Var16

	BNE PRG063_F890	; If object is out of range X-wise from Player, jump to PRG063_F890 (skip to next object)

	; Temp_Var17 -> difference of Player Y with object bounding box
	; Temp_Var18 -> Bounding box height
	JSR PRG063_CalcObjYDiffBBox

	LDA Spr_Flags2+$00,Y
	AND #$3F
	TAY	; Y = object's bounding box index

	LDA <Temp_Var17	; Bounding box height
	CMP <Temp_Var18	; difference of Player Y with object bounding box
	BGE PRG063_F890	; If out of range, jump to PRG063_F890 (skip to next object)

	SEC
	
	LDA PRG063_ObjBoundBoxWidth,Y
	SBC <Temp_Var16	; Player X diff against object
	BLT PRG063_F890	; If out of range, jump to PRG063_F890 (skip to next object)

	STA <Temp_Var16	; Remaining difference -> Temp_Var16
	
	CMP #$08
	BLT PRG063_F88C	; If difference < 8, jump to PRG063_F88C

	; Set difference to 8
	LDA #$08
	STA <Temp_Var16

PRG063_F88C:
	LDY <Temp_Var0	; $F88C

	SEC	; $F88E
	RTS	; $F88F


PRG063_F890:
	DEC <Temp_Var1	; Temp_Var1-- (object index)
	LDY <Temp_Var1	; Y = Temp_Var1
	BNE PRG063_F84E	; If Temp_Var1 > 0, loop!

	LDY <Temp_Var0	; $F83F

PRG063_F898:
	CLC	; $F841
	RTS	; $F842



	; Calculates a relative X difference between the object and Player
PRG063_CalcPlayerRelXDiff:
	LDA Spr_X+$00
	SUB Spr_X+$00,Y
	STA <Temp_Var16
	
	LDA Spr_XHi+$00
	SBC Spr_XHi+$00,Y
	BCS PRG063_F8BA

	PHA
	
	; Negate Temp_Var16
	LDA <Temp_Var16
	EOR #$FF
	ADC #$01
	STA <Temp_Var16
	
	PLA
	
	EOR #$FF
	ADC #$00
	
	CLC	; $F8B9

PRG063_F8BA:
	AND #$01
	RTS	; $F8BC


	; Temp_Var17 -> difference of Player Y with object bounding box
	; Temp_Var18 -> Bounding box height
PRG063_CalcObjYDiffBBox:
	LDA Spr_Flags2+$00,Y
	AND #$3F
	TAY	; Y = object's bounding box
	
	LDA PRG063_ObjBoundBoxHeight,Y
	STA <Temp_Var18	; Bounding box height -> Temp_Var18
	
	LDY <Temp_Var1	; Y = current object index
	
	LDA Spr_CurrentAnim+$00
	CMP #SPRANM2_PLAYERSLIDE
	BNE PRG063_F8D7	; If Player is not sliding, jump to PRG063_F8D7

	; Player is sliding, offset bounding box
	LDA <Temp_Var18
	SBC #$02
	STA <Temp_Var18

PRG063_F8D7:
	; Compute difference
	LDA Spr_Y+$00
	SUB Spr_Y+$00,Y
	BCS PRG063_F8E5

	; Negate
	EOR #$FF
	ADC #$01
	
	CLC

PRG063_F8E5:
	STA <Temp_Var17	; -> Temp_Var17
	
	PHP
	
	BCC PRG063_F8F7	; $F8E8

	LDA Spr_CurrentAnim+$00
	CMP #SPRANM2_PLAYERSLIDE
	BNE PRG063_F8F7	; If Player is not sliding, jump to PRG063_F8F7

	; Player is sliding, offset Y
	LDA <Temp_Var18
	SBC #$04
	STA <Temp_Var18

PRG063_F8F7:
	PLP
	
	RTS	; $F8F8


PRG063_F8F9:
	SEC	; $F8F9
	LDA Spr_X+$00,X	; $F8FA
	SBC <Temp_Var16	; $F8FD
	STA Spr_X+$00,X	; $F8FF
	LDA Spr_XHi+$00,X	; $F902
	SBC #$00	; $F905
	STA Spr_XHi+$00,X	; $F907
	JMP PRG063_F91E	; $F90A


PRG063_F90D:
	CLC	; $F90D
	LDA Spr_X+$00,X	; $F90E
	ADC <Temp_Var16	; $F911
	STA Spr_X+$00,X	; $F913
	LDA Spr_XHi+$00,X	; $F916
	ADC #$00	; $F919
	STA Spr_XHi+$00,X	; $F91B

PRG063_F91E:
	SEC	; $F91E
	LDA <Temp_Var2	; $F91F
	SBC Spr_X+$00,X	; $F921
	STA <Temp_Var2	; $F924
	LDA <Temp_Var3	; $F926
	SBC Spr_XHi+$00,X	; $F928
	ORA <Temp_Var2	; $F92B
	RTS	; $F92D


	; Offset sprite Y by Temp_Var17/Temp_Var2
PRG063_CalcObjectRelYDiffRev:
	SEC
	LDA Spr_Y+$00,X
	SBC <Temp_Var17
	STA Spr_Y+$00,X
	BCS PRG063_F956	; If carry set, jump to PRG063_F956

	DEC Spr_YHi,X
	JMP PRG063_F956


PRG063_CalcObjectRelYDiff:
	CLC
	
	LDA Spr_Y+$00,X
	ADC <Temp_Var17	; Y difference 
	STA Spr_Y+$00,X
	BCS PRG063_F953

	CMP #$F0
	BLT PRG063_F956

	ADC #$0F
	STA Spr_Y,X	
	
PRG063_F953:
	; Overflow, Spr_YHi = 1
	INC Spr_YHi,X


PRG063_F956:
	SEC
	
	LDA <Temp_Var2
	SBC Spr_Y+$00,X
	RTS	; $F95C


	; Tests Player collision to other objects; returns Carry Clear if collided
PRG063_TestPlayerObjCollide:
	SEC	; Set carry
	
	LDA Spr_YHi+$00
	BNE PRG063_F9B3	; If Player is vertically off-screen, jump to PRG063_F9B3 (RTS)

	LDA Spr_YHi+$00,X
	BNE PRG063_F9B3	; If non-Player object is vertically off-screen, jump to PRG063_F9B3 (RTS)

	LDA Spr_Flags+$00,X
	BPL PRG063_F9B3	; If object is not on-screen, jump to PRG063_F9B3 (RTS)

	AND #$04	; $F96D
	BNE PRG063_F9B3	; $F96F

	; Y = bounding box index
	LDA Spr_Flags2+$00,X
	AND #$3F
	TAY
	
	LDA PRG063_ObjBoundBoxHeight,Y
	STA <Temp_Var0
	
	LDA Spr_CurrentAnim+$00
	CMP #SPRANM2_PLAYERSLIDE
	BNE PRG063_F98A	; If Player is not sliding, jump to PRG063_F98A

	; Sliding, adjust for height
	LDA <Temp_Var0
	SUB #$08
	STA <Temp_Var0

PRG063_F98A:
	LDA Spr_X+$00
	SUB Spr_X+$00,X
	
	PHA		; Save the X difference
	
	LDA Spr_XHi+$00
	SBC Spr_XHi+$00,X
	
	PLA		; Restore X differnce
	
	BCS PRG063_F99F

	; Negate
	EOR #$FF
	ADC #$01

PRG063_F99F:
	CMP PRG063_ObjBoundBoxWidth,Y
	BGE PRG063_F9B3	; If object not in range, jump to PRG063_F9B3

	LDA Spr_Y+$00
	SUB Spr_Y+$00,X
	
	BCS PRG063_F9B1

	; Negate
	EOR #$FF
	ADC #$01

PRG063_F9B1:
	CMP <Temp_Var0

PRG063_F9B3:
	RTS	; $F9B3


PRG063_ObjBoundBoxHeight:
	.byte $14	; $00
	.byte $13	; $01
	.byte $14	; $02
	.byte $14	; $03
	.byte $14	; $04
	.byte $14	; $05
	.byte $14	; $06
	.byte $14	; $07
	.byte $14	; $08
	.byte $14	; $09
	.byte $10	; $0A
	.byte $12	; $0B
	.byte $14	; $0C
	.byte $18	; $0D
	.byte $10	; $0E
	.byte $0F	; $0F
	.byte $18	; $10
	.byte $18	; $11
	.byte $14	; $12
	.byte $24	; $13
	.byte $1C	; $14
	.byte $1C	; $15
	.byte $24	; $16
	.byte $2C	; $17
	.byte $2C	; $18
	.byte $34	; $19
	.byte $10	; $1A
	.byte $16	; $1B
	.byte $1A	; $1C
	.byte $0E	; $1D
	.byte $15	; $1E
	.byte $3C	; $1F
	.byte $11	; $20
	.byte $0E	; $21
	.byte $18	; $22
	.byte $24	; $23
	.byte $1C	; $24
	.byte $4C	; $25
	.byte $1C	; $26
	.byte $1C	; $27
	.byte $18	; $28
	.byte $34	; $29
	.byte $14	; $2A
	.byte $0F	; $2B
	.byte $2C	; $2C
	.byte $20	; $2D
	.byte $2C	; $2E
	.byte $3C	; $2F
	.byte $3C	; $30
	.byte $14	; $31
	.byte $1C	; $32
	.byte $84	; $33
	.byte $14	; $34
	.byte $8C	; $35
	.byte $17	; $36
	.byte $24	; $37
	.byte $16	; $38
	.byte $14	; $39
	.byte $0C	; $3A
	.byte $0C	; $3B
	.byte $0C	; $3C
	.byte $0C	; $3D
	.byte $0C	; $3E
	.byte $0C	; $3F



PRG063_ObjBoundBoxWidth:
	.byte $10	; $00
	.byte $10	; $01
	.byte $18	; $02
	.byte $20	; $03
	.byte $28	; $04
	.byte $30	; $05
	.byte $38	; $06
	.byte $40	; $07
	.byte $48	; $08
	.byte $50	; $09
	.byte $20	; $0A
	.byte $18	; $0B
	.byte $20	; $0C
	.byte $14	; $0D
	.byte $0C	; $0E
	.byte $0B	; $0F
	.byte $18	; $10
	.byte $10	; $11
	.byte $0C	; $12
	.byte $18	; $13
	.byte $18	; $14
	.byte $10	; $15
	.byte $10	; $16
	.byte $10	; $17
	.byte $38	; $18
	.byte $38	; $19
	.byte $10	; $1A
	.byte $14	; $1B
	.byte $0B	; $1C
	.byte $14	; $1D
	.byte $14	; $1E
	.byte $18	; $1F
	.byte $10	; $20
	.byte $10	; $21
	.byte $20	; $22
	.byte $12	; $23
	.byte $12	; $24
	.byte $0C	; $25
	.byte $38	; $26
	.byte $0C	; $27
	.byte $0C	; $28
	.byte $10	; $29
	.byte $48	; $2A
	.byte $14	; $2B
	.byte $28	; $2C
	.byte $30	; $2D
	.byte $1C	; $2E
	.byte $38	; $2F
	.byte $28	; $30
	.byte $1C	; $31
	.byte $1C	; $32
	.byte $18	; $33
	.byte $0E	; $34
	.byte $F8	; $35
	.byte $11	; $36
	.byte $20	; $37
	.byte $10	; $38
	.byte $12	; $39
	.byte $08	; $3A
	.byte $08	; $3B
	.byte $08	; $3C
	.byte $08	; $3D
	.byte $08	; $3E
	.byte $08	; $3F



PRG063_CheckProjToObjCollide:
	LDY <Player_CurWeapon	; Y = Player_CurWeapon
	
	LDA PRG063_WpnTopIdxToCheck,Y
	BEQ PRG063_FA80	; If this Player weapon can't hit anything ever, jump to PRG063_FA80

	STA <Temp_Var16	; Set top object index for scanning

PRG063_FA3D:
	LDY <Temp_Var16	; Y = Temp_Var16 (current scan index)
	
	LDA Spr_SlotID+$00,Y
	BEQ PRG063_FA7C	; If this slot is empty, jump to PRG063_FA7C (loop around)

	LDA Spr_Flags+$00,Y
	BPL PRG063_FA7C	; If not on-screen, jump to PRG063_FA7C (loop around)

	LDA Spr_SlotID+$00,Y
	CMP #SPRSLOTID_DEFLECTEDSHOT
	BEQ PRG063_FA7C	; If slot ID <> SPRSLOTID_DEFLECTEDSHOT, jump to PRG063_FA7C (loop around)

	LDA Spr_Flags+$00,X
	BPL PRG063_FA7C	; If projectile is not on-screen, jump to PRG063_FA7C (loop around)

	AND #$04
	BNE PRG063_FA7C


	; Projectile X/Hi -> Temp_Var0/1
	LDA Spr_X+$00,Y
	STA <Temp_Var0		
	LDA Spr_XHi+$00,Y
	STA <Temp_Var1
	
	; Projectile Y -> Temp_Var2
	LDA Spr_Y+$00,Y
	STA <Temp_Var2
	
	LDA Spr_Flags2+$00,Y
	ASL A
	TAY
	
	; Load projectile sizes
	LDA PRG063_ProjSize,Y
	STA <RandomN+$02
	LDA PRG063_ProjSize+1,Y
	STA <RandomN+$03
	
	JSR PRG063_TestProjToObjCollide

	BCC PRG063_FA81	; Projectile hit! Jump to PRG063_FA81 (RTS, also clear carry means impact)


PRG063_FA7C:
	DEC <Temp_Var16	; Temp_Var16-- (current object index)
	BNE PRG063_FA3D	; While Temp_Var16 > 0, loop!


PRG063_FA80:
	SEC	; Set carry (no impact)

PRG063_FA81:
	RTS	; $FA81


PRG063_TestProjToObjCollide:
	LDA Spr_Flags2+$00,X
	AND #$3F	; Bounding box index
	TAY	; -> 'Y'
	
	LDA PRG063_ProjBBoxHeights,Y
	ADD <RandomN+$02
	STA <RandomN+$02
	
	LDA PRG063_ProjBBoxWidths,Y
	ADD <RandomN+$03
	STA <RandomN+$03
	
	LDA <Temp_Var0
	SUB Spr_X+$00,X
	PHA
	LDA <Temp_Var1
	SBC Spr_XHi+$00,X
	PLA
	BCS PRG063_FAAB

	EOR #$FF
	ADC #$01

PRG063_FAAB:
	CMP <RandomN+$03
	BGE PRG063_FABD

	LDA <Temp_Var2	
	SUB Spr_Y+$00,X	
	BCS PRG063_FABB	

	EOR #$FF
	ADC #$01

PRG063_FABB:
	CMP <RandomN+$02

PRG063_FABD:
	RTS	; $FABD


	; Specifies the "top" index to check (going backwards to and including $01)
	; for checking to see if a Player's projectile has hit an object. $00 means
	; to not consider a projectile hit at all.
PRG063_WpnTopIdxToCheck:
	.byte $03	; 0: Mega Buster
	.byte $03	; 1: Rush Coil
	.byte $03	; 2: Rush Jet
	.byte $03	; 3: Rush Marine
	.byte $00	; 4: Toad Rain
	.byte $04	; 5: Wire Adapter
	.byte $00	; 6: Balloon
	.byte $01	; 7: Dive Missile
	.byte $01	; 8: Ring Boomerang
	.byte $01	; 9: Drill Bomb
	.byte $04	; 10: Dust Crusher
	.byte $03	; 11: Pharaoh Shot
	.byte $03	; 12: Bright
	.byte $01	; 13: Skull
	
	; UNUSED
	.byte $00, $00


	; Indexed by object bounding box (Spr_Flags2 bits 0-5)
	; NOTE that only very low values make sense here
PRG063_ProjSize:
	;       H    W
	.byte $00, $00	; 0
	.byte $02, $06	; 1
	.byte $06, $06	; 2
	.byte $0E, $0E	; 3
	.byte $02, $02	; 4
	.byte $0A, $0A	; 5
	.byte $16, $16	; 6
	
	; Indexed by object bounding box (Spr_Flags2 bits 0-5)
PRG063_ProjBBoxHeights:
	.byte $0A	; $00
	.byte $09	; $01
	.byte $0A	; $02
	.byte $0A	; $03
	.byte $0A	; $04
	.byte $0A	; $05
	.byte $0A	; $06
	.byte $0A	; $07
	.byte $0A	; $08
	.byte $0A	; $09
	.byte $06	; $0A
	.byte $08	; $0B
	.byte $0A	; $0C
	.byte $0E	; $0D
	.byte $06	; $0E
	.byte $05	; $0F
	.byte $0E	; $10
	.byte $0E	; $11
	.byte $0A	; $12
	.byte $1A	; $13
	.byte $12	; $14
	.byte $12	; $15
	.byte $1A	; $16
	.byte $22	; $17
	.byte $22	; $18
	.byte $2A	; $19
	.byte $06	; $1A
	.byte $0C	; $1B
	.byte $10	; $1C
	.byte $04	; $1D
	.byte $0B	; $1E
	.byte $32	; $1F
	.byte $07	; $20
	.byte $04	; $21
	.byte $0E	; $22
	.byte $1A	; $23
	.byte $12	; $24
	.byte $42	; $25
	.byte $12	; $26
	.byte $12	; $27
	.byte $0E	; $28
	.byte $2A	; $29
	.byte $0A	; $2A
	.byte $05	; $2B
	.byte $22	; $2C
	.byte $16	; $2D
	.byte $22	; $2E
	.byte $32	; $2F
	.byte $32	; $30
	.byte $0A	; $31
	.byte $12	; $32
	.byte $7A	; $33
	.byte $0A	; $34
	.byte $82	; $35
	.byte $0D	; $36
	.byte $1A	; $37
	.byte $0C	; $38
	.byte $0A	; $39
	.byte $02	; $3A
	.byte $02	; $3B
	.byte $02	; $3C
	.byte $02	; $3D
	.byte $02	; $3E
	.byte $02	; $3F


	; Indexed by object bounding box (Spr_Flags2 bits 0-5)
PRG063_ProjBBoxWidths:
	.byte $0A	; $00
	.byte $0A	; $01
	.byte $12	; $02
	.byte $1A	; $03
	.byte $22	; $04
	.byte $2A	; $05
	.byte $32	; $06
	.byte $3A	; $07
	.byte $42	; $08
	.byte $4A	; $09
	.byte $1A	; $0A
	.byte $12	; $0B
	.byte $1A	; $0C
	.byte $0E	; $0D
	.byte $06	; $0E
	.byte $05	; $0F
	.byte $12	; $10
	.byte $0A	; $11
	.byte $06	; $12
	.byte $12	; $13
	.byte $12	; $14
	.byte $0A	; $15
	.byte $0A	; $16
	.byte $0A	; $17
	.byte $32	; $18
	.byte $32	; $19
	.byte $0A	; $1A
	.byte $0E	; $1B
	.byte $05	; $1C
	.byte $0E	; $1D
	.byte $0E	; $1E
	.byte $12	; $1F
	.byte $0A	; $20
	.byte $0A	; $21
	.byte $1A	; $22
	.byte $0C	; $23
	.byte $0C	; $24
	.byte $06	; $25
	.byte $32	; $26
	.byte $06	; $27
	.byte $06	; $28
	.byte $0A	; $29
	.byte $42	; $2A
	.byte $0E	; $2B
	.byte $22	; $2C
	.byte $2A	; $2D
	.byte $16	; $2E
	.byte $32	; $2F
	.byte $22	; $30
	.byte $16	; $31
	.byte $16	; $32
	.byte $12	; $33
	.byte $08	; $34
	.byte $F2	; $35
	.byte $0B	; $36
	.byte $1A	; $37
	.byte $0A	; $38
	.byte $0C	; $39
	.byte $02	; $3A
	.byte $02	; $3B
	.byte $02	; $3C
	.byte $02	; $3D
	.byte $02	; $3E
	.byte $02	; $3F


	; Finds a free object sprite slot between $07-$17, returning it in 'X'.
	; If a free slot was found, carry is clear.
	; If no free slot, carry is set.
PRG063_FindFreeSlotMinIdx7X:
	LDX #$17	; X = $17 (all object sprite slots)

PRG063_FB5E:
	LDA Spr_SlotID+$00,X
	BEQ PRG063_FB6A	; If object sprite slot is empty, jump to PRG063_FB6A (clear carry, return)

	DEX	; X--
	CPX #$07
	BNE PRG063_FB5E	; While X > 7, loop!

	SEC	; Set carry (no free slot)
	RTS

PRG063_FB6A:
	CLC	; Clear carry (free slot)
	RTS	; $FB6B


	; Finds a free object sprite slot between $07-$17, returning it in 'Y'.
	; If a free slot was found, carry is clear.
	; If no free slot, carry is set.
PRG063_FindFreeSlotMinIdx7:
	LDY #$17	; Y = $17 (all object sprite slots)

PRG063_FB6E:
	LDA Spr_SlotID+$00,Y
	BEQ PRG063_FB7A	; If object sprite slot is empty, jump to PRG063_FB7A (clear carry, return)

	DEY	; Y--
	CPY #$07
	BNE PRG063_FB6E	; While Y > 7, loop!

	SEC	; Set carry (no free slot)
	RTS	; $FB79


PRG063_FB7A:
	CLC	; Clear carry (free slot)
	RTS	; $FB7B


	; Finds a free object sprite slot between $04-$17, returning it in 'Y'.
	; If a free slot was found, carry is clear.
	; If no free slot, carry is set.
PRG063_FindFreeSlotMinIdx4:
	LDY #$17	; Y = $17 (all object sprite slots)

PRG063_FB7E:
	LDA Spr_SlotID+$00,Y
	BEQ PRG063_FB8A	; If object sprite slot is empty, jump to PRG063_FB8A (clear carry, return)

	DEY	; Y--
	CPY #$04
	BNE PRG063_FB7E	; While Y > 4, loop!

	SEC	; Set carry (no free slot)
	RTS	; $FB89


PRG063_FB8A:
	CLC	; Clear carry (free slot)
	RTS	; $FB8B


	; PRG063_AimPlayer_Var23Spd: Aim towards Player, computing speed
	; based on a value specified by Temp_Var2/3 (fractional and whole parts)
	; Doesn't seem to work right for values less than 1.0, but haven't tested
	; this too much...
	;
	; Inputs:
	; Temp_Var2 - frac
	; Temp_Var3 - whole
	;
	; Damaged:
	; Temp_Var1
	; Temp_Var2
	; Temp_Var3
	; Temp_Var4
	; Temp_Var5
	; Temp_Var10
	; Temp_Var11
	; Temp_Var12
PRG063_AimPlayer_Var23Spd:
	JSR PRG063_CalcObjXDiffFromPlayer	; Calc X diff
	STA <Temp_Var10	; -> Temp_Var10
	
	LDA #SPRDIR_RIGHT
	
	BCS PRG063_FB97	; If Player is to the right of object, jump to PRG063_FB97

	; Player is to left of object
	LDA #SPRDIR_LEFT

PRG063_FB97:
	STA <Temp_Var12	; Direction towards Player -> Temp_Var12
	
	JSR PRG063_CalcObjYDiffFromPlayer
	STA <Temp_Var11	; -> Temp_Var11
	
	LDA #SPRDIR_DOWN
	
	BCS PRG063_FBA4	; If Player is below object, jump to PRG063_FBA4

	; Player is above object
	LDA #SPRDIR_UP

PRG063_FBA4:
	ORA <Temp_Var12	; OR with L/R dir
	STA <Temp_Var12	; Direction towards Player -> Temp_Var12
	
	LDA <Temp_Var11
	CMP <Temp_Var10
	BGE PRG063_FBE1	; If Y diff >= X diff, jump to PRG063_FBE1

	; X diff > Y diff

	LDA <Temp_Var2
	STA Spr_XVelFrac+$00,X
	LDA <Temp_Var3
	STA Spr_XVel+$00,X
	
	LDA <Temp_Var10
	STA <Temp_Var1	; Temp_Var1 = Temp_Var10 (X difference)
	
	; Temp_Var0 = 0
	LDA #$00
	STA <Temp_Var0
	JSR PRG063_ScaleVal

	LDA <Temp_Var4
	STA <Temp_Var2	; Temp_Var2 = Temp_Var4
	
	LDA <Temp_Var5
	STA <Temp_Var3	; Temp_Var3 = Temp_Var5
	
	LDA <Temp_Var11
	STA <Temp_Var1	; Temp_Var1 = Temp_Var11 (Y difference)
	
	; Temp_Var0 = 0
	LDA #$00
	STA <Temp_Var0
	JSR PRG063_ScaleVal

	LDA <Temp_Var4
	STA Spr_YVelFrac+$00,X
	LDA <Temp_Var5
	STA Spr_YVel+$00,X
	
	RTS	; $FBE0


PRG063_FBE1:
	LDA <Temp_Var2
	STA Spr_YVelFrac+$00,X
	LDA <Temp_Var3
	STA Spr_YVel+$00,X
	
	LDA <Temp_Var11
	STA <Temp_Var1	; Temp_Var1 = Temp_Var11 (Y difference)
	
	; Temp_Var0 = 0
	LDA #$00
	STA <Temp_Var0
	JSR PRG063_ScaleVal

	LDA <Temp_Var4
	STA <Temp_Var2	; Temp_Var2 = Temp_Var4
	
	LDA <Temp_Var5
	STA <Temp_Var3	; Temp_Var3 = Temp_Var5
	
	LDA <Temp_Var10
	STA <Temp_Var1	; Temp_Var1 = Temp_Var10 (X difference)
	
	LDA #$00
	STA <Temp_Var0
	JSR PRG063_ScaleVal

	LDA <Temp_Var4
	STA Spr_XVelFrac+$00,X
	LDA <Temp_Var5
	STA Spr_XVel+$00,X
	
	RTS	; $FC13


PRG063_FC14:
	LDA #$00
	STA <Temp_Var2	; Temp_Var2 = 0
	STA <Temp_Var3	; Temp_Var3 = 0
	
	LDA <Temp_Var0
	ORA <Temp_Var1
	BNE PRG063_FC23	; If Temp_Var0 <> 0 or Temp_Var1 <> 0, jump to PRG063_FC23

	STA <Temp_Var2	; Temp_Var2 = 0 (and exit)
	
	RTS



PRG063_FC23:

	LDY #$08	; $FC23
PRG063_FC25:
	ASL <Temp_Var2	; $FC25
	ROL <Temp_Var0	; $FC27
	ROL <Temp_Var3	; $FC29
	SEC	; $FC2B
	LDA <Temp_Var3	; $FC2C
	SBC <Temp_Var1	; $FC2E
	BCC PRG063_FC36	; $FC30

	STA <Temp_Var3	; $FC32
	INC <Temp_Var2	; $FC34

PRG063_FC36:
	DEY	; $FC36
	BNE PRG063_FC25	; $FC37

	RTS	; $FC39


	; Temp_Var0/1 form a [frac, whole] scale value 
	; Temp_Var2/3 are the [frac, whole] value to scale
	; Temp_Var4/5 has the result
PRG063_ScaleVal:
	LDA #$00
	STA <Temp_Var6	; Temp_Var6 = 0
	STA <Temp_Var7	; Temp_Var7 = 0
	
	LDA <Temp_Var0
	ORA <Temp_Var1
	ORA <Temp_Var2
	ORA <Temp_Var3
	BNE PRG063_FC4F	; If any of Temp_Var0-3 are non-zero, jump to PRG063_FC4F

	STA <Temp_Var4	; Temp_Var4 = 0
	STA <Temp_Var5	; Temp_Var5 = 0
	RTS


PRG063_FC4F:
	STX <Temp_Var9	; Backup object index -> Temp_Var9
		
	LDY #16	; Y = 16
PRG063_FC53:

	; 32-bit left shift?!
	; Will be shifting 16 TIMES
	;  Temp_Var7 <- Temp_Var1 <- Temp_Var0 <- Temp_Var6
	ASL <Temp_Var6		; this will be zero for the first 8 iterations, and then it's pushing 1s in
	ROL <Temp_Var0
	ROL <Temp_Var1
	ROL <Temp_Var7
	
	SEC	
	LDA <Temp_Var1
	SBC <Temp_Var2
	TAX	; X = Temp_Var1 - Temp_Var2
	
	
	LDA <Temp_Var7
	SBC <Temp_Var3
	BCC PRG063_FC6D	; $FC65

	STX <Temp_Var1	; $FC67
	STA <Temp_Var7	; $FC69
	
	; This effectively will always set bit 0 since we start with Temp_Var6 = 0
	; and "ASL <Temp_Var6" is executed next loop
	INC <Temp_Var6

PRG063_FC6D:
	DEY	; Y--
	BNE PRG063_FC53	; While Y > 0, loop

	; Temp_Var4 = Temp_Var6
	LDA <Temp_Var6
	STA <Temp_Var4	
	
	; Temp_Var5 = Temp_Var0
	LDA <Temp_Var0
	STA <Temp_Var5
	
	LDX <Temp_Var9	; Restore object index
	RTS	; $FC7A

	; CHECKME - UNUSED?
	; $FC7B
	LDA #$00
	STA <Temp_Var2
	STA <Temp_Var3
	STA <Temp_Var4
	LDX #$10
PRG063_FC85:
	LSR <Temp_Var1
	BCC PRG063_FC96
	CLC
	LDA <Temp_Var0
	ADC <Temp_Var2
	STA <Temp_Var2
	LDA <Temp_Var4
	ADC <Temp_Var3
	STA <Temp_Var3
PRG063_FC96:
	ASL <Temp_Var0
	ROR <Temp_Var4
	DEX
	BNE PRG063_FC85
	RTS


PRG063_MarkNeverRespawn:
	LDA Spr_SpawnParentIdx,X
	AND #$07
	TAY		; Y = 0 to 7 based on lower 3 bits (select relative bit)
	
	LDA PRG063_IndexToBit,Y
	STA <Temp_Var0
	
	; Invert to generate appropriate mask (could also use PRG063_IndexToBit_Mask ... wonder if that was added late?)
	EOR #$FF
	STA <Temp_Var1
	
	LDA Spr_SpawnParentIdx,X
	LSR A
	LSR A
	LSR A
	TAY	; Y = parent spawn index / 8 (relative byte to set bit in)
	
	LDA Spr_NoRespawnBits,Y	; This byte's bit set
	AND <Temp_Var1	; Keep existing ones (technically this is a redundant operation since we're just setting it anyway)
	ORA <Temp_Var0	; Set this one
	STA Spr_NoRespawnBits,Y	; Update bit set
	
	RTS	; $FCBE


	; Just gets a bit for an index
PRG063_IndexToBit:
	.byte $01, $02, $04, $08, $10, $20, $40, $80
	
	; Same as above XORed by $FF (for clearing that bit)
PRG063_IndexToBit_Mask:
	.byte $FE, $FD, $FB, $F7, $EF, $DF, $BF, $7F


PRG063_DeleteObjectY:
	LDA #$00
	STA Spr_CodePtrH+$00,Y
	STA Spr_SlotID+$00,Y
	STA Spr_FlashOrPauseCnt,Y
	STA Spr_HP+$00,Y
	
	LDA #$FF
	STA Spr_SpawnParentIdx,Y
	
	RTS	; $FCE2


	; Variant of PRG063_DrawSprites that resets the current sprite index
PRG063_DrawSprites_RsetSprIdx:
	LDA #$04
	STA <Sprite_CurrentIndex


	; Call this to "draw" (i.e. commit to hardware sprite memory) all sprites in the sprite slots
PRG063_DrawSprites:
	
	; Backup current pages at $8000/$A000
	LDA <MMC3_Page8000_Req
	PHA
	LDA <MMC3_PageA000_Req
	PHA
	
	JSR PRG062_ResetSprites

	JSR PRG062_DoDrawSprites

	LDA #$00
	STA <DisFlag_NMIAndDisplay
	JSR PRG063_UpdateOneFrame

	INC <DisFlag_NMIAndDisplay	; $FCFA
	
	; Restore banks
	PLA
	STA <MMC3_PageA000_Req
	PLA
	STA <MMC3_Page8000_Req
	JMP PRG063_SetPRGBanks


	; WARNING: Prerequisite call to PRG062_CHRRAMDynLoadPalSeg required so CHRRAMDLPtr_L is valid!!
	; Safe bank-wrapped call to PRG062_CHRRAMDynLoadCHRSeg
PRG063_CHRRAMDynLoadCHRSegSafe:
	LDA <MMC3_Page8000_Req
	PHA
	LDA <MMC3_PageA000_Req
	PHA
	
	JSR PRG062_CHRRAMDynLoadCHRSeg

	PLA
	STA <MMC3_PageA000_Req
	PLA
	STA <MMC3_Page8000_Req
	JMP PRG063_SetPRGBanks	; $FD14


PRG063_SetMissileAimVelocities:
	STY <Temp_Var0	; Temp_Var0 = 'Y'
	STA <Temp_Var1	; Temp_Var1 = 'A'
	
	; Set aimed direction
	LDA PRG063_Aim_FaceDir,Y
	STA Spr_FaceDir+$00,X
	
	LDA <Temp_Var0
	AND #$07
	ORA <Temp_Var1
	TAY
	
	; Set missile X velocity
	LDA PRG063_MissileAim_VelFrac,Y
	STA Spr_XVelFrac+$00,X
	LDA PRG063_MissileAim_Vel,Y
	STA Spr_XVel+$00,X
	
	; Quarter turn
	TYA
	EOR #$04
	TAY
	
	; Set missile Y velocity
	LDA PRG063_MissileAim_VelFrac,Y
	STA Spr_YVelFrac+$00,X
	LDA PRG063_MissileAim_Vel,Y
	STA Spr_YVel+$00,X
	
	RTS	; $FD44


PRG063_MissileAim_VelFrac:
	.byte $00, $C3, $6A, $D9, $00, $D9, $6A, $C3, $00, $87, $D4, $B2, $00, $B2, $D4, $87
	.byte $00, $4B, $3E, $8B, $00, $8B, $3E, $4B
	
PRG063_MissileAim_Vel:
	.byte $00, $00, $01, $01, $02, $01, $01, $00, $00, $01, $02, $03, $04, $03, $02, $01
	.byte $00, $02, $04, $05, $06, $05, $04, $02



PRG063_WeaponConsumeEnergy:
	; Backup 'Y'
	TYA
	PHA
	
	LDY <Player_CurWeapon
	
	LDA Player_HP,Y
	AND #$7F
	SUB PRG063_WeaponShotCost,Y
	BCS PRG063_FD86

	LDA #$00

PRG063_FD86:
	ORA #$80	; Set "have it" bit
	STA Player_HP,Y
	
	; Restore 'Y'
	PLA
	TAY
	
	RTS	; $FD8D


	; Amount of energy units deducted per weapon fire
PRG063_WeaponShotCost:
	.byte $00	; 0 Mega Buster
	.byte $02	; 1 Rush Coil
	.byte $01	; 2 Rush Jet
	.byte $01	; 3 Rush Marine
	.byte $04	; 4 Toad Rain
	.byte $02	; 5 Wire Adapter
	.byte $02	; 6 Balloon
	.byte $01	; 7 Dive Missile
	.byte $01	; 8 Ring Boomerang
	.byte $01	; 9 Drill Bomb
	.byte $01	; 10 Dust
	.byte $01	; 11 Pharaoh Shot
	.byte $04	; 12 Flash Stopper
	.byte $02	; 13 Skull Barrier


	; PRG063_InitBossMus_Plyr_RetX:
	;	- Start appropriate boss music
	;	- Set Player state for boss waiting once they safely land
	;	- Returns boss's index in 'X'
PRG063_InitBossMus_Plyr_RetX:
	LDA <TileMap_Index
	CMP #TMAP_WILY4
	BNE PRG063_FDAE	; If this is not Wily 4, jump to PRG063_FDAE

	LDA #MUS_FINALBOSS
	CMP <Mus_Cur
	BEQ PRG063_FDB7	; If final boss music is playing, jump to PRG063_FDB7

	; Queue final boss music!
	JSR PRG063_QueueMusSnd_SetMus_Cur

	JMP PRG063_FDB7	; Jump to PRG063_FDB7


PRG063_FDAE:
	LDA #MUS_BOSS
	CMP <Mus_Cur
	BEQ PRG063_FDB7	; If boss music is playing, jump to PRG063_FDB7

	; Queue boss music!
	JSR PRG063_QueueMusSnd_SetMus_Cur


PRG063_FDB7:
	LDA <Player_State
	CMP #PLAYERSTATE_BOSSWAIT
	BEQ PRG063_FDCC	; If Player is waiting on boss, jump to PRG063_FDCC (RTS)

	LDA <Player_State
	BNE PRG063_FDCC		; If Player is not standing, jump to PRG063_FDCC (RTS)

	; Player is ready to start boss wait state...

	STA <Raster_VSplit_HPosReq	; Raster_VSplit_HPosReq = 0
	STA <PPU_CTL1_PageBaseReq_RVBoss				; PPU_CTL1_PageBaseReq_RVBoss = 0
	
	; Player_State = PLAYERSTATE_BOSSWAIT
	LDA #PLAYERSTATE_BOSSWAIT
	STA <Player_State
	
	STX Boss_SprIndex	; Boss_SprIndex = X

PRG063_FDCC:
	RTS	; $FDCC


PRG063_DoIntroStory:
	; Put page 27 at $8000
	LDA #27
	STA <MMC3_Page8000_Req
	JSR PRG063_SetPRGBanks

	JSR PRG027_DoIntroStory_Ind

	; Put page 57 at $8000
	LDA #57
	STA <MMC3_Page8000_Req
	JMP PRG063_SetPRGBanks

	; Deletes Player's projectiles and Rush, as present
PRG063_DeletePlayerObjs:
	LDY #$04	; Y = $04

PRG063_FDE0:
	JSR PRG063_DeleteObjectY	; DELETE IT

	DEY	; Y--
	BNE PRG063_FDE0	; While Y > 0, loop

	RTS	; $FDE6

	; CHECKME - UNUSED?
	.byte $10, $8A, $04, $0B, $44, $39, $04, $19, $11, $00, $D0, $64, $00, $04, $54, $E9	; $FDE7 - $FDF6
	.byte $10, $01, $44, $02, $01, $26, $02, $84, $40	; $FDF7 - $FDFF



IntReset:
	SEI	; $FE00
	CLD	; $FE01
	
	LDA #%00001000
	STA PPU_CTL1	; PT2
	
	LDA #%01000000
	STA FRAMECTR_CTL	; Disable IRQs
	
	LDX #$00
	STX PPU_CTL2	; Disable display
	STX PAPU_MODCTL	; Clear DMC
	STX PAPU_EN		; Disable all sound
	
	; Reset stack
	DEX	; X = $FF
	TXS

	; Wait for 4 frames to pass (?)
	LDX #$04	; $FE19
PRG063_FE1B:
	; Waiting for VBlank to start
	LDA PPU_STAT	; $FE1B
	BPL PRG063_FE1B	; $FE1E

	; Waiting for VBlank to end
PRG063_FE20:
	LDA PPU_STAT	; $FE20
	BMI PRG063_FE20	; $FE23

	DEX	; X--
	BNE PRG063_FE1B	; While X <> 0, loop
	

	; PPU reset junk
	LDA PPU_STAT
	
	LDA #$10
	TAY
PRG063_FE2E:
	STA PPU_VRAM_ADDR
	STA PPU_VRAM_ADDR
	
	EOR #$10
	
	DEY	; Y--
	BNE PRG063_FE2E	; While Y > 0, loop
	

	; All RAM clear loop ($x00, $xFF to x01)
	; Y = 0
	TYA	; A = 0
PRG063_FE3A:
	STA Temp_Var0,Y
	STA Spr_NoRespawnBits,Y
	STA Sprite_RAM+$00,Y
	STA Spr_SlotID+$00,Y
	STA Spr_YVel+$10,Y
	STA Spr_Var7+$08,Y
	STA PalData_1,Y
	STA Sound_TrackPatch,Y
	
	DEY	; Y--
	BNE PRG063_FE3A	; Loop


	; Setting sound trigger RAM slots to $88
	LDX #$07
	LDA #$88
PRG063_FE59:
	STA <Sound_Trigger,X
	
	DEX	; X--
	BPL PRG063_FE59	; While X >= 0, loop!


	LDA #%00011000
	STA <PPU_CTL2_Copy	; Show BG/sprites
	
	; Vertical mirroring
	LDA #$01
	STA MMC3_MIRROR
	
	; Set banks 60 and 61 at $8000 and $A000
	LDX #60	
	STX <MMC3_Page8000_Req
	INX	; 61
	STX <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks


	; Initialize the MMC3 to use the CHR RAM (basically just sets the pages to logical order)
	LDX #MMC3_1K_TO_PPU_1C00	; X = 5 (MMC3_1K_TO_PPU_1C00)
PRG063_FE73:
	STX MMC3_COMMAND
	
	; Set CHR page
	LDA PRG063_CHRPages,X
	STA MMC3_PAGE
	
	DEX	; X--
	BPL PRG063_FE73	; While X >= 0, loop

	; Reset sprites
	JSR PRG062_ResetSprites

	; Clear Nametable 0
	LDA #$20
	LDX #$00
	LDY #$00
	JSR PRG062_ClearVRAM

	; Clear Nametable 1
	LDA #$24
	LDX #$00
	LDY #$00
	JSR PRG062_ClearVRAM

	LDA #HIGH(PRG062_C50C)
	STA <Temp_AddrH
	LDA #LOW(PRG062_C50C)
	STA <Temp_AddrL
	
	; Put PRG062_C50C into exec slot 0
	LDA #$00
	JSR PRG063_LoadExecSlot

	; Sprites in PT2 + Generate VBlank
	LDA #$88
	STA <PPU_CTL1_Copy


PRG063_ProcessExecSlots:
	; Reset stack
	LDX #$FF
	TXS

	; This loops until one of the exec slots has a flag value >= 4
PRG063_FEA8:
	LDX #$00	; $FEA8
	STX <RAM_0090	; $FEAA
	
	; For all exec slots...
	LDY #$04	; Y = 4 (iterating all exec slots)
PRG063_FEAE:
	LDA <ExecState_Slots,X
	CMP #$04
	BGE PRG063_FEBE		; If exec slot flag >= 4, jump to PRG063_FEBE

	INX
	INX
	INX
	INX	; X += 4 (next exec slot)
	
	DEY	; Y--
	BNE PRG063_FEAE	; While Y <> 0, loop!

	JMP PRG063_FEA8	; Loop


PRG063_FEBE:

	LDA <RAM_0090	; $FEBE
	BNE PRG063_FEA8	; $FEC0 FIXME this is a temp flag that does something and jumps back to PRG063_FEA8

	DEY	; Y-- (make into slot index... they could've just looped using a 0-based index, but whatever)
	TYA
	EOR #$03	; Flip to "opposite end" slot (0 -> 3, 1 -> 2, etc.)
	STA <ExecState_SlotDepth	; -> ExecState_SlotDepth
	
	LDY <ExecState_Slots,X	; Get exec slot flag
	
	; Change exec slot flag to 2
	LDA #$02
	STA <ExecState_Slots,X
	
	CPY #$08
	BNE PRG063_FEDD	; If exec slot flag was not previously 8, jump to PRG063_FEDD

	; Exec slot flag was previously 8; load jump address -> Temp_AddrL/H and do it!
	LDA <ExecState_Slots+2,X
	STA <Temp_AddrL
	LDA <ExecState_Slots+3,X
	STA <Temp_AddrH
	
	JMP [Temp_AddrL]


PRG063_FEDD:

	; Exec slot flag was 4
	
	; Restore the stack pointer value held in this slot
	LDA <ExecState_Slots+2,X
	TAX
	TXS
	
	LDA <ExecState_SlotDepth
	BNE PRG063_FEE8

	; Only update controllers if ExecState_SlotDepth = 0
	JSR PRG062_UpdControllers

PRG063_FEE8:

	; Restore X/Y
	PLA
	TAY
	PLA
	TAX
	
	RTS


PRG063_LoadExecSlot:
	JSR PRG063_ExecStateSlot_CalcIndex	; X = A * 4

	; Load Temp_AddrL/H into ExecState_Slots+2 slot
	LDA <Temp_AddrL
	STA <ExecState_Slots+2,X
	LDA <Temp_AddrH
	STA <ExecState_Slots+3,X
	
	; Exec slot flag 8
	LDA #$08
	STA <ExecState_Slots,X
	
	RTS	; $FEFC

	; CHECKME - UNUSED?

	; $FEFD
	JSR PRG063_ExecStateSlot_CalcIndex	; X = A * 4
	
	LDA #$00
	STA <ExecState_Slots,X
	RTS

	; CHECKME - UNUSED?
	
	; $FF05
	JSR PRG063_ExecStateSlot_GetIndex	; X = ExecState_SlotDepth * 4
	
	LDA #$00
	STA <ExecState_Slots,X
	JMP PRG063_ProcessExecSlots


PRG063_ExecStateSlot_GetIndex:
	LDA <ExecState_SlotDepth	; $FF0F

	; Multiplies 'A' by 4 and puts it into X
PRG063_ExecStateSlot_CalcIndex:
	ASL A
	ASL A
	TAX	
	RTS	

	; Shortcut for performing 'X' frame updates (repeat calls to PRG063_UpdateOneFrame)
PRG063_UpdateMultipleFrames:
	JSR PRG063_UpdateOneFrame

	DEX
	BNE PRG063_UpdateMultipleFrames

	RTS


	; Performs a frame update; this is typically called in a game loop of some sort.
PRG063_UpdateOneFrame:

	; Kind of a dumb operation here; all this seems to do is a long-winded storage of $01...
	LDA #$01
	STA <Temp_AddrL
	
	; Backup X/Y
	TXA
	PHA
	TYA
	PHA
	
	JSR PRG063_ExecStateSlot_GetIndex	; $FF24

	; Set exec slot offset 1 (FIXME?) to 1
	LDA <Temp_AddrL		; This just equates to $01 no matter what... ??
	STA <ExecState_Slots+1,X
	
	; Set exec slot flag to 1
	LDA #$01
	STA <ExecState_Slots,X
	
	; Transfer exec slot index -> Y
	TXA
	TAY
	
	; Backing up the stack pointer into exec slot
	TSX
	STX <ExecState_Slots+2,Y
	
	JMP PRG063_ProcessExecSlots


	; Set banks at $8000 and $A000 to pages specified in MMC3_Page8000_Req and MMC3_PageA000_Req
PRG063_SetPRGBanks:	; $FF37
	INC <MMC3_PageChng_InP	; MMC3_PageChng_InP = 1
	
	LDA #MMC3_8K_TO_PRG_8000
	STA <MMC3_PrevCmd
	STA MMC3_COMMAND
	
	LDA <MMC3_Page8000_Req
	STA <MMC3_Page8000
	STA MMC3_PAGE
	
	LDA #MMC3_8K_TO_PRG_A000
	STA <MMC3_PrevCmd
	STA MMC3_COMMAND
	
	LDA <MMC3_PageA000_Req
	STA <MMC3_PageA000
	STA MMC3_PAGE
	
	DEC <MMC3_PageChng_InP	; MMC3_PageChng_InP = 0
	
	LDA <MusSnd_NeedsUpdateInt
	BNE PRG063_DoUpdateMusSnd	; If a sound/music update was requested (but aborted due to page switch in progress), jump to PRG063_DoUpdateMusSnd

	RTS	; $FF5B


PRG063_DoUpdateMusSnd:
	LDA <MMC3_PageChng_InP
	BNE PRG063_FFAA	; If a page change is in progress, jump to PRG063_FFAA

	; Set page 30 @ $8000
	LDA #MMC3_8K_TO_PRG_8000
	STA MMC3_COMMAND
	LDA #30
	STA MMC3_PAGE
	
	; Set page 31 @ $A000
	LDA #MMC3_8K_TO_PRG_A000
	STA MMC3_COMMAND
	LDA #31
	STA MMC3_PAGE

PRG063_FF74:
	; Backup X/Y -> RAM_00ED/RAM_00EE
	STX <RAM_00ED
	STY <RAM_00EE
	
	LDX <MusSnd_ProcessTriggerCurIdx	; X = MusSnd_ProcessTriggerCurIdx
	
	LDA <Sound_Trigger,X
	CMP #$88
	BEQ PRG063_UpdateMusSnd	; If this sound slot is idle, jump to PRG063_UpdateMusSnd

	; Sound trigger in slot

	PHA	; Backup trigger value
	
	; Reset to idle value
	LDA #$88
	STA <Sound_Trigger,X
	
	; Advance to next trigger index
	INX	; X++
	
	; Wrap 0-7
	TXA
	AND #$07
	STA <MusSnd_ProcessTriggerCurIdx
	
	PLA	; Restore trigger value
	
	CMP #MUS_PARTIALMUTE
	BNE PRG063_TriggerMusSnd	; If this is NOT the music partial mute trigger, jump to PRG063_TriggerMusSnd

	; "Partial mute" trigger...
	LDY #$14	; Y = $14

PRG063_TriggerMusSnd:
	JSR PRG030_TriggerMusSnd_Ind

	; Restore X/Y
	LDX <RAM_00ED
	LDY <RAM_00EE
	
	JMP PRG063_FF74	; Jump to PRG063_FF74


PRG063_UpdateMusSnd:
	JSR PRG030_UpdateMusSnd_Ind

	; MusSnd_NeedsUpdateInt = 0 (update complete)
	LDA #$00
	STA <MusSnd_NeedsUpdateInt
	
	; Restore X/Y
	LDX <RAM_00ED
	LDY <RAM_00EE
	
	JMP PRG063_SetPRGBanks	; $FFA7


PRG063_FFAA:
	; Can't do the sound/music update yet due to page change in progress, so flag it needs done
	INC <MusSnd_NeedsUpdateInt
	RTS	; $FFAC


PRG063_CHRPages:
	; Static CHR page settings since this game uses CHRRAM; just spreads it evenly over the CHRRAM
	.byte $00, $02, $04, $05, $06, $07	; $FFAD - $FFB2


	; CHECKME - UNUSED?
	.byte $04, $12, $40, $08, $15, $81, $C1, $C8, $41, $80, $05, $10, $45, $B7, $04, $1F	; $FFB3 - $FFC2
	.byte $44, $20, $04, $E4, $10, $19, $40, $58, $40, $E8, $00, $78, $00, $20, $00, $48	; $FFC3 - $FFD2
	.byte $00, $20, $40, $00, $50, $0B, $00, $00, $10, $18, $00, $64, $41, $42, $50, $50	; $FFD3 - $FFE2
	.byte $44, $08, $40, $80, $50, $40, $54, $08, $14, $80, $00, $44, $00, $8B, $66, $00	; $FFE3 - $FFF2
	.byte $00, $58, $04, $00, $00, $08, $9C	; $FFF3 - $FFF9



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VECTORS
; Must appear at $FFFA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .org $FFFA
.Vector_Table:
    .word IntNMI    ; $FFFA - NMI Interrupt (VBlank)
    .word IntReset  ; $FFFC - Reset Interrupt (boot up)
    .word IntIRQ    ; $FFFE - IRQ Interrupt (scanline from MMC3)



