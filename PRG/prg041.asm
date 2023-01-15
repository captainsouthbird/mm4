	; Standard tilemap data; see format.txt in TMAPDATA for what this is comprised of.
	.incbin "PRG/TMAPDATA/TMAP09.bin"
	
	; Player Weapon Damage table for Drill Bomb
	.org Player_WeaponDamageTable	; <-- help enforce this table *here*
PRG041_DrillBombDamageTable:		
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
	.byte $03	; $10 SPRSLOTID_TAKETETNO
	.byte $01	; $11 SPRSLOTID_TAKETETNO_PROP
	.byte $00	; $12 SPRSLOTID_HOVER
	.byte $03	; $13 SPRSLOTID_TOMBOY
	.byte $00	; $14 SPRSLOTID_SASOREENU
	.byte $00	; $15 SPRSLOTID_SASOREENU_SPAWNER
	.byte $00	; $16 SPRSLOTID_BATTAN
	.byte $00	; $17
	.byte $02	; $18 SPRSLOTID_SWALLOWN
	.byte $01	; $19 SPRSLOTID_COSWALLOWN
	.byte $01	; $1A SPRSLOTID_WALLBLASTER
	.byte $00	; $1B SPRSLOTID_WALLBLASTER_SHOT
	.byte $01	; $1C SPRSLOTID_100WATTON
	.byte $02	; $1D SPRSLOTID_100WATTON_SHOT
	.byte $00	; $1E SPRSLOTID_100WATTON_SHOT_BURST
	.byte $02	; $1F SPRSLOTID_RATTON
	.byte $00	; $20 SPRSLOTID_RMRAINBOW_CTL1
	.byte $00	; $21 SPRSLOTID_RMRAINBOW_CTL2
	.byte $00	; $22 SPRSLOTID_RMRAINBOW_CTL3
	.byte $00	; $23 SPRSLOTID_RMRAINBOW_CTL4
	.byte $01	; $24 SPRSLOTID_SUBBOSS_KABATONCUE
	.byte $01	; $25 SPRSLOTID_KABATONCUE_MISSILE
	.byte $00	; $26 SPRSLOTID_RINGMAN_UNK2
	.byte $01	; $27 SPRSLOTID_WILY_ESCAPEPOD
	.byte $01	; $28 SPRSLOTID_BOMBABLE_WALL
	.byte $00	; $29 SPRSLOTID_MOTHRAYA_DIE
	.byte $00	; $2A SPRSLOTID_POWERGAIN_ORBS
	.byte $01	; $2B SPRSLOTID_SUBBOSS_ESCAROO
	.byte $01	; $2C SPRSLOTID_ESCAROO_BOMB
	.byte $00	; $2D SPRSLOTID_ESCAROO_DIE
	.byte $00	; $2E SPRSLOTID_EXPLODEYBIT
	.byte $00	; $2F SPRSLOTID_RED_UTRACK_PLAT
	.byte $03	; $30 SPRSLOTID_SUBBOSS_WHOPPER
	.byte $00	; $31 SPRSLOTID_SUBBOSS_WHOPPER_RING
	.byte $00	; $32 SPRSLOTID_SUBBOSS_WHOPPER_RIN2
	.byte $01	; $33 SPRSLOTID_HAEHAEY
	.byte $00	; $34 SPRSLOTID_HAEHAEY_SHOT
	.byte $02	; $35 SPRSLOTID_RACKASER
	.byte $01	; $36 SPRSLOTID_RACKASER_UMBRELLA
	.byte $01	; $37 SPRSLOTID_DOMPAN
	.byte $00	; $38 SPRSLOTID_DOMPAN_FIREWORKS
	.byte $00	; $39 SPRSLOTID_CIRCLEBULLET
	.byte $00	; $3A SPRSLOTID_WHOPPER_DIE
	.byte $00	; $3B SPRSLOTID_CIRCULAREXPLOSION
	.byte $00	; $3C SPRSLOTID_CEXPLOSION
	.byte $01	; $3D SPRSLOTID_MINOAN
	.byte $02	; $3E SPRSLOTID_SUPERBALLMACHJR_L
	.byte $01	; $3F SPRSLOTID_SUPERBALLMACHJR_B
	.byte $00	; $40 SPRSLOTID_BOULDER_DISPENSER
	.byte $01	; $41 SPRSLOTID_BOULDER_DEBRIS
	.byte $00	; $42 SPRSLOTID_EDDIE
	.byte $00	; $43 SPRSLOTID_EDDIE_IMMEDIATE
	.byte $04	; $44 SPRSLOTID_EDDIE_ITEM_EJECT
	.byte $03	; $45 SPRSLOTID_CRPLATFORM_FALL
	.byte $04	; $46 SPRSLOTID_JUMPBIG
	.byte $00	; $47
	.byte $04	; $48 SPRSLOTID_SHIELDATTACKER
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
	.byte $00	; $62 SPRSLOTID_SKELETONJOE
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
	.byte $00	; $70 SPRSLOTID_GYOTOT
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
	.byte $01	; $7F SPRSLOTID_DRILLMAN_DRILL
	.byte $00	; $80 SPRSLOTID_MISCSTUFF
	.byte $01	; $81 SPRSLOTID_BOSSINTRO
	.byte $00	; $82 SPRSLOTID_DRILLMAN_POOF
	.byte $00	; $83 SPRSLOTID_SPIRALEXPLOSION
	.byte $01	; $84 SPRSLOTID_BOSSPHARAOH
	.byte $00	; $85 SPRSLOTID_PHARAOHMAN_ATTACK
	.byte $00	; $86 SPRSLOTID_PHARAOHMAN_SATTACK
	.byte $02	; $87 SPRSLOTID_BOSS_MOTHRAYA
	.byte $00	; $88 SPRSLOTID_COSSACK1_UNK1
	.byte $00	; $89 SPRSLOTID_COSSACK1_UNK2
	.byte $00	; $8A SPRSLOTID_MOTHRAYA_SHOT
	.byte $01	; $8B SPRSLOTID_BOSSBRIGHT
	.byte $00	; $8C SPRSLOTID_BOSSBRIGHT_BULLET
	.byte $04	; $8D SPRSLOTID_BOSSTOAD
	.byte $02	; $8E SPRSLOTID_BATTONTON
	.byte $00	; $8F SPRSLOTID_MOTHRAYA_DEBRIS
	.byte $00	; $90 SPRSLOTID_EXPLODEY_DEATH
	.byte $01	; $91 SPRSLOTID_MANTAN
	.byte $00	; $92 SPRSLOTID_BOSS_COSSACKCATCH
	.byte $00	; $93 SPRSLOTID_COSSACK4_UNK1
	.byte $00	; $94 SPRSLOTID_COSSACK4_BULLET
	.byte $02	; $95 SPRSLOTID_BOSS_SQUAREMACHINE
	.byte $00	; $96 SPRSLOTID_SQUAREMACH_PLATFORM
	.byte $00	; $97 SPRSLOTID_SQUAREMACHINE_SHOT
	.byte $01	; $98 SPRSLOTID_BOULDER
	.byte $00	; $99 SPRSLOTID_COSSACK2_UNK2
	.byte $02	; $9A SPRSLOTID_MUMMIRA
	.byte $00	; $9B SPRSLOTID_MUMMIRAHEAD
	.byte $02	; $9C SPRSLOTID_IMORM
	.byte $00	; $9D SPRSLOTID_ENEMYEXPLODE
	.byte $02	; $9E SPRSLOTID_COSSACK3BOSS1
	.byte $00	; $9F SPRSLOTID_COSSACK3BOSS2_SHOT
	.byte $00	; $A0 SPRSLOTID_COSSACK3BOSS1_SHOT
	.byte $01	; $A1 SPRSLOTID_MONOROADER
	.byte $02	; $A2 SPRSLOTID_COSSACK3BOSS2
	.byte $00	; $A3 SPRSLOTID_KALINKA
	.byte $00	; $A4 SPRSLOTID_PROTOMAN
	.byte $00	; $A5 SPRSLOTID_WILY
	.byte $00	; $A6 SPRSLOTID_BOSS_METALLDADDY
	.byte $03	; $A7 SPRSLOTID_GACHAPPON
	.byte $00	; $A8 SPRSLOTID_GACHAPPON_BULLET
	.byte $00	; $A9 SPRSLOTID_GACHAPPON_GASHAPON
	.byte $01	; $AA SPRSLOTID_METALLDADDY_METALL
	.byte $01	; $AB SPRSLOTID_BOSS_TAKOTRASH
	.byte $02	; $AC SPRSLOTID_WILY2_UNK1
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
	.byte $01	; $B7 SPRSLOTID_GARYOBY
	.byte $00	; $B8 SPRSLOTID_BOSS_ROBOTMASTER
	.byte $01	; $B9 SPRSLOTID_DOCRON
	.byte $01	; $BA SPRSLOTID_DOCRON_SKULL
	.byte $01	; $BB SPRSLOTID_WILY3_UNK1
	.byte $01	; $BC SPRSLOTID_BOSS_WILYMACHINE4
	.byte $00	; $BD SPRSLOTID_TOGEHERO_SPAWNER_R
	.byte $01	; $BE SPRSLOTID_TOGEHERO
	.byte $00	; $BF SPRSLOTID_WILYMACHINE4_SHOTCH
	.byte $04	; $C0 SPRSLOTID_WILYMACHINE4_PHASE2
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

	
	.byte $00	; $B7C1 - $B7D0
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B7D1 - $B7E0
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B7E1 - $B7F0
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B7F1 - $B7FF


