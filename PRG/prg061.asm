PRG061_Obj_RMRainbowCtl1:	; $20
PRG061_Obj_RMRainbowCtl2:	; $21
PRG061_Obj_RMRainbowCtl3:	; $22
PRG061_Obj_RMRainbowCtl4:	; $23
	
	LDA Spr_SlotID+$00,X	; Entry ID is $20-$23
	AND #$03	; 0-3
	ASL A		; 0,2,4,6
	ASL A		; 0,4,8,12
	ASL A		; 0,8,16,24
	
	LDY Spr_XHi+$00,X	; The screen the controller resides on -> 'Y'
	ADC PRG061_RMRCtl_OffsetByScr,Y	; Add the offset to the particular controller
	TAY	; -> 'Y' (PRG061_RMRCtl_ScreenData)
	
	; Set Flags2
	LDA PRG061_RMRCtl_ScreenData+6,Y
	STA Spr_Flags2+$00,X
	
	; Set X
	LDA PRG061_RMRCtl_ScreenData+2,Y
	STA Spr_X+$00,X
	
	JSR PRG063_TestPlayerObjCollide
	BCS PRG061_A033	; If Player is not touching rainbow platform controller, jump to PRG061_A033 (RTS)

	; Set Player on top of rainbow platform
	LDA Spr_Y+$00
	SUB Spr_Y+$00,X
	BCS PRG061_A033	; If didn't underflow, jump to PRG061_A033 (RTS)

	; Looking for a free rainbow platform controller slot
	LDY #$03	; Y = 3
PRG061_A02B:
	LDA RingManRainbowPlat_Data+$00,Y
	BPL PRG061_A034	; If bit 7 is not set, jump to PRG061_A034

	DEY	; Y--
	BPL PRG061_A02B	; $A031


PRG061_A033:
	RTS	; $A033


PRG061_A034:
	STY <Temp_Var0	; Backup RingManRainbowPlat_Data index -> Temp_Var0
	
	; Store RingManRainbowPlat_Data index -> Spr_YVel (which is not used otherwise)
	TYA
	STA Spr_YVel+$00,X
	
	LDA Spr_SlotID+$00,X	; Entry ID is $20-$23
	AND #$03	; 0-3
	ASL A		; 0,2,4,6
	ASL A		; 0,4,8,12
	ASL A		; 0,8,16,24
	
	LDY Spr_XHi+$00,X	; The screen the controller resides on -> 'Y'
	ADC PRG061_RMRCtl_OffsetByScr,Y	; Add the offset to the particular controller
	TAY	; -> 'Y' (PRG061_RMRCtl_ScreenData)
	
	STY <Temp_Var1	; Backup offset -> Temp_Var1
	
	LDA PRG061_RMRCtl_ScreenData+7,Y
	STA Spr_X+$00,X
	
	; Spr_Var1 = 0
	LDA #$00
	STA Spr_Var1+$00,X
	
	; Push VRAM addres
	LDA PRG061_RMRCtl_ScreenData,Y
	PHA
	LDA PRG061_RMRCtl_ScreenData+1,Y
	PHA
	
	; VRAM Address low -> Spr_Var5
	STA Spr_Var5+$00,X
	
	LDY <Temp_Var0	; Y = RingManRainbowPlat_Data index
	
	; Set RingManRainbowPlat_Data
	LDA #$80			; Enabling bit
	ORA Spr_XHi+$00,X	; Active screen
	STA RingManRainbowPlat_Data+$00,Y
	
	LDA #$00
	STA Spr_Var2+$00,X					; Spr_Var2 = 0
	STA RingManRainbowPlat_Cnt+$00,Y	; RingManRainbowPlat_Cnt = 0
	
	; Set VRAM address
	PLA
	STA RingManRainbowPlat_VL+$00,Y
	PLA
	STA RingManRainbowPlat_VH+$00,Y
	
	LDY <Temp_Var1	; Y = PRG061_RMRCtl_ScreenData offset
	
	; Set Spr_Var3
	LDA PRG061_RMRCtl_ScreenData+3,Y
	STA Spr_Var3+$00,X
	
	; Set Spr_Var4 / Spr_HP
	LDA PRG061_RMRCtl_ScreenData+5,Y
	STA Spr_Var4+$00,X
	STA Spr_HP+$00,X
	
	; Set Spr_Var6
	LDA PRG061_RMRCtl_ScreenData+6,Y
	STA Spr_Var6+$00,X
	
	; Spr_Var7 = 0
	LDA #$00
	STA Spr_Var7+$00,X
	
	; Set bounding box $01
	LDA #$01
	STA Spr_Flags2+$00,X
	
	LDA Spr_Flags+$00,X
	ORA #SPRFL1_OBJSOLID
	STA Spr_Flags+$00,X
	
	; Set Spr_FaceDir
	LDA PRG061_RMRCtl_ScreenData+4,Y
	STA Spr_FaceDir+$00,X
	
	AND #SPRDIR_LEFT
	TAY	; -> 'Y' (0 if right, 2 if left)
	
	; Store X -> Spr_Var8
	LDA Spr_X+$00,X
	STA Spr_Var8+$00,X
	
	; Offset -> Spr_YVelFracAccum/Spr_YVelFrac
	ADD PRG061_A333+1,Y	
	STA Spr_YVelFracAccum+$00,X
	STA Spr_YVelFrac+$00,X
	
	JSR PRG063_SetObjFlipForFaceDir

	LDA #LOW(PRG061_Obj_RMRainbowCtl_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_RMRainbowCtl_Cont)
	STA Spr_CodePtrH+$00,X

PRG061_A0CA:
	RTS	; $A0CA

PRG061_Obj_RMRainbowCtl_Cont:
	LDA Spr_Var1+$00,X
	BEQ PRG061_A0D4	; If Spr_Var1 = 0, jump to PRG061_A0D4

	; CHECKME - UNUSED?
	DEC Spr_Var1,X		; Spr_Var1--
	RTS

PRG061_A0D4:
	
	; Save Spr_XVel
	LDA Spr_XVel+$00,X
	PHA
	
	LDA Spr_Flags+$00,X
	BMI PRG061_A0E2	; If object is on-screen, jump to PRG061_A0E2

	; Spr_XVel = $04
	LDA #$04
	STA Spr_XVel+$00,X

PRG061_A0E2:
	JSR PRG063_ApplyVelSetFaceDir

	; Restore Spr_XVel
	PLA
	STA Spr_XVel+$00,X
	
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BEQ PRG061_A0FA		; If going left, jump to PRG061_A0FA

	; Going right...

	LDA Spr_X+$00,X
	CMP Spr_YVelFracAccum+$00,X
	BLT PRG061_A0CA	; If haven't reached X target, jump to PRG061_A0CA (RTS)
	BGE PRG061_A102	; Otherwise, jump to PRG061_A102


PRG061_A0FA:
	; Going left...

	LDA Spr_YVelFracAccum+$00,X
	CMP Spr_X+$00,X
	BLT PRG061_A0CA	; If haven't reached X target, jump to PRG061_A0CA (RTS)

PRG061_A102:
	; Reached X target...

	LDA <CommitGBuf_Flag
	ORA <CommitGBuf_FlagV
	BEQ PRG061_A10A	; If no graphics being committed, jump to PRG061_A10A
	BNE PRG061_A0CA	; Otherwise, jump to PRG061_A0CA (RTS)


PRG061_A10A:
	; Reached X target, ready to commit graphics

	LDA Spr_Var6+$00,X
	CMP Spr_Var7+$00,X
	BEQ PRG061_A167	; If Spr_Var6 = Spr_Var7, jump to PRG061_A167

	LDA Spr_Var4+$00,X
	AND #$07
	TAY		; Y = 0 to 7
	
	LDA PRG063_IndexToBit,Y
	STA <Temp_Var0	; converted bit -> Temp_Var0
	
	JSR PRG061_RMRCtl_CalcSTMDOff

	; Set bit in Level_ScreenTileModData
	LDA Level_ScreenTileModData+$00,Y
	ORA <Temp_Var0
	STA Level_ScreenTileModData+$00,Y

PRG061_A128:
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_LEFT
	TAY		; -> 'Y' (0 if right, 2 if left)
	
	LDA Spr_Var4+$00,X
	ADD PRG061_A337,Y
	STA Spr_Var4+$00,X
	
	LDA PRG061_A333,Y
	STA <Temp_Var0			; VRAM low offset
	LDA PRG061_A333+1,Y
	STA <Temp_Var1
	
	LDY Spr_YVel+$00,X		; Y = RingManRainbowPlat_Data (special stupid use of Spr_YVel)
	
	LDA RingManRainbowPlat_VL+$00,Y
	ADD <Temp_Var0
	STA RingManRainbowPlat_VL+$00,Y
	
	LDA Spr_X+$00,X
	ADD <Temp_Var1
	AND #$F0
	ORA #$08
	STA Spr_YVelFracAccum+$00,X
	
	INC Spr_Var7+$00,X	; Spr_Var7++
	
	; Need update
	LDA RingManRainbowPlat_Data+$00,Y
	ORA #$40
	STA RingManRainbowPlat_Data+$00,Y
	
	RTS	; $A166


PRG061_A167:
	LDA #LOW(PRG061_A1A4)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_A1A4)
	STA Spr_CodePtrH+$00,X
	
	LDY Spr_YVel+$00,X	; $A171
	
	; RingManRainbowPlat_Cnt = Spr_Var3
	LDA Spr_Var3+$00,X
	STA RingManRainbowPlat_Cnt+$00,Y
	
	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM4_RMRBC_UGLY
	BEQ PRG061_A186	; If doing the "ugly" animation, jump to PRG061_A186

	; Second stage regenerationg
	LDA #SPRANM4_RMRBC_PRETTY2
	JSR PRG063_SetSpriteAnim


PRG061_A186:
	; Reset for regeneration
	LDA Spr_Var5+$00,X
	STA RingManRainbowPlat_VL+$00,Y
	LDA Spr_Var8+$00,X
	STA Spr_X+$00,X
	LDA Spr_YVelFrac+$00,X
	STA Spr_YVelFracAccum+$00,X
	LDA Spr_HP+$00,X
	STA Spr_Var4+$00,X
	LDA #$00
	STA Spr_Var7+$00,X
	
PRG061_A1A3:
	RTS	; $A1A3

PRG061_A1A4:
	LDA Spr_Var1+$00,X
	BEQ PRG061_A1AD	; If Spr_Var1 = 0, jump to PRG061_A1AD

	; CHECKME - UNUSED?
	DEC Spr_Var1,X		; Spr_Var1--
	RTS

PRG061_A1AD:
	; Save Spr_XVel
	LDA Spr_XVel+$00,X
	PHA
	
	LDA Spr_Flags+$00,X
	BMI PRG061_A1BB	; If object is on-screen, jump to PRG061_A1BB

	; Spr_XVel = $04
	LDA #$04
	STA Spr_XVel+$00,X

PRG061_A1BB:
	JSR PRG063_ApplyVelSetFaceDir

	; Restore Spr_XVel
	PLA
	STA Spr_XVel+$00,X
	
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BEQ PRG061_A1D3	; If going left, jump to PRG061_A1D3

	; Going right...

	LDA Spr_X+$00,X
	CMP Spr_YVelFracAccum+$00,X
	BLT PRG061_A1A3	; If haven't reached X target, jump to PRG061_A1A3 (RTS)
	BGE PRG061_A1DB	; Otherwise, jump to PRG061_A1DB


PRG061_A1D3:
	; Going left

	LDA Spr_YVelFracAccum+$00,X
	CMP Spr_X+$00,X
	BLT PRG061_A1A3	; If haven't reached X target, jump to PRG061_A1A3 (RTS)


PRG061_A1DB:
	; Reached X target...

	LDA <CommitGBuf_Flag	; $A1DB
	ORA <CommitGBuf_FlagV	; $A1DD
	BEQ PRG061_A1E3	; If no graphics being committed, jump to PRG061_A1E3
	BNE PRG061_A1A3	; Otherwise, jump to PRG061_A1A3 (RTS)


PRG061_A1E3:
	; Reached X target, ready to commit graphics

	LDA Spr_Var6+$00,X
	CMP Spr_Var7+$00,X
	BEQ PRG061_A204	; If Spr_Var6 = Spr_Var7, jump to PRG061_A204

	LDA Spr_Var4+$00,X
	AND #$07
	TAY		; Y = 0 to 7
	
	LDA PRG063_IndexToBit_Mask,Y
	STA <Temp_Var0	; converted bit -> Temp_Var0
	
	JSR PRG061_RMRCtl_CalcSTMDOff

	; Clear bit in Level_ScreenTileModData
	LDA Level_ScreenTileModData+$00,Y
	AND <Temp_Var0
	STA Level_ScreenTileModData+$00,Y
	
	JMP PRG061_A128	; Jump to PRG061_A128


PRG061_A204:
	LDA Spr_Flags+$00,X
	AND #~SPRFL1_OBJSOLID
	STA Spr_Flags+$00,X
	
	LDA #$00
	STA Spr_FaceDir+$00,X
	
	LDY Spr_YVel+$00,X
	
	; Clear the platform control data
	STA RingManRainbowPlat_Data+$00,Y
	
	; Reset to init mode
	LDA #LOW(PRG061_Obj_RMRainbowCtl1)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_RMRainbowCtl1)
	STA Spr_CodePtrH+$00,X
	
	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM4_RMRBC_UGLY
	BEQ PRG061_A22D

	; First stage erasing
	LDA #SPRANM4_RMRBC_PRETTY
	JSR PRG063_SetSpriteAnim

PRG061_A22D:
	RTS	; $A22D


	; Compute offset into Level_ScreenTileModData
PRG061_RMRCtl_CalcSTMDOff:
	CLC
	
	LDA <Level_SegCurData
	AND #$C0
	BNE PRG061_A239

	LDA Spr_XHi+$00,X
	LSR A

PRG061_A239:
	LDA Spr_Var4+$00,X
	ROR A
	LSR A
	LSR A
	TAY
	
	RTS	; $A240

	; CHECKME - UNUSED?
	LDA Spr_X,X
	SUB <Horz_Scroll
	LDA Spr_XHi,X
	SBC <Current_Screen
	BNE PRG061_A256
	LDA RingManRainbowPlat_Data,Y
	ORA #$40
	STA RingManRainbowPlat_Data,Y
PRG061_A256:
	RTS


PRG061_RMRCtl_OffsetByScr:
	.byte (PRG061_RMRCtl_Screen0 - PRG061_RMRCtl_ScreenData)
	.byte (PRG061_RMRCtl_Screen1 - PRG061_RMRCtl_ScreenData)
	.byte (PRG061_RMRCtl_Screen2 - PRG061_RMRCtl_ScreenData)
	.byte (PRG061_RMRCtl_Screen3 - PRG061_RMRCtl_ScreenData)
	.byte (PRG061_RMRCtl_Screen4 - PRG061_RMRCtl_ScreenData)
	.byte (PRG061_RMRCtl_Screen5 - PRG061_RMRCtl_ScreenData)
	.byte (PRG061_RMRCtl_Screen6 - PRG061_RMRCtl_ScreenData)
	.byte (PRG061_RMRCtl_Screen7 - PRG061_RMRCtl_ScreenData)
	.byte (PRG061_RMRCtl_Screen8 - PRG061_RMRCtl_ScreenData)
	.byte (PRG061_RMRCtl_Screen9 - PRG061_RMRCtl_ScreenData)
	.byte (PRG061_RMRCtl_Screen10 - PRG061_RMRCtl_ScreenData)
	.byte (PRG061_RMRCtl_Screen11 - PRG061_RMRCtl_ScreenData)
	.byte (PRG061_RMRCtl_Screen12 - PRG061_RMRCtl_ScreenData)
	.byte (PRG061_RMRCtl_Screen13 - PRG061_RMRCtl_ScreenData)
	.byte (PRG061_RMRCtl_Screen14 - PRG061_RMRCtl_ScreenData)
	.byte (PRG061_RMRCtl_Screen15 - PRG061_RMRCtl_ScreenData)
	.byte (PRG061_RMRCtl_Screen16 - PRG061_RMRCtl_ScreenData)
	.byte (PRG061_RMRCtl_Screen17 - PRG061_RMRCtl_ScreenData)
	.byte (PRG061_RMRCtl_Screen18 - PRG061_RMRCtl_ScreenData)
	.byte (PRG061_RMRCtl_Screen19 - PRG061_RMRCtl_ScreenData)
	

;+0/1 VRAM
;+2 Spr_X
;+3 Var3
;+4 FaceDir
;+5 Var4
;+6 Flags2
;+7 Spr_X End?

PRG061_RMRCtl_ScreenData:
PRG061_RMRCtl_Screen0:
	; Controller 1
	vaddr $214A
	.byte $90, $09, SPRDIR_RIGHT, $56, $06, $58

PRG061_RMRCtl_Screen1:
	; Controller 1
	vaddr $22D4
	.byte $70, $09, SPRDIR_LEFT, $B9, $06, $A8
	
	; Controller 2
	vaddr $214C
	.byte $98, $09, SPRDIR_RIGHT, $57, $05, $68

PRG061_RMRCtl_Screen2:
	; Controller 1
	vaddr $2316
	.byte $A0, $09, SPRDIR_LEFT, $CA, $02, $B8
	
	; Controller 2
	vaddr $228E
	.byte $60, $09, SPRDIR_LEFT, $A6, $02, $78
	
	; Controller 3
	vaddr $214C
	.byte $90, $09, SPRDIR_RIGHT, $57, $04, $68

PRG061_RMRCtl_Screen3:
	; Controller 1
	vaddr $22D4
	.byte $88, $09, SPRDIR_LEFT, $B9, $03, $A8
	
	; Controller 2
	vaddr $224A
	.byte $40, $09, SPRDIR_LEFT, $94, $02, $58
	
	; Controller 3
	vaddr $2210
	.byte $A0, $09, SPRDIR_RIGHT, $89, $02, $88
	
	; Controller 4
	vaddr $2114
	.byte $78, $09, SPRDIR_LEFT, $49, $05, $A8

PRG061_RMRCtl_Screen4:
	; Controller 1
	vaddr $22CA
	.byte $88, $09, SPRDIR_RIGHT, $B6, $05, $58

PRG061_RMRCtl_Screen5:
PRG061_RMRCtl_Screen6:
	; Controller 1
	vaddr $228E
	.byte $B8, $09, SPRDIR_RIGHT, $A8, $07, $78

PRG061_RMRCtl_Screen7:
	; Controller 1
	vaddr $2202
	.byte $48, $09, SPRDIR_RIGHT, $82, $05, $18
	
	; Controller 2
	vaddr $228E
	.byte $B8, $09, SPRDIR_RIGHT, $A8, $07, $78
	
	; Controller 3
	vaddr $2194
	.byte $D0, $09, SPRDIR_RIGHT, $6B, $04, $A8

PRG061_RMRCtl_Screen8:
	; Controller 1
	vaddr $2204
	.byte $58, $09, SPRDIR_RIGHT, $83, $06, $28
	
	; Controller 2
	vaddr $2294
	.byte $C8, $09, SPRDIR_RIGHT, $AB, $03, $A8

PRG061_RMRCtl_Screen9:
PRG061_RMRCtl_Screen10:
PRG061_RMRCtl_Screen11:
PRG061_RMRCtl_Screen12:
PRG061_RMRCtl_Screen13:
PRG061_RMRCtl_Screen14:
	; Controller 1
	vaddr $229A
	.byte $A0, $8C, SPRDIR_LEFT, $AC, $06, $D8
	
	; Controller 2
	vaddr $215E
	.byte $B0, $8C, SPRDIR_LEFT, $5E, $08, $F8

PRG061_RMRCtl_Screen15:
	; Controller 1
	vaddr $22CE
	.byte $40, $8C, SPRDIR_LEFT, $B6, $06, $78
	
	; Controller 2
	vaddr $20D6
	.byte $70, $8C, SPRDIR_LEFT, $3A, $08, $B8
	
	; Controller 3
	vaddr $221E
	.byte $C0, $8C, SPRDIR_LEFT, $8E, $06, $F8

PRG061_RMRCtl_Screen16:
	; Controller 1
	vaddr $2152
	.byte $50, $8C, SPRDIR_LEFT, $58, $08, $98
	
	; Controller 2
	vaddr $22DE
	.byte $B0, $8C, SPRDIR_LEFT, $BE, $08, $F8

PRG061_RMRCtl_Screen17:
PRG061_RMRCtl_Screen18:
PRG061_RMRCtl_Screen19:

	; Controller 1
	vaddr $219A
	.byte $88, $8C, SPRDIR_LEFT, $6C, $09, $D8


PRG061_A333:
	.byte $02, $10	; Right
	.byte $FE, $F0	; Left
	
PRG061_A337:
	.byte $01, $00
	.byte $FF, $00


PRG061_Obj_SubBoss_Kabatoncue:
	JSR PRG061_SetPlayerBossWait

	; Load screen $1A into "other" side of BG
	LDA #$80
	STA <CommitBG_Flag
	LDA #$1A
	STA <CommitBG_ScrSel
	
	LDA #LOW(PRG061_Obj_SubBoss_KabatoncueT)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_SubBoss_KabatoncueT)
	STA Spr_CodePtrH+$00,X

PRG061_A350:
	LDA #$00
	STA Spr_AnimTicks+$00,X

PRG061_A355:
	RTS	; $A355


PRG061_Obj_SubBoss_KabatoncueT:
	LDA <Raster_VMode
	BNE PRG061_A364	; If raster mode is active, jump to PRG061_A364

	; Raster mode not active

	LDA <CommitBG_Flag
	BNE PRG061_A355	; If CommitBG_Flag <> 0, jump to PRG061_A355

	STA <IntIRQ_FS1_HScrl	; IntIRQ_FS1_HScrl = 0
	
	INC <Raster_VMode	; Raster_VMode = 1
	BNE PRG061_A3D4	; Jump (technically always) to PRG061_A3D4


