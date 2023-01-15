PRG027_DoIntroStory_Ind:
	JMP PRG027_DoIntroStory	; $8000


PRG027_DoEnding:
	; Fade out...
	JSR PRG062_PalFadeOut

	; Clear sprites and slots
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites
	JSR PRG062_ClearSpriteSlots
	JSR PRG063_UpdateOneFrame

	; Background and graphics for Wily fortress in distance
	LDA #$00
	STA <MetaBlk_CurScreen
	LDX #$4B
	JSR PRG027_LoadGfxAndDrawScr_TMI14

	; Copy in palette
	LDY #$00
	JSR PRG027_CopyPalette_PRG027_8875

	; Wily fortress
	LDX #$01	; Sprite slot 1
	LDA #SPRANM1_ENDINGWILYFORT1
	JSR PRG063_SetSpriteAnim

	; Position Wily Fortress
	LDA #SPRSLOTID_CINESTUFF
	STA Spr_SlotID+$01
	
	LDA #$90
	STA Spr_Flags+$01
	LDA #$00
	STA Spr_XHi+$01
	STA Spr_YHi+$01
	LDA #$6F
	STA Spr_Y+$01
	LDA #$C8
	STA Spr_X+$01
	JSR PRG063_DrawSprites_RsetSprIdx
	
	LDA #$00
	STA <DisFlag_NMIAndDisplay
	STA <General_Counter
	
	; Fade in
	JSR PRG062_PalFadeIn


PRG027_8050:
	; Draw sprites
	JSR PRG063_DrawSprites_RsetSprIdx

	; Reset ticks (hold animation)
	LDA #$00
	STA Spr_AnimTicks+$01
	
	LDA <General_Counter
	CMP #$B4
	BEQ PRG027_8061	; If General_Counter = $B4, jump to PRG027_8061

	JMP PRG027_8050	; Loop until ticks hit threshold


PRG027_8061:
	LDX #$01	; X = 1 (Sprite slot 1, Wily fort)
	LDY #$02	; Y = 2 (destination slot)
	
	LDA #$27	; $8065
	JSR PRG063_CopySprSlotSetAnim	; $8067

	LDA #SPRSLOTID_CINESTUFF
	STA Spr_SlotID+$02
	STA Spr_Y+$02	; = $60 incidentally
	
	; General_Counter = 0
	LDA #$00
	STA <General_Counter

PRG027_8076:
	LDA <General_Counter
	AND #$03
	BNE PRG027_8089	; 3:4 ticks, jump to PRG027_8089

	JSR PRG027_EndingWilyShipXFlutter	; Wily ship X flutter

	DEC Spr_Y+$02	; Wily ship move up
	
	LDA Spr_Y+$02
	CMP #32
	BEQ PRG027_808F	; If Wily ship's Y = 32, jump to PRG027_808F


PRG027_8089:
	; Draw sprites
	JSR PRG063_DrawSprites_RsetSprIdx

	JMP PRG027_8076	; Loop!


PRG027_808F:
	LDA <General_Counter
	AND #$03
	BNE PRG027_80A2	; 3:4 ticks jump to PRG027_80A2

	JSR PRG027_EndingWilyShipYFlutter	; Wily ship Y flutter

	DEC Spr_X+$02	; Wily ship move left
	
	LDA Spr_X+$02
	CMP #136
	BEQ PRG027_80A8	; If Wily ship's X = 136, jump to PRG027_808F


PRG027_80A2:
	; Draw sprites
	JSR PRG063_DrawSprites_RsetSprIdx

	JMP PRG027_808F	; Jump to PRG027_808F


PRG027_80A8:
	LDA <General_Counter
	AND #$03
	BNE PRG027_80BB	; 3:4 ticks, jump to PRG027_80BB

	JSR PRG027_EndingWilyShipXFlutter	; Wily ship X flutter

	DEC Spr_Y+$02	; Wily ship move up
	
	LDA Spr_Y+$02
	CMP #-8
	BEQ PRG027_80C1	; If Wily ship's Y = -8, jump to PRG027_80C1


PRG027_80BB:
	; Draw sprites
	JSR PRG063_DrawSprites_RsetSprIdx

	JMP PRG027_80A8	; Jump to PRG027_80A8


PRG027_80C1:
	; Wily ship has flown away...

	; Wily fortress exploding
	LDX #$01
	LDA #SPRANM1_ENDINGWILYFORT2
	JSR PRG063_SetSpriteAnim

	; General_Counter = 0
	LDA #$00
	STA <General_Counter

PRG027_80CC:
	; Draw sprites
	JSR PRG063_DrawSprites_RsetSprIdx

	LDA <General_Counter
	AND #$1F
	BNE PRG027_80DA			; 1:32 ticks, jump to PRG027_80DA

	; Explode sound effect
	LDA #SFX_EXPLOSION
	JSR PRG063_QueueMusSnd

PRG027_80DA:
	LDA <General_Counter
	BNE PRG027_80CC	; While General_Counter > 0, loop!


	; Configure Rock's teleport-away sprite
	LDX #$01
	LDY #$00
	LDA #SPRANM1_ENDINGROCKTELE
	JSR PRG063_CopySprSlotSetAnim

	LDA #SPRSLOTID_CINESTUFF
	STA Spr_Y+$00			; Incidentally $60
	STA Spr_SlotID+$00

PRG027_80EF:
	; Rock Y -= 2
	DEC Spr_Y+$00
	DEC Spr_Y+$00
	
	LDA Spr_Y+$00
	CMP #$F8
	BEQ PRG027_8102	; If Megman has gone above screen, jump to PRG027_8102

	; Draw sprites!
	JSR PRG063_DrawSprites_RsetSprIdx

	JMP PRG027_80EF	; Loop!


PRG027_8102:

	; Wily fortress final thing before exploding
	LDX #$01
	LDA #SPRANM1_ENDINGWILYFORT3
	JSR PRG063_SetSpriteAnim


PRG027_8109:
	; Draw sprites
	JSR PRG063_DrawSprites_RsetSprIdx

	LDA Spr_Frame+$01
	CMP #$3B
	BNE PRG027_8109	; If Wily fortress explosion not over, loop!

	; Kaboom!
	LDA #SFX_BIGEXPLOSION
	JSR PRG063_QueueMusSnd

	; Wily fortress goes nuclear!
	LDX #$01
	LDA #SPRANM1_ENDINGWILYFORT4
	JSR PRG063_SetSpriteAnim

	; General_Counter = 0
	LDA #$00
	STA <General_Counter

PRG027_8123:
	; Draw sprites
	JSR PRG063_DrawSprites_RsetSprIdx

	LDA <General_Counter
	BNE PRG027_8123	; If General_Counter > 0, loop!

	; Fade out...
	LDA #$00
	STA <DisFlag_NMIAndDisplay
	JSR PRG062_PalFadeOut

	; Clear sprites!
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites
	JSR PRG062_ClearSpriteSlots
	JSR PRG063_UpdateOneFrame

	; Loads train background and Rock's (helmetless) sprites
	LDA #$0C
	STA <MetaBlk_CurScreen
	LDX #$4C
	JSR PRG027_LoadGfxAndDrawScr_TMI14

	; Load palette
	LDY #$20
	JSR PRG027_CopyPalette_PRG027_8875

	; Rock teleporting to train animation
	LDX #$01
	LDA #SPRANM1_ROCKTRAINTELE
	JSR PRG063_SetSpriteAnim

	LDA #SPRSLOTID_CINESTUFF
	STA Spr_SlotID+$01
	
	LDA #$90
	STA Spr_Flags+$01
	
	LDA #$00
	STA Spr_XHi+$01
	STA Spr_YHi+$01
	STA Spr_Y+$01
	
	LDA #$80
	STA Spr_X+$01
	JSR PRG063_SetObjYVelToMinus1

	; Train pole scenery init loop
	LDY #$00
PRG027_8172:
	LDA PRG027_EndingTrainPoleInit,Y	; $8172
	JSR PRG063_CopySprSlotSetAnim	; $8175

	LDA #$98
	STA Spr_Flags+$00,Y
	
	LDA PRG027_EndingTrainPoleInit+1,Y
	STA Spr_Var1+$00,Y
	
	LDA #SPRSLOTID_CINESTUFF
	STA Spr_SlotID+$00,Y
	
	; Y
	LDA PRG027_EndingTrainPoleYXHiInit,Y
	STA Spr_Y+$00,Y
	
	; XHi
	LDA PRG027_EndingTrainPoleYXHiInit+1,Y
	STA Spr_XHi+$00,Y
	
	; X
	LDA #$00
	STA Spr_X+$00,Y
	STA Spr_XVelFrac+$00,Y
	
	; XVel
	LDA #$08
	STA Spr_XVel+$00,Y
	
	INY
	INY
	CPY #$04
	BNE PRG027_8172


	; This draws out the screen
	LDA #$0B	; $81A7
	STA <CommitBG_ScrSel	; $81A9
	LDA #$80	; $81AB
	STA <CommitBG_Flag	; $81AD
	LDA #$80	; $81AF
	STA <Level_SegCurData	; $81B1
	LDA #$00	; $81B3
	STA MMC3_MIRROR	; $81B5

PRG027_81B8:
	JSR PRG063_E35C	; $81B8

	JSR PRG063_UpdateOneFrame	; $81BB

	LDA <CommitBG_Flag	; $81BE
	BNE PRG027_81B8	; $81C0


	LDA #$00
	STA <Raster_VSplit_HPosReq
	STA <PPU_CTL1_PageBaseReq_RVBoss	; $81C6
	LDA #$0B	; $81C8
	STA <CommitBG_ScrSel	; $81CA
	LDA #$1F	; $81CC
	STA <ScreenUpd_CurCol	; $81CE
	
	; Ending music (train)
	LDA #MUS_ENDING1
	JSR PRG063_QueueMusSnd_SetMus_Cur

	; Fade in!
	JSR PRG062_PalFadeIn


PRG027_81D8:

	; Holding animation, move vertically, Rock teleporting in
	LDX #$01
	LDA #$00
	STA Spr_AnimTicks+$01
	JSR PRG063_DoMoveSimpleVert

	LDA #$54
	CMP Spr_Y+$01
	BGE PRG027_81EE	; If Rock has not landed on the train, jump to PRG027_81EE

	STA Spr_Y+$01	; Stick train landing
	BLT PRG027_81F4	; Jump (technically always) to PRG027_81F4


PRG027_81EE:
	; Draw sprites
	JSR PRG063_DrawSprites_RsetSprIdx

	JMP PRG027_81D8	; Loop!


PRG027_81F4:
	; Draw sprites
	JSR PRG063_DrawSprites_RsetSprIdx

	LDA Spr_Frame+$01
	CMP #$04
	BNE PRG027_81F4	; If Rock's teleportation animation hasn't ended, loop!

	; Set standing animation
	LDX #$01
	LDA #SPRANM1_ROCKTRAINSTAND
	JSR PRG063_SetSpriteAnim

	; Raster split position for train/mountains
	LDA #$60
	STA <Raster_VSplit_Req
	
	LDA #RVMODE_INTROTRAIN1
	STA <Raster_VMode
	
	LDA #$0B	; $820D
	STA <MetaBlk_CurScreen	; $820F
	
	; Init ending train text VRAM
	LDA PRG027_EndingTrainCreditText
	STA <EndTrainText_VRAMHigh
	LDA PRG027_EndingTrainCreditText+1
	STA <EndTrainText_VRAMLow
	
	; Init ending train text pointer
	LDA #LOW(PRG027_EndingTrainCreditText+2)
	STA <EndTrainText_TextPtrL
	LDA #HIGH(PRG027_EndingTrainCreditText+3)
	STA <EndTrainText_TextPtrH
	
	LDA #$00
	STA <EndTrainText_NxtLnDelay
	STA <EndTrain_CurPalIndex

PRG027_8229:
	LDA <Raster_VSplit_HPosReq
	ORA <MetaBlk_CurScreen
	BEQ PRG027_8267	; If we're at the leftmost edge (i.e. Raster_VSplit_HPosReq = 0 and MetaBlk_CurScreen = 0), jump to PRG027_8267

	LDA Spr_Var1+$01
	AND #$01
	BNE PRG027_8254	; Basically every other frame, jump to PRG027_8254

	; Parallax mountain move
	LDA <Raster_VSplit_HPosReq
	SUB #$01
	STA <Raster_VSplit_HPosReq
	
	PHP	; $823D
	
	LDA <PPU_CTL1_PageBaseReq_RVBoss	; $823E
	SBC #$00	; $8240
	AND #$01	; $8242
	STA <PPU_CTL1_PageBaseReq_RVBoss	; $8244
	
	PLP	; $8246
	BCS PRG027_824B	; $8247

	DEC <MetaBlk_CurScreen	; $8249

PRG027_824B:
	; BG graphics update
	JSR PRG027_EndingMtnToCityBG
	JSR PRG027_EndingPalTransition

	JMP PRG027_8257	; Jump to PRG027_8257


PRG027_8254:
	JSR PRG027_EndingTrainCredText	; Update ending text on train


PRG027_8257:
	JSR PRG027_MoveTrainPoles	; Move the train poles

	; General_Counter = $FF
	LDA #$FF
	STA <General_Counter
	
	; Draw sprites
	JSR PRG063_DrawSprites_RsetSprIdx

	INC Spr_Var1+$01	; Var1++
	JMP PRG027_8229	; Loop!


PRG027_8267:

	; General_Counter = 0
	LDA #$00
	STA <General_Counter

	; Delay after train stops
PRG027_826B:
	; Draw sprites
	JSR PRG063_DrawSprites_RsetSprIdx

	LDA <General_Counter
	CMP #$3C
	BNE PRG027_826B		; If General_Counter <> $3C, jump to PRG027_826B

	JSR PRG027_TrainTextClear	; Clear train text

	; Sprite palette for Rush and Roll
	LDY #$07
PRG027_8279:
	LDA PRG027_TrainRushRollPal,Y
	STA PalData_1+24,Y
	STA PalData_2+24,Y
	DEY
	BPL PRG027_8279

	STY <CommitPal_Flag	; CommitPal_Flag = $FF
	
	; Config Rush and Roll walking
	LDY #$00
	LDX #$01
	LDA #SPRANM1_ENDINGRRWALK
	JSR PRG063_CopySprSlotSetAnim

	LDA #SPRSLOTID_CINESTUFF
	STA Spr_SlotID+$00
	
	; Rush and Roll's position
	LDA #$00
	STA Spr_X+$00
	LDA #$D7
	STA Spr_Y+$00

PRG027_829F:
	INC Spr_X+$00	; Rush and Roll walking right
	JSR PRG063_DrawSprites_RsetSprIdx	; Draw sprites

	LDA Spr_X+$00
	CMP #$54
	BNE PRG027_829F	; If Rush and Roll's X <> $54, loop!

	; Rush and Roll stop
	LDX #$00
	LDA #SPRANM1_ENDINGRRSTOP
	JSR PRG063_SetSpriteAnim

	; General_Counter = 0
	LDA #$00
	STA <General_Counter
PRG027_82B7:
	; Draw sprites
	JSR PRG063_DrawSprites_RsetSprIdx

	LDA <General_Counter
	CMP #$3C
	BNE PRG027_82B7	; If General_Counter <> 0, loop!

	; Rock jumping off train
	LDX #$01
	LDA #SPRANM1_ROCKTRAINJUMP
	JSR PRG063_SetSpriteAnim

	; Jump off velocity
	LDA #$00
	STA Spr_YVelFrac+$01
	LDA #$05
	STA Spr_YVel+$01

PRG027_82D1:

	; Rock falls downward
	LDX #$01
	JSR PRG063_DoMoveSimpleVert

	LDA #$7C
	CMP Spr_Y+$01
	BGE PRG027_82E0		; If Rock's Y <> $7C, jump to PRG027_82E0

	STA Spr_Y+$01		; Stop here

PRG027_82E0:
	JSR PRG063_DrawSprites_RsetSprIdx

	LDA Spr_Y+$01
	CMP #$7C
	BNE PRG027_82D1	; If Rock's Y <> $7C, jump to PRG027_82D1


	; Rock has finished jumping off train..

	; Copy in the sepia palette
	LDY #$1F
PRG027_82EC:
	LDA PRG027_TrainSepiaPal,Y
	STA PalData_1,Y
	STA PalData_2,Y
	DEY
	BPL PRG027_82EC

	STY <CommitPal_Flag	; CommitPal_Flag = $FF (commit palette)
	
	LDA #$00	; $82FA
	STA <DisFlag_NMIAndDisplay	; $82FC
	
	LDA #MUS_PARTIALMUTE
	JSR PRG063_QueueMusSnd_SetMus_Cur

	LDX #$00
	JSR PRG063_UpdateMultipleFrames

	; Fade out
	JSR PRG062_PalFadeOut

	; Terminate raster effect
	LDA #$00
	STA <Raster_VMode
	JSR PRG063_UpdateOneFrame

	; Clear sprites and slots
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites
	JSR PRG062_ClearSpriteSlots
	JSR PRG063_UpdateOneFrame

	; The "robot master" rotating color BG
	LDX #TMAP_CREDITLOGO
	STX <TileMap_Index
	LDA #$02
	STA <MetaBlk_CurScreen
	JSR PRG027_LoadGfxAndDrawScr

	; Palette
	LDY #$40
	JSR PRG027_CopyPalette_PRG027_8875

	; Slot contains the boss intro object
	LDX #$00
	LDA #SPRSLOTID_BOSSINTRO
	STA Spr_SlotID+$00
	
	; Bright Man's intro
	LDA #SPRANM3_BOSSINT_BRIGHT
	JSR PRG063_SetSpriteAnim

	LDA #$90
	STA Spr_Flags+$00
	
	; Configure for Bright Man
	LDA #TMAP_BRIGHTMAN
	STA <TileMap_Index
	
	; Set XHi/YHi to zero
	STA Spr_XHi+$00
	STA Spr_YHi+$00
	
	; Position intro object
	LDA #$74
	STA Spr_Y+$00
	LDA #$50
	STA Spr_X+$00
	
	; Graphics buffer "STAFF"
	LDY #$08
