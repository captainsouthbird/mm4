PRG053_Obj_Wily:
	JSR PRG063_DoMoveSimpleVert

	LDA #$A4
	CMP Spr_Y+$00,X
	BGE PRG053_A027	; If Wily isn't low enough, jump to PRG053_A027

	STA Spr_Y+$00,X	; Lock vertical position
	
	LDA Spr_Frame+$00,X
	CMP #$04
	BNE PRG053_A02C	; If frame <> 4 (teleport frame), jump to PRG053_A02C (RTS)

	LDA #SPRNAM2_WILY_STANDING
	JSR PRG063_SetSpriteAnim

	LDA #$00
	STA <CineCsak_TextOffset
	
	INC <CineCsak_CurDialogSet	; CineCsak_CurDialogSet++
	
	LDA Spr_Flags+$14
	AND #~SPR_HFLIP
	STA Spr_Flags+$14

PRG053_A027:
	LDA #$00
	STA Spr_AnimTicks+$00,X

PRG053_A02C:
	RTS	; $A02C


PRG053_Obj_BossMetallDaddy:
	JSR PRG063_InitBossMus_Plyr_RetX

	CMP #PLAYERSTATE_BOSSWAIT
	BNE PRG053_A02C	; If Player is not in boss wait state, jump to PRG053_A02C (RTS)

	; Load screen $15 into "other" side of BG
	LDA #$15
	STA <CommitBG_ScrSel
	LDA #$80
	STA <CommitBG_Flag
	
	LDA #LOW(PRG053_MetallDaddy_Init)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_MetallDaddy_Init)
	STA Spr_CodePtrH+$00,X
	

PRG053_MetallDaddy_Init:
	LDA <CommitBG_Flag
	BNE PRG053_A07A	; If haven't committed MetallDaddy to BG, jump to PRG053_A07A (RTS)

	STA <General_Counter
	STA <Boss_HP
	
	INC Spr_Var3+$00,X	; Spr_Var3++
	
	LDA #LOW(PRG053_MetallDaddy_FadeIn)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_MetallDaddy_FadeIn)
	STA Spr_CodePtrH+$00,X
	
	LDA #$08
	STA <Vert_Scroll
	
	LDA #$02
	STA <PPU_CTL1_PageBaseReq_RVBoss
	
	LDA #$C0
	STA <Raster_VSplit_Req
	
	LDA #RVMODE_WBOSS1
	STA <Raster_VMode
	
	LDA #$90	; $A06B
	STA Spr_Flags+$16	; $A06D
	
	; Display boss meter
	LDA #$8F
	STA HUDBarB_DispSetting
	
	; Spr_Var1 = $30 (fade level)
	LDA #$30
	STA Spr_Var1+$00,X

PRG053_A07A:
	RTS	; $A07A


PRG053_MetallDaddy_FadeIn:
	LDA <General_Counter
	AND #$07
	BNE PRG053_A07A	; 7:8 jump to PRG053_A07A (RTS)

	LDY #$07	; Y = 7
PRG053_A083:
	LDA PRG053_MetallDaddy_Pal,Y
	SUB Spr_Var1+$00,X
	BCS PRG053_A08E

	LDA #$0F	; Min dark shade

PRG053_A08E:
	STA PalData_1+4,Y
	STA PalData_2+4,Y
	DEY	; Y--
	BPL PRG053_A083	; While Y >= 0, loop

	STY <CommitPal_Flag	; Commit palette
	
	LDA Spr_Var1+$00,X
	SUB #$10
	STA Spr_Var1+$00,X	; Decrease fade level
	BCS PRG053_A07A	; If not done, jump to PRG053_A07A (RTS)

	; Spr_Var1 = 0
	LDA #$00
	STA Spr_Var1+$00,X
	
	LDA #LOW(PRG053_MetallDaddy_HPFill)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_MetallDaddy_HPFill)
	STA Spr_CodePtrH+$00,X
	
	RTS	; $A0B3


PRG053_MetallDaddy_HPFill:
	LDA <General_Counter
	AND #$07
	BNE PRG053_A07A	; 7:8 jump to PRG053_A07A (RTS)

	LDA #SFX_ENERGYGAIN
	JSR PRG063_QueueMusSnd

	INC <Boss_HP	; Boss_HP++
	LDA <Boss_HP
	CMP #$1C
	BNE PRG053_A07A	; If not filled, jump to PRG053_A07A (RTS)

	LDA #LOW(PRG053_MetallDaddy_LiftUp)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_MetallDaddy_LiftUp)
	STA Spr_CodePtrH+$00,X
	
	LDA #PLAYERSTATE_STAND
	STA <Player_State
	

PRG053_MetallDaddy_LiftUp:
	LDA Spr_Var1+$00,X
	BEQ PRG053_A0DF	; If Spr_Var1 = 0, jump to PRG053_A0DF

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG053_A126	; If Spr_Var1 > 0, jump to PRG053_A126 (RTS)


PRG053_A0DF:
	LDA Spr_Var2+$00,X
	INC Spr_Var2+$00,X	; Spr_Var2++
	AND #$03	; Cap 0 to 3
	BNE PRG053_A126	; 3:4 jump to PRG053_A126

	LDY Spr_Var3+$00,X	; Y = Spr_Var3
	
	LDA PRG053_MetallDaddy_VScrPos,Y
	STA <Vert_Scroll
	
	LDA PRG053_MetallDaddy_YPos,Y
	STA Spr_Y+$16
	
	LDA Spr_Flags+$00,X
	AND #~SPRFL1_NODRAW
	ORA PRG053_MetallDaddy_Flags,Y
	STA Spr_Flags+$00,X
	
	JSR PRG053_MetallDaddy_RedrawBody
	JSR PRG053_MetallDaddy_CommitPal

	INC Spr_Var3+$00,X	; Spr_Var3++
	
	CPY #$05
	BNE PRG053_A126	; If body isn't fully revealed, jump to PRG053_A126 (RTS)

	; Spr_Var3 = 4
	LDA #$04
	STA Spr_Var3+$00,X
	
	LDA #LOW(PRG053_MetallDaddy_LiftedUp)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_MetallDaddy_LiftedUp)
	STA Spr_CodePtrH+$00,X
	
	LDA Spr_Flags2+$00,X
	ORA #SPR_HFLIP
	STA Spr_Flags2+$00,X

PRG053_A126:
	RTS	; $A126


PRG053_MetallDaddy_LiftedUp:
	LDA <RandomN+$00
	ADC <RandomN+$01
	STA <RandomN+$00
	AND #$01
	TAY	; Y = 0 to 1
	
	LDA PRG053_MetallDaddy_Var1,Y
	STA Spr_Var1+$00,X
	
	LDA #LOW(PRG053_MetallDaddy_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_MetallDaddy_Cont)
	STA Spr_CodePtrH+$00,X
	

PRG053_MetallDaddy_Cont:
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG053_A126	; If Spr_Var1 > 0, jump to PRG053_A126 (RTS)

	JSR PRG063_CalcObjXDiffFromPlayer

	LDY #$02	; Y = 2
PRG053_A14A:
	CMP PRG053_MetallDaddy_XDiffLimits,Y
	BGE PRG053_A152	; If Player X diff >= this distance, jump to PRG053_A152

	DEY	; Y--
	BNE PRG053_A14A	; While Y > 0, loop


PRG053_A152:
	LDA PRG053_MetallDaddy_XVelFrac,Y
	STA Spr_XVelFrac+$00,X
	LDA PRG053_MetallDaddy_XVel,Y
	STA Spr_XVel+$00,X
	
	LDA PRG053_MetallDaddy_YVelFrac,Y
	STA Spr_YVelFrac+$00,X
	LDA PRG053_MetallDaddy_YVel,Y
	STA Spr_YVel+$00,X
	
	LDA #LOW(PRG053_A190)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_A190)
	STA Spr_CodePtrH+$00,X
	
	JSR PRG063_SetObjFacePlayer
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG053_A190	; If no free object slot, jump to PRG053_A190

	LDA #SPRANM2_METALLDADDY_DUST
	JSR PRG063_CopySprSlotSetAnim

	LDA #$B4
	STA Spr_Y+$00,Y
	
	LDA #SPRSLOTID_PLAYER
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_Flags2+$00,Y

PRG053_A190:
	JSR PRG063_ApplyVelSetFaceDir

	LDA Spr_Flags+$00,X
	AND #~SPR_HFLIP
	STA Spr_Flags+$00,X
	
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BEQ PRG053_A1AE	; If going left, jump to PRG053_A1AE

	; Going right...

	LDA #$D8
	CMP Spr_X+$00,X
	BGE PRG053_A1B8	; If not too far right, jump to PRG053_A1B8

	; Limit right
	STA Spr_X,X
	BCC PRG053_A1B8


PRG053_A1AE:
	LDA #$28
	CMP Spr_X+$00,X
	BLT PRG053_A1B8	; If not too far left, jump to PRG053_A1B8

	; Limit left
	STA Spr_X,X

PRG053_A1B8:
	JSR PRG063_DoMoveSimpleVert

	LDA #$AB
	CMP Spr_Y+$00,X
	BGE PRG053_A1E3	; If Metall Daddy isn't on floor, jump to PRG053_A1E3

	STA Spr_Y+$00,X	; Floor vertical limit
	
	LDA #LOW(PRG053_MetallDaddy_Landed)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_MetallDaddy_Landed)
	STA Spr_CodePtrH+$00,X
	
	LDA #SPRANM2_METALLDADDY_EYES
	JSR PRG063_SetSpriteAnim

	; Spr_Var1 = $5A
	LDA #$5A
	STA Spr_Var1+$00,X
	
	LDY <Player_State
	BEQ PRG053_A1E1	; If Player is standing, jump to PRG053_A1E1

	CPY #PLAYERSTATE_SLIDING
	BNE PRG053_A1E3	; If Player is not sliding, jump to PRG053_A1E3

PRG053_A1E1:
	; Player was on ground, freeze him a bit
	STA <Player_FreezePlayerTicks


PRG053_A1E3:
	; Set the horizontal raster position
	LDA #$B8
	SUB Spr_X+$00,X
	STA <Raster_VSplit_HPosReq
	
	; Set the vertical raster position
	LDA #$D9
	SUB Spr_Y+$00,X
	STA <Vert_Scroll
	
	LDA Spr_X+$00,X
	STA Spr_X+$16	
	
	LDA Spr_Y+$00,X
	SUB #$26
	STA Spr_Y+$16
	
	RTS	; $A202


PRG053_MetallDaddy_Landed:
	LDA Spr_Var1+$00,X	
	BEQ PRG053_A22A	; If Spr_Var1 = 0, jump to PRG053_A22A

	DEC Spr_Var1+$00,X	; Spr_Var1--

	CMP #$1E
	BLT PRG053_A219	; If Spr_Var1 < $1E, jump to PRG053_A219

	AND #$04
	
	LSR A
	ADD #$BE
	STA <Raster_VSplit_Req
	
	BNE PRG053_A27E	; Jump (technically always) to PRG053_A27E


PRG053_A219:
	LDA #SPRANM2_METALLDADDY_IDLE
	CMP Spr_CurrentAnim+$00,X
	BEQ PRG053_A27E	; If back in idle state, jump to PRG053_A27E (RTS)

	LDY #$C0
	STY <Raster_VSplit_Req
	
	; Set SPRANM2_METALLDADDY_IDLE
	JSR PRG063_SetSpriteAnim

	JMP PRG053_MetallDaddy_SpawnMetall	; Jump to PRG053_MetallDaddy_SpawnMetall


PRG053_A22A:
	LDA Spr_Flags2+$00,X
	AND #~SPR_HFLIP
	STA Spr_Flags2+$00,X
	
	LDA Spr_Var2+$00,X
	INC Spr_Var2+$00,X	; Spr_Var2++
	AND #$03		
	BNE PRG053_A27E		; 3:4 jump to PRG053_A27E (RTS)

	LDY Spr_Var3+$00,X	; Y = Spr_Var3
	
	LDA PRG053_MetallDaddy_VScrPos,Y
	STA <Vert_Scroll
	
	LDA PRG053_MetallDaddy_YPos,Y
	STA Spr_Y+$16
	
	LDA Spr_Flags+$00,X
	AND #~SPRFL1_NODRAW
	ORA PRG053_MetallDaddy_Flags,Y
	STA Spr_Flags+$00,X
	
	JSR PRG053_MetallDaddy_RedrawBody
	JSR PRG053_MetallDaddy_CommitPal

	DEC Spr_Var3+$00,X	; Spr_Var3--
	BPL PRG053_A27E	; If Spr_Var3 > 0, jump to PRG053_A27E (RTS)

	; Spr_Var3 = 1
	LDA #$01
	STA Spr_Var3+$00,X
	
	LDA #LOW(PRG053_MetallDaddy_LiftUp)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_MetallDaddy_LiftUp)
	STA Spr_CodePtrH+$00,X
	
	LDA <RandomN+$00
	ADC <RandomN+$01
	STA <RandomN+$00
	AND #$01
	TAY	; Y = 0 to 1
	
	LDA PRG053_MetallDaddy_Var1_2,Y
	STA Spr_Var1+$00,X

PRG053_A27E:
	RTS	; $A27E


	; Expands/contracts Metall Daddy's body for the helmet rising up and coming down
	; Input 'Y'
PRG053_MetallDaddy_RedrawBody:
	STX <Temp_Var0	; Backup X -> Temp_Var0
	STY <Temp_Var1	; Backup Y -> Temp_Var1
	
	LDX #$00	; X = 0
PRG053_A285:
	LDA PRG053_MetallDaddy_GBufClear,X
	STA Graphics_Buffer+$00,X
	
	BMI PRG053_A290	; If termiantor, jump to PRG053_A290

	INX	; X++
	BNE PRG053_A285	; Loop!


PRG053_A290:
	
	LDX PRG053_MetallDaddy_BodyIdxSel,Y
	LDY PRG053_MetallDaddy_BodyGBStrt,X
	
	LDX #$00
PRG053_A298:
	LDA PRG053_MetallDaddy_BodyGBuf,Y
	CMP #$01
	BEQ PRG053_A2A6	; If terminator, jump to PRG053_A2A6

	STA Graphics_Buffer+$00,X
	
	INY	; Y++
	INX	; X++
	BNE PRG053_A298	; Loop!


PRG053_A2A6:

	; SB: What's strange is that all the address are already in place
	; making this whole patching loop useless. Perhaps there was a
	; different version of this boss at one point...
	LDY #$00
	LDX #$00
PRG053_A2AA:
	LDA PRG053_MetallDaddy_BodyVAddrs,Y
	STA Graphics_Buffer+$00,X
	LDA PRG053_MetallDaddy_BodyVAddrs+1,Y
	STA Graphics_Buffer+$01,X
	
	; Y += 2 (next VAddr)
	INY
	INY
	
	; Skip over to next video address
	TXA
	ADD #(PRG053_MetallDaddy_BodyGBuf_1 - PRG053_MetallDaddy_BodyGBuf_0)
	TAX
	
	CMP #$41
	BNE PRG053_A2AA	; Loop for all segments

	; Commit graphics
	LDA #$FF
	STA <CommitGBuf_Flag
	
	LDX <Temp_Var0	; Restore X
	LDY <Temp_Var1	; Restore Y
	
	RTS	; $A2C9


PRG053_MetallDaddy_SpawnMetall:
	LDA <RandomN+$00
	ADC <RandomN+$01
	STA <RandomN+$00
	AND #$03
	TAY	; Y = 0 to 3
	
	LDA PRG053_MetallDaddy_XIdxBase,Y
	STA <Temp_Var1
	
	; Temp_Var2 = 3
	LDA #$03
	STA <Temp_Var2

PRG053_A2DC:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG053_A330	; If no free slot, jump to PRG053_A330 (RST)

	LDA #SPRANM4_METALL_IDLE
	JSR PRG063_CopySprSlotSetAnim

	STX <Temp_Var0	; Backup object slot index -> Temp_Var0
	
	LDX <Temp_Var1	; X = X based index
	
	LDA PRG053_MetallDaddy_MetallX,X
	STA Spr_X+$00,Y
	
	LDX <Temp_Var2	; X = current Metall
	
	LDA PRG053_MetallDaddy_MetallVar1,X
	STA Spr_Var1+$00,Y
	
	LDA PRG053_MetallDaddy_MetallFDir,X
	STA Spr_FaceDir+$00,Y
	
	LDA PRG053_MetallDaddy_MetallFlags,X
	STA Spr_Flags+$00,Y
	
	LDA #SPRSLOTID_METALLDADDY_METALL
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_Y+$00,Y
	
	; HP = 1
	LDA #$01
	STA Spr_HP+$00,Y
	
	LDA #SPRFL2_HURTPLAYER
	STA Spr_Flags2+$00,Y
	
	LDA #$00
	STA Spr_XVelFrac+$00,Y
	STA Spr_YVelFrac+$00,Y
	STA Spr_YVel+$00,Y
	
	LDA #$01
	STA Spr_XVel+$00,Y
	
	LDX <Temp_Var0	; Restore object slot index
	
	DEC <Temp_Var1	; Temp_Var1--
	
	DEC <Temp_Var2	; Temp_Var2--
	BPL PRG053_A2DC	; While Temp_Var2 >= 0, loop


PRG053_A330:
	RTS	; $A330


PRG053_MetallDaddy_CommitPal:
	LDA Spr_Flags+$00,X
	AND #SPRFL1_NODRAW
	BEQ PRG053_A330		; If not drawing, jump to PRG053_A330 (RTS)

	LDA #$00
	STA Spr_FlashOrPauseCnt,X
	JMP PRG062_CopyPal2To1_Commit


PRG053_MetallDaddy_VScrPos:
	.byte $08, $10, $18, $20, $28, $30
	
PRG053_MetallDaddy_YPos:
	.byte $AB, $A3, $9B, $93, $8B, $83
	
	; Index select out of PRG053_MetallDaddy_BodyGBStrt
PRG053_MetallDaddy_BodyIdxSel:
	.byte $00, $04, $03, $02, $01, $00
	
PRG053_MetallDaddy_Var1_2:
	.byte $B4, $F0
	
PRG053_MetallDaddy_Var1:
	.byte $3C, $78


PRG053_MetallDaddy_XDiffLimits:
	.byte $28, $40, $58

PRG053_MetallDaddy_Flags:
	.byte SPRFL1_NODRAW, SPRFL1_NODRAW, SPRFL1_NODRAW, SPRFL1_NODRAW, $00, $00

PRG053_MetallDaddy_MetallX:
	.byte $38, $68, $98, $C8	; $0 - $3
	.byte $18, $58, $A8, $E8	; $4 - $7
	.byte $50, $70, $90, $B0	; $8 - $B

