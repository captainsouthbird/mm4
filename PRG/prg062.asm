IntNMI:
	
	; Backup status and all registers
	PHP
	PHA
	TXA
	PHA
	TYA
	PHA
	
	LDA <RAM_00EA
	BEQ PRG062_C015	; If RAM_00EA = 0, jump to PRG062_C015


	; Push the VSplit request -> Raster_VSplit
	LDA <Raster_VSplit_Req
	STA <Raster_VSplit
	
	; Reset IntIRQ_FuncSel
	LDA #$00
	STA <IntIRQ_FuncSel
	
	JMP PRG062_C0D2	; Jump to PRG062_C0D2


PRG062_C015:
	LDA <DisFlag_NMIAndDisplay
	BEQ PRG062_C028	; If display is not disabled, jump to PRG062_C028

	; Display disabled

	LDA <PPU_CTL1_Copy
	AND #~%10000111	; No VBlank NMIs
	STA PPU_CTL1
	
	; Disable everything
	LDA #$00
	STA PPU_CTL2
	
	JMP PRG062_C0B7	; Jump to PRG062_C0B7


PRG062_C028:
	; Display not disabled

	; Commit all the scanline split vars
	LDA <Vert_Scroll
	STA <Raster_VSplit_VPos
	
	LDA <Horz_Scroll
	STA <Raster_VSplit_HPos
	
	LDA <PPU_CTL1_PageBaseReq
	STA <PPU_CTL1_PageBaseSel
	
	LDA <Raster_VSplit_Req
	STA <Raster_VSplit
	
	; Set IntIRQ_FuncSel to Raster_VMode
	LDA <Raster_VMode
	STA <IntIRQ_FuncSel
	
	; If raster effect RVMODE_CBOSS1, RVMODE_CBOSS2, RVMODE_CBOSS4, or RVMODE_WBOSS1, jump to PRG062_C04C
	
	CMP #RVMODE_CBOSS1
	BEQ PRG062_C04C
	CMP #RVMODE_CBOSS4
	BEQ PRG062_C04C
	CMP #RVMODE_CBOSS2
	BEQ PRG062_C04C
	CMP #RVMODE_WBOSS1
	BLT PRG062_C054


PRG062_C04C:
	; Raster effect RVMODE_CBOSS1, RVMODE_CBOSS2, RVMODE_CBOSS4, or RVMODE_WBOSS1

	; Commit horizontal position request
	LDA <Raster_VSplit_HPosReq
	STA <Raster_VSplit_HPos
	
	LDA <PPU_CTL1_PageBaseReq_RVBoss
	STA <PPU_CTL1_PageBaseSel

PRG062_C054:

	; Disable VBlank NMI
	LDA <PPU_CTL1_Copy
	AND #~%10000111
	STA PPU_CTL1
	
	; Disable display
	LDA #$00
	STA PPU_CTL2
	
	; Init PPU_SPR_ADDR to zero (common practice)
	STA PPU_SPR_ADDR
	
	; Initiate sprite DMA transfer
	LDA #$02
	STA SPR_DMA
	
	LDA <CommitGBuf_Flag
	BEQ PRG062_C06F		; If not committing graphics buffer (horizontal increment), jump to PRG062_C06F

	; Commit graphics buffer!
	JSR PRG062_CommitGfxBuffer_ClrFlag

PRG062_C06F:
	LDA <CommitGBuf_FlagV
	BEQ PRG062_C08A		; If not committing graphics buffer (vertical increment), jump to PRG062_C08A

	LDA <PPU_CTL1_Copy
	AND #~%10000000		; Disable NMI
	ORA #%00000100		; Vertical increment
	STA PPU_CTL1
	
	; Clear CommitGBuf_FlagV
	LDX #$00
	STX <CommitGBuf_FlagV
	
	JSR PRG062_CommitGfxBuffer
	
	; Disabling the vertical increment
	LDA <PPU_CTL1_Copy
	AND #~%10000000		; Disable NMI
	STA PPU_CTL1

PRG062_C08A:
	LDA <CommitPal_Flag
	BEQ PRG062_C0B7	; If not committing palette, jump to PRG062_C0B7

	; Clear CommitPal_Flag
	LDX #$00
	STX <CommitPal_Flag
	
	LDA PPU_STAT
	
	; Set PPU address to $3F00
	LDA #$3F
	STA PPU_VRAM_ADDR
	STX PPU_VRAM_ADDR
	
	; Write palette
	LDY #$20
PRG062_C09F:
	LDA PalData_1,X
	STA PPU_VRAM_DATA
	
	INX
	DEY
	BNE PRG062_C09F

	LDA #$3F
	STA PPU_VRAM_ADDR
	STY PPU_VRAM_ADDR
	STY PPU_VRAM_ADDR
	STY PPU_VRAM_ADDR

PRG062_C0B7:
	LDA PPU_STAT
	
	; Set scroll registers
	LDA <Raster_VSplit_HPos
	STA PPU_SCROLL
	LDA <Raster_VSplit_VPos
	STA PPU_SCROLL
	
	LDA <PPU_CTL2_Copy
	STA PPU_CTL2
	
	LDA <PPU_CTL1_PageBaseSel	; $C0C9
	AND #$03	; $C0CB
	ORA <PPU_CTL1_Copy	; $C0CD
	STA PPU_CTL1	; $C0CF

PRG062_C0D2:
	
	; Set scanline split reg
	LDA <Raster_VSplit
	STA MMC3_IRQCNT
	STA MMC3_IRQLATCH
	
	; Set whether the raster line interrupt is enabled
	LDX <RasterSplit_En
	STA MMC3_IRQDISABLE,X
	
	BEQ PRG062_C0ED	; If raster split is disabled, jump to PRG062_C0ED

	; Raster split enabled...

	LDX <IntIRQ_FuncSel
	
	; Set scanline interrupt function pointer (reset each V-Blank)
	LDA PRG062_IntIRQFunc_Table_L,X
	STA <IntIRQ_FuncPtr_L
	LDA PRG062_IntIRQFunc_Table_H,X
	STA <IntIRQ_FuncPtr_H

PRG062_C0ED:
	INC <Frame_Counter	; Frame_Counter++
	
	; RAM_0090 = $FF
	LDX #$FF
	STX <RAM_0090
	
	INX	; X = 0
	
	LDY #$04
PRG062_C0F6:
	LDA <ExecState_Slots,X	; $C0F6
	CMP #$01	; $C0F8
	BNE PRG062_C104	; $C0FA

	DEC <ExecState_Slots+1,X	; $C0FC
	BNE PRG062_C104	; $C0FE

	LDA #$04	; $C100
	STA <ExecState_Slots,X	; $C102

PRG062_C104:
	
	; X += 4
	INX
	INX
	INX
	INX
	
	DEY	; Y--
	BNE PRG062_C0F6	; While Y > 0, loop

	; SB: This code's funky, not really sure why CAPCOM did this screwy stack stuff.
	; But anyway, in experimentation with a debugger, the stack appears to always be
	; at $F8, thus the following opcode will set X=$F8, and that will base the RAM label.
	;
	; This is giving the music/sound update a place to return to, but boy this is peculiar.
	TSX	
	
	LDA Stack_Bottom-$F9,X
	STA <ISR_BackupAddr_H
	LDA Stack_Bottom-$FA,X
	STA <ISR_BackupAddr_L
	
	LDA #HIGH(PRG062_CallMusSndUpdate)
	STA Stack_Bottom-$F9,X
	LDA #LOW(PRG062_CallMusSndUpdate)
	STA Stack_Bottom-$FA,X
	
	; Restore regs
	PLA
	TAY
	PLA
	TAX
	PLA
	PLP
	
	RTI	; $C126

PRG062_CallMusSndUpdate:
	
	; One of these is to legitimately save the CPU status, the other two
	; are making room for a return address which will be patched...
	PHP
	PHP	
	PHP
	
	; Save regs
	PHA
	TXA
	PHA
	TYA
	PHA
		
	; See notes above when ISR_BackupAddr_L/H were set...
	; This backs up the ISR return address by one byte (why???)
	TSX
	
	SEC
	LDA <ISR_BackupAddr_L
	SBC #$01
	STA Stack_Bottom-$FB,X
	LDA <ISR_BackupAddr_H
	SBC #$00
	STA Stack_Bottom-$FA,X
	
	JSR PRG063_DoUpdateMusSnd	; Update sound/music!

	; Restore regs
	PLA
	TAY
	PLA
	TAX
	PLA
	
	; NOTE: Only one PLP matching the PHPs above, but the other two
	; were patched into a return address (backed up by 1)
	PLP
	
	RTS	; $C148


IntIRQ:
	; Save CPU status
	PHP
	
	; Save regs
	PHA
	TXA
	PHA
	TYA
	PHA
	
	; Acknowledge interrupt
	STA MMC3_IRQDISABLE
	STA MMC3_IRQENABLE	
	
	; Do whatever has been currently assigned!
	JMP [IntIRQ_FuncPtr_L]
	

PRG062_IntIRQ_1:
	LDA PPU_STAT
	
	; Set VRAM address to $2880
	LDA #$28
	STA PPU_VRAM_ADDR
	LDA #$80
	STA PPU_VRAM_ADDR
	
	; Set H-Scroll to IntIRQ_FS1_HScrl
	LDA <IntIRQ_FS1_HScrl
	STA PPU_SCROLL

	; Set V-Scroll to 0
	LDA #$00
	STA PPU_SCROLL
	
	; Nametable $2400
	LDA <PPU_CTL1_Copy
	ORA #%00000010
	STA PPU_CTL1
	
	; Set raster split to ($BE - Raster_VSplit)
	LDA #$BE
	SUB <Raster_VSplit
	STA MMC3_IRQCNT
	
	; Change raster split func for subsequent scanline interrupts this frame
	LDA #LOW(PRG062_IntIRQ_1B)
	STA <IntIRQ_FuncPtr_L
	LDA #HIGH(PRG062_IntIRQ_1B)
	STA <IntIRQ_FuncPtr_H
	
	JMP PRG062_C311	; Jump to PRG062_C311 (restore regs and exit)

PRG062_IntIRQ_1B:
	LDA PPU_STAT
	
	; Set VRAM address to $2300
	LDA #$23
	STA PPU_VRAM_ADDR
	LDA #$00
	STA PPU_VRAM_ADDR
	
	; Set scroll to 0,0
	LDA #$00
	STA PPU_SCROLL
	STA PPU_SCROLL
	
	LDA <PPU_CTL1_Copy
	AND #~%00000011
	STA PPU_CTL1
	
	JMP PRG062_IntIRQ_0	; Jump to PRG062_IntIRQ_0 (disable the scanline interrupt, restore regs, exit)

PRG062_IntIRQ_2:
	LDA PPU_STAT
	
	; Set VRAM address to $2100
	LDA #$21
	STA PPU_VRAM_ADDR
	LDA #$00
	STA PPU_VRAM_ADDR
	
	; Set scroll to 0,0
	LDA #$00
	STA PPU_SCROLL
	STA PPU_SCROLL

	; Set raster split to ($A0 - Raster_VSplit)
	LDA #$A0
	SUB <Raster_VSplit
	STA MMC3_IRQCNT
	
	; Change raster split func for subsequent scanline interrupts this frame
	LDA #LOW(PRG062_IntIRQ_2B)
	STA <IntIRQ_FuncPtr_L
	LDA #HIGH(PRG062_IntIRQ_2B)
	STA <IntIRQ_FuncPtr_H
	
	JMP PRG062_C311	; Jump to PRG062_C311 (restore regs and exit)

PRG062_IntIRQ_2B:
	LDA PPU_STAT
	
	; Set VRAM address to $2280
	LDA #$22
	STA PPU_VRAM_ADDR
	LDA #$80
	STA PPU_VRAM_ADDR

	JMP PRG062_C202	; Jump to PRG062_C202

PRG062_IntIRQ_3:
	LDA PPU_STAT
	
	; Set VRAM address $2280
	LDA #$80
	LDY #$22
	BNE PRG062_C23C	; Jump (technically always) to PRG062_C23C

PRG062_IntIRQ_4:
	LDA PPU_STAT
	
	LDA <Raster_VSplit_HPos
	LSR A
	LSR A
	LSR A
	AND #$1F	; (Raster_VSplit_HPos / 8) & $1F, basically set to column per Raster_VSplit_HPos
	ORA #$00	; Nothing, perhaps copy/paste error from similar functions below
	
	; Set PPU_VRAM_ADDR to $23xx
	LDY #$23
	STY PPU_VRAM_ADDR
	STA PPU_VRAM_ADDR
	
	LDA <PPU_CTL1_Copy
	STA PPU_CTL1
	
PRG062_C202:
	
	; Set scroll registers
	LDA <Raster_VSplit_HPos
	STA PPU_SCROLL
	LDA <Raster_VSplit_VPos
	STA PPU_SCROLL
	
	JMP PRG062_IntIRQ_0	; Jump to PRG062_IntIRQ_0 (disable the scanline interrupt, restore regs, exit)

PRG062_IntIRQ_5:
	LDA PPU_STAT
	
	LDA <Raster_VSplit_HPos
	LSR A
	LSR A
	LSR A
	AND #$1F	; (Raster_VSplit_HPos / 8) & $1F, basically set to column per Raster_VSplit_HPos
	ORA #$E0	; OR $E0 (So $E0 to $FF)
	
	; $21xx
	LDY #$21
	STY PPU_VRAM_ADDR
	STA PPU_VRAM_ADDR
	
	LDA <PPU_CTL1_Copy
	STA PPU_CTL1
	
	; Set scroll registers
	LDA <Raster_VSplit_HPos
	STA PPU_SCROLL
	LDA <Raster_VSplit_VPos
	STA PPU_SCROLL
	
	JMP PRG062_IntIRQ_0	; Jump to PRG062_IntIRQ_0 (disable the scanline interrupt, restore regs, exit)

PRG062_IntIRQ_6:
	LDA PPU_STAT
	
	; Set VRAM address to $2240
	LDA #$40
	LDY #$22

PRG062_C23C:
	STY PPU_VRAM_ADDR
	STA PPU_VRAM_ADDR

PRG062_C242:
	LDA <PPU_CTL1_Copy
	STA PPU_CTL1
	
	; Set scroll to 0,0
	LDA #$00
	STA PPU_SCROLL
	STA PPU_SCROLL
	
	JMP PRG062_IntIRQ_0	; Jump to PRG062_IntIRQ_0 (disable the scanline interrupt, restore regs, exit)

PRG062_IntIRQ_7:
	CLC	; Clear carry
	
	LDA PPU_STAT
	
	; Horizontal scroll
	LDA <Raster_VSplit_HPos
	EOR #$FF
	ADC #$01
	STA PPU_SCROLL	; Horizontal scroll = -Raster_VSplit_HPos
	
	; Vertical scroll
	LDA #$00
	STA PPU_SCROLL
	
	; Invert the page base selection
	LDA <PPU_CTL1_PageBaseSel
	EOR #$FF
	ADC #$00
	AND #$01
	ORA <PPU_CTL1_Copy
	STA PPU_CTL1
	
	; Scanline split at $4F
	LDA #$4F
	STA MMC3_IRQCNT
	
	; Change raster split func for subsequent scanline interrupts this frame
	LDA #LOW(PRG062_IntIRQ_7B)
	STA <IntIRQ_FuncPtr_L
	LDA #HIGH(PRG062_IntIRQ_7B)
	STA <IntIRQ_FuncPtr_H
	
	JMP PRG062_C311	; Jump to PRG062_C311 (restore regs and exit)

PRG062_IntIRQ_7B:
	LDA PPU_STAT
	
	LDA <Raster_VSplit_HPos
	STA PPU_SCROLL
	
	LDA <PPU_CTL1_Copy
	ORA <PPU_CTL1_PageBaseSel
	STA PPU_CTL1
	
	; Set scanline to $2F
	LDA #$2F
	STA MMC3_IRQCNT
	
	; Change raster split func for subsequent scanline interrupts this frame
	LDA #LOW(PRG062_C242)
	STA <IntIRQ_FuncPtr_L
	LDA #HIGH(PRG062_C242)
	STA <IntIRQ_FuncPtr_H
	
	JMP PRG062_C311	; Jump to PRG062_C311 (restore regs and exit)

PRG062_IntIRQ_8:
	LDA PPU_STAT
	
	; Set VRAM address to $2800
	LDA #$00
	LDY #$28
	STY PPU_VRAM_ADDR
	STA PPU_VRAM_ADDR
	
	; Set nametable to $2400
	LDA <PPU_CTL1_Copy
	ORA #%00000001
	STA PPU_CTL1
	
	; Set scroll to 0,0
	LDA #$00
	STA PPU_SCROLL
	STA PPU_SCROLL
	
	JMP PRG062_IntIRQ_0	; Jump to PRG062_IntIRQ_0 (disable the scanline interrupt, restore regs, exit)

PRG062_IntIRQ_9:
	LDA PPU_STAT
	
	; Set VRAM address to $2300
	LDA #$00
	LDY #$23
	STY PPU_VRAM_ADDR
	STA PPU_VRAM_ADDR
	
	LDA <PPU_CTL1_Copy
	STA PPU_CTL1
	
	; Set scroll to 0,0
	LDA #$00
	STA PPU_SCROLL
	STA PPU_SCROLL
	
	JMP PRG062_IntIRQ_0	; Jump to PRG062_IntIRQ_0 (disable the scanline interrupt, restore regs, exit)

PRG062_IntIRQ_11:
	LDA PPU_STAT
	
	LDA <PPU_CTL1_Copy
	STA PPU_CTL1
	
	; Set scroll
	LDA <Horz_Scroll
	STA PPU_SCROLL
	LDA <Vert_Scroll
	STA PPU_SCROLL
	
	; Set scanline split to $28
	LDA #$28
	STA MMC3_IRQCNT
	
	; Change raster split func for subsequent scanline interrupts this frame
	LDA #LOW(PRG062_IntIRQ_10)
	STA <IntIRQ_FuncPtr_L
	LDA #HIGH(PRG062_IntIRQ_10)
	STA <IntIRQ_FuncPtr_H
	
	JMP PRG062_C311	; Jump to PRG062_C311 (restore regs and exit)

PRG062_IntIRQ_10:
	LDA PPU_STAT
	
	LDA <PPU_CTL1_Copy
	STA PPU_CTL1
	
	; Set scroll to 0,0
	LDA #$00
	STA PPU_SCROLL
	STA PPU_SCROLL

PRG062_IntIRQ_0:
	; Disable the scanline interrupt
	STA MMC3_IRQDISABLE

PRG062_C311:
	
	; Restore registers
	PLA
	TAY
	PLA
	TAX
	PLA
	PLP
	
	RTI	; $C317


	; Addresses used to set IntIRQ_FuncPtr_L/H by value in IntIRQ_FuncSel every V-Blank
PRG062_IntIRQFunc_Table_L:
	.byte LOW(PRG062_IntIRQ_0)		; 0 (Do nothing)
	.byte LOW(PRG062_IntIRQ_1)		; 1
	.byte LOW(PRG062_IntIRQ_2)		; 2
	.byte LOW(PRG062_IntIRQ_3)		; 3
	.byte LOW(PRG062_IntIRQ_4)		; 4
	.byte LOW(PRG062_IntIRQ_5)		; 5
	.byte LOW(PRG062_IntIRQ_6)		; 6
	.byte LOW(PRG062_IntIRQ_7)		; 7
	.byte LOW(PRG062_IntIRQ_8)		; 8
	.byte LOW(PRG062_IntIRQ_9)		; 9
	.byte LOW(PRG062_IntIRQ_10)		; 10
	.byte LOW(PRG062_IntIRQ_11)		; 11
	
PRG062_IntIRQFunc_Table_H:
	.byte HIGH(PRG062_IntIRQ_0)		; 0 (Do nothing)
	.byte HIGH(PRG062_IntIRQ_1)		; 1
	.byte HIGH(PRG062_IntIRQ_2)		; 2
	.byte HIGH(PRG062_IntIRQ_3)		; 3
	.byte HIGH(PRG062_IntIRQ_4)		; 4
	.byte HIGH(PRG062_IntIRQ_5)		; 5
	.byte HIGH(PRG062_IntIRQ_6)		; 6
	.byte HIGH(PRG062_IntIRQ_7)		; 7
	.byte HIGH(PRG062_IntIRQ_8)		; 8
	.byte HIGH(PRG062_IntIRQ_9)		; 9
	.byte HIGH(PRG062_IntIRQ_10)	; 10
	.byte HIGH(PRG062_IntIRQ_11)	; 11


	; Commits graphics buffer to VRAM
PRG062_CommitGfxBuffer_ClrFlag:

	; CommitGBuf_Flag = 0
	LDX #$00
	STX <CommitGBuf_Flag

PRG062_CommitGfxBuffer:
	LDA Graphics_Buffer+$00,X
	BMI PRG062_C354	; If hit terminator, jump to PRG062_C354 (RTS)

	; Set VRAM address
	STA PPU_VRAM_ADDR
	LDA Graphics_Buffer+$01,X
	STA PPU_VRAM_ADDR
	
	; Count of bytes to write
	LDY Graphics_Buffer+$02,X
PRG062_C345:
	; Byte to commit
	LDA Graphics_Buffer+$03,X
	STA PPU_VRAM_DATA
	
	INX	; X++
	DEY	; Y--
	BPL PRG062_C345	; While Y >= 0, loop!

	; X++ (additional advancement passed the previous address and count)
	INX
	INX
	INX
	BNE PRG062_CommitGfxBuffer	; Loop!


PRG062_C354:
	RTS	; $C354

	; $C355
	LDA <PPU_CTL1_Copy
	AND #$11
	STA <PPU_CTL1_Copy
	STA PPU_CTL1
	RTS

	; $C35F
	LDA <PPU_CTL1_Copy
	ORA #$80
	STA <PPU_CTL1_Copy
	STA PPU_CTL1
	RTS


PRG062_DisableDisplay:
	INC <RAM_00EA
	
	; Disable display
	LDA #%00000000
	STA <PPU_CTL2_Copy
	STA PPU_CTL2
	
	RTS


PRG062_EnableDisplay:
	DEC <RAM_00EA
	
	; Enable display (show sprites + BG)
	LDA #%00011000
	STA <PPU_CTL2_Copy
	STA PPU_CTL2
	
	RTS


PRG062_UpdControllers:
	LDX #$01	; $C37D
	STX JOYPAD	; $C37F
	DEX	; $C382
	STX JOYPAD	; $C383
	LDX #$08	; $C386

PRG062_C388:
	LDA JOYPAD	; $C388
	LSR A	; $C38B
	ROL <Ctlr1_Pressed	; $C38C
	LSR A	; $C38E
	ROL <Temp_Var0	; $C38F
	LDA FRAMECTR_CTL	; $C391
	LSR A	; $C394
	ROL <Ctlr2_Pressed	; $C395
	LSR A	; $C397
	ROL <Temp_Var1	; $C398
	DEX	; $C39A
	BNE PRG062_C388	; $C39B

	LDA <Temp_Var0	; $C39D
	ORA <Ctlr1_Pressed	; $C39F
	STA <Ctlr1_Pressed	; $C3A1
	LDA <Temp_Var1	; $C3A3
	ORA <Ctlr2_Pressed	; $C3A5
	STA <Ctlr2_Pressed	; $C3A7
	LDX #$01	; $C3A9

PRG062_C3AB:
	LDA <Ctlr1_Pressed,X	; $C3AB
	TAY	; $C3AD
	EOR <Ctlr1_Held,X	; $C3AE
	AND <Ctlr1_Pressed,X	; $C3B0
	STA <Ctlr1_Pressed,X	; $C3B2
	STY <Ctlr1_Held,X	; $C3B4
	DEX	; $C3B6
	BPL PRG062_C3AB	; $C3B7

	LDX #$03	; $C3B9

PRG062_C3BB:
	LDA <Ctlr1_Pressed,X	; $C3BB
	AND #$0C	; $C3BD
	CMP #$0C	; $C3BF
	BEQ PRG062_C3CB	; $C3C1

	LDA <Ctlr1_Pressed,X	; $C3C3
	AND #$03	; $C3C5
	CMP #$03	; $C3C7
	BNE PRG062_C3D1	; $C3C9


PRG062_C3CB:
	LDA <Ctlr1_Pressed,X
	AND #$F0
	STA <Ctlr1_Pressed,X

PRG062_C3D1:
	DEX	; $C3D1
	BPL PRG062_C3BB	; $C3D2

	RTS	; $C3D4


