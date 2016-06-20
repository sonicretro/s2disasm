; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; simplifying macros and functions

; makes a VDP address difference
vdpCommDelta function addr,((addr&$3FFF)<<16)|((addr&$C000)>>14)

; makes a VDP command
vdpComm function addr,type,rwd,(((type&rwd)&3)<<30)|((addr&$3FFF)<<16)|(((type&rwd)&$FC)<<2)|((addr&$C000)>>14)

; values for the type argument
VRAM = %100001
CRAM = %101011
VSRAM = %100101

; values for the rwd argument
READ = %001100
WRITE = %000111
DMA = %100111

; tells the VDP to copy a region of 68k memory to VRAM or CRAM or VSRAM
dma68kToVDP macro source,dest,length,type
	lea	(VDP_control_port).l,a5
	move.l	#(($9400|((((length)>>1)&$FF00)>>8))<<16)|($9300|(((length)>>1)&$FF)),(a5)
	move.l	#(($9600|((((source)>>1)&$FF00)>>8))<<16)|($9500|(((source)>>1)&$FF)),(a5)
	move.w	#$9700|(((((source)>>1)&$FF0000)>>16)&$7F),(a5)
	move.w	#((vdpComm(dest,type,DMA)>>16)&$FFFF),(a5)
	move.w	#(vdpComm(dest,type,DMA)&$FFFF),(DMA_data_thunk).w
	move.w	(DMA_data_thunk).w,(a5)
    endm

; tells the VDP to fill a region of VRAM with a certain byte
dmaFillVRAM macro byte,addr,length
	lea	(VDP_control_port).l,a5
	move.w	#$8F01,(a5) ; VRAM pointer increment: $0001
	move.l	#(($9400|((((length)-1)&$FF00)>>8))<<16)|($9300|(((length)-1)&$FF)),(a5) ; DMA length ...
	move.w	#$9780,(a5) ; VRAM fill
	move.l	#$40000080|(((addr)&$3FFF)<<16)|(((addr)&$C000)>>14),(a5) ; Start at ...
	move.w	#(byte)<<8,(VDP_data_port).l ; Fill with byte
.loop:	move.w	(a5),d1
	btst	#1,d1
	bne.s	.loop ; busy loop until the VDP is finished filling...
	move.w	#$8F02,(a5) ; VRAM pointer increment: $0002
    endm

; calculates initial loop counter value for a dbf loop
; that writes n bytes total at 4 bytes per iteration
bytesToLcnt function n,n>>2-1

; calculates initial loop counter value for a dbf loop
; that writes n bytes total at 2 bytes per iteration
bytesToWcnt function n,n>>1-1

; fills a region of 68k RAM with 0
clearRAM macro startaddr,endaddr
    if ((startaddr)&$8000)==0
	lea	(startaddr).l,a1
    else
	lea	(startaddr).w,a1
    endif
	moveq	#0,d0
    if ((startaddr)&1)
	move.b	d0,(a1)+
    endif
	move.w	#bytesToLcnt((endaddr-startaddr) - ((startaddr)&1)),d1
.loop:	move.l	d0,(a1)+
	dbf	d1,.loop
    if (((endaddr-startaddr) - ((startaddr)&1))&2)
	move.w	d0,(a1)+
    endif
    if (((endaddr-startaddr) - ((startaddr)&1))&1)
	move.b	d0,(a1)+
    endif
    endm

; tells the Z80 to stop, and waits for it to finish stopping (acquire bus)
stopZ80 macro
	move.w	#$100,(Z80_Bus_Request).l ; stop the Z80
.loop:	btst	#0,(Z80_Bus_Request).l
	bne.s	.loop ; loop until it says it's stopped
    endm

; tells the Z80 to start again
startZ80 macro
	move.w	#0,(Z80_Bus_Request).l    ; start the Z80
    endm

; function to make a little-endian 16-bit pointer for the Z80 sound driver
z80_ptr function x,(x)<<8&$FF00|(x)>>8&$7F|$80

; macro to declare a little-endian 16-bit pointer for the Z80 sound driver
rom_ptr_z80 macro addr
	dc.w z80_ptr(addr)
    endm

; aligns the start of a bank, and detects when the bank's contents is too large
; can also print the amount of free space in a bank with DebugSoundbanks set
startBank macro {INTLABEL}
	align	$8000
__LABEL__ label *
soundBankStart := __LABEL__
soundBankName := "__LABEL__"
    endm

DebugSoundbanks := 0

finishBank macro
	if * > soundBankStart + $8000
		fatal "soundBank \{soundBankName} must fit in $8000 bytes but was $\{*-soundBankStart}. Try moving something to the other bank."
	elseif (DebugSoundbanks<>0)&&(MOMPASS=1)
		message "soundBank \{soundBankName} has $\{$8000+soundBankStart-*} bytes free at end."
	endif
    endm

; macro to replace the destination with its absolute value
abs macro destination
	tst.ATTRIBUTE	destination
	bpl.s	.skip
	neg.ATTRIBUTE	destination
.skip:
    endm

    if 0|allOptimizations
absw macro destination	; use a short branch instead
	abs.ATTRIBUTE	destination
    endm
    else
; macro to replace the destination with its absolute value using a word-sized branch
absw macro destination
	tst.ATTRIBUTE	destination
	bpl.w	.skip
	neg.ATTRIBUTE	destination
.skip:
    endm
    endif

