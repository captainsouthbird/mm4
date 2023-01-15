PRG030_UpdateMusSnd_Ind:
	JMP PRG030_UpdateMusicTrackSnd	; $8000

PRG030_TriggerMusSnd_Ind:
	JMP PRG030_TriggerMusSnd	; $8003


	; Inputs:
	;	MusSnd_TempVar0 (waveform shaping)
	;	MusSnd_TempVar3 (master volume)
	;
	; Output: 16-bit waveform offset (could be used for frequency or volume depending on context)
	;	MusSnd_TempVar0 (H) and MusSnd_TempVar1 (L)
PRG030_ComputeWaveformOffset:

	; MusSnd_TempVar1 = 0
	LDA #$00
	STA <MusSnd_TempVar1
	
	LDY #$08	; Y = 8
PRG030_800C:
	ASL <MusSnd_TempVar1	; Shift MusSnd_TempVar1 left
	ROL <MusSnd_TempVar0	; Bit 7 rolled into MusSnd_TempVar0
	BCC PRG030_801F			; If MusSnd_TempVar0 didn't shift a '1' from its bit 7, jump to PRG030_801F

	CLC	; Clear carry
	
	; MusSnd_TempVar1/0 += MusSnd_TempVar3
	LDA <MusSnd_TempVar1
	ADC <MusSnd_TempVar3
	STA <MusSnd_TempVar1
	
	LDA <MusSnd_TempVar0
	ADC #$00
	STA <MusSnd_TempVar0

PRG030_801F:
	DEY	; Y--
	BNE PRG030_800C	; While Y > 0, loop!

	RTS	; $8022


	; Performs a dynamic jump by indexing a table that follows 
	; the point the function was called from
PRG030_DynJump:
	ASL A
	TAY
	INY
	PLA
	STA <MusSnd_TempVar0
	PLA
	STA <MusSnd_TempVar1
	LDA [MusSnd_TempVar0],Y
	PHA
	INY
	LDA [MusSnd_TempVar0],Y
	STA <MusSnd_TempVar1
	PLA
	STA <MusSnd_TempVar0
	JMP [MusSnd_TempVar0]


	; To support the additional bank 29, if MusSnd_TempVar1 >= $C0, 
	; it puts bank 29 in place and then fixes the pointer
PRG030_FixAndFetchByte:
	STY <MusSnd_TempVar0	; Store low part of address
	
	LDY #$00	; Y = 0
	
	CMP #$C0
	BGE PRG030_8047	; If address high part is $C0 or higher, this is a page 29 entry, jump to PRG030_8047

	STA <MusSnd_TempVar1	; Store high address part
	
	LDA [MusSnd_TempVar0],Y	; Read first byte
	RTS	; $8046


PRG030_8047:
	SUB #$20		; Fix address into page 29
	STA <MusSnd_TempVar1	; Fixed high part
	
	; Set page 29 @ $A000
	LDA #MMC3_8K_TO_PRG_A000
	STA MMC3_COMMAND
	LDA #29
	STA MMC3_PAGE
	
	LDA [MusSnd_TempVar0],Y	; Read byte
	PHA	; Save it
	
	; Set page 31 @ $A000
	LDA #MMC3_8K_TO_PRG_A000
	STA MMC3_COMMAND
	LDA #31
	STA MMC3_PAGE
	
	; Keep the $C0 base in the high part
	LDA #$20
	ADD <MusSnd_TempVar1
	STA <MusSnd_TempVar1
	
	PLA	; Restore byte
	RTS	; $806B


PRG030_UpdateMusicTrackSnd:
	LDA <SndMus_DisFlags
	LSR A
	BCS PRG030_80D7	; If bit 0 set, jump to PRG030_80D7 (RTS)

	LDA <SndPtr_L
	ORA <SndPtr_H
	BEQ PRG030_807A	; If SndPtr_L/SndPtr_H = 0 (no sound effect playing), jump to PRG030_807A

	JSR PRG030_UpdateSFX

PRG030_807A:

	; Adds the 16-bit MusTempo to the MusTempoAccum
	CLC
	LDA <MusTempo_Frac
	ADC <MusTempoAccum_Frac
	STA <MusTempoAccum_Frac
	
	LDA <MusTempo
	ADC #$00
	STA <MusTempoAccum
	
	; Backup Sound_MusOverrideFlags
	LDA <Sound_MusOverrideFlags
	PHA
	
	LDX #$03	; X = 3 (all sound channels)
PRG030_808C:
	LSR <Sound_MusOverrideFlags
	BCC PRG030_8099	; If this channel is not overridden for sound effect usage, jump to PRG030_8099

	; Sound is using this channel

	LDA <Sound_MusOverrideFlags
	ORA #$80
	STA <Sound_MusOverrideFlags
	
	; Update this channel of sound effect
	JSR PRG030_UpdateSoundTrack


PRG030_8099:
	LDA <SndMus_DisFlags
	AND #$02
	BNE PRG030_80A6	; If SndMus_DisFlags Bit 1 is set (music update disabled), jump to PRG030_80A6

	; Backup 'X' (will be offset by $28/OFFS_FROM_SND_TO_MUS_DATA for music data)
	TXA
	PHA
	
	; Update this channel of music
	JSR PRG030_UpdateMusicTrack

	; Restore 'X'
	PLA
	TAX

PRG030_80A6:
	DEX	; X--
	BPL PRG030_808C	; While X >= 0, loop

	; Restore Sound_MusOverrideFlags
	PLA
	STA <Sound_MusOverrideFlags
	
	; If I'm reading this right, this is a long-winded way to clear bit 0
	LSR <SndMus_DisFlags	; Bit 0 goes into carry here, but ...
	ASL <SndMus_DisFlags	; A 0 is shifted into bit 0 here?
	
	LDA <Mus_MasterVol_Dir
	AND #%01111111
	BEQ PRG030_80D7		; If bit 7 ($80) is not set, jump to PRG030_80D7 (RTS)

	; Mus_MasterVol_Dir bit 7 ($80) is set...

	; MusSnd_TempVar0 = 0
	LDY #$00
	STY <MusSnd_TempVar0
	
	; Basically this loop shifts the upper 4 bits of Mus_MasterVol_Dir -> MusSnd_TempVar0
	LDY #$04	; Y = 4
PRG030_80BC:
	ASL A					; Value (started as Mus_MasterVol_Dir) shifted left (bit 7 -> carry)
	ROL <MusSnd_TempVar0	; carry -> bit 7
	
	DEY					; Y--
	BNE PRG030_80BC		; While Y <> 0, loop

	ADD <SndMus_DisFlags
	STA <SndMus_DisFlags	; SndMus_DisFlags += (Mus_MasterVol_Dir << 4)
	
	LDA <MusSnd_TempVar0
	ADC <Mus_MasterVol
	BCC PRG030_80D5	; If it didn't overflow, jump to PRG030_80D5 (set new Mus_MasterVol)

	; Keep only $80 for Mus_MasterVol_Dir
	LDA <Mus_MasterVol_Dir
	AND #$80
	STA <Mus_MasterVol_Dir
	
	LDA #$FF	; A = $FF (value -> Mus_MasterVol)
PRG030_80D5:
	STA <Mus_MasterVol

PRG030_80D7:
	RTS	; $80D7


	; Silence a sound channel
	; 'X' specifies a sound channel:
	;	0 - Noise
	;	1 - Tri
	;	2 - Square 2
	;	3 - Square 1	
PRG030_SynthSilence:
	TXA			; Sound channel select
	AND #$03	; Cap 0-3
	EOR #$03	; Invert order
	ASL A
	ASL A		; x4
	TAY			; -> 'Y'
	
	LDA #$30	; A = $30
	
	CPY #$08
	BNE PRG030_80E8	; If 'Y' <> $08 (PAPU_TCR1), jump to PRG030_80E8

	LDA #$00	; A = $00

PRG030_80E8:
	STA PAPU_CTL1,Y	; $80E8
	RTS	; $80EB


	; Write a synth value to the channel
	; 'A' is value to write to register
	; 'X' specifies a sound channel (+$28 for music track offset):
	;	$28/$00 - Noise
	;	$29/$01 - Tri
	;	$2A/$02 - Square 2
	;	$2B/$03 - Square 1	
	; 'Y' is offset to particular register type, differs based on which channel is selected
PRG030_SynthWrite:
	PHA	; Save input value
	
	TXA			; Sound channel select
	AND #$03	; Cap 0-3
	EOR #$03	; Invert order
	ASL A
	ASL A		; x4 (sound regs are spaced 4 apart)
	
	STY <MusSnd_TempVar3	; Reg offset -> MusSnd_TempVar3
	ORA <MusSnd_TempVar3	; 'A' OR'd with MusSnd_TempVar3 (base reg offset)
	TAY	; -> 'Y'
	
	PLA	; Restore input value
	
	STA PAPU_CTL1,Y	; Write value to sound register
	
	RTS	; $80FD


PRG030_TriggerMusSnd:
	; 'A' contains the sound trigger value

	INC <SndMus_DisFlags	; Disable music/sound updates (??)
	
	JSR PRG030_DoTriggerMusSnd

	DEC <SndMus_DisFlags	; Enable music/sound updates
	
	RTS	; $8105


PRG030_DoTriggerMusSnd:
	CMP #MUS_STOPMUSIC
	BLT PRG030_810D	; If this isn't one of the special music triggers, jump to PRG030_810D

	JMP PRG030_81AE	; Jump to PRG030_81AE


PRG030_810D:
	CMP PRG030_FinalValueConstant
	BLT PRG030_8118		; As long as trigger is under PRG030_FinalValueConstant, jump to PRG030_8118

	; CHECKME - UNUSED?
	
	; This appears to be an overflow catch which will bring the result down to a sane value
	SUB PRG030_FinalValueConstant
	BGE PRG030_810D


PRG030_8118:
	ASL A	; Multiply trigger by 2
	TAX		; -> 'X'

	LDY PRG030_MusSnd_AddrTable+1,X
	TYA
	ORA PRG030_MusSnd_AddrTable,X
	BEQ PRG030_816E	; If address amounts to $0000 (empty), jump to PRG030_816E (RTS)

	LDA PRG030_MusSnd_AddrTable,X
	
	JSR PRG030_FixAndFetchByte	; Fetch byte!

	TAY	; -> 'Y'
	BEQ PRG030_816F	; If zero, jump to PRG030_816F (this is music rather than a sound effect)
	
	; SOUND EFFECT (SFX) START

	LDY #$00	; Y = 0
	
	INX	; X++ (low byte in address table entry)
	
	STA <MusSnd_TempVar3	; First byte -> MusSnd_TempVar3
	
	AND #$7F		; Lower 7 bits of first SFX header byte
	CMP <Sound_CurSFXPriority
	BLT PRG030_816E	; If this sound is a lower priority than the one currently playing, jump to PRG030_816E (RTS)

	STA <Sound_CurSFXPriority	; Set new priority level
	BNE PRG030_8145	; If not $00 priority (?), jump to PRG030_8145

	; If priority setting was $00...

	LDA <Sound_LoopCounter
	BPL PRG030_8145	; If Sound_LoopCounter bit 7 is not set, jump to PRG030_8145

	; CHECKME - UNUSED?
	LDA <MusSnd_TempVar3
	BMI PRG030_8145		; If perpetual loop flag is set, jump to PRG030_8145
	
	; Perpetual loop flag is clear
	
	; Y = $00 from above, so this clears Sound_PostSFXQueueOff
	STY <Sound_PostSFXQueueOff

PRG030_8145:

	; Y = $00 from above, so this clears Sound_LoopCounter
	STY <Sound_LoopCounter	; Sound_LoopCounter = $00
	
	ASL <MusSnd_TempVar3	; Bit 7 of input value -> MusSnd_TempVar3 (this flags for the sound effect to perpetually loop)
	ROR <Sound_LoopCounter			; Bit 7 from MusSnd_TempVar3 -> Sound_LoopCounter
	BPL PRG030_814F			; If bit 7 not set (do not perpetually loop), jump to PRG030_814F

	; The perpetual loop functionality is not actually used by MM4
	
	; Set Sound_PostSFXQueueOff
	STX <Sound_PostSFXQueueOff

PRG030_814F:
	INC <MusSnd_TempVar0	; MusSnd_TempVar0++
	LDA <MusSnd_TempVar0
	
	STA <SndPtr_L	; -> SndPtr_L
	
	BNE PRG030_8159	; If hasn't wrapped, jump to PRG030_8159

	; Advance the high part
	INC <MusSnd_TempVar1

PRG030_8159:
	LDA <MusSnd_TempVar1
	STA <SndPtr_H	; -> SndPtr_H
	
	TYA		; Y = $00 -> 'A'
		
	; Clear sound vars
	STA <Snd_NoteTranspose
	STA <Sound_RestTimer
	STA <RAM_00D4
	STA <RAM_00D5
	
	; Clear sound effect data
	LDY #$27	; Y = $27
PRG030_8168:
	STA Sound_TrackPatch,Y
	
	DEY	; Y--
	BPL PRG030_8168	; While Y >= 0, loop


