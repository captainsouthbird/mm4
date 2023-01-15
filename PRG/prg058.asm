PRG058_PlayerDoHurt_Ind:
	JMP PRG058_PlayerDoHurt	; $8000

	; Updates all objects, handles damage Player <-> Objects
PRG058_UpdateObjsDoDamages:
	LDA <Player_TriggerDeath
	BEQ PRG058_8014	; If Player_TriggerDeath = 0 (Player not dying), jump to PRG058_8014

	; Player is supposed to die...

	LDA <Player_State
	CMP #PLAYERSTATE_HURT
	BGE PRG058_8014	; If Player is in a state that prohibits death, jump to PRG058_8014

	LDA <Player_PlayerHitInv
	BNE PRG058_8014	; If Player is currently invincible, jump to PRG058_8014

	; Player needs to die and all looks good!

	; Stop music, play death sound, spawn the explodey bits
	JSR PRG058_DoPlayerDeath


PRG058_8014:
	; X / SprObj_SlotIndex = 1 (processing objects $01 - $17) 
	LDX #$01
	STX <SprObj_SlotIndex

PRG058_8018:
	LDY Spr_SlotID+$00,X
	BEQ PRG058_8052	; If this object sprite slot is empty, jump to PRG058_8052

	LDA Spr_CodePtrH+$00,X
	BMI PRG058_802E	; If object already has its code pointer initialized ('BMI' since the "high" part will always be $8x+), jump to PRG058_802E

	; Object needs its code pointer set...
	LDA PRG058_ObjCodePtrBySlotL,Y
	STA Spr_CodePtrL+$00,X
	LDA PRG058_ObjCodePtrBySlotH,Y
	STA Spr_CodePtrH+$00,X

PRG058_802E:
	LDA Spr_FlashOrPauseCnt,X
	BMI PRG058_8097	; If object isn't currently frozen (bit $80 set on Spr_FlashOrPauseCnt), jump to PRG058_8097

	; As long as object isn't frozen...

	; Load its execution pointer
	LDA Spr_CodePtrL+$00,X
	STA <Temp_Var0
	LDA Spr_CodePtrH+$00,X
	STA <Temp_Var1
	
	; "Return" to PRG058_8097 after this
	LDA #HIGH(PRG058_8097-1)
	PHA
	LDA #LOW(PRG058_8097-1)
	PHA
	
	LDA PRG058_ObjCodeBankBySlot,Y
	CMP <MMC3_PageA000_Req
	BEQ PRG058_804F		; If page @ $A000 is already correct, jump to PRG058_804F

	; Set correct page @ $A000
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

PRG058_804F:
	JMP [Temp_Var0]	; Execute object's code pointer!


PRG058_8052:
	; Empty slot index or not a Player-reserved object...

	INC <SprObj_SlotIndex	; SprObj_SlotIndex++
	
	LDX <SprObj_SlotIndex
	CPX #$18
	BNE PRG058_8018	; If we haven't processed the last object, loop!
	
	
	; All objects processed...
	LDA <Player_PlayerHitInv
	BNE PRG058_8096	; If Player is currently flashing-invincible, jump to PRG058_8096 (RTS)

	LDA <Player_State
	CMP #PLAYERSTATE_HURT
	BGE PRG058_8096	; If Player is in a state that can't take damage, jump to PRG058_8096 (RTS)

	LDA <TileMap_Index
	CMP #TMAP_RINGMAN
	BEQ PRG058_8096	; If this is Ring Man, jump to PRG058_8096 (RTS)

	; Player not invincible, and this is not Ring Man...

	LDX #$00	; $806A
	
	LDY #$3E	; Y = $3E
	
	; Temp_Var0 = $B5
	LDA #$B5
	STA <Temp_Var0
	
	LDA <Player_State
	CMP #PLAYERSTATE_SLIDING
	BNE PRG058_807D	; If Player is not sliding, jump to PRG058_807D

	; Temp_Var0 = $B7
	LDA #$B7
	STA <Temp_Var0
	
	INY	; Y = $3F

PRG058_807D:
	LDA <Raster_VMode
	CMP #RVMODE_DUSTMANCRUSH
	BNE PRG058_808A	; If this is not the Dust Man crusher segment, jump to PRG058_808A
	
	; Dust Man crusher segement only...

	LDA Spr_Y+$00
	CMP <Temp_Var0
	BGE PRG058_8096	; If Player Y >= Temp_Var0, jump to PRG058_8096 (RTS)

	; Dust Man crusher segment potentially getting crushed

PRG058_808A:
	JSR PRG062_ObjDetWallAttrs

	LDA <Temp_Var16
	AND #TILEATTR_SOLID
	BEQ PRG058_8096	; If not solid, jump to PRG058_8096

	; Player crushed
	JSR PRG058_DoPlayerDeath

PRG058_8096:
	RTS	; $8096


PRG058_8097:
	; Post-object code pointer execution [PRG058_804F] lands here...

	CPX #$05
	BLT PRG058_8052	; If this is one of the Player reserved objects, jump to PRG058_8052

	; Not a player reserved object...

	; Temp_Var17 = Player_CurWeapon
	LDA <Player_CurWeapon
	STA <Temp_Var17
	
	CMP #PLAYERWPN_TOADRAIN
	BEQ PRG058_80DB	; If Player is using Toad Rain weapon, jump to PRG058_80DB

	; Not Toad Rain...

	CMP #PLAYERWPN_FLASHSTOPPER
	BNE PRG058_810B	; If Player is not using Flash Stopper weapon, jump to PRG058_810B

	; Flash Stopper weapon only...

	; Temp_Var17 = 0 (use Mega Buster's damage table instead, since damage factor
	; table for Flash Stopper is used for enable/disable instead)
	LDA #$00
	STA <Temp_Var17
	
	LDA Weapon_FlashStopCnt+$00
	ORA Weapon_FlashStopCnt+$01
	BEQ PRG058_810B	; If Flash Stopper not active, jump to PRG058_810B

	; Flash Stopper active...

	LDA Spr_Flags+$00,X
	AND #SPRFL1_NODRAW
	BNE PRG058_810B	; If not drawing, jump to PRG058_810B

	; Since this is ONLY the Flash Stopper at this point, this always sets bank 32 + 12 = 44
	LDA <Player_CurWeapon		; 12
	ORA #32						; 32 -> 44
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

	LDY Spr_SlotID+$00,X
	LDA PRG044_FlashStopperEnTable,Y
	BEQ PRG058_810B	; If not flagged for flash-stopper-enabled, jump to PRG058_810B

	LDA Spr_FlashOrPauseCnt,X
	BEQ PRG058_80D4	; If object is not paused, jump to PRG058_80D4

	CMP #$81
	BNE PRG058_810B	; If object hasn't fallen to flash tick $81 yet, jump to PRG058_810B


PRG058_80D4:

	; Hold object at $82 while Flash Stopper is active
	LDA #$82
	STA Spr_FlashOrPauseCnt,X
	BNE PRG058_810B	; Jump (technically always) to PRG058_810B


PRG058_80DB:
	; Player has Toad Rain equipped...

	LDA Weapon_ToadRainCounter
	BEQ PRG058_8108	; If Toad Rain is not active, jump to PRG058_8108

	; Toad Rain active...

	LDA ToadRain_OwnerIndex
	CMP #$10
	BGE PRG058_8108	; If Toad Rain was spawned by Toad Man, jump to PRG058_8108

	LDA Spr_FlashOrPauseCnt,X
	BNE PRG058_8108	; If object is flashing-invincible, jump to PRG058_8108

	; Since this is ONLY the Toad Rain at this point, this always sets bank 32 + 4 = 36
	LDA <Player_CurWeapon		; 4
	ORA #32						; 32 -> 36
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

	LDY Spr_SlotID+$00,X
	LDA Player_WeaponDamageTable,Y
	BEQ PRG058_8108	; If Toad Rain does no damage against this object, jump to PRG058_8108

	STA <Temp_Var18	; -> Temp_Var18 (store damage amount)
	JSR PRG058_830F	; Damage / kill!

	LDA Weapon_ToadRainCounter
	STA Spr_FlashOrPauseCnt,X

PRG058_8108:
	JMP PRG058_81B2	; $8108


PRG058_810B:
	JSR PRG063_CheckProjToObjCollide

	BCS PRG058_8108	; If no projectiles hit, jump to PRG058_8108

	; Player projectile hit...

	; Set bank 32-45 depending on Player's equipped weapon
	LDA <Temp_Var17		; Temp_Var17 = Player_CurWeapon, except for Flash Stopper, where forced to zero (since that damage table is used for enable/disable instead)
	ORA #32
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

	LDA <Player_CurWeapon
	CMP #PLAYERWPN_SKULLBARRIER
	BNE PRG058_8141	; If this is not Skull Barrier, jump to PRG058_8141
	
	; Skull Barrier only...

	LDY Spr_SlotID+$00,X
	
	LDA Spr_Flags2+$00,X
	AND #SPRFL2_SHOOTABLE
	ORA Player_WeaponDamageTable,Y
	BEQ PRG058_813C	; $812A

	LDA Player_WeaponDamageTable,Y
	BPL PRG058_8141	; If not an $FF value, jump to PRG058_8141

	; Instant removal, used for Skull Barrier to block projectiles
	JSR PRG062_ResetSpriteSlot


PRG058_8134:
	LDY <Temp_Var16	; Y = Projectile's index (via PRG063_CheckProjToObjCollide)
	JSR PRG063_DeleteObjectY	; Projectile destroyed!

	JMP PRG058_8052	; Jump to PRG058_8052


PRG058_813C:
	LDA Spr_Flags2+$00,X
	BMI PRG058_8134	; If object can hurt Player, jump to PRG058_8134


PRG058_8141:
	LDY Spr_SlotID+$00,X	; Y = object slot ID
	
	LDA Spr_Flags2+$00,X
	AND #SPRFL2_SHOOTABLE
	ORA Player_WeaponDamageTable,Y
	BEQ PRG058_81B2	; (Pass through)

	LDA Player_WeaponDamageTable,Y
	STA <Temp_Var18	; damage factor -> Temp_Var18
	
	BEQ PRG058_8162	; If no damage factor, jump to PRG058_8162

	LDA Spr_Flags2+$00,X
	AND #SPRFL2_SHOOTABLE
	BEQ PRG058_8162	; $815A

	JSR PRG058_82A4	; $815C

	JMP PRG058_81B2	; $815F