PRG053_MetallDaddy_MetallVar1:
	.byte $10, $00, $00, $10

PRG053_MetallDaddy_MetallFDir:
	.byte SPRDIR_LEFT, SPRDIR_LEFT, SPRDIR_RIGHT, SPRDIR_RIGHT

PRG053_MetallDaddy_MetallFlags:
	.byte $94, $90, $D0, $D4

PRG053_MetallDaddy_XIdxBase:
	.byte $03, $07, $0B, $03
	
PRG053_MetallDaddy_XVelFrac:
	.byte $05, $6A, $BD

PRG053_MetallDaddy_XVel:
	.byte $01, $01, $01

PRG053_MetallDaddy_YVelFrac:
	.byte $E5, $A9, $52


PRG053_MetallDaddy_YVel:
	.byte $04, $05, $06


PRG053_MetallDaddy_BodyGBStrt:
	.byte (PRG053_MetallDaddy_BodyGBuf_0 - PRG053_MetallDaddy_BodyGBuf)
	.byte (PRG053_MetallDaddy_BodyGBuf_1 - PRG053_MetallDaddy_BodyGBuf)
	.byte (PRG053_MetallDaddy_BodyGBuf_2 - PRG053_MetallDaddy_BodyGBuf)
	.byte (PRG053_MetallDaddy_BodyGBuf_3 - PRG053_MetallDaddy_BodyGBuf)
	.byte (PRG053_MetallDaddy_BodyGBuf_4 - PRG053_MetallDaddy_BodyGBuf)

PRG053_MetallDaddy_BodyGBuf:

PRG053_MetallDaddy_BodyGBuf_0:	
	vaddr $2B32
	
	.byte $09
	.byte $C6, $BC, $BF, $F2, $F2, $F2, $F2, $FD, $FE, $FF

PRG053_MetallDaddy_BodyGBuf_1:
	vaddr $2B52
	
	.byte $09
	.byte $B9, $BA, $BB, $02, $BD, $BE, $02, $B1, $FA, $C0

PRG053_MetallDaddy_BodyGBuf_2:
	vaddr $2B72

	.byte $09
	.byte $C9, $CA, $CB, $CC, $CD, $CE, $CF, $B8, $FB, $D0

PRG053_MetallDaddy_BodyGBuf_3:	
	vaddr $2B92
	
	.byte $09
	.byte $D9, $DA, $DB, $DC, $DD, $DE, $DF, $C4, $C5, $00

PRG053_MetallDaddy_BodyGBuf_4:
	vaddr $2BB2
	
	.byte $09
	.byte $D3, $EA, $EB, $EC, $ED, $EE, $EF, $D4, $D5, $D6
	
	; Terminator
	.byte $01


PRG053_MetallDaddy_BodyVAddrs:
	vaddr $2B32
	vaddr $2B52
	vaddr $2B72
	vaddr $2B92
	vaddr $2BB2


	; Same layout as PRG053_MetallDaddy_BodyGBuf, but other than
	; installing a proper terminator ($FF), not sure if this
	; data is really any use in the end...
PRG053_MetallDaddy_GBufClear:
	vaddr $0000
	.byte $09
	
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	
	vaddr $0000
	.byte $09
	
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

	vaddr $0000
	.byte $09
	
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

	vaddr $0000
	.byte $09
	
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

	vaddr $0000
	.byte $09
	
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	
	.byte $FF


	; CHECKME - UNUSED?
	.byte $0F, $20, $10, $00	; $A41A - $A41D



PRG053_MetallDaddy_Pal:
	.byte $0F, $20, $10, $27, $0F, $20, $27, $17	; $A41E - $A425


	; CHECKME - UNUSED?
	.byte $0F, $38, $28, $18	; $A426 - $A429


PRG053_Obj_MetallDaddyMetall:
	LDA Spr_Var1+$00,X
	BEQ PRG053_A43C	; If Spr_Var1 = 0, jump to PRG053_A43C

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG053_A486	; If Spr_Var1 > 0, jump to PRG053_A486 (RTS)

	LDA Spr_Flags+$00,X
	AND #~SPRFL1_NODRAW
	STA Spr_Flags+$00,X

PRG053_A43C:
	JSR PRG063_DoMoveSimpleVert

	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	LDA #$B9
	CMP Spr_Y+$00,X
	BGE PRG053_A486	; If the Metall is still too high, jump to PRG053_A486 (RTS)

	STA Spr_Y+$00,X	; Lock position
	
	LDA #LOW(PRG053_MetallDaddyMetall_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_MetallDaddyMetall_Cont)
	STA Spr_CodePtrH+$00,X
	
PRG053_MetallDaddyMetall_Cont:
	LDA #SPRANM4_METALL1_OPEN
	CMP Spr_CurrentAnim+$00,X
	BEQ PRG053_A483	; If Metall is opening, jump to PRG053_A483

	LDY Spr_Frame+$00,X
	CPY #$04
	BEQ PRG053_A480	; If frame = 4, jump to PRG053_A480

	CPY #$01
	BNE PRG053_A486	; If frame <> 1, jump to PRG053_A486 (RTS)

	LDA Spr_AnimTicks+$00,X
	CMP #$04
	BNE PRG053_A486	; If anim ticks <> 4, jump to PRG053_A486 (RTS)

	; Spr_Y -= 3
	DEC Spr_Y+$00,X
	DEC Spr_Y+$00,X
	DEC Spr_Y+$00,X
	
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE)
	STA Spr_Flags2+$00,X
	
	RTS	; $A47F


PRG053_A480:
	JSR PRG063_SetSpriteAnim

PRG053_A483:
	JSR PRG063_ApplyVelSetFaceDir

PRG053_A486:
	RTS	; $A486


PRG053_Obj_BossTakotrash:
	JSR PRG063_InitBossMus_Plyr_RetX

	CMP #PLAYERSTATE_BOSSWAIT
	BNE PRG053_A486	; If Player is not in boss wait state, jump to PRG053_A486 (RTS)

	INC Spr_Var1+$00,X	; Spr_Var1++
	LDA Spr_Var1+$00,X
	AND #$07
	BNE PRG053_A4FA	; 7:8 jump to PRG053_A4FA

	LDY Spr_Var2+$00,X	; Y = Spr_Var2
	
	STX <Temp_Var0	; Backup object slot index -> Temp_Var0
	
	LDX #$00
PRG053_A49F:
	LDA PRG059_Takotrash_Pal1,Y
	STA PalData_1+4,X
	STA PalData_2+4,X
	
	LDA PRG059_Takotrash_Pal2,Y
	STA PalData_1+8,X
	STA PalData_2+8,X
	
	LDA PRG059_Takotrash_Pal3,Y
	STA PalData_1+12,X
	STA PalData_2+12,X
	
	INY	; Y++
	INX	; X++
	CPX #$04
	BNE PRG053_A49F	; While X <> 4, loop!

	; Commit palette
	LDA #$FF
	STA <CommitPal_Flag
	
	LDX <Temp_Var0	; Restore object slot index
	
	TYA
	STA Spr_Var2+$00,X	; 'Y' -> Spr_Var2
	
	CMP #$0C
	BNE PRG053_A4FA	; If Y < $0C, jump to PRG053_A4FA (RTS)

	; Spr_Var1 = $50
	LDA #$50
	STA Spr_Var1+$00,X
	
	; Spr_Var2 = $00
	LDA #$00
	STA Spr_Var2+$00,X
	
	LDA #LOW(PRG053_BossTakotrash_FillHP)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_BossTakotrash_FillHP)
	STA Spr_CodePtrH+$00,X
	
	LDA #$00
	STA <General_Counter
	STA <Boss_HP
	
	; Display boss meter
	LDA #$8F
	STA HUDBarB_DispSetting
	
	LDA #(SPRFL1_ONSCREEN | SPRFL1_SCREENREL)
	STA Spr_Flags+$00,X
	
	LDA #(SPRFL1_ONSCREEN | SPRFL1_SCREENREL | SPRFL1_NOHITMOVEVERT)
	STA Spr_Flags+$14
	STA Spr_Flags+$13

PRG053_A4FA:
	RTS	; $A4FA


PRG053_BossTakotrash_FillHP:
	LDA <General_Counter
	AND #$07
	BNE PRG053_A4FA	; 7:8 jump to PRG053_A4FA (RTS)

	LDA #SFX_ENERGYGAIN
	JSR PRG063_QueueMusSnd

	INC <Boss_HP	; Boss_HP++
	LDA <Boss_HP
	CMP #$1C
	BNE PRG053_A4FA	; If Boss_HP < $1C, jump to PRG053_A4FA (RTS)

	LDA #LOW(PRG053_BossTakotrash_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_BossTakotrash_Cont)
	STA Spr_CodePtrH+$00,X
	
	LDA #PLAYERSTATE_STAND
	STA <Player_State

PRG053_BossTakotrash_Cont:
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG053_A4FA	; If Spr_Var1 > 0, jump to PRG053_A4FA (RTS)

	; Spr_Var1 = $50
	LDA #$50
	STA Spr_Var1+$00,X
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG053_A4FA	; If no free object slot, jump to PRG053_A4FA (RTS)

	LDA <RandomN+$00
	ADC <RandomN+$02
	STA <RandomN+$02
	AND #$01
	BNE PRG053_A559	; 1:2 jump to PRG053_A559

	LDA #SPRANM2_TAKOTRASH_FIREBALL
	JSR PRG063_CopySprSlotSetAnim

	LDA #$6C
	STA Spr_Y+$00,Y
	
	LDA #$94
	STA Spr_X+$00,Y
	
	LDA #SPRSLOTID_TAKOTRASH_FIREBALL
	STA Spr_SlotID+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | $1A)
	STA Spr_Flags2+$00,Y
	
	LDA #$00
	STA Spr_XVelFrac+$00,Y
	LDA #$02
	STA Spr_XVel+$00,Y
	
	RTS	; $A558


PRG053_A559:
	LDA #SPRANM2_TAKOTRASH_BALL
	JSR PRG063_CopySprSlotSetAnim

	LDA #$24
	STA Spr_Y+$00,Y
	
	LDA #$AC
	STA Spr_X+$00,Y
	
	LDA #SPRSLOTID_TAKOTRASH_BALL
	STA Spr_SlotID+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | $0D)
	STA Spr_Flags2+$00,Y
	
	LDA #$00
	STA Spr_YVelFrac+$00,Y
	LDA #$04
	STA Spr_YVel+$00,Y
	
	JSR PRG063_CalcObjXDiffFromPlayer
	STA <Temp_Var1	; -> Temp_Var1
	
	; Temp_Var3 = $3A
	LDA #$3A
	STA <Temp_Var3
	
	LDA Spr_Y+$00
	CMP #$68
	BGE PRG053_A590

	; Temp_Var3 = $28
	LDA #$28
	STA <Temp_Var3

PRG053_A590:
	LDA #$00
	STA <Temp_Var0	; Temp_Var0 = 0
	STA <Temp_Var2	; Temp_Var2 = 0
	
	STY <Temp_Var15	; Backup 'Y'
	
	JSR PRG063_ScaleVal

	LDY <Temp_Var15	; Restore 'Y'
	
	LDA <Temp_Var4
	STA Spr_XVelFrac+$00,Y
	LDA <Temp_Var5
	STA Spr_XVel+$00,Y
	
	RTS	; $A5A7

PRG053_Obj_TakotrashBall:
	LDY #$11
	JSR PRG063_DoObjVertMovement

	BCC PRG053_A5BD	; If didn't hit floor, jump to PRG053_A5BD

	JSR PRG062_ResetSpriteSlot

	LDA #SPRANM4_SMALLPOOFEXP
	JSR PRG063_SetSpriteAnim

	LDA #SPRSLOTID_CIRCULAREXPLOSION
	STA Spr_SlotID+$00,X
	
	RTS	; $A5BC


PRG053_Obj_TakotrashFireball:
PRG053_A5BD:
	JMP PRG063_ApplyXVelocityRev

PRG053_Obj_TakotrashPlatform:
	LDA Spr_X+$00,X
	CMP #$40
	BLT PRG053_A5CC	; If X < $40, jump to PRG053_A5CC

	; Spr_Var1 = $04
	LDA #$04
	STA Spr_Var1+$00,X

PRG053_A5CC:
	LDA <General_Counter
	AND #$01
	BNE PRG053_A5FA	; 1:2 jump to PRG053_A5FA (RTS)

	INC Spr_Y+$00,X	; Y++
	
	LDY Spr_Var1+$00,X	; Y = Spr_Var1
	
	LDA Spr_Y+$00,X
	CMP PRG053_TakotrashPlat_YLimit,Y
	BNE PRG053_A5FA	; If not at Y limit, jump to PRG053_A5FA (RTS)

	LDA Spr_X+$00,X
	CMP PRG053_TakotrashPlat_XLimit,Y
	BNE PRG053_A5FA	; If not at X limit, jump to PRG053_A5FA (RTS)

	INC Spr_Var1+$00,X	; Spr_Var1++
	
	LDA #LOW(PRG053_TakotPlat_AroundBottom)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_TakotPlat_AroundBottom)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var2 = 0
	LDA #$00
	STA Spr_Var2+$00,X

PRG053_A5FA:
	RTS	; $A5FA


PRG053_TakotPlat_AroundBottom:
	LDA <General_Counter
	AND #$01
	BNE PRG053_A64B	; 1:2 jump to PRG053_A64B

	LDY Spr_Var2+$00,X	; Y = Spr_Var2
	
	; Spr_Var2 += 2
	INC Spr_Var2+$00,X
	INC Spr_Var2+$00,X
	
	LDA Spr_Y+$00,X
	ADD PRG053_TakotrashPlat_BotDeltas,Y
	STA Spr_Y+$00,X

	LDA Spr_X+$00,X
	ADD PRG053_TakotrashPlat_BotDeltas+1,Y
	STA Spr_X+$00,X
	
	LDA PRG053_TakotrashPlat_BotDeltas+1,Y
	STA <Temp_Var15
	
	JSR PRG053_TakotrashPlat_TestColl

	LDY Spr_Var1+$00,X	; Y = Spr_Var1
	
	LDA Spr_X+$00,X
	CMP PRG053_TakotrashPlat_XLimit,Y
	BNE PRG053_A64B	; If not at the X limit, jump to PRG053_A64B (RTS)

	LDA Spr_Y+$00,X
	CMP PRG053_TakotrashPlat_YLimit,Y
	BNE PRG053_A64B	; If not at the Y limit, jump to PRG053_A64B (RTS)

	INC Spr_Var1+$00,X	; Spr_Var1++
	
	LDA #LOW(PRG053_TakotPlat_GoingUp)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_TakotPlat_GoingUp)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var2 = 0
	LDA #$00
	STA Spr_Var2+$00,X

PRG053_A64B:
	RTS	; $A64B


PRG053_TakotPlat_GoingUp:
	LDA <General_Counter
	AND #$01
	BNE PRG053_A67A	; 1:2 jump to PRG053_A67A (RTS)

	DEC Spr_Y+$00,X	; Spr_Y--
	
	LDY Spr_Var1+$00,X	; Y = Spr_Var1
	
	LDA Spr_Y+$00,X
	CMP PRG053_TakotrashPlat_YLimit,Y
	BNE PRG053_A67A	; If not at the Y limit, jump to PRG053_A67A

	LDA Spr_X+$00,X
	CMP PRG053_TakotrashPlat_XLimit,Y
	BNE PRG053_A67A	; If not at the X limit, jump to PRG053_A67A

	INC Spr_Var1+$00,X	; Spr_Var1++
	
	LDA #LOW(PRG053_TakotPlat_AroundTop)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_TakotPlat_AroundTop)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var2 = 0
	LDA #$00
	STA Spr_Var2+$00,X

PRG053_A67A:
	RTS	; $A67A


PRG053_TakotPlat_AroundTop:
	LDA <General_Counter
	AND #$01
	BNE PRG053_A6D0	; 1:2 jump to PRG053_A6D0 (RTS)

	LDY Spr_Var2+$00,X	; Y = Spr_Var2
	
	; Spr_Var2 += 2
	INC Spr_Var2+$00,X
	INC Spr_Var2+$00,X
	
	LDA Spr_Y+$00,X
	ADD PRG053_TakotrashPlat_TopDeltas,Y
	STA Spr_Y+$00,X
	
	LDA Spr_X+$00,X
	ADD PRG053_TakotrashPlat_TopDeltas+1,Y
	STA Spr_X+$00,X
	
	LDA PRG053_TakotrashPlat_TopDeltas+1,Y
	STA <Temp_Var15
	
	JSR PRG053_TakotrashPlat_TestColl

	LDY Spr_Var1+$00,X	; Y = Spr_Var1
	
	LDA Spr_X+$00,X
	CMP PRG053_TakotrashPlat_XLimit,Y
	BNE PRG053_A6D0	; If not as X limit, jump to PRG053_A6D0 (RTS)

	LDA Spr_Y+$00,X
	CMP PRG053_TakotrashPlat_YLimit,Y
	BNE PRG053_A6D0	; If not as Y limit, jump to PRG053_A6D0 (RTS)

	LDA #LOW(PRG053_Obj_TakotrashPlatform)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_Obj_TakotrashPlatform)
	STA Spr_CodePtrH+$00,X
	
	LDA Spr_Var1+$00,X
	AND #~$03
	STA Spr_Var1+$00,X
	
	; Spr_Var2 = 0
	LDA #$00
	STA Spr_Var2+$00,X

PRG053_A6D0:
	RTS	; $A6D0


PRG053_TakotrashPlat_TestColl:
	LDA Spr_Y+$00,X
	PHA
	DEC Spr_Y+$00,X
	JSR PRG063_TestPlayerObjCollide
	PLA
	STA Spr_Y+$00,X
	BCS PRG053_A6EA

	LDA Spr_X+$00
	ADD <Temp_Var15
	STA Spr_X+$00

PRG053_A6EA:
	RTS	; $A6EA


PRG059_Takotrash_Pal1:
	.byte $0F, $0F, $0F
	.byte $00, $0F, $06
	.byte $00, $10, $0F
	.byte $16, $10, $30

PRG059_Takotrash_Pal2:
	.byte $0F, $0F, $0F
	.byte $00, $0F, $0F
	.byte $00, $10, $0F
	.byte $06, $10, $30

PRG059_Takotrash_Pal3:
	.byte $0F, $0F, $0F
	.byte $00, $0F, $06
	.byte $00, $10, $0F
	.byte $16, $06, $30
	
PRG053_TakotrashPlat_YLimit:
	.byte $98, $98, $58, $58, $78, $78, $38, $38
	
PRG053_TakotrashPlat_XLimit:
	.byte $32, $22, $22, $32, $62, $52, $52, $62
	
