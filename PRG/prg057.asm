PRG057_DoStoryTitlStagSel_Ind:
	JMP PRG057_DoStoryTitlStagSel	; $8000

PRG057_DoLevelIntermission_Ind:
	JMP PRG057_DoLevelIntermission	; $8003

PRG057_ClearGameRAM_Ind:
	JMP PRG057_ClearGameRAM	; $8006

	; CHECKME - UNUSED?
	; This is the "palette editor" dev tool ... TODO to see if it's ever able to be called
	JMP PRG057_9A28	; $8009



PRG057_DoStoryTitlStagSel:
	
	LDA #TMAP_CREDITLOGO
	STA <TileMap_Index
	
	; Set page 48 at $A000
	ORA #$20		; Constant with $10 | $20 = $30 = 48
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

	; "Copyright / licensed by Nintendo"	
	LDA #$03
	STA <Temp_Var16
	LDA #$04
	STA <MetaBlk_CurScreen
	JSR PRG057_LoadBGTilesPalMusSpr

	; Run copyright for 120 ticks (2 seconds)
	LDX #120
	JSR PRG063_UpdateMultipleFrames


	; "Capcom presents"	
	LDA #$00
	STA <Temp_Var16
	LDA #$01
	STA <MetaBlk_CurScreen	
	JSR PRG057_LoadBGTilesPalMusSpr

	; Run Capcom logo for 120 ticks (2 seconds)
	LDX #120
	JSR PRG063_UpdateMultipleFrames


PRG057_8037:
	; The whole intro story sequence
	JSR PRG063_DoIntroStory

	; Load up title screen
	LDA #$01
	STA <Temp_Var16
	LDA #$02
	STA <MetaBlk_CurScreen
	JSR PRG057_LoadBGTilesPalMusSpr

	; These form a 16-bit countdown for the title screen
	LDA #$B0
	STA <Temp_Var16
	LDA #$04
	STA <Temp_Var17

PRG057_804D:
	LDA <Ctlr1_Pressed
	AND #(PAD_A | PAD_START)
	BNE PRG057_808C		; If Player is pressing A or START, jump to PRG057_808C

	LDA <Ctlr1_Pressed
	AND #(PAD_SELECT | PAD_UP | PAD_DOWN)
	BEQ PRG057_8070		; If Player is NOT pressing SELECT/UP/DOWN, jump to PRG057_8070

	; Player is pressing SELECT/UP/DOWN...

	; Put cursor in opposite position
	LDA #SFX_MENUSELECT
	JSR PRG063_QueueMusSnd

	LDA Sprite_RAM+$00
	ADD #$10
	STA Sprite_RAM+$00
	CMP #$B7
	BNE PRG057_8070

	LDA #$97
	STA Sprite_RAM+$00

PRG057_8070:
	JSR PRG063_UpdateOneFrame

	LDA <Temp_Var16
	SUB #$01
	STA <Temp_Var16
	LDA <Temp_Var17
	SBC #$00
	STA <Temp_Var17
	ORA <Temp_Var16
	BNE PRG057_804D		; If the title screen timeout hasn't reached zero, jump to PRG057_804D (loop around)

	; Title screen has timed out

	; Stop music
	LDA #MUS_STOPMUSIC
	JSR PRG063_QueueMusSnd_SetMus_Cur

	JMP PRG057_8037	; Jump to PRG057_8037


PRG057_808C:
	; Start game / password!

	; Shwing noise
	LDA #SFX_MENUCONFIRM
	JSR PRG063_QueueMusSnd

	LDA Sprite_RAM+$00
	CMP #$97
	BEQ PRG057_809D	; If "game start" was selected, jump to PRG057_809D

	LDA #$00
	JMP PRG057_9672	; Jump to PRG057_9672


