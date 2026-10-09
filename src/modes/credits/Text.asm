; ===========================================================================

; macro for declaring pointer/position structures for intro/credit text
vram_pnt := VRAM_Plane_A_Name_Table
creditsPtrs macro addr,pos
	if "addr"<>""
		dc.l addr
		dc.w vram_pnt + pos
		shift
		shift
		creditsPtrs ALLARGS
	else
		dc.w -1
	endif
    endm

textLoc function col,line,(($80 * line) + (2 * col))

; intro text pointers (one intro screen)
vram_pnt := VRAM_TtlScr_Plane_A_Name_Table
off_B2B0: creditsPtrs	byte_BD1A,textLoc($0F,$09), byte_BCEE,textLoc($11,$0C), \
			byte_BCF6,textLoc($03,$0F), byte_BCE9,textLoc($12,$12)

; credits screen pointer table
off_B2CA:
	dc.l off_B322, off_B336, off_B34A, off_B358	; 3
	dc.l off_B366, off_B374, off_B388, off_B3A8	; 7
	dc.l off_B3C2, off_B3DC, off_B3F0, off_B41C	; 11
	dc.l off_B436, off_B450, off_B45E, off_B490	; 15
	dc.l off_B4B0, off_B4C4, off_B4F0, off_B51C	; 19
	dc.l off_B548, -1				; 21

; credits text pointers for each screen of credits
vram_pnt := VRAM_Plane_A_Name_Table
off_B322: creditsPtrs	byte_BC46,textLoc($0E,$0B), byte_BC51,textLoc($18,$0B), byte_BC55,textLoc($02,$0F)
off_B336: creditsPtrs	byte_B55C,textLoc($03,$0B), byte_B56F,textLoc($16,$0B), byte_B581,textLoc($06,$0F)
off_B34A: creditsPtrs	byte_B56F,textLoc($0C,$0B), byte_B59F,textLoc($07,$0F)
off_B358: creditsPtrs	byte_B5BC,textLoc($0C,$0B), byte_B5CD,textLoc($06,$0F)
off_B366: creditsPtrs	byte_B5EB,textLoc($05,$0B), byte_B60C,textLoc($07,$0F)
off_B374: creditsPtrs	byte_B628,textLoc($08,$0A), byte_B642,textLoc($04,$0E), byte_B665,textLoc($0A,$10)
off_B388: creditsPtrs	byte_B67B,textLoc($04,$08), byte_B69C,textLoc($11,$0A), byte_B6A4,textLoc($09,$0C), byte_B6BC,textLoc($04,$10), byte_B6DE,textLoc($08,$12)
off_B3A8: creditsPtrs	byte_B6F8,textLoc($0B,$09), byte_B70B,textLoc($09,$0B), byte_B723,textLoc($0A,$0F), byte_B738,textLoc($03,$11)
off_B3C2: creditsPtrs	byte_B75C,textLoc($04,$09), byte_B642,textLoc($04,$0D), byte_B77E,textLoc($07,$0F), byte_B799,textLoc($07,$11)
off_B3DC: creditsPtrs	byte_B7B5,textLoc($08,$0A), byte_B75C,textLoc($04,$0C), byte_B799,textLoc($07,$10)
off_B3F0: creditsPtrs	byte_B7F2,textLoc($09,$06), byte_B6BC,textLoc($04,$0A), byte_B80B,textLoc($0A,$0C), byte_B821,textLoc($09,$0E), byte_B839,textLoc($07,$10), byte_B855,textLoc($0B,$12), byte_B869,textLoc($0B,$14)
off_B41C: creditsPtrs	byte_B7B5,textLoc($09,$09), byte_B87D,textLoc($0A,$0B), byte_B893,textLoc($0B,$0F), byte_B8A8,textLoc($07,$11)
off_B436: creditsPtrs	byte_B8C5,textLoc($06,$09), byte_B8E2,textLoc($05,$0D), byte_B902,textLoc($03,$0F), byte_B90F,textLoc($04,$11)
off_B450: creditsPtrs	byte_B932,textLoc($04,$0B), byte_B954,textLoc($05,$0F)
off_B45E: creditsPtrs	byte_B974,textLoc($04,$05), byte_B995,textLoc($0F,$09), byte_B9A1,textLoc($0F,$0B), byte_B9AD,textLoc($0F,$0D), byte_B9B8,textLoc($10,$0F), byte_B9C1,textLoc($11,$11), byte_B9C8,textLoc($11,$13), byte_B9D0,textLoc($0F,$15)
off_B490: creditsPtrs	byte_B9DB,textLoc($03,$08), byte_BA00,textLoc($08,$0C), byte_BA1B,textLoc($06,$0E), byte_BA3A,textLoc($09,$10), byte_BA52,textLoc($0A,$12)
off_B4B0: creditsPtrs	byte_BA69,textLoc($09,$0A), byte_BA81,textLoc($05,$0E), byte_B7CE,textLoc($03,$10)
off_B4C4: creditsPtrs	byte_B55C,textLoc($0B,$06), byte_BAA2,textLoc($0A,$08), byte_BAB8,textLoc($03,$0C), byte_BADC,textLoc($07,$0E), byte_BAF7,textLoc($05,$10), byte_BB16,textLoc($07,$12), byte_BB32,textLoc($02,$14)
off_B4F0: creditsPtrs	byte_BB58,textLoc($06,$06), byte_BB75,textLoc($12,$08), byte_BB7B,textLoc($06,$0C), byte_BC9F,textLoc($05,$0E), byte_BBD8,textLoc($08,$10), byte_BBF2,textLoc($08,$12), byte_BC0C,textLoc($09,$14)
off_B51C: creditsPtrs	byte_BB58,textLoc($06,$06), byte_BB75,textLoc($12,$08), byte_BB98,textLoc($03,$0C), byte_BBBC,textLoc($07,$0E), byte_BCBE,textLoc($07,$10), byte_BCD9,textLoc($0D,$12), byte_BC25,textLoc($04,$14)
off_B548: creditsPtrs	byte_BC7B,textLoc($0B,$09), byte_BC8F,textLoc($12,$0D), byte_BC95,textLoc($10,$11)

 ; temporarily remap characters to credit text format
 ; let's encode 2-wide characters like Aa, Bb, Cc, etc. and hide it with a macro
 charset '@',"\x3B\2\4\6\8\xA\xC\xE\x10\x12\x13\x15\x17\x19\x1B\x1D\x1F\x21\x23\x25\x27\x29\x2B\x2D\x2F\x31\x33"
 charset 'a',"\3\5\7\9\xB\xD\xF\x11\x12\x14\x16\x18\x1A\x1C\x1E\x20\x22\x24\x26\x28\x2A\x2C\x2E\x30\x32\x34"
 charset '!',"\x3D\x39\x3F\x36"
 charset '\H',"\x39\x37\x38"
 charset '9',"\x3E\x40\x41"
 charset '1',"\x3C\x35"
 charset '.',"\x3A"
 charset ' ',0

 ; macro for defining credit text in conjunction with the remapped character set
