	; Standard tilemap data; see format.txt in TMAPDATA for what this is comprised of.
	.incbin "PRG/TMAPDATA/TMAP08.bin"
	
	; Player Weapon Damage table for Ring Boomerang
	.org Player_WeaponDamageTable	; <-- help enforce this table *here*
PRG040_RingBoomerDamageTable:		
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
	.byte $02	; $14 SPRSLOTID_SASOREENU
	.byte $00	; $15 SPRSLOTID_SASOREENU_SPAWNER
	.byte $00	; $16 SPRSLOTID_BATTAN
	.byte $00	; $17
	.byte $01	; $18 SPRSLOTID_SWALLOWN
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
	.byte $00	; $28 SPRSLOTID_BOMBABLE_WALL
	.byte $00	; $29 SPRSLOTID_MOTHRAYA_DIE
	.byte $00	; $2A SPRSLOTID_POWERGAIN_ORBS
	.byte $03	; $2B SPRSLOTID_SUBBOSS_ESCAROO
	.byte $01	; $2C SPRSLOTID_ESCAROO_BOMB
	.byte $00	; $2D SPRSLOTID_ESCAROO_DIE
	.byte $00	; $2E SPRSLOTID_EXPLODEYBIT
	.byte $00	; $2F SPRSLOTID_RED_UTRACK_PLAT
	.byte $03	; $30 SPRSLOTID_SUBBOSS_WHOPPER
	.byte $00	; $31 SPRSLOTID_SUBBOSS_WHOPPER_RING
	.byte $00	; $32 SPRSLOTID_SUBBOSS_WHOPPER_RIN2
	.byte $01	; $33 SPRSLOTID_HAEHAEY
	.byte $00	; $34 SPRSLOTID_HAEHAEY_SHOT
	.byte $04	; $35 SPRSLOTID_RACKASER
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
	.byte $00	; $44 SPRSLOTID_EDDIE_ITEM_EJECT
	.byte $01	; $45 SPRSLOTID_CRPLATFORM_FALL
	.byte $02	; $46 SPRSLOTID_JUMPBIG
	.byte $00	; $47
	.byte $02	; $48 SPRSLOTID_SHIELDATTACKER
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
	.byte $01	; $70 SPRSLOTID_GYOTOT
	.byte $01	; $71 SPRSLOTID_BOSSSKULL
	.byte $00	; $72 SPRSLOTID_SKULLMAN_BULLET
	.byte $00	; $73 SPRSLOTID_DUSTMAN_4PLAT
	.byte $00	; $74 SPRSLOTID_DUSTMAN_PLATSEG
	.byte $01	; $75 SPRSLOTID_BOSSRING
	.byte $00	; $76 SPRSLOTID_RINGMAN_RING
	.byte $00	; $77 SPRSLOTID_BOSSDEATH
	.byte $00	; $78 SPRSLOTID_BIREE1
	.byte $04	; $79 SPRSLOTID_BOSSDUST
	.byte $00	; $7A SPRSLOTID_DUSTMAN_DUSTCRUSHER
	.byte $00	; $7B SPRSLOTID_DUSTMAN_DUSTDEBRIS
	.byte $01	; $7C SPRSLOTID_BOSSDIVE
	.byte $00	; $7D SPRSLOTID_BOSSDIVE_MISSILE
	.byte $01	; $7E SPRSLOTID_BOSSDRILL
	.byte $00	; $7F SPRSLOTID_DRILLMAN_DRILL
	.byte $00	; $80 SPRSLOTID_MISCSTUFF
	.byte $01	; $81 SPRSLOTID_BOSSINTRO
	.byte $00	; $82 SPRSLOTID_DRILLMAN_POOF
	.byte $00	; $83 SPRSLOTID_SPIRALEXPLOSION
	.byte $01	; $84 SPRSLOTID_BOSSPHARAOH
	.byte $00	; $85 SPRSLOTID_PHARAOHMAN_ATTACK
	.byte $00	; $86 SPRSLOTID_PHARAOHMAN_SATTACK
	.byte $04	; $87 SPRSLOTID_BOSS_MOTHRAYA
	.byte $00	; $88 SPRSLOTID_COSSACK1_UNK1
	.byte $00	; $89 SPRSLOTID_COSSACK1_UNK2
	.byte $00	; $8A SPRSLOTID_MOTHRAYA_SHOT
	.byte $01	; $8B SPRSLOTID_BOSSBRIGHT
	.byte $00	; $8C SPRSLOTID_BOSSBRIGHT_BULLET
	.byte $01	; $8D SPRSLOTID_BOSSTOAD
	.byte $02	; $8E SPRSLOTID_BATTONTON
	.byte $00	; $8F SPRSLOTID_MOTHRAYA_DEBRIS
	.byte $00	; $90 SPRSLOTID_EXPLODEY_DEATH
	.byte $01	; $91 SPRSLOTID_MANTAN
	.byte $01	; $92 SPRSLOTID_BOSS_COSSACKCATCH
	.byte $00	; $93 SPRSLOTID_COSSACK4_UNK1
	.byte $00	; $94 SPRSLOTID_COSSACK4_BULLET
	.byte $00	; $95 SPRSLOTID_BOSS_SQUAREMACHINE
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
	.byte $02	; $A6 SPRSLOTID_BOSS_METALLDADDY
	.byte $03	; $A7 SPRSLOTID_GACHAPPON
	.byte $00	; $A8 SPRSLOTID_GACHAPPON_BULLET
	.byte $00	; $A9 SPRSLOTID_GACHAPPON_GASHAPON
	.byte $01	; $AA SPRSLOTID_METALLDADDY_METALL
	.byte $04	; $AB SPRSLOTID_BOSS_TAKOTRASH
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
	.byte $03	; $B7 SPRSLOTID_GARYOBY
	.byte $00	; $B8 SPRSLOTID_BOSS_ROBOTMASTER
	.byte $01	; $B9 SPRSLOTID_DOCRON
	.byte $01	; $BA SPRSLOTID_DOCRON_SKULL
	.byte $01	; $BB SPRSLOTID_WILY3_UNK1
	.byte $03	; $BC SPRSLOTID_BOSS_WILYMACHINE4
	.byte $00	; $BD SPRSLOTID_TOGEHERO_SPAWNER_R
	.byte $01	; $BE SPRSLOTID_TOGEHERO
	.byte $00	; $BF SPRSLOTID_WILYMACHINE4_SHOTCH
	.byte $01	; $C0 SPRSLOTID_WILYMACHINE4_PHASE2
	.byte $00	; $C1 SPRSLOTID_ITEM_PICKUP
	.byte $00	; $C2 SPRSLOTID_SPECWPN_PICKUP
	.byte $00	; $C3 SPRSLOTID_WILY1_DISPBLOCKS
	.byte $01	; $C4 SPRSLOTID_BOSS_WILYCAPSULE
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


	; CHECKME - UNUSED?
	.byte $00, $00, $00, $00, $00, $00, $00	; $B7C7 - $B7D6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B7D7 - $B7E6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B7E7 - $B7F6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B7F7 - $B7FF