PRG058_8162:
	; Shot deflected sound effect
	LDA #SFX_SHOTDEFLECT
	JSR PRG063_QueueMusSnd

	LDA <Player_CurWeapon
	CMP #PLAYERWPN_RINGBOOMERANG
	BEQ PRG058_81B2	; If Player is using Ring Boomerang, jump to PRG058_81B2 (don't destroy Ring)

	LDY <Temp_Var16	; Y = projectile index
	
	LDA Spr_SlotID+$00,Y
	CMP #SPRSLOTID_WIREADAPTER
	BEQ PRG058_81B2	; If this was Wire Adapter that hit, jump to PRG058_81B2 (don't destroy Wire Adapter)

	CMP #SPRSLOTID_CIRCULAREXPLOSION
	BEQ PRG058_81B2	; If this was (??), jump to PRG058_81B2

	; Destroy projectile
	JSR PRG063_DeleteObjectY

	LDA <Player_CurWeapon
	CMP #PLAYERWPN_SKULLBARRIER
	BEQ PRG058_81B2	; If this was Skull Barrier, jump to PRG058_81B2 (don't do anything else after shield destroyed)

	LDA #SPRSLOTID_DEFLECTEDSHOT
	STA Spr_SlotID+$00,Y
	
	; Rebound projectile left/right, and move upward
	LDA Spr_FaceDir+$00,Y
	EOR #(SPRDIR_LEFT | SPRDIR_RIGHT)
	ORA #SPRDIR_UP
	STA Spr_FaceDir+$00,Y
	
	; Set deflect velocities
	LDA #$00
	STA Spr_XVelFrac+$00,Y
	STA Spr_YVelFrac+$00,Y
	LDA #$04
	STA Spr_XVel+$00,Y
	STA Spr_YVel+$00,Y
	
	LDA Spr_CurrentAnim+$00,Y
	CMP #SPRANM2_MBUSTSHOTBURST
	BEQ PRG058_81AD	; If this is the Mega Buster partial charge shot, jump to PRG058_81AD

	CMP #SPRANM2_MBUSTSHOTFULL
	BNE PRG058_81B2	; If this is NOT the Mega Buster full charge shot, jump to PRG058_81B2


PRG058_81AD:
	LDA #SPRANM2_MBUSTFULLDEFLCT
	JSR PRG063_SetSpriteAnimY


PRG058_81B2:
	LDA Spr_Flags2+$00,X
	BPL PRG058_81C9	; If object doesn't hurt Player, jump to PRG058_81C9

	; Need to hurt Player maybe...

	LDA <Player_PlayerHitInv
	BNE PRG058_81C9	; If Player is flashing-invincible, jump to PRG058_81C9

	LDA <Player_State
	CMP #PLAYERSTATE_HURT
	BGE PRG058_81C9	; If Player is in a state that can't be hurt, jump to PRG058_81C9

	JSR PRG063_TestPlayerObjCollide

	BCS PRG058_81C9	; If Player didn't collide, jump to PRG058_81C9

	; Player hurt by object...
	JSR PRG058_PlayerDoHurt


PRG058_81C9:
	JMP PRG058_8052	; $81C9


PRG058_PlayerDoHurt:
	LDA Spr_CurrentAnim+$00
	CMP #SPRANM2_RUSHMARINECLOSE
	BEQ PRG058_823E	; If Player is currently in the Rush Marine closing animation, jump to PRG058_823E (RTS)

	LDY Spr_SlotID+$00,X
	
	LDA PRG058_Obj_PlayerDamageByObj,Y
	BEQ PRG058_823E	; If object does no damage to Player, jump to PRG058_823E (RTS)

	; Unfreeze Player, if frozen
	LDA #$00
	STA <Player_FreezePlayerTicks
	
	; Deduct Player HP by the damage factor
	LDA <Player_HP
	AND #$1F
	SUB PRG058_Obj_PlayerDamageByObj,Y
	BEQ PRG058_DoPlayerDeathHP0
	BCC PRG058_DoPlayerDeathHP0

	; Not dead, just update HP
	ORA #$80
	STA <Player_HP
	
	; Player hurt SFX
	LDA #SFX_PLAYERHURT
	JSR PRG063_QueueMusSnd

	; Store previous Player state -> Spr_Var1+$00
	LDA <Player_State
	STA Spr_Var1+$00
	
	STX <Temp_Var15	; Object index -> Temp_Var15
	
	LDX #$00	; X = 0 (Player index)
	
	STX Spr_Var2+$00
	
	CMP #PLAYERSTATE_SLIDING
	BNE PRG058_8209	; If Player is not sliding, jump to PRG058_8209

	LDA #$04
	STA Spr_Var2+$00

PRG058_8209:
	
	; Player hurt state!
	LDA #PLAYERSTATE_HURT
	STA <Player_State
	
	; Halt Player velocity
	JSR PRG063_SetObjYVelToMinus1

	LDA #SPRANM2_PLAYERHURT
	
	LDY Spr_Var1+$00	; Y = Player's previous state
	CPY #PLAYERSTATE_RUSHMARINE
	BNE PRG058_821B	; If Player is not riding Rush Marine, jump to PRG058_821B

	LDA #SPRANM2_RUSHMARINEHIT

PRG058_821B:
	JSR PRG063_SetSpriteAnim

	; Cancel shooting
	LDA #PLAYERCSA_NOSHOOT
	STA <Player_ShootAnimTimer	
	STA <Player_CurShootAnim
	
	LDX <Temp_Var15	; X = object index restored
	
	LDA Spr_SlotID+$05
	BNE PRG058_823E	; If slot 5 is not empty (Player's decorative sprite objects), jump to PRG058_823E

	LDA Spr_Var1+$00
	CMP #PLAYERSTATE_RUSHMARINE
	BEQ PRG058_823E	; If Player is riding Rush Marine, jump to PRG058_823E (RTS)

	; Add the Player hit spark things
	LDY #$05	; Y = 5 (Player decorative sprte objects)
	LDA #SPRANM2_HURTHITFX
	JSR PRG063_CopySprSlotSetAnim

	LDA #SPRSLOTID_PLAYER
	STA Spr_SlotID+$00,Y

PRG058_823E:
	RTS	; $823E


	; Just like PRG058_DoPlayerDeath, except it forces Player HP to zero
PRG058_DoPlayerDeathHP0:
	LDA #$00
	STA <Player_HP

	; Stop music, play death sound, spawn the explodey bits
PRG058_DoPlayerDeath:
	; Unfreeze player (if frozen)
	LDA #$00
	STA <Player_FreezePlayerTicks
	
	; Stop music
	LDA #MUS_STOPMUSIC
	JSR PRG063_QueueMusSnd_SetMus_Cur

	; Kaboom SFX
	LDA #SFX_ROBOTDEATH
	JSR PRG063_QueueMusSnd

	LDA Spr_Flags+$00
	ORA #SPRFL1_NODRAW
	STA Spr_Flags+$00
	
	; Stop Player from doing anything
	LDA #PLAYERSTATE_DEAD
	STA <Player_State
	
	; Time until reset
	LDA #$2C
	STA Level_ExitTimeout
	LDA #$01
	STA Level_ExitTimeoutH
	
	; Backup 'X' -> Temp_Var16
	STX <Temp_Var16
	
	; Temp_Var17 = $0F (total amount of explodey bits)
	LDA #$0F
	STA <Temp_Var17

PRG058_826D:
	JSR PRG063_FindFreeSlotMinIdx4	; Find a free slot for the explodey bit

	BCS PRG058_82A1	; If none available, jump to PRG058_82A1 (exiting)
	
	; Spawn explodey bit!
	LDX #$00	; X = 0 (copy from Player) [Y set from PRG063_FindFreeSlotMinIdx4]
	LDA #SPRANM2_BOTEXPLODEYBIT
	JSR PRG063_CopySprSlotSetAnim

	LDA #SPRSLOTID_EXPLODEYBIT
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_Flags2+$00,Y
	
	; Current explodey bit index
	LDX <Temp_Var17
	
	; Set X velocity of this explodey bit
	LDA PRG058_ExplodeyBitXVelFrac,X
	STA Spr_XVelFrac+$00,Y
	LDA PRG058_ExplodeyBitXVel,X
	STA Spr_XVel+$00,Y
	
	; Set Y velocity of this explodey bit
	LDA PRG058_ExplodeyBitYVelFrac,X
	STA Spr_YVelFrac+$00,Y
	LDA PRG058_ExplodeyBitYVel,X
	STA Spr_YVel+$00,Y
	
	DEC <Temp_Var17	; Temp_Var17--
	BPL PRG058_826D	; While Temp_Var17 > 0, loop!


PRG058_82A1:
	; Restore 'X'
	LDX <Temp_Var16

PRG058_82A3:
	RTS	; $82A3


PRG058_82A4:
	LDY <Temp_Var16	; Y = Player projectile index
	
	LDA Spr_CurrentAnim+$00,Y
	CMP #SPRANM2_DUSTCRUSHER
	BNE PRG058_82B9	; If this is not Dust Crusher, jump to PRG058_82B9

	LDA Spr_Frame+$00,Y
	BNE PRG058_82A3	; If frame <> 0, jump to PRG058_82A3

	LDA #$01
	STA Spr_Frame+$00,Y	; frame = 1
	BNE PRG058_830F	; Jump (technically always) to PRG058_830F


PRG058_82B9:
	LDA <Player_CurWeapon
	CMP #PLAYERWPN_RINGBOOMERANG
	BEQ PRG058_82E2	; If Player is using Ring Boomerang, jump to PRG058_82E2

	CMP #PLAYERWPN_DRILLBOMB
	BNE PRG058_82E8	; If Player is NOT using Drill Bomb, jump to PRG058_82E8
	
	; Drill Bomb...

	LDA #SPRANM4_SMALLPOOFEXP
	CMP Spr_CurrentAnim+$00,Y
	BEQ PRG058_82E2	; If Drill Bomb is exploding, jump to PRG058_82E2

	JSR PRG063_CopySprSlotSetAnim
	JSR PRG063_DeleteObjectY

	LDA #SPRSLOTID_CIRCULAREXPLOSION
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_Var1+$00,Y
	STA Spr_Var2+$00,Y
	
	LDA #$03
	STA Spr_Flags2+$00,Y

PRG058_82E2:
	LDA Spr_FlashOrPauseCnt,X
	BEQ PRG058_830F	; If target is not flashing invincible, jump to PRG058_830F

	RTS	; $82E7


PRG058_82E8:
	LDA Spr_SlotID+$00,Y
	CMP #SPRSLOTID_WIREADAPTER
	BEQ PRG058_82E2	; If using Wire Adapter, jump to PRG058_82E2


	; Basically projectiles that will plow through multiple targets

	LDA Spr_CurrentAnim+$00,Y
	CMP #SPRANM2_MBUSTSHOTBURST
	BEQ PRG058_82FE	; If Mega Buster shot burst, jump to PRG058_82FE

	CMP #SPRANM2_MBUSTSHOTFULL
	BEQ PRG058_82FE	; If Mega Buster shot fully charged, jump to PRG058_82FE

	CMP #SPRANM2_PHARAOHCHSHOT
	BNE PRG058_830C	; If not a charged Pharaoh shot, jump to PRG058_830C


PRG058_82FE:
	
	; Combining damage done
	LDA <Temp_Var18
	ASL A
	ADC <Temp_Var18
	STA <Temp_Var18
	
	LDA Spr_HP+$00,X
	CMP <Temp_Var18
	BLT PRG058_830F	; If dealt enough damage, jump to PRG058_830F


PRG058_830C:
	; Delete projectile
	JSR PRG063_DeleteObjectY


PRG058_830F:
	; Kill sound effect!
	LDA #SFX_ENEMYHIT
	JSR PRG063_QueueMusSnd

	CPX Boss_SprIndex
	BNE PRG058_ObjDoDamage	; If this is not the boss character, jump to PRG058_ObjDoDamage

	LDA HUDBarB_DispSetting
	BPL PRG058_ObjDoDamage	; If boss's life meter is not being displayed (crude check if boss is active), jump to PRG058_ObjDoDamage

	; This is the boss with the life meter displayed...

	LDA Spr_FlashOrPauseCnt,X
	BEQ PRG058_ObjDoDamage	; If object is normal, jump to PRG058_ObjDoDamage
	BPL PRG058_8329	; If object is flashing-invincible, jump to PRG058_8329 (RTS)

	; Object is frozen...

	CMP #$83
	BLT PRG058_ObjDoDamage	; If less than 3 ticks of "frozen" time remaining, jump to PRG058_ObjDoDamage


PRG058_8329:
	RTS	; $8329


	; Damage object by factor specified in Temp_Var18
PRG058_ObjDoDamage:

	; Take damage from object based on damage factor
	LDA Spr_HP+$00,X
	SUB <Temp_Var18
	STA Spr_HP+$00,X
	
	BCS PRG058_833A	; If object HP didn't fall below zero, jump to PRG058_833A

	; Ground object's HP at zero
	LDA #$00
	STA Spr_HP+$00,X

PRG058_833A:
	LDA <TileMap_Index
	CMP #TMAP_COSSACK4
	BNE PRG058_8350	; If this isn't Cossack 4, jump to PRG058_8350

	LDA <Current_Screen
	CMP #$13
	BNE PRG058_8350	; If this isn't the Cossack 4 boss, jump to PRG058_8350

	; Prevent Cossack 4 boss from dropping below HP = 2
	LDA #$02
	CMP Spr_HP+$00,X
	BLT PRG058_8350

	STA Spr_HP+$00,X

PRG058_8350:
	
	; Setup flashing-invicbility (non-boss)
	LDA Spr_FlashOrPauseCnt,X
	AND #$80
	ORA #$08
	STA Spr_FlashOrPauseCnt,X
	
	CPX Boss_SprIndex
	BNE PRG058_8382	; If this is not the boss character, jump to PRG058_8382

	LDA HUDBarB_DispSetting
	BPL PRG058_8382	; If boss's life meter is not being displayed (crude check if boss is active), jump to PRG058_8382

	; Update Boss_HP with boss object's actual HP
	LDA Spr_HP+$00,X
	STA <Boss_HP
	
	; Set boss's flashing-invincibility
	LDA Spr_FlashOrPauseCnt,X
	AND #$80
	ORA #$30
	STA Spr_FlashOrPauseCnt,X
	
	LDA Spr_SlotID+$00,X
	CMP #SPRSLOTID_COSSACK3BOSS1
	BNE PRG058_8382	; If this is not the Cossack 3 boss walker #1, jump to PRG058_8382

	; Adjusted boss HP to accomodate the boss walker (so it dies at "halfway" on the energy bar)
	LDA Spr_HP+$00,X
	ADD #$0E
	STA <Boss_HP

PRG058_8382:
	LDA Spr_HP+$00,X
	BNE PRG058_83D2	; If object not dead, jump to PRG058_83D2 (RTS)


	; Object dead (HP = 0)

	STA Spr_FlashOrPauseCnt,X	; Clear flash/pause counter
	
	; Clear the sprite object out
	LDY Spr_SlotID+$00,X
	JSR PRG062_ResetSpriteSlot

	LDA Spr_Flags+$00,X
	AND #~SPRFL1_OBJSOLID
	STA Spr_Flags+$00,X
	
	LDA PRG058_ObjDieTurnInto,Y
	BEQ PRG058_83BE	; If object doesn't turn into something else, jump to PRG058_83BE

	; Object becomes something else after death...

	; New ID!
	STA Spr_SlotID+$00,X
	
	; Reset stuff
	LDA #$00
	STA Spr_Flags2+$00,X
	STA Spr_Var1+$00,X
	STA Spr_Var2+$00,X
	STA Spr_Var3+$00,X
	STA Spr_Var4+$00,X
	STA Spr_Var5+$00,X
	STA Spr_Var6+$00,X
	STA Spr_Var7+$00,X
	STA Spr_Var8+$00,X
	
	RTS	; $83BD


PRG058_83BE:

	; Spawn enemy's death explosion!
	LDA #SPRANM4_ENEMYEXPLODE
	JSR PRG063_SetSpriteAnim

	LDA #$00
	STA Spr_Flags2+$00,X
	
	LDA #SPRSLOTID_ENEMYEXPLODE
	STA Spr_SlotID+$00,X
	
	; NOTE: I don't think this sound queue has any actual effect
	LDA #SFX_MBUSTERCHARGEHOLD
	JSR PRG063_QueueMusSnd

PRG058_83D2:
	RTS	; $83D2


	; When the Player dies, the explodey bits fly out at these velocities
PRG058_ExplodeyBitXVelFrac:	.byte $00, $0F, $80, $0F, $00, $F1, $80, $F1, $00, $87, $C0, $87, $00, $79, $40, $79
PRG058_ExplodeyBitXVel:		.byte $00, $01, $01, $01, $00, $FE, $FE, $FE, $00, $00, $00, $00, $00, $FF, $FF, $FF
PRG058_ExplodeyBitYVelFrac:	.byte $80, $F1, $00, $0F, $80, $0F, $00, $F1, $40, $79, $00, $87, $C0, $87, $00, $79
PRG058_ExplodeyBitYVel:		.byte $FE, $FE, $00, $01, $01, $01, $00, $FE, $FF, $FF, $00, $00, $00, $00, $00, $FF


	; When object hurts Player, damage by value (unless $00) by Spr_SlotID
PRG058_Obj_PlayerDamageByObj:
	.byte $00	; $00
	.byte $00	; $01 SPRSLOTID_PLAYER
	.byte $00	; $02 SPRSLOTID_PLAYERSHOT
	.byte $00	; $03 SPRSLOTID_DEFLECTEDSHOT
	.byte $00	; $04 SPRSLOTID_RUSH
	.byte $00	; $05 SPRSLOTID_TOADRAINCAN
	.byte $00	; $06 SPRSLOTID_BALLOON
	.byte $00	; $07 SPRSLOTID_DIVEMISSILE
	.byte $00	; $08 SPRSLOTID_RINGBOOMERANG
	.byte $00	; $09 SPRSLOTID_DRILLBOMB
	.byte $00	; $0A SPRSLOTID_DUSTCRUSHER
	.byte $00	; $0B SPRSLOTID_WIREADAPTER
	.byte $00	; $0C SPRSLOTID_PHARAOHSHOT
	.byte $00	; $0D SPRSLOTID_PHARAOHOVERH
	.byte $00	; $0E
	.byte $00	; $0F SPRSLOTID_SKULLBARRIER
	.byte $04	; $10 SPRSLOTID_TAKETETNO
	.byte $04	; $11 SPRSLOTID_TAKETETNO_PROP
	.byte $00	; $12 SPRSLOTID_HOVER
	.byte $06	; $13 SPRSLOTID_TOMBOY
	.byte $04	; $14 SPRSLOTID_SASOREENU
	.byte $00	; $15 SPRSLOTID_SASOREENU_SPAWNER
	.byte $00	; $16 SPRSLOTID_BATTAN
	.byte $00	; $17
	.byte $04	; $18 SPRSLOTID_SWALLOWN
	.byte $03	; $19 SPRSLOTID_COSWALLOWN
	.byte $04	; $1A SPRSLOTID_WALLBLASTER
	.byte $02	; $1B SPRSLOTID_WALLBLASTER_SHOT
	.byte $06	; $1C SPRSLOTID_100WATTON
	.byte $04	; $1D SPRSLOTID_100WATTON_SHOT
	.byte $02	; $1E SPRSLOTID_100WATTON_SHOT_BURST
	.byte $04	; $1F SPRSLOTID_RATTON
	.byte $00	; $20 SPRSLOTID_RMRAINBOW_CTL1
	.byte $00	; $21 SPRSLOTID_RMRAINBOW_CTL2
	.byte $00	; $22 SPRSLOTID_RMRAINBOW_CTL3
	.byte $00	; $23 SPRSLOTID_RMRAINBOW_CTL4
	.byte $04	; $24 SPRSLOTID_SUBBOSS_KABATONCUE
	.byte $02	; $25 SPRSLOTID_KABATONCUE_MISSILE
	.byte $00	; $26 SPRSLOTID_RINGMAN_UNK2
	.byte $08	; $27 SPRSLOTID_WILY_ESCAPEPOD
	.byte $00	; $28 SPRSLOTID_BOMBABLE_WALL
	.byte $00	; $29 SPRSLOTID_MOTHRAYA_DIE
	.byte $00	; $2A SPRSLOTID_POWERGAIN_ORBS
	.byte $04	; $2B SPRSLOTID_SUBBOSS_ESCAROO
	.byte $02	; $2C SPRSLOTID_ESCAROO_BOMB
	.byte $00	; $2D SPRSLOTID_ESCAROO_DIE
	.byte $00	; $2E SPRSLOTID_EXPLODEYBIT
	.byte $00	; $2F SPRSLOTID_RED_UTRACK_PLAT
	.byte $08	; $30 SPRSLOTID_SUBBOSS_WHOPPER
	.byte $08	; $31 SPRSLOTID_SUBBOSS_WHOPPER_RING
	.byte $04	; $32 SPRSLOTID_SUBBOSS_WHOPPER_RIN2
	.byte $04	; $33 SPRSLOTID_HAEHAEY
	.byte $02	; $34 SPRSLOTID_HAEHAEY_SHOT
	.byte $04	; $35 SPRSLOTID_RACKASER
	.byte $02	; $36 SPRSLOTID_RACKASER_UMBRELLA
	.byte $04	; $37 SPRSLOTID_DOMPAN
	.byte $02	; $38 SPRSLOTID_DOMPAN_FIREWORKS
	.byte $01	; $39 SPRSLOTID_CIRCLEBULLET
	.byte $00	; $3A SPRSLOTID_WHOPPER_DIE
	.byte $00	; $3B SPRSLOTID_CIRCULAREXPLOSION
	.byte $00	; $3C SPRSLOTID_CEXPLOSION
	.byte $04	; $3D SPRSLOTID_MINOAN
	.byte $06	; $3E SPRSLOTID_SUPERBALLMACHJR_L
	.byte $01	; $3F SPRSLOTID_SUPERBALLMACHJR_B
	.byte $00	; $40 SPRSLOTID_BOULDER_DISPENSER
	.byte $04	; $41 SPRSLOTID_BOULDER_DEBRIS
	.byte $00	; $42 SPRSLOTID_EDDIE
	.byte $00	; $43 SPRSLOTID_EDDIE_IMMEDIATE
	.byte $00	; $44 SPRSLOTID_EDDIE_ITEM_EJECT
	.byte $00	; $45 SPRSLOTID_CRPLATFORM_FALL
	.byte $07	; $46 SPRSLOTID_JUMPBIG
	.byte $00	; $47
	.byte $04	; $48 SPRSLOTID_SHIELDATTACKER
	.byte $00	; $49 SPRSLOTID_COSSACK3BOSS1_DIE
	.byte $00	; $4A SPRSLOTID_COSSACK3BOSS2_DIE
	.byte $00	; $4B SPRSLOTID_KABATONCUE_DIE
	.byte $00	; $4C SPRSLOTID_100WATTON_DIE
	.byte $00	; $4D SPRSLOTID_WILYCAPSULE_CHRG
	.byte $06	; $4E SPRSLOTID_TOTEMPOLEN
	.byte $02	; $4F SPRSLOTID_TOTEMPOLEN_SHOT
	.byte $03	; $50 SPRSLOTID_METALL_1
	.byte $02	; $51 SPRSLOTID_METALL_BULLET
	.byte $06	; $52 SPRSLOTID_SUBBOSS_MOBY
	.byte $04	; $53 SPRSLOTID_MOBY_MISSILE
	.byte $02	; $54 SPRSLOTID_MOBY_BIGSPIKE
	.byte $00	; $55
	.byte $03	; $56 SPRSLOTID_METALL_2
	.byte $00	; $57
	.byte $00	; $58
	.byte $00	; $59
	.byte $00	; $5A
	.byte $00	; $5B SPRSLOTID_SWITCH
	.byte $03	; $5C SPRSLOTID_METALL_3
	.byte $00	; $5D SPRSLOTID_SINKINGPLATFORM
	.byte $00	; $5E SPRSLOTID_DUSTMAN_CRUSHERACT
	.byte $04	; $5F SPRSLOTID_M422A
	.byte $00	; $60 SPRSLOTID_CINESTUFF
	.byte $04	; $61 SPRSLOTID_PUYOYON
	.byte $04	; $62 SPRSLOTID_SKELETONJOE
	.byte $02	; $63 SPRSLOTID_SKELETONJOE_BONE
	.byte $04	; $64 SPRSLOTID_RINGRING
	.byte $03	; $65 SPRSLOTID_METALL_4
	.byte $00	; $66 SPRSLOTID_METALL_4_BUBBLE
	.byte $07	; $67 SPRSLOTID_WILY1_UNK1
	.byte $02	; $68
	.byte $06	; $69 SPRSLOTID_SKULLMET_R
	.byte $02	; $6A SPRSLOTID_SKULLMET_BULLET
	.byte $00	; $6B SPRSLOTID_DIVEMAN_BIDIW1
	.byte $00	; $6C SPRSLOTID_DIVEMAN_BIDIW2
	.byte $04	; $6D SPRSLOTID_HELIPON
	.byte $02	; $6E SPRSLOTID_HELIPON_BULLET
	.byte $00	; $6F SPRSLOTID_WATERSPLASH
	.byte $04	; $70 SPRSLOTID_GYOTOT
	.byte $08	; $71 SPRSLOTID_BOSSSKULL
	.byte $04	; $72 SPRSLOTID_SKULLMAN_BULLET
	.byte $00	; $73 SPRSLOTID_DUSTMAN_4PLAT
	.byte $04	; $74 SPRSLOTID_DUSTMAN_PLATSEG
	.byte $08	; $75 SPRSLOTID_BOSSRING
	.byte $04	; $76 SPRSLOTID_RINGMAN_RING
	.byte $00	; $77 SPRSLOTID_BOSSDEATH
	.byte $02	; $78 SPRSLOTID_BIREE1
	.byte $08	; $79 SPRSLOTID_BOSSDUST
	.byte $04	; $7A SPRSLOTID_DUSTMAN_DUSTCRUSHER
	.byte $04	; $7B SPRSLOTID_DUSTMAN_DUSTDEBRIS
	.byte $08	; $7C SPRSLOTID_BOSSDIVE
	.byte $04	; $7D SPRSLOTID_BOSSDIVE_MISSILE
	.byte $08	; $7E SPRSLOTID_BOSSDRILL
	.byte $03	; $7F SPRSLOTID_DRILLMAN_DRILL
	.byte $00	; $80 SPRSLOTID_MISCSTUFF
	.byte $00	; $81 SPRSLOTID_BOSSINTRO
	.byte $00	; $82 SPRSLOTID_DRILLMAN_POOF
	.byte $02	; $83 SPRSLOTID_SPIRALEXPLOSION
	.byte $04	; $84 SPRSLOTID_BOSSPHARAOH
	.byte $06	; $85 SPRSLOTID_PHARAOHMAN_ATTACK
	.byte $02	; $86 SPRSLOTID_PHARAOHMAN_SATTACK
	.byte $00	; $87 SPRSLOTID_BOSS_MOTHRAYA
	.byte $07	; $88 SPRSLOTID_COSSACK1_UNK1
	.byte $07	; $89 SPRSLOTID_COSSACK1_UNK2
	.byte $04	; $8A SPRSLOTID_MOTHRAYA_SHOT
	.byte $08	; $8B SPRSLOTID_BOSSBRIGHT
	.byte $04	; $8C SPRSLOTID_BOSSBRIGHT_BULLET
	.byte $08	; $8D SPRSLOTID_BOSSTOAD
	.byte $03	; $8E SPRSLOTID_BATTONTON
	.byte $00	; $8F SPRSLOTID_MOTHRAYA_DEBRIS
	.byte $00	; $90 SPRSLOTID_EXPLODEY_DEATH
	.byte $06	; $91 SPRSLOTID_MANTAN
	.byte $08	; $92 SPRSLOTID_BOSS_COSSACKCATCH
	.byte $00	; $93 SPRSLOTID_COSSACK4_UNK1
	.byte $02	; $94
	.byte $06	; $95 SPRSLOTID_BOSS_SQUAREMACHINE
	.byte $04	; $96 SPRSLOTID_SQUAREMACH_PLATFORM
	.byte $04	; $97 SPRSLOTID_SQUAREMACHINE_SHOT
	.byte $06	; $98 SPRANM4_BOULDER
	.byte $02	; $99 SPRSLOTID_COSSACK2_UNK2
	.byte $06	; $9A SPRSLOTID_MUMMIRA
	.byte $02	; $9B SPRSLOTID_MUMMIRAHEAD
	.byte $04	; $9C SPRSLOTID_IMORM
	.byte $00	; $9D SPRSLOTID_ENEMYEXPLODE
	.byte $08	; $9E SPRSLOTID_COSSACK3BOSS1
	.byte $06	; $9F SPRSLOTID_COSSACK3BOSS2_SHOT
	.byte $04	; $A0 SPRSLOTID_COSSACK3BOSS1_SHOT
	.byte $04	; $A1 SPRSLOTID_MONOROADER
	.byte $08	; $A2 SPRSLOTID_COSSACK3BOSS2
	.byte $00	; $A3 SPRSLOTID_KALINKA
	.byte $00	; $A4 SPRSLOTID_PROTOMAN
	.byte $00	; $A5 SPRSLOTID_WILY
	.byte $07	; $A6 SPRSLOTID_BOSS_METALLDADDY
	.byte $06	; $A7 SPRSLOTID_GACHAPPON
	.byte $02	; $A8 SPRSLOTID_GACHAPPON_BULLET
	.byte $02	; $A9 SPRSLOTID_GACHAPPON_GASHAPON
	.byte $03	; $AA SPRSLOTID_METALLDADDY_METALL
	.byte $00	; $AB SPRSLOTID_BOSS_TAKOTRASH
	.byte $08	; $AC SPRSLOTID_WILY2_UNK1
	.byte $04	; $AD SPRSLOTID_TAKOTRASH_BALL
	.byte $06	; $AE SPRSLOTID_TAKOTRASH_FIREBALL
	.byte $00	; $AF SPRSLOTID_TAKOTRASH_PLATFORM
	.byte $04	; $B0 SPRSLOTID_PAKATTO24
	.byte $02	; $B1 SPRSLOTID_PAKATTO24_SHOT
	.byte $03	; $B2 SPRSLOTID_UPNDOWN
	.byte $00	; $B3 SPRSLOTID_WILYTRANSPORTER
	.byte $00	; $B4 SPRSLOTID_UPNDOWN_SPAWNER
	.byte $04	; $B5 SPRSLOTID_SPIKEBLOCK_1
	.byte $06	; $B6 SPRSLOTID_SEAMINE
	.byte $02	; $B7 SPRSLOTID_GARYOBY
	.byte $00	; $B8 SPRSLOTID_BOSS_ROBOTMASTER
	.byte $04	; $B9 SPRSLOTID_DOCRON
	.byte $04	; $BA SPRSLOTID_DOCRON_SKULL
	.byte $06	; $BB SPRSLOTID_WILY3_UNK1
	.byte $00	; $BC SPRSLOTID_BOSS_WILYMACHINE4
	.byte $00	; $BD SPRSLOTID_TOGEHERO_SPAWNER_R
	.byte $04	; $BE SPRSLOTID_TOGEHERO
	.byte $04	; $BF SPRSLOTID_WILYMACHINE4_SHOTCH
	.byte $06	; $C0 SPRSLOTID_WILYMACHINE4_PHASE2
	.byte $00	; $C1 SPRSLOTID_ITEM_PICKUP
	.byte $00	; $C2 SPRSLOTID_SPECWPN_PICKUP
	.byte $00	; $C3 SPRSLOTID_WILY1_DISPBLOCKS
	.byte $06	; $C4 SPRSLOTID_BOSS_WILYCAPSULE
	.byte $08	; $C5 SPRSLOTID_WILYCAPSULE_SHOT
	.byte $00	; $C6 SPRSLOTID_ITEM_PICKUP_GRAVITY
	.byte $04	; $C7 SPRSLOTID_LADDERPRESS_R
	.byte $00	; $C8 SPRSLOTID_DOMPAN_INTERWORK
	.byte $00	; $C9 SPRSLOTID_GREEN_UTRACK_PLAT
	.byte $04	; $CA SPRSLOTID_LADDERPRESS_L
	.byte $00	; $CB SPRSLOTID_WILYCAPSULE_DIE
	.byte $00	; $CC SPRSLOTID_DRILLMAN_POOF_ALT
	.byte $04	; $CD SPRSLOTID_TOADMAN_UNK1
	.byte $00	; $CE SPRSLOTID_TOGEHERO_SPAWNER_L
	.byte $1C	; $CF SPRSLOTID_DIVEMAN_UNK5


	; When object is destroyed, transform it into something else (unless $00) by Spr_SlotID
PRG058_ObjDieTurnInto:
	.byte $00	; $00
	.byte $00	; $01 SPRSLOTID_PLAYER
	.byte $00	; $02 SPRSLOTID_PLAYERSHOT
	.byte $00	; $03 SPRSLOTID_DEFLECTEDSHOT
	.byte $00	; $04 SPRSLOTID_RUSH
	.byte $00	; $05 SPRSLOTID_TOADRAINCAN
	.byte $00	; $06 SPRSLOTID_BALLOON
	.byte $00	; $07 SPRSLOTID_DIVEMISSILE
	.byte $00	; $08 SPRSLOTID_RINGBOOMERANG
	.byte $00	; $09 SPRSLOTID_DRILLBOMB
	.byte $00	; $0A SPRSLOTID_DUSTCRUSHER
	.byte $00	; $0B SPRSLOTID_WIREADAPTER
	.byte $00	; $0C SPRSLOTID_PHARAOHSHOT
	.byte $00	; $0D SPRSLOTID_PHARAOHOVERH
	.byte $00	; $0E
	.byte $00	; $0F SPRSLOTID_SKULLBARRIER
	.byte $00	; $10 SPRSLOTID_TAKETETNO
	.byte $00	; $11 SPRSLOTID_TAKETETNO_PROP
	.byte $00	; $12 SPRSLOTID_HOVER
	.byte $00	; $13 SPRSLOTID_TOMBOY
	.byte $00	; $14 SPRSLOTID_SASOREENU
	.byte $00	; $15 SPRSLOTID_SASOREENU_SPAWNER
	.byte $00	; $16 SPRSLOTID_BATTAN
	.byte $00	; $17
	.byte $00	; $18 SPRSLOTID_SWALLOWN
	.byte $00	; $19 SPRSLOTID_COSWALLOWN
	.byte $00	; $1A SPRSLOTID_WALLBLASTER
	.byte $00	; $1B SPRSLOTID_WALLBLASTER_SHOT
	.byte SPRSLOTID_100WATTON_DIE	; $1C SPRSLOTID_100WATTON
	.byte $00	; $1D SPRSLOTID_100WATTON_SHOT
	.byte $00	; $1E SPRSLOTID_100WATTON_SHOT_BURST
	.byte $00	; $1F SPRSLOTID_RATTON
	.byte $00	; $20 SPRSLOTID_RMRAINBOW_CTL1
	.byte $00	; $21 SPRSLOTID_RMRAINBOW_CTL2
	.byte $00	; $22 SPRSLOTID_RMRAINBOW_CTL3
	.byte $00	; $23 SPRSLOTID_RMRAINBOW_CTL4
	.byte SPRSLOTID_KABATONCUE_DIE	; $24 SPRSLOTID_SUBBOSS_KABATONCUE
	.byte $00	; $25 SPRSLOTID_KABATONCUE_MISSILE
	.byte $00	; $26 SPRSLOTID_RINGMAN_UNK2
	.byte $00	; $27 SPRSLOTID_WILY_ESCAPEPOD
	.byte $00	; $28 SPRSLOTID_BOMBABLE_WALL
	.byte $00	; $29 SPRSLOTID_MOTHRAYA_DIE
	.byte $00	; $2A SPRSLOTID_POWERGAIN_ORBS
	.byte SPRSLOTID_ESCAROO_DIE	; $2B SPRSLOTID_SUBBOSS_ESCAROO
	.byte $00	; $2C SPRSLOTID_ESCAROO_BOMB
	.byte $00	; $2D SPRSLOTID_ESCAROO_DIE
	.byte $00	; $2E SPRSLOTID_EXPLODEYBIT
	.byte $00	; $2F SPRSLOTID_RED_UTRACK_PLAT
	.byte SPRSLOTID_WHOPPER_DIE	; $30 SPRSLOTID_SUBBOSS_WHOPPER
	.byte $00	; $31 SPRSLOTID_SUBBOSS_WHOPPER_RING
	.byte $00	; $32 SPRSLOTID_SUBBOSS_WHOPPER_RIN2
	.byte $00	; $33 SPRSLOTID_HAEHAEY
	.byte $00	; $34 SPRSLOTID_HAEHAEY_SHOT
	.byte $00	; $35 SPRSLOTID_RACKASER
	.byte $00	; $36 SPRSLOTID_RACKASER_UMBRELLA
	.byte SPRSLOTID_DOMPAN_INTERWORK	; $37 SPRSLOTID_DOMPAN
	.byte $00	; $38 SPRSLOTID_DOMPAN_FIREWORKS
	.byte $00	; $39 SPRSLOTID_CIRCLEBULLET
	.byte $00	; $3A SPRSLOTID_WHOPPER_DIE
	.byte $00	; $3B SPRSLOTID_CIRCULAREXPLOSION
	.byte $00	; $3C SPRSLOTID_CEXPLOSION
	.byte $00	; $3D SPRSLOTID_MINOAN
	.byte $00	; $3E SPRSLOTID_SUPERBALLMACHJR_L
	.byte $00	; $3F SPRSLOTID_SUPERBALLMACHJR_B
	.byte $00	; $40 SPRSLOTID_BOULDER_DISPENSER
	.byte $00	; $41 SPRSLOTID_BOULDER_DEBRIS
	.byte $00	; $42 SPRSLOTID_EDDIE
	.byte $00	; $43 SPRSLOTID_EDDIE_IMMEDIATE
	.byte $00	; $44 SPRSLOTID_EDDIE_ITEM_EJECT
	.byte $00	; $45 SPRSLOTID_CRPLATFORM_FALL
	.byte $00	; $46 SPRSLOTID_JUMPBIG
	.byte $00	; $47
	.byte $00	; $48 SPRSLOTID_SHIELDATTACKER
	.byte $00	; $49 SPRSLOTID_COSSACK3BOSS1_DIE
	.byte $00	; $4A SPRSLOTID_COSSACK3BOSS2_DIE
	.byte $00	; $4B SPRSLOTID_KABATONCUE_DIE
	.byte $00	; $4C SPRSLOTID_100WATTON_DIE
	.byte SPRSLOTID_EXPLODEY_DEATH	; $4D SPRSLOTID_WILYCAPSULE_CHRG
	.byte $00	; $4E SPRSLOTID_TOTEMPOLEN
	.byte $00	; $4F SPRSLOTID_TOTEMPOLEN_SHOT
	.byte $00	; $50 SPRSLOTID_METALL_1
	.byte $00	; $51 SPRSLOTID_METALL_BULLET
	.byte SPRSLOTID_EXPLODEY_DEATH	; $52 SPRSLOTID_SUBBOSS_MOBY
	.byte $00	; $53 SPRSLOTID_MOBY_MISSILE
	.byte $00	; $54 SPRSLOTID_MOBY_BIGSPIKE
	.byte $00	; $55
	.byte $00	; $56 SPRSLOTID_METALL_2
	.byte $00	; $57
	.byte $00	; $58
	.byte $00	; $59
	.byte $00	; $5A
	.byte $00	; $5B SPRSLOTID_SWITCH
	.byte $00	; $5C SPRSLOTID_METALL_3
	.byte $00	; $5D SPRSLOTID_SINKINGPLATFORM
	.byte $00	; $5E SPRSLOTID_DUSTMAN_CRUSHERACT
	.byte $00	; $5F SPRSLOTID_M422A
	.byte $00	; $60 SPRSLOTID_CINESTUFF
	.byte $00	; $61 SPRSLOTID_PUYOYON
	.byte $00	; $62 SPRSLOTID_SKELETONJOE
	.byte $00	; $63 SPRSLOTID_SKELETONJOE_BONE
	.byte $00	; $64 SPRSLOTID_RINGRING
	.byte $00	; $65 SPRSLOTID_METALL_4
	.byte $00	; $66 SPRSLOTID_METALL_4_BUBBLE
	.byte $00	; $67 SPRSLOTID_WILY1_UNK1
	.byte $00	; $68
	.byte $00	; $69 SPRSLOTID_SKULLMET_R
	.byte $00	; $6A SPRSLOTID_SKULLMET_BULLET
	.byte $00	; $6B SPRSLOTID_DIVEMAN_BIDIW1
	.byte $00	; $6C SPRSLOTID_DIVEMAN_BIDIW2
	.byte $00	; $6D SPRSLOTID_HELIPON
	.byte $00	; $6E SPRSLOTID_HELIPON_BULLET
	.byte $00	; $6F SPRSLOTID_WATERSPLASH
	.byte $00	; $70 SPRSLOTID_GYOTOT
	.byte SPRSLOTID_BOSSDEATH	; $71 SPRSLOTID_BOSSSKULL
	.byte $00	; $72 SPRSLOTID_SKULLMAN_BULLET
	.byte $00	; $73 SPRSLOTID_DUSTMAN_4PLAT
	.byte $00	; $74 SPRSLOTID_DUSTMAN_PLATSEG
	.byte SPRSLOTID_BOSSDEATH	; $75 SPRSLOTID_BOSSRING
	.byte $00	; $76 SPRSLOTID_RINGMAN_RING
	.byte $00	; $77 SPRSLOTID_BOSSDEATH
	.byte $00	; $78 SPRSLOTID_BIREE1
	.byte SPRSLOTID_BOSSDEATH	; $79 SPRSLOTID_BOSSDUST
	.byte $00	; $7A SPRSLOTID_DUSTMAN_DUSTCRUSHER
	.byte $00	; $7B SPRSLOTID_DUSTMAN_DUSTDEBRIS
	.byte SPRSLOTID_BOSSDEATH	; $7C SPRSLOTID_BOSSDIVE
	.byte $00	; $7D SPRSLOTID_BOSSDIVE_MISSILE
	.byte SPRSLOTID_BOSSDEATH	; $7E SPRSLOTID_BOSSDRILL
	.byte $00	; $7F SPRSLOTID_DRILLMAN_DRILL
	.byte $00	; $80 SPRSLOTID_MISCSTUFF
	.byte $00	; $81 SPRSLOTID_BOSSINTRO
	.byte $00	; $82 SPRSLOTID_DRILLMAN_POOF
	.byte $00	; $83 SPRSLOTID_SPIRALEXPLOSION
	.byte SPRSLOTID_BOSSDEATH	; $84 SPRSLOTID_BOSSPHARAOH
	.byte $00	; $85 SPRSLOTID_PHARAOHMAN_ATTACK
	.byte $00	; $86 SPRSLOTID_PHARAOHMAN_SATTACK
	.byte SPRSLOTID_MOTHRAYA_DIE	; $87 SPRSLOTID_BOSS_MOTHRAYA
	.byte $00	; $88 SPRSLOTID_COSSACK1_UNK1
	.byte $00	; $89 SPRSLOTID_COSSACK1_UNK2
	.byte $00	; $8A SPRSLOTID_MOTHRAYA_SHOT
	.byte SPRSLOTID_BOSSDEATH	; $8B SPRSLOTID_BOSSBRIGHT
	.byte $00	; $8C SPRSLOTID_BOSSBRIGHT_BULLET
	.byte SPRSLOTID_BOSSDEATH	; $8D SPRSLOTID_BOSSTOAD
	.byte $00	; $8E SPRSLOTID_BATTONTON
	.byte $00	; $8F SPRSLOTID_MOTHRAYA_DEBRIS
	.byte $00	; $90 SPRSLOTID_EXPLODEY_DEATH
	.byte $00	; $91 SPRSLOTID_MANTAN
	.byte $00	; $92 SPRSLOTID_BOSS_COSSACKCATCH
	.byte $00	; $93 SPRSLOTID_COSSACK4_UNK1
	.byte $00	; $94
	.byte SPRSLOTID_MOTHRAYA_DIE	; $95 SPRSLOTID_BOSS_SQUAREMACHINE
	.byte $00	; $96 SPRSLOTID_SQUAREMACH_PLATFORM
	.byte $00	; $97 SPRSLOTID_SQUAREMACHINE_SHOT
	.byte $00	; $98 SPRANM4_BOULDER
	.byte $00	; $99 SPRSLOTID_COSSACK2_UNK2
	.byte $00	; $9A SPRSLOTID_MUMMIRA
	.byte $00	; $9B SPRSLOTID_MUMMIRAHEAD
	.byte $00	; $9C SPRSLOTID_IMORM
	.byte $00	; $9D SPRSLOTID_ENEMYEXPLODE
	.byte SPRSLOTID_COSSACK3BOSS1_DIE	; $9E SPRSLOTID_COSSACK3BOSS1
	.byte $00	; $9F SPRSLOTID_COSSACK3BOSS2_SHOT
	.byte $00	; $A0 SPRSLOTID_COSSACK3BOSS1_SHOT
	.byte $00	; $A1 SPRSLOTID_MONOROADER
	.byte SPRSLOTID_COSSACK3BOSS2_DIE	; $A2 SPRSLOTID_COSSACK3BOSS2
	.byte $00	; $A3 SPRSLOTID_KALINKA
	.byte $00	; $A4 SPRSLOTID_PROTOMAN
	.byte $00	; $A5 SPRSLOTID_WILY
	.byte SPRSLOTID_MOTHRAYA_DIE	; $A6 SPRSLOTID_BOSS_METALLDADDY
	.byte $00	; $A7 SPRSLOTID_GACHAPPON
	.byte $00	; $A8 SPRSLOTID_GACHAPPON_BULLET
	.byte $00	; $A9 SPRSLOTID_GACHAPPON_GASHAPON
	.byte $00	; $AA SPRSLOTID_METALLDADDY_METALL
	.byte SPRSLOTID_MOTHRAYA_DIE	; $AB SPRSLOTID_BOSS_TAKOTRASH
	.byte $00	; $AC SPRSLOTID_WILY2_UNK1
	.byte $00	; $AD SPRSLOTID_TAKOTRASH_BALL
	.byte $00	; $AE SPRSLOTID_TAKOTRASH_FIREBALL
	.byte $00	; $AF SPRSLOTID_TAKOTRASH_PLATFORM
	.byte $00	; $B0 SPRSLOTID_PAKATTO24
	.byte $00	; $B1 SPRSLOTID_PAKATTO24_SHOT
	.byte $00	; $B2 SPRSLOTID_UPNDOWN
	.byte $00	; $B3 SPRSLOTID_WILYTRANSPORTER
	.byte $00	; $B4 SPRSLOTID_UPNDOWN_SPAWNER
	.byte $00	; $B5 SPRSLOTID_SPIKEBLOCK_1
	.byte $00	; $B6 SPRSLOTID_SEAMINE
	.byte $00	; $B7 SPRSLOTID_GARYOBY
	.byte $00	; $B8 SPRSLOTID_BOSS_ROBOTMASTER
	.byte $00	; $B9 SPRSLOTID_DOCRON
	.byte $00	; $BA SPRSLOTID_DOCRON_SKULL
	.byte $00	; $BB SPRSLOTID_WILY3_UNK1
	.byte SPRSLOTID_WILYMACHINE4_PHASE2	; $BC SPRSLOTID_BOSS_WILYMACHINE4
	.byte $00	; $BD SPRSLOTID_TOGEHERO_SPAWNER_R
	.byte $00	; $BE SPRSLOTID_TOGEHERO
	.byte $00	; $BF SPRSLOTID_WILYMACHINE4_SHOTCH
	.byte SPRSLOTID_WILY_ESCAPEPOD	; $C0 SPRSLOTID_WILYMACHINE4_PHASE2
	.byte $00	; $C1 SPRSLOTID_ITEM_PICKUP
	.byte $00	; $C2 SPRSLOTID_SPECWPN_PICKUP
	.byte $00	; $C3 SPRSLOTID_WILY1_DISPBLOCKS
	.byte SPRSLOTID_WILYCAPSULE_DIE	; $C4 SPRSLOTID_BOSS_WILYCAPSULE
	.byte $00	; $C5 SPRSLOTID_WILYCAPSULE_SHOT
	.byte $00	; $C6 SPRSLOTID_ITEM_PICKUP_GRAVITY
	.byte $00	; $C7 SPRSLOTID_LADDERPRESS_R
	.byte $00	; $C8 SPRSLOTID_DOMPAN_INTERWORK
	.byte $00	; $C9 SPRSLOTID_GREEN_UTRACK_PLAT
	.byte $00	; $CA SPRSLOTID_LADDERPRESS_L
	.byte $00	; $CB SPRSLOTID_WILYCAPSULE_DIE
	.byte $00	; $CC SPRSLOTID_DRILLMAN_POOF_ALT
	.byte $00	; $CD SPRSLOTID_TOADMAN_UNK1
	.byte $00	; $CE SPRSLOTID_TOGEHERO_SPAWNER_L
	.byte $00	; $CF SPRSLOTID_DIVEMAN_UNK5


	; Sets the bank @ $A000 by Spr_SlotID
PRG058_ObjCodeBankBySlot:
	.byte 59	; $00
	.byte 59	; $01 SPRSLOTID_PLAYER
	.byte 59	; $02 SPRSLOTID_PLAYERSHOT
	.byte 59	; $03 SPRSLOTID_DEFLECTEDSHOT
	.byte 59	; $04 SPRSLOTID_RUSH
	.byte 59	; $05 SPRSLOTID_TOADRAINCAN
	.byte 59	; $06 SPRSLOTID_BALLOON
	.byte 59	; $07 SPRSLOTID_DIVEMISSILE
	.byte 59	; $08 SPRSLOTID_RINGBOOMERANG
	.byte 59	; $09 SPRSLOTID_DRILLBOMB
	.byte 59	; $0A SPRSLOTID_DUSTCRUSHER
	.byte 59	; $0B SPRSLOTID_WIREADAPTER
	.byte 59	; $0C SPRSLOTID_PHARAOHSHOT
	.byte 59	; $0D SPRSLOTID_PHARAOHOVERH
	.byte 59	; $0E
	.byte 59	; $0F SPRSLOTID_SKULLBARRIER
	.byte 59	; $10 SPRSLOTID_TAKETETNO
	.byte 59	; $11 SPRSLOTID_TAKETETNO_PROP
	.byte 59	; $12 SPRSLOTID_HOVER
	.byte 59	; $13 SPRSLOTID_TOMBOY
	.byte 59	; $14 SPRSLOTID_SASOREENU
	.byte 59	; $15 SPRSLOTID_SASOREENU_SPAWNER
	.byte 59	; $16 SPRSLOTID_BATTAN
	.byte 59	; $17
	.byte 59	; $18 SPRSLOTID_SWALLOWN
	.byte 59	; $19 SPRSLOTID_COSWALLOWN
	.byte 59	; $1A SPRSLOTID_WALLBLASTER
	.byte 59	; $1B SPRSLOTID_WALLBLASTER_SHOT
	.byte 59	; $1C SPRSLOTID_100WATTON
	.byte 59	; $1D SPRSLOTID_100WATTON_SHOT
	.byte 59	; $1E SPRSLOTID_100WATTON_SHOT_BURST
	.byte 59	; $1F SPRSLOTID_RATTON
	.byte 61	; $20 SPRSLOTID_RMRAINBOW_CTL1
	.byte 61	; $21 SPRSLOTID_RMRAINBOW_CTL2
	.byte 61	; $22 SPRSLOTID_RMRAINBOW_CTL3
	.byte 61	; $23 SPRSLOTID_RMRAINBOW_CTL4
	.byte 61	; $24 SPRSLOTID_SUBBOSS_KABATONCUE
	.byte 61	; $25 SPRSLOTID_KABATONCUE_MISSILE
	.byte 61	; $26 SPRSLOTID_RINGMAN_UNK2
	.byte 53	; $27 SPRSLOTID_WILY_ESCAPEPOD
	.byte 59	; $28 SPRSLOTID_BOMBABLE_WALL
	.byte 53	; $29 SPRSLOTID_MOTHRAYA_DIE
	.byte 53	; $2A SPRSLOTID_POWERGAIN_ORBS
	.byte 61	; $2B SPRSLOTID_SUBBOSS_ESCAROO
	.byte 61	; $2C SPRSLOTID_ESCAROO_BOMB
	.byte 61	; $2D SPRSLOTID_ESCAROO_DIE
	.byte 61	; $2E SPRSLOTID_EXPLODEYBIT
	.byte 61	; $2F SPRSLOTID_RED_UTRACK_PLAT
	.byte 59	; $30 SPRSLOTID_SUBBOSS_WHOPPER
	.byte 59	; $31 SPRSLOTID_SUBBOSS_WHOPPER_RING
	.byte 59	; $32 SPRSLOTID_SUBBOSS_WHOPPER_RIN2
	.byte 59	; $33 SPRSLOTID_HAEHAEY
	.byte 59	; $34 SPRSLOTID_HAEHAEY_SHOT
	.byte 59	; $35 SPRSLOTID_RACKASER
	.byte 59	; $36 SPRSLOTID_RACKASER_UMBRELLA
	.byte 59	; $37 SPRSLOTID_DOMPAN
	.byte 59	; $38 SPRSLOTID_DOMPAN_FIREWORKS
	.byte 59	; $39 SPRSLOTID_CIRCLEBULLET
	.byte 61	; $3A SPRSLOTID_WHOPPER_DIE
	.byte 59	; $3B SPRSLOTID_CIRCULAREXPLOSION
	.byte 59	; $3C SPRSLOTID_CEXPLOSION
	.byte 59	; $3D SPRSLOTID_MINOAN
	.byte 59	; $3E SPRSLOTID_SUPERBALLMACHJR_L
	.byte 59	; $3F SPRSLOTID_SUPERBALLMACHJR_B
	.byte 59	; $40 SPRSLOTID_BOULDER_DISPENSER
	.byte 59	; $41 SPRSLOTID_BOULDER_DEBRIS
	.byte 59	; $42 SPRSLOTID_EDDIE
	.byte 59	; $43 SPRSLOTID_EDDIE_IMMEDIATE
	.byte 59	; $44 SPRSLOTID_EDDIE_ITEM_EJECT
	.byte 53	; $45 SPRSLOTID_CRPLATFORM_FALL
	.byte 59	; $46 SPRSLOTID_JUMPBIG
	.byte 59	; $47
	.byte 59	; $48 SPRSLOTID_SHIELDATTACKER
	.byte 53	; $49 SPRSLOTID_COSSACK3BOSS1_DIE
	.byte 53	; $4A SPRSLOTID_COSSACK3BOSS2_DIE
	.byte 61	; $4B SPRSLOTID_KABATONCUE_DIE
	.byte 61	; $4C SPRSLOTID_100WATTON_DIE
	.byte 53	; $4D SPRSLOTID_WILYCAPSULE_CHRG
	.byte 59	; $4E SPRSLOTID_TOTEMPOLEN
	.byte 59	; $4F SPRSLOTID_TOTEMPOLEN_SHOT
	.byte 59	; $50 SPRSLOTID_METALL_1
	.byte 59	; $51 SPRSLOTID_METALL_BULLET
	.byte 61	; $52 SPRSLOTID_SUBBOSS_MOBY
	.byte 61	; $53 SPRSLOTID_MOBY_MISSILE
	.byte 61	; $54 SPRSLOTID_MOBY_BIGSPIKE
	.byte 61	; $55
	.byte 59	; $56 SPRSLOTID_METALL_2
	.byte 61	; $57
	.byte 61	; $58
	.byte 61	; $59
	.byte 61	; $5A
	.byte 61	; $5B SPRSLOTID_SWITCH
	.byte 59	; $5C SPRSLOTID_METALL_3
	.byte 53	; $5D SPRSLOTID_SINKINGPLATFORM
	.byte 61	; $5E SPRSLOTID_DUSTMAN_CRUSHERACT
	.byte 59	; $5F SPRSLOTID_M422A
	.byte 59	; $60 SPRSLOTID_CINESTUFF
	.byte 59	; $61 SPRSLOTID_PUYOYON
	.byte 59	; $62 SPRSLOTID_SKELETONJOE
	.byte 59	; $63 SPRSLOTID_SKELETONJOE_BONE
	.byte 59	; $64 SPRSLOTID_RINGRING
	.byte 59	; $65 SPRSLOTID_METALL_4
	.byte 59	; $66 SPRSLOTID_METALL_4_BUBBLE
	.byte 59	; $67 SPRSLOTID_WILY1_UNK1
	.byte 59	; $68
	.byte 59	; $69 SPRSLOTID_SKULLMET_R
	.byte 59	; $6A SPRSLOTID_SKULLMET_BULLET
	.byte 61	; $6B SPRSLOTID_DIVEMAN_BIDIW1
	.byte 61	; $6C SPRSLOTID_DIVEMAN_BIDIW2
	.byte 59	; $6D SPRSLOTID_HELIPON
	.byte 59	; $6E SPRSLOTID_HELIPON_BULLET
	.byte 61	; $6F SPRSLOTID_WATERSPLASH
	.byte 59	; $70 SPRSLOTID_GYOTOT
	.byte 56	; $71 SPRSLOTID_BOSSSKULL
	.byte 56	; $72 SPRSLOTID_SKULLMAN_BULLET
	.byte 61	; $73 SPRSLOTID_DUSTMAN_4PLAT
	.byte 61	; $74 SPRSLOTID_DUSTMAN_PLATSEG
	.byte 56	; $75 SPRSLOTID_BOSSRING
	.byte 56	; $76 SPRSLOTID_RINGMAN_RING
	.byte 53	; $77 SPRSLOTID_BOSSDEATH
	.byte 59	; $78 SPRSLOTID_BIREE1
	.byte 56	; $79 SPRSLOTID_BOSSDUST
	.byte 56	; $7A SPRSLOTID_DUSTMAN_DUSTCRUSHER
	.byte 56	; $7B SPRSLOTID_DUSTMAN_DUSTDEBRIS
	.byte 56	; $7C SPRSLOTID_BOSSDIVE
	.byte 56	; $7D SPRSLOTID_BOSSDIVE_MISSILE
	.byte 56	; $7E SPRSLOTID_BOSSDRILL
	.byte 56	; $7F SPRSLOTID_DRILLMAN_DRILL
	.byte 59	; $80 SPRSLOTID_MISCSTUFF
	.byte 59	; $81 SPRSLOTID_BOSSINTRO
	.byte 56	; $82 SPRSLOTID_DRILLMAN_POOF
	.byte 59	; $83
	.byte 56	; $84 SPRSLOTID_BOSSPHARAOH
	.byte 56	; $85 SPRSLOTID_PHARAOHMAN_ATTACK
	.byte 56	; $86 SPRSLOTID_PHARAOHMAN_SATTACK
	.byte 61	; $87 SPRSLOTID_BOSS_MOTHRAYA
	.byte 61	; $88 SPRSLOTID_COSSACK1_UNK1
	.byte 61	; $89 SPRSLOTID_COSSACK1_UNK2
	.byte 61	; $8A SPRSLOTID_MOTHRAYA_SHOT
	.byte 56	; $8B SPRSLOTID_BOSSBRIGHT
	.byte 56	; $8C SPRSLOTID_BOSSBRIGHT_BULLET
	.byte 56	; $8D SPRSLOTID_BOSSTOAD
	.byte 59	; $8E SPRSLOTID_BATTONTON
	.byte 59	; $8F SPRSLOTID_MOTHRAYA_DEBRIS
	.byte 61	; $90 SPRSLOTID_EXPLODEY_DEATH
	.byte 59	; $91 SPRSLOTID_MANTAN
	.byte 61	; $92 SPRSLOTID_BOSS_COSSACKCATCH
	.byte 61	; $93 SPRSLOTID_COSSACK4_UNK1
	.byte 61	; $94
	.byte 61	; $95 SPRSLOTID_BOSS_SQUAREMACHINE
	.byte 61	; $96 SPRSLOTID_SQUAREMACH_PLATFORM
	.byte 61	; $97 SPRSLOTID_SQUAREMACHINE_SHOT
	.byte 59	; $98 SPRANM4_BOULDER
	.byte 59	; $99 SPRSLOTID_COSSACK2_UNK2
	.byte 59	; $9A SPRSLOTID_MUMMIRA
	.byte 59	; $9B SPRSLOTID_MUMMIRAHEAD
	.byte 59	; $9C SPRSLOTID_IMORM
	.byte 59	; $9D SPRSLOTID_ENEMYEXPLODE
	.byte 56	; $9E SPRSLOTID_COSSACK3BOSS1
	.byte 56	; $9F SPRSLOTID_COSSACK3BOSS2_SHOT
	.byte 56	; $A0 SPRSLOTID_COSSACK3BOSS1_SHOT
	.byte 59	; $A1 SPRSLOTID_MONOROADER
	.byte 56	; $A2 SPRSLOTID_COSSACK3BOSS2
	.byte 53	; $A3 SPRSLOTID_KALINKA
	.byte 53	; $A4 SPRSLOTID_PROTOMAN
	.byte 53	; $A5 SPRSLOTID_WILY
	.byte 53	; $A6 SPRSLOTID_BOSS_METALLDADDY
	.byte 59	; $A7 SPRSLOTID_GACHAPPON
	.byte 59	; $A8 SPRSLOTID_GACHAPPON_BULLET
	.byte 59	; $A9 SPRSLOTID_GACHAPPON_GASHAPON
	.byte 53	; $AA SPRSLOTID_METALLDADDY_METALL
	.byte 53	; $AB SPRSLOTID_BOSS_TAKOTRASH
	.byte 53	; $AC SPRSLOTID_WILY2_UNK1
	.byte 53	; $AD SPRSLOTID_TAKOTRASH_BALL
	.byte 53	; $AE SPRSLOTID_TAKOTRASH_FIREBALL
	.byte 53	; $AF SPRSLOTID_TAKOTRASH_PLATFORM
	.byte 59	; $B0 SPRSLOTID_PAKATTO24
	.byte 59	; $B1 SPRSLOTID_PAKATTO24_SHOT
	.byte 59	; $B2 SPRSLOTID_UPNDOWN
	.byte 53	; $B3 SPRSLOTID_WILYTRANSPORTER
	.byte 59	; $B4 SPRSLOTID_UPNDOWN_SPAWNER
	.byte 59	; $B5 SPRSLOTID_SPIKEBLOCK_1
	.byte 59	; $B6 SPRSLOTID_SEAMINE
	.byte 59	; $B7 SPRSLOTID_GARYOBY
	.byte 53	; $B8 SPRSLOTID_BOSS_ROBOTMASTER
	.byte 59	; $B9 SPRSLOTID_DOCRON
	.byte 59	; $BA SPRSLOTID_DOCRON_SKULL
	.byte 53	; $BB SPRSLOTID_WILY3_UNK1
	.byte 53	; $BC SPRSLOTID_BOSS_WILYMACHINE4
	.byte 59	; $BD SPRSLOTID_TOGEHERO_SPAWNER_R
	.byte 59	; $BE SPRSLOTID_TOGEHERO
	.byte 53	; $BF SPRSLOTID_WILYMACHINE4_SHOTCH
	.byte 53	; $C0 SPRSLOTID_WILYMACHINE4_PHASE2
	.byte 59	; $C1 SPRSLOTID_ITEM_PICKUP
	.byte 59	; $C2 SPRSLOTID_SPECWPN_PICKUP
	.byte 53	; $C3 SPRSLOTID_WILY1_DISPBLOCKS
	.byte 53	; $C4 SPRSLOTID_BOSS_WILYCAPSULE
	.byte 53	; $C5 SPRSLOTID_WILYCAPSULE_SHOT
	.byte 59	; $C6 SPRSLOTID_ITEM_PICKUP_GRAVITY
	.byte 59	; $C7 SPRSLOTID_LADDERPRESS_R
	.byte 59	; $C8 SPRSLOTID_DOMPAN_INTERWORK
	.byte 61	; $C9 SPRSLOTID_GREEN_UTRACK_PLAT
	.byte 59	; $CA SPRSLOTID_LADDERPRESS_L
	.byte 53	; $CB SPRSLOTID_WILYCAPSULE_DIE
	.byte 59	; $CC SPRSLOTID_DRILLMAN_POOF_ALT
	.byte 59	; $CD SPRSLOTID_TOADMAN_UNK1
	.byte 59	; $CE SPRSLOTID_TOGEHERO_SPAWNER_L
	.byte 61	; $CF SPRSLOTID_DIVEMAN_UNK5


PRG058_ObjCodePtrBySlotL:
	.byte LOW(PRG058_Obj00)					; $00
	.byte LOW(PRG058_Obj_Player)			; $01 SPRSLOTID_PLAYER
	.byte LOW(PRG058_Obj_PlayerShot)		; $02 SPRSLOTID_PLAYERSHOT
	.byte LOW(PRG058_Obj_DeflectedShot)					; $03 SPRSLOTID_DEFLECTEDSHOT
	.byte LOW(PRG058_Obj_Rush)				; $04 SPRSLOTID_RUSH
	.byte LOW(PRG058_Obj_ToadRainCanister)	; $05 SPRSLOTID_TOADRAINCAN
	.byte LOW(PRG058_Obj_Balloon)			; $06 SPRSLOTID_BALLOON
	.byte LOW(PRG058_Obj_DiveMissile)		; $07 SPRSLOTID_DIVEMISSILE
	.byte LOW(PRG058_Obj_RingBoomerang)		; $08 SPRSLOTID_RINGBOOMERANG
	.byte LOW(PRG058_Obj_DrillBomb)			; $09 SPRSLOTID_DRILLBOMB
	.byte LOW(PRG058_Obj_DustCrusher)		; $0A SPRSLOTID_DUSTCRUSHER
	.byte LOW(PRG058_Obj_WireAdapter)		; $0B SPRSLOTID_WIREADAPTER
	.byte LOW(PRG058_Obj_PharaohShot)		; $0C SPRSLOTID_PHARAOHSHOT
	.byte LOW(PRG058_Obj_PharaohShOvrhead)	; $0D SPRSLOTID_PHARAOHOVERH
	.byte LOW(PRG058_Obj0E)					; $0E
	.byte LOW(PRG058_Obj_SkullBarrier)		; $0F SPRSLOTID_SKULLBARRIER
	.byte LOW(PRG058_Obj_Taketetno)			; $10 SPRSLOTID_TAKETETNO
	.byte LOW(PRG058_Obj_TaketetnoProp)		; $11 SPRSLOTID_TAKETETNO_PROP
	.byte LOW(PRG058_Obj_Hover)				; $12 SPRSLOTID_HOVER
	.byte LOW(PRG058_Obj_Tomboy)			; $13 SPRSLOTID_TOMBOY
	.byte LOW(PRG058_Obj_Sasoreenu)			; $14 SPRSLOTID_SASOREENU
	.byte LOW(PRG058_Obj_SasoreenuSpawner)	; $15 SPRSLOTID_SASOREENU_SPAWNER
	.byte LOW(PRG058_Obj_Battan)			; $16 SPRSLOTID_BATTAN
	.byte LOW(PRG058_Obj17)					; $17
	.byte LOW(PRG058_Obj_Swallown)			; $18 SPRSLOTID_SWALLOWN
	.byte LOW(PRG058_Obj_Coswallown)		; $19 SPRSLOTID_COSWALLOWN
	.byte LOW(PRG058_Obj_WallBlaster)		; $1A SPRSLOTID_WALLBLASTER
	.byte LOW(PRG058_Obj_WallBlaster_Shot)	; $1B SPRSLOTID_WALLBLASTER_SHOT
	.byte LOW(PRG058_Obj_100Watton)			; $1C SPRSLOTID_100WATTON
	.byte LOW(PRG058_Obj_100Watton_Shot)	; $1D SPRSLOTID_100WATTON_SHOT
	.byte LOW(PRG058_Obj_100Watton_ShotBurst)	; $1E SPRSLOTID_100WATTON_SHOT_BURST
	.byte LOW(PRG058_Obj_Ratton)			; $1F SPRSLOTID_RATTON
	.byte LOW(PRG061_Obj_RMRainbowCtl1)		; $20 SPRSLOTID_RMRAINBOW_CTL1
	.byte LOW(PRG061_Obj_RMRainbowCtl2)		; $21 SPRSLOTID_RMRAINBOW_CTL2
	.byte LOW(PRG061_Obj_RMRainbowCtl3)		; $22 SPRSLOTID_RMRAINBOW_CTL3
	.byte LOW(PRG061_Obj_RMRainbowCtl4)		; $23 SPRSLOTID_RMRAINBOW_CTL4
	.byte LOW(PRG061_Obj_SubBoss_Kabatoncue)	; $24 SPRSLOTID_SUBBOSS_KABATONCUE
	.byte LOW(PRG061_Obj_Kabatoncue_Missile)	; $25 SPRSLOTID_KABATONCUE_MISSILE
	.byte LOW(PRG058_Obj_RingMan_UNK2)		; $26 SPRSLOTID_RINGMAN_UNK2
	.byte LOW(PRG053_Obj_WilyEscapePod)		; $27 SPRSLOTID_WILY_ESCAPEPOD
	.byte LOW(PRG058_Obj_BombableWall)		; $28 SPRSLOTID_BOMBABLE_WALL
	.byte LOW(PRG053_Obj_Mothraya_Die)		; $29 SPRSLOTID_MOTHRAYA_DIE
	.byte LOW(PRG053_Obj_PowerGainOrbs)		; $2A SPRSLOTID_POWERGAIN_ORBS
	.byte LOW(PRG061_Obj_SubBoss_Escaroo)	; $2B SPRSLOTID_SUBBOSS_ESCAROO
	.byte LOW(PRG061_Obj_Escaroo_Bomb)		; $2C SPRSLOTID_ESCAROO_BOMB
	.byte LOW(PRG061_Obj_Escaroo_Die)		; $2D SPRSLOTID_ESCAROO_DIE
	.byte LOW(PRG061_Obj_ExplodeyBit)		; $2E SPRSLOTID_EXPLODEYBIT
	.byte LOW(PRG061_Obj_Red_UTrackPlat)	; $2F SPRSLOTID_RED_UTRACK_PLAT
	.byte LOW(PRG058_Obj_SubBoss_Whopper)	; $30 SPRSLOTID_SUBBOSS_WHOPPER
	.byte LOW(PRG058_Obj_Whopper_Rings)		; $31 SPRSLOTID_SUBBOSS_WHOPPER_RING
	.byte LOW(PRG058_Obj_Whopper_Ring)		; $32 SPRSLOTID_SUBBOSS_WHOPPER_RIN2
	.byte LOW(PRG058_Obj_Haehaey)			; $33 SPRSLOTID_HAEHAEY
	.byte LOW(PRG058_Obj_Haehaey_Shot)		; $34 SPRSLOTID_HAEHAEY_SHOT
	.byte LOW(PRG058_Obj_Rackaser)			; $35 SPRSLOTID_RACKASER
	.byte LOW(PRG058_Obj_Rackaser_Umb)		; $36 SPRSLOTID_RACKASER_UMBRELLA
	.byte LOW(PRG058_Obj_Dompan)			; $37 SPRSLOTID_DOMPAN
	.byte LOW(PRG058_Obj_DompanFireworks)	; $38 SPRSLOTID_DOMPAN_FIREWORKS
	.byte LOW(PRG058_Obj_CircleBullet)		; $39 SPRSLOTID_CIRCLEBULLET
	.byte LOW(PRG061_Obj_WhopperDie)		; $3A SPRSLOTID_WHOPPER_DIE
	.byte LOW(PRG058_Obj_CircularExplosion)	; $3B SPRSLOTID_CIRCULAREXPLOSION
	.byte LOW(PRG058_Obj_CExplosion)		; $3C SPRSLOTID_CEXPLOSION
	.byte LOW(PRG059_Obj_Minoan)			; $3D SPRSLOTID_MINOAN
	.byte LOW(PRG059_Obj_SuperballMachineJr)	; $3E SPRSLOTID_SUPERBALLMACHJR_L
	.byte LOW(PRG058_Obj_SBM_Ball)			; $3F SPRSLOTID_SUPERBALLMACHJR_B
	.byte LOW(PRG059_Obj_BoulderDispenser)	; $40 SPRSLOTID_BOULDER_DISPENSER
	.byte LOW(PRG059_Obj_BoulderDebris)		; $41 SPRSLOTID_BOULDER_DEBRIS
	.byte LOW(PRG059_Obj_Eddie)				; $42 SPRSLOTID_EDDIE
	.byte LOW(PRG059_Obj_EddieImm)			; $43 SPRSLOTID_EDDIE_IMMEDIATE
	.byte LOW(PRG059_Obj_EddieItem)			; $44 SPRSLOTID_EDDIE_ITEM_EJECT
	.byte LOW(PRG053_Obj_CRPlatFall)		; $45 SPRSLOTID_CRPLATFORM_FALL
	.byte LOW(PRG059_Obj_JumpBig)			; $46 SPRSLOTID_JUMPBIG
	.byte LOW(PRG058_Obj47)					; $47
	.byte LOW(PRG059_Obj_ShieldAttacker)	; $48 SPRSLOTID_SHIELDATTACKER
	.byte LOW(PRG053_Obj_Cossack3Boss1Die)	; $49 SPRSLOTID_COSSACK3BOSS1_DIE
	.byte LOW(PRG053_Obj_Cossack3Boss2Die)	; $4A SPRSLOTID_COSSACK3BOSS2_DIE
	.byte LOW(PRG061_Obj_Kabatoncue_Die)	; $4B SPRSLOTID_KABATONCUE_DIE
	.byte LOW(PRG061_Obj_100Watton_Die)		; $4C SPRSLOTID_100WATTON_DIE
	.byte LOW(PRG053_Obj_WilyCapShotCharge)		; $4D SPRSLOTID_WILYCAPSULE_CHRG
	.byte LOW(PRG059_Obj_Totempolen)		; $4E SPRSLOTID_TOTEMPOLEN
	.byte LOW(PRG059_Obj_Totempolen_Shot)	; $4F SPRSLOTID_TOTEMPOLEN_SHOT
	.byte LOW(PRG059_Obj_Metall1)			; $50 SPRSLOTID_METALL_1
	.byte LOW(PRG059_Obj_MetallBullet)		; $51 SPRSLOTID_METALL_BULLET
	.byte LOW(PRG061_Obj_SubBoss_Moby)		; $52 SPRSLOTID_SUBBOSS_MOBY
	.byte LOW(PRG061_Obj_Moby_Missile)		; $53 SPRSLOTID_MOBY_MISSILE
	.byte LOW(PRG061_Obj_Moby_BigSpike)		; $54 SPRSLOTID_MOBY_BIGSPIKE
	.byte LOW(PRG061_Obj55)					; $55
	.byte LOW(PRG059_Obj_Metall2)			; $56 SPRSLOTID_METALL_2
	.byte LOW(PRG061_Obj57)					; $57
	.byte LOW(PRG061_Obj58)					; $58
	.byte LOW(PRG061_Obj59)					; $59
	.byte LOW(PRG061_Obj5A)					; $5A
	.byte LOW(PRG061_Obj_DrillManSwitch)	; $5B SPRSLOTID_SWITCH
	.byte LOW(PRG059_Obj_Metall3)			; $5C SPRSLOTID_METALL_3
	.byte LOW(PRG053_Obj_SinkingPlatform)	; $5D SPRSLOTID_SINKINGPLATFORM
	.byte LOW(PRG061_Obj_DustmanCrusherAct)	; $5E SPRSLOTID_DUSTMAN_CRUSHERACT
	.byte LOW(PRG059_Obj_M422A)				; $5F SPRSLOTID_M422A
	.byte LOW(PRG058_Obj_CineStuff)			; $60 SPRSLOTID_CINESTUFF
	.byte LOW(PRG059_Obj_Puyoyon)			; $61 SPRSLOTID_PUYOYON
	.byte LOW(PRG059_Obj_SkeletonJoe)		; $62 SPRSLOTID_SKELETONJOE
	.byte LOW(PRG059_Obj_SkelJoeBone)		; $63 SPRSLOTID_SKELETONJOE_BONE
	.byte LOW(PRG059_Obj_Ringring)			; $64 SPRSLOTID_RINGRING
	.byte LOW(PRG059_Obj_Metall4)			; $65 SPRSLOTID_METALL_4
	.byte LOW(PRG059_Obj_Metall4_Bubble)	; $66 SPRSLOTID_METALL_4_BUBBLE
	.byte LOW(PRG058_Obj_Wily1_UNK)			; $67 SPRSLOTID_WILY1_UNK1
	.byte LOW(PRG059_Obj68)					; $68
	.byte LOW(PRG059_Obj_SkullMet)			; $69 SPRSLOTID_SKULLMET_R
	.byte LOW(PRG059_Obj_SkullMet_Bullet)	; $6A SPRSLOTID_SKULLMET_BULLET
	.byte LOW(PRG061_Obj_DiveMan_BidiWtr1)	; $6B SPRSLOTID_DIVEMAN_BIDIW1
	.byte LOW(PRG061_Obj_DiveMan_BidiWtr2)	; $6C SPRSLOTID_DIVEMAN_BIDIW2
	.byte LOW(PRG059_Obj_Helipon)			; $6D SPRSLOTID_HELIPON
	.byte LOW(PRG059_Obj_HeliponBullet)		; $6E SPRSLOTID_HELIPON_BULLET
	.byte LOW(PRG061_Obj_WaterSplash)		; $6F SPRSLOTID_WATERSPLASH
	.byte LOW(PRG059_Obj_Gyotot)			; $70 SPRSLOTID_GYOTOT
	.byte LOW(PRG056_Obj_BossSkull)			; $71 SPRSLOTID_BOSSSKULL
	.byte LOW(PRG056_Obj_SkullManBullet)	; $72 SPRSLOTID_SKULLMAN_BULLET
	.byte LOW(PRG061_Obj_DustMan_4Plat)		; $73 SPRSLOTID_DUSTMAN_4PLAT
	.byte LOW(PRG061_Obj_DM4Plat_Seg)		; $74 SPRSLOTID_DUSTMAN_PLATSEG
	.byte LOW(PRG056_Obj_BossRing)			; $75 SPRSLOTID_BOSSRING
	.byte LOW(PRG056_Obj_RingManRing)		; $76 SPRSLOTID_RINGMAN_RING
	.byte LOW(PRG053_Obj_BossDeathCtl)		; $77 SPRSLOTID_BOSSDEATH
	.byte LOW(PRG059_Obj_Biree)				; $78 SPRSLOTID_BIREE1
	.byte LOW(PRG056_Obj_BossDust)			; $79 SPRSLOTID_BOSSDUST
	.byte LOW(PRG056_Obj_DustManCrusher)	; $7A SPRSLOTID_DUSTMAN_DUSTCRUSHER
	.byte LOW(PRG056_Obj_DustManCrusherD)	; $7B SPRSLOTID_DUSTMAN_DUSTDEBRIS
	.byte LOW(PRG056_Obj_BossDive)			; $7C SPRSLOTID_BOSSDIVE
	.byte LOW(PRG056_Obj_BossDiveMissile)	; $7D SPRSLOTID_BOSSDIVE_MISSILE
	.byte LOW(PRG056_Obj_BossDrill)			; $7E SPRSLOTID_BOSSDRILL
	.byte LOW(PRG056_Obj_DrillManDrill)		; $7F SPRSLOTID_DRILLMAN_DRILL
	.byte LOW(PRG058_Obj_MiscStuff)			; $80 SPRSLOTID_MISCSTUFF
	.byte LOW(PRG058_Obj_BossIntro)			; $81 SPRSLOTID_BOSSINTRO
	.byte LOW(PRG056_Obj_DrillManPoof)		; $82 SPRSLOTID_DRILLMAN_POOF
	.byte LOW(PRG058_Obj_SpiralExplosion)	; $83 SPRSLOTID_SPIRALEXPLOSION
	.byte LOW(PRG056_Obj_BossPharaoh)		; $84 SPRSLOTID_BOSSPHARAOH
	.byte LOW(PRG056_Obj_PharaohAttack)		; $85 SPRSLOTID_PHARAOHMAN_ATTACK
	.byte LOW(PRG056_Obj_PharManSmAtk)		; $86 SPRSLOTID_PHARAOHMAN_SATTACK
	.byte LOW(PRG061_Obj_BossMothraya)		; $87 SPRSLOTID_BOSS_MOTHRAYA
	.byte LOW(PRG061_Obj_Cossack1_UNK1)		; $88 SPRSLOTID_COSSACK1_UNK1
	.byte LOW(PRG061_Obj_Cossack1_UNK2)		; $89 SPRSLOTID_COSSACK1_UNK2
	.byte LOW(PRG061_Obj_Mothraya_Shot)		; $8A SPRSLOTID_MOTHRAYA_SHOT
	.byte LOW(PRG056_Obj_BossBright)		; $8B SPRSLOTID_BOSSBRIGHT
	.byte LOW(PRG056_Obj_BrightManBullet)	; $8C SPRSLOTID_BOSSBRIGHT_BULLET
	.byte LOW(PRG056_Obj_BossToad)			; $8D SPRSLOTID_BOSSTOAD
	.byte LOW(PRG059_Obj_Battonton)			; $8E SPRSLOTID_BATTONTON
	.byte LOW(PRG059_Obj_MothrayaDebris)	; $8F SPRSLOTID_MOTHRAYA_DEBRIS
	.byte LOW(PRG061_Obj_ExplodeyDeath)		; $90 SPRSLOTID_EXPLODEY_DEATH
	.byte LOW(PRG059_Obj_Mantan)			; $91 SPRSLOTID_MANTAN
	.byte LOW(PRG061_Obj_CossackCatcher)	; $92 SPRSLOTID_BOSS_COSSACKCATCH
	.byte LOW(PRG061_Obj_Cossack4_UNK1)		; $93 SPRSLOTID_COSSACK4_UNK1
	.byte LOW(PRG061_Obj94)					; $94
	.byte LOW(PRG061_Obj_BossSquareMachine)	; $95 SPRSLOTID_BOSS_SQUAREMACHINE
	.byte LOW(PRG061_Obj_SqrMachPlatform)		; $96 SPRSLOTID_SQUAREMACH_PLATFORM
	.byte LOW(PRG061_Obj_SquareMachShot)	; $97 SPRSLOTID_SQUAREMACHINE_SHOT
	.byte LOW(PRG059_Obj_Boulder)			; $98 SPRANM4_BOULDER
	.byte LOW(PRG058_Obj_Cossack2_UNK2)		; $99 SPRSLOTID_COSSACK2_UNK2
	.byte LOW(PRG059_Obj_Mummira)			; $9A SPRSLOTID_MUMMIRA
	.byte LOW(PRG059_Obj_MummiraHead)		; $9B SPRSLOTID_MUMMIRAHEAD
	.byte LOW(PRG059_Obj_Imorm)				; $9C SPRSLOTID_IMORM
	.byte LOW(PRG059_Obj_EnemyExplode)		; $9D SPRSLOTID_ENEMYEXPLODE
	.byte LOW(PRG056_Obj_BossCockroachTwin1)	; $9E SPRSLOTID_COSSACK3BOSS1
	.byte LOW(PRG056_Obj_BossCockroach2Shot)	; $9F SPRSLOTID_COSSACK3BOSS2_SHOT
	.byte LOW(PRG056_Obj_BossCockroach1Shot)	; $A0 SPRSLOTID_COSSACK3BOSS1_SHOT
	.byte LOW(PRG059_Obj_MonoRoader)		; $A1 SPRSLOTID_MONOROADER
	.byte LOW(PRG056_Obj_BossCockroachTwin2)	; $A2 SPRSLOTID_COSSACK3BOSS2
	.byte LOW(PRG053_Obj_Kalinka)			; $A3 SPRSLOTID_KALINKA
	.byte LOW(PRG053_Obj_Protoman)			; $A4 SPRSLOTID_PROTOMAN
	.byte LOW(PRG053_Obj_Wily)				; $A5 SPRSLOTID_WILY
	.byte LOW(PRG053_Obj_BossMetallDaddy)	; $A6 SPRSLOTID_BOSS_METALLDADDY
	.byte LOW(PRG059_Obj_Gachappon)			; $A7 SPRSLOTID_GACHAPPON
	.byte LOW(PRG059_Obj_GachapponBullet)	; $A8 SPRSLOTID_GACHAPPON_BULLET
	.byte LOW(PRG059_Obj_GachapponGashapon)		; $A9 SPRSLOTID_GACHAPPON_GASHAPON
	.byte LOW(PRG053_Obj_MetallDaddyMetall)		; $AA SPRSLOTID_METALLDADDY_METALL
	.byte LOW(PRG053_Obj_BossTakotrash)		; $AB SPRSLOTID_BOSS_TAKOTRASH
	.byte LOW(PRG058_Obj_Wily2_UNK1)		; $AC SPRSLOTID_WILY2_UNK1
	.byte LOW(PRG053_Obj_TakotrashBall)		; $AD SPRSLOTID_TAKOTRASH_BALL
	.byte LOW(PRG053_Obj_TakotrashFireball)		; $AE SPRSLOTID_TAKOTRASH_FIREBALL
	.byte LOW(PRG053_Obj_TakotrashPlatform)		; $AF SPRSLOTID_TAKOTRASH_PLATFORM
	.byte LOW(PRG059_Obj_Pakatto24)			; $B0 SPRSLOTID_PAKATTO24
	.byte LOW(PRG059_Obj_Pakatto24_Shot)	; $B1 SPRSLOTID_PAKATTO24_SHOT
	.byte LOW(PRG059_Obj_UpNDown)			; $B2 SPRSLOTID_UPNDOWN
	.byte LOW(PRG053_Obj_WilyTransporter)	; $B3 SPRSLOTID_WILYTRANSPORTER
	.byte LOW(PRG059_Obj_UpNDown_Spawner)	; $B4 SPRSLOTID_UPNDOWN_SPAWNER
	.byte LOW(PRG059_Obj_SpikeBlock)		; $B5 SPRSLOTID_SPIKEBLOCK_1
	.byte LOW(PRG059_Obj_SeaMine)			; $B6 SPRSLOTID_SEAMINE
	.byte LOW(PRG059_Obj_Garyoby)			; $B7 SPRSLOTID_GARYOBY
	.byte LOW(PRG053_Obj_BossRobotMaster)	; $B8 SPRSLOTID_BOSS_ROBOTMASTER
	.byte LOW(PRG059_Obj_Docron)			; $B9 SPRSLOTID_DOCRON
	.byte LOW(PRG059_Obj_DocronSkull)		; $BA SPRSLOTID_DOCRON_SKULL
	.byte LOW(PRG058_Obj_Wily3_UNK1)		; $BB SPRSLOTID_WILY3_UNK1
	.byte LOW(PRG053_Obj_WilyMachineFour)	; $BC SPRSLOTID_BOSS_WILYMACHINE4
	.byte LOW(PRG059_Obj_Togehero_SpawnerR)	; $BD SPRSLOTID_TOGEHERO_SPAWNER_R
	.byte LOW(PRG059_Obj_Togehero)			; $BE SPRSLOTID_TOGEHERO
	.byte LOW(PRG053_Obj_WM4_ChargeShot)	; $BF SPRSLOTID_WILYMACHINE4_SHOTCH
	.byte LOW(PRG053_Obj_WilyMachineFour_P2)	; $C0 SPRSLOTID_WILYMACHINE4_PHASE2
	.byte LOW(PRG059_Obj_PlayerItems)		; $C1 SPRSLOTID_ITEM_PICKUP
	.byte LOW(PRG059_Obj_ItemBonusWeapons)	; $C2 SPRSLOTID_SPECWPN_PICKUP
	.byte LOW(PRG053_Obj_Wily1_DisappearBlks)	; $C3 SPRSLOTID_WILY1_DISPBLOCKS
	.byte LOW(PRG053_Obj_BossWilyCapsule)	; $C4 SPRSLOTID_BOSS_WILYCAPSULE
	.byte LOW(PRG053_Obj_WilyCapsule_Shot)	; $C5 SPRSLOTID_WILYCAPSULE_SHOT
	.byte LOW(PRG059_Obj_ItemWithGrav)		; $C6 SPRSLOTID_ITEM_PICKUP_GRAVITY
	.byte LOW(PRG059_Obj_LadderPressR)		; $C7 SPRSLOTID_LADDERPRESS_R
	.byte LOW(PRG058_Obj_DompanDeath)		; $C8 SPRSLOTID_DOMPAN_INTERWORK
	.byte LOW(PRG061_Obj_Green_UTrackPlat)	; $C9 SPRSLOTID_GREEN_UTRACK_PLAT
	.byte LOW(PRG059_Obj_LadderPressL)		; $CA SPRSLOTID_LADDERPRESS_L
	.byte LOW(PRG053_Obj_WilyCapsuleDie)	; $CB SPRSLOTID_WILYCAPSULE_DIE
	.byte LOW(PRG058_Obj_DrillManPoofAlt)	; $CC SPRSLOTID_DRILLMAN_POOF_ALT
	.byte LOW(PRG058_Obj_ToadMan_UNK1)		; $CD SPRSLOTID_TOADMAN_UNK1
	.byte LOW(PRG059_Obj_Togehero_SpawnerL)		; $CE SPRSLOTID_TOGEHERO_SPAWNER_L
	.byte LOW(PRG061_Obj_DiveMan_UNK5)		; $CF SPRSLOTID_DIVEMAN_UNK5



PRG058_ObjCodePtrBySlotH:
	.byte HIGH(PRG058_Obj00)				; $00
	.byte HIGH(PRG058_Obj_Player)			; $01 SPRSLOTID_PLAYER
	.byte HIGH(PRG058_Obj_PlayerShot)		; $02 SPRSLOTID_PLAYERSHOT
	.byte HIGH(PRG058_Obj_DeflectedShot)				; $03 SPRSLOTID_DEFLECTEDSHOT
	.byte HIGH(PRG058_Obj_Rush)				; $04 SPRSLOTID_RUSH
	.byte HIGH(PRG058_Obj_ToadRainCanister)	; $05 SPRSLOTID_TOADRAINCAN
	.byte HIGH(PRG058_Obj_Balloon)			; $06 SPRSLOTID_BALLOON
	.byte HIGH(PRG058_Obj_DiveMissile)		; $07 SPRSLOTID_DIVEMISSILE
	.byte HIGH(PRG058_Obj_RingBoomerang)	; $08 SPRSLOTID_RINGBOOMERANG
	.byte HIGH(PRG058_Obj_DrillBomb)		; $09 SPRSLOTID_DRILLBOMB
	.byte HIGH(PRG058_Obj_DustCrusher)		; $0A SPRSLOTID_DUSTCRUSHER
	.byte HIGH(PRG058_Obj_WireAdapter)		; $0B SPRSLOTID_WIREADAPTER
	.byte HIGH(PRG058_Obj_PharaohShot)		; $0C SPRSLOTID_PHARAOHSHOT
	.byte HIGH(PRG058_Obj_PharaohShOvrhead)	; $0D SPRSLOTID_PHARAOHOVERH
	.byte HIGH(PRG058_Obj0E)				; $0E
	.byte HIGH(PRG058_Obj_SkullBarrier)		; $0F SPRSLOTID_SKULLBARRIER
	.byte HIGH(PRG058_Obj_Taketetno)		; $10 SPRSLOTID_TAKETETNO
	.byte HIGH(PRG058_Obj_TaketetnoProp)	; $11 SPRSLOTID_TAKETETNO_PROP
	.byte HIGH(PRG058_Obj_Hover)			; $12 SPRSLOTID_HOVER
	.byte HIGH(PRG058_Obj_Tomboy)			; $13 SPRSLOTID_TOMBOY
	.byte HIGH(PRG058_Obj_Sasoreenu)		; $14 SPRSLOTID_SASOREENU
	.byte HIGH(PRG058_Obj_SasoreenuSpawner)	; $15 SPRSLOTID_SASOREENU_SPAWNER
	.byte HIGH(PRG058_Obj_Battan)			; $16 SPRSLOTID_BATTAN
	.byte HIGH(PRG058_Obj17)				; $17
	.byte HIGH(PRG058_Obj_Swallown)			; $18 SPRSLOTID_SWALHIGHN
	.byte HIGH(PRG058_Obj_Coswallown)		; $19 SPRSLOTID_COSWALLOWN
	.byte HIGH(PRG058_Obj_WallBlaster)		; $1A SPRSLOTID_WALLBLASTER
	.byte HIGH(PRG058_Obj_WallBlaster_Shot)	; $1B SPRSLOTID_WALLBLASTER_SHOT
	.byte HIGH(PRG058_Obj_100Watton)		; $1C SPRSLOTID_100WATTON
	.byte HIGH(PRG058_Obj_100Watton_Shot)	; $1D SPRSLOTID_100WATTON_SHOT
	.byte HIGH(PRG058_Obj_100Watton_ShotBurst)	; $1E SPRSLOTID_100WATTON_SHOT_BURST
	.byte HIGH(PRG058_Obj_Ratton)			; $1F SPRSLOTID_RATTON
	.byte HIGH(PRG061_Obj_RMRainbowCtl1)	; $20 SPRSLOTID_RMRAINBOW_CTL1
	.byte HIGH(PRG061_Obj_RMRainbowCtl2)	; $21 SPRSLOTID_RMRAINBOW_CTL2
	.byte HIGH(PRG061_Obj_RMRainbowCtl3)	; $22 SPRSLOTID_RMRAINBOW_CTL3
	.byte HIGH(PRG061_Obj_RMRainbowCtl4)	; $23 SPRSLOTID_RMRAINBOW_CTL4
	.byte HIGH(PRG061_Obj_SubBoss_Kabatoncue)	; $24 SPRSLOTID_SUBBOSS_KABATONCUE
	.byte HIGH(PRG061_Obj_Kabatoncue_Missile)	; $25 SPRSLOTID_KABATONCUE_MISSILE
	.byte HIGH(PRG058_Obj_RingMan_UNK2)		; $26 SPRSLOTID_RINGMAN_UNK2
	.byte HIGH(PRG053_Obj_WilyEscapePod)	; $27 SPRSLOTID_WILY_ESCAPEPOD
	.byte HIGH(PRG058_Obj_BombableWall)		; $28 SPRSLOTID_BOMBABLE_WALL
	.byte HIGH(PRG053_Obj_Mothraya_Die)		; $29 SPRSLOTID_MOTHRAYA_DIE
	.byte HIGH(PRG053_Obj_PowerGainOrbs)	; $2A SPRSLOTID_POWERGAIN_ORBS
	.byte HIGH(PRG061_Obj_SubBoss_Escaroo)	; $2B SPRSLOTID_SUBBOSS_ESCAROO
	.byte HIGH(PRG061_Obj_Escaroo_Bomb)		; $2C SPRSLOTID_ESCAROO_BOMB
	.byte HIGH(PRG061_Obj_Escaroo_Die)		; $2D SPRSLOTID_ESCAROO_DIE
	.byte HIGH(PRG061_Obj_ExplodeyBit)		; $2E SPRSLOTID_EXPLODEYBIT
	.byte HIGH(PRG061_Obj_Red_UTrackPlat)	; $2F SPRSLOTID_RED_UTRACK_PLAT
	.byte HIGH(PRG058_Obj_SubBoss_Whopper)	; $30 SPRSLOTID_SUBBOSS_WHOPPER
	.byte HIGH(PRG058_Obj_Whopper_Rings)	; $31 SPRSLOTID_SUBBOSS_WHOPPER_RING
	.byte HIGH(PRG058_Obj_Whopper_Ring)		; $32 SPRSLOTID_SUBBOSS_WHOPPER_RIN2
	.byte HIGH(PRG058_Obj_Haehaey)			; $33 SPRSLOTID_HAEHAEY
	.byte HIGH(PRG058_Obj_Haehaey_Shot)		; $34 SPRSLOTID_HAEHAEY_SHOT
	.byte HIGH(PRG058_Obj_Rackaser)			; $35 SPRSLOTID_RACKASER
	.byte HIGH(PRG058_Obj_Rackaser_Umb)		; $36 SPRSLOTID_RACKASER_UMBRELLA
	.byte HIGH(PRG058_Obj_Dompan)			; $37 SPRSLOTID_DOMPAN
	.byte HIGH(PRG058_Obj_DompanFireworks)	; $38 SPRSLOTID_DOMPAN_FIREWORKS
	.byte HIGH(PRG058_Obj_CircleBullet)		; $39 SPRSLOTID_CIRCLEBULLET
	.byte HIGH(PRG061_Obj_WhopperDie)		; $3A SPRSLOTID_WHOPPER_DIE
	.byte HIGH(PRG058_Obj_CircularExplosion)	; $3B SPRSLOTID_CIRCULAREXPLOSION
	.byte HIGH(PRG058_Obj_CExplosion)		; $3C SPRSLOTID_CEXPLOSION
	.byte HIGH(PRG059_Obj_Minoan)			; $3D SPRSLOTID_MINOAN
	.byte HIGH(PRG059_Obj_SuperballMachineJr)	; $3E SPRSLOTID_SUPERBALLMACHJR_L
	.byte HIGH(PRG058_Obj_SBM_Ball)			; $3F SPRSLOTID_SUPERBALLMACHJR_B
	.byte HIGH(PRG059_Obj_BoulderDispenser)	; $40 SPRSLOTID_BOULDER_DISPENSER
	.byte HIGH(PRG059_Obj_BoulderDebris)	; $41 SPRSLOTID_BOULDER_DEBRIS
	.byte HIGH(PRG059_Obj_Eddie)			; $42 SPRSLOTID_EDDIE
	.byte HIGH(PRG059_Obj_EddieImm)			; $43 SPRSLOTID_EDDIE_IMMEDIATE
	.byte HIGH(PRG059_Obj_EddieItem)		; $44 SPRSLOTID_EDDIE_ITEM_EJECT
	.byte HIGH(PRG053_Obj_CRPlatFall)		; $45 SPRSLOTID_CRPLATFORM_FALL
	.byte HIGH(PRG059_Obj_JumpBig)			; $46 SPRSLOTID_JUMPBIG
	.byte HIGH(PRG058_Obj47)				; $47
	.byte HIGH(PRG059_Obj_ShieldAttacker)	; $48 SPRSLOTID_SHIELDATTACKER
	.byte HIGH(PRG053_Obj_Cossack3Boss1Die)	; $49 SPRSLOTID_COSSACK3BOSS1_DIE
	.byte HIGH(PRG053_Obj_Cossack3Boss2Die)	; $4A SPRSLOTID_COSSACK3BOSS2_DIE
	.byte HIGH(PRG061_Obj_Kabatoncue_Die)	; $4B SPRSLOTID_KABATONCUE_DIE
	.byte HIGH(PRG061_Obj_100Watton_Die)	; $4C SPRSLOTID_100WATTON_DIE
	.byte HIGH(PRG053_Obj_WilyCapShotCharge)	; $4D SPRSLOTID_WILYCAPSULE_CHRG
	.byte HIGH(PRG059_Obj_Totempolen)		; $4E SPRSLOTID_TOTEMPOLEN
	.byte HIGH(PRG059_Obj_Totempolen_Shot)	; $4F SPRSLOTID_TOTEMPOLEN_SHOT
	.byte HIGH(PRG059_Obj_Metall1)			; $50 SPRSLOTID_METALL_1
	.byte HIGH(PRG059_Obj_MetallBullet)		; $51 SPRSLOTID_METALL_BULLET
	.byte HIGH(PRG061_Obj_SubBoss_Moby)		; $52 SPRSLOTID_SUBBOSS_MOBY
	.byte HIGH(PRG061_Obj_Moby_Missile)		; $53 SPRSLOTID_MOBY_MISSILE
	.byte HIGH(PRG061_Obj_Moby_BigSpike)	; $54 SPRSLOTID_MOBY_BIGSPIKE
	.byte HIGH(PRG061_Obj55)				; $55
	.byte HIGH(PRG059_Obj_Metall2)			; $56 SPRSLOTID_METALL_2
	.byte HIGH(PRG061_Obj57)				; $57
	.byte HIGH(PRG061_Obj58)				; $58
	.byte HIGH(PRG061_Obj59)				; $59
	.byte HIGH(PRG061_Obj5A)				; $5A
	.byte HIGH(PRG061_Obj_DrillManSwitch)	; $5B SPRSLOTID_SWITCH
	.byte HIGH(PRG059_Obj_Metall3)			; $5C SPRSLOTID_METALL_3
	.byte HIGH(PRG053_Obj_SinkingPlatform)	; $5D SPRSLOTID_SINKINGPLATFORM
	.byte HIGH(PRG061_Obj_DustmanCrusherAct)	; $5E SPRSLOTID_DUSTMAN_CRUSHERACT
	.byte HIGH(PRG059_Obj_M422A)			; $5F SPRSLOTID_M422A
	.byte HIGH(PRG058_Obj_CineStuff)		; $60 SPRSLOTID_CINESTUFF
	.byte HIGH(PRG059_Obj_Puyoyon)			; $61 SPRSLOTID_PUYOYON
	.byte HIGH(PRG059_Obj_SkeletonJoe)		; $62 SPRSLOTID_SKELETONJOE
	.byte HIGH(PRG059_Obj_SkelJoeBone)		; $63 SPRSLOTID_SKELETONJOE_BONE
	.byte HIGH(PRG059_Obj_Ringring)			; $64 SPRSLOTID_RINGRING
	.byte HIGH(PRG059_Obj_Metall4)			; $65 SPRSLOTID_METALL_4
	.byte HIGH(PRG059_Obj_Metall4_Bubble)	; $66 SPRSLOTID_METALL_4_BUBBLE
	.byte HIGH(PRG058_Obj_Wily1_UNK)		; $67 SPRSLOTID_WILY1_UNK1
	.byte HIGH(PRG059_Obj68)				; $68
	.byte HIGH(PRG059_Obj_SkullMet)			; $69 SPRSLOTID_SKULLMET_R
	.byte HIGH(PRG059_Obj_SkullMet_Bullet)	; $6A SPRSLOTID_SKULLMET_BULLET
	.byte HIGH(PRG061_Obj_DiveMan_BidiWtr1)	; $6B SPRSLOTID_DIVEMAN_BIDIW1
	.byte HIGH(PRG061_Obj_DiveMan_BidiWtr2)	; $6C SPRSLOTID_DIVEMAN_BIDIW2
	.byte HIGH(PRG059_Obj_Helipon)			; $6D SPRSLOTID_HELIPON
	.byte HIGH(PRG059_Obj_HeliponBullet)	; $6E SPRSLOTID_HELIPON_BULLET
	.byte HIGH(PRG061_Obj_WaterSplash)		; $6F SPRSLOTID_WATERSPLASH
	.byte HIGH(PRG059_Obj_Gyotot)			; $70 SPRSLOTID_GYOTOT
	.byte HIGH(PRG056_Obj_BossSkull)		; $71 SPRSLOTID_BOSSSKULL
	.byte HIGH(PRG056_Obj_SkullManBullet)	; $72 SPRSLOTID_SKULLMAN_BULLET
	.byte HIGH(PRG061_Obj_DustMan_4Plat)	; $73 SPRSLOTID_DUSTMAN_4PLAT
	.byte HIGH(PRG061_Obj_DM4Plat_Seg)		; $74 SPRSLOTID_DUSTMAN_PLATSEG
	.byte HIGH(PRG056_Obj_BossRing)			; $75 SPRSLOTID_BOSSRING
	.byte HIGH(PRG056_Obj_RingManRing)		; $76 SPRSLOTID_RINGMAN_RING
	.byte HIGH(PRG053_Obj_BossDeathCtl)		; $77 SPRSLOTID_BOSSDEATH
	.byte HIGH(PRG059_Obj_Biree)			; $78 SPRSLOTID_BIREE1
	.byte HIGH(PRG056_Obj_BossDust)			; $79 SPRSLOTID_BOSSDUST
	.byte HIGH(PRG056_Obj_DustManCrusher)	; $7A SPRSLOTID_DUSTMAN_DUSTCRUSHER
	.byte HIGH(PRG056_Obj_DustManCrusherD)	; $7B SPRSLOTID_DUSTMAN_DUSTDEBRIS
	.byte HIGH(PRG056_Obj_BossDive)			; $7C SPRSLOTID_BOSSDIVE
	.byte HIGH(PRG056_Obj_BossDiveMissile)	; $7D SPRSLOTID_BOSSDIVE_MISSILE
	.byte HIGH(PRG056_Obj_BossDrill)		; $7E SPRSLOTID_BOSSDRILL
	.byte HIGH(PRG056_Obj_DrillManDrill)	; $7F SPRSLOTID_DRILLMAN_DRILL
	.byte HIGH(PRG058_Obj_MiscStuff)		; $80 SPRSLOTID_MISCSTUFF
	.byte HIGH(PRG058_Obj_BossIntro)		; $81 SPRSLOTID_BOSSINTRO
	.byte HIGH(PRG056_Obj_DrillManPoof)		; $82 SPRSLOTID_DRILLMAN_POOF
	.byte HIGH(PRG058_Obj_SpiralExplosion)	; $83 SPRSLOTID_SPIRALEXPLOSION
	.byte HIGH(PRG056_Obj_BossPharaoh)		; $84 SPRSLOTID_BOSSPHARAOH
	.byte HIGH(PRG056_Obj_PharaohAttack)	; $85 SPRSLOTID_PHARAOHMAN_ATTACK
	.byte HIGH(PRG056_Obj_PharManSmAtk)		; $86 SPRSLOTID_PHARAOHMAN_SATTACK
	.byte HIGH(PRG061_Obj_BossMothraya)		; $87 SPRSLOTID_BOSS_MOTHRAYA
	.byte HIGH(PRG061_Obj_Cossack1_UNK1)	; $88 SPRSLOTID_COSSACK1_UNK1
	.byte HIGH(PRG061_Obj_Cossack1_UNK2)	; $89 SPRSLOTID_COSSACK1_UNK2
	.byte HIGH(PRG061_Obj_Mothraya_Shot)	; $8A SPRSLOTID_MOTHRAYA_SHOT
	.byte HIGH(PRG056_Obj_BossBright)		; $8B SPRSLOTID_BOSSBRIGHT
	.byte HIGH(PRG056_Obj_BrightManBullet)	; $8C SPRSLOTID_BOSSBRIGHT_BULLET
	.byte HIGH(PRG056_Obj_BossToad)			; $8D SPRSLOTID_BOSSTOAD
	.byte HIGH(PRG059_Obj_Battonton)		; $8E SPRSLOTID_BATTONTON
	.byte HIGH(PRG059_Obj_MothrayaDebris)	; $8F SPRSLOTID_MOTHRAYA_DEBRIS
	.byte HIGH(PRG061_Obj_ExplodeyDeath)	; $90 SPRSLOTID_EXPLODEY_DEATH
	.byte HIGH(PRG059_Obj_Mantan)			; $91 SPRSLOTID_MANTAN
	.byte HIGH(PRG061_Obj_CossackCatcher)	; $92 SPRSLOTID_BOSS_COSSACKCATCH
	.byte HIGH(PRG061_Obj_Cossack4_UNK1)	; $93 SPRSLOTID_COSSACK4_UNK1
	.byte HIGH(PRG061_Obj94)				; $94
	.byte HIGH(PRG061_Obj_BossSquareMachine)	; $95 SPRSLOTID_BOSS_SQUAREMACHINE
	.byte HIGH(PRG061_Obj_SqrMachPlatform)	; $96 SPRSLOTID_SQUAREMACH_PLATFORM
	.byte HIGH(PRG061_Obj_SquareMachShot)	; $97 SPRSLOTID_SQUAREMACHINE_SHOT
	.byte HIGH(PRG059_Obj_Boulder)			; $98 SPRANM4_BOULDER
	.byte HIGH(PRG058_Obj_Cossack2_UNK2)	; $99 SPRSLOTID_COSSACK2_UNK2
	.byte HIGH(PRG059_Obj_Mummira)			; $9A SPRSLOTID_MUMMIRA
	.byte HIGH(PRG059_Obj_MummiraHead)		; $9B SPRSLOTID_MUMMIRAHEAD
	.byte HIGH(PRG059_Obj_Imorm)			; $9C SPRSLOTID_IMORM
	.byte HIGH(PRG059_Obj_EnemyExplode)		; $9D SPRSLOTID_ENEMYEXPLODE
	.byte HIGH(PRG056_Obj_BossCockroachTwin1)	; $9E SPRSLOTID_COSSACK3BOSS1
	.byte HIGH(PRG056_Obj_BossCockroach2Shot)	; $9F SPRSLOTID_COSSACK3BOSS2_SHOT
	.byte HIGH(PRG056_Obj_BossCockroach1Shot)	; $A0 SPRSLOTID_COSSACK3BOSS1_SHOT
	.byte HIGH(PRG059_Obj_MonoRoader)		; $A1 SPRSLOTID_MONOROADER
	.byte HIGH(PRG056_Obj_BossCockroachTwin2)	; $A2 SPRSLOTID_COSSACK3BOSS2
	.byte HIGH(PRG053_Obj_Kalinka)			; $A3 SPRSLOTID_KALINKA
	.byte HIGH(PRG053_Obj_Protoman)			; $A4 SPRSLOTID_PROTOMAN
	.byte HIGH(PRG053_Obj_Wily)				; $A5 SPRSLOTID_WILY
	.byte HIGH(PRG053_Obj_BossMetallDaddy)	; $A6 SPRSLOTID_BOSS_METALLDADDY
	.byte HIGH(PRG059_Obj_Gachappon)		; $A7 SPRSLOTID_GACHAPPON
	.byte HIGH(PRG059_Obj_GachapponBullet)	; $A8 SPRSLOTID_GACHAPPON_BULLET
	.byte HIGH(PRG059_Obj_GachapponGashapon)	; $A9 SPRSLOTID_GACHAPPON_GASHAPON
	.byte HIGH(PRG053_Obj_MetallDaddyMetall)	; $AA SPRSLOTID_METALLDADDY_METALL
	.byte HIGH(PRG053_Obj_BossTakotrash)	; $AB SPRSLOTID_BOSS_TAKOTRASH
	.byte HIGH(PRG058_Obj_Wily2_UNK1)		; $AC SPRSLOTID_WILY2_UNK1
	.byte HIGH(PRG053_Obj_TakotrashBall)	; $AD SPRSLOTID_TAKOTRASH_BALL
	.byte HIGH(PRG053_Obj_TakotrashFireball)	; $AE SPRSLOTID_TAKOTRASH_FIREBALL
	.byte HIGH(PRG053_Obj_TakotrashPlatform)	; $AF SPRSLOTID_TAKOTRASH_PLATFORM
	.byte HIGH(PRG059_Obj_Pakatto24)		; $B0 SPRSLOTID_PAKATTO24
	.byte HIGH(PRG059_Obj_Pakatto24_Shot)	; $B1 SPRSLOTID_PAKATTO24_SHOT
	.byte HIGH(PRG059_Obj_UpNDown)			; $B2 SPRSLOTID_UPNDOWN
	.byte HIGH(PRG053_Obj_WilyTransporter)	; $B3 SPRSLOTID_WILYTRANSPORTER
	.byte HIGH(PRG059_Obj_UpNDown_Spawner)	; $B4 SPRSLOTID_UPNDOWN_SPAWNER
	.byte HIGH(PRG059_Obj_SpikeBlock)		; $B5 SPRSLOTID_SPIKEBLOCK_1
	.byte HIGH(PRG059_Obj_SeaMine)			; $B6 SPRSLOTID_SEAMINE
	.byte HIGH(PRG059_Obj_Garyoby)			; $B7 SPRSLOTID_GARYOBY
	.byte HIGH(PRG053_Obj_BossRobotMaster)	; $B8 SPRSLOTID_BOSS_ROBOTMASTER
	.byte HIGH(PRG059_Obj_Docron)			; $B9 SPRSLOTID_DOCRON
	.byte HIGH(PRG059_Obj_DocronSkull)		; $BA SPRSLOTID_DOCRON_SKULL
	.byte HIGH(PRG058_Obj_Wily3_UNK1)		; $BB SPRSLOTID_WILY3_UNK1
	.byte HIGH(PRG053_Obj_WilyMachineFour)	; $BC SPRSLOTID_BOSS_WILYMACHINE4
	.byte HIGH(PRG059_Obj_Togehero_SpawnerR)	; $BD SPRSLOTID_TOGEHERO_SPAWNER_R
	.byte HIGH(PRG059_Obj_Togehero)			; $BE SPRSLOTID_TOGEHERO
	.byte HIGH(PRG053_Obj_WM4_ChargeShot)	; $BF SPRSLOTID_WILYMACHINE4_SHOTCH
	.byte HIGH(PRG053_Obj_WilyMachineFour_P2)	; $C0 SPRSLOTID_WILYMACHINE4_PHASE2
	.byte HIGH(PRG059_Obj_PlayerItems)		; $C1 SPRSLOTID_ITEM_PICKUP
	.byte HIGH(PRG059_Obj_ItemBonusWeapons)	; $C2 SPRSLOTID_SPECWPN_PICKUP
	.byte HIGH(PRG053_Obj_Wily1_DisappearBlks)	; $C3 SPRSLOTID_WILY1_DISPBLOCKS
	.byte HIGH(PRG053_Obj_BossWilyCapsule)	; $C4 SPRSLOTID_BOSS_WILYCAPSULE
	.byte HIGH(PRG053_Obj_WilyCapsule_Shot)	; $C5 SPRSLOTID_WILYCAPSULE_SHOT
	.byte HIGH(PRG059_Obj_ItemWithGrav)		; $C6 SPRSLOTID_ITEM_PICKUP_GRAVITY
	.byte HIGH(PRG059_Obj_LadderPressR)		; $C7 SPRSLOTID_LADDERPRESS_R
	.byte HIGH(PRG058_Obj_DompanDeath)		; $C8 SPRSLOTID_DOMPAN_INTERWORK
	.byte HIGH(PRG061_Obj_Green_UTrackPlat)	; $C9 SPRSLOTID_GREEN_UTRACK_PLAT
	.byte HIGH(PRG059_Obj_LadderPressL)		; $CA SPRSLOTID_LADDERPRESS_L
	.byte HIGH(PRG053_Obj_WilyCapsuleDie)	; $CB
	.byte HIGH(PRG058_Obj_DrillManPoofAlt)	; $CC SPRSLOTID_DRILLMAN_POOF_ALT
	.byte HIGH(PRG058_Obj_ToadMan_UNK1)		; $CD SPRSLOTID_TOADMAN_UNK1
	.byte HIGH(PRG059_Obj_Togehero_SpawnerL)	; $CE SPRSLOTID_TOGEHERO_SPAWNER_L
	.byte HIGH(PRG061_Obj_DiveMan_UNK5)		; $CF SPRSLOTID_DIVEMAN_UNK5


PRG058_Obj00:
PRG058_Obj_Player:
PRG058_Obj_CineStuff:
PRG058_Obj_MiscStuff:
PRG058_Obj_BossIntro:
PRG058_Obj_DrillManPoofAlt:
	RTS	; $8823


PRG058_Obj_RingMan_UNK2:
PRG058_Obj_BombableWall:
PRG058_Obj_Wily1_UNK:
PRG058_Obj_Cossack2_UNK2:
PRG058_Obj_Wily2_UNK1:
PRG058_Obj_Wily3_UNK1:
PRG058_Obj_ToadMan_UNK1:
	RTS	; $8824


PRG058_Obj_PlayerShot:
	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM2_MBUSTSHOTBURST
	BNE PRG058_8844	; If this is not the Mega Buster full-charge burst (from initial release), jump to PRG058_8844

	LDY Spr_Frame+$00,X	; Y = frame
	
	LDA PRG058_PShotMBFCBurst_XVelFrac,Y
	STA Spr_XVelFrac+$00,X
	LDA PRG058_PShotMBFCBurst_XVel,Y
	STA Spr_XVel+$00,X
	
	CPY #$05
	BNE PRG058_8844	; If frame < 5, jump to PRG058_8844

	; Change to the actual Mega Buster shot!
	LDA #SPRANM2_MBUSTSHOTFULL
	JSR PRG063_SetSpriteAnim

PRG058_8844:
	JSR PRG063_ApplyVelSetFaceDir
	JSR PRG058_ShootOutDustCrushBlocks

PRG058_884A:
	RTS	; $884A


PRG058_ShootOutDustCrushBlocks:
	LDA <Raster_VMode
	CMP #RVMODE_DUSTMANCRUSH
	BNE PRG058_884A	; If this is not the Dust Man Crusher segment, jump to PRG058_884A (RTS)

	LDA DustManCrsh_BlkShotOutScr
	BNE PRG058_884A

	; Check if hit Dust Man shootable block
	LDY #$02
	JSR PRG062_ObjDetFloorAttrs

	LDA <Level_TileAttrsDetected+$00
	CMP #TILEATTR_DUSTSHOOTABLE
	BNE PRG058_884A	; If this is not one of the shootable Dust Man blocks, jump to PRG058_884A (RTS)

	LDA Spr_X+$00,X
	SUB <Horz_Scroll
	CMP #$F0
	BGE PRG058_884A	; If object X >= $F0, jump to PRG058_884A (RTS)

	CMP #$18
	BLT PRG058_884A	; If object X < $18, jump to PRG058_884A (RTS)

	LDA Spr_XHi+$00,X
	STA DustManCrsh_BlkShotOutScr
	
	LDA <MetaBlk_Index
	STA DustManCrsh_BlkShotOutMeta

	LDA <Temp_Var3
	STA DustManCrsh_BlkShotOutCol
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG058_88A7	; If no empty object slot, jump to PRG058_88A7

	LDA #SPRANM4_SMALLPOOFEXP
	JSR PRG063_CopySprSlotSetAnim

	LDA #SPRSLOTID_MISCSTUFF
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_Flags2+$00,Y
	
	; Center X over tile
	LDA Spr_X+$00,Y
	AND #$F0
	ORA #$08
	STA Spr_X+$00,Y
	
	; Center Y over tile
	LDA Spr_Y+$00,Y
	AND #$F0
	ORA #$08
	STA Spr_Y+$00,Y

PRG058_88A7:
	LDA Spr_SlotID+$00,X
	CMP #SPRSLOTID_RINGBOOMERANG
	BEQ PRG058_88BC	; If this is Ring Boomerang, jump to PRG058_88BC

	; Mega Buster shots jump to PRG058_88BC
	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM2_MBUSTSHOTBURST
	BEQ PRG058_88BC
	CMP #SPRANM2_MBUSTSHOTFULL
	BEQ PRG058_88BC

	; Most projectiles are destroyed by the Dust Man block shootout
	JSR PRG062_ResetSpriteSlot

PRG058_88BC:
	RTS	; $88BC


PRG058_PShotMBFCBurst_XVelFrac:
	.byte $00, $00, $00, $00, $00, $00

PRG058_PShotMBFCBurst_XVel:
	.byte $00, $00, $00, $0C, $08, $05


PRG058_Obj_DeflectedShot:
	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM2_DUSTCRUSHER
	BNE PRG058_88D8	; If this is not Dust Crusher, jump to PRG058_88D8

	LDA #$00
	STA Spr_AnimTicks+$00,X
	STA Spr_Frame+$00,X

PRG058_88D8:
	JSR PRG063_ApplyVelSetFaceDir
	JMP PRG063_DoMoveVertOnlyH16


PRG058_Obj_Rush:
	LDY <Player_CurWeapon	; Y = Player_CurWeapon (to select the Rush mode)
	
	; Set Rush's code pointer
	LDA PRG058_Obj_RushJumpTable_L-1,Y
	STA Spr_CodePtrL+$00,X
	STA <Temp_Var0
	LDA PRG058_Obj_RushJumpTable_H-1,Y
	STA Spr_CodePtrH+$00,X
	STA <Temp_Var1
	
	JMP [Temp_Var0]	; Jump to the proper Rush code


PRG058_Obj_RushCoil:

	; Hold animation while Rush is coming down
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	; Detect floor
	LDY #$15	; Y = $15 (index into PRG062_TDetFloorOffSpread)
	JSR PRG062_ObjDetFloorAttrs

	LDA <Temp_Var16
	AND #TILEATTR_SOLID
	BNE PRG058_890E	; If Rush hit solid ground, jump to PRG058_890E

	LDA Spr_Y+$00
	SUB #32
	
	CMP Spr_Y+$00,X
	BLT PRG058_8911	; If Rush is at or below the Player, jump to PRG058_8911


PRG058_890E:
	JMP PRG063_DoMoveSimpleVert


PRG058_8911:
	LDY #$00
	JSR PRG063_DoObjVertMovement

	BCC PRG058_894A	; If Rush hasn't hit floor, jump to PRG058_894A (RTS)
	BCS PRG058_8940	; Otherwise, jump to PRG058_8940


PRG058_Obj_RushJet:
	; Hold animation while Rush is coming down
	LDA #$00
	STA Spr_AnimTicks+$00,X

	JSR PRG063_DoMoveSimpleVert

	LDA Spr_Y+$00
	SUB Spr_Y+$00,X
	BCC PRG058_892F		; If Rush Jet hasn't fallen lower than Player, jump to PRG058_892F

	CMP #$0C
	BGE PRG058_894A


PRG058_892F:
	; Detect floor
	LDY #$15	; Y = $15 (index into PRG062_TDetFloorOffSpread)
	JSR PRG062_ObjDetFloorAttrs

	LDA <Temp_Var16
	AND #TILEATTR_SOLID
	BNE PRG058_894A	; If Rush hit solid ground, jump to PRG058_894A (RTS)

	LDA <Level_TileAttr_GreatestDet
	CMP #TILEATTR_WATER
	BEQ PRG058_8973	; If Rush Jet hit water, jump to PRG058_8973


PRG058_8940:

	; Set new code pointer
	LDA #LOW(PRG058_Obj_RushReadyCommon)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Obj_RushReadyCommon)
	STA Spr_CodePtrH+$00,X

PRG058_894A:
	RTS	; $894A


PRG058_Obj_RushMarine:
	; Hold animation while Rush is coming down
	LDA #$00
	STA Spr_AnimTicks+$00,X

	JSR PRG063_DoMoveSimpleVert

	LDA Spr_Y+$00
	SUB Spr_Y+$00,X
	BCC PRG058_8960		; If Rush Marine hasn't fallen lower than Player, jump to PRG058_8960
	
	CMP #$0C
	BGE PRG058_894A

PRG058_8960:
	; Detect floor
	LDY #$15	; Y = $15 (index into PRG062_TDetFloorOffSpread)
	JSR PRG062_ObjDetFloorAttrs

	LDA <Temp_Var16
	AND #TILEATTR_SOLID
	BNE PRG058_894A	; If Rush hit solid ground, jump to PRG058_894A (RTS)
		
	LDA <Level_TileAttr_GreatestDet
	CMP #TILEATTR_WATER
	BNE PRG058_894A		; If Rush Marine has not hit water, jump to PRG058_894A (RTS)
	BEQ PRG058_8940		; Otherwise, jump to PRG058_8940

PRG058_8973:
	; Set animation to teleport out
	LDA #SPRANM2_TELEPORTOUT
	JSR PRG063_SetSpriteAnim

	; Set code pointer for teleporting out
	LDA #LOW(PRG058_Obj_TeleportOut)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Obj_TeleportOut)
	STA Spr_CodePtrH+$00,X
	
	LDA #$00
	STA Spr_Flags2+$00,X
	STA Spr_YVelFrac+$00,X
	STA Spr_YVel+$00,X
	
	LDA Spr_Flags+$00,X
	AND #~(SPRFL1_OBJSOLID | SPRFL1_NOHITMOVEVERT)
	STA Spr_Flags+$00,X
	
	RTS	; $8995


PRG058_Obj_RushReadyCommon:
	LDA Spr_Frame+$00,X
	CMP #$04
	BNE PRG058_89E2	; If frame <> 4, jump to PRG058_89E2 (RTS)

	LDY <Player_CurWeapon
	
	LDA PRG058_8B1D-1,Y
	JSR PRG063_SetSpriteAnim

	LDA PRG058_Rush_BBox-1,Y
	STA Spr_Flags2+$00,X
	
	LDA Spr_Flags+$00,X
	ORA PRG058_Rush_Flags-1,Y
	STA Spr_Flags+$00,X
	
	LDA #LOW(PRG058_RushReadyCommon_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_RushReadyCommon_Cont)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var1/2 = $12C (16-bit counter)
	LDA #$2C
	STA Spr_Var1+$00,X
	LDA #$01
	STA Spr_Var2+$00,X
	
	LDA #SPRDIR_RIGHT
	STA Spr_FaceDir+$00,X
	
	LDA Spr_Flags+$00
	AND #SPR_HFLIP
	BNE PRG058_89D7	; If horizontally flipped, jump to PRG058_89D7

	INC Spr_FaceDir+$00,X	; Set direction left

PRG058_89D7:
	ORA Spr_Flags+$00,X
	STA Spr_Flags+$00,X
	
	LDA #$00
	STA Spr_AnimTicks+$00,X

PRG058_89E2:
	RTS	; $89E2


PRG058_RushReadyCommon_Cont:
	LDY <Player_CurWeapon
	
	; Sub_Var1/2 -= 1
	LDA Spr_Var1+$00,X
	SUB #$01
	STA Spr_Var1+$00,X
	LDA Spr_Var2+$00,X
	SBC #$00
	STA Spr_Var2+$00,X
	
	ORA Spr_Var1+$00,X
	BNE PRG058_89FE	; If Sub_Var1/2 <> 0, jump to PRG058_89FE

	JMP PRG058_8973	; Jump to PRG058_8973


PRG058_89FE:
	LDA PRG058_Rush_ContCodePtr_H-1,Y
	BNE PRG058_8A06	; If code pointer high byte <> $00, jump to PRG058_8A06

	; Technically useless assignment since it falls into another zero-out
	STA Spr_AnimTicks+$00,X

PRG058_8A06:
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	DEC Spr_Y+$00,X
	JSR PRG063_TestPlayerObjCollide
	INC Spr_Y+$00,X
	BCS PRG058_8A5C	; If Player is not touching Rush, jump to PRG058_8A5C (RTS)

	LDY <Player_CurWeapon
	CPY #PLAYERWPN_RUSHMARINE
	BEQ PRG058_8A23	; If this is Rush Marine, jump to PRG058_8A23

	LDA Spr_Frame+$00,X
	ORA <Player_State
	BNE PRG058_8A5C	; If frame <> 0 or Player is not standing, jump to PRG058_8A5C (RTS)


PRG058_8A23:
	LDA PRG058_Rush_ContCodePtr_H-1,Y
	BEQ PRG058_8A37	; If code pointer high byte = $00, jump to PRG058_8A37

	STA Spr_CodePtrH+$00,X
	LDA PRG058_Rush_ContCodePtr_L-1,Y
	STA Spr_CodePtrL+$00,X
	
	; Spr_Var4 = $3C
	LDA #$3C
	STA Spr_Var4+$00,X
	
	RTS	; $8A36


PRG058_8A37:
	; Spr_Var2 = 0
	LDA #$00
	STA Spr_Var2+$00,X
	
	; Spr_Var1 = $1E
	LDA #$1E
	STA Spr_Var1+$00,X
	
	INC Spr_Frame+$00,X	; frame++
	
	LDA #$EE
	STA Spr_YVelFrac+$00
	LDA #$06
	STA Spr_YVel+$00
	
	INC Spr_Var3+$00	; Spr_Var3++
	
	JSR PRG063_WeaponConsumeEnergy	; $8A51

	LDA Spr_Flags+$00,X
	AND #~SPRFL1_NOHITMOVEVERT
	STA Spr_Flags+$00,X

PRG058_8A5C:
	RTS	; $8A5C

PRG058_Obj_TeleportOut:
	LDA Spr_Frame+$00,X
	CMP #$04
	BNE PRG058_8A85		; If teleport-out animation has not reached frame 4, jump to PRG058_8A85 (RTS)

	; Hold teleport animation
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	; Teleport speed upward
	LDA Spr_YVelFrac+$00,X
	ADD #$40
	STA Spr_YVelFrac+$00,X
	LDA Spr_YVel+$00,X
	ADC #$00
	STA Spr_YVel+$00,X
	JSR PRG063_ApplyYVelocityNeg

	LDA Spr_YHi+$00,X
	BEQ PRG058_8A85		; If object hasn't left screen, jump to PRG058_8A85 (RTS)

	; Object has teleported out, delete
	JSR PRG062_ResetSpriteSlot

PRG058_8A85:
	RTS	; $8A85


PRG058_Rush_ContJet:
	LDY #$00	; Y = 0
	
	; Fix Rush Jet to left/right direction only (until we consider Player input)
	LDA Spr_FaceDir+$00,X
	AND #(SPRDIR_LEFT | SPRDIR_RIGHT)
	STA Spr_FaceDir+$00,X
	
	LDA <Ctlr1_Held
	AND #(PAD_LEFT | PAD_RIGHT)
	BEQ PRG058_8A9D	; If not pressing LEFT/RIGHT, jump to PRG058_8A9D

	CMP Spr_FaceDir+$00,X
	BEQ PRG058_8A9D	; If Player is pressing direction that matches Rush Jet's, jump to PRG058_8A9D

	LDY #$02	; Y = 2

PRG058_8A9D:
	LDA <Ctlr1_Held
	AND #(PAD_UP | PAD_DOWN)
	BEQ PRG058_8AAA	; If Player is not pressing UP/DOWN, jump to PRG058_8AAA

	; Apply this direction to Rush Jet
	ORA Spr_FaceDir+$00,X
	STA Spr_FaceDir+$00,X
	
	INY	; Y = 1 or 3

PRG058_8AAA:
	LDA PRG058_RushJet_XVelFrac,Y
	STA Spr_XVelFrac+$00,X
	LDA PRG058_RushJet_XVel,Y
	STA Spr_XVel+$00,X
	
	LDA PRG058_RushJet_YVelFrac,Y
	STA Spr_YVelFrac+$00,X
	LDA PRG058_RushJet_YVel,Y
	STA Spr_YVel+$00,X
	
	DEC Spr_Y+$00,X
	JSR PRG063_TestPlayerObjCollide
	INC Spr_Y+$00,X
	ROR <Temp_Var15	; Carry -> bit 7
	BMI PRG058_8AF8	; If Player is not touching Rush Jet, jump to PRG058_8AF8

	LDA Spr_FaceDir+$00,X
	AND #(SPRDIR_UP | SPRDIR_DOWN)
	BEQ PRG058_8AF8	; If Rush isn't moving up or down, jump to PRG058_8AF8

	AND #SPRDIR_UP
	BEQ PRG058_8AEC	; If Rush is moving down, jump to PRG058_8AEC

	LDA Spr_Y+$00,X
	CMP #$1C
	BLT PRG058_8AF8	; If Rush Jet is too high, jump to PRG058_8AF8

	SBC Spr_Y+$00
	BCC PRG058_8AF8

	CMP #$0E
	BLT PRG058_8AF8

	BCS PRG058_8AF3


PRG058_8AEC:
	LDA Spr_Y+$00,X
	CMP #$E8
	BGE PRG058_8AF8	; If Rush Jet is too low, jump to PRG058_8AF8


PRG058_8AF3:
	; Vertical movement
	LDY #$18
	JSR PRG063_DoMoveVertOnly


PRG058_8AF8:
	; Horizontal movement
	LDY #$24
	JSR PRG063_DoObjMoveSetFaceDir

	BCC PRG058_8B02	; If didn't hit solid, jump to PRG058_8B02


PRG058_8AFF:
	JMP PRG058_8973	; Jump to PRG058_8973


PRG058_8B02:
	DEC Spr_Var4+$00,X	; Spr_Var4--
	BNE PRG058_8B15		; If Spr_Var4 > 0, jump to PRG058_8B15

	JSR PRG063_WeaponConsumeEnergy

	LDA <Player_WpnEnergy+1
	AND #$7F
	BEQ PRG058_8AFF	; If no energy left, jump to PRG058_8AFF

	; Spr_Var4 = $3C
	LDA #$3C
	STA Spr_Var4+$00,X

PRG058_8B15:
	LDA <Temp_Var15
	BMI PRG058_8B1C	; If Player is not touching Rush Jet, jump to PRG058_8B1C (RTS)

	JSR PRG063_MovePlayerWithObj

PRG058_8B1C:
	RTS	; $8B1C

PRG058_8B1D:
	.byte SPRANM2_RUSHCOIL, SPRANM2_RUSHJET, SPRANM2_RUSHMARINE

PRG058_Rush_BBox:
	.byte $0E, $1D, $00

PRG058_Rush_Flags:
	.byte SPRFL1_NOHITMOVEVERT, SPRFL1_NOHITMOVEVERT, $00

PRG058_Obj_RushJumpTable_L:
	.byte LOW(PRG058_Obj_RushCoil)
	.byte LOW(PRG058_Obj_RushJet)
	.byte LOW(PRG058_Obj_RushMarine)

PRG058_Obj_RushJumpTable_H:
	.byte HIGH(PRG058_Obj_RushCoil)
	.byte HIGH(PRG058_Obj_RushJet)
	.byte HIGH(PRG058_Obj_RushMarine)
	
PRG058_Rush_ContCodePtr_L:
	.byte $00, LOW(PRG058_Rush_ContJet), LOW(PRG058_Rush_ContMarine)

PRG058_Rush_ContCodePtr_H:
	.byte $00, HIGH(PRG058_Rush_ContJet), HIGH(PRG058_Rush_ContMarine)


PRG058_RushJet_XVelFrac:
	.byte $4C, $33, $00, $B5


PRG058_RushJet_XVel:
	.byte $01, $01, $01, $00


PRG058_RushJet_YVelFrac:
	.byte $00, $7F, $00, $B5


PRG058_RushJet_YVel:
	.byte $00, $00, $00, $00
	
	
PRG058_Rush_ContMarine:
	LDA <Player_State
	CMP #PLAYERSTATE_SLIDING
	BGE PRG058_8B94		; If Player is not standing or jumping/falling, jump to PRG058_8B94 (RTS)
	
	JSR PRG063_TestPlayerObjCollide
	BCS PRG058_8B94		; If Player isn't touching Rush Marine, jump to PRG058_8B94
	
	LDA #PLAYERSTATE_RUSHMARINE
	STA <Player_State
	
	; Player Spr_Var8 = $3C
	LDA #$3C
	STA Spr_Var8+$00
	
	LDA #SPRANM2_RUSHMARINECLOSE
	
	LDY #$00
	STY <Player_ShootAnimTimer
	STY <Player_CurShootAnim
	
	JSR PRG063_SetSpriteAnimY
	
	; Lock Player at Rush Marine's position
	LDA Spr_Y+$00,X
	STA Spr_Y+$00
	
	LDA Spr_YHi+$00,X
	STA Spr_YHi+$00
	
	LDA Spr_X+$00,X
	STA Spr_X+$00
	STA <RAM_0027
	
	LDA Spr_XHi+$00,X
	STA Spr_XHi+$00
	STA <RAM_0028
	
	LDA Spr_Flags+$00,X
	ORA #SPRFL1_NODRAW
	STA Spr_Flags+$00,X
	
	LDA #LOW(PRG058_8B95)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_8B95)
	STA Spr_CodePtrH+$00,X
	
	; Queue Rush Marine graphics load
	LDA #$16
	JSR PRG062_CHRRAMDynLoadPalSeg

PRG058_8B94:
	RTS

PRG058_8B95:
	JSR PRG063_CHRRAMDynLoadCHRSegSafe
	
	LDA Spr_CurrentAnim
	CMP #SPRANM2_RUSHMARINERIDE
	BNE PRG058_8BA2		; If Player is not already in Rush Marine's riding animation, jump to PRG058_8BA2 (RTS)
	
	JSR PRG062_ResetSpriteSlot

PRG058_8BA2:
	RTS


PRG058_Obj_ToadRainCanister:
	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM2_TOADRAINCAN
	BNE PRG058_8BBF	; If canister's animation <> SPRANM2_TOADRAINCAN, jump to PRG058_8BBF

	LDA Spr_Frame+$00,X
	CMP #$05
	BEQ PRG058_8BFA	; If canister's frame = 5, jump to PRG058_8BFA (RTS)

	CMP #$06
	BNE PRG058_8BBF	; If canister's frame <> 6, jump to PRG058_8BBF

	; Set animation for flying
	LDA #SPRANM2_TOADRAINCANFLY
	JSR PRG063_SetSpriteAnim

	; Upward velocity
	LDA #$08
	STA Spr_YVel+$00,X

PRG058_8BBF:
	JSR PRG063_ApplyYVelocityNeg

	LDA Spr_YHi+$00,X
	BEQ PRG058_8BFA		; If not off-screen, jump to PRG058_8BFA (RTS)

	LDA Spr_Flags+$00,X
	AND #SPRFL1_NODRAW
	BNE PRG058_8BE0		; If not drawing, jump to PRG058_8BE0

	LDA #$00
	STA Spr_YHi+$00,X
	
	LDA Spr_Flags+$00,X
	ORA #SPRFL1_NODRAW
	STA Spr_Flags+$00,X
	
	; Spr_Var1 = $0B
	LDA #$0B
	STA Spr_Var1+$00,X

PRG058_8BE0:
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG058_8BFA		; If Spr_Var1 > 0, jump to PRG058_8BFA (RTS)

	; Delete the canister
	JSR PRG062_ResetSpriteSlot

	LDA Weapon_ToadRainCounter
	BNE PRG058_8BFA		; If Toad Rain is already falling, jump to PRG058_8BFA (RTS)

	; Weapon_ToadRain_XYOff = 0
	LDA #$00
	STA Weapon_ToadRain_XYOff
	
	; Weapon_ToadRainCounter = $3C
	LDA #$3C
	STA Weapon_ToadRainCounter
	
	; Set index owning the canister -> ToadRain_OwnerIndex
	STX ToadRain_OwnerIndex

PRG058_8BFA:
	RTS	; $8BFA


PRG058_Obj_Balloon:
	; Spr_Var1 = ticks balloon "lives"

	LDY #$0C	; $8BFB
	JSR PRG063_DoMoveVertOnly

	BCC PRG058_8C0F	; If Balloon hasn't hit a solid, jump to PRG058_8C0F


PRG058_8C02:
	; Reset balloon's sprite
	JSR PRG062_ResetSpriteSlot

	; Poof away
	LDA #SPRSLOTID_PLAYER
	STA Spr_SlotID+$00,X
	LDA #SPRANM2_SMALLPOOF
	JMP PRG063_SetSpriteAnim


PRG058_8C0F:
	LDA Spr_Var2+$00,X
	BEQ PRG058_8C28		; If Spr_Var2 = 0, jump to PRG058_8C28

	DEC Spr_Var2+$00,X	; Spr_Var2--
	BNE PRG058_8C28		; If Spr_Var2 > 0, jump to PRG058_8C28

	; Balloon moving up
	LDA #SPRDIR_UP
	STA Spr_FaceDir+$00,X
	
	; Upward velocity
	LDA #$33
	STA Spr_YVelFrac+$00,X
	LDA #$00
	STA Spr_YVel+$00,X

PRG058_8C28:
	LDA Spr_Var1+$00,X
	CMP #$28
	BGE PRG058_8C32	; If Spr_Var1 >= $28, jump to PRG058_8C32

	; If balloon's "life" ticks are low, flicker
	STA Spr_FlashOrPauseCnt,X

PRG058_8C32:
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BEQ PRG058_8C02		; If Spr_Var1 = 0, jump to PRG058_8C02

	LDA #SPRANM2_BALLOON_PUSHDN
	CMP Spr_CurrentAnim+$00,X
	BNE PRG058_8C65	; If balloon is not doing its push down animation, jump to PRG058_8C65

	; Backup Spr_Flags2
	LDA Spr_Flags2+$00,X
	PHA
	
	; Consider under bbox $0D
	LDA #$0D
	STA Spr_Flags2+$00,X
	
	JSR PRG063_TestPlayerObjCollide

	; Restore Spr_Flags2
	PLA
	STA Spr_Flags2+$00,X
	
	BCC PRG058_8CA3		; If Player is touching Balloon, jump to PRG058_8CA3 (RTS)

	; Got off balloon, balloon pop back up animation
	LDA #SPRANM2_BALLOON_POPUP
	JSR PRG063_SetSpriteAnim

	; Bounding box $0D
	LDA #$0D
	STA Spr_Flags2+$00,X
	
	; Upward velocity
	LDA #$33
	STA Spr_YVelFrac+$00,X
	LDA #$00
	STA Spr_YVel+$00,X
	
	RTS	; $8C64


PRG058_8C65:
	JSR PRG063_TestPlayerObjCollide
	BCS PRG058_8CA3	; If Player is NOT touching Balloon, jump to PRG058_8CA3 (RTS)

	LDA Spr_Y+$00,X
	SUB Spr_Y+$00
	BCC PRG058_8CA3

	CMP #$17
	BLT PRG058_8CA3	; If Player is out of range vertically, jump to PRG058_8CA3 (RTS)

	LDA Spr_YVel+$00
	BPL PRG058_8CA3	; If Player is moving upward, jump to PRG058_8CA3 (RTS)

	; Player drops 3 pixels
	LDA Spr_Y+$00
	ADD #$03
	STA Spr_Y+$00
	
	; Balloon's Var2 = 8
	LDA #$08
	STA Spr_Var2+$00,X
	
	LDA #$80
	STA Spr_YVelFrac+$00,X
	LDA #$00
	STA Spr_YVel+$00,X
	
	; Slight descent on balloon
	LDA #SPRDIR_DOWN
	STA Spr_FaceDir+$00,X
	
	; Bounding box $1E
	LDA #$1E
	STA Spr_Flags2+$00,X
	
	; Got on balloon, balloon press down animation
	LDA #SPRANM2_BALLOON_PUSHDN
	JSR PRG063_SetSpriteAnim


PRG058_8CA3:
	RTS	; $8CA3

PRG058_Obj_DiveMissile:
	
	LDA Spr_Var3+$00,X
	ORA Spr_Var4+$00,X
	BEQ PRG058_8CC2	; If Spr_Var3 = 0 and Spr_Var4 = 0, jump to PRG058_8CC2 (PRG058_8D7C)

	; Spr_Var3/4 -= 1
	LDA Spr_Var3+$00,X
	SUB #$01
	STA Spr_Var3+$00,X
	LDA Spr_Var4+$00,X
	SBC #$00
	STA Spr_Var4+$00,X
	
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BEQ PRG058_8CC5		; If Spr_Var1 = 0, jump to PRG058_8CC5


PRG058_8CC2:
	JMP PRG058_8D7C	; Jump to PRG058_8D7C


PRG058_8CC5:
	; Since this is ONLY the Dive Missile at this point, this always sets bank 32 + 7 = 39
	LDA <Player_CurWeapon		; 12
	ORA #32						; 32 -> 39
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

	; Spr_Var1 = 2
	LDA #$02
	STA Spr_Var1+$00,X
	
	; Temp_Var0 = 0
	; Temp_Var1 = 1
	LDA #$00
	STA <Temp_Var0
	STA <Temp_Var1
	
	DEC <Temp_Var1	; Temp_Var1--
	
	STX <Temp_Var2	; Object index -> Temp_Var2
	
	LDY #$17	; Y = $17 (all object sprite slots)
PRG058_8CDF:
	LDX Spr_SlotID+$00,Y
	BEQ PRG058_8D14	; If object sprite slot is empty, jump to PRG058_8D14

	LDA Spr_Flags+$00,Y
	BPL PRG058_8D14	; If not on-screen, jump to PRG058_8D14

	LDA Spr_Flags2+$00,Y
	AND #$40
	BEQ PRG058_8D14	; If object cannot be shot, jump to PRG058_8D14

	LDA Player_WeaponDamageTable,X
	BEQ PRG058_8D14	; If Dive Missile will not damage this, jump to PRG058_8D14

	LDX <Temp_Var2	; X = original Dive Missile index
	
	LDA Spr_X+$00,Y
	SUB Spr_X+$00,X
	PHA	
	LDA Spr_XHi+$00,Y
	SBC Spr_XHi+$00,X
	PLA
	BCS PRG058_8D0C

	EOR #$FF	; $8D08
	ADC #$01	; $8D0A

PRG058_8D0C:
	CMP <Temp_Var1	; $8D0C 
	BGE PRG058_8D14	; $8D0E

	STA <Temp_Var1	; $8D10
	
	STY <Temp_Var0	; $8D12
PRG058_8D14:
	DEY	; $8D14
	
	CPY #$07	; $8D15
	BNE PRG058_8CDF	; $8D17

	LDX <Temp_Var2	; $8D19
	LDY <Temp_Var0	; $8D1B
	BEQ PRG058_8D7C	; $8D1D

	JSR PRG063_AimTowardsObject	
	CMP Spr_Var2+$00,X
	BEQ PRG058_8D7C	; If already aimed in this direction, jump to PRG058_8D7C

	STA <Temp_Var1	; Aim dir -> Temp_Var1
	
	LDA Spr_Var2+$00,X
	AND #$03
	BEQ PRG058_8D3D

	LDA Spr_Var2+$00,X
	ADD Spr_Var5+$00,X
	STA Spr_Var2+$00,X
	
	JMP PRG058_8D63	; Jump to PRG058_8D63


PRG058_8D3D:
	LDA Spr_Var2+$00,X	; $8D3D
	ADD #$08	; $8D40
	AND #$0F	; $8D43
	SUB <Temp_Var1	; $8D45
	AND #$0F	; $8D48
	SUB #$08	; $8D4A
	BEQ PRG058_8D63	; $8D4D

	BCS PRG058_8D5B	; $8D4F

	LDA #$01	; $8D51
	STA Spr_Var5+$00,X	; $8D53
	INC Spr_Var2+$00,X	; $8D56
	BNE PRG058_8D63	; $8D59


PRG058_8D5B:
	LDA #$FF	; $8D5B
	STA Spr_Var5+$00,X	; $8D5D
	DEC Spr_Var2+$00,X	; $8D60

PRG058_8D63:
	LDA Spr_Var2+$00,X	; $8D63
	AND #$0F	; $8D66
	STA Spr_Var2+$00,X	; $8D68
	TAY	; $8D6B
	
	LDA PRG058_DiveMissile_Anim,Y
	CMP Spr_CurrentAnim+$00,X
	BEQ PRG058_8D77	; If Dive Missile is already in the right animation, jump to PRG058_8D77

	JSR PRG063_SetSpriteAnim	; $8D74


PRG058_8D77:
	LDA #$08
	JSR PRG063_SetMissileAimVelocities


PRG058_8D7C:
	JSR PRG063_ApplyVelSetFaceDir
	JSR PRG063_DoMoveVertOnlyH16
	JSR PRG058_ShootOutDustCrushBlocks

	LDA Spr_YHi+$00,X
	BEQ PRG058_8D8D	; If missile is not vertically off-screen, jump to PRG058_8D8D

	JSR PRG062_ResetSpriteSlot

PRG058_8D8D:
	RTS	; $8D8D


PRG058_DiveMissile_Anim:
	.byte SPRANM2_DIVEMISSILE_UP		; SPRAIM_ANG_0
	.byte SPRANM2_DIVEMISSILE_DIAGUP	; SPRAIM_ANG_22
	.byte SPRANM2_DIVEMISSILE_DIAGUP	; SPRAIM_ANG_45
	.byte SPRANM2_DIVEMISSILE_DIAGUP	; SPRAIM_ANG_67
	.byte SPRANM2_DIVEMISSILE			; SPRAIM_ANG_90
	.byte SPRANM2_DIVEMISSILE_DIAGDN	; SPRAIM_ANG_112
	.byte SPRANM2_DIVEMISSILE_DIAGDN	; SPRAIM_ANG_135
	.byte SPRANM2_DIVEMISSILE_DIAGDN	; SPRAIM_ANG_157
	.byte SPRANM2_DIVEMISSILE_DN		; SPRAIM_ANG_180
	.byte SPRANM2_DIVEMISSILE_DIAGDN	; SPRAIM_ANG_202
	.byte SPRANM2_DIVEMISSILE_DIAGDN	; SPRAIM_ANG_225
	.byte SPRANM2_DIVEMISSILE_DIAGDN	; SPRAIM_ANG_247
	.byte SPRANM2_DIVEMISSILE			; SPRAIM_ANG_270
	.byte SPRANM2_DIVEMISSILE_DIAGUP	; SPRAIM_ANG_292
	.byte SPRANM2_DIVEMISSILE_DIAGUP	; SPRAIM_ANG_315
	.byte SPRANM2_DIVEMISSILE_DIAGUP	; SPRAIM_ANG_337


PRG058_Obj_RingBoomerang:
	JSR PRG063_ApplyVelSetFaceDir
	JSR PRG063_DoMoveVertOnlyH16
	JSR PRG058_ShootOutDustCrushBlocks

	DEC Spr_Var1+$00,X
	BNE PRG058_8DBB	; If Spr_Var1 > 0, jump to PRG058_8DBB (RTS)

	; Ring rebounding (well, boomerang-ing)

PRG058_8DAC:

	; Spr_Var1 = 8
	LDA #$08
	STA Spr_Var1+$00,X
	
	LDA #LOW(PRG058_Obj_Ring_Rebound_Init)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Obj_Ring_Rebound_Init)
	STA Spr_CodePtrH+$00,X

PRG058_8DBB:
	RTS	; $8DBB


PRG058_Obj_Ring_Rebound_Init:
	DEC Spr_Var1+$00,X		; Spr_Var1--
	BNE PRG058_8DBB			; If Spr_Var1 > 0, jump to PRG058_8DBB (RTS)

	; Set Ring Boomerang to use continuation
	LDA #LOW(PRG058_Obj_Ring_Rebound_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Obj_Ring_Rebound_Cont)
	STA Spr_CodePtrH+$00,X
	
	; Ring aims towards back towards Player
	JSR PRG063_AimTowardsPlayer
	STA <Temp_Var0	; $8DCE
	
	; Spr_Var1 = $16
	LDA #$16
	STA Spr_Var1+$00,X
	
	BNE PRG058_8E10	; Jump (technically always) to PRG058_8E10
	

PRG058_Obj_Ring_Rebound_Cont:
	JSR PRG063_AimTowardsPlayer
	STA <Temp_Var0
		
	LDA Spr_Var2+$00,X	; $8DDC
	AND #$03	; $8DDF
	STA <Temp_Var1	; $8DE1
	
	LDA Spr_Var2+$00,X	; $8DE3
	AND #$0C	; $8DE6
	STA <Temp_Var2	; $8DE8
	
	LDA <Temp_Var1	; $8DEA
	BEQ PRG058_8DFD	; $8DEC

	LDA <Temp_Var0
	AND #$03
	BEQ PRG058_8DFD
	
	CMP <Temp_Var1
	BNE PRG058_8E17
	
	ORA <Temp_Var2
	STA Spr_Var2,X


PRG058_8DFD:
	LDA <Temp_Var2	; $8DFD
	BEQ PRG058_8E10	; $8DFF

	LDA <Temp_Var0	; $8E01
	AND #$0C	; $8E03
	BEQ PRG058_8E10	; $8E05

	CMP <Temp_Var2	; $8E07
	BNE PRG058_8E17	; $8E09

	ORA <Temp_Var1	; $8E0B
	STA Spr_Var2+$00,X	; $8E0D

PRG058_8E10:
	LDY <Temp_Var0	; $8E10
	
	LDA #$10	; $8E12
	JSR PRG063_SetMissileAimVelocities	; $8E14


PRG058_8E17:
	JSR PRG063_ApplyVelSetFaceDir
	JSR PRG063_DoMoveVertOnlyH16
	JSR PRG058_ShootOutDustCrushBlocks

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG058_8E28		; If Spr_Var1 > 0, jump to PRG058_8E28

	JSR PRG058_8DAC

PRG058_8E28:
	JSR PRG063_TestPlayerObjCollide
	BCS PRG058_8E30	; If Ring Boomerange didn't touch Player, jump to PRG058_8E30 (RTS)

	; Reclaimed Ring
	JMP PRG062_ResetSpriteSlot

PRG058_8E30:
	RTS	; $8E30


PRG058_Obj_DrillBomb:
	LDY #$0E
	JSR PRG063_DoObjMoveSetFaceDir

	ROR <Temp_Var15	; Carry -> bit 7
	
	JSR PRG058_ShootOutDustCrushBlocks	; $8E38

	LDA <Temp_Var15
	BPL PRG058_8E45	; If didn't hit something solid, jump to PRG058_8E45

	LDA <Level_TileAttr_GreatestDet
	CMP #TILEATTR_DUSTSHOOTABLE
	BNE PRG058_8E54	; If this is not a Dust Man Crusher shootable block, jump to PRG058_8E54


PRG058_8E45:
	LDA Spr_Var1+$00,X
	BEQ PRG058_8E4E	; If Spr_Var1 = 0, jump to PRG058_8E4E

	DEC Spr_Var1+$00,X	; Spr_Var1--
	RTS	; $8E4D


PRG058_8E4E:
	LDA <Ctlr1_Pressed
	AND #PAD_B
	BEQ PRG058_8E6E	; If Player is not pressing B, jump to PRG058_8E6E (RTS)


PRG058_8E54:
	; Reset drill bomb's sprite
	JSR PRG062_ResetSpriteSlot

	; Drill actually "poofs" away inside the explosion when it's been manually
	; destructed or hits a wall...
	LDA #SPRANM4_SMALLPOOFEXP
	JSR PRG063_SetSpriteAnim
	
	LDA #SPRSLOTID_CIRCULAREXPLOSION
	STA Spr_SlotID+$00,X
	
	LDA #$00
	STA Spr_Var1+$00,X	; Spr_Var1 = 0
	STA Spr_Var2+$00,X	; Spr_Var2 = 0
	
	; Bounding box 3
	LDA #$03
	STA Spr_Flags2+$00,X

PRG058_8E6E:
	RTS	; $8E6E


PRG058_Obj_DustCrusher:
	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM2_DUSTCRUSHER
	BNE PRG058_8EAD		; If Dust Crusher is not in its initial shot-out animation, jump to PRG058_8EAD

	; Fresh Dust Crusher...

	LDA Spr_Frame+$00,X
	BEQ PRG058_8EAD	; If frame = 0, jump to PRG058_8EAD

	CMP #$04
	BNE PRG058_8ECB	; If frame <> 4, jump to PRG058_8ECB (RTS)

	; Instantiate Dust Crusher debris
	LDY #$04	; Y = 4 (object slot index)
PRG058_8E81:
	; Delete object (index 'Y')
	JSR PRG063_DeleteObjectY

	; Animation of this debris chunk
	LDA PRG058_DCrush_DebrisAnim-1,Y
	JSR PRG063_CopySprSlotSetAnim

	; Slot ID
	LDA #SPRSLOTID_DUSTCRUSHER
	STA Spr_SlotID+$00,Y
	
	; Direction of this debris chunk
	LDA PRG058_DCrush_DebrisDir-1,Y
	STA Spr_FaceDir+$00,Y
	
	; Velocity
	LDA #$3E
	STA Spr_XVelFrac+$00,Y
	STA Spr_YVelFrac+$00,Y
	LDA #$04
	STA Spr_XVel+$00,Y
	STA Spr_YVel+$00,Y
	
	; Bounding box 0
	LDA #$00
	STA Spr_Flags2+$00,Y
	
	DEY	; Y--
	BNE PRG058_8E81	; While Y > 0, loop!


PRG058_8EAD:
	; Hold animation
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	JSR PRG063_ApplyVelSetFaceDir
	JSR PRG063_DoMoveVertOnlyH16
	JSR PRG058_ShootOutDustCrushBlocks

	LDA Spr_Flags+$00,X
	AND #~SPR_HFLIP
	STA Spr_Flags+$00,X
	
	LDA Spr_YHi+$00,X
	BEQ PRG058_8ECB	; If Dust Crusher is not vertically off-screen, jump to PRG058_8ECB (RTS)

	; Remove Dust Crusher
	JSR PRG062_ResetSpriteSlot

PRG058_8ECB:
	RTS	; $8ECB

PRG058_DCrush_DebrisAnim:
	.byte SPRANM2_DUSTCRUSHER_D1
	.byte SPRANM2_DUSTCRUSHER_D2
	.byte SPRANM2_DUSTCRUSHER_D3
	.byte SPRANM2_DUSTCRUSHER_D4
	
PRG058_DCrush_DebrisDir:
	.byte SPRDIR_UP | SPRDIR_LEFT
	.byte SPRDIR_UP | SPRDIR_RIGHT
	.byte SPRDIR_DOWN | SPRDIR_LEFT
	.byte SPRDIR_DOWN | SPRDIR_RIGHT


PRG058_Obj_WireAdapter:
	LDA <Player_State
	CMP #PLAYERSTATE_WIREADAPTER
	BNE PRG058_8F21	; If Player state is not Wire Adapter in-use, jump to PRG058_8F21

	LDA Spr_Y+$00
	SUB #14
	STA Spr_Var1+$04	; Spr_Var1 = Player Y - 14
	
	; Move Wire Adapter
	LDY #$23
	JSR PRG063_DoMoveVertOnly

	BCC PRG058_8EEF	; If hasn't hit ceiling, jump to PRG058_8EEF

	; Attached to ceiling
	LDA #SPRANM2_WIREADAPTERPL
	JMP PRG063_SetSpriteAnim

PRG058_8EEF:
	LDA <Frame_Counter
	AND #$07
	BNE PRG058_8EFA	; 1:8 ticks, jump to PRG058_8EFA

	; Wire Adapter noise!
	LDA #SFX_WIREADAPTER
	JSR PRG063_QueueMusSnd


PRG058_8EFA:
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_UP
	BEQ PRG058_8F15	; If Wire Adapter direction is not up, jump to PRG058_8F15

	LDA Spr_YHi+$00,X
	BEQ PRG058_8F24	; If Wire Adapter is not vertically off-screen, jump to PRG058_8F24 (RTS)

	; Stop Wire Adapter at top of screen
	LDA #$00
	STA Spr_Y+$00,X
	STA Spr_YHi+$00,X
	
	; Return Wire Adapter down
	LDA #SPRDIR_DOWN
	STA Spr_FaceDir+$00,X
	
	BNE PRG058_8F24	; Jump (technically always) to PRG058_8F24 (RTS)


PRG058_8F15:
	LDA Spr_Y+$00,X
	CMP Spr_Var1+$00,X
	BLT PRG058_8F24		; If Wire Adapter hasn't returned to Player, jump to PRG058_8F24 (RTS)

	; Wire Adapter retracted to Player
	LDA #PLAYERSTATE_STAND
	STA <Player_State

PRG058_8F21:
	; Delete Wire Adapter
	JSR PRG062_ResetSpriteSlot

PRG058_8F24:
	RTS	; $8F24


PRG058_Obj_PharaohShot:
	LDY Spr_CurrentAnim+$00,X	; Y = Pharaoh shot's animation
	
	; Set bounding box
	LDA PRG058_PharaohShotBBox-SPRANM2_PHARAOHSHOT,Y
	STA Spr_Flags2+$00,X
	
	JSR PRG063_ApplyVelSetFaceDir
	JSR PRG063_DoMoveVertOnlyH16
	JSR PRG058_ShootOutDustCrushBlocks

	LDA Spr_YHi+$00,X
	BEQ PRG058_8F3F		; If Pharaoh Shot is not vertically off-screen, jump to PRG058_8F3F

	; Delete the Pharaoh Shot
	JSR PRG062_ResetSpriteSlot

PRG058_8F3F:
	RTS	; $8F3F


PRG058_Obj_PharaohShOvrhead:
	LDA Spr_Frame+$00,X
	CMP #$0E
	BNE PRG058_8F4C	; If overhead frame <> $0E, jump to PRG058_8F4C

	LDA #SPRANM2_PHARAOHCHSHOT
	JSR PRG063_SetSpriteAnim

PRG058_8F4C:
	; Position above Player's head
	LDA Spr_Y+$00
	SUB #$1C
	STA Spr_Y+$00,X	
	LDA Spr_YHi+$00
	SBC #$00
	STA Spr_YHi+$00,X
	
	LDA Spr_Var1+$00,X
	BNE PRG058_8F81	; If Spr_Var1 <> 0, jump to PRG058_8F81

	; Spr_Var1 = 0 (it is already?)
	LDA #$00
	STA Spr_Var1+$00,X
	
	JSR PRG063_CalcObjXDiffFromPlayer

	CMP #$08
	BLT PRG058_8FE2

	JSR PRG063_SetObjFacePlayer

	LDA Spr_X+$00
	STA Spr_Var2+$00,X
	
	LDA Spr_XHi+$00
	STA Spr_Var3+$00,X
	
	INC Spr_Var1+$00,X
	
	RTS	; $8F80


PRG058_8F81:
	LDA Spr_Var2+$00,X
	SUB Spr_X+$00	
	STA <Temp_Var0	
	
	LDA Spr_Var3+$00,X
	SBC Spr_XHi+$00	
	ORA <Temp_Var0	
	BEQ PRG058_8FAD	

	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BEQ PRG058_8F9F

	BCC PRG058_8FA1

PRG058_8F9D:
	BCS PRG058_8FAD


PRG058_8F9F:
	BCC PRG058_8FAD


PRG058_8FA1:
	LDA Spr_X+$00
	STA Spr_Var2+$00,X
	LDA Spr_XHi+$00
	STA Spr_Var3+$00,X

PRG058_8FAD:
	LDA <Player_HCurSpeedFrac
	STA Spr_XVelFrac+$00,X	
	LDA <Player_HCurSpeed
	STA Spr_XVel+$00,X	
	
	JSR PRG063_ApplyVelSetFaceDir
	JSR PRG058_ShootOutDustCrushBlocks

	LDA Spr_Var2+$00,X
	SUB Spr_X+$00,X	
	STA <Temp_Var0	
	
	LDA Spr_Var3+$00,X
	SBC Spr_XHi+$00,X
	ORA <Temp_Var0
	BEQ PRG058_8FDD

	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BEQ PRG058_8FDB	
	BCC PRG058_8FDD	
	BCS PRG058_8FE2	


PRG058_8FDB:
	BCC PRG058_8FE2	


PRG058_8FDD:
	LDA #$00
	STA Spr_Var1+$00,X

PRG058_8FE2:
	RTS	; $8FE2

PRG058_PharaohShotBBox:
	.byte $04	; SPRANM2_PHARAOHSHOT
	.byte $02	; SPRANM2_PHARAOHCHLSHOT
	.byte $05	; SPRANM2_PHARAOHCHSHOT


PRG058_Obj0E:
	; CHECKME - UNUSED?
	RTS

PRG058_Obj_SkullBarrier:
	; Skull barrier just sticks to Player
	LDA Spr_X+$00
	STA Spr_X+$00,X
	LDA Spr_XHi+$00
	STA Spr_XHi+$00,X
	
	LDA Spr_Y+$00
	STA Spr_Y+$00,X
	LDA Spr_YHi+$00
	STA Spr_YHi+$00,X
	
	RTS	; $8FFF


PRG058_Obj_Taketetno:
	; Mushroom with detaching propellar
	
	LDA Spr_Var1+$00,X
	BNE PRG058_9014	; If Spr_Var1 <> 0, jump to PRG058_9014

	LDA <RandomN+$00
	ADC <RandomN+$02
	STA <RandomN+$00
	
	AND #$07
	TAY	; Y = 0 to 7
	
	; Var1 = random val from PRG058_Taketetno_Var1Inits
	LDA PRG058_Taketetno_Var1Inits,Y
	STA Spr_Var1+$00,X

PRG058_9014:
	JSR PRG063_ApplyVelSetFaceDir

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG058_9062		; If Spr_Var1 > 0, jump to PRG058_9062 (RTS)

	LDA #LOW(PRG058_Obj_Taketetno_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Obj_Taketetno_Cont)
	STA Spr_CodePtrH+$00,X
	
	; Allow to be shot, and hurt Player
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE)
	STA Spr_Flags2+$00,X
	
	JSR PRG058_9073	; $902B

	; Reset animation
	LDA #$00
	STA Spr_AnimTicks+$00,X
	STA Spr_Frame+$00,X
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG058_9062	; If no free slot, jump to PRG058_9062 (RTS)

	LDA #SPRSLOTID_TAKETETNO_PROP
	STA Spr_SlotID+$00,Y
	
	; Temp_Var16 = 2 (shot data index)
	LDA #$02
	STA <Temp_Var16
	
	LDA #SPRANM4_TAKETETNO_PROP
	JSR PRG063_InitProjectile

	; Propellar going upward!
	LDA #SPRDIR_UP
	STA Spr_FaceDir+$00,Y
	
	; Propellar upward speed
	LDA #$00
	STA Spr_YVelFrac+$00,Y
	LDA #$02
	STA Spr_YVel+$00,Y
	
	; Bounding box $0F, hurt player, shootable
	LDA #$CF
	STA Spr_Flags2+$00,Y
	
	; 1HP for propellar
	LDA #$01
	STA Spr_HP+$00,Y

PRG058_9062:
	RTS	; $9062

PRG058_Obj_Taketetno_Cont:
	JSR PRG063_ApplyVelSetFaceDir
	JSR PRG063_DoMoveVertOnlyH16

	INC Spr_Var1+$00,X	; Spr_Var1++
	LDA Spr_Var1+$00,X
	AND #$07
	BNE PRG058_9062	; 1:8 ticks, jump to PRG058_9062 (RTS)


PRG058_9073:
	JSR PRG063_Aim2Plyr_SetDir_Var4

	; Set velocity towards Player
	LDA PRG058_Taketetno_XVelFrac,Y
	STA Spr_XVelFrac+$00,X
	LDA PRG058_Taketetno_XVel,Y
	STA Spr_XVel+$00,X
	LDA PRG058_Taketetno_YVelFrac,Y
	STA Spr_YVelFrac+$00,X
	LDA PRG058_Taketetno_YVel,Y
	STA Spr_YVel+$00,X
	
	LDY #SPRANM4_TAKETETNO_UP
	
	LDA Spr_FaceDir+$00,X
	CMP #SPRDIR_UP
	BGE PRG058_9098	; If some upward direction, jump to PRG058_9098

	INY	; Y = SPRANM4_TAKETETNO_DOWN

PRG058_9098:
	; Set animation
	TYA
	STA Spr_CurrentAnim+$00,X
	
	; Reset animation ticks
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	RTS	; $90A1


PRG058_Taketetno_Var1Inits:
	.byte $18, $30, $40, $30, $18, $30, $40, $18
	
							;       U,  UR,  UR,  UR,   R,  DR,  DR,  DR,   D,  DL,  DL,  DL,   L,  UL,  UL,  UL
PRG058_Taketetno_XVelFrac:	.byte $00, $80, $B5, $DC, $00, $DC, $B5, $80, $00, $80, $B5, $DC, $00, $C0, $B5, $80
PRG058_Taketetno_XVel:		.byte $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00
PRG058_Taketetno_YVelFrac:	.byte $33, $08, $DA, $99, $00, $66, $91, $B0, $CC, $B0, $91, $66, $00, $99, $DA, $08
PRG058_Taketetno_YVel:		.byte $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01


PRG058_Obj_TaketetnoProp:
	; Taketetno's propellar just flies away
	JMP PRG063_DoMoveVertOnlyH16

PRG058_Obj_Hover:
	DEC Spr_Y+$00,X
	JSR PRG063_TestPlayerObjCollide
	INC Spr_Y+$00,X
	BCS PRG058_910C	; If Player isn't touching Hover, jump to PRG058_910C

	; Set continuation code pointer
	LDA #LOW(PRG058_Obj_Hover_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Obj_Hover_Cont)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var1 = $0E
	LDA #$0E
	STA Spr_Var1+$00,X
	
	LDA #SPRANM4_HOVER
	JMP PRG063_SetSpriteAnim


PRG058_910C:
	LDA Spr_Frame+$00,X
	CMP #$03
	BNE PRG058_9123	; If Hover is not on frame 3, jump to PRG058_9123 (RTS)

	LDA Spr_AnimTicks+$00,X
	BNE PRG058_9123	; If animation ticks <> 0, jump to PRG058_9123 (RTS)

	; Left shot
	LDA #$02
	STA <Temp_Var14

PRG058_911C:
	JSR PRG058_HoverShootProj	; Shoot shot!

	DEC <Temp_Var14	; Temp_Var14 = 1 (right shot)
	BNE PRG058_911C	; Loop around for the right shot


PRG058_9123:
	RTS	; $9123

PRG058_Obj_Hover_Cont:
	DEC Spr_Var1+$00,X	; Spr_Var1--
	
	LDA Spr_Var1+$00,X
	BEQ PRG058_9145	; If Spr_Var1 = 0, jump to PRG058_9145

	CMP #$08
	BGE PRG058_9138	; If Spr_Var1 >= 8, jump to PRG058_9138

	DEC Spr_Y+$00,X	; Hover move down slightly
	
	; Set animation for riding hover
	LDA #SPRANM4_HOVER_RIDING
	JMP PRG063_SetSpriteAnim


PRG058_9138:
	BNE PRG058_9141	; If Spr_Var1 <> 8, jump to PRG058_9141

	; Kick up dust
	LDA #$00
	STA <Temp_Var14
	JSR PRG058_HoverShootProj


PRG058_9141:
	INC Spr_Y+$00,X	; Hover move up slightly
	RTS	; $9144


PRG058_9145:
	
	; Change Hover's code pointer for riding
	LDA #LOW(PRG058_Obj_Hover_Ride)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Obj_Hover_Ride)
	STA Spr_CodePtrH+$00,X
	
	; Hover move right
	LDA #SPRDIR_RIGHT
	STA Spr_FaceDir+$00,X
	
	RTS	; $9154

PRG058_Obj_Hover_Ride:
	; Spr_Var2 = 0
	LDA #$00
	STA Spr_Var2+$00,X
	
	DEC Spr_Y+$00,X
	JSR PRG063_TestPlayerObjCollide
	INC Spr_Y+$00,X
	
	ROL Spr_Var2+$00,X	; carry -> bit 0
	
	LDY #$13
	JSR PRG063_DoObjVertMovement

	PHP	; Save CPU status (namely carry)
	
	LDA Spr_Var2+$00,X
	BNE PRG058_917D	; If Spr_Var2 <> 0 (Player not touching), jump to PRG058_917D

	; Set Player vertically on Hover
	LDA Spr_Y+$00,X
	SUB #$17
	STA Spr_Y+$00
	
	; Fix Player
	JSR PRG063_PlayerHitFloorAlign


PRG058_917D:
	PLP	; Restore CPU status (namely carry)
	BCC PRG058_9123	; If Hover didn't hit solid tiles, jump to PRG058_9123 (RTS)

	LDA Spr_Var2+$00,X
	BNE PRG058_9188	; If Spr_Var2 <> 0 (Player not touching), jump to PRG058_9188

	JSR PRG063_MovePlayerWithObj	; Carry Player

PRG058_9188:
	LDY #$14	; $9188
	JSR PRG063_DoObjMoveSetFaceDir	; $918A
	BCC PRG058_9123	; If Hover didn't hit solid tiles, jump to PRG058_9123 (RTS)

	; Hover's gonna poof away

	LDA #SPRSLOTID_MISCSTUFF
	STA Spr_SlotID+$00,X
	
	; Decomission the code pointer
	LDA #$00
	STA Spr_CodePtrH+$00,X
	
	LDA #SPRANM4_SMALLPOOFEXP
	JMP PRG063_SetSpriteAnim


PRG058_EnemyProj_ShotDataIdx:	.byte $0F, $1B, $1A
PRG058_EnemyProj_SprAnim:		.byte SPRANM4_HOVER_DUST, SPRANM4_CIRCLEBULLET, SPRANM4_CIRCLEBULLET
PRG058_EnemyProj_SprSlotID:		.byte SPRSLOTID_MISCSTUFF, SPRSLOTID_CIRCLEBULLET, SPRSLOTID_CIRCLEBULLET

	; Set Temp_Var14:
	;	0 = Dust kicked up when you jump on Hover
	;	1 = Right shot
	;	2 = Left shot
PRG058_HoverShootProj:
	STX <Temp_Var15	; Backup 'X' -> Temp_Var15
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG058_91DB	; If no free slot, jump to PRG058_91DB (RTS)

	; Bounding box $0F, hurt player
	LDA #$8F
	STA Spr_Flags2+$00,Y
	
	; Projectiles have no HP
	LDA #$00
	STA Spr_HP+$00,Y
	
	LDX <Temp_Var14	; X = Temp_Var14
	
	; Set facing direction (assumption of X = 1 / RIGHT, X = 2 / LEFT)
	TXA
	STA Spr_FaceDir+$00,Y
	
	; Slot ID
	LDA PRG058_EnemyProj_SprSlotID,X
	STA Spr_SlotID+$00,Y
	
	; Index for PRG063_InitProjectile
	LDA PRG058_EnemyProj_ShotDataIdx,X
	STA <Temp_Var16
	
	; Spawn projectile
	LDA PRG058_EnemyProj_SprAnim,X
	LDX <Temp_Var15	; Restore 'X'
	JSR PRG063_InitProjectile	; $91CE

	; Shot speed
	LDA #$00
	STA Spr_XVelFrac+$00,Y
	LDA #$02
	STA Spr_XVel+$00,Y

PRG058_91DB:
	RTS	; $91DB


PRG058_Obj_CircleBullet:
	JMP PRG063_ApplyVelSetFaceDir


PRG058_Obj_Tomboy:
	JSR PRG058_Tomboy_SetFlags2ByFrame
	JSR PRG063_SetObjFlipForFaceDir

	; Reset animatino
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	LDA Spr_Var4+$00,X
	INC Spr_Var4+$00,X	; Spr_Var4++
	CMP #$08
	BNE PRG058_921D	; If Spr_Var4 <> 8, jump to PRG058_921D (RTS)

	AND #$07
	STA Spr_Var4+$00,X	; Cap Spr_Var4 0-7
	
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_LEFT
	LSR A		; $01 if left, $00 if right
	ORA #$08	; $09 if left, $08 if right
	STA Spr_Var2+$00,X	; -> Spr_Var2
	
	JSR PRG058_Tomboy_TurnAround

	LDY #$12	; Y = $12
	
	LDA Spr_Var1+$00,X
	BEQ PRG058_9210	; If Spr_Var1 = 0, jump to PRG058_9210

	LDY #$00	; Y = $00

PRG058_9210:
	JSR PRG058_Tomboy_Move

	LDA #LOW(PRG058_Obj_Tomboy_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Obj_Tomboy_Cont)
	STA Spr_CodePtrH+$00,X

PRG058_921D:
	RTS	; $921D

PRG058_Obj_Tomboy_Cont:
	JSR PRG058_Tomboy_SetFlags2ByFrame

	; Spr_AnimTicks = 0
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	LDA Spr_Var4+$00,X
	INC Spr_Var4+$00,X	; Spr_Var4++
	CMP #$08
	BNE PRG058_921D	; If Spr_Var4 <> 8, jump to PRG058_921D (RTS)

	AND #$07
	STA Spr_Var4+$00,X	; Cap Spr_Var4 0-7
	
	LDY #$08	; Y = $08
	
	LDA Spr_Frame+$00,X
	CMP #$0A
	BEQ PRG058_9269	; If frame = $0A, jump to PRG058_9269

	; Y = $0A
	INY
	INY
	
	CMP #$05
	BEQ PRG058_9269	; If frame = $05, jump to PRG058_9269

	CMP #$0F
	BEQ PRG058_9269	; If frame = $0F, jump to PRG058_9269

	CMP #$11
	BEQ PRG058_9256	; If frame = $11, jump to PRG058_9256

	LDY Spr_Frame+$00,X
	JSR PRG058_Tomboy_Move

	INC Spr_Frame+$00,X	; Spr_Frame++
	
	RTS	; $9255


PRG058_9256:
	LDY Spr_Var1+$00,X	; Y = Spr_Var1
	
	; Set frame
	LDA PRG058_Tomboy_Frames,Y
	STA Spr_Frame+$00,X
	TAY	; -> 'Y'
	
	CMP #$06
	BEQ PRG058_9266	; If frame = $06, jump to PRG058_9266

	LDY #$15	; Y = $15

PRG058_9266:
	JMP PRG058_Tomboy_Move


PRG058_9269:
	TYA	
	STA Spr_Var2+$00,X
	
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BNE PRG058_9277	; If Tomboy is moving right, jump to PRG058_9277

	INC Spr_Var2+$00,X	; Spr_Var2++

PRG058_9277:
	; Spr_Var3 = Spr_Var1
	LDA Spr_Var1+$00,X
	STA Spr_Var3+$00,X
	
	JSR PRG058_Tomboy_TurnAround

	LDA Spr_Var1+$00,X
	CMP Spr_Var3+$00,X
	BNE PRG058_9293	; If Spr_Var1 isn't the same value, jump to PRG058_9293

	CMP #$01
	BNE PRG058_92B9	; If Spr_Var1 = 1, jump to PRG058_92B9

	LDA #$00
	STA Spr_Frame,X
	BEQ PRG058_92B9	; Jump (technically always) to PRG058_92B9


PRG058_9293:
	LDA Spr_Var1+$00,X
	BNE PRG058_92A5	; If Spr_Var1 <> 0, jump to PRG058_92A5

	LDY #$16	; Y = $16
	
	LDA Spr_Var3+$00,X
	CMP #$01
	BEQ PRG058_92B9	; If Spr_Var3 = $01, jump to PRG058_92B9

	LDY #$11	; Y = $11
	BNE PRG058_92B9	; Jump (technically always) to PRG058_92B9


PRG058_92A5:
	LDY #$14	; Y = $14
	
	LDA Spr_Var3+$00,X
	BEQ PRG058_92B4	; If Spr_Var3 = $00, jump to PRG058_92B4

	LDY #$10	; Y = $10

	CMP #$01
	BEQ PRG058_92B9	; If Spr_Var3 = $01, jump to PRG058_92B9

	LDY #$13	; Y = $13

PRG058_92B4:
	; Spr_Frame = $11
	LDA #$11
	STA Spr_Frame+$00,X

PRG058_92B9:
	JSR PRG058_Tomboy_Move

	RTS	; $92BC


PRG058_Tomboy_SetFlags2ByFrame:
	LDY Spr_Frame+$00,X
	
	LDA PRG058_Tomboy_Flags2ByFrame,Y
	STA Spr_Flags2+$00,X
	
	RTS	; $92C6


PRG058_Tomboy_TurnAround:
	LDA Spr_FaceDir+$00,X
	LSR A		; $01 if left, $00 if right
	AND #$01	; $00/$01
	ORA #$0C	; $0D if left, $0C if right
	TAY			; -> 'Y' (detection select)
	JSR PRG062_ObjDetWallAttrs

	LDA <Temp_Var16
	AND #TILEATTR_SOLID
	BNE PRG058_92ED	; If hit solid, jump to PRG058_92ED

	LDY Spr_Var2+$00,X	; $92D9
	JSR PRG062_ObjDetWallAttrs	; $92DC

	; Checking any solid impacts
	LDY #$00
PRG058_92E1:
	LDA Level_TileAttrsDetected+$00,Y
	
	AND #TILEATTR_SOLID
	BNE PRG058_9304	; Solid tile found, jump to PRG058_9304

	INY			; Y++
	CPY #$03
	BNE PRG058_92E1	; While Y < 3, loop


PRG058_92ED:
	
	; Turn Tomboy around
	LDA Spr_Flags+$00,X
	EOR #SPR_HFLIP
	STA Spr_Flags+$00,X

	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_LEFT | SPRDIR_RIGHT)
	STA Spr_FaceDir+$00,X
	
	; Set animation frame to $17
	LDA #$17
	STA Spr_Frame+$00,X
	
	LDY #$00	; Y = 0

PRG058_9304:
	TYA
	STA Spr_Var1+$00,X	; Y -> Spr_Var1
	
	LDA Spr_Frame+$00,X
	PHA	; Save frame
	
	LDA PRG058_Tomboy_Frames,Y
	STA Spr_Frame+$00,X
	
	; Spr_AnimTicks = 0
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	PLA	; Restore frame
	TAY	; -> 'Y'
	
	RTS	; $9319


PRG058_Tomboy_Move:
	; Move vertically
	LDA Spr_Y+$00,X
	ADD PRG058_Tomboy_YOffset,Y
	STA Spr_Y+$00,X
	
	; Temp_Var0 = 0 (16-bit sign extension)
	LDA #$00
	STA <Temp_Var0
	
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BNE PRG058_9338	; If Tomboy is facing right, jump to PRG058_9338

	LDA PRG058_Tomboy_XOffset_L,Y
	BPL PRG058_933F	; If offset is positive, jump to PRG058_933F

	DEC <Temp_Var0	; Temp_Var0 = $FF (16-bit sign extension)
	
	BMI PRG058_933F	; Jump (technically always) to PRG058_933F


PRG058_9338:
	LDA PRG058_Tomboy_XOffset_R,Y
	BPL PRG058_933F	; If offset is positive, jump to PRG058_933F

	DEC <Temp_Var0	; Temp_Var0 = $FF (16-bit sign extension)

PRG058_933F:
	ADD Spr_X+$00,X
	STA Spr_X+$00,X
	LDA Spr_XHi+$00,X
	ADC <Temp_Var0
	STA Spr_XHi+$00,X
	
	RTS	; $934E


PRG058_Tomboy_Flags2ByFrame:
	.byte $D2, $C0, $C0, $E7, $E7, $E8, $D2, $C0, $C0, $C0, $C0, $C0, $C0, $E7, $E7
	.byte $D5, $D2, $D2, $E8, $08, $0A


PRG058_Tomboy_Frames:
	.byte $06, $01, $0B


	; Negative of PRG058_Tomboy_XOffset_R
PRG058_Tomboy_XOffset_L:
	.byte $F8, $00, $F8, $00, $00, $00, $FC, $FC, $00, $FC, $FC, $00, $F8, $00, $00
	.byte $00, $F8, $00, $00, $00, $FC, $F8, $00, $04

	; Negative of PRG058_Tomboy_XOffset_L
PRG058_Tomboy_XOffset_R:
	.byte $08, $00, $08, $00, $00, $00, $04, $04, $00, $04, $04, $00, $08, $00, $00
	.byte $00, $08, $00, $00, $00, $04, $08, $00, $FC

PRG058_Tomboy_YOffset:
	.byte $00, $00, $08, $00, $00, $08, $04, $00, $00, $00, $FC, $00, $10, $00, $00
	.byte $08, $08, $0C, $FC, $0C, $FC, $04, $04, $FC


PRG058_Obj_SasoreenuSpawner:
	; Pharaoh Man scorpion thing

	LDA Weapon_FlashStopCnt+$00
	ORA Weapon_FlashStopCnt+$01
	BNE PRG058_942A	; If Flash Stopper is active, jump to PRG058_942A (RTS)
	
	; Flash Stopper is not active

	; Timer before spawning another Sasoreenu
	LDA Spr_Var2+$00,X
	BEQ PRG058_93CF	; If Spr_Var2 = 0, jump to PRG058_93CF

	; Spr_Var1/2 -= 1
	LDA Spr_Var1+$00,X
	SUB #$01
	STA Spr_Var1+$00,X
	LDA Spr_Var2+$00,X
	SBC #$00
	STA Spr_Var2+$00,X
	
	BNE PRG058_942A	; Jump (technically always) to PRG058_942A (RTS) [Spr_Var2 = 0 jumps over this, so it'll always be non-zero)


PRG058_93CF:
	STX <Temp_Var15	; Backup object index -> Temp_Var15
	
	JSR PRG063_FindFreeSlotMinIdx7	; Find empty slot
	BCS PRG058_942A	; If no empty slot available, jump to PRG058_942A (RTS)

	LDA #SPRSLOTID_SASOREENU
	STA Spr_SlotID+$00,Y
	
	; Emerging Sasoreenu
	LDA #SPRANM4_SASOREENU_EMERG
	JSR PRG063_CopySprSlotSetAnim

	; Behind quicksand
	LDA Spr_Flags+$00,Y
	ORA #SPR_BEHINDBG
	STA Spr_Flags+$00,Y
	
	; Y = $D8
	LDA #$D8
	STA Spr_Y+$00,Y
	
	; Bounding box $15, hurt Player, can't be shot
	LDA #$95
	STA Spr_Flags2+$00,Y
	
	; HP = 4
	LDA #$04
	STA Spr_HP+$00,Y
	
	; Up direction
	LDA #SPRDIR_UP
	STA Spr_FaceDir+$00,Y
	
	; Set velocity
	LDA #$00
	STA Spr_YVelFrac+$00,Y
	STA Spr_XVelFrac+$00,Y
	LDA #$01
	STA Spr_YVel+$00,Y
	STA Spr_XVel+$00,Y
	
	; Spr_Var2 = $03
	LDA #$03
	STA Spr_Var2+$00,Y
	
	LDA <RandomN+$03
	ADC <RandomN+$00
	AND #$01
	ADD Spr_XVel+$00,Y
	STA Spr_XVel+$00,Y
	
	LDX <Temp_Var15	; Restore object index -> 'X'
	
	; Reset spawn counter Spr_Var1/Spr_Var2 = $022C
	LDA #$02
	STA Spr_Var2+$00,X	
	LDA #$2C
	STA Spr_Var1+$00,X

PRG058_942A:
	RTS	; $942A


PRG058_Obj_Sasoreenu:
	JSR PRG058_Sasoreenu_DecVar3

	JSR PRG063_DoMoveVertOnlyH16

	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_UP
	BNE PRG058_9442	; If moving upward, jump to PRG058_9442

	LDA Spr_Y+$00,X
	CMP #$D0
	BLT PRG058_942A	; If Spr_Y < $D0, jump to PRG058_942A (RTS)

	; Delete Sasoreenu
	JMP PRG062_ResetSpriteSlot


PRG058_9442:
	LDA Spr_Y+$00,X
	CMP #$B0
	BGE PRG058_942A	; If Spr_Y >= $B0, jump to PRG058_942A (RTS)

	LDA #LOW(PRG058_Sasoreenu_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Sasoreenu_Cont)
	STA Spr_CodePtrH+$00,X
	
	; Face Player
	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir

	LDA <RandomN+$02
	ADC <RandomN+$00
	AND #$03
	TAY	; Y = 0 to 3 random
	
	LDA PRG058_Sasoreenu_Var4,Y
	STA Spr_Var4+$00,X
	
	; Set movement animation
	LDA #SPRANM4_SASOREENU_MOVE
	JSR PRG063_SetSpriteAnim

	; Set bounding box $15, hurt Player, allow shooting
	LDA #(SPRFL2_SHOOTABLE | SPRFL2_HURTPLAYER	| $15)
	STA Spr_Flags2+$00,X
	
PRG058_Sasoreenu_Cont:
	LDY #$14
	JSR PRG063_DoObjMoveSetFaceDir

	BCS PRG058_947C	; If Sasoreenu hit solid, jump to PRG058_947C

	; Haven't hit solid...

	DEC Spr_Var4+$00,X	; Spr_Var4-- (time before 
	BNE PRG058_949A	; If Spr_Var4 > 0, jump to PRG058_949A


PRG058_947C:
	; Sasoreenu going to sink back down
	LDA #SPRDIR_DOWN
	STA Spr_FaceDir+$00,X
	
	LDA #LOW(PRG058_Obj_Sasoreenu)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Obj_Sasoreenu)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var2 = $03
	LDA #$03
	STA Spr_Var2+$00,X
	
	LDA #(SPRFL2_HURTPLAYER | $15)
	STA Spr_Flags2+$00,X
	
	LDA #SPRANM4_SASOREENU_EMERG
	JSR PRG063_SetSpriteAnim


PRG058_949A:
	RTS	; $949A


PRG058_Sasoreenu_DecVar3:
	LDA Spr_Var2+$00,X
	BEQ PRG058_949A	; If Spr_Var2 = 0, jump to PRG058_949A (RTS)

	LDA Spr_Var3+$00,X
	BEQ PRG058_Sasoreenu_SpawnPoof	; If Spr_Var3 = 0, jump to PRG058_949A (RTS)

	DEC Spr_Var3+$00,X	; Spr_Var3--
	
	RTS	; $94A8


PRG058_Sasoreenu_SpawnPoof:
	DEC Spr_Var2+$00,X	; Spr_Var2--
	
	; Spr_Var3 = $08
	LDA #$08
	STA Spr_Var3+$00,X
	
	STX <Temp_Var15	; Backup object index -> Temp_Var15
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG058_949A	; If no free object slot, jump to PRG058_949A (RTS)

	LDA #SPRSLOTID_MISCSTUFF
	STA Spr_SlotID+$00,Y
	
	LDA #SPRANM4_SASOREENU_POOF
	JSR PRG063_CopySprSlotSetAnim

	LDA Spr_Var2+$00,X
	TAX		; X = Spr_Var2
	
	LDA #$C0	; $94C6
	SUB PRG058_Sasoreenu_PoofYOff,X
	STA Spr_Y+$00,Y
	
	LDA Spr_X+$00,Y
	ADD PRG058_Sasoreenu_PoofXOff,X
	STA Spr_X+$00,Y
	
	LDX <Temp_Var15	; Restore object index
	
	RTS	; $94DB


PRG058_Sasoreenu_PoofYOff:
	.byte $04, $14, $08
	
PRG058_Sasoreenu_PoofXOff:
	.byte $FA, $00, $06

PRG058_Sasoreenu_Var4:
	.byte $78, $50, $30, $50


PRG058_Obj_Battan:
	; Grasshopper thing from Bright Man
	
	; Spr_AnimTicks = 0
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	DEC Spr_Y+$00,X
	JSR PRG063_TestPlayerObjCollide
	INC Spr_Y+$00,X
	BCS PRG058_9515	; If Player isn't touching Battan, jump to PRG058_9515 (RTS)

	; Battan moving right
	LDA #SPRDIR_RIGHT
	STA Spr_FaceDir+$00,X
	
	; Spr_Var1 = $14
	LDA #$14
	STA Spr_Var1+$00,X
	
	LDA #LOW(PRG058_Obj_Battan_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Obj_Battan_Cont)
	STA Spr_CodePtrH+$00,X
	
	JSR PRG058_Battan_SelectHop

	; Halt horizontal movement
	LDA #$00
	STA Spr_XVelFrac+$00,X
	STA Spr_XVel+$00,X

PRG058_9515:
	RTS	; $9515


PRG058_Obj_Battan_Cont:
	LDA #$00
	STA Spr_AnimTicks+$00,X		; Spr_AnimTicks = 0
	STA Spr_Var4+$00,X			; Spr_Var4 = 0
	
	DEC Spr_Y+$00,X
	JSR PRG063_TestPlayerObjCollide
	INC Spr_Y+$00,X
	ROL Spr_Var4+$00,X	; Carry -> Bit 0 of Spr_Var4 (0 if touching, 1 if not)
	
	LDA Spr_Var1+$00,X
	BEQ PRG058_9571		; If Spr_Var1 = 0, jump to PRG058_9571

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG058_9571		; If Spr_Var1 > 0, jump to PRG058_9571

	INC Spr_Frame+$00,X	; Spr_Frame++
	
	LDY Spr_Frame+$00,X
	CPY #$06
	BNE PRG058_9544		; If Spr_Frame <> $06, jump to PRG058_9544

	; Spr_Frame = $00
	LDA #$00
	STA Spr_Frame+$00,X
	
	TAY	; $9543

PRG058_9544:
	LDA Spr_Y+$00,X
	ADD PRG058_Battan_YOff,Y
	STA Spr_Y+$00,X	
	
	LDA PRG058_Battan_Var1,Y
	STA Spr_Var1+$00,X
	
	LDA Spr_Frame+$00,X
	CMP #$04
	BLT PRG058_9571	; If frame < $04, jump to PRG058_9571
	BEQ PRG058_956B	; If frame = $04, jump to PRG058_956B

	LDA Spr_Var3+$00,X
	BNE PRG058_9571	; If Spr_Var3 <> 0, jump to PRG058_9571

	JSR PRG058_Battan_ResetVar3
	JSR PRG063_FlipObjDirAndSpr

	JMP PRG058_9571	; Jump to PRG058_9571


PRG058_956B:
	JSR PRG058_Battan_Hop

	DEC Spr_Var3+$00,X	; Spr_Var3--

PRG058_9571:
	LDY Spr_Frame+$00,X
	
	; Vertical movement check
	LDA PRG058_961E,Y
	TAY	; -> 'Y'
	JSR PRG063_DoObjVertMovement

	BCC PRG058_9591	; If Battan hasn't hit solid, jump to PRG058_9591
	
	; Hit solid

	LDA Spr_Frame+$00,X
	CMP #$04
	BNE PRG058_95AB	; If frame <> 4, jump to PRG058_95AB

	; Spr_Var1 = $01
	LDA #$01
	STA Spr_Var1+$00,X
	
	; Stop horizontal movement
	LDA #$00
	STA Spr_XVelFrac+$00,X
	STA Spr_XVel+$00,X

PRG058_9591:
	LDY Spr_Frame+$00,X
	
	; Horizontal movement check
	LDA PRG058_9624,Y
	TAY	; -> 'Y'
	JSR PRG063_DoObjMoveSetFaceDir

	BCC PRG058_95AB	; If Battan hasn't hit solid, jump to PRG058_95AB

	; Stop horizontal movement
	LDA #$00
	STA Spr_XVelFrac+$00,X
	STA Spr_XVel+$00,X
	
	JSR PRG063_FlipObjDirAndSpr
	JSR PRG058_Battan_SelectHop


PRG058_95AB:
	LDA Spr_Var4+$00,X
	BNE PRG058_95BF	; If Spr_Var4 <> 0, jump to PRG058_95BF

	; Player standing on Battan
	LDA Spr_Y+$00,X
	SUB #$13
	STA Spr_Y+$00
	JSR PRG063_MovePlayerWithObj
	JSR PRG063_PlayerHitFloorAlign


PRG058_95BF:
	RTS	; $95BF


PRG058_Battan_SelectHop:
	LDA <RandomN+$02
	ADC <RandomN+$00
	STA <RandomN+$00
	
	AND #$07			; 0 to 7 random
	STA Spr_Var2+$00,X	; -> Spr_Var2 (hop select)

PRG058_Battan_ResetVar3:
	LDY Spr_Var2+$00,X	; Y = 0 to 7
	
	LDA PRG058_Battan_Var3,Y
	STA Spr_Var3+$00,X
	
	RTS	; $95D4


PRG058_Battan_Hop:
	LDY Spr_Var2+$00,X	; Y = Spr_Var2 (hop select)
	
	LDA PRG058_Battan_YVelFrac,Y
	STA Spr_YVelFrac+$00,X
	
	LDA PRG058_Battan_YVel,Y
	STA Spr_YVel+$00,X
	
	LDA PRG058_Battan_XVelFrac,Y
	STA Spr_XVelFrac+$00,X
	
	LDA PRG058_Battan_XVel,Y
	STA Spr_XVel+$00,X
	
	; Battan's hop sound
	LDA #SFX_GRASSHOPPERHOP
	JSR PRG063_QueueMusSnd

	RTS	; $95F5


PRG058_Battan_Var3:
	.byte $03, $02, $02, $02, $03, $02, $03, $03
	
PRG058_Battan_XVelFrac:
	.byte $50, $A1, $A1, $A1, $50, $A1, $50, $50
	
PRG058_Battan_XVel:
	.byte $01, $01, $01, $01, $01, $01, $01, $01
	
PRG058_Battan_YVelFrac:
	.byte $00, $E5, $E5, $E5, $00, $E5, $00, $00
	
PRG058_Battan_YVel:
	.byte $04, $04, $04, $04, $04, $04, $04, $04
	
PRG058_961E:
	.byte $08, $06, $08, $0A, $0A, $06

PRG058_9624:
	.byte $10, $0E, $10, $12, $12, $0E


PRG058_Battan_YOff:
	.byte $00, $03, $00, $00, $F8, $08

PRG058_Battan_Var1:
	.byte $14, $06, $06, $06, $00, $06


PRG058_Obj17:
	; CHECKME - UNUSED?
	; Appears to be a Swallown spawner?
	JSR PRG063_SetObjFacePlayer

	STX <Temp_Var15		; Backup object slot index -> Temp_Var15

	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG058_969D		; If no free object slot, jump to PRG058_969D (RTS)

	LDA Spr_FaceDir,X
	ORA #SPRDIR_DOWN
	STA Spr_FaceDir,Y

	; Became a Swallown
	LDA #SPRSLOTID_SWALLOWN
	STA Spr_SlotID,Y

	LDA #SPRANM4_SWALLOWN2
	JSR PRG063_CopySprSlotSetAnim

	LDA <RandomN+$00
	ADC <RandomN+$03
	STA <RandomN+$03
	AND #$03
	TAX		; X = 0 to 3
	
	LDA PRG058_Obj17_YSet,X
	STA Spr_Y,Y
	STA Spr_Var5,Y

	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $0C)
	STA Spr_Flags2,Y

	; HP = 2
	LDA #$02
	STA Spr_HP,Y

	LDX <Temp_Var15		; Restore object slot index

	; This will then set its code to just execute RTS, becoming ineffective.
	; This object is probably simply not finished or it was used for internal dev.
	LDA #LOW(PRG058_969D)
	STA Spr_CodePtrL,X
	LDA #HIGH(PRG058_969D)
	STA Spr_CodePtrH,X

	; Spr_Var1 = $42
	LDA #$42
	STA Spr_Var1,Y

	; Spr_Var3 = $10
	LDA #$10
	STA Spr_Var3,Y

	; Spr_Var4 = $10
	LDA #$03
	STA Spr_Var4,Y



PRG058_CoswallownSetSpeed:
	; Coswallown's horizontal speed
	LDA #$33
	STA Spr_XVelFrac+$00,Y
	LDA #$01
	STA Spr_XVel+$00,Y
	
	; vertical speed
	LDA #$F0
	STA Spr_YVelFrac+$00,Y
	LDA #$01
	STA Spr_YVel+$00,Y

PRG058_969D:
	RTS	; $969D

PRG058_Obj17_YSet:
	; CHECKME - UNUSED?
	.byte $30, $48, $68, $88


PRG058_Obj_Swallown:
	; Bird with little birds in Toad Man

	LDA Spr_Var1+$00,X
	BNE PRG058_96C6	; If Spr_Var1 <> 0, jump to PRG058_96C6

	; Swallown's vertical speed
	LDA #$F0
	STA Spr_YVelFrac+$00,X
	LDA #$01
	STA Spr_YVel+$00,X
	
	; Spr_Var1 = $42
	LDA #$42
	STA Spr_Var1+$00,X
	
	; Spr_Var3 = $10
	LDA #$10
	STA Spr_Var3+$00,X
	
	; Spr_Var4 = $03
	LDA #$03
	STA Spr_Var4+$00,X
	
	; Spr_Var5 = Spr_Y
	LDA Spr_Y+$00,X	
	STA Spr_Var5+$00,X

PRG058_96C6:
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG058_96E4		; If Spr_Var1 > 0, jump to PRG058_96E4

	; Spr_Var1 = 0...

	; Swallown's horizontal speed
	LDA #$00
	STA Spr_XVelFrac+$00,X
	LDA #$03
	STA Spr_XVel+$00,X
	
	LDA #LOW(PRG058_9762)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_9762)
	STA Spr_CodePtrH+$00,X
	
	LDA #SPRANM4_SWALLOWN
	JMP PRG063_SetSpriteAnim


PRG058_96E4:
	LDA Spr_Var4+$00,X
	BEQ PRG058_973E	; If Spr_Var4 = 0, jump to PRG058_973E

	DEC Spr_Var3+$00,X	; Spr_Var3--
	BNE PRG058_973E		; If Spr_Var3 > 0, jump to PRG058_973E

	DEC Spr_Var4+$00,X	; Spr_Var4--
	
	STX <Temp_Var15		; Backup object slot index -> Temp_Var15

	; Spawning a Coswallown
		
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG058_969D		; If no free slot, jump to PRG058_969D (RTS)

	; Match Swallown
	LDA Spr_FaceDir+$00,X
	STA Spr_FaceDir+$00,Y
	
	LDA #SPRSLOTID_COSWALLOWN
	STA Spr_SlotID+$00,Y
	
	LDA #SPRANM4_COSWALLOWN
	JSR PRG063_CopySprSlotSetAnim

	; Coswallown's Y
	LDA Spr_Var5+$00,X
	STA Spr_Y+$00,Y	
	
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BNE PRG058_9717	; If facing right, jump to PRG058_9717

	LDA #$FF

PRG058_9717:
	ADD <Horz_Scroll
	STA Spr_X+$00,Y	
	LDA <Current_Screen
	ADC #$00
	STA Spr_XHi+$00,Y
	
	; Coswallown hurts Player and can be shot
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $0E)
	STA Spr_Flags2+$00,Y
	
	; Coswallown HP = 1
	LDA #$01
	STA Spr_HP+$00,Y
	
	JSR PRG058_CoswallownSetSpeed

	LDX <Temp_Var15		; Restore object slot
	
	; Transfer Spr_Var1
	LDA Spr_Var1+$00,X
	STA Spr_Var1+$00,Y
	
	; Spr_Var3 = $10
	LDA #$10
	STA Spr_Var3+$00,X

PRG058_973E:
	
	LDA Spr_YVelFrac+$00,X
	SUB #$10
	STA Spr_YVelFrac+$00,X
	LDA Spr_YVel+$00,X
	SBC #$00
	STA Spr_YVel+$00,X
	
	LDA Spr_YVelFracAccum+$00,X
	ADD Spr_YVelFrac+$00,X
	STA Spr_YVelFracAccum+$00,X
	LDA Spr_Y+$00,X
	ADC Spr_YVel+$00,X
	STA Spr_Y+$00,X	
	
PRG058_9762:
	JMP PRG063_ApplyVelSetFaceDir	; $9762

	; CHECKME - UNUSED?
	; Just a lonely RTS...
	RTS		; $9763


PRG058_Obj_Coswallown:
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BEQ PRG058_976E		; If Spr_Var1 = 0, jump to PRG058_976E

	JMP PRG058_973E	; Jump to PRG058_973E


PRG058_976E:
	JSR PRG063_AimTowardsPlayer	; Coswallown aims towards Player
	TAY	; -> 'Y'
	
	; Set Coswallown's facing direction
	LDA PRG058_Aim_FaceDir,Y
	STA Spr_FaceDir+$00,X
	
	; Set appropriate animation for aim
	LDA PRG058_Coswallown_Anim,Y
	JSR PRG063_SetSpriteAnim

	; Index irrespective of down/left flips
	TYA
	AND #$07
	TAY
	
	; Coswallown horizontal speed
	LDA PRG058_Coswallown_XVelFrac,Y
	STA Spr_XVelFrac+$00,X
	LDA PRG058_Coswallown_XVel,Y
	STA Spr_XVel+$00,X
	
	; Coswallown vertical speed
	LDA PRG058_Coswallown_YVelFrac,Y
	STA Spr_YVelFrac+$00,X
	LDA PRG058_Coswallown_YVel,Y
	STA Spr_YVel+$00,X
	
	LDA #LOW(PRG058_Coswallown_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Coswallown_Cont)
	STA Spr_CodePtrH+$00,X
	
	RTS	; $97A4

PRG058_Coswallown_Cont:
	JSR PRG063_ApplyVelSetFaceDir
	JMP PRG063_DoMoveVertOnlyH16


PRG058_Coswallown_XVelFrac:
	.byte $00, $EA, $B2, $36

PRG058_Coswallown_YVelFrac:
	.byte $66, $36, $B2, $EA, $00, $EA, $B2, $36


PRG058_Coswallown_XVel:
	.byte $00, $00, $01, $02
	
PRG058_Coswallown_YVel:
	.byte $02, $02, $01, $00, $00, $00, $01, $02

	; NOTE: This is actually a perfect clone of PRG063_Aim_FaceDir,
	; so this is totally unnecessary...
PRG058_Aim_FaceDir:
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
	
PRG058_Coswallown_Anim:
	.byte SPRANM4_COSWALLOWN_UP			; $00	SPRAIM_ANG_0	Up
	.byte SPRANM4_COSWALLOWN_DIAD		; $01	SPRAIM_ANG_22
	.byte SPRANM4_COSWALLOWN_DIAD		; $02 	SPRAIM_ANG_45	Up-Right
	.byte SPRANM4_COSWALLOWN_DIAD		; $03	SPRAIM_ANG_67
	.byte SPRANM4_COSWALLOWN			; $04	SPRAIM_ANG_90	Right
	.byte SPRANM4_COSWALLOWN_DIAU		; $05	SPRAIM_ANG_112
	.byte SPRANM4_COSWALLOWN_DIAU		; $06	SPRAIM_ANG_135	Down-Right
	.byte SPRANM4_COSWALLOWN_DIAU		; $07	SPRAIM_ANG_157
	.byte SPRANM4_COSWALLOWN_DOWN		; $08	SPRAIM_ANG_180	Down
	.byte SPRANM4_COSWALLOWN_DIAU		; $09	SPRAIM_ANG_202
	.byte SPRANM4_COSWALLOWN_DIAU		; $0A	SPRAIM_ANG_225	Down-left
	.byte SPRANM4_COSWALLOWN_DIAU		; $0B	SPRAIM_ANG_247
	.byte SPRANM4_COSWALLOWN			; $0C	SPRAIM_ANG_270	Left
	.byte SPRANM4_COSWALLOWN_DIAD		; $0D	SPRAIM_ANG_292
	.byte SPRANM4_COSWALLOWN_DIAD		; $0E	SPRAIM_ANG_315	Up-Left
	.byte SPRANM4_COSWALLOWN_DIAD		; $0F	SPRAIM_ANG_337


PRG058_Obj_WallBlaster:
	JSR PRG058_Wallblaster_AimIfExpire	; Aim gun

	LDA Spr_Var2+$00,X
	BEQ PRG058_97EF		; If Spr_Var2 = 0, jump to PRG058_97EF

	DEC Spr_Var2+$00,X	; Spr_Var2--
	RTS	; $97EE


PRG058_97EF:
	LDA <RandomN+$00
	ADC <RandomN+$02
	STA <RandomN+$02
	AND #$03
	BEQ PRG058_9809	; 1:4, jump to PRG058_9809

	INC Spr_Var1+$00,X	; Spr_Var1++
	LDA Spr_Var1+$00,X
	CMP #$03
	BEQ PRG058_9809	; If Spr_Var1 = 3, jump to PRG058_9809

	; Spr_Var2 = $3C
	LDA #$3C
	STA Spr_Var2+$00,X
	
	RTS	; $9808


PRG058_9809:
	ADC <RandomN+$01
	AND #$07	; 0 to 7
	TAY			; -> 'Y'
	
	LDA PRG058_Wallblaster_Var1,Y
	STA Spr_Var1+$00,X
	
	; Spr_Var2 = $3C
	LDA #$3C
	STA Spr_Var2+$00,X
	
	LDA #LOW(PRG058_Obj_WallBlaster_Shoot)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Obj_WallBlaster_Shoot)
	STA Spr_CodePtrH+$00,X
	
PRG058_Obj_WallBlaster_Shoot:
	JSR PRG058_Wallblaster_AimIfExpire

	LDA Spr_Var2+$00,X
	BEQ PRG058_9898		; If Spr_Var2 = 0, jump to PRG058_9898 (RTS)

	DEC Spr_Var2+$00,X	; Spr_Var2--
	BNE PRG058_9898		; If Spr_Var2 > 0, jump to PRG058_9898 (RTS)

	INC Spr_CurrentAnim+$00,X	; Spr_CurrentAnim++
	
	STX <Temp_Var15	; Backup object slot index -> Temp_Var15
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG058_9898	; If no free slot, jump to PRG058_9898 (RTS)

	; Wallblaster shot
	LDA #SPRSLOTID_WALLBLASTER_SHOT
	STA Spr_SlotID+$00,Y
	
	LDA Spr_Var3+$00,X
	TAX		; X = Spr_Var3
	
	; Set facing direction
	LDA PRG058_Aim_FaceDir,X
	STA Spr_FaceDir+$00,Y
	
	; Wallblaster shot horizontal speed
	LDA PRG058_Wallblaster_XVelFrac,X
	STA Spr_XVelFrac+$00,Y
	LDA PRG058_Wallblaster_XVel,X
	STA Spr_XVel+$00,Y
	
	; Wallblaster shot vertical speed
	LDA PRG058_Wallblaster_YVelFrac,X
	STA Spr_YVelFrac+$00,Y
	LDA PRG058_Wallblaster_YVel,X
	STA Spr_YVel+$00,Y
	
	; Shot init info index
	LDA PRG058_Wallblaster_ShotIdx,X
	STA <Temp_Var16
	
	LDX <Temp_Var15	; Restore object index
	
	LDA #SPRANM4_CIRCLEBULLET
	JSR PRG063_InitProjectile

	; Bullet hurts player
	LDA #(SPRFL2_HURTPLAYER | $0F)
	STA Spr_Flags2+$00,Y
	
	LDX <Temp_Var15	; Restore object index
	
	; Spr_Var5 = $10
	LDA #$10
	STA Spr_Var5+$00,X
	
	; Spr_Var2 = $1E
	LDA #$1E
	STA Spr_Var2+$00,X
	
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG058_9898		; If Spr_Var1 > 0, jump to PRG058_9898 (RTS)

	LDA #$00
	STA Spr_Var1+$00,X	; Spr_Var1 = 0
	STA Spr_Var2+$00,X	; Spr_Var2 = 0
	STA Spr_Var3+$00,X	; Spr_Var3 = 0

	; Return back to main routine
	LDA #LOW(PRG058_Obj_WallBlaster)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Obj_WallBlaster)
	STA Spr_CodePtrH+$00,X

PRG058_9898:
	RTS	; $9898


PRG058_Wallblaster_AimIfExpire:
	LDA Spr_Var5+$00,X
	BEQ PRG058_98A3		; If Spr_Var5 = 0, jump to PRG058_98A3

	DEC Spr_Var5+$00,X	; Spr_Var5--
	BNE PRG058_9898		; If Spr_Var5 > 0, jump to PRG058_9898 (RTS)


PRG058_98A3:
	JSR PRG063_Aim2Plyr_SetDir_Var4

	TYA
	BNE PRG058_98B6			; If aimed angle <> 0 (straight up), jump to PRG058_98B6

	LDY #SPRAIM_ANG_22		; High as it'll go

	LDA Spr_Flags+$00,X
	AND #SPR_HFLIP
	BNE PRG058_98C5			; If horizontally flipped, jump to PRG058_98C5

	LDY #SPRAIM_ANG_337		; Opposite if not flipped
	BNE PRG058_98C5			; Jump (technically always) to PRG058_98C5


PRG058_98B6:
	CMP #SPRAIM_ANG_180
	BNE PRG058_98C5			; If angle <> SPRAIM_ANG_180 (straight down), jump to PRG058_98C5

	LDY #SPRAIM_ANG_157		; Low as it'll go
	
	LDA Spr_Flags+$00,X
	AND #SPR_HFLIP
	BNE PRG058_98C5			; If horizontally flipped, jump to PRG058_98C5
	
	LDY #SPRAIM_ANG_202

PRG058_98C5:
	TYA
	STA Spr_Var3+$00,X		; Store angle -> Spr_Var3
	
	; Set appropriate animation
	LDA PRG058_Wallblaster_Anim,Y
	STA Spr_CurrentAnim+$00,X
	
	; Spr_Var5 = $08
	LDA #$08
	STA Spr_Var5+$00,X
	
	RTS	; $98D4


PRG058_Wallblaster_Var1:
	.byte $03, $03, $02, $01, $03, $03, $02, $03	; $98D5 - $98DC

PRG058_Wallblaster_Anim:
	.byte $00, SPRANM4_WALLBLASTER_22, SPRANM4_WALLBLASTER_45, SPRANM4_WALLBLASTER_62, SPRANM4_WALLBLASTER_90, SPRANM4_WALLBLASTER_112, SPRANM4_WALLBLASTER_135, SPRANM4_WALLBLASTER_157
	.byte $00, SPRANM4_WALLBLASTER_157, SPRANM4_WALLBLASTER_135, SPRANM4_WALLBLASTER_112, SPRANM4_WALLBLASTER_90, SPRANM4_WALLBLASTER_62, SPRANM4_WALLBLASTER_45, SPRANM4_WALLBLASTER_22

	; Overlap with PRG058_Wallblaster_YVelFrac as a quarter turn
PRG058_Wallblaster_XVelFrac:
	.byte $00, $C2, $6A, $DB

PRG058_Wallblaster_YVelFrac:
	.byte $00, $DB, $6A, $C2, $00, $C2, $6A, $DB, $00, $DB, $6A, $C2, $00, $C2, $6A, $DB

	; Overlap with PRG058_Wallblaster_YVel as a quarter turn
PRG058_Wallblaster_XVel:
	.byte $00, $00, $01, $01

PRG058_Wallblaster_YVel:
	.byte $02, $01, $01, $00, $00, $00, $01, $01, $02, $01, $01, $00, $00, $00, $01, $01
	
PRG058_Wallblaster_ShotIdx:
	.byte $00, $04, $05, $06, $07, $08, $09, $0A, $00, $13, $14, $15, $16, $17, $18, $19


PRG058_Obj_WallBlaster_Shot:
	; Wallblaster shot just goes
	JSR PRG063_ApplyVelSetFaceDir
	JMP PRG063_DoMoveVertOnlyH16


PRG058_Obj_100Watton:
	; Flying lightening bug thing from Bright Man

	LDA Spr_Frame+$00,X
	ORA Spr_AnimTicks+$00,X
	BNE PRG058_9936	; If frame or animation ticks not zero, jump to PRG058_9936

	INC Spr_Var1+$00,X	; Spr_Var1++

PRG058_9936:
	LDA Spr_AnimTicks+$00,X
	BNE PRG058_9967	; If animation ticks <> 0, jump to PRG058_9967

	LDA Spr_Frame+$00,X
	CMP #$09
	BNE PRG058_9967	; If frame <> 9, jump to PRG058_9967

	STX <Temp_Var15	; Backup index -> Temp_Var15
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG058_9987	; If no free slot, jump to PRG058_9987 (RTS)

	LDA #SPRSLOTID_MISCSTUFF
	STA Spr_SlotID+$00,Y
	
	; Temp_Var16 = $02 (projectile init index)
	LDA #$02
	STA <Temp_Var16
	
	LDA #SPRANM4_100WATTON_POOF
	JSR PRG063_InitProjectile

	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT	; 0 if left, 1 if right
	LSR A				; -> carry
	ROR A				; -> bit 7
	LSR A				; -> bit 6 (SPR_HFLIP)
	ORA Spr_Flags+$00,X	; OR with sprite flags
	STA Spr_Flags+$00,Y	; Update sprite flags
	
	LDX <Temp_Var15	; Restore 'X'

PRG058_9967:
	LDA Spr_Var1+$00,X
	CMP #$02
	BGE PRG058_997A	; If Spr_Var1 >= 2, jump to PRG058_997A

	JSR PRG063_ApplyVelSetFaceDir

	LDA Spr_Flags+$00,X
	AND #~SPR_HFLIP
	STA Spr_Flags+$00,X
	
	RTS	; $9979


PRG058_997A:
	INC Spr_CurrentAnim+$00,X
	
	LDA #LOW(PRG058_Obj_100Watton_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Obj_100Watton_Cont)
	STA Spr_CodePtrH+$00,X

PRG058_9987:
	RTS	; $9987

PRG058_Obj_100Watton_Cont:
	LDA Spr_Frame+$00,X
	CMP #$03
	BNE PRG058_99AA	; If frame <> 3, jump to PRG058_99AA

	LDA Spr_AnimTicks+$00,X
	CMP #$02
	BNE PRG058_99AA	; If animation ticks <> 2, jump to PRG058_99AA

	LDA #LOW(PRG058_Obj_100Watton)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Obj_100Watton)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var1 = 0
	LDA #$00
	STA Spr_Var1+$00,X
	
	LDA #SPRANM4_100WATTON
	JMP PRG063_SetSpriteAnim

PRG058_99AA:
	LDA Spr_AnimTicks+$00,X
	BNE PRG058_9987	; If animation ticks <> 0, jump to PRG058_9987 (RTS)

	LDA Spr_Frame+$00,X
	CMP #$01
	BNE PRG058_9987	; If frame <> 1, jump to PRG058_9987 (RTS)

	STX <Temp_Var15	; Backup object index -> Temp_Var15
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG058_9987	; If no free slot, jump to PRG058_9987 (RTS)

	; 100 Watton's shot
	LDA #SPRSLOTID_100WATTON_SHOT
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_XVelFrac+$00,Y
	STA Spr_XVel+$00,Y
	STA Spr_YVelFrac+$00,Y
	
	; Upward speed
	LDA #$04
	STA Spr_YVel+$00,Y
	
	; Temp_Var16 = 2 (projectile init index)
	LDA #$02
	STA <Temp_Var16
	
	LDA #SPRANM4_100WATTON_SHOT
	JSR PRG063_InitProjectile

	; Spr_Var2 = $20
	LDA #$20
	STA Spr_Var2+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $0E)	; ?? Why does his shot have shooting enabled?
	STA Spr_Flags2+$00,Y
	
	; ... and HP=2??
	LDA #$02
	STA Spr_HP+$00,Y
	
	LDX <Temp_Var15	; Restore object index
	
	RTS	; $99EC


PRG058_Obj_100Watton_Shot:
	JSR PRG063_DoMoveSimpleVert

	LDA Spr_Var2+$00,X
	BEQ PRG058_99FA	; If Spr_Var2 = 0, jump to PRG058_99FA

	DEC Spr_Var2+$00,X	; Spr_Var2--
	BNE PRG058_9A56		; If Spr_Var2 > 0, jump to PRG058_9A56 (RTS)


PRG058_99FA:
	INC Spr_Var1+$00,X	; Spr_Var1++
	LDA Spr_Var1+$00,X
	AND #$07
	BNE PRG058_9A56		; 7:8 jump to PRG058_9A56 (RTS)

	LDA <RandomN+$01
	ADC <RandomN+$02
	STA <RandomN+$02
	AND #$01
	BNE PRG058_9A56	; Randomly jump to PRG058_9A56 (RTS)

	JSR PRG062_ResetSpriteSlot

	LDA #$04
	STA <Temp_Var14	; Temp_Var14 = $04
	STX <Temp_Var15	; Temp_Var15 = $04

PRG058_9A17:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG058_9A56	; If no free slot, jump to PRG058_9A56 (RTS)

	LDA #SPRSLOTID_100WATTON_SHOT_BURST
	STA Spr_SlotID+$00,Y
	
	LDA #SPRANM4_100WATTON_BURST
	JSR PRG063_CopySprSlotSetAnim

	LDA #(SPRFL2_HURTPLAYER | $0F)
	STA Spr_Flags2+$00,Y
	
	; HP = 0
	LDA #$00
	STA Spr_HP+$00,Y
	
	LDX <Temp_Var14	; $9A30
	
	; 100 Watton's shot's burst horizontal speed
	LDA PRG058_100WBurst_XVelFrac,X
	STA Spr_XVelFrac+$00,Y
	LDA PRG058_100WBurst_XVel,X
	STA Spr_XVel+$00,Y
	
	; 100 Watton's shot's burst vertical speed
	LDA PRG058_100WBurst_YVelFrac,X
	STA Spr_YVelFrac+$00,Y
	LDA PRG058_100WBurst_YVel,X
	STA Spr_YVel+$00,Y
	
	LDA PRG058_100WBurst_FaceDir,X
	STA Spr_FaceDir+$00,Y
	
	LDX <Temp_Var15	; X = Temp_Var15
	
	DEC <Temp_Var14	; Temp_Var14--
	BPL PRG058_9A17	; While Temp_Var14 >= 0, loop


PRG058_9A56:
	RTS	; $9A56


PRG058_100WBurst_XVelFrac:
	.byte $80, $0F, $00, $0F, $80
	
PRG058_100WBurst_XVel:
	.byte $01, $01, $00, $01, $01
	
PRG058_100WBurst_YVelFrac:
	.byte $00, $0F, $80, $0F, $00
	
PRG058_100WBurst_YVel:
	.byte $00, $01, $01, $01, $00
	
PRG058_100WBurst_FaceDir:
	.byte SPRDIR_RIGHT, SPRDIR_RIGHT | SPRDIR_DOWN, SPRDIR_DOWN, SPRDIR_LEFT | SPRDIR_DOWN, SPRDIR_LEFT


PRG058_Obj_100Watton_ShotBurst:
	; The 100 Watton's shot's burst just moves
	JSR PRG063_ApplyVelSetFaceDir
	JMP PRG063_DoMoveVertOnlyH16


PRG058_Obj_Ratton:
	; Rat from Toad Man

	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir


PRG058_9A7C:
	LDA <RandomN+$02
	ADC <RandomN+$00
	STA <RandomN+$02
	AND #$03
	TAY	; Y = 0 to 3
	
	; Ratton's vertical movement
	LDA PRG058_Ratton_YVelFrac,Y
	STA Spr_YVelFrac+$00,X
	LDA PRG058_Ratton_YVel,Y
	STA Spr_YVel+$00,X
	
	; Ratton's horizontal movement
	LDA #$00
	STA Spr_XVelFrac+$00,X
	LDA #$01
	STA Spr_XVel+$00,X
	
	; Spr_Var1 = $20
	LDA #$20
	STA Spr_Var1+$00,X
	
	LDA #LOW(PRG058_Obj_Ratton_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Obj_Ratton_Cont)
	STA Spr_CodePtrH+$00,X
	
PRG058_Obj_Ratton_Cont:
	LDA Spr_Var1+$00,X
	BEQ PRG058_9ABD	; If Spr_Var1 = 0, jump to PRG058_9ABD

	; anim ticks = 0
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG058_9AFE		; If Spr_Var1 > 0, jump to PRG058_9AFE

	INC Spr_Frame+$00,X	; frame++
	RTS	; $9ABC


PRG058_9ABD:
	LDA Spr_Frame+$00,X
	CMP #$02
	BEQ PRG058_9ADF	; If frame = 2, jump to PRG058_9ADF

	CMP #$03
	BNE PRG058_9AFE	; If frame <> 3, jump to PRG058_9AFE

	LDA Spr_AnimTicks+$00,X
	CMP #$09
	BNE PRG058_9AFE	; If ticks <> 9, jump to PRG058_9AFE

	LDA Spr_XVel+$00,X
	BNE PRG058_9AD7	; If Ratton's XVel <> 0, jump to PRG058_9AD7

	JSR PRG063_FlipObjDirAndSpr

PRG058_9AD7:
	; Frame = 0
	LDA #$00
	STA Spr_Frame+$00,X
	JMP PRG058_9A7C	; Jump to PRG058_9A7C


PRG058_9ADF:
	; Reset animation
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	LDY #$0C
	JSR PRG063_DoObjVertMovement

	BCS PRG058_9AFB	; If Ratton hit solid, jump to PRG058_9AFB

	LDY #$14
	JSR PRG063_DoObjMoveSetFaceDir

	BCC PRG058_9AFE	; If Ratton has not hit wall, jump to PRG058_9AFE

	; Ratton stop
	LDA #$00
	STA Spr_XVelFrac,X
	STA Spr_XVel,X
	RTS


PRG058_9AFB:
	INC Spr_Frame+$00,X	; frame++

PRG058_9AFE:
	RTS	; $9AFE


PRG058_Ratton_YVelFrac:
	.byte $CC, $00, $6D, $00
	
PRG058_Ratton_YVel:
	.byte $04, $04, $03, $04


PRG058_Obj_SubBoss_Whopper:
	; The ring-based sub-boss

	LDA Spr_Var1+$00,X	
	BNE PRG058_9B11	; If Spr_Var1 <> 0, jump to PRG058_9B11

	; Spr_Var1 = $79
	LDA #$79
	STA Spr_Var1+$00,X

PRG058_9B11:
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG058_9AFE		; If Spr_Var1 > 0, jump to PRG058_9AFE (RTS)

	LDA #SPRANM4_WHOPPER_EYESOPEN
	JSR PRG063_SetSpriteAnim

	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir

	; Eyes can now be shot
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $02)
	STA Spr_Flags2+$00,X
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG058_9AFE	; If no free slot, jump to PRG058_9AFE (RTS)

	LDA #SPRSLOTID_SUBBOSS_WHOPPER_RING
	STA Spr_SlotID+$00,Y
	
	LDA #SPRANM4_WHOPPER_RINGS
	JSR PRG063_CopySprSlotSetAnim

	LDA Spr_Flags+$00,Y
	AND #~SPR_HFLIP
	STA Spr_Flags+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | $02)
	STA Spr_Flags2+$00,Y
	
	; HP = $12
	LDA #$12
	STA Spr_HP+$00,Y
	
	; Actually just changes to the RTS
	LDA #LOW(PRG058_9B51)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_9B51)
	STA Spr_CodePtrH+$00,X