PRG061_A364:
	JSR PRG061_SetPlayerBossWait

	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM4_KABATONCUE_T
	BEQ PRG061_A397	; If Kabantoncue is already here, jump to PRG061_A397

	LDA Spr_YVelFracAccum+$00,X
	SUB #$80
	STA Spr_YVelFracAccum+$00,X
	
	LDA Spr_Y+$00,X
	SBC #$00
	STA Spr_Y+$00,X
	
	CMP #$44
	BNE PRG061_A3D4	; If Kabatoncue is not low enough, jump to PRG061_A3D4 (PRG061_A40D)

	; Set animation
	LDA #SPRANM4_KABATONCUE_T
	JSR PRG063_SetSpriteAnim

	LDA Spr_Flags+$00,X
	AND #~SPRFL1_NODRAW
	STA Spr_Flags+$00,X
	
	; Spr_Y = 0
	LDA #$00
	STA Spr_Y+$00,X
	
	BEQ PRG061_A355	; Jump (technically always) to PRG061_A355


PRG061_A397:
	JSR PRG063_DoMoveSimpleVert

	LDA #$44
	CMP Spr_Y+$00,X
	BGE PRG061_A350	; If Kabantoncue is too high, jump to PRG061_A350

	STA Spr_Y+$00,X	; Lock at $44
	
	LDA Spr_Frame+$00,X
	CMP #$03
	BNE PRG061_A415	; If frame <> 3, jump to PRG061_A415

	; Kabatoncue finished teleporting and landed
	LDA #SPRANM4_KABATONCUE_IDLE
	JSR PRG063_SetSpriteAnim

	LDY #$03	; Y = $03
PRG061_A3B2:
	LDA PRG061_Kabatoncue_Pal,Y
	STA PalData_1,Y
	STA PalData_2,Y
	
	DEY	; Y--
	BNE PRG061_A3B2	; While Y > 0, loop

	; Commit palette
	LDY #$0F
	STY <CommitPal_Flag
	
	LDA Spr_Flags+$16
	AND #~$04
	STA Spr_Flags+$16
	
	LDA #LOW(PRG061_Obj_SubBoss_KabatoncueC)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_SubBoss_KabatoncueC)
	STA Spr_CodePtrH+$00,X

PRG061_A3D4:
	JMP PRG061_A40D	; Jump to PRG061_A40D
	

PRG061_Obj_SubBoss_KabatoncueC:

	; Annimation hold
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	LDA Spr_Var2+$00,X
	INC Spr_Var2+$00,X	; Spr_Var2++
	CMP #$03
	BGE PRG061_A3EB	; If Spr_Var2 >= 3, jump to PRG061_A3EB

	INC Spr_Y+$00,X		; Spr_Y++
	BNE PRG061_A3EE		; Jump (technically always) to PRG061_A3EE


PRG061_A3EB:
	DEC Spr_Y+$00,X		; Spr_Y--

PRG061_A3EE:
	; Force slot $16 Y
	LDA Spr_Y+$00,X
	STA Spr_Y+$16
	
	LDA Spr_Var2+$00,X
	CMP #$06
	BNE PRG061_A40D	; If Spr_Var2 <> 6, jump to PRG061_A40D

	LDA #LOW(PRG061_Obj_SubBoss_KabatoncueI)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_SubBoss_KabatoncueI)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var2 = $3C
	LDA #$3C
	STA Spr_Var2+$00,X
	
	JSR PRG061_SetPlayerStandState	; $A40A


PRG061_A40D:
	LDA Spr_Y+$00,X	
	SUB #$24
	STA <Raster_VSplit_Req

PRG061_A415:
	RTS	; $A415

PRG061_Obj_SubBoss_KabatoncueI:
	LDA Spr_AnimTicks+$00,X
	BNE PRG061_A479	; If animation ticks <> 0, jump to PRG061_A479

	LDA Spr_Frame+$00,X
	CMP #$06
	BEQ PRG061_A426	; If frame <> 6, jump to PRG061_A426

	CMP #$08
	BNE PRG061_A479	; If frame <> 8, jump to PRG061_A479


PRG061_A426:
	; Temp_Var17 = 0
	LDA #$00
	STA <Temp_Var17
	
	LDY #$17	; Y = $17
PRG061_A42C:
	LDA Spr_SlotID+$00,Y
	CMP #SPRSLOTID_KABATONCUE_MISSILE
	BNE PRG061_A435	; If this is not one of Kabatoncue's missiles, jump to PRG061_A435

	INC <Temp_Var17	; Temp_Var17++ (counting missiles)

PRG061_A435:
	DEY	; Y--
	CPY #$07
	BNE PRG061_A42C	; While Y > 7, loop

	LDA <Temp_Var17
	CMP #$02
	BEQ PRG061_A479	; If Temp_Var17 = 2, jump to PRG061_A479

	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG061_A479	; If no free slot, jump to PRG061_A479

	; Projectile init index $10
	LDA #$10
	STA <Temp_Var16
	JSR PRG063_InitProjectile

	; Kabatoncue's missile
	LDA #SPRSLOTID_KABATONCUE_MISSILE
	STA Spr_SlotID+$00,Y
	
	; Bounding box $0E, shootable, hurts
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $0E)
	STA Spr_Flags2+$00,Y
	
	; HP = 1
	LDA #$01
	STA Spr_HP+$00,Y
	
	; Spr_Var1 = $40
	LDA #$40
	STA Spr_Var1+$00,Y
	
	; Spr_Var2 = $01
	LDA #$01
	STA Spr_Var2+$00,Y
	
	; Spr_Var4 = $0C
	LDA #$0C
	STA Spr_Var4+$00,Y
	
	; Direction left
	LDA #SPRDIR_LEFT
	STA Spr_FaceDir+$00,Y
	
	; Velocity
	LDA #$00
	STA Spr_XVelFrac+$00,Y
	LDA #$02
	STA Spr_XVel+$00,Y

PRG061_A479:
	STX <Temp_Var4	; Backup index -> Temp_Var4
	
	LDX #$15	; X = $15
PRG061_A47D:
	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM4_KABATONCUE_BLKB
	BNE PRG061_A491	; If this isn't a shot out block, jump to PRG061_A491

	; Shot out block...

	LDA Spr_Frame+$00,X
	CMP #$05
	BNE PRG061_A491	; If frame <> 5, jump to PRG061_A491

	JSR PRG061_Kab_RemShotBlkSpr	; Remove shot out block

	JMP PRG061_A4D4	; Jump to PRG061_A4D4


PRG061_A491:
	LDA Spr_YHi+$00,X
	BNE PRG061_A49D	; If off-screen vertically, jump to PRG061_A49D

	LDA Spr_Y+$00,X
	CMP #$B6
	BLT PRG061_A4A3	; If Y < $B6, jump to PRG061_A4A3


PRG061_A49D:
	JSR PRG061_Kab_TrayRaise

	JMP PRG061_A4D4	; Jump to PRG061_A4D4


PRG061_A4A3:
	; Code for shooting out a Kabatoncue platform support

	JSR PRG063_CheckProjToObjCollide
	BCS PRG061_A4D4	; If shot didn't hit a platform support, jump to PRG061_A4D4

	LDY <Player_CurWeapon
	
	LDA PRG061_Kab_WeaponDamage,Y
	STA <Temp_Var0	; -> Temp_Var0
	
	LDY <Temp_Var16	; Y = current index of player projectile object (from PRG063_CheckProjToObjCollide)
	
	LDA Spr_CurrentAnim+$00,Y
	CMP #SPRANM2_MBUSTSHOTFULL
	BNE PRG061_A4BA	; If not a fully charged Mega Buster, jump to PRG061_A4BA

	INC <Temp_Var0	; Temp_Var0++ (Mega Buster will break it immediately)

PRG061_A4BA:
	JSR PRG063_DeleteObjectY	; Delete the Player projectile

	; Spr_Var1 += Temp_Var0
	LDA Spr_Var1+$00,X
	ADD <Temp_Var0
	STA Spr_Var1+$00,X
	
	CMP #$02
	BLT PRG061_A4A3	; If Spr_Var1 < 2, jump to PRG061_A4A3 (otherwise the platform support has been successfully shot out)

	; Spr_Var1 = 0
	LDA #$00
	STA Spr_Var1+$00,X
	
	; Poof away
	LDA #SPRANM4_KABATONCUE_BLKB
	JSR PRG063_SetSpriteAnim


PRG061_A4D4:
	DEX	; X--
	CPX #$10
	BNE PRG061_A47D	; While X > $10, loop

	LDX <Temp_Var4	; Restore object index
	JMP PRG061_A40D	; Jump to PRG061_A40D


PRG061_Kab_RemShotBlkSpr:
	; Effectively remove object
	LDA #$00
	JSR PRG063_SetSpriteAnim

	; Spr_Var2 = $78
	LDA #$78
	STA Spr_Var2+$00,X
	
	; Spr_Var3 = $10
	LDA #$10
	STA Spr_Var3+$00,X
	
	; Temp_Var0 = Spr_Y
	LDA Spr_Y+$00,X
	STA <Temp_Var0
	
	; +16
	LDA Spr_Y+$17
	ADD #$10
	STA Spr_Y+$17	
	STA Spr_Y+$16
	
	ADD #$71
	STA Spr_Y+$00,X
	LDA Spr_YHi+$00,X
	ADC #$00
	STA Spr_YHi+$00,X
	
	LDY #$15	; Y = $15
PRG061_A50E:
	LDA Spr_YHi+$00,Y
	BNE PRG061_A51F	; If off-screen, jump to PRG061_A51F

	LDA Spr_Y+$00,Y
	CMP <Temp_Var0
	BGE PRG061_A51F	; If not lowest jump to PRG061_A51F

	ADC #$10
	STA Spr_Y+$00,Y
	
PRG061_A51F:
	DEY	; Y--
	CPY #$10
	BNE PRG061_A50E	; While Y > $10, loop

	RTS	; $A524


PRG061_Kab_TrayRaise:
	LDA Spr_Var2+$00,X
	BEQ PRG061_A52F	; If Spr_Var2 = 0, jump to PRG061_A52F

	DEC Spr_Var2+$00,X	; Spr_Var2--
	BNE PRG061_A55A		; If Spr_Var2 <> 0, jump to PRG061_A55A (RTS)


PRG061_A52F:
	LDA Spr_YHi+$00,X
	BNE PRG061_A55A	; If vertically off-screen, jump to PRG061_A55A (RTS)

	LDA Spr_Y+$00,X
	CMP #$C6
	BGE PRG061_A55A	; If Y >= $C6, jump to PRG061_A55A (RTS)

	STX <Temp_Var0	; Backup object index -> Temp_Var0
	
	LDX #$17	; X = $17
PRG061_A53F:
	; Tray raising up
	LDA Spr_Y+$00,X
	SUB #$01
	STA Spr_Y+$00,X
	LDA Spr_YHi+$00,X
	SBC #$00
	STA Spr_YHi+$00,X
	
	DEX	; X--
	CPX #$10
	BNE PRG061_A53F	; While X > $10, loop

	LDX <Temp_Var0	; Restore object index
	
	DEC Spr_Var3+$00,X	; Spr_Var3--

PRG061_A55A:
	RTS	; $A55A


PRG061_Obj_Kabatoncue_Missile:
	LDA Spr_Flags+$00,X
	BMI PRG061_A563	; If missile is on-screen, jump to PRG061_A563

	; Missile off-screen, delete it
	JMP PRG062_ResetSpriteSlot


PRG061_A563:
	LDA Spr_Var1+$00,X
	ORA Spr_Var2+$00,X
	BEQ PRG061_A594	; If Spr_Var1 = 0 and Spr_Var2 = 0, jump to PRG061_A594

	; Sub_Var1/2 -= 1
	LDA Spr_Var1+$00,X
	SUB #$01
	STA Spr_Var1+$00,X
	LDA Spr_Var2+$00,X
	SBC #$00
	STA Spr_Var2+$00,X
	
	LDA Spr_Var1+$00,X
	AND #$07
	BNE PRG061_A594	; 7:8 ticks jump to PRG061_A594

	; Re-orient towards Player
	JSR PRG063_Aim2Plyr_SetDir_Var4

	LDY Spr_Var4+$00,X
	
	LDA PRG061_Kab_Missile_Anim,Y	; $A589
	STA Spr_CurrentAnim+$00,X	; $A58C
	
	LDA #$00
	JSR PRG063_SetMissileAimVelocities


PRG061_A594:
	JSR PRG063_ApplyVelSetFaceDir
	JSR PRG063_SetObjFlipForFaceDir
	JMP PRG063_DoMoveVertOnlyH16


PRG061_Kabatoncue_Pal:	
	.byte $0F, $20, $22, $13	; index 0 is technically not used, but they put it here anyway~


	; CHECKME - UNUSED?
	.byte $00, $0A, $3C, $3C	; $A5A1 - $A5A4


PRG061_Kab_Missile_Anim:
	.byte SPRANM4_KABMISSILE_UP			; $00	SPRAIM_ANG_0	Up
	.byte SPRANM4_KABMISSILE_DIAD		; $01	SPRAIM_ANG_22
	.byte SPRANM4_KABMISSILE_DIAD		; $02 	SPRAIM_ANG_45	Up-Right
	.byte SPRANM4_KABMISSILE_DIAD		; $03	SPRAIM_ANG_67
	.byte SPRANM4_KABMISSILE			; $04	SPRAIM_ANG_90	Right
	.byte SPRANM4_KABMISSILE_DIAU		; $05	SPRAIM_ANG_112
	.byte SPRANM4_KABMISSILE_DIAU		; $06	SPRAIM_ANG_135	Down-Right
	.byte SPRANM4_KABMISSILE_DIAU		; $07	SPRAIM_ANG_157
	.byte SPRANM4_KABMISSILE_DOWN		; $08	SPRAIM_ANG_180	Down
	.byte SPRANM4_KABMISSILE_DIAU		; $09	SPRAIM_ANG_202
	.byte SPRANM4_KABMISSILE_DIAU		; $0A	SPRAIM_ANG_225	Down-left
	.byte SPRANM4_KABMISSILE_DIAU		; $0B	SPRAIM_ANG_247
	.byte SPRANM4_KABMISSILE			; $0C	SPRAIM_ANG_270	Left
	.byte SPRANM4_KABMISSILE_DIAD		; $0D	SPRAIM_ANG_292
	.byte SPRANM4_KABMISSILE_DIAD		; $0E	SPRAIM_ANG_315	Up-Left
	.byte SPRANM4_KABMISSILE_DIAD		; $0F	SPRAIM_ANG_337
	

	; "Damage" towards Kabatoncue's platform blocks, which have 2 hits.
PRG061_Kab_WeaponDamage:
	.byte $01	; 0 = Mega Buster
	.byte $01	; 1 = Rush coil
	.byte $01	; 2 = Rush Jet
	.byte $01	; 3 = Rush Marine
	.byte $00	; 4 = Toad Rain
	.byte $01	; 5 = Wire adapter
	.byte $00	; 6 = Balloon
	.byte $02	; 7 = Dive Missile
	.byte $01	; 8 = Ring
	.byte $01	; 9 = Drill
	.byte $01	; 10 = Dust
	.byte $02	; 11 = Pharaoh
	.byte $01	; 12 = Bright
	.byte $01	; 13 = Skull
	
	; UNUSED
	.byte $00	
	.byte $00	



PRG061_SetPlayerBossWait:
	LDA <Player_State
	BNE PRG061_A5CD

	LDA #PLAYERSTATE_BOSSWAIT
	STA <Player_State

PRG061_A5CD:
	RTS	; $A5CD


PRG061_SetPlayerStandState:
	LDA #$00
	STA <Player_State
	RTS	; $A5D2


PRG061_Obj_ExplodeyDeath:
	
	LDY #$17	; Y = $17
PRG061_A5D5:
	JSR PRG063_DeleteObjectY

	DEY	; Y--
	CPY #$05
	BNE PRG061_A5D5	; While Y > 5, loop

	LDY #$17
	LDA #SPRANM4_SMALLPOOFEXP
	JSR PRG063_SetSpriteAnimY

	LDA #SPRSLOTID_CEXPLOSION
	STA Spr_SlotID+$00,Y
	
	LDY #$07	; Y = $07
	
	LDA <TileMap_Index
	CMP #TMAP_PHARAOHMAN
	BNE PRG061_A5F3	; If not Pharaoh Man, jump to PRG061_A5F3

	; CHECKME - UNUSED?
	; Pharaoh Man doesn't use this ... anymore?
	; This might have belonged to the deleted sub-boss!
	LDY #$03

PRG061_A5F3:
	LDA PalData_1+16
	STA PalData_1+8,Y
	STA PalData_2+8,Y
	
	DEY	; Y--
	BPL PRG061_A5F3	; While Y >= 0, loop

	STY <CommitPal_Flag	; Commit palette
	RTS	; $A601


PRG061_Obj_SubBoss_Escaroo:
	; Toad Man snail sub-boss

	JSR PRG061_SetPlayerBossWait
	JSR PRG063_DoMoveSimpleVert

	LDA #$7F
	CMP Spr_Y+$00,X
	BGE PRG061_A677	; If Escaroo is not teleported in low enough, jump to PRG061_A677

	; Lock into place
	STA Spr_Y+$00,X
	
	LDA Spr_Frame+$00,X
	CMP #$03
	BNE PRG061_A67C	; If frame <> 3 (teleport completed), jump to PRG061_A67C

	LDA <RAM_001D	; $A619
	BMI PRG061_A677	; $A61B

	LDA #$1C	; $A61D
	STA <CommitBG_ScrSel	; $A61F
	
	LDY Spr_Var1+$00,X	; Y =  Spr_Var1
	INC Spr_Var1+$00,X	; Spr_Var1++
	
	LDA PRG061_A806,Y	; $A627
	STA <RAM_001D	; $A62A
	
	LDA Spr_Var1+$00,X
	CMP #$06
	BNE PRG061_A677	; If Spr_Var1 < 6, jump to PRG061_A677

	; Normal eyes
	LDA #SPRANM4_ESCAROO_EYESNORMAL
	JSR PRG063_SetSpriteAnim

	; X position
	LDA #$B0
	STA Spr_X+$00,X
	
	LDA #LOW(PRG061_Obj_SubBoss_Escaroo_C)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_SubBoss_Escaroo_C)
	STA Spr_CodePtrH+$00,X
	
	; Clear the boss wait state
	JSR PRG061_SetPlayerStandState

	LDA Spr_Flags+$16
	AND #~$04
	STA Spr_Flags+$16
	
	LDA Spr_Flags+$15
	AND #~$04
	STA Spr_Flags+$15
	
	; Spr_Var1 = $8C
	LDA #$8C
	STA Spr_Var1+$00,X
		
	LDA #$00
	STA Spr_Var2+$00,X	; Spr_Var2 = 0
	STA Spr_Var3+$00,X	; Spr_Var3 = 0
	
	LDY #$07	; Y = 7
PRG061_A669:
	LDA PRG061_Escaroo_Pal,Y
	STA PalData_1+4,Y
	STA PalData_2+4,Y
	
	DEY	; Y--
	BPL PRG061_A669	; While Y >= 0, loop

	STY <CommitPal_Flag	; Commit palette

PRG061_A677:
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
PRG061_A67C:
	RTS	; $A67C

PRG061_Obj_SubBoss_Escaroo_C:
	JSR PRG061_Escaroo_HF_ClearShoot

	LDA Spr_Var1+$00,X
	BEQ PRG061_A689	; If Spr_Var1 = 0, jump to PRG061_A689

	DEC Spr_Var1+$00,X	; Spr_Var1--
	RTS	; $A688


PRG061_A689:
	LDA <RandomN+$00
	ADC <RandomN+$01
	STA <RandomN+$00
	
	AND #$03
	BEQ PRG061_A708	; 1:4 jump to PRG061_A708

	LDA Spr_Var2+$00,X
	BNE PRG061_A6A7	; If Spr_Var2 <> 0, jump to PRG061_A6A7

	INC Spr_Var3+$00,X	; Spr_Var3++
	LDA Spr_Var3+$00,X
	AND #$03			; Cap 0-3
	STA Spr_Var3+$00,X
	BEQ PRG061_A71C	; If Spr_Var3 = 0, jump to PRG061_A71C

	BNE PRG061_A6AC	; Otherwise, jump to PRG061_A6AC


PRG061_A6A7:
	; Spr_Var3 = 0
	LDA #$00
	STA Spr_Var3+$00,X

PRG061_A6AC:
	; Spr_Var2 = 0
	LDA #$00
	STA Spr_Var2+$00,X
	
	; Spr_Var1 = $8C
	LDA #$8C
	STA Spr_Var1+$00,X
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG061_A67C		; If no empty slot, jump to PRG061_A67C (RTS)

	LDA #SPRANM4_ESCAROO_BOMB
	JSR PRG063_CopySprSlotSetAnim

	; X = $D4
	LDA #$D4
	STA Spr_X+$00,Y
	
	; Y = $60
	LDA #$60
	STA Spr_Y+$00,Y
	
	; Escaroo's bomb!
	LDA #SPRSLOTID_ESCAROO_BOMB
	STA Spr_SlotID+$00,Y
	
	; Hurt player, shootable, bounding box $0E
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $0E)
	STA Spr_Flags2+$00,Y
	
	; HP = 2
	LDA #$02
	STA Spr_HP+$00,Y
	
	STX <Temp_Var15	; Backup object index -> Temp_Var15
	
	JSR PRG063_CalcObjXDiffFromPlayer

	LDX #$00	; X = 0
	
	CMP #$41
	BLT PRG061_A6EA	; If Player X diff < $41, jump to PRG061_A6EA

	INX	; X = 1
	
	CMP #$61
	BLT PRG061_A6EA	; If Player X diff < $61, jump to PRG061_A6EA

	INX	; X = 2