PRG040_PPUUploadTable_L:	; $B800
	.byte LOW(PRG040_B8E0)	; $00
	.byte LOW(PRG040_B901)	; $01
	.byte LOW(PRG040_B922)	; $02
	.byte LOW(PRG040_B943)	; $03
	.byte LOW(PRG040_B964)	; $04
	.byte LOW(PRG040_B985)	; $05
	.byte LOW(PRG040_B9A6)	; $06
	.byte LOW(PRG040_B9CF)	; $07
	.byte LOW(PRG040_B9F0)	; $08
	.byte LOW(PRG040_BA0D)	; $09
	.byte LOW(PRG040_BA2A)	; $0A
	.byte LOW(PRG040_BA4F)	; $0B
	.byte LOW(PRG040_BA6C)	; $0C
	.byte LOW(PRG040_BA85)	; $0D
	.byte LOW(PRG040_BAAA)	; $0E
	.byte LOW(PRG040_BAC7)	; $0F
	.byte LOW(PRG040_BAE8)	; $10
	.byte LOW(PRG040_BAFA)	; $11
	.byte LOW(PRG040_BB04)	; $12
	.byte LOW(PRG040_BB0A)	; $13
	.byte LOW(PRG040_BB10)	; $14
	.byte LOW(PRG040_BB1A)	; $15
	.byte LOW(PRG040_BB1F)	; $16
	.byte LOW(PRG040_BB28)	; $17
	.byte LOW(PRG040_BB31)	; $18
	.byte LOW(PRG040_BB3A)	; $19
	.byte LOW(PRG040_BB43)	; $1A
	.byte LOW(PRG040_BB50)	; $1B
	.byte LOW(PRG040_BB5D)	; $1C
	.byte LOW(PRG040_BB66)	; $1D
	.byte LOW(PRG040_BB6F)	; $1E
	.byte LOW(PRG040_BB78)	; $1F
	.byte LOW(PRG040_BB7D)	; $20
	.byte LOW(PRG040_BB82)	; $21
	.byte LOW(PRG040_BB88)	; $22
	.byte LOW(PRG040_BB8D)	; $23
	.byte LOW(PRG040_BB92)	; $24
	.byte LOW(PRG040_BB97)	; $25
	.byte LOW(PRG040_BB9C)	; $26
	.byte LOW(PRG040_BBA1)	; $27
	.byte LOW(PRG040_BBA6)	; $28
	.byte LOW(PRG040_BBAB)	; $29
	.byte LOW(PRG040_BBB0)	; $2A
	.byte LOW(PRG040_BBB5)	; $2B
	.byte LOW(PRG040_BBBA)	; $2C
	.byte LOW(PRG040_BBBF)	; $2D
	.byte LOW(PRG040_BBC4)	; $2E
	.byte LOW(PRG040_BBC9)	; $2F
	.byte LOW(PRG040_BBCF)	; $30
	.byte LOW(PRG040_BBD4)	; $31
	.byte LOW(PRG040_BBD9)	; $32
	.byte LOW(PRG040_BBDE)	; $33
	.byte LOW(PRG040_BBE3)	; $34
	.byte LOW(PRG040_BBE8)	; $35
	.byte LOW(PRG040_BBED)	; $36
	.byte LOW(PRG040_BBF2)	; $37
	.byte LOW(PRG040_BBF7)	; $38
	.byte LOW(PRG040_BBFC)	; $39
	.byte LOW(PRG040_BC01)	; $3A
	.byte LOW(PRG040_BC06)	; $3B
	.byte LOW(PRG040_BBCF)	; $3C
	.byte LOW(PRG040_BC0B)	; $3D
	.byte LOW(PRG040_BC10)	; $3E
	.byte LOW(PRG040_BC22)	; $3F
	.byte LOW(PRG040_BC34)	; $40
	.byte LOW(PRG040_BC3E)	; $41
	.byte LOW(PRG040_BC44)	; $42
	.byte LOW(PRG040_BC55)	; $43
	.byte LOW(PRG040_BC66)	; $44
	.byte LOW(PRG040_BC7B)	; $45
	.byte LOW(PRG040_BC94)	; $46
	.byte LOW(PRG040_BCA1)	; $47
	.byte LOW(PRG040_BCB6)	; $48
	.byte LOW(PRG040_BCCA)	; $49
	.byte LOW(PRG040_BCD3)	; $4A
	.byte LOW(PRG040_BCD8)	; $4B
	.byte LOW(PRG040_BCE9)	; $4C
	.byte LOW(PRG040_BCF6)	; $4D
	.byte LOW(PRG040_BD04)	; $4E
	.byte LOW(PRG040_BD1D)	; $4F
	.byte LOW(PRG040_BD32)	; $50
	.byte LOW(PRG040_BD43)	; $51
	.byte LOW(PRG040_BD58)	; $52
	.byte LOW(PRG040_BD6D)	; $53
	.byte LOW(PRG040_BD82)	; $54
	.byte LOW(PRG040_BD9A)	; $55
	.byte LOW(PRG040_BDAF)	; $56
	.byte LOW(PRG040_BDB8)	; $57
	.byte LOW(PRG040_BDC2)	; $58
	.byte LOW(PRG040_BDC2)	; $59
	.byte LOW(PRG040_BDC2)	; $5A
	.byte LOW(PRG040_BDC2)	; $5B
	.byte LOW(PRG040_BDC2)	; $5C
	.byte LOW(PRG040_BDC2)	; $5D
	.byte LOW(PRG040_BDC2)	; $5E
	.byte LOW(PRG040_BDC2)	; $5F
	.byte LOW(PRG040_BDC2)	; $60
	.byte LOW(PRG040_BDC2)	; $61
	.byte LOW(PRG040_BDC2)	; $62
	.byte LOW(PRG040_BDC2)	; $63
	.byte LOW(PRG040_BDC2)	; $64
	.byte LOW(PRG040_BDC2)	; $65
	.byte LOW(PRG040_BDC2)	; $66
	.byte LOW(PRG040_BDC2)	; $67
	.byte LOW(PRG040_BDC2)	; $68
	.byte LOW(PRG040_BDC2)	; $69
	.byte LOW(PRG040_BDC2)	; $6A
	.byte LOW(PRG040_BDC2)	; $6B
	.byte LOW(PRG040_BDC2)	; $6C
	.byte LOW(PRG040_BDC2)	; $6D
	.byte LOW(PRG040_BDC2)	; $6E
	.byte LOW(PRG040_BDC2)	; $6F



