	; Standard tilemap data; see format.txt in TMAPDATA for what this is comprised of.
	.incbin "PRG/TMAPDATA/TMAP00.bin"
	
	; Player Weapon Damage table for Rush Coil
	.org Player_WeaponDamageTable	; <-- help enforce this table *here*
PRG032_MegaBusterDamageTable:
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
	.byte $01	; $10 SPRSLOTID_TAKETETNO
	.byte $01	; $11 SPRSLOTID_TAKETETNO_PROP
	.byte $00	; $12 SPRSLOTID_HOVER
	.byte $01	; $13 SPRSLOTID_TOMBOY
	.byte $01	; $14 SPRSLOTID_SASOREENU
	.byte $00	; $15 SPRSLOTID_SASOREENU_SPAWNER
	.byte $00	; $16 SPRSLOTID_BATTAN
	.byte $00	; $17
	.byte $01	; $18 SPRSLOTID_SWALLOWN
	.byte $01	; $19 SPRSLOTID_COSWALLOWN
	.byte $01	; $1A SPRSLOTID_WALLBLASTER
	.byte $00	; $1B SPRSLOTID_WALLBLASTER_SHOT
	.byte $01	; $1C SPRSLOTID_100WATTON
	.byte $01	; $1D SPRSLOTID_100WATTON_SHOT
	.byte $00	; $1E SPRSLOTID_100WATTON_SHOT_BURST
	.byte $01	; $1F SPRSLOTID_RATTON
	.byte $00	; $20 SPRSLOTID_RMRAINBOW_CTL1
	.byte $00	; $21 SPRSLOTID_RMRAINBOW_CTL2
	.byte $00	; $22 SPRSLOTID_RMRAINBOW_CTL3
	.byte $00	; $23 SPRSLOTID_RMRAINBOW_CTL4
	.byte $01	; $24 SPRSLOTID_SUBBOSS_KABATONCUE
	.byte $01	; $25 SPRSLOTID_KABATONCUE_MISSILE
	.byte $00	; $26 SPRSLOTID_RINGMAN_UNK2
	.byte $01	; $27 SPRSLOTID_WILY_ESCAPEPOD
	.byte $00	; $28 SPRSLOTID_BOMBABLE_WALL
	.byte $00	; $29 SPRSLOTID_MOTHRAYA_DIE
	.byte $00	; $2A SPRSLOTID_POWERGAIN_ORBS
	.byte $01	; $2B SPRSLOTID_SUBBOSS_ESCAROO
	.byte $01	; $2C SPRSLOTID_ESCAROO_BOMB
	.byte $00	; $2D SPRSLOTID_ESCAROO_DIE
	.byte $00	; $2E SPRSLOTID_EXPLODEYBIT
	.byte $00	; $2F SPRSLOTID_RED_UTRACK_PLAT
	.byte $01	; $30 SPRSLOTID_SUBBOSS_WHOPPER
	.byte $00	; $31 SPRSLOTID_SUBBOSS_WHOPPER_RING
	.byte $00	; $32 SPRSLOTID_SUBBOSS_WHOPPER_RIN2
	.byte $01	; $33 SPRSLOTID_HAEHAEY
	.byte $00	; $34 SPRSLOTID_HAEHAEY_SHOT
	.byte $01	; $35 SPRSLOTID_RACKASER
	.byte $01	; $36 SPRSLOTID_RACKASER_UMBRELLA
	.byte $01	; $37 SPRSLOTID_DOMPAN
	.byte $00	; $38 SPRSLOTID_DOMPAN_FIREWORKS
	.byte $00	; $39 SPRSLOTID_CIRCLEBULLET
	.byte $00	; $3A SPRSLOTID_WHOPPER_DIE
	.byte $00	; $3B SPRSLOTID_CIRCULAREXPLOSION
	.byte $00	; $3C SPRSLOTID_CEXPLOSION
	.byte $01	; $3D SPRSLOTID_MINOAN
	.byte $01	; $3E SPRSLOTID_SUPERBALLMACHJR_L
	.byte $01	; $3F SPRSLOTID_SUPERBALLMACHJR_B
	.byte $00	; $40 SPRSLOTID_BOULDER_DISPENSER
	.byte $01	; $41 SPRSLOTID_BOULDER_DEBRIS
	.byte $00	; $42 SPRSLOTID_EDDIE
	.byte $00	; $43 SPRSLOTID_EDDIE_IMMEDIATE
	.byte $00	; $44 SPRSLOTID_EDDIE_ITEM_EJECT
	.byte $01	; $45 SPRSLOTID_CRPLATFORM_FALL
	.byte $01	; $46 SPRSLOTID_JUMPBIG
	.byte $00	; $47
	.byte $01	; $48 SPRSLOTID_SHIELDATTACKER
	.byte $01	; $49 SPRSLOTID_COSSACK3BOSS1_DIE
	.byte $00	; $4A SPRSLOTID_COSSACK3BOSS2_DIE
	.byte $00	; $4B SPRSLOTID_KABATONCUE_DIE
	.byte $00	; $4C SPRSLOTID_100WATTON_DIE
	.byte $00	; $4D SPRSLOTID_WILYCAPSULE_CHRG
	.byte $01	; $4E SPRSLOTID_TOTEMPOLEN
	.byte $00	; $4F SPRSLOTID_TOTEMPOLEN_SHOT
	.byte $01	; $50 SPRSLOTID_METALL_1
	.byte $00	; $51 SPRSLOTID_METALL_BULLET
	.byte $01	; $52 SPRSLOTID_SUBBOSS_MOBY
	.byte $00	; $53 SPRSLOTID_MOBY_MISSILE
	.byte $00	; $54 SPRSLOTID_MOBY_BIGSPIKE
	.byte $00	; $55
	.byte $01	; $56 SPRSLOTID_METALL_2
	.byte $00	; $57
	.byte $00	; $58
	.byte $00	; $59
	.byte $00	; $5A
	.byte $00	; $5B SPRSLOTID_SWITCH
	.byte $01	; $5C SPRSLOTID_METALL_3
	.byte $00	; $5D SPRSLOTID_SINKINGPLATFORM
	.byte $00	; $5E SPRSLOTID_DUSTMAN_CRUSHERACT
	.byte $00	; $5F SPRSLOTID_M422A
	.byte $00	; $60 SPRSLOTID_CINESTUFF
	.byte $01	; $61 SPRSLOTID_PUYOYON
	.byte $01	; $62 SPRSLOTID_SKELETONJOE
	.byte $00	; $63 SPRSLOTID_SKELETONJOE_BONE
	.byte $01	; $64 SPRSLOTID_RINGRING
	.byte $01	; $65 SPRSLOTID_METALL_4
	.byte $00	; $66 SPRSLOTID_METALL_4_BUBBLE
	.byte $00	; $67 SPRSLOTID_WILY1_UNK1
	.byte $01	; $68 SPRSLOTID_UNK68
	.byte $01	; $69 SPRSLOTID_SKULLMET_R
	.byte $00	; $6A SPRSLOTID_SKULLMET_BULLET
	.byte $00	; $6B SPRSLOTID_DIVEMAN_BIDIW1
	.byte $00	; $6C SPRSLOTID_DIVEMAN_BIDIW2
	.byte $01	; $6D SPRSLOTID_HELIPON
	.byte $00	; $6E SPRSLOTID_HELIPON_BULLET
	.byte $00	; $6F SPRSLOTID_WATERSPLASH
	.byte $01	; $70 SPRSLOTID_GYOTOT
	.byte $01	; $71 SPRSLOTID_BOSSSKULL
	.byte $00	; $72 SPRSLOTID_SKULLMAN_BULLET
	.byte $00	; $73 SPRSLOTID_DUSTMAN_4PLAT
	.byte $00	; $74 SPRSLOTID_DUSTMAN_PLATSEG
	.byte $01	; $75 SPRSLOTID_BOSSRING
	.byte $00	; $76 SPRSLOTID_RINGMAN_RING
	.byte $00	; $77 SPRSLOTID_BOSSDEATH
	.byte $00	; $78 SPRSLOTID_BIREE1
	.byte $01	; $79 SPRSLOTID_BOSSDUST
	.byte $00	; $7A SPRSLOTID_DUSTMAN_DUSTCRUSHER
	.byte $00	; $7B SPRSLOTID_DUSTMAN_DUSTDEBRIS
	.byte $01	; $7C SPRSLOTID_BOSSDIVE
	.byte $01	; $7D SPRSLOTID_BOSSDIVE_MISSILE
	.byte $01	; $7E SPRSLOTID_BOSSDRILL
	.byte $00	; $7F SPRSLOTID_DRILLMAN_DRILL
	.byte $00	; $80 SPRSLOTID_MISCSTUFF
	.byte $01	; $81 SPRSLOTID_BOSSINTRO
	.byte $00	; $82 SPRSLOTID_DRILLMAN_POOF
	.byte $00	; $83 SPRSLOTID_SPIRALEXPLOSION
	.byte $01	; $84 SPRSLOTID_BOSSPHARAOH
	.byte $00	; $85 SPRSLOTID_PHARAOHMAN_ATTACK
	.byte $00	; $86 SPRSLOTID_PHARAOHMAN_SATTACK
	.byte $01	; $87 SPRSLOTID_BOSS_MOTHRAYA
	.byte $00	; $88 SPRSLOTID_COSSACK1_UNK1
	.byte $00	; $89 SPRSLOTID_COSSACK1_UNK2
	.byte $00	; $8A SPRSLOTID_MOTHRAYA_SHOT
	.byte $01	; $8B SPRSLOTID_BOSSBRIGHT
	.byte $00	; $8C SPRSLOTID_BOSSBRIGHT_BULLET
	.byte $01	; $8D SPRSLOTID_BOSSTOAD
	.byte $01	; $8E SPRSLOTID_BATTONTON
	.byte $00	; $8F SPRSLOTID_MOTHRAYA_DEBRIS
	.byte $00	; $90 SPRSLOTID_EXPLODEY_DEATH
	.byte $01	; $91 SPRSLOTID_MANTAN
	.byte $01	; $92 SPRSLOTID_BOSS_COSSACKCATCH
	.byte $00	; $93 SPRSLOTID_COSSACK4_UNK1
	.byte $00	; $94 SPRSLOTID_COSSACK4_BULLET
	.byte $01	; $95 SPRSLOTID_BOSS_SQUAREMACHINE
	.byte $00	; $96 SPRSLOTID_SQUAREMACH_PLATFORM
	.byte $00	; $97 SPRSLOTID_SQUAREMACHINE_SHOT
	.byte $01	; $98 SPRSLOTID_BOULDER
	.byte $00	; $99 SPRSLOTID_COSSACK2_UNK2
	.byte $01	; $9A SPRSLOTID_MUMMIRA
	.byte $00	; $9B SPRSLOTID_MUMMIRAHEAD
	.byte $01	; $9C SPRSLOTID_IMORM
	.byte $00	; $9D SPRSLOTID_ENEMYEXPLODE
	.byte $01	; $9E SPRSLOTID_COSSACK3BOSS1
	.byte $00	; $9F SPRSLOTID_COSSACK3BOSS2_SHOT
	.byte $00	; $A0 SPRSLOTID_COSSACK3BOSS1_SHOT
	.byte $01	; $A1 SPRSLOTID_MONOROADER
	.byte $01	; $A2 SPRSLOTID_COSSACK3BOSS2
	.byte $00	; $A3 SPRSLOTID_KALINKA
	.byte $00	; $A4 SPRSLOTID_PROTOMAN
	.byte $00	; $A5 SPRSLOTID_WILY
	.byte $01	; $A6 SPRSLOTID_BOSS_METALLDADDY
	.byte $01	; $A7 SPRSLOTID_GACHAPPON
	.byte $00	; $A8 SPRSLOTID_GACHAPPON_BULLET
	.byte $00	; $A9 SPRSLOTID_GACHAPPON_GASHAPON
	.byte $01	; $AA SPRSLOTID_METALLDADDY_METALL
	.byte $01	; $AB SPRSLOTID_BOSS_TAKOTRASH
	.byte $00	; $AC SPRSLOTID_WILY2_UNK1
	.byte $00	; $AD SPRSLOTID_TAKOTRASH_BALL
	.byte $00	; $AE SPRSLOTID_TAKOTRASH_FIREBALL
	.byte $00	; $AF SPRSLOTID_TAKOTRASH_PLATFORM
	.byte $01	; $B0 SPRSLOTID_PAKATTO24
	.byte $00	; $B1 SPRSLOTID_PAKATTO24_SHOT
	.byte $01	; $B2 SPRSLOTID_UPNDOWN
	.byte $00	; $B3 SPRSLOTID_WILYTRANSPORTER
	.byte $00	; $B4 SPRSLOTID_UPNDOWN_SPAWNER
	.byte $00	; $B5 SPRSLOTID_SPIKEBLOCK_1
	.byte $00	; $B6 SPRSLOTID_SEAMINE
	.byte $00	; $B7 SPRSLOTID_GARYOBY
	.byte $00	; $B8 SPRSLOTID_BOSS_ROBOTMASTER
	.byte $01	; $B9 SPRSLOTID_DOCRON
	.byte $01	; $BA SPRSLOTID_DOCRON_SKULL
	.byte $01	; $BB SPRSLOTID_WILY3_UNK1
	.byte $01	; $BC SPRSLOTID_BOSS_WILYMACHINE4
	.byte $00	; $BD SPRSLOTID_TOGEHERO_SPAWNER_R
	.byte $01	; $BE SPRSLOTID_TOGEHERO
	.byte $00	; $BF SPRSLOTID_WILYMACHINE4_SHOTCH
	.byte $01	; $C0 SPRSLOTID_WILYMACHINE4_PHASE2
	.byte $00	; $C1 SPRSLOTID_ITEM_PICKUP
	.byte $00	; $C2 SPRSLOTID_SPECWPN_PICKUP
	.byte $00	; $C3 SPRSLOTID_WILY1_DISPBLOCKS
	.byte $00	; $C4 SPRSLOTID_BOSS_WILYCAPSULE
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

	; UNUSED
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B7D0 - $B7DF
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B7E0 - $B7EF
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B7F0 - $B7FF