PRG061_A6EA:

	; Bomb vertical speed
	LDA #$E5
	STA Spr_YVelFrac+$00,Y
	LDA #$04
	STA Spr_YVel+$00,Y
	
	; Bomb horizontal speed
	LDA PRG061_Escaroo_Bomb_XVelFrac,X
	STA Spr_XVelFrac+$00,Y
	LDA PRG061_Escaroo_Bomb_XVel,X
	STA Spr_XVel+$00,Y
	
	; Bomb traveling left
	LDA #SPRDIR_LEFT
	STA Spr_FaceDir+$00,Y
	
	LDX <Temp_Var15	; Restore object index
	
	RTS	; $A707


PRG061_A708:
	LDA Spr_Var2+$00,X
	BEQ PRG061_A71C	; If Spr_Var2 = 0, jump to PRG061_A71C

	INC Spr_Var3+$00,X	; Spr_Var3++
	LDA Spr_Var3+$00,X
	AND #$03			; Cap 0 to 3
	STA Spr_Var3+$00,X
	BEQ PRG061_A6A7	; If Spr_Var3 = 0, jump to PRG061_A6A7
	BNE PRG061_A721	; Otherwise, jump to PRG061_A721


PRG061_A71C:
	; Spr_Var3 = 0
	LDA #$00
	STA Spr_Var3+$00,X

PRG061_A721:

	; Spr_Var2 = 1
	LDA #$01
	STA Spr_Var2+$00,X
	
	; Aiming Escaroo's eyeballs
	JSR PRG063_AimTowardsPlayer
	TAY	; -> 'Y'
	
	LDA PRG061_Escaroo_EyeAimDir,Y
	BEQ PRG061_A75E	; If zero, not moving eyes, jump to PRG061_A75E (RTS)

	STA Spr_FaceDir+$00,X	; -> Spr_FaceDir
	
	; First 9 indicies are zero so it just subtracts them out here.
	; Kinda odd since most NES-era programmers would just subtract
	; the address indexed, but hey.
	TYA
	SUB #$09
	TAY
	
	; Escaroo's eyes vertical speed
	LDA PRG061_Escaroo_EyeYVelFrac,Y
	STA Spr_YVelFrac+$00,X
	LDA PRG061_Escaroo_EyeYVel,Y
	STA Spr_YVel+$00,X
	
	; Escaroo's eyes horizontal speed
	LDA PRG061_Escaroo_EyeXVelFrac,Y
	STA Spr_XVelFrac+$00,X
	LDA PRG061_Escaroo_EyeXVel,Y
	STA Spr_XVel+$00,X
	
	LDA #LOW(PRG061_Obj_SubBoss_Escaroo_E)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_SubBoss_Escaroo_E)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var1 = 0
	LDA #$00
	STA Spr_Var1+$00,X

PRG061_A75E:
	RTS	; $A75E

PRG061_Obj_SubBoss_Escaroo_E:
	JSR PRG061_Escaroo_HF_ClearShoot

	LDA Spr_Var1+$00,X
	BEQ PRG061_A76B	; If Spr_Var1 = 0, jump to PRG061_A76B

	DEC Spr_Var1+$00,X	; Spr_Var1--
	RTS	; $A76A


PRG061_A76B:
	JSR PRG063_ApplyVelSetFaceDir
	JSR PRG063_DoMoveVertOnlyH16

	LDA Spr_Flags+$00,X
	AND #~SPR_HFLIP
	STA Spr_Flags+$00,X
	
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BNE PRG061_A7AA	; If eyes are moving right (returning), jump to PRG061_A7AA

	; Eyes launching out

	LDA #$10
	CMP Spr_X+$00,X
	BGE PRG061_A799	; If eyes X <= $10, jump to PRG061_A799

	CMP Spr_Y+$00,X
	BGE PRG061_A793	; If eyes Y <= $10, jump to PRG061_A793

	LDA #$D0
	CMP Spr_Y+$00,X
	BGE PRG061_A75E	; If eyes Y <= $D0, jump to PRG061_A75E (RTS)


PRG061_A793:
	STA Spr_Y+$00,X	; Lock eyes Y @ $10
	JMP PRG061_A79C	; Jump to PRG061_A79C


PRG061_A799:
	STA Spr_X+$00,X	; Lock eyes X @ $10

PRG061_A79C:
	; Spr_Var1 = $14
	LDA #$14
	STA Spr_Var1+$00,X
	
	; Full directional reverse
	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_DOWN | SPRDIR_LEFT | SPRDIR_RIGHT | SPRDIR_UP)
	STA Spr_FaceDir+$00,X
	
	RTS	; $A7A9


PRG061_A7AA:
	; Eyes returning

	LDA #$B0
	CMP Spr_X+$00,X
	BGE PRG061_A75E	; If Spr_X <= $B0, jump to PRG061_A75E

	STA Spr_X+$00,X	; Lock eyes X @ $B0
	
	; Spr_Y = $80
	LDA #$80
	STA Spr_Y+$00,X
	
	; Spr_Var1 = $8C
	LDA #$8C
	STA Spr_Var1+$00,X
	
	LDA #LOW(PRG061_Obj_SubBoss_Escaroo_C)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_SubBoss_Escaroo_C)
	STA Spr_CodePtrH+$00,X
	
	LDA #SPRANM4_ESCAROO_EYESNORMAL
	JMP PRG063_SetSpriteAnim


PRG061_Escaroo_HF_ClearShoot:
	LDA Spr_Flags2+$00,X
	ORA #SPR_HFLIP
	STA Spr_Flags2+$00,X
	
	LDA Spr_Frame+$00,X
	CMP #$0B
	BGE PRG061_A7E4	; If frame >= $0B, jump to PRG061_A7E4

	LDA Spr_Flags2+$00,X
	AND #~SPRFL2_SHOOTABLE
	STA Spr_Flags2+$00,X

PRG061_A7E4:
	RTS	; $A7E4


PRG061_Obj_Escaroo_Bomb:
	LDY #$11
	JSR PRG063_DoObjVertMovement

	BCS PRG061_A7F3	; If bomb hit solid, jump to PRG061_A7F3

	LDY #$1A
	JSR PRG063_DoObjMoveSetFaceDir

	BCC PRG061_A805	; If bomb did not hit solid, jump to PRG061_A805 (RTS)


PRG061_A7F3:
	; Reset sprite
	JSR PRG062_ResetSpriteSlot

	LDA #SPRANM4_SMALLPOOFEXP
	JSR PRG063_SetSpriteAnim	; $A7F8

	LDA #SPRSLOTID_SPIRALEXPLOSION
	STA Spr_SlotID+$00,X
	
	; Hurt Player, bounding box $37
	LDA #(SPRFL2_HURTPLAYER | $37)
	STA Spr_Flags2+$00,X

PRG061_A805:
	RTS	; $A805


PRG061_A806:
	.byte $9D, $9E, $9F, $A5, $A6, $A7


PRG061_Escaroo_EyeAimDir:
	; Note $00 disables moving eyes in that direction. Also the index is adjusted accordingly in code,
	; so you can't just remove the zeroes if that's what you were interested in doing...
	.byte $00	; $00	SPRAIM_ANG_0	Up
	.byte $00	; $01	SPRAIM_ANG_22
	.byte $00	; $02 	SPRAIM_ANG_45	Up-Right
	.byte $00	; $03	SPRAIM_ANG_67
	.byte $00	; $04	SPRAIM_ANG_90	Right
	.byte $00	; $05	SPRAIM_ANG_112
	.byte $00	; $06	SPRAIM_ANG_135	Down-Right
	.byte $00	; $07	SPRAIM_ANG_157
	.byte $00	; $08	SPRAIM_ANG_180	Down
	.byte SPRDIR_DOWN | SPRDIR_LEFT		; $09	SPRAIM_ANG_202
	.byte SPRDIR_DOWN | SPRDIR_LEFT		; $0A	SPRAIM_ANG_225	Down-left
	.byte SPRDIR_DOWN | SPRDIR_LEFT		; $0B	SPRAIM_ANG_247
	.byte SPRDIR_LEFT					; $0C	SPRAIM_ANG_270	Left
	.byte SPRDIR_UP | SPRDIR_LEFT		; $0D	SPRAIM_ANG_292
	.byte SPRDIR_UP | SPRDIR_LEFT		; $0E	SPRAIM_ANG_315	Up-Left
	.byte SPRDIR_UP | SPRDIR_LEFT		; $0F	SPRAIM_ANG_337



PRG061_Escaroo_Bomb_XVelFrac:
	.byte $A1, $72, $43

PRG061_Escaroo_Bomb_XVel:
	.byte $01, $02, $03

PRG061_Escaroo_Pal:
	.byte $0F, $20, $32, $13, $0F, $13, $29, $19


PRG061_Escaroo_EyeYVelFrac:
	.byte $B2		; $09	SPRAIM_ANG_202
	.byte $D4		; $0A	SPRAIM_ANG_225	Down-left
	.byte $87		; $0B	SPRAIM_ANG_247
	.byte $00		; $0C	SPRAIM_ANG_270	Left
	.byte $87		; $0D	SPRAIM_ANG_292
	.byte $D4		; $0E	SPRAIM_ANG_315	Up-Left
	.byte $B2		; $0F	SPRAIM_ANG_337

	
PRG061_Escaroo_EyeYVel:
	.byte $03		; $09	SPRAIM_ANG_202
	.byte $02		; $0A	SPRAIM_ANG_225	Down-left
	.byte $01		; $0B	SPRAIM_ANG_247
	.byte $00		; $0C	SPRAIM_ANG_270	Left
	.byte $01		; $0D	SPRAIM_ANG_292
	.byte $02		; $0E	SPRAIM_ANG_315	Up-Left
	.byte $03		; $0F	SPRAIM_ANG_337

PRG061_Escaroo_EyeXVelFrac:
	.byte $87		; $09	SPRAIM_ANG_202
	.byte $D4		; $0A	SPRAIM_ANG_225	Down-left
	.byte $B2		; $0B	SPRAIM_ANG_247
	.byte $00		; $0C	SPRAIM_ANG_270	Left
	.byte $B2		; $0D	SPRAIM_ANG_292
	.byte $D4		; $0E	SPRAIM_ANG_315	Up-Left
	.byte $87		; $0F	SPRAIM_ANG_337
	
	
PRG061_Escaroo_EyeXVel:
	.byte $01		; $09	SPRAIM_ANG_202
	.byte $02		; $0A	SPRAIM_ANG_225	Down-left
	.byte $03		; $0B	SPRAIM_ANG_247
	.byte $04		; $0C	SPRAIM_ANG_270	Left
	.byte $03		; $0D	SPRAIM_ANG_292
	.byte $02		; $0E	SPRAIM_ANG_315	Up-Left
	.byte $01		; $0F	SPRAIM_ANG_337


PRG061_Obj_Escaroo_Die:
	LDA <RAM_001D	; $A846
	BMI PRG061_A876	; $A848

	LDA <Current_Screen
	STA <CommitBG_ScrSel
	
	LDY Spr_Var1+$00,X	; Y = Spr_Var1
	
	INC Spr_Var1+$00,X	; Spr_Var1++
	
	LDA PRG061_A806,Y	; $A854
	STA <RAM_001D	; $A857
	
	LDA Spr_Var1+$00,X
	CMP #$06
	BNE PRG061_A876	; If Spr_Var1 <> 6, jump to PRG061_A876 (RTS)

	LDY #$17	; Y = $17
PRG061_A862:
	JSR PRG063_DeleteObjectY

	DEY	; Y--
	CPY #$05
	BNE PRG061_A862	; While Y > 5, loop

	LDY #$16
	LDA #SPRANM4_SMALLPOOFEXP
	JSR PRG063_SetSpriteAnimY

	LDA #SPRSLOTID_CEXPLOSION
	STA Spr_SlotID+$00,Y

PRG061_A876:
	RTS	; $A876


PRG061_Obj_WhopperDie:
	LDA Spr_XHi+$00,X
	CMP #$0A
	BNE PRG061_A89A	; If not screen $0A, jump to PRG061_A89A

	LDA <RAM_001D	; $A87E
	BMI PRG061_A8BD	; $A880

	LDA #$1A
	STA <CommitBG_ScrSel
	
	LDY Spr_Var1+$00,X	; Y = Spr_Var1
	
	INC Spr_Var1+$00,X	; Spr_Var1++
	
	LDA PRG061_A8BE,Y	; $A88C
	STA <RAM_001D	; $A88F
	
	LDA Spr_Var1+$00,X
	CMP #$05
	BNE PRG061_A8BD	; If Spr_Var1 <> 5, jump to PRG061_A8BD (RTS)

	INC <RAM_003E	; $A898

PRG061_A89A:
	JSR PRG062_ResetSpriteSlot

	LDA #$00
	STA Spr_Flags2+$00,X
	
	LDA #SPRANM4_SMALLPOOFEXP
	JSR PRG063_SetSpriteAnim

	LDA #SPRSLOTID_CEXPLOSION
	STA Spr_SlotID+$00,X
	
	LDA Spr_XHi+$00,X
	CMP #$0A
	BNE PRG061_A8BD	; If not screen $0A, jump to PRG061_A8BD (RTS)

	LDA #$50
	STA Spr_X+$00,X
	LDA #$C0
	STA Spr_Y+$00,X

PRG061_A8BD:
	RTS	; $A8BD


PRG061_A8BE:
	.byte $A9, $AA, $AB, $B2, $BA	; $A8BE - $A8C2


PRG061_Obj_ExplodeyBit:
	; One of the little particles that fly off an exploded Player / boss

	LDA #$00
	STA <Temp_Var0	; Temp_Var0 = 0
	STA <Temp_Var1	; Temp_Var1 = 0

	; SB: Almost wonder if this is some really old code predating their
	; other movement logic or something, weird that it's doing the X/Y
	; velocity manually I think...
	
	; Manually applying X velocity
	LDA Spr_XVelFrac+$00,X
	ADD Spr_XVelFracAccum+$00,X
	STA Spr_XVelFracAccum+$00,X
	
	LDA Spr_XVel+$00,X
	BPL PRG061_A8DA

	DEC <Temp_Var0	

PRG061_A8DA:
	ADC Spr_X+$00,X	
	STA Spr_X+$00,X	
	LDA Spr_XHi+$00,X
	ADC <Temp_Var0
	STA Spr_XHi+$00,X
	
	; Manually applying Y velocity
	LDA Spr_YVelFrac+$00,X
	ADD Spr_YVelFracAccum+$00,X
	STA Spr_YVelFracAccum+$00,X
	LDA Spr_YVel+$00,X
	BPL PRG061_A8F9

	DEC <Temp_Var1	

PRG061_A8F9:
	ADC Spr_Y+$00,X	
	STA Spr_Y+$00,X	
	LDA Spr_YHi+$00,X
	ADC <Temp_Var1
	STA Spr_YHi+$00,X
	
	BEQ PRG061_A90C	; As long as not vertically off-screen, jump to PRG061_A90C

	; Delete it
	JSR PRG062_ResetSpriteSlot

PRG061_A90C:
	RTS	; $A90C


PRG061_Obj_Red_UTrackPlat:
	DEC Spr_Y+$00,X
	JSR PRG063_TestPlayerObjCollide
	INC Spr_Y+$00,X
	BCS PRG061_A97F	; If Player is not touching platform, jump to PRG061_A97F

	LDA #LOW(PRG061_Obj_Red_UTrackPlat_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_Red_UTrackPlat_Cont)
	STA Spr_CodePtrH+$00,X
	
	LDA #SPRDIR_RIGHT
	STA Spr_FaceDir+$00,X
	

PRG061_Obj_Red_UTrackPlat_Cont:

	; Spr_Var2 = 0
	LDA #$00
	STA Spr_Var2+$00,X
	
	DEC Spr_Y+$00,X
	JSR PRG063_TestPlayerObjCollide
	INC Spr_Y+$00,X
	ROL Spr_Var2+$00,X	; Carry -> Bit 0 (0 = touching, 1 = not touching)
	
	LDA Spr_Var1+$00,X
	CMP #$48
	BEQ PRG061_A968	; If Spr_Var1 = $48, jump to PRG061_A968

	JSR PRG063_ApplyVelSetFaceDir

	LDA Spr_Flags+$00,X
	AND #~SPR_HFLIP
	STA Spr_Flags+$00,X
	
	LDY Spr_Var1+$00,X	; Y = Spr_Var1
	INC Spr_Var1+$00,X	; Spr_Var1++

	; Y movement
	LDA Spr_Y+$00,X
	ADD PRG061_UTrackPlat_YOff,Y
	STA Spr_Y+$00,X
	
	CPY #(PRG061_UTrackPlat_YOff_End - PRG061_UTrackPlat_YOff - 1)
	BNE PRG061_A96B	; If Y < $47, jump to PRG061_A96B

	; Stop platform
	LDA #$00
	STA Spr_XVelFrac+$00,X
	STA Spr_XVel+$00,X
	
	BEQ PRG061_A96B	; Jump (technically always) to PRG061_A96B


PRG061_A968:
	JSR PRG063_DoMoveSimpleVert	; $A968


PRG061_A96B:
	LDA Spr_Var2+$00,X
	BNE PRG061_A97F	; If Spr_Var2 <> 0, jump to PRG061_A97F (RTS)

	; Moving Player with platform
	LDA Spr_Y+$00,X
	SUB #$14
	STA Spr_Y+$00
	JSR PRG063_MovePlayerWithObj
	JSR PRG063_PlayerHitFloorAlign

PRG061_A97F:
	RTS	; $A97F


PRG061_Obj_Green_UTrackPlat:
	DEC Spr_Y+$00,X
	JSR PRG063_TestPlayerObjCollide
	INC Spr_Y+$00,X
	BCS PRG061_A97F	; If not touching, jump to PRG061_A97F (RTS)

	LDA #LOW(PRG061_Green_UTrackPlat_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Green_UTrackPlat_Cont)
	STA Spr_CodePtrH+$00,X

	; Platform travels right
	LDA #SPRDIR_RIGHT
	STA Spr_FaceDir+$00,X
		
PRG061_Green_UTrackPlat_Cont:
	LDA Spr_Var3+$00,X
	BEQ PRG061_A9A3	; If Spr_Var3 = 0, jump to PRG061_A9A3

	DEC Spr_Var3+$00,X	; Spr_Var3--
	RTS	; $A9A2


PRG061_A9A3:

	; Spr_Var2 = 0
	LDA #$00
	STA Spr_Var2+$00,X
	
	DEC Spr_Y+$00,X
	JSR PRG063_TestPlayerObjCollide
	INC Spr_Y+$00,X
	ROL Spr_Var2+$00,X	; Carry -> Bit 0 (0 = touching, 1 = not touching)
	
	JSR PRG063_ApplyVelSetFaceDir

	LDA Spr_Flags+$00,X
	AND #~SPR_HFLIP
	STA Spr_Flags+$00,X
	
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BEQ PRG061_A9DC	; If not traveling right, jump to PRG061_A9DC
	
	; Traveling right...

	LDY Spr_Var1+$00,X	; Y = Spr_Var1
	
	INC Spr_Var1+$00,X	; Spr_Var1++
	
	LDA Spr_Y+$00,X
	ADD PRG061_UTrackPlat_YOff,Y
	STA Spr_Y+$00,X
	
	CPY #(PRG061_UTrackPlat_YOff_End - PRG061_UTrackPlat_YOff - 1)
	BNE PRG061_AA0A	; If Y < $47, jump to PRG061_AA0A
	BEQ PRG061_A9F9	; Otherwise, jump to PRG061_A9F9

PRG061_A9DC:

	; Traveling left...
	
	CLC
	
	LDY Spr_Var1+$00,X	; Y = Spr_Var1
	
	DEC Spr_Var1+$00,X	; Spr_Var1--
	
	; Store negated Y offset
	LDA PRG061_UTrackPlat_YOff,Y
	EOR #$FF
	ADC #$01
	STA <Temp_Var0	; -> Temp_Var0
	
	LDA Spr_Y+$00,X	
	ADD <Temp_Var0
	STA Spr_Y+$00,X
	
	CPY #$00
	BNE PRG061_AA0A	; If Spr_Var1 > 0, jump to PRG061_AA0A


PRG061_A9F9:
	TYA
	STA Spr_Var1+$00,X
	
	; Reverse direction
	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_LEFT | SPRDIR_RIGHT)
	STA Spr_FaceDir+$00,X
	
	; Spr_Var3 = $0A
	LDA #$0A
	STA Spr_Var3+$00,X

PRG061_AA0A:
	LDA Spr_Var2+$00,X
	BNE PRG061_AA1E	; If Spr_Var2 > 0, jump to PRG061_AA1E (RTS)

	; Moving Player with platform
	LDA Spr_Y+$00,X
	SUB #$14
	STA Spr_Y+$00
	JSR PRG063_MovePlayerWithObj
	JSR PRG063_PlayerHitFloorAlign


PRG061_AA1E:
	RTS	; $AA1E


PRG061_UTrackPlat_YOff:
	.byte $06, $05, $04, $04, $02, $02, $03, $02, $01, $02, $01, $01, $01, $02, $00, $01
	.byte $02, $00, $01, $01, $00, $01, $00, $01, $01, $00, $00, $01, $00, $00, $00, $01
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $FF, $00, $00, $00, $FF, $00, $00, $FF
	.byte $00, $FF, $FF, $00, $FF, $FF, $00, $FF, $FF, $FF, $FF, $FE, $FF, $FF, $FF, $FE
	.byte $FE, $FF, $FC, $FE, $FE, $FA, $FB, $FA
PRG061_UTrackPlat_YOff_End


PRG061_Obj_Kabatoncue_Die:

	LDY #$17	; Y = $17
PRG061_AA69:
	JSR PRG063_DeleteObjectY

	DEY	; Y--
	CPY #$05
	BNE PRG061_AA69	; While Y > 5, loop

	LDY #$16
	LDA #SPRANM4_SMALLPOOFEXP
	JSR PRG063_SetSpriteAnimY

	LDA #SPRSLOTID_CEXPLOSION
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA <Raster_VMode
	
	LDA #$88
	STA <Raster_VSplit_Req
	
	RTS	; $AA85


