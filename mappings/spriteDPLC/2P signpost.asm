DPLC_obj0D:	mappingsTable
	mappingsTableEntry.w	DPLC_obj0D_000C
	mappingsTableEntry.w	DPLC_obj0D_0012
	mappingsTableEntry.w	DPLC_obj0D_001A
	mappingsTableEntry.w	DPLC_obj0D_0020
	mappingsTableEntry.w	DPLC_obj0D_0024
	mappingsTableEntry.w	DPLC_obj0D_0020

DPLC_obj0D_000C:	dplcHeader
	dplcEntry	$C, $22
	dplcEntry	$C, $2E
DPLC_obj0D_000C_End

DPLC_obj0D_0012:	dplcHeader
	dplcEntry	4, $3A
	dplcEntry	$10, $3E
	dplcEntry	4, $3A
DPLC_obj0D_0012_End

DPLC_obj0D_001A:	dplcHeader
	dplcEntry	$C, 0
	dplcEntry	$C, 0
DPLC_obj0D_001A_End

DPLC_obj0D_0020:	dplcHeader
	dplcEntry	$10, $C
DPLC_obj0D_0020_End

DPLC_obj0D_0024:	dplcHeader
	dplcEntry	4, $1C
DPLC_obj0D_0024_End

	even
