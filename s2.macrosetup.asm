
	padding off		; we don't want AS padding out dc.b instructions
	;listing off		; We don't need to generate anything for a listing file
	;listing on		; Want full listing file
	;listing noskipped	; Want listing file, but only the non-skipped part of conditional assembly
	listing purecode	; Want listing file, but only the final code in expanded macros
	page	0		; Don't want form feeds
	supmode on		; we don't need warnings about privileged instructions


paddingSoFar set 0

; 128 = 80h = z80, 32988 = 80DCh = z80unDoC 
notZ80 function cpu,(cpu<>128)&&(cpu<>32988)

; make org safer (impossible to overwrite previously assembled bytes) and count padding
; and also make it work in Z80 code without creating a new segment
org macro address
	if notZ80(MOMCPU)
		if address < *
			error "too much stuff before org $\{address} ($\{(*-address)} bytes)"
		elseif address > *
paddingSoFar	set paddingSoFar + address - *
			!org address
		endif
	else
		if address < $
			error "too much stuff before org 0\{address}h (0\{($-address)}h bytes)"
		else
			while address > $
				db 0
			endm
		endif
	endif
    endm

; define the cnop pseudo-instruction
cnop macro offset,alignment
	if notZ80(MOMCPU)
		org (*-1+(alignment)-((*-1+(-(offset)))#(alignment)))
	else
		org ($-1+(alignment)-(($-1+(-(offset)))#(alignment)))
	endif
    endm

; redefine align in terms of cnop, for the padding counter
align macro alignment
	cnop 0,alignment
    endm

; define the even pseudo-instruction
even macro
	if notZ80(MOMCPU)
		if (*)&1
paddingSoFar		set paddingSoFar+1
			dc.b 0 ;ds.b 1 
		endif
	else
		if ($)&1
			db 0
		endif
	endif
    endm

; make ds work in Z80 code without creating a new segment
ds macro
	if notZ80(MOMCPU)
		!ds.ATTRIBUTE ALLARGS
	else
		rept ALLARGS
			db 0
		endm
	endif
   endm

  if TRUE
; define a trace macro
; lets you easily check what address a location in this disassembly assembles to
; if used in Z80 code, the displayed PC will be relative to the start of Z80 RAM
trace macro optionalMessageWithoutQuotes
    if MOMPASS=1
	if notZ80(MOMCPU)
		if ("ALLARGS"<>"")
			message "#\{tracenum/1.0}: line=\{MOMLINE/1.0} PC=$\{*} msg=ALLARGS"
		else
			message "#\{tracenum/1.0}: line=\{MOMLINE/1.0} PC=$\{*}"
		endif
	else
		if ("ALLARGS"<>"")
			message "#\{tracenum/1.0}: line=\{MOMLINE/1.0} PC=\{$}h msg=ALLARGS"
		else
			message "#\{tracenum/1.0}: line=\{MOMLINE/1.0} PC=\{$}h"
		endif
	endif
tracenum := (tracenum+1)
    endif
   endm
  else
trace macro
	endm
  endif
tracenum := 0

chkop function op,ref,(substr(lowstring(op),0,strlen(ref))<>ref)

    if zeroOffsetOptimization=0
    ; disable a space optimization in AS so we can build a bit-perfect ROM
    ; (the hard way, but it requires no modification of AS itself)

; 1-arg instruction that's self-patching to remove 0-offset optimization
insn1op	 macro oper,x
	  if (chkop("x","0(") && chkop("x","id(") && chkop("x","slot_rout(") && chkop("x","soundqueue.music0("))
		!oper	x
	  else
		!oper	1+x
		!org	*-1
		!dc.b	0
	  endif
	 endm

; 2-arg instruction that's self-patching to remove 0-offset optimization
insn2op	 macro oper,x,y
	  if (chkop("x","0(") && chkop("x","id(") && chkop("x","slot_rout(") && chkop("x","soundqueue.music0("))
		  if (chkop("y","0(") && chkop("y","id(") && chkop("y","slot_rout(") && chkop("y","soundqueue.music0("))
			!oper	x,y
		  else
			!oper	x,1+y
			!org	*-1
			!dc.b	0
		  endif
	  else
		if chkop("y","d")
		  if (chkop("y","0(") && chkop("y","id(") && chkop("y","slot_rout(") && chkop("y","soundqueue.music0("))
start:
			!oper	1+x,y
end:
			!org	start+3
			!dc.b	0
			!org	end
		  else
			!oper	1+x,1+y
			!org	*-3
			!dc.b	0
			!org	*+1
			!dc.b	0
		  endif
		else
			!oper	1+x,y
			!org	*-1
			!dc.b	0
		endif
	  endif
	 endm

	; instructions that were used with 0(a#) syntax
	; defined to assemble as they originally did
_move	macro
		insn2op move.ATTRIBUTE, ALLARGS
	endm
_add	macro
		insn2op add.ATTRIBUTE, ALLARGS
	endm
_addq	macro
		insn2op addq.ATTRIBUTE, ALLARGS
	endm
_cmp	macro
		insn2op cmp.ATTRIBUTE, ALLARGS
	endm
_cmpi	macro
		insn2op cmpi.ATTRIBUTE, ALLARGS
	endm
_clr	macro
		insn1op clr.ATTRIBUTE, ALLARGS
	endm
_tst	macro
		insn1op tst.ATTRIBUTE, ALLARGS
	endm

	else

	; regular meaning to the assembler; better but unlike original
_move	macro
		!move.ATTRIBUTE ALLARGS
	endm
_add	macro
		!add.ATTRIBUTE ALLARGS
	endm
_addq	macro
		!addq.ATTRIBUTE ALLARGS
	endm
_cmp	macro
		!cmp.ATTRIBUTE ALLARGS
	endm
_cmpi	macro
		!cmpi.ATTRIBUTE ALLARGS
	endm
_clr	macro
		!clr.ATTRIBUTE ALLARGS
	endm
_tst	macro
		!tst.ATTRIBUTE ALLARGS
	endm

    endif

	; in REV02, almost all possible add/sub optimizations were made.
	; this toggle allows you to have them in any revision
    if addsubOptimize
	; if addsubOptimize, optimize these
addi_	macro
		!addq.ATTRIBUTE ALLARGS
	endm
subi_	macro
		!subq.ATTRIBUTE ALLARGS
	endm
adda_	macro
		!addq.ATTRIBUTE ALLARGS
	endm

    else

	; otherwise, leave them unoptimized
addi_	macro
		!addi.ATTRIBUTE ALLARGS
	endm
subi_	macro
		!subi.ATTRIBUTE ALLARGS
	endm
adda_	macro
		!adda.ATTRIBUTE ALLARGS
	endm

    endif

; depending on if relativeLea is set or not, this will create a pc-relative lea or an absolute long lea.
lea_ macro address,reg
	if relativeLea
		!lea address(pc),reg
	else
		!lea (address).l,reg
	endif
    endm

_btst macro x,y
last_btst_converted := ~~chkop("x","#render_flags.on_screen") || ~~chkop("x","#status.npc.no_balancing") || ~~chkop("x","#status_secondary.sliding")

	if last_btst_converted
		tst.b	y
	else
		btst	x,y
	endif
    endm

_beq macro x
	if last_btst_converted
		bpl.ATTRIBUTE	x
	else
		beq.ATTRIBUTE	x
	endif
    endm

_bne macro x
	if last_btst_converted
		bmi.ATTRIBUTE	x
	else
		bne.ATTRIBUTE	x
	endif
    endm

; This 'even' will only exist in REV02. It is unnecessary, presumably being
; automatically generated by the assembler after 'dc.b' opcodes.
rev02even macro
	if gameRevision=2
		even
	endif
    endm

; Discard everything before the first underscore.
; This expects that every JmpTo label start with 'JmpTo_'.
extractJmpToName function name,val(substr(name, strstr(name, "_") + 1, strlen(name)))

    ; depending on if removeJmpTos is set or not, these macros will create a jump directly
    ; to the destination, or create a branch to a JmpTo
jsrto macro indirectaddr
	if removeJmpTos
		!jsr (extractJmpToName("indirectaddr")).l	; jump directly to address
	else
		!bsr.w indirectaddr	; otherwise, branch to an indirect JmpTo
	endif
    endm

jmpto macro indirectaddr
	if removeJmpTos
		!jmp (extractJmpToName("indirectaddr")).l	; jump directly to address
	else
		!bra.w indirectaddr	; otherwise, branch to an indirect JmpTo
	endif
    endm

jmpTosInternal2 macro
	if ARGCOUNT>0
	irp op,ALLARGS
op label *
	jmp	(extractJmpToName("op")).l
	endm
	endif
    endm

jmpTosInternal macro UseNop
	if ~~removeJmpTos
		if (*)&2
			; I wish I understood what really controls this.
			if UseNop
				nop
			else
				align 4
			endif
		endif

		shift

		jmpTosInternal2 ALLARGS

		align 4
	endif
    endm

	; Output list of JmpTos, pad start with a NOP instuction.
jmpTos macro
	jmpTosInternal TRUE,ALLARGS
	endm

	; Output list of JmpTos, pad start with zeroes.
jmpTos0 macro
	jmpTosInternal FALSE,ALLARGS
	endm

bit function nBits,1<<(nBits-1)
signmask function val,nBits,-((-(val&bit(nBits)))&bit(nBits))
signextend function val,nBits,(val+signmask(val,nBits))!signmask(val,nBits)
signextendB function val,signextend(val,8)
roundFloatToInteger function float,INT(float+0.5)
min function a,b,b!((a!b)&(-(a<b)))
max function a,b,a!((a!b)&(-(a<b)))
