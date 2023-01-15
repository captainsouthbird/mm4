	; CONTINUED FROM PRG058, CAUTION!!

	STA Spr_SlotID+$00,Y
	
	; Spr_Flags2 = 0
	LDA #$00
	STA Spr_Flags2+$00,Y
	
	LDA Spr_Var2+$00,X
	TAX	; X = Spr_Var2
	
	LDA PRG058_CExp_ExpProjInitIdx,X
	STA <Temp_Var16
	
	LDX <Temp_Var15	; Restore object index
	
	LDA #SPRANM4_SMALLPOOFEXP
	JSR PRG063_InitProjectile

	; Spr_Var1 = 6
	LDA #$06
	STA Spr_Var1+$00,X
	
	INC Spr_Var2+$00,X	; Spr_Var2++
	LDA Spr_Var2+$00,X
	CMP #$05
	BNE PRG059_A02A	; If Spr_Var2 < 5, jump to PRG059_A02A

	; End
	JSR PRG062_ResetSpriteSlot


PRG059_A02A:
	RTS	; $A02A


PRG058_CExp_ExpProjInitIdx:
	.byte $25, $26, $27, $28, $1C


PRG059_Obj_Minoan:
	LDA Spr_CurrentAnim+$00,X
	CMP #$0A	; $A033
	BNE PRG059_A067	; $A035

	LDY #$0E
	JSR PRG063_DoObjVertMovement
	BCS PRG059_A044	; If Minoan hit floor, jump to PRG059_A044

	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	RTS	; $A043


PRG059_A044:
	LDA Spr_Frame+$00,X
	CMP #$08
	BNE PRG059_A0BC	; If frame <> 8, jump to PRG059_A0BC

	; Spr_Var1 = $14
	LDA #$14
	STA Spr_Var1+$00,X
	
	LDA #LOW(PRG059_Obj_Minoan_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Minoan_Cont)
	STA Spr_CodePtrH+$00,X
	
	; Stop vertical
	LDA #$00
	STA Spr_YVelFrac+$00,X
	STA Spr_YVel+$00,X
	
	LDA #SPRANM4_MINOAN_TWIRL
	JMP PRG063_SetSpriteAnim


PRG059_A067:
	JSR PRG063_CalcObjXDiffFromPlayer

	CMP #$50
	BLT PRG059_A080	; If X difference < $50, jump to PRG059_A080

	JSR PRG063_CheckProjToObjCollide
	BCS PRG059_A0BC	; If no projectile hit, jump to PRG059_A0BC (RTS)

	LDY <Temp_Var16
	LDA Spr_Y,Y
	CMP Spr_Y,X
	BGE PRG059_A0BC
	
	JSR PRG063_DeleteObjectY


PRG059_A080:
	LDA #SPRANM4_MINOAN_DROP
	JSR PRG063_SetSpriteAnim

	; HP = 2
	LDA #$02
	STA Spr_HP+$00,X
	
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE)
	STA Spr_Flags2+$00,X
	
	; Drop 8 pixels
	LDA Spr_Y+$00,X
	ADD #$08
	STA Spr_Y+$00,X
	
	STX <Temp_Var15	; Backup object slot -> Temp_Var15
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_A0BC	; If no free object slot, jump to PRG059_A0BC (RTS)

	; Little poof as Minoan detaches

	LDA #SPRSLOTID_MISCSTUFF
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_Flags2+$00,Y
	STA Spr_HP+$00,Y
	
	LDA #SPRANM4_SMALLPOOFEXP
	JSR PRG063_CopySprSlotSetAnim

	; 8 pixels above (Minoan's original position)
	LDA Spr_Y+$00,Y
	SUB #$08
	STA Spr_Y+$00,Y
	
	LDX <Temp_Var15	; Restore object index

PRG059_A0BC:
	RTS	; $A0BC


PRG059_Obj_Minoan_Cont:
	LDA Spr_Var1+$00,X
	BEQ PRG059_A0CA	

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_A0BC	; If Spr_Var1 > 0, jump to PRG059_A0BC

	JSR PRG063_SetObjFacePlayer

PRG059_A0CA:
	LDY #$06
	
	JSR PRG063_DoObjVertMovement
	BCC PRG059_A0DB	; If didn't hit floor, jump to PRG059_A0DB (RTS)

	LDY #$1C
	JSR PRG063_DoObjMoveSetFaceDir

	BCC PRG059_A0BC	; If didn't hit wall, jump to PRG059_A0BC

	; Turn around
	JSR PRG063_FlipObjDirAndSpr	

PRG059_A0DB:
	RTS	; $A0DB


PRG059_Obj_SuperballMachineJr:
	LDA Spr_Frame+$00,X
	BNE PRG059_A12B	; If frame <> 0, jump to PRG059_A12B

	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	LDA Spr_Var1+$00,X
	BEQ PRG059_A0F0	; If Spr_Var1 = 0, jump to PRG059_A0F0

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_A0DB	; If Spr_Var1 > 0, jump to PRG059_A0DB (RTS)


PRG059_A0F0:
	LDA <RandomN+$00
	ADC <RandomN+$02
	STA <RandomN+$02
	AND #$07
	TAY	; Y = 0 to 7
	
	LDA PRG058_Minoan_Var1,Y
	STA Spr_Var1+$00,X
	
	JSR PRG063_CalcObjYDiffFromPlayer

	CMP #$20
	BGE PRG059_A184	; If Y difference >= $20, jump to PRG059_A184 (RTS)

	; Temp_Var0 = $00
	LDA #$00
	STA <Temp_Var0
	
	LDY #$17	; Y = $17
PRG059_A10C:
	LDA Spr_CodePtrH+$00,Y
	BEQ PRG059_A11A	; If code pointer NULL, jump to PRG059_A11A

	LDA Spr_SlotID+$00,Y
	CMP #SPRSLOTID_SUPERBALLMACHJR_B
	BNE PRG059_A11A	; If not a Super Ball Machine Jr. ball, jump to PRG059_A11A

	INC <Temp_Var0	; Temp_Var0++

PRG059_A11A:
	DEY	; Y--
	CPY #$07
	BNE PRG059_A10C	; If Y > 7, loop

	; Limit 2 balls
	LDA <Temp_Var0
	CMP #$03
	BGE PRG059_A184	; If Temp_Var0 >= 3, jump to PRG059_A184 (RTS)

	INC Spr_Frame+$00,X	; Spr_Frame++
	
	LDA Spr_Frame+$00,X
PRG059_A12B:
	CMP #$02
	BEQ PRG059_A13A	; $A12D
	BLT PRG059_A184	; $A12F

	; CHECKME - UNUSED?
	LDA #$00
	STA Spr_Frame,X
	STA Spr_AnimTicks,X
	RTS

PRG059_A13A:
	LDA Spr_AnimTicks+$00,X
	CMP #$03
	BNE PRG059_A184	; If Spr_AnimTicks <> 3, jump to PRG059_A184 (RTS)

	STX <Temp_Var15	; Backup object slot index ->Temp_Var15
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_A184	; If no empty object slot, jump to PRG059_A184 (RTS)

	LDA #SPRSLOTID_SUPERBALLMACHJR_B
	STA Spr_SlotID+$00,Y
	
	; Hurt, shootable, bbox $0E
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $0E)
	STA Spr_Flags2+$00,Y
	
	; HP = 1
	LDA #$01
	STA Spr_HP+$00,Y
	
	; Ball speeds
	LDA #$6A
	STA Spr_YVelFrac+$00,Y
	STA Spr_XVelFrac+$00,Y
	LDA #$01
	STA Spr_YVel+$00,Y
	STA Spr_XVel+$00,Y
	
	LDA Spr_Flags+$00,X
	
	LDX #SPRDIR_LEFT | SPRDIR_UP
	
	AND #SPR_HFLIP
	BEQ PRG059_A172	; If not horizontally flipped, jump to PRG059_A172

	LDX #SPRDIR_RIGHT | SPRDIR_UP

PRG059_A172:
	TXA
	STA Spr_FaceDir+$00,Y
	
	AND #SPRDIR_RIGHT
	ADD #$29	; + $29
	STA <Temp_Var16	; Temp_Var16 = $29 or $2A
	
	LDX <Temp_Var15	; Restore object index
	
	LDA #SPRANM4_SBM_BALL
	JSR PRG063_InitProjectile

PRG059_A184:
	RTS	; $A184


PRG058_Minoan_Var1:
	.byte $5A, $3C, $28, $78, $5A, $28, $3C, $3C


PRG058_Obj_SBM_Ball:
	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM4_SBM_BALL_BOUNCE
	BNE PRG059_A19E	; If not bouncing, jump to PRG059_A19E

	LDA Spr_Frame+$00,X
	BEQ PRG059_A19E	; If frame = 0, jump to PRG059_A19E

	LDA #SPRANM4_SBM_BALL
	JSR PRG063_SetSpriteAnim

PRG059_A19E:
	LDY #$16
	JSR PRG063_DoMoveVertOnly
	BCS PRG059_A1B2	; If hit floor/ceiling, jump to PRG059_A1B2

	LDY #$20
	JSR PRG063_DoObjMoveSetFaceDir

	BCC PRG059_A184	; If didn't hit wall, jump to PRG059_A184 (RTS)

	; Bounce
	JSR PRG063_FlipObjDirAndSpr

	JMP PRG059_A1BF	; Jump to PRG059_A1BF


PRG059_A1B2:
	LDA #SPRANM4_SBM_BALL_BOUNCE
	JSR PRG063_SetSpriteAnim

	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_DOWN | SPRDIR_UP)
	STA Spr_FaceDir+$00,X

PRG059_A1BF:
	LDA Spr_XVel+$00,X
	CMP #$05
	BGE PRG059_A184	; If X vel >= 5, jump to PRG059_A184 (RTS)

	LDA Spr_XVelFrac+$00,X
	ADD #$66
	STA Spr_XVelFrac+$00,X
	STA Spr_YVelFrac+$00,X
	LDA Spr_XVel+$00,X
	ADC #$00
	STA Spr_XVel+$00,X
	STA Spr_YVel+$00,X
	
	RTS	; $A1DD


PRG059_Obj_BoulderDispenser:
	LDA Weapon_FlashStopCnt+$00
	ORA Weapon_FlashStopCnt+$01
	BNE PRG059_A222	; If Flash Stopper is active, jump to PRG059_A222 (RTS)

	JSR PRG063_CalcObjXDiffFromPlayer

	CMP #$20
	BLT PRG059_A1F3	; If X difference < $20, jump to PRG059_A1F3

	; Spr_Var1 = 0
	LDA #$00
	STA Spr_Var1+$00,X
	
	RTS	; $A1F2


PRG059_A1F3:
	LDA Spr_Var1+$00,X
	BEQ PRG059_A1FC	; If Spr_Var1 = 0, jump to PRG059_A1FC

	DEC Spr_Var1+$00,X	; Spr_Var1--
	RTS	; $A1FB


PRG059_A1FC:
	; Spr_Var1 = $78
	LDA #$78
	STA Spr_Var1+$00,X
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_A222	; If no free object slot, jump to PRG059_A222 (RTS)

	LDA #SPRSLOTID_BOULDER
	STA Spr_SlotID+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE)
	STA Spr_Flags2+$00,Y
	
	; HP = 1
	LDA #$01
	STA Spr_HP+$00,Y
	
	LDA #$00
	STA Spr_YVelFrac+$00,Y
	STA Spr_YVel+$00,Y
	
	LDA #SPRANM4_BOULDER
	JSR PRG063_CopySprSlotSetAnim


PRG059_A222:
	RTS	; $A222


PRG059_Obj_Boulder:
	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM4_BOULDER_IMPACT
	BEQ PRG059_A236	; If impacting, jump to PRG059_A236

	LDY #$0C
	JSR PRG063_DoObjVertMovement
	BCC PRG059_A286	; If no impact, jump to PRG059_A286 (RTS)

	LDA #SPRANM4_BOULDER_IMPACT
	JMP PRG063_SetSpriteAnim


PRG059_A236:
	LDA Spr_AnimTicks+$00,X
	CMP #$05
	BLT PRG059_A286	; If ticks < 5, jump to PRG059_A286 (RTS)

	JSR PRG062_ResetSpriteSlot

	; Temp_Var14 = 3
	LDA #$03
	STA <Temp_Var14
	
	STX <Temp_Var15	; Backup object slot index -> Temp_Var15

PRG059_A246:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_A286	; If no free object slot, jump to PRG059_A286 (RTS)

	LDA #SPRSLOTID_BOULDER_DEBRIS
	STA Spr_SlotID+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $0F)
	STA Spr_Flags2+$00,Y
	
	; HP = 1
	LDA #$01
	STA Spr_HP+$00,Y
	
	LDX <Temp_Var14	; X = debris index
	
	; debris horizontal speed
	LDA PRG058_BoulderDebris_XVelFrac,X
	STA Spr_XVelFrac+$00,Y
	LDA PRG058_BoulderDebris_XVel,X
	STA Spr_XVel+$00,Y
	
	; debris vertical speed
	LDA PRG058_BoulderDebris_YVelFrac,X
	STA Spr_YVelFrac+$00,Y
	LDA PRG058_BoulderDebris_YVel,X
	STA Spr_YVel+$00,Y
	
	; debris direction
	LDA PRG058_BoulderDebris_FaceDir,X
	STA Spr_FaceDir+$00,Y
	
	; debris animation
	LDA PRG058_BoulderDebris_Anim,X
	
	LDX <Temp_Var15	; Restore object index
	
	JSR PRG063_CopySprSlotSetAnim

	DEC <Temp_Var14	; Temp_Var14--
	BPL PRG059_A246	; While Temp_Var14 > 0, loop


PRG059_A286:
	RTS	; $A286


PRG058_BoulderDebris_YVelFrac:
	.byte $D4, $E5, $00, $74
	
PRG058_BoulderDebris_YVel:
	.byte $02, $04, $02, $03
	
PRG058_BoulderDebris_XVelFrac:
	.byte $0F, $68, $80, $26
	
PRG058_BoulderDebris_XVel:
	.byte $01, $00, $00, $01
	
PRG058_BoulderDebris_FaceDir:
	.byte $02, $02, $02, $01
	
PRG058_BoulderDebris_Anim:
	.byte SPRANM4_BOULDER_DEBRIS1, SPRANM4_BOULDER_DEBRIS3, SPRANM4_BOULDER_DEBRIS4, SPRANM4_BOULDER_DEBRIS2


PRG059_Obj_BoulderDebris:
PRG059_Obj_MothrayaDebris:
	LDY #$14
	JSR PRG063_DoObjVertMovement
	BCS PRG059_A2AD	; If hit solid, jump to PRG059_A2AD

	LDY #$1E
	JSR PRG063_DoObjMoveSetFaceDir
	BCC PRG059_A2B0	; If didn't hit solid, jump to PRG059_A2B0


PRG059_A2AD:
	; Delete debris
	JMP PRG062_ResetSpriteSlot


PRG059_A2B0:
	LDA Spr_Flags+$00,X
	AND #~SPR_HFLIP
	STA Spr_Flags+$00,X

PRG059_A2B8:
	RTS	; $A2B8


PRG059_Obj_Eddie:
	; Face Player
	JSR PRG063_SetObjFlipForFaceDir

	LDY #$0E
	JSR PRG063_DoObjVertMovement
	BCC PRG059_A2B8	; If didn't hit solid, jump to PRG059_A2B8 (RTS)

	LDY #$22
	JSR PRG063_DoObjMoveSetFaceDir
	BCC PRG059_A2CD	; If didn't hit wall, jump to PRG059_A2CD

	JSR PRG063_FlipObjDirAndSpr	; Turn around

PRG059_Obj_EddieImm:
PRG059_A2CD:
	JSR PRG063_SetObjFlipForFaceDir

	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM4_ENDEDDIEOPEN
	BEQ PRG059_A2ED	; If Eddie is opening, jump to PRG059_A2ED

	JSR PRG063_CalcObjXDiffFromPlayer

	CMP #$20
	BGE PRG059_A2B8	; If Player X difference >= $20, jump to PRG059_A2B8 (RTS)

	LDA #LOW(PRG059_A2CD)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_A2CD)
	STA Spr_CodePtrH+$00,X
	
	LDA #SPRANM4_ENDEDDIEOPEN
	JMP PRG063_SetSpriteAnim


PRG059_A2ED:
	LDA Spr_Frame+$00,X	
	CMP #$04
	BEQ PRG059_A314	; If frame = 4, jump to PRG059_A314

	CMP #$07
	BNE PRG059_A2B8	; If frame <> 7, jump to PRG059_A2B8 (RTS)

	; Spr_Var1 = $50
	LDA #$50
	STA Spr_Var1+$00,X
	
	LDA #LOW(PRG059_Obj_Eddie_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Eddie_Cont)
	STA Spr_CodePtrH+$00,X
	
	LDA #$00
	STA Spr_YVelFrac+$00,X
	STA Spr_YVel+$00,X
	
	LDA #SPRANM4_ENDEDDIESTAND
	JMP PRG063_SetSpriteAnim


PRG059_A314:
	INC Spr_Frame+$00,X	; Spr_Frame++
	
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	STX <Temp_Var15	; Backup slot index -> Temp_Var15
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_A2B8	; If no free object slot, jump to PRG059_A2B8 (RTS)

	LDA #SPRSLOTID_EDDIE_ITEM_EJECT
	STA Spr_SlotID+$00,Y
	
	LDA Spr_SpawnParentIdx,X	; $A328
	STA Spr_SpawnParentIdx,Y	; $A32B
	
	LDA #$00
	STA Spr_Flags2+$00,Y
	
	LDA #$00
	STA Spr_YVelFrac+$00,Y
	STA Spr_XVelFrac+$00,Y
	
	; horizontal speed
	LDA #$01
	STA Spr_XVel+$00,Y
	
	; vertical speed
	LDA #$04
	STA Spr_YVel+$00,Y
	
	LDA Spr_FaceDir+$00,X
	STA Spr_FaceDir+$00,Y
	
	LDA <RandomN+$01
	ADC <RandomN+$03
	STA <RandomN+$03
	
	AND #$0F
	STA <Temp_Var14	; Temp_Var14 = $0 to $F
	
	LDA Spr_SlotID+$00,X
	CMP #SPRSLOTID_EDDIE_IMMEDIATE
	BEQ PRG059_A364	; If this is the immediate variety of Eddie, jump to PRG059_A364

	LDX <Temp_Var14	; X = $0 to $F
	
	LDA PRG059_Eddie_ItemAnim,X
	JMP PRG059_A369	; Jump to PRG059_A369

PRG059_A364:
	; CHECKME - UNUSED?
	; No such thing as an "immediate" Eddie?
	LDX <Temp_Var14	; X = $0 to $F
	LDA PRG059_EddieImm_ItemAnim,X


PRG059_A369:
	LDX <Temp_Var15	; Restore object slot index
	
	JSR PRG063_CopySprSlotSetAnim

	; Ejected item appears 12 pixels above
	LDA Spr_Y+$00,Y
	SUB #12
	STA Spr_Y+$00,Y
	
	RTS	; $A377


PRG059_Obj_Eddie_Cont:
	LDA Spr_Var1+$00,X
	BEQ PRG059_A38C	; If Spr_Var1 = 0, jump to PRG059_A38C

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_A3B4	; If Spr_Var1 > 0, jump to PRG059_A3B4

	LDA #SPRDIR_UP
	STA Spr_FaceDir+$00,X
	
	LDA #SPRANM4_EDDIE_TELEPORTOUT
	JMP PRG063_SetSpriteAnim


PRG059_A38C:
	LDA Spr_Frame+$00,X
	CMP #$04
	BNE PRG059_A398	; If frame <> 4, jump to PRG059_A398

	; Hold animation
	LDA #$00
	STA Spr_AnimTicks+$00,X

PRG059_A398:
	; Teleport out speed
	LDA Spr_YVelFrac+$00,X
	ADD #$40
	STA Spr_YVelFrac+$00,X
	LDA Spr_YVel+$00,X
	ADC #$00
	STA Spr_YVel+$00,X
	
	JSR PRG063_ApplyYVelocityNeg

	LDA Spr_YHi+$00,X
	BEQ PRG059_A3B4	; If not off-screen, jump to PRG059_A3B4

	; Delete Eddie
	JSR PRG062_ResetSpriteSlot

PRG059_A3B4:
	RTS	; $A3B4

PRG059_Eddie_ItemAnim:
	.byte SPRANM4_ITEM_1UP			; $00
	.byte SPRANM4_ITEM_ENERGYTANK	; $01
	.byte SPRANM4_ITEM_LARGEWEAPON	; $02
	.byte SPRANM4_ITEM_LARGEHEALTH	; $03
	.byte SPRANM4_ITEM_LARGEHEALTH	; $04
	.byte SPRANM4_ITEM_LARGEWEAPON	; $05
	.byte SPRANM4_ITEM_1UP			; $06
	.byte SPRANM4_ITEM_ENERGYTANK	; $07
	.byte SPRANM4_ITEM_LARGEWEAPON	; $08
	.byte SPRANM4_ITEM_LARGEHEALTH	; $09
	.byte SPRANM4_ITEM_ENERGYTANK	; $0A
	.byte SPRANM4_ITEM_LARGEWEAPON	; $0B
	.byte SPRANM4_ITEM_LARGEHEALTH	; $0C
	.byte SPRANM4_ITEM_1UP			; $0D
	.byte SPRANM4_ITEM_LARGEWEAPON	; $0E
	.byte SPRANM4_ITEM_LARGEHEALTH	; $0F

	; This (unused?) variety of Eddie has a much more even item distribution