PRG032_B800:
	LDA Level_LightDarkCtl
	BNE PRG032_B828	; If a light/dark transition is occurring, don't do palette animation, jump to PRG032_B828 (RTS)

	; PalAnim_CurIndex = 3
	LDA #$03
	STA <PalAnim_CurIndex
	
	; This will set PalAnim_CommitCount = 1 if a commit is pending, relying on the usual
	; behavior that CommitPal_Flag is set to $FF by other commit routines (even though
	; technically that is not required)
	LDA <CommitPal_Flag
	AND #$01
	STA <PalAnim_CommitCount	; PalAnim_CommitCount = 0 (no commits pending before this) or 1 (a commit was already pending)
	
	; To avoid any potential race conditions of the NMI firing before palette animations are done,
	; the commit flag will be definitively cleared. PalAnim_CommitCount will be 1 if a commit was
	; pending (assuming standard practice of setting it to $FF elsewhere.)
	
	; Basically if at least one animation is actually executed, we need to commit the updates. If
	; no animations are actually active, PalAnim_CommitCount will not be adjusted. But since we
	; need to clear the commit flag to avoid the race condition, it will at least be 1 if a commit
	; was still needed regardless.
	
	; CommitPal_Flag = 0 (to avoid race condition)
	LDA #$00
	STA <CommitPal_Flag

