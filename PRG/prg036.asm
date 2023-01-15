	; Standard tilemap data; see format.txt in TMAPDATA for what this is comprised of.
	.incbin "PRG/TMAPDATA/TMAP04.bin"
	
	; Player Weapon Damage table for Toad Rain
	.org Player_WeaponDamageTable	; <-- help enforce this table *here*
PRG036_ToadRainDamageTable:	
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
	.byte $04	; $14 SPRSLOTID_SASOREENU
	.byte $00	; $15 SPRSLOTID_SASOREENU_SPAWNER
	.byte $00	; $16 SPRSLOTID_BATTAN
	.byte $00	; $17
	.byte $02	; $18 SPRSLOTID_SWALLOWN
	.byte $01	; $19 SPRSLOTID_COSWALLOWN
	.byte $05	; $1A SPRSLOTID_WALLBLASTER
	.byte $00	; $1B SPRSLOTID_WALLBLASTER_SHOT
	.byte $01	; $1C SPRSLOTID_100WATTON
	.byte $02	; $1D SPRSLOTID_100WATTON_SHOT
	.byte $00	; $1E SPRSLOTID_100WATTON_SHOT_BURST
	.byte $02	; $1F SPRSLOTID_RATTON
	.byte $00	; $20 SPRSLOTID_RMRAINBOW_CTL1
	.byte $00	; $21 SPRSLOTID_RMRAINBOW_CTL2
	.byte $00	; $22 SPRSLOTID_RMRAINBOW_CTL3
	.byte $00	; $23 SPRSLOTID_RMRAINBOW_CTL4
	.byte $03	; $24 SPRSLOTID_SUBBOSS_KABATONCUE
	.byte $01	; $25 SPRSLOTID_KABATONCUE_MISSILE
	.byte $00	; $26 SPRSLOTID_RINGMAN_UNK2
	.byte $01	; $27 SPRSLOTID_WILY_ESCAPEPOD
	.byte $00	; $28 SPRSLOTID_BOMBABLE_WALL
	.byte $00	; $29 SPRSLOTID_MOTHRAYA_DIE
	.byte $00	; $2A SPRSLOTID_POWERGAIN_ORBS
	.byte $00	; $2B SPRSLOTID_SUBBOSS_ESCAROO
	.byte $00	; $2C SPRSLOTID_ESCAROO_BOMB
	.byte $00	; $2D SPRSLOTID_ESCAROO_DIE
	.byte $00	; $2E SPRSLOTID_EXPLODEYBIT
	.byte $00	; $2F SPRSLOTID_RED_UTRACK_PLAT
	.byte $04	; $30 SPRSLOTID_SUBBOSS_WHOPPER
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
	.byte $02	; $3D SPRSLOTID_MINOAN
	.byte $04	; $3E SPRSLOTID_SUPERBALLMACHJR_L
	.byte $01	; $3F SPRSLOTID_SUPERBALLMACHJR_B
	.byte $00	; $40 SPRSLOTID_BOULDER_DISPENSER
	.byte $01	; $41 SPRSLOTID_BOULDER_DEBRIS
	.byte $00	; $42 SPRSLOTID_EDDIE
	.byte $00	; $43 SPRSLOTID_EDDIE_IMMEDIATE
	.byte $00	; $44 SPRSLOTID_EDDIE_ITEM_EJECT
	.byte $03	; $45 SPRSLOTID_CRPLATFORM_FALL
	.byte $04	; $46 SPRSLOTID_JUMPBIG
	.byte $00	; $47
	.byte $04	; $48 SPRSLOTID_SHIELDATTACKER
	.byte $04	; $49 SPRSLOTID_COSSACK3BOSS1_DIE
	.byte $00	; $4A SPRSLOTID_COSSACK3BOSS2_DIE
	.byte $00	; $4B SPRSLOTID_KABATONCUE_DIE
	.byte $00	; $4C SPRSLOTID_100WATTON_DIE
	.byte $00	; $4D SPRSLOTID_WILYCAPSULE_CHRG
	.byte $08	; $4E SPRSLOTID_TOTEMPOLEN
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
	.byte $02	; $61 SPRSLOTID_PUYOYON
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
	.byte $02	; $71 SPRSLOTID_BOSSSKULL
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
	.byte $00	; $7D SPRSLOTID_BOSSDIVE_MISSILE
	.byte $01	; $7E SPRSLOTID_BOSSDRILL
	.byte $00	; $7F SPRSLOTID_DRILLMAN_DRILL
	.byte $00	; $80 SPRSLOTID_MISCSTUFF
	.byte $01	; $81 SPRSLOTID_BOSSINTRO
	.byte $00	; $82 SPRSLOTID_DRILLMAN_POOF
	.byte $00	; $83 SPRSLOTID_SPIRALEXPLOSION
	.byte $02	; $84 SPRSLOTID_BOSSPHARAOH
	.byte $00	; $85 SPRSLOTID_PHARAOHMAN_ATTACK
	.byte $00	; $86 SPRSLOTID_PHARAOHMAN_SATTACK
	.byte $00	; $87 SPRSLOTID_BOSS_MOTHRAYA
	.byte $00	; $88 SPRSLOTID_COSSACK1_UNK1
	.byte $00	; $89 SPRSLOTID_COSSACK1_UNK2
	.byte $00	; $8A SPRSLOTID_MOTHRAYA_SHOT
	.byte $04	; $8B SPRSLOTID_BOSSBRIGHT
	.byte $00	; $8C SPRSLOTID_BOSSBRIGHT_BULLET
	.byte $01	; $8D SPRSLOTID_BOSSTOAD
	.byte $02	; $8E SPRSLOTID_BATTONTON
	.byte $00	; $8F SPRSLOTID_MOTHRAYA_DEBRIS
	.byte $00	; $90 SPRSLOTID_EXPLODEY_DEATH
	.byte $02	; $91 SPRSLOTID_MANTAN
	.byte $00	; $92 SPRSLOTID_BOSS_COSSACKCATCH
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
	.byte $00	; $9E SPRSLOTID_COSSACK3BOSS1
	.byte $00	; $9F SPRSLOTID_COSSACK3BOSS2_SHOT
	.byte $00	; $A0 SPRSLOTID_COSSACK3BOSS1_SHOT
	.byte $03	; $A1 SPRSLOTID_MONOROADER
	.byte $00	; $A2 SPRSLOTID_COSSACK3BOSS2
	.byte $00	; $A3 SPRSLOTID_KALINKA
	.byte $00	; $A4 SPRSLOTID_PROTOMAN
	.byte $00	; $A5 SPRSLOTID_WILY
	.byte $00	; $A6 SPRSLOTID_BOSS_METALLDADDY
	.byte $04	; $A7 SPRSLOTID_GACHAPPON
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
	.byte $00	; $B2 SPRSLOTID_UPNDOWN
	.byte $00	; $B3 SPRSLOTID_WILYTRANSPORTER
	.byte $00	; $B4 SPRSLOTID_UPNDOWN_SPAWNER
	.byte $00	; $B5 SPRSLOTID_SPIKEBLOCK_1
	.byte $00	; $B6 SPRSLOTID_SEAMINE
	.byte $01	; $B7 SPRSLOTID_GARYOBY
	.byte $00	; $B8 SPRSLOTID_BOSS_ROBOTMASTER
	.byte $04	; $B9 SPRSLOTID_DOCRON
	.byte $01	; $BA SPRSLOTID_DOCRON_SKULL
	.byte $00	; $BB SPRSLOTID_WILY3_UNK1
	.byte $00	; $BC SPRSLOTID_BOSS_WILYMACHINE4
	.byte $00	; $BD SPRSLOTID_TOGEHERO_SPAWNER_R
	.byte $01	; $BE SPRSLOTID_TOGEHERO
	.byte $00	; $BF SPRSLOTID_WILYMACHINE4_SHOTCH
	.byte $00	; $C0 SPRSLOTID_WILYMACHINE4_PHASE2
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


	; CHECKME - UNUSED?
	.byte $00, $00, $00, $00, $00, $00, $00	; $B7C7 - $B7D6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B7D7 - $B7E6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B7E7 - $B7F6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B7F7 - $B806
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $7C, $C6, $C6, $C6, $FE, $C6, $C6	; $B807 - $B816
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $FC, $C6, $C6, $C6, $C6, $C6, $FC	; $B817 - $B826
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $CC, $CC, $78, $30, $78, $CC, $CC	; $B827 - $B836
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $B0, $F0, $C6, $C6	; $B837 - $B846
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $7C, $C6, $C6, $C6, $C6, $C6, $7C	; $B847 - $B856
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $7C, $C6, $06, $3C, $60, $C0, $FE	; $B857 - $B866
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $7C, $C6, $06, $3C, $06, $C6, $7C	; $B867 - $B876
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $7C, $C6, $C6, $7C, $C6, $C6, $7C	; $B877 - $B886
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $06, $0E, $0E, $1C, $18, $00, $60	; $B887 - $B896
	.byte $60, $00, $00, $00, $00, $00, $00, $00, $00, $FC, $84, $BC, $A0, $A0, $E0, $00	; $B897 - $B8A6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $FE, $7C, $38, $10, $00	; $B8A7 - $B8B6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02, $04, $08, $38, $48, $08	; $B8B7 - $B8C6
	.byte $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $7E, $12, $12, $22, $22	; $B8C7 - $B8D6
	.byte $4C, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7C, $44, $84, $04, $04, $08	; $B8D7 - $B8E6
	.byte $30, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7E, $02, $02, $02, $02, $7E	; $B8E7 - $B8F6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $24, $FE, $24, $24, $04, $08, $30	; $B8F7 - $B906
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $FC, $08, $10, $28, $44, $82	; $B907 - $B916
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $42, $22, $22, $04, $08, $70	; $B917 - $B926
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $20, $3E, $22, $5A, $04, $08, $30	; $B927 - $B936
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $20, $20, $20, $38, $24, $20	; $B937 - $B946
	.byte $20, $00, $00, $00, $00, $00, $00, $00, $00, $08, $08, $FE, $08, $08, $10, $60	; $B947 - $B956
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7C, $00, $00, $00, $FE	; $B957 - $B966
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $08, $44, $44, $42, $82, $02	; $B967 - $B976
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $FC, $04, $04, $04, $08, $70	; $B977 - $B986
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $FE, $10, $54, $52, $92	; $B987 - $B996
	.byte $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $FC, $04, $04, $08, $50, $20	; $B997 - $B9A6
	.byte $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7E, $00, $7E, $02, $02, $04	; $B9A7 - $B9B6
	.byte $38, $00, $00, $00, $00, $00, $00, $00, $00, $00, $44, $44, $44, $44, $04, $08	; $B9B7 - $B9C6
	.byte $30, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $50, $50, $50, $50, $52	; $B9C7 - $B9D6
	.byte $9C, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $FC, $84, $84, $84, $84	; $B9D7 - $B9E6
	.byte $FC, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7E, $42, $42, $42, $02, $04	; $B9E7 - $B9F6
	.byte $18, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $E4, $04, $04, $04, $08	; $B9F7 - $BA06
	.byte $F0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $90, $D8, $48, $00, $00, $00	; $BA07 - $BA16
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $60, $90, $90, $60, $00, $00, $00	; $BA17 - $BA26
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $54, $54, $04	; $BA27 - $BA36
	.byte $38, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $38, $08, $08	; $BA37 - $BA46
	.byte $7C, $00, $00, $00, $00, $00, $00, $00, $00, $0A, $1F, $44, $1F, $44, $5B, $60	; $BA47 - $BA56
	.byte $1F, $00, $00, $00, $00, $00, $00, $00, $00, $30, $2E, $64, $98, $26, $DD, $24	; $BA57 - $BA66
	.byte $3C, $00, $00, $00, $00, $00, $00, $00, $00, $44, $54, $FF, $55, $55, $73, $50	; $BA67 - $BA76
	.byte $9F, $00, $00, $00, $00, $00, $00, $00, $00, $52, $52, $FF, $52, $52, $5E, $40	; $BA77 - $BA86
	.byte $7F, $00, $00, $00, $00, $00, $00, $00, $00, $FE, $92, $FE, $92, $FE, $44, $AA	; $BA87 - $BA96
	.byte $69, $00, $00, $00, $00, $00, $00, $00, $00, $28, $28, $7E, $88, $3E, $08, $08	; $BA97 - $BAA6
	.byte $7F, $00, $00, $00, $00, $00, $00, $00, $00, $18, $FF, $81, $04, $FF, $24, $24	; $BAA7 - $BAB6
	.byte $0C, $00, $00, $00, $00, $00, $00, $00, $00, $7C, $60, $7C, $70, $FF, $4A, $4C	; $BAB7 - $BAC6
	.byte $63, $00, $00, $00, $00, $00, $00, $00, $00, $28, $2F, $2C, $47, $64, $A7, $24	; $BAC7 - $BAD6
	.byte $24, $00, $00, $00, $00, $00, $00, $00, $00, $08, $2A, $2A, $3E, $08, $48, $49	; $BAD7 - $BAE6
	.byte $7F, $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $7E, $24, $24, $24, $24	; $BAE7 - $BAF6
	.byte $7E, $00, $00, $00, $00, $00, $00, $00, $00, $20, $FC, $20, $7C, $AA, $AA, $92	; $BAF7 - $BB06
	.byte $64, $00, $00, $00, $00, $00, $00, $00, $00, $00, $84, $82, $82, $82, $82, $A0	; $BB07 - $BB16
	.byte $40, $00, $00, $00, $00, $00, $00, $00, $00, $38, $00, $38, $44, $04, $04, $08	; $BB17 - $BB26
	.byte $30, $00, $00, $00, $00, $00, $00, $00, $00, $20, $10, $FC, $08, $30, $60, $52	; $BB27 - $BB36
	.byte $8C, $00, $00, $00, $00, $00, $00, $00, $00, $20, $FA, $22, $38, $64, $A2, $A2	; $BB37 - $BB46
	.byte $44, $00, $00, $00, $00, $00, $00, $00, $00, $40, $44, $F2, $4A, $4A, $48, $C8	; $BB47 - $BB56
	.byte $98, $00, $00, $00, $00, $00, $00, $00, $00, $10, $7C, $10, $7E, $08, $3C, $40	; $BB57 - $BB66
	.byte $3C, $00, $00, $00, $00, $00, $00, $00, $00, $08, $08, $10, $20, $60, $10, $08	; $BB67 - $BB76
	.byte $0C, $00, $00, $00, $00, $00, $00, $00, $00, $04, $84, $BE, $84, $84, $84, $C4	; $BB77 - $BB86
	.byte $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7C, $06, $04, $00, $00, $40	; $BB87 - $BB96
	.byte $3E, $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $7E, $08, $3C, $44, $40	; $BB97 - $BBA6
	.byte $38, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $40, $40, $42, $44	; $BBA7 - $BBB6
	.byte $38, $00, $00, $00, $00, $00, $00, $00, $00, $08, $FE, $08, $38, $48, $38, $08	; $BBB7 - $BBC6
	.byte $10, $00, $00, $00, $00, $00, $00, $00, $00, $44, $44, $FE, $44, $48, $40, $60	; $BBC7 - $BBD6
	.byte $3C, $00, $00, $00, $00, $00, $00, $00, $00, $44, $28, $10, $FE, $08, $30, $20	; $BBD7 - $BBE6
	.byte $1C, $00, $00, $00, $00, $00, $00, $00, $00, $20, $20, $FC, $20, $2E, $40, $50	; $BBE7 - $BBF6
	.byte $9E, $00, $00, $00, $00, $00, $00, $00, $00, $20, $20, $FC, $40, $7C, $E2, $02	; $BBF7 - $BC06
	.byte $3C, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3C, $E2, $02, $02, $04	; $BC07 - $BC16
	.byte $18, $00, $00, $00, $00, $00, $00, $00, $00, $00, $FE, $0C, $10, $20, $20, $10	; $BC17 - $BC26
	.byte $0C, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $4C, $70, $40, $80, $80	; $BC27 - $BC36
	.byte $7C, $00, $00, $00, $00, $00, $00, $00, $00, $20, $2C, $F2, $48, $88, $38, $4C	; $BC37 - $BC46
	.byte $38, $00, $00, $00, $00, $00, $00, $00, $00, $00, $60, $4E, $40, $40, $40, $50	; $BC47 - $BC56
	.byte $6E, $00, $00, $00, $00, $00, $00, $00, $00, $00, $48, $48, $7C, $CA, $AA, $B7	; $BC57 - $BC66
	.byte $56, $00, $00, $00, $00, $00, $00, $00, $00, $40, $4C, $F2, $62, $E2, $CC, $4E	; $BC67 - $BC76
	.byte $44, $00, $00, $00, $00, $00, $00, $00, $00, $00, $38, $54, $92, $92, $92, $92	; $BC77 - $BC86
	.byte $64, $00, $00, $00, $00, $00, $00, $00, $00, $04, $C4, $9E, $84, $84, $9C, $A4	; $BC87 - $BC96
	.byte $5A, $00, $00, $00, $00, $00, $00, $00, $00, $00, $F0, $24, $66, $45, $44, $4C	; $BC97 - $BCA6
	.byte $38, $00, $00, $00, $00, $00, $00, $00, $00, $10, $08, $08, $10, $4A, $49, $89	; $BCA7 - $BCB6
	.byte $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $30, $48, $84, $02, $01	; $BCB7 - $BCC6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $5E, $84, $84, $9E, $84, $9C, $A4	; $BCC7 - $BCD6
	.byte $5A, $00, $00, $00, $00, $00, $00, $00, $00, $10, $FC, $10, $7C, $10, $70, $98	; $BCD7 - $BCE6
	.byte $64, $00, $00, $00, $00, $00, $00, $00, $00, $00, $E0, $24, $24, $7C, $A6, $A4	; $BCE7 - $BCF6
	.byte $48, $00, $00, $00, $00, $00, $00, $00, $00, $20, $20, $F2, $21, $60, $A2, $62	; $BCF7 - $BD06
	.byte $1C, $00, $00, $00, $00, $00, $00, $00, $00, $00, $48, $48, $7C, $AA, $AA, $92	; $BD07 - $BD16
	.byte $64, $00, $00, $00, $00, $00, $00, $00, $00, $20, $20, $F8, $20, $F8, $22, $22	; $BD17 - $BD26
	.byte $1C, $00, $00, $00, $00, $00, $00, $00, $00, $40, $68, $3C, $EA, $2A, $24, $30	; $BD27 - $BD36
	.byte $10, $00, $00, $00, $00, $00, $00, $00, $00, $08, $88, $BC, $EA, $CA, $CA, $94	; $BD37 - $BD46
	.byte $10, $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $1E, $10, $70, $98, $98	; $BD47 - $BD56
	.byte $64, $00, $00, $00, $00, $00, $00, $00, $00, $00, $58, $4C, $C0, $F8, $84, $04	; $BD57 - $BD66
	.byte $78, $00, $00, $00, $00, $00, $00, $00, $00, $20, $44, $44, $44, $64, $04, $08	; $BD67 - $BD76
	.byte $10, $00, $00, $00, $00, $00, $00, $00, $00, $FC, $08, $10, $78, $04, $E4, $A4	; $BD77 - $BD86
	.byte $78, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $EC, $54, $64, $C4, $C4	; $BD87 - $BD96
	.byte $42, $00, $00, $00, $00, $00, $00, $00, $00, $7E, $04, $08, $3C, $02, $02, $42	; $BD97 - $BDA6
	.byte $3C, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $EC, $52, $E2, $C2, $C2	; $BDA7 - $BDB6
	.byte $44, $00, $00, $00, $00, $00, $00, $00, $00, $10, $FE, $20, $3C, $28, $48, $40	; $BDB7 - $BDC6
	.byte $3E, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $20, $70, $48, $C8	; $BDC7 - $BDD6
	.byte $8E, $00, $00, $00, $00, $00, $00, $00, $00, $20, $90, $40, $00, $00, $00, $00	; $BDD7 - $BDE6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40	; $BDE7 - $BDF6
	.byte $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $38, $04	; $BDF7 - $BE06
	.byte $18, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $18, $10, $38, $54	; $BE07 - $BE16
	.byte $30, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $20, $50	; $BE17 - $BE26
	.byte $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $18, $18, $00	; $BE27 - $BE36
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7C, $10, $10, $10, $10, $FE	; $BE37 - $BE46
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $54, $FE, $82, $BA, $10, $FE, $10	; $BE47 - $BE56
	.byte $30, $00, $00, $00, $00, $00, $00, $00, $00, $00, $FE, $92, $FE, $92, $FE, $92	; $BE57 - $BE66
	.byte $96, $00, $00, $00, $00, $00, $00, $00, $00, $00, $FE, $54, $54, $54, $FE, $10	; $BE67 - $BE76
	.byte $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $70, $2E, $FA, $2A, $7E, $A8	; $BE77 - $BE86
	.byte $20, $00, $00, $00, $00, $00, $00, $00, $00, $10, $FE, $92, $92, $92, $FE, $10	; $BE87 - $BE96
	.byte $10, $00, $00, $00, $00, $00, $00, $00, $00, $20, $29, $4A, $CC, $48, $48, $49	; $BE97 - $BEA6
	.byte $47, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7F, $08, $3E, $08, $14, $22	; $BEA7 - $BEB6
	.byte $41, $00, $00, $00, $00, $00, $00, $00, $00, $08, $08, $7E, $08, $0C, $38, $48	; $BEB7 - $BEC6
	.byte $18, $00, $00, $00, $00, $00, $00, $00, $00, $72, $2A, $F2, $2A, $72, $AE, $22	; $BEC7 - $BED6
	.byte $22, $00, $00, $00, $00, $00, $00, $00, $00, $12, $7C, $18, $FE, $20, $5C, $94	; $BED7 - $BEE6
	.byte $1C, $00, $00, $00, $00, $00, $00, $00, $00, $10, $7C, $44, $7C, $44, $7C, $44	; $BEE7 - $BEF6
	.byte $7C, $00, $00, $00, $00, $00, $00, $00, $00, $00, $E8, $2F, $E2, $8A, $84, $A6	; $BEF7 - $BF06
	.byte $E9, $00, $00, $00, $00, $00, $00, $00, $00, $24, $BF, $24, $9F, $80, $9E, $52	; $BF07 - $BF16
	.byte $3F, $00, $00, $00, $00, $00, $00, $00, $00, $F7, $A9, $AA, $F7, $21, $72, $22	; $BF17 - $BF26
	.byte $72, $00, $00, $00, $00, $00, $00, $00, $00, $27, $7D, $22, $36, $08, $3E, $08	; $BF27 - $BF36
	.byte $7F, $00, $00, $00, $00, $00, $00, $00, $00, $00, $EE, $AA, $CE, $AA, $EE, $8A	; $BF37 - $BF46
	.byte $9F, $00, $00, $00, $00, $00, $00, $00, $00, $08, $08, $08, $0E, $48, $48, $48	; $BF47 - $BF56
	.byte $FF, $00, $00, $00, $00, $00, $00, $00, $00, $00, $24, $3F, $44, $4E, $D5, $6E	; $BF57 - $BF66
	.byte $44, $00, $00, $00, $00, $00, $00, $00, $00, $44, $55, $EE, $44, $6E, $D5, $44	; $BF67 - $BF76
	.byte $DB, $00, $00, $00, $00, $00, $00, $00, $00, $54, $05, $74, $5F, $74, $25, $72	; $BF77 - $BF86
	.byte $25, $00, $00, $00, $00, $00, $00, $00, $00, $3E, $08, $3E, $2A, $3E, $2A, $7F	; $BF87 - $BF96
	.byte $22, $00, $00, $00, $00, $00, $00, $00, $00, $40, $7E, $C8, $3C, $28, $FF, $08	; $BF97 - $BFA6
	.byte $08, $00, $00, $00, $00, $00, $00, $00, $00, $08, $7F, $54, $7F, $40, $52, $8C	; $BFA7 - $BFB6
	.byte $B3, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $FC, $00, $00	; $BFB7 - $BFC6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7E, $42, $42, $42, $42, $7E	; $BFC7 - $BFD6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7E, $42, $42, $42, $42, $7E	; $BFD7 - $BFE6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7E, $42, $42, $42, $42, $7E	; $BFE7 - $BFF6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BFF7 - $BFFF