PRG040_PPUUploadTable_H:	; $B870
	.byte HIGH(PRG040_B8E0)	; $00
	.byte HIGH(PRG040_B901)	; $01
	.byte HIGH(PRG040_B922)	; $02
	.byte HIGH(PRG040_B943)	; $03
	.byte HIGH(PRG040_B964)	; $04
	.byte HIGH(PRG040_B985)	; $05
	.byte HIGH(PRG040_B9A6)	; $06
	.byte HIGH(PRG040_B9CF)	; $07
	.byte HIGH(PRG040_B9F0)	; $08
	.byte HIGH(PRG040_BA0D)	; $09
	.byte HIGH(PRG040_BA2A)	; $0A
	.byte HIGH(PRG040_BA4F)	; $0B
	.byte HIGH(PRG040_BA6C)	; $0C
	.byte HIGH(PRG040_BA85)	; $0D
	.byte HIGH(PRG040_BAAA)	; $0E
	.byte HIGH(PRG040_BAC7)	; $0F
	.byte HIGH(PRG040_BAE8)	; $10
	.byte HIGH(PRG040_BAFA)	; $11
	.byte HIGH(PRG040_BB04)	; $12
	.byte HIGH(PRG040_BB0A)	; $13
	.byte HIGH(PRG040_BB10)	; $14
	.byte HIGH(PRG040_BB1A)	; $15
	.byte HIGH(PRG040_BB1F)	; $16
	.byte HIGH(PRG040_BB28)	; $17
	.byte HIGH(PRG040_BB31)	; $18
	.byte HIGH(PRG040_BB3A)	; $19
	.byte HIGH(PRG040_BB43)	; $1A
	.byte HIGH(PRG040_BB50)	; $1B
	.byte HIGH(PRG040_BB5D)	; $1C
	.byte HIGH(PRG040_BB66)	; $1D
	.byte HIGH(PRG040_BB6F)	; $1E
	.byte HIGH(PRG040_BB78)	; $1F
	.byte HIGH(PRG040_BB7D)	; $20
	.byte HIGH(PRG040_BB82)	; $21
	.byte HIGH(PRG040_BB88)	; $22
	.byte HIGH(PRG040_BB8D)	; $23
	.byte HIGH(PRG040_BB92)	; $24
	.byte HIGH(PRG040_BB97)	; $25
	.byte HIGH(PRG040_BB9C)	; $26
	.byte HIGH(PRG040_BBA1)	; $27
	.byte HIGH(PRG040_BBA6)	; $28
	.byte HIGH(PRG040_BBAB)	; $29
	.byte HIGH(PRG040_BBB0)	; $2A
	.byte HIGH(PRG040_BBB5)	; $2B
	.byte HIGH(PRG040_BBBA)	; $2C
	.byte HIGH(PRG040_BBBF)	; $2D
	.byte HIGH(PRG040_BBC4)	; $2E
	.byte HIGH(PRG040_BBC9)	; $2F
	.byte HIGH(PRG040_BBCF)	; $30
	.byte HIGH(PRG040_BBD4)	; $31
	.byte HIGH(PRG040_BBD9)	; $32
	.byte HIGH(PRG040_BBDE)	; $33
	.byte HIGH(PRG040_BBE3)	; $34
	.byte HIGH(PRG040_BBE8)	; $35
	.byte HIGH(PRG040_BBED)	; $36
	.byte HIGH(PRG040_BBF2)	; $37
	.byte HIGH(PRG040_BBF7)	; $38
	.byte HIGH(PRG040_BBFC)	; $39
	.byte HIGH(PRG040_BC01)	; $3A
	.byte HIGH(PRG040_BC06)	; $3B
	.byte HIGH(PRG040_BBCF)	; $3C
	.byte HIGH(PRG040_BC0B)	; $3D
	.byte HIGH(PRG040_BC10)	; $3E
	.byte HIGH(PRG040_BC22)	; $3F
	.byte HIGH(PRG040_BC34)	; $40
	.byte HIGH(PRG040_BC3E)	; $41
	.byte HIGH(PRG040_BC44)	; $42
	.byte HIGH(PRG040_BC55)	; $43
	.byte HIGH(PRG040_BC66)	; $44
	.byte HIGH(PRG040_BC7B)	; $45
	.byte HIGH(PRG040_BC94)	; $46
	.byte HIGH(PRG040_BCA1)	; $47
	.byte HIGH(PRG040_BCB6)	; $48
	.byte HIGH(PRG040_BCCA)	; $49
	.byte HIGH(PRG040_BCD3)	; $4A
	.byte HIGH(PRG040_BCD8)	; $4B
	.byte HIGH(PRG040_BCE9)	; $4C
	.byte HIGH(PRG040_BCF6)	; $4D
	.byte HIGH(PRG040_BD04)	; $4E
	.byte HIGH(PRG040_BD1D)	; $4F
	.byte HIGH(PRG040_BD32)	; $50
	.byte HIGH(PRG040_BD43)	; $51
	.byte HIGH(PRG040_BD58)	; $52
	.byte HIGH(PRG040_BD6D)	; $53
	.byte HIGH(PRG040_BD82)	; $54
	.byte HIGH(PRG040_BD9A)	; $55
	.byte HIGH(PRG040_BDAF)	; $56
	.byte HIGH(PRG040_BDB8)	; $57
	.byte HIGH(PRG040_BDC2)	; $58
	.byte HIGH(PRG040_BDC2)	; $59
	.byte HIGH(PRG040_BDC2)	; $5A
	.byte HIGH(PRG040_BDC2)	; $5B
	.byte HIGH(PRG040_BDC2)	; $5C
	.byte HIGH(PRG040_BDC2)	; $5D
	.byte HIGH(PRG040_BDC2)	; $5E
	.byte HIGH(PRG040_BDC2)	; $5F
	.byte HIGH(PRG040_BDC2)	; $60
	.byte HIGH(PRG040_BDC2)	; $61
	.byte HIGH(PRG040_BDC2)	; $62
	.byte HIGH(PRG040_BDC2)	; $63
	.byte HIGH(PRG040_BDC2)	; $64
	.byte HIGH(PRG040_BDC2)	; $65
	.byte HIGH(PRG040_BDC2)	; $66
	.byte HIGH(PRG040_BDC2)	; $67
	.byte HIGH(PRG040_BDC2)	; $68
	.byte HIGH(PRG040_BDC2)	; $69
	.byte HIGH(PRG040_BDC2)	; $6A
	.byte HIGH(PRG040_BDC2)	; $6B
	.byte HIGH(PRG040_BDC2)	; $6C
	.byte HIGH(PRG040_BDC2)	; $6D
	.byte HIGH(PRG040_BDC2)	; $6E
	.byte HIGH(PRG040_BDC2)	; $6F


	; Palette data: 
	; The beginning bytes start getting copied to sprite palettes
	; 2 and 3, and copying ends if $FF is hit OR 8 bytes are copied.
	; (Since $FF at the start is legal, 0 to 8 bytes are copied in any case)
	;
	; After 8 bytes or a terminator...
	;
	; Otherwise follows general PPU data for loading CHR RAM:
	; [BANK][COUNT][AH][VH]
	;
	; [BANK]: 	A bank number (which sets the bank at $8000 to this value and the bank at $A000 to this value+1)
	; [COUNT]:	Number of 256 byte chunks to copy to PPU 
	; [AH]: 	High byte of a ROM address to start loading from ($00 low part assumed)
	; [VH]:		High byte of a VRAM address to start writing to ($00 low part assumed)
	;
	; Repeat until $FF is read! (Immediate termination is legal here too if it's just sprite palette data)


PRG040_B8E0:

	; Sprite palette data
	.byte $0F, $0F, $3A, $19, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte 16				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG016_8000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 10				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9300)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  4				; Number of 256 byte chunks to load
	.byte HIGH(PRG005_A000)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG005_A600)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG005_A700)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_B901:

	; Sprite palette data
	.byte $0F, $20, $16, $29, $0F, $30, $27, $12

	; CHR RAM upload
	.byte 16				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG016_9000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 10				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9300)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG005_BE00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  3				; Number of 256 byte chunks to load
	.byte HIGH(PRG006_8000)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG005_BD00)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_B922:

	; Sprite palette data
	.byte $0F, $0F, $20, $27, $0F, $0F, $30, $16

	; CHR RAM upload
	.byte 16				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG017_A000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 10				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9300)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)

	.byte 28				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG028_8000)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG006_9200)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte 28				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG028_8300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_B943:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $0F, $30, $15

	; CHR RAM upload
	.byte 16				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG017_B000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 10				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9300)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_A800)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_AD00)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG003_B900)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_B964:

	; Sprite palette data
	.byte $0F, $0F, $0F, $0F, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte 18				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG018_8000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 10				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9300)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG008_8600)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG008_8000)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG008_8500)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_B985:

	; Sprite palette data
	.byte $0F, $0F, $20, $27, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte 22				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG022_9000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 10				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9300)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)

	.byte 28				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG028_8000)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_B500)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte 28				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG028_8A00)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_B9A6:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $0F, $20, $27

	; CHR RAM upload
	.byte 22				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG022_8000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 10				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9300)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG009_B500)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG009_B300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG005_BD00)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG006_8300)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG003_BF00)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_B9CF:

	; Sprite palette data
	.byte $0F, $0F, $20, $16, $0F, $0F, $20, $29

	; CHR RAM upload
	.byte 22				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG023_A000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 10				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9300)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG002_9800)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG002_9D00)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG006_8700)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_B9F0:

	; Sprite palette data
	.byte $0F, $0F, $20, $16, $0F, $0F, $20, $2C

	; CHR RAM upload
	.byte 24				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG024_8000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 10				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9300)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_B100)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG006_8700)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BA0D:

	; Sprite palette data
	.byte $0F, $0F, $20, $16, $0F, $0F, $2C, $1C

	; CHR RAM upload
	.byte 26				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG026_9000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 10				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9300)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)

	.byte 28				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG028_8700)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte  3				; Number of 256 byte chunks to load
	.byte HIGH(PRG008_9800)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BA2A:

	; Sprite palette data
	.byte $0F, $0F, $27, $16, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte 22				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG023_B000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 10				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9300)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)

	.byte 28				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG028_8400)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_BC00)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  3				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_BD00)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte 28				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG028_8B00)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BA4F:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $0F, $10, $23

	; CHR RAM upload
	.byte 26				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG026_8000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 10				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9300)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG005_B800)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG005_A600)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BA6C:

	; Sprite palette data
	.byte $0F, $0F, $20, $27, $0F, $0F, $0F, $0F

	; CHR RAM upload
	.byte 18				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG019_A000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 10				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9300)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)

	.byte 28				; ROM Bank to load CHR RAM from
	.byte  4				; Number of 256 byte chunks to load
	.byte HIGH(PRG028_8000)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BA85:

	; Sprite palette data
	.byte $0F, $0F, $20, $16, $0F, $0F, $30, $16

	; CHR RAM upload
	.byte 34				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG034_B800) - $20	; High part of ROM address to copy from [HACK]
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte 34				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG035_B800)	; High part of ROM address to copy from
	.byte $08				; PPU destination address high byte (PT0/BG)

	.byte 34				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG035_BF00)	; High part of ROM address to copy from
	.byte $09				; PPU destination address high byte (PT0/BG)

	.byte 24				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG025_AF00)	; High part of ROM address to copy from
	.byte $0F				; PPU destination address high byte (PT0/BG)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 10				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9300)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG006_9200)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BAAA:

	; Sprite palette data
	.byte $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F

	; CHR RAM upload
	.byte 48				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG048_B800) - $20	; High part of ROM address to copy from [HACK]
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte 48				; ROM Bank to load CHR RAM from
	.byte  7				; Number of 256 byte chunks to load
	.byte HIGH(PRG049_B800)	; High part of ROM address to copy from
	.byte $08				; PPU destination address high byte (PT0/BG)

	.byte 24				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG025_AF00)	; High part of ROM address to copy from
	.byte $0F				; PPU destination address high byte (PT0/BG)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 10				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9300)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BAC7:

	; Sprite palette data
	.byte $0F, $0F, $20, $16, $0F, $0F, $20, $29

	; CHR RAM upload
	.byte 38				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG038_B800) - $20	; High part of ROM address to copy from [HACK]
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte 16				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG017_B800)	; High part of ROM address to copy from
	.byte $08				; PPU destination address high byte (PT0/BG)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte 10				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9300)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_BA00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_BB00)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BAE8:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 18				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG019_B000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9600)	; High part of ROM address to copy from
	.byte $12				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG003_B800)	; High part of ROM address to copy from
	.byte $14				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BAFA:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 20				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG020_8000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9200)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BB04:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 36				; ROM Bank to load CHR RAM from
	.byte  3				; Number of 256 byte chunks to load
	.byte HIGH(PRG037_B800)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BB0A:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte 10				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BB10:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 20				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG021_A000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9800)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BB1A:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)