PRG061_Obj_100Watton_Die:
	LDA #SPRANM4_SMALLPOOFEXP
	CMP Spr_CurrentAnim+$00,X
	BEQ PRG061_AAAE	; If already poof anim, jump to PRG061_AAAE (RTS)

	JSR PRG063_SetSpriteAnim

	; Trigger darkness

	LDA Level_LightDarkCtl
	AND #$7F
	BNE PRG061_AAAE

	STA Level_LightDarkTransCnt
	
	LDA #$10
	STA Level_LightDarkTransLevel
	
	LDA #$01
	STA Level_LightDarkCtl
	
	LDA #$58
	STA Level_DarkTimer+$00
	LDA #$02
	STA Level_DarkTimer+$01

PRG061_AAAE:
	RTS	; $AAAE


PRG061_Obj_SubBoss_Moby:
	; Whale sub-boss from Dive Man

	LDA Spr_Frame+$00,X
	BNE PRG061_AAC9	; If frame <> 0, jump to PRG061_AAC9

	JSR PRG063_DoMoveSimpleVert

	LDA #$6F
	CMP Spr_Y+$00,X
	BGE PRG061_AAC4	; If Spr_Y < $6F, jump to PRG061_AAC4

	STA Spr_Y+$00,X	; Set to $6F
	INC Spr_Frame+$00,X	; frame++

PRG061_AAC4:
	; ticks = 0
	LDA #$00
	STA Spr_AnimTicks+$00,X

PRG061_AAC9:
	LDA Spr_Frame+$00,X
	CMP #$03
	BNE PRG061_AB27	; If frame <> 3, jump to PRG061_AB27

	LDA #SPRANM4_MOBY_IDLE
	JSR PRG063_SetSpriteAnim

	LDY #$02	; Y = $02
PRG061_AAD7:
	LDA Spr_Flags+$14,Y	; $AAD7
	AND #~$04
	STA Spr_Flags+$14,Y	; $AADC
	
	DEY	; Y--
	BPL PRG061_AAD7	; While Y >= 0, loop


	LDY #$07	; Y = $07
PRG061_AAE4:
	LDA PRG061_MobyPal,Y
	STA PalData_1+8,Y
	STA PalData_2+8,Y
	
	DEY	; Y--
	BPL PRG061_AAE4	; While Y >= 0, loop

	STY <CommitPal_Flag	; commit palette
	
	LDA #LOW(PRG061_Obj_SubBoss_Moby_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_SubBoss_Moby_Cont)
	STA Spr_CodePtrH+$00,X
	
	LDA #$20
	STA Spr_YVelFrac+$00,X
	LDA #$00
	STA Spr_YVel+$00,X
	
	LDA #$80
	STA Spr_XVelFrac+$00,X
	LDA #$00
	STA Spr_XVel+$00,X
	
	LDA #(SPRDIR_UP | SPRDIR_RIGHT)
	STA Spr_FaceDir+$00,X
	
	; Spr_Var1 = $80
	LDA #$80
	STA Spr_Var1+$00,X
	
	; Spr_Var2 = $3C
	LDA #$3C
	STA Spr_Var2+$00,X
	
	LDA #$40
	STA <Raster_VSplit_Req
	
	LDA #RVMODE_DMSBOSS
	STA <Raster_VMode

PRG061_AB27:
	RTS	; $AB27


PRG061_Obj_SubBoss_Moby_Cont:
	LDA Spr_Var3+$00,X
	BEQ PRG061_AB3A	; If Spr_Var3 = 0, jump to PRG061_AB3A

	LDA Spr_X+$00
	CMP #$80
	BGE PRG061_AB3D	; If X >= $80, jump to PRG061_AB3D

	JSR PRG063_MovePlayerWithObj

	JMP PRG061_AB3D	; Jump to PRG061_AB3D


PRG061_AB3A:
	JSR PRG063_DoMoveVertOnlyH16


PRG061_AB3D:
	LDA Spr_Y+$00,X
	STA Spr_Y+$16	; propellat
	STA Spr_Y+$15	; fins
	STA Spr_Y+$14	; white highlights
	
	SUB #$2D
	STA <Raster_VSplit_Req
	
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG061_AB60	; If Spr_Var1 > 0, jump to PRG061_AB60

	; Spr_Var1 = $80
	LDA #$80
	STA Spr_Var1+$00,X
	
	; Reverse vertical direction
	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_UP | SPRDIR_DOWN)
	STA Spr_FaceDir+$00,X

PRG061_AB60:
	LDA Spr_Var2+$00,X
	BEQ PRG061_AB73	; If Spr_Var2 = 0, jump to PRG061_AB73

	DEC Spr_Var2+$00,X
	BNE PRG061_AB72	; If Spr_Var2 > 0, jump to PRG061_AB72 (RTS)

	LDY Spr_Var5+$00,X
	BEQ PRG061_AB72	; If Spr_Var5 = 0, jump to PRG061_AB72 (RTS)

	; CHECKME - UNUSED?
	JSR PRG063_DeleteObjectY

PRG061_AB72:
	RTS	; $AB72


PRG061_AB73:
	; Spr_Var5 = 0
	LDA #$00
	STA Spr_Var5+$00,X
	
	LDA <RandomN+$00
	ADC <RandomN+$01
	STA <RandomN+$01
	AND #$03
	BEQ PRG061_ABDA	; 3:4, jump to PRG061_ABDA

	LDA Spr_Var3+$00,X
	BNE PRG061_AB93	; If Spr_Var3 > 0, jump to PRG061_AB93

	INC Spr_Var4+$00,X	; Spr_Var4++
	LDA Spr_Var4+$00,X
	CMP #$05
	BEQ PRG061_ABDF	; If Spr_Var4 = 5, jump to PRG061_ABDF
	BNE PRG061_AB98	; Otherwise, jump to PRG061_AB98


PRG061_AB93:
	LDA #$00
	STA Spr_Var4,X


PRG061_AB98:
	; Spr_Var3 = 0
	LDA #$00
	STA Spr_Var3+$00,X
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG061_ABD9	; If no free slot, jump to PRG061_ABD9 (RTS)

	; Spr_Var2 = $3C
	LDA #$3C
	STA Spr_Var2+$00,X
	
	LDA #$3B
	STA <Temp_Var16
	LDA #SPRANM4_MOBY_MISSILE_L
	JSR PRG063_InitProjectile

	LDA #$00
	STA Spr_XVelFrac+$00,Y
	STA Spr_YVelFrac+$00,Y
	STA Spr_YVel+$00,Y
	
	; Launch init speed
	LDA #$04
	STA Spr_XVel+$00,Y
	
	LDA #SPRSLOTID_MOBY_MISSILE
	STA Spr_SlotID+$00,Y
	
	LDA #SPRDIR_LEFT
	STA Spr_FaceDir+$00,Y
	
	LDA #SPRFL2_HURTPLAYER
	STA Spr_Flags2+$00,Y
	
	; Spr_Var1 = $04
	LDA #$04
	STA Spr_Var1+$00,Y
	
	; Spr_Var2 = $0C
	LDA #$0C
	STA Spr_Var2+$00,Y

PRG061_ABD9:
	RTS	; $ABD9


PRG061_ABDA:
	LDA Spr_Var3+$00,X
	BNE PRG061_AB93	; If Spr_Var3 > 0, jump to PRG061_AB93


PRG061_ABDF:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG061_ABD9	; If no empty object slot, jump to PRG061_ABD9 (RTS)

	; Spr_Var3 = 1
	LDA #$01
	STA Spr_Var3+$00,X
	
	; Spr_Var4 = 0
	LDA #$00
	STA Spr_Var4+$00,X
	
	; Spr_Var2 = $FF
	LDA #$FF
	STA Spr_Var2+$00,X
	
	LDA #$3C
	STA <Temp_Var16
	LDA #SPRANM4_MOBY_BIGSPIKE
	JSR PRG063_InitProjectile

	LDA #$00
	STA Spr_YVelFrac+$00,Y
	LDA #$04
	STA Spr_YVel+$00,Y
	
	LDA #SPRSLOTID_MOBY_BIGSPIKE
	STA Spr_SlotID+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | $0E)
	STA Spr_Flags2+$00,Y
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG061_AC28	; If no free object slot, jump to PRG061_AC28 (RTS)

	LDA #SPRANM4_MOBY_BUBBLES
	JSR PRG063_CopySprSlotSetAnim

	LDA #SPRSLOTID_MISCSTUFF
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_Flags2+$00,Y
	
	; Store bubbles index -> Spr_Var5 (for tracking)
	TYA	
	STA Spr_Var5+$00,X

PRG061_AC28:
	RTS	; $AC28


PRG061_Obj_Moby_Missile:
	LDA Spr_Var1+$00,X	
	BNE PRG061_AC60	; If Spr_Var1 <> 0, jump to PRG061_AC60

	JSR PRG063_AimTowardsPlayer

	CMP #SPRAIM_ANG_202
	BLT PRG061_AC44	; If the missile aim is out of range, jump to PRG061_AC44

	CMP Spr_Var2+$00,X
	BEQ PRG061_AC44	; If the aim = Spr_Var2, jump to PRG061_AC44
	BLT PRG061_AC41	; If aim < Spr_Var2, jump to PRG061_AC41

	INC Spr_Var2+$00,X	; Spr_Var2++
	BNE PRG061_AC44	; If Spr_Var2 <> 0, jump to PRG061_AC44


PRG061_AC41:
	DEC Spr_Var2+$00,X	; Spr_Var2--

PRG061_AC44:
	LDA #$08
	LDY Spr_Var2+$00,X
	JSR PRG063_SetMissileAimVelocities

	LDY Spr_Var2+$00,X
	
	LDA PRG063_Aim_FaceDir,Y
	STA Spr_FaceDir+$00,X
	
	; Set missile animation appropriate for aim
	LDA PRG061_MobyMissileAnims-9,Y
	JSR PRG063_SetSpriteAnim

	; Spr_Var1 = $05
	LDA #$05
	STA Spr_Var1+$00,X

PRG061_AC60:
	JSR PRG063_ApplyVelSetFaceDir
	JSR PRG063_DoMoveVertOnlyH16

	DEC Spr_Var1+$00,X	; Spr_Var1--
	RTS	; $AC69


PRG061_Obj_Moby_BigSpike:
	JSR PRG063_ApplyYVelocityNeg

	LDA Spr_YHi+$00,X
	BEQ PRG061_ACE6	; If not off-screen, jump to (RTS)

	LDA #SPRANM4_MOBY_SMALLSPIKE
	JSR PRG063_SetSpriteAnim

	; Set to top of screen
	LDA #$00
	STA Spr_Y+$00,X
	STA Spr_YHi+$00,X
	
	LDA Spr_Flags+$00,X
	ORA #SPRFL1_NODRAW
	STA Spr_Flags+$00,X
	
	LDA #$14
	STA Spr_X+$00,X		; X = $14
	STA <Temp_Var3		; Temp_Var3 = $14
	
	LDA #LOW(PRG061_Obj_Moby_LittleSpike)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_Moby_LittleSpike)
	STA Spr_CodePtrH+$00,X
	
	; Moving down
	LDA #$00
	STA Spr_YVelFrac+$00,X
	LDA #$01
	STA Spr_YVel+$00,X
	
	; Spr_Var1 = $0A
	LDA #$0A
	STA Spr_Var1+$00,X
	
	; Temp_Var2 = $03
	LDA #$03
	STA <Temp_Var2

PRG061_ACAB:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG061_ACE6	; If no free object slot, jump to PRG061_ACE6 (RTS)

	LDA #SPRANM4_MOBY_SMALLSPIKE
	JSR PRG063_CopySprSlotSetAnim

	; Next X over
	LDA <Temp_Var3
	ADD #$28
	STA <Temp_Var3
	STA Spr_X+$00,Y
	
	LDA #SPRSLOTID_MOBY_BIGSPIKE
	STA Spr_SlotID+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | $0E)
	STA Spr_Flags2+$00,Y
	
	LDA #LOW(PRG061_Obj_Moby_LittleSpike)
	STA Spr_CodePtrL+$00,Y
	LDA #HIGH(PRG061_Obj_Moby_LittleSpike)
	STA Spr_CodePtrH+$00,Y
	
	LDA #$00
	STA Spr_YVelFrac+$00,Y
	LDA #$01
	STA Spr_YVel+$00,Y	; $ACDA
	LDA #$0A	; $ACDD
	STA Spr_Var1+$00,Y	; $ACDF
	DEC <Temp_Var2	; $ACE2
	BNE PRG061_ACAB	; $ACE4


PRG061_ACE6:
	RTS	; $ACE6

	
PRG061_Obj_Moby_LittleSpike:
	LDA Spr_Var1+$00,X
	BEQ PRG061_ACF9	; If Spr_Var1 = 0, jump to PRG061_ACF9

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG061_ACE6	; If Spr_Var1 > 0, jump to PRG061_ACE6 (RTS)

	LDA Spr_Flags+$00,X
	AND #~SPRFL1_NODRAW
	STA Spr_Flags+$00,X

PRG061_ACF9:
	JMP PRG063_ApplyYVelocityH16

PRG061_Obj55:
	; CHECKME - UNUSED?
	RTS


PRG061_MobyPal:
	.byte $11, $20, $22, $0F, $11, $16, $22, $0F
	
PRG061_MobyMissileAnims:
	.byte SPRANM4_MOBY_MISSILE_DL	; $09 SPRAIM_ANG_202
	.byte SPRANM4_MOBY_MISSILE_DL	; $0A SPRAIM_ANG_225
	.byte SPRANM4_MOBY_MISSILE_L	; $0B SPRAIM_ANG_247
	.byte SPRANM4_MOBY_MISSILE_L	; $0C SPRAIM_ANG_270
	.byte SPRANM4_MOBY_MISSILE_L	; $0D SPRAIM_ANG_292
	.byte SPRANM4_MOBY_MISSILE_UL	; $0E SPRAIM_ANG_315
	.byte SPRANM4_MOBY_MISSILE_UL	; $0F SPRAIM_ANG_337


PRG061_Obj57:
PRG061_Obj58:
PRG061_Obj59:
PRG061_Obj5A:
PRG061_Obj_DrillManSwitch:
	LDA Spr_Frame+$00,X
	BNE PRG061_AD19	; If Spr_Frame <> 0, jump to PRG061_AD19

	JSR PRG063_TestPlayerObjCollide
	BCS PRG061_AD91	; If Player is not touching switch, jump to PRG061_AD91

	LDA Spr_Var1+$00,X
PRG061_AD19:
	BNE PRG061_AD91	; Frame or Spr_Var1 not zero, jump to PRG061_AD91

	LDA Spr_SlotID+$00,X
	CMP #SPRSLOTID_SWITCH
	BNE PRG061_AD25	; If this isn't the Drill Man switch, jump to PRG061_AD25

	; NOTE: Four object IDs point here, but I believe only the Drill Man switch is used, so a lot of this code is dead code forever
	JMP PRG061_ADD0	; Jump to PRG061_ADD0

	; CHECKME - UNUSED? from here to PRG061_AD91
	; I don't think ANY of these other object IDs are ever used!
PRG061_AD25:
	SUB #$57		; zero-base the ID
	ASL A
	ASL A			; x4
	STA <Temp_Var2	; ->Temp_Var2
	
	LDY Spr_XHi,X	; Y = current screen this whatever's on
	
	LDA PRG061_AE21-5,Y		; Seems they need to be on at least screen 5
	ADD <Temp_Var2			; Add the relative ID x4
	STA <Temp_Var2			; -> Temp_Var2
	
	LDY #$17	; Y = $17 (all object slots)	
PRG061_AD39:
	LDA Spr_SlotID,Y
	BEQ PRG061_AD48		; If empty, jump to PRG061_AD48
	
	; Deleting all of whatever has animation SPRANM4_UNK_70
	LDA Spr_CurrentAnim,Y
	CMP #SPRANM4_UNK_70
	BNE PRG061_AD48
	
	JSR PRG063_DeleteObjectY

PRG061_AD48:
	DEY				; Y--
	CPY #$07		
	BNE PRG061_AD39	; While Y > 7, loop

PRG061_AD4D:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG061_AD91		; If no free object slot, jump to PRG061_AD91
	
	LDA #$70
	JSR PRG063_CopySprSlotSetAnim
	
	LDA Spr_Flags,Y
	ORA #$02
	STA Spr_Flags,Y
	
	; Become inert
	LDA #SPRSLOTID_MISCSTUFF
	STA Spr_SlotID,Y

	; bbox $02
	LDA #$02
	STA Spr_Flags2,Y
	
	STX <Temp_Var0		; Backup object slot index -> Temp_Var0
	
	LDX <Temp_Var2		; X = Temp_Var2
	
	LDA PRG061_AE25,X
	STA Spr_XHi,Y
	LDA PRG061_AE25+1,X
	STA Spr_X,Y
	LDA PRG061_AE25+2,X
	STA Spr_Y,Y
	LDY PRG061_AE25+3,X
	
	LDX <Temp_Var0		; Restore object slot index
	
	; Temp_Var2 += 4
	LDA <Temp_Var2
	ADD #$04
	STA <Temp_Var2
	
	DEY		; Y--
	BPL PRG061_AD4D		; While Y >= 0, loop
	
	INC Spr_Var1,X		; Spr_Var1++

PRG061_AD91:
	LDA Spr_Var1+$00,X
	AND #$01
	BEQ PRG061_ADC5	; 1:2 jump to PRG061_ADC5

	LDA Spr_SlotID+$00,X
	CMP #SPRSLOTID_SWITCH
	BEQ PRG061_ADBB	; If this is the Drill Man switch, jump to PRG061_ADBB

	; CHECKME - UNUSED?
	LDA Spr_Frame,X
	ASL A
	ASL A
	TAY		; Y = frame * 4
	
	; Copy palette in
	LDA PRG061_AE97+1,Y
	STA PalData_1+$19
	LDA PRG061_AE97+2,Y
	STA PalData_1+$1A
	LDA PRG061_AE97+3,Y
	STA PalData_1+$1B
	
	; commit palette
	LDA #$FF
	STA <CommitPal_Flag

PRG061_ADBB:
	LDA Spr_Frame+$00,X
	CMP #$02
	BNE PRG061_ADCF	; If frame <> 2, jump to PRG061_ADCF (RTS)

	INC Spr_Var1+$00,X	; $ADC2

PRG061_ADC5:
	; freeze animation
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	LDA Spr_Var2+$00,X
	BNE PRG061_ADF2	; If Spr_Var2 <> 0, jump to PRG061_ADF2


PRG061_ADCF:
	RTS	; $ADCF


PRG061_ADD0:
	INC Spr_Var1+$00,X	; Spr_Var1++
	INC Spr_Var2+$00,X	; Spr_Var2++
	INC Spr_Frame+$00,X	; frame++
	
	LDA #$8E	; $ADD9
	STA PalAnim_EnSel+$02	; $ADDB
	
	LDA #$00	; $ADDE
	STA PalAnim_TickCount+$02	; $ADE0
	STA PalAnim_CurAnimOffset+$02	; $ADE3
	STA Spr_AnimTicks+$00,X	; $ADE6
	
	LDY Spr_XHi+$00,X	; Y = current screen
	
	LDA #$70	; $ADEC
	STA Pattern_AttrBuffer+$30,Y	; $ADEE
	RTS	; $ADF1


PRG061_ADF2:
	LDA PalAnim_EnSel+$02
	BNE PRG061_AE20	; If PalAnim_EnSel+$02 > 0, jump to PRG061_AE20 (RTS)

	LDY Spr_XHi+$00,X	; Y = current screen
	
	LDA #$7F	; $ADFA
	STA Pattern_AttrBuffer+$30,Y	; $ADFC
	
	CPY <Current_Screen
	BNE PRG061_AE20	; If not on current screen, jump to PRG061_AE20 (RTS)

	; Spr_Var2 = $00
	LDA #$00
	STA Spr_Var2+$00,X
	
	STX <Temp_Var0	; Backup slot index -> Temp_Var0
	
	LDX PRG061_AE49,Y	; $AE0A
PRG061_AE0D:
	LDY PRG061_AE61,X	; $AE0D
	BEQ PRG061_AE1A	; $AE10

	LDA #$55	; $AE12
	STA Pattern_AttrBuffer,Y	; $AE14
	
	INX	; $AE17
	BNE PRG061_AE0D	; $AE18


PRG061_AE1A:
	LDA #$FF	; $AE1A
	STA <RAM_001E	; $AE1C
	
	LDX <Temp_Var0	; Restore object index

PRG061_AE20:
	RTS	; $AE20

PRG061_AE21:
	; CHECKME - UNUSED?
	.byte (PRG061_AE25_0 - PRG061_AE25), (PRG061_AE25_1 - PRG061_AE25), (PRG061_AE25_2 - PRG061_AE25), (PRG061_AE25_3 - PRG061_AE25)
	
PRG061_AE25:
PRG061_AE25_0:
	.byte $05, $90, $48, $00
	.byte $05, $50, $48, $00
	.byte $05, $50, $A8, $00
	.byte $05, $90, $A8, $00
	
PRG061_AE25_1:	
	.byte $06, $90, $58, $00
	.byte $06, $70, $88, $00
	.byte $06, $50, $B8, $01
	.byte $06, $A0, $A8, $00

PRG061_AE25_2:	
	.byte $07, $90, $88, $00

PRG061_AE49:
	; $AE41 - $AE49
	.byte $07, $D0, $98, $00
	.byte $08, $10, $A8, $00

PRG061_AE25_3:
	.byte $08, $50, $88, $00
	.byte $08, $A0, $A8, $00


	.byte $00, $12, $12, $29


	; CHECKME - UNUSED?
	.byte $00, $00, $00, $00



