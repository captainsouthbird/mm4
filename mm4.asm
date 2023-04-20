	.inesprg 32  ; 32x 16KB PRG code (64 banks of 8KB)
	.ineschr 0  ; 0x  8KB CHR data
	.inesmap 4   ; mapper 4 = MMC3, 8KB PRG, 1/2KB CHR bank swapping
	.inesmir 0   ; background mirroring


; Handy pseudo instructions... only make sense in the context of CMPing a number...
BLT     .macro
    BCC \1  ; A < CMP (unsigned)
    .endm

BGE     .macro
    BCS \1  ; A >= CMP (unsigned)
    .endm

BLS     .macro
    BMI \1  ; A < CMP (signed)
    .endm

BGS     .macro
    BPL \1  ; A >= CMP (signed)
    .endm

; Clarifying pseudo instructions
ADD .macro  ; RegEx S&R "CLC.*\n.*?ADC" -> "ADD"
    CLC
    ADC \1
    .endm

SUB .macro  ; RegEx S&R "SEC.*\n.*?SBC" -> "SUB"
    SEC
    SBC \1
    .endm

NEG .macro  ; RegEx S&R "EOR #\$ff.*\n.*ADD #\$01" -> "NEG"
    EOR #$ff
    ADD #$01
    .endm


; This is used in video update streams; since the video address register
; takes the address high-then-low (contrary to 6502's normal low-then-high),
; this allows a 16-bit value but "corrects" it to the proper endianness.
vaddr	.macro
	.byte (\1 & $FF00) >> 8
	.byte (\1 & $00FF)
	.endm


; Pads bytes to align to nearest 64 byte boundary for DMC samples
; SB: This would be useful for your own works, but I can't use
; it in the natively disassembly since the assembler pads zeroes
; instead of $FF values... just FYI!
;
; Usage example:
;
; .LabelPriorToDMC: DMCAlign .LabelPriorToDMC
DMCAlign:	.macro
			.ds ((\1 + $3F) & $FFC0) - \1
		.endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PPU I/O regs (CPU side)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;	PPU_CTL1:
;	0-1: Name table address, changes between the four name tables at $2000 (0), $2400 (1), $2800 (2) and $2C00 (3).
;	2: Clear, PPU incs by 1 ("horizontal"); Set, PPU incs by 32 ("vertical")
;	3: Which pattern table holds for sprites; 0 for PT1 ($0000) or 1 for PT2 ($1000)
;	4: Which pattern table holds for BG; 0 for PT1 ($0000) or 1 for PT2 ($1000)
;	5: Set to use 8x16 sprites instead of 8x8
;	7: Set to generate VBlank NMIs
PPU_CTL1	= $2000		; Write only

;	PPU_CTL2:
;	0: Clear for color, set for mono
;	1: Clear to clip 8 left pixels of BG
;	2: Clear to clip 8 left pixels of sprites
;	3: If clear, BG hidden
;	4: If clear, sprites hidden
;	5-7: BG color in mono mode, "color intensity" in color mode (??)
PPU_CTL2	= $2001		; Write only

;	PPU_STAT:
;	4: if set, can write to VRAM, else writes ignored
;	5: if set, sprite overflow occurred on scanline
;	6: Set if any non-transparent pixel of sprite 0 is overlapping a non-transparent pixel of BG
;	7: VBlank is occurring (cleared after read)
PPU_STAT	= $2002

; Sprites: 256 bytes, each sprite takes 4, so 64 sprites total
; Only 8 sprites per scanline, sprite 0 is drawn on top (thus highest priority)
; PPU_SPR_ADDR / PPU_SPR_DATA
; * Byte 0 - Stores the y-coordinate of the top left of the sprite minus 1.
; * Byte 1 - Index number of the sprite in the pattern tables.
; * Byte 2 - Stores the attributes of the sprite.
;   * Bits 0-1 - Most significant two bits of the colour.  (Or "palette" 0-3)
;   * Bit 5 - Indicates whether this sprite has priority over the background.
;   * Bit 6 - Indicates whether to flip the sprite horizontally.
;   * Bit 7 - Indicates whether to flip the sprite vertically.
; * Byte 3 - X coordinate
PPU_SPR_ADDR	= $2003		; Set address sprite data
PPU_SPR_DATA	= $2004		; Read or write this sprite byte

PPU_SCROLL	= $2005		; Scroll register; read PPU_STAT, then write horiz/vert scroll
PPU_VRAM_ADDR	= $2006		; VRAM address (first write is high, next write is low)
PPU_VRAM_DATA	= $2007		; Data to read/write at this address

; Note that all transparent colors ($3F04, $3F08, $3F0C, $3F10, $3F14, $3F18 and $3F1C) are mirrored from 3F00
PPU_BG_PAL	= $3F00 	; 3F00-3F0F
PPU_SPR_PAL	= $3F10		; 3F10-3F1F


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SOUND I/O regs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; $4000(rct1)/$4004(rct2)/$400C(noise) bits
; ---------------------------------------
; 0-3	volume / envelope decay rate
; 4	envelope decay disable
; 5	length counter clock disable / envelope decay looping enable
; 6-7	duty cycle type (unused on noise channel)

; Duty cycles:
; 00 = a weak, grainy tone.  (12.5% Duty), 01 = a solid mid-strength tone. (25% Duty), 
; 10 = a strong, full tone (50% Duty), 11 = sounds a lot like 01 (25% Duty negated)

PAPU_CTL1	= $4000	; pAPU Pulse 1 Control Register.
PAPU_CTL2	= $4004	; pAPU Pulse 2 Control Register.
PAPU_NCTL1 	= $400C ; pAPU Noise Control Register 1.


; $4008(tri) bits
; ---------------
; 0-6	linear counter load register
; 7	length counter clock disable / linear counter start
PAPU_TCR1	= $4008	; pAPU Triangle Control Register 1.


; $4001(rct1)/$4005(rct2) bits
; --------------------------
; 0-2	right shift amount
; 3	decrease / increase (1/0) wavelength
; 4-6	sweep update rate
; 7	sweep enable
PAPU_RAMP1	= $4001	; pAPU Pulse 1 Ramp Control Register.
PAPU_RAMP2	= $4005	; pAPU Pulse 2 Ramp Control Register.


; $4002(rct1)/$4006(rct2)/$400A(Tri) bits
; -------------------------------------
; 0-7	8 LSB of wavelength
PAPU_FT1	= $4002	; pAPU Pulse 1 Fine Tune (FT) Register.
PAPU_FT2	= $4006	; pAPU Pulse 2 Fine Tune (FT) Register.
PAPU_TFREQ1	= $400A ; pAPU Triangle Frequency Register 1.


; $400E(noise) bits
; -----------------
; 0-3	playback sample rate
; 4-6	unused
; 7	random number type generation
PAPU_NFREQ1	= $400E ; pAPU Noise Frequency Register 1.

; $4003(rct1)/$4007(rct2)/$400B(tri)/$400F(noise) bits
; --------------------------------------------------
; 0-2	3 MS bits of wavelength (unused on noise channel) (the "high" frequency)
; 3-7	length of tone
PAPU_CT1	= $4003 ; pAPU Pulse 1 Coarse Tune (CT) Register.
PAPU_CT2	= $4007 ; pAPU Pulse 2 Coarse Tune (CT) Register.
PAPU_TFREQ2	= $400B ; pAPU Triangle Frequency Register 2.
PAPU_NFREQ2	= $400F ; pAPU Noise Frequency Register 2.


; $4010 - DMC Play mode and DMA frequency

; Bits 0-3:
;    f   period
;    ----------
;    0   $1AC
;    1   $17C
;    2   $154
;    3   $140
;    4   $11E
;    5   $0FE
;    6   $0E2
;    7   $0D6
;    8   $0BE
;    9   $0A0
;    A   $08E
;    B   $080
;    C   $06A
;    D   $054
;    E   $048
;    F   $036
; Bits 6-7: this is the playback mode.
;	00 - play DMC sample until length counter reaches 0 (see $4013)
;	x1 - loop the DMC sample (x = immaterial)
;	10 - play DMC sample until length counter reaches 0, then generate a CPU 
PAPU_MODCTL	= $4010 ; pAPU Delta Modulation Control Register.

PAPU_MODDA	= $4011 ; pAPU Delta Modulation D/A Register.
PAPU_MODADDR	= $4012 ; pAPU Delta Modulation Address Register.
PAPU_MODLEN	= $4013 ; pAPU Delta Modulation Data Length Register.

; read
; ----
; 0	rectangle wave channel 1 length counter status
; 1	rectangle wave channel 2 length counter status
; 2	triangle wave channel length counter status
; 3	noise channel length counter status
; 4	DMC is currently enabled (playing a stream of samples)
; 5	unknown
; 6	frame IRQ status (active when set)
; 7	DMC's IRQ status (active when set)
; 
; write
; -----
; 0	rectangle wave channel 1 enable
; 1	rectangle wave channel 2 enable
; 2	triangle wave channel enable
; 3	noise channel enable
; 4	enable/disable DMC (1=start/continue playing a sample;0=stop playing)
; 5-7	unknown
PAPU_EN		= $4015	; R/W pAPU Sound Enable


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; OTHER I/O regs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SPR_DMA		= $4014 ; Sprite DMA Register -- DMA from CPU memory at $100 x n to SPR-RAM (256 bytes)


; Read / Write Joypad 1/2:
;                   *  Bit 0 - Reads data from joypad or causes joypad strobe
;                      when writing.
;                   *  Bit 3 - Indicates whether Zapper is pointing at a sprite.
;                   *  Bit 4 - Cleared when Zapper trigger is released.
;                   Only bit 0 is involved in writing.
JOYPAD		= $4016		

; Frame counter control
; Changes the frame counter that changes updates on sound; any write resets
; the frame counter, good for synchronizing sound with VBlank etc.
; 0        4, 0,1,2,3, 0,1,2,3,..., etc.
; 1        0,1,2,3,4, 0,1,2,3,4,..., etc. 
; bit 6 - enable frame IRQs (when zero)
; bit 7 - 0 = 60 IRQs a frame / 1 = 48 IRQs a frame (obviously need bit 6 clear to use)
; Interestingly, both of the above are clear on bootup, meaning IRQs are being generated,
; but the 6502 ignores NMIs on startup; also, need to read from $4015 (PAPU_EN) to acknowledge
; the interrupt, otherwise it holds the status on!
FRAMECTR_CTL	= $4017


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MMC3 regs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; MMC3_COMMAND:
;  Bits 0-2 - Command number:
;  * 0 - Swap two 1 KB VROM banks at PPU $0000.
;  * 1 - Swap two 1 KB VROM banks at PPU $0800.
;  * 2 - Swap one 1 KB VROM bank at PPU $1000.
;  * 3 - Swap one 1 KB VROM bank at PPU $1400.
;  * 4 - Swap one 1 KB VROM bank at PPU $1800.
;  * 5 - Swap one 1 KB VROM bank at PPU $1C00.
;  * 6 - Swap PRG-ROM bank at either $8000 or $C000 based on bit 6.
;  * 7 - Swap PRG-ROM bank at either $A000 
;
;  Bit 6 - If 0, enables swapping at $8000 and $A000, otherwise enables
;  swapping at $C000 and $A000.
;
;  Bit 7 - If 1, causes addresses for commands 0-5 to be the exclusive-or
;  of the address stated and $1000.

; Note that bit 6 is clear on all of these consistently since MM4 uses the PRG switch this way
MMC3_2K_TO_PPU_0000	= %00000000	; 0
MMC3_2K_TO_PPU_0800	= %00000001	; 1
MMC3_1K_TO_PPU_1000	= %00000010	; 2
MMC3_1K_TO_PPU_1400	= %00000011	; 3
MMC3_1K_TO_PPU_1800	= %00000100	; 4
MMC3_1K_TO_PPU_1C00	= %00000101	; 5
MMC3_8K_TO_PRG_8000	= %00000110	; 6
MMC3_8K_TO_PRG_A000	= %00000111	; 7
MMC3_PPU_XOR_1000	= %10000000


MMC3_COMMAND	= $8000	; consult ref
MMC3_PAGE  	= $8001	; page number to MMC3_COMMAND
MMC3_MIRROR	= $A000	; bit 0 clear is horizontal mirroring, bit 0 set is vertical mirroring
MMC3_SRAM_EN	= $A001	; bit 7 set to enable SRAM at $6000-$7FFF
MMC3_IRQCNT	= $C000 ; Countdown to an IRQ
MMC3_IRQLATCH	= $C001 ; Store a temp val to be copied to MMC3_IRQCNT later
MMC3_IRQDISABLE	= $E000 ; Disables IRQ generation and copies MMC3_IRQLATCH to MMC3_IRQCNT
MMC3_IRQENABLE	= $E001 ; Enables IRQ generation



	.data	; Using .data instead of .zp to export labels
	.org $0000

	; AUTOGENERATED: Remember the "ds" ranges may be too large, but they shouldn't be too small at least

	Temp_Var0:		.ds 1	 ; $0000
	Temp_Var1:		.ds 1	 ; $0001
	Temp_Var2:		.ds 1	 ; $0002
	Temp_Var3:		.ds 1	 ; $0003
	Temp_Var4:		.ds 1	 ; $0004
	Temp_Var5:		.ds 1	 ; $0005
	Temp_Var6:		.ds 1	 ; $0006
	Temp_Var7:		.ds 1	 ; $0007
	Temp_Var8:		.ds 1	 ; $0008
	Temp_Var9:		.ds 1	 ; $0009
	Temp_Var10:		.ds 1	 ; $000A
	Temp_Var11:		.ds 1	 ; $000B
	Temp_Var12:		.ds 1	 ; $000C
	Temp_Var13:		.ds 1	 ; $000D
	Temp_Var14:		.ds 1	 ; $000E
	Temp_Var15:		.ds 1	 ; $000F
	Temp_Var16:		.ds 1	 ; $0010
	Temp_Var17:		.ds 1	 ; $0011
	Temp_Var18:		.ds 1	 ; $0012
	Temp_Var19:		.ds 1	 ; $0013

PAD_A		= $80
PAD_B		= $40
PAD_SELECT	= $20
PAD_START	= $10
PAD_UP		= $08
PAD_DOWN	= $04
PAD_LEFT	= $02
PAD_RIGHT	= $01

	Ctlr1_Pressed:		.ds 1	 ; $0014
	Ctlr2_Pressed:		.ds 1	 ; $0015
	Ctlr1_Held:		.ds 1	 ; $0016
	Ctlr2_Held:		.ds 1
	
	CommitPal_Flag:			.ds 1	 ; If set non-zero, commit palette (PalData_1 -> PPU)
	CommitGBuf_Flag:		.ds 1	 ; If set non-zero, commit graphics buffer (horizontal increment)
	CommitGBuf_FlagV:		.ds 1	 ; If set non-zero, commit graphics buffer (vertical increment)
	
	; CommitBG_Flag:
	;	Bit 6 ($40) set ONLY - Commit BG attribute data stored in all 64 bytes of Level_ScreenTileModData
	;	Bit 7 ($80) set - Commits BG to the "other" side of the BG mirror (for large bosses); lower 7 bits specify MetaBlk_Index (generally $00?); paired with CommitBG_ScrSel which specifies the screen
	CommitBG_Flag:		.ds 1	 ; $001B
	CommitBG_ScrSel:	.ds 1	 ; See CommitBG_Flag; specifies the screen
	RAM_001D:		.ds 1	 ; $001D
	RAM_001E:		.ds 1	 ; $001E
	
	; Player_Midpoint:
	;	0 - Start at beginning of level
	;	1 - Start at midpoint of level
	;	2 - Start inside boss gates
	Player_Midpoint:		.ds 1

	; Pointer to current metablock screen layout data
	MetaBlk_ScrAddrL:		.ds 1
	MetaBlk_ScrAddrH:		.ds 1
	
	; TileMap_Index: OR'd with 32 to make a page for $A000
TMAP_BRIGHTMAN		= $00	; $00 - Bright Man
TMAP_TOADMAN		= $01	; $01 - Toad Man
TMAP_DRILLMAN		= $02	; $02 - Drill Man
TMAP_PHARAOHMAN		= $03	; $03 - Pharaoh Man
TMAP_RINGMAN		= $04	; $04 - Ring Man
TMAP_DUSTMAN		= $05	; $05 - Dust Man
TMAP_DIVEMAN		= $06	; $06 - Dive Man
TMAP_SKULLMAN		= $07	; $07 - Skull Man
TMAP_COSSACK1		= $08	; $08 - Cossack 1
TMAP_COSSACK2		= $09	; $09 - Cossack 2
TMAP_COSSACK3		= $0A	; $0A - Cossack 3
TMAP_COSSACK4		= $0B	; $0B - Cossack 4
TMAP_WILY1			= $0C	; $0C - Wily 1
TMAP_WILY2			= $0D	; $0D - Wily 2
TMAP_WILY3			= $0E	; $0E - Wily 3
TMAP_WILY4			= $0F	; $0F - Wily 4
TMAP_CREDITLOGO		= $10	; $10 - startup credit, logo, stage select, in-game menu
TMAP_TITLE			= $11	; $11 - title
TMAP_COSSACKINTRO	= $12	; $12 - Cossack fortress intro
TMAP_INTROSTORY		= $13	; $13 - intro story
TMAP_ENDING			= $14	; $14 - Ending
	TileMap_Index:		.ds 1	 ; $0022
	
	RAM_0023:		.ds 1	 ; $0023
	ScreenUpd_CurCol:		.ds 1	 ; wraps 0-31, column on screen to draw
	RAM_0025:		.ds 1	 ; $0025
	RAM_0026:		.ds 1	 ; $0026
	RAM_0027:		.ds 1	 ; $0027
	RAM_0028:		.ds 1	 ; $0028
	MetaBlk_Index:		.ds 1	 ; Index of current metablock to select the 16x16 tile
	MetaBlk_CurScreen:		.ds 1	 ; Current "screen" to offset to in metablock data (e.g. passed as 'Y' into PRG062_SetMetaBlkAddr)
	
	; "Segment" increases per ladder climb, screen transition, etc., see e.g. PRG062_CC79
	
	; Level_SegCurData: Not fully known yet but...
	;	Lower nibble holds index to Level_SegmentDefs (current segment)
	;	Upper nibble set by Level_SegmentDefs, indexed by the lower nibble; see following defs
SEGDIR_BOSSGATE		= $10	; Boss gate is the next segment to the right (combine with SEGDIR_HORIZONTAL)
SEGDIR_HORIZONTAL	= $20	; Segment horizontal scrolling (typical)
SEGDIR_DOWN			= $40	; Segment allows downward transit transition
SEGDIR_UP			= $80	; Segment allows upward transit transition
	Level_SegCurData:		.ds 1	 ; $002B
					.ds 1	; Unused

	; Level_SegTotalRelScreen / Level_SegCurrentRelScreen
	; Total screens for current segment (before a transition happens) and current
	; relative screen you're on (towards the total); once the final screen is
	; reached, horizontal scrolling (if applicable) stops...
	Level_SegTotalRelScreen:		.ds 1
	Level_SegCurrentRelScreen:		.ds 1
	
	Level_LastScrollDir:		.ds 1	 ; 1 for right / up, 2 for left / down
	
	; Player_State:
	;	NOTE: A lot of game logic checks if Player_State >= PLAYERSTATE_HURT and
	;	decides in general not to damage Player if that case is true.
PLAYERSTATE_STAND		= 0		; Player standing on ground
PLAYERSTATE_FALLJUMP	= 1		; Player falling/jumping
PLAYERSTATE_SLIDING		= 2		; Player sliding on ground
PLAYERSTATE_CLIMBING	= 3		; Player is climbing on ladder
PLAYERSTATE_RUSHMARINE	= 4		; Player is riding in Rush Marine
PLAYERSTATE_WIREADAPTER	= 5		; Player is using Wire Adapter
PLAYERSTATE_HURT		= 6		; Player hurt
PLAYERSTATE_DEAD		= 7		; Player is dead
PLAYERSTATE_TELEPORTOUT	= 8		; Player teleport out, end level
PLAYERSTATE_BOSSWAIT	= 9		; Player is waiting for boss to do intro / fill energy
PLAYERSTATE_READY		= 10	; "READY" opening animation, teleport in
PLAYERSTATE_ENDLEVEL	= 11	; Player runs to center to gain power (unless TileMap_Index >= 8), and then leads to PLAYERSTATE_TELEPORTOUT
PLAYERSTATE_COSSACKGRAB	= 12	; Player grabbed by Cossack boss claw grip
PLAYERSTATE_POSTCOSSACK	= 13	; Afted defeating Cossack, Player marches to left side
PLAYERSTATE_POSTCOSSCIN	= 14	; Post-Cossack cinematic sequence
PLAYERSTATE_WILYTRANS	= 15	; Wily transporter teleporting
PLAYERSTATE_COSSBOSSWLK	= 16	; The dual Cossack boss needs the Player to step forward a bit; that's this
PLAYERSTATE_GOTSPWEAPON	= 17	; Player got special weapon (e.g. Wire Adapter)
PLAYERSTATE_POSTWILY	= 18	; Sound_NoteTicksLeft defeating final Wily boss, Player walks left and holds
PLAYERSTATE_TELEPORTEND	= 19	; Sound_NoteTicksLeft defeating final Wily boss, Player teleports out and starts ending sequence
	Player_State:		.ds 1
	Player_FaceDir:		.ds 1	 ; 1 for right, 2 for left
	Player_ShootAnimTimer:		.ds 1	 ; Counts down to zero; as zero is reached, clears Player_CurShootAnim

	; Player_CurShootAnim:
PLAYERCSA_NOSHOOT	= 0
PLAYERCSA_SHOOT		= 1
PLAYERCSA_THROW		= 2
	Player_CurShootAnim:		.ds 1	 ; An animation offset based on what's appropriate for the player's current "shooting" (generic way to offset for standing, walking, on ladder, etc.) -- basically, 0 = not shooting, 1 = shooting, 2 = throwing
	Player_SlideTimer:		.ds 1	 ; Ticks down to zero; Player is sliding while active
	Player_MBusterChargeLevel:		.ds 1	 ; $0035
	Player_MBustDischargePalIdx:		.ds 1	 ; Palette index used immediately Sound_NoteTicksLeft discharging Mega Buster
	
	; These together define the Player's horizontal movement speed.
	Player_HCurSpeedFrac:		.ds 1	; "Fractional" component of Player's horizontal speed
	Player_HCurSpeed:			.ds 1	; "Whole" component of Player's horizontal speed
	
	; Player_TMWaterPush* -- override values used for Toad Man's
	; "water pushing"; temporarily overrides Player's X velocity
	; and facing direction to execute (restored after the move is
	; made); enabled by Player_TMWaterPushFaceDir being non-zero
	Player_TMWaterPushFaceDir:		.ds 1	 ; $0039
	Player_TMWaterPushXVelFrac:		.ds 1	 ; $003A
	Player_TMWaterPushXVel:		.ds 1	 ; $003B
	
	Player_PlayerHitInv:		.ds 1	 ; $003C
	Player_TriggerDeath:		.ds 1	 ; Triggers death sequence (always set to $FF? Does it matter?)
	RAM_003E:		.ds 1	 ; $003E
	Player_HitWallR_Flag:		.ds 1	 ; Will be set if Player walked right (direction) into wall, otherwise $00
	Level_TileDetOff_Index:		.ds 1	 ; During tile detection loop, current index into the relevant "spread" array
	Level_TileAttr_GreatestDet:		.ds 1	 ; The "greatest" tile attribute value detected last pass
	Player_Y:		.ds 1	 ; $0042
	Player_WaterPhysFudge:		.ds 1	 ; Remains at zero if not in water, cycles 0-3 otherwise, provides "boost" when jumping for floaty physics in water
	Player_LastTileAttr:		.ds 1	 ; Last "greatest" (Level_TileAttr_GreatestDet) tile effect, used as a specialized temp
	
	; Level_TileAttrsDetected:
	; Up to 4 tile attributes to be detected (as detected, total amount specified by PRG062_TDetOffsetSpread table)
	; Note this same space is also used as scratch vars periodically, because why not.
	Level_TileAttrsDetected:		.ds 4	 

	; Ugly, but what can ya do
Temp_Var45 = Level_TileAttrsDetected+$00
Temp_Var46 = Level_TileAttrsDetected+$01
Temp_Var47 = Level_TileAttrsDetected+$02
Temp_Var48 = Level_TileAttrsDetected+$03

	Temp_Var49:		.ds 1	 ; This one's totally temp though
	
	RAM_004A:		.ds 1	 ; $004A
	WeaponMenu_BackupPalAnims:		.ds 5	 ; Backs up palette animation data when opening weapons menu
	
	; Vars for doing dynamic CHR RAM loading during gameplay
	CHRRAMDL_LastPalLoad:		.ds 1
	CHRRAMDL_LastPalIndex:		.ds 1
	CHRRAMDLPtr_L:				.ds 1
	CHRRAMDLPtr_H:				.ds 1
	CHRRAMDL_BankLoadFrom:		.ds 1
	CHRRAMDL_GBufDataLen:		.ds 1
	CHRRAMDL_GBufDataSrcAddrL:	.ds 1
	CHRRAMDL_GBufDataSrcAddrH:	.ds 1
	CHRRAMDL_GBufVRAML:			.ds 1
	CHRRAMDL_GBufVRAMH:			.ds 1
	
	; ^ Ending overlaps those vars
EndTrainText_VRAMHigh 	= CHRRAMDL_LastPalLoad		; VRAM address high component of the text printing
EndTrainText_VRAMLow 	= CHRRAMDL_LastPalIndex		; VRAM address low component of the text printing
EndTrainText_TextPtrL	= CHRRAMDLPtr_L				; Address low component of text printing
EndTrainText_TextPtrH	= CHRRAMDLPtr_H				; Address high component of text printing
EndTrainText_NxtLnDelay	= CHRRAMDL_BankLoadFrom		; Tick delay before next line of text
EndTrain_CurPalIndex	= CHRRAMDL_GBufDataLen		; Current palette during train ending sequence


	Level_TileDetOffPtr_L:	.ds 1	 ; $005A
	Level_TileDetOffPtr_H:	.ds 1	 ; $005B
	Raster_VSplit:			.ds 1	 ; Raster_VSplit_Req is copied to this value which is pushed to the MMC3 scanline regs
	IntIRQ_FuncSel:			.ds 1	 ; Selects what function to call during scanline interrupt (-> IntIRQ_FuncPtr_L/H) (set by Raster_VMode)
	IntIRQ_FS1_HScrl:		.ds 1	 ; Used only when IntIRQ_FuncSel = 1, sets the horizontal scroll register
					.ds 1	; unused
	PalAnim_CurIndex:		.ds 1	 ; Current index of palette animation processing
	
	; PalAnim_CommitCount: Number of palette animations run will set this count, including 
	; if a commit was due prior to animating. This count doesn't really have any use, I think
	; it just exists to avoid any potential timing glitches with the palette commit during
	; the NMI. Basically any non-zero value will commit the palette. See anim code for more.
	PalAnim_CommitCount:	.ds 1
	
	PalAnim_PtrL:		.ds 1	 ; Palette animation pointer low
	PalAnim_PtrH:		.ds 1	 ; Palette animation pointer high
	
	; Pal_FadeMask: For palette fade in/out routines, can mask quadrants of colors that
	; should not be effected by the fade. The LSB would be the last quadrant (the last
	; 4 sprite colors) and the MSB would be the first quadrant (the first 4 BG colors.)
	; BBBB SSSS
	; 0123 0123
	Pal_FadeMask:		.ds 1	 ; $0064
	
	Raster_VSplit_VPos:		.ds 1	 ; $0065
	Raster_VSplit_HPos:		.ds 1	 ; When doing a vertical raster scanline split, specifies the current horizontal position of the "upper half"; use Raster_VSplit_HPosReq to change
	PPU_CTL1_PageBaseSel:		.ds 1	 ; Lower 2 bits OR'ed in with other PPU_CTL1 settings, specifically selecting the base nametable (i.e. wrap controls)
					.ds 1	; unused
	Raster_VSplit_HPosReq:		.ds 1	 ; Requested horizontal value above a vertical raster scanline split; copied to Raster_VSplit_HPos
	PPU_CTL1_PageBaseReq_RVBoss:		.ds 1	 ; $006A In certain raster modes, this gets pushed to PPU_CTL1_PageBaseSel
	Player_EnergyGainCounter:		.ds 1	 ; $006B Just used as a counter for energy-gaining pickups, generally contained to PRG059, although a weird fringe use exists in PRG062 that never does anything
	CineCsak_CurDialogSet:		.ds 1	 ; Current set of dialog during the post-Cossack cinematic dialog
	CineCsak_TextOffset:		.ds 1	 ; Text offset witin dialog block during the post-Cossack cinematic dialog
	CineCsak_TextPtrL:		.ds 1	 ; Base pointer to the dialog block during the post-Cossack cinematic dialog
	CineCsak_TextPtrH:		.ds 1	 ; Base pointer to the dialog block during the post-Cossack cinematic dialog
	
							.ds 16	; unused?
	
		
	; The "exec slots" seem to provide a stack outside of the 6502's stack.
	; This enables the game to completely reset the 6502 stack for some reason.
	; (Seems like a weird programming practice? But, all right, Capcom...)
	;
	; Basically an exec slot either contains an absolute jump address or it
	; contains a stack register value that can be restored later. Sound_NoteTicksLeft a slot
	; with flag 4 or 8 has been processed, the flag value is set to 2.
	;
	; 0: Flag:
	;	- 0: ?
	;	- 1: ?
	;	- 2: Exec slot fulfilled / not in use ???
	;	- 4: Only offset 2 of jump address is used and it holds a stack register value
	;   - 8: Jump address contains literal jump address to execute
	; 1: Always 1?
	; 2/3: Jump address
	;	- If flag is set to 4, only offset 2 is used, and it stores a stack register value
	;	- If flag is set to 8, jump address is an absolute jump address
	ExecState_Slots:	.ds 16	 ; $0082
	
	RAM_0090:		.ds 1	 ; $0090
	ExecState_SlotDepth:		.ds 1	 ; Current depth into the exec slots
	Frame_Counter:		.ds 1	 ; Increments every V-Blank
	Temp_AddrL:		.ds 1	 ; $0093
	Temp_AddrH:		.ds 1	 ; $0094
	General_Counter:		.ds 1	 ; Free-running counter in level, also used on stage select to time the Dr. Cossack appearance flash
	Spr_SlotIndex:		.ds 1	 ; $0096 Slot index for sprites ($00-$17)
	Sprite_CurrentIndex:		.ds 2	 ; $0097 - $0098
	Gravity:		.ds 1	 ; Current rate all objects are pulled down (usually $40, an underwater Metall sets it temporarily to $15)
	DisFlag_NMIAndDisplay:		.ds 1	 ; Next NMI, the display and NMIs will be disabled
	RasterSplit_En:		.ds 1	 ; 0 = Disable MMC3 raster split interrupt, 1 = enable (NOTE: MUST be 0 or 1 due to the way it's coded)
	IntIRQ_FuncPtr_L:		.ds 1	 ; Low address for function executed on the scanline interrupt
	IntIRQ_FuncPtr_H:		.ds 1	 ; High address for function executed on the scanline interrupt
	RAM_009E:		.ds 1	 ; $009E (FIXME: Might be "rightmost object spawn index?")
	RAM_009F:		.ds 1	 ; $009F (FIXME: Might be "leftmost object spawn index?")

	 ; Currently select weapon (not enough to just change this as palette / graphics will be wrong)
PLAYERWPN_MEGABUSTER	= 0		; 0 = Mega Buster
PLAYERWPN_RUSHCOIL		= 1		; 1 = Rush coil
PLAYERWPN_RUSHJET		= 2		; 2 = Rush Jet
PLAYERWPN_RUSHMARINE	= 3		; 3 = Rush Marine
PLAYERWPN_TOADRAIN		= 4		; 4 = Toad Rain
PLAYERWPN_WIREADAPTER	= 5		; 5 = Wire adapter
PLAYERWPN_BALLOON		= 6		; 6 = Balloon
PLAYERWPN_DIVEMISSILE	= 7		; 7 = Dive Missile
PLAYERWPN_RINGBOOMERANG	= 8		; 8 = Ring
PLAYERWPN_DRILLBOMB		= 9		; 9 = Drill
PLAYERWPN_DUSTCRUSHER	= 10	; 10 = Dust
PLAYERWPN_PHARAOHSHOT	= 11	; 11 = Pharaoh
PLAYERWPN_FLASHSTOPPER	= 12	; 12 = Bright
PLAYERWPN_SKULLBARRIER	= 13	; 13 = Skull
	Player_CurWeapon:		.ds 1
	
	Player_Lives:		.ds 1	 ; Player's lives
	Player_EnergyTanks:		.ds 1	 ; Player's energy tanks
	Player_LandPressLR:		.ds 1	 ; Player pressing LEFT/RIGHT at the moment they land
	Player_OnIce:		.ds 1	 ; Set if Player is on ice
	
	; Player_Land*: Variabels set immediately when Player lands
	Player_SlipXVelFrac:	.ds 1	 ; Factor applied towards XVelFrac when slipping
	Player_SlipXVel:		.ds 1	 ; Factor applied towards XVel when slipping
	Player_LandXVelFrac:	.ds 1	 ; XVelFrac when Player landed
	Player_LandXVel:		.ds 1	 ; XVel when Player landed
	
	; Player_CompletedBosses: Bitfield of completed bosses
	;	$01 - Bright Man
	;	$02 - Toad Man
	;	$04 - Drill Man
	;	$08 - Pharaoh Man
	;	$10 - Ring Man
	;	$20 - Dust Man
	;	$40 - Dive Man
	;	$80 - Skull Man
	Player_CompletedBosses:		.ds 1
	Player_CompletedFortLvls:	.ds 1	 ; Similar bitfield of completed Cossack/Wily fortress levels
	
	WilyTrans_CurPortal:		.ds 1	 ; Last Wily transporter entered
	LevelWily3_TransSysComp:		.ds 1	 ; Completed Wily Transport System bosses
	Player_FreezePlayerTicks:		.ds 1	 ; Player is frozen while non-zero, counts to zero
		.ds 2	; Unused
	
	; Player HP: $9C is max, $80 never-reached min, $00 if dead
	Player_HP:		.ds 1	 ; $00B0
	
	; Player_WpnEnergy: All the different weapon energy amounts
	; $9C is max, $80 is min, $00 means you don't have it at all
	;
	; Offsets:
	; 00 = Rush coil
	; 01 = Rush Jet
	; 02 = Rush Marine
	; 03 = Toad Rain
	; 04 = Wire adapter
	; 05 = Balloon
	; 06 = Dive Missile
	; 07 = Ring
	; 08 = Drill
	; 09 = Dust
	; 10 = Pharaoh
	; 11 = Bright
	; 12 = Skull
	; 13 = Mega Buster (not really used, forced to $9C usually, though the meter is drawn like the others so it can be less than this)
	Player_WpnEnergy:		.ds 14
	Boss_HP:		.ds 1	 ; Boss HP $00 min, $1C max (no bit 7 muck here)
	
	; SndMus_DisFlags:
	; FIXME: I don't think I understand this right... bit $01 set actually fetches data
	; and updates SFX from the processing side
	SndMus_DisFlags:		.ds 1	 ; Bit 0 ($01) set disables music and sound updating, Bit 1 ($02) set disables music updates only
	
	MusSnd_TempVar0:	.ds 1	 ; TempVar used in music/sound code
	MusSnd_TempVar1:	.ds 1	 ; TempVar used in music/sound code
	MusSnd_TempVar2:	.ds 1	 ; TempVar used in music/sound code
	MusSnd_TempVar3:	.ds 1	 ; TempVar used in music/sound code
	MusSnd_PatchPtr_L:		.ds 1	 ; Low part of address of instrument patch data (from within PRG030_PatchData)
	MusSnd_PatchPtr_H:		.ds 1	 ; High part of address of instrument patch data (from within PRG030_PatchData)
	
	; Music tempo accumulator value
	MusTempoAccum:		.ds 1	; This specifically is used to decrement ticks (so 2 is twice as fast as 1)
	MusTempoAccum_Frac:	.ds 1	; Fractional accumulation for MusTempo_Frac
	
	; Added to MusTempoAccum_H/L -- sets music speed
	MusTempo:			.ds 1	 ; Sets the speed of tick decrement per frame (so 2 is twice as fast as 1)
	MusTempo_Frac:		.ds 1	 ; Fractional component; can allow for fractional frame speeds
	
	Mus_NoteTranspose:	.ds 1	 ; Added to note value 
	Mus_MasterVol_Dir:	.ds 1	 ; $00 means Mus_MasterVol = $00 is loudest, $80 means Mus_MasterVol = $FF is loudest
	Mus_MasterVol:		.ds 1	 ; Sets master volume level; see Mus_MasterVol_Dir
	Sound_CurSFXPriority:	.ds 1	 ; Arbitrary value assigned to sound effects to determine if a "more important" sound effect is currently playing (so an SFX with a lower priority number in its header cannot play)
	; Sound_MusOverrideFlags: Each bit set disables a channel of music for sound playback
	;	$01 - Square 1
	;	$02 - Square 2
	;	$04 - Triangle
	;	$08 - Noise
	Sound_MusOverrideFlags:		.ds 1
	SndPtr_L:		.ds 1	 ; $00D0
	SndPtr_H:		.ds 1	 ; $00D1
	Snd_NoteTranspose:		.ds 1	 ; $00D2 Added to note value for sound effects
	Sound_RestTimer:		.ds 1	 ; $00D3 While non-zero, decrements to zero, pausing SFX processing
	RAM_00D4:		.ds 1	 ; $00D4
	RAM_00D5:		.ds 1	 ; $00D5
	
	; Sound_LoopCounter
	; Bit 7 ($80) is set if perpetual loop mode is enabled (not used by MM4, but fully functional)
	; Bits 0-6 hold the loop counter value for the internal loop command (nothing to do with the perpetual loop mode)
	Sound_LoopCounter:		.ds 1	 ; $00D6
	
	; Sound_PostSFXQueueOff:
	; If non-zero, This value will chain the SFX system to play a sound after
	; the current one finishes. This does not reset after the sound plays so
	; it loops forever until modified. This can be used to either loop a single
	; sound or chain a sound so that it has a "start" and a "loop" section.
	; This was not used by MM4, but I think MM5 did and maybe others.
	;
	; This value is based an offset into the address table, so the value 
	; (if non-zero) must be the same as "intended SFX_ (value * 2 + 1)", e.g.:
	;
	; If intended post-play sound is:
	; SFX_PLAYERSHOT				= $21
	;
	; value in Sound_PostSFXQueueOff should be $21 * 2 + 1 = $43
	;
	; Finally, value MUST be an SFX, NOT music
	Sound_PostSFXQueueOff:		.ds 1	 ; $00D7
	
	RAM_00D8:		.ds 1	 ; $00D8
	Mus_Cur:		.ds 1	 ; $00D9
	MusSnd_TriggerCurIdx:		.ds 1	 ; Current index into Sound_Trigger (queuing)
	MusSnd_ProcessTriggerCurIdx:		.ds 1	 ; Current index into Sound_Trigger (processing)
	Sound_Trigger:		.ds 8	 ; TODO: Describe better; 8 slots of sound triggers, $88 is idle, not fully sure how these work yet
	RandomN:		.ds 4	 ; Array of randomly scribbled numbers
	
	; ISR_BackupAddr: Backs up an ISR address when music/sound (FIXME) something happens
	ISR_BackupAddr_L:		.ds 1	 ; $00E8
	ISR_BackupAddr_H:		.ds 1	 ; $00E9
	
	RAM_00EA:		.ds 1	 ; $00EA
	SprObj_SlotIndex:		.ds 1	 ; $00EB
	MMC3_PageA000_Backup:		.ds 1	 ; $00EC
	RAM_00ED:		.ds 1	 ; $00ED
	RAM_00EE:		.ds 1	 ; $00EE
	Object_ReqBGSwitch:		.ds 1	 ; Set to $B8 or $01 to put current object in BG
	
	; Raster_VMode: Change the current scanline split operation
	; Will be copied into IntIRQ_FuncSel
RVMODE_NONE			= $00	; No split operation (normal scrolling)
RVMODE_RMBOSS		= $01	; Ring Man hippo sub-boss (Kabatoncue)
RVMODE_DMSBOSS		= $02	; Dive Man whale sub-boss (Moby)
RVMODE_CBOSS1		= $03	; Cossack Boss 1 (giant moth thing Mothraya)
RVMODE_DUSTMANCRUSH	= $04	; Dust Man's crushing segment
RVMODE_DMWATER		= $05	; Dive Man's dynamic water level
RVMODE_CBOSS4		= $06	; Cossack Boss 4 (Dr. Cossack)
RVMODE_CBOSS2		= $07	; Cossack Boss 2 (the triple-mirrored split)
RVMODE_CINEDIALOG	= $08	; Cinematic dialog post-Cossack boss
RVMODE_WBOSS1		= $09	; Wily Boss 1 (Giant Mettool)
RVMODE_INTROTRAIN1	= $0A	; Intro train scrolling sky
RVMODE_INTROTRAIN2	= $0B	; Intro train scrolling sky, train rolling away
	Raster_VMode:		.ds 1
	Raster_VSplit_Req:		.ds 1	 ; Scanline where vertical split happens, copied to Raster_VSplit
	MMC3_PrevCmd:		.ds 1	 ; Previous MMC3 command
	MMC3_Page8000:		.ds 1	 ; Current bank at $8000
	MMC3_PageA000:		.ds 1	 ; Current bank at $A000
	MMC3_Page8000_Req:		.ds 1	 ; Requested bank to be at $8000
	MMC3_PageA000_Req:		.ds 1	 ; Requested bank to be at $A000
	MMC3_PageChng_InP:		.ds 1	 ; Non-zero during a page change operation

	; MusSnd_NeedsUpdateInt:
	; If a music/sound update was desired, but the interrupt occurred in the middle 
	; of a page switch (per PRG063_SetPRGBanks), this flag will be set. The next
	; music/sound update will then be performed after PRG063_SetPRGBanks completes.
	; THIS IS IMPORTANT because NOTHING changes MMC3 pages in the VBlank interrupt
	; except music/sound, so this flag prevents a potential timing glitch that can
	; occur if the interrupt happens between the MMC3 command being issued and
	; the requested page!!
	MusSnd_NeedsUpdateInt:	.ds 1

	Current_Screen:		.ds 1	 ; Current screen the player is on
	Vert_Scroll:		.ds 1	 ; $00FA
	RAM_00FB:		.ds 1	 ; $00FB
	Horz_Scroll:		.ds 1	 ; $00FC
	PPU_CTL1_PageBaseReq:		.ds 1	 ; $00FD Pushed to PPU_CTL1_PageBaseSel
	PPU_CTL2_Copy:		.ds 1	 ; $00FE
	PPU_CTL1_Copy:		.ds 1	 ; $00FF
	
	; Spr_NoRespawnBits: Bytes which hold bitfields that mark objects to never respawn from the level set.
	;	So each byte represents 8 objects from the level data
	;	A bit being set here means to not spawn this object when the spawn cycle comes around.
	;	Since there's 32, that means there's a maximum of 256 supported objects (which makes sense)
	Spr_NoRespawnBits:	.ds 32 	; $0100 - $011F
	
	; Ring Man's rainbow platforms, up to 4 could be active (but I don't think that can even happen)
	RingManRainbowPlat_Data:	.ds 4	 ; Bit 7 ($80) sets it active, bit 6 ($40) requests an update, the lower 6 bits are its operating screen
	RingManRainbowPlat_VH:		.ds 4	 ; VRAM Address High
	RingManRainbowPlat_VL:		.ds 4	 ; VRAM Address Low
	RingManRainbowPlat_Cnt:		.ds 4	 ; $012C - $012F
	
	; HUDBar[P/W/B]_DispSetting (P = Player's HP, W = Player's Weapon, B = Boss) Energy bar:
	; Bit $80 must be set for it to display at all
	; The lower nibble specifies which offset from Player_HP to display.
	; NOTE: 
	;	HUDBarP_DispSetting will thus always be $80 or $00, since nothing else makes sense
	;	HUDBarW_DispSetting should be in the range of $81-$8D, or $00 if no weapon selected/etc.
	;	HUDBarB_DispSetting will thus always be $8F or $00, since nothing else makes sense
	HUDBarP_DispSetting:		.ds 1
	HUDBarW_DispSetting:		.ds 1
	HUDBarB_DispSetting:		.ds 1
	Level_ExitTimeout:		.ds 1	 ; $0133 Counts to zero and exits level, but only if Player is in state PLAYERSTATE_TELEPORTOUT
	Level_ExitTimeoutH:		.ds 1	 ; $0134 "High" part of Level_ExitTimeout, in use Sound_NoteTicksLeft dying only
	
	; Level_LightDarkCtl:
	;	- $00: Bright
	;	- $01: Darkening
	;	- $40: Dark
	;	- $80: Brightening up
	Level_LightDarkCtl:		.ds 1
	Level_LightDarkTransCnt:		.ds 1	 ; $0136
	Level_LightDarkTransLevel:		.ds 1	 ; $0137
	Player_WpnMenuCurSel:		.ds 1	 ; Current selection in weapon menu (does not indicate Player's current power-up, but is used to restore menu highlight when you return)
	Player_WpnMenuLastSel:		.ds 1	 ; "Last" selected weapon (will be synced to Player_WpnMenuCurSel)
	Weapon_ToadRainCounter:		.ds 1	 ; Counts down to zero; while active, rain effect is happening
	Weapon_ToadRain_XYOff:		.ds 1	 ; Added to sprites X and Y to offset rain sprites
	Weapon_FlashStopCnt:		.ds 2	 ; 16-bit flash stopper counter (non-zero, flash is active)
	Level_RasterYOff:		.ds 1	 ; $013E
	Level_RasterVDir:		.ds 1	 ; $013F
	DustManCrsh_BlkShotOutScr:		.ds 1	 ; Screen of Dust Man crusher block to shoot out
	DustManCrsh_BlkShotOutMeta:		.ds 1	 ; Metatile selector of Dust Man crusher block to shoot out
	DustManCrsh_BlkShotOutCol:		.ds 1	 ; Column within metatile of Dust Man crusher block to shoot out
	Level_DarkTimer:		.ds 2	; 16-bit counter while shrouded in darkness in Bright Man
	ToadRain_OwnerIndex:		.ds 1	 ; Object index where the Toad Rain canister was spawned
	Boss_SprIndex:		.ds 1	 ; Sprite object slot index where a boss resides
	TileMap_IndexBackup:		.ds 1	 ; $0147
	Level_EndLevel_Timeout:		.ds 1	 ; During PLAYERSTATE_ENDLEVEL, counts to zero before progressing
	WilyTrans_LastTransParentIdx:		.ds 1	 ; ID of last transporter entered
	
	; STACK RESERVATION
	.ds 182 ; $014A - $01FF This is for stack space so don't use it
	Stack_Bottom:
	
; Sprite memory is laid out in four bytes:
; Byte 0 - Stores the y-coordinate of the top left of the sprite minus 1.
; Byte 1 - Index number of the sprite in the pattern tables.
; Byte 2 - Stores the attributes of the sprite.
; * Bits 0-1 - Most significant two bits of the colour.
; * Bit 5 - Indicates whether this sprite has priority over the background.
; * Bit 6 - Indicates whether to flip the sprite horizontally.
; * Bit 7 - Indicates whether to flip the sprite vertically.
; Byte 3 - X coordinate
;
; Relevant flags
SPR_PAL0	= %00000000
SPR_PAL1	= %00000001
SPR_PAL2	= %00000010
SPR_PAL3	= %00000011
SPR_BEHINDBG	= %00100000
SPR_HFLIP	= %01000000
SPR_VFLIP	= %10000000
	Sprite_RAM:		.ds 256	 ; $0200
	
	; Spr_SlotID:
	; Indexes PRG062_Spr_Bank to select the source bank for the sprite data.
	; Some exceptions are coded for the different sprite slot IDs.
	; Further selected by the Spr_CurrentAnim.
	; Must be non-zero or else sprite is not drawn.
	;
	; Some indexes are reserved for Player:
	;	0: 		Main Player object
	;	1-3: 	Player projectiles
	;	4:		Rush
	;	5:		Decorative Player sprites, e.g. "dust" when sliding, water splashes, etc.
	Spr_SlotID:		.ds 24	 ; Sprite  IDs
	
	Spr_XVelFracAccum:		.ds 24	 ; Accumulator of fractional X velocity (to add Spr_XVelFrac and overflow into carry)
	Spr_X:		.ds 24	 ; Sprite X position
	Spr_XHi:		.ds 24	 ; $0348
	Spr_YVelFracAccum:		.ds 24	 ; Accumulator of fractional Y velocity (to add Spr_YVelFrac and overflow into carry)
	Spr_Y:		.ds 24	 ; Sprite Y position
	Spr_YHi:		.ds 24	 ; $FF (-1) if above top of screen, 1 if below bottom of screen
	Spr_XVelFrac:		.ds 24	 ; "Fractional" X velocity, which is added to Spr_XVelFracAccum which applies carry with Spr_XVel which is added to Spr_X
	Spr_XVel:		.ds 24	 ; X velocity to objects (will be applied left/right by object's facing direction)
	Spr_YVelFrac:	.ds 24	 ; "Fractional" Y velocity, which is added to Spr_YVelFracAccum which applies carry with Spr_YVel which is added to Spr_Y
	Spr_YVel:		.ds 24	 ; Y velocity to objects (positive moves up)
	
	; Spr_Flags2:
	;	Bits 0-5: [$00-$3F] Specifies a bounding box for the object (see PRG063_ObjBoundBoxWidth / PRG063_ObjBoundBoxHeight)
	;	Bit 6: If set, object is permitted to be shot (otherwise projectiles deflect)
	;	Bit 7: If set, object will hurt the Player if touched
SPRFL2_SHOOTABLE	= $40
SPRFL2_HURTPLAYER	= $80
	Spr_Flags2:		.ds 24	 ; $0408


	; Rough angles cooresponding to PRG063_Aim_FaceDir as generated by PRG063_AimTowardsPlayer and such
SPRAIM_ANG_0	= $00	; Up
SPRAIM_ANG_22	= $01
SPRAIM_ANG_45	= $02	; Up-right
SPRAIM_ANG_67	= $03
SPRAIM_ANG_90	= $04	; Right
SPRAIM_ANG_112	= $05
SPRAIM_ANG_135	= $06	; Down-right
SPRAIM_ANG_157	= $07
SPRAIM_ANG_180	= $08	; Down
SPRAIM_ANG_202	= $09
SPRAIM_ANG_225	= $0A	; Down-left
SPRAIM_ANG_247	= $0B
SPRAIM_ANG_270	= $0C	; Left
SPRAIM_ANG_292	= $0D
SPRAIM_ANG_315	= $0E	; Up-Left
SPRAIM_ANG_337	= $0F
	
	; Spr_FaceDir: Employed by PRG063_F413 or PRG063_F3ED
	; Most importantly, "Up" will reverse the application of Y velocity,
	; Left will clear hflip, right will set hflip, in one variant of the 
SPRDIR_RIGHT	= 1
SPRDIR_LEFT		= 2
SPRDIR_DOWN		= 4
SPRDIR_UP		= 8	
	Spr_FaceDir:	.ds 24	 ; Sprite facing direction (1 for right, 2 for left, 4 for down, 8 for up)
	Spr_SpawnParentIdx:		.ds 24	 ; Spawn index from level data that "owns" the level to prevent multiple spawns; $FF means "no parent" (e.g. dynamically spawned stuff)
	Spr_HP:			.ds 24	 ; HP of object (not Player though)
	Spr_Var1:		.ds 24	 ; NOTE: Player uses index 0 to hold the "previous state" when they get hit
	Spr_Var2:		.ds 24	 ; $0480
	Spr_Var3:		.ds 24	 ; $0498
	Spr_Var4:		.ds 24	 ; NOTE: Player uses index 0 for Rush Jet riding flag
	Spr_Var5:		.ds 24	 ; NOTE: Player uses index 0 for held Pharaoh Shot slot index
	Spr_Var6:		.ds 24	 ; NOTE: Player uses index 0 for Flash Stopper background flashing
	Spr_Var7:		.ds 24	 ; NOTE: In state PLAYERSTATE_POSTCOSSACK, acts as a countdown before cinematic kicks off
	Spr_Var8:		.ds 24	 ; NOTE: Player uses index 0 for the Rush Marine decrement counter
	
	; Spr_Flags: Note that a pretty common base bits set for typical objects is (SPRFL1_ONSCREEN | SPRFL1_SCREENREL)
SPRFL1_NOHITMOVEVERT	= $01	; Player detection disabled if moving vertically (e.g. Rush teleporting away should not longer respond to Player)
SPRFL1_OBJSOLID			= $02	; Object is fully solid if set
SPRFL1_NODRAW			= $04	; Don't draw if set
SPRFL1_PERSIST			= $08	; Persist if off-screen
SPRFL1_SCREENREL		= $10	; If set, object will be screen-relative
; $20 = SPR_BEHINDBG
; $40 = SPR_HFLIP
SPRFL1_ONSCREEN			= $80	; Set if object is on-screen
	Spr_Flags:		.ds 24	 ; $0528
	
	Spr_Frame:		.ds 24	 ; $0540
	
	; Spr_CurrentAnim:
	; Selects the sprite animation from within the bank as set by Spr_SlotID
	; Must be non-zero or else no sprite is drawn
	Spr_CurrentAnim:		.ds 24
	
	; Spr_AnimTicks: Animation ticks that count up for current animation frame
	Spr_AnimTicks:		.ds 24
	
	; Spr_CodePtr: Object's currently executing code (initialized from default
	; if Spr_CodePtrH bit $80 not set, so can't be in RAM I guess)
	Spr_CodePtrL:		.ds 24
	Spr_CodePtrH:		.ds 24
	
	; Spr_FlashOrPauseCnt: When not zero, decrements towards zero (irrespective of bit $80) in two different modes
	;	If bit $80 is not set, do "flashing invincibility" effect (note: does not in and of itself actually grant invincibility)
	;	If bit $80 is set, halt animation and movement
	Spr_FlashOrPauseCnt:		.ds 24
	
	; Unused space I think... multiple of 24, maybe was reserved sprite functionality?
					.ds 48
	
	PalData_1:		.ds 32	; "Current" palette
	PalData_2:		.ds 32	; "Master copy" palette
	
	Pattern_AttrBuffer:		.ds 64	 ; $0640 - $067F
	
	; Level_ScreenTileModData: Variable purpose dynamic tile mod data
	; Generally seems to be used to set a bit per tile row to mark it as "unsolid"
	;	Usages:
	;	Dust Man: Crusher segment, shootable blocks
	;	Ring Man: Rainbow platforms
	Level_ScreenTileModData:		.ds 64
	
	Pattern_Buffer:		.ds 16	 ; $06C0
	RAM_06D0:		.ds 32
	
	; PalAnim_EnSel: Index per BG palette quadrant:
	;	Bits 0-5 animation index (0 to 63) into PRG032_PalAnim_Table_L/H
	;	Bit 7 ($80) set enables animation on this quadrant
	;
	; NOTE: There's a hack for $87 specifically (enabled, index 7); see near PRG032_B8AD
	; It animates the sprite palette with the BG palette
	PalAnim_EnSel:	.ds 4	 ; $06F0-$06F3
	
	; PalAnim_CurAnimOffset: Current offset within the palette animation data (PRG032_PalAnim_Table data offset 2+PalAnim_CurAnimOffset)
	PalAnim_CurAnimOffset:	.ds 4	 ; $06F4 - $06F7
	
	; PalAnim_TickCount: Current tick count for animation, limit set by byte 1 of (PRG032_PalAnim_Table data)
	PalAnim_TickCount:		.ds 4	 ; $06F8 - $06FB
	
	; UNUSED SPACE
		.ds 4	 ; $06FC - $06FF
	
	; MUSIC FORMAT
	;
	; Music byte stream values >= 0x20 are a note
	; Upper 3 bits select a delay value from PRG030_DelayTable1 or PRG030_DelayTable2 depending on bit 5 of Music_TrackOctaveTimingCtl
	; If lower 5 bits are all zero, value is rest, otherwise it's a note select
	;
	; Music commands (byte stream values < 0x20)
MCMD_TOGGLE_TIME_SEL		= $00	; [0P] Toggle timing select
MCMD_TOGGLE_SINE_RESET		= $01	; [0P] Toggle sine reset
MCMD_SET_1_5X_TIMING		= $02	; [0P] Set 1.5x timing
MCMD_TOGGLE_OCTAVE_HIGH		= $03	; [0P] Toggle highest octave bit
	; Music commands >= 0x04 implicitly obtain at one parameter byte, although additional ones may be fetched
MCMD_TRACK_CONFIG			= $04	; [1P] Set bits 3, 5, and 6 on Music_TrackOctaveTimingCtl according to parameter
MCMD_TEMPO_SET				= $05	; [2P] Set tempo MusTempo = parameter 1 and MusTempo_Frac = parameter 2
MCMD_NOTEATTACKLEN_SET		= $06	; [1P] Music_NoteAttackLength = parameter
MCMD_SYNTH_VOLUME_SET		= $07	; [1P] New synth vol = parameter (lower 4 bits only)
MCMD_PATCH_SET				= $08	; [1P] Set patch = parameter
MCMD_OCTAVE_SET				= $09	; [1P] Set octave = parameter [expecting 0 to 7]
MCMD_GLOBAL_TRANSPOSE_SET	= $0A	; [1P] Global transpose = parameter
MCMD_TRACK_TRANSPOSE_SET	= $0B	; [1P] Track transpose = parameter
MCMD_FREQFINEOFFSET_SET		= $0C	; [1P] Sound_FreqFineOffset = parameter
MCMD_FREQOFFSET_SET			= $0D	; [1P] Sound_FreqOffset = parameter
MCMD_LOOPCNT0_INIT_UPDATE	= $0E	; [3P] Loop counter 0 initialize/update; parameter 1 is the loop count init, parameter 2 and 3 are the jump address
MCMD_LOOPCNT1_INIT_UPDATE	= $0F	; [3P] Loop counter 1 initialize/update; parameter 1 is the loop count init, parameter 2 and 3 are the jump address
MCMD_LOOPCNT2_INIT_UPDATE	= $10	; [3P] Loop counter 2 initialize/update; parameter 1 is the loop count init, parameter 2 and 3 are the jump address
MCMD_LOOPCNT3_INIT_UPDATE	= $11	; [3P] Loop counter 3 initialize/update; parameter 1 is the loop count init, parameter 2 and 3 are the jump address
MCMD_LOOPCNT0_JMPLAST_CFG	= $12	; [3P] Loop counter 0 jump on last iteration; parameter 1 is passed to command $04 [MCMD_TRACK_CONFIG], parameter 2 and 3 are the jump address
MCMD_LOOPCNT1_JMPLAST_CFG	= $13	; [3P] Loop counter 1 jump on last iteration; parameter 1 is passed to command $04 [MCMD_TRACK_CONFIG], parameter 2 and 3 are the jump address
MCMD_LOOPCNT2_JMPLAST_CFG	= $14	; [3P] Loop counter 2 jump on last iteration; parameter 1 is passed to command $04 [MCMD_TRACK_CONFIG], parameter 2 and 3 are the jump address
MCMD_LOOPCNT3_JMPLAST_CFG	= $15	; [3P] Loop counter 3 jump on last iteration; parameter 1 is passed to command $04 [MCMD_TRACK_CONFIG], parameter 2 and 3 are the jump address
MCMD_JUMP_ALWAYS			= $16	; [2P] Always jump; parameter 1 and 2 are the jump address
MCMD_TRACK_STOP				= $17	; [1P] End of track signal -- NOTE: Parameter is fetched implicitly but not used, value is irrelevant (and can be ommitted since the fetch is irrelevant)
MCMD_DUTYCYCLE_SET			= $18	; [1P] New duty cycle set by parameter [expecting bits 6 and 7 only]
	; NOTE: Commands $19-$1F are INVALID/undefined, but could be implemented if needed for some reason (table PRG030_84A4)
MCMD_INVALID_19				= $19	; [1P] INVALID
MCMD_INVALID_1A				= $1A	; [1P] INVALID
MCMD_INVALID_1B				= $1B	; [1P] INVALID
MCMD_INVALID_1C				= $1C	; [1P] INVALID
MCMD_INVALID_1D				= $1D	; [1P] INVALID
MCMD_INVALID_1E				= $1E	; [1P] INVALID
MCMD_INVALID_1F				= $1F	; [1P] INVALID

; SFX defs
SFXF_PERPETUALLOOP			= $80	; Perpetual loop flag set on the otherwise-priority-byte (not used by MM4, but fully implemented)

; Bitfield commands (bits can be joined and are executed in-order)
SCMDBIT_LOOP				= $01	; [1P] Counted loop (or jump always, depending on count)
SCMDBIT_NOTELEN				= $02	; [1P] Note length -> RAM_00D4
SCMDBIT_TRANSPOSE			= $04	; [1P] Sets transpose value -> Snd_NoteTranspose

; Channel select
SCHAN_SQUARE1				= $01
SCHAN_SQUARE2				= $02
SCHAN_TRIANGLE				= $04
SCHAN_NOISE					= $08

; Sequential commands (bits can be joined and are executed in-order)
SCMD_PATCH_SET				= $01	; [1P] Set patch = parameter
SCMD_DUTYCYCLE_SET			= $02	; [1P] New duty cycle set by parameter [expecting bits 6 and 7 only]
SCMD_SYNTH_VOLUME_SET		= $04	; [1P] New synth vol = parameter (lower 4 bits only)
SCMD_FREQOFFSET_SET			= $08	; [1P] Sound_FreqOffset = parameter
SCMD_FREQFINEOFFSET_SET		= $10	; [1P] Sound_FreqFineOffset = parameter

	; Sound Address type 1 (normal)
sda1	.macro
	.byte (\1 & $FF00) >> 8
	.byte (\1 & $00FF)
	.endm

	; Sound Address type 2 ($Cxxx base, which implies using bank 29)
sda2	.macro
	.byte ((\1 & $FF00) >> 8) + $20
	.byte (\1 & $00FF)
	.endm
	
	; Sound and music reuse code with different tracking variables
	Sound_TrackPatch:		.ds 4	 ; $00 disables the channel, otherwise indexes PRG030_PatchData $0728 - $072B
	
	; Sound_SineWaveCtl:
	;	Lower 3 bits select routine from PRG030_UpdateSynth (only 0 through 4 valid!)
	;	Bit 3 ($08) will set Sound_SineWaveAccum = 0 (one time use, cleared) -- set when patch changes
	;	Bit 4 ($10) ???
	;	Bit 5 ($20) Set if Sound_FreqOffset <> 0, clear if Sound_FreqOffset = 0
	;	Bit 6 ($40) inverts the effect of Sound_SineWaveAccum for the "descending" part of the faux sinosuidal waveform
	;	Bit 7 ($80) FIXME as Sound_SineWaveAccum takes effect, $40/$80/$C0... are these all effects?
	Sound_SineWaveCtl:		.ds 4	 ; $0704 - $0707
	
	
	; Sound_SineWaveAccum: For approximating a sinusoidal wave by reversing decay on the note
	; This will get added to by patch byte 4 (the rate) and when it overflows the decay is reversed
	Sound_SineWaveAccum:		.ds 4	 ; $0708 - $070B
	
	SndMus_SynthVolEnvDuty:		.ds 4	 ; $070C - $070F Value written to (PAPU_CTL1, PAPU_CTL2, PAPU_TCR1, PAPU_NCTL1)
	
	
	; Sound_TrackVolume:
	;	- Upper nibble: Only actual applied value
	;		- Square 1 uses $Fx to $0x (loudest to quietest)
	;		- Square 2 uses $Fx to $7x (loudest to quietest)
	;		- Triangle it's just on or off (non-zero vs zero)
	;		- Noise uses $Fx to $0x (loudest to quietest)
	;		
	;	- Lower nibble: Mostly nothing but used for decrement counter, but also effects noise "somehow"
	Sound_TrackVolume:		.ds 4	 ; $0710 - $0713
	
	Sound_FreqFineOffset:	.ds 4	 ; $0714 - $0717 minor frequency offset (applied on hardware synth)
	
	; Sound_FreqOffset
	;	FIXME (PRG030_8349) If bit 7 set Force $54 last note played, if clear set $0A last note played
	; 	Sound_FreqOffset is multiplied by 2 and added to Sound_TrackFreqL/H
	;	Bit 7 negates it (not that the entire value is negative, the lower 7 bits are added in negated form)
	Sound_FreqOffset:		.ds 4	 ; $0718 - $071B
	
	; Sound_LastNotePlayed: Stores the last note value played on this track
	Sound_LastNotePlayed:		.ds 4	 ; $071C - $071F
	
	; Sound_TrackFreq: Base frequency of note to play
	Sound_TrackFreqL:		.ds 4	 ; $0720 - $0723
	Sound_TrackFreqH:		.ds 4	 ; $0724 - $0727
	
	; See Sound_TrackPatch
	Music_TrackPatch:		.ds 4	 ; $00 disables the channel, otherwise indexes PRG030_PatchData $0728 - $072B
	
	; See Sound_SineWaveCtl
	Music_SineWaveCtl:		.ds 4	 ; $072C - $072F
	
	; See Sound_SineWaveAccum
	Music_SineWaveAccum:	.ds 4	 ; $0730 - $0733
			
			.ds 4	 ; Not really used by sound effects, would be MusTrack_Transpose corollary 
	
	; See Sound_TrackVolume
	Music_TrackVolume:		.ds 4	 ; $0738 - $073B
	
	Music_FreqFineOffset:	.ds 4	 ; $073C - $073F minor frequency offset
	
			.ds 4	 ; $0740 - $0743
	
	; See Sound_LastNotePlayed
	Music_LastNotePlayed:		.ds 4	 ; $0744 - $0747

	; See Sound_TrackFreq 
	Music_TrackFreqL:		.ds 4	; $0748-$074B
	Music_TrackFreqH:		.ds 4	; $074C-$074F

	; Sound/music share code, just split memory regions
OFFS_FROM_SND_TO_MUS_DATA = (Music_TrackPatch - Sound_TrackPatch)
	
	; Offset:
	;	0 - Noise
	;	1 - Tri
	;	2 - Square 2
	;	3 - Square 1
	Music_TrackPtr_L:	.ds 4
	Music_TrackPtr_H:	.ds 4
	
	; Music_TrackOctaveTimingCtl: 
	;
	; - Bits 0-3 bits holds an octave value
	; - Bit 4 ($10) does PRG030_DelayTable2 * 1.5 (one time use, cleared afterward)
	; - Bit 5 ($20) selects timing value (NOT set use PRG030_DelayTable2 v. SET use PRG030_DelayTable1); one time use, cleared afterward
	; - Bit 6 ($40) The bit value will be pushed to bit 7; if set, also causes Music_NoteLength = $FF
	; - Bit 7 ($80) If set, and a note is repeated on a track, it clears the faux sinusoidal waveform
	Music_TrackOctaveTimingCtl:	.ds 4
	
	; MusTrack_Transpose: Added to note value to offset it
	MusTrack_Transpose:			.ds 4
	
	Music_NoteTicksLeft:		.ds 4

	Music_NoteAttackLength:		.ds 4
		
	; sets note length (FIXME) time to decay I think, also effects wavey sounds
	; If < 0, note is intended to decay
	Music_NoteLength:			.ds 4
	
	; Music_LoopCounters: You can actually have up to 4 loop counters which jump to other
	; points in the music once they expire. The command will initialize the loop counter 
	; if it's zero and subsequent calls to it decrement the counter... once it hits zero,
	; then it makes the jump to the particular address.
	Music_LoopCounters:
		.ds 4		; Loop counter 1
		.ds 4		; Loop counter 2
		.ds 4		; Loop counter 3
		.ds 4		; Loop counter 4
		
	SndMus_SynthToneFreq:		.ds 4	 ; $077C - $077F Value [with bit $08 forced on] written to (PAPU_CT1, PAPU_CT2, PAPU_TFREQ2, PAPU_NFREQ2)
	
	; Delayed buffer for committing PPU data. Follows simple format of repeating:
	; [VADDR][CNT][DATA]
	;	[VADDR]	= 2 byte PPU address
	;	[CNT]	= 0-based count of data to follow (i.e. "0" means 1 byte of data, "1" means 2 bytes of data...)
	;	[DATA]	= Data to commit to PPU
	; ... and then terminated with $FF
	Graphics_Buffer:		.ds 128	 ; $0780


	.org $6000

	; SRAM NOT USED BY STOCK MM4



; PRG banks
	.code

	; Constants for playing music/sound effects from the system (call PRG063_QueueMusSnd)

MUS_BRIGHTMAN				= $00		; Bright Man
MUS_TOADMAN					= $01		; Toad Man
MUS_RINGMAN					= $02		; Ring Man
MUS_DRILLMAN				= $03		; Drill Man
MUS_PHARAOHMAN				= $04		; Pharaoh Man
MUS_DIVEMAN					= $05		; Dive Man
MUS_SKULLMAN				= $06		; Skull Man
MUS_DUSTMAN					= $07		; Dust Man
MUS_COSSACK1				= $08		; Cossack Level 1 and 2
MUS_WILY1					= $09		; Wily Level 1 and 2
MUS_INTROSTORY				= $0A		; Intro story
MUS_ENDING1					= $0B		; Ending train
MUS_BOSSVICTORY				= $0C		; Boss victory / level clear
MUS_PASSWORD				= $0D		; Password/intermission screen
MUS_GAMEOVER				= $0E		; Game Over
MUS_BOSSINTRO				= $0F		; Robot Master intro
MUS_STAGESELECT				= $10		; Stage select
MUS_BOSS					= $11		; Boss battle
MUS_TITLETHEME				= $12		; Title theme
MUS_ENDING2					= $13		; Ending credits
MUS_GETWEAPON				= $14		; Get new weapon
MUS_COSSACK2				= $15		; Cossack Level 3 and 4
MUS_WILY2					= $16		; Wily Level 3 an4 2
MUS_SPECIALITEMGET			= $3A		; Special item get
MUS_WILYFORTRESSINTRO		= $3B		; Wily Fortress intro
MUS_COSSACKFORTRESSINTRO	= $3C		; Cossack Fortress Intro
MUS_PROTOWHISTLE			= $3F		; Proto Man (Blues) whistle song (not used in MM4)
MUS_INTROSTORYTRAIN			= $43		; Intro story, train segment
MUS_FINALBOSS				= $45		; Final Wily boss
MUS_FINALVICTORY			= $46		; Victory over Wily!
MUS_STOPMUSIC				= $F0		; Stop music
MUS_PARTIALMUTE				= $F6		; Mutes the square tracks (used when train departs during intro)

SFX_FLASHSTOPPER			= $17		; Flash Stopper
SFX_TOADRAIN				= $18		; Toad Rain
SFX_RINGBOOMERANG			= $19		; Ring Boomerang
SFX_DRILLBOMB				= $1A		; Drill Bomb
SFX_PHARAOHSHOT				= $1B		; Uncharged Pharaoh shot
SFX_COSSACKLIGHTENING		= $1C		; Lightening sound during Cossack fortress intro
SFX_PATHDRAW				= $1D		; Path draw on Cossack/Wily fortress
SFX_WATERSPLASH				= $1E		; Water Splash
SFX_1UP						= $1F		; 1-Up
 ; $20
SFX_PLAYERSHOT				= $21		; Player normal shot
SFX_MBUSTERCHARGE			= $22		; Mega Buster charge sound
SFX_PLAYERLAND				= $23		; Player landing noise
SFX_PLAYERHURT				= $24		; Player got hurt
SFX_ROBOTDEATH				= $25		; Player/boss explosion sound effect
SFX_ENEMYHIT				= $26		; Enemy damaged sound effect
SFX_MBUSTERCHARGEHOLD		= $27		; Mega Buster charge holding sound
SFX_EXPLOSION				= $28		; Explosion sound
SFX_ENERGYGAIN				= $29		; Energy meter gain
SFX_MENUCONFIRM				= $2A		; Menu confirmation shwing
SFX_SHOTDEFLECT				= $2B		; Shot deflected [bleep]
SFX_BOSSGATEOPEN			= $2C		; Boss gate opening
SFX_PASSWORDERROR			= $2D		; Password error
SFX_MENUSELECT				= $2E		; Menu selection
SFX_PASSWORDCORRECT			= $2F		; Password correct
SFX_WEAPONMENU				= $30		; Open/close weapon menu
SFX_GRASSHOPPERHOP			= $31		; Bright Man Grasshopper hop
SFX_WIREADAPTER				= $32		; Wire Adapter
SFX_TELEPORTLAND			= $33		; Teleportation landing
 ; $34
SFX_LETTERTYPE				= $35		; Letter "typing" noise (when you get a power)
SFX_DANGERALARM				= $36		; Post-Wily escape DANGER alarm
SFX_BIGEXPLOSION			= $37		; Big explosion sound effect used during cinematics
 ; $38
SFX_DISAPPEARINGBLOCK		= $39		; Disappearing / reappearing block
SFX_PLAYERMBUSTSHOT			= $3D		; Player Mega Buster shot
SFX_PHARAOHCHSHOT			= $3E		; Charged Pharaoh Shot
SFX_WILYSHIP				= $40		; Wily ship noise
SFX_TELEPORTOUT				= $41		; Teleport-out sound
	
	; Banks 11, 13, 15, and 55 contain sprite  data with tables that need to be 
	; located at constant places...
	
	
	; Sprite_FrameDefTable1/2: Defines the actual hardware sprites that make up the displayed sprite
	;
	; [SPRITES][UNK4INDEX][PATTERN][ATTR]
	;
	; Where:
	;	[SPRITES]	= Total number of hardware sprites to be done, minus 1 (so "0" = 1 hardware sprite)
	;	[UNK4INDEX]	= Index into Sprite_YXOffsetTable (and 1 is added if horizontally flipped)
	;		- Most important note being that the Y/X offsets are
	;
	;	And then repeating:
	;	[PATTERN]	= Pattern index for this sprite
	;	[ATTR]		= Attribute for the sprite
	
	; Sprite_FrameDefTable1: PRIMARY Pointers to definition of a sprite frame (as referenced by the animation script [FRAME] element)
Sprite_FrameDefTable1	= $B800		; Table is located at $B800-$B8FF / $BA00-$BAFF

	; Sprite_FrameDefTable2: SECONDARY Pointers to definition of a sprite frame (as referenced by the animation script [FRAME] element)
Sprite_FrameDefTable2	= $B900		; Table is located at $B900-$B9FF / $BB00-$BBFF


	; Sprite_YXOffsetTable: Y/X offsets to the sprite (designed to be reusable for patterning similar frames)
	;	Note that these must be in parallel with the [PATTERN][ATTR] bytes from the sprite frame definition's hardware sprites.
	;	Also that each index in Sprite_YXOffsetTable should feature the horizontally-flipped version as the following index
	;	(i.e. a complete set of appropriate offsets the handle the horizontal flip!)
	;	[YOFFSET] 	= Y offset to sprite's master Y position
	;	[XOFFSET]	= X offset to sprite's master X position

Sprite_YXOffsetTable	= $BC00		; Table is located at $B900-$B9FF / $BB00-$BBFF

	; Sprite_AnimScriptTable: Pointers to data that make up an animation script, 
	; which is indexed by Spr_CurrentAnim...
	; The format of each script is simply:
	;	[FRAMES][DELAY][FRAME][FRAME]...[FRAME]
	;
	; Where:
	;	[FRAMES] 	= Total number of frames, minus 1 (thus "0" = 1 frame, etc.)
	;		- Additionally, setting bit $80 on this will use the "SECONDARY" set of frames for each [FRAME] element
	;	[DELAY]		= Number of ticks to wait for each frame
	;	[FRAME]		= Sprite frame to display (if zero, sprite slot will be set to zero, and thus sprite is gone)
Sprite_AnimScriptTable		= $BE00		; Table is located at $BE00-$BFFF

SPRSLOTID_PLAYER				= $01	; Player object (and some other common stuff)
SPRSLOTID_PLAYERSHOT			= $02	; Player weapon shot
SPRSLOTID_DEFLECTEDSHOT			= $03	; Deflected player shot
SPRSLOTID_RUSH					= $04	; Rush object
SPRSLOTID_TOADRAINCAN			= $05	; Toad Rain canister
SPRSLOTID_BALLOON				= $06	; Balloon
SPRSLOTID_DIVEMISSILE			= $07	; Dive Missile
SPRSLOTID_RINGBOOMERANG			= $08	; Ring Boomerang
SPRSLOTID_DRILLBOMB				= $09	; Drill Bomb
SPRSLOTID_DUSTCRUSHER			= $0A	; Dust Crusher
SPRSLOTID_WIREADAPTER			= $0B	; Wire Adapter
SPRSLOTID_PHARAOHSHOT			= $0C	; Pharaoh Shot
SPRSLOTID_PHARAOHOVERH			= $0D	; Overhead charging Pharaoh Shot
SPRSLOTID_SKULLBARRIER			= $0F	; Skull barrier
SPRSLOTID_TAKETETNO				= $10	; Enemy Taketetno
SPRSLOTID_TAKETETNO_PROP		= $11	; Taketetno's propellar
SPRSLOTID_HOVER					= $12
SPRSLOTID_TOMBOY				= $13
SPRSLOTID_SASOREENU				= $14	; Actual Sasoreenu
SPRSLOTID_SASOREENU_SPAWNER		= $15	; Spawns Sasoreenu
SPRSLOTID_BATTAN				= $16
SPRSLOTID_SWALLOWN				= $18
SPRSLOTID_COSWALLOWN			= $19
SPRSLOTID_WALLBLASTER			= $1A
SPRSLOTID_WALLBLASTER_SHOT		= $1B
SPRSLOTID_100WATTON				= $1C
SPRSLOTID_100WATTON_SHOT		= $1D
SPRSLOTID_100WATTON_SHOT_BURST	= $1E
SPRSLOTID_RATTON				= $1F

; NOTE: Hack @ PRG062_DBA0 for these objects...
SPRSLOTID_RMRAINBOW_CTL1		= $20
SPRSLOTID_RMRAINBOW_CTL2		= $21
SPRSLOTID_RMRAINBOW_CTL3		= $22
SPRSLOTID_RMRAINBOW_CTL4		= $23
; END HACK

SPRSLOTID_SUBBOSS_KABATONCUE	= $24
SPRSLOTID_KABATONCUE_MISSILE	= $25
SPRSLOTID_RINGMAN_UNK2			= $26	; NOTE: HACK persistence @ PRG062_DBDA
SPRSLOTID_WILY_ESCAPEPOD		= $27	; After Wily Machine 4 Phase 2 defeated, Wily's escape pod
SPRSLOTID_BOMBABLE_WALL			= $28
SPRSLOTID_MOTHRAYA_DIE			= $29
SPRSLOTID_POWERGAIN_ORBS		= $2A	; Little spirally bits that circle into the Player as they gain a robot master's power
SPRSLOTID_SUBBOSS_ESCAROO		= $2B
SPRSLOTID_ESCAROO_BOMB			= $2C	; Escaroo's bomb
SPRSLOTID_ESCAROO_DIE			= $2D
SPRSLOTID_EXPLODEYBIT			= $2E	; Player/boss explodey bit
SPRSLOTID_RED_UTRACK_PLAT		= $2F
SPRSLOTID_SUBBOSS_WHOPPER		= $30	; Subboss Whopper
SPRSLOTID_SUBBOSS_WHOPPER_RING	= $31	; Whopper's rings unified over Whopper
SPRSLOTID_SUBBOSS_WHOPPER_RIN2	= $32	; Each of Whopper's ring flying out
SPRSLOTID_HAEHAEY				= $33
SPRSLOTID_HAEHAEY_SHOT			= $34	; Enemy Haehaey's shot
SPRSLOTID_RACKASER				= $35
SPRSLOTID_RACKASER_UMBRELLA		= $36	; Rackaser's umbrella
SPRSLOTID_DOMPAN				= $37	; Enemy Dompan
SPRSLOTID_DOMPAN_FIREWORKS		= $38	; Enemy Dompan's fireworks
SPRSLOTID_CIRCLEBULLET			= $39	; Circular shot
SPRSLOTID_WHOPPER_DIE			= $3A
SPRSLOTID_CIRCULAREXPLOSION		= $3B	; Circular explosion
SPRSLOTID_CEXPLOSION			= $3C	; Cossack explosion (multiple SPRSLOTID_CIRCULAREXPLOSION)
SPRSLOTID_MINOAN				= $3D
SPRSLOTID_SUPERBALLMACHJR_L		= $3E	; Super Ball Machine Jr.
SPRSLOTID_SUPERBALLMACHJR_B		= $3F	; Super Ball Machine Jr.'s ball
SPRSLOTID_BOULDER_DISPENSER		= $40
SPRSLOTID_BOULDER_DEBRIS		= $41
SPRSLOTID_EDDIE					= $42
SPRSLOTID_EDDIE_IMMEDIATE		= $43	; Eddie variety that immediately ejects from a different list (not used?)
SPRSLOTID_EDDIE_ITEM_EJECT		= $44	; Eddie ejected item
SPRSLOTID_CRPLATFORM_FALL		= $45	; Platforms at the Cockroach Twins boss (Cossack 3 boss) that wiggle and fall
SPRSLOTID_JUMPBIG				= $46
SPRSLOTID_SHIELDATTACKER		= $48
SPRSLOTID_COSSACK3BOSS1_DIE		= $49
SPRSLOTID_COSSACK3BOSS2_DIE		= $4A
SPRSLOTID_KABATONCUE_DIE		= $4B
SPRSLOTID_100WATTON_DIE			= $4C
SPRSLOTID_WILYCAPSULE_CHRG		= $4D	; Boss Wily Capsule charging circular thing 	; NOTE: HACK persistence @ PRG062_DBDA
SPRSLOTID_TOTEMPOLEN			= $4E
SPRSLOTID_TOTEMPOLEN_SHOT		= $4F	; Totempolen's shot
SPRSLOTID_METALL_1				= $50
SPRSLOTID_METALL_BULLET			= $51	; Metall's bullet
SPRSLOTID_SUBBOSS_MOBY			= $52
SPRSLOTID_MOBY_MISSILE			= $53	; Moby's missile
SPRSLOTID_MOBY_BIGSPIKE			= $54	; Moby's big spike
SPRSLOTID_METALL_2				= $56
SPRSLOTID_SWITCH				= $5B
SPRSLOTID_METALL_3				= $5C
SPRSLOTID_SINKINGPLATFORM		= $5D
SPRSLOTID_DUSTMAN_CRUSHERACT	= $5E
SPRSLOTID_M422A					= $5F
SPRSLOTID_CINESTUFF				= $60	; Various uses, no code function
SPRSLOTID_PUYOYON				= $61
SPRSLOTID_SKELETONJOE			= $62	; Enemy Skeleton Joe
SPRSLOTID_SKELETONJOE_BONE		= $63	; Skeleton Joe's bone
SPRSLOTID_RINGRING				= $64
SPRSLOTID_METALL_4				= $65
SPRSLOTID_METALL_4_BUBBLE		= $66	; Metall Swim's bubble
SPRSLOTID_WILY1_UNK1			= $67	; Links to no code... so does nothing?? Removed object maybe?
SPRSLOTID_UNK68					= $68	; Totally unused?? Has some code
SPRSLOTID_SKULLMET_R			= $69
SPRSLOTID_SKULLMET_BULLET		= $6A	; Skullmet's bullet
SPRSLOTID_DIVEMAN_BIDIW1		= $6B
SPRSLOTID_DIVEMAN_BIDIW2		= $6C
SPRSLOTID_HELIPON				= $6D
SPRSLOTID_HELIPON_BULLET		= $6E	; Helipon's bullet
SPRSLOTID_WATERSPLASH			= $6F	; Water splash
SPRSLOTID_GYOTOT				= $70
SPRSLOTID_BOSSSKULL				= $71	; Skull Man
SPRSLOTID_SKULLMAN_BULLET		= $72
SPRSLOTID_DUSTMAN_4PLAT			= $73	; Dust Man 4-piece platform
SPRSLOTID_DUSTMAN_PLATSEG		= $74	; Dust Man 4-piece platform segment
SPRSLOTID_BOSSRING				= $75	; Ring Man
SPRSLOTID_RINGMAN_RING			= $76
SPRSLOTID_BOSSDEATH				= $77	; Boss death controller; standard for robot master demise!
SPRSLOTID_BIREE1				= $78
SPRSLOTID_BOSSDUST				= $79	; Dust Man
SPRSLOTID_DUSTMAN_DUSTCRUSHER	= $7A	; Dust Man's Dust crusher
SPRSLOTID_DUSTMAN_DUSTDEBRIS	= $7B	; Dust Man's Dust crusher debris
SPRSLOTID_BOSSDIVE				= $7C	; Dive Man
SPRSLOTID_BOSSDIVE_MISSILE		= $7D	; Dive Man's Missile
SPRSLOTID_BOSSDRILL				= $7E	; Drill Man
SPRSLOTID_DRILLMAN_DRILL		= $7F	; Drill Man's drill
SPRSLOTID_MISCSTUFF				= $80	; Just sort of a loose slot for non-complex decorative sprites (no code function) (animations in banks 54-55)
SPRSLOTID_BOSSINTRO				= $81	; Robot Master's intro sprite
SPRSLOTID_DRILLMAN_POOF			= $82	; Drill Man's "poof" when drilling
SPRSLOTID_SPIRALEXPLOSION		= $83	; Spiral explosion
SPRSLOTID_BOSSPHARAOH			= $84	; Pharaoh Man
SPRSLOTID_PHARAOHMAN_ATTACK		= $85	; Pharaoh Man's attack
SPRSLOTID_PHARAOHMAN_SATTACK	= $86	; Pharaoh Man's small attack
SPRSLOTID_BOSS_MOTHRAYA			= $87
SPRSLOTID_COSSACK1_UNK1			= $88	; FIXME: Update commentary in PRG062_DDFB as we figure this out
SPRSLOTID_COSSACK1_UNK2			= $89
SPRSLOTID_MOTHRAYA_SHOT			= $8A	; Mothraya's pulsating shot
SPRSLOTID_BOSSBRIGHT			= $8B	; Bright Man
SPRSLOTID_BOSSBRIGHT_BULLET		= $8C	; Bright Man's bullet
SPRSLOTID_BOSSTOAD				= $8D	; Toad Man
SPRSLOTID_BATTONTON				= $8E
SPRSLOTID_MOTHRAYA_DEBRIS		= $8F	; Mothraya floor debris
SPRSLOTID_EXPLODEY_DEATH		= $90
SPRSLOTID_MANTAN				= $91
SPRSLOTID_BOSS_COSSACKCATCH		= $92
SPRSLOTID_COSSACK4_UNK1			= $93
SPRSLOTID_COSSACK4_BULLET		= $94
SPRSLOTID_BOSS_SQUAREMACHINE	= $95
SPRSLOTID_SQUAREMACH_PLATFORM	= $96	; NOTE: HACK persistence @ PRG062_DBDA
SPRSLOTID_SQUAREMACHINE_SHOT	= $97	; Boss Square Machine's shot
SPRSLOTID_BOULDER				= $98
SPRSLOTID_COSSACK2_UNK2			= $99	; NOTE: HACK persistence @ PRG062_DBDA
SPRSLOTID_MUMMIRA				= $9A
SPRSLOTID_MUMMIRAHEAD			= $9B
SPRSLOTID_IMORM					= $9C
SPRSLOTID_ENEMYEXPLODE			= $9D	; Enemy death explosion
SPRSLOTID_COSSACK3BOSS1			= $9E	; Cossack 3 boss walker #1
SPRSLOTID_COSSACK3BOSS2_SHOT	= $9F
SPRSLOTID_COSSACK3BOSS1_SHOT	= $A0
SPRSLOTID_MONOROADER			= $A1
SPRSLOTID_COSSACK3BOSS2			= $A2	; Cossack 3 boss walker #2
SPRSLOTID_KALINKA				= $A3	; Kalinka
SPRSLOTID_PROTOMAN				= $A4	; Proto Man
SPRSLOTID_WILY					= $A5	; Dr. Wily (in Cossack scene only?)
SPRSLOTID_BOSS_METALLDADDY		= $A6
SPRSLOTID_GACHAPPON				= $A7
SPRSLOTID_GACHAPPON_BULLET		= $A8	; Gachappon's straight shot bullet
SPRSLOTID_GACHAPPON_GASHAPON	= $A9	; Gachappon's arcing shot
SPRSLOTID_METALLDADDY_METALL	= $AA	; Boss Metall Daddy's Metalls
SPRSLOTID_BOSS_TAKOTRASH		= $AB
SPRSLOTID_WILY2_UNK1			= $AC
SPRSLOTID_TAKOTRASH_BALL		= $AD	; Boss Takotrash's ball
SPRSLOTID_TAKOTRASH_FIREBALL	= $AE	; Boss Takotrash's "nose" fireball
SPRSLOTID_TAKOTRASH_PLATFORM	= $AF	; Boss Takotrash's moving platform
SPRSLOTID_PAKATTO24				= $B0
SPRSLOTID_PAKATTO24_SHOT		= $B1
SPRSLOTID_UPNDOWN				= $B2
SPRSLOTID_WILYTRANSPORTER		= $B3
SPRSLOTID_UPNDOWN_SPAWNER		= $B4
SPRSLOTID_SPIKEBLOCK_1			= $B5
SPRSLOTID_SEAMINE				= $B6
SPRSLOTID_GARYOBY				= $B7
SPRSLOTID_BOSS_ROBOTMASTER		= $B8	; Robot Master's "greeting" animation
SPRSLOTID_DOCRON				= $B9
SPRSLOTID_DOCRON_SKULL			= $BA
SPRSLOTID_WILY3_UNK1			= $BB	; NOTE: HACK persistence @ PRG062_DBDA
SPRSLOTID_BOSS_WILYMACHINE4		= $BC	; NOTE: HACK persistence @ PRG062_DBDA
SPRSLOTID_TOGEHERO_SPAWNER_R	= $BD	; Togehero spawner (from right side of screen)
SPRSLOTID_TOGEHERO				= $BE
SPRSLOTID_WILYMACHINE4_SHOTCH	= $BF	; Wily Machine 4 charge shot
SPRSLOTID_WILYMACHINE4_PHASE2	= $C0	; Boss Wily Machine Phase 2
SPRSLOTID_ITEM_PICKUP			= $C1	; All bonus items except special weapons (Balloon, Wire Adpater)
SPRSLOTID_SPECWPN_PICKUP		= $C2	; Balloon, Wire Adapter pickups
SPRSLOTID_WILY1_DISPBLOCKS		= $C3
SPRSLOTID_BOSS_WILYCAPSULE		= $C4
SPRSLOTID_WILYCAPSULE_SHOT		= $C5
SPRSLOTID_ITEM_PICKUP_GRAVITY	= $C6	; Item pickup with gravity (Wily transporter boss defeat)
SPRSLOTID_LADDERPRESS_R			= $C7
SPRSLOTID_DOMPAN_INTERWORK		= $C8	; Interstitial object between Dompan dying and fireworks spawning
SPRSLOTID_GREEN_UTRACK_PLAT		= $C9
SPRSLOTID_LADDERPRESS_L			= $CA
SPRSLOTID_WILYCAPSULE_DIE		= $CB	; Final boss death
SPRSLOTID_DRILLMAN_POOF_ALT		= $CC	; Alternate slot for Drill Man's "poof" that has no code
SPRSLOTID_TOADMAN_UNK1			= $CD
SPRSLOTID_TOGEHERO_SPAWNER_L	= $CE	; Togehero spawner (from left side of screen)
SPRSLOTID_DIVEMAN_UNK5			= $CF	; This object just syncs vertically to Level_RasterYOff+8 ... maybe for debugging?



	; Animations for sprites defined in banks 10-11
SPRANM1_ROCKTRAINHEAD		= $01	; Intro: Rock's head on train
SPRANM1_ROCKTRAINHEAD2		= $02	; Intro: Rock's head on train, determined face
SPRANM1_ROCKTRAINHEAD3		= $03	; Intro: Rock's head on train, determined face hold
SPRANM1_ROCKTRAINHEAD4		= $04	; Intro: Rock's head on train, don helmet
SPRANM1_ROCKTRAINBODY		= $05	; Intro: Rock's body on train
SPRANM1_ROCKTRAINBODY2		= $06	; Intro: Rock's body on train, arm up
SPRANM1_BODY				= $07	; Intro: Rock's body overlay in transformation tube
SPRANM1_ROCKTFACE			= $08	; Intro: Rock's face in transformation tube starting transformation
SPRANM1_ROCKWAKEUP2			= $09	; Intro: Rock's face waking up (opening eyes)
SPRANM1_TRAINBGLIGHTS		= $0D	; Intro: Train has scrolling lights in the BG
SPRANM1_DOCRON_SKULL		= $0E	; Large skull enemy deposited from hatch
SPRANM1_DOCRON_SKULL2		= $0F	; Large skull enemy wheeling around
SPRANM1_DOCRON_SHAFT		= $10
SPRANM1_DISAPPEARINGBLOCK	= $11	; Disappearing/reappearing block
SPRANM1_ENDINGWILYFORT1		= $12	; Ending: Wily fortress in background
SPRANM1_ENDINGWILYFORT2		= $13	; Ending: Wily fortress in background, exploding
SPRANM1_ENDINGWILYFORT3		= $14	; Ending: Wily fortress in background, right before final kaboom
SPRANM1_ENDINGWILYFORT4		= $15	; Ending: Wily fortress in background, nuclear!
SPRANM1_WILYCAPSULE_WILY	= $16	; Boss Wily Capsule's brief appearance
SPRANM1_WILYCAPSULE_SHOTCH	= $17	; Boss Wily Capsule shot charge orb
SPRANM1_WILYCAPSULE_SHOT	= $18	; Boss Wily Capsule shot
SPRANM1_WILYCAPSULE_WILYE	= $19	; Wily exploding out of capsule
SPRANM1_WILYCAPSULE_BEG		= $1A	; Wily begging on floor
SPRANM1_WILYCAPSULE_ESCAPE	= $1B	; Wily escaping
SPRANM1_TOGEHERO			= $1C	; Enemy Togehero
SPRANM1_WILYFINAL_BLINKIN	= $1D	; Blinking light in the background after Wily's defeated
SPRANM1_WILYCAPSULE_DANGER	= $1E	; "DANGER" sign after Wily escapes
SPRANM1_JUMPBIG_INAIR		= $1F	; Enemy Jumpbig in air
SPRANM1_JUMPBIG_LANDED		= $20	; Enemy Jumpbig landed
SPRANM1_ENDINGRRWALK		= $21	; Ending: Rush and Roll walking
SPRANM1_ENDINGRRSTOP		= $22	; Ending: Rush and Roll stopped
SPRANM1_ROCKTRAINSTAND		= $23	; Ending: Rock standing on train
SPRANM1_ROCKTRAINJUMP		= $24	; Ending: Rock jump off train
SPRANM1_ROCKTRAINTELE		= $25	; Ending: Rock teleporting to train
SPRANM1_ENDINGROCKTELE		= $28	; Ending: Rock teleporting away in background
SPRANM1_TRAINPOLEF			= $29	; Ending: Train pole foreground
SPRANM1_TRAINPOLEB			= $2A	; Ending: Train pole background
SPRANM1_ENDCAPCOM_C			= $2B	; Ending: "CAPCOM" letter C
SPRANM1_ENDCAPCOM_A			= $2C	; Ending: "CAPCOM" letter A
SPRANM1_ENDCAPCOM_P			= $2D	; Ending: "CAPCOM" letter P
SPRANM1_ENDCAPCOM_O			= $2E	; Ending: "CAPCOM" letter O
SPRANM1_ENDCAPCOM_M			= $2F	; Ending: "CAPCOM" letter M
SPRANM1_WILYCAPSULE_VANISH	= $30	; Boss Wily Capsule vanishing (Is this just invisible?)
SPRANM1_LADDERPRESS_L		= $31
SPRANM1_LADDERPRESS_R		= $32
SPRANM1_ROCKFACE			= $33	; Intro: Rock's face in transformation tube
SPRANM1_ROCKWAKEUP1			= $34	; Intro: Rock's face waking up (eyelids flutter)
SPRANM1_ROCKTRAINHEAD5		= $35	; Intro: Rock's head on train, helmet don hold
SPRANM1_ROCKTRAINBODY3		= $36	; Intro: Rock's body on train, arm up, hold
SPRANM1_ROCKWAKEUP3			= $37	; Intro: Rock's face awake
SPRANM1_ROCKTFACE2			= $38	; Intro: Rock's face in transformation tube during transformation (grit teeth)

	; Animations for sprites defined in banks 12-13
SPRANM2_PLAYERSTAND			= $01	; Player standing
SPRANM2_PLAYERSHOOT			= $02	; Player shooting
SPRANM2_PLAYERWALK			= $04	; Player walking
SPRANM2_PLAYERWALKSHOOT		= $05	; Player walking and shooting
SPRANM2_PLAYERJUMPFALL		= $07	; Player jumping/falling
SPRANM2_PLAYERJFSHOOT		= $08	; Player jumping/falling and shooting
SPRANM2_PLAYERCLIMB			= $0A	; Player climbing on ladder
SPRANM2_PLAYERCLIMBSHOOT	= $0B	; Player shooting while climbing on ladder
SPRANM2_PLAYERSTEP			= $0D	; Player stepping forward a little
SPRANM2_PLAYERSTEPSHOOT		= $0E	; Player stepping and shooting
SPRANM2_PLAYERTHROW			= $0F	; Player throwing (Pharaoh Shot)
SPRANM2_PLAYERSLIDE			= $10	; Player sliding
SPRANM2_PLAYERHURT			= $11	; Player hurt animation
SPRANM2_HURTHITFX			= $12	; Player's little "ouch" white sparkle thingies
SPRANM2_TELEPORT			= $13	; Teleporting in
SPRANM2_PLYRCLIMTOP			= $14	; Player climbing on ladder at the top (hunched over)
SPRANM2_PLYRCLIMTOPSHOOT	= $15	; Player shooting while climbing on ladder at the top
SPRANM2_PLAYERSLIDEDUST		= $17	; Little dust poof that happens when you slide (except in the beginning of Toad Man)
SPRANM2_PLAYERSHOT			= $18	; Standard plasma bullet
SPRANM2_BOTEXPLODEYBIT		= $19	; Player/boss explodey bit
SPRANM2_MBUSTSHOTBURST		= $20	; Mega Buster full charge burst release
SPRANM2_MBUSTSHOTLOW		= $21	; Mega Buster low charge slot
SPRANM2_MBUSTFULLDEFLCT		= $22	; Mega Buster full charge deflected shot
SPRANM2_MBUSTSHOTFULL		= $23	; Mega Buster full charge slot
SPRANM2_RUSHJET				= $24	; Rush Jet 
SPRANM2_RUSHCOIL			= $25	; Rush Coil 
SPRANM2_RUSHMARINE			= $26	; Rush Marine
SPRANM2_RUSHMARINECLOSE		= $27	; Rush Marine closing
SPRANM2_RUSHMARINERIDE		= $29	; Riding in Rush Marine
SPRANM2_RUSHMARINEHIT		= $2B	; Getting his while in Rush Marine
SPRANM2_WATERSPLASH			= $2E	; Splash when hitting water
SPRANM2_RAINSPLASH			= $2F	; Splash when stepping on Toad Man's rainy ground
SPRANM2_WILYMACHINE4_PHASE1	= $30	; Boss Wily Machine 4 Phase 1
SPRANM2_PLAYERSLIDESPLASH	= $31	; Little splash that happens when you slide in the beginning of Toad Man
SPRANM2_TELEPORTOUT			= $32	; Teleporting out
SPRANM2_READY				= $33	; The "READY" display when level starts
SPRANM2_SMALLPOOF			= $35	; Small "poof" explosion
SPRANM2_TOADRAINCAN			= $36	; Toad Rain canister launched
SPRANM2_TOADRAINCANFLY		= $37	; Toad Rain canister flying
SPRANM2_PLAYERLOOKUP		= $38	; Player looking upward for wire adapter usage
SPRANM2_PLAYERWIREFIRE		= $39	; Player looking up, cannon up, for wire adapter firing
SPRANM2_PLAYERWIREHANG		= $3A	; Player hanging from Wire Adapter
SPRANM2_PLAYERWIREHANGS		= $3B	; Player hanging from Wire Adapter and shooting
SPRANM2_WIREADAPTERUP		= $3C	; Wire Adapter extending upward / retracting down
SPRANM2_WIREADAPTERPL		= $3D	; Wire Adapter pulling Player up
SPRANM2_BALLOON_POPUP		= $3E	; Balloon weapon, pop up animation
SPRANM2_BALLOON_PUSHDN		= $3F	; Balloon weapon, push down animation
SPRANM2_DIVEMISSILE_UP		= $40	; Dive Missile pointing upward
SPRANM2_DIVEMISSILE_DIAGUP	= $41	; Dive Missile pointing diagonally upward
SPRANM2_DIVEMISSILE			= $42	; Dive Missile pointing sideways
SPRANM2_DIVEMISSILE_DIAGDN	= $43	; Dive Missile pointing diagonally downward
SPRANM2_DIVEMISSILE_DN		= $44	; Dive Missile pointing downward
SPRANM2_RINGBOOMERANG		= $45	; Ring Boomerang
SPRANM2_DRILLBOMB			= $46	; Drill Bom
SPRANM2_PHARAOHSHOT			= $47	; Pharaoh Shot no charge shot
SPRANM2_PHARAOHCHLSHOT		= $48	; Pharaoh Shot low charge shot
SPRANM2_PHARAOHCHSHOT		= $49	; Pharaoh Shot charged shot
SPRANM2_DUSTCRUSHER			= $4A	; Dust Crusher
SPRANM2_DUSTCRUSHER_D1		= $4B	; Dust Crusher Debris 1
SPRANM2_DUSTCRUSHER_D2		= $4C	; Dust Crusher Debris 1
SPRANM2_DUSTCRUSHER_D3		= $4D	; Dust Crusher Debris 1
SPRANM2_DUSTCRUSHER_D4		= $4E	; Dust Crusher Debris 1
SPRANM2_PHARAOHOVERHEAD		= $4F	; Overhead Pharaoh Shot charge
SPRANM2_SKULLBARRIER		= $50	; Skull barrier
SPRANM2_ITEM_WIREADAPTER	= $51	; Weapon Wire Adapter pickup
SPRANM2_ITEM_BALLOON		= $52	; Weapon Balloon pickup
SPRANM2_IMORM_CRAWLING		= $61	; Imorm crawling
SPRANM2_IMORM				= $63
SPRANM2_COSSACKCLAW_CAUGHT	= $6C	; Cossack Catcher's claw caught Player
SPRANM2_COSSACKCLAW_RELEASE	= $6D	; Cossack Catcher's claw released Player
SPRANM2_COSSACKCLAW_GRABBY	= $6E	; Cossack Catcher's claw "grabby" idle motion
SPRANM2_ROCKHEAD_SPIN		= $70	; Rock's head spinning around during Weapon Get transition
SPRNAM2_WILY_STANDING		= $71	; Wily standing
SPRNAM2_WILY_TALKING		= $72	; UNUSED Wily talking and pointing
SPRANM2_TRANSPBLINKER		= $73	; Blinking light on Wily Transporter
SPRANM2_KALINKA_WALKING		= $74	; Kalinka walking over
SPRANM2_KALINKA_TALKING		= $75	; UNUSED Kalinka talking
SPRANM2_DRCOSSACKSTAND		= $76	; Dr. Cossack outside mech
SPRANM2_COSSACK_TALKING		= $77	; UNUSED Dr. Cossack outside mech, talking (possible to Kalinka?)
SPRANM2_PROTOTELEPORT		= $78	; Proto Man teleporting in
SPRANM2_PROTOMAN_STAND		= $79	; Proto Man standing
SPRANM2_COSSACK_ATCONTROLS	= $7A	; Cossack working controls
SPRANM2_METALLDADDY_IDLE	= $7B	; Boss Metall Daddy's normal eyes
SPRANM2_METALLDADDY_EYES	= $7C	; Boss Metall Daddy's eyes bouncing after landing
SPRANM2_METALLDADDY_DUST	= $7E	; Dust kicked up when Boss Metall Daddy jumps
SPRANM2_SPIKEBLOCK_UDLF		= $84	; Spike block, spikes up and down, left flashing arrow
SPRANM2_SPIKEBLOCK_UDT		= $85	; Spike block, spikes up and down, halfway in transition
SPRANM2_SPIKEBLOCK_LR		= $86	; Spike block, spikes left and right
SPRANM2_SPIKEBLOCK_LRT		= $87	; Spike block, spikes left and right, halfway in transition
SPRANM2_WILYSHIP_3DDEPART	= $89	; Wily's ship departing in ~3D~
SPRANM2_WILYSHIP_INTRO		= $8A	; Wily's ship during his intro (post-Cossack)
SPRANM2_WILYSHIP_TOPONLY	= $8B	; Wily's ship top only to do the eyebrows thing
SPRANM2_WILYSHIP_EYEBROWS	= $8C	; Wily doing his eyebrows thing
SPRANM2_SQUAREMACHINE		= $90
SPRANM2_SQUAREMACHINE_SHOT	= $91	; Boss Square Machine's shot
SPRANM2_WM4P2_DECOSPRITES	= $93	; Boss Wily Machine 4 Phase 2 decorative sprites
SPRANM2_WM4P2_WILY			= $94	; Boss Wily Machine 4 Phase 2 Wily at controls
SPRANM2_WILYMACHINE4_SHOTCH	= $95	; Boss Wily Machine 4's shot charging
SPRANM2_WILYMACHINE4_SHOT	= $96	; Boss Wily Machine 4's shot flying
SPRANM2_WILYESCAPEPOD		= $97	; Wily's escape pod
SPRANM2_MUMMIRA				= $98
SPRANM2_MUMMIRA_HEAD		= $99	; Mummira's tossed head
SPRANM2_TAKOTRASH			= $9B	
SPRANM2_TAKOTRASH_BALL		= $9C	; Boss Takotrash's ball
SPRANM2_TAKOTRASH_FIREBALL	= $9D	; Boss Takotrash's fireball
SPRANM2_UPNDOWN				= $9E	; Up N' Down
SPRANM2_PAKATTO24			= $9F
SPRANM2_SEAMINE_IDLE		= $A7
SPRANM2_SEAMINE_PENDINGEXPL	= $A8	; Sea Mine pending explosion
SPRANM2_GARYOBY				= $A9
SPRANM2_COCKROACHPLAT_IDLE	= $AA	; Cockroach platform still
SPRANM2_COCKROACHPLAT_WIGL	= $AB	; Cockroach platform wiggling
SPRANM2_COCKROACHPLAT_FALL	= $AC	; Cockroach platform falling

	; Animations for sprites defined in banks 14-15
SPRANM3_SKULLMAN_SHIELD		= $01	; Skull Man's shield
SPRANM3_SKULLMAN_IDLE		= $02
SPRANM3_SKULLMAN_RUN		= $03
SPRANM3_SKULLMAN_SHIELDUP	= $04
SPRANM3_SKULLMAN_SHOOT		= $05
SPRANM3_SKULLMAN_JUMP		= $06
SPRANM3_CIRCULAR_BULLET		= $08
SPRANM3_RINGMAN_IDLE		= $09
SPRANM3_RINGMAN_RUN			= $0A
SPRANM3_RINGMAN_RUNTHROW	= $0B
SPRANM3_RINGMAN_JUMP		= $0C
SPRANM3_RINGMAN_JUMPTHROW	= $0D
SPRANM3_BOSS_MOTHRAYA		= $0E
SPRANM3_BOSS_RMSPARKLE		= $0F	; Ring Man's sparkle on his ring head
SPRANM3_RINGMAN_RING		= $10
SPRANM3_RINGMAN_STANDTHROW	= $11
SPRANM3_DUSTMAN_IDLE		= $12
SPRANM3_DUSTMAN_SHOOTDUST	= $13
SPRANM3_DUSTMAN_JUMP		= $14
SPRANM3_DUSTMAN_SUCKSTART	= $15
SPRANM3_DUSTMAN_DUSTCRUSHER	= $17	; Dust Man's dust crusher projectile
SPRANM3_DUSTMAN_DUSTCRUSHD1	= $18	; Dust Man's dust crusher debris
SPRANM3_DUSTMAN_DUSTCRUSHD2	= $19	; Dust Man's dust crusher debris
SPRANM3_DUSTMAN_DUSTCRUSHD3	= $1A	; Dust Man's dust crusher debris
SPRANM3_DUSTMAN_DUSTCRUSHD4	= $1B	; Dust Man's dust crusher debris
SPRANM3_DUSTMAN_SUCKING		= $1C
SPRANM3_DIVEMAN_INTRO		= $1D	; Dive Man's intro
SPRANM3_DIVEMAN_RAMSTART	= $1E	; Dive Man entering into ram state
SPRANM3_DIVEMAN_MISSILE		= $1F	; Dive Man's missile straight
SPRANM3_DIVEMAN_MISSILE_UP	= $20	; Dive Man's missile upward
SPRANM3_DIVEMAN_MISSILE_DN	= $21	; Dive Man's missile downward
SPRANM3_DIVEMAN_MISSILE_DD	= $22	; Dive Man's missile diagonal-down
SPRANM3_DIVEMAN_MISSILE_DU	= $23	; Dive Man's missile diagonal-up
SPRANM3_DIVEMAN_IDLE		= $24	; Dive Man standing still
SPRANM3_DIVEMAN_RAM			= $25	; Dive Man ramming (spiraling around)
SPRANM3_DIVEMAN_RAM2		= $26	; Dive Man ramming (spiraling around) (difference between SPRANM3_DIVEMAN_RAM2?)
SPRANM3_DIVEMAN_RAMEND		= $28	; Dive Man entering exiting ram state
SPRANM3_DRILLMAN_IDLE		= $29
SPRANM3_DRILLMAN_DRILLSTART	= $2A	; Drill Man facing forward about to burrow
SPRANM3_DRILLMAN_POOF		= $2B	; Little poof of dust related to burrowing
SPRANM3_DRILLMAN_DRILLING	= $2C	; Drill Man facing forward drilling
SPRANM3_DRILLMAN_DRILLTRANS	= $2D	; Drill Man's animation transition to flipping over (just action lines)
SPRANM3_DRILLMAN_DRILLINGD	= $2E	; Drill Man facing backward drilling down
SPRANM3_DRILLMAN_DRILLSPLAY	= $2F	; Drill Man standing with drills splayed
SPRANM3_DRILLMAN_RUN		= $30	; Drill Man running
SPRANM3_DRILLMAN_SHOOT		= $31	; Drill Man firing drills
SPRANM3_MOTHRAYA_SHOT		= $32	; Mothraya's shot
SPRANM3_DRILLMAN_DRILL		= $33	; Drill Man's drill
SPRANM3_BRIGHTMAN_STAND		= $34	; Bright Man stand
SPRANM3_BRIGHTMAN_JUMP		= $35	; Bright Man jump
SPRANM3_WEAPONGET_RUSH		= $36	; Large Rush from Weapon Get screen
SPRANM3_BRIGHTMAN_BRIGHT	= $37	; Bright Man's bright attack
SPRANM3_BRIGHTMAN_SHOOT		= $38	; Bright Man shoot
SPRANM3_PHARAOHMAN_ATTACK2	= $39	; diff from SPRANM3_PHARAOHMAN_ATTACK?
SPRANM3_PHARAOHMAN_ATTACK	= $3A
SPRANM3_PHARAOHMAN_JUMP_L	= $3B	; left facing
SPRANM3_PHARAOHMAN_JUMP_R	= $3D	; right facing
SPRANM3_PHARAOHMAN_PROJ		= $3F
SPRANM3_TOADMAN_IDLE		= $41
SPRANM3_TOADMAN_JUMP		= $42
SPRANM3_TOADMAN_RAINDANCE	= $43
SPRANM3_BOSSINT_BRIGHT		= $44
SPRANM3_BOSSINT_TOAD		= $45
SPRANM3_BOSSINT_DRILL		= $46
SPRANM3_BOSSINT_PHARAOH		= $47
SPRANM3_BOSSINT_RING		= $48
SPRANM3_BOSSINT_DUST		= $49
SPRANM3_BOSSINT_DIVE		= $4A
SPRANM3_BOSSINT_SKULL		= $4B
SPRANM3_CRTWIN_WALK_FLOOR	= $50
SPRANM3_CRTWIN_SHOOT_FLOOR	= $51
SPRANM3_CRTWIN_WALK_LWALL	= $52
SPRANM3_CRTWIN_SHOOT_LWALL	= $53
SPRANM3_CRTWIN_WALK_CEIL	= $54
SPRANM3_CRTWIN_SHOOT_CEIL	= $55
SPRANM3_CRTWIN_WALK_RWALL	= $56
SPRANM3_CRTWIN_SHOOT_RWALL	= $57
SPRANM3_CRTWIN1_SHOOT_DIAG	= $5C
SPRANM3_CRTWIN1_SHOOT_CENTER= $5D
SPRANM3_GACHAPPON_IDLE		= $60
SPRANM3_GACHAPPON_GASHAPON	= $61	; Gachappon's arcing overhead shot
SPRANM3_GACHAPPON_SHOOT		= $62	; Gachappon's straight shot
SPRANM3_GACHAPPON_GASHAPONB	= $63
SPRANM3_MANTAN_TILTDOWNFULL	= $64
SPRANM3_MANTAN_TILTDOWNHALF	= $65
SPRANM3_MANTAN_FLAT			= $66
SPRANM3_MONOROADER_ROLL		= $67
SPRANM3_MONOROADER_SPIN		= $68
SPRANM3_BATTONTON_IDLE		= $69
SPRANM3_BATTONTON_STARTFLY	= $6A
SPRANM3_BATTONTON_FLY		= $6B
SPRANM3_BATTONTON_ENDFLY	= $6C
SPRANM3_SINKING_PLATFORM	= $6D
SPRANM3_TOADMAN_RAINDANCE2	= $6E	; Toad Man's rain dance with some "sparks"

	; Animations for sprites defined in banks 54-55
SPRANM4_TAKETETNO_IDLE		= $01
SPRANM4_TAKETETNO_UP		= $02	; Enemy Taketetno moving upward
SPRANM4_TAKETETNO_DOWN		= $03	; Enemy Taketetno moving downward
SPRANM4_TAKETETNO_PROP		= $04	; Taketetno's propellar
SPRANM4_HOVER_IDLE			= $05
SPRANM4_HOVER_RIDING		= $06	; Riding Hover
SPRANM4_HOVER_DUST			= $07	; Dust kicked up when you jump on Hover
SPRANM4_HOVER				= $08	; Enemy(ish) Hover
SPRANM4_MINOAN_IDLE			= $09
SPRANM4_MINOAN_DROP			= $0A	; Minoan dropping off ceiling
SPRANM4_MINOAN_TWIRL		= $0B	; Minoan twirilng on floor
SPRANM4_KABATONCUE_IDLE		= $0C	; SubBoss Kabatoncue (hippo boss)
SPRANM4_RINGMAN_UNK1		= $0D
SPRANM4_KABMISSILE_UP		= $0E	; Kabatoncue's missile up
SPRANM4_KABMISSILE_DIAD		= $0F	; Kabatoncue's missile diagonal-down
SPRANM4_KABMISSILE			= $10	; Kabatoncue's missile right
SPRANM4_KABMISSILE_DIAU		= $11	; Kabatoncue's missile diagonal-up
SPRANM4_KABMISSILE_DOWN		= $12	; Kabatoncue's missile down
SPRANM4_TOMBOY				= $13
SPRANM4_SASOREENU_MOVE		= $14	; Enemy Sasoreenu moving along the quicksand
SPRANM4_SASOREENU_EMERG		= $15	; Enemy Sasoreenu emerging
SPRANM4_KABATONCUE_BLKB		= $17	; Kabatoncue's block shot out
SPRANM4_CIRCLEBULLET		= $18	; Circular bullet
SPRANM4_ENEMYEXPLODE		= $19	; Enemy death explosion
SPRANM4_ITEM_LARGEHEALTH	= $1A	; Large health pickup
SPRANM4_ITEM_SMALLHEALTH	= $1B	; Small health pickup
SPRANM4_ITEM_LARGEWEAPON	= $1C	; Large weapon pickup
SPRANM4_ITEM_SMALLWEAPON	= $1D	; Small weapon pickup
SPRANM4_ITEM_1UP			= $1E	; 1-up
SPRANM4_ITEM_ENERGYTANK		= $1F	; Energy tank
SPRANM4_BOMBWALL_1			= $21
SPRANM4_BOMBWALL_2			= $22	; Unused?
SPRANM4_BOMBWALL_3			= $23	; Unused?
SPRANM4_RMRBC_PRETTY		= $29	; Ring Man Rainbow Platform Controller "pretty" sprite used when erasing the "pretty" blocks
SPRANM4_RMRBC_UGLY			= $2A	; Ring Man Rainbow Platform Controller "ugly" sprite used when erasing/reforming the "ugly" later level versions
SPRANM4_DOMPAN_WALK			= $2B	; Enemy Dompan walking
SPRANM4_DOMPAN_JUMP			= $2C	; Enemy Dompan jumping
SPRANM4_RED_UTRACK_PLAT		= $2E
SPRANM4_SWALLOWN			= $2F	; Enemy Swallown
SPRANM4_SWALLOWN2			= $30	; Enemy Swallown (difference from SPRANM4_SWALLOWN?)
SPRANM4_COSWALLOWN			= $31	; Coswallown (little bird from Swallow) - flying "straight"
SPRANM4_COSWALLOWN_DOWN		= $32	; Coswallown flying downward
SPRANM4_COSWALLOWN_DIAU		= $33	; Coswallown flying diagonally upward
SPRANM4_COSWALLOWN_UP		= $34	; Coswallown flying upward
SPRANM4_COSWALLOWN_DIAD		= $35	; Coswallown flying diagonally downward
SPRANM4_ESCAROO_EYESNORMAL	= $36	; SubBoss Escaroo (snail boss)
SPRANM4_ESCAROO_BOMB		= $39	; Escaroo's bomb
SPRANM4_WALLBLASTER_22		= $3A	; Wallblaster at 22.5
SPRANM4_WALLBLASTER_45		= $3C	; Wallblaster at 45
SPRANM4_WALLBLASTER_62		= $3E	; Wallblaster at 62.5
SPRANM4_WALLBLASTER_90		= $40	; Wallblaster at 90
SPRANM4_WALLBLASTER_112		= $42	; Wallblaster at 112.5
SPRANM4_WALLBLASTER_135		= $44	; Wallblaster at 135
SPRANM4_WALLBLASTER_157		= $46	; Wallblaster at 157.5
SPRANM4_SASOREENU_POOF		= $48	; Enemy Sasoreenu's emerging puff in the quicksand
SPRANM4_DOMPAN_FIREWORKS	= $49	; Dompan firework rocket
SPRANM4_DOMPAN_FIREWORKE	= $4A	; Firework explosions
SPRANM4_RMRBC_PRETTY2		= $4B	; Ring Man Rainbow Platform Controller "pretty" sprite used when reforming the "pretty" blocks
SPRANM4_100WATTON			= $4C	; Enemy 100 Watton
SPRANM4_100WATTON_POOF		= $4E	; 100 Watton's poof that comes out of its head as it flies along
SPRANM4_100WATTON_SHOT		= $4F	; 100 Watton's shot
SPRANM4_100WATTON_BURST		= $50	; 100 Watton's shot burst
SPRANM4_RATTON				= $51
SPRANM4_WHOOPER_IDLE		= $52	; Whopper's idle animation, dancing withing the rings
SPRANM4_WHOPPER_EYESOPEN	= $53	; SubBoss Whopper (ring subboss) eyes open (rings thrown)
SPRANM4_WHOPPER_RINGS		= $54	; Whopper's rings before the fly out / when they return
SPRANM4_WHOPPER_RING		= $55	; Individual whopper ring
SPRANM4_HAEHAEY				= $56
SPRANM4_HAEHAEY_SHOT		= $57	; Enemy Haehaey's shot
SPRANM4_ENDEDDIESTAND		= $58	; Ending: Eddie stand
SPRANM4_ENDEDDIEOPEN		= $59	; Ending: Eddie flipping open
SPRANM4_ENDEDDIEWALK		= $5A	; Ending: Eddie walking in
SPRANM4_KABATONCUE_T		= $5B	; SubBoss Kabatoncue (hippo boss) teleporting in
SPRANM4_RACKASER_IDLE		= $5C
SPRANM4_RACKASER_CLOSEUMB	= $5D	; Enemy Rackaser closing umbrella
SPRANM4_RACKASER_RUN		= $5F	; Enemy Rackaser running
SPRANM4_RACKASER_TOSSUMB	= $60	; Enemy Rackaser tossing umbrella
SPRANM4_RACKASER_UMBRELLA	= $61	; Rackaser's umbrella
SPRANM4_SMALLPOOFEXP		= $62	; Block bust poof (e.g. shooting out Dust Man blocks)
SPRANM4_BATTAN				= $63
SPRANM4_SUPERBALLMACHINEJR	= $64
SPRANM4_SBM_BALL			= $65	; Super Ball Machine Jr. ball
SPRANM4_SBM_BALL_BOUNCE		= $66	; Super Ball Machine Jr. ball bounce
SPRANM4_BOULDER				= $67	; Drill Man boulder
SPRANM4_BOULDER_DEBRIS1		= $68	; Drill Man boulder debris 1
SPRANM4_BOULDER_DEBRIS2		= $69	; Drill Man boulder debris 2
SPRANM4_BOULDER_DEBRIS3		= $6A	; Drill Man boulder debris 3
SPRANM4_BOULDER_DEBRIS4		= $6B	; Drill Man boulder debris 4
SPRANM4_BOULDER_IMPACT		= $6C	; Boulder impact
SPRANM4_EDDIE_TELEPORTOUT	= $6D	; Eddie teleporting out
SPRANM4_UNK_70				= $70	; Unused?? animation ref'ed by dead?? code
SPRANM4_DRILLMAN_SWITCH		= $71
SPRANM4_SKULLMET_IDLE		= $72	; Enemy Skullmet Player in front
SPRANM4_SKULLMET_PINFRONT	= $73	; Enemy Skullmet Player in front
SPRANM4_SHIELDATTACKER		= $76	; Shield Attacker
SPRANM4_SHIELDATTACKER_TURN	= $77	; Shield Attacker turning around
SPRANM4_TOTEMPOLEN			= $79	; Enemy Totempolen
SPRANM4_TOTEMPOLEN_SHOOT	= $7A	; Totempolen shooting
SPRANM4_TOTEMPOLEN_BULLET	= $7B	; Totempolen's bullet
SPRANM4_METALL4_GETUP		= $7C	; Metall 4 getting up
SPRANM4_METALL4_SWIM		= $7D	; Metall 4 kicking feet to swim
SPRANM4_METALL4_BUBBLE		= $7E	; Metall 4's bubble
SPRANM4_MOBY_IDLE			= $80	; SubBoss Moby after teleporting in (invisible)
SPRANM4_MOBY_BUBBLES		= $82	; Moby's bubbles during suction
SPRANM4_M422A				= $84
SPRANM4_METALL_IDLE			= $86	; Metall idle
SPRANM4_METALL2_OPEN		= $87	; Metall type 2 opening
SPRANM4_METALL3_OPEN		= $88	; Metall type 3 opening
SPRANM4_METALL1_OPEN		= $89	; Metall type 1 opening
SPRANM4_MOBY_MISSILE_L		= $8A	; Moby's missile left
SPRANM4_MOBY_MISSILE_UL		= $8B	; Moby's missile upper left
SPRANM4_MOBY_MISSILE_DL		= $8C	; Moby's missile down left
SPRANM4_MOBY_BIGSPIKE		= $8D	; Moby's big spike ball that gets launched (and returns as little ones)
SPRANM4_MOBY_SMALLSPIKE		= $8E	; One of the four little spike balls that get dropped by Moby
SPRANM4_METALL_CLOSING		= $8F	; Metall closing
SPRANM4_PUYOYON_INCH_C		= $90	; Puyoyon inching along, on ceiling
SPRANM4_PUYOYON_DROP		= $91	; Enemy Puyoyon dropping
SPRANM4_PUYOYON_INCH		= $92	; Puyoyon inching along, on floor
SPRANM4_PUYOYON_RAISE		= $93	; Enemy Puyoyon raising up
SPRANM4_SKELJOE_IDLE		= $94	; Enemy Skeleton Joe idle
SPRANM4_SKELJOE_COLLAPSE	= $95	; Enemy Skeleton Joe collapsing
SPRANM4_SKELJOE_BONE		= $96	; Skeleton Joe's tossed bone
SPRANM4_RINGRING			= $97
SPRANM4_GYOTOT_SWIM			= $98	; Gyotot swimming
SPRANM4_GYOTOT_JUMP			= $99	; Gyotot jumping
SPRANM4_HELIPON_FLYING		= $9A	; Helipon flying in
SPRANM4_HELIPON_LANDED		= $9B	; Helipon landed
SPRANM4_HELIPON_PRESHOOT	= $9C	; Helipon shooting
SPRANM4_HELIPON_SHOOT		= $9D	; Helipon shooting
SPRANM4_METALL4_GETDOWN		= $9F	; Metall 4 getting down
SPRANM4_UNK_A0				= $A0	; Unused?? code refs this
SPRANM4_UNK_A1				= $A1	; Unused?? code refs this
SPRANM4_WATERSPLASH			= $A4	; Water splash
SPRANM4_DM4PLAT_SEG_SINKING	= $A5	; Dust Man 4-segment platform sinking (base value)
SPRANM4_DM4PLAT_SEG_RISING	= $A8	; Dust Man 4-segment platform rising
SPRANM4_DM4PLAT_SEG_SHINE	= $A9	; Dust Man 4-segment platform shining
SPRANM4_DM4PLAT_SEG_DIS		= $AA	; Dust Man 4-segment platform disassembling
SPRANM4_BIREE				= $AB
SPRANM4_GREEN_UTRACK_PLAT	= $AC


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; TILEMAP DATA CONSTANTS
	;
	; Tilemap data is pretty rigid and exists in banks 32-52.
	; Offsets and some relevant constants defined below.
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Object Spawn IDs are what are stored in the level data to spawn objects.
; Note that they do not directly correlate to the object sprite IDs that
; are actually used for code execution, it just links to initializate tables
; that exist in PRG056 (PRG056_...BySpawnID)
OBJSPAWN_TAKETETNO			= $00	; Mushroom with detaching propellar
OBJSPAWN_HOVER				= $01	; Pharaoh Man platform guy that also shoots
OBJSPAWN_TOMBOY				= $02	; Slinky
OBJSPAWN_SASOREENU			= $03	; Pharaoh Man scorpian guy
OBJSPAWN_BATTAN				= $04 	; grasshopper
OBJSPAWN_SWALLOWN			= $05	; Blue bird with little birds (Coswallown)
OBJSPAWN_WALLBLASTER_R		= $06	; Mounted on right wall [Ring Man directional gun]
OBJSPAWN_WALLBLASTER_L		= $07	; Mounted on left wall [Ring Man directional gun]
OBJSPAWN_RMRAINBOW_CTL1		= $08	; Ring Man rainbow platform controller 1
OBJSPAWN_RMRAINBOW_CTL2		= $09	; Ring Man rainbow platform controller 2
OBJSPAWN_RMRAINBOW_CTL3		= $0A	; Ring Man rainbow platform controller 3
OBJSPAWN_RMRAINBOW_CTL4		= $0B	; Ring Man rainbow platform controller 4
OBJSPAWN_RMRAINBOW_CTL5		= $0C	; Ring Man rainbow platform controller 5
OBJSPAWN_RMRAINBOW_CTL6		= $0D	; Ring Man rainbow platform controller 6
OBJSPAWN_RMRAINBOW_CTL7		= $0E	; Ring Man rainbow platform controller 7
; $0F
OBJSPAWN_100WATTON			= $10	; Winged light bulb
OBJSPAWN_RATTON				= $11	; Jumping rat
OBJSPAWN_SUBBOSS_WHOPPER	= $12	; Ring-based sub-boss
OBJSPAWN_HAEHAEY			= $13	; Pharaoh Man fast flying bug like
OBJSPAWN_RACKASER			= $14	; Metall-like guy with the umbrella
OBJSPAWN_DOMPAN				= $15	; Green guy that shoots fireworks when killed
OBJSPAWN_DIVEMAN_BIDIW1		= $16	; Dive Man bidirectional water level controller
OBJSPAWN_DIVEMAN_BIDIW2		= $17	; Dive Man bidirectional water level controller 2
OBJSPAWN_SUBBOSS_KABATONCUE	= $18	; Giant hippo sub-boss on platform
OBJSPAWN_RINGMAN_UNK1		= $19	; Ring Man ???
OBJSPAWN_RINGMAN_UNK2		= $1A	; Ring Man ??? something solid
OBJSPAWN_WILY2_UNK1			= $1B	; Wily 2 ?? Large, damaging thing that deflects shots... probably the body of "Tako Trash"?
OBJSPAWN_CRPLATFORM_FALL	= $1C	; Cockroach Twins falling platform
; $1D
OBJSPAWN_SUBBOSS_ESCAROO	= $1E	; Huge Snail
OBJSPAWN_TOADMAN_UNK1		= $1F	; Toad Man ???
OBJSPAWN_TOADMAN_UNK2		= $20	; Toad Man ???
; $21
; $22
; $23
; $24
; $25
; $26
; $27
OBJSPAWN_RED_UTRACK_PLAT	= $28	; Bright Man Red U-track platform
OBJSPAWN_BOMBABLE_WALL		= $29	; Wall that requires Drill Bomb to break
; $2A
; $2B
; $2C
OBJSPAWN_MINOAN				= $2D	; Hangs from ceiling, drops
OBJSPAWN_SUPERBALLMACHJR_L	= $2E	; Super Ball Machine Jr., firing left [Skull Man bouncy ball cannon]
OBJSPAWN_SUPERBALLMACHJR_R	= $2F	; Super Ball Machine Jr., firing right [Skull Man bouncy ball cannon]
OBJSPAWN_BOULDER_DISPENSER	= $30	; Drill Man Falling rocks "Boulder"
OBJSPAWN_EDDIE				= $31	; Eddie / Flip-Top who walks up to Player
OBJSPAWN_EDDIE_IMMEDIATE	= $32	; Eddie that immediately opens
OBJSPAWN_JUMPBIG			= $33	; Big red/orange guy who jumps
; $33
OBJSPAWN_SHIELDATTACKER		= $34	; Rocket-powered enemy with face shield
OBJSPAWN_WILY1_DISPBLOCKS	= $35	; Disappearing/reappearing blocks
OBJSPAWN_TOTEMPOLEN			= $36	; Totem pole enemy from Bright Man
OBJSPAWN_DIVEMAN_UNK1		= $37	; Dive Man ???
OBJSPAWN_SUBBOSS_MOBY		= $38	; Dive Man whale sub-boss
OBJSPAWN_DIVEMAN_UNK2		= $39	; Dive Man ???
OBJSPAWN_DIVEMAN_UNK3		= $3A	; Dive Man ???
OBJSPAWN_METALL_1			= $3B	; Metall who shoots 3 shots and charges, then hides
OBJSPAWN_METALL_2			= $3C	; Metall who jumps, shooting 3 shots, then hides
; $3D
; $3E
; $3F
; $40
OBJSPAWN_SWITCH				= $41	; Drill Man flip switch
OBJSPAWN_METALL_3			= $42	; Metall that twirls
; $43
OBJSPAWN_DUSTMAN_CRUSHERACT	= $44	; Dust Man crusher activator
OBJSPAWN_M422A				= $45	; Dive Man floaty thing with the claws
OBJSPAWN_SKULLMET_R			= $46	; Skullmet, firing right [mostly shielded guy with vulnerable eyeball that fires falling projectile]
OBJSPAWN_PUYOYON			= $47	; blobby amoeba thing
OBJSPAWN_SKELETONJOE		= $48	; Skull Man bone tosser
OBJSPAWN_RINGRING			= $49	; Ring Ring [Ring Man planet]
OBJSPAWN_METALL_4			= $4A	; Metall Swim
OBJSPAWN_SKULLMET_L			= $4B	; Skullmet, firing left [mostly shielded guy with vulnerable eyeball that fires falling projectile]
OBJSPAWN_HELIPON			= $4C	; Guy who spins around in the air, lands, and shoots
OBJSPAWN_GYOTOT				= $4D	; Fish that charges and jumps
OBJSPAWN_DOCRON				= $4E	; Hatch in ceiling that deposits skull enemy
OBJSPAWN_DUSTMAN_4PLAT		= $4F	; Dust Man 4-piece assembling platform
OBJSPAWN_WILY3_UNK1			= $50	; Wily 3 ???
OBJSPAWN_BIREE1				= $51	; Little sparking thing that traces platforms
OBJSPAWN_BIREE2				= $52	; Little sparking thing that traces platforms
OBJSPAWN_BOSS_WILYMACHINE4	= $53	; Wily Machine 4
OBJSPAWN_TOGEHERO			= $54	; Sow moving, slow turning enemy with spikes
OBJSPAWN_WILY3_UNK2			= $55	; Wily 3 ???
OBJSPAWN_ITEM_ENERGYTANK	= $56	; Energy Tank
OBJSPAWN_BOSS_MOTHRAYA		= $57	; Cossack 1 Boss, giant moth thing
OBJSPAWN_COSSACK1_UNK1		= $58	; Cossack 1 ???
OBJSPAWN_COSSACK1_UNK2		= $59	; Cossack 2 ???
OBJSPAWN_ITEM_LARGEHEALTH	= $5A	; Large Health Energy
OBJSPAWN_ITEM_SMALLHEALTH	= $5B	; Small Health Energy
OBJSPAWN_BATTONTON			= $5C	; Bat enemy
OBJSPAWN_MANTAN				= $5D	; Dive Man stingray thing
OBJSPAWN_BOSS_COSSACKCATCH	= $5E	; Cossack Catcher [Cossack 4 Dr. Cossack boss]
OBJSPAWN_COSSACK4_UNK1		= $5F	; Cossack 4 ???
OBJSPAWN_COSSACK4_UNK2		= $60	; Cossack 4 ???
OBJSPAWN_BOSS_SQUAREMACHINE	= $61	; Square Machine [Cossack 2 triple-part boss]
OBJSPAWN_COSSACK2_UNK1		= $62	; Cossack 2 ???
OBJSPAWN_COSSACK2_UNK2		= $63	; Cossack 2 "wall??" [invisible, blocks horizontal movement like a wall]		<-- are these related to Square Machine?
OBJSPAWN_COSSACK2_UNK3		= $64	; Cossack 2 "solid??" [invisible, blocks horizontal movement like a wall]	<-- are these related to Square Machine?
OBJSPAWN_COSSACK2_UNK4		= $65	; Cossack 2 "solid??" [invisible, blocks horizontal movement like a wall]	<-- are these related to Square Machine?
OBJSPAWN_COSSACK2_UNK5		= $66	; Cossack 2 "solid??" [invisible, blocks vertical movement like a floor]		<-- are these related to Square Machine?
OBJSPAWN_MUMMIRA			= $67	; Pharaoh Man mummy
OBJSPAWN_IMORM				= $68	; Caterpillar thing that drops from ceiling and crawls around
OBJSPAWN_BOSS_COCKROACHES	= $69	; Cockroach Twins [Cossack 3 boss]
OBJSPAWN_SINKINGPLATFORM	= $6A	; Cossack 3 sinking platform
OBJSPAWN_MONOROADER			= $6B	; Guy who shields his eyes and spins towards you
OBJSPAWN_BOSS_METALLDADDY	= $6C	; Metall Daddy [Wily 1 boss]
OBJSPAWN_WILY1_UNK1			= $6D	; Wily 1 ???
OBJSPAWN_GACHAPPON			= $6E	; Tall red guy with the ball tank
OBJSPAWN_BOSS_TAKOTRASH		= $6F	; Wily 2 boss that shoots stuff and has small weak point; technically just the weak point
OBJSPAWN_WILY2_UNK2			= $70	; Wily 2 ?? Large, damaging thing that deflects shots... probably the body of "Tako Trash"?
OBJSPAWN_WILY2_UNK3			= $71	; Wily 2 ??? Related to "Tako Trash"?
OBJSPAWN_PAKATTO24			= $72	; Shielded gun that opens and fires
OBJSPAWN_UPNDOWN			= $73	; Up'n'Down [guy who obnoxiously pops out of a pit]
OBJSPAWN_WILYTRANSPORTLIGHT	= $74	; Wily transporter blinking light
OBJSPAWN_SPIKEBLOCK_1		= $75	; Cossack 2 block with spikes that come out left/right or top/bottom
OBJSPAWN_SPIKEBLOCK_2		= $76	; Cossack 2 block with spikes that come out left/right or top/bottom [alternate timing]
OBJSPAWN_SEAMINE			= $77	; Dive Man spikey ball that explodes if shot
OBJSPAWN_GARYOBY			= $78	; Little floor saw
OBJSPAWN_BOSS_ROBOTMASTER	= $79	; Stage boss [level determines]
OBJSPAWN_ITEM_LARGEWEAPON	= $7A	; Large Weapon Energy
OBJSPAWN_ITEM_SMALLWEAPON	= $7B	; Small Weapon Energy
OBJSPAWN_ITEM_1UP			= $7C	; 1-Up
OBJSPAWN_ITEM_BALLOON		= $7D	; Balloon
OBJSPAWN_ITEM_WIREADAPTER	= $7E	; Wire Adapter
OBJSPAWN_BOSS_WILYCAPSULE	= $7F	; Wily Capsule [Final boss]
OBJSPAWN_BRIGHTMAN_UNK1		= $80	; Bright Man ??? [non-interactive?]
OBJSPAWN_LADDERPRESS_L		= $81	; Ladder Press Left Half [spiky things on ladders]
OBJSPAWN_GREEN_UTRACK_PLAT	= $82	; Bright Man Green U-track platform
OBJSPAWN_DIVEMAN_UNK4		= $83 	; Dive Man "wall??" [invisible, blocks horizontal movement like a wall]
OBJSPAWN_LADDERPRESS_R		= $84	; Ladder Press Right Half [spiky things on ladders]
OBJSPAWN_COSSACK1_UNK3		= $85	; Cossack 1 ???
OBJSPAWN_TOADMAN_UNK3		= $86	; Toad Man ??? [hurts if touched]
OBJSPAWN_DIVEMAN_UNK5		= $87	; Dive Man ???
; ----
; SPECIAL SPAWNS
; ----
OBJSPAWN_TOADMAN_UNK4		= $C0
OBJSPAWN_TOADMAN_UNK5		= $C1
OBJSPAWN_TOADMAN_UNK6		= $C2
OBJSPAWN_TOADMAN_UNK7		= $C3
OBJSPAWN_BRIGHTMAN_UNK2		= $C4
OBJSPAWN_BRIGHTMAN_PALSW1	= $C5
OBJSPAWN_BRIGHTMAN_UNK3		= $C6
OBJSPAWN_BRIGHTMAN_UNK4		= $C7
; $C8
; $C9
; $CA
; $CB
OBJSPAWN_DRILLMAN_UNK1		= $CC
OBJSPAWN_DIVEMAN_UNK6		= $CD
OBJSPAWN_DIVEMAN_PALSW1		= $CE
OBJSPAWN_DIVEMAN_UNK7		= $CF
; $D0
; $D1
OBJSPAWN_BRIGHTMAN_UNK5		= $D2
OBJSPAWN_DUSTMAN_UNK1		= $D3
OBJSPAWN_DUSTMAN_UNK2		= $D4
OBJSPAWN_SKULLMAN_PALSW1	= $D5
OBJSPAWN_SKULLMAN_UNK1		= $D6
OBJSPAWN_SKULLMAN_PALSW2	= $D7
OBJSPAWN_DIVEMAN_PALSW2		= $D8
OBJSPAWN_PHARAOHMAN_UNK1	= $D9
OBJSPAWN_PHARAOHMAN_PALSW1	= $DA
OBJSPAWN_COSSACK1_PALSW1	= $DB
OBJSPAWN_COSSACK1_PALSW2	= $DC
OBJSPAWN_PHARAOHMAN_UNK2	= $DD
OBJSPAWN_WILY3_PALSW1		= $DE
OBJSPAWN_WILY3_PALSW2		= $DF
OBJSPAWN_DIVEMAN_PALSW3		= $E0
OBJSPAWN_DIVEMAN_UNK8		= $E1

	
	; Banks 32-52 have fixed layout data as follows:
	; MetaBlk_ScrLayoutOffset: 	Offset (divided by 64) to per-screen metablock layout
	; MetaBlk_ScrLayout: 		List of metablocks per screen, 8 to a row
	; MetaBlk_TileLayout: 		2x2 layout of 16x16 tiles inside the metablock
	; TileLayout_Patterns:		Specifies the pattern per 16x16 tile (divided by 256 bytes each; UL, UR, LL, LR)
TileLayout_Patterns			= $A000


	; Tile attributes:
	;
	; These define essentially the "property" of the detected tile, and are prioritized
	; in some checks (i.e. of all tiles detected from the last pass of the tile detect
	; routines, the "greatest" attribute value from below is stored.)
	;
	; After calling a tile detection routine (which use a "spread" detection system of an array of offsets):
	;
	; 	Level_TileAttr_GreatestDet: "Greatest" of any of these detected
	;
	; 	Temp_Var16: "Amalgamation" of the upper 4 BITS of all of these detected
	;		NOTE! A lot of times this is checked bit-wise even though it doesn't totally make sense,
	;		e.g. the game will check for the "TILEATTR_SOLID" set in Temp_Var16, meaning any of the
	;		following TILEATTRs with $10 set will also be treated as "SOLID" in some checks
	;
TILEATTR_UNSOLID			= $00	; Generally used as an empty/unsolid tile (for solidity mod routines)
TILEATTR_SOLID				= $10	; Solid tile
TILEATTR_LADDER				= $20	; Ladder tile (climbable, can not be stood on)
TILEATTR_SPIKES				= $30	; Spikes (death on impact!)
TILEATTR_LADDERTOP			= $40	; Ladder tile (climbable, can be stood on)
TILEATTR_WATER				= $60	; Underwater tile
TILEATTR_DRILLMANSPECFLR	= $70	; Drill Man's "dynamic" floors that appear by flipping a switch (only works in Drill Man due to specific check, so it could possibly be made into a general "custom" attribute with some work)
TILEATTR_TOADWATERPUSHR		= $80	; Toad Man's water flow (pushes Player right)
TILEATTR_DUSTSHOOTABLE		= $90	; Dust Man's shootable blocks
TILEATTR_TOADWATERPUSHL		= $A0	; Toad Man's water flow (pushes Player left)
TILEATTR_ICE				= $B0	; Cossack ice
TILEATTR_QUICKSAND_SNOW		= $C0	; Pharaoh Man's quicksand, Cossack 1's snow, and also Toad Man's water flow that flows down into left/right (center doesn't push)
TileLayout_Attributes		= $A400

MetaBlk_TileLayout			= $A500		; NOTE: Symbolic to have full address, but really only high part is used in code logic as a base offset (i.e. $A5)
MetaBlk_ScrLayout			= $A900		; NOTE: Symbolic to have full address, but really only high part is used in code logic as a base offset (i.e. $A9)

Level_LayoutObjXHi			= $B100		; Level layout object X Hi (which screen)
Level_LayoutObjX			= $B180		; Level layout object X
Level_LayoutObjY			= $B200		; Level layout object Y
Level_LayoutObjIDs			= $B280		; Level layout object IDs
	
	; Level_LayoutObjHintByScr: This defines the "lowest" index into object layout data per screen.
	; This is based on the "Level_LayoutObjXHi" data to basically break down the data for hints
	; related to the spawning logic. The data in this array will never go backwards, so even if
	; theres no objects that are actually on the screen in question, it will just hold the "next" index...
	;
	; Here's the gist using the following demo "Level_LayoutObjXHi":
	; 
	;   0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F
	; $01, $01, $01, $02, $02, $03, $03, $03, $05, $05, $05, $06, $07, $08, $08, $08
	;
	; There's no objects on screen 0 and 3 objects on screen 1; the "lowest" index for both is $00.
	; The next two objects are on screen 2; the "lowest" index for that screen is $03.
	; Since there's objects then on screen 3, it is coded with index $06.
	; But there's none on 4, so screen 4 also states index $06.
	; 
	; And thus:
	;	Screen 0: $00
	;	Screen 1: $00
	;	Screen 2: $03
	;	Screen 3: $05
	;	Screen 4: $05
	;	Screen 5: $08
	;	Screen 6: $0B
	;	Screen 7: $0C
	;	Screen 8: $0D
	; ... $00, 400, $03, $05, $05, $0B, $0B, $0C, $0D
Level_LayoutObjHintByScr	= $B300

	; Table of offsets (divided by 64) into MetaBlk_ScrLayout to get metatile layout per screen
MetaBlk_ScrLayoutOffset 	= $B500

	; Level_SegmentDefs: "Segment" being a series of 1 or more "screens" of level data
	; Segment-by-segment settings
	; The lower nibble specifies the number of screens in the segment.
	; The upper nibble specifies attributes; see Level_SegCurData
Level_SegmentDefs			= $B530		; Level-bank (32+Level) table used for defining a "segment" of a level (1 or more related screens)

	; Level_ScreenAltPathLinks: 
	; [SRC][UN1][UN2][DST]
	;
	; [SRC] = "Source" screen of the alternate path
	; [UN1] = ???
	;	$20 = ???
	;	$40 = Going down? (4 typ)
	;	$80 = Going up? (8 typ)
	; [UN2] = ???
	; [DST] = "Destination" screen of the alternate path
Level_ScreenAltPathLinks	= $B540		; Level-bank (32+Level) table used for cross-linking screens to not-adjacent screens (alternate paths)

Level_SegmentPalSel			= $B550		; Level-bank (32+Level) table used for selecting a new palette from Level_BGPaletteData when entering a new segment ($00 means to not change)
Level_SegmentDynCHRPalIndex	= $B560		; Level-bank (32+Level) table used for loading new graphics and sprite palette when entering a new segment (call to PRG062_CHRRAMDynLoadPalSeg)

	; Boss Gate Opening constants for banks 32-52
Level_BossGateBaseVADDR			= $B570		; VADDR to start modifying for the boss gate (from bottom)
Level_BossGateReplaceTiles		= $B572		; Replacement tiles to use as gate opens
Level_BossGateBaseAttrVADDRL	= $B576		; VADDR to start modifying for the boss gate (from bottom)
Level_BossGateBaseAttrMask		= $B577		; Mask to use for replacement tile as opening gate
Level_BossGateAttrBytes			= $B578		; Attribute bytes to OR in for each tile of the boss gate

	; Boss Gate Closing constants for banks 32-52
Level_BossGateCBaseVADDR		= $B57C		; VADDR to start modifying for the boss gate (from bottom)
Level_BossGateCReplaceTiles		= $B57E		; Replacement tiles to use as gate opens
Level_BossGateCBaseAttrVADDRL	= $B582		; VADDR to start modifying for the boss gate (from bottom)
Level_BossGateCBaseAttrMask		= $B583		; Mask to use for replacement tile as opening gate
Level_BossGateCAttrBytes		= $B584		; Attribute bytes to OR in for each tile of the boss gate

Level_BGPaletteData			= $B590		; Level-bank (32+Level) palette table for BG (contains 16 BG colors plus 4 palette animation init values per entry)
Level_SegPalAnimInitData	= Level_BGPaletteData+16		; Level-bank (32+Level) palette animation init data

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; /// END TILEMAP DATA CONSTANTS


	; Weapons use tables to lookup their damage table for banks 32-45
Player_WeaponDamageTable	= $B700


	; BEGIN CHR banks

	.bank 0
	.org $8000
	.include "PRG/prg000.asm"

	.bank 1
	.org $A000
	.include "PRG/prg001.asm"

	.bank 2
	.org $8000
	.include "PRG/prg002.asm"

	.bank 3
	.org $A000
	.include "PRG/prg003.asm"

	.bank 4
	.org $8000
	.include "PRG/prg004.asm"

	.bank 5
	.org $A000
	.include "PRG/prg005.asm"

	.bank 6
	.org $8000
	.include "PRG/prg006.asm"

	.bank 7
	.org $A000
	.include "PRG/prg007.asm"

	.bank 8
	.org $8000
	.include "PRG/prg008.asm"

	.bank 9
	.org $A000
	.include "PRG/prg009.asm"

	; END CHR banks

	; Sprite animation defs 1A
	.bank 10
	.org $8000
	.include "PRG/prg010.asm"

	; Sprite animation defs 1B
	.bank 11
	.org $A000
	.include "PRG/prg011.asm"

	; Sprite animation defs 2A
	.bank 12
	.org $8000
	.include "PRG/prg012.asm"

	; Sprite animation defs 2B
	.bank 13
	.org $A000
	.include "PRG/prg013.asm"

	; Sprite animation defs 3A
	.bank 14
	.org $8000
	.include "PRG/prg014.asm"

	; Sprite animation defs 3B
	.bank 15
	.org $A000
	.include "PRG/prg015.asm"

	; BEGIN CHR banks

	.bank 16
	.org $8000
	.include "PRG/prg016.asm"

	.bank 17
	.org $A000
	.include "PRG/prg017.asm"

	.bank 18
	.org $8000
	.include "PRG/prg018.asm"

	.bank 19
	.org $A000
	.include "PRG/prg019.asm"

	.bank 20
	.org $8000
	.include "PRG/prg020.asm"

	.bank 21
	.org $A000
	.include "PRG/prg021.asm"

	.bank 22
	.org $8000
	.include "PRG/prg022.asm"

	.bank 23
	.org $A000
	.include "PRG/prg023.asm"

	.bank 24
	.org $8000
	.include "PRG/prg024.asm"

	.bank 25
	.org $A000
	.include "PRG/prg025.asm"

	.bank 26
	.org $8000
	.include "PRG/prg026.asm"

	; END CHR banks

	; Intro story and ending
	.bank 27
	.org $8000
	.include "PRG/prg027.asm"

	; One more CHR bank #28
	.bank 28
	.org $8000
	.include "PRG/prg028.asm"

	; Music bank 2 (virtual address extension)
	.bank 29
	.org $A000
	.include "PRG/prg029.asm"

	; Music/sound primary code bank
	.bank 30
	.org $8000
	.include "PRG/prg030.asm"

	; Music bank 1
	.bank 31
	.org $A000
	.include "PRG/prg031.asm"

	; Tilemap 0 (Bright Man) defs, object layouts, etc.
	; Weapon 0 (Mega Buster) damage table
	.bank 32
	.org $A000
	.include "PRG/prg032.asm"

	; Tilemap 1 (Toad Man) defs, object layouts, etc.
	; Weapon 1 (Rush Coil) damage table
	.bank 33
	.org $A000
	.include "PRG/prg033.asm"

	; Tilemap 2 (Drill Man) defs, object layouts, etc.
	; Weapon 2 (Rush Jet) damage table
	; Some additional CHR data at the end!
	.bank 34
	.org $A000
	.include "PRG/prg034.asm"

	; Tilemap 3 (Pharaoh Man) defs, object layouts, etc.
	; Weapon 3 (Rush Marine) damage table
	; Some additional CHR data at the end!
	.bank 35
	.org $A000
	.include "PRG/prg035.asm"

	; Tilemap 4 (Ring Man) defs, object layouts, etc.
	; Weapon 4 (Toad Rain) damage table
	.bank 36
	.org $A000
	.include "PRG/prg036.asm"

	; Tilemap 5 (Dust Man) defs, object layouts, etc.
	; Weapon 5 (Wire Adapter) damage table
	; Some additional CHR data at the end!
	.bank 37
	.org $A000
	.include "PRG/prg037.asm"

	; Tilemap 6 (Dive Man) defs, object layouts, etc.
	; Weapon 6 (Balloon) damage table
	; Some additional CHR data at the end!
	.bank 38
	.org $A000
	.include "PRG/prg038.asm"

	; Tilemap 7 (Skull Man) defs, object layouts, etc.
	; Weapon 7 (Dive Missile) damage table
	.bank 39
	.org $A000
	.include "PRG/prg039.asm"

	; Tilemap 8 (Cossack 1) defs, object layouts, etc.
	; Weapon 8 (Ring Boomerang) damage table
	.bank 40
	.org $A000
	.include "PRG/prg040.asm"

	; Tilemap 9 (Cossack 2) defs, object layouts, etc.
	; Weapon 9 (Drill Bomb) damage table
	.bank 41
	.org $A000
	.include "PRG/prg041.asm"

	; Tilemap 10 (Cossack 3) defs, object layouts, etc.
	; Weapon 10 (Dust Crusher) damage table
	; Some additional CHR data at the end!
	.bank 42
	.org $A000
	.include "PRG/prg042.asm"

	; Tilemap 11 (Cossack 4) defs, object layouts, etc.
	; Weapon 11 (Pharaoh Shot) damage table
	; Some additional CHR data at the end!
	.bank 43
	.org $A000
	.include "PRG/prg043.asm"

	; Tilemap 12 (Wily 1) defs, object layouts, etc.
	; Weapon 12 (Flash Stopper) damage [enable] table
	; Some additional CHR data at the end!
	.bank 44
	.org $A000
	.include "PRG/prg044.asm"

	; Tilemap 13 (Wily 2) defs, object layouts, etc.
	; Weapon 13 (Skull Barrier) damage table
	.bank 45
	.org $A000
	.include "PRG/prg045.asm"

	; Tilemap 14 (Wily 3) defs, object layouts, etc.
	; Some additional CHR data at the end!
	.bank 46
	.org $A000
	.include "PRG/prg046.asm"

	; Tilemap 15 (Wily 4) defs, object layouts, etc.
	; Some additional CHR data at the end!
	.bank 47
	.org $A000
	.include "PRG/prg047.asm"

	; Tilemap 16 (Credits, logo) defs, etc.
	; Some additional CHR data at the end!
	.bank 48
	.org $A000
	.include "PRG/prg048.asm"

	; Tilemap 17 (title) defs, etc.
	; Some additional CHR data at the end!
	.bank 49
	.org $A000
	.include "PRG/prg049.asm"

	; Tilemap 18 (Cossack/Wily fortress intro) defs, etc.
	; Some additional CHR data at the end!
	.bank 50
	.org $A000
	.include "PRG/prg050.asm"

	; Tilemap 19 (intro story) defs, etc.
	; Some additional CHR data at the end!
	.bank 51
	.org $A000
	.include "PRG/prg051.asm"

	; Tilemap 20 (Ending) defs, etc.
	.bank 52
	.org $A000
	.include "PRG/prg052.asm"

	; Object code bank
	.bank 53
	.org $A000
	.include "PRG/prg053.asm"

	; Sprite animation defs 4A
	.bank 54
	.org $8000
	.include "PRG/prg054.asm"

	; Sprite animation defs 4B
	.bank 55
	.org $A000
	.include "PRG/prg055.asm"

	; More object code, object init data
	.bank 56
	.org $A000
	.include "PRG/prg056.asm"

	; Title screen, level intermission (weapon get, Cossack/Wily Fortress path screen), password screen, robot master intro
	.bank 57
	.org $8000
	.include "PRG/prg057.asm"

	; Primary object code run area, object -> Player damage table, other init data (e.g. code pointers!)
	; More object code
	.bank 58
	.org $8000
	.include "PRG/prg058.asm"

	; More object code
	.bank 59
	.org $A000
	.include "PRG/prg059.asm"

	; Player code, weapon menu
	.bank 60
	.org $8000
	.include "PRG/prg060.asm"

	; More object code
	.bank 61
	.org $A000
	.include "PRG/prg061.asm"

	; Common bank always present at $C000
	.bank 62
	.org $C000
	.include "PRG/prg062.asm"

	; Common bank always present at $E000
	.bank 63
	.org $E000
	.include "PRG/prg063.asm"