PRG053_TakotrashPlat_BotDeltas:
	.byte $01, $00, $01, $00, $00, $FF, $01, $00, $01, $00, $00, $FF, $01, $00, $00, $FF
	.byte $00, $FF, $01, $00, $00, $FF, $00, $FF, $01, $00, $00, $FF, $00, $FF, $00, $FF
	.byte $FF, $00, $00, $FF, $00, $FF, $FF, $00, $00, $FF, $00, $FF, $FF, $00, $00, $FF
	.byte $FF, $00, $FF, $00, $00, $FF, $FF, $00, $FF, $FF

PRG053_TakotrashPlat_TopDeltas:
	.byte $FF, $01, $FF, $00, $FF, $00, $00, $01, $FF, $00, $FF, $00, $00, $01, $FF, $00
	.byte $00, $01, $00, $01, $FF, $00, $00, $01, $00, $01, $FF, $00, $00, $01, $00, $01
	.byte $00, $01, $01, $00, $00, $01, $00, $01, $01, $00, $00, $01, $00, $01, $01, $00
	.byte $00, $01, $01, $00, $01, $00, $00, $01, $01, $00, $01, $00, $01, $00


PRG053_Obj_WilyTransporter:
	LDA #(SPRFL1_ONSCREEN | SPRFL1_SCREENREL)
	STA Spr_Flags+$00,X
	
	JSR PRG063_TestPlayerObjCollide
	BCS PRG053_A7E6	; If Player didn't collide, jump to PRG053_A7E6 (RTS)

	LDA <Player_State
	BNE PRG053_A7E6	; If Player is not in standing state, jump to PRG053_A7E6 (RTS)

	STA <Player_ShootAnimTimer
	STA <Player_CurShootAnim
	
	LDA #PLAYERSTATE_WILYTRANS
	STA <Player_State
	
	LDA Spr_X+$00,X
	STA Spr_X+$00	
	LDA Spr_Y+$00,X
	STA Spr_Y+$00	
	
	LDA #SPRANM2_TELEPORTOUT
	LDY #$00
	JSR PRG063_SetSpriteAnimY

	LDA <Current_Screen
	CMP #$09
	BNE PRG053_A7E6	; If Current_Screen <> 9, jump to PRG053_A7E6 (RTS)

	; Backup the parent index of the transporter object -> WilyTrans_LastTransParentIdx
	LDA Spr_SpawnParentIdx,X
	STA WilyTrans_LastTransParentIdx
	
	LDY #$00	; $A7CC
	STY <WilyTrans_CurPortal	; $A7CE

PRG053_A7D0:
	LDA Spr_Y+$00,X
	CMP PRG053_WilyTrans_CheckCoords,Y
	BNE PRG053_A7E0	; If Y didn't match, jump to PRG053_A7E0

	LDA Spr_X+$00,X
	CMP PRG053_WilyTrans_CheckCoords+1,Y
	BEQ PRG053_A7E6	; If X matched, jump to PRG053_A7E6 (RTS)


PRG053_A7E0:
	; Y += 2 (next coordinate pair)
	INY
	INY
	
	INC <WilyTrans_CurPortal	; WilyTrans_CurPortal++
	BNE PRG053_A7D0	; Loop


PRG053_A7E6:
	RTS	; $A7E6


PRG053_WilyTrans_CheckCoords:
	.byte $44, $20
	.byte $84, $20
	.byte $C4, $20
	.byte $C4, $70
	.byte $C4, $90
	.byte $44, $E0
	.byte $84, $E0
	.byte $C4, $E0
	.byte $44, $80

PRG053_Obj_BossRobotMaster:
	LDY <TileMap_Index
	CPY #TMAP_COSSACK1
	BGE PRG053_A80D	; If this is a fortress level, jump to PRG053_A80D

	LDA <Player_CompletedBosses
	AND PRG063_IndexToBit,Y	
	BEQ PRG053_A80D	; If this robot master hasn't yet been defeated, jump to PRG053_A80D
	
	; The case where you've re-entered a level and the robot master is already defeated...

	LDA #PLAYERSTATE_TELEPORTOUT
	STA <Player_State
	JMP PRG063_DeletePlayerObjs

PRG053_A80D:
	JSR PRG063_InitBossMus_Plyr_RetX

	CMP #PLAYERSTATE_BOSSWAIT
	BNE PRG053_A7E6	; If Player is not in boss wait state, jump to PRG053_A7E6 (RTS)

	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	JSR PRG053_GetCorrectBossID

	LDA PRG053_RMaster_AnimByBossID,Y
	CMP Spr_CurrentAnim+$00,X
	BEQ PRG053_A827	; If the intro animation is already set, jump to PRG053_A827

	; Set robot master's intro animation
	JSR PRG063_SetSpriteAnim

PRG053_A827:
	LDA Spr_Y+$00,X
	CMP #$80
	BGE PRG053_A831	; If robot master has landed, jump to PRG053_A831

	; Keep falling
	JMP PRG063_DoMoveSimpleVert


PRG053_A831:
	LDA PRG053_RMaster_BBoxByBossID,Y
	TAY
	JSR PRG063_DoObjVertMovement

	BCC PRG053_A89E	; If didn't hit floor, jump to PRG053_A89E (RTS)

	LDA #LOW(PRG053_BossRobotMaster_FillHP)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_BossRobotMaster_FillHP)
	STA Spr_CodePtrH+$00,X
	
	LDA #$00
	STA <General_Counter
	STA <Boss_HP
	
	; Display boss meter
	LDA #$8F
	STA HUDBarB_DispSetting


PRG053_BossRobotMaster_FillHP:
	LDA Spr_Frame+$00,X
	CMP #$05
	BNE PRG053_A89E	; If frame <> 5, jump to PRG053_A89E (RTS)

	; Freeze animation
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	LDA <General_Counter
	AND #$07
	BNE PRG053_A89E	; 7:8 jump to PRG053_A89E (RTS)

	LDA #SFX_ENERGYGAIN
	JSR PRG063_QueueMusSnd

	INC <Boss_HP	; Boss_HP++
	LDA <Boss_HP
	CMP #$1C
	BNE PRG053_A89E	; If boss HP not yet full, jump to PRG053_A89E (RTS)

	JSR PRG062_ResetSpriteSlot
	JSR PRG053_GetCorrectBossID

	LDA PRG053_RMaster_SprIDForBossID,Y
	STA Spr_SlotID+$00,X
	
	LDA PRG053_RMaster_AnimForBossID,Y
	JSR PRG063_SetSpriteAnim

	LDA PRG053_RMaster_Flags2ForBossID,Y
	STA Spr_Flags2+$00,X
	
	LDA PRG053_RMaster_XvelFForBossID,Y
	STA Spr_XVelFrac+$00,X
	LDA PRG053_RMaster_XvelForBossID,Y
	STA Spr_XVel+$00,X
	
	; HP = $1C (max!)
	LDA #$1C
	STA Spr_HP+$00,X
	
	JSR PRG063_SetObjYVelToMinus1

	; Unlock Player
	LDA #PLAYERSTATE_STAND
	STA <Player_State

PRG053_A89E:
	RTS	; $A89E


PRG053_GetCorrectBossID:
	LDY <TileMap_Index
	CPY #TMAP_COSSACK1
	BLT PRG053_A8AB	; If this is not the second half of the game, jump to PRG053_A8AB (RTS)

	LDY <WilyTrans_CurPortal
	
	LDA PRG053_RMaster_TransToBossID,Y
	TAY

PRG053_A8AB:
	RTS	; $A8AB


PRG053_RMaster_AnimByBossID:
	.byte SPRANM3_BOSSINT_BRIGHT, SPRANM3_BOSSINT_TOAD, SPRANM3_BOSSINT_DRILL, SPRANM3_BOSSINT_PHARAOH, SPRANM3_BOSSINT_RING, SPRANM3_BOSSINT_DUST, SPRANM3_BOSSINT_DIVE, SPRANM3_BOSSINT_SKULL

PRG053_RMaster_BBoxByBossID:
	.byte $13, $0A, $0A, $0A, $0C, $0C, $0A, $08

PRG053_RMaster_SprIDForBossID:
	.byte SPRSLOTID_BOSSBRIGHT, SPRSLOTID_BOSSTOAD, SPRSLOTID_BOSSDRILL, SPRSLOTID_BOSSPHARAOH, SPRSLOTID_BOSSRING, SPRSLOTID_BOSSDUST, SPRSLOTID_BOSSDIVE, SPRSLOTID_BOSSSKULL
	
PRG053_RMaster_AnimForBossID:
	.byte SPRANM3_BRIGHTMAN_STAND, SPRANM3_TOADMAN_IDLE, SPRANM3_DRILLMAN_IDLE, SPRANM3_PHARAOHMAN_ATTACK2, SPRANM3_RINGMAN_IDLE, SPRANM3_DUSTMAN_IDLE, SPRANM3_DIVEMAN_IDLE, SPRANM3_SKULLMAN_IDLE
	
PRG053_RMaster_Flags2ForBossID:
	.byte (SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $23), (SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $23), (SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $36), (SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $24), (SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $23), (SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $23), (SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $24), (SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $36)

PRG053_RMaster_TransToBossID:
	.byte TMAP_DRILLMAN, TMAP_BRIGHTMAN, TMAP_SKULLMAN, TMAP_DIVEMAN, TMAP_TOADMAN, TMAP_PHARAOHMAN, TMAP_RINGMAN, TMAP_DUSTMAN
	
PRG053_MothrayaDie_PalFlash:
	.byte $0F, $20
	
PRG053_RMaster_XvelFForBossID:
	.byte $80, $80, $80, $00, $00, $99, $00, $80

PRG053_RMaster_XvelForBossID:
	.byte $01, $01, $01, $02, $02, $01, $04, $01


PRG053_Obj_Mothraya_Die:
	LDA #$0F	; Black palette color
	LDY #$0B	; Y = $B
PRG053_A8F2:
	STA PalData_1+4,Y
	STA PalData_2+4,Y
	
	DEY	; Y--
	BPL PRG053_A8F2	; While Y >= 0, loop

	STY <CommitPal_Flag	; Commit palette
	
	LDY #$16	; Y = $16
PRG053_A8FF:
	JSR PRG063_DeleteObjectY

	DEY	; Y--
	CPY #$07
	BNE PRG053_A8FF	; While Y > 7, loop

	LDA #$00
	STA <General_Counter
	JSR PRG063_SetSpriteAnim

	LDA #LOW(PRG053_A927)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_A927)
	STA Spr_CodePtrH+$00,X
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG053_A927	; If no free object slot index, jump to PRG053_A927

	LDA #SPRANM4_SMALLPOOFEXP
	JSR PRG063_CopySprSlotSetAnim

	LDA #SPRSLOTID_CEXPLOSION
	STA Spr_SlotID+$00,Y

PRG053_A927:
	LDA <General_Counter
	LSR A
	LSR A
	AND #$01
	TAY	; Y = 0 or 1
	
	LDA PRG053_MothrayaDie_PalFlash,Y
	STA PalData_1+16
	
	; Commit palette
	LDA #$FF
	STA <CommitPal_Flag
	
	LDA <General_Counter
	CMP #$90
	BNE PRG053_A970	; If General_Counter <> $90

	LDA #LOW(PRG053_A948)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_A948)
	STA Spr_CodePtrH+$00,X
	
PRG053_A948:
	LDA <Player_State
	BNE PRG053_A970	; If Player is not standing, jump to PRG053_A970 (RTS)

	JSR PRG062_ResetSpriteSlot

	LDA #$88
	STA <Raster_VSplit_Req
	
	LDA #$00
	STA <Raster_VSplit_HPosReq
	STA <PPU_CTL1_PageBaseReq_RVBoss
	STA <PPU_CTL1_PageBaseReq
	STA <Raster_VMode
	STA <Vert_Scroll
	
	LDA #MUS_BOSSVICTORY
	JSR PRG063_QueueMusSnd_SetMus_Cur

	LDA #$FF
	STA Level_EndLevel_Timeout
	
	LDA #PLAYERSTATE_ENDLEVEL
	STA <Player_State
	
	JSR PRG063_DeletePlayerObjs

PRG053_A970:
	RTS	; $A970


PRG053_Obj_Kalinka:
	LDA Spr_Var1+$00,X
	BEQ PRG053_A980	; If Spr_Var1 = 0, jump to PRG053_A980

	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG053_A9B5	; If Spr_Var1 > 0, jump to PRG053_A9B5 (RTS)


PRG053_A980:
	LDA Spr_X+$00,X
	CMP #$88
	BEQ PRG053_A98C	; If Kalinka's in position, jump to PRG053_A98C

	DEC Spr_X+$00,X	; Kalinka moves left
	BNE PRG053_A9B5	; Jump (technically always) to PRG053_A9B5 (RTS)


PRG053_A98C:
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	LDA #$B8
	STA <Raster_VSplit_Req
	
	LDA #RVMODE_CINEDIALOG
	CMP <Raster_VMode
	BEQ PRG053_A9A7	; If raster effect set, jump to PRG053_A9A7

	STA <Raster_VMode
	
	; Init dialog vars
	LDA #$00
	STA <CineCsak_CurDialogSet
	STA <CineCsak_TextOffset
	
	LDA #PLAYERSTATE_POSTCOSSCIN
	STA <Player_State

PRG053_A9A7:
	LDA <CineCsak_CurDialogSet
	CMP #$01
	BNE PRG053_A9B5

	; Turn around to face Cossack
	LDA Spr_Flags+$00,X
	ORA #SPR_HFLIP
	STA Spr_Flags+$00,X

PRG053_A9B5:
	RTS	; $A9B5

PRG053_Obj_Protoman:
	LDA Spr_Frame+$00,X
	BNE PRG053_A9D0	; If frame <> 0, jump to PRG053_A9D0

	; Dropping to floor
	LDA #$00
	STA Spr_AnimTicks+$00,X
	JSR PRG063_DoMoveSimpleVert

	LDA #$84
	CMP Spr_Y+$00,X
	BGE PRG053_A9B5	; If Proto Man hasn't come down low enough, jump to PRG053_A9B5 (RTS)

	STA Spr_Y+$00,X	; Lock position
	
	INC Spr_Frame+$00,X	; frame++

PRG053_A9D0:
	LDA Spr_Frame+$00,X
	CMP #$04
	BNE PRG053_A9B5	; If frame <> 4, jump to PRG053_A9B5 (RTS)

	LDA #SPRANM2_PROTOMAN_STAND
	CMP Spr_CurrentAnim+$00,X
	BEQ PRG053_AA15	; If already in the standing animation, jump to PRG053_AA15

	; Set standing animation
	JSR PRG063_SetSpriteAnim

	; Delete object at index $14
	LDY #$14
	JSR PRG063_DeleteObjectY

	; Instantiate Kalinka here
	LDA #SPRANM2_KALINKA_WALKING
	JSR PRG063_CopySprSlotSetAnim

	LDA #SPRSLOTID_KALINKA
	STA Spr_SlotID+$00,Y
	
	LDA #$3C
	STA Spr_Var1+$00,X	; Spr_Var1 = $3C (Proto Man)
	STA Spr_Var1+$00,Y	; Spr_Var1 = $3C (Kalinka)
	
	LDA #$C8
	STA Spr_X+$00,Y
	
	LDA #$84
	STA Spr_Y+$00,Y
	
	LDA #$00
	STA Spr_YVelFrac+$00,X
	STA Spr_YVel+$00,X
	
	LDA #LOW(PRG053_AA15)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_AA15)
	STA Spr_CodePtrH+$00,X
	
	RTS	; $AA14


PRG053_AA15:
	LDA Spr_Var1+$00,X
	BEQ PRG053_AA29	; If Spr_Var1 = 0, jump to PRG053_AA29

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG053_AA51	; If Spr_Var1 > 0, jump to PRG053_AA51 (RTS)

	LDA #SPRANM2_PROTOTELEPORT
	JSR PRG063_SetSpriteAnim

	; Set to teleport frame immediately
	LDA #$04
	STA Spr_Frame+$00,X

PRG053_AA29:
	LDA Spr_Frame+$00,X
	CMP #$02
	BNE PRG053_AA51	; If frame <> 2, jump to PRG053_AA51 (RTS)

	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	; Teleporting up
	LDA Spr_YVelFrac+$00,X
	ADD #$40
	STA Spr_YVelFrac+$00,X
	LDA Spr_YVel+$00,X
	ADC #$00
	STA Spr_YVel+$00,X
	JSR PRG063_ApplyYVelocityNeg

	LDA Spr_YHi+$00,X
	BEQ PRG053_AA51	; If not vertically off-screen, jump to PRG053_AA51 (RTS)

	JSR PRG062_ResetSpriteSlot

PRG053_AA51:
	RTS	; $AA51

PRG053_Obj_WilyMachineFour:
	JSR PRG063_InitBossMus_Plyr_RetX

	CMP #PLAYERSTATE_BOSSWAIT
	BNE PRG053_AA51	; If Player is not in boss wait state, jump to PRG053_AA51 (RTS)

	; Load screen $0C into "other" side of BG
	LDA #$0C
	STA <CommitBG_ScrSel	
	LDA #$80
	STA <CommitBG_Flag
	
	LDA #LOW(PRG053_WilyMachineFour_Init)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_WilyMachineFour_Init)
	STA Spr_CodePtrH+$00,X
	
PRG053_WilyMachineFour_Init:
	LDA <CommitBG_Flag
	BNE PRG053_AAB0	; If haven't committed WM4 to BG, jump to PRG053_AAB0 (RTS)

	STA <Raster_VSplit_HPosReq
	STA <PPU_CTL1_PageBaseReq_RVBoss
	
	; Raster_VSplit_Req = $C0
	LDA #$C0
	STA <Raster_VSplit_Req
	
	LDA #RVMODE_WBOSS1
	STA <Raster_VMode
	
	LDA #LOW(PRG053_WilyMachineFour_Lower)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_WilyMachineFour_Lower)
	STA Spr_CodePtrH+$00,X
	
	; Position WM4 at top
	LDA #$FF
	STA Spr_YHi+$00,X
	STA Spr_YHi+$17
	
	LDA #(SPRFL1_ONSCREEN | SPRFL1_SCREENREL)
	STA Spr_Flags+$00,X
	STA Spr_Flags+$17	
	STA Spr_Flags+$15	
	STA Spr_Flags+$14	
	
	LDA #$80
	STA Spr_YVelFrac+$00,X
	STA Spr_XVelFrac+$00,X
	LDA #$00
	STA Spr_YVel+$00,X
	STA Spr_XVel+$00,X
	
	LDA #SPRDIR_DOWN
	STA Spr_FaceDir+$00,X

PRG053_AAB0:
	RTS	; $AAB0