PRG032_B813:
	LDX <PalAnim_CurIndex	; X = PalAnim_CurIndex
	
	LDA PalAnim_EnSel+$00,X
	BPL PRG032_B820	; If palette animation for this BG palette quadrant is not enabled, jump to PRG032_B820

	AND #~$80	; Bit 7 is just enable flag
	TAY	; index of animation -> 'Y'
	
	JSR PRG032_AnimatePalQuadrant

PRG032_B820:
	DEC <PalAnim_CurIndex	; PalAnim_CurIndex--
	BPL PRG032_B813	; While PalAnim_CurIndex >= 0, loop

	; Commit as needed!
	LDA <PalAnim_CommitCount
	STA <CommitPal_Flag

PRG032_B828:
	RTS	; $B828


PRG032_AnimatePalQuadrant:
	; X = PalAnim_CurIndex
	
	; Set pointer to the data for this palette animation
	LDA PRG032_PalAnim_Table_L,Y
	STA <PalAnim_PtrL
	LDA PRG032_PalAnim_Table_H,Y
	STA <PalAnim_PtrH
	
	LDY #$01	; Y = 1 (tick count limit offset)
	
	LDA PalAnim_TickCount+$00,X	; Current tick count for this palette animation
	
	INC PalAnim_TickCount+$00,X	; PalAnim_TickCount++
	
	CMP [PalAnim_PtrL],Y
	BNE PRG032_B828	; If tick count has not reached limit, jump to PRG032_B828 (RTS)

	; PalAnim_TickCount = 0
	LDA #$00
	STA PalAnim_TickCount+$00,X
	
	TAY	; Y = 0
	
	LDA PalAnim_CurAnimOffset+$00,X	; Fetch current offset into palette animation data
	
	INC PalAnim_CurAnimOffset+$00,X	; PalAnim_CurAnimOffset++ (next data byte)
	
	CMP [PalAnim_PtrL],Y
	BNE PRG032_B854	; If didn't hit last index of palette animation data, jump to PRG032_B854

	; Reset back to first index of palette animation
	LDA #$00
	STA PalAnim_CurAnimOffset+$00,X

PRG032_B854:
	LDA PalAnim_CurAnimOffset+$00,X
	ADD #$02	; Since first byte is max index, second byte is tick limit
	TAY			; Y = PalAnim_CurAnimOffset + 2
	
	LDA [PalAnim_PtrL],Y
	BNE PRG032_B865	; If palette animation data byte <> 0, jump to PRG032_B865

	; If palette anim data byte is zero, stop animation

	; Disable animation, PalAnim_EnSel = 0
	LDX <PalAnim_CurIndex
	STA PalAnim_EnSel+$00,X
	
	RTS	; $B864


PRG032_B865:
	; Palette animation byte
	STA <PalAnim_PtrL	; -> PalAnim_PtrL
	
	; PalAnim_PtrH = 0
	LDA #$00
	STA <PalAnim_PtrH
	
	LDA <PalAnim_PtrL
	ASL A	; Pal anim byte * 2
	ROL <PalAnim_PtrH	; Roll carry into PalAnim_PtrH
	ADD <PalAnim_PtrL	; + PalAnim_PtrL (x3)
	STA <PalAnim_PtrL	; PalAnim_PtrL = palette animation data * 3
	LDA <PalAnim_PtrH
	ADC #$00
	STA <PalAnim_PtrH
	
	; Compute offset within PRG032_PalAnim_PalData
	LDA #LOW(PRG032_PalAnim_PalData)
	ADD <PalAnim_PtrL
	STA <PalAnim_PtrL
	LDA #HIGH(PRG032_PalAnim_PalData)
	ADC <PalAnim_PtrH
	STA <PalAnim_PtrH
	
	LDA <PalAnim_CurIndex
	ASL A
	ASL A
	TAX	; X = PalAnim_CurIndex * 4 (compute offset to proper palette quadrant)
	
	LDY #$00	; Y = 0