PRG027_8356:
	LDA PRG027_EndTextStaff,Y
	STA Graphics_Buffer+$00,Y
	DEY
	BPL PRG027_8356

	STY <CommitGBuf_Flag	; Commit graphics buffer
	
	; Fade in
	JSR PRG062_PalFadeIn

	; Ending music!
	LDA #MUS_ENDING2
	JSR PRG063_QueueMusSnd_SetMus_Cur

	LDX #$01	; $8369
	LDY #$92	; $836B

PRG027_836D:
	TYA	; $836D
	STA PalAnim_EnSel+$00,X	; $836E
	LDA #$00	; $8371
	STA PalAnim_CurAnimOffset+$00,X	; $8373
	STA PalAnim_TickCount+$00,X	; $8376
	INY	; $8379
	INX	; $837A
	CPX #$04	; $837B
	BNE PRG027_836D	; $837D

	; Delay "STAFF" display
	LDX #$96
	JSR PRG063_UpdateMultipleFrames

	; Clear "STAFF"
	LDY #$08
PRG027_8386:
	LDA PRG027_EndTextStaffClear,Y
	STA Graphics_Buffer+$00,Y
	DEY
	BPL PRG027_8386

	STY <CommitGBuf_Flag	; Commit graphics buffer
	JSR PRG063_UpdateOneFrame


PRG027_8394:
	LDX <TileMap_Index	; X = TileMap_Index

	; Set graphics / palette for current robot master
	LDA PRG027_EndCHRSelPerRobotMaster,X
	INC <DisFlag_NMIAndDisplay
	JSR PRG062_CHRRAMDynLoadPalSeg

	LDA #$00	; $839E
	STA <CommitPal_Flag	; $83A0
	
	DEC <DisFlag_NMIAndDisplay	; $83A2
	
	; General_Counter = $78
	LDA #$78
	STA <General_Counter

	; $78 ticks to load and otherwise delay 
PRG027_83A8:
	; Load graphics segment
	JSR PRG063_CHRRAMDynLoadCHRSegSafe
	JSR PRG063_UpdateOneFrame

	DEC <General_Counter
	BNE PRG027_83A8

	; Draw sprites
	LDA Spr_Flags+$00
	AND #$FB
	STA Spr_Flags+$00
	JSR PRG063_DrawSprites_RsetSprIdx

	LDA #$00	; $83BD
	STA <DisFlag_NMIAndDisplay	; $83BF
	
	; Temp_Var15 = $30 (fade value)
	LDA #$30
	STA <Temp_Var15

PRG027_83C5:
	
	LDX #$00	; X = 0
	
	LDA <TileMap_Index
	ASL A
	ASL A
	ASL A
	TAY		; Y = TileMap_Index * 8

PRG027_83CD:
	LDA PRG027_8C4B,X
	SUB <Temp_Var15
	BCS PRG027_83D7

	LDA #$0F	; Black palette min value

PRG027_83D7:
	STA PalData_1+16,X
	STA PalData_2+16,X
	
	LDA PRG027_8C4B+8,Y
	SUB <Temp_Var15
	BCS PRG027_83E7

	LDA #$0F	; Black palette min value

PRG027_83E7:
	STA PalData_1+24,X	; $83E7
	STA PalData_2+24,X	; $83EA
	
	INY	; $83ED
	INX	; $83EE
	CPX #$08	; $83EF
	BNE PRG027_83CD	; $83F1

	; Commit palette
	LDA #$FF
	STA <CommitPal_Flag
	
	; Delay 10 ticks
	LDX #$0A
	JSR PRG063_UpdateMultipleFrames

	; Less fade
	LDA <Temp_Var15
	SUB #$10
	STA <Temp_Var15
	
	BCS PRG027_83C5	; Loop until fade done


	; Loop for animation
PRG027_8405:
	; Draw sprites
	JSR PRG063_DrawSprites_RsetSprIdx

	LDA Spr_Frame+$00
	CMP #$05
	BNE PRG027_8405	; If robot master has not reached frame 5, loop!
	

	LDA #$00
	STA <DisFlag_NMIAndDisplay
	
	; Print Robot Master number, name, credit
	JSR PRG027_DoRobotMasterCredit

	; Pause after display robot master name
	LDX #$F0
	JSR PRG063_UpdateMultipleFrames

	INC <TileMap_Index	; Next robot master
	LDA <TileMap_Index
	CMP #TMAP_COSSACK1
	BEQ PRG027_8483		; If that was the last robot master, jump to PRG027_8483

	LDY #$32	; $8423

	; Clear the previous robot master number, name, credit
PRG027_8425:
	LDA PRG027_EndCredit_ClearRMaster,Y
	STA Graphics_Buffer+$00,Y
	DEY
	BPL PRG027_8425

	STY <CommitGBuf_Flag	; CommitGBuf_Flag = $FF (commit graphics buffer)
	
	; Temp_Var15 = $10 (fade level)
	LDA #$10
	STA <Temp_Var15

PRG027_8434:

	; Darken palette for robot master fade out
	LDY #$0F
PRG027_8436:
	LDA PalData_2+16,Y
	SUB <Temp_Var15
	BCS PRG027_8440

	LDA #$0F	; Minimum palette black

PRG027_8440:
	STA PalData_1+16,Y
	DEY
	BPL PRG027_8436

	STY <CommitPal_Flag	; CommitPal_Flag = $FF (commit palette)
	
	; Wait 10 frames
	LDX #$0A
	JSR PRG063_UpdateMultipleFrames

	; Increase fade level
	LDA <Temp_Var15
	ADD #$10
	STA <Temp_Var15
	
	CMP #$50
	BNE PRG027_8434	; If fade not complete, loop

	; Robot master has faded out...

	LDY #$02	; $8458
PRG027_845A:
	LDA PalAnim_EnSel+$01,Y	; $845A
	ADD #$03	; $845D
	STA PalAnim_EnSel+$01,Y	; $8460
	DEY	; $8463
	BPL PRG027_845A	; $8464

	; Don't draw sprite
	LDA Spr_Flags+$00
	ORA #$04
	STA Spr_Flags+$00
	
	INC Spr_CurrentAnim+$00	; $846E

	; Clear robot master sprite
	LDA #$00
	STA Spr_Frame+$00
	STA Spr_AnimTicks+$00
	JSR PRG063_DrawSprites_RsetSprIdx

	LDA #$00	; $847C
	STA <DisFlag_NMIAndDisplay	; $847E
	
	JMP PRG027_8394	; Jump to PRG027_8394 (next robot master)


PRG027_8483:
	; Robot master roster complete!!

	; Fade out
	LDA #$00	; $8483
	STA <DisFlag_NMIAndDisplay	; $8485
	STA PalAnim_EnSel+$01	; $8487
	STA PalAnim_EnSel+$02	; $848A
	STA PalAnim_EnSel+$03	; $848D
	JSR PRG062_PalFadeOut	; $8490

	; Clear sprites and alots
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites
	JSR PRG062_ClearSpriteSlots

	; Load up the final credit roll!
	LDA #$0D
	STA <MetaBlk_CurScreen
	LDX #$4D
	JSR PRG027_LoadGfxAndDrawScr_TMI14

	; Palette for credit roll
	LDY #$60
	JSR PRG027_CopyPalette_PRG027_8875

	; Copy in the background starfield sprites
	LDY #(PRG027_EndCredit_Starfield_End - PRG027_EndCredit_Starfield - 1)
PRG027_84AD:
	LDA PRG027_EndCredit_Starfield,Y
	STA Sprite_RAM+$00,Y
	DEY
	BPL PRG027_84AD

	; Update frame
	JSR PRG063_UpdateOneFrame

	; Fade in
	JSR PRG062_PalFadeIn

	; End credit lines -> Temp_Var16/17
	LDA #LOW(PRG027_EndCredit_RollText)
	STA <Temp_Var16
	LDA #HIGH(PRG027_EndCredit_RollText)
	STA <Temp_Var17
	
	; Temp_Var18 = $01 (index into PRG027_EndingCredRollTable, first assignment is forced hence why 1)
	LDA #$01
	STA <Temp_Var18
	
	; Temp_Var19 = $00 (current credit line, screen-relative)
	LDA #$00
	STA <Temp_Var19
	
	; General_Counter = $00
	LDA #$00
	STA <General_Counter

PRG027_84D0:
	LDA <General_Counter
	AND #$01
	BNE PRG027_84EA	; Every other loop, jump to PRG027_84EA (to PRG027_856B)

	; Every other frame...

	LDA <Temp_Var18
	CMP #$24
	BNE PRG027_84ED	; If not on the last credit line, jump to PRG027_84ED

	; Final credit screen...

	LDA <Vert_Scroll
	CMP #$90
	BNE PRG027_84ED	; If not scrolled far enough, jump to PRG027_84ED

	; Final segment of ending!
	
	LDA #MUS_PARTIALMUTE
	JSR PRG063_QueueMusSnd_SetMus_Cur

	JMP PRG027_8576	; Jump to PRG027_8576


PRG027_84EA:
	JMP PRG027_856B	; Jump to PRG027_856B


PRG027_84ED:
	; Credit scrolling!
	
	INC <Vert_Scroll	; Move credits up
	
	LDA <Vert_Scroll
	CMP #$F0
	BNE PRG027_84F9	; If not at the vertical bottom point, jump to PRG027_84F9

	; Reset vertical scroll for loop
	LDA #$00
	STA <Vert_Scroll

PRG027_84F9:
	LDA <Vert_Scroll
	AND #$07
	BNE PRG027_856B	; If haven't scrolled 8 pixels, jump to PRG027_856B

	; Time to put in a new credit line!

	INC <Temp_Var19	; Temp_Var19++ (next credit line)
	
	LDA <Temp_Var19
	CMP #$1E
	BNE PRG027_850B	; If not on the final credit line of the screen, jump to PRG027_850B

	; New screen, reset credit line
	LDA #$00
	STA <Temp_Var19

PRG027_850B:
	
	; Copy in the credit line buffer data
	LDX #(PRG027_EndCredit_LineTempl_End - PRG027_EndCredit_LineTempl - 1)
PRG027_850D:
	LDA PRG027_EndCredit_LineTempl,X
	STA Graphics_Buffer+$00,X
	DEX
	BPL PRG027_850D

	LDY #$00	; Y = 0
	
	LDA <Temp_Var19	; Current credit line
	CMP [Temp_Var16],Y	; Compare to next credit line trigger
	BNE PRG027_853C	; If not time for this credit line, jump to PRG027_853C


	; New credit line!

	INY	; Y++ (after the line trigger value)
	
	LDA [Temp_Var16],Y	; Fetch length of credit line
	TAX	; -> X
	
	INY	; Y++ (after the length value)

PRG027_8523:
	LDA [Temp_Var16],Y	; Fetch next credit line character
	BMI PRG027_852E	; If terminator, jump to PRG027_852E

	STA Graphics_Buffer+$03,X	; Store next credit character!
	
	INX	; X++ (next buffer pos)
	INY	; Y++ (next credit char)
	BNE PRG027_8523	; Loop!


PRG027_852E:

	LDY <Temp_Var18	; Y = current index into PRG027_EndingCredRollTable
	
	; Fetch address of next credit line
	LDA PRG027_EndingCredRollTable_L,Y
	STA <Temp_Var16
	LDA PRG027_EndingCredRollTable_H,Y
	STA <Temp_Var17
	
	INC <Temp_Var18	; Temp_Var18++

PRG027_853C:
	
	; Compute VRAM address low for credit line
	LDA <Temp_Var19	; Current credit line
	STA <Temp_Var0

	LDA #$00
	STA <Temp_Var1
	ASL <Temp_Var0
	ROL <Temp_Var1
	ASL <Temp_Var0
	ROL <Temp_Var1
	ASL <Temp_Var0
	ROL <Temp_Var1
	ASL <Temp_Var0
	ROL <Temp_Var1
	ASL <Temp_Var0
	ROL <Temp_Var1
	LDA <Temp_Var0
	ORA Graphics_Buffer+$01
	STA Graphics_Buffer+$01
	
	; Computer VRAM address high for credit line
	LDA #$20
	ORA <Temp_Var1
	STA Graphics_Buffer+$00
	
	; Commit graphics buffer
	LDA #$FF
	STA <CommitGBuf_Flag

PRG027_856B:
	JSR PRG027_EndingStarScroll	; Scroll stars

	JSR PRG063_UpdateOneFrame	; Update frame

	INC <General_Counter	; General_Counter++
	JMP PRG027_84D0	; Loop!


PRG027_8576:
	; Credit roll is done! Final part

	; Set Eddie's animation!
	LDX #$00
	LDA #SPRANM4_ENDEDDIEWALK
	JSR PRG063_SetSpriteAnim

	LDA #$90
	STA Spr_Flags+$00
	
	LDA #SPRSLOTID_MISCSTUFF
	STA Spr_SlotID+$00
	
	LDA #$00
	STA Spr_XHi+$00
	STA Spr_YHi+$00
	
	LDA #$FC
	STA Spr_X+$00
	LDA #$88
	STA Spr_Y+$00

PRG027_8599:
	LDA Spr_X+$00
	CMP #$B0
	BEQ PRG027_85B0	; If Eddie is in place, jump to PRG027_85B0

	DEC Spr_X+$00	; Move Eddie left
	
	JSR PRG027_EndingStarScroll	; Keep scrolling those stars

	; Draw Eddie's sprites (avoiding the background stars)
	LDA #$2C
	STA <Sprite_CurrentIndex
	JSR PRG063_DrawSprites

	JMP PRG027_8599	; Loop


PRG027_85B0:
	; Eddie's in place for the finale!

	; Index into CAPCOM sprite object stuff
	LDA #$06
	STA Spr_Var2+$00
	
	LDA #$01
	STA Spr_Var1+$00

PRG027_85BA:
	DEC Spr_Var1+$00	; $85BA
	BNE PRG027_85CB	; $85BD

	LDA #$28
	STA Spr_Var1+$00
	
	; Do flip-open animation
	LDA #SPRANM4_ENDEDDIEOPEN
	LDX #$00
	JSR PRG063_SetSpriteAnim


PRG027_85CB:
	LDA Spr_CurrentAnim+$00
	CMP #SPRANM4_ENDEDDIEOPEN
	BNE PRG027_8612	; If not spitting out letters, jump to PRG027_8612

	; Spitting letters animation

	LDA Spr_Frame+$00
	CMP #$04
	BNE PRG027_8612	; If Eddie's not on the right frame for spitting another letter, jump to PRG027_8612

	; Spit letter

	INC Spr_Frame+$00	; $85D9
	
	; X = 0
	LDX #$00
	
	; Index into CAPCOM sprite slot stuff
	LDY Spr_Var2+$00
	
	LDA PRG027_EndCAPCOM_Anim-1,Y
	JSR PRG063_CopySprSlotSetAnim

	; CAPCOM letter Y vel
	LDA #$E5
	STA Spr_YVelFrac+$00,Y
	LDA #$04
	STA Spr_YVel+$00,Y

	; CAPCOM letter X vel
	LDA PRG027_EndCAPCOM_XVelF-1,Y
	STA Spr_XVelFrac+$00,Y	
	LDA PRG027_EndCAPCOM_XVel-1,Y
	STA Spr_XVel+$00,Y
	
	LDA PRG027_EndCAPCOM_XDest-1,Y	; $85FD
	STA Spr_Var1+$00,Y	; $8600
	
	; Sprite slot
	LDA #SPRSLOTID_CINESTUFF
	STA Spr_SlotID+$00,Y
	
	; Previous index into CAPCOM sprite slot stuff
	DEC Spr_Var2+$00
	
	BNE PRG027_8612	; If not on the final letter of CAPCOM, jump to PRG027_8612

	; Final letter, stop music
	LDA #MUS_STOPMUSIC
	JSR PRG063_QueueMusSnd_SetMus_Cur


PRG027_8612:
	LDX Spr_Var2+$00	; X = index to CAPCOM sprite slot stuff
	
	INX	; X++ (correct to proper sprite index)
	
	JSR PRG063_DoMoveSimpleVert	; Move letter vertically

	LDA Spr_YVel+$00,X
	BPL PRG027_8636	; If letter is still moving upward, jump to PRG027_8636

	LDA #$70
	CMP Spr_Y+$00,X
	BGE PRG027_8636	; If letter hasn't hit Y = $70, jump to PRG027_8636

	STA Spr_Y+$00,X	; Lock letter in place
	
	; Final destination X
	LDA Spr_Var1+$00,X
	STA Spr_X+$00,X	
	
	; Landing noise
	LDA #SFX_PLAYERLAND
	JSR PRG063_QueueMusSnd

	JMP PRG027_8639	; Jump to PRG027_8639 (letter is halted)


PRG027_8636:
	JSR PRG063_ApplyXVelocityRev	; Move letter horizontally


PRG027_8639:
	LDA Spr_CurrentAnim+$00
	CMP #SPRANM4_ENDEDDIEOPEN
	BNE PRG027_864E	; If Eddie is not spitting letters, jump to PRG027_864E

	LDA Spr_Frame+$00
	CMP #$07
	BNE PRG027_864E	; If Eddie is not on the final frame of spit, jump to PRG027_864E

	; Stop spit animation
	LDX #$00
	LDA #SPRANM4_ENDEDDIESTAND
	JSR PRG063_SetSpriteAnim


PRG027_864E:
	JSR PRG027_EndingStarScroll	; Continue scrolling star field

	; Draw Eddie and letters
	LDA #$2C
	STA <Sprite_CurrentIndex
	JSR PRG063_DrawSprites

	LDA Spr_Var2+$00
	BEQ PRG027_8612	; If all letters are done, short loop

	JMP PRG027_85BA	; Otherwise, more letters, long loop

	; "CAPCOM" ending letters spit out by Eddie
	
	;                           M    O    C    P    A    C
