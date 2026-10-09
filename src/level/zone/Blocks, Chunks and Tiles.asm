; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; LEVEL ART AND BLOCK MAPPINGS (16x16 and 128x128)
;
; #define BLOCK_TBL_LEN  // table length unknown
; #define BIGBLOCK_TBL_LEN // table length unknown
; typedef uint16_t uword
;
; struct blockMapElement {
;  uword unk : 5;    // u
;  uword patternIndex : 11; };  // i
; // uuuu uiii iiii iiii
;
; blockMapElement (*blockMapTable)[BLOCK_TBL_LEN][4] = 0xFFFF9000
;
; struct bigBlockMapElement {
;  uword : 4
;  uword blockMapIndex : 12; };  //I
; // 0000 IIII IIII IIII
;
; bigBlockMapElement (*bigBlockMapTable)[BIGBLOCK_TBL_LEN][64] = 0xFFFF0000
;
; /*
; This data determines how the level blocks will be constructed graphically. There are
; two kinds of block mappings: 16x16 and 128x128.
;
; 16x16 blocks are made up of four cells arranged in a square (thus, 16x16 pixels).
; Two bytes are used to define each cell, so the block is 8 bytes long. It can be
; represented by the bitmap blockMapElement, of which the members are:
;
; unk
;  These bits have to do with pattern orientation. I do not know their exact
;  meaning.
; patternIndex
;  The pattern's address divided by $20. Otherwise said: an index into the
;  pattern array.
;
; Each mapping can be expressed as an array of four blockMapElements, while the
; whole table is expressed as a two-dimensional array of blockMapElements (blockMapTable).
; The maps are read in left-to-right, top-to-bottom order.
;
; 128x128 maps are basically lists of indices into blockMapTable. The levels are built
; out of these "big blocks", rather than the "small" 16x16 blocks. bigBlockMapTable is,
; predictably, the table of big block mappings.
; Each big block is 8 16x16 blocks, or 16 cells, square. This produces a total of 16
; blocks or 64 cells.
; As noted earlier, each element of the table provides 'i' for blockMapTable[i][j].
; */

; All of these are compressed in the Kosinski format.

BM16_EHZ:	BINCLUDE	"mappings/16x16/EHZ.kos"
ArtKos_EHZ:	BINCLUDE	"art/kosinski/EHZ_HTZ.kos"
BM16_HTZ:	BINCLUDE	"mappings/16x16/HTZ.kos"
ArtKos_HTZ:	BINCLUDE	"art/kosinski/HTZ_Supp.kos" ; HTZ pattern suppliment to EHZ level patterns
BM128_EHZ:	BINCLUDE	"mappings/128x128/EHZ_HTZ.kos"

BM16_MTZ:	BINCLUDE	"mappings/16x16/MTZ.kos"
ArtKos_MTZ:	BINCLUDE	"art/kosinski/MTZ.kos"
BM128_MTZ:	BINCLUDE	"mappings/128x128/MTZ.kos"

BM16_HPZ:	;BINCLUDE	"mappings/16x16/HPZ.kos"
ArtKos_HPZ:	;BINCLUDE	"art/kosinski/HPZ.kos"
BM128_HPZ:	;BINCLUDE	"mappings/128x128/HPZ.kos"

BM16_OOZ:	BINCLUDE	"mappings/16x16/OOZ.kos"
ArtKos_OOZ:	BINCLUDE	"art/kosinski/OOZ.kos"
BM128_OOZ:	BINCLUDE	"mappings/128x128/OOZ.kos"

BM16_MCZ:	BINCLUDE	"mappings/16x16/MCZ.kos"
ArtKos_MCZ:	BINCLUDE	"art/kosinski/MCZ.kos"
BM128_MCZ:	BINCLUDE	"mappings/128x128/MCZ.kos"

BM16_CNZ:	BINCLUDE	"mappings/16x16/CNZ.kos"
ArtKos_CNZ:	BINCLUDE	"art/kosinski/CNZ.kos"
BM128_CNZ:	BINCLUDE	"mappings/128x128/CNZ.kos"

BM16_CPZ:	BINCLUDE	"mappings/16x16/CPZ_DEZ.kos"
ArtKos_CPZ:	BINCLUDE	"art/kosinski/CPZ_DEZ.kos"
BM128_CPZ:	BINCLUDE	"mappings/128x128/CPZ_DEZ.kos"

; This file contains $320 blocks, overflowing the 'Block_table' buffer. This causes
; 'TempArray_LayerDef' to be overwritten with (empty) block data.
; If only 'fixBugs' could fix this...
BM16_ARZ:	BINCLUDE	"mappings/16x16/ARZ.kos"
ArtKos_ARZ:	BINCLUDE	"art/kosinski/ARZ.kos"
BM128_ARZ:	BINCLUDE	"mappings/128x128/ARZ.kos"

BM16_WFZ:	BINCLUDE	"mappings/16x16/WFZ_SCZ.kos"
ArtKos_SCZ:	BINCLUDE	"art/kosinski/WFZ_SCZ.kos"
ArtKos_WFZ:	BINCLUDE	"art/kosinski/WFZ_Supp.kos" ; WFZ pattern suppliment to SCZ tiles
BM128_WFZ:	BINCLUDE	"mappings/128x128/WFZ_SCZ.kos"