vram_src := ArtTile_ArtNem_CreditText_CredScr
creditText macro pal,ss
	if ((vram_src & $FF) <> $0) && ((vram_src & $FF) <> $1)
		fatal "The low byte of vram_src was $\{vram_src & $FF}, but it must be $00 or $01."
	endif
	dc.b (make_art_tile(vram_src,pal,0) & $FF00) >> 8
	irpc char,ss
	dc.b "char"
	switch "char"
	case "I"
	case "1"
		dc.b "!"
	case "2"
		dc.b "$"
	case "9"
		dc.b "#"
	elsecase
l := lowstring("char")
		if l<>"char"
			dc.b l
		endif
	endcase
	endm
	dc.b -1
	rev02even
    endm

; credits text data (palette index followed by a string)
vram_src := ArtTile_ArtNem_CreditText_CredScr
byte_B55C:	creditText 1,"EXECUTIVE"
byte_B56F:	creditText 1,"PRODUCER"
byte_B581:	creditText 0,"HAYAO  NAKAYAMA"
byte_B59F:	creditText 0,"SHINOBU  TOYODA"
byte_B5BC:	creditText 1,"DIRECTOR"
byte_B5CD:	creditText 0,"MASAHARU  YOSHII"
byte_B5EB:	creditText 1,"CHIEF  PROGRAMMER"
byte_B60C:	creditText 0,"YUJI  NAKA (YU2)"
byte_B628:	creditText 1,"GAME  PLANNER"
byte_B642:	creditText 0,"HIROKAZU  YASUHARA"
byte_B665:	creditText 0,"(CAROL  YAS)"
byte_B67B:	creditText 1,"CHARACTER  DESIGN"
byte_B69C:	creditText 1,"AND"
byte_B6A4:	creditText 1,"CHIEF  ARTIST"
byte_B6BC:	creditText 0,"YASUSHI  YAMAGUCHI"
byte_B6DE:	creditText 0,"(JUDY  TOTOYA)"
byte_B6F8:	creditText 1,"ASSISTANT"
byte_B70B:	creditText 1,"PROGRAMMERS"
byte_B723:	creditText 0,"BILL  WILLIS"
byte_B738:	creditText 0,"MASANOBU  YAMAMOTO"
byte_B75C:	creditText 1,"OBJECT  PLACEMENT"
byte_B77E:	creditText 0,"TAKAHIRO  ANTO"
byte_B799:	creditText 0,"YUTAKA  SUGANO"
byte_B7B5:	creditText 1,"SPECIALSTAGE"
byte_B7CE:	creditText 0,"CAROL  ANN  HANSHAW"
byte_B7F2:	creditText 1,"ZONE  ARTISTS"
byte_B80B:	creditText 0,"CRAIG  STITT"
byte_B821:	creditText 0,"BRENDA  ROSS"
byte_B839:	creditText 0,"JINA  ISHIWATARI"
byte_B855:	creditText 0,"TOM  PAYNE"
byte_B869:	creditText 0,"PHENIX  RIE"
byte_B87D:	creditText 1,"ART  AND  CG"
byte_B893:	creditText 0,"TIM  SKELLY"
byte_B8A8:	creditText 0,"PETER  MORAWIEC"
byte_B8C5:	creditText 1,"MUSIC  COMPOSER"
byte_B8E2:	creditText 0,"MASATO  NAKAMURA"
byte_B902:	creditText 0,"( @1992"
byte_B90F:	creditText 0,"DREAMS  COME  TRUE)"
byte_B932:	creditText 1,"SOUND  PROGRAMMER"
byte_B954:	creditText 0,"TOMOYUKI  SHIMADA"
byte_B974:	creditText 1,"SOUND  ASSISTANTS"
byte_B995:	creditText 0,"MACKY"
byte_B9A1:	creditText 0,"JIMITA"
byte_B9AD:	creditText 0,"MILPO"
byte_B9B8:	creditText 0,"IPPO"
byte_B9C1:	creditText 0,"S.O"
byte_B9C8:	creditText 0,"OYZ"
byte_B9D0:	creditText 0,"N.GEE"
byte_B9DB:	creditText 1,"PROJECT  ASSISTANTS"
byte_BA00:	creditText 0,"SYUICHI  KATAGI"
byte_BA1B:	creditText 0,"TAKAHIRO  HAMANO"
byte_BA3A:	creditText 0,"YOSHIKI  OOKA"
byte_BA52:	creditText 0,"STEVE  WOITA"
byte_BA69:	creditText 1,"GAME  MANUAL"
byte_BA81:	creditText 0,"YOUICHI  TAKAHASHI"
byte_BAA2:	creditText 1,"SUPPORTERS"
byte_BAB8:	creditText 0,"DAIZABUROU  SAKURAI"
byte_BADC:	creditText 0,"HISASHI  SUZUKI"
    if gameRevision=0