PRG058_9B51:
	RTS	; $9B51


PRG058_9B52:
	.byte $06, $0A, $10, $10	; $9B52 - $9B55


PRG058_Obj_Whopper_Rings:
	LDA Spr_AnimTicks+$00,X
	CMP #$04
	BNE PRG058_9B51	; If animation ticks <> 4, jump to PRG058_9B51 (RTS)

	LDA Spr_Frame+$00,X
	BEQ PRG058_9B93	; If frame = 0, jump to PRG058_9B93

	JSR PRG062_ResetSpriteSlot

	; Temp_Var0 = SPRSLOTID_SUBBOSS_WHOPPER
	LDA #SPRSLOTID_SUBBOSS_WHOPPER
	STA <Temp_Var0
	
	; Trying to find Whopper
	JSR PRG058_FindObjInT0_orUseY7

	LDA Spr_SlotID+$00,Y
	BEQ PRG058_9B51	; If an empty slot was returned, Whopper could not be found for some reason (dead?)... jump to PRG058_9B51 (RTS)

	LDA #SPRANM4_WHOOPER_IDLE
	JSR PRG063_SetSpriteAnimY

	; Hurt player, bounding box $13
	LDA #(SPRFL2_HURTPLAYER | $13)
	STA Spr_Flags2+$00,Y	; $9B78
	
	; Spr_Var1 = $00
	LDA #$00
	STA Spr_Var1+$00,Y
	
	LDA Spr_Flags+$00,Y
	AND #~SPR_HFLIP
	STA Spr_Flags+$00,Y
	
	LDA #LOW(PRG058_Obj_SubBoss_Whopper)
	STA Spr_CodePtrL+$00,Y
	LDA #HIGH(PRG058_Obj_SubBoss_Whopper)
	STA Spr_CodePtrH+$00,Y
	RTS	; $9B92