PRG027_EndCAPCOM_XVelF:	.byte $F0, $2D, $69, $A5, $E1, $1E
PRG027_EndCAPCOM_XVel:	.byte $00, $01, $01, $01, $01, $02
PRG027_EndCAPCOM_Anim:	.byte SPRANM1_ENDCAPCOM_M, SPRANM1_ENDCAPCOM_O, SPRANM1_ENDCAPCOM_C, SPRANM1_ENDCAPCOM_P, SPRANM1_ENDCAPCOM_A, SPRANM1_ENDCAPCOM_C
PRG027_EndCAPCOM_XDest:	.byte $8C, $84, $7C, $74, $6C, $64


PRG027_DoRobotMasterCredit:
	LDY <TileMap_Index	; Y = TileMap_Index (current robot master being shown during ending)
	
	; Address to robot master number, name, credit -> Temp_Var2/3
	LDA PRG027_8E26,Y
	STA <Temp_Var2
	LDA PRG027_8E2E,Y
	STA <Temp_Var3
	
	LDY #$00
PRG027_8686:
	LDA [Temp_Var2],Y	; Get next byte of robot master text
	BMI PRG027_86B7	; If terminator, jump to PRG027_86B7

	; High byte of VRAM address
	STA Graphics_Buffer+$00
	
	INY	; Y++ (next byte)
	
	; Low byte of VRAM address
	LDA [Temp_Var2],Y
	STA Graphics_Buffer+$01

	; Bytes to copy (1)
	LDA #$00
	STA Graphics_Buffer+$02
	
	INY	; Y++ (next byte)
	
	LDA [Temp_Var2],Y
	STA <Temp_Var4	; Length of string -> Temp_Var4
	
	INY	; Y++ (next byte)

PRG027_869E:
	
	; Next printable char
	LDA [Temp_Var2],Y
	STA Graphics_Buffer+$03
	
	; Terminator
	LDA #$FF
	STA Graphics_Buffer+$04
	
	STA <CommitGBuf_Flag	; Commit graphics buffer
	
	JSR PRG063_UpdateOneFrame	; Update frame

	INY	; Y++ 
	
	INC Graphics_Buffer+$01	; Next VRAM address
	
	DEC <Temp_Var4	; One less character
	BPL PRG027_869E	; If more characters, loop!

	BMI PRG027_8686	; Jump (technically always) to PRG027_8686 (fetch new VRAM address or terminate)


PRG027_86B7:
	RTS	; $86B7


	; Scroll the star field during the ending credit roll... pretty straightforward
PRG027_EndingStarScroll:
	
	LDY #$08
PRG027_86BA:
	LDA Sprite_RAM+$03,Y
	ADD #$03
	STA Sprite_RAM+$03,Y
	
	DEY
	DEY
	DEY
	DEY
	BPL PRG027_86BA

	LDY #$1C
PRG027_86CB:
	LDA Sprite_RAM+$0F,Y
	ADD #$02
	STA Sprite_RAM+$0F,Y
	
	DEY
	DEY
	DEY
	DEY
	BPL PRG027_86CB

	RTS	; $86DA


PRG027_EndingPalTransition:
	LDY <EndTrain_CurPalIndex
	CPY #$14
	BEQ PRG027_871E		; If EndTrain_CurPalIndex = $14 (no more transitions), jump to PRG027_871E (RTS)

	LDA <MetaBlk_CurScreen
	CMP PRG027_PalTriggerScreen,Y
	BNE PRG027_871E		; If this isn't the next trigger screen, jump to PRG027_871E (RTS)

	LDA PRG027_PalTriggerScrHPos,Y
	CMP <Raster_VSplit_HPosReq
	BNE PRG027_871E		; If this isn't the next trigger position on this screen, jump to PRG027_871E (RTS)

	INC <EndTrain_CurPalIndex	; Next palette
	
	TYA
	ASL A
	ASL A				; * 4
	STA <Temp_Var0	
	ASL A				; * 8
	ADC <Temp_Var0
	
	TAY	; Y = EndTrain_CurPalIndex * 12 (palette index)

	LDX #$00

	; Copy in train palette (first 4 BG)
PRG027_86FC:
	LDA PRG027_TrainPalettes,Y
	STA PalData_1,X
	STA PalData_2,X
	INY
	INX
	CPX #$04
	BNE PRG027_86FC

	; Copy in train palette (last 8 BG)
PRG027_870B:
	LDA PRG027_TrainPalettes,Y
	STA PalData_1+4,X
	STA PalData_2+4,X
	INY
	INX
	CPX #$0C
	BNE PRG027_870B

	LDA #$FF	; $871A
	STA <CommitPal_Flag	; $871C

PRG027_871E:
	RTS	; $871E


PRG027_EndingTrainCredText:
	LDA <EndTrainText_NxtLnDelay
	BEQ PRG027_8735	; If EndTrainText_NxtLnDelay = 0, jump to PRG027_8735

	DEC <EndTrainText_NxtLnDelay	; EndTrainText_NxtLnDelay--
	BNE PRG027_871E	; If EndTrainText_NxtLnDelay > 0, jump to PRG027_871E (RTS)


PRG027_TrainTextClear:
	LDY #(PRG027_TrainTextClearGBuf_End - PRG027_TrainTextClearGBuf - 1)

	; Copy in graphics buffer to clear text on the train
PRG027_8729:
	LDA PRG027_TrainTextClearGBuf,Y
	STA Graphics_Buffer+$00,Y
	DEY
	BPL PRG027_8729

	STY <CommitGBuf_Flag	; CommitGBuf_Flag = $FF
	RTS	; $8734


PRG027_8735:
	LDY #$00	; Y = 0
	
	LDA [EndTrainText_TextPtrL],Y	; Get next character for train text
	
	CMP #$7F
	BEQ PRG027_875F	; If $7F (end of line, but not end of block), jump to PRG027_875F

	CMP #$FF
	BEQ PRG027_87A0	; If $FF (terminator), jump to PRG027_87A0

	LDA [EndTrainText_TextPtrL],Y	; Get next character for train text
	BPL PRG027_8778	; Only expected "negative" value here is going to be $B0... so if it's not that, jump to PRG027_8778

	; Expected if you get here, it's $B0

	STA <EndTrainText_NxtLnDelay	; EndTrainText_NxtLnDelay = $B0
	
	INY	; Next character
	
	; Starting next block...
	
	; Fetch new VRAM address
	LDA [EndTrainText_TextPtrL],Y
	STA <EndTrainText_VRAMHigh
	INY
	LDA [EndTrainText_TextPtrL],Y
	STA <EndTrainText_VRAMLow
	
	; Skipping past $B0 ender and VRAM address for new text
	LDA <EndTrainText_TextPtrL
	ADD #$03
	STA <EndTrainText_TextPtrL
	LDA <EndTrainText_TextPtrH
	ADC #$00
	STA <EndTrainText_TextPtrH
	
	RTS	; $875E


PRG027_875F:
	; Line break ($7F) hit

	INY	; Move passed $7F
	
	; Fetch new VRAM address
	LDA [EndTrainText_TextPtrL],Y
	STA <EndTrainText_VRAMHigh
	INY
	LDA [EndTrainText_TextPtrL],Y
	STA <EndTrainText_VRAMLow
	
	; Skipping past $7F and VRAM address for new text
	LDA <EndTrainText_TextPtrL
	ADD #$03
	STA <EndTrainText_TextPtrL
	LDA <EndTrainText_TextPtrH
	ADC #$00
	STA <EndTrainText_TextPtrH
	
	LDY #$00	; Y = 0
PRG027_8778:
	; Store text VRAM pos
	LDA <EndTrainText_VRAMHigh
	STA Graphics_Buffer+$00
	LDA <EndTrainText_VRAMLow
	STA Graphics_Buffer+$01
	
	STY Graphics_Buffer+$02	; $00 (1 byte)
	
	; Character to write
	LDA [EndTrainText_TextPtrL],Y
	STA Graphics_Buffer+$03
	
	; Terminate and commit graphics buffer
	LDA #$FF
	STA Graphics_Buffer+$04
	STA <CommitGBuf_Flag
	
	; Next VRAM address (not 16-bit, not important for way ending works, but note)
	INC <EndTrainText_VRAMLow
	
	; Next character...
	LDA <EndTrainText_TextPtrL
	ADD #$01
	STA <EndTrainText_TextPtrL
	LDA <EndTrainText_TextPtrH
	ADC #$00
	STA <EndTrainText_TextPtrH

PRG027_87A0:
	RTS	; $87A0


PRG027_MoveTrainPoles:
	LDX #$00	; $87A1

PRG027_87A3:
	LDA Spr_Var1+$00,X
	BNE PRG027_87B5	; If Var1 is non-zero, jump to PRG027_87B5

	JSR PRG063_ApplyXVelocity	; Apply X velocity to train poles

	LDA Spr_XHi+$00,X
	BEQ PRG027_87C2	; If on-screen, jump to PRG027_87C2

	; Otherwise reset Var1 to $8D
	LDA #$8D
	STA Spr_Var1+$00,X

PRG027_87B5:
	DEC Spr_Var1+$00,X	; Var1--
	BNE PRG027_87C2	; If Var1 > 0, jump to PRG027_87C2

	; Reset pole position
	LDA #$00
	STA Spr_X+$00,X
	STA Spr_XHi+$00,X

PRG027_87C2:
	INX
	INX
	CPX #$04
	BNE PRG027_87A3	; Loop for other pole

	RTS	; $87C8


PRG027_EndingWilyShipXFlutter:
	LDA <General_Counter
	LSR A
	LSR A
	LSR A
	LSR A
	AND #$03
	TAY	; Y = 0 to 3
	
	; Move Wily ship X around a bit
	LDA Spr_X+$02
	ADD PRG027_EndingWilyShipOff,Y
	STA Spr_X+$02
	
	RTS	; $87DC


PRG027_EndingWilyShipYFlutter:
	LDA <General_Counter
	LSR A
	LSR A
	LSR A
	LSR A
	AND #$03
	TAY	; Y = 0 to 3

	; Move Wily ship Y around a bit
	LDA Spr_Y+$02
	ADD PRG027_EndingWilyShipOff,Y
	STA Spr_Y+$02

	RTS	; $87F0


PRG027_LoadGfxAndDrawScr_TMI13:
	; Layout select for intro sequence
	LDA #TMAP_INTROSTORY
	STA <TileMap_Index
	
	BNE PRG027_LoadGfxAndDrawScr


PRG027_LoadGfxAndDrawScr_TMI14:
	; Layout select for ending
	LDA #TMAP_ENDING
	STA <TileMap_Index

	; Disables display, loads graphics, enables display, fills screen
PRG027_LoadGfxAndDrawScr:
	JSR PRG062_DisableDisplay	; $87FB

	JSR PRG062_Upl_SprPal_CHRPats	; $87FE

	JSR PRG062_EnableDisplay	; $8801

	; Full screen update loop
	LDA #$00
	STA <ScreenUpd_CurCol
PRG027_8808:
	JSR PRG062_SetMBA_DrawColumn

	JSR PRG063_UpdateOneFrame

	INC <ScreenUpd_CurCol
	LDA <ScreenUpd_CurCol
	AND #$1F
	STA <ScreenUpd_CurCol
	BNE PRG027_8808

	LDA #$00	; $8818
	STA <Current_Screen	; $881A
	STA <Horz_Scroll	; $881C
	STA <PPU_CTL1_PageBaseReq	; $881E
	STA <Vert_Scroll	; $8820
	STA HUDBarP_DispSetting	; $8822
	STA HUDBarW_DispSetting	; $8825
	STA HUDBarB_DispSetting	; $8828
	
	RTS	; $882B


PRG027_EndingMtnToCityBG:
	LDA <Raster_VSplit_HPosReq	; $882C
	AND #$03	; $882E
	CMP #$03	; $8830
	BNE PRG027_8865	; $8832

	LDA <ScreenUpd_CurCol	; $8834
	LSR A	; $8836
	LSR A	; $8837
	LSR A	; $8838
	STA <MetaBlk_Index	; $8839
	LDA <ScreenUpd_CurCol	; $883B
	AND #$07	; $883D
	ASL A	; $883F
	ASL A	; $8840
	ASL A	; $8841
	ORA <MetaBlk_Index	; $8842
	STA <MetaBlk_Index	; $8844
	CMP #$18	; $8846
	BGE PRG027_8857	; $8848

	LDY #$00	; $884A
	LDA <CommitBG_ScrSel	; $884C
	AND #$01	; $884E
	BEQ PRG027_8854	; $8850

	LDY #$04	; $8852

PRG027_8854:
	JSR PRG063_E286	; $8854


PRG027_8857:
	DEC <ScreenUpd_CurCol	; $8857
	LDA <ScreenUpd_CurCol	; $8859
	AND #$3F	; $885B
	STA <ScreenUpd_CurCol	; $885D
	CMP #$3F	; $885F
	BNE PRG027_8865	; $8861

	DEC <CommitBG_ScrSel	; $8863

PRG027_8865:
	RTS	; $8865


	; Copy full palette in from PRG027_8875 based on input 'Y' (offset into palette table)
PRG027_CopyPalette_PRG027_8875:
	LDX #$00	; $8866

PRG027_8868:
	LDA PRG027_8875,Y
	STA PalData_2,X
	INY
	INX
	CPX #32
	BNE PRG027_8868

	RTS	; $8874


	; Palettes loaded by PRG027_CopyPalette_PRG027_8875
PRG027_8875:
	; $00
	.byte $0F, $20, $21, $1C, $0F, $20, $1A, $0A, $0F, $20, $2B, $1A, $0F, $20, $21, $1C	; $8875 - $8884
	.byte $0F, $0F, $16, $2C, $0F, $0F, $37, $27, $0F, $0F, $35, $15, $0F, $0F, $10, $11	; $8885 - $8894

	; $20
	.byte $0F, $30, $2C, $1C, $0F, $30, $10, $1C, $0F, $30, $2C, $1C, $0F, $30, $2C, $1C	; $8895 - $88A4
	.byte $0F, $0F, $2C, $11, $0F, $0F, $30, $37, $0F, $0F, $10, $00, $0F, $0F, $10, $11	; $88A5 - $88B4

	; $40
	.byte $0F, $30, $2C, $11, $0F, $36, $26, $16, $0F, $16, $26, $36, $0F, $16, $16, $16	; $88B5 - $88C4
	.byte $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F	; $88C5 - $88D4

	; $60
	.byte $0F, $20, $20, $20, $0F, $20, $20, $20, $0F, $20, $20, $20, $0F, $20, $20, $20	; $88D5 - $88E4
	.byte $0F, $0F, $20, $11, $0F, $0F, $0F, $0F, $0F, $0F, $20, $16, $0F, $0F, $0F, $0F	; $88E5 - $88F4

	; $80
	.byte $0F, $30, $31, $2C, $0F, $30, $0F, $31, $0F, $21, $31, $2B, $0F, $0F, $2A, $1A	; $88F5 - $8904
	.byte $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $20, $38, $36, $0F, $0F, $0F, $0F	; $8905 - $8914

	; $A0
	.byte $0F, $16, $11, $01, $0F, $20, $11, $01, $0F, $20, $37, $27, $0F, $20, $20, $20	; $8915 - $8924
	.byte $0F, $20, $11, $01, $0F, $20, $37, $27, $0F, $20, $24, $16, $0F, $20, $20, $20	; $8925 - $8934

	; $C0
	.byte $0F, $2C, $11, $01, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $20, $20, $20	; $8935 - $8944
	.byte $0F, $2C, $11, $01, $0F, $20, $37, $27, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F	; $8945 - $8954

	; $E0
	.byte $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $20, $10, $17, $0F, $20, $0F, $0F	; $8955 - $8964
	.byte $0F, $0F, $11, $01, $0F, $27, $37, $20, $0F, $0F, $37, $27, $0F, $0F, $2C, $11	; $8965 - $8974


	;
	; Train sequecne of ending, palettes and triggers...
	;
	
PRG027_PalTriggerScrHPos:
	; by Raster_VSplit_HPosReq
	.byte $FF, $C0, $80, $40, $FF, $C0, $80, $40, $FF, $C0, $80, $40, $FF, $C0, $FF, $FF
	.byte $80, $FF, $80, $FF

PRG027_PalTriggerScreen:
	; by MetaBlk_CurScreen
	.byte $09, $09, $09, $09, $08, $08, $08, $08, $07, $07, $07, $07, $06, $06, $03, $02
	.byte $02, $01, $01, $00

PRG027_TrainPalettes:
	.byte $0F, $30, $21, $11, $0F, $30, $21, $11, $0F, $20, $21, $11	; $00
	.byte $0F, $30, $22, $13, $0F, $30, $22, $13, $0F, $20, $22, $13	; $01
	.byte $0F, $30, $23, $14, $0F, $30, $23, $14, $0F, $20, $23, $14	; $02
	.byte $0F, $34, $24, $14, $0F, $34, $24, $14, $0F, $20, $24, $14	; $03
	.byte $0F, $25, $15, $06, $0F, $25, $15, $06, $0F, $20, $15, $06	; $04
	.byte $0F, $26, $16, $07, $0F, $26, $16, $07, $0F, $20, $16, $07	; $05
	.byte $0F, $27, $17, $07, $0F, $27, $17, $07, $0F, $20, $17, $07	; $06
	.byte $0F, $26, $16, $06, $0F, $26, $16, $06, $0F, $20, $16, $06	; $07
	.byte $0F, $25, $15, $05, $0F, $25, $15, $05, $0F, $20, $15, $05	; $08
	.byte $0F, $24, $15, $04, $0F, $24, $15, $04, $0F, $20, $15, $04	; $09
	.byte $0F, $23, $13, $03, $0F, $23, $13, $03, $0F, $20, $13, $03	; $0A
	.byte $0F, $12, $02, $01, $0F, $12, $13, $01, $0F, $20, $13, $01	; $0B
	.byte $0F, $11, $01, $0C, $0F, $11, $01, $0C, $0F, $20, $01, $0C	; $0C
	.byte $0F, $20, $0C, $27, $0F, $20, $0C, $22, $0F, $20, $0C, $23	; $0D
	.byte $0F, $20, $01, $27, $0F, $20, $01, $23, $0F, $20, $01, $0C	; $0E
	.byte $0F, $21, $11, $27, $0F, $21, $11, $01, $0F, $20, $11, $01	; $0F
	.byte $0F, $31, $11, $01, $0F, $31, $11, $01, $0F, $20, $11, $01	; $10
	.byte $0F, $20, $21, $11, $0F, $20, $21, $11, $0F, $20, $21, $11	; $11
	.byte $0F, $20, $21, $1C, $0F, $21, $1B, $0B, $0F, $20, $21, $1C	; $12
	.byte $0F, $20, $21, $16, $0F, $21, $1A, $0A, $0F, $20, $21, $1C	; $13