PRG041_B800_L:	; $B800
	.byte LOW(PRG041_B8B0)	; $00
	.byte LOW(PRG041_B8B2)	; $01
	.byte LOW(PRG041_B8C3)	; $02
	.byte LOW(PRG041_B8D8)	; $03
	.byte LOW(PRG041_B8E5)	; $04
	.byte LOW(PRG041_B8FA)	; $05
	.byte LOW(PRG041_B913)	; $06
	.byte LOW(PRG041_B924)	; $07
	.byte LOW(PRG041_B931)	; $08
	.byte LOW(PRG041_B93E)	; $09
	.byte LOW(PRG041_B94B)	; $0A
	.byte LOW(PRG041_B95C)	; $0B
	.byte LOW(PRG041_B969)	; $0C
	.byte LOW(PRG041_B97E)	; $0D
	.byte LOW(PRG041_B98F)	; $0E
	.byte LOW(PRG041_B9A4)	; $0F
	.byte LOW(PRG041_B9B9)	; $10
	.byte LOW(PRG041_B9CA)	; $11
	.byte LOW(PRG041_B9D7)	; $12
	.byte LOW(PRG041_B9E8)	; $13
	.byte LOW(PRG041_B9FD)	; $14
	.byte LOW(PRG041_BA12)	; $15
	.byte LOW(PRG041_BA2B)	; $16
	.byte LOW(PRG041_BA31)	; $17
	.byte LOW(PRG041_BA4E)	; $18
	.byte LOW(PRG041_BA6B)	; $19
	.byte LOW(PRG041_BA7C)	; $1A
	.byte LOW(PRG041_BA8D)	; $1B
	.byte LOW(PRG041_BA8D)	; $1C
	.byte LOW(PRG041_BA9A)	; $1D
	.byte LOW(PRG041_BAAF)	; $1E
	.byte LOW(PRG041_BAC4)	; $1F
	.byte LOW(PRG041_BAD9)	; $20
	.byte LOW(PRG041_BADF)	; $21
	.byte LOW(PRG041_BAF8)	; $22
	.byte LOW(PRG041_BAFE)	; $23
	.byte LOW(PRG041_BB17)	; $24
	.byte LOW(PRG041_BB28)	; $25
	.byte LOW(PRG041_BB3D)	; $26
	.byte LOW(PRG041_BB5A)	; $27
	.byte LOW(PRG041_BB67)	; $28
	.byte LOW(PRG041_BB78)	; $29
	.byte LOW(PRG041_BB89)	; $2A
	.byte LOW(PRG041_BB9A)	; $2B
	.byte LOW(PRG041_BBAF)	; $2C
	.byte LOW(PRG041_BBC4)	; $2D
	.byte LOW(PRG041_BBD5)	; $2E
	.byte LOW(PRG041_BBE6)	; $2F
	.byte LOW(PRG041_BBFF)	; $30
	.byte LOW(PRG041_BC0C)	; $31
	.byte LOW(PRG041_BC21)	; $32
	.byte LOW(PRG041_BC2E)	; $33
	.byte LOW(PRG041_BC43)	; $34
	.byte LOW(PRG041_BC54)	; $35
	.byte LOW(PRG041_BC69)	; $36
	.byte LOW(PRG041_BC82)	; $37
	.byte LOW(PRG041_BC93)	; $38
	.byte LOW(PRG041_BCA4)	; $39
	.byte LOW(PRG041_BCB1)	; $3A
	.byte LOW(PRG041_BCC2)	; $3B
	.byte LOW(PRG041_BCD3)	; $3C
	.byte LOW(PRG041_BCE4)	; $3D
	.byte LOW(PRG041_BCF9)	; $3E
	.byte LOW(PRG041_BD0E)	; $3F
	.byte LOW(PRG041_BD27)	; $40
	.byte LOW(PRG041_BD38)	; $41
	.byte LOW(PRG041_BD51)	; $42
	.byte LOW(PRG041_BD66)	; $43
	.byte LOW(PRG041_BD73)	; $44
	.byte LOW(PRG041_BD88)	; $45
	.byte LOW(PRG041_BD9D)	; $46
	.byte LOW(PRG041_BDB2)	; $47
	.byte LOW(PRG041_BDC3)	; $48
	.byte LOW(PRG041_BDDC)	; $49
	.byte LOW(PRG041_BDE9)	; $4A
	.byte LOW(PRG041_BDEF)	; $4B
	.byte LOW(PRG041_BE00)	; $4C
	.byte LOW(PRG041_BE19)	; $4D
	.byte LOW(PRG041_BE26)	; $4E
	.byte LOW(PRG041_BE3B)	; $4F

	; Incomplete. no "high" side
	.byte $A8	; $50 [UNUSED]
	.byte $49	; $51 [UNUSED]
	.byte $A0	; $52 [UNUSED]
	.byte $B7	; $53 [UNUSED]
	.byte $80	; $54 [UNUSED]
	.byte $77	; $55 [UNUSED]
	.byte $28	; $56 [UNUSED]
	.byte $A8	; $57 [UNUSED]
	.byte $20	; $58 [UNUSED]
	.byte $2E	; $59 [UNUSED]
	.byte $02	; $5A [UNUSED]
	.byte $F1	; $5B [UNUSED]
	.byte $A8	; $5C [UNUSED]
	.byte $7C	; $5D [UNUSED]
	.byte $8A	; $5E [UNUSED]
	.byte $29	; $5F [UNUSED]