PRG057_809D:

	; Put up stage select!
	LDA #$02
	STA <Temp_Var16
	LDA #$00
	STA <MetaBlk_CurScreen
	JSR PRG057_LoadBGTilesPalMusSpr

	; Temp_Var16: Stage select cursor column (0-2)
	LDA #$01
	STA <Temp_Var16
	
	; Temp_Var17: Stage select cursor row (0, 3, 6)
	LDA #$03
	STA <Temp_Var17
	
	; General_Counter = 0 (used for Dr. Cossack's appearance, if needed)
	LDA #$00
	STA <General_Counter
	
	; Do Dr. Cossack's appearance, if needed
	JSR PRG057_SS_DrCAppear

	; Stage select selection loop
PRG057_80B7:
	LDA <Ctlr1_Pressed
	AND #(PAD_A | PAD_START)
	BNE PRG057_80D2	; If Player is pressing A or START, jump to PRG057_80D2

	; Player not pressing A or START...

	JSR PRG057_SS_CursorControl	; Move cursor, if needed


PRG057_80C0:
	
	; Backup Temp_Var16/Temp_Var17 (cursor col/row)
	LDA <Temp_Var16
	PHA
	LDA <Temp_Var17
	PHA
	
	; Frame update
	JSR PRG063_UpdateOneFrame

	; Restore Temp_Var16/Temp_Var17 (cursor col/row)
	PLA
	STA <Temp_Var17
	PLA
	STA <Temp_Var16
	
	JMP PRG057_80B7	; Loop around if nothing else to do


PRG057_80D2:
	; Player pressed A or START

	; Add stage select row/column together to make offset
	LDA <Temp_Var16
	ADD <Temp_Var17
	TAY	; -> 'Y'
	
	LDA PRG057_SS_StageNum,Y
	BMI PRG057_80C0	; If bit $80 set, jump to PRG057_80C0 (ignore selection) (NOTE: Never happens; maybe leftover from a level select you can't re-enter completed bosses?)

	CMP #$08
	BNE PRG057_80E7	; If Player is not attempting to select Dr. Cossack, jump to PRG057_80E7

	; Player is trying to select Dr. Cossack...

	LDY <Player_CompletedBosses
	CPY #$FF
	BNE PRG057_80C0	; If all bosses aren't completed, jump to PRG057_80C0 (ignore selection)


PRG057_80E7:
	; Valid selection made!
	STA <TileMap_Index	; Set the stage!
	
	; Confirm sound effect!
	LDA #SFX_MENUCONFIRM
	JSR PRG063_QueueMusSnd

	LDA <TileMap_Index
	CMP #$08
	BGE PRG057_80FE	; If Dr. Cossack was selected, jump to PRG057_80FE
	
	; Not Dr. Cossack ...

	JSR PRG057_SS_DoBossIntro	; Do the robot master's intro!

	LDA #$00
	STA <MetaBlk_CurScreen
	STA <ScreenUpd_CurCol
	
	RTS	; $80FD


PRG057_80FE:
	LDA <Player_CompletedFortLvls
	CMP #$0F
	BLT PRG057_8107	; If not all Dr. Cossack levels have been completed yet, jump to PRG057_8107

	; Go do Dr. Wily's fortress
	JMP PRG057_DrW_DoFortPaths


PRG057_8107:
	; Fade out
	JSR PRG062_PalFadeOut

	; Clear sprites
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites

	; Commit frame
	JSR PRG063_UpdateOneFrame

	; Disable display
	JSR PRG062_DisableDisplay

	; Load up Cossack Fortress graphics
	LDX #$3E
	JSR PRG062_Upl_SprPal_CHRPats

	; Enable display
	JSR PRG062_EnableDisplay

	LDA #TMAP_COSSACKINTRO
	STA <TileMap_Index
	
	LDA #$00
	STA <MetaBlk_CurScreen
	STA <ScreenUpd_CurCol

	; Draw out Cossack's fortress
PRG057_8129:
	JSR PRG062_SetMBA_DrawColumn
	JSR PRG063_UpdateOneFrame

	INC <ScreenUpd_CurCol	; ScreenUpd_CurCol++
	LDA <ScreenUpd_CurCol
	AND #$1F
	STA <ScreenUpd_CurCol
	BNE PRG057_8129	; Loop

	; Some decorative sprites for the background and the lightening bolts!!
	LDY #(PRG057_DrCF_DetailSprs_End2 - PRG057_DrCF_DetailSprs)
PRG057_813B:
	LDA PRG057_DrCF_DetailSprs-1,Y
	STA Sprite_RAM-1,Y
	
	DEY	; Y--
	BNE PRG057_813B	; While Y > 0, loop

	; General_Counter = 0
	LDA #$00
	STA <General_Counter
	
	; Stop music
	LDA #MUS_STOPMUSIC
	JSR PRG063_QueueMusSnd_SetMus_Cur


PRG057_814D:
	LDX #$00	; X = 0
	LDY #$00	; Y = 0 (post-lightening darkness)
	
	LDA <General_Counter
	AND #$1F
	CMP #$03
	BGE PRG057_8164

	CMP #$00
	BNE PRG057_8162

	; Lightening sound!
	LDA #SFX_COSSACKLIGHTENING
	JSR PRG063_QueueMusSnd


PRG057_8162:
	LDY #$10	; Y = $10 (lightening flash)

PRG057_8164:
	LDA PRG057_DrCF_PalLightening,Y
	STA PalData_1,X
	STA PalData_1+4,X
	
	LDA PRG057_DrCF_PalLightening+4,Y
	STA PalData_1+8,X
	STA PalData_1+12,X
	
	LDA PRG057_DrCF_PalLightening+8,Y
	STA PalData_1+16,X
	STA PalData_1+20,X
	
	LDA PRG057_DrCF_PalLightening+12,Y
	STA PalData_1+24,X
	STA PalData_1+28,X
	
	INY	; Y++ (PRG057_DrCF_PalLightening index)
	INX	; X++ (loop counter)
	
	CPX #$04
	BNE PRG057_8164	; While X < 4, loop

	; Commit palette
	LDA #$FF
	STA <CommitPal_Flag
	
	JSR PRG063_UpdateOneFrame

	INC <General_Counter	; General_Counter++
	LDA <General_Counter
	CMP #$60
	BNE PRG057_814D	; While General_Counter < $60, loop

	; Dr. Cossack fortress palette
	LDY #$1F
PRG057_819F:
	LDA PRG057_DrCF_Pal,Y
	STA PalData_2,Y
	
	DEY	; Y--
	BPL PRG057_819F	; While Y >= 0, loop

	LDY #$30	; Y = $30 (start address of lightening bolt sprites to clear)
	LDA #$F8	; A = $F8 (sprite clear value)
PRG057_81AC:
	STA Sprite_RAM+$00,Y	; Clear lightening bolt sprite
	
	INY
	INY
	INY
	INY	; Y += 4
	
	BNE PRG057_81AC	; Loop until rest of sprites cleared

	; Fade in
	JSR PRG062_PalFadeIn

	; Fortress intro music
	LDA #MUS_COSSACKFORTRESSINTRO
	JSR PRG063_QueueMusSnd_SetMus_Cur

	; Convoluted 2 frame delay?
	LDX #$00
	JSR PRG063_UpdateMultipleFrames
	LDX #$00
	JSR PRG063_UpdateMultipleFrames

	JSR PRG057_DoFortressPalFlash

	LDY #$0F	; Y = $0F
PRG057_81CC:
	LDA PRG057_DrCF_PalDark,Y
	STA PalData_1,Y
	STA PalData_2,Y
	
	CPY #$08
	BGE PRG057_81DF	; If the latter half of BG palette, jump to PRG057_81DF

	STA PalData_1+16,Y
	STA PalData_2+16,Y

PRG057_81DF:
	DEY	; Y--
	BPL PRG057_81CC	; While Y >= 0, loop

	STY <CommitPal_Flag	; Commit palette
	
	; Add the path stops
	LDY #(PRG057_DrCF_PathStopSprs_End - PRG057_DrCF_PathStopSprs)
PRG057_81E6:
	LDA PRG057_DrCF_PathStopSprs-1,Y
	STA Sprite_RAM+$2F,Y
	
	DEY	; Y--
	BNE PRG057_81E6	; While Y >= 0, loop

	LDA #$50
	STA <Sprite_CurrentIndex
	
	LDA <Player_CompletedFortLvls
	AND #$0F
	STA <Temp_Var3	; Temp_Var3 = completed Cossack level bits
	
	; Draw already-completed paths on Cossack fortress
	LDY #$00	; Y = 0 (Cossack level base index)
	JSR PRG057_FortDrawComplPaths_RetY

	; Blink next destination before path for $B4 ticks
	LDX #$B4
	JSR PRG057_FortBlinkDestination

	LDA <Temp_Var2
	TAY		; Y = current level to make path for
	
	; Compute proper TileMap_Index for next level
	ADD #$08
	STA <TileMap_Index
	
	; Draw path to next area
	JSR PRG057_FortDrawPathToNext

	; Blink next destination after path for $F0 ticks
	LDX #$F0
	JSR PRG057_FortBlinkDestination

	LDA #$00
	STA <MetaBlk_CurScreen
	STA <ScreenUpd_CurCol

	RTS	; $8219


PRG057_DoFortressPalFlash:
	; General_Counter = 6
	LDA #$06
	STA <General_Counter

PRG057_821E:
	LDA <General_Counter
	AND #$01
	TAY	; Y = 0 or 1
	
	; Set flash color
	LDA PRG057_SS_DrC_FlashPal,Y
	STA PalData_1+16
	
	; Commit palette
	LDA #$FF
	STA <CommitPal_Flag
	
	; Delay
	LDX #$0A
	JSR PRG063_UpdateMultipleFrames

	DEC <General_Counter	; General_Counter--
	BNE PRG057_821E	; While General_Counter > 0, loop

	RTS	; $8236


PRG057_SS_CursorControl:
	LDA <Ctlr1_Pressed
	AND #(PAD_RIGHT | PAD_LEFT)
	BEQ PRG057_8259	; If Player is not pressing RIGHT or LEFT, jump to PRG057_8259

	; Player pressed LEFT or RIGHT...

	AND #PAD_RIGHT
	BEQ PRG057_824F	; If Player did not press RIGHT, jump to PRG057_824F

	; Player pressed RIGHT...

	; Move to next column and wrap around (Temp_Var16 = 0 to 2)
	INC <Temp_Var16
	LDA <Temp_Var16
	CMP #$03
	BNE PRG057_8281

	LDA #$00
	STA <Temp_Var16
	BEQ PRG057_8281

PRG057_824F:
	; Player pressed LEFT...

	; Move to previous column and wrap around (Temp_Var16 = 0 to 2)
	DEC <Temp_Var16
	BPL PRG057_8281

	LDA #$02
	STA <Temp_Var16
	BNE PRG057_8281

PRG057_8259:
	; Player not pressing RIGHT or LEFT...

	LDA <Ctlr1_Pressed
	AND #(PAD_DOWN | PAD_UP)
	BEQ PRG057_82BF		; If Player is not pressing DOWN or UP, jump to PRG057_82BF

	; Player is pressing DOWN or UP...

	AND #PAD_UP
	BEQ PRG057_8272	; If Player did not press UP, jump to PRG057_8272
	
	; Player pressed UP...

	; Move to next row and wrap (Temp_Var17 = 0, 3, 6)
	LDA <Temp_Var17
	SUB #$03
	STA <Temp_Var17
	BCS PRG057_8281

	LDA #$06
	STA <Temp_Var17
	BNE PRG057_8281

PRG057_8272:

	; Player pressed DOWN...


	; Move to previous row and wrap (Temp_Var17 = 0, 3, 6)
	LDA <Temp_Var17
	ADD #$03
	STA <Temp_Var17
	CMP #$09
	BNE PRG057_8281

	LDA #$00
	STA <Temp_Var17


PRG057_8281:
	
	; Add stage select cursor row and column together into an offset
	LDA <Temp_Var16
	ADD <Temp_Var17
	TAX		; -> offset
	
	; Set stage select cursor sprite Y
	LDA PRG057_SS_CursorSprY,X
	STA Sprite_RAM+$00
	STA Sprite_RAM+$04
	STA Sprite_RAM+$08
	
	; +40 for bottom of cursor
	ADD #40
	STA Sprite_RAM+$0C
	STA Sprite_RAM+$10
	STA Sprite_RAM+$14
	
	; Set stage select cursor sprite X
	LDA PRG057_SS_CursorSprX,X
	STA Sprite_RAM+$03
	STA Sprite_RAM+$0F
	
	; +19 for middle of cursor
	ADD #19
	STA Sprite_RAM+$07
	STA Sprite_RAM+$13
	
	; +19 for right of cursor
	ADD #19
	STA Sprite_RAM+$0B
	STA Sprite_RAM+$17
	
	; Cursor move sound
	LDA #SFX_MENUSELECT
	JSR PRG063_QueueMusSnd


PRG057_82BF:
	LDA <Frame_Counter
	AND #$08
	BEQ PRG057_82EA		; Every other 8 ticks, jump to PRG057_82EA

	; Stage select cursor patterns when illuminated
	LDA PRG057_SSCursorSprDef+1
	STA Sprite_RAM+$01	
	LDA PRG057_SSCursorSprDef+5
	STA Sprite_RAM+$05
	LDA PRG057_SSCursorSprDef+9
	STA Sprite_RAM+$09
	LDA PRG057_SSCursorSprDef+13
	STA Sprite_RAM+$0D
	LDA PRG057_SSCursorSprDef+17
	STA Sprite_RAM+$11
	LDA PRG057_SSCursorSprDef+21
	STA Sprite_RAM+$15
	
	RTS	; $82E9


PRG057_82EA:
	
	; Clear patterns on cursor when not illuminated
	LDA #$15
	STA Sprite_RAM+$01
	STA Sprite_RAM+$05
	STA Sprite_RAM+$09
	STA Sprite_RAM+$0D
	STA Sprite_RAM+$11
	STA Sprite_RAM+$15
	
	RTS	; $82FE


PRG057_SS_DrCAppear:
	LDA <Player_CompletedBosses
	CMP #$FF
	BNE PRG057_833B	; If at least one boss hasn't been defeated yet, jump to PRG057_833B (RTS)

	; All bosses are defeated...

	LDA <General_Counter
	LSR A
	LSR A
	AND #$01
	TAY	; Y = 0 or 1 [General_Counter / 4, bit 0]
	
	LDA PRG057_SS_DrC_FlashPal,Y	; Load white or black for Dr. Cossack's appearance flash
	STA PalData_1+16
	
	; Commit palette
	LDA #$FF
	STA <CommitPal_Flag
	JSR PRG063_UpdateOneFrame

	INC <General_Counter	; General_Counter++
	LDA <General_Counter
	CMP #$28
	BNE PRG057_SS_DrCAppear		; If General_Counter <> $28, loop!


	; Done flashing...

	; Dr. Cossack's overlay sprites
	LDY #(PRG057_SS_DrCOverlaySpr_End - PRG057_SS_DrCOverlaySpr)
PRG057_SS_DrCOverlaySprites:
	LDA PRG057_SS_DrCOverlaySpr-1,Y
	STA Sprite_RAM+$1F,Y
	DEY
	BNE PRG057_SS_DrCOverlaySprites


	; Dr. Cossack's BG tiles
PRG057_832C:
	LDA PRG057_SS_DrCBGTiles,Y
	STA Graphics_Buffer+$00,Y
	CMP #$FF
	BEQ PRG057_8339

	INY
	BNE PRG057_832C


PRG057_8339:
	STA <CommitGBuf_Flag

PRG057_833B:
	RTS	; $833B


PRG057_DrC_DoFortPaths:
	; Fade out (from level)
	JSR PRG062_PalFadeOut

	; Clear sprites
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites
	JSR PRG062_ClearSpriteSlots

	; Clear game state
	JSR PRG057_ClearGameRAM

	; Commit frame
	JSR PRG063_UpdateOneFrame

	; Disable display
	JSR PRG062_DisableDisplay

	; Load up Cossack Fortress graphics
	LDX #$3E
	JSR PRG062_Upl_SprPal_CHRPats

	; Enable display
	JSR PRG062_EnableDisplay

	LDA #TMAP_COSSACKINTRO
	STA <TileMap_Index
	
	LDA #$00
	STA <MetaBlk_CurScreen
	STA <ScreenUpd_CurCol

	; Draw out Cossack's fortress
PRG057_8364:
	JSR PRG062_SetMBA_DrawColumn
	JSR PRG063_UpdateOneFrame

	INC <ScreenUpd_CurCol	; ScreenUpd_CurCol++
	LDA <ScreenUpd_CurCol
	AND #$1F
	STA <ScreenUpd_CurCol
	BNE PRG057_8364	; Loop

	; Some decorative sprites for the background
	LDY #(PRG057_DrCF_DetailSprs_End1 - PRG057_DrCF_DetailSprs)
PRG057_8376:
	LDA PRG057_DrCF_DetailSprs-1,Y
	STA Sprite_RAM-1,Y
	
	DEY	; Y--
	BNE PRG057_8376	; While Y > 0, loop

	; Dr. Cossack fortress palette
	LDY #$1F
PRG057_8381:
	LDA PRG057_DrCF_Pal,Y
	STA PalData_2,Y
	
	DEY	; Y--
	BPL PRG057_8381	; While Y >= 0, loop

	; Fortress intro music
	LDA #MUS_COSSACKFORTRESSINTRO
	JSR PRG063_QueueMusSnd_SetMus_Cur

	JSR PRG063_UpdateOneFrame

	; Fade in
	JSR PRG062_PalFadeIn

	; Convoluted 2 frame delay?
	LDX #$00
	JSR PRG063_UpdateMultipleFrames
	LDX #$00
	JSR PRG063_UpdateMultipleFrames

	JSR PRG057_DoFortressPalFlash

	; Switch to dark palette
	LDY #$1F
PRG057_83A4:
	LDA PRG057_DrCF_PalDark,Y
	STA PalData_1,Y	
	STA PalData_2,Y	
	
	DEY	; Y--
	BPL PRG057_83A4	; While Y >= 0, loop

	STY <CommitPal_Flag	; Commit palette
	
	; Add the path stops
	LDY #(PRG057_DrCF_PathStopSprs_End - PRG057_DrCF_PathStopSprs)
PRG057_83B4:
	LDA PRG057_DrCF_PathStopSprs-1,Y
	STA Sprite_RAM+$2F,Y
	
	DEY	; Y--
	BNE PRG057_83B4	; While Y >= 0, loop

	LDA #$50
	STA <Sprite_CurrentIndex
	
	LDA <Player_CompletedFortLvls
	AND #$0F
	STA <Temp_Var3	; Temp_Var3 = completed Cossack level bits
	
	; Draw already-completed paths on Cossack fortress
	LDY #$00	; Y = 0 (Cossack level base index)
	JSR PRG057_FortDrawComplPaths_RetY

	; Blink next destination before path for $B4 ticks
	LDX #$B4
	JSR PRG057_FortBlinkDestination

	LDA <Temp_Var2
	TAY		; Y = current level to make path for
	
	; Compute proper TileMap_Index for next level
	ADD #$08
	STA <TileMap_Index
	
	; Draw path to next area
	JSR PRG057_FortDrawPathToNext

	; Blink next destination after path for $B4 ticks
	LDX #$B4
	JSR PRG057_FortBlinkDestination

	LDA #$00
	STA <MetaBlk_CurScreen
	STA <ScreenUpd_CurCol
	
	RTS	; $83E7


PRG057_DrW_DoFortPaths:
	; Fade out (from level)
	JSR PRG062_PalFadeOut

	; Clear sprites
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites
	JSR PRG062_ClearSpriteSlots

	; Clear game state
	JSR PRG057_ClearGameRAM

	; Commit frame
	JSR PRG063_UpdateOneFrame

	; Disable display
	JSR PRG062_DisableDisplay

	; Load up Wily Fortress graphics
	LDX #$3F
	JSR PRG062_Upl_SprPal_CHRPats

	; Enable display
	JSR PRG062_EnableDisplay

	LDA #TMAP_COSSACKINTRO
	STA <TileMap_Index
	
	LDA #$02
	STA <MetaBlk_CurScreen
	
	LDA #$00
	STA <ScreenUpd_CurCol

	; Draw out Wily's fortress
PRG057_8412:
	JSR PRG062_SetMBA_DrawColumn
	JSR PRG063_UpdateOneFrame

	INC <ScreenUpd_CurCol	; ScreenUpd_CurCol++
	LDA <ScreenUpd_CurCol
	AND #$1F
	STA <ScreenUpd_CurCol
	BNE PRG057_8412	; Loop

	; Dr. Wily fortress palette
	LDY #$1F
PRG057_8424:
	LDA PRG057_DrW_Pal,Y
	STA PalData_2,Y
	
	DEY	; Y--
	BPL PRG057_8424	; While Y >= 0, loop

	; Fortress intro music
	LDA #MUS_WILYFORTRESSINTRO
	JSR PRG063_QueueMusSnd_SetMus_Cur

	JSR PRG063_UpdateOneFrame

	; Fade in
	JSR PRG062_PalFadeIn

	; Convoluted 2 frame delay?
	LDA #$00
	JSR PRG063_UpdateMultipleFrames
	LDA #$00
	JSR PRG063_UpdateMultipleFrames

	JSR PRG057_DoFortressPalFlash

	; Switch to dark palette
	LDY #$1F
PRG057_8447:
	LDA PRG057_DrW_PalDark,Y
	STA PalData_1,Y	
	STA PalData_2,Y	
	
	DEY	; Y--
	BPL PRG057_8447	; While Y >= 0, loop

	STY <CommitPal_Flag	; Commit palette

	; Add the path stops
	LDY #(PRG057_DrW_PathStopSprs_End2 - PRG057_DrW_PathStopSprs)	; Path stops including final stage

	LDA <Player_CompletedFortLvls
	CMP #$7F
	BEQ PRG057_845F	; If all the Wily levels prior to the last are complete, jump to PRG057_845F

	LDY #(PRG057_DrW_PathStopSprs_End1 - PRG057_DrW_PathStopSprs)	; Path stops excluding final stage

PRG057_845F:
	LDA PRG057_DrW_PathStopSprs-1,Y
	STA Sprite_RAM+$27,Y

	DEY	; Y--
	BNE PRG057_845F	; While Y >= 0, loop

	LDA #$54
	STA <Sprite_CurrentIndex
	
	LDA <Player_CompletedFortLvls
	LSR A
	LSR A
	LSR A
	LSR A
	STA <Temp_Var3	; Temp_Var3 = completed Wily level bits
	
	LDY #$04	; Y = 4 (Wily level base index)
	JSR PRG057_FortDrawComplPaths_RetY

	; Blink next destination before path for $B4 ticks
	LDX #$B4
	JSR PRG057_FortBlinkDestination

	LDA <Temp_Var2
	TAY		; Y = current level to make path for
	
	; Compute proper TileMap_Index for next level
	ADD #$08
	STA <TileMap_Index
	
	; Draw path to next area
	JSR PRG057_FortDrawPathToNext

	; Blink next destination after path for $B4 ticks
	LDX #$B4
	JSR PRG057_FortBlinkDestination

	LDA #$00
	STA <MetaBlk_CurScreen
	STA <ScreenUpd_CurCol
	
	RTS	; $8494


PRG057_LoadBGTilesPalMusSpr:

	; Inputs
	;Temp_Var16:
	;	- Expected index value:
	;		0: Capcom logo
	;		1: Title screen
	;		2: Stage select screen
	;		3: Copyright screen	
	;	- Tilemap (indexes PRG057_TileMapIndexSel)
	;	- Palette select (*32 -> from PRG057_BGMapPalData)
	;	- Music select (indexes PRG057_BGMusicSetting)
	;
	; MetaBlk_CurScreen: Background map

	; Backup Temp_Var16
	LDA <Temp_Var16
	PHA
	
	; Fade out
	JSR PRG062_PalFadeOut

	; Clear all sprites
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites
	JSR PRG063_UpdateOneFrame

	; Restore Temp_Var16
	PLA
	STA <Temp_Var16
	
	; Disable display
	JSR PRG062_DisableDisplay

	LDY <Temp_Var16	; Y = Temp_Var16 (palette select)

	; Set TileMap_Index appropriately
	LDX PRG057_TileMapIndexSel,Y
	STX <TileMap_Index
	
	LDA <MetaBlk_CurScreen
	CMP #$04
	BNE PRG057_84BA	; $84B6

	LDX #$55	; Intro credits

PRG057_84BA:
	JSR PRG062_Upl_SprPal_CHRPats	; $84BA

	JSR PRG062_EnableDisplay	; $84BD

	; Backup Temp_Var16
	LDA <Temp_Var16
	PHA
	
	JSR PRG057_ClearGameRAM


	; Draw out all 32 columns (full screen update)
PRG057_84C6:
	JSR PRG062_SetMBA_DrawColumn
	JSR PRG063_UpdateOneFrame

	INC <ScreenUpd_CurCol
	LDA <ScreenUpd_CurCol
	AND #$1F
	STA <ScreenUpd_CurCol
	BNE PRG057_84C6

	; Restore Temp_Var16
	PLA
	STA <Temp_Var16
	
	; Multiply by 32 to index palette data
	ASL A
	ASL A
	ASL A
	ASL A
	ASL A
	TAY
	
	; Copy palette data
	LDX #$00
PRG057_84E1:
	LDA PRG057_BGMapPalData,Y
	STA PalData_2,X
	INY
	INX
	CPX #$20
	BNE PRG057_84E1

	LDX <Temp_Var16
	BNE PRG057_84F4		; If Temp_Var16 <> 0 (not Capcom logo), jump to PRG057_84F4

	; Capcom logo only
	JMP PRG057_8585		; Jump to PRG057_8585

PRG057_84F4:
	; Anything but the Capcom logo...

	; X = 1 to 3
	
	LDA PRG057_8856,X	; $84F4
	STA <Temp_Var0	; $84F7
	LDA PRG057_885A,X	; $84F9
	STA <Temp_Var1	; $84FC
	
	LDA <Player_CompletedBosses	; $84FE
	STA <Temp_Var2	; $8500
	
	; Copy sprite data in
	LDY #$00
PRG057_8504:
	LDA [Temp_Var0],Y
	CMP #$FF
	BEQ PRG057_8510	; If haven't hit terminator, jump to PRG057_8510

	; Store sprite data
	STA Sprite_RAM+$00,Y
	INY
	BNE PRG057_8504	; Loop


PRG057_8510:
	STY <Temp_Var3	; $8510
	
	CPX #$02
	BNE PRG057_8585	; If not on the stage select screen, jump to PRG057_8585

	LDX #$00
PRG057_8518:
	LDA PRG057_8C4F,X
	STA Graphics_Buffer+$00,X
	CMP #$FF
	BEQ PRG057_8525		; If hit terminator, jump to PRG057_8525

	INX	; X++
	BNE PRG057_8518	; Loop


PRG057_8525:

	; Temp_Var2 = Player_CompletedBosses
	LDA <Player_CompletedBosses
	STA <Temp_Var2
	
	; Temp_Var4 = 0 (loop index for stage select sprite overlays)
	LDX #$00
	STX <Temp_Var4
PRG057_852D:
	LSR <Temp_Var2
	BCC PRG057_855E	; If this boss wasn't completed, jump to PRG057_855E (add his sprite overlay)

	; Boss is completed; setup graphics buffer to cover it over

	LDA PRG057_SS_GBufClearBoss_VRH,X
	STA Graphics_Buffer+$00
	STA Graphics_Buffer+$07
	STA Graphics_Buffer+$0E
	STA Graphics_Buffer+$15
	
	CLC
	
	LDA PRG057_SS_GBufClearBoss_VRL,X
	STA Graphics_Buffer+$01
	ADC #32
	STA Graphics_Buffer+$08
	ADC #32
	STA Graphics_Buffer+$0F
	ADC #32
	STA Graphics_Buffer+$16
	
	; Commit clear panel
	INC <CommitGBuf_Flag
	JSR PRG063_UpdateOneFrame

	JMP PRG057_857D	; Jump to PRG057_857D (next boss on stage select)


PRG057_855E:

	; Pointer to stage select sprite overlays
	LDA PRG057_SS_SprOverlayTable_L,X
	STA <Temp_Var0
	LDA PRG057_SS_SprOverlayTable_H,X
	STA <Temp_Var1
	
	STX <Temp_Var4	; $8568

	; Copy in stage select overlay sprites
	LDY #$00
	LDX <Temp_Var3
PRG057_856E:
	LDA [Temp_Var0],Y
	CMP #$FF
	BEQ PRG057_857D	; If hit terminator, jump to PRG057_857D

	STA Sprite_RAM+$00,X
	INY
	INX
	STX <Temp_Var3
	BNE PRG057_856E


PRG057_857D:
	INC <Temp_Var4
	LDX <Temp_Var4
	CPX #$08
	BNE PRG057_852D	; If haven't done all 8 overlays, loop


PRG057_8585:
	
	; Play appropriate music
	LDX <Temp_Var16
	LDA PRG057_BGMusicSetting,X
	JSR PRG063_QueueMusSnd_SetMus_Cur
	JSR PRG063_UpdateOneFrame

	LDA <TileMap_Index
	CMP #TMAP_CREDITLOGO
	BEQ PRG057_85AA	; If TileMap_Index = $10 (in this context, not the title screen/password), jump to PRG057_85AA

	; Title screen/password screen...

	LDA <MetaBlk_CurScreen	; $01 = password, $02 = title
	CMP #$02
	BNE PRG057_85AA		; If not the title screen, jump to PRG057_85AA

	; Title screen only -- no fade in, just force palette in
	LDY #$1F
PRG057_859E:
	LDA PalData_2,Y
	STA PalData_1,Y
	DEY
	BPL PRG057_859E

	STY <CommitPal_Flag	; Commit palette
	RTS	; $85A9


PRG057_85AA:
	; Except title screen, fade in

	JMP PRG062_PalFadeIn	; $85AA


PRG057_ClearGameRAM:

	; Clear a bunch of RAM!
	LDA #$00
	STA <ScreenUpd_CurCol
	STA <Current_Screen
	STA <Horz_Scroll
	STA <PPU_CTL1_PageBaseReq
	STA <Vert_Scroll
	STA <RAM_00FB
	STA Spr_X+$00
	STA Spr_XHi+$00
	STA Spr_Y+$00
	STA Spr_YHi+$00
	STA <RAM_0025
	STA <RAM_0027
	STA <RAM_0028
	STA <Raster_VMode
	STA <Object_ReqBGSwitch
	STA <RAM_003E
	STA <Player_HitWallR_Flag
	STA <Player_FreezePlayerTicks
	STA RingManRainbowPlat_Data+$00
	STA RingManRainbowPlat_Data+$01
	STA RingManRainbowPlat_Data+$02
	STA RingManRainbowPlat_Data+$03
	STA <RAM_003E
	STA <Player_ShootAnimTimer
	STA <Player_CurShootAnim
	STA <Player_MBusterChargeLevel
	STA <Player_MBustDischargePalIdx
	STA <Player_PlayerHitInv
	STA Weapon_FlashStopCnt+$00
	STA Weapon_FlashStopCnt+$01
	STA Weapon_ToadRainCounter
	STA <CommitBG_ScrSel
	STA Level_LightDarkCtl
	STA Weapon_FlashStopCnt+$00
	STA Weapon_FlashStopCnt+$01
	STA <PPU_CTL1_PageBaseReq
	STA PalAnim_EnSel+$00
	STA PalAnim_EnSel+$01
	STA PalAnim_EnSel+$02
	STA PalAnim_EnSel+$03
	STA HUDBarP_DispSetting
	STA HUDBarW_DispSetting
	STA HUDBarB_DispSetting
	
	; Clear Level_ScreenTileModData array
	LDY #$3F
PRG057_861C:
	STA Level_ScreenTileModData+$00,Y
	
	DEY					; Y--
	BPL PRG057_861C		; While Y >= 0, loop

	LDA #$88	; $8622
	STA <Raster_VSplit_Req	; $8624
	
	RTS	; $8626


	; Draw the already-completed paths on Cossack/Wily fortress
	; Inputs:
	; 'Y' - base relative level index (0 for Cossack, 4 for Wily)
	; Temp_Var3 - completed level bits
	;
	; Returns the current not-completed path index -> 'Y'
PRG057_FortDrawComplPaths_RetY:
	STY <Temp_Var2	; 'Y' -> Temp_Var2
	
	LSR <Temp_Var3
	BCC PRG057_866A	; If all completed levels accounted for, jump to PRG057_866A (RTS)

	; Set base address to this path so we can draw it out
	LDA PRG057_FortPath_SprAddrL,Y
	STA <Temp_Var0
	LDA PRG057_FortPath_SprAddrH,Y
	STA <Temp_Var1
	
	LDY #$00	; Y = 0
	LDX <Sprite_CurrentIndex	; X = Sprite_CurrentIndex

PRG057_863B:
	LDA [Temp_Var0],Y
	BEQ PRG057_8662	; If terminator, jump to PRG057_8662

	; Path sprite Y
	STA Sprite_RAM+$00,X
	INY
	
	; Path pattern
	LDA [Temp_Var0],Y
	STA Sprite_RAM+$01,X
	INY
	
	; Path attributes
	LDA [Temp_Var0],Y
	STA Sprite_RAM+$02,X
	INY
	
	; Path sprite X
	LDA [Temp_Var0],Y
	STA Sprite_RAM+$03,X
	INY
	
	LDA [Temp_Var0],Y
	CMP #$01
	BNE PRG057_865C	; If next path sprite Y value <> 1, jump to PRG057_865C

	; UNUSED - not sure what the purpose of this is/was, but a sprite path
	; with Y = 1 would have done something here? Implemented as a byte skip
	; and otherwise does nothing...
	INY

PRG057_865C:
	INX
	INX
	INX
	INX		; X += 4
	
	BNE PRG057_863B	; Loop


PRG057_8662:
	STX <Sprite_CurrentIndex	; Update Sprite_CurrentIndex
	
	INC <Temp_Var2	; Temp_Var2++ 
	
	LDY <Temp_Var2	; Y = Temp_Var2
	BNE PRG057_FortDrawComplPaths_RetY	; Jump (technically always) to PRG057_FortDrawComplPaths_RetY (loop back up)


PRG057_866A:
	RTS	; $866A


PRG057_FortDrawPathToNext:
	LDA PRG057_FortPath_SprAddrL,Y
	STA <Temp_Var2
	LDA PRG057_FortPath_SprAddrH,Y
	STA <Temp_Var3
	
	LDY #$00	; Y = 0
	LDX <Sprite_CurrentIndex	; X = Sprite_CurrentIndex

PRG057_8679:
	LDA [Temp_Var2],Y
	BEQ PRG057_86B6	; If this is the terminator, jump to PRG057_86B6 (RTS)

	; Path sprite Y
	STA Sprite_RAM+$00,X
	INY
	
	; Path pattern
	LDA [Temp_Var2],Y
	STA Sprite_RAM+$01,X
	INY
	
	; Path attributes
	LDA [Temp_Var2],Y
	STA Sprite_RAM+$02,X
	INY
	
	; Path sprite X
	LDA [Temp_Var2],Y
	STA Sprite_RAM+$03,X
	INY
	
	LDA [Temp_Var2],Y
	CMP #$01
	BNE PRG057_869C	; If next path sprite Y value <> 1, jump to PRG057_865C

	INY
	BNE PRG057_86AA	; Jump (technically always) to PRG057_86AA


PRG057_869C:
	LDA #SFX_PATHDRAW
	JSR PRG063_QueueMusSnd

	; Backup current offset into path data
	TYA
	PHA
	
	; Blink destination for 4 ticks
	LDX #$04
	JSR PRG057_FortBlinkDestination

	; Restore path data offset
	PLA
	TAY

PRG057_86AA:
	INC <Sprite_CurrentIndex
	INC <Sprite_CurrentIndex
	INC <Sprite_CurrentIndex
	INC <Sprite_CurrentIndex
	
	LDX <Sprite_CurrentIndex	; X = Sprite_CurrentIndex
	BNE PRG057_8679	; Jump (technically always) to PRG057_8679


PRG057_86B6:
	RTS	; $86B6


PRG057_FortBlinkDestination:
	STX <Temp_Var16	; 'X' input value -> Temp_Var16

PRG057_86B9:
	LDA <General_Counter
	LSR A
	LSR A
	LSR A
	AND #$01
	STA <Temp_Var0	; Temp_Var0 = 0 or 1, every 8 ticks

	LDY #$00	; Y = 0
	
	LDA <Player_CompletedFortLvls
PRG057_86C6:
	LSR A
	BCC PRG057_86CE	; If all completed levels accounted for, jump to PRG057_86CE

	INY			; Y++
	CPY #$07	
	BNE PRG057_86C6	; If Y <> 7, jump to PRG057_86C6 (max cap for final stage)

PRG057_86CE:
	TYA	
	ASL A
	ASL A
	TAY	; Y = [level path to do] * 4
	
	LDX PRG057_FortBlinkSprData,Y	; X = offset to sprite(s) to modify
	
	LDA PRG057_FortBlinkSprData+1,Y
	STA <Temp_Var1	; Number of sprites to change (minus 1) -> Temp_Var1
	
	; Every 8 ticks add 0 or 1
	TYA
	ADD <Temp_Var0
	TAY
	
	LDA PRG057_FortBlinkSprData+2,Y
	TAY	; Offset into PRG057_FortBlinkSprPats -> 'Y'

PRG057_86E3:
	LDA PRG057_FortBlinkSprPats,Y
	STA Sprite_RAM+$01,X	; Set blink pattern
	
	INX
	INX
	INX
	INX	; X += 4
	
	INY	; Y++
	
	DEC <Temp_Var1	; Temp_Var1--
	BPL PRG057_86E3	; While Temp_Var1 >= 0, loop

	JSR PRG063_UpdateOneFrame

	INC <General_Counter	; General_Counter++
	
	DEC <Temp_Var16	; Temp_Var16--
	BNE PRG057_86B9	; While Temp_Var16 > 0, loop

	RTS	; $86FB


PRG057_FortBlinkSprData:
	; SO = Sprite Offset to (initially) alter
	; NS = Number of sprites to alter (minus 1)
	; F0 = Flash 0 offset into PRG057_FortBlinkSprPats
	; F1 = Flash 1 offset into PRG057_FortBlinkSprPats
	;      SO   NS   F0   F1
	.byte $34, $00, $00, $01	; Cossack 1
	.byte $38, $00, $00, $01	; Cossack 2
	.byte $3C, $00, $00, $01	; Cossack 3
	.byte $40, $03, $02, $06	; Cossack 4
	.byte $2C, $00, $00, $01	; Wily 1
	.byte $30, $00, $00, $01	; Wily 2
	.byte $34, $03, $0A, $0E	; Wily 3
	.byte $44, $03, $0A, $0E	; Wily 4
	
PRG057_FortBlinkSprPats:
	.byte $20					; $00
	.byte $21					; $01
	.byte $16, $17, $18, $19	; $02 - $05
	.byte $1A, $1B, $1C, $1D	; $06 - $09
	.byte $22, $23, $24, $25	; $0A - $0D
	.byte $26, $27, $28, $29	; $0E - $11
	
PRG057_BGMapPalData:
	; $872C - $872E
	; $00
	.byte $0F, $27, $28, $02, $0F, $17, $27, $02, $0F, $20, $32, $23, $0F, $0F, $0F, $0F
	.byte $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F
	
	; $01
	.byte $0F, $11, $2C, $16, $0F, $21, $20, $11, $0F, $26, $20, $16, $0F, $11, $01, $28
	.byte $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $11, $2C, $20, $0F, $26, $28, $16
	
	; $02
	.byte $0F, $30, $10, $11, $0F, $27, $26, $30, $0F, $29, $30, $19, $0F, $37, $26, $16
	.byte $0F, $37, $10, $20, $0F, $28, $37, $19, $0F, $37, $27, $19, $0F, $37, $27, $2C
	
	; $03
	.byte $0F, $30, $30, $30, $0F, $30, $30, $30, $0F, $30, $30, $30, $0F, $30, $30, $30
	.byte $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F


	; Dr. Cossack's Fortress palette for the intermission, after flash, dark color for paths
PRG057_DrCF_PalDark:
	.byte $0F, $11, $01, $0C, $0F, $11, $01, $0C, $0F, $11, $01, $0C, $0F, $11, $01, $0C
	.byte $0F, $11, $01, $0C, $0F, $11, $01, $0C, $0F, $0F, $27, $16, $0F, $0F, $20, $29


	; Dr. Cossack's Fortress palette for the intermission
PRG057_DrCF_Pal:
	.byte $0F, $38, $27, $19, $0F, $38, $26, $15, $0F, $30, $21, $12, $0F, $3B, $19, $17
	.byte $0F, $38, $27, $19, $0F, $2B, $12, $19, $0F, $0F, $27, $16, $0F, $0F, $20, $29

PRG057_DrCF_PalLightening:
	.byte $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F	; Post-lightening darkness
	.byte $0F, $3C, $2C, $1C, $0F, $3C, $2C, $1C, $0F, $3C, $2C, $1C, $0F, $0F, $20, $2C	; Lightening strike
	
PRG057_DrW_Pal:
	.byte $0F, $30, $2C, $1B, $0F, $27, $26, $13, $0F, $30, $27, $26, $0F, $30, $2C, $13
	.byte $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $20, $37, $0F, $0F, $20, $16

PRG057_DrW_PalDark:
	.byte $0F, $11, $01, $0C, $0F, $11, $01, $0C, $0F, $11, $01, $0C, $0F, $11, $01, $0C
	.byte $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $20, $37, $0F, $0F, $20, $16

PRG057_TileMapIndexSel:
	; Value -> TileMap_Index
	.byte TMAP_CREDITLOGO	; 0: Capcom logo
	.byte TMAP_TITLE		; 1: Title screen
	.byte TMAP_CREDITLOGO	; 2: Stage select screen
	.byte TMAP_CREDITLOGO	; 3: Copyright screen	


	; CHECKME - UNUSED?
	.byte $10, $02, $01, $10

PRG057_8856:
	.byte LOW(PRG057_TitleCursorSprDef)	; 0: Capcom logo [NOT USED]
	.byte LOW(PRG057_TitleCursorSprDef)	; 1: Title screen
	.byte LOW(PRG057_SSCursorSprDef)	; 2: Stage select screen
	.byte LOW(PRG057_TitleCursorSprDef)	; 3: Copyright screen	

PRG057_885A:
	.byte HIGH(PRG057_TitleCursorSprDef)	; 0: Capcom logo [NOT USED]
	.byte HIGH(PRG057_TitleCursorSprDef)	; 1: Title screen
	.byte HIGH(PRG057_SSCursorSprDef)	; 2: Stage select screen
	.byte HIGH(PRG057_TitleCursorSprDef)	; 3: Copyright screen	
	
	
PRG057_SS_CursorSprY:
	; Cursor sprite base Y by row/col (as organized)
	.byte $17, $17, $17
	.byte $57, $57, $57
	.byte $97, $97, $97
	
	
PRG057_SS_CursorSprX:
	; Cursor sprite base X by row/col (as organized)
	.byte $19, $69, $B9
	.byte $19, $69, $B9
	.byte $19, $69, $B9
	
	
PRG057_SS_StageNum:
	; Stage number by selection cursor (as organized)
	.byte $04, $06, $07
	.byte $03, $08, $00
	.byte $01, $02, $05

PRG057_BGMusicSetting:
	; Sent to PRG063_QueueMusSnd_SetMus_Cur
	.byte MUS_STOPMUSIC		; 0: Capcom logo
	.byte MUS_TITLETHEME	; 1: Title screen
	.byte MUS_STAGESELECT	; 2: Stage select screen
	.byte MUS_STOPMUSIC		; 3: Copyright screen	

	
	; Dr. Cossack's BG tiles (when added to stage select post-bosses)
PRG057_SS_DrCBGTiles:
	vaddr $218E
	.byte $03
	
	.byte $C2, $C3, $C4, $C5
	
	vaddr $21AE
	.byte $03
	
	.byte $C6, $C7, $C8, $C9
	
	vaddr $21CE
	.byte $03
	
	.byte $CA, $CB, $CC, $CD
	
	vaddr $21EE
	.byte $03
	
	.byte $CE, $CF, $D0, $D1
	
	vaddr $23DB
	.byte $01, $44, $11
	
	.byte $FF

	; Dr. Cossack's flashing palette colors
PRG057_SS_DrC_FlashPal:
	.byte $20, $0F
	
	; Base sprite for title screen cursor
PRG057_TitleCursorSprDef:
	.byte $97, $06, $03, $28
	.byte $FF


	; CHECKME - UNUSED?
	; $88A6
	.byte $57, $00, $02, $E0
	.byte $57, $01, $02, $E8
	.byte $2F, $02, $02, $C0
	.byte $37, $03, $02, $C0
	.byte $3F, $04, $02, $C0
	.byte $43, $05, $03, $B8
	.byte $FF

	; Base sprites for stage select cursor
PRG057_SSCursorSprDef:
	.byte $57, $12, $00, $69
	.byte $57, $13, $00, $7C
	.byte $57, $12, $40, $8F
	.byte $7F, $14, $00, $69
	.byte $7F, $13, $00, $7C
	.byte $7F, $14, $40, $8F
	.byte $FF

	; Dr. Cossack's overlay sprites (when added to stage select post-bosses)
PRG057_SS_DrCOverlaySpr:
	.byte $5F, $1A, $01, $78
	.byte $5F, $1B, $01, $80
	.byte $67, $1C, $01, $78
	.byte $67, $1D, $01, $80
	.byte $6F, $1E, $01, $74
	.byte $6F, $1F, $01, $7C
	.byte $77, $20, $01, $84
	.byte $77, $21, $01, $78
PRG057_SS_DrCOverlaySpr_End

	; Little detail sprites added to Dr. Cossack's fortress during the intermission
PRG057_DrCF_DetailSprs:
	.byte $6F, $00, $00, $40
	.byte $6F, $01, $00, $48
	.byte $6F, $02, $00, $50
	.byte $77, $03, $01, $A0
	.byte $77, $04, $01, $A8
	.byte $7F, $05, $01, $50
	.byte $7F, $06, $01, $58
	.byte $77, $07, $01, $60
	.byte $77, $08, $01, $68
	.byte $57, $09, $01, $78
	.byte $57, $0A, $01, $80
	.byte $7F, $0B, $01, $AD
PRG057_DrCF_DetailSprs_End1		; Dr. Cossack's fortress sans lightening bolts

	.byte $07, $10, $02, $38
	.byte $0F, $10, $02, $38
	.byte $17, $14, $02, $30
	.byte $17, $15, $02, $38
	.byte $1F, $10, $02, $30
	.byte $27, $12, $02, $30
	.byte $27, $13, $02, $38
	.byte $2F, $14, $02, $30
	.byte $2F, $15, $02, $38
	.byte $37, $10, $02, $30
	.byte $3F, $10, $02, $30
	.byte $47, $15, $02, $30
	.byte $07, $10, $02, $D0
	.byte $0F, $10, $02, $D0
	.byte $17, $12, $02, $D0
	.byte $17, $13, $02, $D8
	.byte $1F, $10, $02, $D8
	.byte $27, $14, $02, $D0
	.byte $27, $15, $02, $D8
	.byte $2F, $10, $02, $D0
	.byte $37, $14, $02, $C8
	.byte $37, $11, $02, $D0
	.byte $37, $13, $02, $D8
	.byte $3F, $14, $02, $C0
	.byte $3F, $15, $02, $C8
	.byte $3F, $12, $02, $D8
	.byte $47, $10, $02, $C0
	.byte $4F, $15, $02, $C0
PRG057_DrCF_DetailSprs_End2		; Dr. Cossack's fortress with lightening bolts

	; Path nubs and the end star for Dr. Cossack's Fortress
PRG057_DrCF_PathStopSprs:
	; Path nubs
	.byte $CF, $20, $03, $18
	.byte $A7, $20, $03, $38
	.byte $77, $20, $03, $50
	.byte $67, $20, $03, $80
	
	; Final star
	.byte $BF, $16, $02, $A4
	.byte $BF, $17, $02, $AC
	.byte $C7, $18, $02, $A4
	.byte $C7, $19, $02, $AC
PRG057_DrCF_PathStopSprs_End


	; CHECKME - UNUSED?
	.byte $4F, $3F, $00, $A0, $4F, $40, $00, $A8, $57, $41, $00, $A0, $77, $34, $00, $A0	; $89B8 - $89C7
	.byte $77, $35, $00, $A8, $8F, $39, $00, $B8, $97, $3A, $00, $B8, $9F, $3A, $00, $B8	; $89C8 - $89D7
	.byte $A7, $3D, $01, $40, $A7, $3E, $01, $48
	
	
PRG057_DrW_PathStopSprs:
	.byte $B7, $20, $03, $20
	.byte $8F, $20, $03, $50
	.byte $67, $20, $03, $98
	.byte $A7, $22, $02, $A8
	.byte $A7, $23, $02, $B0
	.byte $AF, $24, $02, $A8
	.byte $AF, $25, $02, $B0
PRG057_DrW_PathStopSprs_End1	; End of Wily fortress path sprites before final stage is revealed

	.byte $BF, $22, $02, $D8
	.byte $BF, $23, $02, $E0
	.byte $C7, $24, $02, $D8
	.byte $C7, $25, $02, $E0
PRG057_DrW_PathStopSprs_End2	; End of Wily fortress path sprites including final stage

PRG057_8A0C:	
	.byte $CF, $1F, $03, $20
	.byte $CF, $1E, $C3, $28
	.byte $C7, $2A, $03, $28
	.byte $BF, $1E, $03, $28
	.byte $BF, $1E, $C3, $30
	.byte $B7, $2A, $03, $30
	.byte $AF, $2A, $03, $30
	.byte $A7, $1E, $03, $30
	
	; Terminator
	.byte $00
	
PRG057_8A2D:
	.byte $9F, $2A, $03, $38
	.byte $97, $1E, $03, $38
	.byte $97, $1E, $C3, $40
	.byte $8F, $2A, $03, $40
	.byte $87, $1E, $03, $40
	.byte $87, $1E, $C3, $48
	.byte $7F, $2A, $03, $48
	.byte $77, $1E, $03, $48
	
	; Terminator
	.byte $00
	
PRG057_8A4E:
	.byte $77, $1E, $C3, $58
	.byte $6F, $1E, $03, $58
	.byte $6F, $1F, $03, $60
	.byte $6F, $1E, $C3, $68
	.byte $67, $1E, $03, $68
	.byte $67, $1F, $03, $70
	.byte $67, $1F, $03, $78
	
	; Terminator
	.byte $00

PRG057_8A6B:	
	.byte $6F, $2A, $03, $80
	.byte $77, $2A, $03, $80
	.byte $7F, $1E, $83, $80
	.byte $7F, $2B, $03, $88
	.byte $7F, $1F, $03, $90
	.byte $01, $87, $2A, $03
	.byte $88, $7F, $1E, $43
	.byte $98, $01, $8F, $1E
	.byte $83, $88, $87, $2A
	.byte $03, $98, $01, $8F
	.byte $1F, $03, $90, $8F
	.byte $2B, $83, $98, $8F
	.byte $1E, $43, $A0, $97
	.byte $2A, $03, $A0, $9F
	.byte $2A, $03, $A0, $A7
	.byte $1E, $83, $A0, $A7
	.byte $1E, $43, $A8, $AF
	.byte $2A, $03, $A8, $B7
	.byte $2A, $03, $A8		; ??
	
	; Terminator (this will work due to loop logic, but a sprite will be partially erroneously written??)
	.byte $00
	
PRG057_8AB7:
	.byte $AF, $2A, $03, $20
	.byte $A7, $2A, $03, $20
	.byte $9F, $1E, $03, $20
	.byte $9F, $1F, $03, $28
	.byte $9F, $1F, $03, $30
	.byte $9F, $1F, $03, $38
	.byte $9F, $1E, $C3, $40
	.byte $97, $2A, $03, $40
	.byte $8F, $1E, $03, $40
	.byte $8F, $1F, $03, $48
	
	; Terminator
	.byte $00
	
PRG057_8AE0:
	.byte $8F, $1F, $03, $58
	.byte $8F, $1F, $03, $60
	.byte $8F, $1E, $C3, $68
	.byte $87, $1E, $03, $68
	.byte $87, $1F, $03, $70
	.byte $87, $1F, $03, $78
	.byte $87, $1E, $C3, $80
	.byte $7F, $2A, $03, $80
	.byte $77, $2A, $03, $80
	.byte $6F, $2A, $03, $80
	.byte $67, $1E, $03, $80
	.byte $67, $1F, $03, $88
	.byte $67, $1F, $03, $90
	
	; Terminator
	.byte $00
	
PRG057_8B15:
	.byte $6F, $2A, $03, $98
	.byte $77, $2A, $03, $98
	.byte $7F, $2A, $03, $98
	.byte $87, $2A, $03, $98
	.byte $8F, $2A, $03, $98
	.byte $97, $2A, $03, $98
	.byte $9F, $2A, $03, $98
	.byte $A7, $1E, $83, $98
	.byte $A7, $1F, $03, $A0
	
	; Terminator
	.byte $00
	
PRG057_8B3A:
	.byte $AF, $1F, $03, $B8
	.byte $AF, $1E, $43, $C0
	.byte $B7, $2A, $03, $C0
	.byte $BF, $1E, $83, $C0
	.byte $BF, $1F, $03, $C8
	.byte $BF, $1F, $03, $D0
	
	; Terminator
	.byte $00


PRG057_FortPath_SprAddrL:
	.byte LOW(PRG057_8A0C)	; Cossack 1 complete path
	.byte LOW(PRG057_8A2D)	; Cossack 2 complete path
	.byte LOW(PRG057_8A4E)	; Cossack 3 complete path
	.byte LOW(PRG057_8A6B)	; Cossack 4 complete path
	
	.byte LOW(PRG057_8AB7)	; Wily 1 complete path
	.byte LOW(PRG057_8AE0)	; Wily 2 complete path
	.byte LOW(PRG057_8B15)	; Wily 3 complete path
	.byte LOW(PRG057_8B3A)	; Wily 4 complete path

PRG057_FortPath_SprAddrH:
	.byte HIGH(PRG057_8A0C)	; Cossack 1 complete path
	.byte HIGH(PRG057_8A2D)	; Cossack 2 complete path
	.byte HIGH(PRG057_8A4E)	; Cossack 3 complete path
	.byte HIGH(PRG057_8A6B)	; Cossack 4 complete path
	
	.byte HIGH(PRG057_8AB7)	; Wily 1 complete path
	.byte HIGH(PRG057_8AE0)	; Wily 2 complete path
	.byte HIGH(PRG057_8B15)	; Wily 3 complete path
	.byte HIGH(PRG057_8B3A)	; Wily 4 complete path
	
	
PRG057_SS_BrightManOverlay:
	; Bright Man's stage select sprite overlays
	.byte $5F, $30, $00, $C4
	.byte $5F, $31, $00, $CC
	.byte $5F, $32, $00, $D4
	.byte $67, $33, $00, $C4
	.byte $67, $34, $00, $CC
	.byte $67, $35, $00, $D4
	.byte $6F, $36, $00, $C4
	.byte $6F, $37, $00, $CC
	.byte $6F, $38, $00, $D4
	.byte $77, $39, $00, $C8
	.byte $77, $3A, $00, $D0
	.byte $FF
	
PRG057_SS_ToadManOverlay:
	; Toad Man's stage select sprite overlays
	.byte $9F, $09, $01, $27
	.byte $9F, $0A, $01, $2F
	.byte $A7, $0B, $01, $24
	.byte $A7, $0C, $01, $2C
	.byte $A7, $0D, $01, $34
	.byte $AF, $0E, $01, $24
	.byte $AF, $0F, $01, $2C
	.byte $AF, $10, $01, $34
	.byte $B7, $11, $01, $27
	.byte $B7, $3D, $01, $2F
	.byte $FF
	
PRG057_SS_DrillManOverlay:
	; Drill Man's stage select sprite overlays
	.byte $9F, $22, $00, $77
	.byte $9F, $23, $00, $7F
	.byte $9F, $24, $00, $87
	.byte $A7, $25, $00, $74
	.byte $A7, $26, $00, $7C
	.byte $A7, $27, $00, $84
	.byte $AF, $28, $00, $78
	.byte $AF, $29, $00, $80
	.byte $B7, $2A, $00, $78
	.byte $B7, $2B, $00, $80
	.byte $FF
	
PRG057_SS_PharaohManOverlay:
	; Pharaoh Man's stage select sprite overlays
	.byte $67, $07, $02, $28
	.byte $6F, $08, $02, $28
	.byte $FF

PRG057_SS_RingManOverlay:
	; Ring Man's stage select sprite overlays
	.byte $27, $00, $00, $20
	.byte $27, $01, $00, $28
	.byte $27, $02, $00, $30
	.byte $2F, $03, $00, $25
	.byte $2F, $04, $00, $2D
	.byte $2F, $05, $00, $35
	.byte $37, $06, $00, $30
	.byte $FF
	
PRG057_SS_DustManOverlay:
	; Dust Man's stage select sprite overlays
	.byte $B7, $3B, $03, $C8
	.byte $B7, $3C, $03, $D0
	.byte $FF
	
PRG057_SS_DiveManOverlay:
	; Dive Man's stage select sprite overlays
	.byte $1F, $3E, $03, $7C
	.byte $27, $3F, $03, $78
	.byte $27, $40, $03, $80
	.byte $2F, $41, $03, $78
	.byte $2F, $42, $03, $80
	.byte $37, $18, $03, $78
	.byte $37, $19, $03, $80
	.byte $FF
	
PRG057_SS_SkullManOverlay:
	; Skull Man's stage select sprite overlays
	.byte $27, $2C, $02, $C7
	.byte $27, $2D, $02, $CF
	.byte $2F, $2E, $02, $C6
	.byte $2F, $2F, $02, $CE
	.byte $FF

PRG057_SS_SprOverlayTable_L:
	; $8C3B - $8C3F
	.byte LOW(PRG057_SS_BrightManOverlay)
	.byte LOW(PRG057_SS_ToadManOverlay)
	.byte LOW(PRG057_SS_DrillManOverlay)
	.byte LOW(PRG057_SS_PharaohManOverlay)
	.byte LOW(PRG057_SS_RingManOverlay)
	.byte LOW(PRG057_SS_DustManOverlay)
	.byte LOW(PRG057_SS_DiveManOverlay)
	.byte LOW(PRG057_SS_SkullManOverlay)
	
PRG057_SS_SprOverlayTable_H:
	; $8C3F - $8C47
	.byte HIGH(PRG057_SS_BrightManOverlay)
	.byte HIGH(PRG057_SS_ToadManOverlay)
	.byte HIGH(PRG057_SS_DrillManOverlay)
	.byte HIGH(PRG057_SS_PharaohManOverlay)
	.byte HIGH(PRG057_SS_RingManOverlay)
	.byte HIGH(PRG057_SS_DustManOverlay)
	.byte HIGH(PRG057_SS_DiveManOverlay)
	.byte HIGH(PRG057_SS_SkullManOverlay)

PRG057_8C4F:
	; $8C47 - $8C4F
	
	vaddr $2000
	.byte $03
	
	.byte $00, $00, $00, $00
	
	vaddr $2000
	.byte $03
	
	.byte $00, $00, $00, $00
	
	vaddr $2000
	.byte $03
	
	.byte $00, $00, $00, $00
	
	vaddr $2000
	.byte $03
	
	.byte $00, $00, $00, $00
	
	.byte $FF
	

	; VRAM High and Low base addresses for the "boss clear" black overlays on the stage select
PRG057_SS_GBufClearBoss_VRL:	.byte $98, $84, $8E, $84, $84, $98, $8E, $98
PRG057_SS_GBufClearBoss_VRH:	.byte $21, $22, $22, $21, $20, $22, $20, $20



	; Entry point for:
	;	Game Over (if Player_State = PLAYERSTATE_DEAD)
	;	Weapon Get sequence (If TileMap_Index < 8)
	;	Cossack / Wily fortress intro
PRG057_DoLevelIntermission:
	LDA <Player_State
	CMP #PLAYERSTATE_DEAD
	BNE PRG057_8C85	; If Player is not dead (thus not doing game over), jump to PRG057_8C85

	JMP PRG057_8EF7	; Jump to PRG057_8EF7 (Game Over sequence)


PRG057_8C85:
	; Not Game Over...

	LDY <TileMap_Index
	CPY #TMAP_COSSACK1
	BGE PRG057_8C95	; If post-stage select stage, jump to PRG057_8C95

	; Not a Cossack / Wily fortress stage...

	LDA <Player_CompletedBosses
	AND PRG063_IndexToBit,Y
	BEQ PRG057_8C95	; If boss was not already completed, jump to PRG057_8C95

	; Boss already completed, jump to PRG057_8E78
	JMP PRG057_8E78


PRG057_8C95:
	; New robot master defeated OR a fortress stage of sorts...

	LDA <TileMap_Index
	PHA	; Backup TileMap_Index
	
	AND #$07
	TAY	; Y = 0 to 7 (relative index either within robot masters or fortress stages)
	
	PLA	; Restore TileMap_Index 
	
	LSR A
	LSR A
	LSR A
	TAX		; X = 0 if stage select robot master stage, 1 if Cossack/Wily fortress stage
	
	; Set completion bit on Player_CompletedBosses / Player_CompletedFortLvls as appropriate
	LDA <Player_CompletedBosses,X
	ORA PRG063_IndexToBit,Y
	STA <Player_CompletedBosses,X
	
	CPX #$01
	BNE PRG057_8CBC	; If this is NOT a fortress level, jump to PRG057_8CBC

	LDA <Player_CompletedFortLvls
	CMP #$0F
	BEQ PRG057_8CB9	; If all the Cossack levels have been completed (but none of the Wily ones), jump to PRG057_8CB9 (PRG057_90C7)
	
	BGE PRG057_8CB6	; If at least one Wily level has been completed, jump to PRG057_8CB6 (PRG057_DrW_DoFortPaths)

	JMP PRG057_DrC_DoFortPaths	; Otherwise, jump to PRG057_DrC_DoFortPaths


PRG057_8CB6:
	; At least one Wily level completed (Wily fortress continues)
	JMP PRG057_DrW_DoFortPaths	; $8CB6


PRG057_8CB9:
	; All Cossack levels completed, none of the Wily ones (Wily Fortress intro)
	JMP PRG057_90C7	; $8CB9


PRG057_8CBC:
	; Standard stage select stage...

	; Fade out
	JSR PRG062_PalFadeOut

	; Clear out the sprites and such
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites
	JSR PRG062_ClearSpriteSlots

	; Clear out game state
	JSR PRG057_ClearGameRAM
	
	; Commit frame
	JSR PRG063_UpdateOneFrame

	; Disable display
	JSR PRG062_DisableDisplay

	; Load up graphics for weapon get transition!
	LDX #$16
	JSR PRG062_Upl_SprPal_CHRPats

	; Enable display
	JSR PRG062_EnableDisplay

	LDA #$00
	STA <MetaBlk_CurScreen
	
	; Save TileMap_Index
	LDA <TileMap_Index
	PHA
	
	; TileMap_Index = $11 (for the weapon transition screen)
	LDA #TMAP_TITLE
	STA <TileMap_Index

	; Commit all 32 columns of screen
PRG057_8CE5:
	JSR PRG062_SetMBA_DrawColumn
	JSR PRG063_UpdateOneFrame

	INC <ScreenUpd_CurCol
	LDA <ScreenUpd_CurCol
	AND #$1F
	STA <ScreenUpd_CurCol
	
	BNE PRG057_8CE5		; Loop

	; Restore TileMap_Index
	PLA
	STA <TileMap_Index
	
	; Copy in palette for weapon get screen
	LDY #$1F
PRG057_8CFA:
	LDA PRG057_WeaponGetBGPal,Y
	STA PalData_2,Y
	
	DEY
	BPL PRG057_8CFA

	LDX #$00	; X = 0
	
	LDA #SPRSLOTID_PLAYER		; arbitrary choice to get to sprites in banks 12-13
	STA Spr_SlotID+$00
	
	LDA #SPRANM2_ROCKHEAD_SPIN
	JSR PRG063_SetSpriteAnim

	LDA #$90	; $8D0F
	STA Spr_Flags+$00	; $8D11
	
	LDA #$00
	STA Spr_XHi+$00
	STA Spr_YHi+$00
	
	; Position of head
	LDA #$70
	STA Spr_Y+$00
	LDA #$80
	STA Spr_X+$00
	
	JSR PRG063_DrawSprites_RsetSprIdx
	JSR PRG063_UpdateOneFrame

	; Refill all weapon energies
	LDY #$0E	; Y = $0E
PRG057_8D2E:
	LDA Player_HP,Y
	BPL PRG057_8D38	; If this power is not acquired, jump to PRG057_8D38

	; Refill weapon energy
	LDA #$9C
	STA Player_HP,Y

PRG057_8D38:
	DEY	; Y--
	BPL PRG057_8D2E	; While Y >= 0, loop!

	; Get Weapon Music!
	LDA #MUS_GETWEAPON
	JSR PRG063_QueueMusSnd_SetMus_Cur

	; Fade in!
	JSR PRG062_PalFadeIn

	INC <DisFlag_NMIAndDisplay	; $8D43

PRG057_8D45:
	JSR PRG063_DrawSprites_RsetSprIdx

	LDA Spr_Frame+$00
	CMP #$08
	BNE PRG057_8D45	; If head hasn't finished rotating, jump to PRG057_8D45

	; Delay
	LDX #$1E
	JSR PRG063_UpdateMultipleFrames


PRG057_8D54:
	DEC Spr_X+$00	; Slide head left
	JSR PRG063_DrawSprites_RsetSprIdx	; Draw head

	; Hold animation
	LDA #$00
	STA Spr_AnimTicks+$00
	
	LDA Spr_X+$00
	CMP #$48
	BNE PRG057_8D54	; If head isn't in position, jump to PRG057_8D54 (loop around)

	LDY #$00
	STY <DisFlag_NMIAndDisplay	; $8D68
	
	; Init text writer
	JSR PRG057_TextWrite

	; Delay 10 ticks
	LDX #$0A
	JSR PRG063_UpdateMultipleFrames

	LDY <TileMap_Index	; Y = TileMap_Index
	
	LDX PRG057_WeaponIdxForTileMap,Y	; X = appropriate index into Player_HP
	
	; Give weapon, fully charged
	LDA #$9C
	STA <Player_HP,X
	
	INY	; Y = 1
	JSR PRG057_TextWrite

	; General_Counter = $3C
	LDA #$3C
	STA <General_Counter

PRG057_8D83:
	LDX #$00	; X = 0
	
	LDY #$00	; Y = 0
	
	LDA <General_Counter
	LSR A
	LSR A
	BCS PRG057_8D96	; 1:2 ticks jump to PRG057_8D96

	LDA <TileMap_Index
	ADC #$01	; (note carry is implicitly clear by above check)
	ASL A
	ASL A
	ASL A
	ASL A
	TAY	; Y = (TileMap_Index + 1) * 16

PRG057_8D96:
	LDA PRG057_WeaponGetPals,Y
	STA PalData_1+16,X
	STA PalData_2+16,X
	
	INY	; Y++
	INX	; X++
	CPX #$10
	BNE PRG057_8D96	; If didn't copy all 16 colors, loop!

	; Commit palette
	LDA #$FF
	STA <CommitPal_Flag
	JSR PRG063_UpdateOneFrame

	DEC <General_Counter
	BNE PRG057_8D83	; While General_Counter > 0, loop

	; Delay
	LDX #$3C
	JSR PRG063_UpdateMultipleFrames

	LDX #$03	; X = 3 (Rush Marine's Player_HP index for weapon energy)
	
	LDA <TileMap_Index
	CMP #TMAP_TOADMAN
	BEQ PRG057_8DC5	; If this was Toad Man's power get (also getting Rush Marine), jump to PRG057_8DC5

	; Not Toad Man...

	DEX	; X = 2 (Rush Jet's Player_HP index for weapon energy)
	
	CMP #TMAP_DRILLMAN
	BEQ PRG057_8DC5	; If this was Drill Man's power get (also getting Rush Jet), jump to PRG057_8DC5

	; No Rush power...

	JMP PRG057_8E78	; Jump to PRG057_8E78


PRG057_8DC5:
	
	; Grant appropriate Rush power!
	LDA #$9C
	STA <Player_HP,X
	
	LDA #$70	; $8DC9
	STA <Pal_FadeMask	; $8DCB
	
	; Fade out
	JSR PRG062_PalFadeOut

	; Clear sprites
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites

	; Clear text for Rush
	LDX #$00
PRG057_8DD9:
	LDA PRG057_TextClearForRush,X
	STA Graphics_Buffer+$00,X
	
	CMP #$FF
	BEQ PRG057_8DE6	; If terminator, jump to PRG057_8DE6

	INX	; X++
	BNE PRG057_8DD9	; Loop


PRG057_8DE6:
	STA <CommitGBuf_Flag
	JSR PRG063_UpdateOneFrame

	; General_Counter = 0
	LDA #$00
	STA <General_Counter

PRG057_8DEF:
	LDA <General_Counter
	AND #$01
	TAY	; Y = 0 or 1

	; Get red / not for Rush flashing
	LDA PRG057_RushPalRedFlash,Y
	STA PalData_1+3
	
	; Commit palette change
	LDA #$FF
	STA <CommitPal_Flag
	
	; Delay
	LDX #$0A
	JSR PRG063_UpdateMultipleFrames

	INC <General_Counter	; General_Counter++
	
	LDA <General_Counter
	CMP #$04
	BNE PRG057_8DEF	; If General_Counter < 4, loop

	; Delay
	LDX #$3C
	JSR PRG063_UpdateMultipleFrames

	LDX #$00	; X = 0
	
	LDA #SPRANM3_WEAPONGET_RUSH
	JSR PRG063_SetSpriteAnim

	LDA #SPRSLOTID_BOSSINTRO		; Arbitrary choice to get to bank 14-15 sprites
	STA Spr_SlotID+$00
	
	; Position Rush
	LDA #$80
	STA Spr_X+$00

	; Copy in Rush's palette
PRG057_8E21:
	LDA PRG057_RushWeaponGetPal,X
	STA PalData_2+16,X
	
	INX	; X++
	CPX #$10
	BNE PRG057_8E21	; While X < 16, loop

	JSR PRG063_DrawSprites_RsetSprIdx

	LDA #$00
	STA <DisFlag_NMIAndDisplay	; $8E31
	
	JSR PRG063_UpdateOneFrame

	; Mask BG pals that don't change for Rush
	LDA #%01110000
	STA <Pal_FadeMask
	
	; Fade in
	JSR PRG062_PalFadeIn

	; Delay
	LDX #$1E
	JSR PRG063_UpdateMultipleFrames


PRG057_8E42:
	DEC Spr_X+$00	; Slide Rush left
	JSR PRG063_DrawSprites_RsetSprIdx

	LDA Spr_X+$00
	CMP #$48
	BNE PRG057_8E42	; If Rush is not in place, loop

	LDA <Temp_Var0
	STA <DisFlag_NMIAndDisplay	; $8E51
	
	; Init text writer
	LDY #$00
	JSR PRG057_TextWrite

	; Delay
	LDX #$0A
	JSR PRG063_UpdateMultipleFrames

	LDY #$09	; Y = 9 (Rush Jet)
	
	LDA <TileMap_Index
	CMP #TMAP_DRILLMAN
	BEQ PRG057_8E66	; If this was Drill Man (thus Rush Jet), jump to PRG057_8E66

	INY	; Y = 10 (Rush Marine)

PRG057_8E66:
	JSR PRG057_TextWrite

	; Delay
	LDX #$0A
	JSR PRG063_UpdateMultipleFrames

	LDY #$13	; Y = $13 (Adapter)
	JSR PRG057_TextWrite

	; Delay
	LDX #$3C
	JSR PRG063_UpdateMultipleFrames


PRG057_8E78:
	; Common continuation point with or without Rush...

	; Delay
	LDX #$3C
	JSR PRG063_UpdateMultipleFrames

	; STAGE SELECT / CONTINUE text
	LDA #$01
	JSR PRG057_DrawInterScreen

	; Music
	LDA #MUS_PASSWORD
	JSR PRG063_QueueMusSnd_SetMus_Cur

	; Generate appropriate password
	JSR PRG057_GeneratePassword

	LDA TileMap_IndexBackup
	STA <TileMap_Index

PRG057_8E8F:
	; Cursor at primary position
	LDA #$AF
	STA Sprite_RAM+$90
	LDA #$02
	STA Sprite_RAM+$91
	LDA #$00
	STA Sprite_RAM+$92
	LDA #$48
	STA Sprite_RAM+$93

PRG057_8EA3:
	LDA <Ctlr1_Pressed
	AND #(PAD_START | PAD_A)
	BNE PRG057_8ECC	; If Player is pressing A / START, jump to PRG057_8ECC

	LDA <Ctlr1_Pressed
	AND #(PAD_SELECT | PAD_UP | PAD_DOWN)
	BEQ PRG057_8EC6	; If Player is not pressing SELECT / UP / DOWN, jump to PRG057_8EC6

	; Cursor move!
	LDA #SFX_MENUSELECT
	JSR PRG063_QueueMusSnd

	; Swap cursor position
	LDA Sprite_RAM+$90
	ADD #$10
	STA Sprite_RAM+$90
	CMP #$CF
	BNE PRG057_8EC6

	LDA #$AF
	STA Sprite_RAM+$90

PRG057_8EC6:


	; Update frame
	JSR PRG063_UpdateOneFrame

	JMP PRG057_8EA3	; Jump to PRG057_8EA3 (go back around)


PRG057_8ECC:
	; Player confirmed STAGE SELECT / CONTINUE menu...

	LDA Sprite_RAM+$90
	CMP #$BF
	BEQ PRG057_RefillWeapsRsetMidPoint	; If Player select STAGE SELECT, jump to PRG057_RefillWeapsRsetMidPoint

	; Confirmation sound
	LDA #SFX_MENUCONFIRM
	JSR PRG063_QueueMusSnd

	JSR PRG057_RefillWeapsRsetMidPoint	; Refill weapons energy

	JMP PRG057_809D	; Return to stage select!


PRG057_RefillWeapsRsetMidPoint:
	; Confirmation sound
	LDA #SFX_MENUCONFIRM
	JSR PRG063_QueueMusSnd

	; Refill all weapons energy
	LDY #$0F
PRG057_8EE5:
	LDA Player_HP,Y
	BPL PRG057_8EEF

	LDA #$9C
	STA Player_HP,Y

PRG057_8EEF:
	DEY
	BPL PRG057_8EE5

	; Player_Midpoint = 0
	LDA #$00
	STA <Player_Midpoint
	
	RTS	; $8EF6


PRG057_8EF7:
	; Game Over...

	; Reset Player's lives
	LDA #$02
	STA <Player_Lives
	
	; "GAME OVER" text
	LDA #$04
	JSR PRG057_DrawInterScreen

	LDA #MUS_GAMEOVER
	JSR PRG063_QueueMusSnd_SetMus_Cur

	; Display password
	JSR PRG057_GeneratePassword

	; Update frame
	LDX #$00
	JSR PRG063_UpdateMultipleFrames

	; Password music
	LDA #MUS_PASSWORD
	JSR PRG063_QueueMusSnd_SetMus_Cur

	; Restore TileMap_Index
	LDA TileMap_IndexBackup
	STA <TileMap_Index
	
	LDX #$01	; X = 1 (index into PRG057_InterScreen_TextTable, "STAGE SELECT / CONTINUE")
	
	LDA <TileMap_Index
	CMP #$08
	BGE PRG057_8F25	; If at Cossack's or later, jump to PRG057_8F25

	; Not at Cossack's...

	; STAGE SELECT / CONTINUE text
	JSR PRG057_DrawInterScreenText

	JMP PRG057_8E8F	; Jump to PRG057_8E8F


PRG057_8F25:
	; Cossack's+...

	INX		; X = 2 (index into PRG057_InterScreen_TextTable, "CONTINUE" only)
	
	; CONTINUE text
	JSR PRG057_DrawInterScreenText

	; Fixed cursor at CONTINUE
	LDA #$B7
	STA Sprite_RAM+$90
	LDA #$02
	STA Sprite_RAM+$91
	LDA #$00
	STA Sprite_RAM+$92
	LDA #$48
	STA Sprite_RAM+$93

	; Idle loop waiting for A / START
PRG057_8F3D:
	LDA <Ctlr1_Pressed
	AND #(PAD_START | PAD_A)
	BNE PRG057_RefillWeapsRsetMidPoint	; If Player is pressing A / START, jump to PRG057_RefillWeapsRsetMidPoint

	; Update frame
	JSR PRG063_UpdateOneFrame

	JMP PRG057_8F3D	; Loop forever until A / START


	; Loads the intermission screen
	; Input 'A' indexes PRG057_InterScreen_TextTable
PRG057_DrawInterScreen:
	PHA	; Save input value
	
	; Fade out
	JSR PRG062_PalFadeOut

	; Clear things, update frame
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites
	JSR PRG057_ClearGameRAM
	JSR PRG063_UpdateOneFrame

	; Disable display
	JSR PRG062_DisableDisplay

	; Load up palette and graphics
	LDX #$17
	JSR PRG062_Upl_SprPal_CHRPats

	; Enable display
	JSR PRG062_EnableDisplay

	; The password screen
	LDA #$01
	STA <MetaBlk_CurScreen
	
	LDA #TMAP_TITLE
	STA <TileMap_Index

	; Render out the screen
PRG057_8F6D:
	JSR PRG062_SetMBA_DrawColumn
	JSR PRG063_UpdateOneFrame

	INC <ScreenUpd_CurCol
	LDA <ScreenUpd_CurCol
	AND #$1F
	STA <ScreenUpd_CurCol
	BNE PRG057_8F6D
	

	PLA	; Restore input value
	TAX	; -> 'X'
	
	JSR PRG057_DrawInterScreenText	; Add appropriate text

	; Intermission screen palette
	LDY #$1F
PRG057_8F84:
	LDA PRG057_InterScreenPal,Y
	STA PalData_2,Y
	DEY
	BPL PRG057_8F84

	; Update frame
	JSR PRG063_UpdateOneFrame

	; Fade in!
	JMP PRG062_PalFadeIn


	; Robot master's intro...
PRG057_SS_DoBossIntro:
	; Fade out...
	JSR PRG062_PalFadeOut

	; Clear sprites and sprite slots
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites
	JSR PRG062_ClearSpriteSlots
	JSR PRG063_UpdateOneFrame

	; Disable display
	JSR PRG062_DisableDisplay

	; Since only robot masters use this, TileMap_Index is 0 to 7
	LDA <TileMap_Index
	ORA #24	
	TAX		; X = 24 to 31
	JSR PRG062_Upl_SprPal_CHRPats

	; Enable display
	JSR PRG062_EnableDisplay

	LDA #$00
	STA <ScreenUpd_CurCol
	LDA #$02
	STA <MetaBlk_CurScreen
	
	; Backup TileMap_Index
	LDA <TileMap_Index
	PHA
	
	; Set TileMap_Index to $10
	LDA #TMAP_CREDITLOGO
	STA <TileMap_Index

	; Full screen BG update
PRG057_8FC0:
	JSR PRG062_SetMBA_DrawColumn
	JSR PRG063_UpdateOneFrame

	INC <ScreenUpd_CurCol
	LDA <ScreenUpd_CurCol
	AND #$1F
	STA <ScreenUpd_CurCol
	BNE PRG057_8FC0

	; Restore TileMap_Index
	PLA
	STA <TileMap_Index
	
	ASL A
	ASL A
	ASL A
	ASL A
	TAY	; Y = TileMap_Index * 16
	
	; Copies a whole BG palette in for the boss (even though it mostly doesn't get used!)
	LDX #$00	; $8FD8
PRG057_8FDA:
	LDA PRG057_SS_BossIntroBGPal,Y
	STA PalData_2,X
	
	; All black sprite palette
	LDA #$0F
	STA PalData_2+16,X
	
	INY
	INX
	CPX #16
	BNE PRG057_8FDA

	LDA <TileMap_Index
	ASL A
	ADC <TileMap_Index
	ADC #146
	TAY	; Y = (TileMap_Index * 3) + 146
	
	LDX #$01
PRG057_8FF5:
	TYA	; $8FF5
	STA PalAnim_EnSel+$00,X	; $8FF6
	
	LDA #$00	; $8FF9
	STA PalAnim_CurAnimOffset+$00,X	; $8FFB
	STA PalAnim_TickCount+$00,X	; $8FFE
	
	INY
	INX
	CPX #$04
	BNE PRG057_8FF5

	LDX #$00	; $9007
	
	; Boss sprite for intro
	LDA #SPRSLOTID_BOSSINTRO
	STA Spr_SlotID+$00
	
	; Set intro animation
	LDA <TileMap_Index
	ADD #SPRANM3_BOSSINT_BRIGHT
	JSR PRG063_SetSpriteAnim

	LDA #$90	; $9016
	STA Spr_Flags+$00	; $9018
	
	LDA #$00
	STA Spr_XHi+$00
	STA Spr_YHi+$00
	
	; Position boss intro sprite
	LDA #$74
	STA Spr_Y+$00
	LDA #$80
	STA Spr_X+$00

	LDA <TileMap_Index
	CMP #$04
	BNE PRG057_9049	; If this isn't Ring Man, jump to PRG057_9049

	; Ring Man only... he gets a stupid little sparkle

	; Copy Ring Man's sprite slot data into slot 1 for the twinkle
	LDY #$01	; Slot index 1
	LDA #SPRANM3_BOSS_RMSPARKLE
	JSR PRG063_CopySprSlotSetAnim

	LDA #$7F
	STA Spr_X+$01
	LDA #$63
	STA Spr_Y+$01
	
	LDA #SPRSLOTID_BOSSINTRO
	STA Spr_SlotID+$01

PRG057_9049:
	JSR PRG063_DrawSprites_RsetSprIdx

	LDA #$00	; $904C
	STA <DisFlag_NMIAndDisplay	; $904E
	
	; Robot Master intro music
	LDA #MUS_BOSSINTRO
	JSR PRG063_QueueMusSnd_SetMus_Cur

	; Fade in
	JSR PRG062_PalFadeIn

	; Temp_Var15 = $30 (fade level)
	LDA #$30
	STA <Temp_Var15

PRG057_905C:
	LDX #$00	; $905C

	LDA <TileMap_Index
	ASL A
	ASL A
	ASL A
	TAY	; Y = TileMap_Index * 8

	; Copy in boss palette
PRG057_9064:
	; Common colors
	LDA PRG057_SS_BossIntroCommonPal,X	; Target color
	SUB <Temp_Var15	; Fade
	BCS PRG057_906E	; If not "too dark", jump to PRG057_906E

	LDA #$0F	; If fade below zero, just use black
	
PRG057_906E:
	STA PalData_1+16,X
	STA PalData_2+16,X
	
	
	; Boss-specific colors
	LDA PRG057_SS_BossIntroSpecificPal,Y	; Target color
	SUB <Temp_Var15	; Fade
	BCS PRG057_907E	; If not "too dark", jump to PRG057_907E

	LDA #$0F	; If fade below zero, just use black

PRG057_907E:
	STA PalData_1+24,X
	STA PalData_2+24,X
	
	INY
	INX
	CPX #$08
	BNE PRG057_9064


	; Commit palette
	LDA #$FF
	STA <CommitPal_Flag
	
	LDX #$0A	; $908E
	JSR PRG063_UpdateMultipleFrames	; $9090

	; More boss palette fade in to go?
	LDA <Temp_Var15
	SUB #$10
	STA <Temp_Var15
	BCS PRG057_905C	; If not faded in yet, loop!

	; Loop until boss has finished animating
PRG057_909C:
	JSR PRG063_DrawSprites_RsetSprIdx

	LDA Spr_Frame+$00
	CMP #$05
	BNE PRG057_909C	; If boss's intro animation frame <> 5, loop!

	LDA #$00
	STA <DisFlag_NMIAndDisplay
	
	LDA <TileMap_Index
	ADD #$0B	; Offset to start of boss names (see PRG057_BossIntTextTable_L/H)
	TAY		; Y = TileMap_Index + $0B
	JSR PRG057_TextWrite

	; Delay end of intro
	LDX #$F0
	JSR PRG063_UpdateMultipleFrames

	LDA #$00	; $90B8
	STA PalAnim_EnSel+$00	; $90BA
	STA PalAnim_EnSel+$01	; $90BD
	STA PalAnim_EnSel+$02	; $90C0
	STA PalAnim_EnSel+$03	; $90C3
	
	RTS	; $90C6


PRG057_90C7:
	; Fade out (from level)
	JSR PRG062_PalFadeOut

	; Clear sprites
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites
	JSR PRG062_ClearSpriteSlots

	; Clear game state
	JSR PRG057_ClearGameRAM

	; Commit frame
	JSR PRG063_UpdateOneFrame

	; Disable display
	JSR PRG062_DisableDisplay

	; Load up Wily starry background / ship graphics
	LDX #$40
	JSR PRG062_Upl_SprPal_CHRPats

	; Enable display
	JSR PRG062_EnableDisplay

	LDA #$00
	STA <ScreenUpd_CurCol

	LDA #$01
	STA <MetaBlk_CurScreen

	LDA #TMAP_COSSACKINTRO
	STA <TileMap_Index

	; Draw out starry background behind Wily
PRG057_90F1:
	JSR PRG062_SetMBA_DrawColumn
	JSR PRG063_UpdateOneFrame

	INC <ScreenUpd_CurCol	; ScreenUpd_CurCol++
	LDA <ScreenUpd_CurCol
	AND #$1F
	STA <ScreenUpd_CurCol
	BNE PRG057_90F1	; Loop

	; Dr. Wily fortress palette
	LDY #$1F
PRG057_9103:
	LDA PRG057_DrW_StarBGShipPal,Y
	STA PalData_2,Y
	
	DEY	; Y--
	BPL PRG057_9103	; While Y >= 0, loop

	LDX #$00	; X = 0
	
	LDA #SPRANM2_WILYSHIP_INTRO
	JSR PRG063_SetSpriteAnim

	LDA #$80	; $9113
	STA Spr_Flags+$00	; $9115

	LDA #SPRSLOTID_PLAYER		; arbitrary choice to get to sprites in banks 12-13
	STA Spr_SlotID+$00

	; Position Wily's ship
	LDA #$80
	STA Spr_X+$00
	LDA #$F0
	STA Spr_Y+$00
	
	; Copy in "closer" 3D stars
	LDY #(PRG057_DrW_StarBG3DSprs_End - PRG057_DrW_StarBG3DSprs - 1)
PRG057_9129:
	LDA PRG057_DrW_StarBG3DSprs,Y
	STA Sprite_RAM+$00,Y
	
	DEY	; Y--
	BPL PRG057_9129	; While Y >= 0, loop

	; Vertical mirroring
	LDA #$01
	STA MMC3_MIRROR
	
	; Commit frame
	JSR PRG063_UpdateOneFrame

	; Stop music
	LDA #MUS_STOPMUSIC
	JSR PRG063_QueueMusSnd_SetMus_Cur

	; Fade in
	JSR PRG062_PalFadeIn

	LDA #$00
	STA <Temp_Var45
	STA <Temp_Var46
	STA <Temp_Var47
	STA <Temp_Var48
	STA <Temp_Var49

PRG057_914E:
	LDA <General_Counter
	AND #$01
	BEQ PRG057_9163	; Every other tick, jump to PRG057_9163

	DEC Spr_Y+$00	; Wily ship moving up
	
	LDA Spr_Y+$00
	AND #$07
	BNE PRG057_9163	; 7:8 ticks jump to PRG057_9163

	; Play Wily ship sound!
	LDA #SFX_WILYSHIP
	JSR PRG063_QueueMusSnd

PRG057_9163:
	; Draw the ship
	LDA #$14
	STA <Sprite_CurrentIndex
	JSR PRG063_DrawSprites

	LDA Spr_Y+$00
	CMP #$80
	BNE PRG057_914E	; If Wily ship is not in position, loop around!


PRG057_9171:
	LDA <Temp_Var48
	CMP #$04
	BEQ PRG057_9186	; If Temp_Var48 = 4, jump to PRG057_9186

	INC <Temp_Var46	; Temp_Var46++ (acceleration)
	
	; Temp_Var47/48 += Temp_Var46
	LDA <Temp_Var47
	ADD <Temp_Var46
	STA <Temp_Var47
	LDA <Temp_Var48
	ADC #$00
	STA <Temp_Var48

PRG057_9186:
	
	; Temp_Var49/Horz_Scroll += Temp_Var47/Temp_Var48
	LDA <Temp_Var49
	ADD <Temp_Var47
	STA <Temp_Var49
	LDA <Horz_Scroll
	ADC <Temp_Var48	
	STA <Horz_Scroll
	
	JSR PRG057_WilyStarBG_ScrlStars

	LDA <General_Counter
	AND #$0F
	BNE PRG057_91A1	; 15:16 jump to PRG057_91A1

	; Wily ship sound
	LDA #SFX_WILYSHIP
	JSR PRG063_QueueMusSnd

PRG057_91A1:
	; Draw Wily ship!
	LDA #$14
	STA <Sprite_CurrentIndex
	JSR PRG063_DrawSprites

	DEC <Temp_Var45	; Temp_Var45--
	BNE PRG057_9171	; While Temp_Var45 > 0, loop!


PRG057_91AC:
	
	; Temp_Var47/48 -= Temp_Var46
	LDA <Temp_Var47
	SUB <Temp_Var46
	STA <Temp_Var47
	LDA <Temp_Var48
	SBC #$00
	STA <Temp_Var48
	
	BCC PRG057_91E2	; If underflowed, jump to PRG057_91E2

	DEC <Temp_Var46	; Temp_Var46--
	
	; Temp_Var49/Horz_Scroll += Temp_Var47/48
	LDA <Temp_Var49
	ADD <Temp_Var47
	STA <Temp_Var49
	LDA <Horz_Scroll
	ADC <Temp_Var48	
	STA <Horz_Scroll
	
	JSR PRG057_WilyStarBG_ScrlStars	

	LDA <General_Counter
	AND #$0F
	BNE PRG057_91D8	; 15:16 jump to PRG057_91D8

	; Wily ship sound
	LDA #SFX_WILYSHIP
	JSR PRG063_QueueMusSnd

PRG057_91D8:
	; Draw Wily ship!
	LDA #$14
	STA <Sprite_CurrentIndex
	JSR PRG063_DrawSprites

	JMP PRG057_91AC	; Jump to PRG057_91AC


PRG057_91E2:
	LDA #SPRANM2_WILYSHIP_EYEBROWS
	LDX #$00
	JSR PRG063_SetSpriteAnim

	LDY #$01	; Y = 1
	LDA #SPRANM2_WILYSHIP_TOPONLY
	JSR PRG063_CopySprSlotSetAnim

	LDA #$80	; $91F0
	STA Spr_Flags+$01	; $91F2
	
	LDA #SPRSLOTID_PLAYER		; arbitrary choice to get to sprites in banks 12-13
	STA Spr_SlotID+$01

PRG057_91FA:
	DEC Spr_Y+$01	; Top of ship lifting up
	
	; Draw Wily's ship!
	LDA #$14
	STA <Sprite_CurrentIndex
	JSR PRG063_DrawSprites

	; General_Counter = 0
	LDA #$00
	STA <General_Counter
	
	LDA Spr_Y+$01
	CMP #$50
	BNE PRG057_91FA	; If Wily ship top hasn't reached apex, loop!

	; Draw for $B4 frames
	LDA #$B4
	JSR PRG057_DrawSpritesXTimes


PRG057_9214:
	INC Spr_Y+$01	; Wily ship top closing
	
	; Draw Wily ship!
	LDA #$14
	STA <Sprite_CurrentIndex
	JSR PRG063_DrawSprites

	; General_Counter = 0
	LDA #$00
	STA <General_Counter
	
	LDA Spr_Y+$01
	CMP #$80
	BNE PRG057_9214	; If Wily ship top has not closed, loop!
	

	; Don't need seperate top anymore!
	LDY #$01
	JSR PRG063_DeleteObjectY

	LDA #SPRANM2_WILYSHIP_INTRO
	LDX #$00
	JSR PRG063_SetSpriteAnim

	; Draw ship for $3C ticks
	LDA #$3C
	JSR PRG057_DrawSpritesXTimes

	LDA #SPRANM2_WILYSHIP_3DDEPART
	LDX #$00
	JSR PRG063_SetSpriteAnim

PRG057_9241:
	; Draw Wily's ship
	LDA #$14
	STA <Sprite_CurrentIndex
	JSR PRG063_DrawSprites

	LDA Spr_SlotID+$00
	BNE PRG057_9241	; While the ship is still animating, loop!

	LDA #$00	; $924D
	STA <DisFlag_NMIAndDisplay	; $924F
	
	JMP PRG057_DrW_DoFortPaths	; Jump to PRG057_DrW_DoFortPaths


PRG057_WilyStarBG_ScrlStars:
	LDA <Temp_Var47
	STA <Temp_Var0	
	
	LDA <Temp_Var48
	STA <Temp_Var1	
	
	ASL <Temp_Var0	
	ROL <Temp_Var1	
	
	LDY #$14	; Y = $14
PRG057_9262:
	; Shift star sprites left
	LDA Sprite_RAM+$03,Y
	SUB <Temp_Var1
	STA Sprite_RAM+$03,Y
	
	; Y -= 4
	DEY
	DEY
	DEY
	DEY
	
	BPL PRG057_9262	; While Y >= 0 (more stars), loop

	RTS	; $9271


PRG057_DrawSpritesXTimes:
	PHA	; Save current loop value
	
	LDA #$1C
	STA <Sprite_CurrentIndex
	JSR PRG063_DrawSprites

	PLA	; Restore loop value
	
	SUB #$01
	BNE PRG057_DrawSpritesXTimes	; While loop value >= 0, loop!

	RTS	; $9280


PRG057_TextWrite:
	STY <Temp_Var4	; Offset into PRG057_BossIntTextTable_L/H
	
	; Point to string to write out
	LDA PRG057_BossIntTextTable_L,Y
	STA <Temp_Var2
	LDA PRG057_BossIntTextTable_H,Y
	STA <Temp_Var3
		
	; Length TBD
	LDY #$00
	STY Graphics_Buffer+$02
	
	; The VRAM address
	LDA [Temp_Var2],Y
	STA Graphics_Buffer+$00
	INY
	LDA [Temp_Var2],Y
	STA Graphics_Buffer+$01
	INY

PRG057_929E:
	LDA [Temp_Var2],Y	; Next character
	CMP #$FF
	BEQ PRG057_92C8		; If terminator, jump to PRG057_92C8 (RTS)

	; Store next character
	STA Graphics_Buffer+$03
	
	; Buffer terminator
	LDA #$FF
	STA Graphics_Buffer+$04
	STA <CommitGBuf_Flag	; $92AC
	
	LDA <Temp_Var4
	CMP #$0B
	BLT PRG057_92B8	; If Temp_Var4 < $0B (not a robot master name), jump to PRG057_92B8

	; A robot master name... potentially...

	CMP #$13	
	BLT PRG057_92BD	; If Temp_Var4 < $13 (definitely a robot master name), jump to PRG057_92BD

	; NOT a robot master name...

PRG057_92B8:
	; "Typing" noise
	LDA #SFX_LETTERTYPE
	JSR PRG063_QueueMusSnd


PRG057_92BD:
	LDX #$0A
	JSR PRG063_UpdateMultipleFrames

	; Next VRAM position to the right
	INC Graphics_Buffer+$01
	
	INY	; Next character index
	BNE PRG057_929E	; Loop again...


PRG057_92C8:
	RTS	; $92C8


PRG057_DrawInterScreenText:
	LDY PRG057_InterScreen_TextTable,X	; Y = index to start of intermission screen text
	
	LDX #$00	; X = 0 (offset into graphics buffer)
	
PRG057_92CE:
	LDA PRG057_InterScreen_Text,Y	; Next character
	STA Graphics_Buffer+$00,X	; Store into graphics buffer
	CMP #$FF
	BEQ PRG057_92DC	; If this is the terminator, jump to PRG057_92DC

	INY
	INX
	BNE PRG057_92CE	; Loop!


PRG057_92DC:
	STA <CommitGBuf_Flag	; Commit graphics buffer
	RTS	; $92DE


	; BG palette
PRG057_WeaponGetBGPal:
	.byte $0F, $29, $19, $0F, $0F, $3C, $2C, $11, $0F, $2C, $11, $01, $0F, $00, $00, $00

	; Sprite palettes (note base palette is committed at start with BG pal)
PRG057_WeaponGetPals:
	.byte $0F, $2C, $11, $01, $0F, $20, $37, $27, $0F, $20, $11, $27, $0F, $2C, $11, $16	; Base blue palette
	
	; Palettes by TileMap_Index (i.e. robot master that was just defeated)
	.byte $0F, $20, $14, $04, $0F, $20, $37, $27, $0F, $20, $14, $27, $0F, $20, $14, $16	; 0 TMAP_BRIGHTMAN
	.byte $0F, $31, $29, $19, $0F, $20, $37, $27, $0F, $20, $29, $27, $0F, $31, $29, $16	; 1
	.byte $0F, $10, $16, $06, $0F, $20, $37, $27, $0F, $20, $16, $27, $0F, $10, $16, $16	; 2
	.byte $0F, $36, $26, $16, $0F, $20, $37, $27, $0F, $20, $26, $27, $0F, $36, $26, $16	; 3
	.byte $0F, $38, $18, $08, $0F, $20, $37, $27, $0F, $20, $18, $27, $0F, $38, $18, $16	; 4
	.byte $0F, $20, $10, $00, $0F, $20, $37, $27, $0F, $20, $10, $27, $0F, $20, $10, $16	; 5
	.byte $0F, $20, $11, $01, $0F, $20, $37, $27, $0F, $20, $11, $27, $0F, $20, $11, $16	; 6
	.byte $0F, $3C, $21, $1C, $0F, $20, $37, $27, $0F, $20, $21, $27, $0F, $3C, $21, $16	; 7

PRG057_RushWeaponGetPal:
	.byte $0F, $20, $16, $06, $0F, $20, $16, $27, $0F, $20, $37, $27, $0F, $37, $16, $06


PRG057_RushPalRedFlash:
	.byte $16, $0F
	
	
	; Palette for Wily's starry background and ship escape
PRG057_DrW_StarBGShipPal:
	.byte $0F, $30, $21, $0B, $0F, $27, $26, $13, $0F, $30, $27, $19, $0F, $30, $21, $13
	.byte $0F, $0F, $11, $2C, $0F, $0F, $28, $20, $0F, $0F, $20, $37, $0F, $0F, $0F, $0F

PRG057_WeaponIdxForTileMap:
	; Index into Player_HP to match up with weapon obtained by TileMap_Index
	.byte $0C, $04, $09, $0B, $08, $0A, $07, $0D
	

	; Clear weapon get text for Rush
PRG057_TextClearForRush:
	vaddr $214F
	.byte $06
	
	.byte $9B, $9B, $9B, $9B, $9B, $9B, $9B
	
	vaddr $218F
	.byte $0D
	
	.byte $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B, $9B
	
	.byte $FF
		
	
PRG057_TextYouGot:
	vaddr $214F
	
	;       Y    O    U         G    O    T
	.byte $98, $8E, $94, $9A, $86, $8E, $93, $FF
	
PRG057_TextFlashStopper:
	vaddr $218F
	
	;       F    L    A    S    H         S    T    O    P    P    E    R
	.byte $85, $8B, $80, $92, $87, $9A, $92, $93, $8E, $8F, $8F, $84, $91, $FF
	
PRG057_TextRainFlush:
	vaddr $218F
	
	;       R    A    I    N         F    L    U    S    H
	.byte $91, $80, $88, $8D, $9A, $85, $8B, $94, $92, $87, $FF
	
PRG057_TextDrillBomb:
	vaddr $218F
	
	;       D    R    I    L    L         B    O    M    B
	.byte $83, $91, $88, $8B, $8B, $9A, $81, $8E, $8C, $81, $FF
	
PRG057_TextPharaohShot:
	vaddr $218F

	;       P    H    A    R    A    O    H         S    H    O    T
	.byte $8F, $87, $80, $91, $80, $8E, $87, $9A, $92, $87, $8E, $93, $FF
	
PRG057_TextRingBoomerang:
	vaddr $218F
	
	;       R    I    N    G         B    O    O    M    E    R    A    N    G
	.byte $91, $88, $8D, $86, $9A, $81, $8E, $8E, $8C, $84, $91, $80, $8D, $86, $FF

PRG057_TextDustCrusher:
	vaddr $218F
	
	;       D    U    S    T         C    R    U    S    H    E    R
	.byte $83, $94, $92, $93, $9A, $82, $91, $94, $92, $87, $84, $91, $FF
	
PRG057_TextDiveMissile:
	vaddr $218F
	
	;       D    I    V    E         M    I    S    S    I    L    E
	.byte $83, $88, $95, $84, $9A, $8C, $88, $92, $92, $88, $8B, $84, $FF
	
PRG057_TextSkullBarrier:
	vaddr $218F
	
	;       S    K    U    L    L         B    A    R    R    I    E    R
	.byte $92, $8A, $94, $8B, $8B, $9A, $81, $80, $91, $91, $88, $84, $91, $FF
	
PRG057_TextRushJet:
	vaddr $218F
	
	;       R    U    S    H         J    E    T
	.byte $91, $94, $92, $87, $9A, $89, $84, $93, $FF
	
PRG057_TextRushMarine:
	vaddr $218F
	
	;       R    U    S    H         M    A    R    I    N    E
	.byte $91, $94, $92, $87, $9A, $8C, $80, $91, $88, $8D, $84, $FF
	
PRG057_TextBrightMan:
	vaddr $224B
	
	;       B    R    I    G    H    T         M    A    N
	.byte $81, $91, $88, $86, $87, $93, $9A, $8C, $80, $8D, $FF
	
PRG057_TextToadMan:
	vaddr $224C
	
	;       T    O    A    D         M    A    N
	.byte $93, $8E, $80, $83, $9A, $8C, $80, $8D, $FF
	
PRG057_TextDrillMan:
	vaddr $224B
	
	;       D    R    I    L    L         M    A    N
	.byte $83, $91, $88, $8B, $8B, $9A, $8C, $80, $8D, $FF
	
PRG057_TextPharaohMan:
	vaddr $224A
	
	;       P    H    A    R    A    O    H         M    A    N
	.byte $8F, $87, $80, $91, $80, $8E, $87, $9A, $8C, $80, $8D, $FF
	
PRG057_TextRingMan:
	vaddr $224C
	
	;       R    I    N    G         M    A    N
	.byte $91, $88, $8D, $86, $9A, $8C, $80, $8D, $FF
	
PRG057_TextDustMan:
	vaddr $224C
	
	;       D    U    S    T         M    A    N
	.byte $83, $94, $92, $93, $9A, $8C, $80, $8D, $FF
	
PRG057_TextDiveMan:
	vaddr $224C
	
	;       D    I    V    E         M    A    N
	.byte $83, $88, $95, $84, $9A, $8C, $80, $8D, $FF
	
PRG057_TextSkullMan:
	vaddr $224B
	
	;       S    K    U    L    L         M    A    N
	.byte $92, $8A, $94, $8B, $8B, $9A, $8C, $80, $8D, $FF
	
PRG057_TextAdapter:
	vaddr $21D5
	
	;       A    D    A    P    T    E    R
	.byte $80, $83, $80, $8F, $93, $8E, $91, $FF

PRG057_BossIntTextTable_L:
	.byte LOW(PRG057_TextYouGot)	; $00
	.byte LOW(PRG057_TextFlashStopper)	; $01
	.byte LOW(PRG057_TextRainFlush)	; $02
	.byte LOW(PRG057_TextDrillBomb)	; $03
	.byte LOW(PRG057_TextPharaohShot)	; $04
	.byte LOW(PRG057_TextRingBoomerang)	; $05
	.byte LOW(PRG057_TextDustCrusher)	; $06
	.byte LOW(PRG057_TextDiveMissile)	; $07
	.byte LOW(PRG057_TextSkullBarrier)	; $08
	.byte LOW(PRG057_TextRushJet)	; $09
	.byte LOW(PRG057_TextRushMarine)	; $0A
	.byte LOW(PRG057_TextBrightMan)	; $0B
	.byte LOW(PRG057_TextToadMan)	; $0C
	.byte LOW(PRG057_TextDrillMan)	; $0D
	.byte LOW(PRG057_TextPharaohMan)	; $0E
	.byte LOW(PRG057_TextRingMan)	; $0F
	.byte LOW(PRG057_TextDustMan)	; $10
	.byte LOW(PRG057_TextDiveMan)	; $11
	.byte LOW(PRG057_TextSkullMan)	; $12
	.byte LOW(PRG057_TextAdapter)	; $13

	; UNUSED strange, redundant entries (old reservations?)
	.byte LOW(PRG057_TextPharaohShot)	; $14
	.byte LOW(PRG057_TextRingBoomerang)	; $15
	.byte LOW(PRG057_TextDustCrusher)	; $16
	.byte LOW(PRG057_TextDiveMissile)	; $17



PRG057_BossIntTextTable_H:
	.byte HIGH(PRG057_TextYouGot)	; $00
	.byte HIGH(PRG057_TextFlashStopper)	; $01
	.byte HIGH(PRG057_TextRainFlush)	; $02
	.byte HIGH(PRG057_TextDrillBomb)	; $03
	.byte HIGH(PRG057_TextPharaohShot)	; $04
	.byte HIGH(PRG057_TextRingBoomerang)	; $05
	.byte HIGH(PRG057_TextDustCrusher)	; $06
	.byte HIGH(PRG057_TextDiveMissile)	; $07
	.byte HIGH(PRG057_TextSkullBarrier)	; $08
	.byte HIGH(PRG057_TextRushJet)	; $09
	.byte HIGH(PRG057_TextRushMarine)	; $0A
	.byte HIGH(PRG057_TextBrightMan)	; $0B
	.byte HIGH(PRG057_TextToadMan)	; $0C
	.byte HIGH(PRG057_TextDrillMan)	; $0D
	.byte HIGH(PRG057_TextPharaohMan)	; $0E
	.byte HIGH(PRG057_TextRingMan)	; $0F
	.byte HIGH(PRG057_TextDustMan)	; $10
	.byte HIGH(PRG057_TextDiveMan)	; $11
	.byte HIGH(PRG057_TextSkullMan)	; $12
	.byte HIGH(PRG057_TextAdapter)	; $13

	; UNUSED strange, redundant entries (old reservations?)
	.byte HIGH(PRG057_TextPharaohShot)	; $14
	.byte HIGH(PRG057_TextRingBoomerang)	; $15
	.byte HIGH(PRG057_TextDustCrusher)	; $16
	.byte HIGH(PRG057_TextDiveMissile)	; $17



PRG057_InterScreenPal:
	.byte $11, $30, $2C, $01, $11, $01, $30, $0F, $11, $00, $00, $00, $11, $00, $00, $00
	.byte $11, $30, $11, $16, $11, $00, $00, $00, $11, $00, $00, $00, $11, $00, $00, $00

PRG057_InterScreen_TextTable:
	.byte (PRG057_Text_Blanks1 - PRG057_InterScreen_Text)			; 0
	.byte (PRG057_Text_SSElectCont - PRG057_InterScreen_Text)		; 1
	.byte (PRG057_Text_ContOnly - PRG057_InterScreen_Text)			; 2
	.byte (PRG057_Text_PasswordError - PRG057_InterScreen_Text)		; 3
	.byte (PRG057_Text_GameOver - PRG057_InterScreen_Text)			; 4
	
PRG057_InterScreen_Text:

PRG057_Text_Blanks1:
	vaddr $22E9
	.byte $0E
	
	; Blanks
	.byte $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A
	
	.byte $FF
	
	
PRG057_Text_SSElectCont:
	vaddr $22CB
	.byte $0B
	
	;       S    T    A    G    E         S    E    L    E    C    T
	.byte $92, $93, $80, $86, $84, $9A, $92, $84, $8B, $84, $82, $93
	
	vaddr $230B
	.byte $07
	
	;       C    O    N    T    I    N    U    E
	.byte $82, $8E, $8D, $93, $88, $8D, $94, $84
	
	vaddr $22EC
	.byte $08
	
	; Blanks
	.byte $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A, $9A
	
	.byte $FF
	
	
PRG057_Text_ContOnly:
	vaddr $22EB
	.byte $09

	;       C    O    N    T    I    N    U    E
	.byte $82, $8E, $8D, $93, $88, $8D, $94, $84, $9A, $9A
	
	.byte $FF
	
	
PRG057_Text_PasswordError:
	vaddr $22E9
	.byte $0E
	
	;       P    A    S    S         W    O    R    D         E    R    R    O    R
	.byte $8F, $80, $92, $92, $9A, $96, $8E, $91, $83, $9A, $84, $91, $91, $8E, $91
	
	.byte $FF
	
PRG057_Text_GameOver:
	vaddr $22EC
	.byte $08
	
	;       G    A    M    E         O    V    E    R
	.byte $86, $80, $8C, $84, $9A, $8E, $95, $84, $91
	
	.byte $FF


PRG057_SS_BossIntroBGPal:
	; Interestingly, this sets an ENTIRE BG palette per boss, which is then mostly
	; overwritten by the rotating palette colors!
	.byte $0F, $30, $2C, $11, $0F, $36, $26, $16, $0F, $16, $26, $36, $0F, $16, $16, $16	; Bright Man
	.byte $0F, $30, $2C, $11, $0F, $30, $38, $29, $0F, $29, $38, $30, $0F, $29, $29, $29	; Toad Man
	.byte $0F, $30, $2C, $11, $0F, $20, $10, $16, $0F, $16, $10, $20, $0F, $16, $16, $16	; Drill Man
	.byte $0F, $30, $2C, $11, $0F, $30, $37, $27, $0F, $27, $37, $30, $0F, $27, $27, $27	; Pharaoh Man
	.byte $0F, $30, $2C, $11, $0F, $36, $27, $16, $0F, $16, $27, $36, $0F, $16, $16, $16	; Ring Man
	.byte $0F, $30, $2C, $11, $0F, $20, $21, $11, $0F, $11, $21, $20, $0F, $11, $11, $11	; Dust Man
	.byte $0F, $30, $2C, $11, $0F, $3C, $2C, $11, $0F, $1C, $2C, $3C, $0F, $1C, $1C, $1C	; Dive Man
	.byte $0F, $30, $2C, $11, $0F, $20, $10, $00, $0F, $00, $10, $20, $0F, $00, $00, $00	; Skull Man

	; Common palette always applied to colors 16-23
PRG057_SS_BossIntroCommonPal:
	.byte $0F, $0F, $2C, $11, $0F, $0F, $30, $37
	
	; Palette unique to each robot master applied to colors 24-31
PRG057_SS_BossIntroSpecificPal:
	.byte $0F, $0F, $20, $26, $0F, $0F, $20, $29	; Bright Man
	.byte $0F, $0F, $38, $29, $0F, $0F, $27, $2C	; Toad Man
	.byte $0F, $0F, $20, $16, $0F, $0F, $20, $10	; Drill Man
	.byte $0F, $0F, $20, $27, $0F, $20, $2C, $11	; Pharaoh Man
	.byte $0F, $0F, $28, $16, $0F, $0F, $20, $29	; Ring Man
	.byte $0F, $0F, $20, $10, $0F, $0F, $20, $21	; Dust Man
	.byte $0F, $0F, $20, $1C, $0F, $0F, $20, $16	; Dive Man
	.byte $0F, $0F, $20, $16, $0F, $0F, $20, $10	; Skull Man

	; "Closer" 3D stars for Wily star field when flying by in ship
PRG057_DrW_StarBG3DSprs:
	.byte $1C, $2F, $01, $44
	.byte $24, $2F, $01, $E4
	.byte $44, $2F, $01, $74
	.byte $54, $2F, $01, $C4
	.byte $9C, $2F, $01, $14
PRG057_DrW_StarBG3DSprs_End


PRG057_9672:
	; Password entry...

	JSR PRG057_DrawInterScreen

	LDA #MUS_PASSWORD
	JSR PRG063_QueueMusSnd_SetMus_Cur

	; Copy in the sprites to setup the password screen
	LDY #(PRG057_InterScrSprsWC_End - PRG057_InterScrSprs)
PRG057_967C:
	LDA PRG057_InterScrSprs-1,Y
	STA Sprite_RAM-1,Y
	
	DEY	; Y--
	BNE PRG057_967C	; While Y > 0, loop

	LDA #$00
	STA <Temp_Var16
	STA <Temp_Var17
	STA <General_Counter

PRG057_968D:
	LDA <Ctlr1_Pressed
	AND #(PAD_LEFT | PAD_RIGHT)
	BEQ PRG057_96D1	; If Player did not press LEFT/RIGHT, jump to PRG057_96D1
	
	; Player pressed LEFT/RIGHT...

	AND #PAD_RIGHT
	TAX	; X = 1 if right, 0 if left
	
	; Cursor change sound
	LDA #SFX_MENUSELECT
	JSR PRG063_QueueMusSnd

	; Left/right movement
	LDA <Temp_Var17
	STA <Temp_Var0		
	ADD PRG057_PrevNextDelta,X
	STA <Temp_Var17
	
	CMP #$06
	BEQ PRG057_96C9
	CMP #$FF
	BEQ PRG057_96C9

	CMP #$07
	BEQ PRG057_96C1
	CMP #$05
	BNE PRG057_96D1

	LDA <Temp_Var0
	CMP #$06
	BNE PRG057_96D1

	; Temp_Var16 = 0
	LDA #$00
	STA <Temp_Var16
	
	BEQ PRG057_9701		; Jump (technically always) to PRG057_9701

PRG057_96C1:
	; Temp_Var16/17 = 0
	LDA #$00
	STA <Temp_Var16
	STA <Temp_Var17
	
	BEQ PRG057_9701		; Jump (technically always) to PRG057_9701

PRG057_96C9:
	; Temp_Var16/17 = 6
	LDA #$06
	STA <Temp_Var16
	STA <Temp_Var17
	BNE PRG057_9701		; Jump (technically always) to PRG057_9701


PRG057_96D1:
	LDA <Temp_Var16
	CMP #$06
	BEQ PRG057_9701		; If Temp_Var16 = 6, jump to PRG057_9701

	LDA <Ctlr1_Pressed
	AND #(PAD_UP | PAD_DOWN)
	BEQ PRG057_9701	; If Player is not pressing UP/DOWN, jump to PRG057_9701

	AND #PAD_DOWN
	LSR A
	LSR A
	TAX
	
	; Cursor change sound
	LDA #SFX_MENUSELECT
	JSR PRG063_QueueMusSnd

	LDA <Temp_Var16
	ADD PRG057_PrevNextDelta,X
	STA <Temp_Var16
	
	CMP #$06
	BEQ PRG057_96FD
	
	CMP #$FF
	BNE PRG057_9701

	LDA #$05
	STA <Temp_Var16
	BNE PRG057_9701		; Jump (technically always) to PRG057_9701

PRG057_96FD:
	; Temp_Var16 = 0
	LDA #$00
	STA <Temp_Var16

PRG057_9701:
	LDA <Ctlr1_Pressed
	AND #PAD_A
	BEQ PRG057_9722	; If Player is not pressing A, jump to PRG057_9722

	; Player pressed A...

	LDA <Temp_Var17
	CMP #$06
	BEQ PRG057_972D	; If Temp_Var17 = 6 (cursor is on "END"), jump to PRG057_972D

	LDA <Temp_Var16
	ASL A
	STA <Temp_Var0	; Temp_Var0 = Temp_Var16 (row) * 2
	ASL A
	ADC <Temp_Var0	; Temp_Var0 = Temp_Var16 (row) * 6
	ADC <Temp_Var17	; +Temp_Var17
	
	; Mul by 4 to get to proper password ball sprite
	ASL A
	ASL A
	
	TAY	; -> 'Y'
	
	; Toggle password ball
	LDA Sprite_RAM+$01,Y
	EOR #$01
	STA Sprite_RAM+$01,Y

PRG057_9722:
	JSR PRG057_DrawCursor

	INC <General_Counter	; General_Counter++
	
	JSR PRG063_UpdateOneFrame	; Update frame

	JMP PRG057_968D	; Loop!


PRG057_972D:
	; "END" selected on password...

	; Count number of set password balls -> 'X'
	LDY #$90	; Y = $90
	LDX #$00	; X = 0
PRG057_9731:
	LDA Sprite_RAM-$03,Y
	BEQ PRG057_973B		; If password ball not set, jump to PRG057_973B

	INX	; X++ (one more password ball set)
	
	CPX #$07
	BEQ PRG057_9772	; If number of balls set = 7 (already too many), jump to PRG057_9772 (reject password)


PRG057_973B:
	; Y -= 4
	DEY
	DEY
	DEY
	DEY
	BNE PRG057_9731	; While Y > 0, loop

	CPX #$06
	BNE PRG057_9772	; If number of balls set < 6 (too few), jump to PRG057_9772 (reject password)

	; Automatic rejection balls check
	LDY #$04	; Y = 4
PRG057_9747:
	LDX PRG057_InvalidPWBalls,Y
	
	LDA Sprite_RAM+$01,X
	BNE PRG057_9772	; If this automatically-invalid ball is set, jump to PRG057_9772 (reject password)

	DEY	; Y--
	BPL PRG057_9747	; While Y >= 0, loop

	LDY #$0A	; Y = $0A
	
	; Temp_Var0 = 0
	LDA #$00
	STA <Temp_Var0
	
PRG057_9758:
	LDX PRG057_PWBall_ForWepsCollected,Y	; X = offset to "overall count ball" in password
	
	LDA Sprite_RAM+$01,X
	BEQ PRG057_9769	; If this "total weapon count" ball is not set, jump to PRG057_9769

	LDA <Temp_Var0
	BNE PRG057_9772	; If a "total weapon count" ball has already been set previously, this password is invalid, jump to PRG057_9772 (reject password)

	; Set Temp_Var0 to "total weapon count" OR'd with $80
	TYA
	ORA #$80
	STA <Temp_Var0

PRG057_9769:
	DEY	; Y--
	BPL PRG057_9758	; While Y >= 0, loop

	LDY #$0F	; Y = $0F
	
	LDA <Temp_Var0
	BMI PRG057_9775	; If "total weapon count" value was set, jump to PRG057_9775

	; "Total weapon count" not set, reject...

PRG057_9772:
	; Bad password, reject!
	JMP PRG057_981D	; Jump to PRG057_981D


	; Clear $0F bytes from Graphics_Buffer (this is being used as "weapons obtained" temp space, yucckkkk)
PRG057_9775:
	; $00 into graphics buffer at current position
	LDA #$00
	STA Graphics_Buffer+$00,Y
	
	DEY	; Y--
	BPL PRG057_9775	; While Y >= 0, loop

	; Always have your base HP, though!
	LDA #$9C
	STA Graphics_Buffer+$00
	
	; Strip bit 7 from "total weapon count"
	LDA <Temp_Var0
	AND #$0F
	STA <Temp_Var0
	
	LDY #$00
	STY <Temp_Var4	; Temp_Var4 = 0
	STY <Temp_Var5	; Temp_Var5 = 0

PRG057_978E:
	JSR PRG057_PWWepObtainCheck

	LDA <Temp_Var1
	CMP #$01
	BNE PRG057_9772	; If not exactly one valid weapon obtained, jump to PRG057_9772 (reject password)

	LDA <Temp_Var2
	AND #$03
	CMP #$03
	BEQ PRG057_97D7

	AND #$02
	BNE PRG057_97A5

	LDA #$01

PRG057_97A5:
	ADD <Temp_Var4
	STA <Temp_Var4
	
	LDX <Temp_Var2
	
	; Building boss completion bits
	LDA <Temp_Var5
	ORA PRG057_PWBossCompBits,X
	STA <Temp_Var5
	
	LDA <Temp_Var2
	ASL A
	ADC <Temp_Var2
	TAX
	
	STY <Temp_Var6
	
	LDA #$9C
	
	LDY PRG057_99E2,X
	BEQ PRG057_97D5	; If no valid weapon index, jump to PRG057_97D5

	; Set weapon as obtained
	STA Graphics_Buffer+$00,Y
	
	LDY PRG057_99E2+1,X
	BEQ PRG057_97D5	; If no secondary weapon index, jump to PRG057_97D5

	; Set weapon as obtained
	STA Graphics_Buffer+$00,Y
	
	LDY PRG057_99E2+2,X
	BEQ PRG057_97D5	; If no tertiary weapon index, jump to PRG057_97D5

	; Set weapon as obtained
	STA Graphics_Buffer+$00,Y

PRG057_97D5:
	
	LDY <Temp_Var6	; Y = Temp_Var6

PRG057_97D7:
	CPY #$14
	BNE PRG057_978E	; While Y <> $14, loop!

	LDA <Temp_Var0
	CMP <Temp_Var4
	BNE PRG057_981D

	; Password correct!
	LDA #SFX_PASSWORDCORRECT
	JSR PRG063_QueueMusSnd

	; Delay
	LDX #$3C
	JSR PRG063_UpdateMultipleFrames

	; Set energy levels for weapons
	LDY #$0F
PRG057_97ED:
	LDA Graphics_Buffer+$00,Y
	STA Player_HP,Y
	
	DEY	; Y--
	BPL PRG057_97ED	; While Y >= 0, loop!

	; Set boss completion bits
	LDA <Temp_Var5
	STA <Player_CompletedBosses
	
	; Never set any fortress levels as complete
	LDA #$00
	STA <Player_CompletedFortLvls
	
	JMP PRG057_809D	; Jump to PRG057_809D


PRG057_PWWepObtainCheck:
	LDA #$00
	STA <Temp_Var1	; Temp_Var1 = 0
	STA <Temp_Var2	; Temp_Var2 = 0
	
	LDA #$04
	STA <Temp_Var3	; Temp_Var3 = 0

PRG057_980B:
	LDX PRG057_PWBallResultOffset,Y	; offset to "this weapon obtained" password ball
	
	LDA Sprite_RAM+$01,X
	BEQ PRG057_9817	; If ball not set, jump to PRG057_9817

	STY <Temp_Var2	; "this weapon obtained" offset -> Temp_Var2
	
	INC <Temp_Var1	; Temp_Var1++ (one more weapon obtain marked)

PRG057_9817:
	INY	; Y++
	
	DEC <Temp_Var3	; Temp_Var3--
	BNE PRG057_980B	; While Temp_Var3 > 0, loop

	RTS	; $981C


PRG057_981D:
	; Bad password!

	LDA #SFX_PASSWORDERROR
	JSR PRG063_QueueMusSnd

	LDY #$00
	STY <Temp_Var16	; Temp_Var16 = 0
	STY <Temp_Var17	; Temp_Var17 = 0
	
	; PASSWORD ERROR
	LDX #$03
	JSR PRG057_DrawInterScreenText

	; Stop music!
	LDX #MUS_STOPMUSIC
	JSR PRG063_UpdateMultipleFrames

	LDX #$00
	JSR PRG057_DrawInterScreenText

	JMP PRG057_9722	; Jump to PRG057_9722


PRG057_DrawCursor:
	LDA <General_Counter
	LSR A
	LSR A
	LSR A
	BCS PRG057_9877	; Every 8 ticks on/off, jump to PRG057_9877

	LDY <Temp_Var16	; Y = Temp_Var16 (current row)
	
	LDA PRG057_PWScr_CursorSprY,Y
	STA Sprite_RAM+$90
	STA Sprite_RAM+$94
	ADD #$08
	STA Sprite_RAM+$98
	STA Sprite_RAM+$9C
	
	LDY <Temp_Var17	; Y = Temp_Var17 (current col)
	
	LDA PRG057_PWScr_CursorSprX,Y
	STA Sprite_RAM+$93
	STA Sprite_RAM+$9B
	ADD #$08
	STA Sprite_RAM+$97
	STA Sprite_RAM+$9F
	
	CPY #$06
	BNE PRG057_9876	; If current column <> 6 (not on "END"), jump to PRG057_9876

	; Shift cursor down for "END"
	ADD #$10
	STA Sprite_RAM+$97
	STA Sprite_RAM+$9F

PRG057_9876:
	RTS	; $9876


PRG057_9877:
	
	; Blank out cursor for a bit
	LDA #$F8
	STA Sprite_RAM+$90
	STA Sprite_RAM+$94
	STA Sprite_RAM+$98
	STA Sprite_RAM+$9C
	
	RTS	; $9885


PRG057_GeneratePassword:

	; Copy intermission screen sprites (sans cursor)
	LDY #(PRG057_InterScrSprs_End - PRG057_InterScrSprs)
PRG057_9888:
	LDA PRG057_InterScrSprs-1,Y
	STA Sprite_RAM-1,Y
	
	DEY
	BNE PRG057_9888

	; Temp_Var0 = 0
	LDA #$00
	STA <Temp_Var0
	
	; Counting number of weapons obtained
	LDY #$09	; Y = 9 (scanning weapons obtained)
PRG057_9897:
	LDA Player_WpnEnergy+3,Y
	BEQ PRG057_989E		; If this weapon was not obtained, jump to PRG057_989E

	INC <Temp_Var0	; One more weapon obtained

PRG057_989E:
	DEY	; Y--
	BPL PRG057_9897	; While Y > 0, loop

	LDY <Temp_Var0	; Y = number of weapons obtained
	
	LDX PRG057_PWBall_ForWepsCollected,Y	; X = offset to "overall count ball" in password
	
	; Display password ball here
	LDA #$01
	STA Sprite_RAM+$01,X
	
	LDY #$00
	STY <Temp_Var0	; Temp_Var0 = 0 (number of weapons considered)
	STY <Temp_Var1	; Temp_Var1 = 0 (index value into password balls)

PRG057_98B1:

	; Temp_Var2 = 0
	LDA #$00
	STA <Temp_Var2
	
	LDX PRG057_PWWepIndexes,Y	; X = weapon index
	
	LDA <Player_HP,X
	BPL PRG057_98C9		; If this weapon has not been obtained, jump to PRG057_98C9

	; This weapon was obtained...

	LDX PRG057_PWWepIndexes+1,Y	; X = following weapon index
	
	LDA <Player_HP,X
	BPL PRG057_98D6		; If this weapon has not been obtained, jump to PRG057_98D6

	; Both weapon indexes were obtained...

	; Temp_Var2 = 2
	LDA #$02
	STA <Temp_Var2
	
	BNE PRG057_98D6		; Jump (technically always) to PRG057_98D6


PRG057_98C9:
	; The primary weapon was not obtained...

	INC <Temp_Var2	; Temp_Var2 = 1
	
	LDX PRG057_PWWepIndexes+1,Y	; X = following weapon index
	
	LDA <Player_HP,X
	BMI PRG057_98D6		; If this weapon was obtained, jump to PRG057_98D6

	; Neither of the two checked weapons were obtained
	
	; Temp_Var2 = 3
	LDA #$03
	STA <Temp_Var2

PRG057_98D6:
	LDA <Temp_Var1	; multiple of 4 per weapon considered
	ORA <Temp_Var2	; 0 to 3 based on weapons obtained
	TAY
	
	LDX PRG057_PWBallResultOffset,Y	; X = resulting password ball from all that
	
	; Put a password ball here!
	LDA #$01
	STA Sprite_RAM+$01,X
	
	; Temp_Var1 += 4
	INC <Temp_Var1
	INC <Temp_Var1
	INC <Temp_Var1
	INC <Temp_Var1
	
	; Temp_Var0 += 2
	INC <Temp_Var0
	INC <Temp_Var0
	
	LDY <Temp_Var0
	
	CPY #$0A
	BNE PRG057_98B1	; Loop!

	RTS	; $98F5

	; CHECKME - UNUSED?
	.byte $A4, $2F, $01, $D4

PRG057_InterScrSprs:
	; Password ball [placeholder] sprites
	.byte $27, $00, $00, $38
	.byte $27, $00, $00, $48
	.byte $27, $00, $00, $58
	.byte $27, $00, $00, $68
	.byte $27, $00, $00, $78
	.byte $27, $00, $00, $88
	.byte $37, $00, $00, $38
	.byte $37, $00, $00, $48
	.byte $37, $00, $00, $58
	.byte $37, $00, $00, $68
	.byte $37, $00, $00, $78
	.byte $37, $00, $00, $88
	.byte $47, $00, $00, $38
	.byte $47, $00, $00, $48
	.byte $47, $00, $00, $58
	.byte $47, $00, $00, $68
	.byte $47, $00, $00, $78
	.byte $47, $00, $00, $88
	.byte $57, $00, $00, $38
	.byte $57, $00, $00, $48
	.byte $57, $00, $00, $58
	.byte $57, $00, $00, $68
	.byte $57, $00, $00, $78
	.byte $57, $00, $00, $88
	.byte $67, $00, $00, $38
	.byte $67, $00, $00, $48
	.byte $67, $00, $00, $58
	.byte $67, $00, $00, $68
	.byte $67, $00, $00, $78
	.byte $67, $00, $00, $88
	.byte $77, $00, $00, $38
	.byte $77, $00, $00, $48
	.byte $77, $00, $00, $58
	.byte $77, $00, $00, $68
	.byte $77, $00, $00, $78
	.byte $77, $00, $00, $88
PRG057_InterScrSprs_End		; Basic intermission screen with all "password balls" in place
	
	; Cursor sprites
	.byte $23, $03, $00, $34
	.byte $23, $03, $40, $38
	.byte $2B, $03, $80, $34
	.byte $2B, $03, $C0, $38
PRG057_InterScrSprsWC_End		; "With cursor"

PRG057_PWScr_CursorSprY:
	.byte $23, $33, $43, $53, $63, $73, $4B
	
PRG057_PWScr_CursorSprX:
	.byte $34, $44, $54, $64, $74, $84, $BC

PRG057_PrevNextDelta:
	.byte -1, 1
	
PRG057_InvalidPWBalls:
	; If any of these are set, password automatically rejected
	.byte $58, $5C, $84, $70, $8C

	; Offset in sprite RAM to show an initial password ball for number of weapons obtained
PRG057_PWBall_ForWepsCollected:
	.byte $88	; 0
	.byte $14	; 1
	.byte $1C	; 2
	.byte $20	; 3
	.byte $30	; 4
	.byte $3C	; 5
	.byte $44	; 6
	.byte $4C	; 7
	.byte $6C	; 8
	.byte $74	; 9
	.byte $78	; 10

PRG057_PWBallResultOffset:
	.byte $34, $18, $00, $04, $38, $24, $0C, $08, $2C, $40, $28, $10, $60, $7C, $64, $48
	.byte $54, $50, $80, $68


PRG057_PWBossCompBits:
	.byte $01, $02, $03, $00, $04, $08, $0C, $00, $10, $20, $30, $00, $40, $80, $C0, $00
	.byte $00, $00, $00, $00
	
PRG057_99E2:
	.byte $0C, $00, $00
	.byte $04, $03, $00
	.byte $0C, $04, $03
	.byte $00, $00, $00
	.byte $09, $02, $00
	.byte $0B, $00, $00
	.byte $09, $0B, $02
	.byte $00, $00, $00
	.byte $08, $00, $00
	.byte $0A, $00, $00
	.byte $08, $0A, $00
	.byte $00, $00, $00
	.byte $07, $00, $00
	.byte $0D, $00, $00
	.byte $07, $0D, $00
	.byte $00, $00, $00
	.byte $05, $00, $00
	.byte $06, $00, $00
	.byte $05, $06, $00
	.byte $00, $00, $00


	; Offset into Player_HP (i.e. weapons) generally checked as 
	; "this index" and "following index" to generate password
	; hash data etc.
PRG057_PWWepIndexes:
	.byte $0C, $04, $09, $0B, $08, $0A, $07, $0D, $05, $06


PRG057_9A28:
	; UNUSED!
	; Palette editor debug code ... I'm really not interested in this enough to bother commenting it
	LDA #$00
	STA <DisFlag_NMIAndDisplay
	JSR PRG062_PalFadeOut
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites
	JSR PRG063_UpdateOneFrame
	JSR PRG062_DisableDisplay
	LDX #$12
	JSR PRG062_Upl_SprPal_CHRPats
	JSR PRG062_EnableDisplay
	LDY #$07
PRG057_9A46:
	LDA PRG057_9B75,Y
	STA PalData_2+$10,Y
	DEY
	BPL PRG057_9A46
	JSR PRG063_UpdateOneFrame
	LDA PalAnim_EnSel+$00
	STA Pattern_Buffer+$00
	LDA PalAnim_EnSel+$01
	STA Pattern_Buffer+$01
	LDA PalAnim_EnSel+$02
	STA Pattern_Buffer+$02
	LDA PalAnim_EnSel+$03
	STA Pattern_Buffer+$03
	LDA #$00
	STA PalAnim_EnSel+$00
	STA PalAnim_EnSel+$01
	STA PalAnim_EnSel+$02
	STA PalAnim_EnSel+$03
	JSR PRG062_PalFadeIn
	LDA #$00
	STA <Temp_Var16
PRG057_9A7F:
	LDA <Ctlr1_Pressed
	AND #$10
	BNE PRG057_9AEF
	LDA <Ctlr1_Pressed
	AND #$80
	BNE PRG057_9A9F
	LDA <Ctlr1_Pressed
	AND #$40
	BEQ PRG057_9AD3
	INC <Temp_Var16
	LDA <Temp_Var16
	CMP #$18
	BNE PRG057_9AD3
	LDA #$00
	STA <Temp_Var16
	BEQ PRG057_9AD3
PRG057_9A9F:
	LDY <Temp_Var16
	LDX PRG057_9C5E,Y
	INC PalData_1,X
	LDA PalData_1,X
	AND #$3F
	STA PalData_1,X
	STA PalData_2,X
	CMP #$10
	BCS PRG057_9ABE
	CMP #$0D
	BCC PRG057_9AD3
	LDA #$0F
	BNE PRG057_9ACD
PRG057_9ABE:
	AND #$0F
	CMP #$0D
	BCC PRG057_9AD3
	LDA PalData_1,X
	AND #$30
	ADC #$10
	AND #$30
PRG057_9ACD:
	STA PalData_1,X
	STA PalData_2,X
PRG057_9AD3:
	JSR PRG057_9B30
	LDA <Temp_Var16
	PHA
	LDA PalData_1
	STA PalData_1+$10
	STA PalData_2+$10
	LDA #$FF
	STA <CommitPal_Flag
	JSR PRG063_UpdateOneFrame
	PLA
	STA <Temp_Var16
	JMP PRG057_9A7F
PRG057_9AEF:
	JSR PRG062_PalFadeOut
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites
	JSR PRG063_UpdateOneFrame
	JSR PRG062_DisableDisplay
	LDX #$13
	JSR PRG062_Upl_SprPal_CHRPats
	JSR PRG062_EnableDisplay
	LDY #$07
PRG057_9B09:
	LDA PRG057_9B7D,Y
	STA PalData_2+$10,Y
	DEY
	BPL PRG057_9B09
	LDA Pattern_Buffer+$00
	STA PalAnim_EnSel+$00
	LDA Pattern_Buffer+$01
	STA PalAnim_EnSel+$01
	LDA Pattern_Buffer+$02
	STA PalAnim_EnSel+$02
	LDA Pattern_Buffer+$03
	STA PalAnim_EnSel+$03
	JSR PRG063_UpdateOneFrame
	JMP PRG062_PalFadeIn
PRG057_9B30:
	LDY #$00
PRG057_9B32:
	LDA PRG057_9B85,Y
	CMP #$FF
	BEQ PRG057_9B3F
	STA Sprite_RAM+$00,Y
	INY
	BNE PRG057_9B32
PRG057_9B3F:
	LDX #$00
	LDY #$00
PRG057_9B43:
	LDA PalData_1,X
	PHA
	LSR A
	LSR A
	LSR A
	LSR A
	STA Sprite_RAM+$01,Y
	PLA
	AND #$0F
	STA Sprite_RAM+$05,Y
	TYA
	CLC
	ADC #$08
	TAY
	INX
	CPX #$20
	BEQ PRG057_9B66
	CPX #$10
	BNE PRG057_9B43
	LDX #$18
	BNE PRG057_9B43
PRG057_9B66:
	LDA <Temp_Var16
	ASL A
	ASL A
	ASL A
	TAY
	LDA #$01
	STA Sprite_RAM+$02,Y
	STA Sprite_RAM+$06,Y
	RTS
	
PRG057_9B75:
	.byte $0F, $20, $20	; $9B68 - $9B77
	.byte $20, $0F, $16, $16, $16
	
PRG057_9B7D:
	.byte $0F, $0F, $2C, $11, $0F, $0F, $30, $37
	
PRG057_9B85:
	.byte $30, $00, $00	; $9B78 - $9B87
	.byte $30, $30, $00, $00, $38, $30, $00, $00, $48, $30, $00, $00, $50, $30, $00, $00	; $9B88 - $9B97
	.byte $60, $30, $00, $00, $68, $30, $00, $00, $78, $30, $00, $00, $80, $40, $00, $00	; $9B98 - $9BA7
	.byte $30, $40, $00, $00, $38, $40, $00, $00, $48, $40, $00, $00, $50, $40, $00, $00	; $9BA8 - $9BB7
	.byte $60, $40, $00, $00, $68, $40, $00, $00, $78, $40, $00, $00, $80, $50, $00, $00	; $9BB8 - $9BC7
	.byte $30, $50, $00, $00, $38, $50, $00, $00, $48, $50, $00, $00, $50, $50, $00, $00	; $9BC8 - $9BD7
	.byte $60, $50, $00, $00, $68, $50, $00, $00, $78, $50, $00, $00, $80, $60, $00, $00	; $9BD8 - $9BE7
	.byte $30, $60, $00, $00, $38, $60, $00, $00, $48, $60, $00, $00, $50, $60, $00, $00	; $9BE8 - $9BF7
	.byte $60, $60, $00, $00, $68, $60, $00, $00, $78, $60, $00, $00, $80, $80, $00, $00	; $9BF8 - $9C07
	.byte $30, $80, $00, $00, $38, $80, $00, $00, $48, $80, $00, $00, $50, $80, $00, $00	; $9C08 - $9C17
	.byte $60, $80, $00, $00, $68, $80, $00, $00, $78, $80, $00, $00, $80, $90, $00, $00	; $9C18 - $9C27
	.byte $30, $90, $00, $00, $38, $90, $00, $00, $48, $90, $00, $00, $50, $90, $00, $00	; $9C28 - $9C37
	.byte $60, $90, $00, $00, $68, $90, $00, $00, $78, $90, $00, $00, $80, $20, $1C, $01	; $9C38 - $9C47
	.byte $20, $20, $0C, $01, $28, $20, $1B, $01, $30, $70, $18, $01, $20, $70, $0B, $01	; $9C48 - $9C57
	.byte $28, $70, $13, $01, $30, $FF
	
PRG057_9C5E:
	.byte $00, $01, $02, $03, $04, $05, $06, $07, $08, $09	; $9C58 - $9C67
	.byte $0A, $0B, $0C, $0D, $0E, $0F, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F
	
	; Assuming rest of this is UNUSED, it's definitely unused as far as anything important is concerned
	.byte $04, $14	; $9C68 - $9C77
	.byte $00, $10, $40, $10, $0A, $40, $8C, $04, $00, $01, $40, $04, $80, $00, $00, $00	; $9C78 - $9C87
	.byte $0C, $00, $00, $00, $01, $50, $00, $00, $00, $10, $10, $00, $16, $04, $01, $00	; $9C88 - $9C97
	.byte $00, $00, $01, $01, $08, $10, $00, $00, $00, $40, $A0, $50, $0E, $00, $01, $00	; $9C98 - $9CA7
	.byte $00, $05, $40, $00, $08, $00, $01, $40, $10, $10, $20, $10, $40, $04, $03, $00	; $9CA8 - $9CB7
	.byte $00, $40, $40, $00, $08, $00, $00, $00, $80, $10, $01, $00, $90, $00, $01, $00	; $9CB8 - $9CC7
	.byte $28, $00, $08, $00, $08, $41, $00, $40, $00, $00, $61, $00, $20, $04, $00, $40	; $9CC8 - $9CD7
	.byte $04, $00, $00, $41, $00, $00, $08, $01, $08, $04, $81, $00, $90, $00, $68, $00	; $9CD8 - $9CE7
	.byte $40, $80, $00, $00, $30, $00, $00, $00, $00, $00, $10, $00, $C8, $00, $16, $00	; $9CE8 - $9CF7
	.byte $00, $10, $04, $00, $12, $00, $0A, $00, $44, $10, $20, $00, $00, $04, $20, $00	; $9CF8 - $9D07
	.byte $61, $00, $04, $00, $21, $01, $00, $04, $00, $01, $00, $00, $00, $00, $00, $00	; $9D08 - $9D17
	.byte $80, $00, $00, $00, $00, $00, $00, $00, $21, $40, $7D, $00, $F2, $04, $80, $10	; $9D18 - $9D27
	.byte $14, $40, $00, $00, $92, $00, $40, $10, $84, $04, $41, $04, $14, $00, $01, $40	; $9D28 - $9D37
	.byte $20, $40, $00, $00, $00, $00, $22, $00, $16, $04, $00, $00, $40, $04, $80, $00	; $9D38 - $9D47
	.byte $0C, $01, $00, $00, $00, $04, $42, $00, $C4, $00, $23, $40, $00, $00, $81, $04	; $9D48 - $9D57
	.byte $00, $00, $10, $01, $40, $00, $00, $14, $02, $00, $22, $00, $46, $40, $00, $00	; $9D58 - $9D67
	.byte $00, $00, $80, $40, $C0, $00, $09, $00, $80, $00, $22, $10, $08, $00, $80, $40	; $9D68 - $9D77
	.byte $00, $10, $90, $10, $18, $00, $28, $00, $60, $00, $80, $00, $08, $00, $06, $01	; $9D78 - $9D87
	.byte $01, $04, $01, $40, $00, $01, $00, $00, $80, $00, $00, $00, $00, $00, $40, $00	; $9D88 - $9D97
	.byte $00, $00, $00, $00, $00, $00, $80, $00, $C1, $14, $20, $05, $43, $00, $05, $40	; $9D98 - $9DA7
	.byte $0C, $00, $4C, $14, $04, $05, $01, $01, $02, $04, $04, $40, $20, $00, $74, $00	; $9DA8 - $9DB7
	.byte $08, $44, $00, $10, $00, $00, $04, $01, $08, $00, $12, $05, $03, $00, $01, $00	; $9DB8 - $9DC7
	.byte $04, $00, $94, $00, $8A, $01, $18, $00, $08, $10, $08, $10, $00, $00, $00, $00	; $9DC8 - $9DD7
	.byte $60, $04, $02, $00, $00, $00, $08, $00, $98, $04, $40, $45, $00, $15, $10, $00	; $9DD8 - $9DE7
	.byte $93, $00, $01, $01, $86, $04, $00, $01, $20, $00, $00, $00, $80, $00, $09, $00	; $9DE8 - $9DF7
	.byte $20, $01, $10, $00, $02, $00, $20, $00, $80, $00, $00, $00, $04, $40, $50, $00	; $9DF8 - $9E07
	.byte $40, $01, $00, $10, $00, $10, $40, $04, $00, $00, $00, $00, $00, $10, $00, $00	; $9E08 - $9E17
	.byte $00, $00, $10, $00, $00, $00, $00, $00, $08, $11, $12, $00, $82, $50, $00, $00	; $9E18 - $9E27
	.byte $05, $00, $01, $00, $14, $01, $00, $40, $80, $00, $06, $00, $08, $04, $04, $04	; $9E28 - $9E37
	.byte $00, $00, $08, $41, $01, $00, $00, $40, $34, $10, $00, $00, $04, $00, $04, $50	; $9E38 - $9E47
	.byte $12, $40, $00, $00, $00, $00, $40, $00, $80, $40, $20, $00, $00, $01, $16, $00	; $9E48 - $9E57
	.byte $02, $00, $01, $00, $00, $04, $02, $00, $0C, $00, $19, $11, $04, $04, $10, $00	; $9E58 - $9E67
	.byte $10, $01, $88, $50, $12, $01, $CD, $40, $00, $00, $10, $05, $00, $40, $80, $00	; $9E68 - $9E77
	.byte $80, $41, $01, $00, $01, $40, $00, $00, $88, $01, $C0, $00, $01, $40, $10, $00	; $9E78 - $9E87
	.byte $10, $00, $10, $00, $00, $00, $00, $00, $00, $40, $00, $00, $40, $00, $20, $01	; $9E88 - $9E97
	.byte $4A, $04, $05, $00, $00, $00, $00, $00, $00, $10, $80, $04, $10, $01, $40, $10	; $9E98 - $9EA7
	.byte $10, $40, $29, $00, $C6, $01, $41, $40, $40, $00, $4A, $10, $40, $00, $01, $10	; $9EA8 - $9EB7
	.byte $22, $00, $00, $00, $10, $00, $00, $00, $21, $00, $AA, $50, $98, $04, $11, $40	; $9EB8 - $9EC7
	.byte $00, $10, $01, $00, $06, $00, $00, $00, $92, $00, $E4, $00, $00, $04, $00, $00	; $9EC8 - $9ED7
	.byte $00, $00, $10, $00, $08, $01, $80, $11, $84, $10, $01, $45, $00, $01, $30, $00	; $9ED8 - $9EE7
	.byte $82, $00, $8C, $01, $A2, $00, $84, $00, $11, $00, $00, $40, $D2, $00, $20, $05	; $9EE8 - $9EF7
	.byte $20, $00, $A2, $00, $20, $01, $40, $00, $00, $00, $00, $00, $80, $00, $00, $00	; $9EF8 - $9F07
	.byte $E0, $40, $43, $00, $02, $00, $00, $00, $80, $00, $00, $04, $04, $00, $01, $00	; $9F08 - $9F17
	.byte $00, $00, $00, $00, $09, $00, $00, $00, $0B, $00, $4A, $00, $06, $40, $00, $40	; $9F18 - $9F27
	.byte $40, $01, $18, $55, $63, $01, $41, $00, $01, $10, $02, $00, $80, $04, $00, $04	; $9F28 - $9F37
	.byte $40, $04, $08, $00, $00, $00, $40, $00, $40, $40, $C0, $00, $00, $10, $00, $00	; $9F38 - $9F47
	.byte $20, $01, $00, $15, $00, $40, $00, $00, $11, $01, $2A, $00, $20, $00, $00, $01	; $9F48 - $9F57
	.byte $00, $00, $00, $00, $00, $00, $08, $01, $00, $00, $00, $00, $80, $00, $00, $01	; $9F58 - $9F67
	.byte $14, $00, $B1, $00, $48, $04, $00, $00, $08, $00, $02, $00, $10, $00, $00, $00	; $9F68 - $9F77
	.byte $09, $00, $00, $00, $20, $00, $00, $11, $34, $00, $01, $04, $10, $40, $41, $00	; $9F78 - $9F87
	.byte $00, $00, $20, $00, $00, $00, $00, $00, $02, $00, $20, $00, $00, $00, $80, $00	; $9F88 - $9F97
	.byte $80, $10, $20, $00, $00, $00, $04, $00, $20, $05, $28, $05, $00, $14, $20, $41	; $9F98 - $9FA7
	.byte $04, $00, $81, $00, $04, $40, $00, $00, $40, $04, $C0, $40, $04, $00, $02, $00	; $9FA8 - $9FB7
	.byte $08, $01, $21, $00, $10, $00, $00, $40, $4A, $00, $04, $00, $9B, $00, $58, $44	; $9FB8 - $9FC7
	.byte $02, $00, $02, $00, $80, $00, $44, $00, $10, $00, $04, $00, $04, $40, $01, $00	; $9FC8 - $9FD7
	.byte $01, $00, $00, $54, $40, $00, $08, $01, $08, $00, $18, $04, $00, $00, $00, $01	; $9FD8 - $9FE7
	.byte $08, $04, $80, $05, $A6, $00, $10, $00, $02, $00, $00, $00, $10, $00, $00, $14	; $9FE8 - $9FF7
	.byte $C0, $05, $01, $00, $40, $40, $20, $01	; $9FF8 - $9FFF