PRG061_AE61:
	.byte $23, $24, $25, $2B, $2C, $2D, $2E, $33, $34, $35, $36, $37, $3B, $3C, $3D, $3E	; $AE61 - $AE70
	.byte $3F, $00, $25, $26, $27, $2B, $2C, $2D, $2E, $2F, $31, $32, $33, $34, $35, $36	; $AE71 - $AE80
	.byte $37, $39, $3A, $3B, $3C, $3D, $3E, $3F, $00, $2D, $2E, $32, $33, $34, $35, $36	; $AE81 - $AE90
	.byte $3A, $3B, $3C, $3D, $3E, $00	; $AE91 - $AE96


	; CHECKME - UNUSED?
PRG061_AE97:
	.byte $0F, $0F, $0F, $0F
	.byte $0F, $10, $0F, $08
	.byte $0F, $30, $10, $18


PRG061_Obj_DustmanCrusherAct:
	; Load screen $18 into "other" side of BG
	LDA #$18
	STA <CommitBG_ScrSel
	LDA #$80
	STA <CommitBG_Flag
	
	LDA #LOW(PRG061_Obj_DustmanCrusherAct_C)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_DustmanCrusherAct_C)
	STA Spr_CodePtrH+$00,X
	
	BNE PRG061_AF1E	; Jump (technically always) to PRG061_AF1E


PRG061_Obj_DustmanCrusherAct_C:
	LDA <Raster_VMode
	BNE PRG061_AEE3	; If raster effect active, jump to PRG061_AEE3

	LDA <CommitBG_Flag
	BNE PRG061_AF1E	; If CommitBG_Flag <> 0, jump to PRG061_AF1E

	STA Level_RasterYOff	; Level_RasterYOff = 0
	
	; Raster_VSplit_Req = $C0
	LDA #$C0
	STA <Raster_VSplit_Req
	
	LDA #RVMODE_DUSTMANCRUSH
	STA <Raster_VMode
	
	LDA #$80
	STA Spr_YVelFrac+$00,X
	LDA #$00
	STA Spr_YVel+$00,X
	
	LDA #SPRDIR_UP
	STA Spr_FaceDir+$00,X
	
	LDA #SPRDIR_DOWN
	STA Level_RasterVDir
	
	; Spr_Var1 = $80
	LDA #$80
	STA Spr_Var1+$00,X

PRG061_AEE3:
	JSR PRG063_DoMoveVertOnlyH16

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG061_AF00	; If Spr_Var1 > 0, jump to PRG061_AF00

	; Reverse direction
	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_UP | SPRDIR_DOWN)
	STA Spr_FaceDir+$00,X
	
	LDA Level_RasterVDir
	EOR #(SPRDIR_UP | SPRDIR_DOWN)
	STA Level_RasterVDir
	
	; Spr_Var1 = $80
	LDA #$80
	STA Spr_Var1+$00,X

PRG061_AF00:
	; Set vertical position
	LDA Spr_Y+$00,X	
	STA <Vert_Scroll
	BNE PRG061_AF0B

	STA <PPU_CTL1_PageBaseReq	
	BEQ PRG061_AF0F


PRG061_AF0B:
	LDA #$02	; $AF0B
	STA <PPU_CTL1_PageBaseReq	; $AF0D

PRG061_AF0F:
	LDA Spr_Y+$00,X
	BEQ PRG061_AF1B	; If Spr_Y = 0, jump to PRG061_AF1B

	ADD #$10
	
	EOR #$FF
	ADC #$01

PRG061_AF1B:
	STA Level_RasterYOff

PRG061_AF1E:
	LDA Spr_X+$00
	STA Spr_X+$00,X
	LDA Spr_XHi+$00
	STA Spr_XHi+$00,X
	
	RTS	; $AF2A


PRG061_Obj_DiveMan_BidiWtr1:
PRG061_Obj_DiveMan_BidiWtr2:
	; Load screen $1E into "other" side of BG
	LDA #$1E
	STA <CommitBG_ScrSel
	LDA #$80
	STA <CommitBG_Flag
	
	LDA #LOW(PRG061_Obj_DiveMan_BidiWtrC)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_DiveMan_BidiWtrC)
	STA Spr_CodePtrH+$00,X
	
	BNE PRG061_AF78	; Jump (technically always) to PRG061_AF78


PRG061_Obj_DiveMan_BidiWtrC:
	LDA <Raster_VMode
	BNE PRG061_AF63	; If raster effect enabled, jump to PRG061_AF63

	LDA <CommitBG_Flag	; $AF43
	BNE PRG061_AF87	; $AF45

	; Raster_VSplit_Req = $78
	LDA #$78
	STA <Raster_VSplit_Req
	
	LDA #RVMODE_DMWATER
	STA <Raster_VMode
	
	LDA #SPRDIR_UP
	STA Spr_FaceDir+$00,X
	
	; Spr_Var1 = $90
	LDA #$90
	STA Spr_Var1+$00,X
	
	LDA #$80
	STA Spr_YVelFrac+$00,X
	LDA #$00
	STA Spr_YVel+$00,X

PRG061_AF63:
	JSR PRG063_DoMoveVertOnlyH16

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG061_AF78	; If Spr_Var1 > 0, jump to PRG061_AF78

	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_UP | SPRDIR_DOWN)
	STA Spr_FaceDir+$00,X
	
	; Spr_Var1 = $90
	LDA #$90
	STA Spr_Var1+$00,X

PRG061_AF78:
	LDA Spr_Y+$00,X
	STA <Vert_Scroll
	BNE PRG061_AF83

	STA <PPU_CTL1_PageBaseReq	; $AF7F
	BEQ PRG061_AF87	; $AF81


PRG061_AF83:
	LDA #$02	; $AF83
	STA <PPU_CTL1_PageBaseReq	; $AF85

PRG061_AF87:
	LDA Spr_Y+$00,X
	BEQ PRG061_AF93	; If Spr_Y = 0, jump to PRG061_AF93

	ADD #$10	; $AF8C
	EOR #$FF	; $AF8F
	ADC #$01	; $AF91

PRG061_AF93:
	ADD #$10
	STA Level_RasterYOff
	
	; the bidirectional water controller follows Player
	LDA Spr_X+$00
	STA Spr_X+$00,X
	LDA Spr_XHi+$00
	STA Spr_XHi+$00,X
	
	RTS	; $AFA5


PRG061_Obj_DiveMan_UNK5:
	; What's the point of this object? Might just be for testing?
	LDA Level_RasterYOff
	ADD #$08
	STA Spr_Y+$00,X
	
	RTS	; $AFAF


PRG061_Obj_WaterSplash:
	; Lock splash to water line
	LDA Level_RasterYOff
	STA Spr_Y+$00,X
	RTS	; $AFB6


PRG061_Obj_DustMan_4Plat:
	LDA Spr_Var1+$00,X
	CMP #$3C
	BEQ PRG061_AFC2	; If Spr_Var1 = $3C, jump to PRG061_AFC2

	INC Spr_Var1+$00,X	; Spr_Var1++
	RTS	; $AFC1


PRG061_AFC2:
	LDA Spr_Var2+$00,X
	BNE PRG061_B02F	; If Spr_Var2 > 0, jump to PRG061_B02F

	LDY Spr_Var3+$00,X	; Y = Spr_Var3
	
	LDA PRG061_DM4Plat_Var14,Y
	STA <Temp_Var14
	
	LDA PRG061_DM4Plat_Var15,Y
	STA <Temp_Var15
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG061_B02C	; If no free object slot, jump to PRG061_B02C

	LDA Spr_Var3+$00,X
	PHA	; Save Spr_Var3
	
	AND #$01
	ADC #$39
	STA <Temp_Var16	; $39 or $3A
	
	PLA	; Restore Spr_Var3
	ADC #$A5	; + $A5
	JSR PRG063_InitProjectile

	LDA Spr_Flags+$00,Y
	ORA #SPRFL1_OBJSOLID
	STA Spr_Flags+$00,Y
	
	; Block moving up
	LDA #SPRDIR_UP
	STA Spr_FaceDir+$00,Y
	
	LDA Spr_Y+$00,Y
	ADD <Temp_Var14
	STA Spr_Var1+$00,Y
	
	LDA <Temp_Var15
	STA Spr_Var2+$00,Y
	
	; New block segment = $E8
	LDA #$E8
	STA Spr_Y+$00,Y
	
	; Block moving up
	LDA #$00
	STA Spr_YVelFrac+$00,Y
	LDA #$02
	STA Spr_YVel+$00,Y
	
	LDA #SPRSLOTID_DUSTMAN_PLATSEG
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_Flags2+$00,Y
	
	; Spr_Var2 = $15
	LDA #$15
	STA Spr_Var2+$00,X
	
	INC Spr_Var3+$00,X	; Spr_Var3++
	LDA Spr_Var3+$00,X
	CMP #$04
	BNE PRG061_B02F	; If Spr_Var3 <> 4, jump to PRG061_B02F


PRG061_B02C:
	JMP PRG062_ResetSpriteSlot

PRG061_B02F:
	DEC Spr_Var2+$00,X	; Spr_Var2--
	
PRG061_B032:
	RTS	; $B032


PRG061_Obj_DM4Plat_Seg:
	LDA Spr_Var3+$00,X
	BEQ PRG061_B03D	; If Spr_Var3 = 0, jump to PRG061_B03D

	DEC Spr_Var3,X		; Spr_Var3--
	BNE PRG061_B032		; If Spr_Var3 > 0, jump to PRG061_B032

PRG061_B03D:
	JSR PRG063_DoMoveVertOnlyH16

	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_UP
	BNE PRG061_B04E	; If platform segment moving up, jump to PRG061_B04E

	LDA Spr_YHi,X
	BEQ PRG061_B098		; If vertically on-screen, jump to PRG061_B098 (RTS)
	BNE PRG061_B065		; Otherwise, jump to PRG061_B065

PRG061_B04E:
	LDA Spr_Var1+$00,X
	CMP Spr_Y+$00,X	
	BLT PRG061_B098	; If segment hasn't reached vertical position, jump to PRG061_B098 (RTS)

	STA Spr_Y+$00,X	; Lock vertically
	
	DEC Spr_Var2+$00,X	; Spr_Var2--
	BNE PRG061_B098	; If Spr_Var2 > 0, jump to PRG061_B098

	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM4_DM4PLAT_SEG_RISING
	BEQ PRG061_B068	; If rising animation, jump to PRG061_B068

PRG061_B065:
	JMP PRG062_ResetSpriteSlot	; Hold sprite


PRG061_B068:
	LDA #SPRANM4_DM4PLAT_SEG_SHINE
	JSR PRG063_SetSpriteAnim

	; bbox $14
	LDA #$14
	STA Spr_Flags2+$00,X
	
	; Rise 8 pixels
	LDA Spr_Y+$00,X
	SUB #$08
	STA Spr_Y+$00,X
	
	; Left 8 pixels
	LDA Spr_X+$00,X
	SUB #$08
	STA Spr_X+$00,X
	
	LDA #LOW(PRG061_Obj_DM4Plat_Seg_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_DM4Plat_Seg_Cont)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var1 = $58
	LDA #$58
	STA Spr_Var1+$00,X
	
	; Spr_Var2 = $02
	LDA #$02
	STA Spr_Var2+$00,X

PRG061_B098:
	RTS	; $B098


PRG061_Obj_DM4Plat_Seg_Cont:
	LDA Spr_Frame+$00,X
	CMP #$0C
	BNE PRG061_B0D4	; If frame = $0C, jump to PRG061_B0D4

	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	; Spr_Var1/2 -= 1
	LDA Spr_Var1+$00,X
	SUB #$01
	STA Spr_Var1+$00,X
	LDA Spr_Var2+$00,X
	SBC #$00
	STA Spr_Var2+$00,X
	
	ORA Spr_Var1+$00,X
	BNE PRG061_DM4Plat_Disasm	; If Spr_Var1/2 = $0000, jump to PRG061_DM4Plat_Disasm

	LDA #SPRANM4_DM4PLAT_SEG_DIS
	JSR PRG063_SetSpriteAnim
	
	LDA #LOW(PRG061_DM4Plat_Disasm)
	STA Spr_CodePtrL,X
	LDA #HIGH(PRG061_DM4Plat_Disasm)
	STA Spr_CodePtrH,X
	
	; Spr_Var1 = $58
	LDA #$58
	STA Spr_Var1,X
	
	; Spr_Var2 = $02
	LDA #$02
	STA Spr_Var2,X


PRG061_B0D4:
	RTS	; $B0D4


PRG061_DM4Plat_Disasm:
	LDA Spr_Frame+$00,X
	CMP #$02
	BNE PRG061_B0D4	; If frame = 2, jump to PRG061_B0D4

	; Temp_Var12 = $03
	LDA #$03
	STA <Temp_Var12
	
PRG061_B0E0:
	LDY <Temp_Var12		; Y = Temp_Var12
	
	LDA PRG061_DM4Plat_Var14,Y
	STA <Temp_Var13
	LDA PRG061_DM4Plat_Var14B,Y
	STA <Temp_Var14
	LDA PRG061_DM4Plat_Var15,Y
	STA <Temp_Var15
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG061_B139		; If no empty object slot, jump to PRG061_B139
	
	LDA #SPRANM4_DM4PLAT_SEG_SINKING
	ADC <Temp_Var12
	JSR PRG063_CopySprSlotSetAnim
	
	LDA Spr_Flags,Y
	ORA #$02
	STA Spr_Flags,Y
	
	LDA #SPRDIR_DOWN
	STA Spr_FaceDir,Y
	
	LDA Spr_Y,Y
	ADD <Temp_Var13
	STA Spr_Y,Y
	
	LDA Spr_X,Y
	ADD <Temp_Var14
	STA Spr_X,Y
	
	LDA <Temp_Var15
	STA Spr_Var3,Y
	
	; Move down speed
	LDA #$00
	STA Spr_YVelFrac,Y
	LDA #$02
	STA Spr_YVel,Y
	
	LDA #SPRSLOTID_DUSTMAN_PLATSEG
	STA Spr_SlotID,Y
	
	LDA #$00
	STA Spr_Flags2,Y
	
	DEC <Temp_Var12	; Temp_Var12--
	BPL PRG061_B0E0	; While Temp_Var12 >= 0, loop

PRG061_B139:
	JMP PRG062_ResetSpriteSlot


PRG061_DM4Plat_Var14:
	.byte $F8, $F8, $08, $08	; $B13C - $B13F

PRG061_DM4Plat_Var14B:
	.byte $F8, $08, $F8, $08	; $B140 - $B143

PRG061_DM4Plat_Var15:
	.byte $3D, $29, $15, $01	; $B144 - $B147


PRG061_Obj_BossMothraya:
	JSR PRG063_InitBossMus_Plyr_RetX

	CMP #PLAYERSTATE_BOSSWAIT
	BNE PRG061_B1A6	; If Player wasn't set to boss wait state, jump to PRG061_B1A6 (RTS)

	; Load screen $14 into "other" side of BG
	LDA #$14
	STA <CommitBG_ScrSel
	LDA #$80
	STA <CommitBG_Flag
	
	LDA #LOW(PRG061_Obj_BossMothraya_FadeIn)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_BossMothraya_FadeIn)
	STA Spr_CodePtrH+$00,X
	
	BNE PRG061_B1A6	; Jump (technically always) to PRG061_B1A6 (RTS)

PRG061_Obj_BossMothraya_FadeIn:
	LDA <Raster_VMode
	BNE PRG061_B17D	; If raster effect active, jump to PRG061_B17D

	LDA <CommitBG_Flag
	BNE PRG061_B1A6

	STA <General_Counter	; $B16B
	
	; Raster_VSplit_Req = $A0
	LDA #$A0
	STA <Raster_VSplit_Req
	
	; Set raster mode
	LDA #RVMODE_CBOSS1
	STA <Raster_VMode
	
	; Spr_Var1 = $30 (fade level for boss fade in)
	LDA #$30
	STA Spr_Var1+$00,X
	
	JSR PRG061_Mothraya_SetRasterH


PRG061_B17D:
	LDA <General_Counter
	AND #$0F
	BNE PRG061_B1A6	; 15:16 jump to PRG061_B1A6 (RTS)

	; Fade in boss
	LDY #$0B	; Y = $0B
PRG061_B185:
	LDA PRG061_Mothraya_Pal,Y
	SUB Spr_Var1+$00,X	; Subtract fade level
	BCS PRG061_B190	; If didn't underflow, jump to PRG061_B190

	LDA #$0F	; A = $0F (min pal darkness)

PRG061_B190:
	STA PalData_1+4,Y
	STA PalData_2+4,Y
	DEY	; Y--
	BPL PRG061_B185	; While Y >= 0, loop

	STY <CommitPal_Flag	; Commit palette
	
	; Spr_Var1
	LDA Spr_Var1+$00,X
	SUB #$10
	STA Spr_Var1+$00,X
	BCC PRG061_B1A7	; If underflowed (fade done), jump toPRG061_B1A7


PRG061_B1A6:
	RTS	; $B1A6


PRG061_B1A7:
	LDA #LOW(PRG061_Obj_BossMothraya_FillHP)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_BossMothraya_FillHP)
	STA Spr_CodePtrH+$00,X
	
	LDA #$80
	STA Spr_XVelFrac+$00,X
	LDA #$00
	STA Spr_XVel+$00,X
	
	LDA #$40
	STA Spr_YVelFrac+$00,X
	LDA #$00
	STA Spr_YVel+$00,X
	
	; Spr_Var1 = $20
	LDA #$20
	STA Spr_Var1+$00,X
	
	LDA #(SPRDIR_RIGHT | SPRDIR_UP)
	STA Spr_FaceDir+$00,X
	
	; Spr_Var4 = $78
	LDA #$78
	STA Spr_Var4+$00,X
	
	; Spr_Var5 = $5A
	LDA #$5A
	STA Spr_Var5+$00,X
	
	; Spr_Var6 = $FF
	LDA #$FF
	STA Spr_Var6+$00,X
	
	LDA #(SPRFL1_ONSCREEN | SPRFL1_SCREENREL)
	STA Spr_Flags+$00,X
	STA Spr_Flags+$15	
	
	LDA #(SPRFL1_ONSCREEN | SPRFL1_SCREENREL | SPR_BEHINDBG)
	STA Spr_Flags+$16
	
	LDA #$8F	; $B1EB
	STA HUDBarB_DispSetting	; $B1ED
	
	LDA #$00
	STA <General_Counter
	STA <Boss_HP

PRG061_B1F6:
	RTS	; $B1F6


PRG061_Obj_BossMothraya_FillHP:
	LDA <General_Counter
	AND #$07
	BNE PRG061_B1F6	; 7:8 ticks jump to PRG061_B1F6 (RTS)

	; Energy gain sound
	LDA #SFX_ENERGYGAIN
	JSR PRG063_QueueMusSnd

	INC <Boss_HP	; Boss_HP++
	LDA <Boss_HP
	CMP #$1C
	BNE PRG061_B1F6	; If not at max boss HP, jump to PRG061_B1F6 (RTS)

	LDA #LOW(PRG061_Obj_BossMothraya_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_BossMothraya_Cont)
	STA Spr_CodePtrH+$00,X
	
	; Release Player
	LDA #PLAYERSTATE_STAND
	STA <Player_State

PRG061_Obj_BossMothraya_Cont:
	LDA Spr_Var2+$00,X
	BNE PRG061_B269	; If Spr_Var2 <> 0, jump to PRG061_B269

	JSR PRG063_ApplyVelSetFaceDir
	JSR PRG063_DoMoveVertOnlyH16

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG061_B26F	; If Spr_Var1 > 0, jump to PRG061_B26F

	; Spr_Var3 = 0 to 9
	INC Spr_Var3+$00,X	; Spr_Var3++
	LDA Spr_Var3+$00,X
	CMP #$0A
	BNE PRG061_B237	; If Spr_Var3 <> $0A, jump to PRG061_B237

	; Spr_Var3 = 0
	LDA #$00
	STA Spr_Var3+$00,X

PRG061_B237:
	LDY Spr_Var3+$00,X	; Y = Spr_Var3
	
	LDA PRG061_Mothraya_DirTime,Y
	STA Spr_Var1+$00,X
	
	; Reverse vertical direction
	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_UP | SPRDIR_DOWN)
	STA Spr_FaceDir+$00,X
	
	AND #SPRDIR_RIGHT
	BEQ PRG061_B255	; If not moving right, jump to PRG061_B255

	LDA Spr_X+$00,X
	CMP #$C0
	
	BNE PRG061_B296	; If Mothraya X <> $C0, jump to PRG061_B296
	BEQ PRG061_B25C	; Otherwise, jump to PRG061_B25C


PRG061_B255:
	LDA Spr_X+$00,X
	CMP #$40
	BNE PRG061_B296	; If Mothraya X <> $40, jump to PRG061_B296


PRG061_B25C:
	; Reverse horizontal direction
	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_LEFT | SPRDIR_RIGHT)
	STA Spr_FaceDir+$00,X
	
	; Spr_Var2 = $15
	LDA #$15
	STA Spr_Var2+$00,X

PRG061_B269:
	DEC Spr_Var2+$00,X	; Spr_Var2--
	JMP PRG061_B296	; Jump to PRG061_B296


PRG061_B26F:
	LDA Spr_Var6+$00,X
	BEQ PRG061_B27C	; If Spr_Var6 = 0, jump to PRG061_B27C

	DEC Spr_Var6+$00,X	; Spr_Var6--
	BNE PRG061_B296		; If Spr_Var6 > 0, jump to PRG061_B296

	JSR PRG061_Mothraya_DoActXDiv64


PRG061_B27C:
	LDA Spr_X+$00,X
	CMP Spr_Var8+$00,X
	BNE PRG061_B293	; If X <> Spr_Var8, jump to PRG061_B293

	LDA #LOW(PRG061_B37B)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_B37B)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var6 = $1E
	LDA #$1E
	STA Spr_Var6+$00,X

PRG061_B293:
	JMP PRG061_B2EE	; Jump to PRG061_B2EE