PRG053_WilyMachineFour_Lower:

	; Move down
	JSR PRG063_ApplyYVelocityH16

	JSR PRG053_WM4_SetPosDecoAndScr

	LDA Spr_YHi+$00,X
	BNE PRG053_AAB0	; If still vertically off-screen, jump to PRG053_AAB0 (RTS)

	LDA Spr_Y+$00,X
	CMP #$70
	BNE PRG053_AAB0	; If still too high, jump to PRG053_AAB0 (RTS)

	LDA #$00
	STA <General_Counter
	STA <Boss_HP
	
	; Display boss meter
	LDA #$8F
	STA HUDBarB_DispSetting
	
	LDA #LOW(PRG053_WilyMachineFour_FillHP)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_WilyMachineFour_FillHP)
	STA Spr_CodePtrH+$00,X
	

PRG053_WilyMachineFour_FillHP:
	LDA <General_Counter
	AND #$07
	BNE PRG053_AB0B	; 7:8 jump to PRG053_AB0B (RTS)
	
	LDA #SFX_ENERGYGAIN
	JSR PRG063_QueueMusSnd

	INC <Boss_HP	; Boss_HP++
	LDA <Boss_HP
	CMP #$1C
	BNE PRG053_AB0B	; If boss HP is not max, jump to PRG053_AB0B (RTS)

	LDA #PLAYERSTATE_STAND
	STA <Player_State
	
	LDA #LOW(PRG053_WilyMachineFour_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_WilyMachineFour_Cont)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var1 = $20
	LDA #$20
	STA Spr_Var1+$00,X
	
	; Spr_Var2 = $28
	LDA #$28
	STA Spr_Var2+$00,X
	
	LDA #$94	; $AB03
	STA Spr_Flags+$15	; $AB05
	STA Spr_Flags+$14	; $AB08

PRG053_AB0B:
	RTS	; $AB0B


PRG053_WilyMachineFour_Cont:

	; Move vertically
	JSR PRG063_DoMoveVertOnlyH16

	LDA Spr_Flags+$15	; $AB0F
	AND #$04	; $AB12
	BNE PRG053_AB25	; $AB14

	LDA Spr_Frame+$15
	CMP #$12
	BNE PRG053_AB25	; If left rocket frame <> $12, jump to PRG053_AB25

	LDA #$94	; $AB1D
	STA Spr_Flags+$15	; $AB1F
	STA Spr_Flags+$14	; $AB22

PRG053_AB25:
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG053_AB51	; If Spr_Var1 > 0, jump to PRG053_AB51

	; Spr_Var1 = $40
	LDA #$40
	STA Spr_Var1+$00,X
	
	; Reverse vertical direction
	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_UP | SPRDIR_DOWN)
	STA Spr_FaceDir+$00,X
	
	AND #SPRDIR_UP
	BEQ PRG053_AB51	; If not moving up, jump to PRG053_AB51
	
	; Moving up...

	LDA #$90	; $AB3B
	STA Spr_Flags+$15	; $AB3D
	STA Spr_Flags+$14	; $AB40
	
	; Reset rockets
	LDA #$00
	STA Spr_Frame+$15
	STA Spr_Frame+$14
	STA Spr_AnimTicks+$15
	STA Spr_AnimTicks+$14

PRG053_AB51:
	LDA Spr_Var2+$00,X
	BNE PRG053_ABA3	; If Spr_Var2 > 0, jump to PRG053_ABA3

	LDY Spr_Var3+$00,X	; Y = Spr_Var3
	
	LDA PRG053_WM4_Var2,Y
	STA Spr_Var2+$00,X
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG053_ABA3	; If no free slot, jump to PRG053_ABA3

	LDA #$67	; $AB64
	STA <Temp_Var16	; $AB66

	; Forced into slot $17 (so doesn't use return from PRG063_FindFreeSlotMinIdx7, but prevents charge anim if can't fire)
	LDA #SPRANM2_WILYMACHINE4_SHOTCH
	LDX #$17
	JSR PRG063_InitProjectile

	LDX #$16	; X = $16
	
	LDA #SPRSLOTID_WILYMACHINE4_SHOTCH
	STA Spr_SlotID+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | $0D)
	STA Spr_Flags2+$00,Y
	
	LDA #$F6
	STA Spr_XVelFrac+$00,Y
	LDA #$01
	STA Spr_XVel+$00,Y
	
	LDA #$63
	STA Spr_YVelFrac+$00,Y
	LDA #$00
	STA Spr_YVel+$00,Y
	
	LDA #(SPRDIR_LEFT | SPRDIR_DOWN)
	STA Spr_FaceDir+$00,Y
	
	INC Spr_Var3+$00,X	; Spr_Var3++
	
	LDA Spr_Var3+$00,X
	CMP #$03
	BNE PRG053_ABA3	; If Spr_Var3 <> 3, jump to PRG053_ABA3

	; Spr_Var3 = 0
	LDA #$00
	STA Spr_Var3+$00,X

PRG053_ABA3:
	DEC Spr_Var2+$00,X	; Spr_Var2--

PRG053_WM4_SetPosDecoAndScr:
	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM2_WILYMACHINE4_PHASE1
	BEQ PRG053_ABC2	; If on phase 1, jump to PRG053_ABC2

	; Horizontal position of boss
	LDA Spr_X+$00,X	
	ADD #$30
	STA Spr_X+$17

	; Vertical position of boss
	LDA Spr_Y+$00,X
	ADD #$08
	STA Spr_Y+$17
	
	JMP PRG053_ABF8	; Jump to PRG053_ABF8


PRG053_ABC2:
	; Horizontal position of boss
	LDA Spr_X+$00,X
	ADD #$20
	STA Spr_X+$17
	
	; Vertical position of boss
	LDA Spr_Y+$00,X
	STA Spr_Y+$17	
	LDA Spr_YHi+$00,X
	STA Spr_YHi+$17
	
	; Vertical position of left and right rockets
	LDA Spr_Y+$17
	ADD #$30
	BCS PRG053_ABE3

	CMP #$F0
	BLT PRG053_ABE6

PRG053_ABE3:
	ADD #$10

PRG053_ABE6:
	STA Spr_Y+$15	; Vertical position of left rocket
	STA Spr_Y+$14	; Vertical position of right rocket
	
	; Horizontal position of left and right rockets
	LDA Spr_X+$17
	STA Spr_X+$15
	ADD #$1C
	STA Spr_X+$14

PRG053_ABF8:
	
	; Raster screen horizontal position
	LDA #$C0
	SUB Spr_X+$17
	STA <Raster_VSplit_HPosReq
	
	; Raster screen vertical position
	LDA #$AF
	SUB Spr_Y+$17
	STA <Vert_Scroll
	BCS PRG053_AC12

	SBC #$0F
	STA <Vert_Scroll
	
	LDA #$02
	STA <PPU_CTL1_PageBaseReq_RVBoss

PRG053_AC12:
	RTS	; $AC12


PRG053_Obj_WM4_ChargeShot:
	; Charge Shot starts near the charging animation 
	LDA Spr_Y+$17
	ADD #$10
	STA Spr_Y+$00,X
	LDA Spr_X+$17
	SUB #$28
	STA Spr_X+$00,X
	
	LDA Spr_Frame+$00,X
	CMP #$07
	BNE PRG053_AC12	; If frame <> 7, jump to PRG053_AC12 (RTS)

	LDA #SPRANM2_WILYMACHINE4_SHOT
	JSR PRG063_SetSpriteAnim

	LDA #LOW(PRG053_Obj_WM4_ChargeShot_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_Obj_WM4_ChargeShot_Cont)
	STA Spr_CodePtrH+$00,X
	

PRG053_Obj_WM4_ChargeShot_Cont:
	JSR PRG063_ApplyVelSetFaceDir
	JMP PRG063_DoMoveVertOnlyH16
	

PRG053_Obj_WilyMachineFour_P2:
	; Reset boss HP!
	LDA #$1C
	STA Spr_HP+$00,X
	
	; Spr_Flags2 = 0
	LDA #$00
	STA Spr_Flags2+$00,X
	
	LDY Spr_Var1+$00,X	; Y = Spr_Var1
	BNE PRG053_AC64	; If Spr_Var1 > 0, jump to PRG053_AC64

	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG053_AC64	; If no free slot, jump to PRG053_AC64

	LDA #SPRANM4_SMALLPOOFEXP
	JSR PRG063_CopySprSlotSetAnim

	LDA #SPRSLOTID_CEXPLOSION
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_Flags2+$00,Y

PRG053_AC64:
	LDY Spr_Var1+$00,X	; Y = Spr_Var1
	
	STX <Temp_Var0	; Backup object slot index -> Temp_Var0
	
	LDX #$00
PRG053_AC6B:
	LDA PRG053_WM4P2_FaceRemoveGBuf,Y
	STA Graphics_Buffer+$00,X
	
	INX	; X++ (next Graphics_Buffer index)
	INY	; Y++ (next PRG053_WM4P2_FaceRemoveGBuf index)
	
	CMP #$80	; Check for custom terminator
	BNE PRG053_AC6B	; While didn't hit custom terminator, loop

	LDX <Temp_Var0	; Restore object slot index
	
	STA <CommitGBuf_Flag	; Commit graphics
	
	; Current Graphics_Buffer index -> Spr_Var1
	TYA
	STA Spr_Var1+$00,X
	
	INC Spr_Var2+$00,X	; Spr_Var2++
	
	LDA Spr_Var2+$00,X
	CMP #$02
	BNE PRG053_ACC4	; If Spr_Var2 <> 2, jump to PRG053_ACC4

	LDA #LOW(PRG053_WM4P2_BossInit)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_WM4P2_BossInit)
	STA Spr_CodePtrH+$00,X
	
	LDY #$17
	LDA #SPRANM2_WM4P2_DECOSPRITES
	JSR PRG063_SetSpriteAnimY

	LDA #SPRANM2_WM4P2_WILY
	JSR PRG063_SetSpriteAnim

	LDA Spr_X+$00,X
	SUB #$10
	STA Spr_X+$00,X
	LDA Spr_Y+$00,X
	ADD #$08
	STA Spr_Y+$00,X
	
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $0D)	
	STA Spr_Flags2+$00,X
	
	; Boss_HP = 0
	LDA #$00
	STA <Boss_HP
	
	LDY #$15
	JSR PRG063_DeleteObjectY
	LDY #$14
	JSR PRG063_DeleteObjectY


PRG053_ACC4:
	RTS	; $ACC4


PRG053_WM4P2_BossInit:
	JSR PRG063_InitBossMus_Plyr_RetX

	CMP #PLAYERSTATE_BOSSWAIT
	BNE PRG053_ACC4	; If Player is not in boss wait state, jump to PRG053_ACC4 (RTS)

	LDA #$02
	STA <PPU_CTL1_PageBaseReq_RVBoss
	
	LDA Spr_Y+$00,X
	CMP #$70
	BEQ PRG053_ACE3	; If WM4 P2 is vertically in place, jump to PRG053_ACE3
	BGE PRG053_ACDE	; If too low, jump to PRG053_ACDE

	INC Spr_Y+$00,X	; WM4 P2 move down to get into position
	BNE PRG053_AD13	; Jump (technically always) to PRG053_AD13


PRG053_ACDE:
	DEC Spr_Y,X		; WM4 P2 move up to get in position
	BNE PRG053_AD13	; Jump (technically always) to PRG053_AD13


PRG053_ACE3:
	LDA <General_Counter
	AND #$07
	BNE PRG053_AD13	; 7:8 jump to PRG053_AD13

	; Energy gain noise
	LDA #SFX_ENERGYGAIN
	JSR PRG063_QueueMusSnd

	INC <Boss_HP	; Boss_HP++
	
	LDA <Boss_HP
	CMP #$1C
	BNE PRG053_AD13	; If boss isn't fully charged, jump to PRG053_AD13

	LDA #PLAYERSTATE_STAND
	STA <Player_State
	
	LDA #LOW(PRG053_WM4P2_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_WM4P2_Cont)
	STA Spr_CodePtrH+$00,X
	
	LDA #SPRDIR_LEFT
	STA Spr_FaceDir+$00,X
	
	; Spr_Var1 = 1
	LDA #$01
	STA Spr_Var1+$00,X
	
	; Spr_Var2 = $28
	LDA #$28
	STA Spr_Var2+$00,X

PRG053_AD13:
	JMP PRG053_WM4_SetPosDecoAndScr


PRG053_WM4P2_Cont:
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG053_AD32	; If Spr_Var1 > 0, jump to PRG053_AD32

	LDA <RandomN+$00
	ADC <RandomN+$03
	STA <RandomN+$03
	AND #$07
	TAY	; Y = 0 to 7
	
	LDA PRG053_WM4P2_Var1,Y
	STA Spr_Var1+$00,X
	
	; Reverse left/right direction
	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_LEFT | SPRDIR_RIGHT)
	STA Spr_FaceDir+$00,X

PRG053_AD32:
	JSR PRG063_ApplyVelSetFaceDir

	LDA #(SPRFL1_ONSCREEN | SPRFL1_SCREENREL)
	STA Spr_Flags+$00,X
	
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BEQ PRG053_AD4A	; If moving left, jump to PRG053_AD4A

	LDA #$90
	CMP Spr_X+$00,X
	BGE PRG053_AD5C	; If X >= $90, jump to PRG053_AD5C
	BLT PRG053_AD51	; Otherwise, jump to PRG053_AD51


PRG053_AD4A:
	LDA #$50
	CMP Spr_X+$00,X
	BLT PRG053_AD5C	; If X >= $50, jump to PRG053_AD5C


PRG053_AD51:
	STA Spr_X+$00,X	; Stop at X limit
	
	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_LEFT | SPRDIR_RIGHT)
	STA Spr_FaceDir+$00,X

PRG053_AD5C:
	DEC Spr_Var2+$00,X	; Spr_Var2--
	BNE PRG053_ADD3	; If Spr_Var2 > 0, jump to PRG053_ADD3

	; Spr_Var2 = $28
	LDA #$28
	STA Spr_Var2+$00,X
	
	LDA Spr_X+$00,X
	CMP Spr_X+$00	
	BLT PRG053_AD75	; If WM4's X < Player's X, jump to PRG053_AD75

	; Special code branch for if you get "under" the Wily Machine 4

	JSR PRG063_CalcObjYDiffFromPlayer

	CMP #$30
	BGE PRG053_AD98	; If Y difference from Player is >= $30, jump to PRG053_AD98


PRG053_AD75:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG053_ADD3	; If no free object slot, jump to PRG053_ADD3

	; Temp_Var16 = $67
	LDA #$67
	STA <Temp_Var16
	
	LDA #SPRANM2_WILYMACHINE4_SHOTCH
	LDX #$17
	JSR PRG063_InitProjectile

	LDX #$16
	
	LDA #$00
	STA Spr_XVelFrac+$00,Y
	LDA #$02
	STA Spr_XVel+$00,Y
	
	LDA #SPRDIR_LEFT
	STA Spr_FaceDir+$00,Y
	BNE PRG053_ADC4	; Jump (technically always) to PRG053_ADC4


PRG053_AD98:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG053_ADD3	; If no free object slot, jump to PRG053_ADD3

	; Temp_Var16 = $67
	LDA #$67
	STA <Temp_Var16
	
	LDA #SPRANM2_WILYMACHINE4_SHOTCH
	LDX #$17
	JSR PRG063_InitProjectile

	; Temp_Var14 = $16
	LDX #$16
	STX <Temp_Var14
	
	; 'Y' -> 'X' via Temp_Var15 (backing up Y)
	STY <Temp_Var15
	LDX <Temp_Var15
	
	; Projectile intended speed magnitude
	LDA #$00
	STA <Temp_Var2
	LDA #$02
	STA <Temp_Var3
	
	JSR PRG063_AimPlayer_Var23Spd

	LDX <Temp_Var14	; $ADBB
	LDY <Temp_Var15	; Restore Y
	
	; Aim direction
	LDA <Temp_Var12
	STA Spr_FaceDir+$00,Y

PRG053_ADC4:
	LDA #(SPRFL1_ONSCREEN | SPRFL1_SCREENREL)
	STA Spr_Flags+$00,Y
	
	LDA #SPRSLOTID_WILYMACHINE4_SHOTCH
	STA Spr_SlotID+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | $0D)
	STA Spr_Flags2+$00,Y

PRG053_ADD3:
	JMP PRG053_WM4_SetPosDecoAndScr
	

PRG053_Obj_WilyEscapePod:
	LDA #$33
	STA Spr_YVelFrac+$00,X	
	LDA #$00
	STA Spr_YVel+$00,X
	
	JSR PRG063_ApplyYVelocityH16
	JSR PRG053_WM4_SetPosDecoAndScr

	LDA <General_Counter
	AND #$07
	BNE PRG053_AE04	; 7:8 jump to PRG053_AE04

	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG053_AE04	; If no free object slot index, jump to PRG053_AE04

	LDA #SPRANM4_SMALLPOOFEXP
	LDX #$17
	JSR PRG063_CopySprSlotSetAnim

	LDX #$16	; $ADF8
	
	LDA #SPRSLOTID_CEXPLOSION
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_Flags2+$00,Y

PRG053_AE04:
	LDA Spr_Y+$00,X
	CMP #$88
	BNE PRG053_AE15	; If Spr_Y <> $88, jump to PRG053_AE15 (RTS)

	LDA #LOW(PRG053_WilyEscapePod_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_WilyEscapePod_Cont)
	STA Spr_CodePtrH+$00,X

PRG053_AE15:
	RTS	; $AE15


PRG053_WilyEscapePod_Cont:
	LDA #$00
	STA <Raster_VSplit_HPosReq
	STA <PPU_CTL1_PageBaseReq_RVBoss
	STA <Vert_Scroll
	
	LDY #$17
	JSR PRG063_DeleteObjectY

	; Delete all other objects
	LDY #$15
PRG053_AE25:
	JSR PRG063_DeleteObjectY

	DEY	; Y--
	CPY #$07
	BNE PRG053_AE25	; While Y > 7, loop

	LDA #SPRANM2_WILYESCAPEPOD
	JSR PRG063_SetSpriteAnim

	; Position Wily escape pod centered at boss
	LDA Spr_X+$17
	STA Spr_X+$00,X
	
	LDA #$00
	STA Spr_YVelFrac+$00,X
	LDA #$01
	STA Spr_YVel+$00,X
	
	JSR PRG053_BossExplosion

	LDA #LOW(PRG053_WilyEscapePod_PostExpl)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_WilyEscapePod_PostExpl)
	STA Spr_CodePtrH+$00,X
	

PRG053_WilyEscapePod_PostExpl:
	JSR PRG063_ApplyYVelocityNeg

	LDA Spr_YHi+$00,X
	BEQ PRG053_AE7B	; If not vertically off-screen, jump to PRG053_AE7B (RTS)

	LDA #LOW(PRG053_WilyEscapePod_OffScreen)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_WilyEscapePod_OffScreen)
	STA Spr_CodePtrH+$00,X
	