PRG032_B88F:
	LDA [PalAnim_PtrL],Y
	BMI PRG032_B8A5	; If palette byte has bit 7 ($80) set, jump to PRG032_B8A5 (sets palette index 16 specifically, background color rotation)

	CMP #$40
	BGE PRG032_B89D	; If palette byte has bit 6 ($40) set, jump to PRG032_B89D (skip setting palette)

	; Straight palette set
	STA PalData_1+1,X
	STA PalData_2+1,X

PRG032_B89D:
	INX	; X++ (next palette offset)
	INY	; Y++ (next byte from data)
	CPY #$03
	BNE PRG032_B88F	; While Y < 3, loop!

	BEQ PRG032_B8AD	; Otherwise, jump to PRG032_B8AD


PRG032_B8A5:
	; NOTE: The loop above is aborted, so this is supposed to only be
	; on the first color for a background color palette animation.

	AND #$3F	; Get actual palette color
	STA PalData_1+16	; Set background color
	STA PalData_2+16	; Set background color

PRG032_B8AD:
	; End of BG palette quadrant animating

	INC <PalAnim_CommitCount	; PalAnim_CommitCount++
	
	LDX <PalAnim_CurIndex	; X = PalAnim_CurIndex
	
	LDA PalAnim_EnSel+$00,X
	CMP #$87
	BNE PRG032_B8C6	; If the enable is not specifically set to $87 (HACK), jump to PRG032_B8C6 (RTS)

	; $87-only HACK -- sprite palette is also effected

	LDX #$03	; X = 3
PRG032_B8BA:
	LDA PalData_1+8,X
	STA PalData_1+24,X
	STA PalData_2+24,X
	
	DEX	; X--
	BPL PRG032_B8BA	; While X >= 0, loop!


PRG032_B8C6:
	RTS	; $B8C6


	; The palette data indexed by the index pointed to by PRG032_PalAnim_Table, byte offset 2+
	; In the simplest case, this straight sets colors 1-3 of whatever BG quadrant is in context.
	; However, some special case colors are defined:
	; 	If bit 6 ($40) is set, skip setting color
	;	If bit 7 ($80) is set, this will set the background instead (intended for first index only, and other indexes are ignored)