PRG041_B800_H:	; $B860
	.byte HIGH(PRG041_B8B0)	; $00
	.byte HIGH(PRG041_B8B2)	; $01
	.byte HIGH(PRG041_B8C3)	; $02
	.byte HIGH(PRG041_B8D8)	; $03
	.byte HIGH(PRG041_B8E5)	; $04
	.byte HIGH(PRG041_B8FA)	; $05
	.byte HIGH(PRG041_B913)	; $06
	.byte HIGH(PRG041_B924)	; $07
	.byte HIGH(PRG041_B931)	; $08
	.byte HIGH(PRG041_B93E)	; $09
	.byte HIGH(PRG041_B94B)	; $0A
	.byte HIGH(PRG041_B95C)	; $0B
	.byte HIGH(PRG041_B969)	; $0C
	.byte HIGH(PRG041_B97E)	; $0D
	.byte HIGH(PRG041_B98F)	; $0E
	.byte HIGH(PRG041_B9A4)	; $0F
	.byte HIGH(PRG041_B9B9)	; $10
	.byte HIGH(PRG041_B9CA)	; $11
	.byte HIGH(PRG041_B9D7)	; $12
	.byte HIGH(PRG041_B9E8)	; $13
	.byte HIGH(PRG041_B9FD)	; $14
	.byte HIGH(PRG041_BA12)	; $15
	.byte HIGH(PRG041_BA2B)	; $16
	.byte HIGH(PRG041_BA31)	; $17
	.byte HIGH(PRG041_BA4E)	; $18
	.byte HIGH(PRG041_BA6B)	; $19
	.byte HIGH(PRG041_BA7C)	; $1A
	.byte HIGH(PRG041_BA8D)	; $1B
	.byte HIGH(PRG041_BA8D)	; $1C
	.byte HIGH(PRG041_BA9A)	; $1D
	.byte HIGH(PRG041_BAAF)	; $1E
	.byte HIGH(PRG041_BAC4)	; $1F
	.byte HIGH(PRG041_BAD9)	; $20
	.byte HIGH(PRG041_BADF)	; $21
	.byte HIGH(PRG041_BAF8)	; $22
	.byte HIGH(PRG041_BAFE)	; $23
	.byte HIGH(PRG041_BB17)	; $24
	.byte HIGH(PRG041_BB28)	; $25
	.byte HIGH(PRG041_BB3D)	; $26
	.byte HIGH(PRG041_BB5A)	; $27
	.byte HIGH(PRG041_BB67)	; $28
	.byte HIGH(PRG041_BB78)	; $29
	.byte HIGH(PRG041_BB89)	; $2A
	.byte HIGH(PRG041_BB9A)	; $2B
	.byte HIGH(PRG041_BBAF)	; $2C
	.byte HIGH(PRG041_BBC4)	; $2D
	.byte HIGH(PRG041_BBD5)	; $2E
	.byte HIGH(PRG041_BBE6)	; $2F
	.byte HIGH(PRG041_BBFF)	; $30
	.byte HIGH(PRG041_BC0C)	; $31
	.byte HIGH(PRG041_BC21)	; $32
	.byte HIGH(PRG041_BC2E)	; $33
	.byte HIGH(PRG041_BC43)	; $34
	.byte HIGH(PRG041_BC54)	; $35
	.byte HIGH(PRG041_BC69)	; $36
	.byte HIGH(PRG041_BC82)	; $37
	.byte HIGH(PRG041_BC93)	; $38
	.byte HIGH(PRG041_BCA4)	; $39
	.byte HIGH(PRG041_BCB1)	; $3A
	.byte HIGH(PRG041_BCC2)	; $3B
	.byte HIGH(PRG041_BCD3)	; $3C
	.byte HIGH(PRG041_BCE4)	; $3D
	.byte HIGH(PRG041_BCF9)	; $3E
	.byte HIGH(PRG041_BD0E)	; $3F
	.byte HIGH(PRG041_BD27)	; $40
	.byte HIGH(PRG041_BD38)	; $41
	.byte HIGH(PRG041_BD51)	; $42
	.byte HIGH(PRG041_BD66)	; $43
	.byte HIGH(PRG041_BD73)	; $44
	.byte HIGH(PRG041_BD88)	; $45
	.byte HIGH(PRG041_BD9D)	; $46
	.byte HIGH(PRG041_BDB2)	; $47
	.byte HIGH(PRG041_BDC3)	; $48
	.byte HIGH(PRG041_BDDC)	; $49
	.byte HIGH(PRG041_BDE9)	; $4A
	.byte HIGH(PRG041_BDEF)	; $4B
	.byte HIGH(PRG041_BE00)	; $4C
	.byte HIGH(PRG041_BE19)	; $4D
	.byte HIGH(PRG041_BE26)	; $4E
	.byte HIGH(PRG041_BE3B)	; $4F