PRG061_B296:
	DEC Spr_Var4+$00,X	; Spr_Var4--
	BNE PRG061_B2BA	; If Spr_Var4 > 0, jump to PRG061_B2BA

	; Spr_Var4 = $78
	LDA #$78
	STA Spr_Var4+$00,X
	
	LDA <RandomN+$00
	ADC <RandomN+$01
	AND #$03
	BNE PRG061_B2BA	; 3:4, jump to PRG061_B2BA

	LDA #LOW(PRG061_B326)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_B326)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var4 = $10
	LDA #$10
	STA Spr_Var4+$00,X
	
	JMP PRG061_B2EE	; Jump to PRG061_B2EE


PRG061_B2BA:
	DEC Spr_Var5+$00,X	; Spr_Var5--
	BNE PRG061_B2EE	; If Spr_Var5 > 0, jump to PRG061_B2EE

	; Spr_Var5 = $5A
	LDA #$5A
	STA Spr_Var5+$00,X
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG061_B2EE	; If no free object slot, jump to PRG061_B2EE

	LDA #SPRANM3_MOTHRAYA_SHOT
	JSR PRG063_CopySprSlotSetAnim

	LDA #SPRSLOTID_MOTHRAYA_SHOT
	STA Spr_SlotID+$00,Y
	
	LDA #SPRFL2_HURTPLAYER
	STA Spr_Flags2+$00,Y
	
	STX <Temp_Var15	; Backup object slot index -> Temp_Var15
	
	; Y -> X
	TYA
	TAX
	
	; Shot speed 2.0
	LDA #$00
	STA <Temp_Var2
	LDA #$02
	STA <Temp_Var3
	
	JSR PRG063_AimPlayer_Var23Spd

	; Shot direction
	LDA <Temp_Var12
	STA Spr_FaceDir+$00,X
	
	LDX <Temp_Var15	; Restore object slot index

PRG061_B2EE:
	LDA Spr_X+$17
	STA Spr_X+$16	; Hook
	STA Spr_X+$15	; Eyes
	
	LDA #$00
	STA <PPU_CTL1_PageBaseReq
	
	LDA Spr_Y+$17
	SUB #$1C
	STA Spr_Y+$16	; Hook
	STA Spr_Y+$15	; Eyes
	
	LDA #$6C
	SUB Spr_Y+$17
	STA <Vert_Scroll
	BCS PRG061_Mothraya_SetRasterH

	SBC #$0F
	STA <Vert_Scroll
	
	LDA #$02
	STA <PPU_CTL1_PageBaseReq

PRG061_Mothraya_SetRasterH:
	LDA #$80
	SUB Spr_X+$17
	STA <Raster_VSplit_HPosReq
	
	LDA <PPU_CTL1_PageBaseReq
	STA <PPU_CTL1_PageBaseReq_RVBoss
	
	RTS	; $B325


PRG061_B326:

	; Spr_Y += 2
	INC Spr_Y+$00,X
	INC Spr_Y+$00,X
	
	DEC Spr_Var4+$00,X	; Spr_Var4--
	BNE PRG061_B377	; If Spr_Var4 > 0, jump to PRG061_B377

	; Spr_Var4 = $1E
	LDA #$1E
	STA Spr_Var4+$00,X
	
	LDA #LOW(PRG061_B342)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_B342)
	STA Spr_CodePtrH+$00,X
	
	BNE PRG061_B377	; Jump (technically always) to PRG061_B377

PRG061_B342:
	DEC Spr_Var4+$00,X	; Spr_Var4--
	BNE PRG061_B377	; If Spr_Var4 > 0, jump to PRG061_B377

	; Spr_Var4 = $10
	LDA #$10
	STA Spr_Var4+$00,X
	
	LDA #LOW(PRG061_B358)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_B358)
	STA Spr_CodePtrH+$00,X
	
	BNE PRG061_B377	; Jump (technically always) to PRG061_B377

PRG061_B358:
	; Spr_Y -=2
	DEC Spr_Y+$00,X
	DEC Spr_Y+$00,X
	
	DEC Spr_Var4+$00,X	; Spr_Var4--
	BNE PRG061_B377	; If Spr_Var4 > 0, jump to PRG061_B377

	; Spr_Var4 = $0A
	LDA #$0A
	STA Spr_Var4+$00,X
	
	LDA #LOW(PRG061_Obj_BossMothraya_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_BossMothraya_Cont)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var4 = $78
	LDA #$78
	STA Spr_Var4+$00,X

PRG061_B377:
	JMP PRG061_B2EE	; Jump to PRG061_B2EE


PRG061_B37A:
	RTS	; $B37A

PRG061_B37B:
	DEC Spr_Var6+$00,X	; Spr_Var6--
	BNE PRG061_B37A	; If Spr_Var6 > 0, jump to PRG061_B37A (RTS)

	LDA #LOW(PRG061_B392)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_B392)
	STA Spr_CodePtrH+$00,X
	
	; Hook shake left
	DEC Spr_X+$16
	
	; Spr_Var6 = $1F
	LDA #$1F
	STA Spr_Var6+$00,X
	
PRG061_B392:
	LDA Spr_Var6+$00,X
	AND #$01
	BEQ PRG061_B3A2	; 1:2 jump to PRG061_B3A2

	; Hook shake right
	INC Spr_X+$16
	INC Spr_X+$16
	
	JMP PRG061_B3A8	; Jump to PRG061_B3A8


PRG061_B3A2:
	; Hook shake left
	DEC Spr_X+$16
	DEC Spr_X+$16

PRG061_B3A8:
	DEC Spr_Var6+$00,X	; Spr_Var6--
	BNE PRG061_B37A	; If Spr_Var6 > 0, jump to PRG061_B37A (RTS)

	; Hook shake left
	DEC Spr_X+$16
	
	LDA #LOW(PRG061_B3C0)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_B3C0)
	STA Spr_CodePtrH+$00,X
	
	; Hook Y -> Spr_Var7
	LDA Spr_Y+$16
	STA Spr_Var7+$00,X	
	
PRG061_B3C0:
	; Hook's Y += 4
	LDA Spr_Y+$16
	ADD #$04
	STA Spr_Y+$16
	
	CMP #$80
	BLT PRG061_B37A	; If hook Y < $80, jump to PRG061_B37A (RTS)

	STX <Temp_Var0	; Backup object slot index -> <Temp_Var0
	
	; Following loop spawns the explosion and debris from the hook hitting the floor
	
	; Temp_Var1 = 4
	LDA #$04
	STA <Temp_Var1
PRG061_B3D3:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG061_B40F	; If no empty slot, jump to PRG061_B40F

	LDX <Temp_Var1	; X = 4 to 0
	
	LDA PRG061_MothrayaBustFlr_SlotID,X
	STA Spr_SlotID+$00,Y
	
	LDA PRG061_MothrayaBustFlr_XVelF,X
	STA Spr_XVelFrac+$00,Y
	LDA PRG061_MothrayaBustFlr_XVel,X
	STA Spr_XVel+$00,Y
	
	LDA PRG061_MothrayaBustFlr_YVelF,X
	STA Spr_YVelFrac+$00,Y
	LDA PRG061_MothrayaBustFlr_YVel,X
	STA Spr_YVel+$00,Y
	
	LDA PRG061_MothrayaBustFlr_FDir,X
	STA Spr_FaceDir+$00,Y
	
	LDA PRG061_MothrayaBustFlr_Anim,X
	LDX <Temp_Var0	; Restore object slot index
	JSR PRG063_CopySprSlotSetAnim

	; Spr_Y = $80
	LDA #$B0
	STA Spr_Y+$00,Y
	
	DEC <Temp_Var1	; Temp_Var1--
	BPL PRG061_B3D3	; While Temp_Var1 >= 0, loop


PRG061_B40F:
	LDX <Temp_Var0	; Restore object slot index
	
	LDA #LOW(PRG061_B49C)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_B49C)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var6 = $14
	LDA #$14
	STA Spr_Var6+$00,X
	
	LDA #$22
	STA Graphics_Buffer+$00
	STA Graphics_Buffer+$07
	
	LDA #$23
	STA Graphics_Buffer+$0E
	STA Graphics_Buffer+$15
	
	LDY Spr_XVel+$16	; $B430
	
	LDA PRG061_Mothraya_GBufVADDRL,Y
	STA Graphics_Buffer+$01
	ADD #$20
	STA Graphics_Buffer+$08
	ADD #$20
	STA Graphics_Buffer+$0F
	ADD #$20
	STA Graphics_Buffer+$16
	
	LDA #$03
	STA Graphics_Buffer+$02
	STA Graphics_Buffer+$09
	STA Graphics_Buffer+$10
	STA Graphics_Buffer+$17
	
	STX <Temp_Var0	; $B459
	
	LDY Spr_XVelFrac+$16	; $B45B
	
	LDX #$00	; X = 0
PRG061_B460:
	
	LDA PRG061_Mothraya_GBufData1,Y
	STA Graphics_Buffer+$03,X
	LDA PRG061_Mothraya_GBufData2,Y
	STA Graphics_Buffer+$0A,X
	LDA PRG061_Mothraya_GBufData3,Y
	STA Graphics_Buffer+$11,X
	LDA PRG061_Mothraya_GBufData4,Y
	STA Graphics_Buffer+$18,X
	
	INY	; Y++
	INX	; X++
	CPX #$04
	BNE PRG061_B460	; While X < 4, loop

	LDY Spr_Var1+$16	; $B47E
	
	LDX #$00	; X = 0
PRG061_B483:
	LDA PRG061_Mothraya_ScrTileModData,Y
	ORA Level_ScreenTileModData+$16,X
	STA Level_ScreenTileModData+$16,X
	
	INY	; Y++
	INX	; X++
	CPX #$04
	BNE PRG061_B483	; While X < 4, loop

	LDA #$FF
	STA Graphics_Buffer+$1C	; terminator
	STA <CommitGBuf_Flag	; commit graphics
	
	LDX <Temp_Var0
	RTS	; $B49B

PRG061_B49C:
	LDA Spr_Var6+$00,X
	BEQ PRG061_B4A6	; If Spr_Var6 = 0, jump to PRG061_B4A6

	DEC Spr_Var6+$00,X	; Spr_Var6--
	BNE PRG061_B4C3	; If Spr_Var6 > 0, jump to PRG061_B4C3 (RTS)


PRG061_B4A6:
	; Retracting hook
	LDA Spr_Y+$16
	SUB #$04
	STA Spr_Y+$16
	
	CMP Spr_Var7+$00,X
	BNE PRG061_B4C3	; If hook's not back in position, jump to PRG061_B4C3 (RTS)

	LDA #LOW(PRG061_Obj_BossMothraya_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_BossMothraya_Cont)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var6 = $FF
	LDA #$FF
	STA Spr_Var6+$00,X

PRG061_B4C3:
	RTS	; $B4C3


PRG061_Mothraya_DoActXDiv64:
	LDA #$00
	STA Spr_XVelFrac+$16
	
	LDA Spr_X+$00
	LSR A	; / 2
	LSR A	; / 4
	LSR A	; / 8
	LSR A	; / 16
	LSR A	; / 32
	LSR A	; / 64
	TAY	; -> 'Y'
	
	; Select next move based on X position / 64
	LDA PRG061_B5C0,Y
	STA <Temp_Var0
	LDA PRG061_B5C4,Y
	STA <Temp_Var1
	
	JMP [Temp_Var0]

PRG061_B4E0:
	LDY #$00	; $B4E0
	LDA Level_ScreenTileModData+$16	; $B4E2
	AND #$18	; $B4E5
	BEQ PRG061_B4F7	; $B4E7

	; CHECKME - UNUSED?
	LDY #$04
	LDA Level_ScreenTileModData+$18
	AND #$18
	BNE PRG061_B504
	LDA #$10
	STA Spr_XVelFrac+$16

PRG061_B4F7:
	LDA #$00	; $B4F7
	STA Spr_XVel+$16	; $B4F9
	LDA #$41	; $B4FC
	STA Spr_Var8+$00,X	; $B4FE
	JMP PRG061_B588	; $B501


PRG061_B504:
	LDA #$FF
	STA Spr_Var6,X
	RTS


PRG061_B50A:
	LDA #$00	; $B50A
	STA <Temp_Var0	; $B50C
	BEQ PRG061_B514	; $B50E

PRG061_B510:
	LDA #$02
	STA <Temp_Var0



PRG061_B514:
	LDA <RandomN+$00	; $B514
	ADC <RandomN+$02	; $B516
	STA <RandomN+$02	; $B518
	AND #$01	; $B51A
	ORA <Temp_Var0	; $B51C
	TAY	; $B51E
	LDA PRG061_B613,Y	; $B51F
	STY <Temp_Var1	; $B522
	TAY	; $B524
	LDA Level_ScreenTileModData+$16	; $B525
	AND PRG061_Mothraya_ScrTileModData,Y	; $B528
	STA <Temp_Var2	; $B52B
	LDA Level_ScreenTileModData+$17	; $B52D
	AND PRG061_Mothraya_ScrTileModData+1,Y	; $B530
	ORA <Temp_Var2	; $B533
	BEQ PRG061_B552	; $B535

	LDA #$10
	STA Spr_XVelFrac+$16
	INY
	INY
	INY
	INY
	LDA Level_ScreenTileModData+$18
	AND PRG061_Mothraya_ScrTileModData,Y
	STA <Temp_Var2
	LDA Level_ScreenTileModData+$19
	AND PRG061_Mothraya_ScrTileModData+1,Y
	ORA <Temp_Var2
	BNE PRG061_B504

PRG061_B552:
	STY <Temp_Var2	; $B552
	
	LDY <Temp_Var1	; $B554
	
	LDA PRG061_B60B,Y	; $B556
	STA Spr_Var8+$00,X	; $B559
	
	LDA PRG061_B60F,Y	; $B55C
	STA Spr_XVel+$16	; $B55F
	
	LDY <Temp_Var2	; $B562
	JMP PRG061_B588	; $B564


PRG061_B567:
	LDY #$10
	LDA Level_ScreenTileModData+$17
	AND #$18
	BEQ PRG061_B57E

PRG061_B570:
	LDY #$14
	LDA Level_ScreenTileModData+$19
	AND #$18
	BNE PRG061_B504
	
	LDA #$10
	STA Spr_XVelFrac+$16


PRG061_B57E:
	LDA #$02
	STA Spr_XVel+$16
	
	; Spr_Var8 = $BF
	LDA #$BF
	STA Spr_Var8+$00,X

PRG061_B588:
	STY Spr_Var1+$16
	
	; Temp_Var0	= $01
	LDA #$01
	STA <Temp_Var0	
	
	LDA Spr_X+$00,X	; $B58F
	CMP Spr_Var8+$00,X	; $B592
	BEQ PRG061_B5BF	; $B595
	BCC PRG061_B59D	; $B597

	; Temp_Var0 = 2
	LDA #$02
	STA <Temp_Var0

PRG061_B59D:
	LDA Spr_FaceDir+$00,X
	AND <Temp_Var0	; $B5A0
	BNE PRG061_B5BF	; $B5A2

	LDA Spr_FaceDir,X
	EOR #(SPRDIR_RIGHT | SPRDIR_LEFT | SPRDIR_UP | SPRDIR_DOWN)
	STA Spr_FaceDir,X
	
	LDY Spr_Var3,X
	
	LDA PRG061_Mothraya_DirTime,Y
	SUB Spr_Var1,X
	STA Spr_Var1,X
	
	LDA PRG061_B617,Y
	STA Spr_Var3,X


PRG061_B5BF:
	RTS	; $B5BF


PRG061_B5C0:
	.byte LOW(PRG061_B4E0)
	.byte LOW(PRG061_B50A)
	.byte LOW(PRG061_B510)
	.byte LOW(PRG061_B567)

PRG061_B5C4:
	.byte HIGH(PRG061_B4E0)
	.byte HIGH(PRG061_B50A)
	.byte HIGH(PRG061_B510)
	.byte HIGH(PRG061_B567)


PRG061_Obj_Mothraya_Shot:
	JSR PRG063_ApplyVelSetFaceDir	; $B5C8

	JMP PRG063_DoMoveVertOnlyH16	; $B5CB

	; CHECKME - UNUSED?
	.byte $0F, $30, $2C, $11	; $B5CE - $B5D1



PRG061_Mothraya_Pal:
	.byte $0F, $36, $26, $16, $0F, $20, $25, $16, $0F, $20, $23, $16
	
PRG061_Mothraya_DirTime:
	.byte $40, $40, $20, $20, $40, $40, $40, $20, $20, $40
	
PRG061_Mothraya_GBufVADDRL:
	.byte $C6, $CE, $D6

PRG061_Mothraya_GBufData1:
	.byte $0A, $00, $00, $0B

PRG061_Mothraya_GBufData2:
	.byte $18, $00, $00, $19

PRG061_Mothraya_GBufData3:
	.byte $0E, $08, $09, $0E
	
PRG061_Mothraya_GBufData4:
	.byte $1E, $1E, $1E, $1E


	; CHECKME - UNUSED?
	.byte $0A, $00, $00, $0B, $18, $00, $00, $19, $0A, $00, $00, $0B, $1A, $00, $00, $1B	; $B5FB - $B60A

PRG061_B60B:
	.byte $41, $80, $80, $BF
	
PRG061_B60F:
	.byte $00, $01, $01, $02

PRG061_B613:
	.byte $00, $08, $08, $10
	
PRG061_B617:
	.byte $05, $04, $03, $02, $01, $00, $09, $08, $07, $06	; $B615 - $B620



PRG061_Mothraya_ScrTileModData:
	.byte $18, $00, $00, $00
	.byte $18, $00, $18, $00
	.byte $80, $01, $00, $00
	.byte $80, $01, $80, $01
	.byte $00, $18, $00, $00
	.byte $00, $18, $00, $18


PRG061_MothrayaBustFlr_YVelF:
	.byte $00, $D4, $E5, $00, $74

PRG061_MothrayaBustFlr_YVel:
	.byte $00, $02, $04, $02, $03

PRG061_MothrayaBustFlr_XVelF:
	.byte $00, $0F, $68, $80, $26

PRG061_MothrayaBustFlr_XVel:
	.byte $00, $01, $00, $00, $01

PRG061_MothrayaBustFlr_FDir:
	.byte $00, SPRDIR_LEFT, SPRDIR_LEFT, SPRDIR_LEFT, SPRDIR_RIGHT

PRG061_MothrayaBustFlr_Anim:
	.byte $62, $4C, $4D, $4E, $4F

PRG061_MothrayaBustFlr_SlotID:
	.byte SPRSLOTID_CIRCULAREXPLOSION, SPRSLOTID_MOTHRAYA_DEBRIS, SPRSLOTID_MOTHRAYA_DEBRIS, SPRSLOTID_MOTHRAYA_DEBRIS, SPRSLOTID_MOTHRAYA_DEBRIS



PRG061_Obj_Cossack1_UNK1:
PRG061_Obj_Cossack1_UNK2:
PRG061_B65C:
	RTS	; $B65C


PRG061_Obj_CossackCatcher:
	JSR PRG063_InitBossMus_Plyr_RetX

	CMP #PLAYERSTATE_BOSSWAIT
	BNE PRG061_B65C	; If Player's state is not boss wait, jump to PRG061_B65C (RTS)

	; Load screen $14 into "other" side of BG
	LDA #$14
	STA <CommitBG_ScrSel
	LDA #$80
	STA <CommitBG_Flag
	
	LDA #LOW(PRG061_Obj_CCatch_FadeIn)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_CCatch_FadeIn)
	STA Spr_CodePtrH+$00,X
	
	BNE PRG061_B6E0	; Jump (technically always) to PRG061_B6E0 (RTS)


PRG061_Obj_CCatch_FadeIn:
	LDA <Raster_VMode
	BNE PRG061_B692	; If raster effect active, jump to PRG061_B692

	LDA <CommitBG_Flag
	BNE PRG061_B6E0	; If committing graphics, jump to PRG061_B6E0 (RTS)

	STA <General_Counter
	
	; Raster_VSplit_Req = $90
	LDA #$90
	STA <Raster_VSplit_Req
	
	LDA #RVMODE_CBOSS4
	STA <Raster_VMode
	
	; Spr_Var1 = $30 (fade level)
	LDA #$30
	STA Spr_Var1+$00,X
	
	JSR PRG061_CCatch_UpdRastrHAndPage


PRG061_B692:
	LDA <General_Counter
	AND #$0F
	BNE PRG061_B6E0	; 15:16 jump to PRG061_B6E0 (RTS)

	LDY #$07	; Y = $07

PRG061_B69A:
	LDA PRG061_CCatch_Pal,Y
	SUB Spr_Var1+$00,X	; Subtract fade level
	
	BCS PRG061_B6A5	; If didn't underflow, jump to PRG061_B6A5

	LDA #$0F	; A = $0F (min fade)

PRG061_B6A5:
	STA PalData_1+8,Y
	STA PalData_2+8,Y
	DEY	; Y--
	BPL PRG061_B69A	; While Y >= 0, loop

	STY <CommitPal_Flag	; Commit palette
	
	; Less fade
	LDA Spr_Var1+$00,X
	SUB #$10
	STA Spr_Var1+$00,X
	BCS PRG061_B6E0	; If fade not complete, jump to PRG061_B6E0 (RTS)

	LDA #LOW(PRG061_Obj_CCatch_HPFill)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_CCatch_HPFill)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var4 = $78
	LDA #$78
	STA Spr_Var4+$00,X
	
	; Boss meter appears
	LDA #$8F
	STA HUDBarB_DispSetting
	
	LDA #$00
	STA <General_Counter
	STA <Boss_HP
	
	LDA #(SPRFL1_ONSCREEN | SPRFL1_SCREENREL)
	STA Spr_Flags+$00,X
	STA Spr_Flags+$16	
	STA Spr_Flags+$15	

PRG061_B6E0:
	RTS	; $B6E0