PRG027_TrainSepiaPal:
	.byte $0F, $36, $27, $17, $0F, $36, $27, $17, $0F, $27, $17, $07, $0F, $36, $27, $17	; $8A8D - $8A9C
	.byte $0F, $0F, $17, $07, $0F, $0F, $36, $27, $0F, $0F, $27, $36, $0F, $0F, $17, $27	; $8A9D - $8AAC

PRG027_TrainRushRollPal:
	.byte $0F, $0F, $28, $37, $0F, $0F, $16, $20

PRG027_EndingWilyShipOff:
	.byte $FF, $01, $01, $FF
	
PRG027_EndingTrainPoleYXHiInit:
	; Y, XHi
	.byte $84, $00
	.byte $48, $01

PRG027_EndingTrainPoleInit:
	; Animation, Var1
	.byte SPRANM1_TRAINPOLEF, $00
	.byte SPRANM1_TRAINPOLEB, $08
	
	; Graphics buffer data to clear train text
PRG027_TrainTextClearGBuf:
	vaddr $222B
	.byte $0A
	
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	
	vaddr $224B
	.byte $0A
	
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	
	vaddr $226B
	.byte $0A
	
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	
	.byte $FF
PRG027_TrainTextClearGBuf_End


PRG027_EndingTrainCreditText:

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; ENDING TRAIN CREDITS
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	vaddr $224C
	;       P    L    A    N    N    E    R 
	.byte $19, $15, $0A, $17, $17, $0E, $1B
	.byte $B0

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	vaddr $224D
	;       B    A    M    B    O    O
	.byte $0B, $0A, $16, $0B, $18, $18
	.byte $B0

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	vaddr $222C
	;       S    .    K    O    B    A    S    H    I
	.byte $1C, $24, $14, $18, $0B, $0A, $1C, $11, $12
	.byte $7F
	
	vaddr $226C
	;       I    N    A    F    K    I    N    G
	.byte $12, $17, $0A, $0F, $14, $12, $17, $10
	.byte $B0

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	vaddr $222B
	;       O    B    J    E    C    T
	.byte $18, $0B, $13, $0E, $0C, $1D
	.byte $7F
	
	vaddr $226C
	;       D    E    S    I    G    N    E    R
	.byte $0D, $0E, $1C, $12, $10, $17, $0E, $1B
	.byte $B0

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	vaddr $222C
	;       T    O    S    H    I    C    H    A    N
	.byte $1D, $18, $1C, $11, $12, $0C, $11, $0A, $17
	.byte $7F
	
	vaddr $226E
	;       Z    I    Z    I
	.byte $23, $12, $23, $12
	.byte $B0

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	vaddr $222C
	;       K    .    H    A    Y    A    T    O
	.byte $14, $24, $11, $0A, $22, $0A, $1D, $18
	.byte $7F
	
	vaddr $226E
	;       I    K    K    I
	.byte $12, $14, $14, $12
	.byte $B0

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	vaddr $222B
	;       S    C    R    O    L    L
	.byte $1C, $0C, $1B, $18, $15, $15
	.byte $7F
	
	vaddr $226C
	;       D    E    S    I    G    N    E    R
	.byte $0D, $0E, $1C, $12, $10, $17, $0E, $1B
	.byte $B0

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	vaddr $222C
	;       M    A    C    H    A    K    O
	.byte $16, $0A, $0C, $11, $0A, $14, $18
	.byte $7F
	
	vaddr $226C
	;       M    A    M    I    M    U    -
	.byte $16, $0A, $16, $12, $16, $1E, $25
	.byte $B0

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	vaddr $222C
	;       M    I    S    S    .    2    1
	.byte $16, $12, $1C, $1C, $24, $02, $01
	.byte $7F
	
	vaddr $226D
	;       T    A    K    A    p
	.byte $1D, $0A, $14, $0A, $19
	.byte $B0

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	vaddr $222B
	;       S    P    E    C    I    A    L
	.byte $1C, $19, $0E, $0C, $12, $0A, $15
	.byte $7F
	
	vaddr $226C
	;       D    E    S    I    G    N    E    R
	.byte $0D, $0E, $1C, $12, $10, $17, $0E, $1B
	.byte $B0

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	vaddr $222B
	;       Y    A    S    U    K    I    C    H    I
	.byte $22, $0A, $1C, $1E, $14, $12, $0C, $11, $12
	.byte $7F
	
	vaddr $226B
	;       I    N    A    F    K    I    N    G
	.byte $12, $17, $0A, $0F, $14, $12, $17, $10
	.byte $B0

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	vaddr $222B
	;       S    O    U    N    D
	.byte $1C, $18, $1E, $17, $0D
	.byte $7F
	
	vaddr $226C
	;       C    O    M    P    O    S    E    R
	.byte $0C, $18, $16, $19, $18, $1C, $0E, $1B
	.byte $B0

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	vaddr $222B
	;       O    J    A    L    I    N
	.byte $18, $13, $0A, $15, $12, $17
	.byte $7F
	
	vaddr $226B
	;       B    U    N         B    U    N
	.byte $0B, $1E, $17, $00, $0B, $1E, $17
	.byte $B0

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	vaddr $224B
	;       P    R    O    G    R    A    M    M    E    R
	.byte $19, $1B, $18, $10, $1B, $0A, $16, $16, $0E, $1B
	.byte $B0

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	vaddr $222E
	;       T    .    K
	.byte $1D, $24, $14
	.byte $7F
	
	vaddr $226B
	;       K    E    R    O         C    H    A    N
	.byte $14, $0E, $1B, $18, $00, $0C, $11, $0A, $17
	.byte $B0

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	.byte $FF
	

	; Star field sprites
PRG027_EndCredit_Starfield:
	.byte $38, $00, $00, $70
	.byte $B8, $00, $00, $58
	.byte $B8, $00, $00, $F8
	.byte $18, $01, $00, $38
	.byte $18, $01, $00, $B8
	.byte $58, $01, $00, $18
	.byte $58, $01, $00, $A8
	.byte $90, $01, $00, $78
	.byte $90, $01, $00, $E8
	.byte $E0, $01, $00, $50
	.byte $E0, $01, $00, $C8
PRG027_EndCredit_Starfield_End	


	; Template for a new line in the final credit roll
PRG027_EndCredit_LineTempl:
	; Video address base, to be patched
	vaddr $2000
	.byte $1F

	; All blanks, to be patched
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	
	.byte $FF
PRG027_EndCredit_LineTempl_End

PRG027_8C4B:
	.byte $0F, $0F, $2C, $11, $0F, $0F, $30, $37
	.byte $0F, $0F, $20, $26, $0F, $0F, $20, $29
	.byte $0F, $0F, $38, $29, $0F, $0F, $27, $2C
	.byte $0F, $0F, $20, $16, $0F, $0F, $20, $10
	.byte $0F, $0F, $20, $27, $0F, $20, $2C, $11
	.byte $0F, $0F, $28, $16, $0F, $0F, $20, $29
	.byte $0F, $0F, $20, $10, $0F, $0F, $20, $21
	.byte $0F, $0F, $20, $1C, $0F, $0F, $20, $16
	.byte $0F, $0F, $20, $16, $0F, $0F, $20, $10

PRG027_EndCHRSelPerRobotMaster:
	.byte $2D, $2E, $2B, $2C, $27, $29, $2A, $28


PRG027_EndCredit_BrightMan:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; BRIGHT MAN ending credit
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	vaddr $2190
	.byte $04
	
	;       N    O    .    2    5
	.byte $8D, $8E, $F9, $F1, $F4
	
	vaddr $21D0
	.byte $09
	
	;       B    R    I    G    H    T         M    A    N
	.byte $81, $91, $88, $86, $87, $93, $9A, $8C, $80, $8D
	
	vaddr $2210
	.byte $08
	
	;       Y    O    S    H    I    T    A    K    A
	.byte $98, $8E, $92, $87, $88, $93, $80, $8A, $80
	
	vaddr $2230
	.byte $06
	
	;       E    N    O    M    O    T    O
	.byte $84, $8D, $8E, $8C, $8E, $93, $8E
	
	.byte $FF

	
PRG027_EndCredit_ToadMan:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; TOAD MAN ending credit
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	vaddr $2190
	.byte $04
	
	;       N    O    .    2    9
	.byte $8D, $8E, $F9, $F1, $F8
	
	vaddr $21D0
	.byte $07
	
	;       T    O    A    D         M    A    N
	.byte $93, $8E, $80, $83, $9A, $8C, $80, $8D
	
	vaddr $2210
	.byte $06
	
	;       A    T    S    U    S    H    I
	.byte $80, $93, $92, $94, $92, $87, $88
	
	vaddr $2230
	.byte $06
	
	;       O    O    T    S    U    K    A
	.byte $8E, $8E, $93, $92, $94, $8A, $80
	
	.byte $FF


PRG027_EndCredit_DrillMan:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; DRILL MAN ending credit
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	vaddr $2190
	.byte $04
	
	;       N    O    .    2    7
	.byte $8D, $8E, $F9, $F1, $F6
	
	vaddr $21D0
	.byte $08
	
	;       D    R    I    L    L         M    A    N
	.byte $83, $91, $88, $8B, $8B, $9A, $8C, $80, $8D
	
	vaddr $2210
	.byte $07
	
	;       M    A    S    A    Y    U    K    I
	.byte $8C, $80, $92, $80, $98, $94, $8A, $88
	
	vaddr $2230
	.byte $04
	
	;       H    O    S    H    I
	.byte $87, $8E, $92, $87, $88
	
	.byte $FF


PRG027_EndCredit_PharaohMan:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; PHARAOH MAN ending credit
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	vaddr $2190
	.byte $04
	
	;       N    O    .    2    6
	.byte $8D, $8E, $F9, $F1, $F5
	
	vaddr $21D0
	.byte $0A
	
	;       P    H    A    R    A    O    H         M    A    N
	.byte $8F, $87, $80, $91, $80, $8E, $87, $9A, $8C, $80, $8D
	
	vaddr $2210
	.byte $07
	
	;       T    A    K    A    Y    U    K    I
	.byte $93, $80, $8A, $80, $98, $94, $8A, $88
	
	vaddr $2230
	.byte $04
	
	;       E    B    A    R    A
	.byte $84, $81, $80, $91, $80
	
	.byte $FF
	
	
PRG027_EndCredit_RingMan:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; RING MAN ending credit
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	vaddr $2190
	.byte $04
	
	;       N    O    .    2    8
	.byte $8D, $8E, $F9, $F1, $F7
	
	vaddr $21D0
	.byte $07
	
	;       R    I    N    G         M    A    N
	.byte $91, $88, $8D, $86, $9A, $8C, $80, $8D
	
	vaddr $2210
	.byte $05
	
	;       H    I    R    O    M    I
	.byte $87, $88, $91, $8E, $8C, $88
	
	vaddr $2230
	.byte $05
	
	;       U    C    H    I    D    A
	.byte $94, $82, $87, $88, $83, $80
	
	.byte $FF
	
	
PRG027_EndCredit_DustMan:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; DUST MAN ending credit
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	vaddr $2190
	.byte $04
	
	;       N    O    .    3    0
	.byte $8D, $8E, $F9, $F2, $8E
	
	vaddr $21D0
	.byte $07
	
	;       D    U    S    T         M    A    N
	.byte $83, $94, $92, $93, $9A, $8C, $80, $8D
	
	vaddr $2210
	.byte $06
	
	;       Y    U    U    S    U    K    E
	.byte $98, $94, $94, $92, $94, $8A, $84
	
	vaddr $2230
	.byte $05
	
	;       M    U    R    A    T    A
	.byte $8C, $94, $91, $80, $93, $80
	
	.byte $FF
	

PRG027_EndCredit_DiveMan:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; DIVE MAN ending credit
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	vaddr $2190
	.byte $04
	
	;       N    O    .    3    1
	.byte $8D, $8E, $F9, $F2, $F0
	
	vaddr $21D0
	.byte $07
	
	;       D    I    V    E         M    A    N
	.byte $83, $88, $95, $84, $9A, $8C, $80, $8D
	
	vaddr $2210
	.byte $05
	
	;       S    U    G    U    R    U
	.byte $92, $94, $86, $94, $91, $94
	
	vaddr $2230
	.byte $07
	
	;       N    A    K    A    Y    A    M    A
	.byte $8D, $80, $8A, $80, $98, $80, $8C, $80
	
	.byte $FF
	
	
PRG027_EndCredit_SkullMan:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; SKULL MAN ending credit
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	vaddr $2190
	.byte $04
	
	;       N    O    .    3    2
	.byte $8D, $8E, $F9, $F2, $F1
	
	vaddr $21D0
	.byte $08
	
	;       S    K    U    L    L         M    A    N
	.byte $92, $8A, $94, $8B, $8B, $9A, $8C, $80, $8D
	
	vaddr $2210
	.byte $08
	
	;       T    O    S    H    I    Y    U    K    I
	.byte $93, $8E, $92, $87, $88, $98, $94, $8A, $88
	
	vaddr $2230
	.byte $06
	
	;       M    I    Y    A    C    H    I
	.byte $8C, $88, $98, $80, $82, $87, $88
	
	.byte $FF
	
	
	
PRG027_EndCredit_ClearRMaster:
	vaddr $2190
	.byte $04
	.byte $9A, $9A, $9A, $9A, $9A
	
	vaddr $21D0
	.byte $0A
	.byte $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A
	
	vaddr $2210
	.byte $0A
	.byte $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A
	
	vaddr $2230
	.byte $0A
	.byte $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A
	
	.byte $FF

PRG027_EndTextStaff:
	vaddr $21AD
	.byte $04
	
	;       S    T    A    F    F
	.byte $92, $93, $80, $85, $85
	
	.byte $FF
	

PRG027_EndTextStaffClear:
	vaddr $21AD
	.byte $04
	
	.byte $9A, $9A, $9A, $9A, $9A
	
	.byte $FF
	

PRG027_8E26:
	.byte LOW(PRG027_EndCredit_BrightMan)
	.byte LOW(PRG027_EndCredit_ToadMan)
	.byte LOW(PRG027_EndCredit_DrillMan)
	.byte LOW(PRG027_EndCredit_PharaohMan)
	.byte LOW(PRG027_EndCredit_RingMan)
	.byte LOW(PRG027_EndCredit_DustMan)
	.byte LOW(PRG027_EndCredit_DiveMan)
	.byte LOW(PRG027_EndCredit_SkullMan)

PRG027_8E2E:
	.byte HIGH(PRG027_EndCredit_BrightMan)
	.byte HIGH(PRG027_EndCredit_ToadMan)
	.byte HIGH(PRG027_EndCredit_DrillMan)
	.byte HIGH(PRG027_EndCredit_PharaohMan)
	.byte HIGH(PRG027_EndCredit_RingMan)
	.byte HIGH(PRG027_EndCredit_DustMan)
	.byte HIGH(PRG027_EndCredit_DiveMan)
	.byte HIGH(PRG027_EndCredit_SkullMan)


PRG027_DoIntroStory:
	LDA #$00	; $8E36
	STA <DisFlag_NMIAndDisplay	; $8E38
	JSR PRG062_PalFadeOut	; $8E3A

	LDA #$04	; $8E3D
	STA <Sprite_CurrentIndex	; $8E3F
	JSR PRG062_ResetSprites	; $8E41

	JSR PRG062_ClearSpriteSlots	; $8E44

	JSR PRG063_UpdateOneFrame	; $8E47

	; Black background for the "AD 200X"
	LDA #$05	; Screen 5 of current layout index
	STA <MetaBlk_CurScreen
	LDX #$55	; Font is contained in this graphics set
	JSR PRG027_LoadGfxAndDrawScr_TMI13

	; Load palette
	LDY #$60
	JSR PRG027_CopyPalette_PRG027_8875

	; Buffer "AD 200X"
	LDY #(PRG027_Intro_AD200X_End - PRG027_Intro_AD200X - 1)
PRG027_8E5A:
	LDA PRG027_Intro_AD200X,Y
	STA Graphics_Buffer+$00,Y
	DEY
	BPL PRG027_8E5A

	STY <CommitGBuf_Flag	; Commit graphics buffer
	JSR PRG063_UpdateOneFrame


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	; Just a delay before starting the intro
	LDX #$78
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	; Intro music!
	LDA #MUS_INTROSTORY
	JSR PRG063_QueueMusSnd_SetMus_Cur

	; Fade in...
	JSR PRG062_PalFadeIn

	; Delay for "AD 200X"
	LDX #$78
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	; Fade out...
	JSR PRG062_PalFadeOut
	JSR PRG063_UpdateOneFrame

	; Load city BG
	LDA #$00	; Screen 0 of current layout index
	STA <MetaBlk_CurScreen
	LDX #$55	; BG in this graphics set
	JSR PRG027_LoadGfxAndDrawScr_TMI13

	; Load city BG palette
	LDY #$80
	JSR PRG027_CopyPalette_PRG027_8875
	JSR PRG063_UpdateOneFrame	; $8E94

	; First line of story
	LDY #$00
	JSR PRG027_DrawNextIntroStoryLine

	; Fade in...
	JSR PRG062_PalFadeIn

	; Delay before story line
	LDX #$3C
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	; Fade in text
	JSR PRG027_FadeInText

	; Delay and fade in first story line
	LDX #$B4
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	; Draw next story line and fade it in
	LDY #$01	; Story block 2
	LDX #$3C
	JSR PRG027_DoNextStoryLine

	; Tint into night time
	LDX #$03
	LDY #$BA