PRG041_B8B0:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte $FF	; Terminator


PRG041_B8B2:

	; Sprite palette data
	.byte $0F, $0F, $22, $13, $0F, $0F, $35, $16

	; CHR RAM upload
	.byte 18				; ROM Bank to load CHR RAM from
	.byte 96				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG018_9000)	; High part of ROM address to copy from
	.byte $0A				; PPU destination address high byte (PT0/BG)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 64				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG008_8100)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_B8C3:

	; Sprite palette data
	.byte $0F, $20, $28, $18, $0F, $0F, $30, $16

	; CHR RAM upload
	.byte 18				; ROM Bank to load CHR RAM from
	.byte 96				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG018_8A00)	; High part of ROM address to copy from
	.byte $0A				; PPU destination address high byte (PT0/BG)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG008_8600)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG008_8700)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_B8D8:

	; Sprite palette data
	.byte $0F, $0F, $30, $2C, $0F, $16, $30, $25

	; CHR RAM upload
	.byte  4				; ROM Bank to load CHR RAM from
	.byte 96				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_AA00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_B8E5:

	; Sprite palette data
	.byte $0F, $0F, $30, $27, $0F, $0F, $30, $15

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_A100)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_A300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_A000)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_B8FA:

	; Sprite palette data
	.byte $0F, $0F, $29, $19, $0F, $20, $32, $13

	; CHR RAM upload
	.byte 20				; ROM Bank to load CHR RAM from
	.byte 80				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG021_B000)	; High part of ROM address to copy from
	.byte $08				; PPU destination address high byte (PT0/BG)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_8400)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_8800)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG008_8300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_B913:

	; Sprite palette data
	.byte $0F, $0F, $39, $19, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte  4				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_A800)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_A400)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_B924:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte  4				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_A600)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_B931:

	; Sprite palette data
	.byte $0F, $0F, $20, $16, $0F, $0F, $0F, $0F

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG000_8E00)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_B93E:

	; Sprite palette data
	.byte $0F, $16, $20, $10, $0F, $0F, $10, $23

	; CHR RAM upload
	.byte  4				; ROM Bank to load CHR RAM from
	.byte 80				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_B800)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_B94B:

	; Sprite palette data
	.byte $0F, $16, $20, $10, $0F, $0F, $10, $23

	; CHR RAM upload
	.byte 16				; ROM Bank to load CHR RAM from
	.byte 80				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG016_9800)	; High part of ROM address to copy from
	.byte $08				; PPU destination address high byte (PT0/BG)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte 80				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_B800)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_B95C:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $0F, $20, $29

	; CHR RAM upload
	.byte  4				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_A600)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_B969:

	; Sprite palette data
	.byte $0F, $0F, $20, $21, $0F, $0F, $0F, $0F

	; CHR RAM upload
	.byte 16				; ROM Bank to load CHR RAM from
	.byte 80				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG016_9800)	; High part of ROM address to copy from
	.byte $08				; PPU destination address high byte (PT0/BG)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_8300)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG003_BF00)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_B97E:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $0F, $30, $15

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_A800)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_AD00)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_B98F:

	; Sprite palette data
	.byte $0F, $0F, $0F, $0F, $0F, $0F, $20, $15

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_AC00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_AF00)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_9300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_B9A4:

	; Sprite palette data
	.byte $0F, $0F, $30, $27, $0F, $0F, $30, $16

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_A100)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_A300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_9200)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_B9B9:

	; Sprite palette data
	.byte $0F, $0F, $27, $18, $0F, $0F, $20, $11

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_9100)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_9300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_B9CA:

	; Sprite palette data
	.byte $0F, $0F, $29, $19, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte  8				; ROM Bank to load CHR RAM from
	.byte 96				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG008_8800)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_B9D7:

	; Sprite palette data
	.byte $0F, $0F, $27, $18, $0F, $0F, $20, $21

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_9000)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_9600)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_B9E8:

	; Sprite palette data
	.byte $0F, $0F, $3A, $19, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte  4				; ROM Bank to load CHR RAM from
	.byte 64				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_A000)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_A600)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_A700)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_B9FD:

	; Sprite palette data
	.byte $0F, $20, $28, $18, $0F, $0F, $20, $26

	; CHR RAM upload
	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG008_8600)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG008_8700)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG003_BF00)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BA12:

	; Sprite palette data
	.byte $0F, $20, $28, $18, $0F, $0F, $20, $26

	; CHR RAM upload
	.byte 18				; ROM Bank to load CHR RAM from
	.byte 128				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG018_9600)	; High part of ROM address to copy from
	.byte $08				; PPU destination address high byte (PT0/BG)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG008_8600)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG008_8700)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_9300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BA2B:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG000_8C00)	; High part of ROM address to copy from
	.byte $11				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BA31:

	; Sprite palette data
	.byte $0F, $0F, $22, $11, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte 20				; ROM Bank to load CHR RAM from
	.byte 80				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG021_B500)	; High part of ROM address to copy from
	.byte $0B				; PPU destination address high byte (PT0/BG)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG009_BF00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG009_BB00)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG008_8300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG009_BE00)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BA4E:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $0F, $20, $27

	; CHR RAM upload
	.byte 22				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG022_8B00)	; High part of ROM address to copy from
	.byte $0B				; PPU destination address high byte (PT0/BG)

	.byte 20				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG021_BA00)	; High part of ROM address to copy from
	.byte $0D				; PPU destination address high byte (PT0/BG)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG009_B500)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG009_B300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_BD00)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BA6B:

	; Sprite palette data
	.byte $0F, $10, $00, $08, $0F, $0F, $30, $16

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_9000)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_9200)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BA7C:

	; Sprite palette data
	.byte $0F, $0F, $20, $27, $0F, $0F, $29, $19

	; CHR RAM upload
	.byte 28				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG028_8700)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG008_9800)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BA8D:

	; Sprite palette data
	.byte $0F, $0F, $20, $27, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte 28				; ROM Bank to load CHR RAM from
	.byte 64				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG028_8000)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BA9A:

	; Sprite palette data
	.byte $0F, $0F, $20, $16, $0F, $0F, $20, $29

	; CHR RAM upload
	.byte  2				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG002_9800)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG002_9D00)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_8700)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BAAF:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_B500)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_A600)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte 28				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG028_8400)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BAC4:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $0F, $20, $2C

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_B300)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_B700)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_8700)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BAD9:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 18				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG018_9E00)	; High part of ROM address to copy from
	.byte $0C				; PPU destination address high byte (PT0/BG)

	.byte $FF	; Terminator