PRG032_PalAnim_PalData:
	.byte $3C, $11, $2C		; $00
	.byte $2C, $3C, $11		; $01
	.byte $11, $2C, $3C		; $02
	.byte $0F, $0F, $11		; $03
	.byte $0F, $11, $0F		; $04
	.byte $11, $0F, $0F		; $05
	.byte $30, $19, $28		; $06
	.byte $30, $2A, $18		; $07
	.byte $11, $01, $07		; $08
	.byte $11, $01, $08		; $09
	.byte $0F, $0F, $0F		; $0A
	.byte $01, $0F, $0F		; $0B
	.byte $11, $01, $0F		; $0C
	.byte $1C, $11, $01		; $0D
	.byte $31, $1C, $11		; $0E
	.byte $16, $25, $26		; $0F
	.byte $25, $26, $27		; $10
	.byte $26, $27, $35		; $11
	.byte $35, $37, $30		; $12
	.byte $37, $30, $38		; $13
	.byte $30, $38, $39		; $14
	.byte $38, $39, $3A		; $15
	.byte $39, $3A, $2A		; $16
	.byte $3A, $2A, $33		; $17
	.byte $2A, $33, $25		; $18
	.byte $30, $21, $0F		; $19
	.byte $30, $22, $0F		; $1A
	.byte $AC, $00, $00		; $1B
	.byte $9C, $00, $00		; $1C
	.byte $8C, $00, $00		; $1D
	.byte $8F, $00, $00		; $1E
	.byte $3C, $11, $2C		; $1F
	.byte $1A, $0A, $08		; $20
	.byte $1B, $0C, $08		; $21
	.byte $00, $01, $0B		; $22
	.byte $10, $11, $1B		; $23
	.byte $20, $21, $2B		; $24
	.byte $2B, $1C, $11		; $25
	.byte $11, $2B, $1C		; $26
	.byte $1C, $11, $2B		; $27
	.byte $21, $35, $29		; $28
	.byte $25, $29, $35		; $29
	.byte $30, $21, $21		; $2A
	.byte $21, $21, $30		; $2B
	.byte $0F, $0F, $0F		; $2C
	.byte $07, $0F, $0F		; $2D
	.byte $29, $21, $25		; $2E
	.byte $30, $32, $0F		; $2F
	.byte $39, $25, $21		; $30
	.byte $16, $07, $0F		; $31
	.byte $26, $16, $06		; $32
	.byte $37, $26, $16		; $33
	.byte $11, $01, $17		; $34
	.byte $11, $01, $18		; $35
	.byte $11, $01, $27		; $36
	.byte $11, $01, $28		; $37
	.byte $11, $01, $37		; $38
	.byte $11, $01, $38		; $39
	.byte $27, $17, $38		; $3A
	.byte $38, $27, $17		; $3B
	.byte $25, $05, $04		; $3C
	.byte $26, $05, $04		; $3D
	.byte $15, $16, $04		; $3E
	.byte $16, $16, $04		; $3F
	.byte $05, $15, $04		; $40
	.byte $06, $15, $04		; $41
	.byte $05, $16, $04		; $42
	.byte $16, $05, $04		; $43
	.byte $15, $06, $04		; $44
	.byte $26, $06, $04		; $45
	.byte $26, $04, $0F		; $46
	.byte $16, $0F, $26		; $47
	.byte $04, $26, $16		; $48
	.byte $0F, $16, $04		; $49
	.byte $17, $38, $27		; $4A
	.byte $1B, $0C, $2B		; $4B
	.byte $0C, $2B, $1B		; $4C
	.byte $0F, $1B, $0C		; $4D
	.byte $0F, $0C, $0F		; $4E
	.byte $0C, $0F, $0F		; $4F
	.byte $36, $26, $16		; $50
	.byte $26, $36, $26		; $51
	.byte $16, $26, $36		; $52
	.byte $16, $16, $26		; $53
	.byte $16, $16, $16		; $54
	.byte $26, $16, $16		; $55
	.byte $30, $38, $29		; $56
	.byte $38, $30, $38		; $57
	.byte $29, $38, $30		; $58
	.byte $29, $29, $38		; $59
	.byte $29, $29, $29		; $5A
	.byte $38, $29, $29		; $5B
	.byte $20, $10, $16		; $5C
	.byte $10, $20, $10		; $5D
	.byte $16, $10, $20		; $5E
	.byte $16, $16, $10		; $5F
	.byte $10, $16, $16		; $60
	.byte $30, $37, $27		; $61
	.byte $37, $30, $37		; $62
	.byte $27, $37, $30		; $63
	.byte $27, $27, $37		; $64
	.byte $27, $27, $27		; $65
	.byte $37, $27, $27		; $66
	.byte $36, $27, $16		; $67
	.byte $27, $36, $26		; $68
	.byte $16, $27, $36		; $69
	.byte $16, $16, $27		; $6A
	.byte $27, $16, $16		; $6B
	.byte $20, $21, $11		; $6C
	.byte $21, $20, $21		; $6D
	.byte $11, $21, $20		; $6E
	.byte $11, $11, $21		; $6F
	.byte $11, $11, $11		; $70
	.byte $21, $11, $11		; $71
	.byte $3C, $2C, $1C		; $72
	.byte $2C, $3C, $2C		; $73
	.byte $1C, $2C, $3C		; $74
	.byte $1C, $1C, $2C		; $75
	.byte $1C, $1C, $1C		; $76
	.byte $2C, $1C, $1C		; $77
	.byte $20, $10, $00		; $78
	.byte $10, $20, $10		; $79
	.byte $00, $10, $20		; $7A
	.byte $00, $00, $10		; $7B
	.byte $00, $00, $00		; $7C
	.byte $10, $00, $00		; $7D
	.byte $30, $0F, $0F		; $7E
	.byte $0F, $30, $0F		; $7F
	.byte $0F, $0F, $30		; $80
	.byte $12, $32, $32		; $81
	.byte $12, $32, $22		; $82
	.byte $12, $32, $12		; $83
	.byte $32, $30, $31		; $84
	.byte $32, $30, $32		; $85
	.byte $32, $30, $30		; $86
	.byte $37, $25, $30		; $87
	.byte $30, $2C, $25		; $88
	.byte $25, $37, $2C		; $89
	.byte $2C, $30, $37		; $8A
	.byte $00, $01, $02		; $8B
	.byte $10, $11, $12		; $8C
	.byte $0F, $01, $01		; $8D
	.byte $01, $0F, $01		; $8E
	.byte $20, $28, $16		; $8F
	.byte $20, $16, $28		; $90
	.byte $20, $0F, $0F		; $91
	.byte $0F, $20, $0F		; $92
	.byte $0F, $0F, $20		; $93
	.byte $20, $21, $22		; $94
	.byte $40, $01, $0F		; $95
	.byte $2B, $0F, $0C		; $96
	.byte $0F, $09, $01		; $97
	.byte $01, $09, $01		; $98
	.byte $11, $09, $01		; $99
	.byte $21, $09, $01		; $9A
	.byte $31, $09, $01		; $9B
	.byte $07, $09, $01		; $9C
	.byte $17, $09, $01		; $9D
	.byte $27, $09, $01		; $9E
	.byte $37, $09, $01		; $9F
	.byte $25, $13, $03		; $A0
	.byte $14, $13, $03		; $A1
	.byte $04, $13, $03		; $A2
	.byte $0F, $13, $03		; $A3
	.byte $02, $0F, $02		; $A4
	.byte $0F, $02, $02		; $A5
	.byte $30, $32, $21		; $A6
	.byte $30, $33, $22		; $A7
	.byte $34, $24, $13		; $A8
	.byte $35, $25, $14		; $A9
	.byte $36, $26, $15		; $AA
	.byte $37, $27, $17		; $AB
	.byte $36, $26, $15		; $AC
	.byte $35, $25, $04		; $AD
	.byte $24, $14, $03		; $AE
	.byte $13, $03, $0F		; $AF
	.byte $11, $01, $0F		; $B0
	.byte $30, $0F, $32		; $B1
	.byte $30, $0F, $33		; $B2
	.byte $34, $0F, $24		; $B3
	.byte $35, $0F, $25		; $B4
	.byte $36, $0F, $26		; $B5
	.byte $37, $0F, $27		; $B6
	.byte $36, $0F, $26		; $B7
	.byte $35, $0F, $25		; $B8
	.byte $24, $27, $14		; $B9
	.byte $13, $27, $03		; $BA
	.byte $11, $27, $01		; $BB
	.byte $22, $32, $2B		; $BC
	.byte $23, $33, $2A		; $BD
	.byte $14, $24, $29		; $BE
	.byte $15, $25, $28		; $BF
	.byte $16, $26, $27		; $C0
	.byte $16, $27, $16		; $C1
	.byte $16, $26, $17		; $C2
	.byte $15, $25, $18		; $C3
	.byte $04, $14, $0A		; $C4
	.byte $02, $03, $0B		; $C5
	.byte $0C, $01, $0C		; $C6
	.byte $40, $2A, $1A		; $C7
	.byte $40, $29, $19		; $C8
	.byte $40, $28, $18		; $C9
	.byte $40, $27, $17		; $CA
	.byte $40, $27, $17		; $CB
	.byte $40, $27, $17		; $CC
	.byte $40, $28, $18		; $CD
	.byte $40, $19, $09		; $CE
	.byte $40, $0A, $0B		; $CF
	.byte $40, $01, $0C		; $D0
	.byte $40, $0C, $0F		; $D1
	.byte $40, $11, $01		; $D2
	.byte $40, $21, $11		; $D3
	
	
	; Palette animation data
	; 	Byte 0:  Length of animation (total bytes - 1 / max index val)
	;	Byte 1:  Tick count limit
	;	Byte 2+: [Index / 3] into PRG032_PalAnim_PalData
PRG032_BB43:
	.byte $02, $08, $1F, $01, $02

PRG032_BB48:
	.byte $02, $07, $03, $04, $05

PRG032_BB4D:
	.byte $02, $04, $03, $04, $05

PRG032_BB52:
	.byte $02, $02, $03, $04, $05

PRG032_BB57:
	.byte $01, $08, $06, $07

PRG032_BB5B:
	.byte $0D, $08, $08, $09, $34, $35, $36, $37, $38, $39, $38, $37, $36, $35, $34, $09


PRG032_BB6B:
	.byte $08, $0A, $0A, $0A, $0B, $0C, $0D, $0E, $0D, $0C, $0B

PRG032_BB76:
	.byte $09, $08, $0F, $10, $11, $12, $13, $14, $15, $16, $17, $18

PRG032_BB82:
	.byte $03, $10, $19, $1A, $2F, $1A

PRG032_BB88:
	.byte $04, $20, $1B, $1C, $1D, $1E, $00