PRG027_8EBD:
	TYA
	STA PalAnim_EnSel+$00,X
	
	LDA #$00
	STA PalAnim_CurAnimOffset+$00,X
	STA PalAnim_TickCount+$00,X
	
	DEY
	DEX
	BPL PRG027_8EBD
	
	; Delay after night time tint
	LDX #$78
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	; Draw next story line and fade it in
	LDY #$02	; Story block 3
	LDX #$B4
	JSR PRG027_DoNextStoryLine

	; Draw next story line and fade it in
	LDY #$03	; Story block 4
	LDX #$3C
	JSR PRG027_DoNextStoryLine

	; Init explosions
	LDX #$00
	JSR PRG027_InitStoryExplosion

	; Delay
	LDX #$28
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	; Init explosions
	LDX #$01
	JSR PRG027_InitStoryExplosion

	; Delay
	LDX #$28
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	; Init explosions
	LDX #$02
	JSR PRG027_InitStoryExplosion

	; Boom, boom, boom, boooom
	JSR PRG027_IntroExplodeSFXAndDelay

	; Draw next story line and fade it in
	LDY #$04	; Story block 5
	LDX #$14
	JSR PRG027_DoNextStoryLine

	; More booms
	JSR PRG027_IntroExplodeSFXAndDelay
	JSR PRG027_IntroExplodeSFXAndDelay
	JSR PRG027_IntroExplodeSFXAndDelay

	; Draw next story line and fade it in
	LDY #$05	; Story block 6
	LDX #$14
	JSR PRG027_DoNextStoryLine	; $8F19

	; More booms
	JSR PRG027_IntroExplodeSFXAndDelay
	JSR PRG027_IntroExplodeSFXAndDelay
	JSR PRG027_IntroExplodeSFXAndDelay

	; Fade out...
	JSR PRG062_PalFadeOut


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	; Clear out explosions
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites

	JSR PRG062_ClearSpriteSlots	; $8F2F

	JSR PRG063_UpdateOneFrame	; $8F32

	; Load Rock in the transformation tube thing
	LDA #$01	; Screen 1 of current layout index
	STA <MetaBlk_CurScreen
	LDX #$56	; Graphics set for Rock in the transformation tube thing
	JSR PRG027_LoadGfxAndDrawScr_TMI13

	; Palette for the transformation tube thing
	LDY #$A0
	JSR PRG027_CopyPalette_PRG027_8875

	LDX #$00	; X = 0 (first sprite slot)
	
	; Use Rock's intro sprites
	LDA #SPRSLOTID_CINESTUFF
	STA Spr_SlotID+$00
	STA Spr_SlotID+$01
	
	LDA #$80	; $8F4D
	STA Spr_Flags+$00	; $8F4F
	STA Spr_Flags+$01	; $8F52
	
	; Rock's face sprites overlay
	LDA #SPRANM1_ROCKFACE	; $8F55
	JSR PRG063_SetSpriteAnim	; $8F57

	; Y position of face
	LDA #$47	; $8F5A
	STA Spr_Y+$00	; $8F5C
	
	; X position of face and body
	LDA #$80
	STA Spr_X+$00
	STA Spr_X+$01
	
	LDA #$00	; $8F67
	STA Spr_YHi+$00	; $8F69
	STA Spr_XHi+$00	; $8F6C
	STA Spr_YHi+$01	; $8F6F
	STA Spr_XHi+$01	; $8F72
	
	INX	; X = 1 (second sprite slot)
	
	; Rock's body sprites overlay
	LDA #SPRANM1_BODY	; $8F76
	JSR PRG063_SetSpriteAnim	; $8F78

	; Y position of body
	LDA #$77
	STA Spr_Y+$01
	
	; Draw face and body overlay sprites
	JSR PRG063_DrawSprites_RsetSprIdx

	LDA #$00	; $8F83
	STA <DisFlag_NMIAndDisplay	; $8F85
	
	; Delay
	LDX #$60
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	; Fade in...
	JSR PRG062_PalFadeIn

	LDY #$06	; Story block 7
	LDX #$B4
	JSR PRG027_DoNextStoryLine

	LDY #$07	; Story block 8
	LDX #$14
	JSR PRG027_DoNextStoryLine

	; Transformation face start animation
	LDX #$00
	LDA #SPRANM1_ROCKTFACE
	JSR PRG063_SetSpriteAnim


PRG027_8FA7:
	; One frame update
	LDX #$01
	JSR PRG027_IntroDelayAndUpdFX

	LDA Spr_Frame+$00
	CMP #$07
	BNE PRG027_8FA7	; If Rock's transformation animation hasn't hit frame 7, jump to PRG027_8FA7

	; Transformation face during animation
	LDX #$00
	LDA #SPRANM1_ROCKTFACE2
	JSR PRG063_SetSpriteAnim


	; Transformation white flicker
	LDA #$00
	STA <Temp_Var8
	STA <Temp_Var9

PRG027_8FC0:
	LDY <Temp_Var8
	
	LDX #$00
PRG027_8FC4:
	LDA PRG027_948B,Y
	STA PalData_1,X	
	
	INY
	INX
	CPX #$20
	BNE PRG027_8FC4

	LDA #$FF
	STA <CommitPal_Flag
	CPY #$60
	BNE PRG027_8FDA

	LDY #$00
PRG027_8FDA:
	STY <Temp_Var8
	LDX #$01
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	DEC <Temp_Var9
	BNE PRG027_8FC0

	JSR PRG062_PalFadeOut


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites

	JSR PRG062_ClearSpriteSlots

	JSR PRG063_UpdateOneFrame

	; Load Rock waking up post-transformation tube thing
	LDA #$02
	STA <MetaBlk_CurScreen
	LDX #$56
	JSR PRG027_LoadGfxAndDrawScr_TMI13

	; Palette
	LDY #$C0
	JSR PRG027_CopyPalette_PRG027_8875

	; Use Rock's intro sprites
	LDX #$00
	LDA #SPRSLOTID_CINESTUFF
	STA Spr_SlotID+$00
	
	LDA #$80
	STA Spr_Flags+$00
	
	; Rock waking up eyelids flutter
	LDA #SPRANM1_ROCKWAKEUP1
	JSR PRG063_SetSpriteAnim

	; Y pos
	LDA #$8B
	STA Spr_Y+$00
	
	; X pos
	LDA #$80
	STA Spr_X+$00
	
	LDA #$00
	STA Spr_YHi+$00
	STA Spr_XHi+$00
	JSR PRG063_DrawSprites_RsetSprIdx	; $9029

	LDA #$00	; $902C
	STA <DisFlag_NMIAndDisplay	; $902E
	
	; Delay
	LDX #$78
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	; Fade in...
	JSR PRG062_PalFadeIn

	; Delay
	LDX #$F0
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	; Rock waking up opening eyes
	LDX #$00
	LDA #SPRANM1_ROCKWAKEUP2
	JSR PRG063_SetSpriteAnim


PRG027_904A:
	; One frame update
	LDX #$01
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	LDA Spr_Frame+$00
	CMP #$21
	BNE PRG027_904A	; If open eye frame <> $21, jump to PRG027_904A

	; Rock fully awake
	LDX #$00
	LDA #SPRANM1_ROCKWAKEUP3
	JSR PRG063_SetSpriteAnim

	; Delay
	LDX #$28
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	LDY #$00	; $9068


	; White out
PRG027_906A:
	LDX #$00	; $906A

PRG027_906C:
	LDA PRG027_94EB,Y
	STA PalData_1,X
	STA PalData_2,X
	STA PalData_1+16,X
	STA PalData_2+16,X
	INY
	INX
	CPX #$08
	BNE PRG027_906C

	LDA #$FF	; $9081
	STA <CommitPal_Flag	; $9083
	STY <Temp_Var8	; $9085
	
	; Delay
	LDX #$0A	; $9087
	JSR PRG027_IntroDelayAndUpdFX	; $9089
	JSR PRG027_PressStartToSkipIntro	; $908C

	LDY <Temp_Var8
	CPY #$20
	BNE PRG027_906A

	; Fade out
	JSR PRG062_PalFadeOut
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	; Clear out sprites
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites

	JSR PRG062_ClearSpriteSlots

	JSR PRG063_UpdateOneFrame

	; Train
	LDA #$03
	STA <MetaBlk_CurScreen
	
	; Delay
	LDX #$3C
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	; Delay more?
	LDX #$78
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	; Load train graphics
	LDX #$57
	JSR PRG027_LoadGfxAndDrawScr_TMI13
	LDY #$E0
	JSR PRG027_CopyPalette_PRG027_8875

	; Get sprites ready
	LDX #$00	; X = 0 (first sprite slot)
	LDA #SPRSLOTID_CINESTUFF
	STA Spr_SlotID+$00
	STA Spr_SlotID+$01
	STA Spr_SlotID+$02
	STA Spr_SlotID+$03
	
	LDA #$80
	STA Spr_Flags+$00
	STA Spr_Flags+$01
	STA Spr_Flags+$02
	STA Spr_Flags+$03
	
	; Set Rock's train head
	LDA #SPRANM1_ROCKTRAINHEAD
	JSR PRG063_SetSpriteAnim

	; Rock's head Y/X
	LDA #$4F
	STA Spr_Y+$00
	LDA #$7C
	STA Spr_X+$00
	
	; Clearing sprite data
	LDA #$00
	STA Spr_YHi+$00
	STA Spr_XHi+$00
	STA Spr_YHi+$01
	STA Spr_XHi+$01
	STA Spr_YHi+$02
	STA Spr_XHi+$02
	STA Spr_YHi+$03
	STA Spr_XHi+$03
	STA Spr_Var1+$02
	STA Spr_Var1+$03
	
	INX	; X = 1 (next sprite slot)
	
	; Set Rock's train body
	LDA #SPRANM1_ROCKTRAINBODY
	JSR PRG063_SetSpriteAnim

	; Rock's body Y/X
	LDA #$7F
	STA Spr_Y+$01
	LDA #$80
	STA Spr_X+$01
	
	INX	; X = 2 (next sprite slot)
	
	; One train BG light
	LDA #SPRANM1_TRAINBGLIGHTS
	JSR PRG063_SetSpriteAnim

	; BG light 1 X
	LDA #$40
	STA Spr_X+$02
	
	INX	; X = 3 (next sprite slot)
	
	; Another train BG light
	LDA #SPRANM1_TRAINBGLIGHTS
	JSR PRG063_SetSpriteAnim	; $912E

	; BG light 2 X
	LDA #$C0
	STA Spr_X+$03
	
	; Train BG light Y
	LDA #$2B
	STA Spr_Y+$02
	STA Spr_Y+$03
	
	; Draw sprites
	JSR PRG063_DrawSprites_RsetSprIdx

	LDA #$00
	STA <DisFlag_NMIAndDisplay
	
	; Fade in
	JSR PRG062_PalFadeIn

	; Music change!
	LDA #MUS_INTROSTORYTRAIN
	JSR PRG063_QueueMusSnd_SetMus_Cur

	LDY #$08	; Story block 9
	LDX #$B4
	JSR PRG027_DoNextStoryLine

	LDY #$09	; Story block 10
	LDX #$B4
	JSR PRG027_DoNextStoryLine

	LDA #$BB	; $915B
	STA PalAnim_EnSel+$00	; $915D
	LDA #$BC	; $9160
	STA PalAnim_EnSel+$01	; $9162
	LDA #$BD	; $9165
	STA PalAnim_EnSel+$03	; $9167

	LDX #$00	; $916A
	STX PalAnim_CurAnimOffset+$00	; $916C
	STX PalAnim_TickCount+$00	; $916F
	STX PalAnim_CurAnimOffset+$01	; $9172
	STX PalAnim_TickCount+$01	; $9175
	STX PalAnim_CurAnimOffset+$03	; $9178
	STX PalAnim_TickCount+$03	; $917B
	
	; Clear train lights
	STX Spr_SlotID+$02	; $917E
	STX Spr_SlotID+$03	; $9181
	
	
	LDA PRG027_950B
	STA PalData_1+18
	LDA PRG027_950C
	STA PalData_1+22
	LDA PRG027_950D
	STA PalData_1+26
	LDA PRG027_950E
	STA PalData_1+30
	
	LDA #$FF	; $919C
	STA <CommitPal_Flag	; $919E
	
	; Rock changes to determined face
	LDA #SPRANM1_ROCKTRAINHEAD2
	JSR PRG063_SetSpriteAnim

	; Configure train's raster effect
	LDA #$80
	STA <Raster_VSplit_Req
	LDA #RVMODE_INTROTRAIN1
	STA <Raster_VMode

PRG027_91AD:
	; Update one frame
	LDX #$01
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	LDA PalAnim_EnSel+$00	; $91B5
	BMI PRG027_91AD	; $91B8

	; Rock hold determined face
	LDX #$00
	LDA #SPRANM1_ROCKTRAINHEAD3
	JSR PRG063_SetSpriteAnim

	LDY #$0A	; Story block 11
	LDX #$B4
	JSR PRG027_DoNextStoryLine

	LDY #$0B	; Story block 12
	LDX #$B4
	JSR PRG027_DoNextStoryLine

	LDY #$0C	; Story block 13
	LDX #$B4
	JSR PRG027_DoNextStoryLine

	; Delay
	LDX #$3C
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	; Rock puts on helmet
	LDX #$00
	LDA #SPRANM1_ROCKTRAINHEAD4
	JSR PRG063_SetSpriteAnim


PRG027_91E5:
	; Update one frame
	LDX #$01
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	LDA Spr_Frame+$00
	CMP #$07
	BNE PRG027_91E5	; If helmet donning animation frame <> 7, jump to PRG027_91E5

	; Holding helmet animation
	LDX #$00
	LDA #SPRANM1_ROCKTRAINHEAD5
	JSR PRG063_SetSpriteAnim

	; Rock raises up arm
	LDX #$01
	LDA #SPRANM1_ROCKTRAINBODY2
	JSR PRG063_SetSpriteAnim


PRG027_9202:
	; Update one frame
	LDX #$01
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	LDA Spr_Frame+$01
	CMP #$02
	BNE PRG027_9202	; If arm lift frame <> 2, jump to PRG027_9202

	; Hold arm up
	LDX #$01
	LDA #SPRANM1_ROCKTRAINBODY3
	JSR PRG063_SetSpriteAnim

	; delay
	LDX #$78
	JSR PRG027_IntroDelayAndUpdFX
	JSR PRG027_PressStartToSkipIntro

	LDA #MUS_PARTIALMUTE
	JSR PRG063_QueueMusSnd_SetMus_Cur

	; Change to train depart effect
	LDA #RVMODE_INTROTRAIN2
	STA <Raster_VMode
	
	; Delay
	LDX #$B4
	JSR PRG027_IntroDelayAndUpdFX
	
	; Fade out...
	JSR PRG062_PalFadeOut

PRG027_9231:
	; NOTE: If player presses START during intro, it jumps here

	; Reset raster effect
	LDA #$00
	STA <Raster_VMode
	STA PalAnim_EnSel+$00
	STA PalAnim_EnSel+$01
	STA PalAnim_EnSel+$02
	STA PalAnim_EnSel+$03
	
	
	LDY #$1F
PRG027_9243:
	LDA PalData_1,Y
	STA PalData_2,Y
	DEY
	BPL PRG027_9243

	LDX #$3C
	JMP PRG027_IntroDelayAndUpdFX	; And that's it for the intro!!


PRG027_PressStartToSkipIntro:
	LDA <Ctlr1_Held
	AND #PAD_START
	BEQ PRG027_925F

	; Don't return to caller, jump to PRG027_9231 instead
	PLA
	PLA
	LDA #HIGH(PRG027_9231-1)
	PHA
	LDA #LOW(PRG027_9231-1)
	PHA

PRG027_925F:
	RTS	; $925F

	; CHECKME - UNUSED?
	; $9260
	LDA #$03
	STA <Temp_Var8
	
PRG027_9264:
	LDA #$42
	JSR PRG063_QueueMusSnd
	
	LDX #$14
	JSR PRG027_IntroDelayAndUpdFX
	
	LDA <Ctlr1_Held
	AND #PAD_START
	BNE PRG027_9278
	
	DEC <Temp_Var8
	BNE PRG027_9264
	
PRG027_9278:
	RTS



	; Scrolling the train BG lights
PRG027_IntroTrainBGLights:
	TXA	; $9279
	PHA	; $927A
	LDX #$02	; $927B

PRG027_927D:
	LDA Spr_Var1+$00,X	; $927D
	BEQ PRG027_928C	; $9280

	DEC Spr_Var1+$00,X	; $9282
	BNE PRG027_92A4	; $9285

	LDA #SPRANM1_TRAINBGLIGHTS	; $9287
	JSR PRG063_SetSpriteAnim	; $9289


PRG027_928C:
	LDA Spr_X+$00,X	; $928C
	ADD #$08	; $928F
	STA Spr_X+$00,X	; $9292
	BCC PRG027_92A4	; $9295

	LDA #$00	; $9297
	STA Spr_X+$00,X	; $9299
	JSR PRG063_SetSpriteAnim	; $929C

	LDA #$1E	; $929F
	STA Spr_Var1+$00,X	; $92A1

PRG027_92A4:
	INX	; $92A4
	CPX #$04	; $92A5
	BNE PRG027_927D	; $92A7

	LDA <General_Counter	; $92A9
	LSR A	; $92AB
	AND #$01	; $92AC
	ASL A	; $92AE
	ASL A	; $92AF
	TAY	; $92B0
	LDA PRG027_950B,Y	; $92B1
	STA PalData_1+18	; $92B4
	LDA PRG027_950C,Y	; $92B7
	STA PalData_1+22	; $92BA
	LDA PRG027_950D,Y	; $92BD
	STA PalData_1+26	; $92C0
	LDA PRG027_950E,Y	; $92C3
	STA PalData_1+30	; $92C6
	LDA #$FF	; $92C9
	STA <CommitPal_Flag	; $92CB
	PLA	; $92CD
	TAX	; $92CE
	RTS	; $92CF