PRG059_EddieImm_ItemAnim:
	.byte SPRANM4_ITEM_1UP			; $00
	.byte SPRANM4_ITEM_ENERGYTANK	; $01
	.byte SPRANM4_ITEM_LARGEWEAPON	; $02
	.byte SPRANM4_ITEM_1UP			; $03
	.byte SPRANM4_ITEM_LARGEHEALTH	; $04
	.byte SPRANM4_ITEM_LARGEWEAPON	; $05
	.byte SPRANM4_ITEM_1UP			; $06
	.byte SPRANM4_ITEM_ENERGYTANK	; $07
	.byte SPRANM4_ITEM_LARGEWEAPON	; $08
	.byte SPRANM4_ITEM_1UP			; $09
	.byte SPRANM4_ITEM_ENERGYTANK	; $0A
	.byte SPRANM4_ITEM_LARGEWEAPON	; $0B
	.byte SPRANM4_ITEM_LARGEHEALTH	; $0C
	.byte SPRANM4_ITEM_1UP			; $0D
	.byte SPRANM4_ITEM_ENERGYTANK	; $0E
	.byte SPRANM4_ITEM_LARGEHEALTH	; $0F



PRG059_Obj_EddieItem:
	LDY #$0E
	JSR PRG063_DoObjVertMovement
	BCC PRG059_A3E6	; If hasn't hit floor, jump to PRG059_A3E6

	LDA #LOW(PRG059_A3FA)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_A3FA)
	STA Spr_CodePtrH+$00,X

PRG059_A3E6:
	LDY #$18
	JSR PRG063_DoObjMoveSetFaceDir

	LDA Spr_Flags+$00,X
	AND #~SPR_HFLIP
	STA Spr_Flags+$00,X
	BCC PRG059_A3FA	; If didn't hit solid, jump to PRG059_A3FA

	LDA #$00
	STA Spr_FaceDir+$00,X

PRG059_A3FA:
	JMP PRG059_Obj_PlayerItems	; Jump to PRG059_Obj_PlayerItems


PRG059_Obj_ShieldAttacker:
	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM4_SHIELDATTACKER_TURN
	BEQ PRG059_A422	; If Shield Attacker is turning around, jump to PRG059_A422

	LDA Spr_Var1+$00,X
	BNE PRG059_A40E	; If Spr_Var1 <> 0, jump to PRG059_A40E

	; Spr_Var1 = $40
	LDA #$40
	STA Spr_Var1+$00,X

PRG059_A40E:
	LDY #$14
	JSR PRG063_DoObjMoveSetFaceDir
	BCS PRG059_A41A	; If hit solid, jump to PRG059_A41A

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_Do1SideVulnerability	; If Spr_Var1 > 0, jump to PRG059_Do1SideVulnerability


PRG059_A41A:
	LDA #SPRANM4_SHIELDATTACKER_TURN
	JSR PRG063_SetSpriteAnim

	JMP PRG059_Do1SideVulnerability	; Jump to PRG059_Do1SideVulnerability


PRG059_A422:
	LDA Spr_Frame+$00,X
	CMP #$06
	BNE PRG059_A46C	; If frame <> 6, jump to PRG059_A46C (RTS)

	; Spr_Var1 = $40
	LDA #$40
	STA Spr_Var1+$00,X
	
	LDA #SPRANM4_SHIELDATTACKER
	JSR PRG063_SetSpriteAnim
	JSR PRG063_FlipObjDirAndSpr


PRG059_Do1SideVulnerability:
	; Enable vulnerability
	LDA Spr_Flags2+$00,X
	ORA #SPRFL2_SHOOTABLE
	STA Spr_Flags2+$00,X
	
	JSR PRG063_CheckProjToObjCollide
	BCS PRG059_A46C	; If no projectile collision, jump to PRG059_A46C (RTS)

	LDY <Temp_Var16	; Y = projectile object index
	
	LDA Spr_X+$00,X
	SUB Spr_X+$00,Y
	LDA Spr_XHi+$00,X
	SBC Spr_XHi+$00,Y
	BCS PRG059_A45D

	LDA Spr_Flags+$00,X
	AND #SPR_HFLIP
	BEQ PRG059_A46C	; Hit back, permit damage
	BNE PRG059_A464	; Otherwise, jump to PRG059_A464 (disable vulnerability)


PRG059_A45D:
	LDA Spr_Flags+$00,X
	AND #SPR_HFLIP
	BNE PRG059_A46C	; Hit back, permit damage


PRG059_A464:
	; Disable vulnerability
	LDA Spr_Flags2+$00,X
	AND #~SPRFL2_SHOOTABLE
	STA Spr_Flags2+$00,X

PRG059_A46C:
	RTS	; $A46C


PRG059_Obj_Totempolen:
	LDA Spr_Var1+$00,X
	BNE PRG059_A477	; If Spr_Var1 > 0, jump to PRG059_A477

	; Spr_Var1 = $14
	LDA #$14
	STA Spr_Var1+$00,X

PRG059_A477:
	LDA #$00
	STA Spr_AnimTicks+$00,X
	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir
	JSR PRG063_CalcObjXDiffFromPlayer

	CMP #$04
	BGE PRG059_A49E	; If X diff >= 4, jump to PRG059_A49E

	; Totempolen jump
	LDA #$A9
	STA Spr_YVelFrac+$00,X
	LDA #$05
	STA Spr_YVel+$00,X
	
	LDA #LOW(PRG059_Obj_Totempolen_Jump)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Totempolen_Jump)
	STA Spr_CodePtrH+$00,X
	
	RTS	; $A49D


PRG059_A49E:
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_A46C		; If Spr_Var1 > 0, jump to PRG059_A46C (RTS)

	LDA <RandomN+$01
	ADC <RandomN+$03
	STA <RandomN+$03
	AND #$03
	BNE PRG059_A4B0	; 3:4 jump to PRG059_A4B0

	JMP PRG059_A52E	; Jump to PRG059_A52E


PRG059_A4B0:
	INC Spr_Frame+$00,X	; frame++
	
	LDA #LOW(PRG059_Obj_Totempolen_Shoot)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Totempolen_Shoot)
	STA Spr_CodePtrH+$00,X
	
PRG059_Obj_Totempolen_Shoot:
	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM4_TOTEMPOLEN
	BNE PRG059_A4DC	; If shooting, jump to PRG059_A4DC

	LDA Spr_Frame+$00,X
	CMP #$05
	BNE PRG059_A533	; If frame <> 5, jump to PRG059_A533

	LDA #SPRANM4_TOTEMPOLEN_SHOOT
	JSR PRG063_SetSpriteAnim

	LDA <RandomN+$02
	ADC <RandomN+$00
	STA <RandomN+$00
	AND #$07
	STA Spr_Frame+$00,X	; Random frame 0 to 7
	RTS	; $A4DB


PRG059_A4DC:
	LDA Spr_AnimTicks+$00,X
	CMP #$10
	BEQ PRG059_A4F6	; If ticks = $10, jump to PRG059_A4F6

	CMP #$20
	BNE PRG059_A533	; If ticks <> $20, jump to PRG059_A533

	LDA #LOW(PRG059_A477)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_A477)
	STA Spr_CodePtrH+$00,X
	
	LDA #SPRANM4_TOTEMPOLEN
	JMP PRG063_SetSpriteAnim


PRG059_A4F6:
	STX <Temp_Var15	; Backup object slot index -> Temp_Var15
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_A533	; If no empty object slot, jump to PRG059_A533 (RTS)

	LDA #SPRSLOTID_TOTEMPOLEN_SHOT
	STA Spr_SlotID+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | $0F)
	STA Spr_Flags2+$00,Y
	
	; Bullet speed
	LDA #$00
	STA Spr_XVelFrac+$00,Y
	LDA #$02
	STA Spr_XVel+$00,Y
	
	LDA Spr_FaceDir+$00,X
	STA Spr_FaceDir+$00,Y
	AND #SPRDIR_RIGHT
	STA <Temp_Var0	; Temp_Var0 = 0 if left, 1 if right
	
	LDA Spr_Frame+$00,X
	TAX	; X = frame
	
	LDA PRG059_Totempolen_ProjInitIdx,X
	ADD <Temp_Var0
	STA <Temp_Var16	; Projectile init index
	
	LDX <Temp_Var15
	LDA #SPRANM4_TOTEMPOLEN_BULLET
	JSR PRG063_InitProjectile


PRG059_A52E:
	; Spr_Var1 = $40
	LDA #$40
	STA Spr_Var1+$00,X

PRG059_A533:
	RTS	; $A533


PRG059_Obj_Totempolen_Jump:
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	LDY #$1C
	JSR PRG063_DoObjVertMovement
	BCC PRG059_A533	; If didn't hit solid, jump to PRG059_A533 (RTS)

	LDA #LOW(PRG059_A477)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_A477)
	STA Spr_CodePtrH+$00,X
	
	JMP PRG059_A52E	; Jump to PRG059_A52E


PRG059_Totempolen_ProjInitIdx:
	.byte $33, $35, $31, $35, $37, $35, $33, $33


PRG059_Obj_Totempolen_Shot:
	; Bullet just moves
	JMP PRG063_ApplyVelSetFaceDir


PRG059_Obj_Metall1:
PRG059_Obj_Metall2:
PRG059_Obj_Metall3:
	LDA Spr_Frame+$00,X
	BNE PRG059_A577	; If frame <> 0, jump to PRG059_A577

	LDA #$00
	STA Spr_AnimTicks+$00,X
	JSR PRG063_SetObjFlipForFaceDir
	JSR PRG063_CalcObjXDiffFromPlayer

	CMP #$40
	BGE PRG059_A533	; If X difference >= $40, jump to PRG059_A533 (RTS)

	INC Spr_Frame+$00,X	; frame++
	
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE)
	STA Spr_Flags2+$00,X
	JMP PRG063_SetObjYVelToMinus1


PRG059_A577:
	LDA Spr_AnimTicks+$00,X
	CMP #$04
	BNE PRG059_A533	; If ticks <> 4, jump to PRG059_A533 (RTS)

	LDA Spr_Frame+$00,X	
	CMP #$01
	BEQ PRG059_A5F4	; If frame = 1, jump to PRG059_A5F4

	CMP #$04
	BNE PRG059_A5FD	; If frame <> 4, jump to PRG059_A5FD

	LDA Spr_SlotID+$00,X
	CMP #SPRSLOTID_METALL_3
	BEQ PRG059_A593	; If Metall type 3 (twirling), jump to PRG059_A593

	JSR PRG059_MetallFireSpread	; Jump to PRG059_MetallFireSpread


PRG059_A593:
	LDA Spr_SlotID+$00,X
	CMP #SPRSLOTID_METALL_1
	BEQ PRG059_A5E0	; If Metall type 1 (run and hide), jump to PRG059_A5E0

	CMP #SPRSLOTID_METALL_2
	BEQ PRG059_A5B2	; If Metall type 2 (jumper), jump to PRG059_A5B2

	; Metall type 3 (twirler)
	LDA #LOW(PRG059_Obj_Metall3_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Metall3_Cont)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var3 = 3
	LDA #$03
	STA Spr_Var3+$00,X
	
	LDA #SPRANM4_METALL3_OPEN
	JMP PRG063_SetSpriteAnim


PRG059_A5B2:
	; Metall type 2 (jumper)

	LDA #LOW(PRG059_Obj_Metall2_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Metall2_Cont)
	STA Spr_CodePtrH+$00,X
	
	LDA <RandomN+$02
	ADC <RandomN+$01
	STA <RandomN+$01
	AND #$01
	TAY	; Y = 0 or 1
	
	; vertical speed
	LDA PRG059_A690,Y
	STA Spr_YVelFrac+$00,X
	LDA PRG059_A692,Y
	STA Spr_YVel+$00,X
	
	; horizontal speed
	LDA #$CC
	STA Spr_XVelFrac+$00,X
	LDA #$00
	STA Spr_XVel+$00,X
	
	LDA #SPRANM4_METALL2_OPEN
	JMP PRG063_SetSpriteAnim


PRG059_A5E0:
	; Metall type 1 (runner)

	LDA #LOW(PRG059_Obj_Metall1_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Metall1_Cont)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var1 = $40
	LDA #$40
	STA Spr_Var1+$00,X
	
	LDA #SPRANM4_METALL1_OPEN
	JMP PRG063_SetSpriteAnim


PRG059_A5F4:
	; Move up 3 pixels
	LDA Spr_Y+$00,X
	SUB #$03
	STA Spr_Y+$00,X

PRG059_A5FD:
	RTS	; $A5FD


PRG059_MetallFireSpread:
	; Temp_Var14 = 2 (bullet index)
	LDA #$02
	STA <Temp_Var14

	STX <Temp_Var15	; Backup object slot index -> Temp_Var15

PRG059_MetallFireBullet:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_A648	; If no empty slot, jump to PRG059_A648 (RTS)

	LDA #SPRSLOTID_METALL_BULLET
	STA Spr_SlotID+$00,Y
	
	; hurt player, bbox $0F
	LDA #(SPRFL2_HURTPLAYER | $0F)
	STA Spr_Flags2+$00,Y
	
	LDA Spr_FaceDir+$00,X
	STA Spr_FaceDir+$00,Y
	
	AND #SPRDIR_RIGHT
	ADD #$39		; $39 if left, $3A if right
	STA <Temp_Var16
	
	LDA #SPRANM4_CIRCLEBULLET
	JSR PRG063_InitProjectile

	LDX <Temp_Var14	; X = bullet index
	
	LDA PRG059_MetallBullet1_VelFrac,X
	STA Spr_XVelFrac+$00,Y
	STA Spr_YVelFrac+$00,Y
	
	LDA PRG059_MetallBullet1_Vel,X
	STA Spr_XVel+$00,Y
	STA Spr_YVel+$00,Y
	
	LDA Spr_FaceDir+$00,Y
	ORA PRG059_MetallBullet1_FaceDir,X
	STA Spr_FaceDir+$00,Y
	
	LDX <Temp_Var15	; Restore object index
	
	DEC <Temp_Var14	; Temp_Var14--
	BPL PRG059_MetallFireBullet	; While Temp_Var14 >= 0, loop


PRG059_A648:
	RTS	; $A648



PRG059_Metall_LandInvin:
	LDA Spr_Var2+$00,X
	BEQ PRG059_A665	; If Spr_Var2 = 0, jump to PRG059_A665

	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	DEC Spr_Var2+$00,X	; Spr_Var2--
	BNE PRG059_A68F	; If Spr_Var2 > 0, jump to PRG059_A68F (RTS)

	LDA #LOW(PRG059_Obj_Metall1)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Metall1)
	STA Spr_CodePtrH+$00,X
	
	JMP PRG063_SetObjFacePlayer


PRG059_A665:
	LDA Spr_AnimTicks+$00,X
	CMP #$04
	BNE PRG059_A68F	; If anim ticks <> 4, jump to PRG059_A68F

	LDA Spr_Frame+$00,X
	CMP #$01
	BEQ PRG059_A686	; If frame = 1, jump to PRG059_A686

	CMP #$03
	BNE PRG059_A68F	; If frame <> 3, jump to PRG059_A68F (RTS)

	LDA #SPRFL2_HURTPLAYER
	STA Spr_Flags2+$00,X
	
	; Spr_Var2 = $40
	LDA #$40
	STA Spr_Var2+$00,X
	
	LDA #SPRANM4_METALL_IDLE
	JMP PRG063_SetSpriteAnim


PRG059_A686:
	LDA Spr_Y+$00,X
	ADD #$03
	STA Spr_Y+$00,X

PRG059_A68F:
	RTS	; $A68F


PRG059_A690:
	.byte $2C, $00

PRG059_A692:
	.byte $03, $04
	
PRG059_MetallBullet1_VelFrac:
	.byte $80, $0F, $0F
	
PRG059_MetallBullet1_Vel:
	.byte $01, $01, $01
	
PRG059_MetallBullet1_FaceDir:
	.byte $00, SPRDIR_UP, SPRDIR_DOWN


PRG059_Obj_Metall1_Cont:
	LDY #$1D
	JSR PRG063_DoObjVertMovement
	BCC PRG059_A68F	; If no solid hit, jump to PRG059_A68F (RTS)

	LDY #$2A
	JSR PRG063_DoObjMoveSetFaceDir
	BCS PRG059_Metall_SetLandAndInvin	; If solid hit, jump to PRG059_Metall_SetLandAndInvin

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_A68F		; If Spr_Var1 > 0, jump to PRG059_A68F (RTS)

	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir
	JSR PRG059_MetallFireSpread


PRG059_Metall_SetLandAndInvin:
	LDA #LOW(PRG059_Metall_LandInvin)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Metall_LandInvin)
	STA Spr_CodePtrH+$00,X
	
	; hurt player, bbox $20
	LDA #(SPRFL2_HURTPLAYER | $20)
	STA Spr_Flags2+$00,X
	
	LDA #SPRANM4_METALL_CLOSING
	JMP PRG063_SetSpriteAnim


PRG059_Obj_MetallBullet:
	; bullet just moves
	JSR PRG063_ApplyVelSetFaceDir
	JMP PRG063_DoMoveVertOnlyH16


PRG059_Obj_Metall2_Cont:
	LDA Spr_Frame+$00,X
	AND #$03
	BNE PRG059_A6E8	; 3:4 jump to PRG059_A6E8

	LDA Spr_Frame+$00,X
	BEQ PRG059_A704	; If frame = 0, jump to PRG059_A704 (RTS)

	LDA Spr_AnimTicks+$00,X
	CMP #$04
	BNE PRG059_A704	; If anim ticks <> 4, jump to PRG059_A704 (RTS)
	BEQ PRG059_Metall_SetLandAndInvin	; Otherwise jump to PRG059_Metall_SetLandAndInvin


PRG059_A6E8:
	LDY #$1D
	JSR PRG063_DoObjVertMovement
	BCC PRG059_A6FA	; If didn't hit solid, jump to PRG059_A6FA

	; anim ticks = 0
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	; frame = 4
	LDA #$04
	STA Spr_Frame+$00,X
	
	RTS	; $A6F9


PRG059_A6FA:
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	LDY #$2A
	JSR PRG063_DoObjMoveSetFaceDir

PRG059_A704:
	RTS	; $A704


PRG059_Obj_Metall3_Cont:
	LDA Spr_Var1+$00,X
	BEQ PRG059_A70F	; If Spr_Var1 = 0, jump to PRG059_A70F

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_A728	; If Spr_Var1 > 0, jump to PRG059_A728 (RTS)


PRG059_A70F:
	STX <Temp_Var15	; Backup object slot -> Temp_Var15
	
	; Temp_Var14 = 0
	LDA #$00
	STA <Temp_Var14
	
	JSR PRG063_SetObjFacePlayer
	JSR PRG059_MetallFireBullet

	DEC Spr_Var3+$00,X	; Spr_Var3--
	BNE PRG059_A723	; If Spr_Var3 > 0, jump to PRG059_A723

	JMP PRG059_Metall_SetLandAndInvin	; Jump to PRG059_Metall_SetLandAndInvin


PRG059_A723:
	; Spr_Var1 = $28
	LDA #$28
	STA Spr_Var1+$00,X

PRG059_A728:
	RTS	; $A728


PRG059_Obj_Metall4:
	JSR PRG059_Metall4_MakeBubbles

	LDA Spr_Frame+$00,X
	BNE PRG059_A74C	; If frame <> 0, jump to PRG059_A74C

	LDA #$00
	STA Spr_AnimTicks+$00,X
	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir
	JSR PRG063_CalcObjXDiffFromPlayer

	CMP #$40
	BGE PRG059_A761	; If X diff >= $40, jump to PRG059_A761 (RTS)

	INC Spr_Frame+$00,X	; frame++
	
	; Hurt player, shootable, bbox $11
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $11)
	STA Spr_Flags2+$00,X
	
	RTS	; $A74B


PRG059_A74C:
	CMP #$03
	BNE PRG059_A761	; If frame <> 3, jump to PRG059_A761 (RTS)

	; Move up 8 pixels
	LDA Spr_Y+$00,X
	SUB #$08
	STA Spr_Y+$00,X
	
	; Spr_Var1 = $0C
	LDA #$0C
	STA Spr_Var1+$00,X
	
	JSR PRG059_Metall4_StartSwim


PRG059_A761:
	RTS	; $A761