PRG032_BB8F:
	.byte $01, $07, $20, $21

PRG032_BB93:
	.byte $02, $07, $25, $26, $27

PRG032_BB98:
	.byte $03, $08, $28, $29, $2E, $30

PRG032_BB9E:
	.byte $01, $15, $2A, $2B

PRG032_BBA2:
	.byte $05, $08, $2C, $2D, $31, $32, $33, $00

PRG032_BBAA:
	.byte $02, $08, $3A, $3B, $4A

PRG032_BBAF:
	.byte $09, $04, $3C, $3D, $3E, $3F, $40, $41, $42, $43, $44, $45

PRG032_BBBB:
	.byte $03, $08, $46, $47, $48, $49

PRG032_BBC1:
	.byte $05, $04, $50, $51, $52, $53, $54, $55

PRG032_BBC9:
	.byte $05, $04, $52, $53, $54, $55, $50, $51

PRG032_BBD1:
	.byte $05, $04, $54, $55, $50, $51, $52, $53

PRG032_BBD9:
	.byte $05, $04, $56, $57, $58, $59, $5A, $5B

PRG032_BBE1:
	.byte $05, $04, $58, $59, $5A, $5B, $56, $57

PRG032_BBE9:
	.byte $05, $04, $5A, $5B, $56, $57, $58, $59

PRG032_BBF1:
	.byte $05, $04, $5C, $5D, $5E, $5F, $54, $60

PRG032_BBF9:
	.byte $05, $04, $5E, $5F, $54, $60, $5C, $5D

PRG032_BC01:
	.byte $05, $04, $54, $60, $5C, $5D, $5E, $5F

PRG032_BC09:
	.byte $05, $04, $61, $62, $63, $64, $65, $66

PRG032_BC11:
	.byte $05, $04, $63, $64, $65, $66, $61, $62

PRG032_BC19:
	.byte $05, $04, $65, $66, $61, $62, $63, $64

PRG032_BC21:
	.byte $05, $04, $67, $68, $69, $6A, $54, $6B

PRG032_BC29:
	.byte $05, $04, $69, $6A, $54, $6B, $67, $68

PRG032_BC31:
	.byte $05, $04, $54, $6B, $67, $68, $69, $6A

PRG032_BC39:
	.byte $05, $04, $6C, $6D, $6E, $6F, $70, $71

PRG032_BC41:
	.byte $05, $04, $6E, $6F, $70, $71, $6C, $6D

PRG032_BC49:
	.byte $05, $04, $70, $71, $6C, $6D, $6E, $6F

PRG032_BC51:
	.byte $05, $04, $72, $73, $74, $75, $76, $77

PRG032_BC59:
	.byte $05, $04, $74, $75, $76, $77, $72, $73

PRG032_BC61:
	.byte $05, $04, $76, $77, $72, $73, $74, $75

PRG032_BC69:
	.byte $05, $04, $78, $79, $7A, $7B, $7C, $7D

PRG032_BC71:
	.byte $05, $04, $7A, $7B, $7C, $7D, $78, $79

PRG032_BC79:
	.byte $05, $04, $7C, $7D, $78, $79, $7A, $7B

PRG032_BC81:
	.byte $02, $08, $7E, $7F, $80

PRG032_BC86:
	.byte $02, $10, $81, $82, $83

PRG032_BC8B:
	.byte $02, $10, $84, $85, $86

PRG032_BC90:
	.byte $03, $08, $87, $88, $89, $8A

PRG032_BC96:
	.byte $03, $08, $8D, $8E, $8E, $8D

PRG032_BC9C:
	.byte $01, $10, $8E, $8D

PRG032_BCA0:
	.byte $01, $08, $8F, $90

PRG032_BCA4:
	.byte $02, $08, $91, $92, $93

PRG032_BCA9:
	.byte $06, $08, $96, $4B, $4C, $4D, $4E, $0A, $4F

PRG032_BCB2:
	.byte $0F, $04, $97, $98, $99, $9A, $9B, $9A, $99, $98, $97, $9C, $9D, $9E, $9F, $9E
	.byte $9D, $9C

PRG032_BCC4:
	.byte $0F, $04, $9F, $9E, $9D, $9C, $97, $98, $99, $9A, $9B, $9A, $99, $98, $97, $9C
	.byte $9D, $9E

PRG032_BCD6:
	.byte $05, $08, $A0, $A1, $A2, $A3, $A2, $A1

PRG032_BCDE:
	.byte $01, $08, $A4, $A5

PRG032_BCE2:
	.byte $0B, $2C, $A6, $A7, $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF, $B0, $00

PRG032_BCF0:
	.byte $0B, $2C, $B1, $B2, $B3, $B4, $B5, $B6, $B7, $B8, $B9, $BA, $BB, $00

PRG032_BCFE:
	.byte $0B, $2C, $BC, $BD, $BE, $BF, $C0, $C1, $C2, $C3, $C4, $C5, $C6, $00

PRG032_BD0C:
	.byte $0B, $2C, $C7, $C8, $C9, $CA, $CB, $CC, $CD, $CE, $CF, $D0, $D1, $00

PRG032_BD1A:
	.byte $03, $0A, $22, $23, $24, $00

PRG032_BD20:
	.byte $03, $0A, $8B, $8C, $94, $00

PRG032_BD26:
	.byte $03, $0A, $95, $D2, $D3, $00