PRG053_WilyEscapePod_OffScreen:
	LDA <Player_State
	CMP #PLAYERSTATE_CLIMBING
	BGE PRG053_AE7B	; If Player is not in stand, jump/fall, or sliding states, jump to PRG053_AE7B (RTS)

	; Delete escape pod
	JSR PRG062_ResetSpriteSlot

	LDA #MUS_BOSSVICTORY
	JSR PRG063_QueueMusSnd_SetMus_Cur

	LDA #PLAYERSTATE_ENDLEVEL
	STA <Player_State
	
	LDA #$FF
	STA Level_EndLevel_Timeout
	
	JSR PRG063_DeletePlayerObjs


PRG053_AE7B:
	RTS	; $AE7B


PRG053_BossExplosion:
	LDA #MUS_STOPMUSIC
	JSR PRG063_QueueMusSnd_SetMus_Cur


PRG053_AE81:
	LDA #SFX_ROBOTDEATH
	JSR PRG063_QueueMusSnd

	STX <Temp_Var16	; Backup object slot index -> Temp_Var16
	
	; Temp_Var17 = $0F (explodey bit init index)
	LDA #$0F
	STA <Temp_Var17

PRG053_AE8C:
	JSR PRG063_FindFreeSlotMinIdx4
	BCS PRG053_AED9	; If no free object slot index, jump to PRG053_AED9

	; Explodey-out stuff!
	LDX #$17
	LDA #SPRANM4_ENEMYEXPLODE
	JSR PRG063_CopySprSlotSetAnim

	LDA #(SPRFL1_ONSCREEN | SPRFL1_SCREENREL)
	STA Spr_Flags+$00,Y
	
	LDA #SPRSLOTID_EXPLODEYBIT
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_Flags2+$00,Y
	
	LDX <Temp_Var17	; X = Temp_Var17 (explodey bit init index)
	
	LDA PRG053_EscapePod_XVelFrac,X
	STA Spr_XVelFrac+$00,Y
	LDA PRG053_EscapePod_XVel,X
	STA Spr_XVel+$00,Y
	
	LDA PRG053_EscapePod_YVelFrac,X
	STA Spr_YVelFrac+$00,Y
	LDA PRG053_EscapePod_YVel,X
	STA Spr_YVel+$00,Y
	
	LDA <TileMap_Index
	CMP #TMAP_WILY4
	BNE PRG053_AED5	; If this is the final level, jump to PRG053_AED5

	; 'Y' -> 'X'
	TYA
	TAX
	
	; Multiply X velocity by 2
	ASL Spr_XVelFrac+$00,X
	ROL Spr_XVel+$00,X
	
	; Multiply Y velocity by 2
	ASL Spr_YVelFrac+$00,X
	ROL Spr_YVel+$00,X

PRG053_AED5:
	DEC <Temp_Var17	; Temp_Var17--
	BPL PRG053_AE8C	; While Temp_Var17 >= 0, loop


PRG053_AED9:
	LDX <Temp_Var16	; Restore object slot index
	
	RTS	; $AEDB


PRG053_WM4_Var2:
	.byte $29, $29, $51
	
PRG053_WM4P2_FaceRemoveGBuf:
	vaddr $2A10
	.byte $09
	
	.byte $00, $00, $00, $6A, $6B, $6C, $6D, $0E, $09, $09
	
	vaddr $2A30
	.byte $09
	
	.byte $00, $00, $79, $7A, $7B, $7C, $7D, $1E, $1F, $19
	
	vaddr $2A50
	.byte $09
	
	.byte $00, $88, $89, $00, $00, $8C, $8D, $2E, $2F, $0F
	
	vaddr $2A70
	.byte $09
	
	.byte $00, $98, $99, $9A, $9B, $9C, $9D, $3E, $3F, $39
	
	vaddr $2A90
	.byte $09
	
	.byte $00, $A8, $A9, $AA, $AB, $AC, $AD, $4E, $48, $49
	
	vaddr $2AB0
	.byte $09
	
	.byte $00, $B8, $B9, $BA, $BB, $BC, $BD, $5E, $5F, $59
	
	vaddr $2AD0
	.byte $09
	
	.byte $00, $00, $C4, $C5, $C6, $C7, $C8, $C9, $CA, $CB
	
	vaddr $2AF0
	.byte $09
	
	.byte $00, $00, $D4, $D5, $D6, $D7, $D8, $D9, $DA, $DB

	; Actual graphics buffer terminator
	.byte $FF
	
	; Custom interstitial terminator
	.byte $80
	
	
	vaddr $2B10
	.byte $09
	
	.byte $00, $00, $CC, $CD, $CE, $CF, $AE, $AF, $8E, $8F
	
	vaddr $2B30
	.byte $09
	
	.byte $00, $00, $00, $DD, $DE, $DF, $BE, $BF, $9E, $9F
	
	vaddr $2B50
	.byte $07
	
	.byte $00, $00, $63, $73, $74, $83, $84, $93
	
	vaddr $2B70
	.byte $07
	
	.byte $00, $00, $00, $00, $00, $00, $B2, $B3
	
	vaddr $2BE4
	.byte $01
	
	.byte $AA, $AA
	
	vaddr $2BEC
	.byte $01
	
	.byte $FA, $7A
	
	vaddr $2BF4
	.byte $01
	
	.byte $FF, $F7
	
	; Actual graphics buffer terminator
	.byte $FF
	
	; Custom interstitial terminator
	.byte $80
	
PRG053_WM4P2_Var1:
	.byte $80, $60, $20, $40, $80, $60, $40, $80


	; CHECKME - UNUSED?
	.byte $94, $90	; $AF92 - $AF93



PRG053_EscapePod_XVelFrac:
	.byte $00, $0F, $80, $0F, $00, $F1, $80, $F1, $00, $87, $C0, $87, $00, $79, $40, $79	; $AF94 - $AFA3

PRG053_EscapePod_XVel:
	.byte $00, $01, $01, $01, $00, $FE, $FE, $FE, $00, $00, $00, $00, $00, $FF, $FF, $FF	; $AFA4 - $AFB3

PRG053_EscapePod_YVelFrac:
	.byte $80, $F1, $00, $0F, $80, $0F, $00, $F1, $40, $79, $00, $87, $C0, $87, $00, $79	; $AFB4 - $AFC3

PRG053_EscapePod_YVel:
	.byte $FE, $FE, $00, $01, $01, $01, $00, $FE, $FF, $FF, $00, $00, $00, $00, $00, $FF	; $AFC4 - $AFD3


PRG053_Obj_BossDeathCtl:
	LDY #$17	; Y = $17 (all object index)
PRG053_AFD6:
	CPY <SprObj_SlotIndex
	BEQ PRG053_AFDD	; If not self, jump to PRG053_AFDD

	JSR PRG063_DeleteObjectY	; Otherwise, delete whatever this i

PRG053_AFDD:
	DEY	; Y--
	CPY #$05
	BNE PRG053_AFD6	; While Y > 5, loop

	; Boss explosion!
	JSR PRG053_BossExplosion

	; Clear boss meter
	LDA #$00
	STA HUDBarB_DispSetting
	
	; Make sure no BG color is active (from Flash I assume)
	LDA PalData_2
	STA PalData_1+16
	LDA #$FF
	STA <CommitPal_Flag
	
	LDA <TileMap_Index
	CMP #TMAP_COSSACK1
	BLT PRG053_B042	; If this isn't post-stage select levels, jump to PRG053_B042

	; Assumed Wily Transport boss defeat

	; Also delete slot 5 object
	LDY #$05
	JSR PRG063_DeleteObjectY

	; Become a large health pickup
	LDA #SPRANM4_ITEM_LARGEHEALTH
	JSR PRG063_CopySprSlotSetAnim

	LDA #SPRSLOTID_ITEM_PICKUP_GRAVITY
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_Flags2+$00,Y
	
	; Reset for change
	JSR PRG062_ResetSpriteSlot

	; Setup a Wily Transporter blinking light
	LDA #SPRANM2_TRANSPBLINKER
	JSR PRG063_SetSpriteAnim

	LDA #(SPRFL1_ONSCREEN | SPRFL1_SCREENREL)
	STA Spr_Flags+$00,X
	
	; bounding box $1C
	LDA #$1C
	STA Spr_Flags2+$00,X
	
	LDA #SPRSLOTID_WILYTRANSPORTER
	STA Spr_SlotID+$00,X
	
	LDA #$20
	STA Spr_X+$00,X
	
	LDA #$B4
	STA Spr_Y+$00,X
	
	; Storing the source index for the transporter into the boss's former slot
	; just to make the call to PRG063_MarkNeverRespawn successfully!
	LDA WilyTrans_LastTransParentIdx
	STA Spr_SpawnParentIdx,X
	JSR PRG063_MarkNeverRespawn

	; Mark this as completed
	LDY <WilyTrans_CurPortal	
	LDA <LevelWily3_TransSysComp
	ORA PRG063_IndexToBit,Y
	STA <LevelWily3_TransSysComp

PRG053_B041:
	RTS	; $B041


PRG053_B042:
	; Robot master official stage finished

	LDA #$00
	JSR PRG063_SetSpriteAnim

	LDA #LOW(PRG053_BossDeathCtl_StartV)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_BossDeathCtl_StartV)
	STA Spr_CodePtrH+$00,X
	

PRG053_BossDeathCtl_StartV:
	LDA #PLAYERSTATE_ENDLEVEL
	CMP <Player_State
	BEQ PRG053_B093	; If Player is in end level state, jump to PRG053_B093

	LDY #$00
	STY <Player_FreezePlayerTicks
	
	LDA <Player_State
	CMP #PLAYERSTATE_CLIMBING
	BGE PRG053_B041	; If Player is not standing, jumping/falling, or sliding, jump to PRG053_B041 (RTS)

	; Checking if anything besides the boss death controller remains (mainly if the boss explosion has cleared etc.)
	LDY #$17	; Y = $17
PRG053_B063:
	LDA Spr_SlotID+$00,Y
	BEQ PRG053_B06C	; If empty slot, jump to PRG053_B06C

	CMP #SPRSLOTID_BOSSDEATH
	BNE PRG053_B041	; If there's something remaining that's not just the boss death controller, jump to PRG053_B041 (RTS)

PRG053_B06C:
	DEY			; Y--
	CPY #$04
	BNE PRG053_B063	; While Y > 4, loop

	LDA #MUS_BOSSVICTORY
	JSR PRG063_QueueMusSnd_SetMus_Cur

	LDA #PLAYERSTATE_ENDLEVEL
	STA <Player_State
	
	LDA #$FF
	STA Level_EndLevel_Timeout
	
	JSR PRG063_DeletePlayerObjs

	; Player face right
	LDA #SPRDIR_RIGHT
	STA Spr_FaceDir+$00
	
	LDA #$80
	CMP Spr_X+$00
	BGE PRG053_B093	; If Player is on the left, jump to PRG053_B093

	; Player face left
	LDA #SPRDIR_LEFT
	STA Spr_FaceDir+$00

PRG053_B093:
	LDA Spr_YVel+$00
	BPL PRG053_B0F3	; If Player is moving up, jump to PRG053_B0F3 (RTS)

	LDA #$80
	CMP Spr_X+$00
	BNE PRG053_B0F3	; If Player is not in the middle, jump to PRG053_B0F3 (RTS)

	LDA #$6C
	CMP Spr_Y+$00
	BNE PRG053_B0F3	; If Player is not vertically centered, jump to PRG053_B0F3 (RTS)

	; Temp_Var16 = 3
	LDA #$03
	STA <Temp_Var16

PRG053_B0AA:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG053_B0F0	; If no free object slot, jump to PRG053_B0F0

	LDA #$19	; $B0AF
	JSR PRG063_CopySprSlotSetAnim	; $B0B1

	LDA #$00
	STA Spr_Flags2+$00,Y
	STA Spr_HP+$00,Y
	
	; NOTE: This assignment doesn't make any sense, and it's overwritten just
	; after this anyway.
	LDA #SPRSLOTID_BOSSDEATH
	STA Spr_SlotID+$00,Y
	
	LDA #LOW(PRG053_Obj_PowerGainOrbs)
	STA Spr_CodePtrL+$00,Y
	LDA #HIGH(PRG053_Obj_PowerGainOrbs)
	STA Spr_CodePtrH+$00,Y
	
	; ... there we go
	LDA #SPRSLOTID_POWERGAIN_ORBS
	STA Spr_SlotID+$00,Y
	
	STX <Temp_Var0	; Backup object slot index -> Temp_Var0
	
	LDA <Temp_Var16	; Orb index
	ASL A	; x2
	TAX		; -> 'X'
	
	LDA PRG053_BossDefeatOrbs_YX,X
	STA Spr_Y+$00,Y
	
	LDA PRG053_BossDefeatOrbs_YX+1,X
	STA Spr_X+$00,Y
	
	LDX <Temp_Var16	; Orb index
	
	LDA PRG053_BossDefeatOrbs_Var1,X
	STA Spr_Var1+$00,Y
	
	LDX <Temp_Var0	; Restore object slot index
	
	DEC <Temp_Var16	; Temp_Var16-- (prev orb index)
	BPL PRG053_B0AA	; While Temp_Var16 >= 0, loop


PRG053_B0F0:
	JMP PRG062_ResetSpriteSlot


PRG053_B0F3:
	RTS	; $B0F3

PRG053_Obj_PowerGainOrbs:
PRG053_Obj_WilyCapShotCharge:
	LDY Spr_Var2+$00,X	; Y = Spr_Var2
	
	LDA Spr_Var1+$00,X
	AND #$01
	BNE PRG053_B10F	; 1:2 jump to PRG053_B10F

	LDA PRG053_Spiral_YXDelta,Y
	CMP #$80
	BEQ PRG053_B0F0	; If terminator, jump to PRG053_B0F0

	STA <Temp_Var0	; Y delta -> Temp_Var0
	
	LDA PRG053_Spiral_YXDelta+1,Y
	STA <Temp_Var1	; X delta -> Temp_Var1
	
	JMP PRG053_B11D		; Jump to PRG053_B11D


PRG053_B10F:
	LDA PRG053_Spiral_YXDelta2,Y
	CMP #$80
	BEQ PRG053_B0F0	; If terminator, jump to PRG053_B0F0

	STA <Temp_Var0	; Y delta -> Temp_Var0
	
	LDA PRG053_Spiral_YXDelta2+1,Y
	STA <Temp_Var1	; X delta -> Temp_Var1

PRG053_B11D:
	LDA Spr_Var1+$00,X
	CMP #$02
	BLT PRG053_B136	; If Spr_Var1 < 2, jump to PRG053_B136

	; Negate Temp_Var0
	LDA <Temp_Var0
	NEG
	STA <Temp_Var0
	
	; Negate Temp_Var1
	LDA <Temp_Var1
	NEG
	STA <Temp_Var1

PRG053_B136:
	
	; Apply Y delta
	LDA Spr_Y+$00,X
	ADD <Temp_Var0	
	STA Spr_Y+$00,X
	CMP #$F0
	BLT PRG053_B15A

	LDY <Temp_Var0
	BMI PRG053_B152

	ADC #$0F
	STA Spr_Y+$00,X
	
	INC Spr_YHi+$00,X
	
	JMP PRG053_B15A	; Jump to PRG053_B15A


PRG053_B152:
	SBC #$10
	STA Spr_Y+$00,X
	
	DEC Spr_YHi+$00,X

PRG053_B15A:
	; Temp_Var2 = $00 (16-bit sign extension)
	LDA #$00
	STA <Temp_Var2
	
	LDA <Temp_Var1
	BPL PRG053_B164

	; Temp_Var2 = $FF (16-bit sign extension)
	DEC <Temp_Var2	

PRG053_B164:

	; Apply X delta
	LDA Spr_X+$00,X
	ADD <Temp_Var1	
	STA Spr_X+$00,X
	LDA Spr_XHi+$00,X
	ADC <Temp_Var2
	STA Spr_XHi+$00,X
	
	; Spr_Var2 += 2 (next delta)
	INC Spr_Var2+$00,X
	INC Spr_Var2+$00,X
	
	RTS	; $B17B


	; Position of the 4 boss defeat orbs
PRG053_BossDefeatOrbs_YX:
	.byte $38, $48
	.byte $38, $B8
	.byte $A8, $48
	.byte $A8, $B8
	
	; Respective boss defeat orbs Var1 init values
PRG053_BossDefeatOrbs_Var1:
	.byte $00, $01, $03, $02

PRG053_Spiral_YXDelta:
	.byte $00, $08
	.byte $00, $08
	.byte $00, $08
	.byte $00, $08
	.byte $00, $08
	.byte $00, $08
	.byte $00, $08
	.byte $00, $08
	.byte $02, $08
	.byte $04, $0A
	.byte $06, $08
	.byte $06, $08
	.byte $06, $04
	.byte $08, $04
	.byte $08, $04
	.byte $08, $02
	.byte $08, $00
	.byte $08, $00
	.byte $08, $FE
	.byte $08, $FC
	.byte $08, $FC
	.byte $08, $FA
	.byte $06, $F8
	.byte $04, $F8
	.byte $04, $F8
	.byte $02, $F8
	.byte $FE, $F6
	.byte $FC, $F8
	.byte $FA, $F8
	.byte $FA, $FA
	.byte $FA, $F8
	.byte $F8, $FA
	.byte $F8, $FC
	.byte $F8, $FE
	.byte $F8, $00
	.byte $F8, $00
	.byte $F8, $02
	.byte $F8, $04
	.byte $FA, $06
	.byte $FA, $06
	.byte $FC, $08
	.byte $FE, $08
	.byte $00, $08
	.byte $02, $08
	.byte $06, $06
	.byte $04, $06
	.byte $06, $06
	.byte $08, $06
	.byte $0A, $04
	.byte $08, $00
	.byte $08, $00
	.byte $08, $FC
	.byte $0A, $F8
	.byte $04, $F8
	.byte $04, $F8
	.byte $00, $FA
	.byte $FC, $F8
	.byte $F8, $F8
	.byte $FA, $FC
	.byte $F8, $FE
	.byte $F6, $FE
	.byte $F8, $02
	.byte $F8, $04
	.byte $FA, $08
	.byte $FE, $08
	.byte $02, $08
	.byte $04, $06
	.byte $08, $04
	.byte $0A, $FE
	
	; Terminator
	.byte $80
	