PRG059_Metall4_Swim:
	JSR PRG059_Metall4_MakeBubbles

	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM4_METALL4_GETUP
	BNE PRG059_A778		; If Metall Swim isn't getting up, jump to PRG059_A778

	LDA Spr_Frame,X
	CMP #$03
	BNE PRG059_A761		; If frame <> 3, jump to PRG059_A761 (RTS)
	
	LDA #SPRANM4_METALL4_SWIM
	JMP PRG063_SetSpriteAnim

PRG059_A778:
	LDA Spr_Var1+$00,X
	BEQ PRG059_A7A1	; If Spr_Var1 = 0, jump to PRG059_A7A1

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_A7A1	; If Spr_Var1 > 0, jump to PRG059_A7A1

	; Temp_Var0 = 0
	LDA #$00
	STA <Temp_Var0
	
	LDY #$17	; Y = $17
PRG059_A788:
	LDA Spr_SlotID+$00,Y
	BEQ PRG059_A793	; If empty slot, jump to PRG059_A793

	CMP #SPRSLOTID_METALL_BULLET
	BNE PRG059_A793	; If this is a Metall bullet, jump to PRG059_A793

	INC <Temp_Var0	; Temp_Var0++

PRG059_A793:
	DEY			; Y--
	CPY #$07
	BNE PRG059_A788	; While Y > 7, loop

	LDA <Temp_Var0
	CMP #$06
	BGE PRG059_A7A1	; If there's at least 6 Metall bullets, jump to PRG059_A7A1

	JSR PRG059_MetallFireSpread

PRG059_A7A1:
	LDY #$26
	JSR PRG059_Metall4_WaterMove

	LDA Spr_YVel+$00,X
	BMI PRG059_A7B0

	LDY #$2E
	JMP PRG063_DoObjMoveSetFaceDir

PRG059_A7B0:
	LDA <Temp_Var16
	AND #TILEATTR_SOLID
	BNE PRG059_A7CE	; If didn't hit solid, jump to PRG059_A7CE

	LDA #LOW(PRG059_A805)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_A805)
	STA Spr_CodePtrH+$00,X
	
	LDA #$00
	STA Spr_AnimTicks+$00,X
	STA Spr_Frame+$00,X
	
	; Spr_Var1 = $0C
	LDA #$0C
	STA Spr_Var1+$00,X
	
	RTS	; $A7CD


PRG059_A7CE:
	LDA #LOW(PRG059_A7E5)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_A7E5)
	STA Spr_CodePtrH+$00,X
	
	LDA #$00
	STA Spr_XVelFrac+$00,X
	STA Spr_XVel+$00,X
	
	LDA #SPRANM4_METALL4_GETDOWN
	JMP PRG063_SetSpriteAnim

PRG059_A7E5:
	JSR PRG059_Metall4_MakeBubbles

	LDA Spr_Frame+$00,X
	CMP #$03
	BNE PRG059_A7F4	; If frame <> 3, jump to PRG059_A7F4

	LDA #$00
	STA Spr_AnimTicks,X

PRG059_A7F4:
	LDY #$0E
	JSR PRG059_Metall4_WaterMove

	BCC PRG059_A86F	; If didn't hit solid, jump to PRG059_A86F (RTS)

	LDA #LOW(PRG059_A805)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_A805)
	STA Spr_CodePtrH+$00,X
	
PRG059_A805:
	JSR PRG059_Metall4_MakeBubbles

	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM4_METALL4_GETDOWN
	BEQ PRG059_A83B	; If Metall Swim is getting down, jump to PRG059_A83B

	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	LDA Spr_Var5+$00,X
	BMI PRG059_A821	; If Spr_Var5 < 0, jump to PRG059_A821

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_A821	; If Spr_Var1 > 0, jump to PRG059_A821

	JMP PRG059_A8A5	; Jump to PRG059_A8A5


PRG059_A821:
	LDY #$26
	JSR PRG059_Metall4_WaterMove
	BCS PRG059_A82D	; If hit solid, jump to PRG059_A82D

	LDY #$2E
	JMP PRG063_DoObjMoveSetFaceDir


PRG059_A82D:
	; Move down 8 pixels
	LDA Spr_Y+$00,X
	ADD #$08
	STA Spr_Y+$00,X
	
	LDA #SPRANM4_METALL4_GETDOWN
	JMP PRG063_SetSpriteAnim


PRG059_A83B:
	LDA Spr_Var4+$00,X
	BEQ PRG059_A85E	; If Spr_Var4 = 0, jump to PRG059_A85E

	; Spr_AnimTicks = 0
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	DEC Spr_Var4+$00,X	; Spr_Var4--
	BNE PRG059_A86F	; If Spr_Var4 > 0, jump to PRG059_A86F (RTS)

	LDA #LOW(PRG059_Obj_Metall4)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Metall4)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var5 = 0
	LDA #$00
	STA Spr_Var5+$00,X
	
	LDA #SPRANM4_METALL4_GETUP
	JMP PRG063_SetSpriteAnim


PRG059_A85E:
	LDA Spr_Frame+$00,X
	CMP #$03
	BNE PRG059_A86F	; If frame <> 3, jump to PRG059_A86F (RTS)

	; Spr_Var4 = $40
	LDA #$40
	STA Spr_Var4+$00,X
	
	LDA #(SPRFL2_HURTPLAYER | $20)
	STA Spr_Flags2+$00,X

PRG059_A86F:
	RTS	; $A86F


PRG059_Metall4_WaterMove:
	; Note doing water movement
	LDA #$15
	STA <Player_AltYVelForWater
	JSR PRG063_DoObjVertMovement

	PHP	; Save status
	
	LDA <TileMap_Index
	CMP #TMAP_WILY1
	BEQ PRG059_A886	; If Wily 1, jump to PRG059_A886

	LDA Level_RasterYOff
	CMP Spr_Y+$00,X
	BGE PRG059_A88F	; If Metall 4 is above water line, jump to PRG059_A88F


PRG059_A886:
	LDA <Temp_Var16
	CMP #TILEATTR_WATER
	BEQ PRG059_A89F	; If water detected, jump to PRG059_A89F

	LDA Spr_Y+$00,X	; $A88C

PRG059_A88F:
	STA Spr_Y+$00,X	; Fix to water line
	
	; Spr_Var5 = $FF
	LDA #$FF
	STA Spr_Var5+$00,X
	
	LDA Spr_YVel+$00,X
	BMI PRG059_A89F

	JSR PRG063_SetObjYVelToMinus1

PRG059_A89F:
	PLP	; Restore status
	
	LDA #$40
	STA <Player_AltYVelForWater
	
	RTS	; $A8A4


PRG059_A8A5:
	; Spr_Var1 = $20
	LDA #$20
	STA Spr_Var1+$00,X
	
	LDA <RandomN+$02
	ADC <RandomN+$03
	STA <RandomN+$03
	AND #$01
	BEQ PRG059_Metall4_StartSwim	; 1:2 jump to PRG059_Metall4_StartSwim

	RTS	; $A8B4


PRG059_Metall4_StartSwim:
	LDA #$95
	STA Spr_YVelFrac+$00,X
	LDA #$02
	STA Spr_YVel+$00,X
	
	LDA <RandomN+$03
	SBC <RandomN+$01
	STA <RandomN+$01
	AND #$03
	TAY	; Y = $03
	
	LDA PRG059_Metall4_XVelFrac,Y
	STA Spr_XVelFrac+$00,X
	LDA PRG059_Metall4_XVel,Y
	STA Spr_XVel+$00,X
	
	LDA #LOW(PRG059_Metall4_Swim)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Metall4_Swim)
	STA Spr_CodePtrH+$00,X
	
	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir

	LDA #SPRANM4_METALL4_SWIM
	JMP PRG063_SetSpriteAnim


PRG059_Metall4_XVelFrac:
	.byte $00, $CC, $00, $00
	
PRG059_Metall4_XVel:
	.byte $00, $00, $00, $00


PRG059_Metall4_MakeBubbles:
	LDA Spr_Var3+$00,X
	BEQ PRG059_A8FA	; If Spr_Var3 = 0, jump to PRG059_A8FA

	DEC Spr_Var3+$00,X	; Spr_Var3--
	RTS	; $A8F9


PRG059_A8FA:
	LDA Spr_Var2+$00,X
	AND #$01
	TAY	; Y = 0 or 1
	
	LDA PRG059_Metall4_Var3,Y
	STA Spr_Var3+$00,X
	
	INC Spr_Var2+$00,X	; Spr_Var2++
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_A93C	; If no empty object slot, jump to PRG059_A93C (RTS)

	LDA #SPRSLOTID_METALL_4_BUBBLE
	STA Spr_SlotID+$00,Y
	
	LDA #$00
	STA Spr_Flags2+$00,Y
	
	LDA Spr_FaceDir+$00,X
	STA Spr_FaceDir+$00,Y
	
	; projectile init index
	AND #SPRDIR_RIGHT
	ADD #$42	; $42 or $43
	STA <Temp_Var16
	
	LDA #SPRANM4_METALL4_BUBBLE
	JSR PRG063_InitProjectile

	LDA Spr_Flags+$00,Y
	AND #~SPR_HFLIP
	STA Spr_Flags+$00,Y
	
	LDA #$00
	STA Spr_YVelFrac+$00,Y
	LDA #$01
	STA Spr_YVel+$00,Y

PRG059_A93C:
	RTS	; $A93C


PRG059_Metall4_Var3:
	.byte $78, $28


PRG059_Obj_Metall4_Bubble:
	LDY #$23
	JSR PRG063_DoObjVertMoveUpOnly

	LDA <Temp_Var16
	CMP #TILEATTR_WATER
	BNE PRG059_A94F	; If water detected, jump to PRG059_A94F

	LDA Spr_YHi+$00,X
	BEQ PRG059_A93C	; If bubble is not vertically off-screen, jump to PRG059_A93C (RTS)


PRG059_A94F:
	JMP PRG062_ResetSpriteSlot


PRG059_Obj_M422A:
	; Spr_Var1 = Spr_Y
	LDA Spr_Y+$00,X
	STA Spr_Var1+$00,X
	
PRG059_Obj_M422A_Reset:
	JSR PRG063_CalcObjXDiffFromPlayer

	CMP #$40
	BGE PRG059_A9A6	; If X diff >= $40, jump to PRG059_A9A6 (RTS)

	; Moving down
	LDA #$00
	STA Spr_YVelFrac+$00,X
	LDA #$02
	STA Spr_YVel+$00,X
	
	LDA #LOW(PRG059_Obj_M422A_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_M422A_Cont)
	STA Spr_CodePtrH+$00,X
	
	LDA #SPRDIR_DOWN
	STA Spr_FaceDir+$00,X
	

PRG059_Obj_M422A_Cont:	
	LDY #$1F
	JSR PRG063_DoMoveVertOnly

	BCS PRG059_A99C	; If hit solid, jump to PRG059_A99C

	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_DOWN
	BNE PRG059_A9A6	; If moving down, jump to PRG059_A9A6 (RTS)

	; Moving up

	LDA Spr_Var1+$00,X
	CMP Spr_Y+$00,X
	BLT PRG059_A9A6	; If not back to original Y, jump to PRG059_A9A6 (RTS)

	; Lock at original position
	STA Spr_Y+$00,X
	
	LDA #LOW(PRG059_Obj_M422A_Reset)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_M422A_Reset)
	STA Spr_CodePtrH+$00,X
	
	RTS	; $A99B


PRG059_A99C:
	LDA #SPRDIR_UP
	STA Spr_FaceDir+$00,X
	
	; Return speed
	LDA #$01
	STA Spr_YVel+$00,X

PRG059_A9A6:
	RTS	; $A9A6


PRG059_Obj_Puyoyon:
	JSR PRG063_CalcObjXDiffFromPlayer

	CMP #$40
	BGE PRG059_A9C5	; If X >= $40, jump to PRG059_A9C5

	LDA #LOW(PRG059_Obj_Puyoyon_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Puyoyon_Cont)
	STA Spr_CodePtrH+$00,X
	
	JSR PRG063_SetObjYVelToMinus1

	LDA #SPRDIR_DOWN
	STA Spr_FaceDir+$00,X
	
	LDA #SPRANM4_PUYOYON_DROP
	JMP PRG063_SetSpriteAnim


PRG059_A9C5:
	LDA Spr_Var1+$00,X
	BEQ PRG059_A9F2	; If Spr_Var1 = 0, jump to PRG059_A9F2

	DEC Spr_Var1+$00,X	; Spr_Var1--
	
	LDY #$22
	JSR PRG063_DoObjVertMoveUpOnly

	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	ASL A	
	TAY		; Y = 0 if left, 2 if right
	
	LDA Level_TileAttrsDetected+$00,Y
	AND #TILEATTR_SOLID
	BEQ PRG059_A9E7	; If didn't hit solid, jump to PRG059_A9E7

	LDY #$2C
	JSR PRG063_DoObjMoveSetFaceDir

	BCC PRG059_A9EF	; If didn't hit wall, jump to PRG059_A9EF


PRG059_A9E7:
	LDA Spr_FaceDir,X
	EOR #(SPRDIR_LEFT | SPRDIR_RIGHT)
	STA Spr_FaceDir,X


PRG059_A9EF:
	JMP PRG059_AAA5	; Jump to PRG059_AAA5


PRG059_A9F2:
	LDA #$00
	STA Spr_YVelFrac+$00,X
	LDA #$01
	STA Spr_YVel+$00,X
	
	; Spr_Var1 = $14
	LDA #$14
	STA Spr_Var1+$00,X
	
	LDA Spr_FaceDir+$00,X
	AND #(SPRDIR_LEFT | SPRDIR_RIGHT)
	BNE PRG059_AA0B		; If direction is left/right, jump to PRG059_AA0B

	JMP PRG063_SetObjFacePlayer


PRG059_AA0B:
	LDA #$00
	STA Spr_FaceDir+$00,X
	
	RTS	; $AA10


PRG059_Obj_Puyoyon_Cont:
	LDA Spr_Frame+$00,X	
	CMP #$01
	BEQ PRG059_AA52	; If frame = 1, jump to PRG059_AA52

	CMP #$02
	BEQ PRG059_AA6D	; If frame = 2, jump to PRG059_AA6D

	CMP #$04
	BNE PRG059_AA8C	; If frame <> 4, jump to PRG059_AA8C (RTS)

	LDA Spr_FaceDir+$00,X
	CMP #SPRDIR_DOWN
	BNE PRG059_AA39	; If Puyoyon is not moving down, jump to PRG059_AA39

	LDA #LOW(PRG059_Obj_Puyoyon_Inch)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Puyoyon_Inch)
	STA Spr_CodePtrH+$00,X
	
	JSR PRG063_SetObjFacePlayer

	LDA #SPRANM4_PUYOYON_INCH
	JMP PRG063_SetSpriteAnim


PRG059_AA39:
	LDA #LOW(PRG059_Obj_Puyoyon)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Puyoyon)
	STA Spr_CodePtrH+$00,X
	
	LDA #$00
	STA Spr_YVelFrac+$00,X
	LDA #$01
	STA Spr_YVel+$00,X
	
	LDA #SPRANM4_PUYOYON_INCH_C
	JMP PRG063_SetSpriteAnim


PRG059_AA52:
	LDA Spr_FaceDir+$00,X
	CMP #SPRDIR_DOWN
	BNE PRG059_AA61	; If not moving down, jump to PRG059_AA61

	LDA Spr_Y+$00,X
	ADD #$08
	BNE PRG059_AA67	; Jump (technically always) to PRG059_AA67


PRG059_AA61:
	LDA Spr_Y+$00,X
	SUB #$08

PRG059_AA67:
	STA Spr_Y+$00,X
	
	INC Spr_Frame+$00,X	; Spr_Frame++

PRG059_AA6D:
	; Spr_AnimTicks = 0
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	LDA Spr_FaceDir+$00,X
	CMP #SPRDIR_DOWN
	BNE PRG059_AA82	; If not moving down, jump to PRG059_AA82

	LDY #$21
	JSR PRG063_DoObjVertMovement

	BCC PRG059_AA8C	; If didn't hit solid, jump to PRG059_AA8C (RTS)
	BCS PRG059_AA89	; Otherwise, jump to PRG059_AA89


PRG059_AA82:
	LDY #$22
	JSR PRG063_DoObjVertMoveUpOnly
	BCC PRG059_AA8C	; If didn't hit solid, jump to PRG059_AA8C (RTS)


PRG059_AA89:
	INC Spr_Frame+$00,X	; frame++

PRG059_AA8C:
	RTS	; $AA8C


PRG059_Obj_Puyoyon_Inch:
	JSR PRG063_CalcObjXDiffFromPlayer

	CMP #$40
	BGE PRG059_AAAE	; If X diff >= $40, jump to PRG059_AAAE

	LDY #$21
	JSR PRG063_DoObjVertMovement

	BCC PRG059_AA8C	; If didn't hit solid, jump to PRG059_AA8C (RTS)

	LDY #$2C
	JSR PRG063_DoObjMoveSetFaceDir

	BCC PRG059_AAA5	; If didn't hit solid, jump to PRG059_AAA5

	JMP PRG059_A9E7		; Jump to PRG059_A9E7


PRG059_AAA5:
	LDA Spr_Flags+$00,X
	AND #~SPR_HFLIP
	STA Spr_Flags+$00,X
	
	RTS	; $AAAD


PRG059_AAAE:
	LDA #LOW(PRG059_Obj_Puyoyon_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Puyoyon_Cont)
	STA Spr_CodePtrH+$00,X
	
	LDA #$00
	STA Spr_YVelFrac+$00,X
	LDA #$02
	STA Spr_YVel+$00,X
	
	LDA #SPRDIR_UP
	STA Spr_FaceDir+$00,X
	
	LDA #SPRANM4_PUYOYON_RAISE
	JMP PRG063_SetSpriteAnim


PRG059_Obj_SkeletonJoe:
	
	; HP = 3
	LDA #$03
	STA Spr_HP+$00,X
	
	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir
	JSR PRG063_CheckProjToObjCollide

	BCS PRG059_AAEB	; If no projectile collision, jump to PRG059_AAEB

	LDA #LOW(PRG059_Obj_SkelJoe_Collapse)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_SkelJoe_Collapse)
	STA Spr_CodePtrH+$00,X
	
	LDA #SPRANM4_SKELJOE_COLLAPSE
	JMP PRG063_SetSpriteAnim


PRG059_AAEB:
	LDA Spr_Frame+$00,X	
	BNE PRG059_AB01	; If frame <> 0, jump to PRG059_AB01

	LDA Spr_Var1+$00,X
	BEQ PRG059_AB1B	; If Spr_Var1 = 0, jump to PRG059_AB1B

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BEQ PRG059_AAFD	; If Spr_Var1 > 0, jump to PRG059_AAFD

	JMP PRG059_ABB0	; Jump to PRG059_ABB0


PRG059_AAFD:
	INC Spr_Frame+$00,X	; frame++
	RTS	; $AB00


PRG059_AB01:
	LDA Spr_AnimTicks+$00,X	
	CMP #$03
	BNE PRG059_AB6F	; If anim ticks <> 3, jump to PRG059_AB6F (RTS)

	LDA Spr_Frame+$00,X
	CMP #$04
	BEQ PRG059_AB21	; If frame = 4, jump to PRG059_AB21

	CMP #$08
	BNE PRG059_AB6F	; If frame <> 8, jump to PRG059_AB6F (RTS)

	LDA #$00
	STA Spr_Frame+$00,X
	STA Spr_AnimTicks+$00,X

PRG059_AB1B:
	; Spr_Var1 = $40
	LDA #$40
	STA Spr_Var1+$00,X
	
	RTS	; $AB20


PRG059_AB21:
	LDY #$04		; Y = 4
	JSR PRG063_CalcObjXDiffFromPlayer
PRG059_AB26:
	CMP PRG059_SkelJoe_PlyrXDiffChks,Y
	BGE PRG059_AB2E	; If Player's X difference is greater than this, jump to PRG059_AB2E

	DEY	; Y--
	BNE PRG059_AB26	; While Y > 0, loop


PRG059_AB2E:
	STY <Temp_Var14	; Selected distance index -> Temp_Var14
	
	STX <Temp_Var15	; Backup object slot index -> Temp_Var15
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_AB6F	; If no free object slot, jump to PRG059_AB6F (RTS)

	LDA #SPRSLOTID_SKELETONJOE_BONE
	STA Spr_SlotID+$00,Y
	
	; Hurt player, bbox $0F
	LDA #(SPRFL2_HURTPLAYER | $0F)
	STA Spr_Flags2+$00,Y
	
	LDA Spr_FaceDir+$00,X
	STA Spr_FaceDir+$00,Y
	
	AND #SPRDIR_RIGHT	; 0/1
	ADD #$3D
	STA <Temp_Var16		; Temp_Var16 = $3D or $3E
	
	LDA #SPRANM4_SKELJOE_BONE
	JSR PRG063_InitProjectile

	LDX <Temp_Var14	; X = selected distance index
	
	; Bone horizontal speed
	LDA PRG059_SkelJoe_BoneXVelFrac,X
	STA Spr_XVelFrac+$00,Y
	LDA PRG059_SkelJoe_BoneXVel,X
	STA Spr_XVel+$00,Y
	
	; Bone vertical speed
	LDA PRG059_SkelJoe_BoneYVelFrac,X
	STA Spr_YVelFrac+$00,Y
	LDA PRG059_SkelJoe_BoneYVel,X
	STA Spr_YVel+$00,Y
	
	LDX <Temp_Var15	; Restore object slot index