PRG030_816E:
	RTS	; $816E


PRG030_816F:
	; MUSIC START

	LDX #$01
	STX <MusTempo	; $8171
	
	LDX #$99	; $8173
	STX <MusTempo_Frac	; $8175
	STA <MusTempoAccum_Frac	; $8177
	STA <Mus_NoteTranspose	; $8179
	STA <Mus_MasterVol_Dir	; $817B
	STA <Mus_MasterVol	; $817D
	
	; Clears $728-$77B
	LDX #$53
PRG030_8181:
	STA Music_TrackPatch,X
	
	DEX	; X--
	BPL PRG030_8181	; While X >= 0, loop


	LDX #$03	; X = 3 (all channels)
PRG030_8189:
	INC <MusSnd_TempVar0	; MusSnd_TempVar0++
	BNE PRG030_818F		; If hasn't wrapped, jump to PRG030_818F

	; Advance the high part
	INC <MusSnd_TempVar1

PRG030_818F:

	; In short, the next so many lines fetch the track pointer high and low...

	; Fetch next byte
	LDY <MusSnd_TempVar0
	LDA <MusSnd_TempVar1
	JSR PRG030_FixAndFetchByte

	STA Music_TrackPtr_H,X

	INC <MusSnd_TempVar0	; MusSnd_TempVar0++
	BNE PRG030_819F		; If hasn't wrapped, jump to PRG030_819F

	; Advance the high part
	INC <MusSnd_TempVar1

PRG030_819F:
	; Fetch next byte
	LDY <MusSnd_TempVar0
	LDA <MusSnd_TempVar1
	JSR PRG030_FixAndFetchByte

	STA Music_TrackPtr_L,X
	
	; -- finished fetching the track pointer!
	
	DEX	; X--
	BPL PRG030_8189	; While X >= 0, loop!

	; All track pointers fetched

	BMI PRG030_SilenceMusicTracks	; Jump (technically always) to PRG030_SilenceMusicTracks


PRG030_81AE:
	; One of the special music triggers

	STY <MusSnd_TempVar2
	
	AND #$07
	JSR PRG030_DynJump

	.word PRG030_MusTrigger_StopMusic	; 0: Trigger $F0 (MUS_STOPMUSIC)
	.word PRG030_MusTrigger_1			; 1: Trigger $F1 Unused?
	.word PRG030_MusTrigger_ZeroMusTrks	; 2: Trigger $F2 Unused?
	.word PRG030_MusTrigger_3			; 3: Trigger $F3 Unused?
	.word PRG030_MusTrigger_4			; 4: Trigger $F4 Unused?
	.word PRG030_MusTrigger_5			; 5: Trigger $F5 Unused?
	.word PRG030_MusTrigger_PartialMute	; 6: Trigger $F6 (MUS_PARTIALMUTE)
	.word PRG030_MusTrigger_7			; 7: Trigger $F7 Unused?


PRG030_MusTrigger_StopMusic:
	JSR PRG030_MusTrigger_ZeroMusTrks	; Zero out the music tracks


PRG030_MusTrigger_1:
	LDA #$00	; $81C8
	STA <Sound_CurSFXPriority	; $81CA
	STA <SndPtr_L	; $81CC
	STA <SndPtr_H	; $81CE
	STA <Sound_PostSFXQueueOff	; $81D0
	STA <RAM_00D8	; $81D2

PRG030_StopSFXChannels:
	LDA <Sound_MusOverrideFlags
	BEQ PRG030_81E3	; If no sound effect overrides, jump to PRG030_81E3 (RTS)

	; Invert the sound override bits (for fudging logic up ahead)
	EOR #$0F
	STA <Sound_MusOverrideFlags
	
	; Basically stops all tracks being used for sound effects as well
	JSR PRG030_SilenceMusicTracks

	; Clear all the sound override bits
	LDA #$00
	STA <Sound_MusOverrideFlags

PRG030_81E3:
	RTS	; $81E3


PRG030_MusTrigger_ZeroMusTrks:

	; Zero out the music tracks
	LDA #$00

	LDX #$03	; X = 3 (all tracks)
PRG030_81E8:
	STA Music_TrackPtr_H,X
	STA Music_TrackPtr_L,X
	
	DEX	; X--
	BPL PRG030_81E8	; While X >= 0, loop


PRG030_SilenceMusicTracks:
	
	; Save Sound_MusOverrideFlags
	LDA <Sound_MusOverrideFlags
	PHA
	
	LDX #$03	; X = 3 (all tracks)
PRG030_81F6:
	LSR <Sound_MusOverrideFlags
	BCS PRG030_820A	; If this track is being used for sound effects, jump to PRG030_820A

	; Silence this synth channel (being used by music)
	JSR PRG030_SynthSilence

	LDA Music_TrackPtr_H,X
	ORA Music_TrackPtr_L,X
	BEQ PRG030_820A		; If this track address is $0000, jump to PRG030_820A

	; SndMus_SynthToneFreq = $FF
	LDA #$FF
	STA SndMus_SynthToneFreq,X

PRG030_820A:
	DEX	; X--
	BPL PRG030_81F6	; While X >= 0, loop!

	; Restore Sound_MusOverrideFlags
	PLA
	STA <Sound_MusOverrideFlags
	
	; Reset ramps
	LDA #$08
	STA PAPU_RAMP1
	STA PAPU_RAMP2
	
	; Enable everything except DMC
	LDA #$0F
	STA PAPU_EN
	
	RTS	; $821D

PRG030_MusTrigger_3:
	; CHECKME - UNUSED?
	; $821E
	LDA <SndMus_DisFlags
	ORA #$02
	STA <SndMus_DisFlags
	BNE PRG030_SilenceMusicTracks
	
PRG030_MusTrigger_4:
	; CHECKME - UNUSED?
	LDA <SndMus_DisFlags
	AND #~$02
	STA <SndMus_DisFlags
	
	RTS
	
PRG030_MusTrigger_5:
	; CHECKME - UNUSED?
	; $822D
	ASL <MusSnd_TempVar2
	BEQ PRG030_MusTrigger_PartialMute
	
	SEC
	ROR <MusSnd_TempVar2

PRG030_MusTrigger_PartialMute:
	LDA <SndMus_DisFlags	; $8234
	AND #$0F	; $8236
	STA <SndMus_DisFlags	; $8238
	
	LDY <MusSnd_TempVar2	; $823A
	STY <Mus_MasterVol_Dir	; $823C
	BEQ PRG030_8247	; $823E

	LDY #$FF	; $8240
	CPY <Mus_MasterVol	; $8242
	BNE PRG030_8249	; $8244

	; CHECKME - UNUSED?
	INY
	
PRG030_8247:
	STY <Mus_MasterVol

PRG030_8249:
	RTS	; $8249

PRG030_MusTrigger_7:
	; CHECKME - UNUSED?
	; $824A
	LDA #$00
	SUB <MusSnd_TempVar2
	STA <RAM_00D8
	RTS

PRG030_UpdateSFX:
	LDA <Sound_RestTimer
	BEQ PRG030_825B	; If Sound_RestTimer = 0, jump to PRG030_825B

	DEC <Sound_RestTimer	; Sound_RestTimer--
	DEC <RAM_00D5	; RAM_00D5--
	RTS	; $825A


PRG030_825B:
	JSR PRG030_AdvanceSndPtr_FetchByte	; Fetch next byte in sound stream
	STA <MusSnd_TempVar3	; -> MusSnd_TempVar3 [herein "value"]
	
	ASL A
	BCC PRG030_8273	; If value bit 7 is NOT set, jump to PRG030_8273

	; value bit 7 is set...

	; Mainly this handles the $FF terminator for a sound effect

	; This will stop the sound
	STY <Sound_CurSFXPriority	; Sound_CurSFXPriority = 0 (Y = 0 due to PRG030_AdvanceSndPtr_FetchByte)
	
	; Due to the way Sound_PostSFXQueueOff is used, bit 1 will always be set if
	; this functionality is enabled (sound looping)
	LDA <Sound_PostSFXQueueOff
	LSR A
	BCC PRG030_8270	; If Sound_PostSFXQueueOff bit 0 is not set, jump to PRG030_8270

	; Loop queue (incidentally not used by MM4, but fully functional)

	JSR PRG030_8118		; Queues sound based on Sound_PostSFXQueueOff
	JMP PRG030_825B		; Jump to PRG030_825B to restart sound processing

