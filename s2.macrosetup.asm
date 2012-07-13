
	padding off	; we don't want AS padding out dc.b instructions
	listing off	; we don't need to generate anything for a listing file
	supmode on	; we don't need warnings about privileged instructions


paddingSoFar set 0

; 128 = 80h = z80, 32988 = 80DCh = z80unDoC 
notZ80 function cpu,(cpu<>128)&&(cpu<>32988)

; make org safer (impossible to overwrite previously assembled bytes) and count padding
; and also make it work in Z80 code without creating a new segment
org macro address
	if notZ80(MOMCPU)
		if address < *
			if assembleZ80SoundDriver
				error "too much stuff before org $\{address} ($\{(*-address)} bytes)"
			else
				error "too much stuff before org $\{address} ($\{(*-address)} bytes) ... try setting assembleZ80SoundDriver=1 in the asm file"
			endif
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

    if zeroOffsetOptimization=0
    ; disable a space optimization in AS so we can build a bit-perfect rom
    ; (the hard way, but it requires no modification of AS itself)


chkop function op,ref,(substr(lowstring(op),0,strlen(ref))<>ref)

; 1-arg instruction that's self-patching to remove 0-offset optimization
insn1op	 macro oper,x
	  if (chkop("x","0(") && chkop("x","id(") && chkop("x","slot_rout("))
		!oper	x
	  else
		!oper	1+x
		!org	*-1
		!dc.b	0
	  endif
	 endm

; 2-arg instruction that's self-patching to remove 0-offset optimization
insn2op	 macro oper,x,y
	  if (chkop("x","0(") && chkop("x","id(") && chkop("x","slot_rout("))
		  if (chkop("y","0(") && chkop("y","id(") && chkop("y","slot_rout("))
			!oper	x,y
		  else
			!oper	x,1+y
			!org	*-1
			!dc.b	0
		  endif
	  else
		if chkop("y","d")
		  if (chkop("y","0(") && chkop("y","id(") && chkop("y","slot_rout("))
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