PRG059_AB6F:
	RTS	; $AB6F


PRG059_Obj_SkelJoe_Collapse:
	
	; HP = 3
	LDA #$03
	STA Spr_HP+$00,X
	
	LDA Spr_Var2+$00,X
	BEQ PRG059_AB82	; If Spr_Var2 = 0, jump to PRG059_AB82

	DEC Spr_Var2+$00,X	; Spr_Var2--
	BNE PRG059_ABB0	; If Spr_Var2 > 0, jump to PRG059_ABB0

	INC Spr_Frame+$00,X	; frame++

PRG059_AB82:
	LDA #(SPRFL2_HURTPLAYER | $0D)
	STA Spr_Flags2+$00,X
	
	LDA Spr_Frame+$00,X
	CMP #$02
	BEQ PRG059_ABA6	; If frame = 2, jump to PRG059_ABA6

	CMP #$0B
	BNE PRG059_AB6F	; If frame <> $0B, jump to PRG059_AB6F (RTS)

	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $0D)
	STA Spr_Flags2+$00,X

	LDA #LOW(PRG059_Obj_SkeletonJoe)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_SkeletonJoe)
	STA Spr_CodePtrH+$00,X
	
	LDA #SPRANM4_SKELJOE_IDLE
	JMP PRG063_SetSpriteAnim


PRG059_ABA6:
	LDA #$00
	STA Spr_Flags2+$00,X
	
	; Spr_Var2 = $40
	LDA #$40
	STA Spr_Var2+$00,X

PRG059_ABB0:
	LDA #$00
	STA Spr_AnimTicks+$00,X
	RTS	; $ABB5


PRG059_SkelJoe_PlyrXDiffChks:	.byte $00, $10, $20, $38, $50	; X difference from Player to select index
PRG059_SkelJoe_BoneXVelFrac:	.byte $00, $30, $00, $64, $D0
PRG059_SkelJoe_BoneXVel:		.byte $00, $01, $02, $02, $02
PRG059_SkelJoe_BoneYVelFrac:	.byte $00, $D4, $D4, $74, $DE
PRG059_SkelJoe_BoneYVel:		.byte $02, $02, $02, $03, $03


PRG059_Obj_SkelJoeBone:
	JSR PRG063_ApplyVelSetFaceDir
	JMP PRG063_DoMoveSimpleVert


PRG059_Obj_Ringring:
	INC Spr_Var1+$00,X	; Spr_Var1++
	LDA Spr_Var1+$00,X	
	AND #$07	; Cap 0 to 7
	BNE PRG059_ABFB	; 7:8 jump to PRG059_ABFB

	JSR PRG063_Aim2Plyr_SetDir_Var4

	LDA PRG059_Obj_Ringring_XVelFrac,Y
	STA Spr_XVelFrac+$00,X
	LDA PRG059_Obj_Ringring_XVel,Y
	STA Spr_XVel+$00,X
	
	LDA PRG059_Obj_Ringring_YVelFrac,Y
	STA Spr_YVelFrac+$00,X
	LDA PRG059_Obj_Ringring_YVel,Y
	STA Spr_YVel+$00,X
	
	RTS	; $ABFA


PRG059_ABFB:
	JSR PRG063_ApplyVelSetFaceDir
	JMP PRG063_DoMoveVertOnlyH16


	; X velocities share with Y velocities as a quarter turn
PRG059_Obj_Ringring_XVelFrac:
	.byte $00, $40, $5A, $6E

PRG059_Obj_Ringring_YVelFrac:
	.byte $80, $6E, $5A, $40, $00, $40, $5A, $6E, $80, $6E, $5A, $40, $00, $40, $5A, $6E

PRG059_Obj_Ringring_XVel:
	.byte $00, $00, $00, $00

PRG059_Obj_Ringring_YVel:
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


	; CHECKME - UNUSED?
	; $AC29
	LDA Spr_Var1,X
	BEQ PRG059_AC32		; If Spr_Var1 = 0, jump to PRG059_AC32
	
	DEC Spr_Var1,X		; Spr_Var1--
	RTS

PRG059_AC32:
	; Spr_Var1 = $50
	LDA #$50
	STA Spr_Var1,X
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_AC50		; If no empty object slot index, jump to PRG059_AC50 (RTS)

	LDA #SPRSLOTID_UNK68
	STA Spr_SlotID,Y
	
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $0F)
	STA Spr_Flags2,Y
	
	; HP = 1
	LDA #$01
	STA Spr_HP,Y
	
	LDA #SPRANM4_UNK_A0
	JSR PRG063_CopySprSlotSetAnim
	
PRG059_AC50:
	RTS
	
	
PRG059_Obj68:
	; CHECKME - UNUSED?
	; Object totally unused?
	LDA Spr_Frame,X
	CMP #$10
	BEQ PRG059_AC6B		; If frame = $10, jump to  PRG059_AC6B

	CMP #$13
	BNE PRG059_AC50		; If frame <> $13, jump to PRG059_AC50

	LDA #LOW(PRG059_AC80)
	STA Spr_CodePtrL,X
	LDA #HIGH(PRG059_AC80)
	STA Spr_CodePtrH,X

	LDA #$00
	STA Spr_YVelFrac,Y
	STA Spr_YVel,Y

	LDA #SPRANM4_UNK_A1
	JMP PRG063_SetSpriteAnim

PRG059_AC6B:
	; Spr_Y += 8
	LDA Spr_Y,X
	ADD #$08
	STA Spr_Y,X
	
	INC Spr_Frame,X	; frame++
	
	RTS

PRG059_AC80:
	LDA Spr_Frame,X
	BNE PRG059_AC8C	; If frame <> 0, jump to PRG059_AC8C (RTS)

	LDY #$14
	JSR PRG063_DoObjVertMovement
	BCC PRG059_AC87		; If didn't hit solid, jump to PRG059_AC87
	
	INC Spr_Frame,X	; frame++

PRG059_AC87:

	LDA #$00
	STA Spr_AnimTicks,X

PRG059_AC8C:
	RTS

PRG059_Obj_SkullMet:
	JSR PRG059_Do1SideVulnerability

	LDA Spr_Var1+$00,X
	BEQ PRG059_ACA2	; If Spr_Var1 = 0, jump to PRG059_ACA2

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_ACD8	; If Spr_Var1 > 0, jump to PRG059_ACD8 (RTS)


PRG059_ACA2:
	LDA Spr_Flags+$00,X
	AND #SPR_HFLIP
	BEQ PRG059_ACBA	; If not h-flipped, jump to PRG059_ACBA

	LDA Spr_X+$00
	SUB Spr_X+$00,X
	LDA Spr_XHi+$00
	SBC Spr_XHi+$00,X
	
	BCS PRG059_ACD8	; If not "in front", jump to PRG059_ACD8 (RTS)
	BCC PRG059_ACC9	; Otherwise, jump to PRG059_ACC9


PRG059_ACBA:
	LDA Spr_X+$00,X
	SUB Spr_X+$00	
	LDA Spr_XHi+$00,X
	SBC Spr_XHi+$00	
	BCS PRG059_ACD8	; If not "in front", jump to PRG059_ACD8


PRG059_ACC9:
	LDA #LOW(PRG059_Obj_SkullMet_PInFront)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_SkullMet_PInFront)
	STA Spr_CodePtrH+$00,X
	
	LDA #SPRANM4_SKULLMET_PINFRONT
	JSR PRG063_SetSpriteAnim


PRG059_ACD8:
	RTS	; $ACD8

PRG059_Obj_SkullMet_PInFront:
	JSR PRG059_Do1SideVulnerability

	LDA Spr_AnimTicks+$00,X
	CMP #$05
	BNE PRG059_ACD8	; If anim ticks <> 5, jump to PRG059_ACD8 (RTS)

	LDA Spr_Frame+$00,X
	CMP #$08
	BEQ PRG059_AD02	; If frame = 8, jump to PRG059_AD02

	CMP #$09
	BNE PRG059_ACD8	; If frame <> 9, jump to PRG059_ACD8 (RTS)

	; Spr_Var1 = $40
	LDA #$40
	STA Spr_Var1+$00,X
	
	LDA #LOW(PRG059_Obj_SkullMet)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_SkullMet)
	STA Spr_CodePtrH+$00,X
	
	LDA #SPRANM4_SKULLMET_IDLE
	JMP PRG063_SetSpriteAnim


PRG059_AD02:
	LDY #$00		; Y = 0
	
	JSR PRG063_CalcObjXDiffFromPlayer

	CMP #$40
	BGE PRG059_AD11	; If X diff >= $40, jump to PRG059_AD11

	INY	; Y = 1
	
	CMP #$30
	BGE PRG059_AD11	; If X diff >= $30, jump to PRG059_AD11

	INY	; Y = 2

PRG059_AD11:
	STY <Temp_Var14	; Temp_Var14 = 0, 1, or 2
	
	STX <Temp_Var15	; backup object slot index -> Temp_Var15
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_AD5D	; If no object slot empty, jump to PRG059_AD5D (RTS)

	LDA #SPRSLOTID_SKULLMET_BULLET
	STA Spr_SlotID+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | $0F)
	STA Spr_Flags2+$00,Y
	
	LDX <Temp_Var14	; X = 0 to 2
	
	; bullet horizontal speed
	LDA PRG059_SkullMetBullet_XVelFrac,X
	STA Spr_XVelFrac+$00,Y
	LDA PRG059_SkullMetBullet_XVel,X
	STA Spr_XVel+$00,Y
	
	; bullet vertical speed
	LDA PRG059_SkullMetBullet_YVelFrac,X
	STA Spr_YVelFrac+$00,Y
	LDA PRG059_SkullMetBullet_YVel,X
	STA Spr_YVel+$00,Y
	
	LDX <Temp_Var15	; Restore object slot index
	
	LDA #SPRDIR_RIGHT
	STA Spr_FaceDir+$00,Y
	
	LDA Spr_Flags+$00,X
	
	LDX #$45	; X = $45
	
	AND #SPR_HFLIP
	BEQ PRG059_AD54	; If h-flipped, jump to PRG059_AD54

	LDA #SPRDIR_LEFT
	STA Spr_FaceDir+$00,Y
	
	DEX	; X = $44

PRG059_AD54:
	STX <Temp_Var16	; projectile init index
	
	LDX <Temp_Var15	; restore object slot index
	
	LDA #$18
	JSR PRG063_InitProjectile


PRG059_AD5D:
	RTS	; $AD5D


PRG059_SkullMetBullet_XVelFrac:	.byte $00, $00, $00
PRG059_SkullMetBullet_XVel:		.byte $02, $02, $01
PRG059_SkullMetBullet_YVelFrac:	.byte $A9, $00, $00
PRG059_SkullMetBullet_YVel:		.byte $05, $02, $02


PRG059_Obj_SkullMet_Bullet:
	JSR PRG063_ApplyVelSetFaceDir
	JMP PRG063_DoMoveSimpleVert


PRG059_Obj_Helipon:
	LDA Spr_Var1+$00,X
	BEQ PRG059_ADA2	; If Spr_Var1 = 0, jump to  PRG059_ADA2

	DEC Spr_Var1+$00,X	; Spr_Var1--
	
	JSR PRG063_DoMoveVertOnlyH16

	LDY #$28
	JSR PRG062_ObjDetFloorAttrs

	LDA <Level_TileAttrsDetected+$00
	AND #TILEATTR_SOLID
	BEQ PRG059_AD8C	; If not solid, jump to PRG059_AD8C

	LDA <Level_TileAttrsDetected+$01
	AND #TILEATTR_SOLID
	BNE PRG059_AD8F	; If solid, jump to PRG059_AD8F


PRG059_AD8C:
	JMP PRG063_ApplyVelSetFaceDir


PRG059_AD8F:
	LDA #LOW(PRG059_Obj_Helipon_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Helipon_Cont)
	STA Spr_CodePtrH+$00,X
	
	LDA #$00
	STA Spr_YVelFrac+$00,X
	STA Spr_YVel+$00,X
	
	RTS	; $ADA1


PRG059_ADA2:
	; Spr_Var1 = $08
	LDA #$08
	STA Spr_Var1+$00,X
	
	JSR PRG063_Aim2Plyr_SetDir_Var4

	LDA PRG058_Taketetno_XVelFrac,Y
	STA Spr_XVelFrac+$00,X
	LDA PRG058_Taketetno_XVel,Y
	STA Spr_XVel+$00,X
	
	LDA PRG058_Taketetno_YVelFrac,Y
	STA Spr_YVelFrac+$00,X
	LDA PRG058_Taketetno_YVel,Y
	STA Spr_YVel+$00,X

PRG059_ADC2:
	RTS	; $ADC2

PRG059_Obj_Helipon_Cont:
	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM4_HELIPON_FLYING
	BNE PRG059_ADD6	; If Helipon is not flying (landed), jump to PRG059_ADD6

	LDY #$29
	JSR PRG063_DoObjVertMovement

	BCC PRG059_ADC2	; If not solid, jump to PRG059_ADC2 (RTS)

	LDA #SPRANM4_HELIPON_LANDED
	JMP PRG063_SetSpriteAnim


PRG059_ADD6:
	LDA Spr_Frame+$00,X
	CMP #$06
	BNE PRG059_ADC2	; If frame <> 6, jump to PRG059_ADC2 (RTS)

	LDA #LOW(PRG059_ADF1)
	STA Spr_CodePtrL,X
	LDA #HIGH(PRG059_ADF1)
	STA Spr_CodePtrH,X

	; Spr_Var2 = $1F
	LDA #$1F
	STA Spr_Var2,X
	
	LDA #SPRANM4_HELIPON_PRESHOOT
	JMP PRG063_SetSpriteAnim

PRG059_ADF1:
	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir
	
	LDA Spr_CurrentAnim,X
	CMP #SPRANM4_HELIPON_PRESHOOT
	BNE PRG059_AE08		; If Helipon is not shooting, jump to PRG059_AE08
	
	DEC Spr_Var2,X		; Spr_Var2--
	BNE PRG059_AE4B 	; If Spr_Var2 > 0, jump to PRG059_AE4B (RTS)
	
	LDA #SPRANM4_HELIPON_SHOOT
	JMP PRG063_SetSpriteAnim
	
PRG059_AE08:
	LDA Spr_Frame,X
	CMP #$03
	BEQ PRG059_AE1D		; If frame = 3, jump to PRG059_AE1D
	
	CMP #$08
	BNE PRG059_AE4B 	; If frame <> 8, jump to PRG059_AE4B (RTS)
	
	; Spr_Var2 = $50
	LDA #$50
	STA Spr_Var2,X
	
	LDA #SPRANM4_HELIPON_PRESHOOT
	JMP PRG063_SetSpriteAnim
	
PRG059_AE1D:
	INC Spr_Frame,X		; frame++
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_AE4B ; If no free object slot, jump to PRG059_AE4B (RTS)
	
	LDA #SPRSLOTID_HELIPON_BULLET
	STA Spr_SlotID,Y
	
	LDA #(SPRFL2_HURTPLAYER | $0F)
	STA Spr_Flags2,Y
	
	; Bullet speed
	LDA #$00
	STA Spr_XVelFrac,Y
	LDA #$02
	STA Spr_XVel,Y
	
	LDA Spr_FaceDir,X
	STA Spr_FaceDir,Y
	
	AND #SPRDIR_RIGHT
	ADD #$33
	STA <Temp_Var16	; $33 or $34
	
	LDA #$18
	JSR PRG063_InitProjectile

PRG059_AE4B:
	RTS	; $AE4B


PRG059_Obj_HeliponBullet:
	JMP PRG063_ApplyVelSetFaceDir


PRG059_Obj_Gyotot:
	; Fish in water that can jump out

	LDY #$1C
	JSR PRG063_DoObjMoveSetFaceDir

	BCC PRG059_AE59	; If didn't hit solid, jump to PRG059_AE59

	JSR PRG063_FlipObjDirAndSpr


PRG059_AE59:
	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir
	
	JSR PRG063_CalcObjXDiffFromPlayer

	CMP #$40
	BGE PRG059_AE4B	; If X diff >= $40, jump to PRG059_AE4B (RTS)

	; Jump Y vel
	LDA #$52
	STA Spr_YVelFrac+$00,X
	LDA #$06
	STA Spr_YVel+$00,X
	
	; Jump X vel
	LDA #$33
	STA Spr_XVelFrac+$00,X
	LDA #$01
	STA Spr_XVel+$00,X
	
	LDA #LOW(PRG059_Gyotot_Jump)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Gyotot_Jump)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var1 = $60
	LDA #TILEATTR_WATER
	STA Spr_Var1+$00,X
	
	; Remember Y -> Spr_Var2
	LDA Spr_Y+$00,X	
	STA Spr_Var2+$00,X
	
	LDA #SPRANM4_GYOTOT_JUMP
	JMP PRG063_SetSpriteAnim

PRG059_Gyotot_Jump:
	JSR PRG063_DoMoveSimpleVert
	JSR PRG063_ApplyVelSetFaceDir

	LDA Spr_Var3+$00,X
	BNE PRG059_AEFB	; If Spr_Var3 > 0, jump to PRG059_AEFB (RTS)

	LDY #$02
	JSR PRG062_ObjDetFloorAttrs

	LDA <Temp_Var16
	AND #$E0	
	CMP Spr_Var1+$00,X	; Tile attribute check
	BEQ PRG059_AEF0	; If Gyotot is in the water, jump to PRG059_AEF0

	STA Spr_Var1+$00,X	; update detected tile (in case out of water)
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_AEFB	; If no empty object slot, jump to PRG059_AEFB (RTS)

	LDA #SPRSLOTID_MISCSTUFF
	STA Spr_SlotID+$00,Y
	
	; Spr_Flags2 = 0
	LDA #$00
	STA Spr_Flags2+$00,Y
	
	LDA #SPRANM4_WATERSPLASH
	JSR PRG063_CopySprSlotSetAnim

	; Align to tile grid
	LDA Spr_Y+$00,Y
	AND #$F0
	STA Spr_Y+$00,Y
	
	LDA Spr_Flags+$00,Y
	AND #~SPR_HFLIP
	STA Spr_Flags+$00,Y
	
	LDA Spr_Var1+$00,X
	CMP #TILEATTR_WATER
	BEQ PRG059_AEE5	; If Gyotot is checking water, jump to PRG059_AEE5

	; Out of water!
	LDA Spr_Y+$00,Y
	ADD #$10
	STA Spr_Y+$00,Y
	
	RTS	; $AEE4


PRG059_AEE5:
	LDA #LOW(PRG059_Gyotot_Fall)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Gyotot_Fall)
	STA Spr_CodePtrH+$00,X
	
	RTS	; $AEEF


PRG059_AEF0:
	LDA Spr_Var2+$00,X
	CMP Spr_Y+$00,X
	BGE PRG059_AEFB	; If Spr_Var2 >= Spr_Y, jump to PRG059_AEFB (RTS)

	INC Spr_Var3,X	; Spr_Var3++

PRG059_AEFB:
	RTS	; $AEFB

PRG059_Gyotot_Fall:
	JSR PRG063_DoMoveSimpleVert	

	LDA Spr_Var2+$00,X
	CMP Spr_Y+$00,X	
	BGE PRG059_AEFB	; If too high, jump to PRG059_AEFB (RTS)

	STA Spr_Y+$00,X	; Lock Y
	
	LDA #SPRANM4_GYOTOT_SWIM
	JSR PRG063_SetSpriteAnim

	LDA #LOW(PRG059_Gyotot_Fall_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Gyotot_Fall_Cont)
	STA Spr_CodePtrH+$00,X

PRG059_Gyotot_Fall_Cont:
	LDY #$1C
	JSR PRG063_DoObjMoveSetFaceDir

	BCC PRG059_AEFB	; If didn't hit wall, jump to PRG059_AEFB (RTS)

	LDA #$00
	STA Spr_XVelFrac+$00,X
	LDA #$02
	STA Spr_XVel+$00,X
	
	LDA #LOW(PRG059_Obj_Gyotot)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Gyotot)
	STA Spr_CodePtrH+$00,X
	
	RTS	; $AF34


PRG059_Obj_Biree:
	LDA Spr_Var1+$00,X
	BNE PRG059_AF57	; If Spr_Var1 > 0, jump to PRG059_AF57

	LDY #SPRDIR_RIGHT	; Y = SPRDIR_RIGHT
	
	LDA Spr_Flags+$00,X
	AND #SPR_HFLIP
	BNE PRG059_AF44	; If horizontally flipped, jump to PRG059_AF44

	INY	; Y = SPRDIR_LEFT