PRG053_Spiral_YXDelta2:
	.byte $08, $00
	.byte $08, $00
	.byte $08, $00
	.byte $08, $00
	.byte $08, $00
	.byte $08, $00
	.byte $08, $00
	.byte $08, $00
	.byte $08, $FE
	.byte $0A, $FC
	.byte $08, $FA
	.byte $08, $FA
	.byte $04, $FA
	.byte $04, $F8
	.byte $04, $F8
	.byte $02, $F8
	.byte $00, $F8
	.byte $00, $F8
	.byte $FE, $F8
	.byte $FC, $F8
	.byte $FC, $F8
	.byte $FA, $F8
	.byte $F8, $FA
	.byte $F8, $FC
	.byte $F8, $FC
	.byte $F8, $FE
	.byte $F6, $02
	.byte $F8, $04
	.byte $F8, $06
	.byte $FA, $06
	.byte $F8, $06
	.byte $FA, $08
	.byte $FC, $08
	.byte $FE, $08
	.byte $00, $08
	.byte $00, $08
	.byte $02, $08
	.byte $04, $08
	.byte $06, $06
	.byte $06, $06
	.byte $08, $04
	.byte $08, $02
	.byte $08, $00
	.byte $08, $FE
	.byte $06, $FA
	.byte $06, $FC
	.byte $06, $FA
	.byte $06, $F8
	.byte $04, $F6
	.byte $00, $F8
	.byte $00, $F8
	.byte $FC, $F8
	.byte $F8, $F6
	.byte $F8, $FC
	.byte $F8, $FC
	.byte $FA, $00
	.byte $F8, $04
	.byte $F8, $08
	.byte $FC, $06
	.byte $FE, $08
	.byte $FE, $0A
	.byte $02, $08
	.byte $04, $08
	.byte $08, $06
	.byte $08, $02
	.byte $08, $FE
	.byte $06, $FC
	.byte $04, $F8
	.byte $FE, $F6
	
	; Terminator
	.byte $80


PRG053_Obj_Cossack3Boss1Die:
	LDA #SFX_ROBOTDEATH
	JSR PRG063_QueueMusSnd

	JSR PRG053_AE81

	JSR PRG062_ResetSpriteSlot

	LDA #$00
	STA Spr_Var1+$00,X
	STA Spr_Var2+$00,X
	STA Spr_Var3+$00,X
	STA Spr_Var4+$00,X
	STA <General_Counter
	
	; Spr_Var5 = $1E
	LDA #$1E
	STA Spr_Var5+$00,X
	
	; Spr_Var6 = $23
	LDA #$23
	STA Spr_Var6+$00,X
	
	LDA #SPRSLOTID_COSSACK3BOSS2
	STA Spr_SlotID+$00,X
	
	LDA #$18
	STA Spr_X+$00,X
	LDA #$11
	STA Spr_XHi+$00,X
	
	LDA #$C0
	STA Spr_Y+$00,X
	
	; HP = $0E
	LDA #$0E
	STA Spr_HP+$00,X
	
	LDA #SPRDIR_LEFT
	STA Spr_FaceDir+$00,X
	
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $14)
	STA Spr_Flags2+$00,X
	
	LDA #SPRANM3_CRTWIN_WALK_FLOOR
	JMP PRG063_SetSpriteAnim


PRG053_Obj_Cossack3Boss2Die:
	JSR PRG053_BossExplosion

	LDA #$00
	JSR PRG063_SetSpriteAnim

	LDA #LOW(PRG053_Cossack3Boss2Die_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_Cossack3Boss2Die_Cont)
	STA Spr_CodePtrH+$00,X
	
PRG053_Cossack3Boss2Die_Cont:

	LDY #$16	; Y = $16
PRG053_B2FF:
	LDA Spr_SlotID+$00,Y
	BNE PRG053_B32B	; If not empty, jump to PRG053_B32B (RTS)

	DEY	; Y-
	CPY #$04
	BNE PRG053_B2FF	; While Y > 4, loop

	LDA #LOW(PRG053_Cossack3Boss2Die_Done)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_Cossack3Boss2Die_Done)
	STA Spr_CodePtrH+$00,X
	
PRG053_Cossack3Boss2Die_Done:
	LDA <Player_State
	BNE PRG053_B32B	; If Player is not standing, jump to PRG053_B32B (RTS)

	JSR PRG062_ResetSpriteSlot

	LDA #MUS_BOSSVICTORY
	JSR PRG063_QueueMusSnd_SetMus_Cur

	LDA #PLAYERSTATE_ENDLEVEL
	STA <Player_State
	
	LDA #$FF
	STA Level_EndLevel_Timeout
	
	JSR PRG063_DeletePlayerObjs

PRG053_B32B:
	RTS	; $B32B


PRG053_Obj_CRPlatFall:
	LDA Spr_X+$00
	CMP #$40
	BNE PRG053_B382	; If Player isn't at X = $40, jump to PRG053_B382 (RTS)

	LDY #(PRG053_CRPlat_RemShadow_End - PRG053_CRPlat_RemShadow - 1)
PRG053_B335:
	LDA PRG053_CRPlat_RemShadow,Y
	STA Graphics_Buffer+$00,Y
	
	DEY	; Y--
	BPL PRG053_B335	; While Y >= 0, loop

	STY <CommitGBuf_Flag	; Commit graphics buffer
	
	LDA #LOW(PRG053_B354)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_B354)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var1 = $1F
	LDA #$1F
	STA Spr_Var1+$00,X
	
	; Platform wiggling
	LDA #SPRANM2_COCKROACHPLAT_WIGL
	JSR PRG063_SetSpriteAnim

PRG053_B354:
	LDA Spr_Var1+$00,X
	BEQ PRG053_B363	; If Spr_Var1 = 0, jump to PRG053_B363

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG053_B382	; If Spr_Var1 > 0, jump to PRG053_B382

	; Platform falling
	LDA #SPRANM2_COCKROACHPLAT_FALL
	JSR PRG063_SetSpriteAnim


PRG053_B363:
	JSR PRG063_DoMoveSimpleVert

	LDA Spr_Y+$00,X
	CMP #$D0
	BLT PRG053_B382	; If not low enough, jump to PRG053_B382 (RTS)

	JSR PRG062_ResetSpriteSlot

	LDA #SPRANM4_SMALLPOOFEXP
	JSR PRG063_SetSpriteAnim

	LDA #SPRSLOTID_MISCSTUFF
	STA Spr_SlotID+$00,X
	
	LDA Spr_Flags+$00,X
	AND #~SPRFL1_NODRAW
	STA Spr_Flags+$00,X

PRG053_B382:
	RTS	; $B382


PRG053_Obj_SinkingPlatform:
	JSR PRG063_CalcObjXDiffFromPlayer
	CMP #$60
	BGE PRG053_B382	; If X diff >= $60, PRG053_B382 (RTS)

	LDA Spr_Flags+$00,X
	AND #~SPRFL1_NODRAW
	STA Spr_Flags+$00,X
	
	LDA #LOW(PRG053_Obj_SinkingPlatform_C)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_Obj_SinkingPlatform_C)
	STA Spr_CodePtrH+$00,X
	
PRG053_Obj_SinkingPlatform_C:
	LDA Spr_Frame+$00,X
	CMP #$0B
	BNE PRG053_B382	; If frame <> $0B, jump to PRG053_B382 (RTS)

	LDA #$00
	STA Spr_AnimTicks+$00,X
	JSR PRG053_SinkingPlat_DetPlayer

	BCS PRG053_B382	; If Player didn't collide, jump to PRG053_B382 (RTS)

	LDA #LOW(PRG053_Obj_SinkingPlatform_S)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_Obj_SinkingPlatform_S)
	STA Spr_CodePtrH+$00,X

PRG053_Obj_SinkingPlatform_S:
	LDA #$00
	STA Spr_AnimTicks+$00,X
	JSR PRG053_SinkingPlat_DetPlayer

	BCS PRG053_B3CF	; If Player didn't collide, jump to PRG053_B3CF

	; Sink speed
	LDA #$80
	STA Spr_YVelFrac+$00,X
	LDA #$00
	STA Spr_YVel+$00,X
	
	LDA #SPRDIR_DOWN
	BNE PRG053_B3DB	; Jump (technically always) to PRG053_B3DB


PRG053_B3CF:
	; Raise speed
	LDA #$80
	STA Spr_YVelFrac+$00,X
	LDA #$01
	STA Spr_YVel+$00,X
	
	LDA #SPRDIR_UP

PRG053_B3DB:
	STA Spr_FaceDir+$00,X
	
	JMP PRG063_DoMoveVertOnlyH16


PRG053_SinkingPlat_DetPlayer:
	; Save Spr_Y
	LDA Spr_Y+$00,X
	PHA
	
	DEC Spr_Y+$00,X		; Spr_Y--
	
	; Save Spr_CurrentAnim
	LDA Spr_CurrentAnim+$00
	PHA
	
	LDA #SPRANM2_PLAYERSTAND
	STA Spr_CurrentAnim+$00
	JSR PRG063_TestPlayerObjCollide

	; Restore Spr_CurrentAnim
	PLA
	STA Spr_CurrentAnim+$00
	
	; Restore Spr_Y
	PLA
	STA Spr_Y+$00,X
	
	RTS	; $B3FC

PRG053_Obj_Wily1_DisappearBlks:
	INC Spr_Var1+$00,X	; Spr_Var1++
	
	LDA Spr_Var1+$00,X
	CMP #$B4
	BNE PRG053_B47F	; If Spr_Var1 <> $B4, jump to PRG053_B47F (RTS)

	LDA #LOW(PRG053_Wily1DBlks_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_Wily1DBlks_Cont)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var1 = 0
	LDA #$00
	STA Spr_Var1+$00,X
	
	LDA Spr_XHi+$00,X
	SUB #$0D
	TAY	; Y = relative screen
	
	; Spr_Var2 is the base index for the disappearing/reappearing block data
	LDA PRG053_Wily1DBlks_Var2,Y
	STA Spr_Var2+$00,X
	

PRG053_Wily1DBlks_Cont:
	LDA Spr_Var1+$00,X
	BNE PRG053_B47C	; If Spr_Var1 > 0, jump to PRG053_B47C


PRG053_B428:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG053_B47F	; If no free object slot index, jump to PRG053_B47F (RTS)

	LDA #SFX_DISAPPEARINGBLOCK
	JSR PRG063_QueueMusSnd

	LDA #SPRANM1_DISAPPEARINGBLOCK
	JSR PRG063_CopySprSlotSetAnim

	LDA #SPRSLOTID_CINESTUFF
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_Flags2+$00,Y
	
	LDA #(SPRFL1_ONSCREEN | SPRFL1_SCREENREL | SPRFL1_OBJSOLID)
	STA Spr_Flags+$00,Y
	
	STX <Temp_Var0	; Backup object slot index -> Temp_Var0
	
	LDA Spr_Var2+$00,X
	TAX	; X = Spr_Var2 (disappearing/reappearing block set index)
	
	LDA PRG053_Wily1DBlks_BlkData,X
	STA Spr_Y+$00,Y
	
	LDA PRG053_Wily1DBlks_BlkData+1,X
	STA Spr_X+$00,Y
	
	LDA PRG053_Wily1DBlks_BlkData+2,X
	STA <Temp_Var1
	
	LDX <Temp_Var0	; Restore object slot index
	
	; Spr_Var2 += 3
	INC Spr_Var2+$00,X
	INC Spr_Var2+$00,X
	INC Spr_Var2+$00,X
	
	LDA <Temp_Var1
	BEQ PRG053_B477	; If Temp_Var1 = 0, jump to PRG053_B477
	BPL PRG053_B428	; If Temp_Var1 > 0, jump to PRG053_B428 (spawn another block)

	; Temp_Var1 < 0... (jump index)

	LDY Spr_Var2+$00,X	; Y = Spr_Var2 (current block index)
	
	; Fetch jump-to index -> Spr_Var2 (block pattern reset)
	LDA PRG053_Wily1DBlks_BlkData,Y
	STA Spr_Var2+$00,X

PRG053_B477:
	; Spr_Var1 = $3D
	LDA #$3D
	STA Spr_Var1+$00,X

PRG053_B47C:
	DEC Spr_Var1+$00,X	; Spr_Var1--

PRG053_B47F:
	RTS	; $B47F


PRG053_CRPlat_RemShadow:
	vaddr $2202
	.byte $03
	
	.byte $6E, $6F, $6E, $6F
	
	vaddr $2222
	.byte $03
	
	.byte $7E, $7F, $7E, $7F
	
	vaddr $2242
	.byte $03
	
	.byte $6E, $6F, $6E, $6F
	
	vaddr $2262
	.byte $03
	
	.byte $7E, $7F, $7E, $7F
	
	vaddr $221A
	.byte $03
	
	.byte $6E, $6F, $6E, $6F
	
	vaddr $223A
	.byte $03
	
	.byte $7E, $7F, $7E, $7F
	
	vaddr $225A
	.byte $03
	
	.byte $6E, $6F, $6E, $6F
	
	vaddr $226A
	.byte $03
	
	.byte $7E, $7F, $7E, $7F
	
	vaddr $23E0
	.byte $01
	
	.byte $00, $00
	
	vaddr $23E6
	.byte $01
	
	.byte $00, $00
	
	.byte $FF
PRG053_CRPlat_RemShadow_End

PRG053_Wily1DBlks_Var2:
	.byte (PRG053_Wily1DBlks_BlkData0 - PRG053_Wily1DBlks_BlkData), (PRG053_Wily1DBlks_BlkData1 - PRG053_Wily1DBlks_BlkData)

PRG053_Wily1DBlks_BlkData:
	
	;      Y*   X    V1		NOTE V1: This can also be a "jump to index" flag if $FF, and the following "Y" becomes the index to return to
PRG053_Wily1DBlks_BlkData0:
	.byte $88, $B8, $00		; 0
	.byte $58, $B8, $00		; 1
	.byte $78, $88, $00		; 2
	.byte $88, $58, $00		; 3
	.byte $68, $28, $FF		; 4 (V1 = $FF, next value is jump index)
	.byte (PRG053_Wily1DBlks_BlkData0 - PRG053_Wily1DBlks_BlkData)	; return index
	
PRG053_Wily1DBlks_BlkData1:
	.byte $98, $38, $01		; 0
	.byte $B8, $98, $00		; 1
	.byte $B8, $68, $00		; 2
	.byte $88, $68, $00		; 3
	.byte $78, $98, $00		; 4
	.byte $88, $C8, $00		; 5
	.byte $58, $C8, $FF		; 6 (V1 = $FF, next value is jump index)
	.byte (PRG053_Wily1DBlks_BlkData1 - PRG053_Wily1DBlks_BlkData)	; return index


PRG053_Obj_BossWilyCapsule:
	JSR PRG063_InitBossMus_Plyr_RetX

	CMP #PLAYERSTATE_BOSSWAIT
	BNE PRG053_B528	; If Player is not in boss wait state, jump to PRG053_B528 (RTS)

	LDA #$00
	STA <General_Counter
	STA <Boss_HP
	
	; Show boss meter
	LDA #$8F
	STA HUDBarB_DispSetting
	
	LDA #LOW(PRG053_BossWilyCapsule_FillHP)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_BossWilyCapsule_FillHP)
	STA Spr_CodePtrH+$00,X
	

PRG053_BossWilyCapsule_FillHP:
	LDA <General_Counter
	AND #$07
	BNE PRG053_B528	; 7:8 jump to PRG053_B528 (RTS)

	LDA #SFX_ENERGYGAIN
	JSR PRG063_QueueMusSnd

	INC <Boss_HP	; Boss_HP++
	
	LDA <Boss_HP
	CMP #$1C
	BNE PRG053_B528	; If not fully charged, jump to PRG053_B528 (RTS)

	LDA #LOW(PRG053_BossWilyCapsule_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_BossWilyCapsule_Cont)
	STA Spr_CodePtrH+$00,X
	
	LDA #PLAYERSTATE_STAND
	STA <Player_State

PRG053_B528:
	RTS	; $B528


PRG053_BossWilyCapsule_Cont:
	LDA <RandomN+$00
	ADC <RandomN+$01
	STA <RandomN+$00
	AND #$0F
	TAY	; Y = $0 to $F
	
	LDA PRG053_WilyCapsule_PosSel,Y
	ASL A	; x2
	TAY		; -> Y
	
	LDA PRG053_WilyCapsule_Pos,Y
	STA Spr_Y+$00,X
	
	LDA PRG053_WilyCapsule_Pos+1,Y
	STA Spr_X+$00,X
	
	LDA <RandomN+$00
	ADC <RandomN+$02
	STA <RandomN+$01
	AND #$07
	TAY	; Y = 0 to 7
	
	LDA PRG053_WilyCapsuleShot_PosSel,Y
	ASL A			; x2
	STA <Temp_Var16	; -> Temp_Var16
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG053_B528	; If no free object slot, jump to PRG053_B528 (RTS)

	LDA #SPRANM1_WILYCAPSULE_SHOT
	JSR PRG063_CopySprSlotSetAnim

	LDA #(SPRFL1_ONSCREEN | SPRFL1_SCREENREL | SPRFL1_NODRAW)
	STA Spr_Flags+$00,Y
	
	LDA #SPRSLOTID_WILYCAPSULE_SHOT
	STA Spr_SlotID+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | $0D)
	STA Spr_Flags2+$00,Y
	
	STX <Temp_Var0	; Backup object slot index -> Temp_Var0
	
	LDX <Temp_Var16	; X = Temp_Var16 (position select index)
	
	LDA PRG053_WilyCapsuleShot_Pos,X
	STA Spr_Y+$00,Y
	
	LDA PRG053_WilyCapsuleShot_Pos+1,X
	STA Spr_X+$00,Y
	
	LDX <Temp_Var0	; Restore object slot index
	
	; Temp_Var17 = 3 (4 spinning orbs)
	LDA #$03
	STA <Temp_Var17
	
	LDA <Temp_Var16
	ASL A		; x2 (x4) (From when Temp_Var16 stored a doubled value for the position select)
	ASL A		; x4 (x8)
	ASL A		; x8 (x16)
	STA <Temp_Var18	; -> Temp_Var18 (orb spawn index)

