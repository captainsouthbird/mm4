PRG060_DoPlayer:
	LDA <TileMap_Index
	CMP #$00
	BNE PRG060_8032	; If TileMap_Index <> 0 (Bright Man), jump to PRG060_8032

	; Bright Man only...

	LDA Level_LightDarkCtl
	CMP #$40
	BNE PRG060_8032	; If Level_LightDarkCtl <> $40 (not shrouded in darkness), jump to PRG060_8032

	; While shrouded in darkness, decrement Level_DarkTimer
	LDA Level_DarkTimer+$00
	SUB #$01
	STA Level_DarkTimer+$00
	LDA Level_DarkTimer+$01
	SBC #$00
	STA Level_DarkTimer+$01
	
	ORA Level_DarkTimer+$00
	BNE PRG060_8032	; If Level_DarkTimer <> 0, jump to PRG060_8032

	; Darkness shroud ends...

	LDA #$00	; $8023
	STA Level_LightDarkTransCnt	; $8025
	LDA #$30	; $8028
	STA Level_LightDarkTransLevel	; $802A
	
	; Brighten up mode
	LDA #$80
	STA Level_LightDarkCtl

PRG060_8032:
	JSR PRG060_PlayerWilyTransporterBG	; Send player behind Wily Transporter as needed

	LDA <Player_ShootAnimTimer
	BEQ PRG060_804A	; If Player_ShootAnimTimer = 0, jump to PRG060_804A

	DEC <Player_ShootAnimTimer	; Player_ShootAnimTimer--
	
	BNE PRG060_804A	; If Player_ShootAnimTimer didn't just hit zero, jump to PRG060_804A

	; Player_ShootAnimTimer just hit zero...

	; Exit the current player shooting animation
	LDA Spr_CurrentAnim+$00
	SUB <Player_CurShootAnim
	STA Spr_CurrentAnim+$00
	
	; Player_CurShootAnim = PLAYERCSA_NOSHOOT
	LDA #PLAYERCSA_NOSHOOT
	STA <Player_CurShootAnim

PRG060_804A:
	LDY <Player_CurWeapon
	BNE PRG060_8070	; If Player is using anything besides Mega Buster, jump to PRG060_8070

	; Mega Buster only... discharge causes a brief color flash

	LDA <Player_MBustDischargePalIdx
	BEQ PRG060_8073	; If Player_MBustDischargePalIdx = 0, jump to PRG060_8073

	ASL A
	ASL A
	TAY		; Y = Player_MBustDischargePalIdx * 4
	
	; Set Player's discharge palette
	LDX #$00
PRG060_8057:
	LDA PRG060_PlayerMBDischargePal+1,Y
	STA PalData_1+17,X
	STA PalData_2+17,X
	
	INY
	INX
	CPX #$03
	BNE PRG060_8057
	
	INC <CommitPal_Flag	; $8066
	
	; Player_MBustDischargePalIdx++, cap 0 - 8
	INC <Player_MBustDischargePalIdx
	LDA <Player_MBustDischargePalIdx
	AND #$07
	STA <Player_MBustDischargePalIdx

PRG060_8070:
	JMP PRG060_80CF	; Jump to PRG060_80CF


