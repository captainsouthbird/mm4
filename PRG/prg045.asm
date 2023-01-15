	; Standard tilemap data; see format.txt in TMAPDATA for what this is comprised of.
	.incbin "PRG/TMAPDATA/TMAP0D.bin"
	
	; Player Weapon Damage table for Skull Barrier
	; NOTE: $FF is used as instant removal (i.e. for projectiles)
	.org Player_WeaponDamageTable	; <-- help enforce this table *here*
PRG045_SkullBarrierDamageTable:	
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
	.byte $FF	; $1B SPRSLOTID_WALLBLASTER_SHOT
	.byte $01	; $1C SPRSLOTID_100WATTON
	.byte $02	; $1D SPRSLOTID_100WATTON_SHOT
	.byte $FF	; $1E SPRSLOTID_100WATTON_SHOT_BURST
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
	.byte $01	; $2B SPRSLOTID_SUBBOSS_ESCAROO
	.byte $01	; $2C SPRSLOTID_ESCAROO_BOMB
	.byte $00	; $2D SPRSLOTID_ESCAROO_DIE
	.byte $00	; $2E SPRSLOTID_EXPLODEYBIT
	.byte $00	; $2F SPRSLOTID_RED_UTRACK_PLAT
	.byte $01	; $30 SPRSLOTID_SUBBOSS_WHOPPER
	.byte $00	; $31 SPRSLOTID_SUBBOSS_WHOPPER_RING
	.byte $00	; $32 SPRSLOTID_SUBBOSS_WHOPPER_RIN2
	.byte $01	; $33 SPRSLOTID_HAEHAEY
	.byte $FF	; $34 SPRSLOTID_HAEHAEY_SHOT
	.byte $04	; $35 SPRSLOTID_RACKASER
	.byte $01	; $36 SPRSLOTID_RACKASER_UMBRELLA
	.byte $01	; $37 SPRSLOTID_DOMPAN
	.byte $00	; $38 SPRSLOTID_DOMPAN_FIREWORKS
	.byte $FF	; $39 SPRSLOTID_CIRCLEBULLET
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
	.byte $03	; $45 SPRSLOTID_CRPLATFORM_FALL
	.byte $01	; $46 SPRSLOTID_JUMPBIG
	.byte $00	; $47
	.byte $04	; $48 SPRSLOTID_SHIELDATTACKER
	.byte $04	; $49 SPRSLOTID_COSSACK3BOSS1_DIE
	.byte $00	; $4A SPRSLOTID_COSSACK3BOSS2_DIE
	.byte $00	; $4B SPRSLOTID_KABATONCUE_DIE
	.byte $00	; $4C SPRSLOTID_100WATTON_DIE
	.byte $00	; $4D SPRSLOTID_WILYCAPSULE_CHRG
	.byte $01	; $4E SPRSLOTID_TOTEMPOLEN
	.byte $FF	; $4F SPRSLOTID_TOTEMPOLEN_SHOT
	.byte $01	; $50 SPRSLOTID_METALL_1
	.byte $00	; $51 SPRSLOTID_METALL_BULLET
	.byte $01	; $52 SPRSLOTID_SUBBOSS_MOBY
	.byte $FF	; $53 SPRSLOTID_MOBY_MISSILE
	.byte $FF	; $54 SPRSLOTID_MOBY_BIGSPIKE
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
	.byte $FF	; $63 SPRSLOTID_SKELETONJOE_BONE
	.byte $01	; $64 SPRSLOTID_RINGRING
	.byte $01	; $65 SPRSLOTID_METALL_4
	.byte $00	; $66 SPRSLOTID_METALL_4_BUBBLE
	.byte $00	; $67 SPRSLOTID_WILY1_UNK1
	.byte $01	; $68 SPRSLOTID_UNK68
	.byte $01	; $69 SPRSLOTID_SKULLMET_R
	.byte $FF	; $6A SPRSLOTID_SKULLMET_BULLET
	.byte $00	; $6B SPRSLOTID_DIVEMAN_BIDIW1
	.byte $00	; $6C SPRSLOTID_DIVEMAN_BIDIW2
	.byte $01	; $6D SPRSLOTID_HELIPON
	.byte $FF	; $6E SPRSLOTID_HELIPON_BULLET
	.byte $00	; $6F SPRSLOTID_WATERSPLASH
	.byte $01	; $70 SPRSLOTID_GYOTOT
	.byte $01	; $71 SPRSLOTID_BOSSSKULL
	.byte $FF	; $72 SPRSLOTID_SKULLMAN_BULLET
	.byte $00	; $73 SPRSLOTID_DUSTMAN_4PLAT
	.byte $00	; $74 SPRSLOTID_DUSTMAN_PLATSEG
	.byte $01	; $75 SPRSLOTID_BOSSRING
	.byte $FF	; $76 SPRSLOTID_RINGMAN_RING
	.byte $00	; $77 SPRSLOTID_BOSSDEATH
	.byte $00	; $78 SPRSLOTID_BIREE1
	.byte $01	; $79 SPRSLOTID_BOSSDUST
	.byte $FF	; $7A SPRSLOTID_DUSTMAN_DUSTCRUSHER
	.byte $FF	; $7B SPRSLOTID_DUSTMAN_DUSTDEBRIS
	.byte $04	; $7C SPRSLOTID_BOSSDIVE
	.byte $FF	; $7D SPRSLOTID_BOSSDIVE_MISSILE
	.byte $01	; $7E SPRSLOTID_BOSSDRILL
	.byte $00	; $7F SPRSLOTID_DRILLMAN_DRILL
	.byte $00	; $80 SPRSLOTID_MISCSTUFF
	.byte $01	; $81 SPRSLOTID_BOSSINTRO
	.byte $00	; $82 SPRSLOTID_DRILLMAN_POOF
	.byte $00	; $83 SPRSLOTID_SPIRALEXPLOSION
	.byte $01	; $84 SPRSLOTID_BOSSPHARAOH
	.byte $FF	; $85 SPRSLOTID_PHARAOHMAN_ATTACK
	.byte $FF	; $86 SPRSLOTID_PHARAOHMAN_SATTACK
	.byte $00	; $87 SPRSLOTID_BOSS_MOTHRAYA
	.byte $00	; $88 SPRSLOTID_COSSACK1_UNK1
	.byte $00	; $89 SPRSLOTID_COSSACK1_UNK2
	.byte $FF	; $8A SPRSLOTID_MOTHRAYA_SHOT
	.byte $02	; $8B SPRSLOTID_BOSSBRIGHT
	.byte $FF	; $8C SPRSLOTID_BOSSBRIGHT_BULLET
	.byte $01	; $8D SPRSLOTID_BOSSTOAD
	.byte $01	; $8E SPRSLOTID_BATTONTON
	.byte $00	; $8F SPRSLOTID_MOTHRAYA_DEBRIS
	.byte $00	; $90 SPRSLOTID_EXPLODEY_DEATH
	.byte $01	; $91 SPRSLOTID_MANTAN
	.byte $00	; $92 SPRSLOTID_BOSS_COSSACKCATCH
	.byte $00	; $93 SPRSLOTID_COSSACK4_UNK1
	.byte $FF	; $94 SPRSLOTID_COSSACK4_BULLET
	.byte $00	; $95 SPRSLOTID_BOSS_SQUAREMACHINE
	.byte $00	; $96 SPRSLOTID_SQUAREMACH_PLATFORM
	.byte $FF	; $97 SPRSLOTID_SQUAREMACHINE_SHOT
	.byte $01	; $98 SPRSLOTID_BOULDER
	.byte $00	; $99 SPRSLOTID_COSSACK2_UNK2
	.byte $02	; $9A SPRSLOTID_MUMMIRA
	.byte $FF	; $9B SPRSLOTID_MUMMIRAHEAD
	.byte $01	; $9C SPRSLOTID_IMORM
	.byte $00	; $9D SPRSLOTID_ENEMYEXPLODE
	.byte $00	; $9E SPRSLOTID_COSSACK3BOSS1
	.byte $FF	; $9F SPRSLOTID_COSSACK3BOSS2_SHOT
	.byte $FF	; $A0 SPRSLOTID_COSSACK3BOSS1_SHOT
	.byte $01	; $A1 SPRSLOTID_MONOROADER
	.byte $00	; $A2 SPRSLOTID_COSSACK3BOSS2
	.byte $00	; $A3 SPRSLOTID_KALINKA
	.byte $00	; $A4 SPRSLOTID_PROTOMAN
	.byte $00	; $A5 SPRSLOTID_WILY
	.byte $00	; $A6 SPRSLOTID_BOSS_METALLDADDY
	.byte $01	; $A7 SPRSLOTID_GACHAPPON
	.byte $00	; $A8 SPRSLOTID_GACHAPPON_BULLET
	.byte $00	; $A9 SPRSLOTID_GACHAPPON_GASHAPON
	.byte $01	; $AA SPRSLOTID_METALLDADDY_METALL
	.byte $01	; $AB SPRSLOTID_BOSS_TAKOTRASH
	.byte $00	; $AC SPRSLOTID_WILY2_UNK1
	.byte $FF	; $AD SPRSLOTID_TAKOTRASH_BALL
	.byte $FF	; $AE SPRSLOTID_TAKOTRASH_FIREBALL
	.byte $00	; $AF SPRSLOTID_TAKOTRASH_PLATFORM
	.byte $01	; $B0 SPRSLOTID_PAKATTO24
	.byte $FF	; $B1 SPRSLOTID_PAKATTO24_SHOT
	.byte $FF	; $B2 SPRSLOTID_UPNDOWN
	.byte $00	; $B3 SPRSLOTID_WILYTRANSPORTER
	.byte $00	; $B4 SPRSLOTID_UPNDOWN_SPAWNER
	.byte $00	; $B5 SPRSLOTID_SPIKEBLOCK_1
	.byte $00	; $B6 SPRSLOTID_SEAMINE
	.byte $00	; $B7 SPRSLOTID_GARYOBY
	.byte $00	; $B8 SPRSLOTID_BOSS_ROBOTMASTER
	.byte $01	; $B9 SPRSLOTID_DOCRON
	.byte $01	; $BA SPRSLOTID_DOCRON_SKULL
	.byte $00	; $BB SPRSLOTID_WILY3_UNK1
	.byte $00	; $BC SPRSLOTID_BOSS_WILYMACHINE4
	.byte $00	; $BD SPRSLOTID_TOGEHERO_SPAWNER_R
	.byte $01	; $BE SPRSLOTID_TOGEHERO
	.byte $FF	; $BF SPRSLOTID_WILYMACHINE4_SHOTCH
	.byte $00	; $C0 SPRSLOTID_WILYMACHINE4_PHASE2
	.byte $00	; $C1 SPRSLOTID_ITEM_PICKUP
	.byte $00	; $C2 SPRSLOTID_SPECWPN_PICKUP
	.byte $00	; $C3 SPRSLOTID_WILY1_DISPBLOCKS
	.byte $00	; $C4 SPRSLOTID_BOSS_WILYCAPSULE
	.byte $FF	; $C5 SPRSLOTID_WILYCAPSULE_SHOT
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
	
	
	.byte $00, $00, $00, $00, $00, $00, $00	; $B7C7 - $B7D6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B7D7 - $B7E6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B7E7 - $B7F6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B7F7 - $B806
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B807 - $B816
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B817 - $B826
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B827 - $B836
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B837 - $B846
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B847 - $B856
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B857 - $B866
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B867 - $B876
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B877 - $B886
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B887 - $B896
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B897 - $B8A6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B8A7 - $B8B6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B8B7 - $B8C6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B8C7 - $B8D6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B8D7 - $B8E6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B8E7 - $B8F6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B8F7 - $B906
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B907 - $B916
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B917 - $B926
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B927 - $B936
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B937 - $B946
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B947 - $B956
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B957 - $B966
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B967 - $B976
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B977 - $B986
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B987 - $B996
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B997 - $B9A6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B9A7 - $B9B6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B9B7 - $B9C6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B9C7 - $B9D6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B9D7 - $B9E6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B9E7 - $B9F6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B9F7 - $BA06
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BA07 - $BA16
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BA17 - $BA26
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BA27 - $BA36
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BA37 - $BA46
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BA47 - $BA56
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BA57 - $BA66
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BA67 - $BA76
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BA77 - $BA86
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BA87 - $BA96
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BA97 - $BAA6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BAA7 - $BAB6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BAB7 - $BAC6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BAC7 - $BAD6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BAD7 - $BAE6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BAE7 - $BAF6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BAF7 - $BB06
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BB07 - $BB16
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BB17 - $BB26
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BB27 - $BB36
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BB37 - $BB46
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BB47 - $BB56
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BB57 - $BB66
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BB67 - $BB76
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BB77 - $BB86
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BB87 - $BB96
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BB97 - $BBA6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BBA7 - $BBB6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BBB7 - $BBC6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BBC7 - $BBD6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BBD7 - $BBE6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BBE7 - $BBF6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BBF7 - $BC06
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BC07 - $BC16
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BC17 - $BC26
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BC27 - $BC36
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BC37 - $BC46
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BC47 - $BC56
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BC57 - $BC66
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BC67 - $BC76
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BC77 - $BC86
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BC87 - $BC96
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BC97 - $BCA6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BCA7 - $BCB6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BCB7 - $BCC6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BCC7 - $BCD6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BCD7 - $BCE6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BCE7 - $BCF6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BCF7 - $BD06
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BD07 - $BD16
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BD17 - $BD26
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BD27 - $BD36
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BD37 - $BD46
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BD47 - $BD56
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BD57 - $BD66
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BD67 - $BD76
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BD77 - $BD86
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BD87 - $BD96
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BD97 - $BDA6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BDA7 - $BDB6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BDB7 - $BDC6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BDC7 - $BDD6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BDD7 - $BDE6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BDE7 - $BDF6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BDF7 - $BE06
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BE07 - $BE16
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BE17 - $BE26
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BE27 - $BE36
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BE37 - $BE46
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BE47 - $BE56
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BE57 - $BE66
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BE67 - $BE76
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BE77 - $BE86
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BE87 - $BE96
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BE97 - $BEA6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BEA7 - $BEB6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BEB7 - $BEC6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BEC7 - $BED6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BED7 - $BEE6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BEE7 - $BEF6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BEF7 - $BF06
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BF07 - $BF16
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BF17 - $BF26
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BF27 - $BF36
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BF37 - $BF46
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BF47 - $BF56
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BF57 - $BF66
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BF67 - $BF76
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BF77 - $BF86
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BF87 - $BF96
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BF97 - $BFA6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BFA7 - $BFB6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BFB7 - $BFC6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BFC7 - $BFD6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BFD7 - $BFE6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BFE7 - $BFF6
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00	; $BFF7 - $BFFF