PRG062_ClearVRAM:

	; A/X/Y settings

	STA <Temp_Var0	; A -> Temp_Var0 (VRAM high address)
	STX <Temp_Var1	; X -> Temp_Var1 (Value to clear VRAM to)
	STY <Temp_Var2	; Y -> Temp_Var2 (Multiple of $100 bytes to clear for non-nametable OR value to clear nametable's attribute data to)
	
	LDA PPU_STAT
	
	LDA <PPU_CTL1_Copy
	AND #~$01
	STA PPU_CTL1
	
	; Set PPU_VRAM_ADDR to $[Temp_Var0]00 
	LDA <Temp_Var0
	STA PPU_VRAM_ADDR
	LDY #$00
	STY PPU_VRAM_ADDR
	
	LDX #$04	; X = $04 (4 loops, thus covering $400 bytes, for covering an entire nametable)

	CMP #$20	; Temp_Var0 
	BGE PRG062_C3F7	; If Temp_Var0 >= $20 (Nametable access), jump to PRG062_C3F7

	; Non-nametable access
	LDX <Temp_Var2	; Otherwise X = Temp_Var2 (multiple of $100 bytes to clear)

PRG062_C3F7:

	; Clear VRAM range to value "Temp_Var1"
	LDY #$00		; Y = 0
	LDA <Temp_Var1	; A = Temp_Var1
PRG062_C3FB:
	STA PPU_VRAM_DATA
	DEY
	BNE PRG062_C3FB
	DEX
	BNE PRG062_C3FB

	LDY <Temp_Var2		; Y = value to clear nametable's attribute data to

	LDA <Temp_Var0
	CMP #$20
	BLT PRG062_C41E		; If Temp_Var0 < $20 (non-nametable access), jump to PRG062_C41E

	; For nametables only...

	; Offset to the corresponding nametable's attribute table
	; PPU_VRAM_ADDR = [Temp_Var0+$02]$C0
	ADC #$02
	STA PPU_VRAM_ADDR
	LDA #$C0
	STA PPU_VRAM_ADDR
	
	; Clear attribute data to Temp_Var2
	LDX #$40
PRG062_C418:
	STY PPU_VRAM_DATA
	DEX
	BNE PRG062_C418


PRG062_C41E:
	
	LDX <Temp_Var1	; X is restored
	
	RTS	; $C420


PRG062_ResetSprites:
	LDX <Sprite_CurrentIndex	; X = Sprite_CurrentIndex
	
	CPX #$04
	BNE PRG062_C42C	; If X <> 4, jump to PRG062_C42C

	; X = 4 needs to additionally clear sprite 0 because of the wonky way this loop works
	LDA #$F8	; Y = $F8 (effective clear)
	STA Sprite_RAM+$00

PRG062_C42C:
	
	LDA #$F8	; Y = $F8 (effective clear)
PRG062_C42E:
	STA Sprite_RAM+$00,X
	
	INX
	INX
	INX
	INX
	BNE PRG062_C42E	; Loop for all sprites

	RTS	; $C437


PRG062_ClearSpriteSlots:

	; Clear the sprite system vars
	LDX #$17	; X = $17
PRG062_C43A:
	LDA #$00
	STA Spr_SlotID+$00,X
	STA Spr_CodePtrH+$00,X
	STA Spr_FlashOrPauseCnt,X
	STA Spr_HP+$00,X
	
	LDA #$FF
	STA Spr_SpawnParentIdx,X
	
	DEX					; X--
	BNE PRG062_C43A		; While X <> 0, loop!

	RTS	; $C450


PRG062_PalFadeIn:
	LDA #$30	; A = $30 (Fade level)
	LDX #-$10	; X = -$10 (Fade delta)
	BNE PRG062_C45A	; $C455


PRG062_PalFadeOut:
	
	LDA #$10	; A = $10 (Fade level)
	TAX			; X = $10 (Fade delta)
	
PRG062_C45A:
	STA <Temp_Var15	; Temp_Var15 = fade level
	
	STX <Temp_Var13	; Temp_Var13 = fade delta
	
	; Temp_Var14 = 4 (controls fade speed)
	LDY #$04
	STY <Temp_Var14

PRG062_C462:

	; Copy PalData_2+Y to PalData_1+Y (Copy PalData_2 to PalData_1)
	LDY #$1F
PRG062_C464:
	LDA PalData_2,Y
	STA PalData_1,Y
	
	DEY	; Y--
	BPL PRG062_C464	; While Y >= 0, loop

	; Save Pal_FadeMask
	LDA <Pal_FadeMask
	PHA
	
	LDY #$1F	; Y = $1F (all palette entries)
PRG062_C472:
	TYA	
	AND #$03
	CMP #$03
	BNE PRG062_C483	; If this isn't the start of a new palette quad, jump to PRG062_C483
	
	; Start of one of the palette quads...

	LSR <Pal_FadeMask
	BCC PRG062_C483	; If respective bit on Pal_FadeMask isn't set, jump to PRG062_C483
	
	; Quad has been masked, so skip it!

	; Y -= 3
	DEY
	DEY
	DEY
	
	JMP PRG062_C490	; Jump to PRG062_C490


PRG062_C483:
	LDA PalData_1,Y
	SUB <Temp_Var15	; Fade delta
	BPL PRG062_C48D	; If it didn't underflow, jump to PRG062_C48D

	LDA #$0F	; Set to black

PRG062_C48D:
	STA PalData_1,Y	; Update palette entry

PRG062_C490:
	DEY				; Y--
	BPL PRG062_C472	; While Y >= 0, loop

	STY <CommitPal_Flag	; commit palette
	
	; Restore Pal_FadeMask
	PLA
	STA <Pal_FadeMask

	; Essentially a variable delay loop
	LDA <Temp_Var14		; A = Temp_Var14
PRG062_C49A:
	PHA		; Save Temp_Var14 val
	
	JSR PRG063_UpdateOneFrame
	
	PLA		; Restore Temp_Var14 val
	
	SUB #$01
	BNE PRG062_C49A	; If haven't hit zero, loop

	LDA <Temp_Var15	; Current fade level
	ADD <Temp_Var13	; Apply fade delta
	STA <Temp_Var15	; Update fade level
	
	CMP #$50
	BEQ PRG062_C4B3	; If overflowed, jump to PRG062_C4B3

	LDA <Temp_Var15
	BPL PRG062_C462	; If didn't underflow, jump to PRG062_C462 (update and around again)


PRG062_C4B3:

	; Pal_FadeMask = 0
	LDA #$00
	STA <Pal_FadeMask
	
	RTS	; $C4B7

	; $C4B8
	; FIXME: Is this referenced?
	STX <Temp_Var14
	STY <Temp_Var15
	ASL A
	TAY
	INY
	PLA
	STA <Temp_Var12
	PLA
	STA <Temp_Var13
	LDA [Temp_Var12],Y
	TAX
	INY
	LDA [Temp_Var12],Y
	STA <Temp_Var13
	STX <Temp_Var12
	LDX <Temp_Var14
	LDY <Temp_Var15
	JMP [Temp_Var12]


PRG062_C4D6:

	; Stack pointer to $7F (??)
	LDX #$7F
	TXS


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; MAIN GAME LOOP FOR EVERYTHING
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRG062_C4D9:

	; Generate random values
	LDX #$00	; X = 0
	LDY #$04	; Y = 4
	
	LDA <RandomN+$00,X
	AND #$02
	STA <Temp_Var0
	
	LDA <RandomN+$01,X
	AND #$02
	EOR <Temp_Var0
	CLC
	BEQ PRG062_C4ED

	SEC

PRG062_C4ED:
	ROR <RandomN+$00,X
	
	INX	; X++
	DEY	; Y--
	BNE PRG062_C4ED	; While Y <> 0, loop

	; Backup and switch $A000 page to 32
	LDA <MMC3_PageA000_Req
	PHA
	LDA #32
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks	; $C4FA

	JSR PRG032_B800

	; Restore page at $A000
	PLA
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks	; $C503

	JSR PRG063_UpdateOneFrame	; $C506

	JMP PRG062_C4D9	; LOOP FOREVER!!

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRG062_C50C:

	; Moving stack to $01BF (???)
	LDX #$BF
	TXS
	
	LDA <PPU_CTL1_Copy
	STA PPU_CTL1
	
	JSR PRG063_UpdateOneFrame

	LDA #$88
	STA <RandomN+$00		; Random seed
	STA <Raster_VSplit_Req	; Raster_VSplit_Req = $88
	
	LDA #HIGH(PRG062_C4D6)
	STA <Temp_AddrH
	LDA #LOW(PRG062_C4D6)
	STA <Temp_AddrL
	
	; Put PRG062_C4D6 into exec slot 1
	LDA #$01
	JSR PRG063_LoadExecSlot

	; Enable interrupts
	CLI
	
	LDA #$01	; $C52B
	STA <RasterSplit_En	; $C52D
	
	; Set bank 57 at $8000
	LDA #57
	STA <MMC3_Page8000_Req
	JSR PRG063_SetPRGBanks

	; Initial credits, story, title, stage select
	JSR PRG057_DoStoryTitlStagSel_Ind

	; BOSS SELECTED, LEVEL START

	; Player starts with 2 lives
	LDA #$02
	STA <Player_Lives
	
	; Player starts with Rush Jet
	LDA #$9C
	STA <Player_WpnEnergy+$00

PRG062_C541:
	; Fade out
	JSR PRG062_PalFadeOut

	; Gravity = $40
	LDA #$40
	STA <Gravity
	
	; Reset sprites and sprite slots
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites
	JSR PRG062_ClearSpriteSlots
	JSR PRG063_UpdateOneFrame

	; Clear some other game RAM
	JSR PRG057_ClearGameRAM_Ind

	LDA <Player_Midpoint
	
	; NOTE: These STAs only make sense with Player_Midpoint = 0...
	STA <MetaBlk_CurScreen
	STA <Current_Screen
	STA Spr_XHi+$00
	STA <Temp_Var45
	STA <Temp_Var46
	STA <Temp_Var47
	STA <Temp_Var48
	
	BEQ PRG062_C592	; If Player_Midpoint = 0, jump to PRG062_C592

	; Player_Midpoint <> 0, and thus the values just set aren't actually valid...

	ASL A
	ASL A
	STA <Temp_Var0	; Temp_Var0 = Player_Midpoint * 4
	
	LDA <TileMap_Index
	ASL A
	ASL A
	ASL A
	ADC <Temp_Var0
	TAY	; Y = (TileMap_Index * 8) + (Player_Midpoint * 4)
	
	; Initialize data appropriately for starting at this level midpoint
	LDA PRG062_LevelMidStartInitData-4,Y
	STA <MetaBlk_CurScreen
	STA <Current_Screen
	STA Spr_XHi+$00
	STA <Temp_Var45
	LDA PRG062_LevelMidStartInitData-3,Y
	STA <Temp_Var46
	LDA PRG062_LevelMidStartInitData-2,Y
	STA <Temp_Var47
	LDA PRG062_LevelMidStartInitData-1,Y
	STA <Temp_Var48

PRG062_C592:
	INC <Temp_Var45
	
	; Disable display
	JSR PRG062_DisableDisplay

	; Load graphics and initialize full current screen
	LDX <TileMap_Index
	JSR PRG062_Upl_SprPal_CHRPats

	LDX <Temp_Var47
	BEQ PRG062_C5A3	; If Temp_Var47 = 0 (no alternate graphics to load), jump to PRG062_C5A3

	; Load alternate graphics/palette
	JSR PRG062_Upl_SprPal_CHRPats

PRG062_C5A3:

	; Enable display
	JSR PRG062_EnableDisplay

	; ScreenUpd_CurCol = 0
	LDA #$00
	STA <ScreenUpd_CurCol

PRG062_C5AA:
	; Update for scrolling
	JSR PRG062_SetMBA_DrawColumn
	JSR PRG063_UpdateOneFrame

	LDA <MetaBlk_CurScreen
	CMP <Temp_Var45
	BEQ PRG062_C5C4	

	; Next column
	INC <ScreenUpd_CurCol
	LDA <ScreenUpd_CurCol
	AND #$1F
	STA <ScreenUpd_CurCol
	
	BNE PRG062_C5AA	; If screen hasn't fully advanced, jump to PRG062_C5AA

	; New screen
	INC <MetaBlk_CurScreen
	BNE PRG062_C5AA	; Jump (technically always) to PRG062_C5AA (render new column)

PRG062_C5C4:
	LDA #$01	; $C5C4
	STA <RAM_0023	; $C5C6
	STA <Level_LastScrollDir	; Level_LastScrollDir = 1
	
	LDY Spr_XHi+$00
	
	; Set spawn hint values for the screen
	LDA Level_LayoutObjHintByScr,Y
	STA <RAM_009E
	STA <RAM_009F
	
	LDY <Temp_Var46	; Y = start segment 
	
	LDA Level_SegmentDefs,Y
	PHA		; Save full segment def value
	
	AND #$F0				; Only keep the upper nibble, the segment settings
	ORA <Temp_Var46			; Keep the segment index!
	STA <Level_SegCurData	; -> Level_SegmentDefs
	
	AND #$20
	BEQ PRG062_C5E8		; If bit $20 in segment settings is not set (not horizontal), jump to PRG062_C5E8
	
	; Keep bit $20, but still set the segment index
	ORA <Temp_Var46
	STA <Level_SegCurData

PRG062_C5E8:

	; Level_SegCurrentRelScreen = 0
	LDA #$00
	STA <Level_SegCurrentRelScreen
	
	PLA	; Restore the full segment settings value
	
	; Total screens of segment -> Level_SegTotalRelScreen
	AND #$0F
	STA <Level_SegTotalRelScreen
	
	LDA <Level_SegCurData
	AND #($80 | $40)
	BEQ PRG062_C607	; No vertical change settings set, jump to PRG062_C607

	LDA #$08	; $C5F7
	STA <RAM_0023	; $C5F9
	
	; ScreenUpd_CurCol = 0
	LDA #$00
	STA <ScreenUpd_CurCol
	
	STA MMC3_MIRROR	; Horizontal mirroring
	
	; Set current screen to Player's position
	LDA Spr_XHi+$00
	STA <MetaBlk_CurScreen

PRG062_C607:

	; Palette selection from Level_BGPaletteData
	LDA <Temp_Var48
	
	ASL A
	ASL A
	STA <Temp_Var0		; Temp_Var0 = Temp_Var48 * 4
	
	ASL A
	ASL A				; Temp_Var48 * 16
	ADC <Temp_Var0		; +Temp_Var0
	TAX					; X = (Temp_Var48 * 20)
	
	
	LDY #$00	; $C612

PRG062_C614:
	; Copy in BG palette
	LDA Level_BGPaletteData,X
	STA PalData_2,Y
	
	CPY #$04
	BGE PRG062_C62C	; If 'Y' >= 4, jump to PRG062_C62C
	
	; For indexes 0 to 3 ONLY

	; Palette animation data (FIXME figure this out)
	LDA Level_BGPaletteData+16,X
	STA PalAnim_EnSel+$00,Y

	LDA #$00
	STA PalAnim_CurAnimOffset+$00,Y
	STA PalAnim_TickCount+$00,Y

PRG062_C62C:
	CPY #$08
	BGE PRG062_C636	; If 'Y' >= 8, jump to PRG062_C636

	; For indexes 0 to 7 ONLY

	; Player's default (blue) palette
	LDA PRG062_PlayerDefaultPal,Y
	STA PalData_2+16,Y

PRG062_C636:
	INX	; X++
	INY	; Y++
	CPY #16
	BNE PRG062_C614	; While 'Y' <> 16, loop!

	; Sync BG color 0 with SPR color 0
	LDA PalData_2
	STA PalData_2+16
	
	; Set player's sprite slot ID
	LDA #SPRSLOTID_PLAYER
	STA Spr_SlotID+$00
	
	; Init Player X (at startup, this will be initially the "READY", but this will be used as player's starting X as well)
	LDA #$80
	STA Spr_X+$00
	STA <RAM_0027	; $C64C
	STA HUDBarP_DispSetting
	
	LDA #(SPRFL1_ONSCREEN | SPRFL1_SCREENREL)
	STA Spr_Flags+$00
	
	; Init Player Y (actually for the "READY", at startup, this will be initially the "READY", will not ultimately effect the player's Y)
	LDA #$64
	STA Spr_Y+$00
	
	; Default Player Y position and weapon
	LDX #$00
	STX Spr_YHi+$00
	STX <Player_CurWeapon
	STX Player_WpnMenuCurSel
	
	; "READY" animation
	LDA #SPRANM2_READY
	JSR PRG063_SetSpriteAnim

	JSR PRG063_SetObjYVelToMinus1

	; Player_State = PLAYERSTATE_READY
	LDA #PLAYERSTATE_READY
	STA <Player_State
	
	; Setting Player's horizontal speed
	LDA #$4C
	STA Spr_XVelFrac+$00
	STA <Player_HCurSpeedFrac
	LDA #$01
	STA Spr_XVel+$00
	STA <Player_HCurSpeed
	
	; Queue the song for this level
	LDY <TileMap_Index
	LDA PRG062_MusForLevel,Y
	JSR PRG063_QueueMusSnd_SetMus_Cur

	; Init Player's HP
	LDA #$9C
	STA <Player_HP
	
	LDA <TileMap_Index
	CMP #TMAP_WILY3
	BNE PRG062_C6C7	; If this is not Wily 3, jump to PRG062_C6C7

	; Wily 3 only...

	LDA <Current_Screen
	CMP #$09
	BNE PRG062_C6C7	; If not on screen 9, jump to PRG062_C6C7

	; Wily 3, screen 9...

	LDA <LevelWily3_TransSysComp
	CMP #$FF
	BNE PRG062_C6C7	; If not all Wily Transport System bosses complete, jump to PRG062_C6C7

	; Graphics buffer to install Wily's transporter
	LDY #$42
PRG062_C69F:
	LDA PRG062_WilyTransporterGBuf,Y
	STA Graphics_Buffer,Y
	DEY
	BPL PRG062_C69F

	STY <CommitGBuf_Flag	; CommitGBuf_Flag = $FF
	
	; Setup transporter's blinking light
	LDY #$17
	LDX #$00
	LDA #SPRANM2_TRANSPBLINKER
	JSR PRG063_CopySprSlotSetAnim
	
	LDA #$1C
	STA Spr_Flags2+$00,Y
	LDA #$B3
	STA Spr_SlotID+$00,Y
	LDA #$80
	STA Spr_X+$00,Y
	LDA #$44
	STA Spr_Y+$00,Y

PRG062_C6C7:
	JSR PRG063_UpdateOneFrame

	; Fade in to level
	JSR PRG062_PalFadeIn

	LDY <TileMap_Index	; Y = TileMap_Index
	
	LDA PRG062_InitPlayerBG,Y
	STA <Object_ReqBGSwitch
	
	LDA <TileMap_Index
	CMP #TMAP_PHARAOHMAN
	BEQ PRG062_C6EB	; If this is Pharaoh Man, jump to PRG062_C6EB
	
	CMP #TMAP_TOADMAN
	BNE PRG062_C6F3	; If this is NOT Toad Man, jump to PRG062_C6F3

	; Toad Man only...

	LDA <Level_SegCurData
	AND #$0F
	TAY	; Y = current segment index
	
	LDA PRG062_CFA1,Y
	STA <Object_ReqBGSwitch
	
	JMP PRG062_C6F3	; Jump to PRG062_C6F3


PRG062_C6EB:

	; Pharaoh Man only...

	LDA <Player_Midpoint
	BEQ PRG062_C6F3	; If player hasn't reached midpoint, jump to Player_Midpoint

	; Pharaoh Man at some midpoint...

	LDA #$00	; $C6EF
	STA <Object_ReqBGSwitch	; $C6F1

PRG062_C6F3:
	LDA <TileMap_Index
	CMP #$08
	BNE PRG062_C707	; If this is not Cossack level 1, jump to PRG062_C707

	; Cossack level 1...

	LDA #$00	; $C6F9
	STA <Object_ReqBGSwitch	; $C6FB
	
	LDA <Current_Screen
	CMP #$06
	BGE PRG062_C707	; If on screen 6 or greater, jump to PRG062_C707

	; Cossack level 1, screen 5 or less

	LDA #$90	; $C703
	STA <Object_ReqBGSwitch	; $C705

PRG062_C707:
	LDA <CommitGBuf_Flag
	ORA <CommitGBuf_FlagV
	BNE PRG062_C740	; If CommitGBuf_Flag or CommitGBuf_FlagV is not zero, jump to PRG062_C740

	; CommitGBuf_Flag and CommitGBuf_FlagV are zero...

	LDA <Ctlr1_Pressed
	AND #PAD_START
	BEQ PRG062_C740	; If Player is not pressing START, jump to PRG062_C740

	; Player has pressed START...

	LDA <Player_State
	CMP #$02
	BEQ PRG062_C740	; If Player_State = 2 (FIXME), jump to PRG062_C740

	CMP #$05
	BGE PRG062_C740	; If Player_State >= 5 (FIXME), jump to PRG062_C740

	LDA Weapon_FlashStopCnt+$00
	ORA Weapon_FlashStopCnt+$01
	ORA Weapon_ToadRainCounter
	BNE PRG062_C740	; If Flash Stopper or Rain Flush is active, jump to PRG062_C740

	LDA Level_LightDarkCtl
	BEQ PRG062_C731	; If level is not brightening / darkening (think Bright Man), jump to PRG062_C731

	CMP #$40
	BNE PRG062_C740	; If level is not fully dark, jump to PRG062_C740

PRG062_C731:
	; Install page 60 at $8000
	LDA #60
	STA <MMC3_Page8000_Req
	JSR PRG063_SetPRGBanks

	; Sound effect for opening weapons menu
	LDA #SFX_WEAPONMENU
	JSR PRG063_QueueMusSnd

	; Open weapons menu!
	JSR PRG060_OpenWeaponMenu

PRG062_C740:
	; Not opening / closed weapons menu...

	; Install pages 60 and 61 at $8000 and $A000
	LDX #60
	STX <MMC3_Page8000_Req	; $C742
	INX	; X = 61
	STX <MMC3_PageA000_Req	; $C745
	JSR PRG063_SetPRGBanks	; $C747

	; Make the Player happen!!!!
	JSR PRG060_DoPlayer

	; Install pages 58 and 59 at $8000 and $A000
	LDX #58
	STX <MMC3_Page8000_Req
	INX	; X = 59
	STX <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

	; Updates all objects, handles damage Player <-> Objects
	JSR PRG058_UpdateObjsDoDamages

	; Set bank 32-52 by current level
	LDA <TileMap_Index
	ORA #32
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

	; While scrolling, update segments, load graphics, palettes, etc.
	JSR PRG062_ScrollUpdSegmentData

	; Set bank 56 @ $8000
	LDA #56
	STA <MMC3_Page8000_Req
	
	; Set bank 32-52 by current level
	LDA <TileMap_Index
	ORA #32
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks
	
	JSR (PRG056_LevelObjDynamicSpawns & $9FFF)	; WARNING: Bank is positioned for $A000, but this entry comes in at $8000
	
	JSR PRG063_RingManRainbowPlatGfx	; Update Ring Man's rainbow platform graphics, if applicable
	JSR PRG063_E35C	; $C779
	JSR PRG063_CopyMetaBlockToGBuf	
	JSR PRG063_BrightManLightDarkFX	; Bright Man's bright/dark effect
	JSR PRG063_DrillManUpdScrlForSw
	JSR PRG063_DustManCrusherBustBlock	; Dust Man crusher blocks getting shot out

	LDA <Player_HCurSpeedFrac
	STA Spr_XVelFrac+$00
	LDA <Player_HCurSpeed
	STA Spr_XVel+$00
	
	LDA <TileMap_Index
	ASL A
	ADD <Player_Midpoint
	TAY	; Y = (TileMap_Index * 2) + Player_Midpoint
	
	LDA <Horz_Scroll	; $C799
	STA <RAM_0025	; $C79B
	LDA Spr_X+$00	; $C79D
	STA <RAM_0027	; $C7A0
	
	LDA Spr_XHi+$00	; $C7A2
	STA <RAM_0028	; $C7A5
	
	CMP PRG062_MidPointScrPoints,Y
	BNE PRG062_C7B4	; If Player hasn't reached this midpoint, jump to PRG062_C7B4

	LDA <Player_Midpoint
	CMP #$02
	BEQ PRG062_C7B4	; If Player is already at the final midpoint, jump to PRG062_C7B4

	; New midpoint achieved!
	INC <Player_Midpoint

PRG062_C7B4:

	; Clear sprites
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites
	
	JSR PRG062_DoDrawSprites

	; Clear triggers, update frame
	LDA #$00
	STA <Player_TriggerDeath
	STA <Player_HitWallR_Flag	; $C7C2
	STA <DisFlag_NMIAndDisplay	; $C7C4
	JSR PRG063_UpdateOneFrame

	INC <DisFlag_NMIAndDisplay
	
	LDA <Player_State
	CMP #PLAYERSTATE_DEAD
	BEQ PRG062_C7DD	; If Player is dead, jump to PRG062_C7DD

	CMP #PLAYERSTATE_TELEPORTOUT
	BEQ PRG062_C7DD	; If Player is teleporting out, jump to PRG062_C7DD

	CMP #PLAYERSTATE_GOTSPWEAPON
	BEQ PRG062_C7DD	; If Player is getting special item (e.g. Wire Adapter, Balloon), jump to PRG062_C7DD

	CMP #PLAYERSTATE_TELEPORTEND
	BNE PRG062_C7F3	; If Player is not teleporting out for the ending, jump to PRG062_C7F3


PRG062_C7DD:
	; Player is in a state awaiting timeout...

	LDA Level_ExitTimeout
	SUB #$01
	STA Level_ExitTimeout
	LDA Level_ExitTimeoutH
	SBC #$00
	STA Level_ExitTimeoutH
	ORA Level_ExitTimeout
	BEQ PRG062_C7F6	; If timeout reached, jump to PRG062_C7F6


PRG062_C7F3:
	; Either not a timeout state or timeout not reached...

	JMP PRG062_C6F3	; Jump to PRG062_C6F3


PRG062_C7F6:
	; Player is in a timeout state and timeout reached

	; Backup TileMap_Index -> TileMap_IndexBackup
	LDA <TileMap_Index
	STA TileMap_IndexBackup
	
	LDA #$00	; $C7FB
	STA <DisFlag_NMIAndDisplay	; $C7FD
	STA PalAnim_EnSel+$00	; $C7FF
	STA PalAnim_EnSel+$01	; $C802
	STA PalAnim_EnSel+$02	; $C805
	STA PalAnim_EnSel+$03	; $C808
	
	LDA <Player_State
	CMP #PLAYERSTATE_TELEPORTEND
	BEQ PRG062_C83C	; If Player is teleporting out for the ending, jump to PRG062_C83C

	; Not for the ending...

	; Set bank 57 @ $8000
	LDA #57
	STA <MMC3_Page8000_Req
	JSR PRG063_SetPRGBanks

	LDA <Player_State
	CMP #PLAYERSTATE_DEAD
	BEQ PRG062_C82F	; If Player is dead, jump to PRG062_C82F

	CMP #PLAYERSTATE_GOTSPWEAPON
	BEQ PRG062_C835	; If Player just got a special item (e.g. Wire Adapter, Balloon), jump to PRG062_C835


PRG062_C822:
	; Game over!

	; Clear midpoint achieved
	LDA #$00
	STA <Player_Midpoint
	
	; Clears a bit of data and Wily Transport completions
	JSR PRG062_GameOverClear

	; Doing game over (in this circumstance)
	JSR PRG057_DoLevelIntermission_Ind

	JMP PRG062_C541	; Jump to PRG062_C541 (restart level)


PRG062_C82F:
	LDA <Player_Lives
	BEQ PRG062_C822	; If Player is out of lives, jump to PRG062_C822

	DEC <Player_Lives	; Otherwise just lose one

PRG062_C835:
	; Player getting special item (e.g. Wire Adapter, Balloon) or dead

	LDA #$00
	STA <DisFlag_NMIAndDisplay
	
	JMP PRG062_C541	; Jump to PRG062_C541 (restart level)


PRG062_C83C:
	; Player just teleported out for the ending!

	; Set bank 27 @ $8000
	LDA #27
	STA <MMC3_Page8000_Req
	JSR PRG063_SetPRGBanks

	; Do Ending and never come back!
	JMP PRG027_DoEnding


PRG062_GameOverClear:
	LDY #$1F
	
	; No Wily transports cleared
	LDA #$00
	STA <LevelWily3_TransSysComp

	; Clear the never-respawn markers
PRG062_C84C:
	STA Spr_NoRespawnBits,Y
	DEY
	BPL PRG062_C84C

	RTS	; $C852


PRG062_PlayerDefaultPal:
	.byte $0F, $0F, $2C, $11, $0F, $0F, $30, $37
	
PRG062_MusForLevel:
	.byte MUS_BRIGHTMAN		; 00: Bright Man
	.byte MUS_TOADMAN		; 01: Toad Man
	.byte MUS_DRILLMAN		; 02: Drill Man
	.byte MUS_PHARAOHMAN	; 03: Pharaoh Man
	.byte MUS_RINGMAN		; 04: Ring Man
	.byte MUS_DUSTMAN		; 05: Dust Man
	.byte MUS_DIVEMAN		; 06: Dive Man
	.byte MUS_SKULLMAN		; 07: Skull Man
	.byte MUS_COSSACK1		; 08: Cossack 1
	.byte MUS_COSSACK1		; 09: Cossack 2
	.byte MUS_COSSACK2		; 0A: Cossack 3
	.byte MUS_COSSACK2		; 0B: Cossack 4
	.byte MUS_WILY1			; 0C: Wily 1
	.byte MUS_WILY1			; 0D: Wily 2
	.byte MUS_WILY2			; 0E: Wily 3
	.byte MUS_WILY2			; 0F: Wily 4

	; Init Spr_Flags bits per level (not greatly used)
PRG062_TMapInitSprFlags:
	.byte $00			; Bright Man
	.byte SPR_BEHINDBG	; Toad Man
	.byte $00			; Drill Man
	.byte $00			; Pharaoh Man
	.byte $00			; Ring Man
	.byte $00			; Dust Man
	.byte $00			; Dive Man
	.byte $00			; Skull Man
	.byte $00			; Cossack 1
	.byte $00			; Cossack 2
	.byte $00			; Cossack 3
	.byte $00			; Cossack 4
	.byte $00			; Wily 1
	.byte $00			; Wily 2
	.byte $00			; Wily 3
	.byte $00			; Wily 4

	; Initial value pushed into Object_ReqBGSwitch
PRG062_InitPlayerBG:
	.byte $00			; Bright Man
	.byte $00			; Toad Man
	.byte $00			; Drill Man
	.byte $B8			; Pharaoh Man
	.byte $00			; Ring Man
	.byte $00			; Dust Man
	.byte $00			; Dive Man
	.byte $00			; Skull Man
	.byte $00			; Cossack 1
	.byte $00			; Cossack 2
	.byte $00			; Cossack 3
	.byte $00			; Cossack 4
	.byte $00			; Wily 1
	.byte $00			; Wily 2
	.byte $00			; Wily 3
	.byte $00			; Wily 4


	; Screen that much be reached for level midpoint 1 and 2
	; Obviously $FF is intended to not enable that to be a valid midpoint setting
	; See also midpoint details below
PRG062_MidPointScrPoints:
	.byte $0B, $19	; TMap 0 - Bright Man
	.byte $13, $1A	; TMap 1 - Toad Man
	.byte $0B, $15	; TMap 2 - Drill Man
	.byte $12, $1F	; TMap 3 - Pharaoh Man
	.byte $0C, $17	; TMap 4 - Ring Man
	.byte $0B, $16	; TMap 5 - Dust Man
	.byte $0E, $17	; TMap 6 - Dive Man
	.byte $10, $19	; TMap 7 - Skull Man
	.byte $07, $FF	; TMap 8 - Cossack 1
	.byte $09, $FF	; TMap 9 - Cossack 2
	.byte $08, $FF	; TMap A - Cossack 3
	.byte $10, $FF	; TMap B - Cossack 4
	.byte $08, $FF	; TMap C - Wily 1
	.byte $0A, $FF	; TMap D - Wily 2
	.byte $09, $FF	; TMap E - Wily 3
	.byte $FF, $FF	; TMap F - Wily 4

	
	; PRG062_LevelMidStartInitData: Initialization values for mid-point (Player_Midpoint = 1) or boss gate (Player_Midpoint = 2) start points
	;
	; Offset 0: Assigned to the following [NOTE: Sync PRG062_MidPointScrPoints!!]
	;	- MetaBlk_CurScreen
	;	- Current_Screen
	;	- Spr_XHi+$00 [i.e. Player's X Hi]
	;	- Temp_Var45
	;
	; Offset 1: Temp_Var46
	;	- Indexes Level_SegmentDefs (so "start segment")
	;
	; Offset 2: Temp_Var47
	;	- Queues graphics / palette to load (call to PRG062_Upl_SprPal_CHRPats)
	;
	; Offset 3: Temp_Var48
	;	- Selects palette from Level_BGPaletteData
PRG062_LevelMidStartInitData:
	; Bright Man
	.byte $0B, $04, $42, $01	; Midpoint
	.byte $19, $07, $00, $02	; Boss Gate

	; Toad Man
	.byte $13, $07, $54, $01	; Midpoint
	.byte $1A, $0B, $00, $02	; Boss Gate

	; Drill Man
	.byte $0B, $06, $43, $00	; Midpoint
	.byte $15, $08, $00, $00	; Boss Gate
	
	; Pharaoh Man
	.byte $12, $05, $44, $03	; Midpoint
	.byte $1F, $08, $00, $02	; Boss Gate
	
	; Ring Man
	.byte $0C, $08, $45, $04	; Midpoint
	.byte $17, $0B, $49, $06	; Boss Gate

	; Dust Man
	.byte $0B, $02, $46, $02	; Midpoint
	.byte $16, $07, $00, $01	; Boss Gate

	; Dive Man
	.byte $0E, $06, $47, $00	; Midpoint
	.byte $17, $0A, $00, $03	; Boss Gate

	; Skull Man
	.byte $10, $06, $48, $00	; Midpoint
	.byte $19, $08, $00, $02	; Boss Gate

	; Cossack 1
	.byte $07, $02, $4E, $00	; Midpoint
	.byte $00, $00, $00, $00	; Boss Gate (unused)
	
	; Cossack 2
	.byte $09, $03, $4F, $00	; Midpoint
	.byte $00, $00, $00, $00	; Boss Gate (unused)
	
	; Cossack 3
	.byte $08, $02, $50, $00	; Midpoint
	.byte $00, $00, $00, $00	; Boss Gate (unused)

	; Cossack 4
	.byte $10, $08, $51, $00	; Midpoint
	.byte $00, $00, $00, $00	; Boss Gate (unused)
	
	; Wily 1
	.byte $08, $02, $52, $00	; Midpoint
	.byte $00, $00, $00, $00	; Boss Gate (unused)

	; Wily 2
	.byte $0A, $05, $53, $00	; Midpoint
	.byte $00, $00, $00, $00	; Boss Gate (unused)

	; Wily 3
	.byte $09, $09, $00, $06	; Midpoint
	.byte $00, $00, $00, $00	; Boss Gate (unused)
	
	; Wily 4
	.byte $00, $00, $00, $00	; Midpoint (unused)
	.byte $00, $00, $00, $00	; Boss Gate (unused)
	
	; If you die and return to Wily Transport System and the Wily transporter needs
	; to appear, this is run...
PRG062_WilyTransporterGBuf:
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


	; "Segment" = A group of 1 or more "screens"
	; As screen scrolls, updates segment data (change to new segment, total screens in
	; segment, etc.), performs dynamic stuff when changing seg (loads new gfx, palettes, etc.)
PRG062_ScrollUpdSegmentData:
	LDA <Level_SegCurData
	AND #(SEGDIR_DOWN | SEGDIR_UP)
	BNE PRG062_C9E6	; If vertical movement allowed?, jump to PRG062_C9E6 (to PRG062_CC13)

	; Vertical mirroring mode
	LDA #$01
	STA MMC3_MIRROR
	
	LDA Spr_X+$00
	SUB <Horz_Scroll
	STA <Temp_Var16		; Difference between Player's X and horizontal scroll -> Temp_Var16
	
	LDA <TileMap_Index
	CMP #TMAP_COSSACK3
	BNE PRG062_C9D3	; If this isn't Cossack 3 (the only one with auto-scrolling), jump to PRG062_C9D3

	; Cossack 3 only, enable auto-scroll

	LDA <Level_SegCurrentRelScreen
	BNE PRG062_C98F	; If not on first screen (auto-scroll remains active), jump to PRG062_C98F

	LDA <Horz_Scroll
	BEQ PRG062_C9D3	; If Player hasn't moved over (to start auto-scrolling), jump to PRG062_C9D3


PRG062_C98F:
	; Auto-scroll active...

	LDA <General_Counter
	AND #$01
	BEQ PRG062_C9E6	; Every other tick, jump to PRG062_C9E6 (to PRG062_CC13)

	STA <Temp_Var17	; Temp_Var17 = 1
	
	LDA <Temp_Var16	; $C997
	SUB #$F0	; $C999
	BCC PRG062_C9B6	; $C99C
	BEQ PRG062_C9B6

	STA <Temp_Var0
	
	LDA Spr_X+$00
	SUB <Temp_Var0
	STA Spr_X+$00
	LDA Spr_XHi+$00
	SBC #$00
	STA Spr_XHi+$00
	
	JMP PRG062_CA3E	; Jump to PRG062_CA3E
	

PRG062_C9B6:
	LDA #$10	; $C9B6
	SUB <Temp_Var16	; $C9B8
	BCC PRG062_C9D0	; $C9BB

	; CHECKME - UNUSED?
	STA <Temp_Var0
	LDA Spr_X+$00
	ADD <Temp_Var0
	STA Spr_X+$00
	LDA Spr_XHi+$00
	ADC #$00
	STA Spr_XHi+$00

PRG062_C9D0:
	JMP PRG062_CA3E	; Jump to PRG062_CA3E
	

PRG062_C9D3:
	; Not Cossack 3 or auto-scroll not started...


	; Standard scrolling and update logic... not really going to bother
	; commenting this all since I'm not really interested in it, but 
	; here it is ... looks more or less straightforward ...
	LDA Spr_X+$00
	SUB <RAM_0027
	STA <Temp_Var17
	LDA Spr_XHi+$00
	SBC <RAM_0028
	ORA <Temp_Var17
	
	BCC PRG062_C9E9
	BNE PRG062_CA2E


PRG062_C9E6:
	JMP PRG062_CC13	; Jump to PRG062_CC13


PRG062_C9E9:
	LDA <Temp_Var16
	CMP #$81
	BGE PRG062_C9E6

	LDA <Temp_Var17
	EOR #$FF
	ADC #$01
	CMP #$08
	BLT PRG062_C9FB

	LDA #$08

PRG062_C9FB:
	STA <Temp_Var17
	
	LDA <Horz_Scroll
	SUB <Temp_Var17
	STA <Horz_Scroll
	
	PHP
	
	LDA <Current_Screen
	STA <Temp_Var17
	SBC #$00
	STA <Current_Screen
	
	PLP
	
	LDA <Level_SegCurrentRelScreen
	SBC #$00
	STA <Level_SegCurrentRelScreen
	BCS PRG062_CA2A

	LDA #$00
	STA <Horz_Scroll
	STA <Level_SegCurrentRelScreen
	
	LDA <Temp_Var17
	STA <Current_Screen
	
	LDA #$10
	CMP Spr_X+$00
	BLT PRG062_CA2A

	STA Spr_X+$00

PRG062_CA2A:
	
	LDA #$02
	BNE PRG062_CA79	; Jump (technically always) to PRG062_CA79


PRG062_CA2E:
	BEQ PRG062_CA76

	LDA <Temp_Var16
	CMP #$80
	BLT PRG062_CA76

	LDA #$08
	CMP <Temp_Var17
	BGE PRG062_CA3E

	STA <Temp_Var17

PRG062_CA3E:
	LDA <Horz_Scroll
	ADD <Temp_Var17
	STA <Horz_Scroll
	
	PHP
	
	LDA <Current_Screen
	ADC #$00
	STA <Current_Screen
	
	PLP
	
	LDA <Level_SegCurrentRelScreen
	ADC #$00
	STA <Level_SegCurrentRelScreen
	CMP <Level_SegTotalRelScreen
	BNE PRG062_CA72

	LDA <Player_HitWallR_Flag
	CMP #$50
	BEQ PRG062_CA6B

	LDA #$00
	STA <Horz_Scroll
	
	LDA #$F0
	CMP Spr_X+$00
	BGE PRG062_CA72

	STA Spr_X+$00

PRG062_CA6B:
	LDA #$00
	STA <Horz_Scroll
	
	JMP PRG062_CAFF	; Jump to PRG062_CAFF


PRG062_CA72:
	LDA #$01
	BNE PRG062_CA79	; Jump (technically always) to PRG062_CA79


PRG062_CA76:
	JMP PRG062_CC13	; Jump to PRG062_CC13


PRG062_CA79:
	STA <Temp_Var16
	STA <Level_LastScrollDir
	
	LDA <Horz_Scroll
	SUB <RAM_0025
	BPL PRG062_CA89

	EOR #$FF
	ADD #$01

PRG062_CA89:
	STA <Temp_Var17
	
	BEQ PRG062_CA76

	LDA <Temp_Var16
	AND #$01
	BEQ PRG062_CA98

	LDA <RAM_0025
	JMP PRG062_CA9C	; Jump to PRG062_CA9C


PRG062_CA98:
	LDA <RAM_0025
	EOR #$FF

PRG062_CA9C:
	AND #$07
	ADD <Temp_Var17
	
	LSR A
	LSR A
	LSR A
	BEQ PRG062_CACC

	LDA <Temp_Var16
	CMP <RAM_0023
	STA <RAM_0023
	
	PHP
	
	AND #$01
	TAY
	
	PLP
	
	BNE PRG062_CAC1

	LDA <ScreenUpd_CurCol
	ADD PRG062_CBFD,Y
	CMP #$20
	AND #$1F
	STA <ScreenUpd_CurCol
	
	BCC PRG062_CAC9


PRG062_CAC1:
	LDA <MetaBlk_CurScreen
	ADD PRG062_CBFD,Y
	STA <MetaBlk_CurScreen

PRG062_CAC9:
	JSR PRG062_SetMBA_DrawColumn


PRG062_CACC:
	JMP PRG062_CC13	; Jump to PRG062_CC13


PRG062_CACF:
	LDX #$00	; $CACF

PRG062_CAD1:
	LDA Level_ScreenAltPathLinks+$00,X
	BMI PRG062_CACC	; If terminator, jump to PRG062_CACC (to PRG062_CC13)

	CMP <Current_Screen
	BEQ PRG062_CAE0	; If this matches the current screen, jump to PRG062_CAE0

	; Didn't match the current screen...

	; X += 4
	INX
	INX
	INX
	INX
	
	BNE PRG062_CAD1	; Loop!


PRG062_CAE0:
	; Screen matched...

	LDA Level_ScreenAltPathLinks+$01,X
	AND #$20
	BEQ PRG062_CACC	; If bit $20 not set, jump to PRG062_CACC (to PRG062_CC13)

	; Bit $20 set...

	LDY Level_ScreenAltPathLinks+$03,X
	STY <MetaBlk_CurScreen	; Destination screen of linkage -> Y / MetaBlk_CurScreen
	
	; Set spawn hint values for the screen
	LDA Level_LayoutObjHintByScr,Y
	STA <RAM_009E
	STA <RAM_009F
	
	DEY	; $CAF3
	STY <Current_Screen	; Set new current screen
	STY Spr_XHi+$00	; Move player's horizontal position to linked screen
	
	LDY Level_ScreenAltPathLinks+$02,X	; $CAF9
	JMP PRG062_CB1B	; $CAFC


PRG062_CAFF:
	LDA <Level_SegCurData
	AND #$0F
	TAY	; Y = current segment index
	
	LDA <Player_State
	CMP #PLAYERSTATE_RUSHMARINE
	BNE PRG062_CB11		; If Player is not in Rush Marine, jump to PRG062_CB11

	; Player in Rush Marine...

	LDA Level_SegmentDefs+$01,Y
	AND #SEGDIR_BOSSGATE
	BNE PRG062_CACC		; If NEXT segment is behind the Boss Gate, jump to PRG062_CACC (to PRG062_CC13)

PRG062_CB11:
	LDA Level_SegmentDefs+$01,Y
		
	AND #(SEGDIR_DOWN | SEGDIR_UP | SEGDIR_HORIZONTAL)
	CMP #SEGDIR_HORIZONTAL
	BNE PRG062_CACF	; If NEXT segment isn't specifically horizontal without permissions to vertically change, jump to PRG062_CACF

	; NEXT segment is horizontal WITHOUT any DOWN/UP permissions...

	INY	; Y++ (next segment index)

PRG062_CB1B:
	STY <Temp_Var0	; -> Temp_Var0
	
	LDA Level_SegmentDefs,Y
	AND #(SEGDIR_HORIZONTAL | SEGDIR_BOSSGATE)		; Keeping only these potential segment bits
	ORA <Temp_Var0			; OR in the segment index
	STA <Level_SegCurData	; -> Level_SegCurData
	
	LDA Level_SegmentDefs,Y
	AND #$0F						; Number of screens
	STA <Level_SegTotalRelScreen	; -> Level_SegTotalRelScreen
	
	; Level_SegCurrentRelScreen = 0
	LDA #$00
	STA <Level_SegCurrentRelScreen
	
	; Right scroll
	LDA #$01
	STA <RAM_0023
	STA <Level_LastScrollDir	; Level_LastScrollDir = 1
	
	LDA <Level_SegCurData
	AND #$0F
	TAY	; Y = index to Level_SegmentDefs
	
	LDA Level_SegmentDefs,Y	
	AND #SEGDIR_BOSSGATE
	BEQ PRG062_CB68	; If this is not the boss gate transit, jump to PRG062_CB68
	
	; Boss gate junction...

	LDA Level_LightDarkCtl
	AND #$7F
	BEQ PRG062_CB59	; Either bright ($00) or brightening up ($80), jump to PRG062_CB59

	; Level_LightDarkTransCnt = $00
	LDA #$00
	STA Level_LightDarkTransCnt
	
	; Level_LightDarkTransLevel = $30
	LDA #$30
	STA Level_LightDarkTransLevel
	
	; Level_LightDarkCtl = $80
	LDA #$80
	STA Level_LightDarkCtl


PRG062_CB59:
	; Player absolutely cannot be in background behind gate
	LDA Spr_Flags+$00
	AND #~SPR_BEHINDBG
	STA Spr_Flags+$00
	
	; NO BACKGROUND
	LDA #$00
	STA <Object_ReqBGSwitch
	
	; Perform boss gate opening sequence
	JSR PRG063_DoBossGateOpen


PRG062_CB68:
	; Boss gate or not, we continue...

	JSR PRG062_LoadPalAndGfxForSeg	; Load palette and graphics for new segment!

	JSR PRG062_ClearSpriteSlots	; Clear all sprites/objects!


PRG062_CB6E:
	; Panning to the right
	LDA <Horz_Scroll
	ADD #$02
	STA <Horz_Scroll
	LDA <Current_Screen
	ADC #$00
	STA <Current_Screen
	
	; Moving Player along...
	LDA Spr_XVelFracAccum+$00
	ADD #$80
	STA Spr_XVelFracAccum+$00	
	LDA Spr_X+$00
	ADC #$00
	STA Spr_X+$00
	LDA Spr_XHi+$00
	ADC #$00
	STA Spr_XHi+$00
	
	LDA <Horz_Scroll	; $CB94
	SUB <RAM_0025	; $CB96
	STA <Temp_Var17	; $CB99
	
	BEQ PRG062_CBB8	; $CB9B

	LDA <RAM_0025	; $CB9D
	AND #$07	; $CB9F
	ADD <Temp_Var17	; $CBA1
	LSR A	; $CBA4
	LSR A	; $CBA5
	LSR A	; $CBA6
	BEQ PRG062_CBB8	; $CBA7

	INC <ScreenUpd_CurCol	; $CBA9
	LDA <ScreenUpd_CurCol	; $CBAB
	AND #$1F	; $CBAD
	STA <ScreenUpd_CurCol	; $CBAF
	BNE PRG062_CBB5	; $CBB1

	INC <MetaBlk_CurScreen	; $CBB3

PRG062_CBB5:
	JSR PRG062_SetMBA_DrawColumn	; $CBB5



PRG062_CBB8:
	JSR PRG062_CHRRAMDynLoadCHRSeg	; $CBB8

	LDA <Horz_Scroll	; $CBBB
	STA <RAM_0025	; $CBBD
	
	; Clear sprites/objects
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites

	; Protecting page $A000 when calling PRG062_DoDrawSprites
	LDA <MMC3_PageA000_Req
	PHA
	JSR PRG062_DoDrawSprites
	PLA
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

	; Restore Player object's slot ID
	LDA #SPRSLOTID_PLAYER
	STA Spr_SlotID+$00

	LDA #$00	; $CBD7
	STA <DisFlag_NMIAndDisplay	; $CBD9
	JSR PRG063_UpdateOneFrame	; $CBDB

	INC <DisFlag_NMIAndDisplay	; $CBDE
	
	LDA <Horz_Scroll
	BNE PRG062_CB6E		; Loop if screen scroll not complete for transition

	LDA <Level_SegCurData
	AND #$0F
	TAY		; Y = segment index
	
	LDA Level_SegmentDefs,Y
	AND #SEGDIR_BOSSGATE
	BEQ PRG062_CBFC	; If this is not a boss gate transition, jump to PRG062_CBFC (RTS)

	LDY <TileMap_Index	; Y = TileMap_Index
	
	LDA PRG062_CloseBossGateBypassScr,Y
	CMP <Current_Screen	
	BEQ PRG062_CBFC	; If this screen matches, don't close boss gate (??)

	JSR PRG063_DoBossGateClose	; Close boss gate

PRG062_CBFC:
	RTS	; $CBFC


PRG062_CBFD:
	.byte $FF, $01

PRG062_CurUpdRowForVScroll:
	.byte $1D, $00

PRG062_CC01:
	; $CBFF - $CC01
	.byte $01, $00
	
PRG062_CloseBossGateBypassScr:
	.byte $00	; TMAP_BRIGHTMAN
	.byte $00	; TMAP_TOADMAN
	.byte $00	; TMAP_DRILLMAN
	.byte $00	; TMAP_PHARAOHMAN
	.byte $00	; TMAP_RINGMAN
	.byte $00	; TMAP_DUSTMAN
	.byte $00	; TMAP_DIVEMAN
	.byte $00	; TMAP_SKULLMAN
	.byte $12	; TMAP_COSSACK1
	.byte $10	; TMAP_COSSACK2
	.byte $00	; TMAP_COSSACK3
	.byte $13	; TMAP_COSSACK4
	.byte $14	; TMAP_WILY1
	.byte $15	; TMAP_WILY2
	.byte $00	; TMAP_WILY3
	.byte $06	; TMAP_WILY4


PRG062_CC13:
	LDA <Horz_Scroll
	BNE PRG062_CC28		; If scroll isn't aligned precisely to a screen edge, jump to PRG062_CC28 (don't limit Player unless screen stopped scrolling)

	LDA #$10
	CMP Spr_X+$00
	BGE PRG062_CC25	; If Player is too far left (left edge), jump to PRG062_CC25

	LDA #$F0
	CMP Spr_X+$00
	BGE PRG062_CC28	; If Player is NOT too right (right edge), jump to PRG062_CC28


PRG062_CC25:
	; Player is too far left/right; lock them at limit
	STA Spr_X+$00

PRG062_CC28:
	LDA Spr_YHi+$00
	BNE PRG062_CBFC	; If vertically off-screen, jump to PRG062_CBFC (RTS)

	; Temp_Var1 = SPRDIR_DOWN
	LDA #SPRDIR_DOWN
	STA <Temp_Var1
	
	LDA Spr_Y+$00
	CMP #$E8
	BGE PRG062_CC46	; If Player Y >= $E8 (Player really low on screen), jump to PRG062_CC46

	CMP #$08
	BGE PRG062_CBFC	; If Player Y >= $08 (Player NOT really high on screen), jump to PRG062_CBFC (RTS)

	; Player < $08... (player really high on screen)

	LDA <Player_State
	CMP #PLAYERSTATE_CLIMBING
	BNE PRG062_CBFC	; If Player is not climbing, jump to PRG062_CBFC (RTS)

	; Temp_Var1 = SPRDIR_UP
	LDA #SPRDIR_UP
	STA <Temp_Var1

PRG062_CC46:
	LDA <Level_SegCurData
	AND #((SPRDIR_DOWN | SPRDIR_UP) << 4)
	BNE PRG062_CC4F	; If current segment allows for DOWN/UP movement, jump to PRG062_CC4F

	; Segment not for DOWN/UP movement...
	JMP PRG062_CD24	; Jump to PRG062_CD24


PRG062_CC4F:
	; Current segment allows for DOWN/UP movement...

	LDA <Temp_Var1	; Get intended transit direction
	AND #(SPRDIR_DOWN | SPRDIR_UP)
	BEQ PRG062_CCCF	; If transit direction is not DOWN/UP, jump to PRG062_CCCF (RTS)

	STA <Temp_Var0	; = SPRDIR_DOWN / SPRDIR_UP
	ASL A
	ASL A
	ASL A
	ASL A	; Shift up by 4 (check allowed direction bits in current segment data)
	AND <Level_SegCurData
	BEQ PRG062_CC99	; If the intended transit direction is not allowed, jump to PRG062_CC99
	
	; Transit is allowed...

	LDA <Level_SegCurrentRelScreen
	CMP <Level_SegTotalRelScreen
	BEQ PRG062_CC79	; If currently on the last screen of this segment, jump to PRG062_CC79

	; NOT on the last screen of this segment...

	INC <Level_SegCurrentRelScreen	; Otherwise, proceed to next screen

PRG062_CC67:
	INC <MetaBlk_CurScreen
	INC <Current_Screen
	INC Spr_XHi+$00
	
	; Intended transit direction (DOWN/UP only)
	LDA <Temp_Var0
	STA <RAM_0023	; -> RAM_0023
	
	LDA #$01
	STA <Level_LastScrollDir
	
	JMP PRG062_CDD5	; Jump to PRG062_CDD5



PRG062_CC79:
	; On the last screen of segment...

	INC <Level_SegCurData	; Next segment
	
	; Clear the transit permission bits
	LDA <Level_SegCurData
	AND #$0F
	STA <Level_SegCurData
	TAY	; segment index -> 'Y' (next segment [that we've just entered] index)
	
	; Get the allowed-transit bits of the next segment, store into Level_SegCurData
	LDA Level_SegmentDefs,Y
	AND #$F0
	ORA <Level_SegCurData
	STA <Level_SegCurData
	
	; Level_SegCurrentRelScreen = 0 (reset relative screen counter)
	LDA #$00
	STA <Level_SegCurrentRelScreen
	
	; Lower nibble specifies total screens of this segment
	LDA Level_SegmentDefs,Y
	AND #$0F
	STA <Level_SegTotalRelScreen
	
	JMP PRG062_CC67	; Jump to PRG062_CC67


PRG062_CC99:
	; The DOWN/UP transit was not allowed...

	LDA <Level_SegCurrentRelScreen
	BEQ PRG062_CCB1	; If already at leftmost screen of this segment, jump to PRG062_CCB1

	; Not at the first screen of segment...

	DEC <Level_SegCurrentRelScreen	; Previous relative screen of this segment

PRG062_CC9F:
	DEC <MetaBlk_CurScreen
	DEC <Current_Screen
	DEC Spr_XHi+$00
	
	; Intended transit direction (DOWN/UP only)
	LDA <Temp_Var0
	STA <RAM_0023	; -> RAM_0023
	
	LDA #$02
	STA <Level_LastScrollDir
	
	JMP PRG062_CDD5	; Jump to PRG062_CDD5


PRG062_CCB1:
	; On first screen of segment...

	DEC <Level_SegCurData	; Previous segment
	
	; Clear the transit permission bits
	LDA <Level_SegCurData
	AND #$0F
	STA <Level_SegCurData
	TAY	; segment index -> 'Y' (previous segment [that we've just entered] index)
	
	; Get the allowed-transit bits of the previous segment, store into Level_SegCurData
	LDA Level_SegmentDefs,Y
	AND #$F0
	ORA <Level_SegCurData
	STA <Level_SegCurData
	
	; Lower nibble specifies total screens of this segment
	LDA Level_SegmentDefs,Y
	AND #$0F
	STA <Level_SegCurrentRelScreen	; We're already on the last screen of the segment since we've entered into it!
	STA <Level_SegTotalRelScreen
	
	JMP PRG062_CC9F	; Jump to PRG062_CC9F


PRG062_CCCF:
	RTS	; $CCCF


PRG062_CCD0:
	LDY #$00	; Y = 0

PRG062_CCD2:
	LDA Level_ScreenAltPathLinks,Y
	BMI PRG062_CCCF	; If terminator, jump to PRG062_CCCF (RTS)

	CMP <Current_Screen
	BEQ PRG062_CCE1	; If this matches the current screen, jump to PRG062_CCE1

	INY
	INY
	INY
	INY	; Y += 4
	BNE PRG062_CCD2	; Loop!


PRG062_CCE1:
	LDA <Temp_Var1	; $CCE1
	ASL A	; $CCE3
	ASL A	; $CCE4
	ASL A	; $CCE5
	ASL A	; $CCE6
	AND Level_ScreenAltPathLinks+$01,Y	; $CCE7
	BEQ PRG062_CCCF	; $CCEA

	LDX Level_ScreenAltPathLinks+$02,Y	; Index into Level_SegmentDefs
	
	LDA Level_SegmentDefs,X
	PHA
	AND #$F0
	ORA Level_ScreenAltPathLinks+$02,Y
	STA <Level_SegCurData	; "Settings" high nibble of Level_SegmentDefs combined with index -> Level_SegCurData
	
	; Store total screens in segment
	PLA
	AND #$0F	; total screens in segment
	STA <Level_SegTotalRelScreen
	
	; Level_SegCurrentRelScreen = 0
	LDA #$00
	STA <Level_SegCurrentRelScreen
	
	; Store destination screen of link..
	LDX Level_ScreenAltPathLinks+$03,Y
	STX <MetaBlk_CurScreen
	STX <Current_Screen
	STX Spr_XHi+$00
	
	; Set spawn hint values for the screen
	LDA Level_LayoutObjHintByScr,X
	STA <RAM_009E
	STA <RAM_009F
	
	; Level_LastScrollDir = 1
	LDA #$01
	STA <Level_LastScrollDir
	
	LDA <Temp_Var1	; $CD18
	STA <RAM_0023	; $CD1A
	
	; Horizontal mirroring mode
	LDA #$00
	STA MMC3_MIRROR
	
	JMP PRG062_CDD5	; Jump to PRG062_CDD5


PRG062_CD24:
	LDA <Horz_Scroll
	BNE PRG062_CCCF	; If scroll is not at zero, jump to PRG062_CCCF (RTS)

	LDA <Level_SegCurData
	AND #$0F
	TAY	; Y = current segment index
	
	LDA <Level_SegTotalRelScreen
	BNE PRG062_CD3E	; If not one screen, jump to PRG062_CD3E

	; One screen segment...

	LDA Level_SegmentDefs+$01,Y	; NOTE: **NEXT** segment!!
	LSR A
	LSR A
	LSR A
	LSR A
	AND <Temp_Var1	; Temp_Var1 was set previously to request either the DOWN/UP transit (i.e. is SPRDIR_UP / SPRDIR_DOWN)
	BNE PRG062_CD46	; If movement direction is permitted on **NEXT** segment, jump to PRG062_CD46

	; Movement direction prohibited on NEXT segment...

	BEQ PRG062_CD65	; Jump to PRG062_CD65


PRG062_CD3E:
	; Multiple-screen segment (usual)

	LDA <Level_SegCurrentRelScreen
	BEQ PRG062_CD65	; If on first screen of segment, jump to PRG062_CD65

	CMP <Level_SegTotalRelScreen
	BNE PRG062_CCCF	; If NOT on last screen of segment, jump to PRG062_CCCF (RTS)


PRG062_CD46:
	; Single-screen segment or last screen of segment

	INY	; Y++ (NEXT segment index)
	
	LDA Level_SegmentDefs,Y
	AND #((SPRDIR_DOWN | SPRDIR_UP) << 4)
	BEQ PRG062_CCD0	; If next segment doesn't permit DOWN/UP movement, jump to PRG062_CCD0

	STA <Temp_Var16	; Store DOWN/UP permission bits
	
	; Temp_Var17 = 0 (starting on screen 0 next segment)
	LDA #$00
	STA <Temp_Var17
	
	; Temp_Var18 = Number of screens in next segment
	LDA Level_SegmentDefs,Y
	AND #$0F
	STA <Temp_Var18
	
	; Temp_Var19 = 1
	LDA #$01
	STA <Temp_Var19
	
	; Temp_Var2 = 1
	LDA #$01
	STA <Temp_Var2
	
	BNE PRG062_CD92	; Jump (technically always) to PRG062_CD92


PRG062_CD65:
	; Direction wasn't permissed going to NEXT segment...
	; OR this is the first screen of segment...

	LDA Level_SegmentDefs,Y		; Fetch current segment definition
	
	DEY	; Y-- (previous segment)
	BMI PRG062_CDD4	; If there is no previous segment, jump to PRG062_CDD4

	AND #((SPRDIR_DOWN | SPRDIR_UP) << 4)
	BNE PRG062_CD76	; If this segment permits DOWN/UP movements, jump to PRG062_CD76

	; This segment does not allow DOWN/UP transit...

	LDA Level_SegmentDefs,Y
	AND #$20
	BNE PRG062_CDA2	; If a horizontal segment, jump to PRG062_CDA2 (to PRG062_CCD0)


PRG062_CD76:
	; This segment allows DOWN/UP transit...

	LDA Level_SegmentDefs,Y	; 'Y' is now the PREVIOUS segment's index...
	AND #((SPRDIR_DOWN | SPRDIR_UP) << 4)
	BEQ PRG062_CDA2	; If PREVIOUS segment doesn't allow DOWN/UP, jump to PRG062_CDA2

	EOR #((SPRDIR_DOWN | SPRDIR_UP) << 4)	; Invert the DOWN/UP 
	STA <Temp_Var16	; -> Temp_Var16
	
	LDA Level_SegmentDefs,Y
	AND #$0F		; Number of screens in next segment
	STA <Temp_Var17	; -> Temp_Var17 (starting on final screen next segment)
	STA <Temp_Var18	; -> Temp_Var18
	
	; Temp_Var19 = $FF
	LDA #$FF
	STA <Temp_Var19
	
	; Temp_Var2 = $02
	LDA #$02
	STA <Temp_Var2

PRG062_CD92:
	; Common merge point whether transiting from first or last screen of segment, or one-screen segment...

	LDA <Temp_Var1	; Intended transit direction
	AND #(SPRDIR_DOWN | SPRDIR_UP)
	BEQ PRG062_CDD4	; If intended transit direction is not DOWN/UP, jump to PRG062_CDD4 (RTS) (NOTE: I don't think this ever happens?)

	STA <Temp_Var0	; -> Temp_Var0
	
	ASL A
	ASL A
	ASL A
	ASL A	; Shift up to segment permission bit position
	AND <Temp_Var16	; Transit bits of segment we're moving into (previous/next, depending on direction)
	BNE PRG062_CDA5	; If transit is permitted, jump to PRG062_CDA5


PRG062_CDA2:
	JMP PRG062_CCD0	; Jump to PRG062_CCD0


PRG062_CDA5:
	STY <Temp_Var16	; Index to segment we're moving into -> Temp_Var16
	
	LDA Level_SegmentDefs,Y
	AND #$F0
	ORA <Temp_Var16	; Merge segment permission bits 
	STA <Level_SegCurData	; -> Level_SegCurData

	; Set appropriate current screen
	LDA <Temp_Var17
	STA <Level_SegCurrentRelScreen
	
	; Set total screens for segment being entered
	LDA <Temp_Var18
	STA <Level_SegTotalRelScreen
	
	; Setup screen tracking and player's XHi
	LDA <Current_Screen
	ADD <Temp_Var19
	STA <Current_Screen
	STA <MetaBlk_CurScreen
	STA Spr_XHi+$00
	
	LDA <Temp_Var0	; DOWN/UP bit
	STA <RAM_0023	; -> RAM_0023
	
	; Set approriate Level_LastScrollDir
	LDA <Temp_Var2
	STA <Level_LastScrollDir
	
	; Horizontal mirroring mode
	LDA #$00
	STA MMC3_MIRROR
	
	JMP PRG062_CDD5	; Jump to PRG062_CDD5

	; CHECKME - UNUSED?

PRG062_CDD4:
	RTS


PRG062_CDD5:
	LDA <RAM_0023
	AND #SPRDIR_DOWN
	LSR A
	LSR A
	STA <Temp_Var17	; Temp_Var17 = 1 if DOWN, 2 if UP
	
	TAX	; X = 1 if DOWN, 2 if UP
	
	; Set current update column as appropriate for movement direction
	LDA PRG062_CurUpdRowForVScroll,X
	STA <ScreenUpd_CurCol
	
	JSR PRG062_LoadPalAndGfxForSeg	; Load graphics and palette for the new segment

	JSR PRG062_ClearSpriteSlots	; Clear all sprites

	; Level_RasterYOff = 0
	LDA #$00
	STA Level_RasterYOff

PRG062_CDEE:
	LDA <RAM_0023
	AND #SPRDIR_DOWN
	BEQ PRG062_CE1E	; If not moving DOWN, jump to PRG062_CE1E
	
	; Screen is transiting DOWN...

	; Vert_Scroll += 2
	LDA <Vert_Scroll
	ADD #$02
	STA <Vert_Scroll
	
	CMP #$F0
	BLT PRG062_CE03	; If Vert_Scroll < $F0, jump to PRG062_CE03

	ADC #$0F
	STA <Vert_Scroll

PRG062_CE03:
	
	; Moving Player a bit more than the screen scroll...
	LDA Spr_YVelFracAccum+$00
	SUB #$C0
	STA Spr_YVelFracAccum+$00
	LDA Spr_Y+$00
	SBC #$01
	STA Spr_Y+$00
	
	BCS PRG062_CE45		; If screen scroll done, jump to PRG062_CE45

	; UNUSED apparently? Keeps Player from moving too far possibly?
	SBC #$0F
	STA Spr_Y+$00
	JMP PRG062_CE45		; Jump to PRG062_CE45

PRG062_CE1E:
	; Screen is transiting UP...

	; Vert_Scroll -= 2
	LDA <Vert_Scroll
	SUB #$02
	STA <Vert_Scroll
	BCS PRG062_CE2B	

	SBC #$0F
	STA <Vert_Scroll

PRG062_CE2B:
	; Moving Player a bit more than the screen scroll...
	LDA Spr_YVelFracAccum+$00
	ADD #$C0
	STA Spr_YVelFracAccum+$00
	LDA Spr_Y+$00
	ADC #$01
	STA Spr_Y+$00
	
	CMP #$F0
	BLT PRG062_CE45		; If screen scroll done, jump to PRG062_CE45

	; UNUSED apparently? Keeps Player from moving too far possibly?
	ADC #$0F
	STA Spr_Y+$00

PRG062_CE45:
	; Segment transition has finished!

	JSR PRG062_CE97	; $CE45

	JSR PRG062_CHRRAMDynLoadCHRSeg	; $CE48

	LDA <Temp_Var17	; Temp_Var17 = 1 if DOWN, 2 if UP
	PHA	; Save it
	
	; Clear out sprites / objects
	LDA #$04
	STA <Sprite_CurrentIndex
	JSR PRG062_ResetSprites

	; Protecting page $A000 when calling PRG062_DoDrawSprites
	LDA <MMC3_PageA000_Req
	PHA
	JSR PRG062_DoDrawSprites
	PLA
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

	; Restore Player object's slot ID
	LDA #SPRSLOTID_PLAYER
	STA Spr_SlotID+$00
	
	; Frame update
	LDA #$00
	STA <DisFlag_NMIAndDisplay
	JSR PRG063_UpdateOneFrame

	; Restoring Temp_Var17
	PLA
	STA <Temp_Var17
	
	INC <DisFlag_NMIAndDisplay	; $CE70
	LDA <Vert_Scroll	; $CE72
	STA <RAM_0026	; $CE74
	BEQ PRG062_CE7B	; $CE76

	JMP PRG062_CDEE	; $CE78


PRG062_CE7B:
	LDA <Level_SegCurData
	AND #$20
	BEQ PRG062_CE96	; If not horizontally scrolling section, jump to PRG062_CE96 (RTS)

	LDA <Level_SegCurData
	AND #%00101111	; Clears DOWN/UP bit and gate? bit
	STA <Level_SegCurData
	
	LDA #$00
	STA <ScreenUpd_CurCol
	
	INC <MetaBlk_CurScreen	; $CE8B
	
	LDA #$01	; $CE8D
	STA <RAM_0023	; $CE8F

	; Vertical mirroring mode
	LDA #$01
	STA MMC3_MIRROR

PRG062_CE96:
	RTS	; $CE96




PRG062_CE97:
	LDA <Vert_Scroll	; $CE97
	SUB <RAM_0026	; $CE99
	BPL PRG062_CEA3	; $CE9C

	EOR #$FF	; $CE9E
	ADD #$01	; $CEA0

PRG062_CEA3:
	AND #$0F	; $CEA3
	STA <Temp_Var16	; $CEA5
	BEQ PRG062_CE96	; $CEA7

	LDA <RAM_0023	; $CEA9
	AND #$04	; $CEAB
	BEQ PRG062_CEB4	; $CEAD

	LDA <RAM_0026	; $CEAF
	JMP PRG062_CEB8	; $CEB1


PRG062_CEB4:
	LDA <RAM_0026	; $CEB4
	EOR #$FF	; $CEB6

PRG062_CEB8:
	AND #$07	; $CEB8
	ADD <Temp_Var16	; $CEBA
	LSR A	; $CEBD
	LSR A	; $CEBE
	LSR A	; $CEBF
	BEQ PRG062_CE96	; $CEC0

	LDX <Temp_Var17	; $CEC2
	LDA <ScreenUpd_CurCol	; $CEC4
	AND #$01	; $CEC6
	CMP PRG062_CC01,X	; $CEC8
	BNE PRG062_CED3	; $CECB

	JSR PRG062_D052	; $CECD

	JMP PRG062_CED6	; $CED0


PRG062_CED3:
	JSR PRG062_D143	; $CED3


PRG062_CED6:
	LDX <Temp_Var17	; $CED6
	LDA <ScreenUpd_CurCol	; $CED8
	ADD PRG062_CBFD,X	; $CEDA
	STA <ScreenUpd_CurCol	; $CEDE
	RTS	; $CEE0


PRG062_LoadPalAndGfxForSeg:
	LDA <Level_SegCurData
	AND #$0F
	TAY	; Y = current segment
	
	; Fetch and backup the sprite palette / dynamic graphics load index
	LDA Level_SegmentDynCHRPalIndex,Y
	PHA
	
	LDA Level_SegmentPalSel,Y
	BEQ PRG062_CF28	; If value is zero, jump to PRG062_CF28

	ASL A	; x2
	ASL A	; x4
	STA <Temp_Var0	; Temp_Var0 = value * 4
	
	ASL A	; x8
	ASL A	; x16
	ADC <Temp_Var0	; Temp_Var0 += value * 16 (So * 20, or an index into Level_BGPaletteData)
	TAY	; Level_BGPaletteData index -> 'Y'
	
	LDX #$00	; X = 0
PRG062_CEFA:
	; Copy in BG color to master palette
	LDA Level_BGPaletteData,Y
	STA PalData_2,X
	
	LDA Level_LightDarkCtl
	BNE PRG062_CF0B	; If currently shrouded in darkness, jump to PRG062_CF0B

	; Copy in BG color to current palette
	LDA Level_BGPaletteData,Y
	STA PalData_1,X

PRG062_CF0B:
	CPX #$04
	BGE PRG062_CF22	; If X >= 4, jump PRG062_CF22

	; X < 3... (copy the 4 palette animation init bytes)

	LDA Level_SegPalAnimInitData,Y
	CMP PalAnim_EnSel+$00,X
	BEQ PRG062_CF22	; If the active palette animation is already what we're trying to copy in, jump to PRG062_CF22

	STA PalAnim_EnSel+$00,X	; Set new palette animation
	
	; Reset data for animation
	LDA #$00
	STA PalAnim_CurAnimOffset+$00,X
	STA PalAnim_TickCount+$00,X

PRG062_CF22:
	INY	; Y++ (next ROM palette byte)
	INX	; X++ (next RAM palette byte)
	CPX #16
	BNE PRG062_CEFA	; While X <> 16, loop


PRG062_CF28:
	LDA PalData_1
	STA PalData_1+16
	STA PalData_2+16
	
	; Commit new palette
	LDA #$FF
	STA <CommitPal_Flag
	
	; Reset a bunch of stuff after moving to new section
	LDA #$00
	STA RingManRainbowPlat_Data+$00
	STA RingManRainbowPlat_Data+$01
	STA RingManRainbowPlat_Data+$02
	STA RingManRainbowPlat_Data+$03
	STA <RAM_003E
	STA <PPU_CTL1_PageBaseReq
	STA <Vert_Scroll
	STA Weapon_FlashStopCnt+$00
	STA Weapon_FlashStopCnt+$01
	STA Weapon_ToadRainCounter
	STA <Boss_HP
	STA Spr_Var5+$00
	
	; Reset any screen modification data
	LDY #$3F
PRG062_CF59:
	STA Level_ScreenTileModData+$00,Y
	DEY
	BPL PRG062_CF59

	; Disable raster effect
	STA <Raster_VMode
	STA <CommitBG_ScrSel	; $CF61
	
	; Raster_VSplit_Req = $88
	LDA #$88
	STA <Raster_VSplit_Req
	
	LDA <TileMap_Index
	CMP #TMAP_COSSACK1
	BEQ PRG062_CF77	; If this is Cossack 1, jump to PRG062_CF77

	CMP #TMAP_PHARAOHMAN
	BNE PRG062_CF7B	; If this is NOT Pharaoh Man, jump to PRG062_CF7B

	; Pharaoh Man...

	LDA <Current_Screen
	CMP #$0C
	BLT PRG062_CF7B	; If not yet on screen $0C, jump to PRG062_CF7B


PRG062_CF77:
	; Cossack 1 / sometimes Pharaoh Man

	LDA #$00	; $CF77
	STA <Object_ReqBGSwitch	; $CF79

PRG062_CF7B:
	LDA <TileMap_Index
	CMP #TMAP_TOADMAN
	BEQ PRG062_CF93	; If this is Toad Man, jump to PRG062_CF93

	CMP #TMAP_PHARAOHMAN
	BNE PRG062_CF9D	; If this is NOT Pharaoh Man, jump to PRG062_CF9D

	; Pharaoh Man and Toad Man only...

	LDA <Level_SegCurData
	AND #$0F
	CMP #$03
	BNE PRG062_CF9D	; If this is not segment $03 of Pharaoh Man, jump to PRG062_CF9D

	LDA #$00
	STA <Object_ReqBGSwitch
	
	BEQ PRG062_CF9D	; Jump (technically always) to PRG062_CF9D


PRG062_CF93:
	; Toad Man only...

	LDA <Level_SegCurData
	AND #$0F
	TAY	; Y = current segment index
	
	LDA PRG062_CFA1,Y
	STA <Object_ReqBGSwitch

PRG062_CF9D:
	
	; Restore the sprite palette / dynamic graphics load index and do it!
	PLA
	JMP PRG062_CHRRAMDynLoadPalSeg	; Dynamically load graphics for this segment!


	; Per Level segment in Toad Man only -> Object_ReqBGSwitch
PRG062_CFA1:
	.byte $00	; 0
	.byte $01	; 1
	.byte $01	; 2
	.byte $01	; 3
	.byte $00	; 4
	.byte $00	; 5
	.byte $00	; 6
	.byte $01	; 7
	.byte $01	; 8
	.byte $00	; 9
	.byte $00	; 10
	.byte $00	; 11
	.byte $00	; 12
	.byte $00	; 13
	.byte $00	; 14
	.byte $00	; 15


	; Sets Meta Block address (important elsewhere) and draws a column to the screen
PRG062_SetMBA_DrawColumn:
	; Set metablock pointer to current "screen"
	LDY <MetaBlk_CurScreen
	JSR PRG062_SetMetaBlkAddr

	LDA #$20	; $CFB6
	STA Graphics_Buffer+$00	; $CFB8
	
	LDA <ScreenUpd_CurCol	; $CFBB
	STA Graphics_Buffer+$01	; $CFBD
	
	LSR A	; $CFC0
	LSR A	; $CFC1
	STA <MetaBlk_Index	; $CFC2
	
	LDA #$1D	; $CFC4
	STA Graphics_Buffer+$02	; $CFC6
	
	LDA #$00	; $CFC9
	STA <Temp_Var3	; $CFCB
	STA <Temp_Var4	; $CFCD
	
	LDA <ScreenUpd_CurCol	; $CFCF
	AND #$03	; $CFD1
	STA <Temp_Var5	; $CFD3

PRG062_CFD5:
	JSR PRG062_FillPatternBuffer	; $CFD5

	LDX <Temp_Var3	; $CFD8
	LDY <Temp_Var5	; $CFDA
	
	LDA Pattern_Buffer,Y	; $CFDC
	STA Graphics_Buffer+$03,X	; $CFDF
	LDA Pattern_Buffer+4,Y	; $CFE2
	STA Graphics_Buffer+$04,X	; $CFE5
	
	LDA <MetaBlk_Index	; $CFE8
	CMP #$38	; $CFEA
	BGE PRG062_D000	; $CFEC

	LDA Pattern_Buffer+8,Y	; $CFEE
	STA Graphics_Buffer+$05,X	; $CFF1
	LDA Pattern_Buffer+12,Y	; $CFF4
	STA Graphics_Buffer+$06,X	; $CFF7
	
	INX	; $CFFA
	INX	; $CFFB
	INX	; $CFFC
	INX	; $CFFD
	STX <Temp_Var3	; $CFFE

PRG062_D000:
	LDA <Temp_Var5	; $D000
	LSR A	; $D002
	BCC PRG062_D036	; $D003

	TAY	; $D005
	LDX <MetaBlk_Index	; $D006
	
	LDA Pattern_AttrBuffer,X	; $D008
	AND PRG062_D04E,Y	; $D00B
	STA <Temp_Var0	; $D00E
	
	; Palette settings for tiles
	LDA <Temp_Var16	; $D010
	AND PRG062_D050,Y	; $D012
	ORA <Temp_Var0	; $D015
	STA Pattern_AttrBuffer,X	; $D017
	
	LDX <Temp_Var4	; $D01A
	STA Graphics_Buffer+$24,X	; $D01C
	
	; $23C0+ (attribute data)
	LDA #$23
	STA Graphics_Buffer+$21,X
	LDA #$C0
	ORA <MetaBlk_Index
	STA Graphics_Buffer+$22,X
	
	LDA #$00	; $D02B
	STA Graphics_Buffer+$23,X	; $D02D
	
	INX	; $D030
	INX	; $D031
	INX	; $D032
	INX	; $D033
	STX <Temp_Var4	; $D034

PRG062_D036:
	LDA <MetaBlk_Index	; $D036
	ADD #$08	; $D038
	STA <MetaBlk_Index	; $D03B
	
	CMP #$40	; $D03D
	BLT PRG062_CFD5	; $D03F

	LDA #$20	; $D041
	ADC <Temp_Var4	; $D043
	TAY	; $D045
	
	LDA #$FF	; $D046
	STA Graphics_Buffer+$00,Y	; $D048
	STA <CommitGBuf_FlagV	; $D04B
	
	RTS	; $D04D


PRG062_D04E:
	.byte $CC, $33
	
PRG062_D050:
	; $D04E - $D050
	.byte $33, $CC	; $D050 - $D051



PRG062_D052:
	LDY <MetaBlk_CurScreen	; $D052
	JSR PRG062_SetMetaBlkAddr	; $D054

	LDA <ScreenUpd_CurCol	; $D057
	AND #$1C	; $D059
	ASL A	; $D05B
	STA <MetaBlk_Index	; $D05C
	LDA #$00	; $D05E
	STA <Temp_Var3	; $D060
	STA <Temp_Var6	; $D062
	LDA <ScreenUpd_CurCol	; $D064
	AND #$03	; $D066
	TAX	; $D068
	EOR #$01	; $D069
	TAY	; $D06B
	LDA PRG062_D173,X	; $D06C
	STA <Temp_Var4	; $D06F
	LDA PRG062_D173,Y	; $D071
	STA <Temp_Var5	; $D074
	LDA <ScreenUpd_CurCol	; $D076
	LSR A	; $D078
	LSR A	; $D079
	TAY	; $D07A
	LDA PRG062_D2C6,Y	; $D07B
	STA Graphics_Buffer+$00	; $D07E
	STA Graphics_Buffer+$50	; $D081
	LDA PRG062_D2BE,Y	; $D084
	ORA PRG062_D177,X	; $D087
	STA Graphics_Buffer+$01	; $D08A
	STA Graphics_Buffer+$51	; $D08D
	LDA #$1F	; $D090
	STA Graphics_Buffer+$02	; $D092
	STA Graphics_Buffer+$52	; $D095
	LDA #$23	; $D098
	STA Graphics_Buffer+$23	; $D09A
	STA Graphics_Buffer+$73	; $D09D
	LDA #$C0	; $D0A0
	ORA <MetaBlk_Index	; $D0A2
	STA Graphics_Buffer+$24	; $D0A4
	STA Graphics_Buffer+$74	; $D0A7
	LDA #$07	; $D0AA
	STA Graphics_Buffer+$25	; $D0AC
	STA Graphics_Buffer+$75	; $D0AF

PRG062_D0B2:
	JSR PRG062_FillPatternBuffer	; $D0B2

	LDA #$04	; $D0B5
	STA <Temp_Var7	; $D0B7
	LDA <Temp_Var4	; $D0B9
	PHA	; $D0BB
	LDA <Temp_Var5	; $D0BC
	PHA	; $D0BE

PRG062_D0BF:
	LDX <Temp_Var3	; $D0BF
	LDY <Temp_Var4	; $D0C1
	LDA Pattern_Buffer,Y	; $D0C3
	STA Graphics_Buffer+$03,X	; $D0C6
	LDY <Temp_Var5	; $D0C9
	LDA Pattern_Buffer,Y	; $D0CB
	STA Graphics_Buffer+$53,X	; $D0CE
	INC <Temp_Var3	; $D0D1
	INC <Temp_Var4	; $D0D3
	INC <Temp_Var5	; $D0D5
	DEC <Temp_Var7	; $D0D7
	BNE PRG062_D0BF	; $D0D9

	PLA	; $D0DB
	STA <Temp_Var5	; $D0DC
	PLA	; $D0DE
	STA <Temp_Var4	; $D0DF
	LDA <ScreenUpd_CurCol	; $D0E1
	AND #$03	; $D0E3
	LSR A	; $D0E5
	TAY	; $D0E6
	LDX <MetaBlk_Index	; $D0E7
	LDA Pattern_AttrBuffer,X	; $D0E9
	AND PRG062_D16F,Y	; $D0EC
	STA <Temp_Var0	; $D0EF
	LDA <Temp_Var16	; $D0F1
	AND PRG062_D171,Y	; $D0F3
	ORA <Temp_Var0	; $D0F6
	STA Pattern_AttrBuffer,X	; $D0F8
	LDX <Temp_Var6	; $D0FB
	STA Graphics_Buffer+$26,X	; $D0FD
	STA Graphics_Buffer+$76,X	; $D100
	INC <Temp_Var6	; $D103
	INC <MetaBlk_Index	; $D105
	LDA <MetaBlk_Index	; $D107
	AND #$07	; $D109
	BNE PRG062_D0B2	; $D10B

	DEC <MetaBlk_Index	; $D10D
	LDA <MetaBlk_Index	; $D10F
	AND #$38	; $D111
	STA <MetaBlk_Index	; $D113
	LDY <MetaBlk_CurScreen	; $D115
	INY	; $D117
	JSR PRG062_SetMetaBlkAddr	; $D118

	JSR PRG062_FillPatternBuffer	; $D11B

	LDY <Temp_Var4	; $D11E
	LDA Pattern_Buffer,Y	; $D120
	STA Graphics_Buffer+$03	; $D123
	LDY <Temp_Var5	; $D126
	LDA Pattern_Buffer,Y	; $D128
	STA Graphics_Buffer+$53	; $D12B
	LDA <RAM_0023	; $D12E
	AND #$04	; $D130
	LSR A	; $D132
	LSR A	; $D133
	TAX	; $D134
	LDY PRG062_D17B,X	; $D135
	LDA #$FF	; $D138
	STA Graphics_Buffer+$00,Y	; $D13A
	STA <CommitGBuf_Flag	; $D13D
	STA Graphics_Buffer+$50,Y	; $D13F
	RTS	; $D142


PRG062_D143:
	LDY #$2E	; $D143

PRG062_D145:
	LDA Graphics_Buffer+$50,Y	; $D145
	STA Graphics_Buffer+$00,Y	; $D148
	DEY	; $D14B
	BPL PRG062_D145	; $D14C

	LDA Graphics_Buffer+$01	; $D14E
	EOR #$20	; $D151
	STA Graphics_Buffer+$01	; $D153
	LDA #$23	; $D156
	STA Graphics_Buffer+$23	; $D158
	LDA <RAM_0023	; $D15B
	AND #$04	; $D15D
	LSR A	; $D15F
	LSR A	; $D160
	EOR #$01	; $D161
	TAX	; $D163
	LDY PRG062_D17B,X	; $D164
	LDA #$FF	; $D167
	STA Graphics_Buffer+$00,Y	; $D169
	STA <CommitGBuf_Flag	; $D16C
	RTS	; $D16E


PRG062_D16F:
	.byte $F0, $0F
	
PRG062_D171:
	.byte $0F, $F0
	
PRG062_D173:
	.byte $00, $04, $08, $0C
	
PRG062_D177:
	.byte $00, $20, $40, $60

PRG062_D17B:
	.byte $23, $2E, $2A, $1F



PRG062_FillPatternBuffer:
	; Set TempVar_0/1 to point to the tile layout data
	JSR PRG062_ChngLBnk_MetatileAddr

	; All 4 tiles of metatile
	LDY #$03
	STY <Temp_Var2
	
	LDA #$00
	STA <Temp_Var16

PRG062_D18A:
	LDY <Temp_Var2
	LDX PRG062_D2BA,Y
	LDA [Temp_Var0],Y
	TAY
	
	; Copy patterns for tile to buffer
	LDA TileLayout_Patterns,Y
	STA Pattern_Buffer,X
	LDA TileLayout_Patterns+$100,Y
	STA Pattern_Buffer+1,X
	LDA TileLayout_Patterns+$200,Y
	STA Pattern_Buffer+4,X
	LDA TileLayout_Patterns+$300,Y
	STA Pattern_Buffer+5,X
	
	; Palette for metablock
	LDA TileLayout_Patterns+$400,Y
	AND #$03
	ORA <Temp_Var16
	STA <Temp_Var16
	
	JSR PRG062_D1C5	; FIXME

	JSR PRG062_D24B	; FIXME

	DEC <Temp_Var2
	BMI PRG062_D1C4

	ASL <Temp_Var16
	ASL <Temp_Var16
	JMP PRG062_D18A


PRG062_D1C4:
	RTS	; $D1C4


PRG062_D1C5:
	LDA <TileMap_Index
	CMP #$02
	BEQ PRG062_D230	; If TileMap_Index = 2 (Drill Man), jump to PRG062_D230

	CMP #$04
	BNE PRG062_D1C4	; If TileMap_Index <> 4 (Ring Man), jump to PRG062_D1C4 (RTS)

	; Ring Man only...

	CPY #$09
	BEQ PRG062_D1D7	; If tile index = $09 (FIXME), jump to PRG062_D1D7

	CPY #$8C
	BNE PRG062_D1C4	; If tile index <> $8C (FIXME), jump to PRG062_D1C4 (RTS)


PRG062_D1D7:
	; Ring Man, tile index $09 / $8C

	LDA #$00	; $D1D7
	STA <RandomN+$02	; $D1D9
	
	LDA <Level_SegCurData	; $D1DB
	AND #$C0	; $D1DD
	BNE PRG062_D1EB	; $D1DF

	LDA <MetaBlk_CurScreen	; $D1E1
	ROR A	; $D1E3
	ROR A	; $D1E4
	ROR A	; $D1E5
	ROR A	; $D1E6
	AND #$20	; $D1E7
	STA <RandomN+$02	; $D1E9

PRG062_D1EB:
	LDA <MetaBlk_Index	; $D1EB
	LSR A	; $D1ED
	PHA	; $D1EE
	AND #$FC	; $D1EF
	STA <RandomN+$03	; $D1F1
	PLA	; $D1F3
	LSR A	; $D1F4
	AND #$01	; $D1F5
	ORA <RandomN+$03	; $D1F7
	STA <RandomN+$03	; $D1F9
	LDA <Temp_Var2	; $D1FB
	AND #$02	; $D1FD
	ORA <RandomN+$02	; $D1FF
	ORA <RandomN+$03	; $D201
	STA <RandomN+$03	; $D203
	LDA <MetaBlk_Index	; $D205
	ASL A	; $D207
	STA <RandomN+$02	; $D208
	LDA <Temp_Var2	; $D20A
	AND #$01	; $D20C
	ORA <RandomN+$02	; $D20E
	AND #$07	; $D210
	TAY	; $D212
	LDA PRG063_IndexToBit,Y	; $D213
	STA <RandomN+$02	; $D216
	LDY <RandomN+$03	; $D218
	LDA Level_ScreenTileModData+$00,Y	; $D21A
	AND <RandomN+$02	; $D21D
	BEQ PRG062_D22F	; $D21F

	LDA #$00	; $D221
	STA Pattern_Buffer,X	; $D223
	STA Pattern_Buffer+1,X	; $D226
	STA Pattern_Buffer+4,X	; $D229
	STA Pattern_Buffer+5,X	; $D22C

PRG062_D22F:
	RTS	; $D22F


PRG062_D230:
	; Drill Man only...

	LDA TileLayout_Patterns+$400,Y	; ; $D230
	AND #$F0	; $D233
	CMP #$70	; $D235
	BNE PRG062_D22F	; $D237

	LDY <MetaBlk_CurScreen	; $D239
	LDA Pattern_AttrBuffer+$30,Y	; $D23B
	AND #$0F	; $D23E
	BEQ PRG062_D22F	; $D240

	LDA <Temp_Var16	; $D242
	AND #$FC	; $D244
	ORA #$01	; $D246
	STA <Temp_Var16	; $D248
	RTS	; $D24A


PRG062_D24B:
	LDA <Raster_VMode
	CMP #RVMODE_DUSTMANCRUSH
	BNE PRG062_D294	; If this is not the Dust Man crusher, jump to PRG062_D294 (RTS)

	; Dust Man crusher only...

	; If outside of screens $0C to $11, jump to PRG062_D294 (RTS)
	LDY <MetaBlk_CurScreen
	CPY #$0C
	BLT PRG062_D294
	CPY #$11
	BGE PRG062_D294

	LDX PRG063_DustManCrushBlkDatOff-$0C,Y	; Starting index for screen

PRG062_D25E:
	LDA PRG063_DustManCrushBlkDat,X	; $D25E
	BMI PRG062_D294	; If terminator to block list, jump to PRG062_D294 (RTS)

	CMP <MetaBlk_Index
	BEQ PRG062_D26B	; If matched the metablock, jump to PRG062_D26B

	INX
	INX
	BNE PRG062_D25E	; Loop!


PRG062_D26B:
	LDA PRG063_DustManCrushBlkDat+$01,X	; $D26B
	ORA <Temp_Var2	; $D26E
	PHA	; $D270
	AND #$07	; $D271
	TAX	; $D273
	PLA	; $D274
	LSR A	; $D275
	LSR A	; $D276
	LSR A	; $D277
	TAY	; $D278
	LDA Level_ScreenTileModData+$00,Y	; $D279
	AND PRG063_IndexToBit,X	; $D27C
	BEQ PRG062_D294	; $D27F

	LDY <Temp_Var2	; $D281
	LDX PRG062_D2BA,Y	; $D283
	LDA #$00	; $D286
	STA Pattern_Buffer,X	; $D288
	STA Pattern_Buffer+1,X	; $D28B
	STA Pattern_Buffer+4,X	; $D28E
	STA Pattern_Buffer+5,X	; $D291

PRG062_D294:
	RTS	; $D294


	; Sets Temp_Var0/Temp_Var1 to the base of the 2x2 16x16 tile grid for the metablock
PRG062_ChngLBnk_MetatileAddr:
	LDA <TileMap_Index	; This could be $00-$14 (thus bank 32 to 52 is put into place)
	ORA #32
	CMP <MMC3_PageA000_Req
	BEQ PRG062_SetMetatilePtr

	; Only if the bank isn't already in place for some reason (never happens I think, but cool beans)
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

PRG062_SetMetatilePtr:
	LDA #$00
	STA <Temp_Var1
	
	LDY <MetaBlk_Index
	
	; Multiply MetaBlk_Index by 4 to index the base of the 2x2 16x16 tile grid for the metablock
	LDA [MetaBlk_ScrAddrL],Y
	ASL A
	ROL <Temp_Var1
	ASL A
	ROL <Temp_Var1
	STA <Temp_Var0
	
	LDA <Temp_Var1
	ADD #HIGH(MetaBlk_TileLayout)
	STA <Temp_Var1
	
	RTS	; $D2B9


PRG062_D2BA:
	.byte $00, $02, $08, $0A
PRG062_D2BE:
	; $D2BA - $D2BE
	.byte $00, $80, $00, $80, $00, $80, $00, $80
PRG062_D2C6:
	; $D2BE - $D2C6
	.byte $20, $20, $21, $21, $22, $22, $23, $23	; $D2C6 - $D2CD



	; Sets MetaBlk_ScrAddrL/MetaBlk_ScrAddrH to [MetaBlk_ScrLayoutOffset,Y] * 64 + MetaBlk_ScrLayout
PRG062_SetMetaBlkAddr:

	LDA <TileMap_Index	; This could be $00-$14 (thus bank 32 to 52 is put into place)
	ORA #32		
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks


	; Load pointer to metablock-screen data -> MetaBlk_ScrAddrL/H
	; Y = current screen index
PRG062_SetMetaBlkScrBaseAddr:

	; NOTE: Can be loading from bank 32 to 52!!
	LDA MetaBlk_ScrLayoutOffset,Y	; Get [offset / 64] into MetaBlk_ScrLayout for this screen
	PHA	; Save it
	
	; Temp_Var0 will hold part of a high address...
	LDA #$00
	STA <Temp_Var0
	
	PLA	; Restore what was pulled from the LUT
	
	; 16-bit left shift 6 times (thus multiply by 64)
	ASL A
	ROL <Temp_Var0
	ASL A
	ROL <Temp_Var0
	ASL A
	ROL <Temp_Var0
	ASL A
	ROL <Temp_Var0
	ASL A
	ROL <Temp_Var0
	ASL A
	ROL <Temp_Var0
	STA <MetaBlk_ScrAddrL	; Low part -> MetaBlk_ScrAddrL
	
	; Add MetaBlk_ScrLayout for high part
	LDA <Temp_Var0
	ADD #HIGH(MetaBlk_ScrLayout)
	STA <MetaBlk_ScrAddrH	; High part -> MetaBlk_ScrAddrH
	
	RTS	; $D2FB


	; Inputs:
	; X = object slot to target
	; Y = selection of horizontal "spread" of X/Y offsets to use for detecting tiles (indexing PRG062_TDetFloorOffSpread)
	;
	; Output:
	; One or more values stored into Level_TileAttrsDetected, depending on "spread" data
PRG062_ObjDetFloorAttrs:

	; NOTE: PRG062_SetTMapBankAndUpdPlyrY sets:
	;	Temp_Var16 = 0
	;	Level_TileAttr_GreatestDet = 0
	JSR PRG062_SetTMapBankAndUpdPlyrY	; Puts tilemap bank into context and updates Player_Y
	JSR PRG062_ChkPlyrXHiDustManCrush	; Dust Man crusher segment screen adjustment

	; Tile detection offset select
	LDA PRG062_TDetFloorOffSpread_L,Y
	STA <Level_TileDetOffPtr_L
	LDA PRG062_TDetFloorOffSpread_H,Y
	STA <Level_TileDetOffPtr_H
	
	LDY #$00	; Y = 0
	STY <Level_TileDetOff_Index	; Level_TileDetOff_Index = 0
	
	; Temp_Var6 = number of expected X offsets for the "spread", minus 1
	LDA [Level_TileDetOffPtr_L],Y
	STA <Temp_Var6
	
	; Temp_Var2 = 0
	LDA #$00
	STA <Temp_Var2
	
	; Temp_Var3 = object's YHi (1 is too low, -1 is too high, 0 is normal screen space)
	LDA Spr_YHi+$00,X
	STA <Temp_Var3
	
	LDY #$01	; Y = 1
	
	LDA [Level_TileDetOffPtr_L],Y	; Y offset for the tile detection
	PHA		; Save it
	
	ADD Spr_Y+$00,X
	STA <Temp_Var17	; Temp_Var17 = object's Y + offset
	
	PLA	; Restore offset (for negation check)
	
	BMI PRG062_D335	; If Y offset was negative, jump to PRG062_D335
	
	; Positive Y offset...
	
	BCS PRG062_D337	; If carry occurred, jump to PRG062_D337

	; No carry...

	LDA <Temp_Var17
	CMP #$F0
	BGE PRG062_D337	; If PRG062_D337 >= $F0 (too low), jump to PRG062_D337

	BCC PRG062_D344	; Otherwise, jump to PRG062_D344


PRG062_D335:
	BCS PRG062_D344	; Otherwise, jump to PRG062_D344


PRG062_D337:

	; Object is off the grid, just clear the results
	LDA #$00

	; Clear all the expected tile detection result slots
	LDY <Temp_Var6
PRG062_D33B:
	STA Level_TileAttrsDetected+$00,Y
	
	DEY	; Y--
	BPL PRG062_D33B	; While Y >= 0, loop

	JMP PRG062_D58D	; Jump to PRG062_D58D (end routine cleanup)


PRG062_D344:
	LDA <Temp_Var3	; Object's Y Hi
	BNE PRG062_D337	; If too low/high, jump to PRG062_D337

	; Start computing interacted with Meta block
	LDA <Temp_Var17	; Object's offset Y
	LSR A
	LSR A	; div by 4
	PHA		; save
	
	AND #$38
	STA <MetaBlk_Index
	
	PLA		; restore offset object Y / 4
	LSR A
	AND #$02
	STA <Temp_Var3
	
	; Temp_Var4 = 0 (16-bit sign extension)
	LDA #$00
	STA <Temp_Var4
	
	; Level_TileDetOff_Index = 2 (internal index var for fetching more data from [Level_TileDetOffPtr_L])
	LDY #$02		; Y = 2
	STY <Level_TileDetOff_Index
	
	LDA [Level_TileDetOffPtr_L],Y
	BPL PRG062_D365	; If X offset is negative, jump to PRG062_D365

	DEC <Temp_Var4	; Temp_Var4 = $FF (16-bit sign extension)

PRG062_D365:
	ADD Spr_X+$00,X
	STA <Temp_Var18	; Temp_Var18 = object offset X
	
	LDA Spr_XHi+$00,X
	ADC <Temp_Var4	; 16-bit ext
	STA <Temp_Var19	; Temp_Var19 = object offset XHi
	
	; Compute final MetaBlk_Index
	LDA <Temp_Var18
	LSR A
	LSR A
	LSR A
	LSR A
	PHA
	AND #$01
	ORA <Temp_Var3
	STA <Temp_Var3
	
	PLA
	LSR A
	ORA <MetaBlk_Index
	STA <MetaBlk_Index

	; OUTER FLOOR TILE DETECTION LOOP
	; Note that this uses data from PRG062_TDetFloorOffSpread table to determine
	; how large of a "spread" of tiles need to be detected; we start here and 
	; may return here or PRG062_D38A if we spanned a tile / metablock / screen
PRG062_D385:
	LDY <Temp_Var19	; current screen, effectively
	JSR PRG062_SetMetaBlkScrBaseAddr


PRG062_D38A:
	JSR PRG062_SetMetatilePtr


PRG062_D38D:
	LDY <Temp_Var3
	
	; FLOOR DETECTION BEGIN!
	
	; Get 16x16 tile -> 'Y'
	LDA [Temp_Var0],Y
	TAY
	
	; Get attribute for relevant 16x16 tile -> 'A'
	LDA TileLayout_Attributes,Y
	AND #$F0	
	
	; NOTE: None of these functions use register 'X' (object index) which holds its value for below
	; Keep that in mind if you go poking around here...
	JSR PRG062_RingManRBowPlatUnsolid	; Solidity override for making Ring Man's rainbow platforms
	JSR PRG062_Cossack1BossBustUnsolid	; Solidity override for the Cossack 1 boss's smashed tiles
	JSR PRG062_DiveDrillRingMiscTile	; Dive Man water line limiter, Drill man (FIXME), and Ring Man (FIXME) tile handlers
	JSR PRG062_DustManCrushShotUnsolid	; Solidity override for Dust Man's crusher segment shootable blocks
	JSR PRG062_WilyTransporterUnsolid	; Solidity override for Wily's specific transporter that dynamically appears

	CPX #$00
	BNE PRG062_D3B0	; If this is not the Player, jump to PRG062_D4E1
	
	; Player object only...

	CMP #TILEATTR_SPIKES
	BNE PRG062_D3B0	; If these are not spikes, jump to PRG062_D4E1

	STA <Player_TriggerDeath	; Kill Player!

	; INNER FLOOR TILE DETECTION LOOP
	; This loops continuously unless we move to a new tile or metablock
PRG062_D3B0:
	LDY <Temp_Var2				; Y = Temp_Var2 (loop index)
	STA Level_TileAttrsDetected+$00,Y	; Store detected tile attribute
	
	; Storing "greatest" attribute value into Level_TileAttr_GreatestDet -- basically
	; when it's all said and done, we're taking the "greatest effect"
	; attribute, so an object can detect multiple tiles and only
	; ultimately respond to the "greatest effect" across all of those tiles.
	CMP <Level_TileAttr_GreatestDet
	BLT PRG062_D3BB	; If attribute value < Level_TileAttr_GreatestDet (?), jump to PRG062_D3BB

	STA <Level_TileAttr_GreatestDet	; Otherwise, store attribute value into Level_TileAttr_GreatestDet

PRG062_D3BB:
	ORA <Temp_Var16	; Combine attribute with current value in Temp_Var16
	STA <Temp_Var16	; -> Temp_Var16
	
	LDA <Temp_Var2	; Loop index
	CMP <Temp_Var6	; "Final" index value
	BEQ PRG062_D3FD	; If equal, jump to PRG062_D3FD

	INC <Temp_Var2	; Next loop index
	
	INC <Level_TileDetOff_Index	; Level_TileDetOff_Index++ 
	LDY <Level_TileDetOff_Index	; Y = Level_TileDetOff_Index (index of next X offset)
	
	LDA <Temp_Var18	; Object offset X
	PHA				; Save it
	
	AND #$10		; future check of tile spanning (since tile is 16 pixels wide, this will invert if you cross onto a new one)
	STA <Temp_Var4	; -> Temp_Var 4
	
	PLA	; Restore object offset X
	
	ADD [Level_TileDetOffPtr_L],Y	; Add next (cumulative) X offset 
	STA <Temp_Var18		; 	-> Temp_Var18
	
	AND #$10
	CMP <Temp_Var4
	BEQ PRG062_D38D	; If still on same tile, jump to PRG062_D38D (loop around)

	; Moved on to another tile...

	LDA <Temp_Var3
	EOR #$01
	STA <Temp_Var3
	AND #$01
	BNE PRG062_D38D	; If haven't advanced to another meta block, jump to PRG062_D38D (loop around)

	; Moved on to another metablock...

	INC <MetaBlk_Index	; MetaBlk_Index++
	LDA <MetaBlk_Index
	AND #$07			; 8 metablocks per row
	BNE PRG062_D38A		; If still on same row of metablocks, jump to PRG062_D38A (set new tile pointer, continue loop)

	; New screen entirely...

	INC <Temp_Var19		; Temp_Var19++ (next screen)
	
	; Fix MetaBlk_Index for new screen
	DEC <MetaBlk_Index
	LDA <MetaBlk_Index
	AND #$38
	STA <MetaBlk_Index
	
	JMP PRG062_D385	; Jump to PRG062_D385 (set new metablock and tile pointers, continue loop)


PRG062_D3FD:
	; Tile detect loop ended...

	LDA <Raster_VMode
	CMP #RVMODE_DUSTMANCRUSH
	BNE PRG062_D425	; If this isn't the Dust Man crusher segment, jump to PRG062_D425

	LDA Level_RasterVDir
	AND #SPRDIR_DOWN
	BNE PRG062_D425		; If crusher is not moving down, jump to PRG062_D425
	
	; Crusher is moving down...

	LDA Spr_XHi+$00,X
	CMP #$0C
	BEQ PRG062_D425	; If object is on first screen of crusher, jump to PRG062_D425

	; Object not on first screen of crusher...

	LDA <Temp_Var16
	BNE PRG062_D425	; If some tile attribute was detected from the loop, jump to PRG062_D425

	; Crusher moving down, no tile solidity detected on previous loop...

	LDA <Temp_Var17			; Object's offset Y
	ADD Level_RasterYOff	; +Raster vertical offset
	CMP #$C0
	BLT PRG062_D425			; If total < $C0, jump to PRG062_D425

	STA <Temp_Var17			; Force object offset Y to new offset
	
	; Force a solid detection
	LDA #TILEATTR_SOLID
	STA <Temp_Var16

PRG062_D425:
	JMP PRG062_D58D	; Jump to PRG062_D58D (end routine cleanup)



	; Inputs:
	; X = object slot to target
	; Y = selection of vertical "spread" of X/Y offsets to use for detecting tiles (indexing PRG062_TDetWallOffSpread)
	;
	; Output:
	; One or more values stored into Level_TileAttrsDetected, depending on "spread" data
PRG062_ObjDetWallAttrs:

	; NOTE: PRG062_SetTMapBankAndUpdPlyrY sets:
	;	Temp_Var16 = 0
	;	Level_TileAttr_GreatestDet = 0
	JSR PRG062_SetTMapBankAndUpdPlyrY	; Puts tilemap bank into context and updates Player_Y
	JSR PRG062_AdjPlyrYForDustManCrush	; Adjust Player's sprite Y for Dust Man's crushing segment (if applicable)

	; Tile detection offset select
	LDA PRG062_TDetWallOffSpread_L,Y
	STA <Level_TileDetOffPtr_L
	LDA PRG062_TDetWallOffSpread_H,Y
	STA <Level_TileDetOffPtr_H

	LDY #$00	; Y = 0
	
	; Temp_Var6 = number of expected Y offsets for the "spread", minus 1
	LDA [Level_TileDetOffPtr_L],Y
	STA <Temp_Var6
	
	; Temp_Var2 = 0
	LDA #$00
	STA <Temp_Var2
	
	LDA #$00
	STA <Temp_Var4	; Temp_Var4 = 0 (16-bit sign extension)
	STA <Temp_Var5	; Temp_Var5 = 0 ("extend tiles" flag, set to 1 if object is off-screen above or below)
	
	LDY #$01	; Y = 1
	
	LDA [Level_TileDetOffPtr_L],Y	; X offset for the tile detection
	BPL PRG062_D450

	DEC <Temp_Var4	; Temp_Var4 = $FF (16-bit sign extension)

PRG062_D450:
	ADD Spr_X+$00,X
	STA <Temp_Var18	; Temp_Var18 new object X
	
	LDA Spr_XHi+$00,X
	ADC <Temp_Var4	; 16-bit sign extension
	STA <Temp_Var19	; Temp_Var19 new object XHi
	
	; Compute final MetaBlk_Index
	LDA <Temp_Var18
	LSR A
	LSR A
	LSR A
	LSR A

	PHA

	AND #$01
	STA <Temp_Var3
	
	PLA
	
	LSR A
	STA <MetaBlk_Index
	
	; Level_TileDetOff_Index = 2 (internal index var for fetching more data from [Level_TileDetOffPtr_L])
	LDY #$02		; Y = 2
	STY <Level_TileDetOff_Index
	
	LDA Spr_YHi+$00,X
	BMI PRG062_D497		; If object's YHi < 0, jump to PRG062_D497

	BNE PRG062_D48F	; $D475

	LDA Spr_Y+$00,X
	ADD [Level_TileDetOffPtr_L],Y	; Offset 2
	STA <Temp_Var17	; Temp_Var17 new object Y
	
	LDA [Level_TileDetOffPtr_L],Y
	BPL PRG062_D487		; If Y offset is negative, jump to PRG062_D487
	
	BCC PRG062_D497
	BCS PRG062_D489


PRG062_D487:
	BCS PRG062_D48F


PRG062_D489:
	; Post-adjust Y limit
	LDA <Temp_Var17
	CMP #$F0
	BLT PRG062_D49D		; If object Y < $F0, jump to PRG062_D49D


PRG062_D48F:
	; Prevent Temp_Var17 (Object Y) from being lower than $EF
	; Basically tiles extend "infinitely" vertically above or below the screen
	LDA #$EF
	STA <Temp_Var17
	
	INC <Temp_Var5	; Temp_Var5 = 1 (object is vertically off-screen)
	BNE PRG062_D49D	; Jump (technically always) to PRG062_D49D


PRG062_D497:
	; Prevent Temp_Var17 (Object Y) from being lower than $00
	; Basically tiles extend "infinitely" vertically above or below the screen
	LDA #$00
	STA <Temp_Var17
	
	INC <Temp_Var5	; Temp_Var5 = 1 (object is vertically off-screen)

PRG062_D49D:

	LDA <Temp_Var17
	LSR A
	LSR A
	PHA
	
	AND #$38
	ORA <MetaBlk_Index
	STA <MetaBlk_Index
	
	PLA
	
	LSR A
	AND #$02
	ORA <Temp_Var3
	STA <Temp_Var3
	
	; NOTE: Unlike "floor" detect variant, never need to return here, because
	; we're detecting a vertical column of meta blocks / tiles and there's no
	; vertical scrolling which would make meta block recomputation a concern.
	LDY <Temp_Var19	; current screen, effectively
	JSR PRG062_SetMetaBlkScrBaseAddr


	; OUTER WALL TILE DETECTION LOOP
	; Note that this uses data from PRG062_TDetWallOffSpread table to determine
	; how large of a "spread" of tiles need to be detected; we start here and 
	; may return here if we spanned a tile / metablock
PRG062_D4B5:
	JSR PRG062_SetMetatilePtr


PRG062_D4B8:
	LDY <Temp_Var3
	
	; WALL DETECTION BEGIN!
	
	; Get 16x16 tile -> 'Y'
	LDA [Temp_Var0],Y
	TAY
	
	; Get attribute for relevant 16x16 tile -> 'A'
	LDA TileLayout_Attributes,Y
	AND #$F0
	
	CMP #TILEATTR_LADDERTOP
	BNE PRG062_D4C8		; If this is not the top of the ladder, jump to PRG062_D4C8

	LDA #TILEATTR_LADDER	; Basically wall detection treats the top of a ladder like the not-top of a ladder

PRG062_D4C8:
	; NOTE: None of these functions use register 'X' (object index) which holds its value for below
	; Keep that in mind if you go poking around here...
	JSR PRG062_RingManRBowPlatUnsolid	; Solidity override for making Ring Man's rainbow platforms
	JSR PRG062_Cossack1BossBustUnsolid	; Solidity override for the Cossack 1 boss's smashed tiles
	JSR PRG062_DiveDrillRingMiscTile	; Dive Man water line limiter, Drill man (FIXME), and Ring Man (FIXME) tile handlers
	JSR PRG062_DustManCrushShotUnsolid	; Solidity override for Dust Man's crusher segment shootable blocks
	JSR PRG062_WilyTransporterUnsolid	; Solidity override for Wily's specific transporter that dynamically appears

	CPX #$00
	BNE PRG062_D4E1	; If this is not the Player, jump to PRG062_D4E1
	
	; Player object only...

	CMP #TILEATTR_SPIKES
	BNE PRG062_D4E1	; If this is not spikes, jump to PRG062_D4E1

	STA <Player_TriggerDeath	; Kill Player!

	; INNER WALL TILE DETECTION LOOP
	; This loops continuously unless we move to a new tile or metablock
PRG062_D4E1:
	LDY <Temp_Var2						; Y = Temp_Var2 (loop index)
	STA Level_TileAttrsDetected+$00,Y	; Store detected tile attribute
	
	; Storing "greatest" attribute value into Level_TileAttr_GreatestDet -- basically
	; when it's all said and done, we're taking the "greatest effect"
	; attribute, so an object can detect multiple tiles and only
	; ultimately respond to the "greatest effect" across all of those tiles.
	CMP <Level_TileAttr_GreatestDet
	BLT PRG062_D4EC	; If attribute value < Level_TileAttr_GreatestDet (?), jump to PRG062_D4EC

	STA <Level_TileAttr_GreatestDet	; Otherwise, store attribute value into Level_TileAttr_GreatestDet

PRG062_D4EC:
	ORA <Temp_Var16	; Combine attribute with current value in Temp_Var16
	STA <Temp_Var16	; -> Temp_Var16

	LDA <Temp_Var2	; Loop index
	CMP <Temp_Var6	; "Final" index value
	BEQ PRG062_D537	; If equal, jump to PRG062_D537

	INC <Temp_Var2	; Next loop index
	
	INC <Level_TileDetOff_Index	; Level_TileDetOff_Index++ 
	
	LDA <Temp_Var5
	BNE PRG062_D4B8	; If object is vertically off-screen, jump to PRG062_D4B8

	LDY <Level_TileDetOff_Index	; Y = Level_TileDetOff_Index (index of next Y offset)
	
	LDA <Temp_Var17	; Object offset Y
	PHA				; Save it

	AND #$10		; future check of tile spanning (since tile is 16 pixels wide, this will invert if you cross onto a new one)
	STA <Temp_Var4	; -> Temp_Var 4
	
	PLA	; Restore object offset Y
	
	ADD [Level_TileDetOffPtr_L],Y	; Add next (cumulative) Y offset 
	STA <Temp_Var17		; 	-> Temp_Var17
	
	AND #$10
	CMP <Temp_Var4
	BEQ PRG062_D4B8	; If still on same tile, jump to PRG062_D4B8 (loop around)

	; Moved on to another tile...

	LDA <Temp_Var3
	EOR #$02
	STA <Temp_Var3
	AND #$02
	BNE PRG062_D4B8	; If haven't advanced to another meta block, jump to PRG062_D4B8 (loop around)

	LDA <MetaBlk_Index
	PHA			; Save old one in case we go too low
	ADD #$08	; Next "row" of metablocks
	STA <MetaBlk_Index
	
	CMP #$40
	PLA			; Restore "old" metablock index
	BLT PRG062_D4B5	; If MetaBlk_Index < $40 (not too low), jump to PRG062_D4B5 (set new tile pointer, contine loop)

	; Too low, restore last (lowest) MetaBlk_Index
	STA <MetaBlk_Index
	
	LDA <Temp_Var3
	EOR #$02
	STA <Temp_Var3
	
	INC <Temp_Var5	; Temp_Var5 set non-zero since object is now below bottom of screen
	JMP PRG062_D4B8	; Jump to PRG062_D4B8 (loop around)


PRG062_D537:
	JMP PRG062_D58D	; Jump to PRG062_D58D (end routine cleanup)


	; Utility function to set the tilemap bank and update Player Y
	; Temp_Var16 = 0
	; Level_TileAttr_GreatestDet = 0
PRG062_SetTMapBankAndUpdPlyrY:
	LDA #$00
	STA <Temp_Var16
	STA <Level_TileAttr_GreatestDet
	
	; Backup page at $A000
	LDA <MMC3_PageA000_Req
	STA <MMC3_PageA000_Backup
	
	; Set bank for current TileMap_Index at $A000
	LDA <TileMap_Index
	ORA #32		; 32 to 52
	STA <MMC3_PageA000_Req
	
	; Update Player_Y
	LDA Spr_Y+$00,X
	STA <Player_Y
	
	JMP PRG063_SetPRGBanks	; Set tile map bank

	; Check Player's XHi for Dust Man's crusher segment
PRG062_ChkPlyrXHiDustManCrush:
	LDA <Raster_VMode
	CMP #RVMODE_DUSTMANCRUSH
	BNE PRG062_D58C	; If this isn't Dust Man's crusher segment, jump to PRG062_D58C (RTS)

	; 4 - down
	; 8 - up

	LDA Level_RasterVDir
	AND #$04
	BNE PRG062_AdjPlyrYForDustManCrush	; If Dust Man's crusher is moving up, jump to PRG062_AdjPlyrYForDustManCrush

	LDA Spr_XHi+$00,X
	CMP #$0C
	BNE PRG062_D582	; If Player XHi is not at $0C, jump to PRG062_D582


	; Changes Player sprite Y for Dust Man's crusher segment
PRG062_AdjPlyrYForDustManCrush:
	LDA <Raster_VMode
	CMP #RVMODE_DUSTMANCRUSH
	BNE PRG062_D58C	; If this isn't Dust Man's crusher segment, jump to PRG062_D58C (RTS)

	LDA <Player_State
	CMP #PLAYERSTATE_SLIDING
	BNE PRG062_D57B	; If Player is not sliding, jump to PRG062_D57B

	LDA Spr_Y+$00,X
	CMP #$B7
	BGE PRG062_D58C	; If Player Y >= $B7 (below the raster split), jump to PRG062_D58C (RTS)
	BLT PRG062_D582	; Otherwise, jump to PRG062_D582


PRG062_D57B:
	; Player not sliding

	LDA Spr_Y+$00,X
	CMP #$B5
	BGE PRG062_D58C	; If Player Y >= $B5 (below the raster split), jump to PRG062_D58C (RTS)


PRG062_D582:
	; Adjust Player Y for raster effect
	LDA Spr_Y+$00,X
	SUB Level_RasterYOff
	STA Spr_Y+$00,X

PRG062_D58C:
	RTS	; $D58C


PRG062_D58D:
	
	; Lock object to player Y (FIXME Why? Or is this just general player Y update?)
	LDA <Player_Y
	STA Spr_Y+$00,X
	
	; Restore page $A000 and return
	LDA <MMC3_PageA000_Backup
	STA <MMC3_PageA000_Req
	JMP PRG063_SetPRGBanks


	; Checks if a Ring Man rainbow platform has become unsolid
PRG062_RingManRBowPlatUnsolid:
	; Basically, if Ring Man's rainbow/nega-rainbow tile, jump to PRG062_D5A1, else PRG062_D5D9 (RTS)
	CPY #$09	; Rainbow Platform Tile
	BEQ PRG062_D5A1
	CPY #$8C	; "Nega" Rainbow Platform Tile (not sure what else to call it)
	BNE PRG062_D5D9


PRG062_D5A1:
	LDY <TileMap_Index
	CPY #TMAP_RINGMAN
	BNE PRG062_D5D9	; If this isn't Ring Man, jump to PRG062_D5D9 (RTS)


PRG062_D5A7:
	LDA <Temp_Var18	; $D5A7
	LSR A	; $D5A9
	LSR A	; $D5AA
	LSR A	; $D5AB
	LSR A	; $D5AC
	STA <Temp_Var7	; $D5AD
	LDA <Temp_Var17	; $D5AF
	AND #$F0	; $D5B1
	ORA <Temp_Var7	; $D5B3
	PHA	; $D5B5
	AND #$07	; $D5B6
	TAY	; $D5B8
	
	LDA PRG063_IndexToBit,Y	; $D5B9
	STA <Temp_Var7	; $D5BC
	CLC	; $D5BE
	LDA <Level_SegCurData	; $D5BF
	AND #$C0	; $D5C1
	BNE PRG062_D5C8	; $D5C3

	LDA <Temp_Var19	; $D5C5
	LSR A	; $D5C7

PRG062_D5C8:
	PLA	; $D5C8
	ROR A	; $D5C9
	LSR A	; $D5CA
	LSR A	; $D5CB
	TAY	; $D5CC
	
	LDA Level_ScreenTileModData+$00,Y	; $D5CD
	AND <Temp_Var7	; $D5D0
	BEQ PRG062_D5D7	; $D5D2

	; Rainbow platform is unsolid here
	LDA #TILEATTR_UNSOLID
	RTS	; $D5D6


PRG062_D5D7:
	; Rainbow platform is solid here
	LDA #TILEATTR_SOLID

PRG062_D5D9:
	RTS	; $D5D9


	; Enables the boss's smashed tiles to becoming unsolid
PRG062_Cossack1BossBustUnsolid:
	LDY <TileMap_Index
	CPY #TMAP_COSSACK1
	BNE PRG062_D5D9	; If this is not Cossack 1, jump to PRG062_D5D9 (RTS)

	CMP #TILEATTR_SOLID
	BEQ PRG062_D5A7	; If this is a solid tile, jump to PRG062_D5A7

	BNE PRG062_D5D9	; Otherwise, jump to PRG062_D5D9 (RTS)


PRG062_DiveDrillRingMiscTile:
	LDY <Raster_VMode
	CPY #RVMODE_DMWATER
	BEQ PRG062_D61A		; If Dive Man's water is active, jump to PRG062_D61A

	LDY <TileMap_Index
	CPY #TMAP_DRILLMAN
	BEQ PRG062_D60E		; If this is Drill Man, jump to PRG062_D60E

	CPY #TMAP_RINGMAN
	BNE PRG062_D60D	; If this is not Ring Man, jump to PRG062_D60D (RTS)

	; Ring Man...

	LDY <RAM_003E	; $D5F6
	BEQ PRG062_D60D	; $D5F8

	STA <Temp_Var7	; $D5FA
	
	LDY #(PRG062_D691_End - PRG062_D691 - 1)
	
	LDA <MetaBlk_Index
PRG062_D600:
	CMP PRG062_D691,Y
	BEQ PRG062_D60B	; If this is the matching metablock for Ring Man, jump to PRG062_D60B

	DEY	; Y--
	BPL PRG062_D600	; While Y >= 0, loop!

	LDA <Temp_Var7	; $D608
	RTS	; $D60A


PRG062_D60B:

	; Unsolid Ring Man rainbow platform 
	LDA #TILEATTR_UNSOLID

PRG062_D60D:
	RTS	; $D60D


PRG062_D60E:
	; Drill Man

	CMP #TILEATTR_DRILLMANSPECFLR
	BNE PRG062_D60D	; If this is not FIXME, jump to PRG062_D60D (RTS)

	LDY <Temp_Var19	; $D612
	
	LDA Pattern_AttrBuffer+$30,Y	; $D614
	AND #$F0	; $D617
	RTS	; $D619


PRG062_D61A:
	; Dive Man's water effect
	LDY <Temp_Var17
	CPY Level_RasterYOff
	BGE PRG062_D623	; $D61F

	; Return empty tile above the raster water line

	LDA #TILEATTR_UNSOLID

PRG062_D623:
	RTS	; $D623


PRG062_DustManCrushShotUnsolid:
	LDY <Raster_VMode
	CPY #RVMODE_DUSTMANCRUSH
	BNE PRG062_D623		; If this is not the Dust Man crusher segment, jump to PRG062_D623 (RTS)

	; Dust Man crusher...

	CMP #TILEATTR_DUSTSHOOTABLE
	BNE PRG062_D623	; If this isn't one of the shootable blocks, jump to PRG062_D623

	LDY <Temp_Var19		; Temp_Var19: Current screen
	
	LDA PRG063_DustManCrushBlkDatOff-$0C,Y	; Get initial offset for this screen
	TAY	; -> 'Y'

PRG062_D634:
	LDA PRG063_DustManCrushBlkDat,Y
	BMI PRG062_D65E		; If terminator byte, jump to PRG062_D65E

	CMP <MetaBlk_Index
	BEQ PRG062_D641		; If this matches the current meta tile, jump to PRG062_D641

	; Otherwise...
	INY
	INY	; Y += 2
	BNE PRG062_D634	; Loop


PRG062_D641:
	LDA PRG063_DustManCrushBlkDat+$01,Y	; $D641
	ORA <Temp_Var3	; $D644
	PHA	; $D646
	
	AND #$07	; $D647
	TAY	; $D649
	
	LDA PRG063_IndexToBit,Y	; $D64A
	STA <Temp_Var7	; $D64D
	PLA	; $D64F
	
	LSR A	; $D650
	LSR A	; $D651
	LSR A	; $D652
	TAY	; $D653
	
	LDA Level_ScreenTileModData+$00,Y	; $D654
	AND <Temp_Var7	; $D657
	BEQ PRG062_D65E	; $D659

	; This shootable block is shot out, return empty
	LDA #TILEATTR_UNSOLID
	
	RTS	; $D65D


PRG062_D65E:

	; This shootable block hasn't been shot out yet, return it!
	LDA #TILEATTR_DUSTSHOOTABLE
	
	RTS	; $D660


PRG062_WilyTransporterUnsolid:
	LDY <TileMap_Index
	CPY #TMAP_WILY3
	BNE PRG062_D690		; If this isn't Wily 3, jump to PRG062_D690 (RTS)

	LDY <Temp_Var19	; Current screen
	CPY #$09
	BNE PRG062_D690	; If this isn't screen 9 (the teleporters), jump to PRG062_D690 (RTS)

	; Wily transport system...

	LDY <LevelWily3_TransSysComp
	CPY #$FF
	BNE PRG062_D690	; If the teleporters haven't all been cleared, jump to PRG062_D690 (RTS)

	CMP #TILEATTR_UNSOLID
	BNE PRG062_D690	; If unsolid tile, jump to PRG062_D690 (RTS)

	LDY #(PRG062_WilyTransMetaSolDat_End - PRG062_WilyTransMetaSolDat - 2)
PRG062_D679:
	LDA PRG062_WilyTransMetaSolDat,Y
	CMP <MetaBlk_Index
	BNE PRG062_D68A		; If this isn't one of the metablocks making up Wily's Transporter, jump to PRG062_D68A (loop)

	LDA PRG062_WilyTransMetaSolDat+1,Y
	CMP <Temp_Var3
	BNE PRG062_D68A		; If this isn't the relative tile index making up this metablock of Wily's Transporter, jump to PRG062_D68A (loop)

	; Found a solid tile of Wily's Transporter!
	LDA #TILEATTR_SOLID	
	RTS	; $D689


PRG062_D68A:
	DEY
	DEY
	BPL PRG062_D679

	; Not a valid solid tile for Wily's Transporter
	LDA #TILEATTR_UNSOLID

PRG062_D690:
	RTS	; $D690


	; Ring Man's rainbow platform metablocks
PRG062_D691:
	.byte $29, $2A, $2B, $32, $3A
PRG062_D691_End
	
	; Wily's Transporter per metablock solidity data
PRG062_WilyTransMetaSolDat:
	; MetaBlk_Index on left, relative tile index on the right
	.byte $0B, $01	; 0
	.byte $0C, $00	; 1
	.byte $13, $03	; 2
	.byte $14, $02	; 3
PRG062_WilyTransMetaSolDat_End



	; This specifies a "spread" of tiles to detect by a Y offset
	; followed by 1 or more X offsets (horizontal line), which the
	; FLOOR detection routine then decides upon the "greatest 
	; effect" (largest attribute value) from across all detected 
	; tiles to be the deciding overall "floor detected"
PRG062_TDetFloorOffSpread_L:	; $D69E
	.byte LOW(PRG062_D71E)	; $00
	.byte LOW(PRG062_D723)	; $01
	.byte LOW(PRG062_D727)	; $02
	.byte LOW(PRG062_D72A)	; $03
	.byte LOW(PRG062_D72F)	; $04
	.byte LOW(PRG062_D734)	; $05
	.byte LOW(PRG062_D739)	; $06
	.byte LOW(PRG062_D73E)	; $07
	.byte LOW(PRG062_D743)	; $08
	.byte LOW(PRG062_D73E)	; $09
	.byte LOW(PRG062_D748)	; $0A
	.byte LOW(PRG062_D73E)	; $0B
	.byte LOW(PRG062_D74D)	; $0C
	.byte LOW(PRG062_D752)	; $0D
	.byte LOW(PRG062_D757)	; $0E
	.byte LOW(PRG062_D75B)	; $0F
	.byte LOW(PRG062_D75F)	; $10
	.byte LOW(PRG062_D727)	; $11
	.byte LOW(PRG062_D727)	; $12
	.byte LOW(PRG062_D762)	; $13
	.byte LOW(PRG062_D767)	; $14
	.byte LOW(PRG062_D76A)	; $15
	.byte LOW(PRG062_D76F)	; $16
	.byte LOW(PRG062_D773)	; $17
	.byte LOW(PRG062_D777)	; $18
	.byte LOW(PRG062_D77C)	; $19
	.byte LOW(PRG062_D781)	; $1A
	.byte LOW(PRG062_D786)	; $1B
	.byte LOW(PRG062_D78B)	; $1C
	.byte LOW(PRG062_D78F)	; $1D
	.byte LOW(PRG062_D793)	; $1E
	.byte LOW(PRG062_D797)	; $1F
	.byte LOW(PRG062_D79B)	; $20
	.byte LOW(PRG062_D79F)	; $21
	.byte LOW(PRG062_D7A4)	; $22
	.byte LOW(PRG062_D727)	; $23
	.byte LOW(PRG062_D7A9)	; $24
	.byte LOW(PRG062_D7AC)	; $25
	.byte LOW(PRG062_D7B0)	; $26
	.byte LOW(PRG062_D7B5)	; $27
	.byte LOW(PRG062_D7BA)	; $28
	.byte LOW(PRG062_D7BE)	; $29
	.byte LOW(PRG062_D7C2)	; $2A
	.byte LOW(PRG062_D7C6)	; $2B
	.byte LOW(PRG062_D7CA)	; $2C
	.byte LOW(PRG062_D7CE)	; $2D
	.byte LOW(PRG062_D7D1)	; $2E
	.byte LOW(PRG062_D7D7)	; $2F
	.byte LOW(PRG062_D7DD)	; $30
	.byte LOW(PRG062_D7E2)	; $31
	.byte LOW(PRG062_D7E7)	; $32
	.byte LOW(PRG062_D7EC)	; $33
	.byte LOW(PRG062_D7F1)	; $34
	.byte LOW(PRG062_D7F4)	; $35
	.byte LOW(PRG062_D7F7)	; $36
	.byte LOW(PRG062_D7FA)	; $37
	.byte LOW(PRG062_D7FD)	; $38
	.byte LOW(PRG062_D800)	; $39
	.byte LOW(PRG062_D805)	; $3A
	.byte LOW(PRG062_TDetWallOffSpread_L)	; $3B (UNUSED)
	.byte LOW(PRG062_TDetWallOffSpread_L)	; $3C (UNUSED)
	.byte LOW(PRG062_TDetWallOffSpread_L)	; $3D (UNUSED)
	.byte LOW(PRG062_TDetWallOffSpread_L)	; $3E (UNUSED)
	.byte LOW(PRG062_TDetWallOffSpread_L)	; $3F (UNUSED)



PRG062_TDetFloorOffSpread_H:	; $D6DE
	.byte HIGH(PRG062_D71E)	; $00
	.byte HIGH(PRG062_D723)	; $01
	.byte HIGH(PRG062_D727)	; $02
	.byte HIGH(PRG062_D72A)	; $03
	.byte HIGH(PRG062_D72F)	; $04
	.byte HIGH(PRG062_D734)	; $05
	.byte HIGH(PRG062_D739)	; $06
	.byte HIGH(PRG062_D73E)	; $07
	.byte HIGH(PRG062_D743)	; $08
	.byte HIGH(PRG062_D73E)	; $09
	.byte HIGH(PRG062_D748)	; $0A
	.byte HIGH(PRG062_D73E)	; $0B
	.byte HIGH(PRG062_D74D)	; $0C
	.byte HIGH(PRG062_D752)	; $0D
	.byte HIGH(PRG062_D757)	; $0E
	.byte HIGH(PRG062_D75B)	; $0F
	.byte HIGH(PRG062_D75F)	; $10
	.byte HIGH(PRG062_D727)	; $11
	.byte HIGH(PRG062_D727)	; $12
	.byte HIGH(PRG062_D762)	; $13
	.byte HIGH(PRG062_D767)	; $14
	.byte HIGH(PRG062_D76A)	; $15
	.byte HIGH(PRG062_D76F)	; $16
	.byte HIGH(PRG062_D773)	; $17
	.byte HIGH(PRG062_D777)	; $18
	.byte HIGH(PRG062_D77C)	; $19
	.byte HIGH(PRG062_D781)	; $1A
	.byte HIGH(PRG062_D786)	; $1B
	.byte HIGH(PRG062_D78B)	; $1C
	.byte HIGH(PRG062_D78F)	; $1D
	.byte HIGH(PRG062_D793)	; $1E
	.byte HIGH(PRG062_D797)	; $1F
	.byte HIGH(PRG062_D79B)	; $20
	.byte HIGH(PRG062_D79F)	; $21
	.byte HIGH(PRG062_D7A4)	; $22
	.byte HIGH(PRG062_D727)	; $23
	.byte HIGH(PRG062_D7A9)	; $24
	.byte HIGH(PRG062_D7AC)	; $25
	.byte HIGH(PRG062_D7B0)	; $26
	.byte HIGH(PRG062_D7B5)	; $27
	.byte HIGH(PRG062_D7BA)	; $28
	.byte HIGH(PRG062_D7BE)	; $29
	.byte HIGH(PRG062_D7C2)	; $2A
	.byte HIGH(PRG062_D7C6)	; $2B
	.byte HIGH(PRG062_D7CA)	; $2C
	.byte HIGH(PRG062_D7CE)	; $2D
	.byte HIGH(PRG062_D7D1)	; $2E
	.byte HIGH(PRG062_D7D7)	; $2F
	.byte HIGH(PRG062_D7DD)	; $30
	.byte HIGH(PRG062_D7E2)	; $31
	.byte HIGH(PRG062_D7E7)	; $32
	.byte HIGH(PRG062_D7EC)	; $33
	.byte HIGH(PRG062_D7F1)	; $34
	.byte HIGH(PRG062_D7F4)	; $35
	.byte HIGH(PRG062_D7F7)	; $36
	.byte HIGH(PRG062_D7FA)	; $37
	.byte HIGH(PRG062_D7FD)	; $38
	.byte HIGH(PRG062_D800)	; $39
	.byte HIGH(PRG062_D805)	; $3A
	.byte HIGH(PRG062_TDetWallOffSpread_L)	; $3B (UNUSED)
	.byte HIGH(PRG062_TDetWallOffSpread_L)	; $3C (UNUSED)
	.byte HIGH(PRG062_TDetWallOffSpread_L)	; $3D (UNUSED)
	.byte HIGH(PRG062_TDetWallOffSpread_L)	; $3E (UNUSED)
	.byte HIGH(PRG062_TDetWallOffSpread_L)	; $3F (UNUSED)


	; This specifies a "spread" of tiles to detect by a Y offset
	; followed by 1 or more X offsets, which the detection routine
	; then decides upon the "greatest effect" (largest attribute
	; value) from across all detected tiles.
	;
	; Data format:
	;	[XOFT][YOFF][XOFF]...[XOFF]
	;
	;	[XOFT]: Total amount of [XOFF] entries, where "0" = just one, "1" = two, etc.
	;	[YOFF]: Applied to object's Y to offset where tile should be detected.
	;	[XOFF]: Applied to object's X to offset where tile should be detected.
	;			There will be ([XOFT]+1) [XOFF] entries
	;			Note that all [XOFF] entries are cumulative (the first is added to
	;			the object X, all additional ones offset from there.)
PRG062_D71E:
	.byte $02, $0C, $F9, $07, $07

PRG062_D723:
	.byte $01, $F7, $F9, $0E

PRG062_D727:
	.byte $00, $00, $00

PRG062_D72A:
	.byte $02, $F2, $F2, $0E, $0E

PRG062_D72F:
	.byte $02, $0A, $F2, $0E, $0E

PRG062_D734:
	.byte $02, $00, $F2, $0E, $0E

PRG062_D739:
	.byte $02, $08, $F5, $0B, $0B

PRG062_D73E:
	.byte $02, $F8, $F5, $0B, $0B

PRG062_D743:
	.byte $02, $0C, $F5, $0B, $0B

PRG062_D748:
	.byte $02, $10, $F5, $0B, $0B

PRG062_D74D:
	.byte $02, $0C, $F5, $0B, $0B

PRG062_D752:
	.byte $02, $F0, $F5, $0B, $0B

PRG062_D757:
	.byte $01, $08, $F9, $0E

PRG062_D75B:
	.byte $01, $F8, $F9, $0E

PRG062_D75F:
	.byte $00, $09, $00

PRG062_D762:
	.byte $02, $14, $F5, $0B, $0B

PRG062_D767:
	.byte $00, $04, $00

PRG062_D76A:
	.byte $02, $00, $F1, $0F, $0F

PRG062_D76F:
	.byte $01, $06, $F9, $0E

PRG062_D773:
	.byte $01, $FA, $F9, $0E

PRG062_D777:
	.byte $02, $08, $F1, $0F, $0F

PRG062_D77C:
	.byte $02, $F8, $F1, $0F, $0F

PRG062_D781:
	.byte $02, $0C, $F1, $0F, $0F

PRG062_D786:
	.byte $02, $FC, $F1, $0F, $0F

PRG062_D78B:
	.byte $01, $24, $F9, $0E

PRG062_D78F:
	.byte $01, $09, $F9, $0E

PRG062_D793:
	.byte $01, $F7, $F9, $0E

PRG062_D797:
	.byte $01, $0A, $F9, $0E

PRG062_D79B:
	.byte $01, $EE, $F9, $0E

PRG062_D79F:
	.byte $02, $05, $F5, $0B, $0B

PRG062_D7A4:
	.byte $02, $FB, $F5, $0B, $0B

PRG062_D7A9:
	.byte $00, $FF, $00

PRG062_D7AC:
	.byte $01, $F0, $F9, $0E

PRG062_D7B0:
	.byte $02, $10, $F7, $09, $09

PRG062_D7B5:
	.byte $02, $F0, $F7, $09, $09

PRG062_D7BA:
	.byte $01, $30, $FA, $0C

PRG062_D7BE:
	.byte $01, $0C, $FA, $0C

PRG062_D7C2:
	.byte $01, $06, $FB, $0A

PRG062_D7C6:
	.byte $01, $FA, $FB, $0A

PRG062_D7CA:
	.byte $01, $F4, $F9, $0E

PRG062_D7CE:
	.byte $00, $08, $00

PRG062_D7D1:
	.byte $03, $10, $E9, $10, $10, $0E

PRG062_D7D7:
	.byte $03, $F0, $E9, $10, $10, $0E

PRG062_D7DD:
	.byte $02, $18, $F1, $0F, $0F

PRG062_D7E2:
	.byte $02, $E8, $F1, $0F, $0F

PRG062_D7E7:
	.byte $02, $1C, $F1, $0F, $0F

PRG062_D7EC:
	.byte $02, $E4, $F1, $0F, $0F

PRG062_D7F1:
	.byte $00, $08, $0E

PRG062_D7F4:
	.byte $00, $F8, $0E

PRG062_D7F7:
	.byte $00, $08, $F2

PRG062_D7FA:
	.byte $00, $F8, $F2

PRG062_D7FD:
	.byte $00, $F7, $00

PRG062_D800:
	.byte $02, $10, $F2, $0E, $0E

PRG062_D805:
	.byte $00, $F4, $00



	; This specifies a "spread" of tiles to detect by an X offset
	; followed by 1 or more Y offsets (vertical line), which the
	; WALL detection routine then decides upon the "greatest 
	; effect" (largest attribute value) from across all detected 
	; tiles to be the deciding overall "wall detected"
PRG062_TDetWallOffSpread_L:	; $D808
	.byte LOW(PRG062_D888)	; $00
	.byte LOW(PRG062_D88D)	; $01
	.byte LOW(PRG062_D892)	; $02
	.byte LOW(PRG062_D892)	; $03
	.byte LOW(PRG062_D897)	; $04
	.byte LOW(PRG062_D89B)	; $05
	.byte LOW(PRG062_D89F)	; $06 Player slide right
	.byte LOW(PRG062_D8A2)	; $07 Player slide left
	.byte LOW(PRG062_D8A5)	; $08
	.byte LOW(PRG062_D8AA)	; $09
	.byte LOW(PRG062_D8AF)	; $0A
	.byte LOW(PRG062_D8B4)	; $0B
	.byte LOW(PRG062_D8B9)	; $0C
	.byte LOW(PRG062_D8BC)	; $0D
	.byte LOW(PRG062_D8BF)	; $0E
	.byte LOW(PRG062_D8C3)	; $0F
	.byte LOW(PRG062_D8C7)	; $10
	.byte LOW(PRG062_D8CC)	; $11
	.byte LOW(PRG062_D8D1)	; $12
	.byte LOW(PRG062_D8D6)	; $13
	.byte LOW(PRG062_D8DB)	; $14
	.byte LOW(PRG062_D8E0)	; $15
	.byte LOW(PRG062_D8E5)	; $16
	.byte LOW(PRG062_D8EA)	; $17
	.byte LOW(PRG062_D8EF)	; $18
	.byte LOW(PRG062_D8F3)	; $19
	.byte LOW(PRG062_D8F7)	; $1A
	.byte LOW(PRG062_D8F7)	; $1B
	.byte LOW(PRG062_D8FA)	; $1C
	.byte LOW(PRG062_D8FE)	; $1D
	.byte LOW(PRG062_D902)	; $1E
	.byte LOW(PRG062_D905)	; $1F
	.byte LOW(PRG062_D908)	; $20
	.byte LOW(PRG062_D90C)	; $21
	.byte LOW(PRG062_D910)	; $22
	.byte LOW(PRG062_D915)	; $23
	.byte LOW(PRG062_D91A)	; $24
	.byte LOW(PRG062_D91E)	; $25
	.byte LOW(PRG062_D922)	; $26
	.byte LOW(PRG062_D926)	; $27
	.byte LOW(PRG062_D92A)	; $28
	.byte LOW(PRG062_D92F)	; $29
	.byte LOW(PRG062_D934)	; $2A
	.byte LOW(PRG062_D939)	; $2B
	.byte LOW(PRG062_D93E)	; $2C
	.byte LOW(PRG062_D941)	; $2D
	.byte LOW(PRG062_D944)	; $2E
	.byte LOW(PRG062_D949)	; $2F
	.byte LOW(PRG062_D94E)	; $30
	.byte LOW(PRG062_D952)	; $31
	.byte LOW(PRG062_D956)	; $32
	.byte LOW(PRG062_D95B)	; $33
	.byte LOW(PRG062_D960)	; $34
	.byte LOW(PRG062_D966)	; $35
	.byte LOW(PRG062_D96C)	; $36
	.byte LOW(PRG062_D970)	; $37
	.byte LOW(PRG062_D974)	; $38
	.byte LOW(PRG062_D979)	; $39
	.byte LOW(PRG062_D97E)	; $3A
	.byte LOW(PRG062_D984)	; $3B
	.byte LOW(PRG062_D98A)	; $3C
	.byte LOW(PRG062_D991)	; $3D
	.byte LOW(PRG062_D998)	; $3E
	.byte LOW(PRG062_D99C)	; $3F



PRG062_TDetWallOffSpread_H:	; $D848
	.byte HIGH(PRG062_D888)	; $00
	.byte HIGH(PRG062_D88D)	; $01
	.byte HIGH(PRG062_D892)	; $02
	.byte HIGH(PRG062_D892)	; $03
	.byte HIGH(PRG062_D897)	; $04
	.byte HIGH(PRG062_D89B)	; $05
	.byte HIGH(PRG062_D89F)	; $06 Player slide right
	.byte HIGH(PRG062_D8A2)	; $07 Player slide left
	.byte HIGH(PRG062_D8A5)	; $08
	.byte HIGH(PRG062_D8AA)	; $09
	.byte HIGH(PRG062_D8AF)	; $0A
	.byte HIGH(PRG062_D8B4)	; $0B
	.byte HIGH(PRG062_D8B9)	; $0C
	.byte HIGH(PRG062_D8BC)	; $0D
	.byte HIGH(PRG062_D8BF)	; $0E
	.byte HIGH(PRG062_D8C3)	; $0F
	.byte HIGH(PRG062_D8C7)	; $10
	.byte HIGH(PRG062_D8CC)	; $11
	.byte HIGH(PRG062_D8D1)	; $12
	.byte HIGH(PRG062_D8D6)	; $13
	.byte HIGH(PRG062_D8DB)	; $14
	.byte HIGH(PRG062_D8E0)	; $15
	.byte HIGH(PRG062_D8E5)	; $16
	.byte HIGH(PRG062_D8EA)	; $17
	.byte HIGH(PRG062_D8EF)	; $18
	.byte HIGH(PRG062_D8F3)	; $19
	.byte HIGH(PRG062_D8F7)	; $1A
	.byte HIGH(PRG062_D8F7)	; $1B
	.byte HIGH(PRG062_D8FA)	; $1C
	.byte HIGH(PRG062_D8FE)	; $1D
	.byte HIGH(PRG062_D902)	; $1E
	.byte HIGH(PRG062_D905)	; $1F
	.byte HIGH(PRG062_D908)	; $20
	.byte HIGH(PRG062_D90C)	; $21
	.byte HIGH(PRG062_D910)	; $22
	.byte HIGH(PRG062_D915)	; $23
	.byte HIGH(PRG062_D91A)	; $24
	.byte HIGH(PRG062_D91E)	; $25
	.byte HIGH(PRG062_D922)	; $26
	.byte HIGH(PRG062_D926)	; $27
	.byte HIGH(PRG062_D92A)	; $28
	.byte HIGH(PRG062_D92F)	; $29
	.byte HIGH(PRG062_D934)	; $2A
	.byte HIGH(PRG062_D939)	; $2B
	.byte HIGH(PRG062_D93E)	; $2C
	.byte HIGH(PRG062_D941)	; $2D
	.byte HIGH(PRG062_D944)	; $2E
	.byte HIGH(PRG062_D949)	; $2F
	.byte HIGH(PRG062_D94E)	; $30
	.byte HIGH(PRG062_D952)	; $31
	.byte HIGH(PRG062_D956)	; $32
	.byte HIGH(PRG062_D95B)	; $33
	.byte HIGH(PRG062_D960)	; $34
	.byte HIGH(PRG062_D966)	; $35
	.byte HIGH(PRG062_D96C)	; $36
	.byte HIGH(PRG062_D970)	; $37
	.byte HIGH(PRG062_D974)	; $38
	.byte HIGH(PRG062_D979)	; $39
	.byte HIGH(PRG062_D97E)	; $3A
	.byte HIGH(PRG062_D984)	; $3B
	.byte HIGH(PRG062_D98A)	; $3C
	.byte HIGH(PRG062_D991)	; $3D
	.byte HIGH(PRG062_D998)	; $3E
	.byte HIGH(PRG062_D99C)	; $3F



	; This specifies a "spread" of tiles to detect by an X offset
	; followed by 1 or more Y offsets, which the detection routine
	; then decides upon the "greatest effect" (largest attribute
	; value) from across all detected tiles.
	;
	; Data format:
	;	[YOFT][XOFF][YOFF]...[YOFF]
	;
	;	[YOFT]: Total amount of [YOFF] entries, where "0" = just one, "1" = two, etc.
	;	[XOFF]: Applied to object's X to offset where tile should be detected.
	;	[YOFF]: Applied to object's Y to offset where tile should be detected.
	;			There will be ([YOFT]+1) [YOFF] entries
	;			Note that all [YOFF] entries are cumulative (the first is added to
	;			the object Y, all additional ones offset from there.)
PRG062_D888:
	.byte $02, $08, $F8, $08, $0B

PRG062_D88D:
	.byte $02, $F8, $F8, $08, $0B

PRG062_D892:
	.byte $02, $00, $F5, $0B, $05

PRG062_D897:
	.byte $01, $0F, $00, $09

PRG062_D89B:
	.byte $01, $F1, $00, $09

PRG062_D89F:
	.byte $00, $0F, $04

PRG062_D8A2:
	.byte $00, $F1, $04

PRG062_D8A5:
	.byte $02, $10, $16, $0F, $0F

PRG062_D8AA:
	.byte $02, $F0, $16, $0F, $0F

PRG062_D8AF:
	.byte $02, $10, $1E, $0F, $0F

PRG062_D8B4:
	.byte $02, $F0, $1E, $0F, $0F

PRG062_D8B9:
	.byte $00, $10, $00

PRG062_D8BC:
	.byte $00, $F0, $00

PRG062_D8BF:
	.byte $01, $0C, $F9, $0E

PRG062_D8C3:
	.byte $01, $F4, $F9, $0E

PRG062_D8C7:
	.byte $02, $0C, $F9, $07, $0B

PRG062_D8CC:
	.byte $02, $F4, $F9, $07, $0B

PRG062_D8D1:
	.byte $02, $0C, $F9, $07, $0F

PRG062_D8D6:
	.byte $02, $F4, $F9, $07, $0F

PRG062_D8DB:
	.byte $02, $0C, $F5, $0B, $0B

PRG062_D8E0:
	.byte $02, $F4, $F5, $0B, $0B

PRG062_D8E5:
	.byte $02, $08, $F1, $0F, $0F

PRG062_D8EA:
	.byte $02, $F8, $F1, $0F, $0F

PRG062_D8EF:
	.byte $01, $08, $F9, $0E

PRG062_D8F3:
	.byte $01, $F8, $F9, $0E

PRG062_D8F7:
	.byte $00, $00, $00

PRG062_D8FA:
	.byte $01, $0C, $F9, $0E

PRG062_D8FE:
	.byte $01, $F4, $F9, $0E

PRG062_D902:
	.byte $00, $04, $00

PRG062_D905:
	.byte $00, $FC, $00

PRG062_D908:
	.byte $01, $08, $FB, $0A

PRG062_D90C:
	.byte $01, $F8, $FB, $0A

PRG062_D910:
	.byte $02, $08, $F7, $09, $07

PRG062_D915:
	.byte $02, $F8, $F7, $09, $07

PRG062_D91A:
	.byte $01, $10, $F9, $0E

PRG062_D91E:
	.byte $01, $F0, $F9, $0E

PRG062_D922:
	.byte $01, $10, $FD, $0E

PRG062_D926:
	.byte $01, $F0, $FD, $0E

PRG062_D92A:
	.byte $02, $0C, $17, $0F, $0F

PRG062_D92F:
	.byte $02, $F4, $17, $0F, $0F

PRG062_D934:
	.byte $02, $08, $F8, $08, $08

PRG062_D939:
	.byte $02, $F8, $F8, $08, $08

PRG062_D93E:
	.byte $00, $0C, $FE

PRG062_D941:
	.byte $00, $F4, $FE

PRG062_D944:
	.byte $02, $0A, $F1, $0F, $0F

PRG062_D949:
	.byte $02, $F6, $F1, $0F, $0F

PRG062_D94E:
	.byte $01, $06, $FB, $0A

PRG062_D952:
	.byte $01, $FA, $FB, $0A

PRG062_D956:
	.byte $02, $0C, $F1, $0F, $0F

PRG062_D95B:
	.byte $02, $F4, $F1, $0F, $0F

PRG062_D960:
	.byte $03, $0C, $EC, $10, $10, $08

PRG062_D966:
	.byte $03, $F4, $EC, $10, $10, $08

PRG062_D96C:
	.byte $01, $14, $F9, $0E

PRG062_D970:
	.byte $01, $EC, $F9, $0E

PRG062_D974:
	.byte $02, $18, $F1, $0F, $0F

PRG062_D979:
	.byte $02, $E8, $F1, $0F, $0F

PRG062_D97E:
	.byte $03, $10, $E9, $10, $10, $0E

PRG062_D984:
	.byte $03, $F0, $E9, $10, $10, $0E

PRG062_D98A:
	.byte $04, $10, $E5, $10, $10, $10, $06

PRG062_D991:
	.byte $04, $F0, $E5, $10, $10, $10, $06

PRG062_D998:
	.byte $01, $00, $FC, $08

PRG062_D99C:
	.byte $00, $00, $05


PRG062_WallR_PopOut:
	; Distance to "pop" out of wall to the right
	LDA <Temp_Var18
	AND #$0F
	STA <Temp_Var18
	
	; Align to wall
	LDA Spr_X+$00,X
	SUB <Temp_Var18
	STA Spr_X+$00,X
	LDA Spr_XHi+$00,X
	SBC #$00
	STA Spr_XHi+$00,X
	
	RTS	; $D9B6


PRG062_WallL_PopOut:
	; Distance to "pop" out of wall to the left
	LDA <Temp_Var18
	AND #$0F
	EOR #$0F
	
	SEC
	ADC Spr_X+$00,X
	STA Spr_X+$00,X
	LDA Spr_XHi+$00,X
	ADC #$00
	STA Spr_XHi+$00,X
	
	RTS	; $D9CC


	; Used for Rush Marine to get pushed beneath water line
PRG062_ObjOffsetYToTileTopRev:
	LDA <Temp_Var17	; Object offset Y
	AND #$0F	; Tile relative
	EOR #$0F	; Invert
	
	; Offset to top of tile
	SEC
	ADC Spr_Y+$00,X
	STA Spr_Y+$00,X
	
	CMP #$F0
	BLT PRG062_D9E6

	ADC #$0F
	STA Spr_Y,X
	
	INC Spr_YHi,X

PRG062_D9E6:
	RTS	; $D9E6


PRG062_ObjOffsetYToTileTop:
	LDA <Temp_Var17	; Object offset Y
	PHA		; Save  it
	
	AND #$0F		; Tile relative
	STA <Temp_Var17	; -> Temp_Var17
	
	LDA Spr_Y+$00,X	
	SUB <Temp_Var17	
	STA Spr_Y+$00,X	; Offset to top of tile
	BCS PRG062_DA01	; If carry set (subtraction didn't overflow), jump to PRG062_DA01

	SBC #$0F
	STA Spr_Y,X
	
	DEC Spr_YHi,X

PRG062_DA01:
	PLA	; Restore object offset Y
	STA <Temp_Var17	; -> Temp_Var17
	
	RTS	; $DA04


	; Based on the input 'X' loads sprite palette data (if applicable)
	; and CHR data to the CHR RAM (see PRG040_PPUUploadTable_L/H)
PRG062_Upl_SprPal_CHRPats:

	; Backup pages at $8000 and $A000
	LDA <MMC3_Page8000_Req
	PHA
	LDA <MMC3_PageA000_Req
	PHA
	
	; Set bank 40 at $A000
	LDA #40
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

	LDA <PPU_CTL1_Copy
	AND #$FE
	STA PPU_CTL1
	
	; Load address of PPU upload data -> Temp_Var2/3
	LDA PRG040_PPUUploadTable_L,X
	STA <Temp_Var2
	LDA PRG040_PPUUploadTable_H,X
	STA <Temp_Var3
	
	LDY #$00
PRG062_DA25:
	LDA [Temp_Var2],Y
	BMI PRG062_DA3A		; If $FF (terminator), jump to PRG062_DA3A

	; Store value into sprite palette 2-3 space
	STA PalData_1+24,Y
	STA PalData_2+24,Y
	
	INY	; Y++ next palette value
	
	CPY #$08
	BNE PRG062_DA25	; If <> 8 (the final possible palette value), loop!

	; Otherwise, forcefully terminate
	
	LDA #$FF
	STA <CommitPal_Flag
	BNE PRG062_DA3B


PRG062_DA3A:
	INY	; Move passed terminating sprite data byte

PRG062_DA3B:

	; Set bank 40 at $A000
	LDA #40
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

	LDA [Temp_Var2],Y
	BMI PRG062_DA82		; If $FF (terminator), jump to PRG062_DA82

	PHA	; Save read byte (bank / bank+1 value)
	
	; Count value (number of 256 byte chunks to read/write)
	INY	; Next byte
	LDA [Temp_Var2],Y
	STA <Temp_Var4		; -> Temp_Var4
	
	; Temp_Var5/6 specifies address of CHR data to read ($xx00)
	INY	; Next byte
	LDA [Temp_Var2],Y
	STA <Temp_Var6	; -> Temp_Var6 (high component of address)
	LDX #$00
	STX <Temp_Var5	; 0 -> Temp_Var5
	
	INY	; Next byte
	
	LDA PPU_STAT

	; Set VRAM start address
	LDA [Temp_Var2],Y
	STA PPU_VRAM_ADDR	; VRAM high
	STX PPU_VRAM_ADDR	; Always $00
	
	STY <Temp_Var7	; Backup current offset -> Temp_Var7
	
	PLA	; Restore initial read value
	STA <MMC3_Page8000_Req	; bank at $8000 set to Temp_Var7
	STA <MMC3_PageA000_Req
	INC <MMC3_PageA000_Req	; bank at $A000 to Temp_Var7 + 1
	JSR PRG063_SetPRGBanks	; Set banks!


PRG062_DA6D:
	LDY #$00

PRG062_DA6F:
	; Copy VRAM byte from the new bank data
	LDA [Temp_Var5],Y
	STA PPU_VRAM_DATA
	
	INY	; Next byte
	BNE PRG062_DA6F	; If didn't overflow address, loop to PRG062_DA6F

	INC <Temp_Var6	; Increment high part of address
	
	DEC <Temp_Var4	; Temp_Var4-- (one less 256 chunk to do)
	BNE PRG062_DA6D	; If Temp_Var4 > 0, loop to PRG062_DA6D

	LDY <Temp_Var7	; Restore previous offset
	
	INY	; Move passed last read byte in bank 40 stream
	BNE PRG062_DA3B	; Continue reading from bank 40 stream...


PRG062_DA82:

	; Restore previous banks and we're outta here!
	PLA
	STA <MMC3_PageA000_Req
	PLA
	STA <MMC3_Page8000_Req
	JMP PRG063_SetPRGBanks


	; Loads the sprite palette data segment for a dynamic CHR RAM upload
	; and preps for the continuation call to PRG062_CHRRAMDynLoadCHRSeg
	; (see PRG041_B800)
PRG062_CHRRAMDynLoadPalSeg:
	STA <CHRRAMDL_LastPalLoad	; $DA8B
	TAY	; $DA8D
	
	; Set page 41 at $A000
	LDA #41
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

	; Load pointer to select palette data
	LDA PRG041_B800_L,Y
	STA <CHRRAMDLPtr_L
	LDA PRG041_B800_H,Y
	STA <CHRRAMDLPtr_H
	
	LDY #$00		; Y = 0
	STY <CHRRAMDL_LastPalIndex	; CHRRAMDL_LastPalIndex = 0
	STY <CHRRAMDL_GBufDataLen	; CHRRAMDL_GBufDataLen = 0

PRG062_DAA5:
	INC <CHRRAMDL_LastPalIndex	; CHRRAMDL_LastPalIndex++
	
	LDA [CHRRAMDLPtr_L],Y	; Load next palette byte
	BMI PRG062_DABA	; If terminator, jump to PRG062_DABA (RTS)

	; Store palette into sprite area
	STA PalData_1+24,Y
	STA PalData_2+24,Y
	
	INY	; Y++
	CPY #$08
	BNE PRG062_DAA5	; While Y <> 8, loop

	; Commit palette change
	LDA #$FF	; $DAB6
	STA <CommitPal_Flag	; $DAB8

PRG062_DABA:
	RTS	; $DABA


	; WARNING: Prerequisite call to PRG062_CHRRAMDynLoadPalSeg required so CHRRAMDLPtr_L is valid!!
	; Loads the next CHR RAM data segment for a dynamic CHR RAM upload
	; (see PRG041_B800)
PRG062_CHRRAMDynLoadCHRSeg:
	LDA <CommitGBuf_Flag
	ORA <CommitGBuf_FlagV
	BNE PRG062_DB39	; If commit pending, jump to PRG062_DB39 (RTS)

	LDA <CHRRAMDL_GBufDataLen
	BNE PRG062_DAEC	; If CHRRAMDL_GBufDataLen is non-zero, jump to PRG062_DAEC

	; Set page 41 @ $A000
	LDA #41
	STA <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

	LDY <CHRRAMDL_LastPalIndex	; Y = last palette index (continue palette load)
	
	; Bank to load graphics from
	LDA [CHRRAMDLPtr_L],Y
	BMI PRG062_DB39	; If this is the terminator, jump to PRG062_DB39 (RTS)
	
	STA <CHRRAMDL_BankLoadFrom	; -> CHRRAMDL_BankLoadFrom

	INY	; Y++	
	
	; Length of data to load (divided by 16)
	LDA [CHRRAMDLPtr_L],Y	; Next byte
	STA <CHRRAMDL_GBufDataLen	; -> CHRRAMDL_GBufDataLen
	 
	INY	; Y++

	; Low component of addresses are implicity $00
	LDA #$00
	STA <CHRRAMDL_GBufDataSrcAddrL	; CHRRAMDL_GBufDataSrcAddrL = 0
	STA <CHRRAMDL_GBufVRAML			; CHRRAMDL_GBufVRAML = 0
	
	; High component of source ROM address
	LDA [CHRRAMDLPtr_L],Y
	STA <CHRRAMDL_GBufDataSrcAddrH	; -> CHRRAMDL_GBufDataSrcAddrH
	
	INY	; Y++
	
	; High component of target PPU VRAM address
	LDA [CHRRAMDLPtr_L],Y
	STA <CHRRAMDL_GBufVRAMH	; -> CHRRAMDL_GBufVRAMH
	
	INY	; Y++
	
	STY <CHRRAMDL_LastPalIndex	; Store this index if continuation required

PRG062_DAEC:
	; Graphics buffer PPU VRAM target
	LDA <CHRRAMDL_GBufVRAMH
	STA Graphics_Buffer+$00
	LDA <CHRRAMDL_GBufVRAML
	STA Graphics_Buffer+$01
	
	; Set banks to load graphics from
	LDA <CHRRAMDL_BankLoadFrom
	STA <MMC3_Page8000_Req
	STA <MMC3_PageA000_Req
	INC <MMC3_PageA000_Req
	JSR PRG063_SetPRGBanks

	; Copy 16 bytes
	LDY #$00	; Y = 0
PRG062_DB03:
	LDA [CHRRAMDL_GBufDataSrcAddrL],Y
	STA Graphics_Buffer+$03,Y
	INY
	TYA
	AND #$0F
	BNE PRG062_DB03

	
	DEC <CHRRAMDL_GBufDataLen	; CHRRAMDL_GBufDataLen--
	BEQ PRG062_DB16		; If no more data to load, jump to PRG062_DB16

	CPY #$30
	BNE PRG062_DB03	; If Y <> $30, loop


PRG062_DB16:
	
	; Terminate buffer
	LDA #$FF
	STA Graphics_Buffer+$03,Y
	
	; Update source address for next round
	TYA		; Graphics buffer index -> 'A'
	ADD <CHRRAMDL_GBufDataSrcAddrL
	STA <CHRRAMDL_GBufDataSrcAddrL
	LDA <CHRRAMDL_GBufDataSrcAddrH
	ADC #$00
	STA <CHRRAMDL_GBufDataSrcAddrH
	
	; Update destination address for next round
	TYA		; Graphics buffer index -> 'A'
	ADD <CHRRAMDL_GBufVRAML
	STA <CHRRAMDL_GBufVRAML
	LDA <CHRRAMDL_GBufVRAMH
	ADC #$00
	STA <CHRRAMDL_GBufVRAMH
	
	DEY	; Y--
	STY Graphics_Buffer+$02	; $DB34
	STY <CommitGBuf_Flag	; $DB37

PRG062_DB39:
	RTS	; $DB39


	; Don't call this directly, use PRG063_DrawSprites
PRG062_DoDrawSprites:
	JSR PRG062_DrawToadRain	; $DB3A

	INC <General_Counter	; $DB3D
	LDA <General_Counter	; $DB3F
	LSR A	; $DB41
	BCS PRG062_DB5C	; $DB42

	JSR PRG062_DEE2	; $DB44

	LDX #$00
	STX <Spr_SlotIndex
PRG062_DB4B:
	LDA Spr_SlotID+$00,X
	BEQ PRG062_DB53		; If sprite overlay slot is empty, jump to PRG062_DB53

	; Process sprite overlay slot...
	JSR PRG062_DB72	; $DB50


PRG062_DB53:
	INC <Spr_SlotIndex
	LDX <Spr_SlotIndex
	CPX #$18
	BNE PRG062_DB4B	; While Spr_SlotIndex < $18, loop!

	RTS	; $DB5B


PRG062_DB5C:
	LDX #$17	; $DB5C
	STX <Spr_SlotIndex	; $DB5E

PRG062_DB60:
	LDA Spr_SlotID+$00,X	; $DB60
	BEQ PRG062_DB68	; $DB63

	JSR PRG062_DB72	; $DB65


PRG062_DB68:
	DEC <Spr_SlotIndex	; $DB68
	LDX <Spr_SlotIndex	; $DB6A
	BPL PRG062_DB60	; $DB6C

	JSR PRG062_DEF2	; $DB6E

	RTS	; $DB71


PRG062_DB72:
	LDA Spr_Flags+$00,X
	AND #SPRFL1_SCREENREL
	BNE PRG062_DB7C		; If object is not screen relative, jump to PRG062_DB7C

	; If Spr_Flags bit $10 is NOT set (sprite should not be offset by scroll), jump to PRG062_DC50
	JMP PRG062_DC50	; $DB79


PRG062_DB7C:

	; Spr_Flags bit $10 is set (sprite should be offset by scroll)

	; Sprite X -> Temp_Var19 and Temp_Var0
	LDA Spr_X+$00,X
	SUB <Horz_Scroll
	STA <Temp_Var19
	STA <Temp_Var0
	
	; Sprite X Hi -> Temp_Var1
	LDA Spr_XHi+$00,X
	SBC <Current_Screen
	STA <Temp_Var1
	BEQ PRG062_DBC7		; If sprite is definitely on-screen, jump to PRG062_DBC7

	LDA Spr_Flags+$00,X
	AND #SPRFL1_PERSIST
	BEQ PRG062_DBDA	; If Spr_Flags bit 2 ($08) is not set, jump to PRG062_DBDA
	
	; Spr_Flags bit 2 ($08) is set, makes object persist even if it goes off-screen
	
	; Correction for off-screen object
	BCS PRG062_DBA0

	LDA <Temp_Var19
	EOR #$FF
	ADC #$01
	STA <Temp_Var0	; Negative sprite X -> Temp_Var0

PRG062_DBA0:

	LDA Spr_SlotID+$00,X
	CMP #SPRSLOTID_RMRAINBOW_CTL1
	BLT PRG062_DBBE			; If sprite slot ID < SPRSLOTID_RMRAINBOW_CTL1, jump to PRG062_DBBE

	CMP #SPRSLOTID_SUBBOSS_KABATONCUE
	BGE PRG062_DBBE			; If sprite slot ID >= SPRSLOTID_SUBBOSS_KABATONCUE, jump to PRG062_DBBE

	; HACK: All Ring Man rainbow controllers here

	LDA <Temp_Var1
	BPL PRG062_DBB3

	; Negate
	EOR #$FF
	ADC #$01

PRG062_DBB3:
	CMP #$02
	BLT PRG062_DBC4

	LDA Spr_FaceDir+$00,X
	BNE PRG062_DBC4	; If the controller is busy, jump to PRG062_DBC4 (PRG062_DC45)

	BEQ PRG062_DBDA	; Otherwise, jump to PRG062_DBDA


PRG062_DBBE:
	LDA <Temp_Var0	; $DBBE
	CMP #$30	; $DBC0
	BGE PRG062_DBDA	; $DBC2


PRG062_DBC4:
	JMP PRG062_DC45	; Jump to PRG062_DC45


PRG062_DBC7:
	LDA Spr_YHi+$00,X
	BEQ PRG062_DBD7	; If object is not vertically off-screen, jump to PRG062_DBD7

	CPX #$00
	BEQ PRG062_DC14	; If this is the Player object, jump to PRG062_DC14

	; Player only...

	LDA Spr_YHi+$00,X
	BMI PRG062_DBC4	; If off top of screen, jump to PRG062_DBC4 (PRG062_DC45)

	BPL PRG062_DBDA	; If off bottom of screen, jump to PRG062_DBDA (will be deleted unless excepted...)


PRG062_DBD7:
	JMP PRG062_DC55	; Jump to PRG062_DC55


PRG062_DBDA:
	; Object is about to be deleted unless it meets one of the following...

	LDA Spr_CurrentAnim+$00,X
	CMP #SPRANM4_WHOPPER_RING	; HACK: Any object using animation $55, but this is PROBABLY what was intended here
	BEQ PRG062_DC45

	CMP #SPRANM4_DRILLMAN_SWITCH	; HACK: Any object using animation $71, but this is PROBABLY what was intended here
	BEQ PRG062_DC45	

	; Some objects which are excepted and forced persistence
	LDA Spr_SlotID+$00,X
	CMP #SPRSLOTID_RINGMAN_UNK2
	BEQ PRG062_DC45

	CMP #SPRSLOTID_SQUAREMACH_PLATFORM
	BEQ PRG062_DC45

	CMP #SPRSLOTID_COSSACK2_UNK2
	BEQ PRG062_DC45

	CMP #SPRSLOTID_WILY3_UNK1
	BEQ PRG062_DC45

	CMP #SPRSLOTID_BOSS_WILYMACHINE4
	BEQ PRG062_DC45

	CMP #SPRSLOTID_WILYCAPSULE_CHRG
	BEQ PRG062_DC45


PRG062_ResetSpriteSlot:
	LDA #$00
	STA Spr_CodePtrH+$00,X
	STA Spr_SlotID+$00,X	
	STA Spr_FlashOrPauseCnt,X
	STA Spr_HP+$00,X
	
	; Remove parentage
	LDA #$FF
	STA Spr_SpawnParentIdx,X
	
	RTS	; $DC13


PRG062_DC14:
	LDA Spr_YHi+$00,X
	BMI PRG062_DC45	; If above top of screen, jump to PRG062_DC45

	LDA #PLAYERSTATE_DEAD
	CMP <Player_State
	BEQ PRG062_DC45	; If Player is already dead, jump to PRG062_DC45

	; Set dead state
	STA <Player_State
	
	LDA #$00
	STA <Player_FreezePlayerTicks
	
	
	; Player died in pit!
	
	LDA #MUS_STOPMUSIC
	JSR PRG063_QueueMusSnd_SetMus_Cur

	LDA #SFX_ROBOTDEATH
	JSR PRG063_QueueMusSnd

	LDA #$2C
	STA Level_ExitTimeout	
	LDA #$01
	STA Level_ExitTimeoutH
	
	BNE PRG062_DC45	; Jump (technically always) to PRG062_DC45

	; Unused code, can't ever get here -- this is possibly leftover debug code
	; that allowed you to jump out of pits in MM3
	LDA #$00
	STA Spr_YVelFrac+$00
	LDA #$0C
	STA Spr_YVel+$00


PRG062_DC45:
	; Object is not on-screen!
	LDA Spr_Flags+$00,X
	AND #~SPRFL1_ONSCREEN
	STA Spr_Flags+$00,X
	
	JMP PRG062_DC67	; Jump to PRG062_DC67


PRG062_DC50:
	; Sprite is not offset by scroll; X/Y taken literally

	LDA Spr_X+$00,X
	STA <Temp_Var19		; X -> Temp_Var19

PRG062_DC55:
	LDA Spr_Y+$00,X
	STA <Temp_Var18		; Y -> Temp_Var18
	
	; Object is on-screen!
	LDA Spr_Flags+$00,X
	ORA #SPRFL1_ONSCREEN
	STA Spr_Flags+$00,X
	
	AND #SPRFL1_NODRAW
	BEQ PRG062_DC67	; If not set to not draw, jump to PRG062_DC67

	; Otherwise we quit now...

PRG062_DC66:
	RTS	; $DC66


PRG062_DC67:
	; Install the banks for this sprite
	LDY Spr_SlotID+$00,X
	
	LDA PRG062_Spr_Bank,Y
	CMP <MMC3_PageA000_Req
	BEQ PRG062_DC7A	; ... unless the banks are already set, in which case, jump to PRG062_DC7A

	STA <MMC3_PageA000_Req	; $DC71
	STA <MMC3_Page8000_Req	; $DC73
	DEC <MMC3_Page8000_Req	; $DC75
	JSR PRG063_SetPRGBanks	; $DC77


PRG062_DC7A:
	
	; Y = 0 (if not h-flipped)
	LDY #$00
	
	LDA Spr_Flags+$00,X
	AND #SPR_HFLIP
	STA <Temp_Var16		; Temp_Var16 holds bit $40
	
	BEQ PRG062_DC86

	INY	; Y = 1	(if h-flipped)

PRG062_DC86:
	STY <Temp_Var17	; Temp_Var17 = 0 or 1
	
	LDY Spr_CurrentAnim+$00,X
	BEQ PRG062_DC66	; If sprite subtype ID = 0, jump to PRG062_DC66 (RTS)

	; Get address to sprite data
	LDA Sprite_AnimScriptTable,Y
	STA <Temp_Var0
	LDA Sprite_AnimScriptTable+$100,Y
	STA <Temp_Var1
	
	LDY #$00	; Y = 0
	
	LDA [Temp_Var0],Y
	STA <Temp_Var2	; -> Temp_Var2 (most importantly, storing the status of bit $80, whether to use "primary" or "secondary" frame definition sets)
	
	; Maximum frame for current animation
	AND #$7F
	STA <Temp_Var3	; Only lower 7 bits -> Temp_Var3
	
	; NOTE: This will never happen because its usage is contained to PRG059,
	; maybe left over from some earlier development?
	LDA <Player_EnergyGainCounter
	BNE PRG062_DCE2	; If Player_EnergyGainCounter <> 0, jump to PRG062_DCE2

	LDA Spr_FlashOrPauseCnt,X
	BEQ PRG062_DCB7	; If Spr_FlashOrPauseCnt = 0, jump to PRG062_DCB7

	DEC Spr_FlashOrPauseCnt,X	; Otherwise, decrement it
	
	; Since Spr_FlashOrPauseCnt operates in two modes (with or without bit $80 set),
	; check for zero irrespective of bit $80...
	LDA Spr_FlashOrPauseCnt,X
	AND #$7F
	BNE PRG062_DCB7	; If Spr_FlashOrPauseCnt hasn't reached zero yet, jump to PRG062_DCB7

	; Otherwise, zero it out (taking care of bit $80 case)
	STA Spr_FlashOrPauseCnt,X

PRG062_DCB7:

	LDA Spr_FlashOrPauseCnt,X
	BMI PRG062_DCE2	; If in pause mode, jump to PRG062_DCE2

	; Sprite is not in pause mode...

	LDA Spr_AnimTicks+$00,X
	AND #$7F	; Ignoring bit $80
	
	INC Spr_AnimTicks+$00,X	; Next anim tick
	
	INY	; Y++
	CMP [Temp_Var0],Y	; Have we reached the anim tick limit for the frame?
	BNE PRG062_DCE2	; If not, jump to PRG062_DCE2

	; Reached the anim tick limit...

	; Preserving bit $80, zeroing out otherwise
	LDA Spr_AnimTicks+$00,X
	AND #$80
	STA Spr_AnimTicks+$00,X
	
	LDA Spr_Frame+$00,X
	AND #$7F	; Ignoring bit $80
	
	INC Spr_Frame+$00,X	; Next animation frame
	
	CMP <Temp_Var3	; Have we reached the maximum frame for this animation?
	BNE PRG062_DCE2	; If not, jump to PRG062_DCE2

	; Reached the last frame of the animation...

	; Back to frame zero
	LDA #$00
	STA Spr_Frame+$00,X

PRG062_DCE2:
	LDA Spr_Flags+$00,X
	BPL PRG062_DD48	; If object is not on-screen, jump to PRG062_DD48 (RTS)

	CPX Boss_SprIndex
	BNE PRG062_DD16	; If not the active boss, jump to PRG062_DD16

	; Currently referencing a boss character...

	LDA HUDBarB_DispSetting
	BPL PRG062_DD16	; If boss energy meter is not being displayed, jump to PRG062_DD16

	JSR PRG062_CopyPal2To1_Commit

	LDA Spr_FlashOrPauseCnt,X
	BEQ PRG062_DD30	; If boss not hit, jump to PRG062_DD30
	BMI PRG062_DD30	; If boss halted, jump to PRG062_DD30
	
	; Boss has been hit

	LSR A
	LSR A
	BCC PRG062_DD30	; Every other 4 ticks, jump to PRG062_DD30

	LDY <TileMap_Index	; Y = TileMap_Index
	
	LDA PRG062_FrDefTblIdxForBossHit,Y
	BEQ PRG062_DD10	; If PRG062_FrDefTblIdxForBossHit = 0, jump to PRG062_DD10

	CPY #TMAP_WILY3
	BNE PRG062_DD6E	; If not Wily 3, jump to PRG062_DD6E

	LDY <Current_Screen
	CPY #$0B
	BNE PRG062_DD6E	; If not screen $0B, jump to PRG062_DD6E

	; Wily 3, screen $0B...

PRG062_DD10:
	JSR PRG062_BossHitFlashSprPal

	JMP PRG062_DD30	; Jump to PRG062_DD30


PRG062_DD16:
	; Not active boss or boss meter not displayed (i.e. meant to mean "no boss is active")

	LDA Spr_FlashOrPauseCnt,X
	BEQ PRG062_DD30	; If object not hit, jump to PRG062_DD30
	BMI PRG062_DD30	; If object is halted, jump to PRG062_DD30
	
	; Object has been hit...

	LDY Spr_SlotID+$00,X
	CPY #SPRSLOTID_SUBBOSS_KABATONCUE
	BEQ PRG062_DD49	; If this is Kabatoncue, jump to PRG062_DD49

	CPY #SPRSLOTID_SUBBOSS_ESCAROO
	BEQ PRG062_DD50	; If this is Escaroo, jump to PRG062_DD50

	CPY #SPRSLOTID_SUBBOSS_MOBY
	BEQ PRG062_DD57	; If this is Moby, jump to PRG062_DD57

	LSR A
	LSR A
	BCS PRG062_DD48	; Every other 4 ticks, jump to PRG062_DD48


PRG062_DD30:
	LDA Spr_Frame+$00,X
	AND #$7F	; Ignore bit $80
	ADD #$02	; +2 since the first two bytes are the total frame count and frame delay
	TAY			; Frame index -> 'Y'
	
	LDA [Temp_Var0],Y	; Fetch sprite frame
	BNE PRG062_DD6E		; If non-zero, jump to PRG062_DD6E

	; If sprite frame was zero, zero out the slot (sprite is gone)

	STA Spr_CodePtrH+$00,X
	STA Spr_SlotID+$00,X
	
	; Remove parentage
	LDA #$FF
	STA Spr_SpawnParentIdx,X

PRG062_DD48:
	RTS	; $DD48


PRG062_DD49:
	; Kabatoncue...

	LDY #$03	; $DD49
	LDA #$03	; $DD4B
	JMP PRG062_DE8D	; Jump to PRG062_DE8D


PRG062_DD50:
	; Escaroo...

	LDY #$0B	; $DD50
	LDA #$07	; $DD52
	JMP PRG062_DE8D	; Jump to PRG062_DE8D


PRG062_DD57:
	; Moby...

	LDY #$0F	; $DD57
	LDA #$07	; $DD59
	JMP PRG062_DE8D	; Jump to PRG062_DE8D


PRG062_FrDefTblIdxForBossHit:
	; TileMap_Index
	.byte $DF	; $00 Bright Man
	.byte $DF	; $01 Toad Man
	.byte $DF	; $02 Drill Man
	.byte $DF	; $03 Pharaoh Man
	.byte $DF	; $04 Ring Man
	.byte $DF	; $05 Dust Man
	.byte $DF	; $06 Dive Man
	.byte $DF	; $07 Skull Man
	.byte $00	; $08 Cossack 1
	.byte $00	; $09 Cossack 2
	.byte $DF	; $0A Cossack 3
	.byte $00	; $0B Cossack 4
	.byte $00	; $0C Wily 1
	.byte $00	; $0D Wily 2
	.byte $DF	; $0E Wily 3
	.byte $8B	; $0F Wily 4



PRG062_DD6E:
	TAY	; Current animation frame -> 'Y'
	
	LDA <Temp_Var2
	BMI PRG062_DD80	; If bit $80 was set on the animation script's total frame count, use "SECONDARY" frame definition set, jump to PRG062_DD80

	; Bit $80 was not set, use PRIMARY frame definition set
	LDA Sprite_FrameDefTable1,Y
	STA <Temp_Var2
	LDA Sprite_FrameDefTable1+$200,Y
	STA <Temp_Var3
	
	JMP PRG062_DD8A


PRG062_DD80:

	; Bit $80 was set, use SECONDARY frame definition set
	LDA Sprite_FrameDefTable2,Y
	STA <Temp_Var2
	LDA Sprite_FrameDefTable2+$200,Y
	STA <Temp_Var3

PRG062_DD8A:

	; Temp_Var0 = 0
	LDY #$00
	STY <Temp_Var0
	
	LDA Spr_SlotID+$00,X
	STA <Temp_Var1	; Slot ID -> Temp_Var1
	
	CMP #SPRSLOTID_WIREADAPTER
	BNE PRG062_DD9C	; If slot ID <> SPRSLOTID_WIREADAPTER, jump to PRG062_DD9C

	; For Wire Adapter only...

	; Temp_Var0 = Spr_Var1+$00
	LDA Spr_Var1+$00,X
	STA <Temp_Var0

PRG062_DD9C:

	; Now it's time to break down the sprite frame definition...

	; Count of hardware sprites to add
	LDA [Temp_Var2],Y
	STA <Temp_Var4
	
	INY	; Y++ (next byte)
	
	LDA [Temp_Var2],Y	; Get index into Sprite_YXOffsetTable
	ADD <Temp_Var17	; Add 1 if Spr_Flags had bit $40 set (horizontal flip)
	PHA	; Save this
	
	LDA Spr_Flags+$00,X
	AND #SPR_BEHINDBG
	STA <Temp_Var17		; Temp_Var17 = SPR_BEHINDBG or $00 (persists "behind BG" priority bit)
	
	PLA	; Restore index into Sprite_YXOffsetTable
	TAX	; -> 'X'
	
	; Set fetched address minus 2 -> Temp_Var5/6
	; (Minus 2 is just so it lines up with where index 'Y' is at)
	LDA Sprite_YXOffsetTable,X
	SUB #$02
	STA <Temp_Var5	
	LDA Sprite_YXOffsetTable+$100,X
	SBC #$00
	STA <Temp_Var6
	
	
	LDX <Sprite_CurrentIndex
	BEQ PRG062_DE41	; If Sprite_CurrentIndex = 0 we're out of sprites, jump to PRG062_DE41 (RTS)

	; Sprite loop...
PRG062_DDC3:
	INY	; Y++
	
	LDA [Temp_Var2],Y	; Gettern PATTERN
	STA Sprite_RAM+$01,X	; Store into sprite pattern
	
	LDA <Temp_Var0	; Note: Always zero unless this is sprite slot SPRSLOTID_UNK0B, in which case it equates to Spr_Var1+$00
	BEQ PRG062_DDE9	; If Temp_Var0 = 0, jump to PRG062_DDE9

	; Temp_Var0 is not zero...

	LDA <Temp_Var18		; Sprite master Y
	ADD [Temp_Var5],Y	; Add Y offset
	STA Sprite_RAM+$00,X	; Store into sprite Y
	BCS PRG062_DDE1	; If carry occurred, jump to PRG062_DDE1

	CMP #$F8
	BGE PRG062_DE42	; If sprite Y = $F8, jump to PRG062_DE42 (drop sprite)

	CMP <Temp_Var0
	BGE PRG062_DE42	; If sprite Y >= Temp_Var0, jump to PRG062_DE42 (drop sprite)
	BLT PRG062_DDFB	; Otherwise, jump to PRG062_DDFB


PRG062_DDE1:
	LDA [Temp_Var5],Y
	CMP #$C0
	BGE PRG062_DDFB	; If Y offset >= $C0, jump to PRG062_DDFB
	BLT PRG062_DE42	; Otherwise, jump to jump to PRG062_DE42 (drop sprite)


PRG062_DDE9:
	; Most normal sprite draws enter here...

	LDA <Temp_Var18		; Sprite Y
	ADD [Temp_Var5],Y	; Add Y offset
	STA Sprite_RAM+$00,X	; Store into sprite Y
	
	LDA [Temp_Var5],Y
	BMI PRG062_DDF9		; If the Y offset is negative, jump to PRG062_DDF9

	; Not a negative offset...

	BCC PRG062_DDFB	; If a carry did not occur, jump to PRG062_DDFB (continue)
	BCS PRG062_DE42	; If a carry occurred, sprite is too low; jump to PRG062_DE42 (drop sprite)


PRG062_DDF9:
	; Negative offset

	BCC PRG062_DE42	; Carry clear (inverse bad case); jump to PRG062_DE42 (drop sprite)


PRG062_DDFB:
	LDA <Temp_Var1			; Sprite slot ID
	CMP #SPRSLOTID_COSSACK1_UNK1
	BNE PRG062_DE0C			; If this is not slot ID SPRSLOTID_COSSACK1_UNK1, jump to PRG062_DE0C

	; SPRSLOTID_COSSACK1_UNK1 only...

	LDA Spr_Y+$17
	ADD #$03
	CMP Sprite_RAM+$00,X
	BGE PRG062_DE42			; If sprite is 3 pixels higher ?? FIXME ?? jump to PRG062_DE42 (drop sprite)


PRG062_DE0C:
	INY	; Y++ (next byte)
	
	LDA <Object_ReqBGSwitch	; $DE0D
	BEQ PRG062_DE1A	; $DE0F

	CMP Sprite_RAM+$00,X	; $DE11
	BGE PRG062_DE1A	; $DE14

	; Set sprite behind BG
	LDA #$20
	STA <Temp_Var17

PRG062_DE1A:
	
	LDA [Temp_Var2],Y	; Get ATTRibute
	EOR <Temp_Var16		; Set horizontal flip bit opposite whatever sprite stream is specifying
	ORA <Temp_Var17		; Set priority ("behind BG") bit as appropriate from sprite flags
	STA Sprite_RAM+$02,X	; Store into sprite attributes
	
	LDA <Temp_Var19		; Sprite X
	ADD [Temp_Var5],Y	; Add X offset
	STA Sprite_RAM+$03,X	; Store into sprite X
	
	LDA [Temp_Var5],Y
	BMI PRG062_DE33	; If X offset is negative, jump to PRG062_DE33

	; X offset not negative...

	BCC PRG062_DE35	; If carry clear, jump to PRG062_DE35 (continue)
	BCS PRG062_DE43	; Otherwise sprite wrapped; jump to PRG062_DE42 (drop sprite)


PRG062_DE33:

	; X offset is negative (inverse bad case)

	BCC PRG062_DE43	; If carry clear, sprite wrapped; jump to PRG062_DE42 (drop sprite)


PRG062_DE35:
	
	; X += 4 (next sprite)
	INX
	INX
	INX
	INX
	STX <Sprite_CurrentIndex
	BEQ PRG062_DE41	; If we hit zero, we're out of sprites, jump to PRG062_DE41 (RTS)


PRG062_DE3D:
	DEC <Temp_Var4	; Temp_Var4--
	BPL PRG062_DDC3	; While Temp_Var4 > 0, loop! (More hardware sprites to go)


PRG062_DE41:
	RTS	; $DE41


PRG062_DE42:
	INY	; Y++

PRG062_DE43:
	LDA #$F8
	STA Sprite_RAM+$00,X
	BNE PRG062_DE3D	; Jump (technically always) to PRG062_DE3D (dropping this sprite, and loop if more to go)

	; Copy PalData_2 -> PalData_1 and commit it
PRG062_CopyPal2To1_Commit:

	LDY #$03	; Y = 3
PRG062_DE4C:
	LDA PalData_2+4,Y
	STA PalData_1+4,Y
	LDA PalData_2+8,Y
	STA PalData_1+8,Y
	LDA PalData_2+12,Y
	STA PalData_1+12,Y
	LDA PalData_2+24,Y
	STA PalData_1+24,Y
	LDA PalData_2+28,Y
	STA PalData_1+28,Y
	DEY	; Y--
	BNE PRG062_DE4C	; While Y > 0, loop

	; Commit palette
	LDA #$FF
	STA <CommitPal_Flag
	
	RTS	; $DE71


	; Flash sprite palettes white when boss hit
PRG062_BossHitFlashSprPal:
	LDY #$03	; Y = 3
	
	LDA #$20
PRG062_DE76:
	STA PalData_1+4,Y
	STA PalData_1+8,Y
	STA PalData_1+12,Y
	STA PalData_1+24,Y
	STA PalData_1+28,Y
	
	DEY	; Y--
	BNE PRG062_DE76	; While Y > 0, loop!

	; Commit palette
	LDA #$FF
	STA <CommitPal_Flag
	
	RTS	; $DE8C


PRG062_DE8D:
	STA <Temp_Var3	; $DE8D
	
	LDA Spr_FlashOrPauseCnt,X
	LSR A
	LSR A
	BCC PRG062_DEB7	; Every 4 ticks, jump to PRG062_DEB7


PRG062_DE96:
	; Flash white
	LDA #$20
	STA PalData_1,Y

PRG062_DE9B:
	DEY	; Y--
	
	DEC <Temp_Var3
	BEQ PRG062_DEA8	; If Temp_Var3 = 0, jump to PRG062_DEA8

	LDA <Temp_Var3
	AND #$03
	BNE PRG062_DE96	; 3:4 jump to PRG062_DE96

	BEQ PRG062_DE9B	; Otherwise loop


PRG062_DEA8:
	LDA #$20	; White
	LDY #$03	; Y = 3
PRG062_DEAC:
	STA PalData_1+24,Y
	STA PalData_1+28,Y
	DEY	; Y--
	BNE PRG062_DEAC	; While Y > 0, loop

	BEQ PRG062_DEDB	; Jump (technically always) to PRG062_DEDB


PRG062_DEB7:
	; Restore from white
	LDA PalData_2,Y
	STA PalData_1,Y

PRG062_DEBD:
	DEY	; Y--
	
	DEC <Temp_Var3	; Temp_Var3--
	BEQ PRG062_DECA	; If Temp_Var3 = 0, jump to PRG062_DECA

	LDA <Temp_Var3
	AND #$03
	BNE PRG062_DEB7	; 3:4 jump to PRG062_DEB7

	BEQ PRG062_DEBD	; Loop!


PRG062_DECA:

	LDY #$03	; Y = 3
PRG062_DECC:
	LDA PalData_2+24,Y	
	STA PalData_1+24,Y	
	
	LDA PalData_2+28,Y	
	STA PalData_1+28,Y	
	
	DEY	; Y--
	BNE PRG062_DECC	; While Y > 0, loop


PRG062_DEDB:
	
	; Commit palette
	LDA #$FF
	STA <CommitPal_Flag
	
	JMP PRG062_DD30	; Jump to PRG062_DD30


PRG062_DEE2:

	; Temp_Var16 = 0
	LDX #$00
	STX <Temp_Var16

PRG062_DEE6:
	JSR PRG062_DrawEnergyMeter

	INC <Temp_Var16	; Temp_Var16++
	
	LDX <Temp_Var16
	CPX #$03
	BNE PRG062_DEE6	; If Temp_Var16 < 3, jump to PRG062_DEE6

	RTS	; $DEF1


PRG062_DEF2:
	; Temp_Var16 = 2
	LDX #$02
	STX <Temp_Var16

PRG062_DEF6:
	JSR PRG062_DrawEnergyMeter

	DEC <Temp_Var16	; Temp_Var16--
	
	LDX <Temp_Var16
	BPL PRG062_DEF6	; If Temp_Var16 >= 0, loop


PRG062_DEFF:
	RTS	; $DEFF


	; Draw energy meter!
PRG062_DrawEnergyMeter:
	; X = 0 for Player, 1 for weapon, or 2 for boss

	LDA HUDBarP_DispSetting,X
	BPL PRG062_DEFF	; If relevant energy meter not displayed, jump to PRG062_DEFF (RTS)

	AND #$7F
	TAY	; Index of relevant object -> 'Y'
	
	LDA Player_HP,Y
	AND #$7F
	STA <Temp_Var0	; Actual HP -> Temp_Var0
	
	; Sprite attribute setting for this energy meter
	LDA PRG062_MeterAttr,X
	STA <Temp_Var1

	; Sprite X for energy meter
	LDA PRG062_MeterX,X	; $DF14
	STA <Temp_Var2	; $DF17
	
	LDX <Sprite_CurrentIndex	; X = Sprite_CurrentIndex
	BEQ PRG062_DF56	; If out of sprites, jump to PRG062_DF56

	; Temp_Var3 = $48
	LDA #$48
	STA <Temp_Var3

PRG062_DF21:
	; Set meter sprite attribute
	LDA <Temp_Var1
	STA Sprite_RAM+$02,X
	
	; Set meter sprite X
	LDA <Temp_Var2
	STA Sprite_RAM+$03,X
	
	; Set meter sprite Y
	LDA <Temp_Var3
	STA Sprite_RAM+$00,X
	
	LDY #$04	; Y = 4 (if >= 4 energy units remain)
	
	LDA <Temp_Var0
	SUB #$04
	BCS PRG062_DF3D	; If there's still at least 4 energy units, jump to PRG062_DF3D

	LDY <Temp_Var0	; Y = Temp_Var0 (remaining energy units, < 4)
	
	LDA #$00	; A = 0 (no energy units remain after this)

PRG062_DF3D:
	STA <Temp_Var0	; Update Temp_Var0 (energy units remaining)
	
	; Set pattern to $80-$84
	TYA
	ORA #$80
	STA Sprite_RAM+$01,X
	
	; X += 4
	INX
	INX
	INX
	INX
	
	BEQ PRG062_DF56	; If out of sprites, jump to PRG062_DF56

	; Meter sprite Y -= 8
	LDA <Temp_Var3
	SUB #$08
	STA <Temp_Var3
	
	CMP #$10
	BNE PRG062_DF21	; If meter sprite Y > $10, loop!


PRG062_DF56:
	STX <Sprite_CurrentIndex	; Update Sprite_CurrentIndex
	
	RTS	; $DF58


	; Energy meter sprite lookups
PRG062_MeterAttr:	.byte SPR_PAL1, SPR_PAL0, SPR_PAL2
PRG062_MeterX:		.byte $18, $10, $28


PRG062_DrawToadRain:
	LDA Weapon_ToadRainCounter
	BEQ PRG062_DFBD	; If no Toad Rain, jump to PRG062_DFBD (RTS)

	DEC Weapon_ToadRainCounter	; Weapon_ToadRainCounter--
	
	LDA Weapon_ToadRainCounter
	AND #$07
	BNE PRG062_DF73	; 7:8 jump to PRG062_DF73

	; Toad Rain sound effect
	LDA #SFX_TOADRAIN
	JSR PRG063_QueueMusSnd


PRG062_DF73:
	LDX #$74	; X = $74
	LDY #(PRG062_ToadRainXYBase_End - PRG062_ToadRainXYBase - 2)
PRG062_DF77:
	LDA ToadRain_OwnerIndex
	CMP #$10
	BGE PRG062_DF8A	; If ToadRain_OwnerIndex >= $10 (spawned by Toad Man rather than Player), jump to PRG062_DF8A

	; Player's Toad Rain

	; Pattern $99
	LDA #$99
	STA Sprite_RAM+$01,X
	
	; Palette 0
	LDA #SPR_PAL0
	STA Sprite_RAM+$02,X
	
	BEQ PRG062_DF94	; Jump (technically always) to PRG062_DF94


PRG062_DF8A:
	; Toad Man's rain

	; Pattern $FF
	LDA #$FF
	STA Sprite_RAM+$01,X
	
	; Palette 3
	LDA #SPR_PAL3
	STA Sprite_RAM+$02,X

PRG062_DF94:
	LDA PRG062_ToadRainXYBase+1,Y
	SUB Weapon_ToadRain_XYOff
	STA Sprite_RAM+$03,X
	
	LDA PRG062_ToadRainXYBase,Y
	ADD Weapon_ToadRain_XYOff
	STA Sprite_RAM+$00,X
	
	; Y -= 2
	DEY
	DEY
	
	; X -= 4 (prev sprite)
	DEX
	DEX
	DEX
	DEX
	
	BPL PRG062_DF77	; While sprites remain, loop

	LDA Weapon_ToadRain_XYOff
	ADD #$04
	STA Weapon_ToadRain_XYOff
	
	LDA #$78
	STA <Sprite_CurrentIndex

PRG062_DFBD:
	RTS	; $DFBD


PRG062_ToadRainXYBase:
	.byte $00, $30
	.byte $00, $50
	.byte $00, $70
	.byte $00, $90
	.byte $00, $B0
	.byte $00, $D0
	.byte $00, $F0
	.byte $18, $F8
	.byte $30, $60
	.byte $38, $38
	.byte $38, $B8
	.byte $38, $F8
	.byte $40, $70
	.byte $48, $70
	.byte $58, $F8
	.byte $60, $30
	.byte $60, $B0
	.byte $70, $80
	.byte $78, $B8
	.byte $78, $F8
	.byte $80, $30
	.byte $88, $C8
	.byte $90, $40
	.byte $98, $F8
	.byte $A8, $48
	.byte $A8, $60
	.byte $B8, $78
	.byte $B8, $98
	.byte $B8, $B8
	.byte $B8, $F8
PRG062_ToadRainXYBase_End

	.org $DFFA		; Putting this here because the table is split over 62-63 and there's no nice way to handle it in NESASM
PRG062_Spr_Bank:
	; This bank is installed at $A000 and this bank minus 1 is installed at $8000
	.byte 13, 13, 13, 13, 13, 13	; Sprite overlay indexes $00-$05

	; !!NOTE!!: CONTINUED IN PRG063