PRG058_9B93:
	LDA Spr_Flags+$00,X
	ORA #SPRFL1_NODRAW
	STA Spr_Flags+$00,X
	
	LDA #LOW(PRG058_9C0E)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_9C0E)
	STA Spr_CodePtrH+$00,X
	
	LDA <RandomN+$01
	ADC <RandomN+$03
	STA <RandomN+$03
	AND #$03
	TAY	; Y = 0 to 3
	
	LDA PRG058_9B52,Y
	STA Spr_Var1+$00,X
	
	; Temp_Var14 = $05
	LDA #$05
	STA <Temp_Var14
	
	STX <Temp_Var15	; Backup object index -> Temp_Var15

PRG058_9BBA:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG058_9B51	; If no free slot, jump to PRG058_9B51 (RTS)

	LDA #SPRSLOTID_SUBBOSS_WHOPPER_RIN2
	STA Spr_SlotID+$00,Y
	
	LDX <Temp_Var14	; X = current ring index
	
	LDA PRG058_WhopperRing_ProjInitIdx,X
	STA <Temp_Var16	; -> Temp_Var16
	
	LDX <Temp_Var15	; Restore object index
	
	LDA #SPRANM4_WHOPPER_RING
	JSR PRG063_InitProjectile

	LDA Spr_Flags+$00,Y
	ORA #SPRFL1_PERSIST
	STA Spr_Flags+$00,Y
	
	LDA Spr_Var1+$00,X
	STA Spr_Var1+$00,Y
	STA Spr_Var2+$00,Y
	
	LDX <Temp_Var14	; X = current ring index
	
	; Ring horizontal speed
	LDA PRG058_WhopperRing_XVelFrac,X
	STA Spr_XVelFrac+$00,Y
	LDA PRG058_WhopperRing_XVel,X
	STA Spr_XVel+$00,Y
	
	; Ring vertical speed
	LDA PRG058_WhopperRing_YVelFrac,X
	STA Spr_YVelFrac+$00,Y
	LDA PRG058_WhopperRing_YVel,X
	STA Spr_YVel+$00,Y
	
	; Direction
	LDA PRG058_WhopperRing_FaceDir,X
	STA Spr_FaceDir+$00,Y
	
	; Hurt player, bounding box $0D
	LDA #(SPRFL2_HURTPLAYER | $0D)
	STA Spr_Flags2+$00,Y
	
	LDX <Temp_Var15	; restore object index
	
	DEC <Temp_Var14	; Temp_Var14--
	BPL PRG058_9BBA	; While Temp_Var14 >= 0, loop