PRG059_AF44:
	TYA
	ORA #SPRDIR_UP
	STA Spr_FaceDir+$00,X
	
	; vertical speed
	LDA #$4C
	STA Spr_YVelFrac+$00,X
	LDA #$01
	STA Spr_YVel+$00,X
	
	INC Spr_Var1+$00,X	; Spr_Var1++

PRG059_AF57:
	LDY #$2A
	JSR PRG063_ObjMoveVert_HitFloor

	BCC PRG059_AF61	; If didn't hit floor, jump to PRG059_AF61

	JMP PRG063_ApplyVelSetFaceDir


PRG059_AF61:
	; Full reverse
	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_RIGHT | SPRDIR_LEFT | SPRDIR_DOWN | SPRDIR_UP)
	STA Spr_FaceDir+$00,X
	
	LDA #LOW(PRG059_Obj_Biree_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Biree_Cont)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Y += 2
	INC Spr_Y+$00,X
	INC Spr_Y+$00,X
	

PRG059_Obj_Biree_Cont:
	LDY #$30
	JSR PRG063_DoObjMoveSetFaceDir

	BCC PRG059_AF83	; If didn't hit solid, jump to PRG059_AF83

	JMP PRG063_DoMoveVertOnlyH16


PRG059_AF83:
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_UP
	BEQ PRG059_AFA9	; If moving up, jump to PRG059_AFA9

	LDA #LOW(PRG059_AF57)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_AF57)
	STA Spr_CodePtrH+$00,X
	
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BNE PRG059_AFA2	; If moving right, jump to PRG059_AFA2

	; Spr_X -= 2
	DEC Spr_X+$00,X
	DEC Spr_X+$00,X
	
	RTS	; $AFA1


PRG059_AFA2:
	; Spr_X += 2
	INC Spr_X+$00,X
	INC Spr_X+$00,X
	RTS	; $AFA8


PRG059_AFA9:
	LDA #LOW(PRG059_AFC9)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_AFC9)
	STA Spr_CodePtrH+$00,X
	
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BNE PRG059_AFC3	; If moving right, jump to PRG059_AFC3

	; Spr_X -= 2
	DEC Spr_X+$00,X
	DEC Spr_X+$00,X
	
	JMP PRG059_AFC9	; Jump to PRG059_AFC9


PRG059_AFC3:
	; Spr_X += 2
	INC Spr_X+$00,X
	INC Spr_X+$00,X

PRG059_AFC9:
	LDY #$2B
	JSR PRG063_DoObjVertMoveUpOnly

	BCC PRG059_AFD3	; If didn't hit solid, jump to PRG059_AFD3

	JMP PRG063_ApplyVelSetFaceDir


PRG059_AFD3:
	; Full reverse
	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_RIGHT | SPRDIR_LEFT | SPRDIR_DOWN | SPRDIR_UP)
	STA Spr_FaceDir+$00,X
	
	; Spr_Y -= 2
	DEC Spr_Y+$00,X
	DEC Spr_Y+$00,X
	
	LDA #LOW(PRG059_Obj_Biree_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Biree_Cont)
	STA Spr_CodePtrH+$00,X
	
	RTS	; $AFEB


PRG059_Obj_Battonton:
	LDA Spr_Var1+$00,X
	BEQ PRG059_B00A	; If Spr_Var1 = 0, jump to PRG059_B00A

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_B01A	; If Spr_Var1 > 0, jump to PRG059_B01A

	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE)
	STA Spr_Flags2+$00,X
	
	LDA #LOW(PRG059_Obj_Battonton_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Battonton_Cont)
	STA Spr_CodePtrH+$00,X
	
	LDA #SPRANM3_BATTONTON_STARTFLY
	JMP PRG063_SetSpriteAnim


PRG059_B00A:
	LDY #$3C	; Y = $3C
	
	LDA <RandomN+$02
	SBC <RandomN+$01
	AND #$01
	BEQ PRG059_B016	; 1:2 jump to PRG059_B016

	LDY #$B4	; Y = $B4

PRG059_B016:
	TYA		; $3C or $B4
	STA Spr_Var1+$00,X	; -> Spr_Var1

PRG059_B01A:
	RTS	; $B01A


PRG059_Obj_Battonton_Cont:
	LDA #SPRANM3_BATTONTON_FLY
	CMP Spr_CurrentAnim+$00,X
	BEQ PRG059_B02E	; If Battonton is flying, jump to PRG059_B02E

	LDA Spr_Frame+$00,X
	CMP #$02
	BNE PRG059_B07C	; If frame <> 2, jump to PRG059_B07C (RTS)

	LDA #SPRANM3_BATTONTON_FLY
	JSR PRG063_SetSpriteAnim

PRG059_B02E:
	LDA Spr_Var2+$00,X
	BNE PRG059_B05A	; If Spr_Var2 <> 0, jump to PRG059_B05A

	JSR PRG063_AimTowardsPlayer
	TAY	; -> 'Y'
	
	LDA PRG059_BattontonFly_XVelFrac,Y
	STA Spr_XVelFrac+$00,X
	LDA PRG059_BattontonFly_XVel,Y
	STA Spr_XVel+$00,X
	
	LDA PRG059_BattontonFly_YVelFrac,Y
	STA Spr_YVelFrac+$00,X
	LDA PRG059_BattontonFly_YVel,Y
	STA Spr_YVel+$00,X
	
	LDA PRG063_Aim_FaceDir,Y
	STA Spr_FaceDir+$00,X
	
	; Spr_Var2 = $79
	LDA #$79
	STA Spr_Var2+$00,X

PRG059_B05A:
	DEC Spr_Var2+$00,X	; Spr_Var2--
	
	JSR PRG063_ApplyVelSetFaceDir
	JSR PRG063_DoMoveVertOnlyH16
	
	JSR PRG063_TestPlayerObjCollide
	BCS PRG059_B07C	; If Player didn't collide, jump to PRG059_B07C


	LDA #$00
	STA Spr_YVelFrac,X
	LDA #$02
	STA Spr_YVel,X
	
	LDA #LOW(PRG059_Obj_Battonton_Retreat)
	STA Spr_CodePtrL,X
	LDA #HIGH(PRG059_Obj_Battonton_Retreat)
	STA Spr_CodePtrH,X

PRG059_B07C:
	RTS	; $B07C

	
PRG059_Obj_Battonton_Retreat:
	LDY #$3A		; Y = $3A
	
	JSR PRG063_DoObjVertMoveUpOnly
	BCC PRG059_B07C		; If Battonton hasn't hit ceiling, jump to PRG059_B07C (RTS)

	LDA #SPRANM3_BATTONTON_ENDFLY
	CMP Spr_CurrentAnim,X
	BEQ PRG059_B08E		; If Battonton is retracting, jump to PRG059_B08E
	
	; Otherwise, start retracting animation
	JSR PRG063_SetSpriteAnim

PRG059_B08E:
	LDA Spr_Frame,X
	CMP #$02
	BNE PRG059_B07C		; If frame <> 2, jump to PRG059_B07C (RTS)

	LDA #LOW(PRG059_Obj_Battonton)
	STA Spr_CodePtrL,X
	LDA #HIGH(PRG059_Obj_Battonton)
	STA Spr_CodePtrH,X
	
	LDA #$00
	STA Spr_Var1,X
	STA Spr_Var2,X
	
	LDA #SPRFL2_HURTPLAYER
	STA Spr_Flags2,X

	LDA #SPRANM3_BATTONTON_IDLE
	JMP PRG063_SetSpriteAnim
	

	; XVel overlaps into YVel at a quarter turn
PRG059_BattontonFly_XVelFrac:
	.byte $00, $40, $5A, $6E
	
PRG059_BattontonFly_YVelFrac:
	.byte $80, $6E, $5A, $40, $00, $40, $5A, $6E, $80, $6E, $5A, $40, $00, $40, $5A, $6E

PRG059_BattontonFly_XVel:
	.byte $00, $00, $00, $00

PRG059_BattontonFly_YVel:
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


PRG059_Obj_Mantan:
	JSR PRG063_DoMoveVertOnlyH16
	JSR PRG063_ApplyVelSetFaceDir

	LDA Spr_Var3+$00
	BNE PRG059_B0EA	; If Spr_Var3 <> 0, jump to PRG059_B0EA

	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir


PRG059_B0EA:
	INC Spr_Var3+$00,X	; Spr_Var3++
	LDA Spr_Var3+$00,X
	CMP #$30
	BNE PRG059_B151	; If Spr_Var3 <> $30, jump to PRG059_B151 (RTS)

	LDA #LOW(PRG059_Obj_Mantan_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Mantan_Cont)
	STA Spr_CodePtrH+$00,X
	
	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir
	
	JSR PRG063_AimTowardsPlayer
	TAY	; -> 'Y'
	
	AND #$07
	STA <Temp_Var0	; Temp_Var0 = 0 to 7
	
	LDA PRG063_Aim_FaceDir,Y
	AND #~(SPRDIR_LEFT | SPRDIR_RIGHT)
	ORA Spr_FaceDir+$00,X
	STA Spr_FaceDir+$00,X
	
	; Spr_Var1 = $30
	LDA #$30
	STA Spr_Var1+$00,X
	
	LDY <Temp_Var0
	JSR PRG059_Mantan_SetSpeedAndAnim


PRG059_Obj_Mantan_Cont:
	LDA Level_RasterYOff
	ADD #$08
	CMP Spr_Y+$00,X
	BLT PRG059_B134	; If Mantan is not above water line, jump to PRG059_B134

	STA Spr_Y+$00,X	; Lock at water line
	
	LDA #SPRANM3_MANTAN_FLAT
	JSR PRG063_SetSpriteAnim


PRG059_B134:
	JSR PRG063_DoMoveVertOnlyH16
	JSR PRG063_ApplyVelSetFaceDir

	LDA Spr_Var1+$00,X
	BEQ PRG059_B151	; If Spr_Var1 = 0, jump to PRG059_B151 (RTS)

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_B151	; If Spr_Var1 > 0, jump to PRG059_B151 (RTS)

	LDA Spr_FaceDir+$00,X
	AND #(SPRDIR_LEFT | SPRDIR_RIGHT)
	STA Spr_FaceDir+$00,X
	
	LDY #$04
	JSR PRG059_Mantan_SetSpeedAndAnim


PRG059_B151:
	RTS	; $B151


PRG059_Mantan_SetSpeedAndAnim:
	LDA PRG059_Mantan_XVelFrac,Y
	STA Spr_XVelFrac+$00,X
	
	LDA PRG059_Mantan_XVel,Y
	STA Spr_XVel+$00,X
	
	LDA PRG059_Mantan_YVelFrac,Y
	STA Spr_YVelFrac+$00,X
	
	LDA PRG059_Mantan_YVel,Y
	STA Spr_YVel+$00,X
	
	LDA PRG059_Mantan_Anim,Y
	JMP PRG063_SetSpriteAnim


PRG059_Mantan_Anim:
	.byte SPRANM3_MANTAN_TILTDOWNFULL, SPRANM3_MANTAN_TILTDOWNFULL, SPRANM3_MANTAN_TILTDOWNFULL, SPRANM3_MANTAN_TILTDOWNHALF, SPRANM3_MANTAN_FLAT, SPRANM3_MANTAN_TILTDOWNHALF, SPRANM3_MANTAN_TILTDOWNFULL, SPRANM3_MANTAN_TILTDOWNFULL
	
PRG059_Mantan_XVelFrac:
	.byte $B5, $B5, $B5, $EC, $00, $EC, $B5, $B5
	
PRG059_Mantan_XVel:
	.byte $00, $00, $00, $00, $01, $00, $00, $00
	
PRG059_Mantan_YVelFrac:
	.byte $B5, $B5, $B5, $61, $00, $61, $B5, $B5
	
PRG059_Mantan_YVel:
	.byte $00, $00, $00, $00, $00, $00, $00, $00


PRG059_Obj_Mummira:
	LDA Spr_Var1+$00,X
	BEQ PRG059_B1A1	; If Spr_Var1 = 0, jump to PRG059_B1A1

	DEC Spr_Var1+$00,X	; Spr_Var1--
	RTS	; $B1A0


PRG059_B1A1:
	LDA Spr_Flags+$00,X
	AND #SPRFL1_NODRAW
	BNE PRG059_B1BA	; If not drawing, jump to PRG059_B1BA

	LDA Spr_Frame+$00,X
	CMP #$06
	BLT PRG059_B1D6	; If frame < 6, jump to PRG059_B1D6 (RTS)

	LDA #LOW(PRG059_Obj_Mummira_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Mummira_Cont)
	STA Spr_CodePtrH+$00,X
	
	RTS	; $B1B9


PRG059_B1BA:
	JSR PRG063_CalcObjXDiffFromPlayer
	CMP #$80
	BGE PRG059_B1D6	; If Player X diff >= $80, jump to PRG059_B1D6 (RTS)

	LDA Spr_Flags+$00,X
	AND #~SPRFL1_NODRAW
	STA Spr_Flags+$00,X
	
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $15)
	STA Spr_Flags2+$00,X
	
	LDA #$00
	STA Spr_Frame+$00,X
	STA Spr_AnimTicks+$00,X

PRG059_B1D6:
	RTS	; $B1D6


PRG059_Obj_Mummira_Cont:
	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir

	LDA Spr_Var2+$00,X
	BEQ PRG059_B1EF	; If Spr_Var2 = 0, jump to PRG059_B1EF

	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	DEC Spr_Var2+$00,X	; Spr_Var2--
	BNE PRG059_B1D6	; If Spr_Var2 > 0, jump to PRG059_B1D6 (RTS)

	INC Spr_Frame+$00,X	; $B1EC

PRG059_B1EF:
	LDA Spr_AnimTicks+$00,X
	BNE PRG059_B1D6	; If anim ticks > 0, jump to PRG059_B1D6 (RTS)

	LDA Spr_Frame+$00,X
	CMP #$15
	BEQ PRG059_B226	; If frame = $15, jump to PRG059_B226

	CMP #$1F
	BEQ PRG059_B220	; If frame = $1F, jump to PRG059_B220

	CMP #$26
	BNE PRG059_B1D6	; If frame <> $26, jump to PRG059_B1D6 (RTS)

	LDA Spr_Flags+$00,X
	ORA #SPRFL1_NODRAW
	STA Spr_Flags+$00,X
	
	LDA #(SPRFL2_HURTPLAYER | $15)
	STA Spr_Flags2+$00,X
	
	LDA #LOW(PRG059_Obj_Mummira)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Mummira)
	STA Spr_CodePtrH+$00,X
		
	; Spr_Var1 = $1E
	LDA #$1E
	STA Spr_Var1+$00,X
	
	RTS	; $B21F


PRG059_B220:
	; Spr_Var2 = $40
	LDA #$40
	STA Spr_Var2+$00,X
	
	RTS	; $B225


PRG059_B226:
	JSR PRG063_AimTowardsPlayer
	TAY	; -> 'Y'
	
	LSR A	; Half-accuracy aim
	STA <Temp_Var14	; -> Temp_Var14
	
	LDA PRG063_Aim_FaceDir,Y
	AND #(SPRDIR_UP | SPRDIR_DOWN)
	ORA Spr_FaceDir+$00,X
	STA Spr_FaceDir+$00,X
	
	STX <Temp_Var15	; Backup object slot index -> Temp_Var15
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_B1D6	; If no free object slot, jump to PRG059_B1D6 (RTS)

	LDA #SPRSLOTID_MUMMIRAHEAD
	STA Spr_SlotID+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | $0E)
	STA Spr_Flags2+$00,Y
	
	; HP = 3 (??)
	LDA #$03
	STA Spr_HP+$00,Y
	
	LDA Spr_FaceDir+$00,X
	STA Spr_FaceDir+$00,Y
	
	AND #SPRDIR_RIGHT
	ADD #$33	; $33 or $34
	STA <Temp_Var16	; -> Temp_Var16
	LDA #SPRANM2_MUMMIRA_HEAD
	JSR PRG063_InitProjectile

	LDX <Temp_Var14	; X = half-accurate aim index
	
	LDA PRG059_MummiraHead_YVelFrac,X
	STA Spr_YVelFrac+$00,Y
	LDA PRG059_MummiraHead_YVel,X
	STA Spr_YVel+$00,Y
	
	LDA PRG059_MummiraHead_XVelFrac,X
	STA Spr_XVelFrac+$00,Y
	LDA PRG059_MummiraHead_XVel,X
	STA Spr_XVel+$00,Y
	
	LDX <Temp_Var15	; Restore object slot index
	
	RTS	; $B27C


PRG059_MummiraHead_XVelFrac:
	.byte $6A, $6A, $6A, $D9, $00, $D9, $6A, $6A
	
PRG059_MummiraHead_XVel:
	.byte $01, $01, $01, $01, $02, $01, $01, $01

PRG059_MummiraHead_YVelFrac:
	.byte $6A, $6A, $6A, $C3, $00, $C3, $6A, $6A
	
PRG059_MummiraHead_YVel:
	.byte $01, $01, $01, $00, $00, $00, $01, $01


PRG059_Obj_MummiraHead:
	JSR PRG063_ApplyVelSetFaceDir
	JMP PRG063_DoMoveVertOnlyH16


PRG059_Obj_Imorm:
	JSR PRG063_CalcObjXDiffFromPlayer
	CMP #$40
	BGE PRG059_B2F6	; If Player X diff >= $40, jump to PRG059_B2F6 (RTS)

	LDA #$00
	STA Spr_YVelFrac+$00,X
	STA Spr_YVel+$00,X
	
	LDA Spr_Flags+$00,X
	AND #~SPRFL1_NODRAW
	STA Spr_Flags+$00,X
	
	LDA #LOW(PRG059_Obj_Imorm_Drop)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Imorm_Drop)
	STA Spr_CodePtrH+$00,X
	
	RTS	; $B2C4


PRG059_Obj_Imorm_Drop:
	LDA Spr_Var1+$00,X
	BEQ PRG059_B2E5	; If Spr_Var1 = 0, jump to PRG059_B2E5

	; hold animation
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_B2F6	; If Spr_Var1 > 0, jump to PRG059_B2F6 (RTS)

	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir

	LDA #LOW(PRG059_Obj_Imorm_Crawl)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Imorm_Crawl)
	STA Spr_CodePtrH+$00,X
	
	RTS	; $B2E4


PRG059_B2E5:
	LDY #$06
	JSR PRG063_DoObjVertMovement

	BCC PRG059_B2F6	; If didn't hit solid, jump to PRG059_B2F6 (RTS)

	LDA #SPRANM2_IMORM_CRAWLING
	JSR PRG063_SetSpriteAnim

	; Spr_Var1 = $14
	LDA #$14
	STA Spr_Var1+$00,X

PRG059_B2F6:
	RTS	; $B2F6


PRG059_Obj_Imorm_Crawl:
	LDY Spr_Frame+$00,X	; Y = Spr_Frame
	
	LDA PRG059_Imorm_Flags2ByFrame,Y
	STA Spr_Flags2+$00,X
	
	LDA Spr_AnimTicks+$00,X
	CMP #$04
	BNE PRG059_B2F6	; If anim ticks <> 4, jump to PRG059_B2F6 (RTS)

	LDA Spr_Frame+$00,X
	AND #$01
	BEQ PRG059_B2F6	; Every other frame, jump to PRG059_B2F6 (RTS)

	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BEQ PRG059_B329	; If moving left, jump to PRG059_B329
	
	; Moving right...

	; X += 4
	LDA Spr_X+$00,X
	ADD #$04
	STA Spr_X+$00,X
	LDA Spr_XHi+$00,X
	ADC #$00
	STA Spr_XHi+$00,X
	
	JMP PRG059_B33A	; Jump to PRG059_B33A


PRG059_B329:

	; X -= 4
	LDA Spr_X+$00,X
	SUB #$04
	STA Spr_X+$00,X
	LDA Spr_XHi+$00,X
	SBC #$00
	STA Spr_XHi+$00,X

PRG059_B33A:
	LDY #$18
	JSR PRG062_ObjDetFloorAttrs

	LDY #$00	; Y = 0
	
	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	BEQ PRG059_B34A	; If moving left, jump to PRG059_B34A

	; moving right

	LDY #$02	; $B348

PRG059_B34A:
	LDA Level_TileAttrsDetected+$00,Y
	AND #TILEATTR_SOLID
	BNE PRG059_B354	; If hit solid, jump to PRG059_B354

	JMP PRG063_FlipObjDirAndSpr


PRG059_B354:
	LDY Spr_Frame+$00,X	; Y = Spr_Frame
	
	LDA Spr_FaceDir+$00,X
	LSR A		
	AND #$01	; 0 if right, 1 if left
	ORA PRG059_Imorm_BBoxByFrame,Y
	TAY	; -> 'Y'
	JSR PRG062_ObjDetWallAttrs	; $B361

	LDA <Temp_Var16
	AND #TILEATTR_SOLID
	BEQ PRG059_B36D	; If didn't hit solid, jump to PRG059_B36D

	JSR PRG063_FlipObjDirAndSpr