PRG027_DoNextStoryLine:
	STY <Temp_Var9	; $92D0
	STX <Temp_Var10	; $92D2
	JSR PRG027_93F1	; $92D4

	LDX #$3C	; $92D7
	JSR PRG027_IntroDelayAndUpdFX	; $92D9

	LDA <Ctlr1_Held	; $92DC
	AND #PAD_START	; $92DE
	BNE PRG027_92EF	; $92E0

	LDY <Temp_Var9	; $92E2
	JSR PRG027_DrawNextIntroStoryLine	; $92E4

	JSR PRG027_FadeInText	; $92E7

	LDX <Temp_Var10	; $92EA
	JMP PRG027_IntroDelayAndUpdFX	; $92EC


PRG027_92EF:
	RTS	; $92EF


	; 'X' is 0 to 2
PRG027_InitStoryExplosion:
	LDA #$60	; $92F0
	STA Spr_SlotID+$00,X	; $92F2
	LDA #$80	; $92F5
	STA Spr_Flags+$00,X	; $92F7
	
	LDA PRG027_9482,X	; $92FA
	JSR PRG063_SetSpriteAnim	; $92FD

	LDA PRG027_9485,X	; $9300
	STA Spr_Y+$00,X	; $9303

	LDA PRG027_9488,X	; $9306
	STA Spr_X+$00,X	; $9309

	LDA #$00	; $930C
	STA Spr_YHi+$00,X	; $930E
	STA Spr_XHi+$00,X	; $9311
	
	LDA #SFX_BIGEXPLOSION	; $9314
	JMP PRG063_QueueMusSnd	; $9316


	; 4 loops of explosion sound effect and delay
PRG027_IntroExplodeSFXAndDelay:
	LDA #$04	; $9319
	STA <Temp_Var8	; $931B

PRG027_931D:
	LDA #SFX_BIGEXPLOSION	; $931D
	JSR PRG063_QueueMusSnd	; $931F

	LDA <Ctlr1_Held	; $9322
	AND #PAD_START
	BNE PRG027_9331	; $9326

	; Delay explosion loop
	LDX #$14	; $9328
	JSR PRG027_IntroDelayAndUpdFX	; $932A

	DEC <Temp_Var8	; $932D
	BNE PRG027_931D	; $932F


PRG027_9331:
	RTS	; $9331


PRG027_IntroDelayAndUpdFX:
	STX <Temp_Var15	; Ticks for this segment

PRG027_9334:
	LDA Spr_SlotID+$03
	BEQ PRG027_933C		; If the train BG lights aren't active, jump to PRG027_933C

	; It's assumed as part of the intro that a sprite being in slot index 3 should be scrolled (the train lights)
	JSR PRG027_IntroTrainBGLights

PRG027_933C:
	
	LDA <Raster_VMode
	CMP #RVMODE_INTROTRAIN1
	BLT PRG027_9376	; If Raster_VMode < RVMODE_INTROTRAIN1 (not doing the rapid scrolling sky during the train part of the intro), jump to PRG027_9376

	LDA <Raster_VSplit_HPosReq
	SUB #$10
	STA <Raster_VSplit_HPosReq
	
	LDA <Raster_VMode
	CMP #RVMODE_INTROTRAIN2
	BNE PRG027_9376	; If Raster_VMode <> RVMODE_INTROTRAIN2 (train is not yet rolling away), jump to PRG027_9376

	; Roll train away
	LDA <Horz_Scroll
	ADD #$08
	STA <Horz_Scroll
	
	; Push Rock's head away to the left
	LDA Spr_X+$00
	SUB #$08
	STA Spr_X+$00
	BCS PRG027_9366

	; If Rock's head's been pushed off, clear the sprite
	LDA #$00
	STA Spr_SlotID+$00

PRG027_9366:

	; Push Rock's body away to the left
	LDA Spr_X+$01
	SUB #$08
	STA Spr_X+$01
	BCS PRG027_9376

	; If Rock's body's been pushed off, clear the sprite
	LDA #$00
	STA Spr_SlotID+$01

PRG027_9376:
	JSR PRG063_DrawSprites_RsetSprIdx

	LDA <Ctlr1_Held
	AND #PAD_START
	BNE PRG027_9383

	DEC <Temp_Var15
	BNE PRG027_9334


PRG027_9383:
	LDA #$00	; $9383
	STA <DisFlag_NMIAndDisplay	; $9385
	
	RTS	; $9387


PRG027_DrawNextIntroStoryLine:
	; Load pointer to start of next line of story
	LDA PRG027_IntroStoryTextTable_L,Y
	STA <Temp_Var0
	LDA PRG027_IntroStoryTextTable_H,Y
	STA <Temp_Var1
	
	; Clear all previous text
	LDY #(PRG027_Intro_ClearText_End - PRG027_Intro_ClearText - 1)
PRG027_9394:
	LDA PRG027_Intro_ClearText,Y
	STA Graphics_Buffer+$00,Y
	DEY
	BPL PRG027_9394

	LDY #$00
	STY <Temp_Var2
	
	LDX #$03	; 'X' is graphics buffer offset (after previous loop filled in all blanks)
PRG027_93A3:
	LDA [Temp_Var0],Y
	CMP #$FF
	BEQ PRG027_93BF	; If terminator for this story block, jump to PRG027_93BF

	CMP #$FD
	BEQ PRG027_93B4	; If line break in this story line, jump to PRG027_93B4

	; Otherwise, store next character
	STA Graphics_Buffer+$00,X
	
	INY
	INX
	BNE PRG027_93A3


PRG027_93B4:
	INY
	
	; Next line
	LDX <Temp_Var2
	INC <Temp_Var2
	
	; Load graphics buffer offset for next line
	LDA PRG027_IntroGBufLineOffset,X
	TAX
	
	BNE PRG027_93A3		; (Technically always) loop


PRG027_93BF:
	STA <CommitGBuf_Flag	; Commit graphics buffer
	
	RTS	; $93C1


PRG027_FadeInText:
	LDA #$40	; $93C2
	STA <Temp_Var8	; $93C4
	LDA #$30	; $93C6
	STA PalData_2+13	; $93C8

PRG027_93CB:
	LDA PalData_2+13	; $93CB
	SUB <Temp_Var8	; $93CE
	BCS PRG027_93D5	; $93D1

	LDA #$0F	; $93D3

PRG027_93D5:
	STA PalData_1+13	; $93D5
	LDA #$FF	; $93D8
	STA <CommitPal_Flag	; $93DA
	LDX #$0A	; $93DC
	JSR PRG027_IntroDelayAndUpdFX	; $93DE

	LDA <Ctlr1_Held	; $93E1
	AND #PAD_START
	BNE PRG027_93F0	; $93E5

	LDA <Temp_Var8	; $93E7
	SUB #$10	; $93E9
	STA <Temp_Var8	; $93EC
	BCS PRG027_93CB	; $93EE


PRG027_93F0:
	RTS	; $93F0


PRG027_93F1:
	LDA #$00	; $93F1
	STA <Temp_Var8	; $93F3
	LDA #$30	; $93F5
	STA PalData_2+13	; $93F7

PRG027_93FA:
	LDA PalData_2+13	; $93FA
	SUB <Temp_Var8	; $93FD
	BCS PRG027_9404	; $9400

	LDA #$0F	; $9402

PRG027_9404:
	STA PalData_1+13	; $9404
	LDA #$FF	; $9407
	STA <CommitPal_Flag	; $9409
	LDX #$0A	; $940B
	JSR PRG027_IntroDelayAndUpdFX	; $940D

	LDA <Ctlr1_Held	; $9410
	AND #$10	; $9412
	BNE PRG027_9421	; $9414

	LDA <Temp_Var8	; $9416
	ADD #$10	; $9418
	STA <Temp_Var8	; $941B
	CMP #$50	; $941D
	BNE PRG027_93FA	; $941F


PRG027_9421:
	RTS	; $9421


PRG027_Intro_AD200X:	
	vaddr $218C
	.byte $06
	
	;       A    D         2    0    0    X
	.byte $0A, $0D, $00, $02, $18, $18, $21
	
	.byte $FF
PRG027_Intro_AD200X_End

	
PRG027_Intro_ClearText:
	vaddr $22C4
	.byte $17
	
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	
	vaddr $2304
	.byte $17
	
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	
	vaddr $2344
	.byte $17
	
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	
	.byte $FF	; $947D - $947E
PRG027_Intro_ClearText_End

	; CHECKME - UNUSED?
	.byte $03


PRG027_IntroGBufLineOffset:
	.byte $1E	; Story line 2 offset into graphics buffer
	.byte $39	; Story line 3 offset into graphics buffer
	
	
PRG027_9482:
	; $9480 - $9482
	.byte $0A, $0B, $0C
PRG027_9485:
	; $9482 - $9485
	.byte $68, $60, $90
PRG027_9488:
	; $9485 - $9488
	.byte $38, $58, $30
PRG027_948B:
	; $9488 - $948B
	.byte $0F, $16, $11, $01, $0F, $20, $11, $01, $0F, $20, $37, $27, $0F, $20, $20, $20	; $948B - $949A
	.byte $0F, $20, $11, $01, $0F, $20, $37, $27, $0F, $20, $24, $16, $0F, $20, $20, $20	; $949B - $94AA
	.byte $0F, $16, $11, $20, $0F, $20, $11, $20, $0F, $20, $37, $20, $0F, $20, $20, $20	; $94AB - $94BA
	.byte $0F, $20, $11, $20, $0F, $20, $37, $20, $0F, $20, $24, $30, $0F, $20, $20, $20	; $94BB - $94CA
	.byte $0F, $20, $20, $20, $0F, $20, $20, $20, $0F, $20, $20, $20, $0F, $20, $20, $20	; $94CB - $94DA
	.byte $0F, $20, $20, $20, $0F, $20, $20, $20, $0F, $20, $20, $20, $0F, $20, $20, $20	; $94DB - $94EA

PRG027_94EB:
	.byte $10, $3C, $21, $11, $10, $30, $37, $37, $20, $20, $31, $21, $20, $30, $30, $37	; $94EB - $94FA
	.byte $30, $30, $20, $31, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30	; $94FB - $950A

PRG027_950B:
	.byte $11
PRG027_950C:
	; $950B - $950C
	.byte $37
PRG027_950D:
	; $950C - $950D
	.byte $37
PRG027_950E:
	; $950D - $950E
	.byte $2C, $3B, $37, $39, $3C	; $950E - $9512


PRG027_EndingCredRollTable_L:
	.byte LOW(PRG027_EndCredit_RollText_1)
	.byte LOW(PRG027_EndCredit_RollText_2)
	.byte LOW(PRG027_EndCredit_RollText_3)
	.byte LOW(PRG027_EndCredit_RollText_4)
	.byte LOW(PRG027_EndCredit_RollText_5)
	.byte LOW(PRG027_EndCredit_RollText_6)
	.byte LOW(PRG027_EndCredit_RollText_7)
	.byte LOW(PRG027_EndCredit_RollText_8)
	.byte LOW(PRG027_EndCredit_RollText_9)
	.byte LOW(PRG027_EndCredit_RollText_10)
	.byte LOW(PRG027_EndCredit_RollText_11)
	.byte LOW(PRG027_EndCredit_RollText_12)
	.byte LOW(PRG027_EndCredit_RollText_13)
	.byte LOW(PRG027_EndCredit_RollText_14)
	.byte LOW(PRG027_EndCredit_RollText_15)
	.byte LOW(PRG027_EndCredit_RollText_16)
	.byte LOW(PRG027_EndCredit_RollText_17)
	.byte LOW(PRG027_EndCredit_RollText_18)
	.byte LOW(PRG027_EndCredit_RollText_19)
	.byte LOW(PRG027_EndCredit_RollText_20)
	.byte LOW(PRG027_EndCredit_RollText_21)
	.byte LOW(PRG027_EndCredit_RollText_22)
	.byte LOW(PRG027_EndCredit_RollText_23)
	.byte LOW(PRG027_EndCredit_RollText_24)
	.byte LOW(PRG027_EndCredit_RollText_25)
	.byte LOW(PRG027_EndCredit_RollText_26)
	.byte LOW(PRG027_EndCredit_RollText_27)
	.byte LOW(PRG027_EndCredit_RollText_28)
	.byte LOW(PRG027_EndCredit_RollText_29)
	.byte LOW(PRG027_EndCredit_RollText_30)
	.byte LOW(PRG027_EndCredit_RollText_31)
	.byte LOW(PRG027_EndCredit_RollText_32)
	.byte LOW(PRG027_EndCredit_RollText_33)
	.byte LOW(PRG027_EndCredit_RollText_34)
	.byte LOW(PRG027_EndCredit_RollText_35)
	.byte LOW(PRG027_EndCredit_RollText_35)
	.byte LOW(PRG027_EndCredit_RollText_35)
	
PRG027_EndingCredRollTable_H:
	.byte HIGH(PRG027_EndCredit_RollText_1)
	.byte HIGH(PRG027_EndCredit_RollText_2)
	.byte HIGH(PRG027_EndCredit_RollText_3)
	.byte HIGH(PRG027_EndCredit_RollText_4)
	.byte HIGH(PRG027_EndCredit_RollText_5)
	.byte HIGH(PRG027_EndCredit_RollText_6)
	.byte HIGH(PRG027_EndCredit_RollText_7)
	.byte HIGH(PRG027_EndCredit_RollText_8)
	.byte HIGH(PRG027_EndCredit_RollText_9)
	.byte HIGH(PRG027_EndCredit_RollText_10)
	.byte HIGH(PRG027_EndCredit_RollText_11)
	.byte HIGH(PRG027_EndCredit_RollText_12)
	.byte HIGH(PRG027_EndCredit_RollText_13)
	.byte HIGH(PRG027_EndCredit_RollText_14)
	.byte HIGH(PRG027_EndCredit_RollText_15)
	.byte HIGH(PRG027_EndCredit_RollText_16)
	.byte HIGH(PRG027_EndCredit_RollText_17)
	.byte HIGH(PRG027_EndCredit_RollText_18)
	.byte HIGH(PRG027_EndCredit_RollText_19)
	.byte HIGH(PRG027_EndCredit_RollText_20)
	.byte HIGH(PRG027_EndCredit_RollText_21)
	.byte HIGH(PRG027_EndCredit_RollText_22)
	.byte HIGH(PRG027_EndCredit_RollText_23)
	.byte HIGH(PRG027_EndCredit_RollText_24)
	.byte HIGH(PRG027_EndCredit_RollText_25)
	.byte HIGH(PRG027_EndCredit_RollText_26)
	.byte HIGH(PRG027_EndCredit_RollText_27)
	.byte HIGH(PRG027_EndCredit_RollText_28)
	.byte HIGH(PRG027_EndCredit_RollText_29)
	.byte HIGH(PRG027_EndCredit_RollText_30)
	.byte HIGH(PRG027_EndCredit_RollText_31)
	.byte HIGH(PRG027_EndCredit_RollText_32)
	.byte HIGH(PRG027_EndCredit_RollText_33)
	.byte HIGH(PRG027_EndCredit_RollText_34)
	.byte HIGH(PRG027_EndCredit_RollText_35)
	.byte HIGH(PRG027_EndCredit_RollText_35)
	.byte HIGH(PRG027_EndCredit_RollText_35)


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; ENDING FINAL CREDITS ROLL
	; Note that the line number loops $00-$1E while scrolling is happening
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRG027_EndCredit_RollText:

PRG027_EndCredit_RollText_1:
	.byte $03	; Line to display credit on
	.byte $09	; Length of credit
	
	;       S    P    E    C    I    A    L         T    H    A    N    K    S
	.byte $1C, $19, $0E, $0C, $12, $0A, $15, $00, $1D, $11, $0A, $17, $14, $1C
	
	.byte $FF
	
	
PRG027_EndCredit_RollText_2:	
	.byte $08	; Line to display credit on
	.byte $0B	; Length of credit
	
	;       D    A    I    G    O         S    E    G    U    C    H    I
	.byte $0D, $0A, $12, $10, $18, $00, $1C, $0E, $10, $1E, $0C, $11, $12
	
	.byte $FF
	

PRG027_EndCredit_RollText_3:
	.byte $0A	; Line to display credit on
	.byte $0A	; Length of credit
	
	;       T    A    K    U    Y    A         Y    A    M    A    G    I    S    H    I
	.byte $1D, $0A, $14, $1E, $22, $0A, $00, $22, $0A, $16, $0A, $10, $12, $1C, $11, $12
	
	.byte $FF
	
	
PRG027_EndCredit_RollText_4:
	.byte $0C	; Line to display credit on
	.byte $07	; Length of credit
	
	;       H    I    D    E    M    I    T    S    U         K    I    K    U    C    H    I
	.byte $11, $12, $0D, $0E, $16, $12, $1D, $1C, $1E, $00, $14, $12, $14, $1E, $0C, $11, $12
	
	.byte $FF
	
	
PRG027_EndCredit_RollText_5:
	.byte $0E	; Line to display credit on
	.byte $0B	; Length of credit

	;       K    E    N    J    I         H    O    R    I    T    A
	.byte $14, $0E, $17, $13, $12, $00, $11, $18, $1B, $12, $1D, $0A
	
	.byte $FF
	
	
PRG027_EndCredit_RollText_6:
	.byte $10	; Line to display credit on
	.byte $0B	; Length of credit

	;       K    O    U    J    I         T    S    U    T    A    Y    A
	.byte $14, $18, $1E, $13, $12, $00, $1D, $1C, $1E, $1D, $0A, $22, $0A
	
	.byte $FF
	

PRG027_EndCredit_RollText_7:
	.byte $12	; Line to display credit on
	.byte $0A	; Length of credit
	
	;       M    A    K    O    T    O         K    A    W    A    T    O    R    I
	.byte $16, $0A, $14, $18, $1D, $18, $00, $14, $0A, $20, $0A, $1D, $18, $1B, $12
	
	.byte $FF


PRG027_EndCredit_RollText_8:
	.byte $14	; Line to display credit on
	.byte $07	; Length of credit
	
	;       T    O    S    H    I    N    A    R    I         D    A    I    J    O    U
	.byte $1D, $18, $1C, $11, $12, $17, $0A, $1B, $12, $00, $0D, $0A, $12, $13, $18, $1E
	
	.byte $FF


PRG027_EndCredit_RollText_9:
	.byte $16	; Line to display credit on
	.byte $05	; Length of credit
	
	;       S    H    I    N    I    C    H    I    R    O    U         S    E    K    I
	.byte $1C, $11, $12, $17, $12, $0C, $11, $12, $1B, $18, $1E, $00, $1C, $0E, $14, $12
	
	.byte $FF