PRG058_9C0E:
	RTS	; $9C0E


PRG058_WhopperRing_ProjInitIdx:
	.byte $02, $0B, $0C, $0F, $0D, $0E
	
PRG058_WhopperRing_XVelFrac:
	.byte $00, $ED, $ED, $00, $ED, $ED
	
PRG058_WhopperRing_XVel:
	.byte $00, $06, $06, $00, $06, $06
	
PRG058_WhopperRing_YVelFrac:
	.byte $00, $00, $00, $00, $00, $00
	
PRG058_WhopperRing_YVel:
	.byte $08, $04, $04, $08, $04, $04
	
PRG058_WhopperRing_FaceDir:
	.byte SPRDIR_UP, SPRDIR_UP | SPRDIR_RIGHT, SPRDIR_DOWN | SPRDIR_RIGHT, SPRDIR_DOWN, SPRDIR_DOWN | SPRDIR_LEFT, SPRDIR_UP | SPRDIR_LEFT


PRG058_Obj_Whopper_Ring:
	LDA #$00
	STA Spr_AnimTicks+$00,X
	JSR PRG063_ApplyVelSetFaceDir
	JSR PRG063_DoMoveVertOnlyH16

	LDA Spr_Flags+$00,X
	AND #~SPR_HFLIP
	STA Spr_Flags+$00,X
	
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG058_9CA1	; If Spr_Var1 > 0, jump to PRG058_9CA1 (RTS)

	LDA Spr_Frame+$00,X
	BNE PRG058_9C62	; If frame frame <> 0, jump to PRG058_9C62

	INC Spr_Frame+$00,X	; frame++
	
	; Full directional reverse
	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_DOWN | SPRDIR_LEFT | SPRDIR_RIGHT | SPRDIR_UP)
	STA Spr_FaceDir+$00,X
	
	LDA Spr_Var2+$00,X
	STA Spr_Var1+$00,X	; Spr_Var1 = Spr_Var2
	
	RTS	; $9C61