PRG053_B588:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG053_B5EE	; If no free object slot index, jump to PRG053_B5EE (RTS)

	LDA #SPRANM1_WILYCAPSULE_SHOTCH
	JSR PRG063_CopySprSlotSetAnim

	LDA #SPRSLOTID_WILYCAPSULE_CHRG
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_Flags2+$00,Y
	
	STX <Temp_Var0	; Backup object slot index -> Temp_Var0
	
	LDX <Temp_Var18	; X = orb spawn index
	
	LDA PRG053_WilyCapsuleShotOrb_Data,X
	STA Spr_YHi+$00,Y
	
	LDA PRG053_WilyCapsuleShotOrb_Data+1,X
	STA Spr_Y+$00,Y
	
	LDA PRG053_WilyCapsuleShotOrb_Data+2,X
	STA Spr_XHi+$00,Y
	
	LDA PRG053_WilyCapsuleShotOrb_Data+3,X
	STA Spr_X+$00,Y
	
	LDX <Temp_Var17	; X = current orb index
	
	LDA PRG053_WilyCapsuleShotOrb_Var1,X
	STA Spr_Var1+$00,Y
	
	LDX <Temp_Var0	; Restore object slot index
	
	; Temp_Var18 += 4 (orb index)
	INC <Temp_Var18
	INC <Temp_Var18
	INC <Temp_Var18
	INC <Temp_Var18
	
	DEC <Temp_Var17	; Temp_Var17--
	BPL PRG053_B588	; While Temp_Var17 >= 0 (more orbs to spawn), loop!

	LDA #LOW(PRG053_BossWilyCap_ShotFired)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_BossWilyCap_ShotFired)
	STA Spr_CodePtrH+$00,X
	
	LDA <RandomN+$00
	AND #$01
	TAY	; Y = 0 to 1
	
	LDA PRG053_WilyCap_Var1,Y
	STA Spr_Var1+$00,X
	
	LDA <RandomN+$01
	AND #$01
	TAY	; Y = 0 to 1
	
	LDA PRG053_WilyCap_Var2,Y
	STA Spr_Var2+$00,X

PRG053_B5EE:
	RTS	; $B5EE


PRG053_BossWilyCap_ShotFired:
	LDA Spr_Var1+$00,X
	BEQ PRG053_B605	; If Spr_Var1 = 0, jump to PRG053_B605

	LDA Spr_Flags+$00,X
	AND #SPRFL1_NODRAW
	BNE PRG053_B614	; If Wily is invisible, jump to PRG053_B614 (RTS)

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG053_B614	; If Spr_Var1 > 0, jump to PRG053_B614 (RTS)

	LDA #(SPRFL1_ONSCREEN | SPRFL1_SCREENREL | SPRFL1_NODRAW)
	STA Spr_Flags+$00,X

PRG053_B605:
	DEC Spr_Var2+$00,X	; Spr_Var2--
	BNE PRG053_B614	; If Spr_Var2 > 0, jump to PRG053_B614 (RTS)

	LDA #LOW(PRG053_BossWilyCapsule_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_BossWilyCapsule_Cont)
	STA Spr_CodePtrH+$00,X

PRG053_B614:
	RTS	; $B614


PRG053_Obj_WilyCapsule_Shot:
	
	LDY #$16
PRG053_B617:
	CPY <SprObj_SlotIndex	; $B617
	BEQ PRG053_B620	; $B619

	LDA Spr_SlotID+$00,Y
	BNE PRG053_B614	; If not empty, jump to PRG053_B614 (RTS)


PRG053_B620:
	DEY			; Y--
	CPY #$07
	BNE PRG053_B617	; While Y > 7, loop

	LDA #(SPRFL1_ONSCREEN | SPRFL1_SCREENREL)
	STA Spr_Flags+$00,X
	
	; Speed magnitude
	LDA #$00
	STA <Temp_Var2
	LDA #$04
	STA <Temp_Var3
	
	JSR PRG063_AimPlayer_Var23Spd

	; Aim direction
	LDA <Temp_Var12
	STA Spr_FaceDir+$00,X
	
	LDA #LOW(PRG053_WilyCapsuleShot_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_WilyCapsuleShot_Cont)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var1 = $15
	LDA #$15
	STA Spr_Var1+$00,X
	
	; Bright white flash
	LDA #$20
	STA PalData_1+16
	LDA #$FF
	STA <CommitPal_Flag
	
	LDY #$17	; Y = $17 (Wily's index)
	
	LDA #SPRANM1_WILYCAPSULE_WILY
	JSR PRG063_SetSpriteAnimY

	; Wily Capsule must not be flashing!
	LDA #$00
	STA Spr_FlashOrPauseCnt,Y
	
	; Wily Capsule visible!
	LDA #$90
	STA Spr_Flags+$17
	BNE PRG053_B66E	; Jump (technically always) to PRG053_B66E


PRG053_WilyCapsuleShot_Cont:
	; Clear white flash
	LDA #$0F
	STA PalData_1+16
	LDA #$FF
	STA <CommitPal_Flag

PRG053_B66E:
	LDA Spr_Var1+$00,X
	BEQ PRG053_B683	; If Spr_Var1 = 0, jump to PRG053_B683

	CMP #$10
	BNE PRG053_B67E	; If Spr_Var1 <> $10, jump to PRG053_B67E

	LDY #$17	; Y = $17 (Wily's index)
	LDA #SPRANM1_WILYCAPSULE_VANISH
	JSR PRG063_SetSpriteAnimY


PRG053_B67E:
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG053_B696	; If Spr_Var1 > 0, jump to PRG053_B696 (RTS)


PRG053_B683:
	JSR PRG063_ApplyVelSetFaceDir
	JSR PRG063_DoMoveVertOnlyH16

	LDA #(SPRFL1_ONSCREEN | SPRFL1_SCREENREL)
	STA Spr_Flags+$00,X
	
	LDA Spr_YHi+$00,X
	BEQ PRG053_B696	; If not off-screen, jump to PRG053_B696 (RTS)

	; Erase capsule shot
	JSR PRG062_ResetSpriteSlot

PRG053_B696:
	RTS	; $B696

PRG053_Obj_WilyCapsuleDie:
	LDA #$00
	STA Spr_Flags2+$00,X
	
	JSR PRG053_BossExplosion

	LDA #SPRANM1_WILYCAPSULE_WILYE
	JSR PRG063_SetSpriteAnim

	LDA #LOW(PRG053_WilyCapsuleDie_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_WilyCapsuleDie_Cont)
	STA Spr_CodePtrH+$00,X
	
	LDA #$00
	STA Spr_YVelFrac+$00,X
	LDA #$04
	STA Spr_YVel+$00,X
	
	LDA #(SPRFL1_ONSCREEN | SPRFL1_SCREENREL)
	STA Spr_Flags+$00,X
	
PRG053_WilyCapsuleDie_Cont:
	JSR PRG063_ApplyYVelocityNeg

	LDA Spr_YHi+$00,X
	BEQ PRG053_B696	; If not vertically off-screen, jump to PRG053_B696 (RTS)

	LDA #LOW(PRG053_WilyCapsuleDie_WaitExp)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_WilyCapsuleDie_WaitExp)
	STA Spr_CodePtrH+$00,X
	
	; Load screen $07 into "other" side of BG
	LDA #$80
	STA <CommitBG_Flag
	LDA #$07
	STA <CommitBG_ScrSel
	

PRG053_WilyCapsuleDie_WaitExp:
	LDA <CommitBG_Flag
	BNE PRG053_B696	; If still committing, jump to PRG053_B696 (RTS)

	LDY #$16	; Y = $16
PRG053_B6DD:
	LDA Spr_SlotID+$00,Y
	BNE PRG053_B696	; If not empty, jump to PRG053_B696 (RTS)

	DEY	; Y--
	CPY #$04
	BNE PRG053_B6DD	; While Y > 4, loop

	LDA <Player_State
	CMP #PLAYERSTATE_CLIMBING
	BGE PRG053_B696	; If Player is not standing, jumping/falling, or sliding, jump to PRG053_B696 (RTS)

	LDA #SPRDIR_RIGHT
	STA Spr_FaceDir+$00
	
	LDA Spr_X+$00
	CMP #$3C
	BLT PRG053_B6FE	; If Player is left of $3C, jump to PRG053_B6FE

	LDA #SPRDIR_LEFT
	STA Spr_FaceDir+$00

PRG053_B6FE:
	LDA #PLAYERSTATE_POSTWILY
	STA <Player_State
	JSR PRG063_DeletePlayerObjs

	LDA #LOW(PRG053_WilyCapsuleDie_FadeIn)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_WilyCapsuleDie_FadeIn)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var1 = $30 (fade level)
	LDA #$30
	STA Spr_Var1+$00,X
	
	LDA #$00
	STA <General_Counter
	
	; Clear ALL meters
	STA HUDBarP_DispSetting
	STA HUDBarW_DispSetting
	STA HUDBarB_DispSetting
	
PRG053_WilyCapsuleDie_FadeIn:
	LDA Spr_X+$00
	CMP #$3C
	BNE PRG053_B755	; If Player isn't in place, jump to PRG053_B755 (RTS)

	LDA <General_Counter
	AND #$0F
	BNE PRG053_B755	; 15:16 jump to PRG053_B755 (RTS)

	LDY #$0F	; Y = $0F
PRG053_B730:
	LDA PRG053_WilyCapDie_FadeInPal,Y
	SUB Spr_Var1+$00,X	; Fade level
	BCS PRG053_B73B	; If didn't underflow, jump to PRG053_B73B

	LDA #$0F	; A = $0F (min fade level)

PRG053_B73B:
	STA PalData_1,Y
	STA PalData_2,Y
	
	DEY	; Y--
	BPL PRG053_B730	; While Y >= 0, loop

	STY <CommitPal_Flag	; Commit palette
	
	LDA #$02
	STA <PPU_CTL1_PageBaseReq
	
	; Fade level reduced
	LDA Spr_Var1+$00,X
	SUB #$10
	STA Spr_Var1+$00,X
	
	BCC PRG053_B756	; If fade complete, jump to PRG053_B756

PRG053_B755:
	RTS	; $B755


PRG053_B756:
	LDA #LOW(PRG053_WilyCapsuleDie_InitMus)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_WilyCapsuleDie_InitMus)
	STA Spr_CodePtrH+$00,X
	
	; Wily's final X position
	LDA #$C0
	STA Spr_X+$00,X
	
	LDA #$00
	STA Spr_Y+$00,X
	STA Spr_YHi+$00,X
	STA Spr_YVelFrac+$00,X
	STA Spr_YVel+$00,X
	
	STA PalAnim_CurAnimOffset+$00	; $B773
	STA PalAnim_TickCount+$00	; $B776
	LDA #$AD	; $B779
	STA PalAnim_EnSel+$00	; $B77B
	
	STX <Temp_Var16	; Backup object slot index -> Temp_Var16
	
	
	; Put the blinking light things in the background
	
	; Temp_Var17 = 4 (blinking light index)
	LDA #$04
	STA <Temp_Var17

PRG053_B784:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG053_B7AC	; If no free object slot, jump to PRG053_B7AC

	LDX #$17
	LDA #SPRANM1_WILYFINAL_BLINKIN
	JSR PRG063_CopySprSlotSetAnim

	LDA #SPRSLOTID_CINESTUFF
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_Flags2+$00,Y
	
	LDX <Temp_Var17	; X = blinking light index
	
	LDA PRG053_WilyBlinkLight_Y,X
	STA Spr_Y+$00,Y
	
	LDA PRG053_WilyBlinkLight_X,X
	STA Spr_X+$00,Y
	
	DEC <Temp_Var17	; Temp_Var17--
	BPL PRG053_B784	; While Temp_Var17 >= 0, loop


PRG053_B7AC:
	LDX <Temp_Var16	; Restore object slot index

PRG053_B7AE:
	RTS	; $B7AE


PRG053_WilyCapsuleDie_InitMus:
	LDY #$00
	JSR PRG063_DoObjVertMovement

	BCC PRG053_B7AE	; If Wily hasn't hit floor, jump to PRG053_B7AE (RTS)

	LDA #SPRANM1_WILYCAPSULE_BEG
	CMP Spr_CurrentAnim+$00,X
	BEQ PRG053_B7AE	; If Wily is already doing begging animation, jump to PRG053_B7AE (RTS)

	JSR PRG063_SetSpriteAnim	; Set begging animation

	LDA #MUS_FINALVICTORY
	JSR PRG063_QueueMusSnd_SetMus_Cur

	; Spr_Var1 = 0
	LDA #$00
	STA Spr_Var1+$00,X
	
	LDA #LOW(PRG053_WilyCapsuleDie_Timeout)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_WilyCapsuleDie_Timeout)
	STA Spr_CodePtrH+$00,X
	
	RTS	; $B7D4


PRG053_WilyCapsuleDie_Timeout:
	LDA <General_Counter
	AND #$01
	BNE PRG053_B7AE	; 1:2 jump to PRG053_B7AE (RTS)

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG053_B7AE	; If Spr_Var1 > 0, jump to PRG053_B7AE (RTS)

	LDA #LOW(PRG053_WilyCapsuleDie_EscInit)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_WilyCapsuleDie_EscInit)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var1 = $3C
	LDA #$3C
	STA Spr_Var1+$00,X
	
	LDA #$00
	STA Spr_Frame+$00,X
	STA Spr_AnimTicks+$00,X
	
	RTS	; $B7F7


PRG053_WilyCapsuleDie_EscInit:
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG053_B7AE	; If Spr_Var1 > 0, jump to PRG053_B7AE (RTS)

	LDA #SPRANM1_WILYCAPSULE_ESCAPE
	JSR PRG063_SetSpriteAnim

	LDA #LOW(PRG053_WilyCapsuleDie_EscWait)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_WilyCapsuleDie_EscWait)
	STA Spr_CodePtrH+$00,X
	

PRG053_WilyCapsuleDie_EscWait:
	LDA Spr_Frame+$00,X
	CMP #$0C
	BNE PRG053_B7AE	; If frame <> $C, jump to PRG053_B7AE (RTS)

	LDA #$00
	JSR PRG063_SetSpriteAnim

	LDA #LOW(PRG053_WilyCapsuleDie_EscIWarn)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_WilyCapsuleDie_EscIWarn)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var1 = $3C
	LDA #$3C
	STA Spr_Var1+$00,X
	
	RTS	; $B82C


PRG053_WilyCapsuleDie_EscIWarn:
	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM1_WILYCAPSULE_DANGER
	BEQ PRG053_B88F	; If already doing the DANGER sign, jump to PRG053_B88F (RTS)

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG053_B88F	; If Spr_Var1 > 0, jump to PRG053_B88F (RTS)

	LDA #SPRANM1_WILYCAPSULE_DANGER
	JSR PRG063_SetSpriteAnim

	; Reposition for the DANGER sign
	LDA #$80
	STA Spr_X+$00,X
	
	LDA #$27
	STA Spr_Y+$00,X
	
	; Spr_Var1 = $96
	LDA #$96
	STA Spr_Var1+$00,X
	
	LDA #LOW(PRG053_WilyCapsuleDie_DANGER)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG053_WilyCapsuleDie_DANGER)
	STA Spr_CodePtrH+$00,X
	
	RTS	; $B857


PRG053_WilyCapsuleDie_DANGER:
	LDA Spr_Var1+$00,X
	AND #$07
	BNE PRG053_B864	; 7:8 jump to PRG053_B864

	LDA #SFX_DANGERALARM
	JSR PRG063_QueueMusSnd


PRG053_B864:
	; Black BG
	LDA #$0F
	STA PalData_1+16
	
	LDA Spr_Var1+$00,X
	AND #$10
	BEQ PRG053_B875	; 16:32 ticks jump to PRG053_B875

	; Orange BG
	LDA #$16
	STA PalData_1+16

PRG053_B875:
	
	; Commit palette
	LDA #$FF
	STA <CommitPal_Flag
	
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG053_B88F	; If Spr_Var1 > 0, jump to PRG053_B88F (RTS)

	JSR PRG062_ResetSpriteSlot

	LDA #PLAYERSTATE_TELEPORTEND
	STA <Player_State
	
	LDA #$78
	STA Level_ExitTimeout
	LDA #$00
	STA Level_ExitTimeoutH

PRG053_B88F:
	RTS	; $B88F


PRG053_WilyCapsule_Pos:
	;       Y    X
	.byte $48, $54		; 0
	.byte $40, $84		; 1
	.byte $30, $D4		; 2
	.byte $70, $44		; 3
	.byte $88, $7C		; 4
	.byte $70, $BC		; 5
	.byte $D0, $34		; 6
	.byte $C0, $B4		; 7
	
PRG053_WilyCapsuleShot_Pos:
	;      Y    X
	.byte $54, $2C
	.byte $34, $AC
	.byte $6C, $94
	.byte $BC, $54
	.byte $94, $D4

	; Selects a position pair from PRG053_WilyCapsule_Pos
PRG053_WilyCapsule_PosSel:
	.byte $01, $00, $01, $07, $02, $06, $03, $05, $04, $03, $05, $02, $06, $01, $07, $00
	
	; Index into PRG053_WilyCapsuleShot_Pos (x2) and PRG053_WilyCapsuleShotOrb_Data (x16)
PRG053_WilyCapsuleShot_PosSel:
	.byte $03, $04, $01, $00, $02, $01, $03, $02
	
PRG053_WilyCapsuleShotOrb_Data:
	;      YH   Y    XH   X

	; 4 orbs position 0
	.byte $00, $1C, $05, $F4
	.byte $00, $1C, $06, $64
	.byte $00, $8C, $05, $F4
	.byte $00, $8C, $06, $64

	; 4 orbs position 1
	.byte $FF, $EC, $06, $74
	.byte $FF, $EC, $06, $E4
	.byte $00, $6C, $06, $74
	.byte $00, $6C, $06, $E4

	; 4 orbs position 2
	.byte $00, $34, $06, $5C
	.byte $00, $34, $06, $CC
	.byte $00, $A4, $06, $5C
	.byte $00, $A4, $06, $CC

	; 4 orbs position 3
	.byte $00, $84, $06, $1C
	.byte $00, $84, $06, $8C
	.byte $01, $04, $06, $1C
	.byte $01, $04, $06, $8C

	; 4 orbs position 4
	.byte $00, $5C, $06, $9C
	.byte $00, $5C, $07, $0C
	.byte $00, $CC, $06, $9C
	.byte $00, $CC, $07, $0C
	
PRG053_WilyCap_Var1:
	.byte $3C, $5A
	
PRG053_WilyCap_Var2:
	.byte $3C, $96

PRG053_WilyCapsuleShotOrb_Var1:
	.byte $02, $03, $01, $00
	
PRG053_WilyBlinkLight_Y:
	.byte $4B, $3B, $3B, $4B, $4B
	
PRG053_WilyBlinkLight_X:
	.byte $1C, $34, $4C, $64, $9C
	
