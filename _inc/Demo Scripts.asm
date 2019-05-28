; ===========================================================================
; macro to simplify editing the demo scripts
demoinput macro buttons,duration
btns_mask := 0
idx := 0
  rept strlen("buttons")
btn := substr("buttons",idx,1)
    switch btn
    case "U"
btns_mask := btns_mask|button_up_mask
    case "D"
btns_mask := btns_mask|button_down_mask
    case "L"
btns_mask := btns_mask|button_left_mask
    case "R"
btns_mask := btns_mask|button_right_mask
    case "A"
btns_mask := btns_mask|button_A_mask
    case "B"
btns_mask := btns_mask|button_B_mask
    case "C"
btns_mask := btns_mask|button_C_mask
    case "S"
btns_mask := btns_mask|button_start_mask
    endcase
idx := idx+1
  endm
	dc.b	btns_mask,duration-1
 endm
; ---------------------------------------------------------------------------
; EHZ Demo Script (Sonic)
; ---------------------------------------------------------------------------
; byte_4CA8: Demo_Def:
Demo_EHZ:
	demoinput ,	$4C
	demoinput R,	$43
	demoinput RC,	9
	demoinput R,	$3F
	demoinput RC,	6
	demoinput R,	$B0
	demoinput RC,	$A
	demoinput R,	$46
	demoinput ,	$1E
	demoinput L,	$F
	demoinput ,	5
	demoinput L,	5
	demoinput ,	9
	demoinput L,	$3F
	demoinput ,	5
	demoinput R,	$67
	demoinput ,	$62
	demoinput R,	$12
	demoinput ,	$22
	demoinput D,	8
	demoinput DC,	7
	demoinput D,	$E
	demoinput ,	$3C
	demoinput R,	$A
	demoinput ,	$1E
	demoinput D,	7
	demoinput DC,	7
	demoinput D,	2
	demoinput ,	$F
	demoinput R,	$100
	demoinput R,	$2F
	demoinput ,	$23
	demoinput C,	8
	demoinput RC,	$10
	demoinput R,	3
	demoinput ,	$30
	demoinput RC,	$24
	demoinput R,	$BE
	demoinput ,	$C
	demoinput L,	$14
	demoinput ,	$17
	demoinput D,	3
	demoinput DC,	7
	demoinput D,	3
	demoinput ,	$64
	demoinput S,	1
	demoinput A,	1
	demoinput ,	1
; ---------------------------------------------------------------------------
; EHZ Demo Script (Tails)
; ---------------------------------------------------------------------------
; byte_4D08:
Demo_EHZ_Tails:
	demoinput ,	$3C
	demoinput R,	$10
	demoinput UR,	$44
	demoinput URC,	$7
	demoinput UR,	$7
	demoinput R,	$CA
	demoinput ,	$12
	demoinput R,	$2
	demoinput RC,	$9
	demoinput R,	$53
	demoinput ,	$12
	demoinput R,	$B
	demoinput RC,	$F
	demoinput R,	$24
	demoinput ,	$B
	demoinput C,	$5
	demoinput ,	$E
	demoinput R,	$56
	demoinput ,	$1F
	demoinput R,	$5B
	demoinput ,	$11
	demoinput R,	$100
	demoinput R,	$C1
	demoinput ,	$21
	demoinput L,	$E
	demoinput ,	$E
	demoinput C,	$5
	demoinput RC,	$10
	demoinput C,	$6
	demoinput ,	$D
	demoinput L,	$6
	demoinput ,	$5F
	demoinput R,	$74
	demoinput ,	$19
	demoinput L,	$45
	demoinput ,	$9
	demoinput D,	$31
	demoinput ,	$9
	demoinput R,	$E
	demoinput ,	$24
	demoinput R,	$28
	demoinput ,	$5
	demoinput R,	$1
	demoinput ,	$1
	demoinput ,	$1
	demoinput ,	$1
	demoinput ,	$1
	demoinput ,	$1