PRG041_BADF:

	; Sprite palette data
	.byte $0F, $0F, $27, $16, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG008_9E00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_BC00)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_BD00)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_9200)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BAF8:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 20				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG021_BA00)	; High part of ROM address to copy from
	.byte $0D				; PPU destination address high byte (PT0/BG)

	.byte $FF	; Terminator


PRG041_BAFE:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte 24				; ROM Bank to load CHR RAM from
	.byte 64				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG025_A800)	; High part of ROM address to copy from
	.byte $0C				; PPU destination address high byte (PT0/BG)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_B300)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_B700)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte 28				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG028_8A00)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BB17:

	; Sprite palette data
	.byte $0F, $0F, $0F, $0F, $0F, $0F, $20, $29

	; CHR RAM upload
	.byte 24				; ROM Bank to load CHR RAM from
	.byte 64				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG024_8C00)	; High part of ROM address to copy from
	.byte $0C				; PPU destination address high byte (PT0/BG)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_9300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BB28:

	; Sprite palette data
	.byte $0F, $0F, $34, $14, $0F, $16, $30, $2C

	; CHR RAM upload
	.byte 24				; ROM Bank to load CHR RAM from
	.byte 128				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG025_A000)	; High part of ROM address to copy from
	.byte $08				; PPU destination address high byte (PT0/BG)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG002_8000)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG002_8200)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BB3D:

	; Sprite palette data
	.byte $0F, $0F, $37, $27, $0F, $37, $10, $16

	; CHR RAM upload
	.byte 24				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG025_AC00)	; High part of ROM address to copy from
	.byte $0B				; PPU destination address high byte (PT0/BG)

	.byte 36				; ROM Bank to load CHR RAM from
	.byte 128				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG037_B800)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG002_8B00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG002_8F00)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG003_A000)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BB5A:

	; Sprite palette data
	.byte $0F, $0F, $28, $16, $0F, $0F, $0F, $0F

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte 96				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG001_A800)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BB67:

	; Sprite palette data
	.byte $0F, $0F, $20, $16, $0F, $0F, $20, $10

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG000_8800)	; High part of ROM address to copy from
	.byte $18				; PPU destination address high byte (PT1/sprites)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 96				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG001_BA00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BB78:

	; Sprite palette data
	.byte $0F, $0F, $20, $10, $0F, $0F, $20, $21

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG001_AE00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 64				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG001_B000)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BB89:

	; Sprite palette data
	.byte $0F, $0F, $20, $1C, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte  2				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG003_B200)	; High part of ROM address to copy from
	.byte $18				; PPU destination address high byte (PT1/sprites)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 96				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG001_B400)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BB9A:

	; Sprite palette data
	.byte $0F, $0F, $20, $16, $0F, $0F, $20, $10

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte 64				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG000_9C00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG001_A000)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG003_B300)	; High part of ROM address to copy from
	.byte $18				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BBAF:

	; Sprite palette data
	.byte $0F, $0F, $20, $27, $0F, $20, $2C, $11

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte 96				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG001_A200)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG003_B500)	; High part of ROM address to copy from
	.byte $18				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG003_B600)	; High part of ROM address to copy from
	.byte $15				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BBC4:

	; Sprite palette data
	.byte $0F, $0F, $20, $26, $0F, $0F, $20, $29

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte 96				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG000_9000)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG003_B400)	; High part of ROM address to copy from
	.byte $18				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BBD5:

	; Sprite palette data
	.byte $0F, $0F, $38, $29, $0F, $0F, $27, $2C

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte 96				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG000_9600)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG003_B700)	; High part of ROM address to copy from
	.byte $18				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BBE6:

	; Sprite palette data
	.byte $0F, $0F, $20, $16, $0F, $0F, $20, $27

	; CHR RAM upload
	.byte 22				; ROM Bank to load CHR RAM from
	.byte 80				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG022_8B00)	; High part of ROM address to copy from
	.byte $0B				; PPU destination address high byte (PT0/BG)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG003_BF00)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG009_B000)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG009_B600)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BBFF:

	; Sprite palette data
	.byte $0F, $0F, $20, $27, $0F, $0F, $0F, $0F

	; CHR RAM upload
	.byte 28				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG028_8000)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BC0C:

	; Sprite palette data
	.byte $0F, $0F, $20, $26, $0F, $0F, $20, $29

	; CHR RAM upload
	.byte  2				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG002_9D00)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_BA00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_BB00)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BC21:

	; Sprite palette data
	.byte $0F, $0F, $30, $19, $0F, $0F, $30, $16

	; CHR RAM upload
	.byte 28				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG028_8C00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BC2E:

	; Sprite palette data
	.byte $0F, $0F, $20, $16, $0F, $0F, $20, $2C

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_B100)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_8700)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_A600)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BC43:

	; Sprite palette data
	.byte $0F, $0F, $20, $16, $0F, $0F, $20, $2C

	; CHR RAM upload
	.byte 28				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG028_8700)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_8700)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BC54:

	; Sprite palette data
	.byte $0F, $0F, $20, $21, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte 28				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG028_8900)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG003_BF00)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_8700)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BC69:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $0F, $20, $15

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_AC00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_AF00)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_A600)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_B500)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BC82:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $0F, $0F, $0F

	; CHR RAM upload
	.byte 28				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG028_8700)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_A600)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BC93:

	; Sprite palette data
	.byte $0F, $0F, $20, $27, $0F, $0F, $30, $16

	; CHR RAM upload
	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG008_8700)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte 28				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG028_8600)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BCA4:

	; Sprite palette data
	.byte $0F, $0F, $20, $16, $0F, $0F, $20, $10

	; CHR RAM upload
	.byte  2				; ROM Bank to load CHR RAM from
	.byte 96				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG002_8400)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BCB1:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $0F, $10, $23

	; CHR RAM upload
	.byte  4				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_B800)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_A600)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BCC2:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte 28				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG028_8B00)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_A600)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BCD3:

	; Sprite palette data
	.byte $0F, $0F, $0F, $0F, $0F, $0F, $20, $21

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_9600)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte 28				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG028_8A00)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BCE4:

	; Sprite palette data
	.byte $0F, $0F, $30, $27, $0F, $0F, $30, $15

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_A000)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_AC00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_AF00)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BCF9:

	; Sprite palette data
	.byte $0F, $0F, $20, $27, $0F, $0F, $30, $16

	; CHR RAM upload
	.byte 28				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG028_8000)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_9200)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte 28				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG028_8300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BD0E:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $0F, $20, $27

	; CHR RAM upload
	.byte 22				; ROM Bank to load CHR RAM from
	.byte 80				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG022_8B00)	; High part of ROM address to copy from
	.byte $0B				; PPU destination address high byte (PT0/BG)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG009_B500)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG009_B600)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_BD00)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BD27:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $16, $20, $26

	; CHR RAM upload
	.byte 34				; ROM Bank to load CHR RAM from
	.byte 80				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG035_B900)	; High part of ROM address to copy from
	.byte $09				; PPU destination address high byte (PT0/BG)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG008_8E00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BD38:

	; Sprite palette data
	.byte $0F, $0F, $20, $24, $0F, $20, $3C, $1C

	; CHR RAM upload
	.byte 50				; ROM Bank to load CHR RAM from
	.byte 128				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG050_B800) - $20	; High part of ROM address to copy from [HACK]
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte 50				; ROM Bank to load CHR RAM from
	.byte 128				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG051_B800)	; High part of ROM address to copy from
	.byte $08				; PPU destination address high byte (PT0/BG)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte 80				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG003_BA00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG003_A300)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BD51:

	; Sprite palette data
	.byte $0F, $0F, $20, $27, $0F, $0F, $0F, $19

	; CHR RAM upload
	.byte  2				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG003_A300)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte 28				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG028_8000)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte 28				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG028_8300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BD66:

	; Sprite palette data
	.byte $0F, $0F, $16, $16, $0F, $0F, $0F, $0F

	; CHR RAM upload
	.byte  4				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_A300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BD73:

	; Sprite palette data
	.byte $0F, $0F, $0F, $0F, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG008_8600)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG008_8000)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG008_8500)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BD88:

	; Sprite palette data
	.byte $0F, $0F, $20, $21, $0F, $0F, $20, $2C

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_A600)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_A700)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_8700)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BD9D:

	; Sprite palette data
	.byte $0F, $0F, $20, $27, $0F, $0F, $20, $27

	; CHR RAM upload
	.byte 28				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG028_8000)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG009_B300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_BD00)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BDB2:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG008_9F00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG003_BF00)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BDC3:

	; Sprite palette data
	.byte $0F, $0F, $3A, $19, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_AC00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_AF00)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_A200)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG005_A700)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BDDC:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $0F, $0F, $0F

	; CHR RAM upload
	.byte  2				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG003_B900)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BDE9:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte 32				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG000_8100)	; High part of ROM address to copy from
	.byte $11				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BDEF:

	; Sprite palette data
	.byte $0F, $0F, $10, $16, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte  8				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG009_A000)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG009_A100)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BE00:

	; Sprite palette data
	.byte $0F, $0F, $27, $16, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte 28				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG028_8400)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_BC00)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_BD00)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte 28				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG028_8B00)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BE19:

	; Sprite palette data
	.byte $0F, $0F, $0F, $0F, $0F, $0F, $20, $26

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte 48				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG006_9300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BE26:

	; Sprite palette data
	.byte $0F, $0F, $20, $16, $0F, $0F, $20, $29

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_BA00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG007_BB00)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte 16				; Number of patterns to load (16 bytes each)
	.byte HIGH(PRG003_BF00)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG041_BE3B:
	; CHECKME - UNUSED?
	.byte $FF, $F7, $55, $F4, $C5, $F9, $54, $DD, $51, $5F, $51, $EF, $45, $DF, $C9, $EE	; $BE3B - $BE4A
	.byte $17, $FB, $55, $FE, $55, $DF, $0D, $7F, $61, $3B, $54, $FB, $15, $9D, $39, $1D	; $BE4B - $BE5A
	.byte $D0, $DE, $44, $D5, $14, $F7, $51, $EF, $55, $B9, $55, $FE, $41, $FF, $1C, $F7	; $BE5B - $BE6A
	.byte $55, $EE, $51, $6C, $40, $F7, $55, $7E, $54, $F3, $24, $FD, $44, $5F, $58, $88	; $BE6B - $BE7A
	.byte $01, $F4, $51, $85, $85, $FF, $55, $7F, $D1, $8B, $11, $B7, $45, $FE, $05, $69	; $BE7B - $BE8A
	.byte $D4, $FF, $55, $BB, $41, $39, $11, $ED, $55, $2F, $55, $B7, $54, $91, $55, $BD	; $BE8B - $BE9A
	.byte $55, $EA, $05, $7B, $40, $F7, $55, $F8, $4D, $F7, $45, $5F, $45, $89, $57, $FE	; $BE9B - $BEAA
	.byte $15, $FF, $49, $FE, $1C, $AF, $04, $F9, $75, $FF, $45, $5D, $45, $7F, $15, $7D	; $BEAB - $BEBA
	.byte $55, $8D, $45, $EF, $10, $EF, $51, $F3, $15, $4F, $55, $F7, $71, $FB, $45, $DF	; $BEBB - $BECA
	.byte $19, $F7, $55, $EF, $55, $F7, $15, $FB, $55, $2F, $14, $7A, $53, $CF, $51, $67	; $BECB - $BEDA
	.byte $51, $FF, $55, $B9, $95, $DE, $41, $F9, $5D, $9F, $55, $B6, $01, $BB, $54, $1F	; $BEDB - $BEEA
	.byte $45, $AA, $01, $5D, $3D, $E6, $15, $7E, $54, $D3, $15, $BB, $44, $FF, $55, $D6	; $BEEB - $BEFA
	.byte $56, $5F, $41, $75, $D5, $DA, $41, $F6, $51, $7B, $63, $DC, $55, $E1, $51, $DD	; $BEFB - $BF0A
	.byte $51, $7F, $11, $FB, $44, $F3, $04, $D1, $41, $F7, $95, $5E, $01, $FF, $15, $93	; $BF0B - $BF1A
	.byte $51, $AF, $51, $70, $51, $FF, $05, $71, $55, $FF, $54, $BB, $04, $FF, $41, $BF	; $BF1B - $BF2A
	.byte $55, $FF, $55, $F2, $41, $BE, $55, $CC, $CD, $EF, $56, $FE, $45, $EF, $51, $38	; $BF2B - $BF3A
	.byte $04, $D2, $51, $CD, $51, $FF, $58, $6C, $44, $BF, $54, $DF, $C1, $B3, $57, $9E	; $BF3B - $BF4A
	.byte $55, $7F, $D1, $D7, $40, $DB, $51, $EB, $85, $42, $55, $E3, $05, $FE, $11, $4A	; $BF4B - $BF5A
	.byte $30, $CE, $41, $F2, $54, $FF, $15, $D8, $15, $CD, $55, $7E, $53, $3F, $55, $DB	; $BF5B - $BF6A
	.byte $35, $B4, $44, $B1, $56, $FF, $44, $EF, $05, $EB, $14, $BB, $10, $97, $40, $EF	; $BF6B - $BF7A
	.byte $55, $3B, $44, $FF, $45, $FF, $55, $76, $5B, $FD, $65, $FF, $15, $6B, $54, $FF	; $BF7B - $BF8A
	.byte $45, $B9, $55, $F8, $54, $16, $55, $5D, $55, $AF, $55, $D2, $05, $C9, $55, $FD	; $BF8B - $BF9A
	.byte $01, $B5, $41, $BB, $51, $4F, $5D, $FF, $55, $FF, $45, $FB, $58, $BB, $54, $6B	; $BF9B - $BFAA
	.byte $54, $2F, $75, $7F, $11, $F5, $55, $ED, $14, $3B, $55, $6F, $54, $F7, $55, $D3	; $BFAB - $BFBA
	.byte $55, $EF, $55, $FD, $D4, $7D, $15, $FF, $51, $7F, $55, $BB, $55, $7F, $41, $3F	; $BFBB - $BFCA
	.byte $44, $BD, $54, $EE, $15, $F8, $C1, $FD, $15, $FE, $40, $CD, $21, $CD, $55, $D7	; $BFCB - $BFDA
	.byte $11, $AE, $15, $8F, $14, $F9, $5D, $DF, $41, $DB, $55, $D5, $54, $FF, $55, $F6	; $BFDB - $BFEA
	.byte $5F, $D7, $C5, $DD, $51, $DF, $45, $5F, $14, $71, $35, $F7, $05, $F6, $01, $AA	; $BFEB - $BFFA
	.byte $10, $3B, $10, $B0, $55	; $BFFB - $BFFF