PRG059_B36D:
	RTS	; $B36D

PRG059_Imorm_BBoxByFrame:
	.byte $0E, $0E, $24, $24, $36, $36, $24, $24

PRG059_Imorm_Flags2ByFrame:
	.byte SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE, SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE, SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE, SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE, SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $39, SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $39, SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE, SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE


PRG059_Obj_MonoRoader:
	LDA Spr_Var1+$00,X
	BEQ PRG059_B3BB	; If Spr_Var1 = 0, jump to PRG059_B3BB

	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_B3D8	; If Spr_Var1 > 0, jump to PRG059_B3D8 (RTS)

	LDA #LOW(PRG059_Obj_MonoRoader_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_MonoRoader_Cont)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var4 = 1
	LDA #$01
	STA Spr_Var4+$00,X
	
	LDA #$00
	STA Spr_XVelFrac+$00,X
	LDA #$02
	STA Spr_XVel+$00,X
	
	LDA #(SPRFL2_HURTPLAYER | $0D)
	STA Spr_Flags2+$00,X
	
	; Spr_Var2 = $20
	LDA #$20
	STA Spr_Var2+$00,X
	
	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir

	LDA #SPRANM3_MONOROADER_SPIN
	JMP PRG063_SetSpriteAnim


PRG059_B3BB:
	LDY #$08
	JSR PRG063_DoObjVertMovement

	BCC PRG059_B3D8	; If didn't hit solid, jump to PRG059_B3D8 (RTS)

	LDY #$14
	JSR PRG063_DoObjMoveSetFaceDir

	BCC PRG059_B3CC	; If didn't hit solid, jump to PRG059_B3CC

	JMP PRG063_FlipObjDirAndSpr


PRG059_B3CC:
	JSR PRG063_CalcObjXDiffFromPlayer

	CMP #$30
	BGE PRG059_B3D8	; If Monoroader is more than $30 X diff away, jump to PRG059_B3D8 (RTS)

	; Spr_Var1 = $0A
	LDA #$0A
	STA Spr_Var1+$00,X

PRG059_B3D8:
	RTS	; $B3D8


PRG059_Obj_MonoRoader_Cont:
	LDA Spr_Var3+$00,X
	BEQ PRG059_B3EB	; If Spr_Var3 = 0, jump to PRG059_B3EB

	DEC Spr_Var3+$00,X	; Spr_Var3--
	BNE PRG059_B3D8	; If Spr_Var3 > 0, jump to PRG059_B3D8 (RTS)

	; Spr_Var2 = $20
	LDA #$20
	STA Spr_Var2+$00,X
	
	JSR PRG063_FlipObjDirAndSpr


PRG059_B3EB:
	LDY #$08
	JSR PRG063_DoObjVertMovement

	BCC PRG059_B42F	; If didn't hit solid, jump to PRG059_B42F

	LDY #$14
	JSR PRG063_DoObjMoveSetFaceDir

	BCC PRG059_B3FC	; If didn't hit solid, jump to PRG059_B3FC

	JMP PRG063_FlipObjDirAndSpr


PRG059_B3FC:
	DEC Spr_Var2+$00,X	; Spr_Var2--
	BNE PRG059_B42F	; If Spr_Var2 > 0, jump to PRG059_B42F

	DEC Spr_Var4+$00,X	; Spr_Var4--
	BPL PRG059_B42A	; If Spr_Var4 >= 0, jump to PRG059_B42A

	LDA #LOW(PRG059_Obj_MonoRoader)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_MonoRoader)
	STA Spr_CodePtrH+$00,X
	
	LDA #$00
	STA Spr_XVelFrac+$00,X
	LDA #$01
	STA Spr_XVel+$00,X
	
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $0D)
	STA Spr_Flags2+$00,X
	
	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir

	LDA #SPRANM3_MONOROADER_ROLL
	JMP PRG063_SetSpriteAnim


PRG059_B42A:
	; Spr_Var3 = $1E
	LDA #$1E
	STA Spr_Var3+$00,X

PRG059_B42F:
	RTS	; $B42F


PRG059_Obj_Gachappon:
	LDY #$01	; Y = 1
	BEQ PRG059_B45C	; Never jump to PRG059_B45C!


PRG059_Obj_Gachappon_Cont:
	LDA Spr_Var1+$00,X
	BEQ PRG059_B43E	; If Spr_Var1 = 0, jump to PRG059_B43E

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_B474	; If Spr_Var1 > 0, jump to PRG059_B474


PRG059_B43E:
	LDA Spr_Frame+$00,X
	ORA Spr_AnimTicks+$00,X
	BNE PRG059_B474	; If frame <> 0 or anim ticks <> 0, jump to PRG059_B474

	LDY #$01	; Y = 1
	
	LDA #$02
	CMP Spr_Var3+$00,X
	BEQ PRG059_B45C	; If Spr_Var3 = 2, jump to PRG059_B45C

	DEY	; Y = 0
	
	CMP Spr_Var4+$00,X
	BEQ PRG059_B45C	; If Spr_Var4 = 2, jump to PRG059_B45C

	LDA <RandomN+$02
	ADC <RandomN+$03
	AND #$01
	TAY	; Y = 0 to 1

PRG059_B45C:
	LDA PRG059_Gachappon_CodePtrL,Y
	STA Spr_CodePtrL+$00,X
	LDA PRG059_Gachappon_CodePtrH,Y
	STA Spr_CodePtrH+$00,X
	
	LDA PRG059_Gachappon_Var2,Y
	STA Spr_Var2+$00,X
	
	LDA PRG059_Gachappon_Anim,Y
	STA Spr_CurrentAnim+$00,X

PRG059_B474:
	RTS	; $B474

PRG059_Gachappon_Gashapon:
	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir

	LDA Spr_Var1+$00,X
	BEQ PRG059_B488	; If Spr_Var1 = 0, jump to PRG059_B488

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_B474	; If Spr_Var1 > 0, jump to PRG059_B474 (RTS)

	INC Spr_CurrentAnim+$00,X

PRG059_B488:
	LDA Spr_Frame+$00,X
	CMP #$03
	BEQ PRG059_B4AE	; If frame = 3, jump to PRG059_B4AE

	CMP #$05
	BNE PRG059_B474	; If frame = 5, jump to PRG059_B474 (RTS)

	LDA #SPRANM3_GACHAPPON_IDLE
	JSR PRG063_SetSpriteAnim

	DEC Spr_Var2+$00,X	; Spr_Var2--
	BEQ PRG059_B4A3	; If Spr_Var2 = 0, jump to PRG059_B4A3

	; Spr_Var1 = $20
	LDA #$20
	STA Spr_Var1+$00,X
	
	RTS	; $B4A2


PRG059_B4A3:
	; Spr_Var4 = 0
	LDA #$00
	STA Spr_Var4+$00,X
	
	INC Spr_Var3+$00,X	; Spr_Var3++
	
	JMP PRG059_B531	; Jump to PRG059_B531


PRG059_B4AE:
	INC Spr_Frame+$00,X	; frame++
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_B509	; If no free object slot, jump to PRG059_B509 (RTS)

	LDA #SPRSLOTID_GACHAPPON_GASHAPON
	STA Spr_SlotID+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | $0F)
	STA Spr_Flags2+$00,Y
	
	; HP = 0
	LDA #$00
	STA Spr_HP+$00,Y
	
	LDA Spr_FaceDir+$00,X
	STA Spr_FaceDir+$00,Y
	AND #$01
	ADD #$63
	STA <Temp_Var16	; $63 or $64
	
	LDA #SPRANM3_GACHAPPON_GASHAPONB
	JSR PRG063_InitProjectile

	LDA #$00
	STA Spr_YVelFrac+$00,Y
	LDA #$04
	STA Spr_YVel+$00,Y
	
	; Temp_Var3 = $28
	LDA #$28
	STA <Temp_Var3
	
	JSR PRG063_CalcObjXDiffFromPlayer
	STA <Temp_Var1	; -> Temp_Var1
	
	CMP #$60
	BLT PRG059_B4F2	; If X diff < $60, jump to PRG059_B4F2

	; Temp_Var3 = $32
	LDA #$32
	STA <Temp_Var3

PRG059_B4F2:
	; Speed to figure the gashapon shot
	LDA #$00
	STA <Temp_Var0	; Temp_Var0 = 0
	STA <Temp_Var2	; Temp_Var2 = 0
	
	STY <Temp_Var15		; Backup 'Y' -> Temp_Var15
	
	JSR PRG063_ScaleVal

	LDY <Temp_Var15		; Restore 'Y'
	
	LDA <Temp_Var4
	STA Spr_XVelFrac+$00,Y
	LDA <Temp_Var5
	STA Spr_XVel+$00,Y

PRG059_B509:
	RTS	; $B509


PRG059_Gachappon_Shoot:
	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir

	LDA Spr_Frame+$00,X
	CMP #$09
	BEQ PRG059_B545	; If frame = 9, jump to PRG059_B545

	CMP #$0F
	BNE PRG059_B509	; If frame <> $0F, jump to PRG059_B509 (RTS)

	DEC Spr_Var2+$00,X	; Spr_Var2--
	BEQ PRG059_B529	; If Spr_Var2 = 0, jump to PRG059_B529

	LDA #$00
	STA Spr_Frame+$00,X
	STA Spr_AnimTicks+$00,X
	
	RTS	; $B528


PRG059_B529:
	LDA #$00
	STA Spr_Var3+$00,X	; Spr_Var3 = 0
	
	INC Spr_Var4+$00,X	; Spr_Var4++

PRG059_B531:
	LDA #LOW(PRG059_Obj_Gachappon_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Gachappon_Cont)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var1 = $3C
	LDA #$3C
	STA Spr_Var1+$00,X
	
	LDA #SPRANM3_GACHAPPON_IDLE
	JMP PRG063_SetSpriteAnim


PRG059_B545:
	INC Spr_Frame+$00,X	; frame++
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_B509	; If no free object slot, jump to PRG059_B509 (RTS)

	LDA #SPRSLOTID_GACHAPPON_BULLET
	STA Spr_SlotID+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | $0F)
	STA Spr_Flags2+$00,Y
	
	; HP = 0
	LDA #$00
	STA Spr_HP+$00,Y
	
	; Projectile init index
	LDA Spr_FaceDir+$00,X
	STA Spr_FaceDir+$00,Y
	AND #$01
	ADD #$65	; $65 or $66
	STA <Temp_Var16	; -> Temp_Var16
	
	LDA #SPRANM3_CIRCULAR_BULLET
	JSR PRG063_InitProjectile

	LDA #$00
	STA Spr_XVelFrac+$00,Y
	LDA #$04
	STA Spr_XVel+$00,Y
	
	LDX <Temp_Var15	; Restore object slot index
	
	RTS	; $B57A


PRG059_Gachappon_Anim:
	.byte SPRANM3_GACHAPPON_GASHAPON		; 0
	.byte SPRANM3_GACHAPPON_SHOOT			; 1

PRG059_Gachappon_CodePtrL:
	.byte LOW(PRG059_Gachappon_Gashapon)	; 0
	.byte LOW(PRG059_Gachappon_Shoot)		; 1
	
PRG059_Gachappon_CodePtrH:
	.byte HIGH(PRG059_Gachappon_Gashapon)	; 0
	.byte HIGH(PRG059_Gachappon_Shoot)		; 1
	
PRG059_Gachappon_Var2:
	.byte $03	; 0
	.byte $02	; 1


	; CHECKME - UNUSED?
	.byte $28, $40, $4E, $5A, $D4, $00, $E5, $A9, $02, $04, $04, $05	; $B583 - $B58E


PRG059_Obj_GachapponBullet:
	JMP PRG063_ApplyVelSetFaceDir


PRG059_Obj_GachapponGashapon:
	JSR PRG063_DoMoveSimpleVert
	JMP PRG063_ApplyVelSetFaceDir


PRG059_Obj_Pakatto24:
	JSR PRG063_SetObjFlipForFaceDir	

	LDA Spr_Var1+$00,X
	BEQ PRG059_B5AA	; If Spr_Var1 = 0, jump to PRG059_B5AA

	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_B5BC	; If Spr_Var1 >= 0, jump to PRG059_B5BC (RTS)


PRG059_B5AA:
	INC Spr_Frame+$00,X	; frame++
	
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE)
	STA Spr_Flags2+$00,X
	
	LDA #LOW(PRG059_Obj_Pakatto24_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Pakatto24_Cont)
	STA Spr_CodePtrH+$00,X

PRG059_B5BC:
	RTS	; $B5BC


PRG059_Obj_Pakatto24_Cont:
	LDA Spr_AnimTicks+$00,X
	CMP #$06
	BNE PRG059_B5BC	; If anim ticks <> 6, jump to PRG059_B5BC (RTS)

	LDA Spr_Frame+$00,X
	CMP #$01
	BEQ PRG059_B5EC	; If frame = 1, jump to PRG059_B5EC

	CMP #$03
	BNE PRG059_B5BC	; If frame <> 3, jump to PRG059_B5BC

	LDA <RandomN+$03
	ADC <RandomN+$01
	AND #$01
	TAY	; Y = 0 or 1
	
	LDA PRG059_Pakatto24_Var1,Y
	STA Spr_Var1+$00,X
	
	LDA #LOW(PRG059_Obj_Pakatto24)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_Pakatto24)
	STA Spr_CodePtrH+$00,X
	
	LDA #SPRFL2_HURTPLAYER
	STA Spr_Flags2+$00,X
	
	RTS	; $B5EB


PRG059_B5EC:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_B5BC	; If no free object slot index, jump to PRG059_B5BC (RTS)

	LDA #SPRSLOTID_PAKATTO24_SHOT
	STA Spr_SlotID+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | $0F)
	STA Spr_Flags2+$00,Y
	
	; HP = 0
	LDA #$00
	STA Spr_HP+$00,Y
	
	; projectile init index
	LDA Spr_FaceDir+$00,X
	STA Spr_FaceDir+$00,Y
	AND #$01
	ADD #$39
	STA <Temp_Var16	; -> Temp_Var16
	
	LDA #SPRANM3_CIRCULAR_BULLET
	JSR PRG063_InitProjectile

	LDA #$80
	STA Spr_XVelFrac+$00,Y
	LDA #$01
	STA Spr_XVel+$00,Y
	
	RTS	; $B61C


PRG059_Pakatto24_Var1:
	.byte $3C, $5A


PRG059_Obj_Pakatto24_Shot:
	JMP PRG063_ApplyVelSetFaceDir


PRG059_Obj_UpNDown_Spawner:
	LDA Weapon_FlashStopCnt+$00
	ORA Weapon_FlashStopCnt+$01
	BNE PRG059_B66B	; If Flash Stopper active, jump to PRG059_B66B (RTS)

	JSR PRG063_SetObjFlipForFaceDir
	
	JSR PRG063_CalcObjXDiffFromPlayer
	CMP #$20
	BGE PRG059_B66B	; If Player X diff >= $20, jump to PRG059_B66B (RTS)

	LDA Spr_Var1+$00,X
	BEQ PRG059_B63D	; If Spr_Var1 = 0, jump to PRG059_B63D

	DEC Spr_Var1+$00,X	; Spr_Var1--
	RTS	; $B63C


PRG059_B63D:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_B66B	; If no free object slot, jump to PRG059_B66B (RTS)

	LDA #SPRSLOTID_UPNDOWN
	STA Spr_SlotID+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE)
	STA Spr_Flags2+$00,Y
	
	; HP = 1
	LDA #$01
	STA Spr_HP+$00,Y
	
	LDA Spr_FaceDir+$00,X
	STA Spr_FaceDir+$00,Y
	
	LDA #SPRANM2_UPNDOWN
	JSR PRG063_CopySprSlotSetAnim

	LDA #$00
	STA Spr_YVelFrac+$00,Y
	LDA #$03
	STA Spr_YVel+$00,Y
	
	; Spr_Var1 = $78
	LDA #$78
	STA Spr_Var1+$00,X

PRG059_B66B:
	RTS	; $B66B


PRG059_Obj_UpNDown:
	LDA <RandomN+$02
	ADC <RandomN+$03
	AND #$03
	TAY	; Y = 0 to 3
	
	LDA PRG059_UpNDown_Var1,Y
	STA Spr_Var1+$00,X
	
	LDA #LOW(PRG059_Obj_UpNDown_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_UpNDown_Cont)
	STA Spr_CodePtrH+$00,X

PRG059_B683:
	RTS	; $B683

PRG059_Obj_UpNDown_Cont:
	JSR PRG063_ApplyYVelocityNeg

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_B683	; If Spr_Var1 > 0, jump to PRG059_B683 (RTS)

	LDA #$B3
	STA Spr_YVelFrac+$00,X
	LDA #$00
	STA Spr_YVel+$00,X
	
	LDA #$59
	STA Spr_XVelFrac+$00,X
	LDA #$00
	STA Spr_XVel+$00,X
	
	LDA #SPRDIR_LEFT
	STA Spr_FaceDir+$00,X
	
	; Spr_Var2 = $0B
	LDA #$0B
	STA Spr_Var2+$00,X
	
	LDA #LOW(PRG059_Obj_UpNDown_MoveUp)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_UpNDown_MoveUp)
	STA Spr_CodePtrH+$00,X
	
	RTS	; $B6B4


PRG059_Obj_UpNDown_MoveUp:
	JSR PRG063_ApplyYVelocityH16

	; Save flags
	LDA Spr_Flags+$00,X
	PHA
	
	JSR PRG063_ApplyVelSetFaceDir

	; Restore flags
	PLA
	STA Spr_Flags+$00,X
	
	DEC Spr_Var2+$00,X	; Spr_Var2--
	BNE PRG059_B6DC	; If Spr_Var2 > 0, jump to PRG059_B6DC (RTS)

	; Spr_Var2 = $0B
	LDA #$0B
	STA Spr_Var2+$00,X
	
	INC Spr_Var3+$00,X	; Spr_Var3++
	LDA Spr_Var3+$00,X
	AND #$03
	TAY	; Y = 0 to 3
	
	LDA PRG059_UpNDown_FaceDir,Y
	STA Spr_FaceDir+$00,X

PRG059_B6DC:
	RTS	; $B6DC


PRG059_UpNDown_Var1:
	.byte $2A, $35, $40, $35
	
PRG059_UpNDown_FaceDir:
	.byte SPRDIR_LEFT, SPRDIR_RIGHT, SPRDIR_RIGHT, SPRDIR_LEFT


PRG059_Obj_SeaMine:
	LDA #$40
	STA Spr_YVelFrac+$00,X
	LDA #$00
	STA Spr_YVel+$00,X
	
	LDA #SPRDIR_UP
	STA Spr_FaceDir+$00,X
	
	; Spr_Var1 = $40
	LDA #$40
	STA Spr_Var1+$00,X
	
	LDA #LOW(PRG059_Obj_SeaMine_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_SeaMine_Cont)
	STA Spr_CodePtrH+$00,X
	
PRG059_Obj_SeaMine_Cont:
	JSR PRG063_CalcObjYDiffFromPlayer

	CMP #$40
	BGE PRG059_B737	; If Player Y diff >= $40, jump to PRG059_B737

	JSR PRG063_CalcObjXDiffFromPlayer

	CMP #$40
	BGE PRG059_B73C	; If Player X diff >= $40, jump to PRG059_B73C

	; Close enough to the mine

	LDA Spr_Var3+$00,X
	BEQ PRG059_B737	; If Spr_Var3 = 0, jump to PRG059_B737

	DEC Spr_Var3+$00,X	; Spr_Var3--
	BNE PRG059_B73C	; If Spr_Var3 > 0, jump to PRG059_B73C

	LDA <RandomN+$01
	ADC <RandomN+$02
	AND #$01
	BNE PRG059_B737	; 1:2 jump to PRG059_B737

	LDA #LOW(PRG059_Obj_SeaMine_Explode)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_SeaMine_Explode)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var1 = $40
	LDA #$40
	STA Spr_Var1+$00,X
	
	LDA #SPRANM2_SEAMINE_PENDINGEXPL
	JMP PRG063_SetSpriteAnim


PRG059_B737:
	; Spr_Var3 = $40
	LDA #$40
	STA Spr_Var3+$00,X

PRG059_B73C:
	LDA Spr_Var2+$00,X
	BEQ PRG059_B753	; If Spr_Var2 = 0, jump to PRG059_B753

	DEC Spr_Var2+$00,X	; Spr_Var2--
	BNE PRG059_B760	; If Spr_Var2 > 0, jump to PRG059_B760 (RTS)

	; Spr_Var1 = $40
	LDA #$40
	STA Spr_Var1+$00,X
	
	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_UP | SPRDIR_DOWN)
	STA Spr_FaceDir+$00,X

PRG059_B753:
	JSR PRG063_DoMoveVertOnlyH16

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_B760	; If Spr_Var1 > 0, jump to PRG059_B760 (RTS)

	; Spr_Var2 = $1E
	LDA #$1E
	STA Spr_Var2+$00,X

