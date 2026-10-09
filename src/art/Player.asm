;---------------------------------------------------------------------------------------
; Player Assets
;---------------------------------------------------------------------------------------
	align tiles_to_bytes(1)
ArtUnc_Sonic:			BINCLUDE	"art/uncompressed/Sonic's art.bin"
	align tiles_to_bytes(1)
ArtUnc_Tails:			BINCLUDE	"art/uncompressed/Tails's art.bin"

MapUnc_Sonic:			include		"mappings/sprite/Sonic.asm"

MapRUnc_Sonic:			include		"mappings/spriteDPLC/Sonic.asm"

ArtNem_Shield:			BINCLUDE	"art/nemesis/Shield.nem"
	even
ArtNem_Invincible_stars:	BINCLUDE	"art/nemesis/Invincibility stars.nem"
	even
ArtUnc_SplashAndDust:		BINCLUDE	"art/uncompressed/Splash and skid dust.bin"

ArtNem_SuperSonic_stars:	BINCLUDE	"art/nemesis/Super Sonic stars.nem"
	even
MapUnc_Tails:			include		"mappings/sprite/Tails.asm"

MapRUnc_Tails:			include		"mappings/spriteDPLC/Tails.asm"