PRG032_PalAnim_Table_L:	; $BD2C
	.byte LOW(PRG032_BB43)	; $00
	.byte LOW(PRG032_BB48)	; $01
	.byte LOW(PRG032_BB4D)	; $02
	.byte LOW(PRG032_BB52)	; $03
	.byte LOW(PRG032_BB57)	; $04
	.byte LOW(PRG032_BB5B)	; $05
	.byte LOW(PRG032_BB6B)	; $06
	.byte LOW(PRG032_BB76)	; $07
	.byte LOW(PRG032_BB82)	; $08
	.byte LOW(PRG032_BB88)	; $09
	.byte LOW(PRG032_BB8F)	; $0A
	.byte LOW(PRG032_BB93)	; $0B
	.byte LOW(PRG032_BB98)	; $0C
	.byte LOW(PRG032_BB9E)	; $0D
	.byte LOW(PRG032_BBA2)	; $0E
	.byte LOW(PRG032_BBAA)	; $0F
	.byte LOW(PRG032_BBAF)	; $10
	.byte LOW(PRG032_BBBB)	; $11
	.byte LOW(PRG032_BBC1)	; $12
	.byte LOW(PRG032_BBC9)	; $13
	.byte LOW(PRG032_BBD1)	; $14
	.byte LOW(PRG032_BBD9)	; $15
	.byte LOW(PRG032_BBE1)	; $16
	.byte LOW(PRG032_BBE9)	; $17
	.byte LOW(PRG032_BBF1)	; $18
	.byte LOW(PRG032_BBF9)	; $19
	.byte LOW(PRG032_BC01)	; $1A
	.byte LOW(PRG032_BC09)	; $1B
	.byte LOW(PRG032_BC11)	; $1C
	.byte LOW(PRG032_BC19)	; $1D
	.byte LOW(PRG032_BC21)	; $1E
	.byte LOW(PRG032_BC29)	; $1F
	.byte LOW(PRG032_BC31)	; $20
	.byte LOW(PRG032_BC39)	; $21
	.byte LOW(PRG032_BC41)	; $22
	.byte LOW(PRG032_BC49)	; $23
	.byte LOW(PRG032_BC51)	; $24
	.byte LOW(PRG032_BC59)	; $25
	.byte LOW(PRG032_BC61)	; $26
	.byte LOW(PRG032_BC69)	; $27
	.byte LOW(PRG032_BC71)	; $28
	.byte LOW(PRG032_BC79)	; $29
	.byte LOW(PRG032_BC81)	; $2A
	.byte LOW(PRG032_BC86)	; $2B
	.byte LOW(PRG032_BC8B)	; $2C
	.byte LOW(PRG032_BC90)	; $2D
	.byte LOW(PRG032_BC96)	; $2E
	.byte LOW(PRG032_BC9C)	; $2F
	.byte LOW(PRG032_BCA0)	; $30
	.byte LOW(PRG032_BCA4)	; $31
	.byte LOW(PRG032_BCA9)	; $32
	.byte LOW(PRG032_BCB2)	; $33
	.byte LOW(PRG032_BCC4)	; $34
	.byte LOW(PRG032_BCD6)	; $35
	.byte LOW(PRG032_BCDE)	; $36
	.byte LOW(PRG032_BCE2)	; $37
	.byte LOW(PRG032_BCF0)	; $38
	.byte LOW(PRG032_BCFE)	; $39
	.byte LOW(PRG032_BD0C)	; $3A
	.byte LOW(PRG032_BD1A)	; $3B
	.byte LOW(PRG032_BD20)	; $3C
	.byte LOW(PRG032_BD26)	; $3D
	.byte LOW(PRG032_PalAnim_Table_L)	; $3E UNUSED/INVALID
	.byte LOW(PRG032_PalAnim_Table_L)	; $3F UNUSED/INVALID