PRG061_Obj_CCatch_HPFill:
	LDA <General_Counter
	AND #$07
	BNE PRG061_B6E0	; 7:8 jump to PRG061_B6E0 (RTS)

	LDA #SFX_ENERGYGAIN
	JSR PRG063_QueueMusSnd

	INC <Boss_HP	; Boss_HP++
	LDA <Boss_HP
	CMP #$1C	
	BNE PRG061_B6E0	; If boss not fully charged, jump to PRG061_B6E0 (RTS)

	LDA #LOW(PRG061_Obj_CCatch_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_CCatch_Cont)
	STA Spr_CodePtrH+$00,X
	
	LDA #PLAYERSTATE_STAND
	STA <Player_State
	

PRG061_Obj_CCatch_Cont:
	LDA Spr_Var1+$00,X
	BEQ PRG061_B719	; If Spr_Var1 = 0, jump to PRG061_B719

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG061_B718	; If Spr_Var1 > 0, jump to PRG061_B718 (RTS)

	LDY #$16	; Y = $16
	
	LDA #SPRANM2_COSSACKCLAW_GRABBY
	CMP Spr_CurrentAnim+$16
	BEQ PRG061_B718	; If claws are grabby, jump to PRG061_B718 (RTS)

	; Set claw grabby animation
	JSR PRG063_SetSpriteAnimY


PRG061_B718:
	RTS	; $B718


PRG061_B719:
	LDA <RandomN+$00
	ADC <RandomN+$01
	STA <RandomN+$01
	AND #$03
	TAY	; Y = 0 to 3
	
	LDA PRG061_BA70,Y
	STA Spr_Var2+$00,X
	
	CMP Spr_Y+$00,X
	BEQ PRG061_B75C
	BGE PRG061_B733

	LDA #SPRDIR_UP
	
	BNE PRG061_B735	; Jump (technically always) to PRG061_B735


PRG061_B733:

	LDA #SPRDIR_DOWN

PRG061_B735:
	STA Spr_FaceDir+$00,X
	
	LDA #LOW(PRG061_Obj_CCatch_Move)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_CCatch_Move)
	STA Spr_CodePtrH+$00,X
	

PRG061_Obj_CCatch_Move:
	LDA Spr_Y+$00,X
	CMP Spr_Var2+$00,X
	BEQ PRG061_B75C	; If Cossack catcher has reached target Y, jump to PRG061_B75C

	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_UP
	BEQ PRG061_B756	; If moving down, jump to PRG061_B756

	DEC Spr_Y+$00,X	; Spr_Y-- move up
	BNE PRG061_B759	; Jump (technically always) to PRG061_B759


PRG061_B756:
	INC Spr_Y+$00,X	; Spr_Y++ move down

PRG061_B759:
	JMP PRG061_B7CE	; Jump to PRG061_B7CE


PRG061_B75C:
	LDA <RandomN+$00
	ADC <RandomN+$01
	STA <RandomN+$01
	AND #$01
	TAY	; Y = 0 to 1
	
	LDA PRG061_CCatch_Var3,Y
	STA Spr_Var3+$00,X
	
	JSR PRG063_SetObjFacePlayer

	LDA #LOW(PRG061_Obj_CCatch_Catch)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_CCatch_Catch)
	STA Spr_CodePtrH+$00,X
	

PRG061_Obj_CCatch_Catch:
	JSR PRG063_ApplyVelSetFaceDir

	LDA Spr_X+$00,X
	CMP #$E0
	BGE PRG061_B78F	; If Spr_X >= $E0, jump to PRG061_B78F

	CMP #$28
	BGE PRG061_B79E	; If Spr_X >= $28, jump to PRG061_B79E

	; At left edge...
	LDA Spr_FaceDir,X
	AND #SPRDIR_LEFT
	BNE PRG061_B796		; If moving left at left edge, jump to PRG061_B796
	BEQ PRG061_B79E		; Otherwise, jump to PRG061_B79E


PRG061_B78F:
	; At right edge...
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BEQ PRG061_B79E	; If moving left, jump to PRG061_B79E

PRG061_B796:
	; Reverse direction
	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_LEFT | SPRDIR_RIGHT)
	STA Spr_FaceDir+$00,X

PRG061_B79E:
	DEC Spr_Var3+$00,X	; Spr_Var3--
	BEQ PRG061_B7BF	; If Spr_Var3 = 0, jump to PRG061_B7BF

	JSR PRG063_CalcObjXDiffFromPlayer

	CMP #$10
	BGE PRG061_B7CE	; If Player X diff >= $10, jump to PRG061_B7CE

	LDA <RandomN+$00
	ADC <RandomN+$01
	STA <RandomN+$00
	AND #$07
	BNE PRG061_B7CE	; 7:8 jump to PRG061_B7CE

	LDA #LOW(PRG061_B865)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_B865)
	STA Spr_CodePtrH+$00,X
	
	RTS	; $B7BE


PRG061_B7BF:
	; Spr_Var1 = $78
	LDA #$78
	STA Spr_Var1+$00,X
	
	LDA #LOW(PRG061_Obj_CCatch_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_CCatch_Cont)
	STA Spr_CodePtrH+$00,X

PRG061_B7CE:
	DEC Spr_Var4+$00,X	; Spr_Var4--
	BNE PRG061_B83D	; If Spr_Var4 > 0, jump to PRG061_B83D

	LDA <RandomN+$00
	ADC <RandomN+$01
	STA <RandomN+$00
	AND #$01
	TAY	; Y = 0 to 1
	
	LDA PRG061_CCatch_Var4,Y
	STA Spr_Var4+$00,X
	
	; Save face dir
	LDA Spr_FaceDir+$00,X
	PHA
	
	JSR PRG063_SetObjFacePlayer

	LDA Spr_FaceDir+$00,X
	STA <Temp_Var17		; Facing direction -> Temp_Var17
	
	AND #SPRDIR_RIGHT
	ORA #$52	; $52 or $53
	STA <Temp_Var16
	
	; Restore face dir
	PLA
	STA Spr_FaceDir+$00,X
	
	; Temp_Var18 = $02 (3 bullets)
	LDA #$02
	STA <Temp_Var18

PRG061_B7FC:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG061_B83D	; If no empty object slot, jump to PRG061_B83D

	LDA #SPRANM4_CIRCLEBULLET
	JSR PRG063_InitProjectile

	LDA #SPRSLOTID_COSSACK4_BULLET
	STA Spr_SlotID+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | $0E)
	STA Spr_Flags2+$00,Y
	
	STX <Temp_Var0	; Backup object slot index -> Temp_Var0
	
	LDX <Temp_Var18	; X = bullet init index
	
	; bullet horizontal speed
	LDA PRG061_CCatchBullet_XVelFrac,X
	STA Spr_XVelFrac+$00,Y
	LDA PRG061_CCatchBullet_XVel,X
	STA Spr_XVel+$00,Y
	
	; bullet vertical speed
	LDA PRG061_CCatchBullet_YVelFrac,X
	STA Spr_YVelFrac+$00,Y
	LDA PRG061_CCatchBullet_YVel,X
	STA Spr_YVel+$00,Y
	
	LDA <Temp_Var17	; Detected direction
	AND PRG061_CCatchBullet_DirMask,X
	ORA PRG061_CCatchBullet_Dir,X
	STA Spr_FaceDir+$00,Y	; -> bullet dir
	
	LDX <Temp_Var0	; Restore object slot index
	
	DEC <Temp_Var18	; Temp_Var18--
	BPL PRG061_B7FC	; While Temp_Var18 >= 0, loop


PRG061_B83D:
	LDA <Player_State
	CMP #PLAYERSTATE_SLIDING
	BGE PRG061_B89C	; If Player is not standing or falling/jumping, jump to PRG061_B89C

	; Temporarily add $28 to Y
	LDA Spr_Y+$00,X
	PHA
	ADD #$28
	STA Spr_Y+$00,X
	
	; Save Spr_Flags2
	LDA Spr_Flags2+$00,X
	PHA
	
	LDA #$00
	STA Spr_Flags2+$00,X
	
	; Test at +$28 without hurting Player
	JSR PRG063_TestPlayerObjCollide

	; Restore Spr_Flags2
	PLA
	STA Spr_Flags2+$00,X
	
	; Restore Y
	PLA
	STA Spr_Y+$00,X
	
	BCC PRG061_B8A9	; If Player was contacted, jump to PRG061_B8A9
	BCS PRG061_B8D8	; Otherwise, jump to PRG061_B8D8

PRG061_B865:
	LDA Spr_Y+$00,X
	ADD #$04
	STA Spr_Y+$00,X
	
	LDA Spr_X+$00,X
	CMP #$58
	BLT PRG061_B879	; If X < $58, jump to PRG061_B879

	; Different limits depending on the X position

	LDA #$5F	; A = $5F
	
	BNE PRG061_B87B	; Jump (technically always) to PRG061_B87B


PRG061_B879:
	LDA #$77	; A = $77

PRG061_B87B:
	CMP Spr_Y+$00,X
	BGE PRG061_B8D8	; If Cossack Catcher is not low enough, jump to PRG061_B8D8

	STA Spr_Y+$00,X	; Lock Cossack Catcher at low limit
	
	LDA <Player_State
	CMP #PLAYERSTATE_SLIDING
	BGE PRG061_B89C	; If Player is not standing or falling/jumping, jump to PRG061_B89C

	; Temporarily add $28 to Y
	LDA Spr_Y+$00,X
	PHA
	ADD #$28
	STA Spr_Y+$00,X
	
	JSR PRG063_TestPlayerObjCollide

	; Restore Y
	PLA
	STA Spr_Y+$00,X
	
	BCC PRG061_B8A9	; If Player contacted with claw, jump to PRG061_B8A9


PRG061_B89C:
	LDA #LOW(PRG061_Obj_CCatch_Caught)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_CCatch_Caught)
	STA Spr_CodePtrH+$00,X
	
	JMP PRG061_B94C	; Jump to PRG061_B94C


PRG061_B8A9:
	; Spr_Var1 = $1E
	LDA #$1E
	STA Spr_Var1+$00,X
	
	LDA #LOW(PRG061_B8DB)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_B8DB)
	STA Spr_CodePtrH+$00,X
	
	LDA #SPRANM2_COSSACKCLAW_CAUGHT
	
	LDY #$16
	JSR PRG063_SetSpriteAnimY

	LDA #PLAYERSTATE_COSSACKGRAB
	STA <Player_State
	
	LDA #SPRANM2_PLAYERJUMPFALL
	
	LDY #$00
	STY <Player_ShootAnimTimer
	STY <Player_CurShootAnim
	JSR PRG063_SetSpriteAnimY

	LDA #$00
	STA Spr_YVelFrac+$00
	LDA #$FC
	STA Spr_YVel+$00

PRG061_B8D8:
	JMP PRG061_B94C	; Jump to PRG061_B94C


PRG061_B8DB:
	LDA Spr_Var1+$00,X
	BEQ PRG061_B8E9		; If Spr_Var1 = 0, jump to PRG061_B8E9

	JSR PRG061_CCatch_HoldPlayerPos


PRG061_B8E3:
	DEC Spr_Var1+$00,X	; Spr_Var1--
	
	JMP PRG061_B94C	; Jump to PRG061_B94C


PRG061_B8E9:
	DEC Spr_Y+$00,X	; Spr_Y--
	
	JSR PRG061_CCatch_HoldPlayerPos

	LDA #$2F
	CMP Spr_Y+$00,X
	BLT PRG061_B94C	; If Cossack Catcher isn't up high enough, jump to PRG061_B94C

	STA Spr_Y+$00,X	; Set Cossack Catcher top height
	
	; Spr_Var1 = $3C
	LDA #$3C
	STA Spr_Var1+$00,X
	
	LDA #LOW(PRG061_B90A)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_B90A)
	STA Spr_CodePtrH+$00,X
	
	BNE PRG061_B94C	; Jump (technically always) to PRG061_B94C
	

PRG061_B90A:
	LDA Spr_Var1+$00,X
	BEQ PRG061_B915	; If Spr_Var1 = 0, jump to PRG061_B915

	JSR PRG061_CCatch_HoldPlayerPos

	JMP PRG061_B8E3	; Jump to PRG061_B8E3


PRG061_B915:
	LDA #SPRANM2_COSSACKCLAW_RELEASE
	LDY #$16
	JSR PRG063_SetSpriteAnimY

	LDA Spr_Y+$00,X
	ADD #$04
	STA Spr_Y+$00,X
	
	CMP #$37
	BNE PRG061_B94C


PRG061_B929:
	; Spr_Var1 = $3C
	LDA #$3C
	STA Spr_Var1+$00,X
	
	LDA #LOW(PRG061_Obj_CCatch_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_CCatch_Cont)
	STA Spr_CodePtrH+$00,X
	
	BNE PRG061_B94C	; Jump (technically always) to PRG061_B94C



PRG061_Obj_CCatch_Caught:
	LDA Spr_Y+$00,X
	CMP Spr_Var2+$00,X
	BEQ PRG061_B929
	BLT PRG061_B949

	DEC Spr_Y+$00,X	; Spr_Y--
	BNE PRG061_B94C	; Jump (technically always) to PRG061_B94C


PRG061_B949:
	INC Spr_Y+$00,X	; Spr_Y++

PRG061_B94C:
	LDA Spr_HP+$00,X
	CMP #$02
	BNE PRG061_B9A7	; If HP <> 2, jump to PRG061_B9A7

	LDA <Player_State
	CMP #PLAYERSTATE_SLIDING
	BGE PRG061_B9A7	; If Player is not standing or falling/jumping, jump to PRG061_B9A7

	; Clear ALL HUD bars and any invincibility flashing
	LDA #$00
	STA HUDBarP_DispSetting
	STA HUDBarW_DispSetting
	STA HUDBarB_DispSetting
	STA Spr_FlashOrPauseCnt,X
	
	LDY #$07	; Y = $07
PRG061_B969:
	; Fix Cossack Catcher palette (if needed)
	LDA PRG061_CCatch_Pal,Y
	STA PalData_1+8,Y
	STA PalData_2+8,Y
	
	; New palette to support cinematic
	LDA PRG061_CCatch_DefeatSprPal,Y
	STA PalData_1+24,Y
	STA PalData_2+24,Y
	
	DEY	; Y--
	BPL PRG061_B969	; While Y >= 0, loop

	STY <CommitPal_Flag	; Commit palette
	
	LDA #LOW(PRG061_CCatch_Defeated)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_CCatch_Defeated)
	STA Spr_CodePtrH+$00,X
	
	LDA #PLAYERSTATE_POSTCOSSACK
	STA <Player_State
	
	JSR PRG063_DeletePlayerObjs

	; Spr_Var7 = $3C
	LDA #$3C
	STA Spr_Var7+$00
	
	LDA #SPRDIR_LEFT
	STA Spr_FaceDir+$00
	
	LDA #$2C
	CMP Spr_X+$00
	BLT PRG061_B9A7	; If Player is not too far left, jump to PRG061_B9A7

	LDA #SPRDIR_RIGHT
	STA Spr_FaceDir

PRG061_B9A7:
	; Fix screen vertical
	LDA <PPU_CTL1_PageBaseReq
	AND #~$02
	STA <PPU_CTL1_PageBaseReq
	
	LDA #$2F
	SUB Spr_Y+$00,X
	STA <Vert_Scroll
	
	BCS PRG061_B9C1	; $B9B5

	SBC #$0F
	STA <Vert_Scroll
	
	LDA <PPU_CTL1_PageBaseReq
	ORA #$02
	STA <PPU_CTL1_PageBaseReq

PRG061_B9C1:
	; Init cine char X
	LDA Spr_X+$17
	STA Spr_X+$16
	STA Spr_X+$15
	
	LDA Spr_Y+$17
	STA Spr_Y+$15
	ADD #$28
	STA Spr_Y+$16

PRG061_CCatch_UpdRastrHAndPage:
	LDA #$C0
	SUB Spr_X+$17
	STA <Raster_VSplit_HPosReq
	
	LDA <PPU_CTL1_PageBaseReq
	STA <PPU_CTL1_PageBaseReq_RVBoss
	
	RTS	; $B9E2


PRG061_CCatch_HoldPlayerPos:
	LDA Spr_Y+$00,X
	ADD #$28
	STA Spr_Y+$00
	
	LDA Spr_X+$00,X
	STA Spr_X+$00
	
	RTS	; $B9F2


PRG061_CCatch_Defeated:
	LDA Spr_Y+$00,X
	CMP #$2F
	BEQ PRG061_BA00	; If Cossack Catcher is back to top, jump to PRG061_BA00

	DEC Spr_Y+$00,X	; Spr_Y--
	JMP PRG061_BA12	; Jump to PRG061_BA12


PRG061_BA00:
	LDA Spr_X+$00,X
	CMP #$C0
	BEQ PRG061_BA1A	; If Cossack Catcher is at right, jump to PRG061_BA1A
	BGE PRG061_BA0F	; If Cossack Catcher is TOO far right, jump to PRG061_BA0F

	INC Spr_X+$00,X	; Spr_X++
	JMP PRG061_BA12	; Jump to PRG061_BA12


PRG061_BA0F:
	DEC Spr_X+$00,X	; Spr_X--


PRG061_BA12:
	; Spr_Var7 = $3C
	LDA #$3C
	STA Spr_Var7+$00
	
	JMP PRG061_B9A7	; Jump to PRG061_B9A7


PRG061_BA1A:
	LDA <Raster_VMode
	CMP #RVMODE_CINEDIALOG
	BEQ PRG061_BA24	; If the cinematic dialog raster effect is on, jump to PRG061_BA24

	; Disabling the boss raster effect
	LDA #RVMODE_NONE
	STA <Raster_VMode

PRG061_BA24:
	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM2_DRCOSSACKSTAND
	BNE PRG061_BA35	; If Cossack is not standing outside mech, jump to PRG061_BA35

	LDA #LOW(PRG061_BA36)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_BA36)
	STA Spr_CodePtrH+$00,X

PRG061_BA35:
	RTS	; $BA35

PRG061_BA36:
	LDA #$80
	CMP Spr_Y+$00,X
	BEQ PRG061_BA35	; If Cossack is on ground, jump to PRG061_BA35 (RTS)

	JSR PRG063_DoMoveSimpleVert

	DEC Spr_X+$00,X	; Spr_X-- (move Cossack left in a hacky way)
	
	LDA #$80
	CMP Spr_Y+$00,X
	BEQ PRG061_BA4C	; If Cossack is on ground NOW, jump to PRG061_BA4C
	BGE PRG061_BA35	; Otherwise, jump to PRG061_BA35 (RTS)


PRG061_BA4C:
	STA Spr_Y+$00,X	; Lock on floor
	
	LDA <CineCsak_CurDialogSet
	BNE PRG061_BA35	; If the dialog is active, jump to PRG061_BA35 (RTS)

	STA <CineCsak_TextOffset
	INC <CineCsak_CurDialogSet
	
	RTS	; $BA57

	; CHECKME - UNUSED?
	; Alternate palette maybe?
	.byte $0F, $20, $10, $04, $0F, $2C, $1C, $0C	; $BA58 - $BA5F



PRG061_CCatch_Pal:
	.byte $0F, $26, $20, $16, $0F, $21, $20, $26

PRG061_CCatch_DefeatSprPal:
	.byte $0F, $0F, $37, $27, $0F, $37, $10, $16

PRG061_BA70:
	.byte $2F, $3F, $3F, $4F

PRG061_CCatch_Var3:
	.byte $B4, $78

PRG061_CCatch_Var4:
	.byte $5A, $78

PRG061_CCatchBullet_Dir:
	.byte $00, SPRDIR_DOWN, SPRDIR_DOWN

PRG061_CCatchBullet_DirMask:
	.byte (SPRDIR_LEFT | SPRDIR_RIGHT), $00, (SPRDIR_LEFT | SPRDIR_RIGHT)
	
PRG061_CCatchBullet_XVelFrac:
	.byte $00, $00, $64
	
PRG061_CCatchBullet_XVel:
	.byte $02, $00, $01
	
PRG061_CCatchBullet_YVelFrac:
	.byte $00, $00, $64
	
PRG061_CCatchBullet_YVel:
	.byte $00, $02, $01



PRG061_Obj_Cossack4_UNK1:
PRG061_BA8A:
	RTS	; $BA8A


PRG061_Obj94:
PRG061_Obj_SquareMachShot:
	JSR PRG063_ApplyVelSetFaceDir
	JMP PRG063_DoMoveVertOnlyH16


PRG061_Obj_BossSquareMachine:
	JSR PRG063_InitBossMus_Plyr_RetX

	CMP #PLAYERSTATE_BOSSWAIT
	BNE PRG061_BA8A	; If Player is not in boss wait state, jump to PRG061_BA8A (RTS)

	; Horizontal mirroring
	LDA #$00
	STA MMC3_MIRROR
	
	STA <Raster_VSplit_HPosReq
	STA <PPU_CTL1_PageBaseReq_RVBoss
	
	LDA <Level_SegCurData	; $BAA1
	AND #$0F	; $BAA3
	ORA #$80	; $BAA5
	STA <Level_SegCurData	; $BAA7
	
	; Load screen $11 into "other" side of BG
	LDA #$11
	STA <CommitBG_ScrSel
	LDA #$80
	STA <CommitBG_Flag
	
	LDA #LOW(PRG061_Obj_SqrMach_HPFill)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_Obj_SqrMach_HPFill)
	STA Spr_CodePtrH+$00,X
	
	BNE PRG061_BAF1	; Jump (technically always) to PRG061_BAF1 (RTS)


PRG061_Obj_SqrMach_HPFill:
	LDA <Raster_VMode
	BNE PRG061_BADE	; If raster effect is active, jump to PRG061_BADE

	LDA <CommitBG_Flag	; $BAC1
	BNE PRG061_BAF1	; $BAC3

	STA <General_Counter	; General_Counter = 0
	STA <Boss_HP			; Boss_HP = 0
	
	LDA #$40
	STA <Raster_VSplit_Req
	
	LDA #RVMODE_CBOSS2
	STA <Raster_VMode
	
	LDA #SPRDIR_RIGHT
	STA Spr_FaceDir+$00,X
	
	; Boss meter appears
	LDA #$8F
	STA HUDBarB_DispSetting
	
	JMP PRG061_BB94	; Jump to PRG061_BB94