PRG058_9C62:
	JSR PRG062_ResetSpriteSlot

	; Trying to locate the ring origin
	LDA #SPRSLOTID_SUBBOSS_WHOPPER_RING
	STA <Temp_Var0
	JSR PRG058_FindObjInT0_orUseY7

	LDA Spr_SlotID+$00,Y
	BEQ PRG058_9C0E	; If ring origin wasn't found, jump to PRG058_9C0E (RTS)

	LDA Spr_Flags+$00,Y
	AND #~SPRFL1_NODRAW
	STA Spr_Flags+$00,Y
	
	; Spr_Frame = $01
	LDA #$01
	STA Spr_Frame+$00,Y
	
	; Spr_AnimTicks = 0
	LDA #$00
	STA Spr_AnimTicks+$00,Y
	
	LDA #LOW(PRG058_Obj_Whopper_Rings)
	STA Spr_CodePtrL+$00,Y
	LDA #HIGH(PRG058_Obj_Whopper_Rings)
	STA Spr_CodePtrH+$00,Y
	
	RTS	; $9C8D


	; This seeks for the sprite object slot ID matching Temp_Var0
	; between slot indexes $07 and $17, returned in 'Y'.
	; If not found, it just deletes whatever's at Y = $07.
PRG058_FindObjInT0_orUseY7:
	LDY #$17	; Y = $17