; macro to move the absolute value of the source in the destination
mvabs macro source,destination
	move.ATTRIBUTE	source,destination
	bpl.s	.skip
	neg.ATTRIBUTE	destination
.skip:
    endm

; macro to declare an offset table
offsetTable macro {INTLABEL}
current_offset_table := __LABEL__
__LABEL__ label *
    endm

; macro to declare an entry in an offset table
offsetTableEntry macro ptr
	dc.ATTRIBUTE ptr-current_offset_table
    endm

; macro to declare a zone-ordered table
; entryLen is the length of each table entry, and zoneEntries is the number of entries per zone
zoneOrderedTable macro entryLen,zoneEntries,{INTLABEL}
__LABEL__ label *
; set some global variables
zone_table_name := "__LABEL__"
zone_table_addr := *
zone_entry_len := entryLen
zone_entries := zoneEntries
zone_entries_left := 0
cur_zone_id := 0
cur_zone_str := "0"
    endm

zoneOrderedOffsetTable macro entryLen,zoneEntries,{INTLABEL}
current_offset_table := __LABEL__
__LABEL__ zoneOrderedTable entryLen,zoneEntries
    endm

; macro to declare one or more entries in a zone-ordered table
zoneTableEntry macro value
	if "value"<>""
	    if zone_entries_left
		dc.ATTRIBUTE value
zone_entries_left := zone_entries_left-1
	    else
		!org zone_table_addr+zone_id_{cur_zone_str}*zone_entry_len*zone_entries
		dc.ATTRIBUTE value
zone_entries_left := zone_entries-1
cur_zone_id := cur_zone_id+1
cur_zone_str := "\{cur_zone_id}"
	    endif
	    shift
	    zoneTableEntry.ATTRIBUTE ALLARGS
	endif
    endm

; macro to declare one or more BINCLUDE entries in a zone-ordered table
zoneTableBinEntry macro numEntries,path
	if zone_entries_left
	    BINCLUDE path
zone_entries_left := zone_entries_left-numEntries
	else
	    !org zone_table_addr+zone_id_{cur_zone_str}*zone_entry_len*zone_entries
	    BINCLUDE path
zone_entries_left := zone_entries-numEntries
cur_zone_id := cur_zone_id+1
cur_zone_str := "\{cur_zone_id}"
	endif
    endm

; macro to declare one entry in a zone-ordered offset table
zoneOffsetTableEntry macro value
	zoneTableEntry.ATTRIBUTE value-current_offset_table
    endm

; macro which sets the PC to the correct value at the end of a zone offset table and checks if the correct
; number of entries were declared
zoneTableEnd macro
	if (cur_zone_id<>no_of_zones)&&(MOMPASS=1)
	    message "Warning: Table \{zone_table_name} has \{cur_zone_id/1.0} entries, but it should have \{(no_of_zones)/1.0} entries"
	endif
	!org zone_table_addr+cur_zone_id*zone_entry_len*zone_entries
    endm

; macro to declare sub-object data
subObjData macro mappings,vram,renderflags,priority,width,collision
	dc.l mappings
	dc.w vram
	dc.b renderflags,priority,width,collision
    endm

; macros for defining animated PLC script lists
zoneanimstart macro {INTLABEL}
__LABEL__ label *
zoneanimcount := 0
zoneanimcur := "__LABEL__"
	dc.w zoneanimcount___LABEL__	; Number of scripts for a zone (-1)
    endm

zoneanimend macro
zoneanimcount_{"\{zoneanimcur}"} = zoneanimcount-1
    endm

zoneanimdeclanonid := 0

zoneanimdecl macro duration,artaddr,vramaddr,numentries,numvramtiles
zoneanimdeclanonid := zoneanimdeclanonid + 1
start:
	dc.l (duration&$FF)<<24|artaddr
	dc.w tiles_to_bytes(vramaddr)
	dc.b numentries, numvramtiles
zoneanimcount := zoneanimcount + 1
    endm

; macros to convert from tile index to art tiles, block mapping or VRAM address.
make_art_tile function addr,pal,pri,((pri&1)<<15)|((pal&3)<<13)|(addr&tile_mask)
make_art_tile_2p function addr,pal,pri,((pri&1)<<15)|((pal&3)<<13)|((addr&tile_mask)>>1)
make_block_tile function addr,flx,fly,pal,pri,((pri&1)<<15)|((pal&3)<<13)|((fly&1)<<12)|((flx&1)<<11)|(addr&tile_mask)
make_block_tile_2p function addr,flx,fly,pal,pri,((pri&1)<<15)|((pal&3)<<13)|((fly&1)<<12)|((flx&1)<<11)|((addr&tile_mask)>>1)
tiles_to_bytes function addr,((addr&$7FF)<<5)
make_block_tile_pair function addr,flx,fly,pal,pri,((make_block_tile(addr,flx,fly,pal,pri)<<16)|make_block_tile(addr,flx,fly,pal,pri))
make_block_tile_pair_2p function addr,flx,fly,pal,pri,((make_block_tile_2p(addr,flx,fly,pal,pri)<<16)|make_block_tile_2p(addr,flx,fly,pal,pri))

; function to calculate the location of a tile in plane mappings with a width of 64 cells
planeLocH40 function col,line,(($80 * line) + (2 * col))

; function to calculate the location of a tile in plane mappings with a width of 128 cells
planeLocH80 function col,line,(($100 * line) + (2 * col))