PRG059_B760:
	RTS	; $B760


PRG059_Obj_SeaMine_Explode:
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_B760	; If Spr_Var1 > 0, jump to PRG059_B760 (RTS)

	LDA #$00
	STA Spr_Var1+$00,X	; Spr_Var1 = 0
	STA Spr_Var2+$00,X	; Spr_Var2 = 0
	
	JSR PRG062_ResetSpriteSlot

	LDA #SPRSLOTID_SPIRALEXPLOSION
	STA Spr_SlotID+$00,X
	
	LDA #(SPRFL2_HURTPLAYER | $14)
	STA Spr_Flags2+$00,X
	
	LDA #SPRANM4_SMALLPOOFEXP
	JMP PRG063_SetSpriteAnim


PRG059_Obj_Garyoby:
	LDA #$C0
	STA Spr_XVelFrac+$00,X
	LDA #$00
	STA Spr_XVel+$00,X
	
	JSR PRG063_CalcObjYDiffFromPlayer

	CMP #$08
	BGE PRG059_B79B	; If Player Y diff >= $08, jump to PRG059_B79B

	LDA #$00
	STA Spr_XVelFrac+$00,X
	LDA #$02
	STA Spr_XVel+$00,X

PRG059_B79B:
	LDY #$0E
	JSR PRG063_DoObjVertMovement

	LDA Spr_FaceDir+$00,X
	AND #SPRDIR_RIGHT
	TAY	; Y = 0 if left, 1 if right
	
	LDA Level_TileAttrsDetected+$00,Y
	AND #TILEATTR_SOLID
	BEQ PRG059_B7B4	; If solid not detected (edge), jump to PRG059_B7B4

	LDY #$18
	JSR PRG063_DoObjMoveSetFaceDir

	BCC PRG059_B7BC	; If solid not detected, jump to PRG059_B7BC

	; Hit wall

PRG059_B7B4:
	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_LEFT | SPRDIR_RIGHT)
	STA Spr_FaceDir+$00,X

PRG059_B7BC:
	LDA Spr_Flags+$00,X
	AND #~SPR_HFLIP
	STA Spr_Flags+$00,X
	
	RTS	; $B7C4


PRG059_Obj_Docron:
	LDA Spr_Frame+$00,X
	BNE PRG059_B801	; If frame <> 0, jump to PRG059_B801

	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	LDA Spr_Var1+$00,X
	BEQ PRG059_B7D9	; If Spr_Var1 = 0, jump to PRG059_B7D9

	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_B7FA	; If Spr_Var1 > 0, jump to PRG059_B7FA (RTS)


PRG059_B7D9:
	
	LDY #$17	; Y = $17 (all object slots)
	
	; Temp_Var0 = 0 (skull count)
	LDA #$00
	STA <Temp_Var0
	
PRG059_B7DF:
	LDA Spr_SlotID+$00,Y
	BEQ PRG059_B7EA	; If empty, jump to PRG059_B7EA

	CMP #SPRSLOTID_DOCRON_SKULL
	BNE PRG059_B7EA	; If this isn't one of the Docron Skulls, jump to PRG059_B7EA

	INC <Temp_Var0	; Temp_Var0++ (counting skulls)

PRG059_B7EA:
	DEY	; Y--
	CPY #$07
	BNE PRG059_B7DF	; While Y > 7, loop!

	LDA <Temp_Var0
	CMP #$03
	BLT PRG059_B7FB	; If Temp_Var0 < 3 (not too many skulls), jump to PRG059_B7FB

	; Spr_Var1 = $B4
	LDA #$B4
	STA Spr_Var1,X

PRG059_B7FA:
	RTS	; $B7FA


PRG059_B7FB:
	INC Spr_Frame+$00,X	; frame++
	
	JMP PRG059_B81B	; Jump to PRG059_B81B


PRG059_B801:
	LDA Spr_AnimTicks+$00,X
	BNE PRG059_B85F	; If anim ticks <> 0, jump to PRG059_B85F (RTS)

	LDA Spr_Frame+$00,X
	CMP #$03
	BNE PRG059_B85F	; If frame <> 3, jump to PRG059_B85F (RTS)

	LDA #$00
	STA Spr_AnimTicks+$00,X
	STA Spr_Frame+$00,X
	
	; Spr_Var1 = $B4
	LDA #$B4
	STA Spr_Var1+$00,X
	
	RTS	; $B81A


PRG059_B81B:
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_B85F	; If no free object slot, jump to PRG059_B85F (RTS)

	LDA #SPRSLOTID_DOCRON_SKULL
	STA Spr_SlotID+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE)
	STA Spr_Flags2+$00,Y
	
	; HP = 1
	LDA #$01
	STA Spr_HP+$00,Y
	
	LDA #SPRANM1_DOCRON_SKULL
	JSR PRG063_CopySprSlotSetAnim

	LDA Spr_Y+$00,Y
	ADD #$10
	STA Spr_Y+$00,Y
	LDA Spr_YHi+$00,Y
	ADC #$00
	STA Spr_YHi+$00,Y
	
	LDA #$00
	STA Spr_XVelFrac+$00,Y
	STA Spr_YVelFrac+$00,Y
	STA Spr_YVel+$00,Y
	
	LDA #$01
	STA Spr_XVel+$00,Y
	
	; Spr_Var2 = 1
	LDA #$01
	STA Spr_Var2+$00,Y
	
	; Spr_Var3 = $2C
	LDA #$2C
	STA Spr_Var3+$00,Y

PRG059_B85F:
	RTS	; $B85F


PRG059_Obj_DocronSkull:
	JSR PRG059_DocronSkull_Timeout

	LDY #$08
	JSR PRG063_DoObjVertMovement

	BCC PRG059_B85F	; If didn't hit floor, jump to PRG059_B85F (RTS)

	LDA Spr_Var1+$00,X
	BNE PRG059_B87D	; If Spr_Var1 > 0, jump to PRG059_B87D

	LDA #$00
	STA Spr_YVelFrac+$00,X
	LDA #$02
	STA Spr_YVel+$00,X
	
	INC Spr_Var1+$00,X	; Spr_Var1++
	RTS	; $B87C


PRG059_B87D:
	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir

	LDA #LOW(PRG059_Obj_DocronSkull_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_DocronSkull_Cont)
	STA Spr_CodePtrH+$00,X
	
	LDA #SPRANM1_DOCRON_SKULL2
	JMP PRG063_SetSpriteAnim

PRG059_Obj_DocronSkull_Cont:
	LDY #$08
	JSR PRG063_DoObjVertMovement

	BCC PRG059_DocronSkull_Timeout	; If didn't hit solid, jump to PRG059_DocronSkull_Timeout

	LDY #$14
	JSR PRG063_DoObjMoveSetFaceDir

	BCC PRG059_DocronSkull_Timeout	; If didn't hit wall, jump to PRG059_DocronSkull_Timeout

	JSR PRG063_FlipObjDirAndSpr


PRG059_DocronSkull_Timeout:
	LDA Spr_Var3+$00,X
	SUB #$01
	STA Spr_Var3+$00,X
	LDA Spr_Var2+$00,X
	SBC #$00
	STA Spr_Var2+$00,X
	
	BPL PRG059_B8C3

	JSR PRG062_ResetSpriteSlot

	LDA #SPRSLOTID_MISCSTUFF
	STA Spr_SlotID+$00,X
	
	LDA #SPRANM4_SMALLPOOFEXP
	JSR PRG063_SetSpriteAnim


PRG059_B8C3:
	RTS	; $B8C3


PRG059_Obj_Togehero_SpawnerR:
PRG059_Obj_Togehero_SpawnerL:
	LDA Weapon_FlashStopCnt+$00
	ORA Weapon_FlashStopCnt+$01
	BNE PRG059_B8C3	; If Flash Stopper is active, jump to PRG059_B8C3 (RTS)

	; Spr_Var2/1 -= 1
	LDA Spr_Var2+$00,X
	SUB #$01
	STA Spr_Var2+$00,X
	LDA Spr_Var1+$00,X
	SBC #$00
	STA Spr_Var1+$00,X
	BPL PRG059_B94D	; If not zero, jump to PRG059_B94D (RTS)

	; Spr_Var1/2 = $22C (16-bit counter)
	LDA #$02
	STA Spr_Var1+$00,X
	LDA #$2C
	STA Spr_Var2+$00,X
	
	JSR PRG063_FindFreeSlotMinIdx7
	BCS PRG059_B94D	; $B8EC

	LDA #SPRSLOTID_TOGEHERO
	STA Spr_SlotID+$00,Y
	
	LDA #(SPRFL2_HURTPLAYER | SPRFL2_SHOOTABLE | $11)
	STA Spr_Flags2+$00,Y
	
	; HP = 1
	LDA #$01
	STA Spr_HP+$00,Y
	
	LDA #SPRANM1_TOGEHERO
	JSR PRG063_CopySprSlotSetAnim

	; Togehero spawns at Player's height
	LDA Spr_Y+$00
	STA Spr_Y+$00,Y
	
	LDA #$80
	STA Spr_XVelFrac+$00,Y
	STA Spr_YVelFrac+$00,Y
	LDA #$00
	STA Spr_XVel+$00,Y
	STA Spr_YVel+$00,Y
	
	; Spr_Var1 = $1E
	LDA #$1E
	STA Spr_Var1+$00,Y
	
	LDA Spr_SlotID+$00,X
	AND #$01
	BEQ PRG059_B939	; If this is the "left" spawner, jump to PRG059_B939

	; "Right" spawner

	LDA #(SPRDIR_LEFT | SPRDIR_UP)
	STA Spr_FaceDir+$00,Y
	
	LDA <Horz_Scroll
	ADD #$F8
	STA Spr_X+$00,Y
	LDA <Current_Screen
	ADC #$00
	STA Spr_XHi+$00,Y
	
	RTS	; $B938


PRG059_B939:
	; "Left" spawner
	
	LDA #(SPRDIR_RIGHT | SPRDIR_UP)
	STA Spr_FaceDir+$00,Y
	
	LDA <Horz_Scroll
	ADD #$08
	STA Spr_X+$00,Y
	LDA <Current_Screen
	ADC #$00
	STA Spr_XHi+$00,Y

PRG059_B94D:
	RTS	; $B94D


PRG059_Obj_Togehero:
	JSR PRG063_ApplyVelSetFaceDir
	JSR PRG063_DoMoveVertOnlyH16

	DEC Spr_Var1+$00,X
	BNE PRG059_B94D	; If Spr_Var1 > 0, jump to PRG059_B94D (RTS)

	INC Spr_Var2+$00,X	; Spr_Var2++
	
	LDA Spr_Var2+$00,X
	AND #$03
	TAY	; Y = 0 to 3
	
	LDA Spr_FaceDir+$00,X
	AND #(SPRDIR_LEFT | SPRDIR_RIGHT)
	ORA PRG059_Togehero_FlyDir,Y
	STA Spr_FaceDir+$00,X
	
	; Spr_Var1 = $1E
	LDA #$1E
	STA Spr_Var1+$00,X
	
	RTS	; $B972


PRG059_Togehero_FlyDir:
	.byte SPRDIR_UP, SPRDIR_DOWN, SPRDIR_DOWN, SPRDIR_UP


PRG059_Obj_SpikeBlock:
	LDA Spr_Frame+$00,X
	BEQ PRG059_B997	; If frame = 0, jump to PRG059_B997

	CMP #$08
	BNE PRG059_B9CD	; If frame <> 8, jump to PRG059_B9CD

	INC Spr_CurrentAnim+$00,X	; Spr_CurrentAnim++
	
	LDA #$00
	STA Spr_AnimTicks+$00,X
	STA Spr_Frame+$00,X
	
	LDA #LOW(PRG059_Obj_SpikeBlock_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_SpikeBlock_Cont)
	STA Spr_CodePtrH+$00,X
	
	BNE PRG059_B9CD	; Jump (technically always) to PRG059_B9CD


PRG059_B997:
	LDA Spr_Var1+$00,X
	BNE PRG059_B9A1	; If Spr_Var1 > 0, jump to PRG059_B9A1

	; Spr_Var1 = $5A
	LDA #$5A
	STA Spr_Var1+$00,X

PRG059_B9A1:
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_B9CD	; If Spr_Var1 > 0, jump to PRG059_B9CD

	INC Spr_Frame+$00,X	; frame++
	
	JMP PRG059_B9CD	; Jump to PRG059_B9CD


PRG059_Obj_SpikeBlock_Cont:
	LDA Spr_Frame+$00,X
	BEQ PRG059_B9CD	; If frame = 0, jump to PRG059_B9CD

	LDA #LOW(PRG059_Obj_SpikeBlock)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_SpikeBlock)
	STA Spr_CodePtrH+$00,X
	
	INC Spr_CurrentAnim+$00,X	; Spr_CurrentAnim++
	
	LDA Spr_CurrentAnim+$00,X
	AND #$03
	ORA #SPRANM2_SPIKEBLOCK_UDLF
	JSR PRG063_SetSpriteAnim