PRG058_9C90:
	LDA Spr_SlotID+$00,Y
	BEQ PRG058_9C99	; If slot is empty, jump to PRG058_9C99

	CMP <Temp_Var0
	BEQ PRG058_9CA1	; If the slot ID = Temp_Var0, jump to PRG058_9CA1 (RTS)


PRG058_9C99:
	DEY			; Y--
	CPY #$07	
	BNE PRG058_9C90	; While Y > 7, loop!

	; If you get this far, just delete what's at Y = 7
	JSR PRG063_DeleteObjectY

PRG058_9CA1:
	RTS	; $9CA1


PRG058_Obj_Haehaey:
	JSR PRG063_SetObjFacePlayer
	
	JSR PRG058_Haehaey_SetXVel

	; Spr_Var1 = $28
	LDA #$28
	STA Spr_Var1+$00,X
	
	LDA #LOW(PRG058_Obj_Haehaey_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Obj_Haehaey_Cont)
	STA Spr_CodePtrH+$00,X
	

PRG058_Obj_Haehaey_Cont:
	JSR PRG063_ApplyVelSetFaceDir

	LDA Spr_X+$00,X
	SUB <Horz_Scroll
	TAY	; X diff -> 'Y'
	
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BNE PRG058_9CCF	; If Haehaey is going right, jump to PRG058_9CCF

	; going left...

	CPY #$10
	BLT PRG058_9CD3	; If difference < $10, jump to PRG058_9CD3

	JMP PRG058_9CE3	; Jump to PRG058_9CE3


