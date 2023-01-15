	; Standard tilemap data; see format.txt in TMAPDATA for what this is comprised of.
	.incbin "PRG/TMAPDATA/TMAP01.bin"
	
	; Player Weapon Damage table for Rush Coil
	.org Player_WeaponDamageTable	; <-- help enforce this table *here*
PRG033_RushCoilDamageTable:	
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
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B7CE - $B7DD
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B7DE - $B7ED
	.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00	; $B7EE - $B7FD
	.byte $00, $00, $3B, $FB, $8F, $BB, $9A, $F7, $AB, $FF, $8A, $BF, $AA, $EF, $EB, $FF	; $B7FE - $B80D
	.byte $BF, $FF, $7F, $6F, $B8, $FF, $AB, $FF, $F3, $FF, $AB, $FD, $AE, $FF, $AA, $7D	; $B80E - $B81D
	.byte $BA, $FF, $A3, $FA, $AB, $FF, $BF, $FF, $AF, $F3, $2A, $FE, $AB, $DD, $EE, $FD	; $B81E - $B82D
	.byte $AE, $FF, $EB, $FF, $AE, $FF, $AA, $FF, $FA, $FF, $AB, $FB, $C9, $FF, $AB, $EF	; $B82E - $B83D
	.byte $EA, $BF, $E2, $CD, $EA, $7C, $CA, $C7, $8B, $FF, $28, $7F, $AA, $BB, $AB, $FE	; $B83E - $B84D
	.byte $AB, $FF, $EF, $FF, $9B, $FF, $EA, $BF, $AB, $FF, $EE, $FF, $AE, $FF, $AF, $FD	; $B84E - $B85D
	.byte $EA, $FF, $AB, $FB, $AB, $FF, $AA, $DF, $F2, $7B, $EA, $FD, $9B, $FF, $79, $8D	; $B85E - $B86D
	.byte $AF, $FF, $BE, $FF, $BB, $F6, $BF, $BF, $EF, $FE, $AA, $FF, $BF, $FF, $AB, $FF	; $B86E - $B87D
	.byte $EB, $FF, $62, $FF, $AB, $7D, $AA, $DD, $AA, $FD, $B7, $FF, $E8, $FF, $BA, $F3	; $B87E - $B88D
	.byte $AA, $FF, $96, $FF, $AA, $FA, $A2, $FF, $AE, $FF, $FB, $FF, $AB, $DF, $EA, $7F	; $B88E - $B89D
	.byte $6E, $FF, $00, $E3, $A8, $EB, $8A, $EF, $A2, $FF, $02, $7F, $AA, $AF, $AA, $FF	; $B89E - $B8AD
	.byte $AA, $FD, $AB, $F9, $BB, $FF, $A3, $FB, $EE, $D7, $AF, $F7, $EB, $7F, $AA, $7F	; $B8AE - $B8BD
	.byte $BE, $FF, $2A, $FE, $AA, $FF, $EE, $FF, $BA, $FE, $AE, $FF, $AA, $3F, $7F, $FF	; $B8BE - $B8CD
	.byte $2F, $DF, $E8, $FF, $AB, $FF, $AA, $FF, $AB, $E7, $BF, $FF, $AA, $FF, $AA, $FF	; $B8CE - $B8DD
	.byte $EF, $FF, $00, $BE, $AE, $7F, $AA, $FB, $A2, $FE, $AA, $B7, $BB, $DF, $3A, $FF	; $B8DE - $B8ED
	.byte $8A, $FE, $EA, $F9, $AA, $FF, $8A, $EF, $3B, $FF, $AE, $7F, $AA, $FF, $BA, $FF	; $B8EE - $B8FD
	.byte $EA, $FF, $AA, $FB, $DB, $FF, $AA, $FF, $AA, $FF, $BE, $EF, $FA, $9F, $CA, $FF	; $B8FE - $B90D
	.byte $AB, $FB, $AA, $FF, $AA, $FF, $AE, $FF, $AF, $FF, $AB, $FF, $AB, $FF, $BA, $7F	; $B90E - $B91D
	.byte $FF, $FF, $BB, $F7, $AB, $D6, $F8, $EF, $E2, $DF, $AB, $FF, $2E, $75, $E2, $77	; $B91E - $B92D
	.byte $BB, $FE, $EA, $7F, $AF, $B7, $FA, $FF, $EE, $FF, $BA, $FF, $AA, $FF, $AE, $BF	; $B92E - $B93D
	.byte $BA, $FF, $AA, $FD, $AB, $FF, $FB, $FF, $7A, $FB, $B9, $FF, $EE, $FF, $BA, $FF	; $B93E - $B94D
	.byte $AA, $F9, $A8, $FF, $AF, $FF, $FA, $EF, $AF, $FF, $AE, $FF, $2A, $AF, $EA, $F7	; $B94E - $B95D
	.byte $AB, $FF, $A8, $F7, $0A, $FF, $AA, $FE, $AA, $FF, $AC, $F5, $EA, $BE, $AE, $5B	; $B95E - $B96D
	.byte $EB, $7E, $2E, $FF, $AA, $FF, $8C, $FF, $EA, $FF, $AF, $B7, $EA, $FF, $AF, $FF	; $B96E - $B97D
	.byte $AA, $FF, $AA, $6A, $EE, $7F, $6B, $FF, $BF, $FF, $AA, $F5, $8A, $FF, $8A, $FD	; $B97E - $B98D
	.byte $AE, $EF, $A8, $FF, $AF, $FF, $AA, $FF, $BA, $7F, $AA, $FF, $BB, $7F, $FE, $FF	; $B98E - $B99D
	.byte $BA, $FE, $A7, $FD, $FB, $D4, $BB, $DF, $AB, $CD, $B9, $FF, $BA, $67, $A8, $FF	; $B99E - $B9AD
	.byte $BA, $5F, $A8, $FF, $EA, $F7, $8A, $FD, $AF, $FF, $EA, $DF, $AA, $FF, $3A, $BF	; $B9AE - $B9BD
	.byte $AE, $FF, $AA, $FF, $AB, $FE, $AA, $FF, $AA, $FF, $83, $FF, $EA, $FF, $EB, $F7	; $B9BE - $B9CD
	.byte $EF, $FF, $EE, $DF, $3B, $FF, $AA, $FF, $AE, $FD, $EE, $F7, $BF, $BF, $FF, $FF	; $B9CE - $B9DD
	.byte $8D, $FF, $8A, $FB, $A0, $B7, $AA, $FA, $AD, $DF, $AA, $DE, $8A, $D7, $AA, $BF	; $B9DE - $B9ED
	.byte $0A, $59, $AA, $AF, $6C, $E7, $AA, $9E, $3A, $FF, $B9, $E7, $62, $DF, $BA, $FF	; $B9EE - $B9FD
	.byte $EB, $FF, $AA, $EE, $AE, $FE, $A3, $FF, $BA, $FF, $B3, $FF, $EF, $DB, $EB, $F7	; $B9FE - $BA0D
	.byte $EB, $EF, $EA, $DF, $FA, $FF, $AE, $D7, $AB, $FF, $AF, $FF, $AB, $FF, $AE, $FF	; $BA0E - $BA1D
	.byte $B3, $FF, $A8, $FF, $AA, $FF, $BB, $FE, $AA, $D9, $BA, $FF, $A8, $F7, $AC, $DF	; $BA1E - $BA2D
	.byte $0E, $FD, $EE, $FF, $88, $FF, $A8, $3F, $A2, $DF, $BF, $FF, $AE, $FF, $EA, $FF	; $BA2E - $BA3D
	.byte $BA, $FF, $23, $BF, $FA, $FF, $BA, $FF, $3A, $FF, $AA, $EF, $AE, $CF, $AB, $FF	; $BA3E - $BA4D
	.byte $AA, $FF, $BB, $FB, $AB, $BF, $AA, $BF, $6B, $FF, $AE, $FF, $AB, $FF, $BB, $EF	; $BA4E - $BA5D
	.byte $AE, $FF, $AA, $E7, $E2, $2F, $86, $DF, $22, $EF, $8A, $FF, $B8, $FF, $AA, $3D	; $BA5E - $BA6D
	.byte $2A, $4B, $AA, $FC, $AA, $F7, $BA, $FF, $AC, $FF, $AB, $FF, $BA, $EE, $AE, $FF	; $BA6E - $BA7D
	.byte $2A, $FF, $AB, $DD, $A2, $DD, $2E, $FF, $BA, $DF, $0A, $FF, $EA, $FF, $FF, $F7	; $BA7E - $BA8D
	.byte $AA, $FB, $2E, $FF, $2B, $E7, $AA, $FF, $FA, $FF, $EB, $FF, $E2, $DF, $AA, $7F	; $BA8E - $BA9D
	.byte $B9, $6F, $AA, $6F, $0A, $BF, $B2, $FD, $3C, $FF, $FB, $FF, $AB, $6F, $DA, $FF	; $BA9E - $BAAD
	.byte $2A, $FD, $AA, $CF, $EE, $FF, $FA, $F7, $AA, $FF, $AE, $FF, $AB, $FD, $E2, $FF	; $BAAE - $BABD
	.byte $EF, $FF, $EF, $FE, $AA, $F7, $EB, $CF, $AE, $BF, $EA, $FB, $AA, $FF, $AB, $DB	; $BABE - $BACD
	.byte $AA, $BF, $AA, $FE, $F8, $DF, $BB, $FF, $E2, $7F, $C8, $FF, $3A, $FF, $BA, $EF	; $BACE - $BADD
	.byte $AF, $F7, $0A, $E8, $BF, $7B, $9C, $B7, $A8, $FB, $49, $DF, $A7, $E9, $AA, $FF	; $BADE - $BAED
	.byte $CA, $FF, $AB, $FF, $EA, $BF, $AA, $9B, $8A, $FB, $BA, $FF, $EA, $DD, $A9, $FF	; $BAEE - $BAFD
	.byte $AB, $FF, $BB, $7F, $FA, $EB, $BA, $DF, $F2, $DE, $A3, $FF, $AF, $FB, $A8, $FF	; $BAFE - $BB0D
	.byte $BE, $FF, $AA, $FF, $BF, $FF, $BB, $FF, $EB, $E7, $A6, $FF, $FB, $F7, $FB, $FF	; $BB0E - $BB1D
	.byte $EA, $FF, $AA, $CD, $8A, $BE, $FA, $FF, $AF, $FF, $AB, $DF, $2B, $FF, $2E, $FF	; $BB1E - $BB2D
	.byte $AF, $BF, $3E, $DF, $FB, $FF, $FA, $BF, $EA, $FF, $AE, $F7, $AE, $BF, $BE, $FF	; $BB2E - $BB3D
	.byte $EB, $FF, $2A, $F7, $A3, $FF, $9E, $CE, $AA, $FF, $DA, $F7, $EA, $FA, $AE, $FF	; $BB3E - $BB4D
	.byte $BA, $FF, $AE, $FF, $A9, $9B, $BE, $FB, $AA, $FF, $AE, $FF, $EB, $F7, $BE, $FF	; $BB4E - $BB5D
	.byte $BB, $FF, $28, $E9, $A2, $D9, $8B, $AE, $EA, $FF, $AA, $F9, $A6, $DE, $9E, $FB	; $BB5E - $BB6D
	.byte $AB, $FB, $2B, $FD, $A2, $FF, $EA, $7F, $E8, $FE, $AA, $FF, $AF, $FF, $EA, $FF	; $BB6E - $BB7D
	.byte $BF, $FF, $8B, $B7, $BE, $FF, $BC, $BF, $BB, $FD, $AB, $D7, $C7, $FF, $2A, $7B	; $BB7E - $BB8D
	.byte $2B, $FD, $AA, $FB, $E2, $FF, $EA, $FF, $A8, $FF, $FA, $FF, $FE, $DF, $AF, $FF	; $BB8E - $BB9D
	.byte $BE, $FF, $BA, $F5, $A2, $FF, $BE, $7F, $AB, $7F, $AE, $FC, $F8, $FE, $AA, $FC	; $BB9E - $BBAD
	.byte $EA, $7F, $A2, $7F, $AA, $3F, $A2, $FD, $AB, $FF, $EE, $FF, $2A, $DF, $BE, $FF	; $BBAE - $BBBD
	.byte $AF, $DF, $6E, $EF, $A2, $FF, $1B, $B9, $82, $FF, $82, $FB, $AA, $DF, $2A, $EF	; $BBBE - $BBCD
	.byte $DB, $BF, $AE, $FF, $20, $DF, $AA, $3F, $AE, $73, $78, $FF, $AE, $FF, $AC, $FF	; $BBCE - $BBDD
	.byte $AB, $FF, $62, $FF, $A6, $DF, $88, $BB, $8D, $7A, $E3, $97, $2A, $FB, $BB, $FF	; $BBDE - $BBED
	.byte $20, $F9, $4A, $FB, $AA, $FD, $9A, $FF, $AB, $FB, $AE, $FF, $BE, $F7, $AE, $FF	; $BBEE - $BBFD
	.byte $8D, $FF, $ED, $14, $B9, $40, $D9, $50, $44, $55, $00, $05, $B1, $50, $B3, $00	; $BBFE - $BC0D
	.byte $AD, $15, $74, $11, $48, $00, $8A, $95, $93, $00, $0C, $14, $04, $00, $60, $40	; $BC0E - $BC1D
	.byte $83, $05, $83, $11, $82, $05, $AC, $50, $27, $14, $72, $05, $D4, $41, $85, $44	; $BC1E - $BC2D
	.byte $20, $05, $87, $04, $01, $41, $C5, $40, $A8, $51, $9C, $11, $B0, $11, $BA, $51	; $BC2E - $BC3D
	.byte $A4, $04, $EC, $14, $A7, $04, $FD, $40, $78, $41, $0C, $04, $79, $15, $DC, $00	; $BC3E - $BC4D
	.byte $68, $01, $14, $04, $61, $10, $02, $05, $DA, $50, $04, $51, $98, $51, $CE, $05	; $BC4E - $BC5D
	.byte $14, $05, $CC, $14, $2E, $05, $B3, $14, $52, $15, $CE, $10, $5F, $50, $C8, $44	; $BC5E - $BC6D
	.byte $1B, $54, $9E, $44, $3D, $44, $EA, $51, $51, $15, $FA, $15, $C7, $10, $9A, $55	; $BC6E - $BC7D
	.byte $46, $10, $CB, $04, $68, $04, $57, $44, $7F, $01, $35, $04, $41, $44, $4C, $44	; $BC7E - $BC8D
	.byte $60, $40, $71, $44, $4A, $50, $81, $15, $9F, $01, $11, $00, $30, $01, $A6, $54	; $BC8E - $BC9D
	.byte $85, $01, $7B, $01, $37, $14, $E5, $04, $52, $00, $7F, $50, $25, $00, $FB, $45	; $BC9E - $BCAD
	.byte $7B, $14, $7B, $54, $6F, $14, $10, $01, $FA, $50, $67, $54, $22, $41, $B8, $50	; $BCAE - $BCBD
	.byte $69, $41, $9F, $54, $72, $15, $9A, $55, $60, $14, $A6, $11, $39, $55, $71, $41	; $BCBE - $BCCD
	.byte $DF, $05, $30, $50, $A8, $40, $C4, $04, $E2, $51, $02, $54, $C3, $54, $D7, $04	; $BCCE - $BCDD
	.byte $98, $44, $9D, $54, $58, $44, $9D, $00, $B9, $05, $E2, $54, $BE, $10, $DF, $44	; $BCDE - $BCED
	.byte $88, $15, $1C, $05, $CD, $10, $6B, $00, $66, $40, $97, $14, $93, $15, $BC, $14	; $BCEE - $BCFD
	.byte $58, $01, $5D, $55, $0A, $54, $95, $44, $8A, $14, $84, $04, $FC, $00, $2D, $41	; $BCFE - $BD0D
	.byte $49, $44, $31, $01, $02, $15, $06, $44, $08, $40, $AC, $41, $12, $44, $06, $15	; $BD0E - $BD1D
	.byte $11, $00, $12, $15, $AF, $10, $5C, $11, $8E, $50, $D2, $14, $55, $00, $09, $15	; $BD1E - $BD2D
	.byte $3B, $54, $25, $14, $4A, $00, $32, $40, $35, $05, $A3, $52, $C1, $14, $85, $01	; $BD2E - $BD3D
	.byte $4C, $44, $6F, $01, $83, $44, $04, $04, $93, $04, $56, $45, $A6, $00, $82, $14	; $BD3E - $BD4D
	.byte $21, $15, $30, $40, $D2, $40, $22, $40, $98, $40, $13, $04, $28, $41, $A0, $04	; $BD4E - $BD5D
	.byte $C2, $10, $DB, $11, $3E, $14, $8E, $05, $5E, $01, $A4, $44, $44, $55, $3E, $10	; $BD5E - $BD6D
	.byte $41, $10, $8A, $01, $0C, $55, $D3, $60, $23, $54, $25, $51, $D9, $15, $C3, $15	; $BD6E - $BD7D
	.byte $7E, $00, $4D, $54, $76, $01, $44, $11, $F3, $40, $91, $04, $C0, $00, $12, $55	; $BD7E - $BD8D
	.byte $9E, $51, $19, $50, $7C, $01, $60, $00, $C7, $44, $9A, $00, $4A, $00, $46, $10	; $BD8E - $BD9D
	.byte $08, $01, $10, $40, $D1, $44, $F1, $45, $DB, $41, $01, $50, $36, $14, $E3, $10	; $BD9E - $BDAD
	.byte $E7, $14, $48, $50, $A6, $00, $C0, $11, $32, $44, $CC, $11, $40, $10, $72, $10	; $BDAE - $BDBD
	.byte $F8, $15, $90, $50, $54, $11, $3C, $50, $14, $54, $36, $10, $17, $01, $5C, $01	; $BDBE - $BDCD
	.byte $60, $45, $27, $50, $10, $01, $96, $10, $5E, $14, $C5, $41, $93, $51, $4E, $50	; $BDCE - $BDDD
	.byte $81, $04, $8B, $45, $C4, $44, $13, $14, $52, $44, $97, $50, $1D, $05, $1B, $45	; $BDDE - $BDED
	.byte $8D, $50, $34, $54, $BB, $10, $CB, $51, $30, $54, $16, $10, $E9, $51, $DB, $10	; $BDEE - $BDFD
	.byte $9B, $54, $EB, $00, $88, $51, $13, $10, $15, $14, $88, $41, $06, $40, $40, $04	; $BDFE - $BE0D
	.byte $00, $40, $81, $41, $0E, $10, $C0, $05, $19, $00, $80, $00, $09, $00, $00, $40	; $BE0E - $BE1D
	.byte $D4, $04, $82, $51, $AB, $40, $AE, $51, $80, $01, $A8, $15, $C1, $41, $82, $00	; $BE1E - $BE2D
	.byte $6B, $04, $D4, $11, $B4, $55, $32, $00, $FC, $50, $20, $05, $68, $44, $62, $45	; $BE2E - $BE3D
	.byte $FF, $15, $2A, $41, $67, $51, $3C, $51, $F1, $55, $71, $40, $58, $40, $CD, $15	; $BE3E - $BE4D
	.byte $15, $05, $A5, $05, $38, $00, $1B, $11, $25, $10, $28, $01, $73, $45, $10, $01	; $BE4E - $BE5D
	.byte $42, $44, $8F, $04, $20, $04, $44, $10, $D3, $54, $24, $05, $44, $00, $BE, $11	; $BE5E - $BE6D
	.byte $AB, $14, $3D, $11, $05, $01, $0D, $51, $91, $14, $43, $01, $E9, $55, $0F, $14	; $BE6E - $BE7D
	.byte $98, $51, $49, $44, $E7, $05, $6C, $05, $33, $05, $70, $01, $44, $10, $79, $00	; $BE7E - $BE8D
	.byte $9A, $41, $02, $55, $69, $10, $31, $14, $83, $10, $05, $15, $05, $04, $9E, $54	; $BE8E - $BE9D
	.byte $82, $01, $E1, $40, $C6, $01, $C2, $45, $28, $05, $FE, $51, $6B, $05, $DE, $41	; $BE9E - $BEAD
	.byte $19, $54, $7A, $44, $8E, $10, $03, $10, $E8, $14, $3E, $55, $86, $55, $83, $14	; $BEAE - $BEBD
	.byte $7C, $45, $FA, $11, $1C, $15, $49, $10, $0A, $41, $C5, $10, $A6, $10, $41, $00	; $BEBE - $BECD
	.byte $82, $14, $2D, $55, $43, $40, $C3, $15, $AD, $05, $90, $05, $48, $41, $69, $00	; $BECE - $BEDD
	.byte $38, $10, $5E, $05, $6A, $51, $DB, $01, $BE, $54, $41, $14, $D0, $51, $28, $00	; $BEDE - $BEED
	.byte $F8, $14, $29, $05, $F3, $54, $13, $40, $E4, $45, $23, $05, $B9, $81, $A8, $15	; $BEEE - $BEFD
	.byte $06, $15, $7B, $44, $E1, $44, $7A, $01, $EA, $15, $C4, $15, $8A, $10, $C1, $04	; $BEFE - $BF0D
	.byte $D5, $50, $05, $01, $58, $04, $40, $44, $46, $40, $0D, $45, $30, $54, $C0, $00	; $BF0E - $BF1D
	.byte $03, $04, $7E, $04, $A3, $04, $C7, $11, $8A, $41, $D7, $05, $8C, $00, $74, $50	; $BF1E - $BF2D
	.byte $58, $10, $96, $40, $38, $04, $DF, $06, $01, $18, $3A, $50, $ED, $51, $D1, $14	; $BF2E - $BF3D
	.byte $11, $01, $B6, $11, $FB, $55, $47, $10, $DB, $55, $5B, $54, $7B, $10, $07, $00	; $BF3E - $BF4D
	.byte $31, $15, $6A, $05, $01, $01, $9C, $14, $B8, $10, $61, $11, $22, $51, $A1, $55	; $BF4E - $BF5D
	.byte $C2, $51, $A8, $41, $6C, $45, $ED, $45, $90, $14, $7F, $55, $2C, $04, $E9, $01	; $BF5E - $BF6D
	.byte $36, $50, $B8, $11, $B8, $10, $78, $54, $FA, $11, $6C, $40, $74, $41, $9C, $40	; $BF6E - $BF7D
	.byte $06, $45, $8E, $14, $90, $55, $F7, $50, $4C, $00, $8A, $00, $08, $10, $E0, $05	; $BF7E - $BF8D
	.byte $A1, $10, $EA, $11, $12, $01, $24, $40, $0A, $10, $84, $55, $89, $00, $8A, $00	; $BF8E - $BF9D
	.byte $22, $00, $00, $51, $EC, $50, $34, $05, $3D, $11, $57, $10, $2A, $54, $79, $51	; $BF9E - $BFAD
	.byte $5F, $45, $C2, $04, $37, $41, $38, $04, $29, $00, $D6, $11, $D8, $55, $C6, $10	; $BFAE - $BFBD
	.byte $E2, $05, $C0, $44, $F6, $44, $BB, $45, $34, $05, $3F, $40, $AA, $00, $A8, $00	; $BFBE - $BFCD
	.byte $7C, $11, $85, $00, $11, $10, $D0, $04, $91, $00, $5C, $45, $52, $01, $B4, $14	; $BFCE - $BFDD
	.byte $81, $10, $C7, $40, $C9, $55, $CC, $54, $12, $50, $67, $11, $75, $04, $D4, $44	; $BFDE - $BFED
	.byte $40, $45, $FA, $11, $A0, $40, $86, $14, $F0, $15, $B9, $45, $8D, $44, $6B, $51	; $BFEE - $BFFD
	.byte $9B, $15	; $BFFE - $BFFF