PRG027_EndCredit_RollText_10:
	.byte $18	; Line to display credit on
	.byte $0B	; Length of credit
	
	;       K    E    N    J    I         N    A    K    A    Y    A    M    A
	.byte $14, $0E, $17, $13, $12, $00, $17, $0A, $14, $0A, $22, $0A, $16, $0A
	
	.byte $FF
	

PRG027_EndCredit_RollText_11:
	.byte $1A	; Line to display credit on
	.byte $07	; Length of credit
	
	;       T    A    T    S    U    H    I    R    O         F    U    J    I    W    A    R    A
	.byte $1D, $0A, $1D, $1C, $1E, $11, $12, $1B, $18, $00, $0F, $1E, $13, $12, $20, $0A, $1B, $0A
	
	.byte $FF


PRG027_EndCredit_RollText_12:
	.byte $1C	; Line to display credit on
	.byte $06	; Length of credit
	
	;       Y    U    U    I    C    H    I    R    O    U         O    K    A    M    O    T    O
	.byte $22, $1E, $1E, $12, $0C, $11, $12, $1B, $18, $1E, $00, $18, $14, $0A, $16, $18, $1D, $18
	
	.byte $FF
	

PRG027_EndCredit_RollText_13:
	.byte $00	; Line to display credit on
	.byte $0A	; Length of credit
	
	;       S    H    I    N    G    O         S    H    I    M    I    Z    U
	.byte $1C, $11, $12, $17, $10, $18, $00, $1C, $11, $12, $16, $12, $23, $1E
	
	.byte $FF


PRG027_EndCredit_RollText_14:
	.byte $02	; Line to display credit on
	.byte $09	; Length of credit
	
	;       T    S    U    T    O    M    U         K    O    N    D    O    U
	.byte $1D, $1C, $1E, $1D, $18, $16, $1E, $00, $14, $18, $17, $0D, $18, $1E
	
	.byte $FF
	

PRG027_EndCredit_RollText_15:
	.byte $04	; Line to display credit on
	.byte $0A	; Length of credit
	
	;       T    O    M    O    M    I         S    H    I    B    A    Y    A    M    A
	.byte $1D, $18, $16, $18, $16, $12, $00, $1C, $11, $12, $0B, $0A, $22, $0A, $16, $0A
	
	.byte $FF
	

PRG027_EndCredit_RollText_16:
	.byte $06	; Line to display credit on
	.byte $0A	; Length of credit
	
	;       S    H    I    N    Y    A         M    I    T    S    U    D    A
	.byte $1C, $11, $12, $17, $22, $0A, $00, $16, $12, $1D, $1C, $1E, $0D, $0A
	
	.byte $FF
	

PRG027_EndCredit_RollText_17:
	.byte $08	; Line to display credit on
	.byte $09	; Length of credit
	
	;       H    I    T    O    S    H    I         T    A    K    E    S    I    M    A
	.byte $11, $12, $1D, $18, $1C, $11, $12, $00, $1D, $0A, $14, $0E, $1C, $12, $16, $0A
	
	.byte $FF
	

PRG027_EndCredit_RollText_18:
	.byte $0A	; Line to display credit on
	.byte $0A	; Length of credit
	
	;       K    O    U    Z    O    U         A    S    A    N    O
	.byte $14, $18, $1E, $23, $18, $1E, $00, $0A, $1C, $0A, $17, $18
	
	.byte $FF


PRG027_EndCredit_RollText_19:
	.byte $0C	; Line to display credit on
	.byte $05	; Length of credit
	
	;       S    H    I    N    I    C    H    I    R    O    U         N    I    S    H    I    D    A
	.byte $1C, $11, $12, $17, $12, $0C, $11, $12, $1B, $18, $1E, $00, $17, $12, $1C, $11, $12, $0D, $0A
	
	.byte $FF


PRG027_EndCredit_RollText_20:
	.byte $0E	; Line to display credit on
	.byte $0A	; Length of credit
	
	;       T    A    K    U    Y    A         K    A    W    A    T    A
	.byte $1D, $0A, $14, $1E, $22, $0A, $00, $14, $0A, $20, $0A, $1D, $0A
	
	.byte $FF
	

PRG027_EndCredit_RollText_21:
	.byte $10	; Line to display credit on
	.byte $09	; Length of credit
	
	;       T    A    K    A    S    H    I         F    U    J    I    W    A    R    A
	.byte $1D, $0A, $14, $0A, $1C, $11, $12, $00, $0F, $1E, $13, $12, $20, $0A, $1B, $0A
	
	.byte $FF
	
	
PRG027_EndCredit_RollText_22:
	.byte $12	; Line to display credit on
	.byte $0B	; Length of credit
	
	;       Y    O    U    J    I         M    A    S    U    D    A
	.byte $22, $18, $1E, $13, $12, $00, $16, $0A, $1C, $1E, $0D, $0A
	
	.byte $FF
	

PRG027_EndCredit_RollText_23:
	.byte $14	; Line to display credit on
	.byte $09	; Length of credit
	
	;       D    A    I    S    U    K    E         A    K    E    B    I
	.byte $0D, $0A, $12, $1C, $1E, $14, $0E, $00, $0A, $14, $0E, $0B, $12
	
	.byte $FF
	
	
PRG027_EndCredit_RollText_24:
	.byte $16	; Line to display credit on
	.byte $0B	; Length of credit
	
	;       A    K    I    K    O         O    O    K    U    M    A
	.byte $0A, $14, $12, $14, $18, $00, $18, $18, $14, $1E, $16, $0A
	
	.byte $FF


PRG027_EndCredit_RollText_25:
	.byte $18	; Line to display credit on
	.byte $0A	; Length of credit
	
	;       Y    O    S    H    I    O         A    B    E
	.byte $22, $18, $1C, $11, $12, $18, $00, $0A, $0B, $0E
	
	.byte $FF
	
	
PRG027_EndCredit_RollText_26:
	.byte $1A	; Line to display credit on
	.byte $07	; Length of credit
	
	;       Y    O    S    H    I    H    I    T    O         O    K    A    D    A
	.byte $22, $18, $1C, $11, $12, $11, $12, $1D, $18, $00, $18, $14, $0A, $0D, $0A
	
	.byte $FF


PRG027_EndCredit_RollText_27:
	.byte $1C	; Line to display credit on
	.byte $0A	; Length of credit
	
	;       T    O    S    H    I    O         M    O    R    I
	.byte $1D, $18, $1C, $11, $12, $18, $00, $16, $18, $1B, $12
	
	.byte $FF


PRG027_EndCredit_RollText_28:
	.byte $00	; Line to display credit on
	.byte $0A	; Length of credit
	
	;       M    A    S    A    Y    O         Y    A    M    A    Z    A    K    I
	.byte $16, $0A, $1C, $0A, $22, $18, $00, $22, $0A, $16, $0A, $23, $0A, $14, $12
	
	.byte $FF
	

PRG027_EndCredit_RollText_29:
	.byte $02	; Line to display credit on
	.byte $0A	; Length of credit
	
	;       M    A    S    U    M    I         A    B    E
	.byte $16, $0A, $1C, $1E, $16, $12, $00, $0A, $0B, $0E
	
	.byte $FF


PRG027_EndCredit_RollText_30:
	.byte $04	; Line to display credit on
	.byte $0B	; Length of credit
	
	;       T    E    T    S    U         A    K    I    Y    A    M    A
	.byte $1D, $0E, $1D, $1C, $1E, $00, $0A, $14, $12, $22, $0A, $16, $0A
	
	.byte $FF
	

PRG027_EndCredit_RollText_31:
	.byte $06	; Line to display credit on
	.byte $0A	; Length of credit
	
	;       M    A    S    A    K    I         K    O    N    D    O    U
	.byte $16, $0A, $1C, $0A, $14, $12, $00, $14, $18, $17, $0D, $18, $1E
	
	.byte $FF
	

PRG027_EndCredit_RollText_32:
	.byte $08	; Line to display credit on
	.byte $09	; Length of credit
	
	;       Y    U    U    S    U    K    E         K    U    R    A    M    O    C    H    I
	.byte $22, $1E, $1E, $1C, $1E, $14, $0E, $00, $14, $1E, $1B, $0A, $16, $18, $0C, $11, $12
	
	.byte $FF


PRG027_EndCredit_RollText_33:
	.byte $0A	; Line to display credit on
	.byte $0A	; Length of credit
	
	;       M    A    S    A    T    O         M    A    T    S    U    Z    A    K    I
	.byte $16, $0A, $1C, $0A, $1D, $18, $00, $16, $0A, $1D, $1C, $1E, $23, $0A, $14, $12
	
	.byte $FF


PRG027_EndCredit_RollText_34:
	.byte $00	; Line to display credit on
	.byte $0A	; Length of credit
	
	;       P    R    E    S    E    N    T    E    D         B    Y
	.byte $19, $1B, $0E, $1C, $0E, $17, $1D, $0E, $0D, $00, $0B, $22
	
	.byte $FF
	

PRG027_EndCredit_RollText_35:
	.byte $10	; Line to display credit on
	.byte $00	; Length of credit

	; (Nothing)
	.byte $00
	
	.byte $FF


PRG027_IntroStoryTextTable_L:	; $97AC
	.byte LOW(PRG027_97C6)	; $00
	.byte LOW(PRG027_980C)	; $01
	.byte LOW(PRG027_983C)	; $02
	.byte LOW(PRG027_987C)	; $03
	.byte LOW(PRG027_98A9)	; $04
	.byte LOW(PRG027_98E2)	; $05
	.byte LOW(PRG027_9927)	; $06
	.byte LOW(PRG027_9964)	; $07
	.byte LOW(PRG027_999B)	; $08
	.byte LOW(PRG027_99CE)	; $09
	.byte LOW(PRG027_9A14)	; $0A
	.byte LOW(PRG027_9A59)	; $0B
	.byte LOW(PRG027_9A9A)	; $0C



PRG027_IntroStoryTextTable_H:	; $97B9
	.byte HIGH(PRG027_97C6)	; $00
	.byte HIGH(PRG027_980C)	; $01
	.byte HIGH(PRG027_983C)	; $02
	.byte HIGH(PRG027_987C)	; $03
	.byte HIGH(PRG027_98A9)	; $04
	.byte HIGH(PRG027_98E2)	; $05
	.byte HIGH(PRG027_9927)	; $06
	.byte HIGH(PRG027_9964)	; $07
	.byte HIGH(PRG027_999B)	; $08
	.byte HIGH(PRG027_99CE)	; $09
	.byte HIGH(PRG027_9A14)	; $0A
	.byte HIGH(PRG027_9A59)	; $0B
	.byte HIGH(PRG027_9A9A)	; $0C



PRG027_97C6:
	;       H    O    U    S    E    H    O    L    D         R    O    B    O    T    S         R    O    C    K
	.byte $11, $18, $1E, $1C, $0E, $11, $18, $15, $0D, $00, $1B, $18, $0B, $18, $1D, $1C, $00, $1B, $18, $0C, $14, $FD
	
	;       A    N    D         R    O    L    L         W    E    R    E         C    R    E    A    T    E    D         B    Y
	.byte $0A, $17, $0D, $00, $1B, $18, $15, $15, $00, $20, $0E, $1B, $0E, $00, $0C, $1B, $0E, $0A, $1D, $0E, $0D, $00, $0B, $22, $FD
	
	;       M    A    S    T    E    R         R    O    B    O    T         D    E    S    I    G    N    E    R    ,
	.byte $16, $0A, $1C, $1D, $0E, $1B, $00, $1B, $18, $0B, $18, $1D, $00, $0D, $0E, $1C, $12, $10, $17, $0E, $1B, $2E, $FF


PRG027_980C:
	;       D    R    .    L    I    G    H    T    ,    A    N    D         W    E    R    E
	.byte $0D, $1B, $24, $15, $12, $10, $11, $1D, $2E, $0A, $17, $0D, $00, $20, $0E, $1B, $0E, $FD
	
	;       E    N    J    O    Y    I    N    G         T    H    E    I    R         P    E    A    C    E    F    U    L
	.byte $0E, $17, $13, $18, $22, $12, $17, $10, $00, $1D, $11, $0E, $12, $1B, $00, $19, $0E, $0A, $0C, $0E, $0F, $1E, $15, $FD
	
	;       D    A    Y    S    .
	.byte $0D, $0A, $22, $1C, $24, $FF


PRG027_983C:
	;       T    H    E    N         O    N    E         D    A    Y    ,    T    H    E
	.byte $1D, $11, $0E, $17, $00, $18, $17, $0E, $00, $0D, $0A, $22, $2E, $1D, $11, $0E, $FD
	
	;       I    N    D    U    S    T    R    I    A    L         R    O    B    O    T    S         A    L    L
	.byte $12, $17, $0D, $1E, $1C, $1D, $1B, $12, $0A, $15, $00, $1B, $18, $0B, $18, $1D, $1C, $00, $0A, $15, $15, $FD
	
	;       O    V    E    R         T    H    E         W    O    R    L    D         W    E    N    T         O    N         A
	.byte $18, $1F, $0E, $1B, $00, $1D, $11, $0E, $00, $20, $18, $1B, $15, $0D, $00, $20, $0E, $17, $1D, $00, $18, $17, $00, $0A, $FF


PRG027_987C:
	;       R    A    M    P    A    G    E         A    N    D         T    H    E         W    O    R    L    D
	.byte $1B, $0A, $16, $19, $0A, $10, $0E, $00, $0A, $17, $0D, $00, $1D, $11, $0E, $00, $20, $18, $1B, $15, $0D, $FD
	
	;       F    E    L    L         I    N    T    O         T    O    T    A    L         C    H    A    O    S    .
	.byte $0F, $0E, $15, $15, $00, $12, $17, $1D, $18, $00, $1D, $18, $1D, $0A, $15, $00, $0C, $11, $0A, $18, $1C, $24, $FF


PRG027_98A9:
	;       D    R    .    L    I    G    H    T         Q    U    I    C    K    L    Y
	.byte $0D, $1B, $24, $15, $12, $10, $11, $1D, $00, $1A, $1E, $12, $0C, $14, $15, $22, $FD
	
	;       R    E    A    L    I    Z    E    D         T    H    A    T         M    A    D
	.byte $1B, $0E, $0A, $15, $12, $23, $0E, $0D, $00, $1D, $11, $0A, $1D, $00, $16, $0A, $0D, $FD
	
	;       S    C    I    E    N    T    I    S    T    ,    D    R    .    W    I    L    Y    ,    W    A    S
	.byte $1C, $0C, $12, $0E, $17, $1D, $12, $1C, $1D, $2E, $0D, $1B, $24, $20, $12, $15, $22, $2E, $20, $0A, $1C, $FF


PRG027_98E2:
	;       B    E    H    I    N    D         T    H    E         N    E    F    A    R    I    O    U    S
	.byte $0B, $0E, $11, $12, $17, $0D, $00, $1D, $11, $0E, $00, $17, $0E, $0F, $0A, $1B, $12, $18, $1E, $1C, $FD
	
	;       D    E    E    D         B    U    T         H    E         D    I    D    N    '    T         K    N    O    W
	.byte $0D, $0E, $0E, $0D, $00, $0B, $1E, $1D, $00, $11, $0E, $00, $0D, $12, $0D, $17, $2C, $1D, $00, $14, $17, $18, $20, $FD
	
	;       W    H    A    T         T    O         D    O    .         R    O    C    K    ,    H    A    V    I    N    G
	.byte $20, $11, $0A, $1D, $00, $1D, $18, $00, $0D, $18, $24, $00, $1B, $18, $0C, $14, $2E, $11, $0A, $1F, $12, $17, $10, $FF


PRG027_9927:
	;       A         S    T    R    O    N    G         S    E    N    S    E         O    F
	.byte $0A, $00, $1C, $1D, $1B, $18, $17, $10, $00, $1C, $0E, $17, $1C, $0E, $00, $18, $0F, $FD
	
	;       J    U    S    T    I    C    E    ,    V    O    L    U    N    T    E    E    R    E    D         T    O
	.byte $13, $1E, $1C, $1D, $12, $0C, $0E, $2E, $1F, $18, $15, $1E, $17, $1D, $0E, $0E, $1B, $0E, $0D, $00, $1D, $18, $FD
	
	;       B    E         C    O    N    V    E    R    T    E    D         I    N    T    O         A
	.byte $0B, $0E, $00, $0C, $18, $17, $1F, $0E, $1B, $1D, $0E, $0D, $00, $12, $17, $1D, $18, $00, $0A, $FF


PRG027_9964:
	;       F    I    G    H    T    I    N    G         R    O    B    O    T    .
	.byte $0F, $12, $10, $11, $1D, $12, $17, $10, $00, $1B, $18, $0B, $18, $1D, $24, $FD
	
	;       T    H    U    S         T    H    E         S    U    P    E    R         R    O    B    O    T
	.byte $1D, $11, $1E, $1C, $00, $1D, $11, $0E, $00, $1C, $1E, $19, $0E, $1B, $00, $1B, $18, $0B, $18, $1D, $FD
	
	;       M    E    G    A    M    A    N         W    A    S         B    O    R    N    .
	.byte $16, $0E, $10, $0A, $16, $0A, $17, $00, $20, $0A, $1C, $00, $0B, $18, $1B, $17, $24, $FF


PRG027_999B:
	;       M    E    G    A    M    A    N         S    H    A    T    T    E    R    E    D
	.byte $16, $0E, $10, $0A, $16, $0A, $17, $00, $1C, $11, $0A, $1D, $1D, $0E, $1B, $0E, $0D, $FD
	
	;       D    R    .    W    I    L    Y    '    S         P    L    A    N    S
	.byte $0D, $1B, $24, $20, $12, $15, $22, $2C, $1C, $00, $19, $15, $0A, $17, $1C, $FD
	
	;       T    H    R    E    E         T    I    M    E    S         A    N    D
	.byte $1D, $11, $1B, $0E, $0E, $00, $1D, $12, $16, $0E, $1C, $00, $0A, $17, $0D, $00, $FF