PRG040_BB1F:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 24				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG024_9000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)



PRG040_BB28:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 20				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG021_A000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9500)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)



PRG040_BB31:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte  6				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_9000)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG003_B400)	; High part of ROM address to copy from
	.byte $18				; PPU destination address high byte (PT1/sprites)



PRG040_BB3A:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte  6				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_9600)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG003_B700)	; High part of ROM address to copy from
	.byte $18				; PPU destination address high byte (PT1/sprites)



PRG040_BB43:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte  4				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_9C00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG001_A000)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG003_B300)	; High part of ROM address to copy from
	.byte $18				; PPU destination address high byte (PT1/sprites)



PRG040_BB50:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte  6				; Number of 256 byte chunks to load
	.byte HIGH(PRG001_A200)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG003_B500)	; High part of ROM address to copy from
	.byte $18				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG003_B600)	; High part of ROM address to copy from
	.byte $15				; PPU destination address high byte (PT1/sprites)



PRG040_BB5D:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8600)	; High part of ROM address to copy from
	.byte $16				; PPU destination address high byte (PT1/sprites)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte  6				; Number of 256 byte chunks to load
	.byte HIGH(PRG001_A800)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)



PRG040_BB66:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG001_AE00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte  4				; Number of 256 byte chunks to load
	.byte HIGH(PRG001_B000)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)



