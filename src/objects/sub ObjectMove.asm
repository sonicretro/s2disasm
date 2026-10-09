; ---------------------------------------------------------------------------
; Subroutine to make an object move and fall downward increasingly fast
; This moves the object horizontally and vertically
; and also applies gravity to its speed
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16380: ObjectFall:
ObjectMoveAndFall:
	move.l	x_pos(a0),d2	; load x position
	move.l	y_pos(a0),d3	; load y position
	move.w	x_vel(a0),d0	; load x speed
	ext.l	d0
	asl.l	#8,d0	; shift velocity to line up with the middle 16 bits of the 32-bit position
	add.l	d0,d2	; add x speed to x position	; note this affects the subpixel position x_sub(a0) = 2+x_pos(a0)
	move.w	y_vel(a0),d0	; load y speed
	addi.w	#$38,y_vel(a0)	; increase vertical speed (apply gravity)
	ext.l	d0
	asl.l	#8,d0	; shift velocity to line up with the middle 16 bits of the 32-bit position
	add.l	d0,d3	; add old y speed to y position	; note this affects the subpixel position y_sub(a0) = 2+y_pos(a0)
	move.l	d2,x_pos(a0)	; store new x position
	move.l	d3,y_pos(a0)	; store new y position
	rts
; End of function ObjectMoveAndFall
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ---------------------------------------------------------------------------
; Subroutine translating object speed to update object position
; This moves the object horizontally and vertically
; but does not apply gravity to it
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_163AC: SpeedToPos:
ObjectMove:
	move.l	x_pos(a0),d2	; load x position
	move.l	y_pos(a0),d3	; load y position
	move.w	x_vel(a0),d0	; load horizontal speed
	ext.l	d0
	asl.l	#8,d0	; shift velocity to line up with the middle 16 bits of the 32-bit position
	add.l	d0,d2	; add to x-axis position	; note this affects the subpixel position x_sub(a0) = 2+x_pos(a0)
	move.w	y_vel(a0),d0	; load vertical speed
	ext.l	d0
	asl.l	#8,d0	; shift velocity to line up with the middle 16 bits of the 32-bit position
	add.l	d0,d3	; add to y-axis position	; note this affects the subpixel position y_sub(a0) = 2+y_pos(a0)
	move.l	d2,x_pos(a0)	; update x-axis position
	move.l	d3,y_pos(a0)	; update y-axis position
	rts
; End of function ObjectMove
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