PRG027_99CE:
	;       W    O    R    L    D         P    E    A    C    E         H    A    S         B    E    E    N
	.byte $20, $18, $1B, $15, $0D, $00, $19, $0E, $0A, $0C, $0E, $00, $11, $0A, $1C, $00, $0B, $0E, $0E, $17, $FD
	
	;       M    A    I    N    T    A    I    N    E    D         S    O         F    A    R    .    .    .    .    B    U    T
	.byte $16, $0A, $12, $17, $1D, $0A, $12, $17, $0E, $0D, $00, $1C, $18, $00, $0F, $0A, $1B, $24, $24, $24, $24, $0B, $1E, $1D, $FD
	
	;       H    I    S    T    O    R    Y         R    E    P    E    A    T    S         I    T    S    E    L    F    .
	.byte $11, $12, $1C, $1D, $18, $1B, $22, $00, $1B, $0E, $19, $0E, $0A, $1D, $1C, $00, $12, $1D, $1C, $0E, $15, $0F, $24, $FF


PRG027_9A14:
	;       D    R    .    C    O    S    S    A    C    K    ,    A         M    Y    S    T    E    R    I    O    U    S
	.byte $0D, $1B, $24, $0C, $18, $1C, $1C, $0A, $0C, $14, $2E, $0A, $00, $16, $22, $1C, $1D, $0E, $1B, $12, $18, $1E, $1C, $FD
	
	;       S    C    I    E    N    T    I    S    T    ,    H    A    S         I    N    V    E    N    T    E    D
	.byte $1C, $0C, $12, $0E, $17, $1D, $12, $1C, $1D, $2E, $11, $0A, $1C, $00, $12, $17, $1F, $0E, $17, $1D, $0E, $0D, $FD
	
	;       E    I    G    H    T         P    O    W    E    R    F    U    L         R    O    B    O    T    S
	.byte $0E, $12, $10, $11, $1D, $00, $19, $18, $20, $0E, $1B, $0F, $1E, $15, $00, $1B, $18, $0B, $18, $1D, $1C, $FF


PRG027_9A59:
	;       A    N    D         S    E    N    T         T    H    E    M         A    F    T    E    R
	.byte $0A, $17, $0D, $00, $1C, $0E, $17, $1D, $00, $1D, $11, $0E, $16, $00, $0A, $0F, $1D, $0E, $1B, $FD
	
	;       M    E    G    A    M    A    N    .    M    E    G    A    M    A    N         S    T    A    R    T    S
	.byte $16, $0E, $10, $0A, $16, $0A, $17, $24, $16, $0E, $10, $0A, $16, $0A, $17, $00, $1C, $1D, $0A, $1B, $1D, $1C, $FD
	
	;       F    O    R         T    H    E         B    A    T    T    L    E         A    G    A    I    N    ,
	.byte $0F, $18, $1B, $00, $1D, $11, $0E, $00, $0B, $0A, $1D, $1D, $15, $0E, $00, $0A, $10, $0A, $12, $17, $2E, $FF


PRG027_9A9A:
	;       T    H    I    S         T    I    M    E         E    Q    U    I    P    P    E    D         W    I    T    H
	.byte $1D, $11, $12, $1C, $00, $1D, $12, $16, $0E, $00, $0E, $1A, $1E, $12, $19, $19, $0E, $0D, $00, $20, $12, $1D, $11, $FD
	
	;       T    H    E         P    O    W    E    R    F    U    L
	.byte $1D, $11, $0E, $00, $19, $18, $20, $0E, $1B, $0F, $1E, $15, $FD
	
	;                      N    E    W         M    E    G    A         B    U    S    T    E    R    !    !
	.byte $00, $00, $00, $17, $0E, $20, $00, $16, $0E, $10, $0A, $00, $0B, $1E, $1C, $1D, $0E, $1B, $28, $28, $FF


	; CHECKME - UNUSED?
	.byte $0A, $85, $2A, $AE, $00, $56, $02, $46, $02, $44, $A0, $1E, $22, $32, $08, $72	; $9AD4 - $9AE3
	.byte $2A, $30, $88, $30, $08, $92, $08, $3D, $20, $EE, $A0, $C0, $8A, $6D, $00, $D0	; $9AE4 - $9AF3
	.byte $80, $A6, $A0, $06, $8A, $51, $A2, $84, $28, $C5, $A0, $E6, $00, $5C, $20, $A1	; $9AF4 - $9B03
	.byte $80, $C6, $20, $84, $22, $4E, $02, $85, $80, $D6, $00, $65, $82, $9E, $02, $A0	; $9B04 - $9B13
	.byte $2A, $7E, $00, $1C, $88, $70, $80, $12, $00, $00, $AA, $95, $80, $66, $08, $88	; $9B14 - $9B23
	.byte $AA, $C6, $82, $86, $02, $48, $88, $D5, $8A, $40, $02, $C1, $02, $67, $28, $18	; $9B24 - $9B33
	.byte $02, $2B, $88, $50, $22, $48, $0A, $16, $80, $07, $08, $0C, $22, $12, $0A, $D2	; $9B34 - $9B43
	.byte $2A, $FC, $00, $02, $22, $59, $00, $4C, $08, $BA, $20, $B1, $00, $00, $28, $16	; $9B44 - $9B53
	.byte $08, $BA, $A0, $02, $00, $24, $AA, $A9, $00, $3C, $00, $48, $A8, $B5, $20, $1A	; $9B54 - $9B63
	.byte $AA, $5C, $0A, $D0, $2A, $1F, $00, $BA, $A8, $1C, $00, $01, $8A, $1A, $82, $0A	; $9B64 - $9B73
	.byte $28, $42, $08, $88, $08, $30, $02, $00, $02, $04, $20, $FD, $02, $06, $82, $5C	; $9B74 - $9B83
	.byte $22, $41, $22, $16, $20, $98, $80, $72, $8A, $E0, $A0, $48, $00, $5F, $02, $44	; $9B84 - $9B93
	.byte $80, $2B, $20, $0F, $08, $4E, $82, $62, $08, $9F, $20, $0F, $20, $00, $2A, $1D	; $9B94 - $9BA3
	.byte $08, $1A, $80, $00, $A0, $2C, $02, $C4, $20, $AE, $88, $63, $00, $4A, $88, $CA	; $9BA4 - $9BB3
	.byte $00, $34, $02, $40, $80, $70, $88, $36, $08, $B8, $88, $23, $8A, $00, $A0, $33	; $9BB4 - $9BC3
	.byte $80, $9D, $88, $94, $80, $BF, $A8, $5B, $80, $BC, $AA, $93, $88, $81, $00, $95	; $9BC4 - $9BD3
	.byte $08, $00, $00, $10, $22, $00, $20, $03, $A0, $03, $00, $DA, $82, $6B, $02, $10	; $9BD4 - $9BE3
	.byte $28, $46, $00, $30, $00, $D2, $00, $90, $02, $02, $20, $81, $A8, $29, $8A, $3B	; $9BE4 - $9BF3
	.byte $00, $08, $20, $36, $0A, $40, $80, $F9, $02, $D8, $80, $E3, $98, $51, $D9, $04	; $9BF4 - $9C03
	.byte $15, $02, $28, $52, $44, $40, $50, $00, $28, $00, $B6, $00, $10, $07, $28, $10	; $9C04 - $9C13
	.byte $13, $55, $00, $64, $76, $00, $8C, $10, $44, $11, $1E, $04, $58, $04, $9F, $51	; $9C14 - $9C23
	.byte $EB, $15, $CB, $54, $59, $14, $62, $51, $25, $45, $72, $50, $88, $50, $DE, $47	; $9C24 - $9C33
	.byte $3F, $00, $93, $40, $C9, $01, $2C, $00, $5D, $15, $D2, $10, $2E, $41, $30, $01	; $9C34 - $9C43
	.byte $B4, $41, $E6, $40, $47, $14, $E5, $11, $8E, $01, $EE, $00, $0E, $65, $AA, $01	; $9C44 - $9C53
	.byte $00, $50, $6C, $01, $49, $50, $9C, $01, $C2, $7D, $29, $01, $FA, $34, $FE, $74	; $9C54 - $9C63
	.byte $FB, $05, $B6, $15, $B7, $01, $5B, $46, $F6, $44, $E5, $01, $AB, $55, $F7, $95	; $9C64 - $9C73
	.byte $D8, $70, $78, $D5, $9F, $55, $EF, $51, $E8, $4D, $D6, $60, $7A, $10, $1C, $00	; $9C74 - $9C83
	.byte $6A, $44, $80, $40, $28, $40, $70, $51, $AC, $60, $28, $01, $2D, $44, $70, $00	; $9C84 - $9C93
	.byte $18, $04, $CC, $05, $8C, $75, $F8, $00, $C2, $4D, $30, $50, $94, $58, $CE, $01	; $9C94 - $9CA3
	.byte $E4, $05, $F8, $D0, $B5, $C1, $5F, $14, $5E, $51, $CC, $47, $36, $50, $94, $44	; $9CA4 - $9CB3
	.byte $33, $51, $7B, $05, $EC, $55, $0C, $45, $BB, $15, $7F, $11, $08, $51, $42, $41	; $9CB4 - $9CC3
	.byte $ED, $42, $AA, $54, $E5, $D0, $C7, $51, $01, $15, $F0, $64, $76, $49, $E4, $00	; $9CC4 - $9CD3
	.byte $BE, $55, $09, $11, $2C, $44, $10, $40, $28, $20, $F4, $15, $FD, $55, $FF, $54	; $9CD4 - $9CE3
	.byte $5A, $C5, $EE, $15, $FC, $45, $CF, $59, $ED, $55, $1D, $51, $7F, $51, $D5, $15	; $9CE4 - $9CF3
	.byte $6E, $56, $DC, $55, $4E, $54, $BE, $17, $AD, $45, $78, $D9, $14, $41, $38, $11	; $9CF4 - $9D03
	.byte $93, $14, $67, $15, $26, $01, $32, $00, $44, $53, $2D, $55, $0B, $00, $CB, $11	; $9D04 - $9D13
	.byte $C8, $00, $1A, $00, $0C, $40, $90, $50, $40, $55, $49, $15, $F4, $55, $CA, $51	; $9D14 - $9D23
	.byte $EF, $57, $88, $12, $AF, $35, $D6, $40, $AF, $55, $E8, $C1, $58, $56, $88, $54	; $9D24 - $9D33
	.byte $D8, $44, $17, $54, $4F, $C4, $92, $05, $01, $40, $06, $04, $48, $11, $DC, $54	; $9D34 - $9D43
	.byte $62, $10, $9F, $41, $93, $44, $DA, $51, $7A, $51, $EB, $14, $1D, $D5, $24, $01	; $9D44 - $9D53
	.byte $40, $44, $23, $45, $01, $14, $B6, $40, $B4, $00, $0A, $04, $7F, $54, $7A, $45	; $9D54 - $9D63
	.byte $E7, $15, $FC, $14, $BF, $50, $C7, $C0, $9C, $9D, $BE, $11, $18, $1D, $6F, $45	; $9D64 - $9D73
	.byte $A2, $51, $55, $60, $80, $90, $AA, $50, $FF, $50, $6D, $15, $D2, $05, $C9, $01	; $9D74 - $9D83
	.byte $C3, $04, $A4, $01, $20, $40, $98, $41, $ED, $14, $2A, $11, $79, $10, $12, $14	; $9D84 - $9D93
	.byte $A2, $01, $3E, $41, $64, $44, $E4, $11, $60, $40, $42, $41, $CE, $61, $34, $D1	; $9D94 - $9DA3
	.byte $DF, $11, $68, $55, $FF, $12, $DE, $4C, $17, $51, $46, $04, $C6, $15, $D9, $44	; $9DA4 - $9DB3
	.byte $18, $50, $20, $55, $07, $55, $20, $C5, $F5, $15, $97, $41, $BE, $14, $FA, $44	; $9DB4 - $9DC3
	.byte $A2, $56, $76, $15, $BF, $40, $DA, $11, $DC, $40, $87, $01, $C2, $D4, $42, $40	; $9DC4 - $9DD3
	.byte $A7, $41, $4A, $45, $BD, $40, $07, $00, $2F, $05, $BD, $14, $EE, $11, $5D, $47	; $9DD4 - $9DE3
	.byte $FD, $1D, $F7, $56, $BF, $14, $FC, $54, $EF, $49, $0F, $7D, $E5, $55, $ED, $54	; $9DE4 - $9DF3
	.byte $75, $54, $DF, $80, $FB, $54, $7E, $75, $BD, $55, $BE, $14, $20, $00, $24, $04	; $9DF4 - $9E03
	.byte $D2, $40, $84, $40, $28, $04, $07, $41, $08, $10, $86, $05, $12, $00, $4F, $00	; $9E04 - $9E13
	.byte $72, $00, $60, $00, $B9, $40, $30, $48, $42, $00, $06, $04, $F6, $50, $7B, $54	; $9E14 - $9E23
	.byte $C4, $05, $2F, $11, $B7, $D1, $A6, $54, $5B, $45, $08, $89, $FF, $15, $19, $44	; $9E24 - $9E33
	.byte $BA, $14, $03, $51, $2F, $44, $64, $20, $EE, $01, $D2, $0C, $BE, $D4, $2C, $65	; $9E34 - $9E43
	.byte $1A, $00, $84, $01, $0E, $10, $9A, $C4, $62, $45, $2D, $00, $D7, $30, $0A, $40	; $9E44 - $9E53
	.byte $A4, $00, $B4, $50, $47, $04, $00, $35, $CE, $15, $93, $11, $5E, $24, $DF, $55	; $9E54 - $9E63
	.byte $BF, $30, $BE, $54, $53, $05, $EA, $04, $2D, $48, $EA, $34, $E9, $14, $8A, $61	; $9E64 - $9E73
	.byte $6A, $55, $E0, $55, $75, $05, $EB, $54, $6A, $15, $ED, $51, $5A, $00, $72, $45	; $9E74 - $9E83
	.byte $55, $45, $51, $41, $D0, $01, $55, $56, $91, $14, $8B, $40, $AB, $51, $50, $14	; $9E84 - $9E93
	.byte $9C, $10, $5A, $40, $4D, $04, $BA, $00, $02, $50, $E8, $41, $FC, $51, $B7, $40	; $9E94 - $9EA3
	.byte $1B, $41, $B8, $11, $DB, $10, $9F, $54, $1A, $55, $DA, $45, $AE, $45, $6E, $50	; $9EA4 - $9EB3
	.byte $42, $54, $28, $F1, $DE, $40, $95, $11, $78, $10, $A8, $10, $53, $51, $AB, $55	; $9EB4 - $9EC3
	.byte $C5, $04, $DD, $04, $FB, $40, $05, $15, $3E, $15, $A8, $15, $7E, $50, $81, $51	; $9EC4 - $9ED3
	.byte $3A, $14, $01, $14, $D6, $40, $ED, $04, $40, $10, $41, $05, $7E, $40, $FE, $1D	; $9ED4 - $9EE3
	.byte $8D, $14, $95, $F3, $FF, $44, $FF, $45, $DF, $55, $BE, $5F, $1A, $15, $0F, $65	; $9EE4 - $9EF3
	.byte $E4, $55, $9F, $50, $AE, $50, $B2, $54, $FF, $17, $F8, $53, $1E, $08, $4C, $04	; $9EF4 - $9F03
	.byte $37, $45, $04, $54, $44, $10, $3C, $44, $04, $51, $90, $50, $F1, $50, $88, $50	; $9F04 - $9F13
	.byte $5A, $44, $41, $40, $4B, $55, $00, $04, $81, $11, $33, $14, $EB, $40, $F1, $14	; $9F14 - $9F23
	.byte $FD, $55, $BE, $5C, $EC, $25, $62, $50, $0E, $51, $41, $04, $50, $44, $5D, $15	; $9F24 - $9F33
	.byte $6B, $55, $BC, $40, $E2, $55, $E0, $15, $F7, $00, $CF, $00, $CC, $44, $1D, $25	; $9F34 - $9F43
	.byte $70, $47, $8B, $10, $17, $11, $20, $45, $A6, $00, $B6, $03, $0E, $15, $C8, $54	; $9F44 - $9F53
	.byte $12, $50, $34, $41, $C4, $58, $7A, $04, $99, $41, $30, $04, $CF, $46, $BD, $D5	; $9F54 - $9F63
	.byte $FD, $41, $F6, $74, $BF, $55, $FE, $05, $F7, $45, $C9, $15, $FB, $45, $2F, $00	; $9F64 - $9F73
	.byte $F4, $04, $CF, $55, $F4, $10, $84, $11, $EA, $40, $B6, $55, $22, $00, $01, $51	; $9F74 - $9F83
	.byte $0C, $10, $F6, $44, $32, $51, $7A, $61, $0A, $14, $A9, $40, $A8, $00, $D3, $41	; $9F84 - $9F93
	.byte $52, $04, $10, $41, $43, $11, $50, $51, $94, $10, $49, $45, $70, $51, $FC, $47	; $9F94 - $9FA3
	.byte $B9, $11, $36, $91, $F4, $54, $D5, $54, $1E, $11, $5D, $50, $E2, $55, $2A, $44	; $9FA4 - $9FB3
	.byte $70, $44, $73, $50, $92, $01, $08, $45, $C7, $54, $F4, $54, $CE, $14, $8C, $44	; $9FB4 - $9FC3
	.byte $25, $59, $A1, $11, $34, $45, $DC, $50, $23, $01, $2A, $11, $B5, $00, $7C, $10	; $9FC4 - $9FD3
	.byte $26, $40, $14, $54, $3A, $54, $20, $4D, $5D, $44, $C9, $11, $BF, $5A, $9F, $05	; $9FD4 - $9FE3
	.byte $FF, $05, $A4, $55, $BB, $45, $79, $91, $DD, $15, $0B, $10, $DF, $55, $50, $58	; $9FE4 - $9FF3
	.byte $69, $44, $5C, $55, $3E, $45, $58, $50, $DD, $43, $03, $FF	; $9FF4 - $9FFF