PRG040_BB6F:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG003_B200)	; High part of ROM address to copy from
	.byte $18				; PPU destination address high byte (PT1/sprites)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte  6				; Number of 256 byte chunks to load
	.byte HIGH(PRG001_B400)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)



PRG040_BB78:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte  6				; Number of 256 byte chunks to load
	.byte HIGH(PRG001_BA00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)



PRG040_BB7D:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 16				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG016_8000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)



PRG040_BB82:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 16				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG016_9000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte $FF	; Terminator


PRG040_BB88:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 16				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG017_A000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)



PRG040_BB8D:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 16				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG017_B000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)



PRG040_BB92:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 18				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG018_8000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)



PRG040_BB97:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 22				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG022_9000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)



PRG040_BB9C:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 22				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG022_8000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)



PRG040_BBA1:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 22				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG023_A000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)



PRG040_BBA6:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 24				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG024_8000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)



PRG040_BBAB:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 26				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG026_9000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)



PRG040_BBB0:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 22				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG023_B000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)



PRG040_BBB5:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 26				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG026_8000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)



PRG040_BBBA:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 18				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG019_A000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)



PRG040_BBBF:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 34				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG034_B800) - $20	; High part of ROM address to copy from [HACK]
	.byte $00				; PPU destination address high byte (PT0/BG)