; ---------------------------------------------------------------------------
; CNZ Demo Script
; ---------------------------------------------------------------------------
Demo_CNZ:
	demoinput ,	$49
	demoinput R,	$11
	demoinput UR,	1
	demoinput R,	2
	demoinput UR,	7
	demoinput R,	$61
	demoinput RC,	6
	demoinput C,	2
	demoinput ,	9
	demoinput L,	3
	demoinput DL,	4
	demoinput L,	2
	demoinput ,	$1A
	demoinput R,	$12
	demoinput RC,	$1A
	demoinput C,	5
	demoinput RC,	$24
	demoinput R,	$1B
	demoinput ,	8
	demoinput L,	$11
	demoinput ,	$F
	demoinput R,	$78
	demoinput RC,	$17
	demoinput C,	1
	demoinput ,	$10
	demoinput L,	$12
	demoinput ,	8
	demoinput R,	$53
	demoinput ,	$70
	demoinput R,	$75
	demoinput ,	$38
	demoinput R,	$17
	demoinput ,	5
	demoinput L,	$27
	demoinput ,	$D
	demoinput L,	$13
	demoinput ,	$6A
	demoinput C,	$11
	demoinput RC,	3
	demoinput DRC,	6
	demoinput DR,	$15
	demoinput R,	6
	demoinput ,	6
	demoinput L,	$D
	demoinput ,	$49
	demoinput L,	$A
	demoinput ,	$1F
	demoinput R,	7
	demoinput ,	$30
	demoinput L,	2
	demoinput ,	$100
	demoinput ,	$50
	demoinput R,	1
	demoinput RC,	$C
	demoinput R,	$2B
	demoinput ,	$5F
; ---------------------------------------------------------------------------
; CPZ Demo Script
; ---------------------------------------------------------------------------
Demo_CPZ:
	demoinput ,	$47
	demoinput R,	$1C
	demoinput RC,	8
	demoinput R,	$A
	demoinput ,	$1C
	demoinput R,	$E
	demoinput RC,	$29
	demoinput R,	$100
	demoinput R,	$E8
	demoinput DR,	5
	demoinput D,	2
	demoinput L,	$34
	demoinput DL,	$68
	demoinput L,	1
	demoinput ,	$16
	demoinput C,	1
	demoinput LC,	8
	demoinput L,	$F
	demoinput ,	$18
	demoinput R,	2
	demoinput DR,	2
	demoinput R,	$D
	demoinput ,	$20
	demoinput RC,	7
	demoinput R,	$B
	demoinput ,	$1C
	demoinput L,	$E
	demoinput ,	$1D
	demoinput L,	7
	demoinput ,	$100
	demoinput ,	$E0
	demoinput R,	$F
	demoinput ,	$1D
	demoinput L,	3
	demoinput ,	$26
	demoinput R,	7
	demoinput ,	7
	demoinput C,	5
	demoinput ,	$29
	demoinput L,	$12
	demoinput ,	$18
	demoinput R,	$1A
	demoinput ,	$11
	demoinput L,	$2E
	demoinput ,	$14
	demoinput S,	1
	demoinput A,	1
	demoinput ,	1
; ---------------------------------------------------------------------------
; ARZ Demo Script
; ---------------------------------------------------------------------------
Demo_ARZ:
	demoinput ,	$43
	demoinput R,	$4B
	demoinput RC,	9
	demoinput R,	$50
	demoinput RC,	$C
	demoinput R,	6
	demoinput ,	$1B
	demoinput R,	$61
	demoinput RC,	$15
	demoinput R,	$55
	demoinput ,	$41
	demoinput R,	5
	demoinput UR,	1
	demoinput R,	$5C
	demoinput ,	$47
	demoinput R,	$3C
	demoinput RC,	9
	demoinput R,	$28
	demoinput ,	$B
	demoinput R,	$93
	demoinput RC,	$33
	demoinput R,	$23
	demoinput ,	$23
	demoinput R,	$4D
	demoinput ,	$1F
	demoinput L,	2
	demoinput UL,	3
	demoinput L,	1
	demoinput ,	$B
	demoinput L,	$D
	demoinput ,	$11
	demoinput R,	6
	demoinput ,	$62
	demoinput R,	4
	demoinput RC,	6
	demoinput R,	$17
	demoinput ,	$1C
	demoinput R,	$57
	demoinput RC,	$B
	demoinput R,	$17
	demoinput ,	$16
	demoinput R,	$D
	demoinput ,	$2C
	demoinput C,	2
	demoinput RC,	$1B
	demoinput R,	$83
	demoinput ,	$C
	demoinput S,	1