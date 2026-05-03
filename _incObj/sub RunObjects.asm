; -------------------------------------------------------------------------------
; This runs the code of all the objects that are in Object_RAM
; -------------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_15F9C: ObjectsLoad:
RunObjects:
	tst.b	(Teleport_flag).w
	bne.s	RunObjects_End	; rts
	lea	(Object_RAM).w,a0 ; a0=object

	moveq	#(Object_RAM_End-Object_RAM)/object_size-1,d7 ; run the first $80 objects out of levels
	moveq	#0,d0
	cmpi.b	#GameModeID_Demo,(Game_Mode).w	; demo mode?
	beq.s	+	; if in a level in a demo, branch
	cmpi.b	#GameModeID_Level,(Game_Mode).w	; regular level mode?
	bne.s	RunObject ; if not in a level, branch to RunObject
+
	move.w	#(LevelOnly_Object_RAM_End-Object_RAM)/object_size-1,d7	; run the first $90 objects in levels
	tst.w	(Two_player_mode).w
	bne.s	RunObject ; if in 2 player competition mode, branch to RunObject

	cmpi.b	#6,(MainCharacter+routine).w
	bhs.s	RunObjectsWhenPlayerIsDead ; if dead, branch
	; continue straight to RunObject
; ---------------------------------------------------------------------------

; -------------------------------------------------------------------------------
; This is THE place where each individual object's code gets called from
; -------------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_15FCC:
RunObject:
	move.b	id(a0),d0	; get the object's ID
	beq.s	RunNextObject ; if it's obj00, skip it

	add.w	d0,d0
	add.w	d0,d0	; d0 = object ID * 4
	movea.l	Obj_Index-4(pc,d0.w),a1	; load the address of the object's code
	jsr	(a1)	; dynamic call! to one of the the entries in Obj_Index
	moveq	#0,d0

; loc_15FDC:
RunNextObject:
	lea	next_object(a0),a0 ; load 0bj address
	dbf	d7,RunObject
; return_15FE4:
RunObjects_End:
	rts

; ---------------------------------------------------------------------------
; this skips certain objects to make enemies and things pause when Sonic dies
; loc_15FE6:
RunObjectsWhenPlayerIsDead:
	moveq	#(Reserved_Object_RAM_End-Reserved_Object_RAM)/object_size-1,d7
	bsr.s	RunObject	; run the first $10 objects normally
	moveq	#(Dynamic_Object_RAM_End-Dynamic_Object_RAM)/object_size-1,d7
	bsr.s	RunObjectDisplayOnly ; all objects in this range are paused
	moveq	#(LevelOnly_Object_RAM_End-LevelOnly_Object_RAM)/object_size-1,d7
	bra.s	RunObject	; run the last $10 objects normally

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_15FF2:
RunObjectDisplayOnly:
	moveq	#0,d0
	; This check prevent objects that don't exist from being displayed.
	move.b	id(a0),d0	; get the object's ID
	beq.s	+	; if it's obj00, skip it
	; This check prevents objects that do exist, but haven't been initialised yet, from being displayed.
	_btst	#render_flags.on_screen,render_flags(a0)	; was the object displayed on the previous frame?
	_beq.s	+						; if not, skip it
    if fixBugs
	; If this is a multi-sprite object, then we cannot use its 'priority'
	; value to display it as it's being used for coordinate data.
	; In theory, this means that calls to 'DisplaySprite' here could
	; overflow the 'Object_Display_Lists' buffer and write to 'Object_RAM'
	; instead, which could be quite disasterous. However, I don't think
	; it's possible for an object to have a Y coordinate higher than
	; $7FF, so, in practice, the overflow never occurs. Still, it can
	; result in objects displaying on a random layer. The best we can do
	; is force them to display on a certain layer consistently.
	; This quirk becomes a much bigger problem if you extend the
	; 'priority' value to 16-bit, such as if you've ported S3K's priority
	; manager, rather than just the upper byte of the Y coordinate being
	; read as priority data, the whole word is. This makes it much more
	; likely to lead to buffer overflow and memory corruption.
	pea	+(pc)	; This is an optimisation to avoid the need for extra branches: it makes it so '+' will be executed after 'DisplaySprite' or 'DisplaySprite3' return.
	btst	#render_flags.multi_sprite,render_flags(a0)	; Is this a multi-sprite object?
	beq.w	DisplaySprite					; If not, display using the object's 'priority' value.
	move.w	#object_display_list_size*4,d0			; If so, display using a hardcoded priority of 4.
	bra.w	DisplaySprite3
    else
	bsr.w	DisplaySprite
    endif
+
	lea	next_object(a0),a0 ; load 0bj address
	dbf	d7,RunObjectDisplayOnly
	rts
; End of function RunObjectDisplayOnly