PRG061_BADE:
	LDA <General_Counter
	AND #$07
	BNE PRG061_BAF1	; 7:8 jump to PRG061_BAF1 (RTS)

	LDA #SFX_ENERGYGAIN
	JSR PRG063_QueueMusSnd

	INC <Boss_HP	; Boss_HP++
	LDA <Boss_HP
	CMP #$1C
	BEQ PRG061_BAF2	; If fully charged, jump to PRG061_BAF2


PRG061_BAF1:
	RTS	; $BAF1


PRG061_BAF2:
	LDA #LOW(PRG061_BB08)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_BB08)
	STA Spr_CodePtrH+$00,X
	
	LDA #$91	; $BAFC
	STA Spr_Flags+$16	; $BAFE
	STA Spr_Flags+$15	; $BB01
	
	LDA #PLAYERSTATE_STAND
	STA <Player_State
	
PRG061_BB08:
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BEQ PRG061_BB2B	; If going left, jump toPRG061_BB2B

	; Apply X velocity to the horizontal position
	LDA Spr_XVelFracAccum+$00,X
	ADD Spr_XVelFrac+$00,X
	STA Spr_XVelFracAccum+$00,X
	LDA <Raster_VSplit_HPosReq
	ADC Spr_XVel+$00,X
	STA <Raster_VSplit_HPosReq
	LDA Spr_Var4+$00,X
	ADC #$00
	STA Spr_Var4+$00,X
	
	JMP PRG061_BB44	; Jump to PRG061_BB44


PRG061_BB2B:
	; Apply X velocity to the horizontal position
	LDA Spr_XVelFracAccum+$00,X
	SUB Spr_XVelFrac+$00,X
	STA Spr_XVelFracAccum+$00,X
	LDA <Raster_VSplit_HPosReq
	SBC Spr_XVel+$00,X
	STA <Raster_VSplit_HPosReq
	LDA Spr_Var4+$00,X
	SBC #$00
	STA Spr_Var4+$00,X

PRG061_BB44:
	AND #$01	; Toggles based on Spr_Var4 to set wrap properly
	STA <PPU_CTL1_PageBaseReq_RVBoss	; -> PPU_CTL1_PageBaseReq_RVBoss
	
	BNE PRG061_BB4D	; 

	STA Spr_Var4+$00,X

PRG061_BB4D:
	JSR PRG061_SqrMach_MoveAndHurtPlyr

	LDA <Raster_VSplit_HPosReq
	ORA Spr_XVelFracAccum+$00,X
	BNE PRG061_BBB2	; If boss isn't locked together, jump to PRG061_BBB2 (RTS)

	LDA <PPU_CTL1_PageBaseReq_RVBoss
	BEQ PRG061_BB80	; $BB59

	LDA Spr_Var1+$00,X
	BNE PRG061_BBB2	; If Spr_Var1 > 0, jump to PRG061_BBB2 (RTS)

	LDA Spr_Flags+$00,X
	AND #~SPRFL1_NODRAW
	STA Spr_Flags+$00,X
	
	LDA #LOW(PRG061_SqrMach_Locked)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_SqrMach_Locked)
	STA Spr_CodePtrH+$00,X
	
	; Bright flash when boss locks together
	LDA #$30
	STA PalData_1+16
	
	; Commit palette
	LDA #$FF
	STA <CommitPal_Flag
	STA Spr_Var2+$00,X	; Spr_Var2 = $FF
	
	BNE PRG061_BBB2	; Jump (technically always) to PRG061_BBB2 (RTS)



PRG061_BB80:
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BPL PRG061_BBA3	; If Spr_Var1 >= 0, jump to PRG061_BBA3

	LDA <RandomN+$02
	ADC <RandomN+$01
	STA <RandomN+$00
	AND #$01
	TAY	; Y = 0 or 1
	
	LDA PRG061_BD57,Y	; $BB8E
	STA Spr_FaceDir+$00,X	; $BB91

PRG061_BB94:
	LDA <RandomN+$00
	ADC <RandomN+$02
	STA <RandomN+$02
	AND #$07
	TAY	; Y = 0 to 7
	
	LDA PRG061_SqrMach_Var1,Y
	STA Spr_Var1+$00,X

PRG061_BBA3:
	LDY Spr_Var1+$00,X	; Y = Spr_Var1
	
	LDA PRG061_SqrMach_XVelFrac,Y
	STA Spr_XVelFrac+$00,X
	LDA PRG061_SqrMach_XVel,Y
	STA Spr_XVel+$00,X

PRG061_BBB2:
	RTS	; $BBB2


PRG061_SqrMach_Locked:
	LDA Spr_Var2+$00,X
	CMP #$FC
	BGE PRG061_BBC6	; If Spr_Var2 >= $FC, jump to PRG061_BBC6

	LDA #$0F
	CMP PalData_1+16
	BEQ PRG061_BBC6	; If white flash from lock has been cleared, jump to PRG061_BBC6

	; Clear white flash from locking
	STA PalData_1+16
	STA <CommitPal_Flag

PRG061_BBC6:
	LDA Spr_Var2+$00,X
	CMP #$05
	BGE PRG061_BBD6	; If Spr_Var2 >= 5, jump to PRG061_BBD6

	; Flash white when unlocking
	LDA #$30
	STA PalData_1+16
	LDA #$FF
	STA <CommitPal_Flag

PRG061_BBD6:
	LDA Spr_Var3+$00,X
	BNE PRG061_BC0A	; If Spr_Var3 > 0, jump to PRG061_BC0A

	; Spr_Var3 = $5A
	LDA #$5A
	STA Spr_Var3+$00,X
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG061_BC0D	; If no free object slot, jump to PRG061_BC0D

	LDA #SPRANM2_SQUAREMACHINE_SHOT
	JSR PRG063_CopySprSlotSetAnim

	LDA #SPRSLOTID_SQUAREMACHINE_SHOT
	STA Spr_SlotID+$00,Y
	
	LDA #SPRFL2_HURTPLAYER
	STA Spr_Flags2+$00,Y
	
	; Temp_Var2 = 0
	LDA #$00
	STA <Temp_Var2
	
	; Temp_Var3 = 2
	LDA #$02
	STA <Temp_Var3
	
	STX <Temp_Var15	; Backup object slot index -> Temp_Var15
	
	TYA
	TAX
	JSR PRG063_AimPlayer_Var23Spd

	; Set projectile direction
	LDA <Temp_Var12
	STA Spr_FaceDir+$00,X
	
	LDX <Temp_Var15	; Restore object slot index

PRG061_BC0A:
	DEC Spr_Var3+$00,X	; Spr_Var3--

PRG061_BC0D:
	DEC Spr_Var2+$00,X	; Spr_Var2--
	BNE PRG061_BC40	; If Spr_Var2 > 0, jump to PRG061_BC40 (RTS)

	JSR PRG062_CopyPal2To1_Commit

	LDA #$00
	STA Spr_FlashOrPauseCnt,X
	
	LDA Spr_Flags+$00,X
	ORA #SPRFL1_NODRAW
	STA Spr_Flags+$00,X
	
	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_RIGHT | SPRDIR_LEFT)
	STA Spr_FaceDir+$00,X
	
	LDA #LOW(PRG061_BB08)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_BB08)
	STA Spr_CodePtrH+$00,X
	
	; Set background flash to black
	LDA #$0F
	STA PalData_1+16
	STA <CommitPal_Flag
	
	; Spr_Var3 = 0
	LDA #$00
	STA Spr_Var3+$00,X

PRG061_BC40:
	RTS	; $BC40


PRG061_SqrMach_MoveAndHurtPlyr:
	
	LDY #$09	; Y = 9
PRG061_BC43:
	CPY #$06
	BGE PRG061_BC5B	; If Y >= $06, jump to PRG061_BC5B

	LDA PRG061_SqrMach_HPosBase,Y
	SUB <Raster_VSplit_HPosReq
	STA Spr_X+$0D,Y
	LDA #$11
	SBC Spr_Var4+$00,X
	STA Spr_XHi+$0D,Y
	
	JMP PRG061_BC6C	; Jump to PRG061_BC6C


PRG061_BC5B:
	LDA PRG061_SqrMach_HPosBase,Y
	ADD <Raster_VSplit_HPosReq
	STA Spr_X+$0D,Y
	LDA #$11
	ADC Spr_Var4+$00,X
	STA Spr_XHi+$0D,Y

PRG061_BC6C:
	AND #$01	; $BC6C
	BNE PRG061_BC75	; $BC6E

	LDA #$10	; $BC70
	STA Spr_XHi+$0D,Y	; $BC72

PRG061_BC75:
	STX <Temp_Var14	; Backup object slot index -> Temp_Var14
	
	LDA Spr_Flags2+$0D,Y
	AND #~SPRFL2_HURTPLAYER
	TAX	; X = bounding box (technically, it should be ignoring SPRFL2_SHOOTABLE too)
	
	LDA PRG063_ObjBoundBoxHeight,X
	STA <Temp_Var0		; bounding box height -> Temp_Var0
	
	LDA Spr_CurrentAnim+$00
	CMP #SPRANM2_PLAYERSLIDE
	BNE PRG061_BC90	; If Player is not sliding (ugly check!), jump to PRG061_BC90

	; Offset for player sliding
	LDA <Temp_Var0
	SUB #$08
	STA <Temp_Var0

PRG061_BC90:
	LDA Spr_Y+$00	; $BC90
	SUB Spr_Y+$0D,Y	; $BC93
	BCS PRG061_BC9D	; $BC97

	EOR #$FF	; $BC99
	ADC #$01	; $BC9B

PRG061_BC9D:
	CMP <Temp_Var0	; $BC9D
	BLT PRG061_BCA4	; $BC9F

	JMP PRG061_BD40	; Jump to PRG061_BD40


PRG061_BCA4:
	; Temp_Var2 = 0
	LDA #$00
	STA <Temp_Var2
	
	LDA Spr_X+$00	; $BCA8
	SUB Spr_X+$0D,Y	; $BCAB
	STA <Temp_Var0	; $BCAF
	LDA Spr_XHi+$00	; $BCB1
	SBC Spr_XHi+$0D,Y	; $BCB4
	STA <Temp_Var1	; $BCB7
	
	BCS PRG061_BCCD	; $BCB9

	INC <Temp_Var2	; $BCBB
	LDA <Temp_Var0	; $BCBD
	EOR #$FF	; $BCBF
	ADC #$01	; $BCC1
	STA <Temp_Var0	; $BCC3
	LDA <Temp_Var1	; $BCC5
	EOR #$FF	; $BCC7
	ADC #$00	; $BCC9
	STA <Temp_Var1	; $BCCB

PRG061_BCCD:
	LDA <Temp_Var1	; $BCCD
	BNE PRG061_BD40	; $BCCF

	LDA PRG063_ObjBoundBoxWidth,X	; $BCD1
	ADD #$01	; $BCD4
	SUB <Temp_Var0	; $BCD7
	BCC PRG061_BD40	; $BCDA

	CMP #$08	; $BCDC
	BLT PRG061_BCE2	; $BCDE

	LDA #$08	; $BCE0

PRG061_BCE2:
	STA <Temp_Var0	; $BCE2
	LDA <Temp_Var2	; $BCE4
	BEQ PRG061_BCF0	; $BCE6

	LDA <Temp_Var0	; $BCE8
	EOR #$FF	; $BCEA
	ADC #$01	; $BCEC
	STA <Temp_Var0	; $BCEE

PRG061_BCF0:
	LDA <Temp_Var0	; $BCF0
	BEQ PRG061_BD40	; $BCF2

	LDA <Player_State
	CMP #PLAYERSTATE_WIREADAPTER
	BNE PRG061_BCFE	; If Player wasn't using Wire Adapter, jump to PRG061_BCFE

	; Cancel Wire Adapter
	LDA #PLAYERSTATE_STAND
	STA <Player_State

PRG061_BCFE:
	LDA Spr_X+$00
	CMP #$F0
	BLT PRG061_BD0C	; If Player X < $F0, jump to PRG061_BD0C

	; Lock Player at $F0
	LDA #$F0
	STA Spr_X+$00
	BNE PRG061_BD15	; Jump (technically always) to PRG061_BD15


PRG061_BD0C:
	CMP #$10
	BGE PRG061_BD15	; If Player X >= $10, jump to PRG061_BD15

	; Lock Player at $10
	LDA #$10
	STA Spr_X

PRG061_BD15:
	ADD <Temp_Var0	; add offset
	STA Spr_X+$00	; -> Spr_X
	
	CMP #$F1
	BGE PRG061_BD2A	; If Player X >= $F1, jump to PRG061_BD2A

	CMP #$10
	BGE PRG061_BD40	; If Player X >= $10, jump to PRG061_BD40

	; Lock Player at $10
	LDA #$10
	STA Spr_X
	BNE PRG061_BD2F	; Jump (technically always) to PRG061_BD2F

PRG061_BD2A:
	; Lock Player at $F0
	LDA #$F0
	STA Spr_X+$00
	
PRG061_BD2F:
	LDA <Player_PlayerHitInv
	BNE PRG061_BD40	; If Player is flashing-invincible, jump to PRG061_BD40

	LDA <Player_State
	CMP #PLAYERSTATE_HURT
	BGE PRG061_BD40	; If Player is hurt or anything beyond that, jump to PRG061_BD40

	; Player is not flashing-invincible, not currently hurt/dead/etc...

	STY <Temp_Var13	; Backup 'Y' -> Temp_Var13
	
	JSR PRG058_PlayerDoHurt_Ind

	LDY <Temp_Var13	; Restore 'Y'

PRG061_BD40:
	LDX <Temp_Var14	; Restore object slot index
	
	DEY	; Y--
	BMI PRG061_BD48	; If Y < 0, jump to PRG061_BD48 (RTS)

PRG061_BD45:
	JMP PRG061_BC43	; Jump to PRG061_BC43 (loop around)


PRG061_BD48:
	RTS	; $BD48


PRG061_SqrMach_XVelFrac:
	.byte $00, $00, $00
	
PRG061_SqrMach_XVel:
	.byte $01, $02, $04

	; Indexes above XVel tables
PRG061_SqrMach_Var1:
	.byte $00, $01, $01, $01, $02, $02, $02, $02


PRG061_BD57:
	.byte SPRDIR_RIGHT, SPRDIR_LEFT, SPRDIR_UP, SPRDIR_DOWN

PRG061_SqrMach_HPosBase:
	.byte $80, $C8, $38, $80, $C8, $38, $C8, $38, $A0, $60



PRG061_Obj_SqrMachPlatform:
	LDA PRG061_BD57-$13,X	; Not sure this is right
	STA Spr_FaceDir+$00,X	; $BD68
	
	LDA #$80
	STA Spr_YVelFrac+$00,X
	LDA #$00
	STA Spr_YVel+$00,X
	
	LDA #LOW(PRG061_BD84)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG061_BD84)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var1 = $60
	LDA #$60
	STA Spr_Var1+$00,X
	
PRG061_BD84:
	JSR PRG063_DoMoveVertOnlyH16

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG061_BD99	; If Spr_Var1 > 0, jump to PRG061_BD99 (RTS)

	; Spr_Var1 = $60
	LDA #$60
	STA Spr_Var1+$00,X
	
	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_UP | SPRDIR_DOWN)
	STA Spr_FaceDir+$00,X

PRG061_BD99:
	RTS	; $BD99

	; CHECKME - UNUSED?
	.byte $86, $00, $20, $00, $4B, $15, $8C, $51, $20, $55, $72, $00, $88, $01, $42, $04	; $BD9A - $BDA9
	.byte $B0, $41, $04, $10, $E3, $00, $03, $04, $1C, $11, $40, $15, $10, $40, $41, $10	; $BDAA - $BDB9
	.byte $00, $00, $02, $10, $00, $01, $EE, $11, $E2, $40, $C2, $55, $84, $04, $00, $84	; $BDBA - $BDC9
	.byte $0D, $46, $4C, $40, $C0, $10, $6E, $44, $14, $14, $10, $40, $E9, $50, $04, $60	; $BDCA - $BDD9
	.byte $B7, $10, $80, $41, $04, $10, $36, $00, $78, $10, $6E, $04, $34, $15, $8A, $00	; $BDDA - $BDE9
	.byte $8C, $00, $4A, $11, $4E, $01, $26, $40, $88, $40, $88, $10, $09, $04, $EC, $40	; $BDEA - $BDF9
	.byte $80, $11, $22, $00, $00, $14, $30, $31, $3A, $10, $90, $10, $B9, $05, $85, $14	; $BDFA - $BE09
	.byte $2D, $04, $6C, $14, $2E, $10, $C0, $54, $D8, $00, $13, $00, $21, $41, $48, $00	; $BE0A - $BE19
	.byte $43, $00, $09, $11, $08, $57, $04, $00, $76, $45, $A5, $40, $DA, $05, $24, $10	; $BE1A - $BE29
	.byte $8E, $40, $C1, $74, $C8, $10, $81, $00, $08, $44, $00, $40, $88, $00, $0F, $00	; $BE2A - $BE39
	.byte $44, $50, $00, $54, $40, $11, $F4, $44, $60, $00, $88, $01, $10, $04, $4C, $40	; $BE3A - $BE49
	.byte $80, $10, $0A, $41, $00, $00, $00, $00, $0B, $20, $84, $50, $02, $04, $02, $01	; $BE4A - $BE59
	.byte $08, $10, $86, $00, $B0, $50, $8C, $45, $9C, $41, $15, $05, $16, $14, $83, $00	; $BE5A - $BE69
	.byte $28, $54, $14, $14, $B0, $40, $95, $41, $01, $00, $16, $54, $A8, $40, $08, $10	; $BE6A - $BE79
	.byte $00, $01, $80, $04, $24, $01, $DB, $11, $61, $05, $60, $84, $79, $10, $4A, $50	; $BE7A - $BE89
	.byte $04, $00, $27, $00, $09, $00, $A0, $44, $A0, $05, $08, $40, $C0, $05, $24, $54	; $BE8A - $BE99
	.byte $80, $00, $08, $00, $04, $40, $38, $41, $04, $10, $08, $55, $82, $11, $02, $00	; $BE9A - $BEA9
	.byte $98, $00, $C6, $50, $40, $00, $84, $50, $65, $00, $11, $50, $D7, $40, $72, $31	; $BEAA - $BEB9
	.byte $24, $00, $10, $05, $00, $51, $45, $54, $98, $01, $A8, $11, $46, $41, $04, $14	; $BEBA - $BEC9
	.byte $23, $45, $24, $41, $22, $40, $00, $04, $06, $54, $A5, $50, $80, $00, $0A, $41	; $BECA - $BED9
	.byte $14, $01, $12, $04, $24, $10, $6A, $14, $E8, $05, $34, $51, $43, $03, $7C, $0D	; $BEDA - $BEE9
	.byte $E2, $34, $94, $02, $B0, $00, $21, $41, $08, $44, $A0, $44, $34, $01, $00, $00	; $BEEA - $BEF9
	.byte $84, $00, $E0, $14, $88, $60, $28, $04, $39, $09, $49, $10, $EB, $40, $80, $50	; $BEFA - $BF09
	.byte $52, $10, $F6, $15, $A3, $10, $4B, $01, $D5, $01, $70, $51, $14, $04, $20, $10	; $BF0A - $BF19
	.byte $09, $80, $41, $14, $41, $00, $0B, $01, $EF, $00, $04, $00, $0C, $54, $86, $41	; $BF1A - $BF29
	.byte $95, $05, $1E, $50, $10, $40, $2A, $85, $41, $00, $22, $00, $82, $11, $41, $01	; $BF2A - $BF39
	.byte $20, $01, $01, $00, $04, $11, $B5, $04, $C4, $10, $92, $04, $05, $14, $51, $05	; $BF3A - $BF49
	.byte $20, $44, $02, $15, $91, $45, $43, $44, $11, $00, $28, $C1, $04, $00, $02, $45	; $BF4A - $BF59
	.byte $00, $11, $40, $00, $60, $D1, $36, $11, $49, $20, $6C, $10, $06, $00, $50, $80	; $BF5A - $BF69
	.byte $30, $01, $9A, $05, $9D, $50, $88, $54, $3E, $40, $41, $40, $40, $00, $22, $01	; $BF6A - $BF79
	.byte $08, $41, $1E, $00, $78, $10, $C9, $56, $11, $05, $46, $15, $26, $15, $18, $14	; $BF7A - $BF89
	.byte $0A, $00, $22, $04, $00, $00, $16, $10, $70, $10, $20, $00, $81, $40, $40, $04	; $BF8A - $BF99
	.byte $49, $41, $00, $00, $80, $80, $98, $00, $C0, $42, $61, $51, $4C, $00, $01, $51	; $BF9A - $BFA9
	.byte $82, $60, $54, $05, $84, $11, $06, $14, $5A, $10, $20, $44, $05, $00, $00, $40	; $BFAA - $BFB9
	.byte $C8, $01, $00, $00, $0A, $00, $2B, $54, $19, $14, $BE, $16, $11, $45, $F3, $51	; $BFBA - $BFC9
	.byte $CB, $90, $2C, $55, $81, $55, $D6, $01, $05, $54, $18, $10, $44, $10, $A0, $00	; $BFCA - $BFD9
	.byte $00, $11, $42, $10, $0A, $15, $D0, $04, $C0, $50, $B8, $05, $5B, $04, $02, $14	; $BFDA - $BFE9
	.byte $4C, $54, $16, $05, $00, $00, $28, $45, $8A, $10, $88, $01, $20, $51, $C0, $50	; $BFEA - $BFF9
	.byte $5A, $50, $10, $40, $10, $50	; $BFFA - $BFFF