PRG058_9CCF:
	; going right...

	CPY #$F0
	BLT PRG058_9CE3	; If difference < $F0, jump to PRG058_9CE3


PRG058_9CD3:
	LDA Spr_Var4+$00,X
	CMP #$02
	BEQ PRG058_9CE3	; If Spr_Var4 = 2, jump to PRG058_9CE3

	INC Spr_Var4+$00,X	; Spr_Var4++
	
	JSR PRG063_FlipObjDirAndSpr
	JSR PRG058_Haehaey_SetXVel	


PRG058_9CE3:
	LDA Spr_Var1+$00,X
	BEQ PRG058_9CFE	; If Spr_Var1 = 0, jump to PRG058_9CFE

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG058_9D47	; If Spr_Var1 > 0, jump to PRG058_9D47 (RTS)

	LDA <RandomN+$02
	ADC <RandomN+$01
	STA <RandomN+$02
	AND #$07
	TAY	; Y = 0 to 7
	
	LDA PRG058_Haehaey_Var2,Y
	STA Spr_Var2+$00,X
	
	BNE PRG058_9D03	; Jump (technically always) to PRG058_9D03


PRG058_9CFE:
	DEC Spr_Var3+$00,X	; Spr_Var3--
	BNE PRG058_9D47	; If Spr_Var3 > 0, jump to PRG058_9D47 (RTS)


PRG058_9D03:
	STX <Temp_Var15	; Backup object slot -> Temp_Var15
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG058_9D47	; If no empty object slot, jump to PRG058_9D47 (RTS)

	LDA #SPRSLOTID_HAEHAEY_SHOT
	STA Spr_SlotID+$00,Y
	
	; Shot speed
	LDA #$00
	STA Spr_YVelFrac+$00,Y
	LDA #$02
	STA Spr_YVel+$00,Y
	
	LDA #SPRANM4_HAEHAEY_SHOT
	JSR PRG063_CopySprSlotSetAnim

	LDA Spr_Y+$00,Y
	ADD #$0C
	STA Spr_Y+$00,Y
	
	LDA #SPRDIR_DOWN
	STA Spr_FaceDir+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | $0F)
	STA Spr_Flags2+$00,Y
	
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	TAY	; Y = 0 if left, 1 if right
	
	LDA PRG058_9D63,Y
	STA Spr_Var3+$00,X
	
	DEC Spr_Var2+$00,X	; Spr_Var2--
	BNE PRG058_9D47	; If Spr_Var2 > 0, jump to PRG058_9D47 (RTS)

	; Spr_Var1 = $3C
	LDA #$3C
	STA Spr_Var1+$00,X

PRG058_9D47:
	RTS	; $9D47


PRG058_Haehaey_SetXVel:
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	TAY	; Y = 0 if left, 1 if right
	
	LDA PRG058_Haehaey_XVelFrac,Y
	STA Spr_XVelFrac+$00,X
	LDA PRG058_Haehaey_XVel,Y
	STA Spr_XVel+$00,X
	
	RTS	; $9D5A


PRG058_Haehaey_Var2:
	.byte $01, $02, $01, $03, $01, $02, $03, $01
	
PRG058_9D63:
	.byte $0E, $08

	;                               L    R
PRG058_Haehaey_XVelFrac:	.byte $80, $00
PRG058_Haehaey_XVel:		.byte $02, $04


PRG058_Obj_Haehaey_Shot:
	JMP PRG063_DoMoveVertOnlyH16


PRG058_Obj_Rackaser:
	; Little Metall type guy with the umbrella

	LDA Spr_Flags+$00,X
	AND #SPRFL1_NODRAW
	BEQ PRG058_9D8D	; If not drawing, jump to PRG058_9D8D

	JSR PRG063_CalcObjXDiffFromPlayer

	CMP #$3C
	BGE PRG058_9DA9	; If the difference >= $3C, jump to PRG058_9DA9 (RTS)

	LDA Spr_Flags+$00,X
	AND #~SPRFL1_NODRAW
	STA Spr_Flags+$00,X
	
	; Rackaser's fall rate
	LDA #$80
	STA Spr_YVelFrac+$00,X
	LDA #$01
	STA Spr_YVel+$00,X
	
	RTS	; $9D8C


PRG058_9D8D:
	LDY #$0A
	JSR PRG063_ObjMoveVert_HitFloor
	BCC PRG058_9DA9	; If not hit floor, jump to PRG058_9DA9 (RTS)

	LDA #SPRANM4_RACKASER_CLOSEUMB
	JSR PRG063_SetSpriteAnim
	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir

	LDA #LOW(PRG058_Obj_Rackaser_CloseU)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Obj_Rackaser_CloseU)
	STA Spr_CodePtrH+$00,X

PRG058_9DA9:
	RTS	; $9DA9


PRG058_Obj_Rackaser_CloseU:
	LDA Spr_Frame+$00,X
	CMP #$07
	BLT PRG058_9DA9	; If frame < 7, jump to PRG058_9DA9 (RTS)

	LDA #SPRANM4_RACKASER_TOSSUMB
	JSR PRG063_SetSpriteAnim

	; Vertical stop
	LDA #$00
	STA Spr_YVelFrac+$00,X
	STA Spr_YVel+$00,X
	
	LDA #LOW(PRG058_Obj_Rackaser_TossU)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Obj_Rackaser_TossU)
	STA Spr_CodePtrH+$00,X
	
	RTS	; $9DC8


PRG058_Obj_Rackaser_TossU:
	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM4_RACKASER_RUN
	BNE PRG058_9DE1	; If not running, jump to PRG058_9DE1

	LDY #$0E
	JSR PRG063_DoObjVertMovement
	BCC PRG058_9DA9	; If not hit solid, jump to PRG058_9DA9 (RTS)

	LDY #$18
	JSR PRG063_DoObjMoveSetFaceDir
	BCC PRG058_9DA9	; If not hit solid, jump to PRG058_9DA9 (RTS)

	; Turn around
	JMP PRG063_FlipObjDirAndSpr


PRG058_9DE1:
	LDA Spr_AnimTicks+$00,X
	CMP #$02
	BNE PRG058_9DA9	; If anim ticks <> 2, jump to PRG058_9DA9 (RTS)

	LDA Spr_Frame+$00,X
	CMP #$08
	BEQ PRG058_9E06	; If frame = 8, jump to PRG058_9E06

	CMP #$09
	BNE PRG058_9DA9	; If frame <> 9, jump to PRG058_9DA9 (RTS)

	; Drop 8 pixels
	LDA Spr_Y+$00,X
	ADD #$08
	STA Spr_Y+$00,X
	
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE)
	STA Spr_Flags2+$00,X
	
	LDA #SPRANM4_RACKASER_RUN
	JMP PRG063_SetSpriteAnim


PRG058_9E06:
	STX <Temp_Var15	; Backup object index -> Temp_Var15
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG058_9E3B	; If no object slot free, jump to PRG058_9E3B

	LDA #SPRSLOTID_RACKASER_UMBRELLA
	STA Spr_SlotID+$00,Y
	
	; Umbrella speed
	LDA #$00
	STA Spr_XVelFrac+$00,Y
	LDA #$02
	STA Spr_XVel+$00,Y
	
	; Copy facing direction
	LDA Spr_FaceDir+$00,X
	STA Spr_FaceDir+$00,Y
	
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	ADD #$11
	STA <Temp_Var16	; Temp_Var16 = $11 (if left), $12 (if right)
	
	LDA #SPRANM4_RACKASER_UMBRELLA
	JSR PRG063_InitProjectile

	; Hurt player, shootable, bounding box $1A
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $1A)
	STA Spr_Flags2+$00,Y
	
	; HP = 1
	LDA #$01
	STA Spr_HP+$00,Y

PRG058_9E3B:
	RTS	; $9E3B


PRG058_Obj_Rackaser_Umb:
	; Umbrella just moves
	JMP PRG063_ApplyVelSetFaceDir


PRG058_Obj_Dompan:
	; Little green guy in Bright Man that shoots fireworks

	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM4_DOMPAN_JUMP
	BNE PRG058_9E4D	; If animation <> SPRANM4_DOMPAN_JUMP, jump to PRG058_9E4D

	; Dompan jumping...

	LDA Spr_Frame+$00,X
	AND #$01
	BEQ PRG058_9E99	; Every other frame, jump to PRG058_9E99


PRG058_9E4D:
	JSR PRG058_Dompan_MoveJump

	LDY #$14
	JSR PRG063_DoObjMoveSetFaceDir
	BCS PRG058_9E6C	; If hit solid, jump to PRG058_9E6C

	LDA Spr_Var1+$00,X
	BNE PRG058_9E99	; If Spr_Var1 > 0, jump to PRG058_9E99 (RTS)

	; Dompan turns to face player every 64 ticks
	INC Spr_Var2+$00,X	; Spr_Var2++
	LDA Spr_Var2+$00,X
	AND #$3F			; Cap $00-$3F
	STA Spr_Var2+$00,X
	BNE PRG058_9E99	; If Spr_Var2 <> 0, jump to PRG058_9E99 (RTS)

	; Face player
	JMP PRG063_SetObjFacePlayer


PRG058_9E6C:
	LDA Spr_Var1+$00,X
	BNE PRG058_9E84	; If Spr_Var1 > 0, jump to PRG058_9E84

	LDA #SPRANM4_DOMPAN_JUMP
	JSR PRG063_SetSpriteAnim

	; Jump speed
	LDA #$25
	STA Spr_YVelFrac+$00,X
	LDA #$04
	STA Spr_YVel+$00,X
	
	INC Spr_Var1+$00,X	; Spr_Var1++
	RTS	; $9E83


PRG058_9E84:
	LDA Spr_YVel+$00,X
	BPL PRG058_9E99	; If Y Vel > 0, jump to PRG058_9E99

	; Turn around
	LDA Spr_FaceDir,X
	EOR #(SPRDIR_RIGHT | SPRDIR_LEFT)
	STA Spr_FaceDir,X
	
	LDA #$00
	STA Spr_XVelFrac,X
	STA Spr_XVel,X


PRG058_9E99:
	RTS	; $9E99


PRG058_Dompan_MoveJump:
	LDY #$08
	JSR PRG063_DoObjVertMovement
	BCS PRG058_9EBD	; If hit solid, jump to PRG058_9EBD

	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	LDA Spr_Var1+$00,X
	BNE PRG058_9EE5	; If Spr_Var1 > 0, jump to PRG058_9EE5 (RTS)

	; Stop horizontal movement
	STA Spr_XVelFrac+$00,X
	STA Spr_XVel+$00,X
	
	INC Spr_Var1+$00,X	; Spr_Var1++
	
	LDA #SPRANM4_DOMPAN_JUMP
	JSR PRG063_SetSpriteAnim

	INC Spr_Frame+$00,X	; Spr_Frame++
	
	RTS	; $9EBC


PRG058_9EBD:
	LDA Spr_Var1+$00,X
	BEQ PRG058_9EE5	; If Spr_Var1 = 0, jump to PRG058_9EE5 (RTS)

	LDA Spr_Frame+$00,X
	CMP #$03
	BEQ PRG058_9ED3	; If frame = 3, jump to PRG058_9ED3

	CMP #$02
	BGE PRG058_9EE5	; If frame >= 2, jump to PRG058_9EE5

	; Frame = 2
	LDA #$02
	STA Spr_Frame+$00,X
	
	RTS	; $9ED2


PRG058_9ED3:
	DEC Spr_Var1+$00,X	; Spr_Var1--
	
	LDA #SPRANM4_DOMPAN_WALK
	JSR PRG063_SetSpriteAnim

	; Resume walking
	LDA #$00
	STA Spr_XVelFrac+$00,X
	LDA #$01
	STA Spr_XVel+$00,X

PRG058_9EE5:
	RTS	; $9EE5


PRG058_Obj_DompanDeath:
	; A temporary object so Dompan can appear to die but spawn fireworks

	; Reset for Dompan
	JSR PRG062_ResetSpriteSlot

	; Poof away
	LDA #SPRANM4_SMALLPOOFEXP
	JSR PRG063_SetSpriteAnim

	; Become an inert object
	LDA #SPRSLOTID_MISCSTUFF
	STA Spr_SlotID+$00,X
	
	STX <Temp_Var15	; Backup slot index
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG058_9F1B	; If no free slot object, jump to PRG058_9F1B

	; New object will be the fireworks
	LDA #SPRSLOTID_DOMPAN_FIREWORKS
	STA Spr_SlotID+$00,Y
	
	LDA #SPRANM4_DOMPAN_FIREWORKS
	JSR PRG063_CopySprSlotSetAnim

	LDA #$00
	STA Spr_Flags2+$00,Y
	
	; Fireworks speed
	LDA #$00
	STA Spr_YVelFrac+$00,Y
	LDA #$06
	STA Spr_YVel+$00,Y
	
	LDA #$00
	STA Spr_Var1+$00,Y	; Spr_Var1 = 0
	STA Spr_Var2+$00,Y	; Spr_Var2 = 0

PRG058_9F1B:
	CLC	; ??
	
	RTS	; $9F1C


PRG058_Obj_DompanFireworks:
	LDA Spr_Var1+$00,X
	BEQ PRG058_9F28	; If Spr_Var1 = 0, jump to PRG058_9F28

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BEQ PRG058_9F38	; If Spr_Var1 = 0, jump to PRG058_9F38

	RTS	; $9F27


PRG058_9F28:
	JSR PRG063_DoMoveSimpleVert

	LDA Spr_YVel+$00,X
	BPL PRG058_9EE5	; If Spr_YVel > 0, jump to PRG058_9EE5 (RTS)

	LDA Spr_Flags+$00,X
	ORA #SPRFL1_NODRAW
	STA Spr_Flags+$00,X

PRG058_9F38:
	STX <Temp_Var15	; Backup object slot index -> Temp_Var15
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG058_9EE5	; If no slot available, jump to PRG058_9EE5 (RTS)

	LDA #SPRSLOTID_MISCSTUFF
	STA Spr_SlotID+$00,Y
	
	; Spr_Flags2 = 0
	LDA #$00
	STA Spr_Flags2+$00,Y
	
	LDA Spr_Var2+$00,X
	ADD #$1C
	STA <Temp_Var16	; Temp_Var16 = Spr_Var2 + $1C
	
	LDA #SPRANM4_DOMPAN_FIREWORKE
	JSR PRG063_InitProjectile

	; Spr_Var1 = $0A
	LDA #$0A
	STA Spr_Var1+$00,X
	
	INC Spr_Var2+$00,X	; Spr_Var2++
	LDA Spr_Var2+$00,X
	CMP #$03			; Cap 0-3
	BNE PRG058_9F7E		; 3:4 jump to PRG058_9F7E (RTS)

	JSR PRG062_ResetSpriteSlot

	LDA Level_LightDarkCtl
	BEQ PRG058_9F7E
	BMI PRG058_9F7E		; If not dark, jump to PRG058_9F7E (RTS)

	; Brighten up
	LDA #$00
	STA Level_LightDarkTransCnt
	LDA #$30
	STA Level_LightDarkTransLevel
	LDA #$80
	STA Level_LightDarkCtl

PRG058_9F7E:
	RTS	; $9F7E

	; CHECKME - UNUSED?
	.byte $00, $08, $10, $00, $F8, $10	; $9F7F - $9F84


PRG058_Obj_CircularExplosion:
PRG058_Obj47:
PRG058_Obj_SpiralExplosion:
	LDA #SFX_EXPLOSION
	JSR PRG063_QueueMusSnd

	LDA #LOW(PRG058_Obj_PostExplodeSound)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG058_Obj_PostExplodeSound)
	STA Spr_CodePtrH+$00,X
	
PRG058_Obj_PostExplodeSound:
	LDA Spr_Var1+$00,X
	BEQ PRG058_9FA0	; If Spr_Var1 = 0, jump to PRG058_9FA0

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG058_9FDE	; If Spr_Var1 > 0, jump to PRG058_9FDE

	LDA #$01	; A = 1

PRG058_9FA0:
	STA <Temp_Var14	; Update Temp_Var14
	
	STX <Temp_Var15	; Backup object slot index -> Temp_Var15

PRG058_9FA4:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG058_9FDE	; If no free object slot, jump to PRG058_9FDE (RTS)

	; Inert object
	LDA #SPRSLOTID_MISCSTUFF
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_Flags2+$00,Y
	
	LDA #$00
	STA Spr_HP+$00,Y
	
	LDA Spr_Var2+$00,X
	TAX		; X = Spr_Var2
	
	LDA PRG058_Obj_ExpProjInitIdx,X
	STA <Temp_Var16
	
	LDX <Temp_Var15	; Restore object index
	
	LDA #SPRANM4_SMALLPOOFEXP
	JSR PRG063_InitProjectile

	INC Spr_Var2+$00,X	; Spr_Var2++
	
	DEC <Temp_Var14	; Temp_Var14--
	BPL PRG058_9FA4	; While Temp_Var14 > 0, loop

	; Spr_Var1 = 2
	LDA #$02
	STA Spr_Var1+$00,X
	
	LDA Spr_Var2+$00,X
	CMP #$09
	BNE PRG058_9FDE	; If Spr_Var2 <> 9, jump to PRG058_9FDE (RTS)

	JSR PRG062_ResetSpriteSlot

PRG058_9FDE:
	RTS	; $9FDE


PRG058_Obj_ExpProjInitIdx:
	.byte $1C, $1F, $20, $21, $22, $23, $24, $02, $0F

	.org $9FE8		; Putting this here because the function is split over 58-59 and there's no nice way to handle it in NESASM
PRG058_Obj_CExplosion:
	LDA Spr_Var1+$00,X
	BEQ PRG058_9FF2	; If Spr_Var1 = 0, jump to PRG058_9FF2

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_A02A		; If Spr_Var1 > 0, jump to PRG059_A02A

PRG058_9FF2:
	STX <Temp_Var15	; Backup object slot -> Temp_Var15
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_A02A		; If no free object slot, jump to PRG059_A02A (RTS)
	
	LDA #SFX_EXPLOSION
	JSR PRG063_QueueMusSnd

	LDA #SPRSLOTID_CIRCULAREXPLOSION

	; CONTINUED ON PRG059