PRG040_BBC4:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 48				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG048_B800) - $20	; High part of ROM address to copy from [HACK]
	.byte $00				; PPU destination address high byte (PT0/BG)



PRG040_BBC9:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 38				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG038_B800) - $20	; High part of ROM address to copy from [HACK]
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte $FF	; Terminator


PRG040_BBCF:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG004_9300)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)



PRG040_BBD4:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8900)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)



PRG040_BBD9:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8A00)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)



PRG040_BBDE:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8B00)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)



PRG040_BBE3:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG003_A900)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)



PRG040_BBE8:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG003_B000)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)



PRG040_BBED:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG003_B100)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)



PRG040_BBF2:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG003_AE00)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)



PRG040_BBF7:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG003_AC00)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)



PRG040_BBFC:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG003_AA00)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)



PRG040_BC01:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG003_AD00)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)



PRG040_BC06:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG003_AB00)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)



PRG040_BC0B:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG003_AF00)	; High part of ROM address to copy from
	.byte $19				; PPU destination address high byte (PT1/sprites)



PRG040_BC10:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 20				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG020_9000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG002_8100)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG002_8300)	; High part of ROM address to copy from
	.byte $11				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG002_8A00)	; High part of ROM address to copy from
	.byte $12				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BC22:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 24				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG025_B000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG002_8300)	; High part of ROM address to copy from
	.byte $11				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG002_8A00)	; High part of ROM address to copy from
	.byte $12				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG002_8D00)	; High part of ROM address to copy from
	.byte $13				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BC34:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 24				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG025_B000)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  5				; Number of 256 byte chunks to load
	.byte HIGH(PRG006_9B00)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BC3E:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 50				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG050_B800) - $20	; High part of ROM address to copy from [HACK]
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte $FF	; Terminator


PRG040_BC44:

	; Sprite palette data
	.byte $0F, $0F, $39, $19, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte  4				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG005_A800)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG005_A400)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BC55:

	; Sprite palette data
	.byte $0F, $0F, $27, $18, $0F, $0F, $20, $11

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG006_9100)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  3				; Number of 256 byte chunks to load
	.byte HIGH(PRG006_9300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BC66:

	; Sprite palette data
	.byte $0F, $0F, $30, $27, $0F, $0F, $30, $15

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_A000)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_AC00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_AF00)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BC7B:

	; Sprite palette data
	.byte $0F, $20, $28, $18, $0F, $0F, $20, $26

	; CHR RAM upload
	.byte 18				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG018_9600)	; High part of ROM address to copy from
	.byte $08				; PPU destination address high byte (PT0/BG)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG008_8600)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG008_8700)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  3				; Number of 256 byte chunks to load
	.byte HIGH(PRG006_9300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BC94:

	; Sprite palette data
	.byte $0F, $0F, $20, $16, $0F, $0F, $0F, $0F

	; CHR RAM upload
	.byte  0				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8E00)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BCA1:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $0F, $20, $27

	; CHR RAM upload
	.byte  8				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG009_B500)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG009_B600)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG005_BD00)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BCB6:

	; Sprite palette data
	.byte $0F, $0F, $20, $26, $0F, $0F, $20, $29

	; CHR RAM upload
	.byte  2				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG002_9D00)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_BA00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_BB00)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)



PRG040_BCCA:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 18				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG018_9600)	; High part of ROM address to copy from
	.byte $08				; PPU destination address high byte (PT0/BG)

	.byte 18				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG018_9E00)	; High part of ROM address to copy from
	.byte $0C				; PPU destination address high byte (PT0/BG)



PRG040_BCD3:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 36				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG037_B800)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)



PRG040_BCD8:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 36				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG037_B800)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte 46				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG046_B800) - $20	; High part of ROM address to copy from [HACK]
	.byte $08				; PPU destination address high byte (PT0/BG)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG005_B000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG002_9000)	; High part of ROM address to copy from
	.byte $18				; PPU destination address high byte (PT1/sprites)



PRG040_BCE9:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 46				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG047_B800)	; High part of ROM address to copy from
	.byte $08				; PPU destination address high byte (PT0/BG)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  7				; Number of 256 byte chunks to load
	.byte HIGH(PRG006_8900)	; High part of ROM address to copy from
	.byte $18				; PPU destination address high byte (PT1/sprites)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)