byte_BAF7:	creditText 0,"TOHMAS  KALINSKE"	; typo
    else
byte_BAF7:	creditText 0,"THOMAS  KALINSKE"
    endif
byte_BB16:	creditText 0,"FUJIO  MINEGISHI"
byte_BB32:	creditText 0,"TAKAHARU UTSUNOMIYA"
byte_BB58:	creditText 1,"SPECIAL  THANKS"
byte_BB75:	creditText 1,"TO"
byte_BB7B:	creditText 0,"CINDY  CLAVERAN"
byte_BB98:	creditText 0,"DEBORAH  MCCRACKEN"
byte_BBBC:	creditText 0,"TATSUO  YAMADA"
byte_BBD8:	creditText 0,"DAISUKE  SAITO"
byte_BBF2:	creditText 0,"KUNITAKE  AOKI"
byte_BC0C:	creditText 0,"TSUNEKO  AOKI"
byte_BC25:	creditText 0,"MASAAKI  KAWAMURA"
byte_BC46:	creditText 0,"SONIC"
byte_BC51:	creditText 1,"2"
byte_BC55:	creditText 0,"CAST  OF  CHARACTERS"
byte_BC7B:	creditText 0,"PRESENTED"
byte_BC8F:	creditText 0,"BY"
byte_BC95:	creditText 0,"SEGA"
byte_BC9F:	creditText 0,"FRANCE  TANTIADO"
byte_BCBE:	creditText 0,"RICK  MACARAEG"
byte_BCD9:	creditText 0,"LOCKY  P"

 charset ; have to revert character set before changing again

 ; temporarily remap characters to intro text format
 charset '@',"\x3A\1\3\5\7\9\xB\xD\xF\x11\x12\x14\x16\x18\x1A\x1C\x1E\x20\x22\x24\x26\x28\x2A\x2C\x2E\x30\x32"
 charset 'a',"\2\4\6\8\xA\xC\xE\x10\x11\x13\x15\x17\x19\x1B\x1D\x1F\x21\x23\x25\x27\x29\x2B\x2D\x2F\x31\x33"
 charset '!',"\x3C\x38\x3E\x35"
 charset '\H',"\x38\x36\x37"
 charset '9',"\x3D\x3F\x40"
 charset '1',"\x3B\x34"
 charset '.',"\x39"
 charset ' ',0

; intro text
vram_src := ArtTile_ArtNem_CreditText
byte_BCE9:	creditText   0,"IN"
byte_BCEE:	creditText   0,"AND"
byte_BCF6:	creditText   0,"MILES 'TAILS' PROWER"
byte_BD1A:	creditText   0,"SONIC"

 charset ; revert character set

	even