PRG030_8270:
	JMP PRG030_MusTrigger_1	; Jump to PRG030_MusTrigger_1 (silence sound effect, we're done)


PRG030_8273:
	LSR <MusSnd_TempVar3
	BCC PRG030_82A6	; If value bit 0 ($01) is NOT set, jump to PRG030_82A6

	; value bit 0 ($01) is set...
	
	; SFX LOOP COMMAND

	JSR PRG030_AdvanceSndPtr_FetchByte	; Fetch another byte (loop count)

	; Loop count gets shifted left by 1 here as a bit of convenience for checking 
	; only the lower 7 bits of Sound_LoopCounter, but also checks for a $00 loop
	; count that implies a JUMP ALWAYS
	ASL A
	BEQ PRG030_8289	; If lower 7 bits are all zero, jump to PRG030_8289 (this is a JUMP ALWAYS)
	
	; Non-zero loop count...

	ASL <Sound_LoopCounter	; Sound_LoopCounter <<= 1 (lines it up with the shifted loop count, and also conveniently ignores the perpetual loop flag)
	
	PHP	; Save status (carry)
	
	CMP <Sound_LoopCounter
	BEQ PRG030_8296	; If we've looped the intended number of times, jump to PRG030_8296

	; Not done looping yet...

	PLP	; Restore status (carry)
	
	ROR <Sound_LoopCounter	; Put bit 7 (perpetual loop flag) back into place
	
	INC <Sound_LoopCounter	; We've done one more loop

PRG030_8289:
	; Do SFX jump!
	JSR PRG030_AdvanceSndPtr_FetchByte	; Fetch high byte of address
	TAX	; -> 'X'
	
	JSR PRG030_AdvanceSndPtr_FetchByte	; Fetch low byte of address

	; Store address
	STA <SndPtr_L
	STX <SndPtr_H
	
	BNE PRG030_825B	; Jump (technically always) to PRG030_825B


PRG030_8296:
	; SFX loop has completed...

	TYA	; A = 0 (Y = 0 due to PRG030_AdvanceSndPtr_FetchByte)
	
	PLP	; Restore status (carry flag holding bit 7, i.e. perpetual loop flag)
	
	; Restore Sound_LoopCounter's bit 7 (perpetual loop flag)
	ROR A
	STA <Sound_LoopCounter
	
	; Loop has ended, advance passed it	
	CLC
	LDA #$02
	ADC <SndPtr_L
	STA <SndPtr_L
	BCC PRG030_82A6

	INC <SndPtr_H

PRG030_82A6:

	LSR <MusSnd_TempVar3
	BCC PRG030_82AF	; If value bit 1 ($02) is NOT set, jump to PRG030_82AF

	; value bit 1 ($02) is set...

	; "NOTE LENGTH" ATTACK/DECAY whatever

	JSR PRG030_AdvanceSndPtr_FetchByte	; Fetch next byte
	STA <RAM_00D4	; -> RAM_00D4

PRG030_82AF:
	LSR <MusSnd_TempVar3
	BCC PRG030_82B8	; If value bit 2 ($04) is NOT set, jump to PRG030_82B8

	; value bit 2 ($04) is set...

	; NOTE TRANSPOSE SET

	JSR PRG030_AdvanceSndPtr_FetchByte	; Fetch next byte
	STA <Snd_NoteTranspose	; -> Snd_NoteTranspose

PRG030_82B8:
	; SFX commands done... fetch rest/length value

	JSR PRG030_AdvanceSndPtr_FetchByte	; Fetch next byte
	STA <Sound_RestTimer			; -> Sound_RestTimer
	STA <MusSnd_TempVar0	; -> MusSnd_TempVar0
	
	; MusSnd_TempVar3 = RAM_00D4
	LDA <RAM_00D4
	STA <MusSnd_TempVar3
	
	JSR PRG030_ComputeWaveformOffset

	LDY <MusSnd_TempVar0	; Y = prior fetched byte
	INY				; Y++
	STY <RAM_00D5	; RAM_00D5 = Sound_RestTimer + 1 (basically)
	
	INC <SndMus_DisFlags	; $82CB
	
	
	; Channel select
	
	JSR PRG030_AdvanceSndPtr_FetchByte	; Fetch next byte
	PHA	; Save it
	
	; The last fetched byte has the sound effect override channel bits.
	; Inverting by existing sound effect overrides which provides a 
	; mask of channels being used by music and not sound effects.
	EOR <Sound_MusOverrideFlags		; Invert existing sound effect overrides
	BEQ PRG030_82DA		; If all channels involved in this new sound effect are already overridden, jump to PRG030_82DA

	; Temporarily storing inverted flags to stop channels this new sound effect will be using
	STA <Sound_MusOverrideFlags	
	JSR PRG030_StopSFXChannels


PRG030_82DA:
	PLA	; Restore the sound effect flags
	STA <Sound_MusOverrideFlags	; Set correct override value
	
	RTS	; $82DD


PRG030_UpdateSoundTrack:
	LDY Sound_TrackPatch,X
	BEQ PRG030_82E6	; If Sound_TrackPatch = 0, jump to PRG030_82E6

	JSR PRG030_SetPatchBaseAddr	; Otherwise set patch address


PRG030_82E6:
	LDA <SndMus_DisFlags
	LSR A
	BCS PRG030_830A	; FIXME but basically if SndMus_DisFlags bit 0 ($01) set, jump to PRG030_830A (fetches processing data)

	; Actually play sound!
	JSR PRG030_UpdateSynth

	LDA <Sound_RestTimer
	BEQ PRG030_82FA	; If Sound_RestTimer = 0, jump to PRG030_82FA (RTS)

	CPX #$01
	BEQ PRG030_82FB	; If this is a sound effect Triangle track, jump to PRG030_82FB

	LDA <RAM_00D5
	BEQ PRG030_8300	; If RAM_00D5 = 0, jump to PRG030_8300


PRG030_82FA:
	RTS	; $82FA


PRG030_82FB:
	DEC Sound_TrackVolume,X	; Sound_TrackVolume--
	BNE PRG030_82FA	; If Sound_TrackVolume <> 0, jump to PRG030_82FA (RTS)


PRG030_8300:
	LDA Sound_SineWaveCtl,X
	AND #%00000100
	BNE PRG030_82FA	; If Sound_SineWaveCtl command = 4 (do nothing), jump to PRG030_82FA (RTS)

	JMP PRG030_SineWaveCtl_SetDecay	; Otherwise, change to command 3 (note decay)


PRG030_830A:
	; Fetch more SFX data for processing...

	; MusSnd_TempVar3 = 0
	LDA #$00
	STA <MusSnd_TempVar3
	
	JSR PRG030_AdvanceSndPtr_FetchByte	; Fetch next byte


PRG030_8311:
	LSR A			; Shift right
	BCC PRG030_8320	; If bit wasn't set, jump to PRG030_8320

	PHA	; Save this (more bit-shifting coming up)
	
	JSR PRG030_AdvanceSndPtr_FetchByte	; Fetch another byte
	STA <MusSnd_TempVar2	; -> MusSnd_TempVar2 (parameter)
	
	LDA <MusSnd_TempVar3
	JSR PRG030_8326	; Run command

	PLA	; Restore it (the bit-shifted value)

PRG030_8320:
	BEQ PRG030_8333	; If all bits clear, jump to PRG030_8333

	INC <MusSnd_TempVar3	; MusSnd_TempVar3++
	BNE PRG030_8311	; Jump (technically always) to PRG030_8311


PRG030_8326:
	; Sound effect commands
	JSR PRG030_DynJump

	.word PRG030_Cmd_SetTrackPatch	; 0
	.word PRG030_Cmd_SetDutyCycle			; 1
	.word PRG030_Cmd_SetSynthVolume			; 2
	.word PRG030_Cmd_SetFreqOffset			; 3
	.word PRG030_Cmd_SetFreqFineOffset			; 4



PRG030_8333:
	JSR PRG030_AdvanceSndPtr_FetchByte	; Fetch next byte
	TAY	; -> 'Y'
	
	BNE PRG030_8349	; If non-zero, jump to PRG030_8349
	
	; Zero supplied...

	STA Sound_TrackVolume,X	; Sound_TrackVolume = 0
	
	; Change to Sound_SineWaveCtl command 4 (do nothing)
	LDA Sound_SineWaveCtl,X
	AND #%11111000
	ORA #%00000100
	STA Sound_SineWaveCtl,X
	
	JMP PRG030_SynthSilence	; Silence the synth channel


PRG030_8349:
	; Set bit 5 ($20) on Sound_SineWaveCtl
	LDA Sound_SineWaveCtl,X
	ORA #%00100000
	STA Sound_SineWaveCtl,X
	
	LDA Sound_FreqOffset,X
	ASL A	; bit 7 -> carry
	
	LDA #$54	; Note value $54
	BCS PRG030_835B	; If Sound_FreqOffset bit 7 set, jump to PRG030_835B (use $54)

	LDA #$0A	; Note value $0A

PRG030_835B:
	STA Sound_LastNotePlayed,X	; Update Sound_LastNotePlayed
	
	TYA	; Last note value fetched
	BPL PRG030_836B	; If bit 7 not set, jump to PRG030_836B

	; CHECKME - UNUSED?
	CPX #$01
	BNE PRG030_8368
	
	JSR PRG030_UpdVolAndWaveCtlCmd
	
PRG030_8368:
	JMP PRG030_SineWave_ResetIfReq


PRG030_836B:
	JSR PRG030_UpdVolAndWaveCtlCmd

	; SndMus_SynthToneFreq = $FF
	LDA #$FF
	STA SndMus_SynthToneFreq,X
	
	DEY	; Last note value, decremented (zero-basing it)
	
	TXA
	BNE PRG030_837F	; If this is not the noise track, jump to PRG030_837F
	
	; Noise track only...

	STA <MusSnd_TempVar2	; MusSnd_TempVar2 = $00
	
	TYA	; Zero-based last note value
	
	EOR #$0F	; Invert
	JMP PRG030_8636	; Jump to PRG030_8636


PRG030_837F:
	TYA	; Zero-based last note value
	ADD <Snd_NoteTranspose	; Add sound effect transpose
	
	; Set note frequency for sound effect
	JMP PRG030_SetNoteFreq


PRG030_AdvanceSndPtr_FetchByte:
	LDY <SndPtr_L	; Y = SndPtr_L
	LDA <SndPtr_H	; A = SndPtr_H
	
	INC <SndPtr_L	; <SndPtr_L++	
	BNE PRG030_8390	; If hasn't wrapped, jump to PRG030_8390

	INC <SndPtr_H	; Advance high byte

PRG030_8390:
	JMP PRG030_FixAndFetchByte


PRG030_UpdateMusicTrack:
	; 'X' is the sound channel
	;	0 - Noise
	;	1 - Tri
	;	2 - Square 2
	;	3 - Square 1
	
	; Offset to music-side vars
	TXA
	ORA #OFFS_FROM_SND_TO_MUS_DATA
	TAX			; X = $28-$2B
	
	LDA Music_TrackPtr_L-OFFS_FROM_SND_TO_MUS_DATA,X
	ORA Music_TrackPtr_H-OFFS_FROM_SND_TO_MUS_DATA,X
	BEQ PRG030_83CC		; If this track address if $0000, jump to PRG030_83CC (RTS)

	LDA Music_NoteTicksLeft-OFFS_FROM_SND_TO_MUS_DATA,X	; $839F
	BEQ PRG030_83CD	; $83A2

	LDY Music_TrackPatch-OFFS_FROM_SND_TO_MUS_DATA,X	; $83A4
	BEQ PRG030_83AF	; $83A7

	; Set the instrument patch data pointer for this track
	JSR PRG030_SetPatchBaseAddr

	; Actually play music!
	JSR PRG030_UpdateSynth


PRG030_83AF:
	; Music_NoteLength -= MusTempoAccum
	LDA Music_NoteLength-OFFS_FROM_SND_TO_MUS_DATA,X
	SUB <MusTempoAccum
	STA Music_NoteLength-OFFS_FROM_SND_TO_MUS_DATA,X
	
	BEQ PRG030_83BC	; If Music_NoteLength,X = 0, jump to PRG030_83BC (PRG030_SineWaveCtl_SetDecay)
	
	BCS PRG030_83BF	; If Music_NoteLength,X has not reached zero, jump to PRG030_83BF


PRG030_83BC:
	; Music_NoteLength,X <= 0...

	JSR PRG030_SineWaveCtl_SetDecay	; Set Sound_SineWaveCtl command to 3 (note decay)


PRG030_83BF:
	; Music_TrackVolume -= MusTempoAccum
	LDA Music_TrackVolume,X
	SUB <MusTempoAccum
	STA Music_TrackVolume,X
	
	; Basically if the ticks expired, jump to PRG030_83CD
	BEQ PRG030_83CD	; If Music_TrackVolume,X = 0, jump to PRG030_83CD
	BCC PRG030_83CD	; If Music_TrackVolume,X went below zero, jump to PRG030_83CD


PRG030_83CC:
	RTS	; $83CC


PRG030_83CD:
	JSR PRG030_FetchNextByteFromTrack	; Read next byte from track

	CMP #$20
	BGE PRG030_83DA	; If read a byte value >= $20, jump to PRG030_83DA

	; Byte value $00-$1F

	JSR PRG030_Process_00to1FVal	; $83D4

	JMP PRG030_83CD	; Loop around


PRG030_83DA:
	; Track byte value >= $20 (NOTE: xx1x xxxx, the upper 3 bits will always be non-zero)

	PHA	; Save value
	
	; x 7654 3210
	ROL A	; 7 6543 210x
	ROL A	; 6 5432 10x7
	ROL A	; 5 4321 0x76
	ROL A	; 4 3210 x765
	AND #%00000111		; The upper 3 bits of the value now make up a 0-7 (technically 1-7 due to base value of $20)
	
	TAY	; -> 'Y'
	DEY	; Y--	(The base value of $20 will amount to 1, so zero-base it)
	
	LDA Music_TrackOctaveTimingCtl-OFFS_FROM_SND_TO_MUS_DATA,X
			; . 7654 3210
	ASL A	; 7 6543 210.
	ASL A	; 6 5432 10..
	
	BPL PRG030_83EF	; If bit 5 ($20) is NOT set (use PRG030_DelayTable2), jump to PRG030_83EF
	
	; Use PRG030_DelayTable1
	LDA PRG030_DelayTable1,Y	; Fetch delay value
	BNE PRG030_8406				; Jump (technically always) to PRG030_8406


PRG030_83EF:
	; If Music_TrackOctaveTimingCtl-OFFS_FROM_SND_TO_MUS_DATA bit 5 is NOT set...
	
	; Y = 0 to 6 based on the track byte value upper 3 bits

			; 6 5432 10..
	ASL A	; 5 4321 0...
	ASL A	; 4 3210 ....
	
	LDA PRG030_DelayTable2,Y
	BCC PRG030_8406	; If Music_TrackOctaveTimingCtl-OFFS_FROM_SND_TO_MUS_DATA bit 4 is not set, jump to PRG030_8406
	
	; Music_TrackOctaveTimingCtl-OFFS_FROM_SND_TO_MUS_DATA bit 4 set...

	STA <MusSnd_TempVar2	; PRG030_DelayTable2,Y -> MusSnd_TempVar2
	
	; Clear Bit 4 from Music_TrackOctaveTimingCtl-OFFS_FROM_SND_TO_MUS_DATA
	LDA Music_TrackOctaveTimingCtl-OFFS_FROM_SND_TO_MUS_DATA,X
	AND #%11101111
	STA Music_TrackOctaveTimingCtl-OFFS_FROM_SND_TO_MUS_DATA,X
	
	LDA <MusSnd_TempVar2	; PRG030_DelayTable2,Y
	LSR A					; Divided by 2
	ADD <MusSnd_TempVar2	; MusSnd_TempVar2 *= 1.5, essentially

PRG030_8406:
	ADD Music_TrackVolume,X
	STA Music_TrackVolume,X
	
	TAY	; -> 'Y'
	
	PLA	; Restore read byte value
	
	AND #%00011111	; Lower 5 bits
	BNE PRG030_8419	; If value is non-zero, jump to PRG030_8419

	JSR PRG030_SineWaveCtl_SetDecay	; Set Sound_SineWaveCtl command to 3 (note decay)

	JMP PRG030_SetMusic_NoteLengthToFF	; Jump to PRG030_SetMusic_NoteLengthToFF (Music_NoteLength-OFFS_FROM_SND_TO_MUS_DATA = $FF)


PRG030_8419:
	PHA	; Save lower 5 bit value
	
	STY <MusSnd_TempVar3	; (Adjusted) tick value
	
	LDA Music_NoteAttackLength-OFFS_FROM_SND_TO_MUS_DATA,X
	STA <MusSnd_TempVar0	; MusSnd_TempVar0 = Music_NoteAttackLength
	
	JSR PRG030_ComputeWaveformOffset

	LDA <MusSnd_TempVar0
	BNE PRG030_842A	; If MusSnd_TempVar0 <> 0, jump to PRG030_842A

	LDA #$01	; A = 1 if it was zero

PRG030_842A:
	STA Music_NoteLength-OFFS_FROM_SND_TO_MUS_DATA,X	; Music_NoteLength (>= 1)
	
	PLA	; Restore lower 5 bit value
	
	TAY	; -> 'Y'
	DEY	; Y--
	
	LDA Music_TrackOctaveTimingCtl-OFFS_FROM_SND_TO_MUS_DATA,X
	BPL PRG030_8440	; If Music_TrackOctaveTimingCtl bit 7 is not set, jump to PRG030_8440

	LDA Sound_FreqOffset,X
	BNE PRG030_8454	; If Sound_FreqOffset <> 0, jump to PRG030_8454

	; Sound_FreqOffset = 0...

	JSR PRG030_SineWave_ResetIfReq	; If Sound_SineWaveCtl bit 3 is set, clear Sound_SineWaveAccum

	JMP PRG030_847E	; Jump to PRG030_847E


PRG030_8440:
	; Music_TrackOctaveTimingCtl bit 7 not set...

	JSR PRG030_UpdVolAndWaveCtlCmd

	LDA <Sound_MusOverrideFlags
	BMI PRG030_8454			; If track is in use for sound effect, jump to PRG030_8454

	STY <MusSnd_TempVar2	; Backup Lower 5 bits value -> MusSnd_TempVar2
	
	; Relative track (0 to 3)
	TXA
	AND #$03
	TAY		; -> 'Y'
	
	; SndMus_SynthToneFreq = $FF
	LDA #$FF
	STA SndMus_SynthToneFreq,Y
	
	LDY <MusSnd_TempVar2	; Restore lower 5 bits value -> 'Y'

PRG030_8454:
	TXA
	AND #$03		; Relative track (0 to 3)
	BNE PRG030_8466	; If this is not the Noise track, jump to PRG030_8466

	; Noise channel only...

	STA <MusSnd_TempVar2	; MusSnd_TempVar2 = 0 (-> Sound_TrackFreqL)
	
	TYA	; A = lower 5 bits value
	
	AND #$0F	; Cap 0 to 15
	EOR #$0F	; Invert
				; -> Sound_TrackFreqH
	
	JSR PRG030_8636	; Set Sound_TrackFreqL/H

	JMP PRG030_847E	; Jump to PRG030_847E


PRG030_8466:
	; All tracks except Noise

	STY <MusSnd_TempVar2	; Backup Lower 5 bits value -> MusSnd_TempVar2
	
	LDA Music_TrackOctaveTimingCtl-OFFS_FROM_SND_TO_MUS_DATA,X
	AND #$0F	; mask octave
	TAY			; Y = octave select
	
	LDA PRG030_OctaveNoteBase,Y	; Base octave note
	ADD <MusSnd_TempVar2	; Specific note level
	ADD <Mus_NoteTranspose	; General Transposition
	ADD MusTrack_Transpose-OFFS_FROM_SND_TO_MUS_DATA,X	; Track-specific transposition
	
	; Set note frequency for music
	JSR PRG030_SetNoteFreq

PRG030_847E:
	LDA Music_TrackOctaveTimingCtl-OFFS_FROM_SND_TO_MUS_DATA,X
	TAY	; Backup Music_TrackOctaveTimingCtl -> 'Y'
	
	AND #%01000000
	ASL A
	STA <MusSnd_TempVar3	; Bit 6 -> shift left (7) -> MusSnd_TempVar3
	
	TYA	; Restore Music_TrackOctaveTimingCtl
	
	AND #%01111111			; Mask off bit 7
	ORA <MusSnd_TempVar3	; OR in what bit 6 was -> Bit 7
	STA Music_TrackOctaveTimingCtl-OFFS_FROM_SND_TO_MUS_DATA,X	; Update Music_TrackOctaveTimingCtl
	
	BPL PRG030_8496	; If bit 6 was zero (and now bit 7), jump to PRG030_8496


PRG030_SetMusic_NoteLengthToFF:
	LDA #$FF
	STA Music_NoteLength-OFFS_FROM_SND_TO_MUS_DATA,X

PRG030_8496:
	RTS	; $8496


PRG030_Process_00to1FVal:
	; Track byte value $00-$1F

	CMP #$04
	BLT PRG030_84A4	; If value < $04, jump to PRG030_84A4 (don't read another byte)

	; Values >= $04, read an additional byte implicitly into MusSnd_TempVar2

	STA <MusSnd_TempVar3	; Stores fetched value -> MusSnd_TempVar3
	
	JSR PRG030_FetchNextByteFromTrack	; Fetch another byte
	STA <MusSnd_TempVar2	; -> MusSnd_TempVar2
	
	LDA <MusSnd_TempVar3	; Reloads the fetched value

PRG030_84A4:
	JSR PRG030_DynJump

	.word PRG030_Cmd_ToggleDelaySel			; $00 toggle using PRG030_DelayTable1 / 2
	.word PRG030_Cmd_ToggleSineWaveReset	; $01 request sine wave disable
	.word PRG030_Cmd_Delay2_150P_Once		; $02 one-time 1.5x of PRG030_DelayTable2 value (only)
	.word PRG030_Cmd_ToggleOctaveHighBit	; $03 toggles highest bit of current octave
	.word PRG030_Cmd_TimingChange			; $04 set bits 3, 5, and 6 on Music_TrackOctaveTimingCtl (technically just an OR'd value against the rest, so use caution)
	.word PRG030_Cmd_SetTempo				; $05 set music tempo
	.word PRG030_Cmd_SetAttackLength		; $06 sets Music_NoteAttackLength
	.word PRG030_Cmd_SetSynthVolume			; $07 New synth volume, also sets constant volume / length counter disabled
	.word PRG030_Cmd_SetTrackPatch			; $08 sets "patch"
	.word PRG030_Cmd_SetOctave				; $09 set bits 0-2 on Music_TrackOctaveTimingCtl (technically just an OR'd value against the rest, so use caution)
	.word PRG030_Cmd_SetGlobalTranpose		; $0A sets Mus_NoteTranspose (global note tranposition value)
	.word PRG030_Cmd_SetTrackTranpose		; $0B sets MusTrack_Transpose (track-specific note tranposition value)
	.word PRG030_Cmd_SetFreqFineOffset		; $0C sets Sound_FreqFineOffset
	.word PRG030_Cmd_SetFreqOffset			; $0D sets Sound_FreqOffset
	.word PRG030_Cmd_LoopCounter0			; $0E Init/update loop counter 0
	.word PRG030_Cmd_LoopCounter1			; $0F Init/update loop counter 1
	.word PRG030_Cmd_LoopCounter2			; $10 Init/update loop counter 2
	.word PRG030_Cmd_LoopCounter3			; $11 Init/update loop counter 3
	.word PRG030_Cmd_LoopCounter0			; $12 Jump on last iteration of loop counter 0 (NOTE: not dupe of $0E due to logic)
	.word PRG030_Cmd_LoopCounter1			; $13 Jump on last iteration of loop counter 1 (NOTE: not dupe of $0F due to logic)
	.word PRG030_Cmd_LoopCounter2			; $14 Jump on last iteration of loop counter 2 (NOTE: not dupe of $10 due to logic)
	.word PRG030_Cmd_LoopCounter3			; $15 Jump on last iteration of loop counter 3 (NOTE: not dupe of $11 due to logic)
	.word PRG030_Cmd_JumpToAddress			; $16 Always jump to specified address
	.word PRG030_Cmd_StopTrack				; $17 stop/silence track
	.word PRG030_Cmd_SetDutyCycle			; $18 New duty cycle, also sets constant volume / length counter disabled
	
	; $19-$1F unused/invalid

PRG030_Cmd_ToggleDelaySel:
	LDA #%00100000	; Toggle bit 5 ($20) on Music_TrackOctaveTimingCtl (use PRG030_DelayTable1)
	BNE PRG030_84EA	; Jump (technically always) to PRG030_84EA

PRG030_Cmd_ToggleSineWaveReset:
	LDA #%01000000	; Toggle bit 6 ($40) on Music_TrackOctaveTimingCtl (will set bit 7, also set Music_NoteLength = $FF)
	BNE PRG030_84EA	; Jump (technically always) to PRG030_84EA

PRG030_Cmd_Delay2_150P_Once:
	LDA #%00010000	; Set (not toggle!) bit 4 ($10) on Music_TrackOctaveTimingCtl (PRG030_DelayTable2 * 1.5 one time use, cleared afterward)
	ORA Music_TrackOctaveTimingCtl-OFFS_FROM_SND_TO_MUS_DATA,X
	BNE PRG030_84ED	; Jump (technically always) to PRG030_84ED

PRG030_Cmd_ToggleOctaveHighBit:
	LDA #%00001000	; Toggle bit 3 ($08) on Music_TrackOctaveTimingCtl (toggles high bit of octave)

PRG030_84EA:
	EOR Music_TrackOctaveTimingCtl-OFFS_FROM_SND_TO_MUS_DATA,X	; Toggle bit

PRG030_84ED:
	STA Music_TrackOctaveTimingCtl-OFFS_FROM_SND_TO_MUS_DATA,X	; Update Music_TrackOctaveTimingCtl
	
	RTS	; $84F0


PRG030_Cmd_SetTempo:
	
	; MusTempoAccum_Frac = 0
	LDA #$00
	STA <MusTempoAccum_Frac
	
	; Fetch a second parameter
	JSR PRG030_FetchNextByteFromTrack

	LDY <MusSnd_TempVar2	; First parameter holds MusTempo value
	STA <MusTempo_Frac		; Second parameter -> MusTempo_Frac
	STY <MusTempo			; First parameter -> MusTempo
	RTS	; $84FE

PRG030_Cmd_SetAttackLength:

	; Set Music_NoteAttackLength to parameter
	LDA <MusSnd_TempVar2
	STA Music_NoteAttackLength-OFFS_FROM_SND_TO_MUS_DATA,X
	
	RTS	; $8504

PRG030_Cmd_SetOctave:
	LDA Music_TrackOctaveTimingCtl-OFFS_FROM_SND_TO_MUS_DATA,X
	AND #%11111000
	ORA <MusSnd_TempVar2	; OR in parameter
	STA Music_TrackOctaveTimingCtl-OFFS_FROM_SND_TO_MUS_DATA,X
	
	RTS	; $850F

PRG030_Cmd_SetGlobalTranpose:
	LDA <MusSnd_TempVar2
	STA <Mus_NoteTranspose	; Parameter -> Mus_NoteTranspose (global transpose)
	RTS	; $8514

PRG030_Cmd_SetTrackTranpose:
	LDA <MusSnd_TempVar2
	STA MusTrack_Transpose-OFFS_FROM_SND_TO_MUS_DATA,X	; Parameter -> MusTrack_Transpose (track specific transpose)
	RTS	; $851A

PRG030_Cmd_LoopCounter0:
	LDA #$00		; A = $00 (offset into Music_LoopCounters)
	BEQ PRG030_8529	; Jump (technically always) to PRG030_8529

PRG030_Cmd_LoopCounter1:
	LDA #$04		; A = $04 (offset into Music_LoopCounters)
	BNE PRG030_8529	; Jump (technically always) to PRG030_8529

PRG030_Cmd_LoopCounter2:
	LDA #$08		; A = $08 (offset into Music_LoopCounters)
	BNE PRG030_8529	; Jump (technically always) to PRG030_8529

PRG030_Cmd_LoopCounter3:
	; POSSIBLY not ever used in MM4?
	LDA #$0C		; A = $0C (offset into Music_LoopCounters)


PRG030_8529:
	STA <MusSnd_TempVar1	; MusSnd_TempVar1 = 0, 4, 8, or C, depending on originating caller
	
	; Y = track index + MusSnd_TempVar1 (0, 4, 8, or C)
	TXA						; Track index
	ADD <MusSnd_TempVar1	; +MusSnd_TempVar1 (0, 4, 8, or C)
	TAY
	
	LDA <MusSnd_TempVar3
	CMP #$12
	BGE PRG030_8547		; If the command value was >= $12, jump to PRG030_8547

	; If the respective loop counter is zero, we need to initialize it.
	LDA Music_LoopCounters-OFFS_FROM_SND_TO_MUS_DATA,Y
	SUB #$01			; Subtract 1 from loop counter
	BCS PRG030_8540		; If didn't underflow, jump to PRG030_8540

	; Initialize loop counter
	LDA <MusSnd_TempVar2	; Load parameter (loop counter)

PRG030_8540:
	STA Music_LoopCounters-OFFS_FROM_SND_TO_MUS_DATA,Y	; Update the loop counter
	
	BEQ PRG030_8566	; If the loop counter has just decremented to zero, jump to PRG030_8566 (bypass jump address)
	BNE PRG030_8555	; Otherwise, jump to PRG030_8555 (make the jump)


PRG030_8547:
	; Command $12 alternate

	LDA Music_LoopCounters-OFFS_FROM_SND_TO_MUS_DATA,Y
	SUB #$01			; Subtract 1 from loop counter (not committed unless it goes to zero)
	BNE PRG030_8566		; If didn't hit zero, jump to PRG030_8566 (bypass jump address)

	STA Music_LoopCounters-OFFS_FROM_SND_TO_MUS_DATA,Y	; Loop counter to zero
	
	; Use parameter 1 to set timing values
	JSR PRG030_Cmd_TimingChange


PRG030_8555:
	JSR PRG030_FetchNextByteFromTrack	; Fetch another byte (high byte of jump)
	STA <MusSnd_TempVar2				; -> MusSnd_TempVar2

PRG030_Cmd_JumpToAddress:
	JSR PRG030_FetchNextByteFromTrack	; Fetch another byte (low byte of jump)

	; New byte -> Music_TrackPtr_L
	STA Music_TrackPtr_L-OFFS_FROM_SND_TO_MUS_DATA,X
	
	; Parameter 1 -> Music_TrackPtr_H
	LDA <MusSnd_TempVar2
	STA Music_TrackPtr_H-OFFS_FROM_SND_TO_MUS_DATA,X
	
	RTS	; $8565


PRG030_8566:
	
	; Not making the jump, so bypass the destination address
	LDA #$02
	ADD Music_TrackPtr_L-OFFS_FROM_SND_TO_MUS_DATA,X
	STA Music_TrackPtr_L-OFFS_FROM_SND_TO_MUS_DATA,X
	
	BCC PRG030_8574	; If no carry, jump to PRG030_8574

	INC Music_TrackPtr_H-OFFS_FROM_SND_TO_MUS_DATA,X	; Music_TrackPtr_H++

PRG030_8574:
	RTS	; $8574


PRG030_Cmd_TimingChange:
	LDA Music_TrackOctaveTimingCtl-OFFS_FROM_SND_TO_MUS_DATA,X
	AND #%10010111					; preserve the octave (bits 0 to 2) and bit 4 ($10) (delay 2 1.5 sel) and bit 7 ($80) (sine wave disable)
	ORA <MusSnd_TempVar2			; OR input parameter
	STA Music_TrackOctaveTimingCtl-OFFS_FROM_SND_TO_MUS_DATA,X
	RTS	; $857F

PRG030_Cmd_StopTrack:
	; Pull return address
	PLA
	PLA
	
	LDA #$00	; $8582
	STA Music_TrackPatch,X	; $8584
	STA Music_SineWaveCtl,X	; $8587
	
	LDA <Sound_MusOverrideFlags
	BMI PRG030_8591	; If track is in use for sound effect, jump to PRG030_8591

	; Silence the track
	JMP PRG030_SynthSilence


PRG030_8591:
	RTS	; $8591


	; FIXME: What is the offset when doing sounds??
	; It can't be $00 because that would conflict
	
	; X = $00/$28 + (channel offset)
	;	$00/$28 - Noise
	;	$01/$29 - Tri
	;	$02/$2A - Square 2
	;	$03/$2B - Square 1
PRG030_FetchNextByteFromTrack:
	LDY Music_TrackPtr_L-$28,X

	; Advance music track pointer
	LDA Music_TrackPtr_H-$28,X
	INC Music_TrackPtr_L-$28,X
	BNE PRG030_85A0
	INC Music_TrackPtr_H-$28,X
PRG030_85A0:

	JMP PRG030_FixAndFetchByte	; Fetch next byte from track


PRG030_SineWaveCtl_SetDecay:

	; Sets command 3 (as called per PRG030_UpdateSynth)
	; This means just decay note (e.g. while track is resting)
	LDA Sound_SineWaveCtl,X
	AND #%11111000
	ORA #%00000011
	STA Sound_SineWaveCtl,X
	
	RTS	; $85AD


PRG030_UpdVolAndWaveCtlCmd:

	; Backup 'Y'
	TYA
	PHA
	
	LDY #$00	; Y = 0
	
	; Use command 0 (per PRG030_UpdateSynth)
	LDA Sound_SineWaveCtl,X
	AND #%11111000
	STA Sound_SineWaveCtl,X
	
	; Exceptions for Triangle tracks
	CPX #(OFFS_FROM_SND_TO_MUS_DATA+1)
	BEQ PRG030_85D0	; If this is the Triangle music track, jump to PRG030_85D0 (change to Sound_SineWaveCtl command 2)
	CPX #$01
	BNE PRG030_85D7	; If this is the Triangle sound effect track, jump to PRG030_85D7 (don't change Sound_SineWaveCtl command state if not music!)

	; Inputs to PRG030_ComputeWaveformOffset
	LDA <Sound_RestTimer	; $85C2
	STA <MusSnd_TempVar0	; $85C4
	
	LDA SndMus_SynthVolEnvDuty,X	; $85C6
	STA <MusSnd_TempVar3	; $85C9
	
	JSR PRG030_ComputeWaveformOffset	; $85CB

	LDY <MusSnd_TempVar0	; $85CE

PRG030_85D0:
	INY	; Y++
	
	; Use command 2 (per PRG030_UpdateSynth)
	INC Sound_SineWaveCtl,X
	INC Sound_SineWaveCtl,X

PRG030_85D7:

	; Set new track volume
	TYA
	STA Sound_TrackVolume,X
	
	; Restore 'Y'
	PLA
	TAY
	
	RTS	; $85DD


PRG030_SetNoteFreq:

	; Store note value; caps at $5F
	CMP #$60
	BLT PRG030_85E4		; If note value < $60, jump to PRG030_85E4

	LDA #$5F	; $5F maximum

PRG030_85E4:
	STA <MusSnd_TempVar2	; -> MusSnd_TempVar2	
	INC <MusSnd_TempVar2	; MusSnd_TempVar2++
	
	CPX #OFFS_FROM_SND_TO_MUS_DATA
	BLT PRG030_862A	; If this is a sound track and not a music track, jump to PRG030_862A
	
	; Music track only...

	LDA Sound_LastNotePlayed,X
	BEQ PRG030_861D	; If no previous note played, jump to PRG030_861D

	CMP <MusSnd_TempVar2	; Sound_LastNotePlayed vs MusSnd_TempVar2
	BNE PRG030_85FC	; If this note isn't the same as the last note played, jump to PRG030_85FC

	; Same note played...

	LDA Music_TrackOctaveTimingCtl-OFFS_FROM_SND_TO_MUS_DATA,X
	BPL PRG030_861D	; If Music_TrackOctaveTimingCtl bit 7 ($80) not set, jump to PRG030_861D

	BMI PRG030_SineWave_ResetIfReq	; Otherwise, jump to PRG030_SineWave_ResetIfReq


PRG030_85FC:
	; Different note than last time on music track

	LDA Sound_FreqOffset,X
	BEQ PRG030_861D	; If Sound_FreqOffset = 0, jump to PRG030_861D

	BGE PRG030_8607	; If last note played was higher than this note, jump to PRG030_8607
	
	; Last note was lower than this note

	ORA #%10000000	; Set Sound_FreqOffset bit 7
	BNE PRG030_8609	; Jump (technically always) to PRG030_8609


PRG030_8607:
	; Last note was higher than this note

	AND #%01111111	; Clear Sound_FreqOffset bit 7

PRG030_8609:
	STA Sound_FreqOffset,X	; Update Sound_FreqOffset
	
	; Set Sound_SineWaveCtl bit 5 ($20)
	LDA Sound_SineWaveCtl,X
	ORA #%00100000
	STA Sound_SineWaveCtl,X
	
	LDA <MusSnd_TempVar2	; A = new note to play
	
	LDY Sound_LastNotePlayed,X
	STY <MusSnd_TempVar2		; Sound_LastNotePlayed -> MusSnd_TempVar2
	
	BNE PRG030_8627	; Jump (technically always?) to PRG030_8627


PRG030_861D:
	; Sound_FreqOffset = 0...

	; Clear Sound_SineWaveCtl bit 5 ($20)
	LDA Sound_SineWaveCtl,X
	AND #%11011111
	STA Sound_SineWaveCtl,X
	
	LDA <MusSnd_TempVar2	; Fetch the played note

PRG030_8627:
	STA Sound_LastNotePlayed,X	; Store new note played

PRG030_862A:
	ASL <MusSnd_TempVar2	; MusSnd_TempVar2 *= 2 (index into the frequency table)
	
	LDY <MusSnd_TempVar2	; Y = MusSnd_TempVar2
	
	
	; NOTE: SB: Primary frequency load for music notes / sound effects is HERE
	; Can offset frequency table and globally transpose stuff
	
	; Low part of frequency -> MusSnd_TempVar2
	LDA PRG030_FreqTable-2,Y
	STA <MusSnd_TempVar2
	
	; High part of frequency
	LDA PRG030_FreqTable-2+1,Y

PRG030_8636:
	STA Sound_TrackFreqH,X	; Storing high part of frequency
	
	; Storing low part of frequency
	LDA <MusSnd_TempVar2
	STA Sound_TrackFreqL,X
	
	LDY #$04	; Y = 4
	
	; Read patch byte 4
	LDA [MusSnd_PatchPtr_L],Y
	BMI PRG030_864C	; If negative, jump to PRG030_864C


PRG030_SineWave_ResetIfReq:
	LDA Sound_SineWaveCtl,X
	AND #%00001000
	BNE PRG030_864C	; If Sound_SineWaveCtl bit 3 is set, jump to PRG030_864C

	RTS	; $864B


PRG030_864C:
	; Sound_SineWaveAccum = 0
	LDA #$00
	STA Sound_SineWaveAccum,X
	
	; Clear bit 3 from Sound_SineWaveCtl
	LDA Sound_SineWaveCtl,X
	AND #%00110111
	STA Sound_SineWaveCtl,X
	
	RTS	; $8659

PRG030_Cmd_SetSynthVolume:
	CPX #$01
	BNE PRG030_8662	; If this is not a sound effect's Triangle track, jump to PRG030_8662
	
	; Sound effect Triangle track only... 

	LDA <MusSnd_TempVar2
	BNE PRG030_866B	; If MusSnd_TempVar2 (parameter) <> 0, jump to PRG030_866B


PRG030_8662:
	LDA SndMus_SynthVolEnvDuty,X
	AND #%11000000			; Preserve bits 6 and 7 only (duty cycle)
	ORA <MusSnd_TempVar2	; OR MusSnd_TempVar2 (new duty cycle)
	ORA #%00110000			; Force bits 4 and 5 (length counter halt, constant volume)

PRG030_866B:
	STA SndMus_SynthVolEnvDuty,X	; Update SndMus_SynthVolEnvDuty
	
	RTS	; $866E

PRG030_Cmd_SetTrackPatch:
	INC <MusSnd_TempVar2	; MusSnd_TempVar2++ (base at $01, since $00 is a silence value)
	
	LDA <MusSnd_TempVar2
	CMP Sound_TrackPatch,X
	BEQ PRG030_86A0	; If this is already the current patch, jump to PRG030_86A0 (RTS)

	STA Sound_TrackPatch,X	; Set new patch value
	TAY	; -> 'Y'
	
	; Set Sound_SineWaveCtl bit 3 ($08) which resets sinusoidal waveform
	LDA Sound_SineWaveCtl,X
	ORA #%00001000
	STA Sound_SineWaveCtl,X

	; Y is the Music_TrackPatch value for this channel
PRG030_SetPatchBaseAddr:
	DEY	; Y-- (because $00 is a silence value)
	
	; MusSnd_TempVar2 = 0
	LDA #$00
	STA <MusSnd_TempVar2
	
	TYA	; A = [Music_TrackPatch+channel] - 1
	
	; Performing a 16-bit shift left 3 bits
	ASL A	; x2
	ROL <MusSnd_TempVar2	; Bit 7 went to carry -> rolled into MusSnd_TempVar2
	ASL A	; x4
	ROL <MusSnd_TempVar2	; Bit 7 went to carry -> rolled into MusSnd_TempVar2
	ASL A	; x8
	ROL <MusSnd_TempVar2	; Bit 7 went to carry -> rolled into MusSnd_TempVar2
	
	ADD PRG030_PatchData_Address+1	; Add base low address
	STA <MusSnd_PatchPtr_L	; -> MusSnd_PatchPtr_L
	
	LDA <MusSnd_TempVar2	; The 3 bits that were shifted left are in here
	ADC PRG030_PatchData_Address	; Add base high address
	STA <MusSnd_PatchPtr_H	; -> MusSnd_PatchPtr_H

PRG030_86A0:
	RTS	; $86A0

PRG030_Cmd_SetFreqFineOffset:
	LDA <MusSnd_TempVar2
	STA Sound_FreqFineOffset,X
	
	RTS	; $86A6

PRG030_Cmd_SetFreqOffset:
	LDA <MusSnd_TempVar2
	STA Sound_FreqOffset,X
	
	RTS	; $86AC

PRG030_Cmd_SetDutyCycle:
	LDA SndMus_SynthVolEnvDuty,X
	AND #%00001111					; Preserve volume
	ORA <MusSnd_TempVar2			; OR in MusSnd_TempVar2 (new duty cycle)
	ORA #%00110000					; Force bits 4 and 5 (length counter halt, constant volume)
	STA SndMus_SynthVolEnvDuty,X	; Update SndMus_SynthVolEnvDuty
	
	RTS	; $86B9


	; Sound offset is based at $00
	; Music offset is based at $28
	;
	; X = $00/$28 + (channel offset)
	;	$00/$28 - Noise
	;	$01/$29 - Tri
	;	$02/$2A - Square 2
	;	$03/$2B - Square 1
PRG030_UpdateSynth:
	
	LDA Sound_TrackVolume,X
	STA <MusSnd_TempVar3	; Sound_TrackVolume -> MusSnd_TempVar3
	
	; Lower 3 bits of Sound_SineWaveCtl determine command to execute
	LDA Sound_SineWaveCtl,X
	AND #%00000111
	JSR PRG030_DynJump

	.word PRG030_AddPatchByte0ToVol		; 0
	.word PRG030_SubPatchByte1FromVol	; 1
	.word PRG030_DoSynthWrite			; 2 update hardware synths
	.word PRG030_SubPatchByte3FromVol	; 3 note decay
	.word PRG030_SineWaveCtl_DoNothing	; 4 do nothing


	; Func 0
PRG030_AddPatchByte0ToVol:
	; Read patch byte 0
	LDY #$00
	LDA [MusSnd_PatchPtr_L],Y
	
	TAY	; patch byte 0 -> 'Y'
	
	LDA <MusSnd_TempVar3			; current track volume
	ADD PRG030_TrackVolumeDelta,Y	; add track volume delta
	BCS PRG030_86E2					; If it overflowed, jump to PRG030_86E2 (cap at $F0)

	CMP #$F0
	BLT PRG030_871D		; If not exceeding $F0, jump to PRG030_871D

	; Exceeded $F0...

PRG030_86E2:
	LDA #$F0	; A = $F0 (cap)
	BNE PRG030_871A	; Jump (technically always) to PRG030_871A


	; Func 1
PRG030_SubPatchByte1FromVol:
	; Read patch byte 1
	LDY #$01
	LDA [MusSnd_PatchPtr_L],Y
	
	BEQ PRG030_86FB	; If patch byte 1 = 0, jump to PRG030_86FB

	TAY	; -> 'Y'
	
	LDA <MusSnd_TempVar3			; current track volume
	SUB PRG030_TrackVolumeDelta,Y	; subtract track volume delta
	BCC PRG030_86FB					; If it underflowed, jump to PRG030_86FB

	; Did not underflow...

	LDY #$02	; Y = 2
	CMP [MusSnd_PatchPtr_L],Y	
	BGE PRG030_871D	; If value >= patch byte 2, jump to PRG030_871D


PRG030_86FB:
	; Patch byte 1 was zero or value < patch byte 2...

	; Read patch byte 2
	LDY #$02
	LDA [MusSnd_PatchPtr_L],Y
	
	JMP PRG030_871A	; Jump to PRG030_871A


	; Func 3
PRG030_SubPatchByte3FromVol:
	TXA	
	AND #$03	; Track index relative 0 to 3
	CMP #$01
	BEQ PRG030_8718	; If this is the Triangle track, jump to PRG030_8718

	; Non-triangle track...

	; Read patch byte 3
	LDY #$03
	LDA [MusSnd_PatchPtr_L],Y
	BEQ PRG030_DoSynthWrite	; If zero, jump to PRG030_DoSynthWrite

	; Non-zero patch byte 3...

	TAY	; -> 'Y'
	
	LDA <MusSnd_TempVar3			; current track volume
	SUB PRG030_TrackVolumeDelta,Y	; subtract track volume delta
	BCS PRG030_871D					; If it didn't underflow, jump to PRG030_871D

	; Value underflowed...

PRG030_8718:
	LDA #$00	; A = 0 (track volume = 0)

PRG030_871A:
	INC Sound_SineWaveCtl,X	; Incrementing command ('yyy') part of Sound_SineWaveCtl (xxxx xyyy)

PRG030_871D:
	STA Sound_TrackVolume,X	; Update track volume setting


	; Func 2 (and general)
PRG030_DoSynthWrite:
	CPX #OFFS_FROM_SND_TO_MUS_DATA
	BLT PRG030_8737	; If this is a sound track rather than a music track, jump to PRG030_8737

	; Music track only...

	LDA <Sound_MusOverrideFlags
	BPL PRG030_872B	; If this track isn't in use by a sound effect, jump to PRG030_872B

	JMP PRG030_88A0	; Jump to PRG030_88A0


PRG030_872B:
	; Begin music track processing...
	
	LDA <Mus_MasterVol	; A = Mus_MasterVol
	
	LDY <Mus_MasterVol_Dir
	BMI PRG030_8733	; If Mus_MasterVol_Dir bit 7 ($80), jump to PRG030_8733

	EOR #$FF	; Invert Mus_MasterVol

PRG030_8733:
	CMP #$FF
	BNE PRG030_8740	; If value <> $FF, jump to PRG030_8740

	; Mus_MasterVol (possibly inverted) = $FF...

PRG030_8737:
	TXA	
	AND #$03	; A = 0 to 3 (relative track number)
	
	CMP #$01
	BNE PRG030_8760	; If this is not the Triangle track, jump to PRG030_8760 (load current track volume)

	; Triangle Track!

	BEQ PRG030_8752	; Jump (technically always) to PRG030_8752


PRG030_8740:
	; Mus_MasterVol (possibly inverted) <> $FF...

	CPX #(OFFS_FROM_SND_TO_MUS_DATA+1)
	BNE PRG030_875B	; If this is not the Triangle track, jump to PRG030_875B
	
	; Triangle track only...

	STA <MusSnd_TempVar3	; Mus_MasterVol (possibly inverted) -> MusSnd_TempVar3 (input to PRG030_ComputeWaveformOffset)
	
	LDA Music_NoteLength-OFFS_FROM_SND_TO_MUS_DATA,X
	STA <MusSnd_TempVar0	; Music_NoteLength-OFFS_FROM_SND_TO_MUS_DATA,X -> MusSnd_TempVar0 (input to PRG030_ComputeWaveformOffset)
	
	JSR PRG030_ComputeWaveformOffset	; $874B

	LDA <MusSnd_TempVar0
	BEQ PRG030_87AA	; If MusSnd_TempVar0 = 0, jump to PRG030_87AA (write $00 to synth)


PRG030_8752:
	; Triangle only -- triangle is basically fully on or off only

	LDA Sound_TrackVolume,X
	BEQ PRG030_87AA		; If Sound_TrackVolume,X = 0, jump to PRG030_87AA (write $00 to synth)

	LDA #$FF
	BNE PRG030_87AA	; Jump (technically always) to PRG030_87AA (write $FF to synth)


PRG030_875B:
	; Non-Triangle track...

	CMP Sound_TrackVolume,X
	BLT PRG030_8763	; If master volume value < Sound_TrackVolume, jump to PRG030_8763 (override max)


PRG030_8760:
	
	LDA Sound_TrackVolume,X	; Load current track volume

PRG030_8763:
	LSR A
	LSR A
	LSR A
	LSR A
	EOR #$0F	; Invert volume value
	STA <MusSnd_TempVar2	; volume bits -> MusSnd_TempVar2
	
	LDY #$06	; Y = 6
	
	; Read patch byte 6
	LDA [MusSnd_PatchPtr_L],Y
	
	CMP #$05
	BLT PRG030_8797	; If [patch byte 6] < 5, jump to PRG030_8797

	STA <MusSnd_TempVar3	; Patch byte 6 (>= 5) -> MusSnd_TempVar3
	
	LDY Sound_SineWaveAccum,X	; Y = Sound_SineWaveAccum,X
	
	LDA Sound_SineWaveCtl,X
	ASL A
	ASL A	; bit 6 -> carry
	
	TYA	; Sound_SineWaveAccum,X -> 'A'
	
	BCC PRG030_8782	; If Sound_SineWaveCtl,X bit 6 is not set, jump to PRG030_8782

	EOR #$FF	; Invert effect of Sound_SineWaveAccum,X (swing back waveform for descent of faux sinosuidal waveform)

PRG030_8782:
	BEQ PRG030_8797	; If value is zero, jump to PRG030_8797

	STA <MusSnd_TempVar0	; -> MusSnd_TempVar0
	
	JSR PRG030_ComputeWaveformOffset

	LDA <MusSnd_TempVar0	; $8789
	LSR A	; $878B
	LSR A	; $878C
	CMP #$10	; $878D
	BGE PRG030_87A5	; $878F

	CMP <MusSnd_TempVar2	; $8791
	BLT PRG030_8797	; $8793

	STA <MusSnd_TempVar2	; $8795

PRG030_8797:
	; MusSnd_TempVar3 = $10
	LDA #$10
	STA <MusSnd_TempVar3
	
	LDA SndMus_SynthVolEnvDuty,X
	SUB <MusSnd_TempVar2	; Subtract from volume (in this context)
	BIT <MusSnd_TempVar3	; Tests bit 4 ($10) in a way that won't damage the accumulator
	
	BNE PRG030_87AA	; If bit 4 ($10) is set, jump to PRG030_87AA (I think this is a "subtracted too much volume" check?)


PRG030_87A5:
	LDA SndMus_SynthVolEnvDuty,X
	AND #%11110000	; Clear volume setting bits

PRG030_87AA:
	; base synth config
	LDY #$00	; Y = 0 register offset (PAPU_CTL1, PAPU_CTL2, PAPU_TCR1, PAPU_NCTL1)
	JSR PRG030_SynthWrite

	TXA
	AND #$03
	TAY	; Y = 0 to 3 (track relative value)
	
	LDA SndMus_SynthToneFreq,Y
	BMI PRG030_880C	; If SndMus_SynthToneFreq bit 7 ($80) set, jump to PRG030_880C

	LDY #$05	; Y = 5
	
	; Read patch byte 5
	LDA [MusSnd_PatchPtr_L],Y
	BEQ PRG030_880C	; If [patch byte 5] = 0, jump to PRG030_880C

	STA <MusSnd_TempVar3	; Patch byte 5 -> MusSnd_TempVar3
	
	LDY Sound_SineWaveAccum,X	; $87C0
	
	LDA Sound_SineWaveCtl,X
	ASL A
	ASL A	; bit 6 -> carry
	
	TYA	; Sound_SineWaveAccum,X -> 'A'
	
	BCC PRG030_87CD	; If Sound_SineWaveCtl,X bit 6 is not set, jump to PRG030_87CD

	EOR #$FF	; Invert Sound_SineWaveAccum,X

PRG030_87CD:
	BEQ PRG030_880C	; If value is zero, jump to PRG030_880C

	STA <MusSnd_TempVar0	; -> MusSnd_TempVar0
	
	JSR PRG030_ComputeWaveformOffset	; $87D1

	; 16-bit shift right 4 bits across MusSnd_TempVar0/1
	LDA <MusSnd_TempVar0
	LSR A
	ROR <MusSnd_TempVar1
	LSR A
	ROR <MusSnd_TempVar1
	LSR A
	ROR <MusSnd_TempVar1
	LSR A
	ROR <MusSnd_TempVar1
		
	TAY	; Result -> 'Y'
	
	ORA <MusSnd_TempVar1
	BEQ PRG030_880C	; If post-shift is completely zero, jump to PRG030_880C

	; SB: This is where the dynamic waveform (dynamically modded frequency) is done; 
	; what makes the music "wobble" over a frequency

	LDA Sound_SineWaveCtl,X
	BMI PRG030_87FA	; If Sound_SineWaveCtl,X bit 7 is set jump to PRG030_87FA

	; Add frequency bend
	CLC
	LDA <MusSnd_TempVar1
	ADC Sound_TrackFreqL,X
	STA <MusSnd_TempVar1
	
	TYA	; 16-bit result -> 'A'	
	ADC Sound_TrackFreqH,X
	BNE PRG030_8809		; Jump (technically always) to PRG030_8809


PRG030_87FA:
	
	; Subtract frequency bend
	SEC	
	LDA Sound_TrackFreqL,X
	SBC <MusSnd_TempVar1
	STA <MusSnd_TempVar1
	
	LDA Sound_TrackFreqH,X
	STY <MusSnd_TempVar0
	SBC <MusSnd_TempVar0

PRG030_8809:
	TAY	; Frequency high -> 'Y'
	BNE PRG030_8814	; Jump (technically always) to PRG030_8814


PRG030_880C:
	; Waveform wobble post-shift wound up zero, so...
	
	; Reload standard frequency
	LDA Sound_TrackFreqL,X
	STA <MusSnd_TempVar1
	LDY Sound_TrackFreqH,X
	
PRG030_8814:
	CPX #OFFS_FROM_SND_TO_MUS_DATA
	BGE PRG030_8835	; If this is a music track instead of a sound track, jump to PRG030_8835
	
	; Sound only...

	LDA <Sound_LoopCounter	; $8818
	BPL PRG030_8835	; $881A

	; CHECKME - UNUSED?
	LDA <RAM_00D8
	BEQ PRG030_8835
	
	STA <MusSnd_TempVar3
	STY <MusSnd_TempVar0
	
	LDA <MusSnd_TempVar1
	PHA
	
	JSR PRG030_ComputeWaveformOffset
	
	PLA
	CLC
	ADC <MusSnd_TempVar1
	STA <MusSnd_TempVar1
	
	LDA #$00
	ADC <MusSnd_TempVar0
	TAY


PRG030_8835:
	TXA			; Track index -> 'A'
	AND #$03	; Reltive 0 to 3
	BNE PRG030_8849	; If this is not the Noise track, jump to PRG030_8849
	
	; Noise only...

	TYA			; High component of frequency -> 'A'
	AND #$0F	; Lower nibble of frequency high
	
	LDY #$07
	ORA [MusSnd_PatchPtr_L],Y	; OR byte 7 of patch data
	STA <MusSnd_TempVar1		; -> MusSnd_TempVar1
	
	; MusSnd_TempVar0 = 0
	LDA #$00
	STA <MusSnd_TempVar0
	
	BEQ PRG030_8884	; Jump (technically always) to PRG030_8884


PRG030_8849:
	; Not the noise track...

	TYA	; High component of frequency -> 'A'
	
	LDY #$08	; Y = 8
PRG030_884C:
	DEY	; Y--
	
	CMP PRG030_8953,Y
	BLT PRG030_884C		; If high component of frequency < PRG030_8953,Y loop!

	STA <MusSnd_TempVar0	; High component of frequency -> MusSnd_TempVar0
	
	; Add index from loop to MusSnd_TempVar0
	TYA
	ADD <MusSnd_TempVar0
	
	TAY		; Backup result -> 'Y'
	
	; Cap 0 to 7, plus 7
	AND #$07
	ADD #$07
	STA <MusSnd_TempVar0
	
	TYA	; Restore result -> 'A'
	
	AND #%00111000
	EOR #%00111000
	BEQ PRG030_8870	; If result = 0, jump to PRG030_8870


PRG030_8867:
	LSR <MusSnd_TempVar0	; $8867
	ROR <MusSnd_TempVar1	; $8869
	SUB #$08	; $886B
	BNE PRG030_8867	; $886E


PRG030_8870:
	LDY #$00	; Y = 0
	
	; Applying fine frequency offset
	LDA Sound_FreqFineOffset,X
	BEQ PRG030_8884	; If Sound_FreqFineOffset,X = 0, jump to PRG030_8884

	BPL PRG030_887A	; If Sound_FreqFineOffset,X bit 7 is not set, jump to PRG030_887A

	DEY	; Y = $FF (16-bit sign extension)

PRG030_887A:
	ADD <MusSnd_TempVar1
	STA <MusSnd_TempVar1	; MusSnd_TempVar1 += Sound_FreqFineOffset,X (register write)
	
	TYA	; $00/$FF (sign extension)
	ADC <MusSnd_TempVar0
	STA <MusSnd_TempVar0

PRG030_8884:
	; Fine tune on square or tri/noise freq
	LDY #$02	; Y = 2 register offset (PAPU_FT1, PAPU_FT2, PAPU_TFREQ1, PAPU_NFREQ1)
	LDA <MusSnd_TempVar1
	JSR PRG030_SynthWrite

	; Y selects relative channel (0 to 3)
	TXA
	AND #$03
	TAY
	
	LDA <MusSnd_TempVar0
	CMP SndMus_SynthToneFreq,Y
	BEQ PRG030_88A0	; If SndMus_SynthToneFreq = MusSnd_TempVar0, jump to PRG030_88A0

	STA SndMus_SynthToneFreq,Y	; SndMus_SynthToneFreq = MusSnd_TempVar0
	
	ORA #$08	; OR $08
	
	; Coarse frequency
	LDY #$03	; Y = 3 register offset (PAPU_CT1, PAPU_CT2, PAPU_TFREQ2, PAPU_NFREQ2)
	JSR PRG030_SynthWrite


PRG030_88A0:
	LDA Sound_SineWaveCtl,X
	AND #%00100000
	BEQ PRG030_88FA	; If Sound_SineWaveCtl bit 5 ($20) is NOT set, jump to PRG030_88FA

	LDA Sound_FreqOffset,X
	BEQ PRG030_88F2	; If Sound_FreqOffset = 0, jump to PRG030_88F2

	LDY #$00	; Y = $00 (16-bit sign extension)
	
	ASL A	; Sound_FreqOffset bit 7 -> carry
	
	PHP		; Save status
	
	BCC PRG030_88B8	; If Sound_FreqOffset bit 7 ($80) is NOT set, jump to PRG030_88B8

	NEG		; Negate Sound_FreqOffset * 2
	
	DEY	; Y = $FF (16-bit sign extension)

PRG030_88B8:
	ADD Sound_TrackFreqL,X	; Adding [Sound_FreqOffset * 2] (possibly negated)
	STA Sound_TrackFreqL,X
	
	TYA	; 16-bit sign extension	
	ADC Sound_TrackFreqH,X
	STA Sound_TrackFreqH,X
	
	LDA Sound_LastNotePlayed,X
	ASL A	; Index into frequency table
	TAY		; -> 'Y
	
	; 16-bit comparison against the frequency of the last note played
	SEC
	LDA Sound_TrackFreqL,X
	SBC PRG030_FreqTable-2,Y
	LDA Sound_TrackFreqH,X
	AND #$3F
	SBC PRG030_FreqTable-2+1,Y
	
	LDA #$FF	; A = $FF
	ADC #$00	; Adding carry
	
	PLP	; Restore processor status (Sound_FreqOffset bit 7 -> carry)
	
	ADC #$00	; Adding carry
	BNE PRG030_88FA	; If non-zero, jump to PRG030_88FA

	TXA
	BEQ PRG030_88FA	; If this is a Noise sound effect channel, jump to PRG030_88FA

	; Otherwise just reload frequency of last note plyaed
	LDA PRG030_FreqTable-2,Y
	STA Sound_TrackFreqL,X
	LDA PRG030_FreqTable-2+1,Y
	STA Sound_TrackFreqH,X

PRG030_88F2:

	; Clear bit 5 ($20) of Sound_SineWaveCtl
	LDA Sound_SineWaveCtl,X
	AND #%11011111
	STA Sound_SineWaveCtl,X

PRG030_88FA:
	LDY #$04	; Y = 4
	
	; Read patch byte 4
	LDA [MusSnd_PatchPtr_L],Y
	AND #%01111111
	BEQ PRG030_SineWaveCtl_DoNothing	; If patch byte 4's lower 7 bits are all zero, jump to PRG030_SineWaveCtl_DoNothing (RTS)

	; Add lower 7 bits of patch byte 4 to Sound_SineWaveAccum
	ADD Sound_SineWaveAccum,X
	STA Sound_SineWaveAccum,X
	
	BCC PRG030_SineWaveCtl_DoNothing	; If it hasn't overflowed, jump to PRG030_SineWaveCtl_DoNothing (RTS)

	; Essentially is flip-flopping the decay so it rises back up, giving a sinusoidal-ish waveform sound
	LDA Sound_SineWaveCtl,X	; $890B
	ADD #$40	; $890E
	STA Sound_SineWaveCtl,X	; $8911

PRG030_SineWaveCtl_DoNothing:
	RTS	; $8914


PRG030_DelayTable1:
	; Track byte value $20+, value built of the upper 3 bits, subtracted 1 (0 to 6)
	.byte $02, $04, $08, $10, $20, $40, $80


PRG030_DelayTable2:
	; Track byte value $20+, value built of the upper 3 bits, subtracted 1 (0 to 6)
	.byte $03, $06, $0C, $18, $30, $60, $C0


	; Base note index per octave level (note these are spaced by 12!)
PRG030_OctaveNoteBase:
	.byte $00	; $00
	.byte $0C	; $01
	.byte $18	; $02
	.byte $24	; $03
	.byte $30	; $04
	.byte $3C	; $05
	.byte $48	; $06
	.byte $54	; $07
	.byte $18	; $08
	.byte $24	; $09
	.byte $30	; $0A
	.byte $3C	; $0B
	.byte $48	; $0C
	.byte $54	; $0D
	.byte $60	; $0E
	.byte $6C	; $0F
	
PRG030_TrackVolumeDelta:
	.byte $00	; $00
	.byte $01	; $01
	.byte $02	; $02
	.byte $03	; $03
	.byte $04	; $04
	.byte $05	; $05
	.byte $06	; $06
	.byte $07	; $07
	.byte $08	; $08
	.byte $09	; $09
	.byte $0A	; $0A
	.byte $0B	; $0B
	.byte $0C	; $0C
	.byte $0E	; $0D
	.byte $0F	; $0E
	.byte $10	; $0F
	.byte $12	; $10
	.byte $13	; $11
	.byte $14	; $12
	.byte $16	; $13
	.byte $18	; $14
	.byte $1B	; $15
	.byte $1E	; $16
	.byte $23	; $17
	.byte $28	; $18
	.byte $30	; $19
	.byte $3C	; $1A
	.byte $50	; $1B
	.byte $7E	; $1C
	.byte $7F	; $1D
	.byte $FE	; $1E
	.byte $FF	; $1F

PRG030_8953:
	.byte $00, $07, $0E, $15, $1C, $23, $2A, $31

PRG030_FreqTable:
	.word $375C	; $01
	.word $369C	; $02
	.word $35E7	; $03
	.word $353C	; $04
	.word $349B	; $05
	.word $3402	; $06
	.word $3372	; $07
	.word $32EA	; $08
	.word $326A	; $09
	.word $31F1	; $0A
	.word $3180	; $0B
	.word $3114	; $0C
	.word $305C	; $0D
	.word $2F9C	; $0E
	.word $2EE7	; $0F
	.word $2E3C	; $10
	.word $2D9B	; $11
	.word $2D02	; $12
	.word $2C72	; $13
	.word $2BEA	; $14
	.word $2B6A	; $15
	.word $2AF1	; $16
	.word $2A80	; $17
	.word $2A14	; $18
	.word $295C	; $19
	.word $289C	; $1A
	.word $27E7	; $1B
	.word $273C	; $1C
	.word $269B	; $1D
	.word $2602	; $1E
	.word $2572	; $1F
	.word $24EA	; $20
	.word $246A	; $21
	.word $23F1	; $22
	.word $2380	; $23
	.word $2314	; $24
	.word $225C	; $25
	.word $219C	; $26
	.word $20E7	; $27
	.word $203C	; $28
	.word $1F9B	; $29
	.word $1F02	; $2A
	.word $1E72	; $2B
	.word $1DEA	; $2C
	.word $1D6A	; $2D
	.word $1CF1	; $2E
	.word $1C80	; $2F
	.word $1C14	; $30
	.word $1B5C	; $31
	.word $1A9C	; $32
	.word $19E7	; $33
	.word $193C	; $34
	.word $189B	; $35
	.word $1802	; $36
	.word $1772	; $37
	.word $16EA	; $38
	.word $166A	; $39
	.word $15F1	; $3A
	.word $1580	; $3B
	.word $1514	; $3C
	.word $145C	; $3D
	.word $139C	; $3E
	.word $12E7	; $3F
	.word $123C	; $40
	.word $119B	; $41
	.word $1102	; $42
	.word $1072	; $43
	.word $0FEA	; $44
	.word $0F6A	; $45
	.word $0EF1	; $46
	.word $0E80	; $47
	.word $0E14	; $48
	.word $0D5C	; $49
	.word $0C9C	; $4A
	.word $0BE7	; $4B
	.word $0B3C	; $4C
	.word $0A9B	; $4D
	.word $0A02	; $4E
	.word $0972	; $4F
	.word $08EA	; $50
	.word $086A	; $51
	.word $07F1	; $52
	.word $0780	; $53
	.word $0714	; $54
	.word $065C	; $55
	.word $059C	; $56
	.word $04E7	; $57
	.word $043C	; $58
	.word $039B	; $59
	.word $0302	; $5A
	.word $0272	; $5B
	.word $01EA	; $5C
	.word $016A	; $5D
	.word $00F1	; $5E
	.word $0080	; $5F
	.word $0014	; $60

	; CHECKME - UNUSED?
	.byte $40, $0C, $24, $00, $00, $27, $40, $0C, $27, $00, $00, $29	; $8A17 - $8A26
	.byte $40, $0C, $29, $00, $0C, $29, $40, $0C, $29, $00, $0C, $2A, $40, $18, $2A, $00	; $8A27 - $8A36
	.byte $00, $2B, $40, $0C, $2B, $00, $0C, $F9, $00	; $8A37 - $8A3F



PRG030_FinalValueConstant:	.byte (PRG030_MusSnd_AddrTable_End - PRG030_MusSnd_AddrTable) / 2



PRG030_PatchData_Address:	sda1 PRG030_PatchData

	
PRG030_MusSnd_AddrTable:
	sda1 PRG030_MUS_BrightMan		; $00
	sda1 PRG030_MUS_ToadMan			; $01
	sda1 PRG030_MUS_RingMan			; $02
	sda1 PRG030_MUS_DrillMan		; $03
	sda1 PRG030_MUS_PharaohMan		; $04
	sda1 PRG030_MUS_DiveMan			; $05
	sda1 PRG031_MUS_SkullMan		; $06
	sda1 PRG031_MUS_DustMan			; $07
	sda1 PRG031_MUS_Cossack1		; $08
	sda1 PRG031_MUS_Wily1			; $09
	sda1 PRG031_MUS_IntroStory		; $0A
	sda1 PRG031_MUS_Ending1			; $0B
	sda1 PRG031_MUS_BossVictory		; $0C
	sda1 PRG031_MUS_Password		; $0D
	sda1 PRG031_MUS_GameOver		; $0E
	sda1 PRG031_MUS_BossIntro		; $0F
	sda1 PRG031_MUS_StageSelect		; $10
	sda1 PRG031_MUS_Boss			; $11
	sda1 PRG031_MUS_Title			; $12
	sda2 PRG029_MUS_Ending2			; $13
	sda2 PRG029_MUS_GetWeapon		; $14
	sda2 PRG029_MUS_Cossack2		; $15
	sda2 PRG029_MUS_Wily2			; $16
	sda2 PRG029_SFX_Bright			; $17
	sda2 PRG029_SFX_ToadRain		; $18
	sda2 PRG029_SFX_RingBoomerang	; $19
	sda2 PRG029_SFX_DrillBomb		; $1A
	sda2 PRG029_SFX_PharaohShot		; $1B
	sda2 PRG029_SFX_CossackLightning	; $1C
	sda2 PRG029_SFX_PathDraw		; $1D
	sda2 PRG029_SFX_WaterSplash		; $1E
	sda2 PRG029_SFX_1Up				; $1F
	sda2 PRG029_SFX_20				; $20 Unused? Some kind of Mega Buster ish charge sound
	sda2 PRG029_SFX_PlayerShot		; $21
	sda2 PRG029_SFX_MegaBusterCharge	; $22
	sda2 PRG029_SFX_PlayerLand		; $23
	sda2 PRG029_SFX_PlayerHurt		; $24
	sda2 PRG029_SFX_RobotDeath		; $25
	sda2 PRG029_SFX_EnemyHit		; $26
	sda2 PRG029_SFX_MegaBusterHold	; $27
	sda2 PRG029_SFX_Explosion		; $28
	sda2 PRG029_SFX_EnergyGain		; $29
	sda2 PRG029_SFX_MenuConfirm		; $2A
	sda2 PRG029_SFX_ShotDeflect		; $2B
	sda2 PRG029_SFX_BossGate		; $2C
	sda2 PRG029_SFX_PasswordError	; $2D
	sda2 PRG029_SFX_MenuSelect		; $2E
	sda2 PRG029_SFX_PasswordCorrect	; $2F
	sda2 PRG029_SFX_WeaponMenu		; $30
	sda2 PRG029_SFX_GrasshopperHop	; $31
	sda2 PRG029_SFX_WireAdapter		; $32
	sda2 PRG029_SFX_TeleportLanding	; $33
	sda2 PRG029_SFX_34				; $34 Unused? Whhhheeeerr blurry sound (maybe a train horn?)
	sda2 PRG029_SFX_LetterType		; $35
	sda2 PRG029_SFX_36				; $36
	sda2 PRG029_SFX_BigExplosion	; $37
	sda2 PRG029_SFX_38				; $38 Unused? K-chshhh (I think of spikes emerging)
	sda2 PRG029_SFX_DisappearingBlock	; $39
	sda2 PRG029_MUS_SpecialItem		; $3A
	sda2 PRG029_MUS_WilyFortressIntro	; $3B
	sda2 PRG029_MUS_CossackFortIntro	; $3C
	sda2 PRG029_SFX_PlayerMBustShot	; $3D
	sda2 PRG029_SFX_PharaohShotCharged	; $3E
	sda2 PRG029_MUS_ProtoWhistle	; Unused Protoman's Whistle
	sda2 PRG029_SFX_WilyShip		; $40
	sda2 PRG029_SFX_TeleportOut		; $41
	sda2 PRG029_SFX_42				; $42 Unused? Weird brrrr sound with a "clopping" noise
	sda2 PRG029_MUS_IntroStoryTrain	; $43
	.byte $00, $00					; $44 Unused/empty
	sda2 PRG029_MUS_FinalBoss		; $45
	sda2 PRG029_MUS_FinalVictory	; $46
PRG030_MusSnd_AddrTable_End


	; This defines the music "instrument" data per patch value
	; Since $00 defines silence, these are based at $01
PRG030_PatchData:
	.byte $1F, $1F, $F0, $1F, $00, $00, $00, $00	; $01
	.byte $1F, $15, $20, $01, $80, $00, $00, $00	; $02
	.byte $1F, $1E, $C0, $07, $80, $00, $00, $80	; $03
	.byte $1F, $19, $C0, $09, $E4, $05, $00, $00	; $04
	.byte $1F, $1F, $F0, $1F, $94, $7F, $00, $00	; $05
	.byte $1A, $1F, $E0, $1C, $80, $00, $00, $00	; $06
	.byte $1F, $11, $50, $01, $E2, $04, $00, $00	; $07
	.byte $1F, $1A, $D0, $17, $92, $00, $26, $00	; $08
	.byte $1F, $18, $B0, $06, $80, $00, $00, $00	; $09
	.byte $1F, $1F, $F0, $11, $80, $00, $00, $00	; $0A
	.byte $1F, $1F, $F0, $1F, $FF, $03, $39, $00	; $0B
	.byte $1F, $1C, $90, $03, $FF, $04, $25, $00	; $0C
	.byte $1F, $00, $B0, $09, $E3, $02, $00, $00	; $0D
	.byte $1F, $1D, $C0, $11, $80, $00, $00, $00	; $0E
	.byte $1F, $1F, $F0, $1F, $94, $7F, $00, $00	; $0F
	.byte $18, $1B, $B0, $0E, $84, $7F, $00, $00	; $10
	.byte $1F, $00, $B0, $07, $E3, $02, $00, $00	; $11
	.byte $1B, $01, $A0, $16, $80, $00, $00, $00	; $12
	.byte $1F, $0C, $00, $02, $A3, $00, $09, $00	; $13
	.byte $1F, $1A, $D0, $0D, $DC, $06, $00, $00	; $14
	.byte $1F, $17, $D0, $05, $98, $02, $2C, $00	; $15
	.byte $1F, $1F, $F0, $13, $D0, $03, $7F, $00	; $16
	.byte $19, $13, $D0, $18, $80, $00, $00, $00	; $17
	.byte $1F, $00, $C0, $18, $80, $00, $00, $00	; $18
	.byte $1F, $01, $20, $09, $99, $10, $00, $00	; $19
	.byte $1A, $1F, $D0, $01, $80, $00, $00, $00	; $1A
	.byte $1F, $16, $C0, $14, $AB, $02, $00, $00	; $1B
	.byte $1F, $1B, $80, $05, $C9, $00, $38, $00	; $1C
	.byte $1F, $1F, $B0, $09, $00, $00, $00, $00	; $1D
	.byte $1F, $1D, $B0, $0C, $80, $00, $00, $00	; $1E
	.byte $1F, $19, $A0, $02, $80, $00, $00, $00	; $1F
	.byte $17, $02, $E0, $0F, $80, $00, $00, $00	; $20
	.byte $1E, $18, $C0, $12, $00, $00, $00, $00	; $21
	.byte $1F, $07, $20, $16, $82, $14, $00, $00	; $22
	.byte $1F, $19, $B0, $04, $E4, $05, $00, $00	; $23
	.byte $1F, $1E, $A0, $0A, $AA, $00, $4B, $00	; $24
	.byte $1F, $18, $90, $05, $00, $00, $00, $00	; $25
	.byte $00, $00, $00, $00, $80, $00, $00, $00	; $26
	.byte $1A, $1F, $D0, $07, $80, $00, $00, $00	; $27
	.byte $00, $00, $00, $00, $80, $00, $00, $00	; $28
	.byte $1F, $1F, $F0, $1F, $00, $00, $00, $00	; $29
	.byte $1F, $1F, $F0, $1F, $FF, $02, $00, $00	; $2A
	.byte $1F, $1F, $F0, $1F, $92, $7F, $00, $00	; $2B
	.byte $1F, $1C, $C0, $15, $80, $00, $00, $00	; $2C
	.byte $1F, $1F, $F0, $1F, $FF, $4C, $00, $00	; $2D
	.byte $1F, $1F, $F0, $1F, $99, $7F, $00, $00	; $2E
	.byte $1D, $1F, $F0, $1F, $80, $00, $00, $00	; $2F
	.byte $1F, $1F, $F0, $1F, $B7, $27, $00, $00	; $30
	.byte $1F, $1F, $F0, $0F, $D7, $09, $7F, $00	; $31
	.byte $1F, $1F, $F0, $1F, $A6, $7F, $00, $80	; $32
	.byte $1F, $1F, $F0, $1F, $80, $00, $00, $80	; $33
	.byte $1F, $01, $F0, $05, $E1, $0D, $00, $00	; $34
	.byte $1F, $1F, $F0, $1F, $C1, $04, $7F, $00	; $35
	.byte $1C, $13, $10, $1F, $FF, $7F, $00, $00	; $36
	.byte $1F, $01, $00, $0F, $E3, $7F, $00, $00	; $37
	.byte $1E, $10, $F0, $0E, $80, $00, $00, $00	; $38
	.byte $1F, $1F, $F0, $1F, $FF, $7F, $00, $00	; $39
	.byte $1F, $17, $00, $16, $80, $00, $00, $00	; $3A
	.byte $1F, $1F, $F0, $16, $80, $00, $00, $00	; $3B
	.byte $1F, $01, $F0, $05, $E1, $0D, $00, $00	; $3C
	.byte $1F, $1A, $A0, $07, $CF, $36, $00, $80	; $3D
	.byte $1D, $04, $20, $12, $00, $00, $00, $00	; $3E
	.byte $11, $12, $30, $04, $00, $00, $00, $00	; $3F
	.byte $1F, $1F, $F0, $1F, $D0, $16, $00, $00	; $40
	.byte $1C, $1F, $F0, $07, $FF, $7F, $36, $00	; $41
	.byte $19, $0B, $F0, $12, $FF, $7F, $36, $80	; $42
	.byte $1F, $12, $40, $1E, $FF, $7F, $51, $80	; $43
	.byte $17, $1F, $F0, $02, $FF, $7F, $5A, $00	; $44
	.byte $12, $02, $A0, $05, $00, $00, $00, $00	; $45
	.byte $1F, $1F, $F0, $1F, $FF, $19, $00, $00	; $46
	.byte $17, $14, $F0, $07, $CA, $54, $00, $00	; $47


;TEST_MUS

	IFDEF TEST_MUS
	
	; $60 = 96
	; 96 / 60 = 1.6
	; 1.6 x 256 = 409.6 = ~19A hex

PRG030_MUS_BrightMan:
	.byte $00			; ???
	
	sda1 PRG030_8D12	; Square 1
	;sda1 PRG030_8DDC	; Square 2
	;sda1 PRG030_8E8F	; Triangle
	;sda1 PRG030_8FB0	; Noise
	
	sda1 $0000
	sda1 $0000
	sda1 $0000
	
PRG030_8D12:
	.byte $05, $01, $99		; tempo
	.byte $0A, $00			; global transpose
	.byte $06, $C8			; attack length
	
	.byte $04, $00			; Set bits 3, 5, and 6 on Music_TrackOctaveTimingCtl
	.byte $09, $02			; Set octave
	.byte $07, $0C			; New synth vol
	.byte $06, $90			; attack length
	.byte $08, $10			; set patch
	.byte $18, $80			; set duty cycle
	
PRG030_LoopPoint
	.byte $01
	.byte %10010000
	.byte %10010000
	.byte $01
	.byte %10110000
	.byte %11011100
	
	;.byte %11000000
	
	.byte $16
	sda1 PRG030_LoopPoint
	
	.byte $17	; terminator, probably never needed?

	ENDIF


PRG030_MUS_BrightMan:	.include "PRG/MUSDATA/Track00.asm"
PRG030_MUS_ToadMan:		.include "PRG/MUSDATA/Track01.asm"
PRG030_MUS_RingMan:		.include "PRG/MUSDATA/Track02.asm"
PRG030_MUS_DrillMan:	.include "PRG/MUSDATA/Track03.asm"
PRG030_MUS_PharaohMan:	.include "PRG/MUSDATA/Track04.asm"

	.org $9FAB		; Putting this here because the table is split over 62-63 and there's no nice way to handle it in NESASM
PRG030_MUS_DiveMan:
	.byte $00, $9F, $B4, $A0, $AA, $A1, $D5, $A2, $F7, $04, $08, $04, $08, $05, $02, $66	; $9FAB - $9FBA
	.byte $18, $C0, $0A, $FA, $07, $0B, $06, $EB, $08, $17, $09, $02, $AD, $AD, $8B, $8D	; $9FBB - $9FCA
	.byte $80, $8D, $80, $8D, $80, $8D, $0D, $50, $90, $0D, $00, $8D, $8B, $12, $08, $9F	; $9FCB - $9FDA
	.byte $E2, $01, $8D, $0E, $01, $9F, $B6, $8D, $8F, $02, $C0, $0D, $50, $01, $90, $0D	; $9FDB - $9FEA
	.byte $00, $02, $01, $B0, $02, $AF, $80, $01, $8D, $01, $ED, $C0, $80, $18, $80, $87	; $9FEB - $9FFA
	.byte $88, $01, $8D, $04, $08
	
	; Continued into PRG031