PRG040_BCF6:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 36				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG037_B800)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_B000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  0				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG000_8E00)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BD04:

	; Sprite palette data
	.byte $0F, $0F, $20, $29, $0F, $0F, $20, $16

	; CHR RAM upload
	.byte 24				; ROM Bank to load CHR RAM from
	.byte  4				; Number of 256 byte chunks to load
	.byte HIGH(PRG025_A800)	; High part of ROM address to copy from
	.byte $0C				; PPU destination address high byte (PT0/BG)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_B300)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  3				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_B700)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte 28				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG028_8A00)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BD1D:

	; Sprite palette data
	.byte $0F, $0F, $0F, $0F, $0F, $0F, $20, $15

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_AC00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_AF00)	; High part of ROM address to copy from
	.byte $1B				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  3				; Number of 256 byte chunks to load
	.byte HIGH(PRG006_9300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BD32:

	; Sprite palette data
	.byte $0F, $0F, $20, $27, $0F, $0F, $30, $16

	; CHR RAM upload
	.byte  8				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG008_8700)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte 28				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG028_8600)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BD43:

	; Sprite palette data
	.byte $0F, $0F, $20, $21, $0F, $0F, $20, $2C

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_A600)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_A700)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG006_8700)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BD58:

	; Sprite palette data
	.byte $0F, $0F, $20, $27, $0F, $0F, $20, $27

	; CHR RAM upload
	.byte 28				; ROM Bank to load CHR RAM from
	.byte  3				; Number of 256 byte chunks to load
	.byte HIGH(PRG028_8000)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG009_B300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte  4				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG005_BD00)	; High part of ROM address to copy from
	.byte $1F				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BD6D:

	; Sprite palette data
	.byte $0F, $0F, $30, $27, $0F, $0F, $30, $15

	; CHR RAM upload
	.byte  6				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_A100)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  3				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_A300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG007_A000)	; High part of ROM address to copy from
	.byte $1C				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


PRG040_BD82:

	; Sprite palette data
	.byte $0F, $0F, $29, $19, $0F, $20, $32, $13

	; CHR RAM upload
	.byte 20				; ROM Bank to load CHR RAM from
	.byte  5				; Number of 256 byte chunks to load
	.byte HIGH(PRG021_B000)	; High part of ROM address to copy from
	.byte $08				; PPU destination address high byte (PT0/BG)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG006_8400)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)

	.byte  6				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG006_8800)	; High part of ROM address to copy from
	.byte $1E				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG008_8300)	; High part of ROM address to copy from
	.byte $1D				; PPU destination address high byte (PT1/sprites)



PRG040_BD9A:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 36				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG037_B800)	; High part of ROM address to copy from
	.byte $00				; PPU destination address high byte (PT0/BG)

	.byte 42				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG042_B800) - $20	; High part of ROM address to copy from [HACK]
	.byte $08				; PPU destination address high byte (PT0/BG)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG008_9000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte  2				; Number of 256 byte chunks to load
	.byte HIGH(PRG008_9B00)	; High part of ROM address to copy from
	.byte $18				; PPU destination address high byte (PT1/sprites)

	.byte  2				; ROM Bank to load CHR RAM from
	.byte  1				; Number of 256 byte chunks to load
	.byte HIGH(PRG002_9A00)	; High part of ROM address to copy from
	.byte $1A				; PPU destination address high byte (PT1/sprites)



PRG040_BDAF:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 42				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG043_B800)	; High part of ROM address to copy from
	.byte $08				; PPU destination address high byte (PT0/BG)

	.byte  8				; ROM Bank to load CHR RAM from
	.byte  9				; Number of 256 byte chunks to load
	.byte HIGH(PRG009_A700)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)



PRG040_BDB8:

	; Sprite palette data
	.byte $FF	; WARNING: CHECK IF THIS TERMINATES THE ^PREVIOUS BLOCK^ BEFORE CHANGING!

	; CHR RAM upload
	.byte 44				; ROM Bank to load CHR RAM from
	.byte  8				; Number of 256 byte chunks to load
	.byte HIGH(PRG044_B800) - $20	; High part of ROM address to copy from [HACK]
	.byte $08				; PPU destination address high byte (PT0/BG)

	.byte 28				; ROM Bank to load CHR RAM from
	.byte 16				; Number of 256 byte chunks to load
	.byte HIGH(PRG028_9000)	; High part of ROM address to copy from
	.byte $10				; PPU destination address high byte (PT1/sprites)

	.byte $FF	; Terminator


	; UNUSED AND TECHNICALLY INVALID (would need a second $FF to be an empty set)