PRG053_WilyCapDie_FadeInPal:
	.byte $0F, $27, $15, $20, $0F, $30, $02, $22, $0F, $27, $00, $02, $0F, $20, $2B, $1C


	; CHECKME - UNUSED?
	.byte $00, $64, $00, $72, $82, $46, $28, $54, $00, $42, $24, $63, $AA, $00, $02, $51	; $B934 - $B943
	.byte $00, $87, $08, $60, $22, $B8, $00, $A1, $88, $01, $80, $C2, $0A, $5C, $00, $80	; $B944 - $B953
	.byte $A0, $AD, $28, $84, $80, $04, $0A, $C1, $A8, $AC, $AA, $0A, $0C, $10, $A8, $88	; $B954 - $B963
	.byte $8A, $19, $00, $B0, $8A, $42, $AA, $E3, $80, $20, $A0, $CB, $2A, $C4, $08, $B6	; $B964 - $B973
	.byte $A8, $AD, $A8, $0C, $08, $BD, $88, $14, $22, $28, $20, $19, $20, $08, $00, $34	; $B974 - $B983
	.byte $08, $9B, $22, $11, $4A, $00, $8A, $34, $80, $08, $42, $14, $A0, $40, $88, $08	; $B984 - $B993
	.byte $02, $61, $88, $42, $02, $24, $08, $AB, $02, $91, $08, $B2, $88, $00, $00, $81	; $B994 - $B9A3
	.byte $20, $83, $02, $83, $00, $0A, $80, $C0, $20, $20, $A8, $50, $08, $09, $00, $D8	; $B9A4 - $B9B3
	.byte $82, $90, $88, $10, $A8, $45, $88, $4B, $A0, $46, $0A, $00, $08, $27, $08, $A7	; $B9B4 - $B9C3
	.byte $28, $61, $00, $51, $1A, $42, $0A, $50, $02, $89, $20, $99, $08, $E2, $00, $06	; $B9C4 - $B9D3
	.byte $A0, $64, $02, $29, $A2, $1D, $00, $60, $02, $1E, $88, $EF, $80, $C0, $00, $6A	; $B9D4 - $B9E3
	.byte $28, $D8, $02, $38, $80, $C8, $02, $34, $08, $04, $00, $04, $00, $06, $08, $58	; $B9E4 - $B9F3
	.byte $A2, $44, $22, $00, $80, $F4, $80, $89, $20, $18, $22, $AD, $08, $81, $20, $00	; $B9F4 - $BA03
	.byte $22, $8C, $00, $40, $82, $80, $00, $10, $00, $8C, $20, $88, $00, $70, $0A, $A0	; $BA04 - $BA13
	.byte $0A, $86, $60, $03, $0A, $18, $08, $10, $02, $E0, $08, $84, $08, $C1, $80, $61	; $BA14 - $BA23
	.byte $A0, $8B, $28, $EC, $88, $14, $00, $0D, $22, $25, $8A, $02, $20, $44, $A8, $18	; $BA24 - $BA33
	.byte $02, $B0, $20, $27, $00, $20, $08, $54, $8A, $64, $06, $18, $A0, $34, $00, $29	; $BA34 - $BA43
	.byte $08, $59, $00, $86, $00, $06, $20, $10, $00, $26, $A0, $0E, $80, $80, $82, $20	; $BA44 - $BA53
	.byte $02, $40, $80, $10, $0A, $92, $00, $29, $08, $10, $28, $2A, $80, $62, $02, $64	; $BA54 - $BA63
	.byte $42, $88, $88, $B0, $09, $0B, $88, $0E, $29, $01, $80, $46, $A2, $29, $8A, $78	; $BA64 - $BA73
	.byte $80, $60, $00, $34, $A2, $63, $0A, $5B, $A8, $64, $08, $37, $08, $21, $80, $88	; $BA74 - $BA83
	.byte $02, $D0, $A8, $90, $00, $42, $00, $48, $2A, $99, $80, $41, $00, $20, $00, $79	; $BA84 - $BA93
	.byte $8A, $00, $00, $45, $30, $02, $08, $05, $0E, $D2, $00, $20, $08, $7B, $00, $03	; $BA94 - $BAA3
	.byte $04, $AA, $00, $A0, $02, $CF, $30, $01, $08, $73, $22, $A2, $A2, $52, $80, $4A	; $BAA4 - $BAB3
	.byte $00, $49, $08, $94, $08, $0C, $02, $08, $02, $61, $A8, $46, $02, $C1, $28, $28	; $BAB4 - $BAC3
	.byte $A0, $0A, $00, $8A, $A0, $2A, $28, $45, $AA, $69, $0A, $55, $82, $2E, $08, $B8	; $BAC4 - $BAD3
	.byte $2A, $4B, $0A, $06, $08, $20, $80, $BA, $02, $5A, $82, $3A, $0A, $26, $AA, $41	; $BAD4 - $BAE3
	.byte $22, $43, $00, $18, $20, $08, $80, $04, $88, $AC, $80, $C2, $80, $45, $80, $13	; $BAE4 - $BAF3
	.byte $0A, $B8, $A4, $6D, $A0, $D0, $00, $01, $A0, $7C, $0A, $63, $20, $C2, $00, $46	; $BAF4 - $BB03
	.byte $02, $04, $08, $98, $00, $59, $80, $82, $00, $10, $08, $06, $20, $61, $00, $00	; $BB04 - $BB13
	.byte $8A, $60, $00, $0C, $0A, $1C, $00, $D2, $08, $E8, $8A, $76, $0A, $02, $20, $01	; $BB14 - $BB23
	.byte $20, $08, $00, $93, $80, $64, $20, $00, $A0, $EB, $82, $0C, $A8, $0D, $00, $82	; $BB24 - $BB33
	.byte $A8, $C8, $00, $C0, $04, $EC, $20, $00, $80, $82, $80, $32, $0A, $49, $80, $A0	; $BB34 - $BB43
	.byte $2A, $03, $28, $BB, $00, $53, $20, $60, $22, $81, $8A, $E8, $A0, $40, $2C, $59	; $BB44 - $BB53
	.byte $06, $72, $80, $20, $00, $40, $A8, $84, $00, $C5, $02, $18, $22, $0E, $08, $80	; $BB54 - $BB63
	.byte $00, $2B, $82, $85, $20, $05, $A2, $0A, $00, $D6, $A2, $41, $28, $08, $00, $BC	; $BB64 - $BB73
	.byte $20, $C1, $80, $02, $8A, $01, $A0, $6A, $20, $CA, $00, $CA, $A0, $04, $A8, $01	; $BB74 - $BB83
	.byte $2A, $22, $22, $70, $20, $7C, $80, $24, $08, $19, $80, $C8, $22, $21, $80, $90	; $BB84 - $BB93
	.byte $A8, $20, $00, $EE, $08, $44, $00, $B0, $80, $12, $02, $D0, $00, $50, $0A, $B0	; $BB94 - $BBA3
	.byte $A0, $68, $28, $82, $02, $0A, $02, $10, $08, $04, $08, $00, $82, $C6, $88, $34	; $BBA4 - $BBB3
	.byte $20, $40, $20, $B0, $08, $0D, $20, $6A, $20, $90, $08, $0D, $20, $AD, $00, $C0	; $BBB4 - $BBC3
	.byte $22, $08, $2A, $44, $82, $01, $08, $4C, $08, $AC, $80, $28, $00, $20, $00, $41	; $BBC4 - $BBD3
	.byte $08, $62, $00, $24, $82, $2B, $20, $C0, $00, $50, $80, $EA, $80, $3B, $02, $62	; $BBD4 - $BBE3
	.byte $AA, $71, $08, $00, $18, $CA, $02, $00, $8A, $38, $20, $12, $02, $0D, $82, $85	; $BBE4 - $BBF3
	.byte $08, $3A, $A0, $F2, $02, $92, $02, $30, $08, $41, $80, $D5, $BF, $15, $EF, $15	; $BBF4 - $BC03
	.byte $FF, $53, $CB, $55, $BD, $47, $3D, $04, $4B, $5D, $DE, $15, $ED, $C1, $B7, $75	; $BC04 - $BC13
	.byte $AF, $11, $FF, $54, $EF, $15, $FF, $55, $F9, $15, $D7, $55, $FE, $55, $DF, $17	; $BC14 - $BC23
	.byte $DB, $55, $DA, $D0, $F6, $45, $FB, $5C, $FF, $55, $6F, $07, $D7, $15, $E9, $55	; $BC24 - $BC33
	.byte $B7, $05, $DF, $45, $11, $D4, $FF, $04, $FD, $51, $FF, $40, $FD, $45, $FE, $5F	; $BC34 - $BC43
	.byte $8F, $54, $77, $55, $B7, $45, $FF, $54, $ED, $45, $F7, $D5, $E2, $54, $DF, $53	; $BC44 - $BC53
	.byte $BF, $55, $FD, $75, $FD, $55, $76, $75, $FF, $55, $B7, $95, $EF, $75, $7D, $5D	; $BC54 - $BC63
	.byte $FD, $55, $F7, $E4, $F7, $50, $EF, $45, $7D, $55, $FF, $1E, $7F, $55, $BF, $55	; $BC64 - $BC73
	.byte $E2, $5D, $7D, $55, $DF, $74, $FF, $65, $D9, $10, $FF, $51, $FF, $59, $FF, $54	; $BC74 - $BC83
	.byte $EF, $F5, $EE, $55, $F7, $55, $EB, $57, $E7, $45, $BF, $50, $F5, $D5, $BD, $51	; $BC84 - $BC93
	.byte $3A, $04, $7D, $65, $D4, $54, $FF, $41, $FE, $55, $FF, $11, $DD, $51, $FF, $55	; $BC94 - $BCA3
	.byte $7F, $C4, $5E, $5E, $BE, $55, $7F, $55, $7F, $50, $EF, $55, $FF, $45, $FC, $55	; $BCA4 - $BCB3
	.byte $C9, $54, $FF, $5D, $DF, $40, $FC, $15, $EF, $55, $EA, $74, $CB, $51, $EF, $C4	; $BCB4 - $BCC3
	.byte $9B, $5D, $BF, $55, $35, $51, $BF, $05, $DF, $15, $FF, $55, $AD, $51, $FE, $45	; $BCC4 - $BCD3
	.byte $D2, $55, $B7, $55, $6F, $55, $CE, $55, $AE, $14, $77, $52, $7F, $55, $EF, $45	; $BCD4 - $BCE3
	.byte $7F, $55, $FF, $5D, $FF, $55, $BF, $65, $6F, $5D, $D6, $55, $7F, $5C, $1B, $15	; $BCE4 - $BCF3
	.byte $E3, $05, $FD, $64, $F6, $9D, $75, $8C, $EF, $47, $DE, $04, $FA, $44, $DB, $0D	; $BCF4 - $BD03
	.byte $5B, $55, $F7, $55, $1D, $54, $FF, $54, $CC, $55, $BB, $D5, $F1, $45, $FF, $41	; $BD04 - $BD13
	.byte $EF, $44, $9F, $51, $DB, $65, $FF, $53, $DF, $04, $A4, $0D, $D6, $45, $DF, $14	; $BD14 - $BD23
	.byte $F9, $55, $FF, $45, $97, $15, $EF, $75, $F7, $55, $D7, $D4, $FC, $15, $F7, $54	; $BD24 - $BD33
	.byte $7B, $C5, $FF, $54, $FB, $75, $85, $41, $9D, $D4, $ED, $D1, $E7, $51, $7F, $51	; $BD34 - $BD43
	.byte $FF, $15, $DE, $55, $F7, $55, $FF, $53, $F7, $D5, $7F, $55, $ED, $55, $F7, $55	; $BD44 - $BD53
	.byte $7F, $16, $7F, $45, $3F, $50, $D7, $51, $9F, $06, $FD, $15, $FB, $55, $B5, $55	; $BD54 - $BD63
	.byte $FF, $71, $7E, $95, $DF, $C5, $F6, $65, $FE, $D7, $FB, $58, $BF, $57, $7F, $D3	; $BD64 - $BD73
	.byte $7F, $45, $F9, $51, $CF, $25, $FD, $57, $5F, $05, $BF, $71, $5F, $61, $5E, $55	; $BD74 - $BD83
	.byte $AF, $54, $9B, $14, $BF, $95, $98, $55, $47, $01, $FF, $15, $B5, $D5, $FF, $55	; $BD84 - $BD93
	.byte $37, $03, $F5, $55, $CF, $C4, $BD, $74, $6A, $05, $AF, $4D, $FF, $55, $BD, $D1	; $BD94 - $BDA3
	.byte $DD, $D5, $BF, $15, $FF, $57, $BF, $45, $E6, $50, $D3, $35, $DA, $55, $FF, $17	; $BDA4 - $BDB3
	.byte $B6, $4C, $7F, $1F, $2E, $51, $FF, $51, $FF, $D1, $2C, $57, $FF, $55, $CE, $D1	; $BDB4 - $BDC3
	.byte $BC, $C5, $B5, $55, $F6, $55, $EF, $44, $7D, $55, $7B, $57, $7B, $55, $DC, $54	; $BDC4 - $BDD3
	.byte $FB, $55, $6F, $15, $F7, $45, $FB, $55, $FC, $D5, $EF, $54, $FF, $44, $6B, $54	; $BDD4 - $BDE3
	.byte $7B, $5D, $FF, $11, $FF, $85, $DD, $56, $BE, $71, $7B, $5D, $AD, $55, $BF, $11	; $BDE4 - $BDF3
	.byte $BD, $D1, $FB, $45, $7F, $54, $F6, $55, $FD, $55, $FE, $55, $FD, $95, $FB, $05	; $BDF4 - $BE03
	.byte $FD, $11, $FE, $55, $CF, $52, $F6, $D5, $DF, $54, $3F, $54, $BF, $55, $DF, $D4	; $BE04 - $BE13
	.byte $73, $55, $FB, $00, $F2, $55, $9B, $5D, $B7, $47, $FD, $55, $BF, $75, $FD, $15	; $BE14 - $BE23
	.byte $F7, $D5, $FF, $75, $DF, $5D, $5F, $55, $EE, $54, $BE, $C5, $2B, $55, $EF, $45	; $BE24 - $BE33
	.byte $EF, $D6, $FF, $45, $ED, $15, $FF, $54, $BF, $40, $73, $15, $F5, $55, $FB, $71	; $BE34 - $BE43
	.byte $7E, $55, $7F, $15, $9F, $55, $FE, $65, $BE, $D5, $7F, $5D, $AE, $55, $FD, $45	; $BE44 - $BE53
	.byte $7E, $11, $4F, $45, $5F, $55, $DB, $F1, $7F, $44, $BD, $95, $FF, $75, $FB, $55	; $BE54 - $BE63
	.byte $BB, $DD, $FF, $41, $EF, $74, $DE, $5D, $AE, $55, $EB, $51, $DF, $15, $5B, $5D	; $BE64 - $BE73
	.byte $FA, $53, $D1, $55, $DF, $04, $E7, $51, $FD, $35, $FF, $54, $7F, $54, $7F, $55	; $BE74 - $BE83
	.byte $F1, $19, $EF, $55, $FE, $15, $F1, $41, $FB, $55, $DF, $55, $E9, $55, $AF, $10	; $BE84 - $BE93
	.byte $BF, $48, $FE, $55, $BB, $0D, $FE, $45, $BE, $41, $FB, $15, $FB, $51, $EF, $55	; $BE94 - $BEA3
	.byte $7D, $55, $9D, $51, $6F, $4F, $3F, $55, $FF, $51, $F7, $45, $7B, $51, $F7, $51	; $BEA4 - $BEB3
	.byte $FF, $75, $F7, $5D, $FB, $43, $7D, $15, $FF, $45, $E4, $50, $DF, $45, $BF, $55	; $BEB4 - $BEC3
	.byte $FF, $65, $D5, $17, $FF, $55, $FE, $65, $E7, $5C, $FA, $D4, $AB, $55, $5F, $55	; $BEC4 - $BED3
	.byte $F3, $55, $67, $45, $FF, $51, $FF, $55, $FA, $51, $7F, $51, $F7, $45, $FA, $50	; $BED4 - $BEE3
	.byte $FF, $05, $FD, $55, $BF, $15, $EB, $55, $FF, $75, $FF, $50, $CB, $51, $FF, $D3	; $BEE4 - $BEF3
	.byte $9F, $45, $FE, $60, $C9, $45, $D7, $5D, $F5, $F5, $FD, $D5, $F4, $55, $A1, $55	; $BEF4 - $BF03
	.byte $BB, $15, $7E, $55, $FE, $41, $FF, $15, $FF, $45, $F3, $55, $FF, $15, $FB, $1D	; $BF04 - $BF13
	.byte $6D, $51, $BF, $58, $FD, $55, $7F, $51, $FD, $55, $F4, $71, $FE, $74, $FE, $55	; $BF14 - $BF23
	.byte $6E, $45, $FF, $57, $FF, $55, $FF, $56, $97, $55, $9F, $45, $DF, $15, $FF, $51	; $BF24 - $BF33
	.byte $DB, $54, $D6, $55, $FF, $47, $DD, $05, $FF, $75, $B3, $51, $77, $56, $FB, $17	; $BF34 - $BF43
	.byte $FF, $55, $FD, $54, $FF, $15, $FF, $55, $BD, $15, $7F, $D5, $D5, $55, $BF, $51	; $BF44 - $BF53
	.byte $57, $55, $FE, $D0, $7D, $51, $7F, $11, $7D, $55, $BD, $D5, $BB, $D5, $B5, $D5	; $BF54 - $BF63
	.byte $FF, $55, $DF, $55, $E5, $55, $FC, $55, $FF, $55, $FF, $15, $B7, $55, $FB, $35	; $BF64 - $BF73
	.byte $FB, $55, $FF, $55, $63, $D5, $FE, $44, $F8, $55, $6D, $50, $7E, $57, $F9, $51	; $BF74 - $BF83
	.byte $BB, $D5, $F7, $54, $DD, $55, $DF, $45, $5F, $C5, $BB, $55, $DB, $05, $EB, $00	; $BF84 - $BF93
	.byte $D1, $D4, $D6, $54, $FC, $14, $57, $51, $AB, $5E, $9F, $15, $FB, $55, $FF, $55	; $BF94 - $BFA3
	.byte $BF, $5C, $FF, $45, $BF, $57, $9F, $55, $EF, $54, $F7, $C5, $D7, $15, $9F, $75	; $BFA4 - $BFB3
	.byte $EF, $5C, $FE, $55, $FF, $15, $FB, $75, $7E, $55, $67, $55, $FE, $11, $FF, $51	; $BFB4 - $BFC3
	.byte $AF, $55, $BF, $51, $BF, $15, $FE, $55, $DA, $44, $B7, $51, $5F, $44, $DF, $76	; $BFC4 - $BFD3
	.byte $E4, $15, $E7, $55, $CE, $55, $F7, $41, $FC, $51, $E5, $14, $77, $35, $7F, $15	; $BFD4 - $BFE3
	.byte $FF, $54, $B7, $55, $EF, $57, $FB, $65, $FF, $11, $E6, $47, $BF, $91, $FF, $D1	; $BFE4 - $BFF3
	.byte $DF, $54, $DD, $55, $E6, $72, $EF, $77, $77, $54, $FF, $50	; $BFF4 - $BFFF