PRG060_8073:
	; Mega Buster selected, but not currently discharging

	LDA <Player_MBusterChargeLevel
	BEQ PRG060_80CF		; If Player_MBusterChargeLevel = 0, jump to PRG060_80CF
	
	; Mega Buster charging...

	LDA <Player_State
	CMP #$04
	BGE PRG060_80CF	; If Player_State >= 4 (times Mega Buster can't be used), jump to PRG060_80CF

	LDA <Ctlr1_Held
	AND #PAD_B
	BEQ PRG060_80CF	; If Player is not holding B, jump to PRG060_80CF

	; Player_MBusterChargeLevel...
	INC <Player_MBusterChargeLevel
	LDA <Player_MBusterChargeLevel
	CMP #$32
	BNE PRG060_8090

	; Mega Buster charge hold sound effect at $32
	LDA #SFX_MBUSTERCHARGE
	JSR PRG063_QueueMusSnd


PRG060_8090:
	LDA <Player_MBusterChargeLevel
	CMP #$64
	BLT PRG060_809F		; If Player_MBusterChargeLevel < $64, jump to PRG060_809F

	; At Player_MBusterChargeLevel = $64, drop back to $5C
	LDA #$5C
	STA <Player_MBusterChargeLevel
	
	LDA #SFX_MBUSTERCHARGEHOLD
	JSR PRG063_QueueMusSnd

PRG060_809F:
	LDA <Player_MBusterChargeLevel
	LSR A
	LSR A
	LSR A		; div by 8 (thus 0 to 31)
	AND #$FC	; 0, 4, 8, 12, 16, 20, 24, 28
	BEQ PRG060_80CF		; effectively 4 ticks off, 12 ticks on...

	STA <Temp_Var0	; Temp_Var0 = 1 to 3
	
	LDA <Player_MBusterChargeLevel	; $00 to $63
	LSR A			; div by 2
	AND #$03		; cap 0 to 3
	ORA <Temp_Var0	; OR 4, 8, 12, 16, 20, 24, 28
	TAY		; Y = 1 to 3
	
	LDA PRG060_PlayerMBChrgPal1,Y
	STA PalData_1+17
	STA PalData_2+17
	
	LDA PRG060_PlayerMBChrgPal2,Y
	STA PalData_1+18
	STA PalData_2+18
	
	LDA PRG060_PlayerMBChrgPal3,Y
	STA PalData_1+19
	STA PalData_2+19
	
	INC <CommitPal_Flag

PRG060_80CF:

	LDA <Player_PlayerHitInv
	BEQ PRG060_80DA		; If Player_PlayerHitInv = 0, jump to PRG060_80DA

	; Reduce Player_PlayerHitInv
	DEC <Player_PlayerHitInv
	
	; Flash Player sprite
	LDA <Player_PlayerHitInv
	STA Spr_FlashOrPauseCnt

PRG060_80DA:
	LDA <Player_FreezePlayerTicks
	BNE PRG060_80F2		; If Player is frozen, jump to PRG060_80F2

	; Generate bubbles
	LDX #$00
	JSR PRG060_PlayerGenerateBubble

	; Do Player state
	LDY <Player_State
	
	LDA PRG060_PState_TableL,Y
	STA <Temp_Var0
	LDA PRG060_PState_TableH,Y
	STA <Temp_Var1
	
	JMP [Temp_Var0]


PRG060_80F2:
	; Player is frozen...

	; Halt animation
	LDA #$00
	STA Spr_AnimTicks+$00

	; Player_FreezePlayerTicks--
	DEC <Player_FreezePlayerTicks
	
PRG060_80F9:
	RTS	; $80F9


	; Indexed by Player_State ... note that state 4 and higher implicitly disable Mega Buster
PRG060_PState_TableL:
	.byte LOW(PRG060_PState_Stand)				; 0 Player standing on ground
	.byte LOW(PRG060_PState_FallJump)			; 1 Player falling
	.byte LOW(PRG060_PState_Slide)				; 2 Player sliding
	.byte LOW(PRG060_PState_Climb)				; 3 Player climbing
	.byte LOW(PRG060_PState_RMarine)			; 4 Player riding in Rush Marine
	.byte LOW(PRG060_PState_Wire)				; 5 Player using Wire Adapter
	.byte LOW(PRG060_PState_Hurt)				; 6 Player hurt
	.byte LOW(PRG060_PState_DoNothing)			; 7 Player does nothing
	.byte LOW(PRG060_PState_TeleportOut)		; 8 Player teleport out, end level
	.byte LOW(PRG060_PState_BossWait)			; 9 Player waits for boss to do intro / fill energy
	.byte LOW(PRG060_PState_READY)				; 10 "READY" opening animation, teleport in
	.byte LOW(PRG060_PState_EndLevel)			; 11 Player end level wait
	.byte LOW(PRG060_PState_CossackClaw)		; 12 Player hurt for a fixed amount of damage (use??)
	.byte LOW(PRG060_PState_PostCossack)		; 13 After (almost) defeating Cossack, Player walks to left, Proto Man drops in
	.byte LOW(PRG060_PState_PostCsakCine)		; 14 Cinematic sequence with dialog post-Cossack
	.byte LOW(PRG060_PState_WilyTrans)			; 15 Wily Transporter teleporting
	.byte LOW(PRG060_PState_CsakBossWalk)		; 16 Cossack Boss walk-in
	.byte LOW(PRG060_PState_GotSpecWep)			; 17 Player got special weapon; wait for a bit and teleport to midpoint
	.byte LOW(PRG060_PState_PostWilyLeft)		; 18 Player walks left after defeating Wily and holds
	.byte LOW(PRG060_PState_TeleportOut)		; 19 Player teleports out and starts ending
	
PRG060_PState_TableH:
	.byte HIGH(PRG060_PState_Stand)				; 0 Player standing on ground
	.byte HIGH(PRG060_PState_FallJump)			; 1 Player falling
	.byte HIGH(PRG060_PState_Slide)				; 2 Player sliding
	.byte HIGH(PRG060_PState_Climb)				; 3 Player climbing
	.byte HIGH(PRG060_PState_RMarine)			; 4 Player riding in Rush Marine
	.byte HIGH(PRG060_PState_Wire)				; 5 Player using Wire Adapter
	.byte HIGH(PRG060_PState_Hurt)				; 6 Player hurt
	.byte HIGH(PRG060_PState_DoNothing)			; 7 Player does nothing
	.byte HIGH(PRG060_PState_TeleportOut)		; 8 Player teleport out, end level
	.byte HIGH(PRG060_PState_BossWait)			; 9 Player waits for boss to do intro / fill energy
	.byte HIGH(PRG060_PState_READY)				; 10 "READY" opening animation, teleport in
	.byte HIGH(PRG060_PState_EndLevel)			; 11 Player end level wait
	.byte HIGH(PRG060_PState_CossackClaw)		; 12 Player held in Cossack boss's claw grip
	.byte HIGH(PRG060_PState_PostCossack)		; 13 After (almost) defeating Cossack, Player walks to left, Proto Man drops in
	.byte HIGH(PRG060_PState_PostCsakCine)		; 14 Cinematic sequence with dialog post-Cossack
	.byte HIGH(PRG060_PState_WilyTrans)			; 15 Wily Transporter teleporting
	.byte HIGH(PRG060_PState_CsakBossWalk)		; 16 Cossack Boss walk-in
	.byte HIGH(PRG060_PState_GotSpecWep)		; 17 Player got special weapon; wait for a bit and teleport to midpoint
	.byte HIGH(PRG060_PState_PostWilyLeft)		; 18 Player walks left after defeating Wily and holds
	.byte HIGH(PRG060_PState_TeleportOut)		; 19 Player teleports out and starts ending


	; Unused bytes
	.byte $00, $00, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF	; $8122 - $812F


PRG060_PState_Stand:
	JSR PRG060_PState_FallJump	; Chain fall/jump code

	BCC PRG060_80F9	; If not on ground, jump to PRG060_80F9 (RTS)

	LDA <Ctlr1_Pressed
	AND #PAD_A
	BNE PRG060_813E		; If Player pressed 'A', jump to PRG060_813E

	JMP PRG060_81D6		; Otherwise, jump to PRG060_81D6


PRG060_813E:
	; Player pressed 'A'...

	LDA Spr_Var4+$00
	BNE PRG060_8149	; If Player is riding Rush Jet, jump to PRG060_8149

	; Player is not riding Rush Jet...

	LDA <Ctlr1_Held
	AND #PAD_DOWN
	BNE PRG060_8156	; If Player is holding DOWN, jump to PRG060_8156

	; Player is not holding down...

PRG060_8149:
	LDA #$00	; $8149
	STA Spr_YVelFrac+$00	; $814B
	
	; Jump velocity
	LDA #$05
	STA Spr_YVel+$00
	
	; Continue into the jump/fall state code
	JMP PRG060_PState_FallJump


PRG060_8156:
	; Player is holding DOWN...

	; Temp_Var8 = 2
	LDA #$02
	STA <Temp_Var8
	
	LDA Spr_Flags+$00
	AND #SPR_HFLIP
	BEQ PRG060_8165	; If Player is not facing right, jump to PRG060_8165

	; Temp_Var8 = 1
	LDA #$01
	STA <Temp_Var8

PRG060_8165:
	LDA <Ctlr1_Held
	AND #(PAD_RIGHT | PAD_LEFT)
	BEQ PRG060_816D	; If Player is not pressing LEFT or RIGHT, jump to PRG060_816D

	; Player is pressing LEFT/RIGHT...

	STA <Temp_Var8	; Temp_Var8 = 2 if facing left, 1 if facing right

PRG060_816D:
	LDA <Temp_Var8
	LSR A			; 0 or 1
	ADD #$06		; +6
	TAY		; Y = 6 or 7 (offset into PRG062_D808)
	
	; Basically check if slide is allowed...
	
	JSR PRG062_ObjDetWallAttrs

	LDA <Temp_Var16
	AND #TILEATTR_SOLID
	BNE PRG060_81D6	; If a solid wall has been detected, jump to PRG060_81D6

	; Slide not blocked by wall...

	; Facing direction
	LDA <Temp_Var8
	STA <Player_FaceDir
	STA Spr_FaceDir+$00
	
	; Player_SlideTimer = $1A
	LDA #$1A
	STA <Player_SlideTimer
	
	; Player_State = PLAYERSTATE_SLIDING
	LDA #PLAYERSTATE_SLIDING
	STA <Player_State
	
	; Player X velocity
	LDA #$80
	STA Spr_XVelFrac+$00
	STA <Player_HCurSpeedFrac
	LDA #$02
	STA Spr_XVel+$00
	STA <Player_HCurSpeed
	
	LDA #SPRANM2_PLAYERSLIDE
	JSR PRG063_SetSpriteAnim

	; Player drops down slightly for the slide
	LDA Spr_Y+$00
	ADD #$02
	STA Spr_Y+$00
	
	; Clear shooting vars
	LDA #PLAYERCSA_NOSHOOT
	STA <Player_CurShootAnim
	STA <Player_ShootAnimTimer
	
	LDA Spr_SlotID+$05
	BNE PRG060_81D3		; If slot 5 is in use, jump to PRG060_81D3

	; Slot 5 is empty...

	LDA #SPRANM2_PLAYERSLIDEDUST
	
	LDY <TileMap_Index
	CPY #MUS_TOADMAN
	BNE PRG060_81C4		; If this is not Toad Man, jump to PRG060_81C4
	
	; Toad Man only...

	LDY Spr_XHi+$00
	CPY #$08
	BGE PRG060_81C4	; If not in the beginning of Toad Man, don't use the water splash slide sprite, jump to PRG060_81C4

	LDA #SPRANM2_PLAYERSLIDESPLASH

PRG060_81C4:
	; Copy Player sprite data to slot 5 for the slide dust/splash
	LDY #$05
	JSR PRG063_CopySprSlotSetAnim

PRG060_81C9:
	LDA #SPRSLOTID_PLAYER
	STA Spr_SlotID+$00,Y
	
	LDA #$00	; $81CE
	STA Spr_Flags2+$00,Y	; $81D0

PRG060_81D3:
	JMP PRG060_8368	; Jump to PRG060_8368


PRG060_81D6:
	; Stand state continues...

	LDA <Ctlr1_Held
	AND #PAD_DOWN
	BEQ PRG060_820C	; If Player is not holding down, jump to PRG060_820C

	; Player is holding down...

	LDA <Level_TileAttrsDetected+$01		; ?? Why is it using the "mid" here?
	CMP #TILEATTR_LADDERTOP
	BNE PRG060_820C				; If Player is not at the top of a ladder, jump to PRG060_820C

	; Player pressed DOWN at top of ladder...

	; Align Player Y to tile
	LDA <Temp_Var17
	AND #$F0
	STA Spr_Y+$00
	
	; Center Player X on tile
	LDA Spr_X+$00
	AND #$F0
	ORA #$08
	STA Spr_X+$00
	
	LDA #$4C	; $81F3
	STA Spr_YVelFrac+$00	; $81F5
	
	; Move down on ladder
	LDA #$01
	STA Spr_YVel+$00
	
	; Ladder climbing
	LDA #PLAYERSTATE_CLIMBING
	STA <Player_State
	
	; Set climb/shoot
	LDA #SPRANM2_PLYRCLIMTOP
	ADD <Player_CurShootAnim
	JSR PRG063_SetSpriteAnim

	JMP PRG060_82A9	; Jump to PRG060_82A9


PRG060_820C:
	; Not entering down onto ladder

	LDA Spr_Var4+$00
	BEQ PRG060_8214	; If Player is not on Rush Jet, jump to PRG060_8214

	; Player is on Rush Jet
	JMP PRG060_8299	; Jump to PRG060_8299


PRG060_8214:
	LDA Spr_CurrentAnim+$00
	CMP #SPRANM2_PLAYERWALK
	BEQ PRG060_8243		; If Player animation is walking, jump to PRG060_8243

	CMP #SPRANM2_PLAYERWALKSHOOT
	BEQ PRG060_8243		; If Player animation is walk and shooting, jump to PRG060_8243

	CMP #SPRANM2_PLAYERSTEP
	BEQ PRG060_822B		; If Player animation is stepping, jump to PRG060_822B

	CMP #SPRANM2_PLAYERSTEPSHOOT
	BEQ PRG060_822B		; If Player animation is stepping and shooting, jump to PRG060_822B

	CMP #SPRANM2_PLAYERTHROW
	BNE PRG060_824D		; If Player is not throwing, jump to PRG060_824D


PRG060_822B:
	; Player stepping / stepping-shooting

	LDA Spr_Frame+$00
	BEQ PRG060_82A6		; If step animation is on frame zero, jump to PRG060_82A6

	; If not on frame zero...

	LDA <Ctlr1_Held
	AND #(PAD_LEFT | PAD_RIGHT)
	BEQ PRG060_8299		; If Player is not pressing left/right, jump to PRG060_8299

	; Update Player facing direction
	STA <Player_FaceDir
	
	; Set walk / walk-shoot animation
	LDA #SPRANM2_PLAYERWALK
	ADD <Player_CurShootAnim
	JSR PRG063_SetSpriteAnim

	JMP PRG060_825D	; Jump to PRG060_825D


PRG060_8243:
	; Player walk / walk-shooting

	LDA <Ctlr1_Held
	AND #(PAD_LEFT | PAD_RIGHT)
	BEQ PRG060_8292	; If Player is not pressing left/right, jump to PRG060_8292

	AND <Player_FaceDir
	BNE PRG060_825D	; If Player has not switched directions, jump to PRG060_825D


PRG060_824D:
	; Player changed walking directions or is just otherwise standing

	LDA <Ctlr1_Held
	AND #(PAD_LEFT | PAD_RIGHT)
	BEQ PRG060_8299	; If Player is not pressing left/right, jump to PRG060_8299

	; Player is pressing left/right while standing

	; Update Player facing direction
	STA <Player_FaceDir
	
	; Set animation to step / step-shoot
	LDA #SPRANM2_PLAYERSTEP
	ADD <Player_CurShootAnim
	JSR PRG063_SetSpriteAnim


PRG060_825D:
	; Player is continuing in the same direction

	LDA <Player_FaceDir
	STA Spr_FaceDir+$00
	JSR PRG060_DoPlayerOnIce

	BCC PRG060_826C	; If Player is on icy ground, jump to PRG060_826C

	LDY #$00	; Y = 0
	JSR PRG063_DoObjMoveSetFaceDir

PRG060_826C:
	LDA <TileMap_Index
	CMP #TMAP_TOADMAN
	BNE PRG060_828F	; If this isn't Toad Man, jump to PRG060_828F

	LDA Spr_XHi+$00
	CMP #$08
	BGE PRG060_828F	; If on screen >= 8, jump to PRG060_828F

	LDA Spr_SlotID+$05
	BNE PRG060_828F	; If sprite slot 5 is in use, jump to PRG060_828F

	LDY #$05	; Y = 5 (sprite slot 5)
	
	; Little splash in the rain
	LDA #SPRANM2_RAINSPLASH
	JSR PRG063_CopySprSlotSetAnim

	; Just a convenient access for sprites in banks 12-13
	LDA #SPRSLOTID_PLAYER
	STA Spr_SlotID+$00,Y
	
	LDA #$00
PRG060_828C:
	; Update Spr_Flags2
	STA Spr_Flags2+$00,Y

PRG060_828F:
	JMP PRG060_82A9	; Jump to PRG060_82A9


PRG060_8292:
	LDA #SPRANM2_PLAYERSTEP
	ADD <Player_CurShootAnim
	BNE PRG060_82A3	; Jump (technically always) to PRG060_82A3


PRG060_8299:
	LDA #SPRANM2_PLAYERSTAND
	ADD <Player_CurShootAnim
	CMP Spr_CurrentAnim+$00	
	BEQ PRG060_82A6	; If animation is already the correct one, jump to PRG060_82A6


PRG060_82A3:
	; Set Player's animation
	JSR PRG063_SetSpriteAnim


PRG060_82A6:
	; Slide along
	JSR PRG060_DoPlayerIdleOnIce


PRG060_82A9:
	JSR PRG060_PlayerDoWeapon

	JSR PRG060_CheckLadderStart

	LDA <Player_CurWeapon
	CMP #PLAYERWPN_WIREADAPTER
	BNE PRG060_82C7		; If the Player doesn't have the Wire Adapter selected, jump to PRG060_82C7 (RTS)

	LDA Spr_CurrentAnim+$00
	CMP #SPRANM2_PLAYERSTAND
	BNE PRG060_82C7		; If Player isn't currently standing, jump to PRG060_82C7

	LDA <Ctlr1_Held
	AND #PAD_UP
	BEQ PRG060_82C7	; If Player isn't holding UP, jump to PRG060_82C7

	; Look up!
	LDA #SPRANM2_PLAYERLOOKUP
	JSR PRG063_SetSpriteAnim


PRG060_82C7:
	RTS	; $82C7


PRG060_PState_FallJump:

	; Clear on-ice flag
	LDY #$00
	STY <Player_OnIce
	
	JSR PRG063_DoObjVertMovement	; Vertical movement

	PHP	; Save flags
	
	LDA <TileMap_Index
	CMP #TMAP_COSSACK1
	BNE PRG060_82EF		; If this isn't Cossack 1, jump to PRG060_82EF

	; Cossack 1...

	LDA Spr_YVel+$00
	BPL PRG060_82EF		; If Player moving upward, jump to PRG060_82EF

	; Cossack 1, Player on ground

	; If on ice, jump to PRG060_82ED, otherwise PRG060_82EF
	LDA <Level_TileAttrsDetected+$00
	CMP #TILEATTR_ICE
	BEQ PRG060_82ED

	LDA <Level_TileAttrsDetected+$01
	CMP #TILEATTR_ICE
	BEQ PRG060_82ED

	LDA <Level_TileAttrsDetected+$02
	CMP #TILEATTR_ICE
	BNE PRG060_82EF


PRG060_82ED:
	STA <Player_OnIce	; Set Player on ice

PRG060_82EF:

	PLP	; Restore flags
	
	; Modify speed for Cossack 1's snow or Toad Man's water
	JSR PRG060_DoSnowAndWaterFlow

	BCS PRG060_8320	; If Player is on ground, jump to PRG060_8320

	; Player not on ground...

	LDA #SPRANM2_PLAYERJUMPFALL
	CMP Spr_CurrentAnim+$00
	BEQ PRG060_8306	; If Player is currently in the jump/fall animation, jump to PRG060_8306

	; Player is not currently in jump/fall animation

	ADD <Player_CurShootAnim
	JSR PRG063_SetSpriteAnim

	; Set Player state to fall/jump
	LDA #PLAYERSTATE_FALLJUMP
	STA <Player_State

PRG060_8306:
	LDA Spr_YVel+$00
	BMI PRG060_8338	; If Player is falling down, jump to PRG060_8338

	; Player moving upward...

	LDA Spr_Var3+$00	; $830B
	BNE PRG060_833D	; $830E

	LDA <Ctlr1_Held
	AND #PAD_A
	BNE PRG060_8338	; If Player is holding A, jump to PRG060_8338

	; Player has released A (cancel jump)

	LDA #$00
	STA Spr_YVelFrac+$00
	STA Spr_YVel+$00
	
	BEQ PRG060_8338	; Jump (technically always) to PRG060_8338


PRG060_8320:
	; Player is on ground...

	LDA <Player_State
	BEQ PRG060_8352	; If Player is standing on ground, jump to PRG060_8352

	; Player not standing...

	; Landing noise
	LDA #SFX_PLAYERLAND
	JSR PRG063_QueueMusSnd

	; Set Player_State to standing
	LDA #PLAYERSTATE_STAND
	STA <Player_State
	
	; Set walk animation
	LDA #SPRANM2_PLAYERWALK
	ADD <Player_CurShootAnim
	JSR PRG063_SetSpriteAnim

	JSR PRG060_PlayerLandSetVars


PRG060_8338:
	; Spr_Var3 = 0
	LDA #$00
	STA Spr_Var3+$00

PRG060_833D:
	
	; Player in the air...
	
	; Set facing direction by input
	LDA <Ctlr1_Held
	AND #(PAD_LEFT | PAD_RIGHT)
	STA Spr_FaceDir+$00
	STA <Player_FaceDir
	
	; Horizontal movement (in air)
	LDY #$00
	JSR PRG063_DoObjMoveSetFaceDir

	; Do/Update weapons
	JSR PRG060_PlayerDoWeapon

	; Seek ladder and start climbing if found and Player pressing UP
	JSR PRG060_CheckLadderStart

	CLC	; Clear carry

PRG060_8352:
	RTS	; $8352

PRG060_PState_Slide:
	LDY #$04
	JSR PRG063_DoObjVertMovement
	JSR PRG060_DoSnowAndWaterFlow

	BCS PRG060_8368	; If on ground, jump to PRG060_8368

	; Not on ground...

	LDY #$39	; Y = $39 (index into PRG062_TDetFloorOffSpread)
	JSR PRG062_ObjDetFloorAttrs

	LDA <Temp_Var16
	AND #$10
	BEQ PRG060_83D3


PRG060_8368:
	LDA <Ctlr1_Pressed
	AND #PAD_A
	BEQ PRG060_839D	; If Player is not pressing A, jump to PRG060_839D

	; Player is holding A...

	LDA <Ctlr1_Held
	AND #PAD_DOWN
	BNE PRG060_839D	; If Player is holding DOWN, jump to PRG060_839D

	; Player pressed A, and is NOT holding DOWN... (jump out of the slide)

	LDY #$03	; Y = $03 (index into PRG062_TDetFloorOffSpread)
	JSR PRG062_ObjDetFloorAttrs

	LDA <Temp_Var16
	BNE PRG060_839D

	JSR PRG060_TestPlayerObjsCollide
	BCS PRG060_839D		; If Player collided with object, jump to PRG060_839D

	; Player X velocity
	LDA #$4C
	STA Spr_XVelFrac+$00
	STA <Player_HCurSpeedFrac
	LDA #$01
	STA Spr_XVel+$00
	STA <Player_HCurSpeed
	
	; Player Y velocity
	LDA #$00
	STA Spr_YVelFrac+$00
	LDA #$05
	STA Spr_YVel+$00
	
	JMP PRG060_PState_FallJump	; Chain into fall/jump code


PRG060_839D:
	LDA <Ctlr1_Held
	AND #(PAD_LEFT | PAD_RIGHT)
	BEQ PRG060_83B4	; If Player is not pressing LEFT/RIGHT, jump to PRG060_83B4

	; Player is pressing LEFT/RIGHT...

	STA <Temp_Var0	; -> Temp_Var0
	
	AND <Player_FaceDir
	BNE PRG060_83B4	; If Player holding same direction as before, jump to PRG060_83B4

	; Player changed direction

	; Set new facing direction
	LDA <Temp_Var0
	STA <Player_FaceDir
	STA Spr_FaceDir+$00
	
	; Stop sliding
	LDA #$00
	STA <Player_SlideTimer

PRG060_83B4:
	LDY #$04
	JSR PRG063_DoObjMoveSetFaceDir

	BCS PRG060_83C3	; If Player slide into wall, jump to PRG060_83C3

	; Decrease slide timer
	LDA <Player_SlideTimer
	BEQ PRG060_83C3

	DEC <Player_SlideTimer
	BNE PRG060_83EF		; If slide timer > 0, jump to PRG060_83EF


PRG060_83C3:
	LDY #$03	; Y = $03 (index into PRG062_TDetFloorOffSpread)
	JSR PRG062_ObjDetFloorAttrs

	LDA <Temp_Var16
	AND #$10
	BNE PRG060_83EF

	JSR PRG060_TestPlayerObjsCollide	; $83CE

	BCS PRG060_83EF	; $83D1


PRG060_83D3:
	
	; Return to standing
	LDA #PLAYERSTATE_STAND
	STA <Player_State
	
	; Player X velocity
	LDA #$4C
	STA Spr_XVelFrac+$00
	STA <Player_HCurSpeedFrac
	LDA #$01
	STA Spr_XVel+$00
	STA <Player_HCurSpeed
	
	; Walking animation
	LDX #$00
	LDA #SPRANM2_PLAYERWALK
	JSR PRG063_SetSpriteAnim

	JSR PRG063_SetObjYVelToMinus1


PRG060_83EF:
	LDX #$00	; $83EF
	RTS	; $83F1


	; Returns carry set if Player collided with an object
PRG060_TestPlayerObjsCollide:

	LDX #$17	; X = $17 (scanning object slots)
PRG060_83F4:
	LDA Spr_SlotID+$00,X
	BEQ PRG060_8417	; If object slot empty, jump to PRG060_8417

	; Not empty object slot...

	LDA Spr_Flags+$00,X
	AND #$02
	BEQ PRG060_8417	; $83FE

	LDA #PLAYERCSA_SHOOT
	STA Spr_CurrentAnim+$00
	JSR PRG063_TestPlayerObjCollide

	; Set Player slide animation
	LDA #SPRANM2_PLAYERSLIDE
	STA Spr_CurrentAnim+$00	
	
	BCS PRG060_8417	; If Player didn't collide with object, jump to PRG060_8417

	LDA Spr_Y+$00
	CMP Spr_Y+$00,X
	BGE PRG060_841D		; collide, jump to PRG060_841D (CMP set carry)


PRG060_8417:
	DEX	; X--
	CPX #$07
	BNE PRG060_83F4	; While X > 0, loop

	CLC	; Clear carry (no impact)

PRG060_841D:
	LDX #$00	; $841D

PRG060_841F:
	RTS	; $841F

PRG060_PState_Climb:
	JSR PRG060_PlayerDoWeapon	; Update/do weapons

	LDA <Player_CurShootAnim
	BNE PRG060_841F	; If Player is shooting, jump to PRG060_841F (RTS)

	LDA <Ctlr1_Held
	AND #(PAD_DOWN | PAD_UP)
	BNE PRG060_8434	; If Player is pressing UP/DOWN, jump to PRG060_8434

	LDA #$00
	STA Spr_AnimTicks+$00
	BEQ PRG060_8449	; Jump (technically always) to PRG060_8449


PRG060_8434:
	; Player not pressing UP/DOWN

	; Set direction
	STA Spr_FaceDir+$00
	STA <Player_FaceDir
	
	; Do movement
	LDY #$00
	JSR PRG063_DoMoveVertOnly

	BCC PRG060_8449	; If didn't hit solid, jump to PRG060_8449

	; Hit solid

	LDA Spr_FaceDir+$00
	AND #SPRDIR_UP
	BNE PRG060_8481		; If Player was moving upward, jump to PRG060_8481 (hit ceiling while climinb ladder)
	BEQ PRG060_8492		; Otherwise, jump to PRG060_8492 (let go of ladder, climbed to floor)


PRG060_8449:
	; Rescan ladder
	LDY #$02
	JSR PRG062_ObjDetWallAttrs

	; Check to make sure still on ladder
	LDY #$02	; Y = 2 (scanning Player's detected tile attrs)
PRG060_8450:
	LDA Level_TileAttrsDetected+$00,Y
	CMP #TILEATTR_LADDER
	BEQ PRG060_8460	; If ladder detected, jump to PRG060_8460

	CMP #TILEATTR_LADDERTOP
	BEQ PRG060_8460	; If top of ladder detected, jump to PRG060_8460

	; No ladder in this attribute slot...

	DEY	; Y--
	BPL PRG060_8450	; While Y >= 0, loop!

	BMI PRG060_8492	; No ladder detected, jump to PRG060_8492


PRG060_8460:
	; Ladder still detected...
	
	; Center Player on ladder
	LDA Spr_X+$00
	AND #$F0
	ORA #$08
	STA Spr_X+$00
	
	; General climbing animation
	LDA #SPRANM2_PLAYERCLIMB
	
	LDY <Level_TileAttrsDetected+$01
	BNE PRG060_8476	; If ladder detected in "middle", jump to PRG060_8476

	LDY <Level_TileAttrsDetected+$00
	BNE PRG060_8476	; If ladder detected at "top", jump to PRG060_8476

	; Player is coming over top of ladder, use hunch over 
	LDA #SPRANM2_PLYRCLIMTOP

PRG060_8476:
	ADD <Player_CurShootAnim
	CMP Spr_CurrentAnim+$00
	BEQ PRG060_8486	; If animation is already set to this, jump to PRG060_8486

	JMP PRG063_SetSpriteAnim	; Otherwise, set the animation

PRG060_8481:
	; Spr_AnimTicks = 0
	LDA #$00
	STA Spr_AnimTicks


PRG060_8486:
	LDA <Ctlr1_Pressed
	AND #PAD_A
	BEQ PRG060_84AC	; If Player is not pressing A, jump to PRG060_84AC

	; Player pressed A...

	LDA <Ctlr1_Held
	AND #(PAD_UP | PAD_DOWN)
	BNE PRG060_84AC	; If Player is pressing UP/DOWN, jump to PRG060_84AC (RTS)

	; Player pressed A without holding UP/DOWN

PRG060_8492:
	; Let go of ladder

	LDA <Level_TileAttr_GreatestDet
	STA <Player_LastTileAttr
	
	LDA #PLAYERSTATE_STAND
	STA <Player_State
	JSR PRG063_SetObjYVelToMinus1

	LDA #SPRDIR_LEFT
	STA <Player_FaceDir
	
	LDA Spr_Flags+$00
	AND #SPR_HFLIP
	BEQ PRG060_84AC	; If Player not horizontally flipped (facing right), jump to PRG060_84AC

	LDA #SPRDIR_RIGHT
	STA <Player_FaceDir

PRG060_84AC:
	RTS	; $84AC


PRG060_PState_RMarine:
	LDA #SPRANM2_RUSHMARINECLOSE
	CMP Spr_CurrentAnim+$00
	BNE PRG060_84C0		; If Player animation is not in the Rush Marine ride animation, jump to PRG060_84C0
	
	LDA Spr_Frame+$00
	CMP #$04
	BNE PRG060_84AC		; If the Rush Marine animation hasn't hit frame 4 (closing), jump to PRG060_84AC
	
	LDA #SPRANM2_RUSHMARINERIDE
	JSR PRG063_SetSpriteAnim

PRG060_84C0:
	; Set direction based on input
	LDA <Ctlr1_Held
	AND #(PAD_UP | PAD_DOWN | PAD_LEFT | PAD_RIGHT)
	STA Spr_FaceDir+$00
	TAY		; -> 'Y'
	
	; Set velocity
	LDA PRG060_RMarine_XvelFrac,Y
	STA Spr_XVelFrac
	LDA PRG060_RMarine_Xvel,Y
	STA Spr_XVel
	LDA PRG060_RMarine_YvelFrac,Y
	STA Spr_YVelFrac
	LDA PRG060_RMarine_Yvel,Y
	STA Spr_YVel
	
	; Vertical move check for water line
	LDY #$1A
	JSR PRG063_DoMoveVertOnly
	
	LDA Spr_FaceDir+$00
	AND #SPRDIR_UP
	BEQ PRG060_84FA		; If not moving up, jump to PRG060_84FA
	
	; Moving up, scanning for water top
	LDY #$02	; Y = $02 (index into PRG062_TDetFloorOffSpread)
	JSR PRG062_ObjDetFloorAttrs
	
	LDA <Temp_Var16
	CMP #TILEATTR_WATER
	BEQ PRG060_84FA		; If still in water, jump to PRG060_84FA
	
	; No water, lock down Y position
	JSR PRG062_ObjOffsetYToTileTopRev

PRG060_84FA:
	; Keep Player from going too high in Rush Marine
	LDA #$10
	CMP Spr_Y
	BLT PRG060_8506		; If below the top 16 pixels, jump to PRG060_8506
	
	; Lock Player to top of screen
	STA Spr_Y
	BGE PRG060_8510		; Jump (technically always) to PRG060_8510

PRG060_8506:
	; Keep Player from going too low in Rush Marine
	LDA #$E0
	CMP Spr_Y
	BGE PRG060_8510		; If above the bottom 32 pixels, jump to PRG060_8510
	
	; Lock Player to bottom of screen
	STA Spr_Y

PRG060_8510:
	
	; Move in Rush Marine
	LDY #$26
	JSR PRG063_DoObjMoveSetFaceDir
	
	; Able to shoot
	JSR PRG060_DoWpnMegaBuster
	
	DEC Spr_Var8+$00	; Decrement Rush Marine counter
	BNE PRG060_854C		; If > 0, jump to PRG060_854C (RTS)
	
	; Reset the Rush Marine counter
	LDA #$3C
	STA Spr_Var8+$00
	
	; Expired timer, decrement energy
	JSR PRG063_WeaponConsumeEnergy
	
	LDA <Player_WpnEnergy+2
	AND #$7F
	BNE PRG060_854C		; If still Rush Marine energy left, jump to PRG060_854C (RTS)
	
	; Set to fall animation
	LDA #SPRANM2_PLAYERJUMPFALL
	JSR PRG063_SetSpriteAnim
	
	; Setup to reload Player's patterns now that Rush Marine terminates
	LDA #$4A
	JSR PRG062_CHRRAMDynLoadPalSeg
	
	LDA #$00
	STA <DisFlag_NMIAndDisplay

	; Reload Player's patterns
PRG060_8539:
	JSR PRG063_CHRRAMDynLoadCHRSegSafe
	
	LDA <CommitGBuf_Flag
	BEQ PRG060_8546		; If no more graphics to load, jump to PRG060_8546
	
	JSR PRG063_DrawSprites_RsetSprIdx
	JMP PRG060_8539

PRG060_8546:
	INC <DisFlag_NMIAndDisplay
	
	LDX #PLAYERSTATE_STAND
	STX <Player_State

PRG060_854C:
	RTS	
	
	; Rush Marine velocities based on direction input
PRG060_RMarine_XvelFrac:	.byte $00, $4C, $4C, $00, $00, $EB, $EB, $00, $00, $EB, $EB, $00, $00, $00, $00, $00
PRG060_RMarine_Xvel:		.byte $00, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
PRG060_RMarine_YvelFrac:	.byte $00, $00, $00, $00, $4C, $EB, $EB, $00, $4C, $EB, $EB, $00, $00, $00, $00, $00
PRG060_RMarine_Yvel:		.byte $00, $00, $00, $00, $01, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00


PRG060_PState_Wire:
	LDA Spr_CurrentAnim+$04
	CMP #SPRANM2_WIREADAPTERPL
	BNE PRG060_85DC	; If not currently pulling Player, jump to PRG060_85DC

	LDA #SPRANM2_PLAYERWIREHANG
	ADD <Player_CurShootAnim
	CMP Spr_CurrentAnim+$00
	BEQ PRG060_85AB	; If Player animation is already set, jump to PRG060_85AB

	; Set correct animation
	JSR PRG063_SetSpriteAnim

	; Upward velocity
	LDA #$00
	STA Spr_YVelFrac+$00
	LDA #$04
	STA Spr_YVel+$00

PRG060_85AB:
	LDY #$02	; $85AB
	JSR PRG062_ObjDetFloorAttrs	; $85AD

	LDA <Temp_Var16
	STA <Player_LastTileAttr
	
	; Player moving up by Wire Adapter
	LDY #$25
	JSR PRG063_DoObjVertMoveUpOnly

	BCC PRG060_85BE	; If Wire Adapter hasn't clung, jump to PRG060_85BE

	; Otherwise, allow shooting
	JSR PRG060_DoWpnMegaBuster


PRG060_85BE:
	
	; Position Wire Adapter
	LDA Spr_Y+$00
	SUB #$0E
	STA Spr_Var1+$04
	
	LDA <Ctlr1_Pressed
	AND #PAD_A
	BNE PRG060_85D3	; If Player pressed A, jump to PRG060_85D3

	LDA <Ctlr1_Held
	AND #PAD_DOWN
	BEQ PRG060_85DC	; If Player hasn't hit DOWN, jump to PRG060_85DC (RTS)


PRG060_85D3:
	; Player pressed A / DOWN

	; Delete Wire Adapter
	LDY #$04
	JSR PRG063_DeleteObjectY

	LDA #PLAYERSTATE_STAND
	STA <Player_State

PRG060_85DC:
	RTS	; $85DC
	

PRG060_PState_Hurt:
	LDA Spr_Var1+$00
	CMP #PLAYERSTATE_RUSHMARINE
	BEQ PRG060_8626	; If Player was in Rush Marine, jump to PRG060_8626

	LDY Spr_Var2+$00
	JSR PRG063_DoObjVertMovement

	; Player hurt slide speed
	LDA #$80
	STA Spr_XVelFrac+$00
	LDA #$00
	STA Spr_XVel+$00
	
	LDA Spr_Flags+$00
	PHA
	
	LDA Spr_Var1+$00
	CMP #$02
	BEQ PRG060_8616	; If Spr_Var1 = 2, jump to PRG060_8616

	LDA Spr_Flags+$00
	AND #SPR_HFLIP
	BNE PRG060_860F	; If Player is facing right, jump to PRG060_860F

	LDY Spr_Var2+$00
	JSR PRG063_DoObjHorzMovement_ToR

	JMP PRG060_8616	; Jump to PRG060_8616


PRG060_860F:
	LDY Spr_Var2+$00	; Y = Spr_Var2
	
	INY	; Y = Spr_Var2 + 1
	
	JSR PRG063_DoObjHorzMovement_ToL


PRG060_8616:

	; This centers Rush at the Player, likely intended only for when riding Rush Jet,
	; but will happen any time with any Rush form which causes oddities...
	LDA Spr_X+$00
	STA Spr_X+$04
	LDA Spr_XHi+$00
	STA Spr_XHi+$04
	
	PLA
	STA Spr_Flags+$00

PRG060_8626:
	LDA Spr_Frame+$00
	CMP #$09
	BNE PRG060_865B	; If Player's injury frame <> 9, jump to PRG060_865B (RTS)

	; Flicker and be invincible for a bit
	LDA #$3C
	STA <Player_PlayerHitInv
	STA Spr_FlashOrPauseCnt
	
	LDA Spr_Var1+$00
	CMP #PLAYERSTATE_RUSHMARINE
	BEQ PRG060_864D	; If Player was in Rush Marine, jump to PRG060_864D

	CMP #PLAYERSTATE_SLIDING
	BNE PRG060_8654	; If Player wasn't sliding, jump to PRG060_8654

	; Restore sliding
	STA <Player_State	; Player_State = PLAYERSTATE_SLIDING
	
	; Restore sliding animation
	LDA #SPRANM2_PLAYERSLIDE
	JSR PRG063_SetSpriteAnim

	LDA #$00
	STA <Player_SlideTimer
	
	JMP PRG060_83C3	; Jump to PRG060_83C3 (terminate slide)

PRG060_864D:

	; Restore Rush Marine state
	STA <Player_State	; Player_State = PLAYERSTATE_RUSHMARINE

	; Restore Rush Marine animation
	LDA #SPRANM2_RUSHMARINERIDE
	JMP PRG063_SetSpriteAnim

PRG060_8654:
	
	; Return to standing state
	LDA #PLAYERSTATE_STAND
	STA <Player_State
	
	; Set animation
	JSR PRG063_SetSpriteAnim


PRG060_865B:
	RTS	; $865B

PRG060_PState_DoNothing:
	RTS	; $865C


PRG060_PState_TeleportOut:
	LDA #SPRANM2_TELEPORTOUT
	CMP Spr_CurrentAnim+$00
	BEQ PRG060_867D	; If already started the teleport-out animation, jump to PRG060_867D

	; Start the teleport-out animation
	JSR PRG063_SetSpriteAnim

	LDA #$90
	STA Spr_Flags+$00
	
	LDA #$00
	STA Spr_YVelFrac+$00
	STA Spr_YVel+$00
	STA <Player_CurShootAnim
	STA <Player_ShootAnimTimer
	
	; Teleport out sound
	LDA #SFX_TELEPORTOUT
	JSR PRG063_QueueMusSnd


PRG060_867D:
	LDA Spr_Frame+$00
	CMP #$04
	BNE PRG060_86AC	; If teleport has not reached frame 4, jump to PRG060_86AC (RTS)

	LDA Spr_YHi+$00
	BNE PRG060_86AC	; If Player is off-screen vertically, jump to PRG060_86AC (RTS)

	; Hold the animation
	LDA #$00
	STA Spr_AnimTicks+$00
	
	; Moving upward
	LDA Spr_YVelFrac+$00
	ADD #$40
	STA Spr_YVelFrac+$00
	LDA Spr_YVel+$00
	ADC #$00
	STA Spr_YVel+$00
	JSR PRG063_ApplyYVelocityNeg

	; Ticks until ending level
	LDA #$78
	STA Level_ExitTimeout
	LDA #$00
	STA Level_ExitTimeoutH

PRG060_86AC:
	RTS	; $86AC

PRG060_PState_BossWait:
	; Only allow Player to fall
	LDY #$00
	JSR PRG063_DoObjVertMovement

	BCC PRG060_86BE	; If Player hasn't hit ground, jump to PRG060_86BE

	LDA #SPRANM2_PLAYERSTAND
	CMP Spr_CurrentAnim+$00
	BEQ PRG060_86BE	; If Player is in the standing animation, jump to PRG060_86BE

	; Set standing animation
	JSR PRG063_SetSpriteAnim


PRG060_86BE:
	LDA #PLAYERCSA_NOSHOOT
	STA <Player_ShootAnimTimer
	STA <Player_CurShootAnim
	
	; Always face right
	LDA #SPRDIR_RIGHT
	STA <Player_FaceDir
	STA Spr_FaceDir+$00
	JMP PRG063_SetObjFlipForFaceDir

PRG060_PState_READY:
	LDA #SPRANM2_TELEPORT
	CMP Spr_CurrentAnim+$00
	BEQ PRG060_8720	; If Player is teleporting in, jump to PRG060_8720

	LDY Spr_Frame+$00
	CPY #$19
	BNE PRG060_86AC	; If READY animation is not at frame $19, jump to PRG060_86AC (RTS)

	; Set Player animation to SPRANM2_TELEPORT
	JSR PRG063_SetSpriteAnim

	; Face right
	LDA Spr_Flags+$00
	ORA #SPR_HFLIP
	STA Spr_Flags+$00
	
	; Start at top of screen
	LDA #$00
	STA Spr_Y+$00
	
	LDY <TileMap_Index
	
	; OR in init bits from PRG062_TMapInitSprFlags (really just amounts to being "behind" rain, water, etc. in Toad Man)
	LDA Spr_Flags+$00
	ORA PRG062_TMapInitSprFlags,Y
	STA Spr_Flags+$00
	
	LDA <TileMap_Index
	CMP #TMAP_WILY3
	BEQ PRG060_8713	; If this is Wily 3, jump to PRG060_8713

	; Not Wily 3...

	CMP #TMAP_TOADMAN
	BNE PRG060_8720	; If this isn't Toad Man, jump to PRG060_8720

	; Toad Man only...

	LDA Spr_XHi+$00
	CMP #$1A
	BNE PRG060_8720	; If not still in segment of Toad Man where you are behind stuff, jump to PRG060_8720

	; Remove the SPR_BEHINDBG bit
	LDA Spr_Flags+$00
	AND #~SPR_BEHINDBG
	STA Spr_Flags+$00
	
	JMP PRG060_8720		; Jump to PRG060_8720

PRG060_8713:
	; Wily 3 only...

	LDA <Current_Screen
	CMP #$09
	BNE PRG060_8720		; If not on screen 9, jump to PRG060_8720

	; Slightly modified start position, lands slightly left on transporter... for some reason
	LDA #$68
	STA Spr_X+$00
	STA <RAM_0027

PRG060_8720:
	
	; Seeking solid ground as teleporting in...
	LDY #$02
	JSR PRG062_ObjDetWallAttrs

	LDA <Temp_Var16
	STA <Player_LastTileAttr
	
	AND #TILEATTR_SOLID
	BNE PRG060_8734	; If this isn't solid ground, jump to PRG060_8734

	LDA Spr_Y+$00
	CMP #$40
	BGE PRG060_873A	; If Player Y >= $40 (too high for landing), jump to PRG060_873A


PRG060_8734:
	JSR PRG063_DoMoveSimpleVert	; Move teleportation

	JMP PRG060_876F	; Jump to PRG060_876F (hold teleport animation)


PRG060_873A:
	LDY #$00
	JSR PRG063_DoObjVertMovement

	BCC PRG060_876F	; If no solid ground, jump to PRG060_876F (hold teleport animation)

	LDA Spr_Frame+$00
	BNE PRG060_8752	; If teleportation animation started, jump to PRG060_8752

	LDA Spr_AnimTicks+$00
	CMP #$01
	BNE PRG060_8752	; If first tick of teleportation animation, jump to PRG060_8752

	; Teleport landing sound effect
	LDA #SFX_TELEPORTLAND
	JSR PRG063_QueueMusSnd
	

PRG060_8752:
	LDA Spr_Frame+$00
	CMP #$04
	BNE PRG060_8774	; If teleport frame <> 4, jump to PRG060_8774 (RTS)

	; Set standing animation
	LDA #SPRANM2_PLAYERSTAND
	JSR PRG063_SetSpriteAnim

	; Init Player state, no horizontal movement
	LDA #PLAYERSTATE_STAND
	STA <Player_State
	STA <Player_LandPressLR
	STA <Player_LandXVelFrac
	STA <Player_LandXVel
	
	; Face right
	LDA #SPRDIR_RIGHT
	STA <Player_FaceDir
	STA Spr_FaceDir+$00

PRG060_876F:

	; Holding teleport animation
	LDA #$00
	STA Spr_AnimTicks+$00

PRG060_8774:
	RTS	; $8774


PRG060_PState_GotSpecWep:
	LDA Spr_YHi+$00
	BNE PRG060_877F	; If Player is vertically off-screen, jump to PRG060_877F

	; Otherwise, set timer
	LDA #$FF
	STA Level_ExitTimeout	; Level_ExitTimeout = $FF

PRG060_877F:
	LDA Level_EndLevel_Timeout
	BNE PRG060_878C	; If Level_EndLevel_Timeout > 0, jump to PRG060_878C

	; Chain teleport out sequence
	JSR PRG060_PState_TeleportOut

	; Go midpoint of level
	LDA #$01
	STA <Player_Midpoint
	
	RTS	; $878B


PRG060_878C:
	; Fall if needed
	LDY #$00
	STY <Player_ShootAnimTimer
	STY <Player_CurShootAnim
	JSR PRG063_DoObjVertMovement

	LDA #SPRANM2_PLAYERSTAND
	
	BCS PRG060_879B	; If Player is on ground, jump to PRG060_879B

	LDA #SPRANM2_PLAYERJUMPFALL

PRG060_879B:
	CMP Spr_CurrentAnim+$00
	BEQ PRG060_87A3	; If Player animation is set correctly, jump to PRG060_87A3

	; Set proper animation
	JSR PRG063_SetSpriteAnim


PRG060_87A3:
	DEC Level_EndLevel_Timeout	; Level_EndLevel_Timeout--
	RTS	; $87A6

PRG060_PState_EndLevel:
	
	LDY #$00
	STY <Player_ShootAnimTimer
	STY <Player_CurShootAnim
	JSR PRG063_DoObjVertMovement

	; Player in air for power gain
	LDA #SPRANM2_PLAYERJUMPFALL
	
	BCC PRG060_87BD	; If Player not on ground, jump to PRG060_87BD

	; Player walking to center for power gain
	LDA #SPRANM2_PLAYERWALK
	
	LDY Level_EndLevel_Timeout	; $87B6
	BEQ PRG060_87BD	; $87B9

	; Player just standing still for a moment
	LDA #SPRANM2_PLAYERSTAND

PRG060_87BD:
	CMP Spr_CurrentAnim+$00
	BEQ PRG060_87C5	; If the current animation is set, jump to PRG060_87C5

	; Otherwise change to the proper animation
	JSR PRG063_SetSpriteAnim


PRG060_87C5:
	LDA Level_EndLevel_Timeout
	BEQ PRG060_87CE	; If Level_EndLevel_Timeout = 0, jump to PRG060_87CE

	DEC Level_EndLevel_Timeout	; Level_EndLevel_Timeout--
	RTS	; $87CD


PRG060_87CE:
	LDA <TileMap_Index
	CMP #TMAP_COSSACK1
	BGE PRG060_8844	; If Cossack 1 or later, no power gained, jump to PRG060_8844

	; Normal robot masters...

	LDA Spr_X+$00
	CMP #$80
	BEQ PRG060_8813	; If Player is at the middle, jump to PRG060_8813

	; Player still walking...
	LDY #$00
	JSR PRG063_DoObjMoveSetFaceDir

	BCC PRG060_87EC	; If Player hasn't hit anything, jump to PRG060_87EC

	; CHECKME - UNUSED?
	; Looks like this lets the Player hop a bit if they encounter an
	; obstacle en route to the center
	LDA #$00
	STA Spr_YVelFrac+$00
	LDA #$05
	STA Spr_YVel+$00


PRG060_87EC:
	LDA Spr_FaceDir+$00
	AND #SPRDIR_RIGHT
	BEQ PRG060_87FE	; If Player is heading right, jump to PRG060_87FE

	; Player heading left...

	LDA #$80
	CMP Spr_X+$00
	BEQ PRG060_8805	; If Player is at the center, jump to PRG060_8805

	BLT PRG060_8805	; If Player is to the left of center, jump to PRG060_8805

	BGE PRG060_8812	; If Player is to the right of center, jump to PRG060_8812


PRG060_87FE:
	LDA #$80
	CMP Spr_X+$00
	BLT PRG060_8812	; If Player not is in place, jump to PRG060_8812 (RTS)


PRG060_8805:
	; Player is at center (or close enough)
	STA Spr_X+$00
	
	; Jump up ward
	LDA #$00
	STA Spr_YVelFrac+$00
	LDA #$08
	STA Spr_YVel+$00

PRG060_8812:
	RTS	; $8812


PRG060_8813:
	LDA Spr_YVel+$00
	BPL PRG060_8812	; While Player is moving upward, jump to PRG060_8812 (RTS)

	LDA Spr_Y+$00
	STA <Temp_Var0
	
	LDA #$6C
	CMP Spr_Y+$00
	BGE PRG060_8812	; If Player Y is above $6C, jump to PRG060_8812 (RTS)

	STA Spr_Y+$00	; Lock at $6C
	
	; Waiting for all objects to be emptied out
	LDY #$17
PRG060_8829:
	LDA Spr_SlotID+$00,Y
	BNE PRG060_8812	; If this slot is not empty, jump to PRG060_8812 (RTS)

	DEY	; Y--
	CPY #$07
	BNE PRG060_8829	; While Y <> 7, loop

	LDA <Temp_Var0	; Player's Y
	STA Spr_Y+$00
	
	LDA #SPRANM2_PLAYERWALK
	CMP Spr_CurrentAnim+$00
	BNE PRG060_8812	; If Player is not in walking animation, jump to PRG060_8812 (RTS)

	; Player teleports out!
	LDA #PLAYERSTATE_TELEPORTOUT
	STA <Player_State
	
	RTS	; $8843


PRG060_8844:
	; Cossack 1 or later alternate

	; Is the Player ever walking for the Cossack 1+ exit??
	LDA Spr_CurrentAnim+$00
	CMP #SPRANM2_PLAYERWALK
	BNE PRG060_884F	; If Player is not walking, jump to PRG060_884F (RTS)

	; Player teleports out!
	LDA #PLAYERSTATE_TELEPORTOUT
	STA <Player_State

PRG060_884F:
	RTS	; $884F

PRG060_PState_CossackClaw:
	LDA Spr_CurrentAnim+$16
	CMP #$6C
	BEQ PRG060_8894	; While just being held in claw grip, jump to PRG060_8894 (RTS)

	LDY #$00
	JSR PRG063_DoObjVertMovement

	BCC PRG060_8894	; If Player is not on ground, jump to PRG060_8894 (RTS)

	LDA #SPRANM2_PLAYERHURT
	JSR PRG063_SetSpriteAnim

	LDA #PLAYERSTATE_HURT
	STA <Player_State
	
	LDA #PLAYERCSA_NOSHOOT
	STA <Player_ShootAnimTimer
	STA <Player_CurShootAnim
	STA Spr_Var1+$00
	STA Spr_Var2+$00
	
	; Deduct 6 HP
	LDA <Player_HP
	AND #$1F
	SUB #$06
	BCS PRG060_887E

	LDA #$00

PRG060_887E:
	ORA #$80
	STA <Player_HP
	
	LDA <Player_HP
	AND #$1F
	BNE PRG060_8894	; If Player not dead, jump to PRG060_8894

	LDA #$80
	STA <Player_HP
	
	; Die
	LDA #$FF
	STA <Player_TriggerDeath
	
	LDA #PLAYERSTATE_STAND
	STA <Player_State

PRG060_8894:
	RTS	; $8894

PRG060_PState_PostCossack:
	; Drop to ground
	LDY #$00
	JSR PRG063_DoObjVertMovement

	BCS PRG060_88A9	; If Player is on ground, jump to PRG060_88A9

	; Not on ground..

	LDA #SPRANM2_PLAYERJUMPFALL
	CMP Spr_CurrentAnim+$00
	BEQ PRG060_88BA	; If Player is in jump/fall, jump to PRG060_88BA

	; Set animation
	JSR PRG063_SetSpriteAnim

	JMP PRG060_88BA	; Jump to PRG060_88BA


PRG060_88A9:
	LDA Spr_X+$00,X
	CMP #$2C
	BEQ PRG060_88E8		; If Player is locked to $2C, jump to PRG060_88E8

	LDA #SPRANM2_PLAYERWALK
	CMP Spr_CurrentAnim+$00
	BEQ PRG060_88BA		; If Player is already in walk animation, jump to PRG060_88BA

	; Set walking animation
	JSR PRG063_SetSpriteAnim


PRG060_88BA:
	LDY #$00
	JSR PRG063_DoObjMoveSetFaceDir

	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BEQ PRG060_88CF	; If facing right, jump to PRG060_88CF

	LDA #$2B
	CMP Spr_X,X
	BGE PRG060_8919		; If Player is < $2B, jump to PRG060_8919
	BLT PRG060_88D6		; Otherwise, jump to PRG060_88D6


PRG060_88CF:
	LDA #$2C
	CMP Spr_X+$00,X
	BLT PRG060_8919	; If Player X > $2C, jump to PRG060_8919

PRG060_88D6:
	
	; Lock Player to $2C
	LDA #$2C
	STA Spr_X+$00,X
	
	; Stand
	LDA #SPRANM2_PLAYERSTAND
	JSR PRG063_SetSpriteAnim

	; Face right
	LDA Spr_Flags+$00,X
	ORA #SPR_HFLIP
	STA Spr_Flags+$00,X

PRG060_88E8:
	LDA Spr_Var7+$00
	BEQ PRG060_8919		; If timeout to cinematic start, jump to PRG060_8919 (RTS)

	DEC Spr_Var7+$00
	BNE PRG060_8919		; If timeout to cinematic start hasn't just hit zero, jump to PRG060_8919 (RTS)

	; Time to kick off post-Cossack cinematic...

	; Clear out sprite slot $13
	LDY #$13
	JSR PRG063_DeleteObjectY

	; Proto Man teleporting in
	LDA #SPRANM2_PROTOTELEPORT
	JSR PRG063_CopySprSlotSetAnim

	; It's Proto Man!
	LDA #SPRSLOTID_PROTOMAN
	STA Spr_SlotID+$00,Y
	
	LDA #$D8
	STA Spr_X+$00,Y
	LDA #$00
	STA Spr_Y+$00,Y
	STA Spr_YVelFrac+$00,Y
	STA Spr_YVel+$00,Y
	
	LDA Spr_Flags+$00,Y
	AND #(SPR_BEHINDBG | $80)
	STA Spr_Flags+$00,Y

PRG060_8919:
	RTS	; $8919


PRG060_PState_PostCsakCine:
	LDY <CineCsak_TextOffset
	BNE PRG060_893B	; If this isn't a new dialog block, jump to PRG060_893B

	LDY <CineCsak_CurDialogSet	; Y = index to current dialog state
	
	; Pointer to dialog strings
	LDA PRG060_PostCossack_DiagTableL,Y
	STA <CineCsak_TextPtrL
	LDA PRG060_PostCossack_DiagTableH,Y
	STA <CineCsak_TextPtrH

PRG060_892A:
	
	; Start of dialog text
	LDA #$28
	STA Graphics_Buffer+$00
	LDA #$44
	STA Graphics_Buffer+$01
	
	; 1 pattern
	LDA #$00
	STA Graphics_Buffer+$02
	
	BEQ PRG060_893E	; Jump (technically always) to PRG060_893E


PRG060_893B:
	INC Graphics_Buffer+$01	; Next VRAM ADDR

PRG060_893E:
	LDY <CineCsak_TextOffset	; Y = current offset within dialog block
	
	; $FD - Line break
	; $FE - Dialog string end
	; $FF - Dialog block end
	
	LDA [CineCsak_TextPtrL],Y
	BMI PRG060_8951				; If this is a control character, jump to PRG060_8951

	STA Graphics_Buffer+$03	; $8944
	INC <CineCsak_TextOffset	; $8947

PRG060_8949:
	
	; Terminator
	LDA #$FF
	STA Graphics_Buffer+$04
	
	; Commit graphics buffer
	STA <CommitGBuf_Flag
	
	RTS	; $8950


PRG060_8951:
	CMP #$FD
	BEQ PRG060_8968	; If this is a line break, jump to PRG060_8968

	CMP #$FE
	BEQ PRG060_8977	; If this is a dialog string terminator, jump to PRG060_8977

	; Dialog block terminator ($FF)...

	LDY <CineCsak_CurDialogSet	; Y = current dialog block we're on
	
	; Do whatever's needed after this dialog block ends!
	LDA PRG060_PostCsakDiag_ActionL,Y
	STA <Temp_Var0
	LDA PRG060_PostCsakDiag_ActionH,Y
	STA <Temp_Var1
	
	JMP [Temp_Var0]


PRG060_8968:
	; Line break ($FD)

	; PPU VRAM address of second line
	LDA #$28
	STA Graphics_Buffer+$00
	LDA #$84
	STA Graphics_Buffer+$01
	
	; Move passed line break
	INC <CineCsak_TextOffset
	
	JMP PRG060_893E	; Jump to PRG060_893E


PRG060_8977:
	LDA <Ctlr1_Pressed
	AND #(PAD_A | PAD_B)
	BNE PRG060_8999	; If Player is pressing A/B, jump to PRG060_8999

	LDA #$28
	STA Graphics_Buffer+$00
	LDA #$AF
	STA Graphics_Buffer+$01
	
	LDA #$00
	STA Graphics_Buffer+$03
	
	LDA <General_Counter
	AND #$08
	BEQ PRG060_8949	; Every other 8 ticks, jump to PRG060_8949

	; Flash arrow
	LDA #$2F
	STA Graphics_Buffer+$03
	
	BNE PRG060_8949	; Jump (technically always) to PRG060_8949


PRG060_8999:
	; Advance to next dialog string

	; First dialog line PPU VRAM addr
	LDA #$28
	STA Graphics_Buffer+$00
	LDA #$44
	STA Graphics_Buffer+$01
	
	; Second dialog line PPU VRAM addr
	LDA #$28
	STA Graphics_Buffer+$1B
	LDA #$84
	STA Graphics_Buffer+$1C
	
	; Filling in blanks to clear out the lines
	LDY #$17
	STY Graphics_Buffer+$02
	STY Graphics_Buffer+$1D
	
	LDA #$00
PRG060_89B7:
	STA Graphics_Buffer+$03,Y
	STA Graphics_Buffer+$1E,Y
	DEY
	BPL PRG060_89B7
	
	; Dialog advancement arrow
	LDA #$28
	STA Graphics_Buffer+$36
	LDA #$AF
	STA Graphics_Buffer+$37
	
	; Clear out the dialog advancement arrow
	LDA #$00
	STA Graphics_Buffer+$38
	STA Graphics_Buffer+$39
	
	; Terminate
	STY Graphics_Buffer+$3A
	
	; Commit graphics buffer
	STY <CommitGBuf_Flag
	
	LDA #$00	; $89D7
	STA <DisFlag_NMIAndDisplay	; $89D9
	
	; Update frame
	JSR PRG063_UpdateOneFrame

	INC <DisFlag_NMIAndDisplay	; $89DE
	
	INC <CineCsak_TextOffset	; Move passed dialog string terminator
	
	JMP PRG060_892A	; Jump to PRG060_892A

PRG060_89E5:
	LDY #$17	; Object sprite slot 17
	
	LDA #SPRANM2_DRCOSSACKSTAND
	CMP Spr_CurrentAnim+$17
	BGE PRG060_8A03	; If Cossack's animation is set, jump to PRG060_8A03 (RTS)

	; Set Cossack's animation to hop out of the mech
	JSR PRG063_SetSpriteAnimY

	; Cossack facing left
	LDA Spr_Flags+$17
	AND #~SPR_HFLIP
	STA Spr_Flags+$17
	
	; Cossack's hop out velocity
	LDA #$D4
	STA Spr_YVelFrac+$17
	LDA #$02
	STA Spr_YVel+$17

PRG060_8A03:
	RTS	; $8A03


PRG060_8A04:
	LDA Spr_CurrentAnim+$16
	CMP #SPRANM2_COSSACKCLAW_GRABBY
	BNE PRG060_8A03	; If claw is no longer present, jump to PRG060_8A03

	; Black out Cossack's mech's palette for effect
	LDY #$0B
	LDA #$0F
PRG060_8A0F:
	STA PalData_1+4,Y
	STA PalData_2+4,Y
	DEY
	BPL PRG060_8A0F

	STY <CommitPal_Flag	; $8A18
	
	; Delete the mech's claw grip
	LDY #$16
	JSR PRG063_DeleteObjectY

	; For some reason Wily uses Proto Man's teleport in, but okay
	LDA #SPRANM2_PROTOTELEPORT
	JSR PRG063_SetSpriteAnimY

	; Setup Wily
	LDA #SPRSLOTID_WILY
	STA Spr_SlotID+$00,Y
	
	LDA #$68
	STA Spr_X+$00,Y
	LDA #$00
	STA Spr_Y+$00,Y
	STA Spr_YVelFrac+$00,Y
	STA Spr_YVel+$00,Y
	
	LDA Spr_Flags+$00,Y
	AND #(SPR_BEHINDBG | $80)
	STA Spr_Flags+$00,Y
	
	; Delete slot $15 object
	DEY	; Y = $15
	JSR PRG063_DeleteObjectY

	; Explosion on the mech
	LDA #SPRSLOTID_CEXPLOSION
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_Var1+$00,Y
	STA Spr_Var2+$00,Y
	STA Spr_Var3+$00,Y
	STA Spr_Var4+$00,Y
	JMP PRG063_SetSpriteAnimY
	

PRG060_8A5B:

	; Do the level exit, but just shorten the timer so it leaves immediately
	LDA #PLAYERSTATE_TELEPORTOUT
	STA <Player_State
	
	LDA #$01
	STA Level_ExitTimeout
	
	LDA #$00
	STA Level_ExitTimeoutH

	RTS	; $8A69


	; Action to perform after dialog block ends
PRG060_PostCsakDiag_ActionL:
	.byte LOW(PRG060_89E5)	; 0
	.byte LOW(PRG060_8A04)	; 1
	.byte LOW(PRG060_8A5B)	; 2

PRG060_PostCsakDiag_ActionH:
	.byte HIGH(PRG060_89E5)	; 0
	.byte HIGH(PRG060_8A04)	; 1
	.byte HIGH(PRG060_8A5B)	; 2


PRG060_PState_WilyTrans:
	LDA Spr_Frame+$00
	CMP #$04
	BNE PRG060_8AF4	; If Player's animation frame <> 4, jump to PRG060_8AF4 (RTS)

	; Fade out
	LDA #$00
	STA <DisFlag_NMIAndDisplay
	STA PalAnim_EnSel+$00
	STA PalAnim_EnSel+$01
	STA PalAnim_EnSel+$02
	STA PalAnim_EnSel+$03
	JSR PRG062_PalFadeOut

	; Clear sprites
	JSR PRG062_ClearSpriteSlots

	LDA <Level_SegCurData
	AND #$0F
	TAY	; Segment index -> 'Y'
	
	CPY #$09
	BNE PRG060_8A9E	; If not segment index 9 (the transporter room), jump to PRG060_8A9E (i.e. returning from boss room)

	; In transporter room...

	LDA <WilyTrans_CurPortal
	CMP #$08
	BNE PRG060_8A9E	; If not using portal #8 (the final post-robot master portal), jump to PRG060_8A9E

	; Portal #8 only...

	LDY #$0B	; Y = $0B
	
PRG060_8A9E:
	; Y = $5 if entering the "intro" portal just beyond the gate
	; Y = $9 if leaving teleporter room
	; Y = $A if returning to teleporter room
	; Y = $B if entered final teleporter

	LDA PRG060_Transporter_PlayerXDest,Y
	STA Spr_X+$00
	STA <RAM_0027	; $8AA4
	
	LDA PRG060_Transporter_PlayerYDest,Y
	STA Spr_Y+$00
	
	LDA PRG060_Transporter_TargetScr,Y
	CMP #$0A
	BNE PRG060_8ABC	; If target screen <> $A (a boss room), jump to PRG060_8ABC

	; Boss room entry...

	LDA <WilyTrans_CurPortal
	ADD #$0E
	TAY	; Y = $E + WilyTrans_CurPortal
	
	LDA PRG060_Transporter_TargetScr,Y
PRG060_8ABC:
	STA <MetaBlk_CurScreen
	STA <Current_Screen
	STA Spr_XHi+$00
	STA <RAM_0028	; $8AC3
	
	LDA PRG060_Transporter_TargetSeg,Y
	JSR PRG063_LoadGfxPalForTrans

	LDA <Current_Screen
	CMP #$09
	BNE PRG060_8AD4	; If not on screen 9, jump to PRG060_8AD4

	JSR PRG060_InstallWilyTransporter	; Install Wily's transporter, if it's time


PRG060_8AD4:
	LDA #PLAYERSTATE_READY
	STA <Player_State
	
	; Teleporting in...
	LDX #$00
	LDA #SPRANM2_TELEPORT
	JSR PRG063_SetSpriteAnim

	; Draw it
	JSR PRG063_DrawSprites_RsetSprIdx

	LDA #$00	; $8AE2
	STA <DisFlag_NMIAndDisplay	; $8AE4
	
	; Fade in
	JSR PRG062_PalFadeIn

	INC <DisFlag_NMIAndDisplay	; $8AE9
	
	; Restore Wily 2 music
	LDA #MUS_WILY2
	CMP <Mus_Cur
	BEQ PRG060_8AF4
	JSR PRG063_QueueMusSnd_SetMus_Cur


PRG060_8AF4:
	LDX #$00
	
	RTS	; $8AF6


PRG060_InstallWilyTransporter:
	LDY <WilyTrans_CurPortal	; Y = WilyTrans_CurPortal
	
	LDA PRG060_Transporter_ReturnX,Y
	STA Spr_X+$00
	STA <RAM_0027
	
	LDA PRG060_Transporter_ReturnY,Y
	STA Spr_Y+$00
	
	LDA <LevelWily3_TransSysComp
	CMP #$FF
	BNE PRG060_8AF4	; If not all transporter boss rooms are complete, jump to PRG060_8AF4

	LDY #(PRG060_WilyPortalGfxBuf_End - PRG060_WilyPortalGfxBuf - 1)
PRG060_8B0F:
	LDA PRG060_WilyPortalGfxBuf,Y
	STA Graphics_Buffer+$00,Y
	
	DEY	; Y--
	BPL PRG060_8B0F	; While Y >= 0, loop

	STY <CommitGBuf_Flag	; Commit graphics
	
	LDY #$17	; Y = $17
	
	; Setup Wily transporter object
	LDX #$00
	LDA #SPRANM2_TRANSPBLINKER
	JSR PRG063_CopySprSlotSetAnim

	; Bounding box $1C
	LDA #$1C
	STA Spr_Flags2+$00,Y
	
	LDA #SPRSLOTID_WILYTRANSPORTER
	STA Spr_SlotID+$00,Y
	
	LDA #$80
	STA Spr_X+$00,Y
	LDA #$44
	STA Spr_Y+$00,Y
	
	RTS	; $8B37


PRG060_PlayerWilyTransporterBG:
	LDA <TileMap_Index
	CMP #TMAP_WILY3
	BNE PRG060_8B8C	; If not Wily stage 3, jump to PRG060_8B8C

	; Wily stage 3 only...

	; Prevent Player from being in the background most of the time...
	LDA Spr_Flags+$00
	AND #~SPR_BEHINDBG
	STA Spr_Flags+$00
	
	; Figure out if Player is inside a Wily transporter...
	LDY #$00
PRG060_8B48:
	LDA Spr_XHi+$00
	CMP PRG060_WilyTptrXHiLimit,Y
	BLT PRG060_8B8C

	BNE PRG060_8B7D

	LDA Spr_X+$00
	SUB PRG060_WilyTptrXLimit,Y
	BCS PRG060_8B5F

	; Negate
	EOR #$FF
	ADC #$01

PRG060_8B5F:
	CMP #$18
	BGE PRG060_8B7D

	LDA Spr_Y+$00
	SUB PRG060_WilyTptrYLimit,Y
	BCS PRG060_8B70

	; Negate
	EOR #$FF
	ADC #$01

PRG060_8B70:
	CMP #$10
	BGE PRG060_8B7D

	; Player is behind a Wily transporter
	LDA Spr_Flags+$00
	ORA #SPR_BEHINDBG
	STA Spr_Flags+$00
	
	RTS	; $8B7C


PRG060_8B7D:
	INY	; Y++
	CPY #$0B
	BEQ PRG060_8B8C	; If Y = $0B, jump to PRG060_8B8C

	CPY #$0A
	BNE PRG060_8B48	; If Y <> $0A, jump to PRG060_8B48

	LDA <LevelWily3_TransSysComp
	CMP #$FF
	BEQ PRG060_8B48	; If all robot master transporters are complete, jump to PRG060_8B48


PRG060_8B8C:
	RTS	; $8B8C


	; Target screen for transporter destination
PRG060_Transporter_TargetScr:
	.byte $00	; $00 UNUSED
	.byte $00	; $01 UNUSED
	.byte $00	; $02 UNUSED
	.byte $00	; $03 UNUSED
	.byte $00	; $04 UNUSED
	.byte $06	; $05 Initial entryway (just beyond gate)
	.byte $00	; $06 UNUSED
	.byte $00	; $07 UNUSED
	.byte $00	; $08 UNUSED
	.byte $0A	; $09 Entering boss room
	.byte $09	; $0A Leaving boss room
	
	; ???
	.byte $0B	; $0B
	.byte $09	; $0C
	.byte $09	; $0D
	
	; Boss destinations
	.byte $0E	; $0E
	.byte $0A	; $0F
	.byte $0A	; $10
	.byte $0D	; $11
	.byte $0A	; $12
	.byte $0A	; $13
	.byte $0A	; $14
	.byte $0A	; $15


	; Target segment for transporter destination
PRG060_Transporter_TargetSeg:
	.byte $00	; $00 UNUSED
	.byte $00	; $01 UNUSED
	.byte $00	; $02 UNUSED
	.byte $00	; $03 UNUSED
	.byte $00	; $04 UNUSED
	.byte $07	; $05 Initial entryway (just beyond gate)
	.byte $00	; $06 UNUSED
	.byte $00	; $07 UNUSED
	.byte $00	; $08 UNUSED
	.byte $0A	; $09 Entering boss room
	.byte $09	; $0A Leaving boss room
	
	; ???
	.byte $0B	; $0B
	.byte $09	; $0C
	.byte $09	; $0D

	; Boss destinations
	.byte $0D	; $0E
	.byte $0A	; $0F
	.byte $0A	; $10
	.byte $0C	; $11
	.byte $0A	; $12
	.byte $0A	; $13
	.byte $0A	; $14
	.byte $0A	; $15


PRG060_Transporter_PlayerXDest:
	.byte $00	; $00 UNUSED
	.byte $00	; $01 UNUSED
	.byte $00	; $02 UNUSED
	.byte $00	; $03 UNUSED
	.byte $00	; $04 UNUSED
	.byte $40	; $05 Initial entryway (just beyond gate)
	.byte $00	; $06 UNUSED
	.byte $00	; $07 UNUSED
	.byte $00	; $08 UNUSED
	.byte $20	; $09 Entering boss room
	.byte $80	; $0A Leaving boss room
	
	; ??
	.byte $18	; $0B
	.byte $80	; $0C
	.byte $80	; $0D


PRG060_Transporter_PlayerYDest:
	.byte $00	; $00 UNUSED
	.byte $00	; $01 UNUSED
	.byte $00	; $02 UNUSED
	.byte $00	; $03 UNUSED
	.byte $00	; $04 UNUSED
	.byte $40	; $05 Initial entryway (just beyond gate)
	.byte $00	; $06 UNUSED
	.byte $00	; $07 UNUSED
	.byte $00	; $08 UNUSED
	.byte $B0	; $09 Entering boss room
	.byte $80	; $0A Leaving boss room

	; ??
	.byte $B0	; $0B
	.byte $80	; $0C
	.byte $80	; $0D


	; Player X position when returning from transporter boss room
PRG060_Transporter_ReturnX:
	.byte $20, $20, $20, $70, $90, $E0, $E0, $E0

	; Player Y position when returning from transporter boss room
PRG060_Transporter_ReturnY:
	.byte $40, $80, $C0, $C0, $C0, $40, $80, $C0

	; Wily's transporter portal graphics
PRG060_WilyPortalGfxBuf:
	vaddr $208E
	.byte $03
	
	.byte $38, $39, $3A, $3B
	
	vaddr $20AE
	.byte $03
	
	.byte $58, $59, $5A, $5B
	
	vaddr $20CE
	.byte $03
	
	.byte $24, $25, $26, $27
	
	vaddr $20EE
	.byte $03
	.byte $34, $35, $00, $19
	
	vaddr $210E
	.byte $03
	
	.byte $34, $35, $00, $19
	
	vaddr $212E
	.byte $03
	
	.byte $34, $35, $00, $19
	
	vaddr $214E
	.byte $03
	
	.byte $44, $45, $46, $47
	
	vaddr $216E
	.byte $03
	
	.byte $54, $55, $56, $57
	
	vaddr $23CB
	.byte $01, $99, $66
	
	vaddr $23D3
	.byte $01
	
	.byte $99, $66
	
	.byte $FF
PRG060_WilyPortalGfxBuf_End

PRG060_WilyTptrXHiLimit:	.byte $05, $06, $09, $09, $09, $09, $09, $09, $09, $09, $09
PRG060_WilyTptrXLimit:		.byte $50, $40, $20, $20, $20, $70, $90, $E0, $E0, $E0, $80
PRG060_WilyTptrYLimit:		.byte $30, $40, $40, $80, $C0, $C0, $C0, $40, $80, $C0, $40


PRG060_PState_CsakBossWalk:
	LDA #SPRANM2_PLAYERWALK
	CMP Spr_CurrentAnim+$00
	BEQ PRG060_8C53	; If Player is in walk animation, jump to PRG060_8C53

	; Set Player to walk
	JSR PRG063_SetSpriteAnim


PRG060_8C53:
	JSR PRG063_ApplyXVelocity

	LDA #$40
	CMP Spr_X+$00,X
	BGE PRG060_8C64	; If Player is not in position, jump to PRG060_8C64 (RTS)

	; Lock at $40
	STA Spr_X+$00,X
	
	; Player stand!
	LDA #PLAYERSTATE_STAND
	STA <Player_State

PRG060_8C64:
	RTS	; $8C64

PRG060_PState_PostWilyLeft:
	; Hold Player animation
	LDY #$00
	STY <Player_CurShootAnim
	STY <Player_ShootAnimTimer
	JSR PRG063_DoObjVertMovement

	BCS PRG060_8C7A	; If hit solid, jump to PRG060_8C7A

	; Falling to ground
	LDA #SPRANM2_PLAYERJUMPFALL
	CMP Spr_CurrentAnim+$00
	BEQ PRG060_8C64		; If Player already in falling animation, jump to PRG060_8C64 (RTS)
	
	; Set falling animation
	JMP PRG063_SetSpriteAnim


PRG060_8C7A:
	LDA #$3C
	CMP Spr_X+$00
	BEQ PRG060_8CAD	; If Player is @ $3C, jump to PRG060_8CAD

	LDA #SPRANM2_PLAYERWALK
	CMP Spr_CurrentAnim+$00
	BEQ PRG060_8C8B	; If Player is walking, jump to PRG060_8C8B

	; Set Player to walking animation
	JSR PRG063_SetSpriteAnim


PRG060_8C8B:
	JSR PRG063_ApplyVelSetFaceDir

	LDA Spr_FaceDir+$00
	AND #SPRDIR_RIGHT
	BEQ PRG060_8CA3	; If Player is facing left, jump to PRG060_8CA3
	
	; Player facing right

	LDA #$3C
	CMP Spr_X+$00,X
	BEQ PRG060_8CAD		; If Player is @ $3C, jump to PRG060_8CAD
	
	BGE PRG060_8CBC		; If Player is not in position, jump to PRG060_8CAD (RTS)
	
	; Lock Player @ $3C
	STA Spr_X+$00
	BLT PRG060_8CAD		; Jump (technically always) to PRG060_8CAD


PRG060_8CA3:
	LDA #$3C
	CMP Spr_X+$00,X
	BLT PRG060_8CBC		; If Player is not in position, jump to PRG060_8CAD (RTS)

	; Lock Player @ $3C
	STA Spr_X+$00

PRG060_8CAD:
	LDA #SPRANM2_PLAYERSTAND
	CMP Spr_CurrentAnim+$00	
	BEQ PRG060_8CB7	; If Player is standing, jump to PRG060_8CB7

	; Set to standing
	JSR PRG063_SetSpriteAnim


PRG060_8CB7:
	LDA #(SPRFL1_ONSCREEN | SPRFL1_SCREENREL | SPR_HFLIP)
	STA Spr_Flags+$00

PRG060_8CBC:
	RTS	; $8CBC


PRG060_PlayerDoWeapon:
	LDY <Player_CurWeapon	; Y = current selected weapon
	
	LDA PRG060_WeaponJumpTable_L,Y
	STA <Temp_Var0
	LDA PRG060_WeaponJumpTable_H,Y
	STA <Temp_Var1
	
	JMP [Temp_Var0]


PRG060_DoWpnMegaBuster:

	; Temp_Var17 = SPRANM2_PLAYERSHOT
	LDA #SPRANM2_PLAYERSHOT
	STA <Temp_Var17
	
	; Temp_Var18 = SFX_PLAYERSHOT
	LDA #SFX_PLAYERSHOT
	STA <Temp_Var18
	
	LDA <Player_MBusterChargeLevel
	BEQ PRG060_8D2F	; If Player_MBusterChargeLevel = 0 (no Mega Buster charge), jump to PRG060_8D2F

	LDA <Player_CurWeapon
	BNE PRG060_8D2F	; If this is not actually the Mega Buster (other weapons chain this), jump to PRG060_8D2F

	LDA <Ctlr1_Held
	AND #PAD_B
	BNE PRG060_8D59	; If Player is holding B (maintaining charge), jump to PRG060_8D59


	; Mega Buster charge release....

	; Temp_Var17 = SPRANM2_MBUSTSHOTLOW
	LDA #SPRANM2_MBUSTSHOTLOW
	STA <Temp_Var17
	
	; Palette effect for the discharge
	LDA #$07
	STA <Player_MBustDischargePalIdx
	
	LDA <Player_MBusterChargeLevel
	PHA	; Save Player_MBusterChargeLevel
	
	; Player_MBusterChargeLevel = 0
	LDA #$00
	STA <Player_MBusterChargeLevel
	
	PLA	; Restore charge level
	CMP #$20
	BLT PRG060_8D59	; If charge level < $20, jump to PRG060_8D59

	; Higher level charge

	INC <Player_MBustDischargePalIdx	; Slightly higher discharge effect
	
	CMP #$40
	BLT PRG060_8D0C	; If charge level < $40, jump to PRG060_8D0C
	
	; Even higher level charge

	INC <Player_MBustDischargePalIdx	; Even higher discharge effect
	
	CMP #$5C
	BLT PRG060_8D0C	; If charge level < $5C, jump to PRG060_8D0C

	; Highest level charge

	; Player_MBustDischargePalIdx = 0
	LDA #$00
	STA <Player_MBustDischargePalIdx
	
	; Temp_Var17 = SPRANM2_MBUSTSHOTBURST
	DEC <Temp_Var17
	
	; Temp_Var18 = SFX_PLAYERMBUSTSHOT
	LDA #SFX_PLAYERMBUSTSHOT
	STA <Temp_Var18

PRG060_8D0C:
	LDA <Player_MBustDischargePalIdx
	ASL A
	ASL A
	TAY	; Y = Player_MBustDischargePalIdx * 4
	
	; Copy palette in for discharge
	LDX #$00	; X = 0
PRG060_8D13:
	LDA PRG060_PlayerMBDischargePal+1,Y
	STA PalData_1+17,X
	STA PalData_2+17,X
	INX
	CPX #$03
	BNE PRG060_8D13

	LDX #$00	; X = 0
	
	INC <Player_MBustDischargePalIdx	; Player_MBustDischargePalIdx++
	
	LDA #$07
	CMP <Player_MBustDischargePalIdx	
	BGE PRG060_8D35	; If Player_MBustDischargePalIdx < 7, jump to PRG060_8D35

	STA <Player_MBustDischargePalIdx	; Player_MBustDischargePalIdx = 7 (cap)
	
	BLT PRG060_8D35	; Jump (technically always) to PRG060_8D35


PRG060_8D2F:
	; No Mega Buster charge...

	LDA <Ctlr1_Pressed
	AND #PAD_B
	BEQ PRG060_8D5B	; If Player is not pressing B, jump to PRG060_8D5B (RTS)


PRG060_8D35:
	; Something is being fired off...

	LDY #$00	; Y = 0
	STY <Temp_Var0	; Temp_Var0 = 0 (returned slot to put the shot into, but zero means no slot available)
	
	INY	; Y = 1
	STY <Player_MBusterChargeLevel	; Player_MBusterChargeLevel = 1
	
	LDY #$03	; Y = 3 (checking slots valid for firing shot)
PRG060_8D3E:
	LDA Spr_SlotID+$00,Y
	BEQ PRG060_8D50	; If sprite slot is empty, jump to PRG060_8D50

	; Not empty...

	LDA Spr_CurrentAnim+$00,Y
	
	CMP #SPRANM2_MBUSTSHOTBURST
	BEQ PRG060_8D59	; If this is already a Mega Buster low charge shot, jump to PRG060_8D59

	CMP #SPRANM2_MBUSTSHOTFULL
	BEQ PRG060_8D59	; If this is already a Mega Buster full charge shot, jump to PRG060_8D59

	BNE PRG060_8D52	; Otherwise, jump to PRG060_8D52


PRG060_8D50:
	STY <Temp_Var0	; Index -> Temp_Var0 (preferred empty slot index)

PRG060_8D52:
	DEY	; Y--
	BNE PRG060_8D3E	; While Y > 0, loop

	LDY <Temp_Var0
	BNE PRG060_8D5C	; If a valid shot slot index was returned, jump to PRG060_8D5C


PRG060_8D59:
	LDA #$00	; No shot

PRG060_8D5B:
	RTS	; $8D5B


PRG060_8D5C:
	; Shot prep continued...

	LDA <Player_State
	CMP #PLAYERSTATE_CLIMBING
	BNE PRG060_8D74	; If Player is not climbing, jump to PRG060_8D74

	LDA <Player_CurWeapon
	BNE PRG060_8D74	; If this is not the Mega Buster, jump to PRG060_8D74

	; Mega Buster, climbing

	LDA <Ctlr1_Held
	AND #(PAD_LEFT | PAD_RIGHT)
	BEQ PRG060_8D74	; If Player is not pressing LEFT/RIGHT, jump to PRG060_8D74
	
	; Player pushing LEFT/RIGHT

	STA Spr_FaceDir+$00
	STA <Player_FaceDir
	JSR PRG063_SetObjFlipForFaceDir	; Set flip for facing direction


PRG060_8D74:
	; Player_ShootAnimTimer = $10
	LDA #$10
	STA <Player_ShootAnimTimer
	
	LDA <Player_CurShootAnim
	BNE PRG060_8D83	; If already doing shoot animation, jump to PRG060_8D83

	; Player_CurShootAnim = PLAYERCSA_SHOOT
	LDA #PLAYERCSA_SHOOT
	STA <Player_CurShootAnim
	
	; Shooting animations are always the "next" one from current
	INC Spr_CurrentAnim+$00

PRG060_8D83:
	; Set projectile going left
	LDA #SPRDIR_LEFT
	STA Spr_FaceDir+$00,Y
	
	LDA Spr_Flags+$00
	AND #SPR_HFLIP
	BEQ PRG060_8D94	; If not horizontally flipped, jump to PRG060_8D94

	; Set projectile going right
	LDA #SPRDIR_RIGHT
	STA Spr_FaceDir+$00,Y

PRG060_8D94:
	LDA Spr_FaceDir+$00,Y
	AND #SPRDIR_RIGHT
	STA <Temp_Var16	; Left/right facing -> Temp_Var16
	
	LDA <Temp_Var17	; Shot type (technically sprite animation value)
	JSR PRG063_InitProjectile

	LDA <Player_CurWeapon
	CMP #PLAYERWPN_RUSHMARINE
	BNE PRG060_8DAF	; If this is not Rush Marine, jump to PRG060_8DAF

	; Offset shot down by 8 for Rush Marine
	LDA Spr_Y,Y
	ADD #$08
	STA Spr_Y,Y


PRG060_8DAF:
	; Play sound effect
	LDA <Temp_Var18
	JSR PRG063_QueueMusSnd

	; Shot horizontal speed
	LDA #$33
	STA Spr_XVelFrac+$00,Y
	LDA #$04
	STA Spr_XVel+$00,Y
	
	; Set slot ID
	LDA #SPRSLOTID_PLAYERSHOT
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_Flags2+$00,Y
	
	LDA Spr_CurrentAnim+$00,Y
	CMP #SPRANM2_MBUSTSHOTBURST
	BNE PRG060_8DD4	; If didn't just fire a full charge Mega Buster, jump to PRG060_8DD4 (RTS)

	; Different bounding box
	LDA #$01
	STA Spr_Flags2+$00,Y

PRG060_8DD4:
	RTS	; $8DD4

PRG060_DoWpnRush:
	LDY <Player_CurWeapon
	
	LDA Player_HP,Y
	AND #$7F
	BEQ PRG060_8DD4	; If there's no energy left for Rush, jump to PRG060_8DD4 (RTS)

	LDA Spr_SlotID+$04
	BEQ PRG060_8DE6	; If Rush's slot is empty, jump to PRG060_8DE6


PRG060_8DE3:
	JMP PRG060_DoWpnMegaBuster	; Chain regular shooting code


PRG060_8DE6:
	; Drop down Rush...

	; Set HFlip by Player
	LDA #SPRDIR_LEFT
	STA Spr_FaceDir+$00

	LDA Spr_Flags+$00
	AND #SPR_HFLIP
	BEQ PRG060_8DF7

	LDA #SPRDIR_RIGHT
	STA Spr_FaceDir+$00

PRG060_8DF7:

	LDA <Ctlr1_Pressed
	AND #PAD_B
	BEQ PRG060_8DE3	; If B was not pressed (player holding it from before), jump to PRG060_8DE3

	LDA <Ctlr1_Held
	AND #(PAD_LEFT | PAD_RIGHT)
	BEQ PRG060_8E0B	; If not pressing LEFT/RIGHT, jump to PRG060_8E0B

	; Set for pressing LEFT/RIGHT
	STA Spr_FaceDir+$00
	STA <Player_FaceDir
	JSR PRG063_SetObjFlipForFaceDir


PRG060_8E0B:
	LDY #$04	; Y = 4 (Rush's slot)
	
	; Copy Player's facing direction to Rush
	LDA Spr_FaceDir+$00
	STA Spr_FaceDir+$04
	
	; Projectile offset index
	AND #$01
	ADD #$2B
	STA <Temp_Var16
	
	; Rush teleporting in
	LDA #SPRANM2_TELEPORT
	JSR PRG063_InitProjectile

	; Clear horizontal flip
	LDA Spr_Flags+$00,Y
	AND #~SPR_HFLIP
	STA Spr_Flags+$00,Y
	
	LDA #$00
	STA Spr_Y+$04
	STA Spr_YHi+$04
	STA Spr_YVelFrac+$04
	STA Spr_YVel+$04
	
	; Set Rush's slot ID
	LDA #SPRSLOTID_RUSH
	STA Spr_SlotID+$04

PRG060_8E3A:
	RTS	; $8E3A

PRG060_DoWpnToad:
	LDY <Player_CurWeapon
	LDA Player_HP,Y
	AND #$7F
	BEQ PRG060_8E3A	; If there's no energy left for Toad Rain, jump to PRG060_8E3A (RTS)

	LDA Weapon_ToadRainCounter
	BNE PRG060_8E3A	; If Toad Rain is already occurring, jump to PRG060_8E3A (RTS)

	LDA <Ctlr1_Pressed
	AND #PAD_B
	BEQ PRG060_8E3A	; If Player is not pressing B, jump to PRG060_8E3A (RTS)

	; NOTE: Duplicte check
	LDA Weapon_ToadRainCounter
	BNE PRG060_8E3A	; If Toad Rain is already occurring, jump to PRG060_8E3A (RTS)

	; NOTE: Toad Rain only allows one to be fired at a time, so it just assumes slot 1
	LDA Spr_SlotID+$01
	BNE PRG060_8E3A	; If sprite slot 1 is occupied, jump to PRG060_8E3A (RTS)

	; Sound effect
	LDA #SFX_PLAYERSHOT
	JSR PRG063_QueueMusSnd

	LDA <Ctlr1_Held
	AND #(PAD_LEFT | PAD_RIGHT)
	BEQ PRG060_8E6C	; If not pressing LEFT/RIGHT, jump to PRG060_8E6C

	; Set for pressing LEFT/RIGHT
	STA Spr_FaceDir+$00
	STA <Player_FaceDir
	JSR PRG063_SetObjFlipForFaceDir


PRG060_8E6C:

	LDY #$01	; Y = 1 (Toad Rain always uses slot 1)
	
	; Projectile offset index
	LDA #$02
	STA <Temp_Var16
	
	LDA #SPRANM2_TOADRAINCAN
	JSR PRG063_InitProjectile

	; Slot ID
	LDA #SPRSLOTID_TOADRAINCAN
	STA Spr_SlotID+$01
	
	; Toad Rain canister Y vel
	LDA #$00
	STA Spr_YVelFrac+$01
	LDA #$02
	STA Spr_YVel+$01
	
	LDA #$00
	STA Spr_Flags2+$01
	
	; Player_ShootAnimTimer = $10
	LDA #$10
	STA <Player_ShootAnimTimer
	
	; Set animation
	LDA #PLAYERCSA_THROW
	STA <Player_CurShootAnim
	ADD Spr_CurrentAnim+$00
	JSR PRG063_SetSpriteAnim

	JMP PRG063_WeaponConsumeEnergy	; Consume energy
	

PRG060_DoWpnWire:
	LDY <Player_CurWeapon
	LDA Player_HP,Y
	AND #$7F
	BEQ PRG060_8F16	; If there's no energy left for Wire Adapter, jump to PRG060_8F16 (RTS)

	LDA Spr_SlotID+$04
	BNE PRG060_8F16	; If slot 4 is occupied, jump to PRG060_8F16 (RTS)

	LDA <Ctlr1_Pressed
	AND #PAD_B
	BEQ PRG060_8F16	; If Player is not pressing B, jump to PRG060_8F16 (RTS)

	LDA <Ctlr1_Held
	AND #PAD_UP
	BEQ PRG060_8F16	; If Player is not holding UP, jump to PRG060_8F16 (RTS)

	LDA #SPRANM2_PLAYERSTAND
	CMP Spr_CurrentAnim+$00
	BNE PRG060_8F16	; If Player is not standing still, jump to PRG060_8F16 (RTS)

	LDA <Ctlr1_Held
	AND #(PAD_LEFT | PAD_RIGHT)
	BEQ PRG060_8ECC	; If not pressing LEFT/RIGHT, jump to PRG060_8ECC

	; Set for pressing LEFT/RIGHT
	STA Spr_FaceDir+$00
	STA <Player_FaceDir
	JSR PRG063_SetObjFlipForFaceDir

PRG060_8ECC:
	LDA #SPRANM2_PLAYERWIREFIRE
	JSR PRG063_SetSpriteAnim

	; Player_State = PLAYERSTATE_WIREADAPTER
	LDA #PLAYERSTATE_WIREADAPTER
	STA <Player_State
	
	; Projectile offset index
	; Temp_Var16 = $3F
	LDA #$3F
	STA <Temp_Var16
	
	LDA Spr_Flags+$00
	AND #SPR_HFLIP
	BEQ PRG060_8EE2

	STA <Temp_Var16	; Temp_Var16 = $40

PRG060_8EE2:
	
	LDY #$04	; Y = 4 (Wire Adapter uses slot 4)
	
	; Wire Adapter extending
	LDA #SPRANM2_WIREADAPTERUP
	JSR PRG063_InitProjectile

	; Clear HFlip bit
	LDA Spr_Flags+$04
	AND #~SPR_HFLIP
	STA Spr_Flags+$04

	LDA #SPRSLOTID_WIREADAPTER	
	STA Spr_SlotID+$04
	
	; Wire Adapter Y vel
	LDA #$00
	STA Spr_YVelFrac+$04
	LDA #$04
	STA Spr_YVel+$04
	
	LDA #SPRDIR_UP
	STA Spr_FaceDir+$04
	
	; Spr_Var1+$04 = Player Y + 2
	LDA Spr_Y+$04
	ADD #$02
	STA Spr_Var1+$04
	
	LDA #$00
	STA Spr_Flags2+$04
	
	JSR PRG063_WeaponConsumeEnergy


PRG060_8F16:
	RTS	; $8F16


PRG060_DoWpnBalloon:
	LDY <Player_CurWeapon
	LDA Player_HP,Y
	AND #$7F
	BEQ PRG060_8F16	; If there's no energy left for Balloon, jump to PRG060_8F16 (RTS)

	LDA <Ctlr1_Pressed
	AND #PAD_B
	BEQ PRG060_8F97	; If Player is not pressing B, jump to PRG060_8F97 (RTS)

	LDA <Player_ShootAnimTimer
	BNE PRG060_8F97	; If Player hasn't stopped firing from before, jump to PRG060_8F97 (RTS)

	; Seek empty slot from 1-3
	LDY #$03
PRG060_8F2C:
	LDA Spr_SlotID+$00,Y
	BEQ PRG060_8F35
	
	DEY
	BNE PRG060_8F2C

	RTS


PRG060_8F35:
	; Found slot for Balloon...

	; Sound effect
	LDA #SFX_PLAYERSHOT
	JSR PRG063_QueueMusSnd

	LDA <Ctlr1_Held
	AND #(PAD_LEFT | PAD_RIGHT)
	BEQ PRG060_8F48	; If not pressing LEFT/RIGHT, jump to PRG060_8ECC

	; Set for pressing LEFT/RIGHT
	STA Spr_FaceDir+$00
	STA <Player_FaceDir
	JSR PRG063_SetObjFlipForFaceDir

PRG060_8F48:

	; Projectile offset index
	LDA #$2B
	STA <Temp_Var16

	LDA Spr_Flags+$00
	AND #SPR_HFLIP
	BEQ PRG060_8F55

	INC <Temp_Var16	; Temp_Var16 = $2C

PRG060_8F55:
	
	LDA #SPRANM2_BALLOON_POPUP
	JSR PRG063_InitProjectile

	LDA Spr_Flags+$00,Y
	ORA #$01
	STA Spr_Flags+$00,Y
	
	LDA #$0D
	STA Spr_Flags2+$00,Y
	
	LDA #SPRSLOTID_BALLOON
	STA Spr_SlotID+$00,Y
	
	; Balloon Y velocity
	LDA #$33
	STA Spr_YVelFrac+$00,Y
	LDA #$00
	STA Spr_YVel+$00,Y
	
	LDA #SPRDIR_UP
	STA Spr_FaceDir+$00,Y
	
	; Balloon's timer
	LDA #$C8
	STA Spr_Var1+$00,Y
	
	; Balloon's "got squashed" counter
	LDA #$00
	STA Spr_Var2+$00,Y

	; Player_ShootAnimTimer = $10
	LDA #$10
	STA <Player_ShootAnimTimer

	; Throw animation
	LDA #PLAYERCSA_THROW
	STA <Player_CurShootAnim
	
	ADD Spr_CurrentAnim+$00
	JSR PRG063_SetSpriteAnim

	JSR PRG063_WeaponConsumeEnergy


PRG060_8F97:
	RTS	; $8F97

PRG060_DoWpnDiveRingDrillDust:
	LDY <Player_CurWeapon

	LDA Player_HP,Y
	AND #$7F
	BEQ PRG060_8F97	; If there's no energy left for Dive/Ring/Drill/Dust, jump to PRG060_8F97 (RTS)

	LDA Spr_SlotID+$01
	BNE PRG060_8F97	; If object sprite slot 1 is occupied, jump to PRG060_8F97 (RTS)

	LDA <Ctlr1_Pressed
	AND #PAD_B
	BEQ PRG060_8F97	; If Player is not pressing B, jump to PRG060_8F97 (RTS)

	LDA <Player_CurShootAnim
	BNE PRG060_8F97	; If Player is still doing shooting animation, jump to PRG060_8F97 (RTS)

	LDA <Ctlr1_Held
	AND #(PAD_LEFT | PAD_RIGHT)
	BEQ PRG060_8FBE	; If not pressing LEFT/RIGHT, jump to PRG060_8FBE

	; Set for pressing LEFT/RIGHT
	STA Spr_FaceDir+$00
	STA <Player_FaceDir
	JSR PRG063_SetObjFlipForFaceDir

PRG060_8FBE:
	; Set HFlip by Player
	LDA #SPRDIR_LEFT
	STA Spr_FaceDir+$01

	LDA Spr_Flags+$00
	AND #SPR_HFLIP
	BEQ PRG060_8FCF

	LDA #SPRDIR_RIGHT
	STA Spr_FaceDir+$01

PRG060_8FCF:

	LDA Spr_FaceDir+$01
	AND #SPRDIR_RIGHT
	STA <Temp_Var16	; Temp_Var16 = 1 if facing right, 0 if not
	
	LDY <Player_CurWeapon

	LDA PRG060_DRDDAnimTable-PLAYERWPN_DIVEMISSILE,Y

	; Projectile offset index
	LDY #$01
	JSR PRG063_InitProjectile

	LDY <Player_CurWeapon
	STY Spr_SlotID+$01	; Coincidentally matches the slot ID
	
	; X velocity of weapon
	LDA PRG060_DRDDXVelFrac-PLAYERWPN_DIVEMISSILE,Y
	STA Spr_XVelFrac+$01
	LDA PRG060_DRDDXVel-PLAYERWPN_DIVEMISSILE,Y
	STA Spr_XVel+$01
	
	LDA PRG060_DRDDVar1-PLAYERWPN_DIVEMISSILE,Y
	STA Spr_Var1+$01
	
	; NOTE: This value gets overwritten below
	LDA PRG060_DRDDFlags2-PLAYERWPN_DIVEMISSILE,Y
	STA Spr_Flags2+$01
	
	; Sound effect
	LDA PRG060_DRDDSFX-PLAYERWPN_DIVEMISSILE,Y
	JSR PRG063_QueueMusSnd

	; Consume weapon energy
	JSR PRG063_WeaponConsumeEnergy

	LDA Spr_FaceDir+$01
	ASL A
	ASL A
	ORA #$04
	STA Spr_Var2+$01
	
	LDA #$58
	STA Spr_Var3+$01
	LDA #$02
	STA Spr_Var4+$01
	
	; Y velocity
	LDA #$00
	STA Spr_YVelFrac+$01
	STA Spr_YVel+$01
	
	; NOTE: Overwrites the setting from before
	LDA #$00
	STA Spr_Flags2+$01
	
	; Player_ShootAnimTimer = $10
	LDA #$10
	STA <Player_ShootAnimTimer
	
	; Shoot animation
	LDA #PLAYERCSA_SHOOT
	STA <Player_CurShootAnim
	ADD Spr_CurrentAnim+$00
	JSR PRG063_SetSpriteAnim

	LDA <Player_CurWeapon
	CMP #PLAYERWPN_RINGBOOMERANG
	BNE PRG060_9044	; If this isn't Ring Boomerang, jump to PRG060_9044

	; Ring Boomerang only...
	LDA Spr_Flags+$01
	ORA #$08
	STA Spr_Flags+$01

PRG060_9044:
	RTS	; $9044

PRG060_DoWpnPharaoh:
	LDY <Player_CurWeapon
	
	LDA Player_HP,Y
	AND #$7F
	BEQ PRG060_9044	; If there's no energy left for Pharaoh Shot, jump to PRG060_9044 (RTS)

	LDA <Ctlr1_Pressed
	AND #PAD_B
	BNE PRG060_90AF	; If Player pressed B, jump to PRG060_90AF

	LDA <Ctlr1_Held
	AND #PAD_B
	BEQ PRG060_9092	; If Player released B, jump to PRG060_9092

	LDY Spr_Var5+$00	; Y = held Pharaoh Shot slot
	BNE PRG060_9086		; If non-zero, jump to PRG060_9086

	LDY #$03	; Otherwise, force to 3

PRG060_9061:
	LDA Spr_SlotID+$00,Y
	BEQ PRG060_906A	; If the held Pharaoh Shot is gone, jump to PRG060_906A

	DEY	; Y--
	BNE PRG060_9061	; While Y <> 0, loop

	RTS


PRG060_906A:
	STY Spr_Var5+$00	; Update the held Pharaoh Shot slot
	
	; For the overhead charging Pharaoh Shot...
	
	; Projectile offset index
	LDA #$41
	STA <Temp_Var16
	
	LDA #SPRANM2_PHARAOHOVERHEAD
	JSR PRG063_InitProjectile

	LDA #SPRSLOTID_PHARAOHOVERH
	STA Spr_SlotID+$00,Y
	
	LDA #$05
	STA Spr_Flags2+$00,Y
	
	LDA #$00
	STA Spr_Var1+$00,Y
	
	RTS	; $9085


PRG060_9086:
	LDA Spr_Frame+$00,Y
	CMP #$0E
	BNE PRG060_9044	; If the overhead Pharaoh Shot hasn't reached frame $0E, jump to PRG060_9044 (RTS)

	; Max charge, holding animation
	LDA #SPRANM2_PHARAOHCHSHOT
	JMP PRG063_SetSpriteAnimY


PRG060_9092:
	; Release Pharaoh Shot

	LDY Spr_Var5+$00
	BEQ PRG060_9044	; If Pharaoh Shot hold slot is empty, jump to PRG060_9044 (RTS)

	; Delete the overhead shot
	JSR PRG063_DeleteObjectY

	LDA #SPRANM2_PHARAOHCHSHOT
	STA <Temp_Var17	; -> Temp_Var17
	CMP Spr_CurrentAnim+$00,Y
	BEQ PRG060_90AC	; If this is the fully charged Pharaoh Shot, jump to PRG060_90AC

	; Overhead wasn't fully charged...

	LDA Spr_Frame+$00,Y
	CMP #$0B
	BLT PRG060_9044	; If frame < $0B, jump to PRG060_9044 (RTS)

	DEC <Temp_Var17	; Temp_Var17 = SPRANM2_PHARAOHCHLSHOT

PRG060_90AC:
	JMP PRG060_90C2	; Jump t oPRG060_90C2


PRG060_90AF:
	LDA <Player_CurShootAnim
	BNE PRG060_9044	; If Player is still shooting, jump to PRG060_9044 (RTS)

	LDA #SPRANM2_PHARAOHSHOT
	STA <Temp_Var17
	
	; Find empty shot slot for Pharaoh Shot; if found, jump to PRG060_90C2
	LDY #$03
PRG060_90B9:
	LDA Spr_SlotID+$00,Y
	BEQ PRG060_90C2		; If slot empty, jump to PRG060_90C2

	DEY
	BNE PRG060_90B9

	RTS


PRG060_90C2:
	
	; Clear the "charging Pharaoh Shot slot" var
	LDA #$00
	STA Spr_Var5+$00

	LDA <Ctlr1_Held
	AND #(PAD_LEFT | PAD_RIGHT)
	BEQ PRG060_90D5	; If not pressing LEFT/RIGHT, jump to PRG060_8FBE

	; Set for pressing LEFT/RIGHT
	STA Spr_FaceDir+$00
	STA <Player_FaceDir
	JSR PRG063_SetObjFlipForFaceDir

PRG060_90D5:
	
	; Player_ShootAnimTimer = $10
	LDA #$10
	STA <Player_ShootAnimTimer

	LDA <Player_CurShootAnim
	BNE PRG060_90E8	; If Player already shooting, jump to PRG060_90E8

	; Set throw animation
	LDA #PLAYERCSA_THROW
	STA <Player_CurShootAnim
	ADD Spr_CurrentAnim+$00
	JSR PRG063_SetSpriteAnim


PRG060_90E8:

	; Set HFlip by Player
	LDA #SPRDIR_LEFT
	STA Spr_FaceDir+$00,Y

	LDA Spr_Flags+$00
	AND #SPR_HFLIP
	BEQ PRG060_90F9

	LDA #SPRDIR_RIGHT
	STA Spr_FaceDir+$00,Y

PRG060_90F9:

	LDA Spr_FaceDir+$00,Y
	AND #SPRDIR_RIGHT
	STA <Temp_Var16	; Temp_Var16 = 1 if facing right, 0 if not

	; Set projectile animation
	LDA <Temp_Var17
	JSR PRG063_InitProjectile

	LDA #SPRSLOTID_PHARAOHSHOT
	STA Spr_SlotID+$00,Y
	
	; Effect up/down direction of Pharaoh Shot by UP/DOWN
	LDA <Ctlr1_Held
	AND #(PAD_UP | PAD_DOWN)
	ORA Spr_FaceDir+$00,Y
	STA Spr_FaceDir+$00,Y
	
	LSR A
	LSR A
	TAX	
	
	; Pharaoh Shot X velocity
	LDA PRG060_PharaohXVelFrac,X
	STA Spr_XVelFrac+$00,Y
	LDA PRG060_PharaohXVel,X
	STA Spr_XVel+$00,Y
	
	; Pharaoh Shot Y velocity
	LDA PRG060_PharaohYVelFrac,X
	STA Spr_YVelFrac+$00,Y
	LDA PRG060_PharaohYVel,X
	STA Spr_YVel+$00,Y
	
	LDA #$04
	STA Spr_Flags2+$00,Y
	
	; NOTE: Meaningless, unused assignment, but maybe was once intended as
	; an alternate branch for the sound effect choice or something.
	LDX #$00	; X = 0 (unused assignment)
	
	JSR PRG063_WeaponConsumeEnergy

	LDX #SFX_PHARAOHSHOT	; X = SFX_PHARAOHSHOT
	
	LDA Spr_CurrentAnim+$00,Y
	CMP #SPRANM2_PHARAOHCHSHOT
	BNE PRG060_9147	; If this isn't the charged Pharaoh Shot, jump to PRG060_9147

	; Consume double energy
	JSR PRG063_WeaponConsumeEnergy

	LDX #SFX_PHARAOHCHSHOT	; X = SFX_PHARAOHCHSHOT

PRG060_9147:
	; Play sound effect
	TXA	
	JSR PRG063_QueueMusSnd

	LDX #$00	; X = 0

PRG060_914D:
	RTS	; $914D

PRG060_DoWpnBright:
	LDA Weapon_FlashStopCnt+$00
	ORA Weapon_FlashStopCnt+$01
	BNE PRG060_917E	; If Flash Stopper is still active, jump to PRG060_917E

	LDY <Player_CurWeapon
	
	LDA Player_HP,Y
	AND #$7F
	BEQ PRG060_914D	; If there's no energy left for Pharaoh Shot, jump to PRG060_914D (RTS)

	LDA <Ctlr1_Pressed
	AND #PAD_B
	BEQ PRG060_91C1	; If Player hasn't pressed B, jump to PRG060_91C1

	JSR PRG063_WeaponConsumeEnergy

	LDA #SFX_FLASHSTOPPER
	JSR PRG063_QueueMusSnd

	; Set Flash Stopper timer
	LDA #$2C
	STA Weapon_FlashStopCnt+$00
	LDA #$01
	STA Weapon_FlashStopCnt+$01
	
	LDA #$12	; $9177
	STA Spr_Var6+$00	; $9179
	
	BNE PRG060_91A6	; Jump (technically always) to PRG060_91A6


PRG060_917E:
	; Flash Stopper still active...

	LDA <Ctlr1_Pressed
	AND #PAD_B
	BEQ PRG060_9195	; If Player hasn't pressed B, jump to PRG060_9195

	LDA <Ctlr1_Held
	AND #(PAD_LEFT | PAD_RIGHT)
	BEQ PRG060_9192	; If not pressing LEFT/RIGHT, jump to PRG060_8FBE

	; Set for pressing LEFT/RIGHT
	STA Spr_FaceDir+$00
	STA <Player_FaceDir
	JSR PRG063_SetObjFlipForFaceDir

PRG060_9192:

	; Chain standard shooting code
	JSR PRG060_DoWpnMegaBuster


PRG060_9195:
	; Decrease Flash Stopper counter
	LDA Weapon_FlashStopCnt+$00
	SUB #$01
	STA Weapon_FlashStopCnt+$00
	LDA Weapon_FlashStopCnt+$01
	SBC #$00
	STA Weapon_FlashStopCnt+$01

PRG060_91A6:
	LDA Spr_Var6+$00
	BEQ PRG060_91C1	; If Flash Stopper flashing isn't happening, jump to PRG060_91C1 (RTS)

	DEC Spr_Var6+$00	; Decrement Flash Stopper flash counter

	; Palette flash
	LSR A
	LSR A
	LDA PalData_2+16
	STA PalData_1+16
	BCC PRG060_91BD

	LDA #$30
	STA PalData_1+16

PRG060_91BD:

	; Commit palette
	LDA #$FF	; $91BD
	STA <CommitPal_Flag	; $91BF

PRG060_91C1:
	RTS	; $91C1

PRG060_DoWpnSkull:
	LDY <Player_CurWeapon	; $91C2
	
	LDA Player_HP,Y
	AND #$7F
	BEQ PRG060_91C1	; If there's no energy left for Pharaoh Shot, jump to PRG060_91C1 (RTS)

	LDA <Ctlr1_Pressed
	AND #PAD_B
	BEQ PRG060_91EA	; If Player hasn't pressed B, jump to PRG060_91EA (RTS)

	LDA Spr_SlotID+$01
	BNE PRG060_91EA	; If object sprite slot 1 is empty, jump to PRG060_91EA (RTS)

		
	; Copy to sprite slot 1
	LDY #$01
	LDA #SPRANM2_SKULLBARRIER
	JSR PRG063_CopySprSlotSetAnim

	; Skull barrier
	LDA #SPRSLOTID_SKULLBARRIER
	STA Spr_SlotID+$01
	
	LDA #$06
	STA Spr_Flags2+$01
	
	JSR PRG063_WeaponConsumeEnergy


PRG060_91EA:
	RTS	; $91EA


PRG060_WeaponJumpTable_L:
	.byte LOW(PRG060_DoWpnMegaBuster)	; 0 Mega Buster
	.byte LOW(PRG060_DoWpnRush)	; 1 Rush Coil
	.byte LOW(PRG060_DoWpnRush)	; 2 Rush Jet
	.byte LOW(PRG060_DoWpnRush)	; 3 Rush Marine
	.byte LOW(PRG060_DoWpnToad)	; 4 Toad Rain
	.byte LOW(PRG060_DoWpnWire)	; 5 Wire Adapter
	.byte LOW(PRG060_DoWpnBalloon)	; 6 Balloon
	.byte LOW(PRG060_DoWpnDiveRingDrillDust)	; 7 Dive Missile
	.byte LOW(PRG060_DoWpnDiveRingDrillDust)	; 8 Ring Boomerang
	.byte LOW(PRG060_DoWpnDiveRingDrillDust)	; 9 Drill Bomb
	.byte LOW(PRG060_DoWpnDiveRingDrillDust)	; 10 Dust Crusher
	.byte LOW(PRG060_DoWpnPharaoh)	; 11 Pharaoh Shot
	.byte LOW(PRG060_DoWpnBright)	; 12 Flash Stopper
	.byte LOW(PRG060_DoWpnSkull)	; 13 Skull Barrier
	
PRG060_WeaponJumpTable_H:
	.byte HIGH(PRG060_DoWpnMegaBuster)	; 0 Mega Buster
	.byte HIGH(PRG060_DoWpnRush)	; 1 Rush Coil
	.byte HIGH(PRG060_DoWpnRush)	; 2 Rush Jet
	.byte HIGH(PRG060_DoWpnRush)	; 3 Rush Marine
	.byte HIGH(PRG060_DoWpnToad)	; 4 Toad Rain
	.byte HIGH(PRG060_DoWpnWire)	; 5 Wire Adapter
	.byte HIGH(PRG060_DoWpnBalloon)	; 6 Balloon
	.byte HIGH(PRG060_DoWpnDiveRingDrillDust)	; 7 Dive Missile
	.byte HIGH(PRG060_DoWpnDiveRingDrillDust)	; 8 Ring Boomerang
	.byte HIGH(PRG060_DoWpnDiveRingDrillDust)	; 9 Drill Bomb
	.byte HIGH(PRG060_DoWpnDiveRingDrillDust)	; 10 Dust Crusher
	.byte HIGH(PRG060_DoWpnPharaoh)	; 11 Pharaoh Shot
	.byte HIGH(PRG060_DoWpnBright)	; 12 Flash Stopper
	.byte HIGH(PRG060_DoWpnSkull)	; 13 Skull Barrier


PRG060_DRDDAnimTable:
	.byte SPRANM2_DIVEMISSILE	; Dive Missile
	.byte SPRANM2_RINGBOOMERANG	; Ring Boomerang
	.byte SPRANM2_DRILLBOMB		; Drill Bomb
	.byte SPRANM2_DUSTCRUSHER	; Dust Crusher

PRG060_DRDDXVelFrac:
	.byte $00	; Dive Missile
	.byte $00	; Ring Boomerang
	.byte $00	; Drill Bomb
	.byte $00	; Dust Crusher
	
PRG060_DRDDXVel:
	.byte $04	; Dive Missile
	.byte $06	; Ring Boomerang
	.byte $04	; Drill Bomb
	.byte $04	; Dust Crusher
	
PRG060_DRDDVar1:
	.byte $02	; Dive Missile
	.byte $0B	; Ring Boomerang
	.byte $02	; Drill Bomb
	.byte $00	; Dust Crusher
	
PRG060_PharaohXVelFrac:
	.byte $00
	.byte $89

	; CHECKME - UNUSED?
	.byte $89


PRG060_PharaohXVel:
	.byte $05
	.byte $03
	.byte $03


PRG060_PharaohYVelFrac:
	.byte $00
	.byte $89
	.byte $89


PRG060_PharaohYVel:
	.byte $00
	.byte $03
	.byte $03

	; NOTE: This value gets overwritten after its set, so ... pointless?
PRG060_DRDDFlags2:
	.byte $04	; Dive Missile
	.byte $02	; Ring Boomerang
	.byte $02	; Drill Bomb
	.byte $02	; Dust Crusher
	
PRG060_DRDDSFX:
	.byte SFX_PLAYERSHOT	; Dive Missile
	.byte SFX_RINGBOOMERANG	; Ring Boomerang
	.byte SFX_DRILLBOMB		; Drill Bomb
	.byte SFX_PLAYERSHOT	; Dust Crusher



PRG060_CheckLadderStart:
	LDA <Ctlr1_Held
	AND #PAD_UP
	BEQ PRG060_926C	; If Player is not holding UP, jump to PRG060_926C (RTS)

	LDA Spr_Flags+$00
	BPL PRG060_926C	; If Player is not following screen (??), jump to PRG060_926C (RTS)

	; Scanning for ladder
	LDY #$02	; offset into PRG062_D808
	JSR PRG062_ObjDetWallAttrs

	LDA Spr_YHi+$00
	BNE PRG060_926C	; If Player is off-screen vertically, jump to PRG060_926C (RTS)

	LDA <Level_TileAttrsDetected+$00
	CMP #TILEATTR_LADDER
	BEQ PRG060_924C		; If ladder detected, jump to PRG060_924C

	LDA <Level_TileAttrsDetected+$01
	CMP #TILEATTR_LADDER
	BNE PRG060_926C		; If no ladder detected, jump to PRG060_926C (RTS)


PRG060_924C:
	
	; Start climbing
	LDA #PLAYERSTATE_CLIMBING
	STA <Player_State
	
	; Center Player on ladder
	LDA Spr_X+$00
	AND #$F0
	ORA #$08
	STA Spr_X+$00
	
	; Set Player velocity upward
	LDA #$4C
	STA Spr_YVelFrac+$00
	LDA #$01
	STA Spr_YVel+$00
	
	; Set climbing animation
	LDA #SPRANM2_PLAYERCLIMB
	ADD <Player_CurShootAnim
	JSR PRG063_SetSpriteAnim


PRG060_926C:
	RTS	; $926C


	; Player's Mega Buster charge palette cycle -- last two entries seem to be never used
PRG060_PlayerMBChrgPal1:	.byte $0F, $0F, $0F, $0F, $0F, $0F, $22, $22, $0F, $22, $0F, $22, $0F, $29, $0F, $29
PRG060_PlayerMBChrgPal2:	.byte $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $2C, $3A, $2C, $3A
PRG060_PlayerMBChrgPal3:	.byte $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $2A, $11, $2A

	
	; Mega Buster discharge palettes indexed by Player_MBustDischargePalIdx
PRG060_PlayerMBDischargePal:
	.byte $0F, $0F, $2C, $11	; 0
	.byte $0F, $0F, $2C, $11	; 1
	.byte $0F, $37, $35, $25	; 2
	.byte $0F, $0F, $2C, $11	; 3
	.byte $0F, $30, $30, $30	; 4
	.byte $0F, $0F, $30, $31	; 5
	.byte $0F, $0F, $30, $31	; 6
	.byte $0F, $0F, $2C, $11	; 7
	.byte $0F, $22, $2C, $11	; 8
	.byte $0F, $1A, $2C, $11	; 9


	; Modifies Player's X velocity when in Cossack 1's snow or Toad Man's water flow effects (including rain)
PRG060_DoSnowAndWaterFlow:
	PHP	; Save flags
	
	ROR <Temp_Var15	; $92C6
	
	LDA <Player_TMWaterPushFaceDir
	BEQ PRG060_92CF	; If Toad Man water pushing not enabled, jump to PRG060_92CF

	JMP PRG060_DoToadManWaterPush	; Do Toad Man water pushing


PRG060_92CF:
	LDA <TileMap_Index
	CMP #TMAP_COSSACK1
	BEQ PRG060_92E7	; If this is Cossack 1, jump to PRG060_92E7

	; Not Cossack 1...

	CMP #TMAP_TOADMAN
	BNE PRG060_933E	; If not Toad Man, jump to PRG060_933E

	; Toad Man...

	LDA <Current_Screen
	CMP #$08
	BGE PRG060_9314	; If Current_Screen >= 8, jump to PRG060_9314

	; Toad Man, early

	LDA <Temp_Var15	; $92DF
	BMI PRG060_933E	; $92E1

	; Do Toad Man water push in the rain
	LDA #$02
	BNE PRG060_SetDoToadManWaterPush


PRG060_92E7:
	; Cossack 1...

	LDA <Object_ReqBGSwitch	; $92E7
	BEQ PRG060_933E	; $92E9

	LDY #$10	; Y = $10 (index into PRG062_TDetFloorOffSpread)
	JSR PRG062_ObjDetFloorAttrs	; Detect floor tiles

	LDA <Temp_Var16
	CMP #TILEATTR_QUICKSAND_SNOW
	BNE PRG060_933E	; If not in snow, jump to PRG060_933E
	
	; Cossack 1, in the snow...

	LDA <Player_State
	CMP #PLAYERSTATE_SLIDING
	BEQ PRG060_9308		; If Player is sliding, jump to PRG060_9308

	; Override velocity for snow, walking
	LDA #$80
	STA Spr_XVelFrac+$00
	LDA #$00
	STA Spr_XVel+$00
	BEQ PRG060_933E		; Jump (technically always) to PRG060_933E


PRG060_9308:

	; Override velocity for snow, sliding
	LDA #$00
	STA Spr_XVelFrac
	LDA #$02
	STA Spr_XVel
	BNE PRG060_933E		; Jump (technically always) to PRG060_933E

PRG060_9314:
	LDY #$10	; Y = $10 (index into PRG062_TDetFloorOffSpread)
	JSR PRG062_ObjDetFloorAttrs	; Detect floor tiles

	; Temp_Var0 = 1
	LDA #$01
	STA <Temp_Var0
	
	LDA <Temp_Var16
	CMP #TILEATTR_TOADWATERPUSHR
	BEQ PRG060_9341	; If Toad Man water flow push right, jump to PRG060_9341

	INC <Temp_Var0	; Temp_Var0 = 2
	
	CMP #TILEATTR_TOADWATERPUSHL
	BEQ PRG060_9341	; If Toad Man water flow push left, jump to PRG060_9341

	CMP #TILEATTR_QUICKSAND_SNOW
	BNE PRG060_938D	; If NOT Toad Man water flow into left/right branch (doesn't push either way), jump to PRG060_938D

	; Toad Man's water flow that branches (so no push left/right)

	; Limits Player's jump
	LDA Spr_YVelFrac+$00
	SUB #$4C
	STA Spr_YVelFrac+$00
	LDA Spr_YVel+$00
	SBC #$00
	STA Spr_YVel+$00

PRG060_933E:
	JMP PRG060_938D	; Jump to PRG060_938D


PRG060_9341:
	LDA <Temp_Var0	; Temp_Var0 = 1 for water right, 2 for water left (fed into Player_TMWaterPushFaceDir)

	; Specify value for Player_TMWaterPushFaceDir, and do water push
PRG060_SetDoToadManWaterPush:
	STA <Player_TMWaterPushFaceDir
	LDA #$80
	STA <Player_TMWaterPushXVelFrac
	LDA #$00
	STA <Player_TMWaterPushXVel


	; Just do Toad Man level water pushing
PRG060_DoToadManWaterPush:

	; Backup Player's flags, X velocity, and facing direction
	LDA Spr_Flags+$00
	PHA
	LDA Spr_XVelFrac+$00
	PHA
	LDA Spr_XVel+$00
	PHA
	LDA Spr_FaceDir+$00
	PHA
	
	LDA <Player_TMWaterPushXVelFrac
	STA Spr_XVelFrac+$00
	LDA <Player_TMWaterPushXVel
	STA Spr_XVel+$00
	LDA <Player_TMWaterPushFaceDir
	STA Spr_FaceDir+$00
	
	LDY #$00
	
	LDA <Player_State
	CMP #PLAYERSTATE_SLIDING
	BNE PRG060_9376	; If Player is not sliding, jump to PRG060_9376

	LDY #$04

PRG060_9376:
	; Perform movement with the overridden velocity / facing direction
	JSR PRG063_DoObjMoveSetFaceDir

	; Restore Player's flags, X velocity, and facing direction
	PLA
	STA Spr_FaceDir+$00
	PLA
	STA Spr_XVel+$00
	PLA
	STA Spr_XVelFrac+$00
	PLA
	STA Spr_Flags+$00
	
	; Disable water push
	LDA #$00
	STA <Player_TMWaterPushFaceDir

PRG060_938D:
	
	PLP	; Restore flags
	
	RTS	; $938E


	; Player's idle (not pressing LEFT/RIGHT) sliding
PRG060_DoPlayerIdleOnIce:
	LDA <TileMap_Index
	CMP #TMAP_COSSACK1
	BNE PRG060_93D9	; If not Cossack 1, jump to PRG060_93D9 (set carry, exit)

	LDA <Player_OnIce
	CMP #TILEATTR_ICE
	BNE PRG060_93D9	; If Player not on ice, jump to PRG060_93D9 (set carry, exit)

	LDA <General_Counter
	AND #$03
	BNE PRG060_93C6	; 3:4 ticks, jump to PRG060_93C6 (PRG060_9458)

	; Apply slip factor
	LDA <Player_LandXVelFrac
	SUB <Player_SlipXVelFrac
	STA <Player_LandXVelFrac
	LDA <Player_LandXVel
	SBC <Player_SlipXVel
	STA <Player_LandXVel
	
	BCC PRG060_ClearLandingVars	; If underflowed, jump to PRG060_ClearLandingVars

	; Player_SlipXVelFrac / Player_SlipXVel -= 1
	LDA <Player_SlipXVelFrac
	SUB #$01
	STA <Player_SlipXVelFrac
	LDA <Player_SlipXVel
	SBC #$00
	STA <Player_SlipXVel
	
	ORA <Player_SlipXVelFrac
	BEQ PRG060_93C3	; If Player_SlipXVelFrac = 0 and Player_SlipXVel = 0, jump to PRG060_93C3

	BCS PRG060_93C6	; If didn't underflow, jump to PRG060_93C6 (PRG060_9458)

PRG060_93C3:
	JSR PRG060_ResetSlipFactor

PRG060_93C6:
	JMP PRG060_9458	; Jump to PRG060_9458


PRG060_ClearLandingVars:
	; Clear landing vars
	LDA #$00
	STA <Player_LandPressLR
	STA <Player_LandXVelFrac
	STA <Player_LandXVel

PRG060_ResetSlipFactor:
	; Reset slip factor
	LDA #$01
	STA <Player_SlipXVelFrac
	LDA #$00
	STA <Player_SlipXVel

PRG060_93D9:
	SEC	; Set carry
	RTS	; $93DA


	; Returns carry clear if Player is slipping on icy ground
PRG060_DoPlayerOnIce:
	LDA <TileMap_Index
	CMP #TMAP_COSSACK1
	BNE PRG060_ClearLandingVars	; If this is not Cossack 1 level, jump to PRG060_ClearLandingVars (set carry, exit)

	LDA <Player_OnIce
	CMP #TILEATTR_ICE
	BNE PRG060_ClearLandingVars	; If Player is not on ice, jump to PRG060_ClearLandingVars (set carry, exit)

	LDA <Player_LandPressLR
	BEQ PRG060_9419	; If Player didn't press LEFT/RIGHT when landing, jump to PRG060_9419

	CMP Spr_FaceDir+$00
	BEQ PRG060_9419	; If Player continuned in the same direction after landing, jump to PRG060_9419

	; Cossack 1, Player is on ice, Player hit direction opposite their facing direction

	; Slipping!
	LDA <Player_LandXVelFrac
	SUB <Player_SlipXVelFrac
	STA <Player_LandXVelFrac
	LDA <Player_LandXVel
	SBC <Player_SlipXVel
	STA <Player_LandXVel
	
	BCS PRG060_9404	; If didn't underflow, jump to PRG060_9404

	JSR PRG060_ClearLandingVars

	CLC	; Clear carry
	RTS	; $9403


PRG060_9404:
	; Player_SlipXVelFrac / Player_SlipXVel -= 1
	LDA <Player_SlipXVelFrac
	SUB #$01
	STA <Player_SlipXVelFrac
	LDA <Player_SlipXVel
	SBC #$00
	STA <Player_SlipXVel
	
	BCS PRG060_9458	; If didn't underflow, jump to PRG060_9458

	JSR PRG060_ResetSlipFactor
	JMP PRG060_9458

PRG060_9419:
	; Update Player_LandPressLR
	LDA Spr_FaceDir+$00
	STA <Player_LandPressLR
	
	LDA <General_Counter
	AND #$01
	BEQ PRG060_9458	; Every other tick, jump to PRG060_9458

	; Adjust landing velocity for slip
	LDA <Player_LandXVelFrac
	ADD <Player_SlipXVelFrac
	STA <Player_LandXVelFrac
	LDA <Player_LandXVel
	ADC <Player_SlipXVel
	STA <Player_LandXVel

	; Set Player to difference between slipping X velocity and actual
	LDA Spr_XVelFrac+$00
	SUB <Player_LandXVelFrac
	LDA Spr_XVel+$00
	SBC <Player_LandXVel
	
	BCS PRG060_944B	; If didn't underflow, jump to PRG060_944B

	; Just set landing velocity
	LDA Spr_XVelFrac+$00
	STA <Player_LandXVelFrac
	LDA Spr_XVel+$00
	STA <Player_LandXVel
	
	JMP PRG060_9458	; Jump to PRG060_9458


PRG060_944B:
	; Player_SlipXVelFrac / Player_SlipXVel ++= 1
	LDA <Player_SlipXVelFrac
	ADD #$01
	STA <Player_SlipXVelFrac
	LDA <Player_SlipXVel
	ADC #$00
	STA <Player_SlipXVel

PRG060_9458:
	LDA <Player_LandPressLR
	STA <Player_TMWaterPushFaceDir
	
	BEQ PRG060_946D	; If Player not pressing LEFT/RIGHT, jump to PRG060_946D

	; Push-back for Toad Man rain
	LDA <Player_LandXVelFrac
	STA <Player_TMWaterPushXVelFrac
	LDA <Player_LandXVel
	STA <Player_TMWaterPushXVel
	
	JSR PRG060_DoSnowAndWaterFlow

	JSR PRG063_SetObjFlipForFaceDir

	CLC	; Clear carry

PRG060_946D:
	RTS	; $946D


PRG060_PlayerLandSetVars:
	LDA <Ctlr1_Held
	AND #(PAD_LEFT | PAD_RIGHT)
	STA <Player_LandPressLR	; Store LEFT/RIGHT input -> layer_LandPressLR
	
	BNE PRG060_9479	; If Player was pressing LEFT/RIGHT when landed, jump to PRG060_9479

	; Player wasn't pressing LEFT/RIGHT when landed...

	JMP PRG060_ClearLandingVars	; Jump to PRG060_ClearLandingVars


PRG060_9479:
	LDA Spr_XVelFrac+$00
	STA <Player_LandXVelFrac
	LDA Spr_XVel+$00
	STA <Player_LandXVel
	
	LDA #$1A
	STA <Player_SlipXVelFrac
	
	LDA #$00
	STA <Player_SlipXVel
	
	RTS	; $948B


PRG060_PlayerGenerateBubble:
	LDA <Player_State
	CMP #PLAYERSTATE_WIREADAPTER
	BGE PRG060_94D0		; If Player is not in a controllable state, jump to PRG060_94D0 (RTS)

	LDA Spr_SlotID+$06
	BNE PRG060_94D0		; If sprite slot 6 is in use, jump to PRG060_94D0 (RTS)

	LDY #$38
	JSR PRG062_ObjDetFloorAttrs

	LDA <Temp_Var16
	CMP #TILEATTR_WATER
	BNE PRG060_94D0		; If hit water, jump to PRG060_94D0 (RTS)

	LDY #$06	; Y = $06 (sprite slot 6)
	
	LDA #$00
	STA Spr_Flags2+$00,Y
	
	LDA #SPRANM4_METALL4_BUBBLE
	JSR PRG063_CopySprSlotSetAnim

	LDA Spr_Y+$00,Y
	SUB #$04
	STA Spr_Y+$00,Y
	BCC PRG060_94D0	; If underflowed (too high for bubble), jump to PRG060_94D0 (RTS)

	LDA #SPRSLOTID_METALL_4_BUBBLE
	STA Spr_SlotID+$00,Y
	
	LDA Spr_Flags+$00,Y
	AND #~SPR_HFLIP
	STA Spr_Flags+$00,Y
	
	; Bubble speed
	LDA #$00
	STA Spr_YVelFrac+$00,Y
	LDA #$01
	STA Spr_YVel+$00,Y

PRG060_94D0:
	RTS	; $94D0

PRG060_PostCossack_DiagBlk1:
	;       P    L    E    A    S    E         M    E    G    A    M    A    N         D    O    N    '    T    !    !
	.byte $19, $15, $0E, $0A, $1C, $0E, $00, $16, $0E, $10, $0A, $16, $0A, $17, $00, $0D, $18, $17, $2C, $1D, $28, $28, $FE
	
	; --------
	
	;       M    Y         F    A    T    H    E    R         I    S         N    O    T         R    E    A    L    L    Y    
	.byte $16, $22, $00, $0F, $0A, $1D, $11, $0E, $1B, $00, $12, $1C, $00, $17, $18, $1D, $00, $1B, $0E, $0A, $15, $15, $22, $FD
	
	;       E    V    I    L    .
	.byte $0E, $1F, $12, $15, $24, $FE
	
	; --------
	
	;       D    R    .    W    I    L    Y         T    O    O    K         M    E         H    O    S    T    A    G    E
	.byte $0D, $1B, $24, $20, $12, $15, $22, $00, $1D, $18, $18, $14, $00, $16, $0E, $00, $11, $18, $1C, $1D, $0A, $10, $0E, $FD
	
	;       A    N    D         F    O    R    C    E    D         M   Y          F    A    T    H    E    R         T    O
	.byte $0A, $17, $0D, $00, $0F, $18, $1B, $0C, $0E, $0D, $00, $16, $22, $00, $0F, $0A, $1D, $11, $0E, $1B, $00, $1D, $18, $FE
	
	; --------
	
	;       F    I    G    H    T         Y    O    U    .
	.byte $0F, $12, $10, $11, $1D, $00, $22, $18, $1E, $24, $FE
	
	; --------
	
	;       P    L    E    A    S    E         M    E    G    A    M    A    N    ,         D    O    N    '    T  
	.byte $19, $15, $0E, $0A, $1C, $0E, $00, $16, $0E, $10, $0A, $16, $0A, $17, $2E, $00, $0D, $18, $17, $2C, $1D, $FD
	
	;       H    U    R    T         M    Y         F    A    T    H    E    R         A    N    Y         M    O    R    E    .
	.byte $11, $1E, $1B, $1D, $00, $16, $22, $00, $0F, $0A, $1D, $11, $0E, $1B, $00, $0A, $17, $22, $00, $16, $18, $1B, $0E, $24, $FE
	
	
	; Dialog block terminator
	.byte $FF
	

PRG060_PostCossack_DiagBlk2:
	;       O    H    ,         K    A    L    I    N    K    A    .    .    .    .    .
	.byte $18, $11, $2E, $00, $14, $0A, $15, $12, $17, $14, $0A, $24, $24, $24, $24, $24, $FE
	
	; --------
	
	;       F    A    T    H    E    R    .    .    .    .    .    
	.byte $0F, $0A, $1D, $11, $0E, $1B, $24, $24, $24, $24, $24, $FE
	
	; --------
	
	;       M    E    G    A    M    A    N    ,    F    O    R    G    I    V    E         M    E    !
	.byte $16, $0E, $10, $0A, $16, $0A, $17, $2E, $0F, $18, $1B, $10, $12, $1F, $0E, $00, $16, $0E, $28, $FE
	
	; --------
	
	;       .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    .    . 
	.byte $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $FE
	
	; Dialog block terminator
	.byte $FF

	
PRG060_PostCossack_DiagBlk3:
	;       Y    O    U         B    E    T    R    A    Y    E    D         M    E    ,
	.byte $22, $18, $1E, $00, $0B, $0E, $1D, $1B, $0A, $22, $0E, $0D, $00, $16, $0E, $2E, $FD

	;       P    R    O    T    O    M    A    N    !    !
	.byte $19, $1B, $18, $1D, $18, $16, $0A, $17, $28, $28, $FE
	
	; --------
	
	;       I    '    M         G    O    N    N    A         B    R    E    A    K         Y    O    U    ,
	.byte $12, $2C, $16, $00, $10, $18, $17, $17, $0A, $00, $0B, $1B, $0E, $0A, $14, $00, $22, $18, $1E, $2E, $FD
	
	;       M    E    G    A    M    A    N    !    !
	.byte $16, $0E, $10, $0A, $16, $0A, $17, $28, $28, $FE
	
	
	; Dialog block terminator
	.byte $FF
	
PRG060_PostCossack_DiagTableL:
	.byte LOW(PRG060_PostCossack_DiagBlk1)	; 0
	.byte LOW(PRG060_PostCossack_DiagBlk2)	; 1
	.byte LOW(PRG060_PostCossack_DiagBlk3)	; 2

PRG060_PostCossack_DiagTableH:
	.byte HIGH(PRG060_PostCossack_DiagBlk1)	; 0
	.byte HIGH(PRG060_PostCossack_DiagBlk2)	; 1
	.byte HIGH(PRG060_PostCossack_DiagBlk3)	; 2


	; CHECKME - UNUSED?
	.byte $B5, $CD, $4F, $55, $B1, $71, $F6, $55	; $95F8 - $95FF

PRG060_OpenWeaponMenu:
	LDA #$00	; $9600
	STA <DisFlag_NMIAndDisplay	; $9602
	
	; Backup TileMap_Index
	LDA <TileMap_Index
	STA <Temp_Var45
	
	; Backup Horz_Scroll into Temp_Var46
	LDA <Horz_Scroll
	STA <Temp_Var46
	
	; Backup CommitBG_ScrSel
	LDA <CommitBG_ScrSel
	STA <Temp_Var47
	
	; Backup Raster_VMode
	LDA <Raster_VMode
	STA <Temp_Var48
	
	; Backup PPU_CTL1_PageBaseReq
	LDA <PPU_CTL1_PageBaseReq
	STA <Temp_Var49
	
	; Backup Vert_Scroll into RAM_004A
	LDA <Vert_Scroll	; $9618
	STA <RAM_004A	; $961A
	
	; Backup palette animation data to WeaponMenu_BackupPalAnims,X
	LDX #$03	; $961C
PRG060_961E:
	LDA PalAnim_EnSel+$00,X
	STA <WeaponMenu_BackupPalAnims,X
	
	; Disable palette animations
	LDA #$00
	STA PalAnim_EnSel+$00,X
	
	DEX
	BPL PRG060_961E	; While 'X' >= 0, loop!

	; Backup level palette into the graphics buffer
	LDY #$1F
PRG060_962D:
	LDA PalData_2,Y
	STA Graphics_Buffer+$30,Y
	
	LDA PalData_1,Y
	STA PalData_2,Y
	
	DEY
	BPL PRG060_962D	; While Y >= 0, loop!

	; Fade out level...
	JSR PRG062_PalFadeOut

	; Clear sprites and slots
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites
	JSR PRG063_UpdateOneFrame
	JSR PRG062_DisableDisplay

	; Load weapons menu graphics
	LDX #$14
	JSR PRG062_Upl_SprPal_CHRPats

	; Disables raster effects and zero out scroll
	LDA #$00
	STA <Horz_Scroll
	STA <Raster_VMode
	STA <Vert_Scroll
	
	LDA #TMAP_CREDITLOGO
	STA <TileMap_Index
	
	; RAM_001D: VRAM target -- $00 = $2000, $40 = $2400
	LDA #$40	; $965D
	STA <RAM_001D	; $965F
	
	; CommitBG_ScrSel: Metablock screen number
	LDA #$03
	STA <CommitBG_ScrSel

	; Loop to copy in the weapons menu BG screen
PRG060_9665:
	LDA <RAM_001D	; $9665
	ORA #$80	; $9667
	STA <RAM_001D	; $9669
	JSR PRG063_CopyMetaBlockToGBuf	; $966B

	JSR PRG062_CommitGfxBuffer_ClrFlag	; $966E

	INC <RAM_001D	; $9671
	LDA <RAM_001D	; $9673
	AND #$3F	; $9675
	BNE PRG060_9665	; $9677

	STA <RAM_001D	; $9679
	
	
	; Copy in weapon menu palette
	LDY #$1F
PRG060_967D:
	LDA PRG060_WeaponMenuPal,Y
	STA PalData_2,Y
	DEY
	BPL PRG060_967D

	; Temp_Var16 is weapon energy index
	LDY #$0E
	STY <Temp_Var16
	
	; Mega Buster listing is forced to max value all the time!
	LDA #$9C
	STA <Player_WpnEnergy+13
	
	; General sprite overlays
	LDY #(PRG060_WpnMenuSprOverlays_End - PRG060_WpnMenuSprOverlays - 1)
PRG060_9690:
	LDA PRG060_WpnMenuSprOverlays,Y
	STA Sprite_RAM+$00,Y
	DEY
	BPL PRG060_9690


PRG060_9699:
	LDY <Temp_Var16	; Y = weapon energy index
	
	LDA Player_HP,Y	; Offset to target weapon energy
	BPL PRG060_96A6	; If bit $80 not set (don't have this weapon), jump to PRG060_96A6

	; Have a weapon...
	JSR PRG060_DrawWpnEnergyMeterBG	; Draw its energy remaining

	JMP PRG060_96A9	; Jump to PRG060_96A9


PRG060_96A6:
	; Don't have this weapon
	JSR PRG060_EraseWeaponFromMenu	; Erase it!


PRG060_96A9:
	JSR PRG062_CommitGfxBuffer_ClrFlag

	DEC <Temp_Var16	; Previous weapon index
	BPL PRG060_9699	; While weapons remain, loop!
	
	
	; Set current energy tanks and lives
	JSR PRG060_DrawETanksAndLives
	JSR PRG062_CommitGfxBuffer_ClrFlag

	; Enable display~!
	JSR PRG062_EnableDisplay

	; Temp_Var0 = 1
	LDA #$01
	STA <Temp_Var0

	LDA <Level_SegCurData
	AND #$20
	BEQ PRG060_96C5	; If not horizontal mirror mode (vertical panning), jump to PRG060_9893

	; Horizontal mirroring mode

	; Temp_Var0 = 2
	INC <Temp_Var0

PRG060_96C5:
	LDA <PPU_CTL1_PageBaseReq
	ORA <Temp_Var0
	STA <PPU_CTL1_PageBaseReq
	
	; Update frame
	JSR PRG063_UpdateOneFrame

	; Fade in...
	JSR PRG062_PalFadeIn

	; Set last menu selection
	LDA Player_WpnMenuCurSel
	STA Player_WpnMenuLastSel

	; Menu loop!
PRG060_96D7:
	LDA <Ctlr1_Pressed
	AND #(PAD_A | PAD_START)
	BNE PRG060_9720	; If Player is pressing 'A' or START, jump to PRG060_9720

	; Player hasn't pressed 'A' or START...

PRG060_96DD:
	; Menu cursor operations and graphics updates due to selection change
	JSR PRG060_DoCursorMoveGfxUpd


PRG060_96E0:
	INC <General_Counter
	
	; Frame update
	JSR PRG063_UpdateOneFrame

	JMP PRG060_96D7	; Loop!


PRG060_96E8:
	; Player wants to use an energy tank...

	LDA <Player_HP
	CMP #$9C
	BEQ PRG060_96DD	; If Player is already at full HP, jump to PRG060_96DD (do nothing)

	LDA <Player_EnergyTanks
	BEQ PRG060_96DD	; If Player doesn't have any energy tanks, jump to PRG060_96DD (do nothing)

	DEC <Player_EnergyTanks	; Take away an energy tank...

PRG060_96F4:
	INC <Player_HP	; +1 Player HP
	
	; Energy gain sound
	LDA #SFX_ENERGYGAIN
	JSR PRG063_QueueMusSnd

	; Update player's energy meter
	LDY #$00
	JSR PRG060_DrawWpnEnergyMeterBG

	; Commit graphics buffer
	LDA #$FF
	STA <CommitGBuf_Flag
	
	; Delay 8 frames
	LDX #$08
	JSR PRG063_UpdateMultipleFrames

	LDA <Player_HP
	CMP #$9C
	BNE PRG060_96F4	; If Player isn't at full health, loop!

	; Get cursor off the energy tank
	LDA #$00
	STA Player_WpnMenuCurSel
	
	; Update energy tank count
	JSR PRG060_DrawETanksAndLives

	; Update frame
	JSR PRG063_UpdateOneFrame

	; Update graphics for weapon selection change
	JSR PRG060_UpdateGfxForSelection

	JMP PRG060_96E0	; Jump to PRG060_96E0


PRG060_9720:
	; Player pressed 'A' / START...

	; Hide weapon energy bar
	LDA #$00
	STA HUDBarW_DispSetting
	
	LDX Player_WpnMenuCurSel
	CPX #$07
	BEQ PRG060_96E8	; If energy tank is selected, jump to PRG060_96E8

	LDA PRG060_WpnMenuSelToIndex,X	; Translate weapon index for menu cursor
	BMI PRG060_96DD	; If $FF (invalid or energy tank, though you won't get here with that), jump to PRG060_96DD (do nothing)

	; Set player's weapon!
	STA <Player_CurWeapon
	
	BEQ PRG060_973A	; If Player_CurWeapon = 0 (Mega Buster), jump to PRG060_973A

	; Set proper weapon energy display bar
	ORA #$80
	STA HUDBarW_DispSetting

PRG060_973A:
	; What knocks you off ladders and such
	LDA #PLAYERSTATE_STAND
	STA <Player_State
	
	; Basically if some form of Rush was chosen, jump to PRG060_974A, else PRG060_976F
	CPX #$0A
	BEQ PRG060_974A
	CPX #$0B
	BEQ PRG060_974A
	CPX #$0C
	BNE PRG060_976F

PRG060_974A:
	; A Rush form was chosen...

	; Backup Player_WpnMenuCurSel
	LDA Player_WpnMenuCurSel
	PHA
	
	; Player_WpnMenuCurSel += 5
	ADD #$05
	STA Player_WpnMenuCurSel	; Basically Player_WpnMenuCurSel will be $0F, $10, or $11 (used to animate Rush on the weapon menu)
	
	; General_Counter = 0
	LDA #$00
	STA <General_Counter

PRG060_9758:
	; Update the Player / Rush sprite on the weapon menu
	JSR PRG060_UpdMenuPlayerSpr

	; Update frame
	JSR PRG063_UpdateOneFrame

	INC <General_Counter
	LDA <General_Counter
	AND #$0F
	BNE PRG060_9758		; Loop for 16  ticks

	; 1:16 ticks...

	; Delay
	LDX #$14
	JSR PRG063_UpdateMultipleFrames

	PLA	; Restore Player_WpnMenuCurSel
	STA Player_WpnMenuCurSel

PRG060_976F:
	; Close menu sound
	LDA #SFX_WEAPONMENU
	JSR PRG063_QueueMusSnd

	; Fade out
	JSR PRG062_PalFadeOut

	; Clear sprites
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites
	JSR PRG063_UpdateOneFrame
	
	; Disable display
	JSR PRG062_DisableDisplay

	LDX #$15
	JSR PRG062_Upl_SprPal_CHRPats

	; Restore TileMap_Index from backup
	LDA <Temp_Var45
	STA <TileMap_Index
	
	ORA #32			; Page 32 to 52
	TAX				; -> X
	CPX #(32+$0E)
	BEQ PRG060_97A2	; If this is Wily stage 3, jump to PRG060_97A2

	; Not Wily 3...

	CPX #(32+$0B)
	BNE PRG060_97AA	; If not Cossack stage 4, jump to PRG060_97AA

	; Cossack Stage 4 only...

	LDA <Current_Screen
	CMP #$13
	BNE PRG060_97AA	; If not on screen 19 (the Cossack boss), jump to PRG060_97AA

	; Cossack Stage 4 screen 19 only (the Cossack boss fight)...

	; Use this graphics set specifically
	LDX #$4A
	BNE PRG060_97AA		; Jump (technically always) to PRG060_97AA


PRG060_97A2:
	; Wily stage 3 only...

	LDA <Current_Screen
	CMP #$0B
	BNE PRG060_97AA	; If not on screen 11, jump to PRG060_97AA

	; Wily stage 3, screen 11 (the Wily fight)...

	; Use this graphics set specifically
	LDX #$41

PRG060_97AA:
	; Reload level graphics
	JSR PRG062_Upl_SprPal_CHRPats

	; Load graphics for the selected weapon
	LDA <Player_CurWeapon
	ORA #$30
	TAX
	JSR PRG062_Upl_SprPal_CHRPats

	; Restore Horz_Scroll from backup
	LDA <Temp_Var46
	STA <Horz_Scroll
	
	; Restore CommitBG_ScrSel from backup
	LDA <Temp_Var47
	STA <CommitBG_ScrSel
	
	BEQ PRG060_97D9	; $97BD

	LDA #$40	; $97BF
	STA <RAM_001D	; $97C1

PRG060_97C3:
	LDA <RAM_001D	; $97C3
	ORA #$80	; $97C5
	STA <RAM_001D	; $97C7
	JSR PRG063_CopyMetaBlockToGBuf	; $97C9

	JSR PRG062_CommitGfxBuffer_ClrFlag	; $97CC

	INC <RAM_001D	; $97CF
	LDA <RAM_001D	; $97D1
	AND #$3F	; $97D3
	BNE PRG060_97C3	; $97D5

	STA <RAM_001D	; $97D7

PRG060_97D9:

	; Restore level palette from the graphics buffer
	LDX #$1F
PRG060_97DB:
	LDA Graphics_Buffer+$30,X
	STA PalData_2,X
	DEX
	BPL PRG060_97DB

	LDA <TileMap_Index
	CMP #$0E
	BNE PRG060_981C	; If not Wily stage 3, jump to PRG060_981C

	; Wily stage 3 only...

	LDA <Current_Screen
	CMP #$0B
	BNE PRG060_981C		; If not on screen 11, jump to PRG060_981C

	; Wily stage 3, screen 11 (the Wily fight)...


	; Basically if not active on the second half of the Wily boss, jump to PRG060_981C
	LDA Spr_CurrentAnim+$16
	BEQ PRG060_981C
	LDA Spr_SlotID+$16
	CMP #$BC
	BEQ PRG060_981C

	; Wily stage 3 Wily fight 2nd half only... (whew)


	; Restore the boss's busted off face
	LDY #$00
PRG060_97FE:
	LDA PRG060_WS3B2_Restore1,Y
	STA Graphics_Buffer+$00,Y
	INY
	CMP #$80
	BNE PRG060_97FE

	JSR PRG062_CommitGfxBuffer_ClrFlag

	LDY #$00
PRG060_980E:
	LDA PRG060_WS3B2_Restore2,Y
	STA Graphics_Buffer+$00,Y
	INY
	CMP #$80
	BNE PRG060_980E

	JSR PRG062_CommitGfxBuffer_ClrFlag


PRG060_981C:
	LDA <Player_CurWeapon
	ASL A
	ASL A
	TAY	; Y = player's current weapon * 4
	
	; Copy in proper weapon palette
	LDX #$00	; X = 0
PRG060_9823:
	LDA PRG060_WpnPlayerPal+1,Y
	STA PalData_2+17,X
	
	INY
	INX
	CPX #$03
	BNE PRG060_9823

	; Enable display!
	JSR PRG062_EnableDisplay

	; Restore other backups
	LDA <Temp_Var48
	STA <Raster_VMode
	
	LDA <Temp_Var49
	STA <PPU_CTL1_PageBaseReq
	
	LDA <RAM_004A
	STA <Vert_Scroll
	
	; Reset first 4 sprite slots (player and any weapon shots)
	LDX #$04
PRG060_9840:
	JSR PRG062_ResetSpriteSlot
	DEX
	BNE PRG060_9840

	STX Spr_Var5+$00	; Spr_Var5+$00 = 0
	
	; Update frame
	JSR PRG063_UpdateOneFrame

	LDA Level_LightDarkCtl
	CMP #$40
	BNE PRG060_9863	; If not shrouded in darkness (e.g. Bright Man), jump to PRG060_9863

	; It's dark, so black out the palette!
	LDY #$0F
PRG060_9855:
	LDA PalData_2,Y
	STA Graphics_Buffer+$30,Y
	LDA #$0F
	STA PalData_2,Y
	DEY
	BPL PRG060_9855


PRG060_9863:
	; Fade in
	JSR PRG062_PalFadeIn

	LDA Level_LightDarkCtl
	CMP #$40
	BNE PRG060_9878	; If not shrouded in darkness (e.g. Bright Man), jump to PRG060_9878

	LDY #$0F
PRG060_986F:
	LDA Graphics_Buffer+$30,Y
	STA PalData_2,Y
	DEY
	BPL PRG060_986F

PRG060_9878:

	; Restore palette animations from backup
	LDX #$03
PRG060_987A:
	LDA <WeaponMenu_BackupPalAnims,X
	STA PalAnim_EnSel+$00,X
	DEX
	BPL PRG060_987A

	; Commit palettes
	INC <DisFlag_NMIAndDisplay
	
	RTS	; $9884


PRG060_DrawWpnEnergyMeterBG:
	
	; VRAM address $x4xx
	LDA #$04
	STA Graphics_Buffer+$00
	
	LDA <Level_SegCurData
	AND #$20
	BEQ PRG060_9893	; If not horizontal mirror mode (vertical panning), jump to PRG060_9893

	; Horizontal mirroring mode

	; VRAM address $x8xx
	ASL Graphics_Buffer+$00

PRG060_9893:

	; VRAM address base for this weapon's energy meter
	LDA PRG060_WpnEnergyMeterVRH,Y
	ORA Graphics_Buffer+$00
	STA Graphics_Buffer+$00
	LDA PRG060_WpnEnergyMeterVRL,Y
	STA Graphics_Buffer+$01
	
	; Length
	LDA #$06
	STA Graphics_Buffer+$02
	
	; Current weapon energy -> Temp_Var0 (sans bit $80, which is the "I have it" bit)
	LDA Player_HP,Y
	AND #$1F
	STA <Temp_Var0
	
	LDX #$00		; Graphics buffer relative offset
PRG060_98B0:
	LDY #$04		; Y = 4 (if at least 4 units left)
	
	LDA <Temp_Var0
	SUB #$04
	BCS PRG060_98BD		; If haven't slipped below zero, still at least 4 energy units left, jump to PRG060_98BD

	; Slipped below zero... (somewhere between 0 and 3)
	LDY <Temp_Var0	; Y = 0 to 3
	
	LDA #$00	; $98BB

PRG060_98BD:
	STA <Temp_Var0	; weapon energy units left to draw
	
	LDA PRG060_WpnEnergySegPats,Y
	STA Graphics_Buffer+$03,X
	
	INX	; X++ (next graphics buffer byte)
	CPX #$07
	BNE PRG060_98B0	; If not on last segment of energy meter, loop!

	; Terminator
	LDA #$FF
	STA Graphics_Buffer+$0A
	
	RTS	; $98CF


PRG060_DrawETanksAndLives:
	
	; Copy in template for the energy tank and lives counters
	LDY #(PRG060_ETankLivesTemplate_End - PRG060_ETankLivesTemplate - 1)
PRG060_98D2:
	LDA PRG060_ETankLivesTemplate,Y
	STA Graphics_Buffer+$00,Y
	DEY
	BPL PRG060_98D2

	; Set right hand digit of energy tanks (won't work above
	; 9, but the game caps it, so you're cool)
	LDA <Player_EnergyTanks
	AND #$0F
	ORA #$70	; pattern for '0'
	STA Graphics_Buffer+$04
	
	; BUG? The upper nibble of Player_Lives is set as the left hand
	; energy tank digit... normally lives are capped at 9 so this
	; never happens, but even so, they probably didn't mean this.
	LDA <Player_Lives
	LSR A
	LSR A
	LSR A
	LSR A
	ORA #$70	; $98EA
	STA Graphics_Buffer+$03
	
	; Set right hand digit of lives
	LDA <Player_Lives
	AND #$0F
	ORA #$70
	STA Graphics_Buffer+$09
	
	; BUG?! Similar to the one above with lives... but again, you
	; can't ever acquire enough energy tanks that this happens!
	LDA <Player_EnergyTanks
	LSR A
	LSR A
	LSR A
	LSR A
	ORA #$70
	STA Graphics_Buffer+$08
	

	; VRAM address $x4xx
	LDA #$04
	STA <Temp_Var0
	
	LDA <Level_SegCurData
	AND #$20
	BEQ PRG060_990F	; If not horizontal mirror mode (vertical panning), jump to PRG060_9893

	; Horizontal mirroring mode

	; VRAM address $x8xx
	ASL <Temp_Var0

PRG060_990F:
	LDA Graphics_Buffer+$00
	ORA <Temp_Var0
	STA Graphics_Buffer+$00
	LDA Graphics_Buffer+$05
	ORA <Temp_Var0
	STA Graphics_Buffer+$05
	STY <CommitGBuf_Flag	; Queue graphics buffer commit
	RTS	; $9921


PRG060_DoCursorMoveGfxUpd:
	LDA <Ctlr1_Pressed
	AND #(PAD_LEFT | PAD_RIGHT)
	BEQ PRG060_9962	; If Player isn't pressing LEFT/RIGHT, jump to PRG060_9962

	LSR A
	TAX	; X = 0 if right, 1 if left
	
	LDA Player_WpnMenuCurSel
	CMP #$07
	BEQ PRG060_9962	; If Player is currently highlighting energy tank (can't move left/right from here), jump to PRG060_9962

	; Add delta for left/right
	ADD PRG060_WpnMenuRLDelta,X
	AND #$0F
	STA Player_WpnMenuCurSel
	
	; I don't think this condition can ever happen!
	CMP #$07
	BEQ PRG060_UpdateGfxForSelection	; If result is 7 (energy tank), jump to PRG060_UpdateGfxForSelection

	TAY		; Y = new weapon menu selection index
	
	; Temp_Var0 = 0 if on left column, 1 if on right column
	AND #$08
	STA <Temp_Var0
	
	; This loop fixes menu selection to a nearest alternate if you don't 
	; have something in the slot you attempted to select
PRG060_9943:
	LDX PRG060_WpnMenuSelToIndex,Y	; Get corresponding weapon energy index -> 'X'
	
	LDA <Player_HP,X
	STY Player_WpnMenuCurSel	; Update menu selection
	BMI PRG060_UpdateGfxForSelection				; If Player has this weapon, jump to PRG060_UpdateGfxForSelection

	; Player does not have this weapon

	CPY <Temp_Var0
	BEQ PRG060_9955

	DEY	; Y--
	JMP PRG060_9943	; Loop


PRG060_9955:

	LDA <Temp_Var0
	ORA #$07
	TAY
	
	CPY #$0F
	BNE PRG060_9943		; If weapon selection <> $F (invalid), jump to PRG060_9943

	LDY #$0E
	BNE PRG060_9943		; Force selection to final weapon slow; jump (technically always) to PRG060_9943


PRG060_9962:
	; Player didn't press LEFT/RIGHT...

	LDA <Ctlr1_Pressed
	AND #(PAD_DOWN | PAD_UP)
	BEQ PRG060_UpdateGfxForSelection		; If Player isn't pressing UP/DOWN, jump to PRG060_UpdateGfxForSelection

	LSR A
	LSR A
	LSR A
	TAX		; X = 1 (Up) or 0 (Down)

PRG060_996C:

	; Menu wrap to stay in left or right column
	LDA Player_WpnMenuCurSel
	PHA
	AND #$08
	STA <Temp_Var0
	PLA
	ADD PRG060_WpnMenuDUDelta,X
	AND #$07
	ORA <Temp_Var0
	STA Player_WpnMenuCurSel
	
	CMP #$0F
	BEQ PRG060_996C	; If landed on $F (invalid), jump to PRG060_996C

	TAY		; New select -> 'Y'
	
	CMP #$07
	BEQ PRG060_UpdateGfxForSelection	; If selecting energy tank, jump to PRG060_UpdateGfxForSelection


	LDA PRG060_WpnMenuSelToIndex,Y	; Get corresponding weapon energy index -> 'A'
	TAY	; -> 'Y'
	
	LDA Player_HP,Y
	BPL PRG060_996C	; If Player does not have this weapon, jump to PRG060_996C


PRG060_UpdateGfxForSelection:
	; New weapon menu item selected... need to update graphically!


	; VRAM address $x4xx
	LDA #$04
	STA <Temp_Var0
	
	LDA <Level_SegCurData
	AND #$20
	BEQ PRG060_999E	; If not horizontal mirror mode (vertical panning), jump to PRG060_9893

	; Horizontal mirroring mode

	; VRAM address $x8xx
	ASL <Temp_Var0

PRG060_999E:
	LDY Player_WpnMenuLastSel	; Y = weapon menu selection
	
	
	LDX PRG060_WpnSprOverlaySelSprY,Y	; X = offset into Sprite_RAM for an overlay involved with the selection
	BEQ PRG060_99AB	; If $00, no sprite involved, jump t o PRG060_99AB

	; Deselect sprite overlay
	LDA #$00
	STA Sprite_RAM+$02,X

PRG060_99AB:

	LDX PRG060_OffsetToDeselTemplData,Y	; X = appropriate offset into PRG060_DeselTemplData

	LDY #$00	; Y = 0 (loop index)

	LDA PRG060_DeselTemplData,X
	ORA <Temp_Var0		; Patch VRAM HIGH address
	BNE PRG060_99BA		; Jump (technically always) to PRG060_99BA

PRG060_99B7:
	LDA PRG060_DeselTemplData,X	; Next byte of graphics buffer data (all but first iteration)

PRG060_99BA:
	CMP #$FF
	BEQ PRG060_99C5	; If terminator, jump to PRG060_99C5

	; Store another byte from the graphics buffer template
	STA Graphics_Buffer+$00,Y
	INY
	INX
	BNE PRG060_99B7	; Loop!


PRG060_99C5:
	LDX Player_WpnMenuCurSel	; X = weapon menu selection
	
	LDA PRG060_WpnSprOverlaySelSprY,X	; A = offset into Sprite_RAM for an overlay involved with the selection
	BEQ PRG060_99D3	; If $00, no sprite involved, jump t o PRG060_99AB

	; Select sprite overlay
	TAX
	LDA #$03
	STA Sprite_RAM+$02,X

PRG060_99D3:
	LDX Player_WpnMenuCurSel	; X = weapon menu selection
	
	
	LDA PRG060_OffsetToSelTemplData,X
	TAX
	LDA PRG060_SelTemplData,X
	ORA <Temp_Var0		; Patch VRAM HIGH address
	BNE PRG060_99E4		; Jump (technically always) to PRG060_99E4


PRG060_99E1:
	LDA PRG060_SelTemplData,X	; Next byte of graphics buffer data (all but first iteration)

PRG060_99E4:
	; Store another byte from the graphics buffer template
	STA Graphics_Buffer+$00,Y
	
	CMP #$FF	; $99E7
	BEQ PRG060_99EF	; If terminator, jump to PRG060_99EF

	INY
	INX
	BNE PRG060_99E1	; Loop!


PRG060_99EF:
	STA <CommitGBuf_Flag	; $99EF
	
	; Set as new selection
	LDA Player_WpnMenuCurSel
	STA Player_WpnMenuLastSel
	
	LDY Player_WpnMenuCurSel	; Y = current weapon menu selection
	
	LDA PRG060_WpnSelIconOvrSprite,Y
	BEQ PRG060_9A2C		; If there's no icon overlay sprite for this selected weapon, jump to PRG060_9A2C

	ASL A
	ASL A
	ASL A
	ASL A
	TAY			; Y = value * 4 for sprite icon
	
	; Copy in the icon overlay sprite
	LDX #$00	; X = 0
PRG060_9A06:
	LDA PRG060_WpnSelIconOvrSprite-1,Y
	STA Sprite_RAM+$2C,X
	LDA PRG060_WpnSelIconOvrSprite,Y
	STA Sprite_RAM+$2D,X
	LDA PRG060_WpnSelIconOvrSprite+1,Y
	STA Sprite_RAM+$2E,X
	LDA PRG060_WpnSelIconOvrSprite+2,Y
	STA Sprite_RAM+$2F,X
	
	INY
	INY
	INY
	INY
	
	INX
	INX
	INX
	INX
	CPX #$10
	BNE PRG060_9A06
	
	BEQ PRG060_UpdMenuPlayerSpr	; End of loop, jump to PRG060_UpdMenuPlayerSpr


PRG060_9A2C:
	; No icon for this selection, so just clear the sprites
	LDA #$F8
	STA Sprite_RAM+$2C
	STA Sprite_RAM+$30
	STA Sprite_RAM+$34
	STA Sprite_RAM+$38

PRG060_UpdMenuPlayerSpr:

	; Clear sprites for Rock / Rush on the weapons menu
	LDY #$2F
	LDA #$F8
PRG060_9A3E:
	STA Sprite_RAM+$3C,Y
	DEY
	BPL PRG060_9A3E

	LDA <General_Counter
	LSR A
	LSR A
	LSR A
	AND #$01
	STA <Temp_Var0	; Temp_Var0 = 0 / 1 every 8 ticks (Rush's tail wagging)
	
	LDA Player_WpnMenuCurSel
	ASL A
	ADC <Temp_Var0
	TAX			; X = (Player_WpnMenuCurSel * 2) + Temp_Var0  [0/1]
	
	; Y = offset to sprites for the Mega Man / Rush sprite at the bottom of the weapon menu
	LDY PRG060_WpnMenuPlayerSprOffs,X
	
	LDX #$00
PRG060_9A59:
	LDA PRG060_WpnMenuPlayerSpr,Y
	BEQ PRG060_9A7D	; If hit terminator, jump to PRG060_9A7D

	; Write this sprite!
	STA Sprite_RAM+$3C,X
	LDA PRG060_WpnMenuPlayerSpr+1,Y
	STA Sprite_RAM+$3D,X
	LDA PRG060_WpnMenuPlayerSpr+2,Y
	STA Sprite_RAM+$3E,X
	LDA PRG060_WpnMenuPlayerSpr+3,Y
	STA Sprite_RAM+$3F,X
	
	INY
	INY
	INY
	INY
	
	INX
	INX
	INX
	INX
	
	BNE PRG060_9A59	; Loop!


PRG060_9A7D:
	; Terminator hit...
	LDA PRG060_WpnMenuPlayerSpr+1,Y	; Fetch the continuation byte
	BEQ PRG060_9A85	; If $00, no continuation, jump to PRG060_9A85

	; Otherwise, continue from that offset
	TAY
	BNE PRG060_9A59	; Jump (technically always) to PRG060_9A59


PRG060_9A85:
	RTS	; $9A85


PRG060_EraseWeaponFromMenu:
	
	LDX #(PRG060_WpnEraseTemplate_End - PRG060_WpnEraseTemplate - 1)
PRG060_9A88:
	; Copy in the template data for erasing a weapon from the menu that the Player does not have
	LDA PRG060_WpnEraseTemplate,X
	STA Graphics_Buffer+$00,X
	DEX
	BPL PRG060_9A88


	; VRAM address $x4xx
	LDA #$04
	STA Graphics_Buffer+$00
	
	LDA <Level_SegCurData
	AND #$20
	BEQ PRG060_9A9F	; If not horizontal mirror mode (vertical panning), jump to PRG060_9893

	; Horizontal mirroring mode

	; VRAM address $x8xx
	ASL Graphics_Buffer+$00

PRG060_9A9F:
	; VRAM address base for this weapon's erasure
	LDA PRG060_WeaponEraseVRH,Y
	ORA Graphics_Buffer+$00
	STA Graphics_Buffer+$00
	STA Graphics_Buffer+$0E
	LDA PRG060_WeaponEraseVRL,Y
	STA Graphics_Buffer+$01
	ORA #$20
	STA Graphics_Buffer+$0F
	
	STX <CommitPal_Flag	; $9AB6
	
	LDA #$F8	; $F8 will be the Y coordinate for an overlay sprite to clear it if needed...
	
	; Rush Coil (letter "C") [never happens!]
	CPY #$01
	BEQ PRG060_9ACF

	; Rush Jet (letter "J")
	CPY #$02
	BEQ PRG060_9AD3

	; Rush Marine (letter "M")
	CPY #$03
	BEQ PRG060_9AD7

	; Wire Adapter (letter "W")
	CPY #$05
	BEQ PRG060_9ADB

	; Dive Missile (letter "V")
	CPY #$07
	BEQ PRG060_9ADF

	RTS	; $9ACE


	; For all of these, also consider PRG060_WpnSprOverlaySelSprY and PRG060_WpnMenuSprOverlays
PRG060_9ACF:
	; Rush Coil
	; NOTE: Would clear the "C" from Rush Coil, but that never happens in game logic!
	STA Sprite_RAM+$14
	RTS

PRG060_9AD3:
	; Rush Jet
	STA Sprite_RAM+$1C
	RTS

PRG060_9AD7:
	; Rush Marine
	STA Sprite_RAM+$18
	RTS

PRG060_9ADB:
	; Wire Adapter
	STA Sprite_RAM+$20
	RTS

PRG060_9ADF:
	; Dive Missile
	STA Sprite_RAM+$10
	RTS


PRG060_WeaponMenuPal:
	.byte $0F, $30, $10, $00, $0F, $2C, $11, $29, $0F, $30, $37, $2C, $0F, $30, $26, $16
	.byte $0F, $30, $18, $16, $0F, $30, $20, $21, $0F, $30, $37, $18, $0F, $2C, $11, $29


	; Palette loaded by Player's weapon selection. Note that
	; the first byte is never used at all, it just mostly 
	; exists for padding purposes...
PRG060_WpnPlayerPal:
	.byte $0F, $0F, $2C, $11	; 0: Mega Buster
	.byte $0F, $0F, $20, $16	; 1: Rush Coil
	.byte $0F, $0F, $20, $16	; 2: Rush Jet
	.byte $0F, $0F, $20, $16	; 3: Rush Marine
	.byte $0F, $0F, $20, $29	; 4: Toad Rain
	.byte $0F, $0F, $20, $16	; 5: Wire Adapter
	.byte $0F, $0F, $20, $16	; 6: Balloon
	.byte $0F, $0F, $20, $11	; 7: Dive Missile
	.byte $0F, $0F, $38, $18	; 8: Ring Boomerang
	.byte $0F, $0F, $10, $16	; 9: Drill Bomb
	.byte $0F, $0F, $20, $00	; 10: Dust Crusher
	.byte $0F, $0F, $36, $26	; 11: Pharaoh Shot
	.byte $0F, $0F, $20, $14	; 12: Bright
	.byte $0F, $0F, $3C, $21	; 13: Skull Barrier
	.byte $0F, $0F, $2C, $11	; 14: Unused (??)


	; VRAM low addresses for the weapon energy meters.
PRG060_WpnEnergyMeterVRL:
	.byte $8D	; Life guage at top of weapon menu
	.byte $75	; Rush Coil
	.byte $F5	; Rush Jet
	.byte $B5	; Rush Marine
	.byte $67	; Toad Rain
	.byte $35	; Wire adapter
	.byte $75	; Balloon
	.byte $F5	; Dive Missile
	.byte $27	; Ring Boomerang
	.byte $A7	; Drill Bomb
	.byte $67	; Dust Crusher
	.byte $E7	; Pharaoh Shot
	.byte $27	; [Bright] Flash Stopper
	.byte $35	; Skull Barrier
	.byte $E7	; Mega Buster

	; VRAM high base addresses for the weapon energy meters.
	; Note that the weapon menu function will appropriately
	; offset this based on conditions.
PRG060_WpnEnergyMeterVRH:
	.byte $20	; Life guage at top of weapon menu
	.byte $21	; Rush Coil
	.byte $21	; Rush Jet
	.byte $21	; Rush Marine
	.byte $21	; Toad Rain
	.byte $22	; Wire adapter
	.byte $22	; Balloon
	.byte $20	; Dive Missile
	.byte $22	; Ring Boomerang
	.byte $21	; Drill Bomb
	.byte $22	; Dust Crusher
	.byte $21	; Pharaoh Shot
	.byte $21	; [Bright] Flash Stopper
	.byte $21	; Skull Barrier
	.byte $20	; Mega Buster
	


	; Energy meter bar patterns
	; Patterns of 0 to 4 energy units
PRG060_WpnEnergySegPats:
	.byte $7E, $7D, $7C, $7B, $7A
	
PRG060_ETankLivesTemplate:
	vaddr $2327
	.byte $01
	.byte $00, $00
	
	vaddr $233A
	.byte $01
	.byte $00, $00
	
	.byte $FF
PRG060_ETankLivesTemplate_End
	
PRG060_WpnMenuRLDelta:	.byte 8, -8
PRG060_WpnMenuDUDelta:	.byte 1, -1

	; Translation table of weapon menu selection to index
PRG060_WpnMenuSelToIndex:
	.byte $00	; 0: Mega Buster
	.byte $0C	; 1: Bright
	.byte $04	; 2: Toad
	.byte $09	; 3: Drill
	.byte $0B	; 4: Pharaoh
	.byte $08	; 5: Ring
	.byte $0A	; 6: Dust
	.byte $FF	; 7: Energy Tank (no corresponding index)

	.byte $07	; 8: Dive
	.byte $0D	; 9: Skull
	.byte $01	; 10: Rush Coil
	.byte $03	; 11: Rush Marine
	.byte $02	; 12: Rush Jet
	.byte $05	; 13: Wire
	.byte $06	; 14: Balloon
	.byte $FF	; 15: Not used at all


	; Offsets into PRG060_SelTemplData
PRG060_OffsetToSelTemplData:
	.byte (PRG060_SelTemplData_MBuster - PRG060_SelTemplData)
	.byte (PRG060_SelTemplData_Bright - PRG060_SelTemplData)
	.byte (PRG060_SelTemplData_Toad - PRG060_SelTemplData)
	.byte (PRG060_SelTemplData_Drill - PRG060_SelTemplData)
	.byte (PRG060_SelTemplData_Pharaoh - PRG060_SelTemplData)
	.byte (PRG060_SelTemplData_Ring - PRG060_SelTemplData)
	.byte (PRG060_SelTemplData_Dust - PRG060_SelTemplData)
	.byte (PRG060_SelTemplData_ETank - PRG060_SelTemplData)
	.byte (PRG060_SelTemplData_Dive - PRG060_SelTemplData)
	.byte (PRG060_SelTemplData_Skull - PRG060_SelTemplData)
	.byte (PRG060_SelTemplData_RCoil - PRG060_SelTemplData)
	.byte (PRG060_SelTemplData_RMarine - PRG060_SelTemplData)
	.byte (PRG060_SelTemplData_RJet - PRG060_SelTemplData)
	.byte (PRG060_SelTemplData_Wire - PRG060_SelTemplData)
	.byte (PRG060_SelTemplData_Balloon - PRG060_SelTemplData)
	
	
	; Selection graphics buffer template data
PRG060_SelTemplData:
PRG060_SelTemplData_MBuster:
	vaddr $23C9
	.byte $02
	
	.byte $5A, $5A, $5A
	
	.byte $FF

PRG060_SelTemplData_Bright:	
	vaddr $23D1
	.byte $02
	
	.byte $85, $A5, $A5
	
	.byte $FF
	
PRG060_SelTemplData_Toad:
	vaddr $23D1
	.byte $02
	
	.byte $58, $5A, $5A
	
	.byte $FF
	
PRG060_SelTemplData_Drill:
	vaddr $23D9
	.byte $02
	
	.byte $85, $A5, $A5
	
	.byte $FF
	
PRG060_SelTemplData_Pharaoh:
	vaddr $23D9
	.byte $02
	
	.byte $58, $5A, $5A
	
	.byte $FF
	
PRG060_SelTemplData_Ring:
	vaddr $23E1
	.byte $02
	
	.byte $85, $A5, $A5
	
	.byte $FF
	
PRG060_SelTemplData_Dust:
	vaddr $23E1
	.byte $02
	
	.byte $58, $5A, $5A
	
	.byte $FF
	
PRG060_SelTemplData_ETank:
	vaddr $23F1
	.byte $01
	
	.byte $05, $FD
	
	.byte $FF
	
PRG060_SelTemplData_Dive:
	vaddr $23CC
	.byte $02
	
	.byte $4A, $5A, $5A
	
	.byte $FF
	
PRG060_SelTemplData_Skull:
	vaddr $23D4
	.byte $02
	
	.byte $24, $A5, $A5
	
	.byte $FF
	
PRG060_SelTemplData_RCoil:
	vaddr $23D4
	.byte $02
	
	.byte $42, $5A, $5A
	
	.byte $FF

PRG060_SelTemplData_RMarine:	
	vaddr $23DC
	.byte $03
	
	.byte $24, $A5, $A5, $ED
	
	.byte $FF
	
PRG060_SelTemplData_RJet:
	vaddr $23DC
	.byte $02
	
	.byte $42, $5A, $5A
	
	.byte $FF
	
PRG060_SelTemplData_Wire:
	vaddr $23E4
	.byte $02
	
	.byte $24, $A5, $A5
	
	.byte $FF
	
PRG060_SelTemplData_Balloon
	vaddr $23E4
	.byte $02
	
	.byte $42, $5A, $5A
	
	.byte $FF


	; Offsets into PRG060_DeselTemplData
PRG060_OffsetToDeselTemplData:
	.byte (PRG060_DeselTemplData_MBuster - PRG060_DeselTemplData)
	.byte (PRG060_DeselTemplData_Bright - PRG060_DeselTemplData)
	.byte (PRG060_DeselTemplData_Toad - PRG060_DeselTemplData)
	.byte (PRG060_DeselTemplData_Drill - PRG060_DeselTemplData)
	.byte (PRG060_DeselTemplData_Pharaoh - PRG060_DeselTemplData)
	.byte (PRG060_DeselTemplData_Ring - PRG060_DeselTemplData)
	.byte (PRG060_DeselTemplData_Dust - PRG060_DeselTemplData)
	.byte (PRG060_DeselTemplData_ETank - PRG060_DeselTemplData)
	.byte (PRG060_DeselTemplData_Dive - PRG060_DeselTemplData)
	.byte (PRG060_DeselTemplData_Skull - PRG060_DeselTemplData)
	.byte (PRG060_DeselTemplData_RCoil - PRG060_DeselTemplData)
	.byte (PRG060_DeselTemplData_RMarine - PRG060_DeselTemplData)
	.byte (PRG060_DeselTemplData_RJet - PRG060_DeselTemplData)
	.byte (PRG060_DeselTemplData_Wire - PRG060_DeselTemplData)
	.byte (PRG060_DeselTemplData_Balloon - PRG060_DeselTemplData)
	
	
	; Deselection graphics buffer template data
PRG060_DeselTemplData:
PRG060_DeselTemplData_MBuster:
	vaddr $23C9
	.byte $02
	
	.byte $8A, $AA, $AA
	
	.byte $FF

PRG060_DeselTemplData_Bright:	
	vaddr $23D1
	.byte $02
	
	.byte $88, $AA, $AA
	
	.byte $FF
	
PRG060_DeselTemplData_Toad:
	vaddr $23D1
	.byte $02
	
	.byte $88, $AA, $AA
	
	.byte $FF
	
PRG060_DeselTemplData_Drill:
	vaddr $23D9
	.byte $02
	
	.byte $88, $AA, $AA
	
	.byte $FF
	
PRG060_DeselTemplData_Pharaoh:
	vaddr $23D9
	.byte $02
	
	.byte $88, $AA, $AA
	
	.byte $FF
	
PRG060_DeselTemplData_Ring:
	vaddr $23E1
	.byte $02
	
	.byte $88, $AA, $AA
	
	.byte $FF
	
PRG060_DeselTemplData_Dust:
	vaddr $23E1
	.byte $02
	
	.byte $88, $AA, $AA
	
	.byte $FF
	
PRG060_DeselTemplData_ETank:
	vaddr $23F1
	.byte $01
	
	.byte $00, $FE
	
	.byte $FF
	
PRG060_DeselTemplData_Dive:
	vaddr $23CC
	.byte $02
	
	.byte $2A, $AA, $AA
	
	.byte $FF
	
PRG060_DeselTemplData_Skull:
	vaddr $23D4
	.byte $02
	
	.byte $22, $AA, $AA
	
	.byte $FF
	
PRG060_DeselTemplData_RCoil:
	vaddr $23D4
	.byte $02
	
	.byte $22, $AA, $AA
	
	.byte $FF

PRG060_DeselTemplData_RMarine:	
	vaddr $23DC
	.byte $03
	
	.byte $22, $AA, $AA, $EE
	
	.byte $FF
	
PRG060_DeselTemplData_RJet:
	vaddr $23DC
	.byte $02
	
	.byte $22, $AA, $AA
	
	.byte $FF
	
PRG060_DeselTemplData_Wire:
	vaddr $23E4
	.byte $02
	
	.byte $22, $AA, $AA
	
	.byte $FF
	
PRG060_DeselTemplData_Balloon
	vaddr $23E4
	.byte $02
	
	.byte $22, $AA, $AA
	
	.byte $FF


PRG060_WpnSelIconOvrSprite:
	; Uses one of the sprite blocks below to add additional color
	; to a selected weapon. $00 means there is no applicable sprite.
	.byte $01	; 0: Mega Buster
	.byte $02	; 1: Bright
	.byte $03	; 2: Toad
	.byte $04	; 3: Drill
	.byte $05	; 4: Pharaoh
	.byte $06	; 5: Ring
	.byte $07	; 6: Dust
	.byte $00	; 7: Energy Tank (no corresponding index)
	.byte $08	; 8: Dive
	.byte $09	; 9: Skull
	.byte $00	; 10: Rush Coil
	.byte $00	; 11: Rush Marine
	.byte $00	; 12: Rush Jet
	.byte $0A	; 13: Wire
	.byte $0B	; 14: Balloon
	
	.byte $2F, $00, $02, $20	; 1
	.byte $2F, $01, $02, $28
	.byte $37, $10, $02, $20
	.byte $37, $11, $02, $28
	
	.byte $3F, $02, $02, $20	; 2
	.byte $3F, $02, $42, $28
	.byte $47, $02, $82, $20
	.byte $47, $02, $C2, $28
	
	.byte $4F, $04, $01, $20	; 3
	.byte $4F, $05, $01, $28
	.byte $57, $14, $01, $20
	.byte $57, $15, $01, $28
	
	.byte $5F, $06, $01, $20	; 4
	.byte $5F, $07, $01, $28
	.byte $67, $16, $01, $20
	.byte $67, $17, $01, $28
	
	.byte $6F, $12, $02, $20	; 5
	.byte $6F, $12, $42, $28
	.byte $77, $12, $82, $20	
	.byte $77, $12, $C2, $28
	
	.byte $7F, $08, $02, $20	; 6
	.byte $7F, $09, $02, $28
	.byte $87, $18, $02, $20
	.byte $87, $19, $02, $28
	
	.byte $8F, $0A, $01, $20	; 7
	.byte $8F, $0B, $01, $28
	.byte $97, $1A, $01, $20
	.byte $97, $1B, $01, $28
	
	.byte $2F, $0C, $01, $90	; 8
	.byte $2F, $0D, $01, $98
	.byte $37, $1C, $01, $90
	.byte $37, $1D, $01, $98
	
	.byte $3F, $03, $01, $90	; 9
	.byte $3F, $03, $41, $98
	.byte $47, $13, $01, $90
	.byte $47, $13, $41, $98
	
	.byte $7F, $0E, $00, $90	; A
	.byte $7F, $0F, $00, $98
	.byte $87, $1E, $00, $90
	.byte $87, $1F, $00, $98
	
	.byte $8F, $20, $00, $90	; B
	.byte $8F, $20, $40, $98
	.byte $97, $30, $00, $90
	.byte $97, $30, $40, $98


	; Offset into Sprite_RAM for an associated overlay sprite on the weapon menu 
	; involved in a weapon selection / deselection... if $00 then no sprite is
	; involved with this weapon!
	; For this table, also consider PRG060_EraseWeaponFromMenu and PRG060_WpnMenuSprOverlays
PRG060_WpnSprOverlaySelSprY:
	.byte $00	; 0: Mega Buster
	.byte $00	; 1: Bright
	.byte $00	; 2: Toad
	.byte $00	; 3: Drill
	.byte $00	; 4: Pharaoh
	.byte $00	; 5: Ring
	.byte $00	; 6: Dust
	.byte $00	; 7: Energy Tank
	.byte $10	; 8: Dive ("V")
	.byte $00	; 9: Skull
	.byte $14	; 10: Rush Coil ("C")
	.byte $18	; 11: Rush Marine ("M")
	.byte $1C	; 12: Rush Jet ("J")
	.byte $20	; 13: Wire ("W")
	.byte $00	; 14: Balloon

	
PRG060_WpnMenuPlayerSprOffs:
	.byte (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr), (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr)	; 0: Mega Buster
	.byte (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr), (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr)	; 1: Bright
	.byte (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr), (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr)	; 2: Toad
	.byte (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr), (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr)	; 3: Drill
	.byte (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr), (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr)	; 4: Pharaoh
	.byte (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr), (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr)	; 5: Ring
	.byte (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr), (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr)	; 6: Dust
	.byte (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr), (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr)	; 7: Energy Tank
	.byte (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr), (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr)	; 8: Dive
	.byte (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr), (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr)	; 9: Skull
	.byte (PRG060_WpnMenuPlayerSpr_RWag1 - PRG060_WpnMenuPlayerSpr), (PRG060_WpnMenuPlayerSpr_RWag2 - PRG060_WpnMenuPlayerSpr)	; 10: Rush Coil
	.byte (PRG060_WpnMenuPlayerSpr_RWag1 - PRG060_WpnMenuPlayerSpr), (PRG060_WpnMenuPlayerSpr_RWag2 - PRG060_WpnMenuPlayerSpr)	; 11: Rush Marine
	.byte (PRG060_WpnMenuPlayerSpr_RWag1 - PRG060_WpnMenuPlayerSpr), (PRG060_WpnMenuPlayerSpr_RWag2 - PRG060_WpnMenuPlayerSpr)	; 12: Rush Jet
	.byte (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr), (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr)	; 13: Wire
	.byte (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr), (PRG060_WpnMenuPlayerSpr_MM - PRG060_WpnMenuPlayerSpr)	; 14: Balloon
	
	.byte (PRG060_WpnMenuPlayerSpr_RC - PRG060_WpnMenuPlayerSpr), (PRG060_WpnMenuPlayerSpr_RC - PRG060_WpnMenuPlayerSpr)	; Rush Coil select animation
	.byte (PRG060_WpnMenuPlayerSpr_RTC - PRG060_WpnMenuPlayerSpr), (PRG060_WpnMenuPlayerSpr_RM - PRG060_WpnMenuPlayerSpr)	; Rush Marine select animation
	.byte (PRG060_WpnMenuPlayerSpr_RTC - PRG060_WpnMenuPlayerSpr), (PRG060_WpnMenuPlayerSpr_RJ - PRG060_WpnMenuPlayerSpr)	; Rush Jet select animation
	
	; Sprites used for the Mega Man / Rush sprites on the weapon menu
PRG060_WpnMenuPlayerSpr:

	; Rock standing sprite
PRG060_WpnMenuPlayerSpr_MM:
	.byte $C2, $6D, $02, $79
	.byte $BC, $40, $03, $74
	.byte $BC, $41, $03, $7C
	.byte $C4, $42, $03, $74
	.byte $C4, $43, $03, $7C
	.byte $C4, $44, $03, $84
	.byte $CC, $45, $03, $74
	.byte $CC, $46, $03, $7C
	.byte $CC, $47, $03, $84

	; $00 - terminator, $00 - no continuation
	.byte $00, $00
	
	; Rush tail wag 1
PRG060_WpnMenuPlayerSpr_RWag1:
	.byte $BC, $52, $00, $87
	.byte $C4, $55, $00, $87

PRG060_WpnMenuPlayerSpr_RWagC:	; Common sprites for Rush's wag continued
	.byte $BC, $51, $00, $7F
	.byte $C4, $54, $00, $7F

PRG060_WpnMenuPlayerSpr_RCC:	; Common sprites for Rush's Coil spring continued
	.byte $C1, $5E, $02, $7C
	.byte $C2, $5D, $02, $74
	.byte $BC, $50, $00, $77
	.byte $C4, $53, $00, $77
	.byte $CC, $56, $00, $77
	.byte $CC, $57, $00, $7F
	.byte $CC, $58, $00, $87
	
	; $00 - terminator, $00 - no continuation
	.byte $00, $00
	
	; Rush tail wag 2
PRG060_WpnMenuPlayerSpr_RWag2:
	.byte $BC, $3F, $00, $87
	.byte $C4, $5F, $00, $87
	
	; $00 - terminator, but continue Rush's common patterns
	.byte $00, (PRG060_WpnMenuPlayerSpr_RWagC - PRG060_WpnMenuPlayerSpr)


	; Rush transformation common frame
PRG060_WpnMenuPlayerSpr_RTC:
	.byte $C6, $29, $02, $7C
	.byte $C6, $28, $02, $74
	.byte $BC, $21, $00, $79
	.byte $C4, $22, $00, $77
	.byte $C4, $23, $00, $7F
	.byte $C4, $24, $00, $87
	.byte $CC, $25, $00, $77
	.byte $CC, $26, $00, $7F
	.byte $CC, $27, $00, $87
	
	; $00 - terminator, $00 - no continuation
	.byte $00, $00
	
	; Rush Coil spring up
PRG060_WpnMenuPlayerSpr_RC:
	.byte $BC, $59, $00, $7F
	.byte $BC, $5A, $00, $87
	.byte $C4, $5B, $00, $7F
	.byte $C4, $5C, $00, $87
	
	; $00 - terminator, but continue Rush's common patterns
	.byte $00, (PRG060_WpnMenuPlayerSpr_RCC - PRG060_WpnMenuPlayerSpr)


	; Rush Marine
PRG060_WpnMenuPlayerSpr_RM:
	.byte $CC, $6C, $02, $6F
	.byte $C4, $60, $00, $6C
	.byte $C4, $61, $00, $74
	.byte $C4, $62, $00, $7C
	.byte $C4, $63, $00, $84
	.byte $C4, $68, $02, $8C
	.byte $CC, $64, $00, $6C
	.byte $CC, $65, $00, $74
	.byte $CC, $66, $00, $7C
	.byte $CC, $67, $00, $84
	.byte $CC, $69, $02, $8C
	.byte $D4, $6A, $02, $8C

	; $00 - terminator, $00 - no continuation
	.byte $00, $00


PRG060_WpnMenuPlayerSpr_RJ:
	.byte $C7, $3E, $02, $73
	.byte $C0, $48, $00, $70
	.byte $C0, $49, $00, $78
	.byte $C0, $4A, $00, $80
	.byte $C0, $4B, $00, $88
	.byte $C8, $4C, $00, $70
	.byte $C8, $4D, $00, $78
	.byte $C8, $4E, $00, $80
	.byte $C8, $4F, $02, $88
	
	; $00 - terminator, $00 - no continuation
	.byte $00, $00

	; Additional sprites to cover some areas BG is lacking
PRG060_WpnMenuSprOverlays:
	; "LIFE" at top of weapons menu
	.byte $17, $31, $00, $74	; L
	.byte $17, $32, $00, $7C	; I
	.byte $17, $33, $00, $84	; F
	.byte $17, $34, $00, $8C	; E
	
	; NOTE: These are involved in erasure operations and selection!
	; Consider values in PRG060_WpnSprOverlaySelSprY and logic in PRG060_WpnMenuSelToIndex
	.byte $2F, $2E, $00, $B8	; "V" in DIVE
	.byte $4F, $2A, $00, $B8	; "C" in COIL
	.byte $5F, $2B, $00, $B8	; "M" in MARINE
	.byte $6F, $2C, $00, $B8	; "J" in JET
	.byte $7F, $2D, $00, $A8	; "W" in WIRE
	
	; Little lives head overlay (BG has face)
	.byte $BF, $2F, $03, $B8	; Left helment
	.byte $BF, $2F, $43, $C0	; Right helmet
PRG060_WpnMenuSprOverlays_End
	
PRG060_WS3B2_Restore1:
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
	
	; Terminator (for graphics buffer)
	.byte $FF
	
	; Terminator (of this block)
	.byte $80
	
	
PRG060_WS3B2_Restore2:
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
	.byte $01, $AA, $AA
	
	vaddr $2BEC
	.byte $01
	
	.byte $FA, $7A, $2B, $F4, $01, $FF, $F7
	
	; Terminator (for graphics buffer)
	.byte $FF
	
	; Terminator (of this block)
	.byte $80

	; Template data for erasing a weapon that the Player does not have from the weapon menu
PRG060_WpnEraseTemplate:
	vaddr $2000
	.byte $0A
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	
	vaddr $2000
	.byte $0A
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	
	.byte $FF
PRG060_WpnEraseTemplate_End


	; VRAM high base addresses for the erasing an unobtained weapon from the menu.
	; Note that the weapon menu function will appropriately
	; offset this based on conditions.
PRG060_WeaponEraseVRH:
	.byte $20	; Life guage at top of weapon menu [technically this is never used!]
	.byte $21	; Rush Coil [technically this is never used!]
	.byte $21	; Rush Jet
	.byte $21	; Rush Marine
	.byte $21	; Toad Rain
	.byte $22	; Wire adapter
	.byte $22	; Balloon
	.byte $20	; Dive Missile
	.byte $22	; Ring Boomerang
	.byte $21	; Drill Bomb
	.byte $22	; Dust Crusher
	.byte $21	; Pharaoh Shot
	.byte $21	; [Bright] Flash Stopper
	.byte $21	; Skull Barrier
	.byte $20	; Mega Buster [technically this is never used!]

	; VRAM low addresses for the erasing an unobtained weapon from the menu.
PRG060_WeaponEraseVRL:
	.byte $C4	; Life guage at top of weapon menu [technically this is never used!]
	.byte $52	; Rush Coil [technically this is never used!]
	.byte $D2	; Rush Jet
	.byte $92	; Rush Marine
	.byte $44	; Toad Rain
	.byte $12	; Wire adapter
	.byte $52	; Balloon
	.byte $D2	; Dive Missile
	.byte $04	; Ring Boomerang
	.byte $84	; Drill Bomb
	.byte $44	; Dust Crusher
	.byte $C4	; Pharaoh Shot
	.byte $04	; [Bright] Flash Stopper
	.byte $12	; Skull Barrier
	.byte $C4	; Mega Buster [technically this is never used!]


	; CHECKME - UNUSED?
	.byte $51, $21, $50, $90, $14, $AA, $55, $C1, $54, $06, $55, $84, $40, $00, $40	; $9F62 - $9F71
	.byte $32, $04, $E4, $00, $0D, $09, $D5, $10, $00, $11, $04, $10, $4C, $04, $84, $15	; $9F72 - $9F81
	.byte $50, $41, $44, $01, $59, $44, $0F, $05, $D5, $01, $2F, $51, $02, $00, $42, $14	; $9F82 - $9F91
	.byte $01, $10, $29, $70, $42, $40, $09, $00, $00, $50, $58, $56, $36, $00, $59, $10	; $9F92 - $9FA1
	.byte $8A, $01, $88, $11, $EA, $54, $7B, $51, $43, $00, $20, $01, $A1, $14, $81, $14	; $9FA2 - $9FB1
	.byte $21, $50, $6C, $05, $9C, $00, $90, $00, $00, $00, $80, $00, $00, $04, $03, $55	; $9FB2 - $9FC1
	.byte $CB, $A4, $80, $04, $B0, $00, $38, $05, $33, $00, $EE, $01, $44, $01, $B1, $04	; $9FC2 - $9FD1
	.byte $04, $00, $31, $40, $81, $00, $08, $13, $80, $00, $42, $04, $08, $10, $4A, $A4	; $9FD2 - $9FE1
	.byte $4E, $51, $26, $01, $74, $10, $A1, $51, $EE, $00, $04, $51, $A1, $45, $F8, $54	; $9FE2 - $9FF1
	.byte $02, $10, $08, $50, $11, $45, $21, $00, $C7, $00, $C0, $41, $98, $50	; $9FF2 - $9FFF