PRG040_BDC2:
	.byte $FF
	
	; CHECKME - UNUSED?
	.byte $90, $10, $FF, $FF, $90, $5E, $55, $D7, $55, $8B, $D5, $BB, $55, $59, $54	; $BDC2 - $BDD1
	.byte $7F, $55, $F9, $44, $F5, $51, $FD, $55, $FB, $05, $7D, $41, $ED, $55, $F6, $57	; $BDD2 - $BDE1
	.byte $FD, $10, $FA, $01, $D9, $45, $9F, $50, $DF, $5C, $FF, $54, $7A, $15, $7E, $11	; $BDE2 - $BDF1
	.byte $34, $50, $FF, $65, $8A, $05, $9E, $15, $FB, $55, $5D, $10, $3F, $11, $EF, $14	; $BDF2 - $BE01
	.byte $B1, $44, $DF, $15, $AF, $14, $FF, $55, $FC, $44, $C5, $55, $FF, $15, $FC, $55	; $BE02 - $BE11
	.byte $FF, $75, $B6, $91, $FD, $00, $FF, $05, $FF, $15, $1D, $15, $F9, $45, $BF, $57	; $BE12 - $BE21
	.byte $FF, $75, $E3, $55, $FF, $51, $3F, $75, $B7, $55, $B9, $11, $36, $4D, $77, $11	; $BE22 - $BE31
	.byte $DD, $04, $3F, $20, $79, $54, $FF, $55, $9F, $55, $FB, $41, $C6, $C6, $9F, $41	; $BE32 - $BE41
	.byte $FF, $45, $5E, $55, $B6, $75, $F7, $C4, $2D, $54, $FF, $51, $D7, $53, $BF, $75	; $BE42 - $BE51
	.byte $5F, $51, $3F, $91, $3B, $51, $6F, $55, $BE, $17, $FD, $74, $FF, $55, $DF, $45	; $BE52 - $BE61
	.byte $FD, $11, $6F, $57, $EF, $5C, $DF, $55, $DF, $41, $FD, $47, $FB, $55, $7F, $04	; $BE62 - $BE71
	.byte $1F, $51, $7A, $1D, $FF, $45, $FB, $15, $F7, $55, $F9, $55, $CE, $D5, $DE, $1D	; $BE72 - $BE81
	.byte $F5, $15, $F7, $41, $FD, $45, $FF, $11, $ED, $55, $E3, $50, $FE, $00, $FD, $55	; $BE82 - $BE91
	.byte $3A, $45, $FF, $45, $29, $51, $F2, $51, $53, $25, $6F, $51, $F8, $50, $FC, $51	; $BE92 - $BEA1
	.byte $F6, $54, $BE, $05, $BF, $55, $F9, $3D, $77, $55, $BD, $55, $C9, $51, $DC, $51	; $BEA2 - $BEB1
	.byte $7F, $55, $FE, $55, $FD, $44, $7D, $D5, $D3, $40, $F5, $45, $9A, $46, $F7, $55	; $BEB2 - $BEC1
	.byte $9F, $94, $7D, $11, $BB, $15, $F7, $55, $EB, $55, $AD, $75, $FD, $55, $BE, $55	; $BEC2 - $BED1
	.byte $DE, $01, $3F, $44, $ED, $51, $87, $55, $FF, $05, $5B, $14, $DF, $91, $CF, $45	; $BED2 - $BEE1
	.byte $EB, $51, $FF, $45, $BF, $11, $FF, $55, $EF, $51, $F1, $14, $AB, $15, $DD, $05	; $BEE2 - $BEF1
	.byte $4F, $51, $E9, $55, $FF, $15, $1C, $41, $A2, $51, $CF, $51, $E8, $45, $FF, $11	; $BEF2 - $BF01
	.byte $CC, $55, $3F, $14, $3F, $54, $45, $51, $9F, $15, $FF, $55, $FB, $14, $FE, $15	; $BF02 - $BF11
	.byte $D0, $54, $5B, $51, $EB, $54, $B2, $94, $B6, $45, $19, $51, $FB, $14, $F6, $41	; $BF12 - $BF21
	.byte $F8, $57, $EF, $11, $FB, $55, $DF, $5D, $DF, $04, $FF, $75, $DF, $45, $3F, $55	; $BF22 - $BF31
	.byte $8F, $5D, $DF, $45, $FF, $D1, $FF, $54, $9B, $54, $6F, $74, $9B, $54, $FD, $5D	; $BF32 - $BF41
	.byte $DD, $11, $EF, $51, $DC, $54, $6E, $54, $EB, $54, $FD, $D9, $FF, $65, $57, $44	; $BF42 - $BF51
	.byte $5E, $55, $8F, $05, $FF, $14, $FF, $70, $AF, $B4, $93, $44, $AC, $D5, $FD, $55	; $BF52 - $BF61
	.byte $FD, $15, $BF, $55, $FF, $44, $97, $95, $7F, $55, $BF, $D5, $EF, $14, $57, $45	; $BF62 - $BF71
	.byte $7F, $09, $98, $5F, $BA, $15, $BE, $14, $5F, $55, $BB, $55, $FB, $54, $CF, $51	; $BF72 - $BF81
	.byte $FB, $D0, $FB, $51, $5E, $55, $B7, $14, $DA, $55, $FB, $55, $A7, $11, $CB, $51	; $BF82 - $BF91
	.byte $BE, $11, $F7, $55, $5E, $50, $A4, $51, $7B, $97, $65, $44, $5C, $46, $FF, $51	; $BF92 - $BFA1
	.byte $F5, $35, $7A, $01, $EF, $45, $53, $D7, $DF, $51, $DF, $55, $D3, $15, $BF, $55	; $BFA2 - $BFB1
	.byte $1A, $46, $E7, $45, $FB, $D5, $4F, $44, $AD, $51, $DF, $40, $C7, $05, $EE, $05	; $BFB2 - $BFC1
	.byte $FF, $45, $BF, $55, $EF, $11, $1F, $51, $FF, $55, $7F, $C0, $BE, $55, $66, $15	; $BFC2 - $BFD1
	.byte $FF, $1C, $FF, $05, $FD, $45, $A7, $15, $97, $04, $BA, $05, $47, $55, $FE, $14	; $BFD2 - $BFE1
	.byte $D3, $11, $F0, $55, $BD, $15, $D1, $55, $FF, $54, $6C, $C5, $E7, $54, $B5, $44	; $BFE2 - $BFF1
	.byte $FB, $34, $B3, $55, $FE, $05, $FB, $15, $AB, $51, $A2, $11, $00, $FF	; $BFF2 - $BFFF