PRG032_PalAnim_Table_H:	; $BD6C
	.byte HIGH(PRG032_BB43)	; $00
	.byte HIGH(PRG032_BB48)	; $01
	.byte HIGH(PRG032_BB4D)	; $02
	.byte HIGH(PRG032_BB52)	; $03
	.byte HIGH(PRG032_BB57)	; $04
	.byte HIGH(PRG032_BB5B)	; $05
	.byte HIGH(PRG032_BB6B)	; $06
	.byte HIGH(PRG032_BB76)	; $07
	.byte HIGH(PRG032_BB82)	; $08
	.byte HIGH(PRG032_BB88)	; $09
	.byte HIGH(PRG032_BB8F)	; $0A
	.byte HIGH(PRG032_BB93)	; $0B
	.byte HIGH(PRG032_BB98)	; $0C
	.byte HIGH(PRG032_BB9E)	; $0D
	.byte HIGH(PRG032_BBA2)	; $0E
	.byte HIGH(PRG032_BBAA)	; $0F
	.byte HIGH(PRG032_BBAF)	; $10
	.byte HIGH(PRG032_BBBB)	; $11
	.byte HIGH(PRG032_BBC1)	; $12
	.byte HIGH(PRG032_BBC9)	; $13
	.byte HIGH(PRG032_BBD1)	; $14
	.byte HIGH(PRG032_BBD9)	; $15
	.byte HIGH(PRG032_BBE1)	; $16
	.byte HIGH(PRG032_BBE9)	; $17
	.byte HIGH(PRG032_BBF1)	; $18
	.byte HIGH(PRG032_BBF9)	; $19
	.byte HIGH(PRG032_BC01)	; $1A
	.byte HIGH(PRG032_BC09)	; $1B
	.byte HIGH(PRG032_BC11)	; $1C
	.byte HIGH(PRG032_BC19)	; $1D
	.byte HIGH(PRG032_BC21)	; $1E
	.byte HIGH(PRG032_BC29)	; $1F
	.byte HIGH(PRG032_BC31)	; $20
	.byte HIGH(PRG032_BC39)	; $21
	.byte HIGH(PRG032_BC41)	; $22
	.byte HIGH(PRG032_BC49)	; $23
	.byte HIGH(PRG032_BC51)	; $24
	.byte HIGH(PRG032_BC59)	; $25
	.byte HIGH(PRG032_BC61)	; $26
	.byte HIGH(PRG032_BC69)	; $27
	.byte HIGH(PRG032_BC71)	; $28
	.byte HIGH(PRG032_BC79)	; $29
	.byte HIGH(PRG032_BC81)	; $2A
	.byte HIGH(PRG032_BC86)	; $2B
	.byte HIGH(PRG032_BC8B)	; $2C
	.byte HIGH(PRG032_BC90)	; $2D
	.byte HIGH(PRG032_BC96)	; $2E
	.byte HIGH(PRG032_BC9C)	; $2F
	.byte HIGH(PRG032_BCA0)	; $30
	.byte HIGH(PRG032_BCA4)	; $31
	.byte HIGH(PRG032_BCA9)	; $32
	.byte HIGH(PRG032_BCB2)	; $33
	.byte HIGH(PRG032_BCC4)	; $34
	.byte HIGH(PRG032_BCD6)	; $35
	.byte HIGH(PRG032_BCDE)	; $36
	.byte HIGH(PRG032_BCE2)	; $37
	.byte HIGH(PRG032_BCF0)	; $38
	.byte HIGH(PRG032_BCFE)	; $39
	.byte HIGH(PRG032_BD0C)	; $3A
	.byte HIGH(PRG032_BD1A)	; $3B
	.byte HIGH(PRG032_BD20)	; $3C
	.byte HIGH(PRG032_BD26)	; $3D
	.byte HIGH(PRG032_PalAnim_Table_L)	; $3E UNUSED/INVALID
	.byte HIGH(PRG032_PalAnim_Table_L)	; $3F UNUSED/INVALID



	; CHECKME - UNUSED?
	.byte $ED, $44, $42, $40, $D9, $01, $AB, $04, $90, $05, $3C, $50, $27, $14	; $BDAA - $BDB9
	.byte $49, $05, $F0, $14, $80, $51, $97, $55, $1D, $54, $E4, $15, $02, $01, $64, $11	; $BDBA - $BDC9
	.byte $21, $14, $95, $50, $DF, $01, $87, $11, $0E, $51, $6E, $14, $84, $00, $E9, $10	; $BDCA - $BDD9
	.byte $01, $40, $9C, $50, $4B, $00, $FD, $04, $FC, $51, $7E, $54, $B0, $00, $FE, $54	; $BDDA - $BDE9
	.byte $9D, $05, $30, $40, $11, $01, $42, $11, $4E, $05, $2B, $54, $64, $44, $96, $51	; $BDEA - $BDF9
	.byte $4E, $41, $24, $15, $C7, $14, $0D, $10, $C2, $55, $AF, $04, $48, $00, $04, $04	; $BDFA - $BE09
	.byte $30, $11, $37, $04, $56, $00, $C9, $00, $E1, $51, $90, $11, $C1, $41, $66, $00	; $BE0A - $BE19
	.byte $4C, $01, $05, $01, $06, $10, $46, $10, $A6, $05, $89, $04, $36, $01, $A7, $10	; $BE1A - $BE29
	.byte $40, $05, $79, $50, $DF, $05, $5E, $05, $A2, $14, $31, $40, $69, $10, $90, $01	; $BE2A - $BE39
	.byte $8A, $00, $4D, $14, $64, $00, $FB, $14, $45, $14, $DD, $50, $69, $51, $02, $14	; $BE3A - $BE49
	.byte $FA, $14, $A5, $50, $E1, $05, $08, $51, $20, $41, $82, $00, $62, $00, $32, $10	; $BE4A - $BE59
	.byte $98, $15, $E3, $40, $20, $05, $DE, $41, $8A, $11, $CB, $45, $B1, $01, $0A, $14	; $BE5A - $BE69
	.byte $2C, $00, $BD, $04, $C6, $40, $7A, $51, $6B, $01, $5F, $50, $CC, $50, $F1, $10	; $BE6A - $BE79
	.byte $DF, $50, $08, $11, $33, $11, $9B, $14, $ED, $54, $CD, $50, $BC, $40, $40, $44	; $BE7A - $BE89
	.byte $3C, $50, $00, $01, $49, $04, $8C, $00, $24, $40, $A6, $41, $81, $01, $70, $40	; $BE8A - $BE99
	.byte $88, $10, $20, $55, $04, $45, $8D, $55, $E9, $14, $E6, $11, $7E, $51, $20, $04	; $BE9A - $BEA9
	.byte $9F, $10, $DB, $15, $CF, $41, $FC, $45, $8C, $14, $15, $41, $58, $44, $41, $51	; $BEAA - $BEB9
	.byte $DD, $14, $C7, $01, $D1, $00, $54, $01, $55, $44, $6F, $41, $88, $51, $22, $51	; $BEBA - $BEC9
	.byte $09, $41, $42, $04, $00, $00, $82, $00, $97, $40, $49, $54, $78, $20, $05, $00	; $BECA - $BED9
	.byte $55, $41, $24, $01, $F3, $00, $3C, $10, $E6, $45, $B1, $15, $F1, $45, $86, $10	; $BEDA - $BEE9
	.byte $BC, $44, $A1, $04, $CA, $44, $CF, $01, $6C, $54, $DF, $15, $EE, $14, $F0, $10	; $BEEA - $BEF9
	.byte $01, $50, $BE, $01, $A7, $44, $56, $10, $F5, $50, $41, $01, $A5, $40, $21, $00	; $BEFA - $BF09
	.byte $E8, $55, $49, $15, $10, $04, $26, $01, $5A, $05, $60, $41, $1A, $01, $B6, $50	; $BF0A - $BF19
	.byte $53, $01, $00, $00, $01, $01, $BB, $50, $47, $01, $EA, $40, $9A, $55, $A5, $05	; $BF1A - $BF29
	.byte $A1, $50, $27, $10, $CC, $14, $8D, $45, $2B, $40, $C9, $00, $2D, $51, $41, $54	; $BF2A - $BF39
	.byte $DD, $14, $E9, $50, $37, $15, $BF, $40, $E3, $04, $0E, $50, $D2, $41, $1E, $04	; $BF3A - $BF49
	.byte $42, $41, $57, $44, $E4, $40, $8D, $44, $53, $44, $14, $40, $79, $05, $60, $00	; $BF4A - $BF59
	.byte $C3, $10, $36, $01, $43, $44, $0E, $45, $22, $15, $A9, $01, $B3, $40, $EF, $50	; $BF5A - $BF69
	.byte $C7, $54, $26, $41, $C2, $11, $68, $44, $E9, $04, $53, $14, $3A, $44, $FE, $44	; $BF6A - $BF79
	.byte $5A, $45, $D9, $81, $4B, $01, $BD, $41, $A2, $50, $11, $40, $D3, $14, $07, $14	; $BF7A - $BF89
	.byte $FC, $14, $21, $00, $CC, $04, $63, $00, $C1, $15, $0A, $14, $A0, $04, $B5, $11	; $BF8A - $BF99
	.byte $48, $41, $EE, $11, $80, $10, $51, $10, $4A, $44, $80, $50, $BF, $45, $06, $10	; $BF9A - $BFA9
	.byte $E2, $50, $F1, $51, $58, $41, $83, $14, $3A, $51, $E1, $44, $8D, $05, $1C, $60	; $BFAA - $BFB9
	.byte $DB, $41, $E8, $11, $8D, $50, $73, $40, $2E, $51, $12, $54, $44, $45, $16, $11	; $BFBA - $BFC9
	.byte $B8, $01, $6B, $51, $BB, $05, $A4, $00, $44, $51, $8A, $00, $D5, $50, $4F, $01	; $BFCA - $BFD9
	.byte $F5, $45, $93, $45, $A2, $40, $8E, $10, $1C, $55, $5A, $05, $7B, $15, $3D, $14	; $BFDA - $BFE9
	.byte $EE, $44, $61, $04, $82, $14, $9A, $44, $60, $54, $11, $41, $EA, $51, $6C, $55	; $BFEA - $BFF9
	.byte $F5, $04, $9E, $01, $8C, $07	; $BFFA - $BFFF