PRG059_B9CD:
	LDA <Player_State
	CMP #PLAYERSTATE_HURT
	BGE PRG059_B9EA	; If Player is already hurt or worse, jump to PRG059_B9EA

	LDA <Player_PlayerHitInv
	BNE PRG059_B9EA	; If Player is flashing invincible, jump to PRG059_B9EA

	LDY Spr_CurrentAnim+$00,X	; Y = Spr_CurrentAnim
	
	LDA PRG059_SpikeBlock_Flags2-SPRANM2_SPIKEBLOCK_UDLF,Y
	BEQ PRG059_B9EA	; If value = 0 (can't hurt Player in this animation), jump to PRG059_B9EA

	STA Spr_Flags2+$00,X
	
	JSR PRG063_TestPlayerObjCollide
	BCS PRG059_B9EA	; If Player is not colliding, jump to PRG059_B9EA

	JSR PRG058_PlayerDoHurt

PRG059_B9EA:
	LDA #$00
	STA Spr_Flags2+$00,X
	RTS	; $B9EF

PRG059_SpikeBlock_Flags2:
	.byte (SPRFL2_HURTPLAYER | $38), $00, (SPRFL2_HURTPLAYER | $39), $00


PRG059_Obj_JumpBig:
	JSR PRG063_SetObjFacePlayer
	JSR PRG063_SetObjFlipForFaceDir

	; Hold animation
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	LDA Spr_Var1+$00,X
	BNE PRG059_BA09	; If Spr_Var1 > 0, jump to PRG059_BA09

	; Spr_Var1 = $1F
	LDA #$1F
	STA Spr_Var1+$00,X

PRG059_BA09:
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_BA4A	; If Spr_Var1 > 0, jump to PRG059_BA4A (RTS)

	LDY #$00	; Y = 0
	
	LDA <RandomN+$01
	ADC <RandomN+$03
	
	AND #$01
	BEQ PRG059_BA25	; 1:2 jump to PRG059_BA25

	LDY #$02	; Y = 2
	JSR PRG063_CalcObjXDiffFromPlayer

PRG059_BA1D:
	CMP PRG059_JumpbigPlayerXDiffLimit,Y
	BGE PRG059_BA25	; If Player is within this limit, jump to PRG059_BA25

	DEY	; Y--
	BNE PRG059_BA1D	; If Y <> 0, jump to PRG059_BA1D


PRG059_BA25:
	
	; Jumpbig's vertical speed
	LDA PRG059_Jumpbig_YVelFrac,Y
	STA Spr_YVelFrac+$00,X
	LDA PRG059_Jumpbig_YVel,Y
	STA Spr_YVel+$00,X

	; Jumpbig's horizontal speed
	LDA PRG059_Jumpbig_XVelFrac,Y
	STA Spr_XVelFrac+$00,X
	LDA PRG059_Jumpbig_XVel,Y
	STA Spr_XVel+$00,X
	
	LDA #LOW(PRG059_Obj_JumpBig_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_JumpBig_Cont)
	STA Spr_CodePtrH+$00,X
	
	INC Spr_Frame+$00,X	; frame++

PRG059_BA4A:
	RTS	; $BA4A


PRG059_Obj_JumpBig_Cont:
	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM1_JUMPBIG_INAIR
	BEQ PRG059_BA6D	; If Jumpbig landed, jump to PRG059_BA6D

	LDA Spr_Frame+$00,X
	CMP #$02
	BNE PRG059_BA4A	; If frame <> 2, jump to PRG059_BA4A (RTS)

	LDA #LOW(PRG059_Obj_JumpBig)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_JumpBig)
	STA Spr_CodePtrH+$00,X
	
	; Spr_Var1 = $3D
	LDA #$3D
	STA Spr_Var1+$00,X
	
	LDA #SPRANM1_JUMPBIG_INAIR
	JMP PRG063_SetSpriteAnim


PRG059_BA6D:
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	LDY #$32
	JSR PRG063_DoObjVertMovement
	BCC PRG059_BA7E	; If haven't hit solid, jump to PRG059_BA7E

	LDA #SPRANM1_JUMPBIG_LANDED
	JMP PRG063_SetSpriteAnim


PRG059_BA7E:
	LDY #$3C
	JMP PRG063_DoObjMoveSetFaceDir


PRG059_JumpbigPlayerXDiffLimit:
	.byte $18, $20, $30

PRG059_Jumpbig_XVelFrac:
	.byte $0F, $E4, $39
	
PRG059_Jumpbig_XVel:
	.byte $01, $00, $01
	
PRG059_Jumpbig_YVelFrac:
	.byte $D4, $78, $E5

PRG059_Jumpbig_YVel:
	.byte $02, $04, $04


PRG059_Obj_LadderPressR:
PRG059_Obj_LadderPressL:
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	LDA Spr_Var1+$00,X
	BNE PRG059_BAA1	; If Spr_Var1 > 0, jump to PRG059_BAA1

	; Spr_Var1 = $1E
	LDA #$1E
	STA Spr_Var1+$00,X

PRG059_BAA1:
	DEC Spr_Var1+$00,X	; Spr_Var1--
	BNE PRG059_BA4A	; If Spr_Var1 > 0, jump to PRG059_BA4A (RTS)

	LDY #SPRDIR_UP
	
	LDA Spr_Y+$00,X
	CMP Spr_Y+$00	
	BGE PRG059_BAB2	; If Player is above, jump to PRG059_BAB2

	LDY #SPRDIR_DOWN

PRG059_BAB2:
	; Set Ladder Press direction
	TYA
	STA Spr_FaceDir+$00,X
	
	LDA #$CC
	STA Spr_YVelFrac+$00,X
	LDA #$00
	STA Spr_YVel+$00,X
	
	INC Spr_Var3+$00,X	; Spr_Var3++
	
	LDA Spr_Var3+$00,X
	AND #$03
	TAY	; Y = 0 to 3
	
	LDA PRG059_LadderPress_Var2,Y
	STA Spr_Var2+$00,X
	
	LDA #LOW(PRG059_LadderPress_Cont)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_LadderPress_Cont)
	STA Spr_CodePtrH+$00,X
	
PRG059_LadderPress_Cont:
	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	LDA Spr_SlotID+$00,X
	AND #$01	; Right-side press sets bit 1
	ASL A		; 0 if left Ladder Press, 2 if right
	
	ADD #$34	; $34 or $36
	TAY	; -> 'Y'
	JSR PRG063_DoMoveVertOnly

	LDA <Temp_Var16
	CMP #TILEATTR_LADDER
	BEQ PRG059_BAF5	; If ladder detected, jump to PRG059_BAF5

	CMP #TILEATTR_LADDERTOP
	BNE PRG059_BB00	; If this isn't the top of the ladder, jump to PRG059_BB00

PRG059_BAF5:
	LDA Spr_Y+$00,X
	CMP #$08
	BLT PRG059_BB00	; If Ladder Press is too high, jump to PRG059_BB00

	CMP #$E8
	BLT PRG059_BB08	; If Ladder Press isn't too low, jump to PRG059_BB08


PRG059_BB00:
	; Reverse direction
	LDA Spr_FaceDir+$00,X
	EOR #(SPRDIR_UP | SPRDIR_DOWN)
	STA Spr_FaceDir+$00,X

PRG059_BB08:
	DEC Spr_Var2+$00,X	; Spr_Var2--
	BNE PRG059_BB1F		; If Spr_Var2 > 0, jump to PRG059_BB1F (RTS)

	LDA #LOW(PRG059_LadderPress_Shut)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_LadderPress_Shut)
	STA Spr_CodePtrH+$00,X
	
	INC Spr_Frame+$00,X		; frame++
	
	LDA Spr_SlotID+$00,X
	BNE PRG059_BB52	; Jump (technically always) to PRG059_BB52


PRG059_BB1F:
	RTS	; $BB1F


PRG059_LadderPress_Shut:
	LDA Spr_Var2+$00,X
	BEQ PRG059_BB32	; If Spr_Var2 = 0, jump to PRG059_BB32

	LDA #$00
	STA Spr_AnimTicks+$00,X
	
	DEC Spr_Var2+$00,X	; Spr_Var2--
	BNE PRG059_BB1F	; If Spr_Var2 > 0, jump to PRG059_BB1F (RTS)

	INC Spr_Frame+$00,X	; frame++

PRG059_BB32:
	LDA Spr_Frame+$00,X
	CMP #$06
	BEQ PRG059_BB60	; If frame = 6, jump to PRG059_BB60

	CMP #$09
	BNE PRG059_BB1F	; If frame <> 9, jump to PRG059_BB1F

	LDA #LOW(PRG059_Obj_LadderPressL)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_LadderPressL)
	STA Spr_CodePtrH+$00,X
	
	LDA #$00
	STA Spr_Frame+$00,X
	STA Spr_AnimTicks+$00,X
	
	LDA Spr_CurrentAnim+$00,X
PRG059_BB52:
	AND #$01
	TAY
	
	; Ladder Press X shift
	LDA Spr_X+$00,X
	ADD PRG059_LadderPress_XOff,Y
	STA Spr_X+$00,X
	
	RTS	; $BB5F


PRG059_BB60:
	
	; Spr_Var2 = $3C
	LDA #$3C
	STA Spr_Var2+$00,X
	
	RTS	; $BB65


PRG059_LadderPress_Var2:
	.byte $3C, $5A, $5A, $3C

PRG059_LadderPress_XOff:
	.byte $04, $FC


PRG059_Obj_EnemyExplode:
	LDA Spr_Frame+$00,X
	CMP #$04
	BNE PRG059_BBC2	; If frame <> 4, jump to PRG059_BBC2 (RTS)

	LDA HUDBarB_DispSetting
	BMI PRG059_BB9B	; If boss energy meter is active, jump to PRG059_BB9B

	; Temp_Var0 randomized
	LDA <RandomN+$02
	ADC <RandomN+$03
	SBC <General_Counter
	STA <RandomN+$02
	SBC <RandomN+$01
	ADC <Frame_Counter
	STA <RandomN+$03
	STA <Temp_Var0
	
	; Temp_Var1 = $32
	LDA #$32
	STA <Temp_Var1
	JSR PRG063_FC14	; $BB8C

	LDY #$04	; Y = 4
	
	LDA <Temp_Var3
PRG059_BB93:
	CMP PRG059_EnemyExpl_DropWeight,Y
	BLT PRG059_BB9E	; $BB96

	DEY	; Y--
	BPL PRG059_BB93	; While Y >= 0, loop


PRG059_BB9B:
	JMP PRG062_ResetSpriteSlot


PRG059_BB9E:
	LDA PRG059_EnemyExpl_ItemDropAnim,Y
	JSR PRG063_SetSpriteAnim

	LDA PRG059_EnemyExpl_Flags2,Y
	STA Spr_Flags2+$00,X
	
	LDA PRG059_EnExpl_BBoxSel,Y
	STA Spr_Var1+$00,X
	
	; Spr_Var2 = $FF
	LDA #$FF
	STA Spr_Var2+$00,X
	
	JSR PRG063_SetObjYVelToMinus1

	LDA #LOW(PRG059_Obj_EnExpl_ItemDrop)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_EnExpl_ItemDrop)
	STA Spr_CodePtrH+$00,X

PRG059_BBC2:
	RTS	; $BBC2


PRG059_Obj_EnExpl_ItemDrop:
	LDY Spr_Var1+$00,X	; Y = Spr_Var1
	
	JSR PRG063_DoObjVertMovement
	JSR PRG063_TestPlayerObjCollide

	BCC PRG059_DoNormalItemPickup	; If Player collided, jump to PRG059_DoNormalItemPickup

	LDA Spr_Var2+$00,X
	CMP #$3C
	BGE PRG059_BBD8	; If Spr_Var2 >= $3C, jump to PRG059_BBD8

	; Disappearing item drop!!
	STA Spr_FlashOrPauseCnt,X

PRG059_BBD8:
	DEC Spr_Var2+$00,X	; Spr_Var2--
	BEQ PRG059_BC41	; If Spr_Var2 = 0, jump to PRG059_BC41

	RTS	; $BBDD


PRG059_DoNormalItemPickup:
	; Player collided
	JSR PRG062_ResetSpriteSlot

	LDY Spr_CurrentAnim+$00,X	; Y = current anim
	
	LDA PRG059_ItemPickup_CodePtrL-$1A,Y
	STA <Temp_Var0	
	LDA PRG059_ItemPickup_CodePtrH-$1A,Y
	STA <Temp_Var1
	
	JMP [Temp_Var0]


PRG059_EnExpl_1UpPickup:
	; Play 1-up sound
	LDA #SFX_1UP
	JSR PRG063_QueueMusSnd

	LDA <Player_Lives
	CMP #$09
	BEQ PRG059_BC41	; If Player's lives are already maxed out, jump to PRG059_BC41 (delete pickup)

	INC <Player_Lives	; Extra life!
	
	JMP PRG059_BC41	; Jump to PRG059_BC41 (delete pickup)


PRG059_EnExpl_ETank:
	; Play 1-up (Energy Tank) sound
	LDA #SFX_1UP
	JSR PRG063_QueueMusSnd

	LDA <Player_EnergyTanks
	CMP #$09
	BEQ PRG059_BC41	; If Player's energy tanks are already maxed out, jump to PRG059_BC41 (delete pickup)

	INC <Player_EnergyTanks	; Additional energy tank!
	
	JMP PRG059_BC41	; Jump to PRG059_BC41 (delete pickup)


PRG059_EnExpl_Health:
	LDX #$00		; X = 0 (index 0 of Player_HP, i.e. Player's health)
	BEQ PRG059_BC19	; Jump (technically always) to PRG059_BC19

PRG059_EnExpl_Weapon:
	LDX <Player_CurWeapon	; $BC15
	BEQ PRG059_BC3B	; $BC17


PRG059_BC19:
	LDA PRG059_ItemPickup_ChrgAmt-$1A,Y
	STA <Player_EnergyGainCounter	; Charge amount -> Player_EnergyGainCounter

PRG059_BC1E:
	LDA <Player_HP,X
	CMP #$9C
	BEQ PRG059_BC3B	; If Player's HP is already maxed out, jump to PRG059_BC3B

	INC <Player_HP,X	; Player's HP +1
	
	; Backup Player_HP offset
	TXA
	PHA
	
	; Draw sprites
	JSR PRG063_DrawSprites_RsetSprIdx

	; Energy gain sound
	LDA #SFX_ENERGYGAIN
	JSR PRG063_QueueMusSnd

	; Delay frames
	LDX #$03
	JSR PRG063_UpdateMultipleFrames

	; Restore Player_HP offset
	PLA
	TAX
	
	DEC <Player_EnergyGainCounter	; Player_EnergyGainCounter--
	BNE PRG059_BC1E	; While Player_EnergyGainCounter > 0, loop!


PRG059_BC3B:
	; Player_EnergyGainCounter = 0
	LDA #$00
	STA <Player_EnergyGainCounter
	
	LDX <SprObj_SlotIndex	; Restore object slot index

PRG059_BC41:
	JMP PRG062_ResetSpriteSlot	; Erase item pickup


PRG059_Obj_ItemBonusWeapons:
	LDA <Player_State
	CMP #PLAYERSTATE_RUSHMARINE
	BEQ PRG059_BC79	; If Player is in Rush Marine, jump to PRG059_BC79 (RTS)

PRG059_Obj_PlayerItems:
	JSR PRG063_TestPlayerObjCollide
	BCS PRG059_BC79	; If Player isn't touching item pickup, jump to PRG059_BC79 (RTS)

	LDA Spr_SlotID+$00,X
	CMP #SPRSLOTID_SPECWPN_PICKUP
	BEQ PRG059_BC59	; If this the Balloon Weapon pickup, jump to PRG059_BC59

	JSR PRG063_MarkNeverRespawn	; Jump to PRG063_MarkNeverRespawn


PRG059_BC59:
	JSR PRG062_ResetSpriteSlot	; Erase item pickup

	LDY Spr_CurrentAnim+$00,X
	CPY #SPRANM2_ITEM_WIREADAPTER
	BGE PRG059_BC66	; If this is a Wire Adapter or Balloon, jump to PRG059_BC66

	JMP PRG059_DoNormalItemPickup	; Jump to PRG059_DoNormalItemPickup


PRG059_BC66:
	LDA #($80 | $1C)	; Max energy, weapon obtained
	STA (Player_HP + 5) - SPRANM2_ITEM_WIREADAPTER,Y
	
	; Weapon pickup!
	LDA #MUS_SPECIALITEMGET
	JSR PRG063_QueueMusSnd_SetMus_Cur

	LDA #$FF
	STA Level_EndLevel_Timeout
	
	LDA #PLAYERSTATE_GOTSPWEAPON
	STA <Player_State

PRG059_BC79:
	RTS	; $BC79


PRG059_Obj_ItemWithGrav:
	LDY #$18
	JSR PRG063_DoObjVertMovement

	BCC PRG059_Obj_PlayerItems	; If haven't hit solid, jump to PRG059_Obj_PlayerItems

	; Basically once item hits solid it won't even try to move anymore
	LDA #LOW(PRG059_Obj_PlayerItems)
	STA Spr_CodePtrL+$00,X
	LDA #HIGH(PRG059_Obj_PlayerItems)
	STA Spr_CodePtrH+$00,X

	BNE PRG059_Obj_PlayerItems	; Jump (technically always) to PRG059_Obj_PlayerItems


PRG059_EnemyExpl_DropWeight:
	.byte $0E	; Drop 0 (small weapon)
	.byte $0A	; Drop 1 (large health)
	.byte $08	; Drop 2 (small health)
	.byte $03	; Drop 3 (1-up)
	.byte $02	; Drop 4 (large weapon)

PRG059_EnemyExpl_ItemDropAnim:
	.byte SPRANM4_ITEM_SMALLWEAPON	; Drop 0 (small weapon)
	.byte SPRANM4_ITEM_LARGEHEALTH	; Drop 1 (large health)
	.byte SPRANM4_ITEM_SMALLHEALTH	; Drop 2 (small health)
	.byte SPRANM4_ITEM_1UP			; Drop 3 (1-up)
	.byte SPRANM4_ITEM_LARGEWEAPON	; Drop 4 (large weapon)
	
PRG059_EnemyExpl_Flags2:
	.byte $00	; Drop 0 (small weapon)
	.byte $00	; Drop 1 (large health)
	.byte $00	; Drop 2 (small health)
	.byte $00	; Drop 3 (1-up)
	.byte $00	; Drop 4 (large weapon)
	
PRG059_EnExpl_BBoxSel:
	.byte $14	; Drop 0 (small weapon)
	.byte $2D	; Drop 1 (large health)
	.byte $14	; Drop 2 (small health)
	.byte $2D	; Drop 3 (1-up)
	.byte $2D	; Drop 4 (large weapon)
	
PRG059_ItemPickup_ChrgAmt:
	.byte $0A	; SPRANM4_ITEM_LARGEHEALTH
	.byte $02	; SPRANM4_ITEM_SMALLHEALTH
	.byte $0A	; SPRANM4_ITEM_LARGEWEAPON
	.byte $02	; SPRANM4_ITEM_SMALLWEAPON
	.byte $00	; SPRANM4_ITEM_1UP (??)

PRG059_ItemPickup_CodePtrL:
	.byte LOW(PRG059_EnExpl_Health)			; SPRANM4_ITEM_LARGEHEALTH
	.byte LOW(PRG059_EnExpl_Health)			; SPRANM4_ITEM_SMALLHEALTH
	.byte LOW(PRG059_EnExpl_Weapon)			; SPRANM4_ITEM_LARGEWEAPON
	.byte LOW(PRG059_EnExpl_Weapon)			; SPRANM4_ITEM_SMALLWEAPON
	.byte LOW(PRG059_EnExpl_1UpPickup)		; SPRANM4_ITEM_1UP
	.byte LOW(PRG059_EnExpl_ETank)			; SPRANM4_ITEM_ENERGYTANK
	
PRG059_ItemPickup_CodePtrH:
	.byte HIGH(PRG059_EnExpl_Health)		; SPRANM4_ITEM_LARGEHEALTH
	.byte HIGH(PRG059_EnExpl_Health)		; SPRANM4_ITEM_SMALLHEALTH
	.byte HIGH(PRG059_EnExpl_Weapon)		; SPRANM4_ITEM_LARGEWEAPON
	.byte HIGH(PRG059_EnExpl_Weapon)		; SPRANM4_ITEM_SMALLWEAPON
	.byte HIGH(PRG059_EnExpl_1UpPickup)		; SPRANM4_ITEM_1UP
	.byte HIGH(PRG059_EnExpl_ETank)			; SPRANM4_ITEM_ENERGYTANK


	; CHECKME - UNUSED?
	.byte $01, $01, $02, $00, $05, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BCB2 - $BCC1
	.byte $00, $05, $90, $40, $60, $15, $02, $00, $80, $00, $00, $00, $00, $10, $00, $00	; $BCC2 - $BCD1
	.byte $00, $00, $80, $11, $00, $00, $05, $00, $00, $01, $10, $10, $40, $00, $04, $00	; $BCD2 - $BCE1
	.byte $40, $05, $C0, $04, $43, $00, $10, $04, $80, $40, $08, $14, $14, $10, $82, $04	; $BCE2 - $BCF1
	.byte $00, $00, $00, $00, $0A, $00, $00, $00, $40, $05, $00, $00, $04, $00, $00, $00	; $BCF2 - $BD01
	.byte $20, $11, $28, $40, $00, $40, $00, $00, $00, $00, $00, $41, $00, $00, $00, $00	; $BD02 - $BD11
	.byte $00, $00, $90, $00, $00, $00, $20, $00, $00, $00, $00, $04, $00, $04, $00, $00	; $BD12 - $BD21
	.byte $10, $01, $02, $00, $3A, $00, $00, $00, $08, $00, $04, $00, $12, $00, $02, $00	; $BD22 - $BD31
	.byte $C5, $04, $20, $00, $08, $44, $88, $00, $40, $01, $00, $00, $40, $00, $50, $00	; $BD32 - $BD41
	.byte $08, $00, $60, $05, $22, $10, $00, $10, $01, $04, $01, $00, $20, $00, $00, $00	; $BD42 - $BD51
	.byte $01, $00, $09, $00, $80, $01, $00, $00, $04, $00, $00, $00, $00, $00, $B1, $14	; $BD52 - $BD61
	.byte $00, $40, $02, $04, $00, $50, $01, $01, $04, $04, $1C, $40, $08, $00, $00, $00	; $BD62 - $BD71
	.byte $04, $00, $20, $00, $83, $04, $30, $10, $61, $00, $00, $00, $08, $01, $0D, $80	; $BD72 - $BD81
	.byte $00, $50, $00, $00, $00, $00, $10, $00, $00, $04, $02, $00, $41, $00, $02, $01	; $BD82 - $BD91
	.byte $00, $40, $00, $00, $10, $00, $81, $00, $01, $10, $00, $00, $40, $00, $02, $00	; $BD92 - $BDA1
	.byte $80, $44, $40, $00, $84, $40, $80, $00, $48, $40, $81, $05, $29, $00, $00, $10	; $BDA2 - $BDB1
	.byte $40, $00, $27, $44, $20, $00, $04, $00, $48, $00, $10, $00, $40, $01, $08, $01	; $BDB2 - $BDC1
	.byte $08, $10, $20, $00, $29, $01, $8A, $00, $21, $10, $61, $00, $50, $00, $80, $01	; $BDC2 - $BDD1
	.byte $00, $04, $58, $01, $00, $40, $82, $01, $00, $04, $01, $01, $01, $00, $07, $00	; $BDD2 - $BDE1
	.byte $54, $05, $21, $14, $06, $14, $29, $00, $10, $00, $00, $10, $10, $00, $44, $00	; $BDE2 - $BDF1
	.byte $21, $00, $02, $41, $11, $00, $01, $00, $20, $00, $00, $10, $01, $10, $00, $40	; $BDF2 - $BE01
	.byte $01, $00, $80, $00, $00, $00, $80, $04, $04, $00, $00, $00, $09, $00, $02, $00	; $BE02 - $BE11
	.byte $80, $00, $20, $00, $00, $01, $0A, $14, $48, $00, $00, $00, $00, $00, $A1, $17	; $BE12 - $BE21
	.byte $33, $11, $90, $10, $40, $00, $84, $01, $04, $44, $44, $10, $00, $10, $91, $04	; $BE22 - $BE31
	.byte $80, $01, $40, $00, $00, $40, $00, $00, $10, $00, $20, $00, $00, $00, $54, $05	; $BE32 - $BE41
	.byte $02, $00, $04, $00, $09, $00, $24, $40, $00, $50, $21, $00, $70, $00, $34, $00	; $BE42 - $BE51
	.byte $00, $04, $00, $41, $04, $40, $10, $04, $28, $00, $40, $00, $C0, $10, $10, $00	; $BE52 - $BE61
	.byte $21, $00, $00, $00, $20, $00, $24, $40, $20, $04, $41, $00, $50, $00, $00, $10	; $BE62 - $BE71
	.byte $02, $00, $20, $00, $08, $10, $00, $00, $20, $00, $02, $10, $08, $04, $00, $00	; $BE72 - $BE81
	.byte $40, $00, $04, $41, $00, $41, $00, $00, $11, $00, $00, $01, $00, $01, $00, $10	; $BE82 - $BE91
	.byte $60, $01, $00, $10, $00, $00, $80, $02, $40, $00, $20, $00, $40, $00, $48, $00	; $BE92 - $BEA1
	.byte $04, $00, $30, $11, $80, $04, $00, $00, $A4, $10, $C0, $41, $04, $04, $82, $02	; $BEA2 - $BEB1
	.byte $05, $01, $28, $40, $00, $04, $08, $00, $94, $00, $00, $00, $00, $00, $48, $01	; $BEB2 - $BEC1
	.byte $62, $40, $E0, $04, $A0, $10, $20, $00, $80, $04, $08, $00, $40, $50, $00, $00	; $BEC2 - $BED1
	.byte $80, $00, $18, $00, $00, $00, $20, $10, $10, $00, $00, $00, $44, $00, $10, $50	; $BED2 - $BEE1
	.byte $00, $00, $81, $40, $A2, $01, $50, $00, $90, $00, $04, $00, $00, $40, $89, $40	; $BEE2 - $BEF1
	.byte $10, $00, $40, $00, $04, $00, $22, $04, $00, $00, $00, $00, $C0, $11, $80, $01	; $BEF2 - $BF01
	.byte $08, $00, $08, $00, $60, $01, $04, $00, $00, $00, $00, $00, $04, $00, $00, $00	; $BF02 - $BF11
	.byte $00, $00, $00, $00, $00, $00, $20, $00, $00, $00, $80, $00, $00, $00, $01, $14	; $BF12 - $BF21
	.byte $03, $00, $1A, $00, $00, $01, $00, $40, $00, $00, $00, $00, $00, $00, $00, $01	; $BF22 - $BF31
	.byte $05, $04, $00, $00, $00, $10, $06, $11, $10, $00, $02, $00, $02, $01, $00, $00	; $BF32 - $BF41
	.byte $44, $00, $A4, $04, $00, $00, $00, $04, $00, $01, $18, $00, $8D, $00, $00, $00	; $BF42 - $BF51
	.byte $00, $10, $00, $00, $00, $40, $00, $00, $00, $00, $10, $04, $00, $00, $0C, $04	; $BF52 - $BF61
	.byte $20, $04, $00, $00, $22, $40, $0A, $40, $00, $01, $11, $10, $04, $00, $90, $00	; $BF62 - $BF71
	.byte $45, $04, $82, $00, $00, $00, $00, $01, $0A, $00, $00, $00, $46, $01, $00, $01	; $BF72 - $BF81
	.byte $08, $04, $08, $00, $01, $00, $44, $10, $01, $10, $00, $04, $00, $00, $01, $41	; $BF82 - $BF91
	.byte $01, $10, $00, $00, $00, $00, $00, $00, $01, $00, $10, $00, $00, $01, $C0, $10	; $BF92 - $BFA1
	.byte $10, $05, $08, $01, $84, $41, $08, $00, $00, $10, $01, $00, $21, $01, $00, $04	; $BFA2 - $BFB1
	.byte $85, $00, $00, $00, $10, $00, $00, $04, $29, $00, $40, $00, $01, $00, $62, $00	; $BFB2 - $BFC1
	.byte $20, $00, $04, $44, $06, $00, $00, $10, $00, $10, $08, $40, $20, $01, $08, $00	; $BFC2 - $BFD1
	.byte $01, $04, $00, $01, $2B, $05, $00, $00, $40, $00, $20, $10, $0C, $01, $00, $10	; $BFD2 - $BFE1
	.byte $48, $04, $49, $40, $20, $05, $20, $04, $02, $00, $40, $00, $11, $00, $4E, $44	; $BFE2 - $BFF1
	.byte $01, $40, $24, $00, $05, $00, $20, $00, $00, $00, $40, $00, $0B, $FF	; $BFF2 - $BFFF


