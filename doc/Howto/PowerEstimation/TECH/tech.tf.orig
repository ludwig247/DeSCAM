/*
	M1 horizontal , M2 vertical, default via1 AVNT_via1_VV
    Jun 14, 2007	. align layers definitions on DK@5.1
    Feb 09, 2007    . all via1 have the attribute isDefaultContact set to 1
    Jan 24, 2007    . align layers definitions on DK_cmos065lpgp_RF_7m4x0y2z_2V51V8@5.0@20061215.0
    Sep 26, 2006    . alignement CB/M7 enclosure 0.7
    Jun 12, 2006    . change default via1 to AVNT_via1_VV
    May 26, 2006    . alignement on DK 4.2 from DK_cmos065lpgp_7m4x0y2z_50A28A@4.2@20060524.0
    Mar 15, 2006    . alignement on DK 4.1 from DK_cmos065lpgp_7m4x0y2z_50A28A@4.1beta0@20060314.0
    Feb 22, 2006    . Update M1 spacing
    Feb 10, 2006    . alignement on DK 4.0 from DK_cmos065lpgp_7m4x0y2z_50A28A@4.0@20060202.1
    Jan 03, 2006    . update form Herve RAFFARD (Synopsys)/Didier GUEZE to support new 2005.09 routing rules
	Sep 16, 2005	. alignement on DK 3.1
	Jul 19, 2005	. remove resistance value already defined in tlu+
	Apr 20, 2005	. alignement new vias rules DRM revC-Draft1
			. modified spacing range vias for VIA1-> 6
			. modified via enclosure rules.
			. modified VIA space in an array
			. add endOfLineCornerKeepoutWidth M1 to M5 : value per metal supposed to be in line with the DRM
			. set stubmode to 4
	Dec 02, 2004	. alignement on DK 2.0c
	Aug 31, 2004	. fix minEdgelength for M1 : 0.09 instead of 0.1
	Jun 14, 2004	. align layers on DK 1.0
	May 25, 2004	. add minEdge coding
	May 17, 2004	. default path = 0.10 for metal1
	May 07, 2004	. stub threshold decrease by 0.001 (derogation DRM?)
	May 06, 2004	. add layer definition from DK_cmos065lp_7m4x0y2z_50A.v0.3
	Apr 29, 2004	. swicth to stubMode = 2
	Apr 21, 2004	. align on DRM 0.08 draft
	Apr 19, 2004	. add stubMode, stubSpacing
	Apr 01, 2004	. add AVNT_via1_HH and VH
	Mar 04, 2004	. pitch = 0.2 - add new syntax for via density for 2004.06
	Jan 30, 2004	. pitch M5 = 0.21
	Jan 20, 2004	. fixed min Area for M2,M3,M4,M5
	Jan 19, 2004	. fix table for VIA1 42 instead of 2
			. fixed width/spacing in VIA layer definition
	Jan 16, 2004	. add AVNT_via1_HH and VH
			. remove M2 for AVNT_via1_HH and VH
	Jan 16, 2004	. update resistance values
			. cut spacing = 0.1 for AVNT_via1
			. non Fat code for double via1 for shape > 0.32
			. changed contactCode number for AVNT_via1 (align with cmos090)
	Jan 15, 2004	. add AVNT_via1_VV code 32
	Jan 13, 2004	. pitch M6/M7 = 0.84
	Jan 12, 2004	. initial version - pitch 0.21
			. AVNT_via1 default M1 horizontal, M2 vertical
*/

Technology	{
		name				= "cmos065_7m4x0y2z"
		date				= "Sep 30 2005"
		dielectric			= 3.4e-05
		unitTimeName			= "ns"
		timePrecision			= 1000
		unitLengthName			= "micron"
		lengthPrecision			= 1000
		gridResolution			= 5
		unitVoltageName			= "V"
		voltagePrecision		= 10000
		unitCurrentName			= "mA"
		currentPrecision		= 1000000
		unitPowerName			= "mw"
		powerPrecision			= 100000
		unitResistanceName		= "kohm"
		resistancePrecision		= 10000000
		unitCapacitanceName		= "pf"
		capacitancePrecision		= 10000000
		unitInductanceName		= "nh"
		inductancePrecision		= 100
		minBaselineTemperature		= 25
		nomBaselineTemperature		= 25
		maxBaselineTemperature		= 25
		stubMode			= 4
		minEdgeMode			= 1

}
Layer		"PO" {
		layerNumber			= 17
		maskName			= "poly"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "49"
		lineStyle			= "solid"
		pattern				= "dot"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0.060
		minSpacing			= 0.120
}

Layer		"CO" {
		layerNumber		= 30
		maskName		= "polyCont"
		isDefaultLayer	= 1
		visible			= 1
		selectable		= 1
		blink			= 0
		color			= "forest"
		lineStyle		= "solid"
		pattern			= "solid"
		pitch			= 0
		defaultWidth	= 0
		minWidth		= 0
		minSpacing		= 0
}

Layer		"M1" {
		layerNumber					= 31
		maskName					= "metal1"
		isDefaultLayer				= 1
		visible						= 1
		selectable					= 1
		blink						= 0
		color						= "7"
		lineStyle					= "solid"
		pattern						= "dot"
		pitch						= 0.2
		defaultWidth				= 0.1
		minWidth					= 0.09
		minSpacing					= 0.09
		maxWidth					= 12
		stubSpacing					= 0.11
		stubThreshold				= 0.109
		endOfLineCornerKeepoutWidth	= 0.035
		maxSegLenForRC				= 1000
		fatTblDimension				= 5
		fatTblThreshold				= (0.000,0.201,0.421,1.501,4.501)
		fatTblParallelLength		= (0.000,0.381,0.421,1.501,4.501)
		fatTblSpacing				= (0.090,0.110,0.160,0.500,1.500,
									   0.110,0.110,0.160,0.500,1.500,
									   0.160,0.160,0.160,0.500,1.500,
									   0.500,0.500,0.500,0.500,1.500,
									   1.500,1.500,1.500,1.500,1.500)
		minArea						= 0.042
		minEnclosedArea				= 0.2
		maxNumMinEdge				= 1
		minEdgeLength				= 0.09
}

Layer		"M2" {
		layerNumber					= 32
		maskName					= "metal2"
		isDefaultLayer				= 1
		visible						= 1
		selectable					= 1
		blink						= 0
		color						= "47"
		lineStyle					= "solid"
		pattern						= "backSlash"
		pitch						= 0.2
		defaultWidth				= 0.1
		minWidth					= 0.1
		minSpacing					= 0.1
		maxWidth					= 12
		stubSpacing					= 0.12
		stubThreshold				= 0.119
		endOfLineCornerKeepoutWidth	= 0.035
		maxSegLenForRC				= 1000
		fatTblDimension				= 5
		fatTblThreshold				= (0.000,0.201,0.381,1.501,4.501)
		fatTblParallelLength		= (0.000,0.381,0.381,1.501,4.501)
		fatTblSpacing				= (0.100,0.120,0.160,0.500,1.500,
									   0.120,0.120,0.160,0.500,1.500,
									   0.160,0.160,0.160,0.500,1.500,
									   0.500,0.500,0.500,0.500,1.500,
									   1.500,1.500,1.500,1.500,1.500)
		minArea						= 0.052
		minEnclosedArea				= 0.2
		maxNumMinEdge				= 1
		minEdgeLength				= 0.1
}

Layer		"M3" {
		layerNumber					= 33
		maskName					= "metal3"
		isDefaultLayer				= 1
		visible						= 1
		selectable					= 1
		blink						= 0
		color						= "59"
		lineStyle					= "solid"
		pattern						= "slash"
		pitch						= 0.2
		defaultWidth				= 0.1
		minWidth					= 0.1
		minSpacing					= 0.1
		maxWidth					= 12
		stubSpacing					= 0.12
		stubThreshold				= 0.119
		endOfLineCornerKeepoutWidth	= 0.035
		maxSegLenForRC				= 1000
		fatTblDimension				= 5
		fatTblThreshold				= (0.000,0.201,0.381,1.501,4.501)
		fatTblParallelLength		= (0.000,0.381,0.381,1.501,4.501)
		fatTblSpacing				= (0.100,0.120,0.160,0.500,1.500,
									   0.120,0.120,0.160,0.500,1.500,
									   0.160,0.160,0.160,0.500,1.500,
									   0.500,0.500,0.500,0.500,1.500,
									   1.500,1.500,1.500,1.500,1.500)
		minArea						= 0.052
		minEnclosedArea				= 0.2
		maxNumMinEdge				= 1
		minEdgeLength				= 0.1
}

Layer		"M4" {
		layerNumber					= 34
		maskName					= "metal4"
		isDefaultLayer				= 1
		visible						= 1
		selectable					= 1
		blink						= 0
		color						= "drab"
		lineStyle					= "solid"
		pattern						= "dot"
		pitch						= 0.2
		defaultWidth				= 0.1
		minWidth					= 0.1
		minSpacing					= 0.1
		maxWidth					= 12
		stubSpacing					= 0.12
		endOfLineCornerKeepoutWidth	= 0.035
		stubThreshold				= 0.119
		maxSegLenForRC				= 1000
		fatTblDimension				= 5
		fatTblThreshold				= (0.000,0.201,0.381,1.501,4.501)
		fatTblParallelLength		= (0.000,0.381,0.381,1.501,4.501)
		fatTblSpacing				= (0.100,0.120,0.160,0.500,1.500,
									   0.120,0.120,0.160,0.500,1.500,
									   0.160,0.160,0.160,0.500,1.500,
									   0.500,0.500,0.500,0.500,1.500,
									   1.500,1.500,1.500,1.500,1.500)
		minArea						= 0.052
		minEnclosedArea				= 0.2
		maxNumMinEdge				= 1
		minEdgeLength				= 0.1
}

Layer		"M5" {
		layerNumber					= 35
		maskName					= "metal5"
		isDefaultLayer				= 1
		visible						= 1
		selectable					= 1
		blink						= 0
		color						= "40"
		lineStyle					= "solid"
		pattern						= "zigzag"
		pitch						= 0.2
		defaultWidth				= 0.1
		minWidth					= 0.1
		minSpacing					= 0.1
		maxWidth					= 12
		stubSpacing					= 0.12
		stubThreshold				= 0.119
		endOfLineCornerKeepoutWidth	= 0.035
		maxSegLenForRC				= 1000
		fatTblDimension				= 5
		fatTblThreshold				= (0.000,0.201,0.381,1.501,4.501)
		fatTblParallelLength		= (0.000,0.381,0.381,1.501,4.501)
		fatTblSpacing				= (0.100,0.120,0.160,0.500,1.500,
									   0.120,0.120,0.160,0.500,1.500,
									   0.160,0.160,0.160,0.500,1.500,
									   0.500,0.500,0.500,0.500,1.500,
									   1.500,1.500,1.500,1.500,1.500)
		minArea						= 0.052
		minEnclosedArea				= 0.2
		maxNumMinEdge				= 1
		minEdgeLength				= 0.1
}

Layer		"M6" {
		layerNumber				= 36
		maskName				= "metal6"
		isDefaultLayer			= 1
		visible					= 1
		selectable				= 1
		blink					= 0
		color					= "orange"
		lineStyle				= "solid"
		pattern					= "wave"
		pitch					= 0.8
		defaultWidth			= 0.4
		minWidth				= 0.4
		minSpacing				= 0.4
		maxWidth				= 12
		maxSegLenForRC			= 1000
		fatTblDimension			= 3
		fatTblThreshold			= (0.000,1.501,4.501)
		fatTblParallelLength	= (0.000,1.501,4.501)
		fatTblSpacing			= (0.400,0.500,1.500,
								   0.500,0.500,1.500,
								   1.500,1.500,1.500)
		minArea					= 0.565
		minEnclosedArea			= 0.565
		maxNumMinEdge			= 1
		minEdgeLength			= 0.4
}

Layer		"M7" {
		layerNumber				= 37
		maskName				= "metal7"
		isDefaultLayer			= 1
		visible					= 1
		selectable				= 1
		blink					= 0
		color					= "purple"
		lineStyle				= "solid"
		pattern					= "enter"
		pitch					= 0.8
		defaultWidth			= 0.4
		minWidth				= 0.4
		minSpacing				= 0.4
		maxWidth				= 12
		maxSegLenForRC			= 1000
		fatTblDimension			= 3
		fatTblThreshold			= (0.000,1.501,4.501)
		fatTblParallelLength	= (0.000,1.501,4.501)
		fatTblSpacing			= (0.400,0.500,1.500,
								   0.500,0.500,1.500,
								   1.500,1.500,1.500)
		minArea					= 0.565
		minEnclosedArea			= 0.565
		maxNumMinEdge			= 1
		minEdgeLength			= 0.4
}
Layer 	 "AP" {
		layerNumber		= 74
		maskName		= "metal8"
		visible			= 1
		selectable		= 1
		blink			= 0
		color			= "yellow"
		lineStyle		= "solid"
		pattern			= "blank"
		defaultWidth	= 3.0
		minWidth		= 3.0
		minSpacing		= 2.0
		maxWidth		= 35
		pitch			= 15.0
		maxSegLenForRC	= 1000
}

Layer		"VIA1" {
		layerNumber			= 51
		maskName			= "via1"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "43"
		lineStyle			= "solid"
		pattern				= "rectangleX"
		pitch				= 0
		defaultWidth			= 0.1
		minWidth			= 0.1
		minSpacing			= 0.13
		sameNetMinSpacing		= 0.13
		cornerMinSpacing		= 0.1
                fatTblDimension                 = 5
                fatTblThreshold                 = (0,0.301,0.701,2.001,3.001)
                fatTblExtensionRange            = (0,0.8,0.8,2,5)
                fatTblFatContactNumber          = (42,42,43,43,43)
                fatTblFatContactMinCuts         = (1,2,4,4,4)
                fatTblExtensionContactNumber    = (42,42,42,42,42)
                fatTblExtensionMinCuts          = (1,2,2,2,2)
                enclosedCutNumNeighbor          = 3
                enclosedCutNeighborRange        = 0.14
                enclosedCutToNeighborMinSpacing = 0.13
}

Layer		"VIA2" {
		layerNumber			= 52
		maskName			= "via2"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "LightBlue"
		lineStyle			= "solid"
		pattern				= "rectangleX"
		pitch				= 0
		defaultWidth			= 0.1
		minWidth			= 0.1
		minSpacing			= 0.13
		cornerMinSpacing		= 0.1
		sameNetMinSpacing		= 0.13
                fatTblDimension                 = 5
                fatTblThreshold                 = (0,0.301,0.701,2.001,3.001)
                fatTblExtensionRange            = (0,0.8,0.8,2,5)
                fatTblFatContactNumber          = (3,23,23,23,23)
                fatTblFatContactMinCuts         = (1,2,4,4,4)
                fatTblExtensionContactNumber    = (3,3,3,3,3)
                fatTblExtensionMinCuts          = (1,2,2,2,2)
                enclosedCutNumNeighbor          = 3
                enclosedCutNeighborRange        = 0.14
                enclosedCutToNeighborMinSpacing = 0.13
}

Layer		"VIA3" {
		layerNumber			= 53
		maskName			= "via3"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		lineStyle			= "solid"
		pattern				= "rectangleX"
		pitch				= 0
		defaultWidth			= 0.1
		minWidth			= 0.1
		minSpacing			= 0.13
		cornerMinSpacing		= 0.1
		sameNetMinSpacing		= 0.13
                fatTblDimension                 = 5
                fatTblThreshold                 = (0,0.301,0.701,2.001,3.001)
                fatTblExtensionRange            = (0,0.8,0.8,2,5)
                fatTblFatContactNumber          = (4,24,24,24,24)
                fatTblFatContactMinCuts         = (1,2,4,4,4)
                fatTblExtensionContactNumber    = (4,4,4,4,4)
                fatTblExtensionMinCuts          = (1,2,2,2,2)
                enclosedCutNumNeighbor          = 3
                enclosedCutNeighborRange        = 0.14
                enclosedCutToNeighborMinSpacing = 0.13
}

Layer		"VIA4" {
		layerNumber			= 54
		maskName			= "via4"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "white"
		lineStyle			= "solid"
		pattern				= "rectangleX"
		pitch				= 0
		defaultWidth			= 0.1
		minWidth			= 0.1
		minSpacing			= 0.13
		cornerMinSpacing		= 0.1
		sameNetMinSpacing		= 0.13
                fatTblDimension                 = 5
                fatTblThreshold                 = (0,0.301,0.701,2.001,3.001)
                fatTblExtensionRange            = (0,0.8,0.8,2,5)
                fatTblFatContactNumber          = (5,25,25,25,25)
                fatTblFatContactMinCuts         = (1,2,4,4,4)
                fatTblExtensionContactNumber    = (5,5,5,5,5)
                fatTblExtensionMinCuts          = (1,2,2,2,2)
                enclosedCutNumNeighbor          = 3
                enclosedCutNeighborRange        = 0.14
                enclosedCutToNeighborMinSpacing = 0.13
}

Layer		"VIA5" {
		layerNumber			= 55
		maskName			= "via5"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "white"
		lineStyle			= "solid"
		pattern				= "rectangleX"
		pitch				= 0
		defaultWidth			= 0.36
		minWidth			= 0.36
		minSpacing			= 0.34
		fatTblDimension			= 3
		fatTblThreshold			= (0,1.801,3.001)
		fatTblExtensionRange		= (0,0,5)
		fatTblFatContactNumber		= (6,6,26)
		fatTblFatContactMinCuts		= (1,2,2)
		fatTblExtensionContactNumber	= (6,6,26)
		fatTblExtensionMinCuts		= (1,1,2)
		enclosedCutNumNeighbor		= 3
		enclosedCutNeighborRange	= 0.56
		enclosedCutToNeighborMinSpacing	= 0.54
}

Layer		"VIA6" {
		layerNumber			= 56
		maskName			= "via6"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "white"
		lineStyle			= "solid"
		pattern				= "rectangleX"
		pitch				= 0
		defaultWidth			= 0.36
		minWidth			= 0.36
		minSpacing			= 0.34
		fatTblDimension			= 3
		fatTblThreshold			= (0,1.801,3.001)
		fatTblExtensionRange		= (0,0,5)
		fatTblFatContactNumber		= (7,7,27)
		fatTblFatContactMinCuts		= (1,2,2)
		fatTblExtensionContactNumber	= (7,7,27)
		fatTblExtensionMinCuts		= (1,1,2)
		enclosedCutNumNeighbor		= 3
		enclosedCutNeighborRange	= 0.56
		enclosedCutToNeighborMinSpacing	= 0.54
}
Layer		"CB" {
		layerNumber		= 76
		maskName		= "via7"
		visible			= 1
		selectable		= 1
		blink			= 0
		color			= "orange"
		lineStyle		= "solid"
		pattern			= "blank"
		defaultWidth	= 3.0
		minWidth		= 3.0
		minSpacing		= 2.0
}

ContactCode	"CONT1" {
		contactCodeNumber		= 1
		cutLayer			= "CO"
		lowerLayer			= "PO"
		upperLayer			= "M1"
		isDefaultContact		= 1
		cutWidth			= 0.09
		cutHeight			= 0.09
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.13
		maxNumRowsNonTurning		= 5
}

ContactCode	"AVNT_via1_VH" {
		contactCodeNumber		= 2
		cutLayer			= "VIA1"
		lowerLayer			= "M1"
		upperLayer			= "M2"
		isDefaultContact		= 1
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0.04
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0.04
		minCutSpacing			= 0.1
		maxNumRowsNonTurning		= 5
}

ContactCode	"AVNT_via2" {
		contactCodeNumber		= 3
		cutLayer			= "VIA2"
		lowerLayer			= "M2"
		upperLayer			= "M3"
		isDefaultContact		= 1
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0.04
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0.04
		minCutSpacing			= 0.1
		maxNumRowsNonTurning		= 5
}

ContactCode	"AVNT_via3" {
		contactCodeNumber		= 4
		cutLayer			= "VIA3"
		lowerLayer			= "M3"
		upperLayer			= "M4"
		isDefaultContact		= 1
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0.04
		lowerLayerEncWidth		= 0.04
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.1
		maxNumRowsNonTurning		= 5
}

ContactCode	"AVNT_via4" {
		contactCodeNumber		= 5
		cutLayer			= "VIA4"
		lowerLayer			= "M4"
		upperLayer			= "M5"
		isDefaultContact		= 1
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0.04
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0.04
		minCutSpacing			= 0.1
		maxNumRowsNonTurning		= 5
}

ContactCode	"AVNT_via5" {
		contactCodeNumber		= 6
		cutLayer			= "VIA5"
		lowerLayer			= "M5"
		upperLayer			= "M6"
		isDefaultContact		= 1
		cutWidth			= 0.36
		cutHeight			= 0.36
		upperLayerEncWidth		= 0.02
		upperLayerEncHeight		= 0.08
		lowerLayerEncWidth		= 0.08
		lowerLayerEncHeight		= 0.02
		minCutSpacing			= 0.34
		maxNumRowsNonTurning		= 12
}

ContactCode	"AVNT_via6" {
		contactCodeNumber		= 7
		cutLayer			= "VIA6"
		lowerLayer			= "M6"
		upperLayer			= "M7"
		isDefaultContact		= 1
		cutWidth			= 0.36
		cutHeight			= 0.36
		upperLayerEncWidth		= 0.08
		upperLayerEncHeight		= 0.02
		lowerLayerEncWidth		= 0.02
		lowerLayerEncHeight		= 0.08
		minCutSpacing			= 0.34
		maxNumRowsNonTurning		= 12
}

ContactCode	"AVNT_via7" {
		contactCodeNumber		= 8
		cutLayer				= "CB"
		lowerLayer				= "M7"
		upperLayer				= "AP"
		isDefaultContact		= 1
		cutWidth				= 3.00
		cutHeight				= 3.00
		upperLayerEncWidth		= 1.00
		upperLayerEncHeight		= 1.00
		lowerLayerEncWidth		= 0.7
		lowerLayerEncHeight		= 0.7
		minCutSpacing			= 2
		maxNumRowsNonTurning	= 12
}

ContactCode	"AVNT_via2Fat" {
		contactCodeNumber		= 23
		cutLayer			= "VIA2"
		lowerLayer			= "M2"
		upperLayer			= "M3"
		isFatContact			= 1
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0.04
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0.04
		minCutSpacing			= 0.13
		maxNumRowsNonTurning		= 5
}

ContactCode	"AVNT_via3Fat" {
		contactCodeNumber		= 24
		cutLayer			= "VIA3"
		lowerLayer			= "M3"
		upperLayer			= "M4"
		isFatContact			= 1
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0.04
		lowerLayerEncWidth		= 0.04
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.13
		maxNumRowsNonTurning		= 5
}

ContactCode	"AVNT_via4Fat" {
		contactCodeNumber		= 25
		cutLayer			= "VIA4"
		lowerLayer			= "M4"
		upperLayer			= "M5"
		isFatContact			= 1
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0.04
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0.04
		minCutSpacing			= 0.13
		maxNumRowsNonTurning		= 5
}

ContactCode	"AVNT_via5Fat" {
		contactCodeNumber		= 26
		cutLayer			= "VIA5"
		lowerLayer			= "M5"
		upperLayer			= "M6"
		isFatContact			= 1
		cutWidth			= 0.36
		cutHeight			= 0.36
		upperLayerEncWidth		= 0.02
		upperLayerEncHeight		= 0.08
		lowerLayerEncWidth		= 0.08
		lowerLayerEncHeight		= 0.02
		minCutSpacing			= 0.54
		maxNumRowsNonTurning		= 12
}

ContactCode	"AVNT_via6Fat" {
		contactCodeNumber		= 27
		cutLayer			= "VIA6"
		lowerLayer			= "M6"
		upperLayer			= "M7"
		isFatContact			= 1
		cutWidth			= 0.36
		cutHeight			= 0.36
		upperLayerEncWidth		= 0.08
		upperLayerEncHeight		= 0.02
		lowerLayerEncWidth		= 0.02
		lowerLayerEncHeight		= 0.08
		minCutSpacing			= 0.54
		maxNumRowsNonTurning		= 12
}

ContactCode	"AVNT_via1_HH" {
		contactCodeNumber		= 32
		cutLayer			= "VIA1"
		lowerLayer			= "M1"
		upperLayer			= "M2"
		isDefaultContact		= 1
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0.04
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0.04
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.1
		maxNumRowsNonTurning		= 5
}

ContactCode	"AVNT_via1_HV" {
		contactCodeNumber		= 42
		cutLayer			= "VIA1"
		lowerLayer			= "M1"
		upperLayer			= "M2"
		isDefaultContact		= 1
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0.04
		lowerLayerEncWidth		= 0.04
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.1
		maxNumRowsNonTurning		= 5
}

ContactCode	"AVNT_via1_HVFat" {
		contactCodeNumber		= 43
		cutLayer			= "VIA1"
		lowerLayer			= "M1"
		upperLayer			= "M2"
		isFatContact			= 1
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0.04
		lowerLayerEncWidth		= 0.04
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.13
		maxNumRowsNonTurning		= 5
}

ContactCode	"AVNT_via1_VV" {
		contactCodeNumber		= 52
		cutLayer			= "VIA1"
		lowerLayer			= "M1"
		upperLayer			= "M2"
		isDefaultContact		= 1
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0.04
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0.04
		minCutSpacing			= 0.1
		maxNumRowsNonTurning		= 5
}

ContactCode	"AVNT_via1_VVFat" {
		contactCodeNumber		= 53
		cutLayer			= "VIA1"
		lowerLayer			= "M1"
		upperLayer			= "M2"
		isFatContact			= 1
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0.04
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0.04
		minCutSpacing			= 0.13
		maxNumRowsNonTurning		= 5
}

; # Added for DFM: extension of metal over via: 0.07um instead of 0.04um

; Via1

ContactCode	"AVNT_via1_VH_Ext" {
		contactCodeNumber		= 62
		cutLayer			= "VIA1"
		lowerLayer			= "M1"
		upperLayer			= "M2"
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0.07
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0.04
		minCutSpacing			= 0.1
		maxNumRowsNonTurning		= 5
}

ContactCode	"AVNT_via1_HH_Ext" {
		contactCodeNumber		= 72
		cutLayer			= "VIA1"
		lowerLayer			= "M1"
		upperLayer			= "M2"
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0.07
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0.04
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.1
		maxNumRowsNonTurning		= 5
}

ContactCode	"AVNT_via1_HV_Ext" {
		contactCodeNumber		= 82
		cutLayer			= "VIA1"
		lowerLayer			= "M1"
		upperLayer			= "M2"
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0.07
		lowerLayerEncWidth		= 0.04
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.1
		maxNumRowsNonTurning		= 5
}

ContactCode	"AVNT_via1_VV_Ext" {
		contactCodeNumber		= 92
		cutLayer			= "VIA1"
		lowerLayer			= "M1"
		upperLayer			= "M2"
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0.07
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0.04
		minCutSpacing			= 0.1
		maxNumRowsNonTurning		= 5
}

; Via2

ContactCode	"AVNT_via2_Ext" {
		contactCodeNumber		= 63
		cutLayer			= "VIA2"
		lowerLayer			= "M2"
		upperLayer			= "M3"
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0.07
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0.07
		minCutSpacing			= 0.1
		maxNumRowsNonTurning		= 5
}

; Via3

ContactCode	"AVNT_via3_Ext" {
		contactCodeNumber		= 64
		cutLayer			= "VIA3"
		lowerLayer			= "M3"
		upperLayer			= "M4"
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0
		upperLayerEncHeight		= 0.07
		lowerLayerEncWidth		= 0.07
		lowerLayerEncHeight		= 0
		minCutSpacing			= 0.1
		maxNumRowsNonTurning		= 5
}

; Via4

ContactCode	"AVNT_via4_Ext" {
		contactCodeNumber		= 65
		cutLayer			= "VIA4"
		lowerLayer			= "M4"
		upperLayer			= "M5"
		cutWidth			= 0.1
		cutHeight			= 0.1
		upperLayerEncWidth		= 0.07
		upperLayerEncHeight		= 0
		lowerLayerEncWidth		= 0
		lowerLayerEncHeight		= 0.07
		minCutSpacing			= 0.1
		maxNumRowsNonTurning		= 5
}

;# End DFM

DesignRule	{
		layer1				= "VIA2"
		layer2				= "VIA1"
		minSpacing			= 0
		stackable			= 1
}

DesignRule	{
		layer1				= "VIA3"
		layer2				= "VIA2"
		minSpacing			= 0
		stackable			= 1
}

DesignRule	{
		layer1				= "VIA4"
		layer2				= "VIA3"
		minSpacing			= 0
		stackable			= 1
}

DesignRule	{
		layer1				= "VIA5"
		layer2				= "VIA4"
		minSpacing			= 0
		stackable			= 1
}

DesignRule	{
		layer1				= "VIA6"
		layer2				= "VIA5"
		minSpacing			= 0
		stackable			= 1
}

DesignRule	{
		layer1				= "via1Blockage"
		layer2				= "VIA1"
		minSpacing			= 0.15
}

DesignRule	{
		layer1				= "via2Blockage"
		layer2				= "VIA2"
		minSpacing			= 0.15
}

DesignRule	{
		layer1				= "via3Blockage"
		layer2				= "VIA3"
		minSpacing			= 0.15
}

DesignRule	{
		layer1				= "via4Blockage"
		layer2				= "VIA4"
		minSpacing			= 0.15
}

DesignRule	{
		layer1				= "via5Blockage"
		layer2				= "VIA5"
		minSpacing			= 0.34
}

DesignRule	{
		layer1				= "via6Blockage"
		layer2				= "VIA6"
		minSpacing			= 0.34
}
;
;

Color		2 {
		name				= "lila"
		rgbDefined			= 1
		redIntensity			= 152
		greenIntensity			= 154
		blueIntensity			= 215
}

Color		3 {
		name				= "gold"
		rgbDefined			= 1
		redIntensity			= 217
		greenIntensity			= 204
		blueIntensity			= 0
}

Color		4 {
		name				= "LightBlue"
		rgbDefined			= 1
		redIntensity			= 154
		greenIntensity			= 192
		blueIntensity			= 205
}

Color		7 {
		name				= "7"
		rgbDefined			= 1
		redIntensity			= 0
		greenIntensity			= 80
		blueIntensity			= 255
}

Color		8 {
		name				= "violet"
		rgbDefined			= 1
		redIntensity			= 94
		greenIntensity			= 0
		blueIntensity			= 230
}

Color		9 {
		name				= "silver"
		rgbDefined			= 1
		redIntensity			= 217
		greenIntensity			= 230
		blueIntensity			= 255
}

Color		10 {
		name				= "cream"
		rgbDefined			= 1
		redIntensity			= 255
		greenIntensity			= 255
		blueIntensity			= 204
}

Color		11 {
		name				= "pink"
		rgbDefined			= 1
		redIntensity			= 255
		greenIntensity			= 191
		blueIntensity			= 242
}

Color		13 {
		name				= "lime"
		rgbDefined			= 1
		redIntensity			= 0
		greenIntensity			= 255
		blueIntensity			= 0
}

Color		14 {
		name				= "tan"
		rgbDefined			= 1
		redIntensity			= 255
		greenIntensity			= 230
		blueIntensity			= 191
}

Color		15 {
		name				= "cyan"
		rgbDefined			= 1
		redIntensity			= 0
		greenIntensity			= 255
		blueIntensity			= 255
}

Color		21 {
		name				= "kaki"
		rgbDefined			= 1
		redIntensity			= 189
		greenIntensity			= 183
		blueIntensity			= 107
}

Color		25 {
		name				= "maroon"
		rgbDefined			= 1
		redIntensity			= 230
		greenIntensity			= 31
		blueIntensity			= 13
}

Color		27 {
		name				= "forest"
		rgbDefined			= 1
		redIntensity			= 38
		greenIntensity			= 140
		blueIntensity			= 107
}

Color		28 {
		name				= "chocolate"
		rgbDefined			= 1
		redIntensity			= 128
		greenIntensity			= 38
		blueIntensity			= 38
}

Color		40 {
		name				= "40"
		rgbDefined			= 1
		redIntensity			= 180
		greenIntensity			= 175
		blueIntensity			= 0
}

Color		43 {
		name				= "43"
		rgbDefined			= 1
		redIntensity			= 180
		greenIntensity			= 175
		blueIntensity			= 255
}

Color		47 {
		name				= "47"
		rgbDefined			= 1
		redIntensity			= 180
		greenIntensity			= 255
		blueIntensity			= 255
}

Color		49 {
		name				= "49"
		rgbDefined			= 1
		redIntensity			= 255
		greenIntensity			= 0
		blueIntensity			= 100
}

Color		59 {
		name				= "59"
		rgbDefined			= 1
		redIntensity			= 255
		greenIntensity			= 175
		blueIntensity			= 255
}

Tile		"unit" {
		width				= 0.2
		height				= 2.6
}

;
;	generated on Thu Jun 14 10:01:25 2007 from cmos065_7m4x0y2z.lmt DK@5.1
;
Layer 	 "DNW" {
		 layerNumber		= 1
		 maskName		= "DNW"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "net_DNW" {
		 layerNumber		= 1
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_DNW" {
		 layerNumber		= 1
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "NW" {
		 layerNumber		= 3
		 maskName		= "NW"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "boundary_NW" {
		 layerNumber		= 3
		 dataTypeNumber		= 26
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_NW" {
		 layerNumber		= 3
		 dataTypeNumber		= 81
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "net_NW" {
		 layerNumber		= 3
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_NW" {
		 layerNumber		= 3
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "OD" {
		 layerNumber		= 6
		 maskName		= "OD"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "tile_OD" {
		 layerNumber		= 6
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "boundary_OD" {
		 layerNumber		= 6
		 dataTypeNumber		= 26
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_OD" {
		 layerNumber		= 6
		 dataTypeNumber		= 81
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "pin_OD" {
		 layerNumber		= 6
		 dataTypeNumber		= 82
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "net_OD" {
		 layerNumber		= 6
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_OD" {
		 layerNumber		= 6
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "NT_N" {
		 layerNumber		= 11
		 maskName		= "NT_N"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer 	 "VTL_N" {
		 layerNumber		= 12
		 maskName		= "VTL_N"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "mask_VTL_N" {
		 layerNumber		= 12
		 dataTypeNumber		= 81
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_VTL_N" {
		 layerNumber		= 12
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "VTL_P" {
		 layerNumber		= 13
		 maskName		= "VTL_P"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "mask_VTL_P" {
		 layerNumber		= 13
		 dataTypeNumber		= 81
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_VTL_P" {
		 layerNumber		= 13
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "OD_18" {
		 layerNumber		= 16
		 maskName		= "OD_18"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "noprocessing_OD_18" {
		 layerNumber		= 16
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_PO" {
		 layerNumber		= 17
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "psm_PO" {
		 layerNumber		= 17
		 dataTypeNumber		= 2
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "boundary_PO" {
		 layerNumber		= 17
		 dataTypeNumber		= 26
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_PO" {
		 layerNumber		= 17
		 dataTypeNumber		= 81
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_PO" {
		 layerNumber		= 17
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "connector_PO" {
		 layerNumber		= 17
		 dataTypeNumber		= 221
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "cutout_PO" {
		 layerNumber		= 17
		 dataTypeNumber		= 222
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "psmBlock_PO" {
		 layerNumber		= 17
		 dataTypeNumber		= 223
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "OD_25" {
		 layerNumber		= 18
		 maskName		= "OD_25"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "noprocessing_OD_25" {
		 layerNumber		= 18
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "PP" {
		 layerNumber		= 25
		 maskName		= "PP"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "mask_PP" {
		 layerNumber		= 25
		 dataTypeNumber		= 81
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_PP" {
		 layerNumber		= 25
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "NP" {
		 layerNumber		= 26
		 maskName		= "NP"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "mask_NP" {
		 layerNumber		= 26
		 dataTypeNumber		= 81
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_NP" {
		 layerNumber		= 26
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "OD1T" {
		 layerNumber		= 27
		 maskName		= "OD1T"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer 	 "RPO" {
		 layerNumber		= 29
		 maskName		= "RPO"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "mask_RPO" {
		 layerNumber		= 29
		 dataTypeNumber		= 81
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_RPO" {
		 layerNumber		= 29
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "sramdmy_CO" {
		 layerNumber		= 30
		 dataTypeNumber		= 11
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "boundary_CO" {
		 layerNumber		= 30
		 dataTypeNumber		= 26
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "ctelec2_CO" {
		 layerNumber		= 30
		 dataTypeNumber		= 47
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "lil_CO" {
		 layerNumber		= 30
		 dataTypeNumber		= 48
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "net_CO" {
		 layerNumber		= 30
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_CO" {
		 layerNumber		= 30
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_M1" {
		 layerNumber		= 31
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_O_M1" {
		 layerNumber		= 31
		 dataTypeNumber		= 7
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_M1" {
		 layerNumber		= 31
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_M2" {
		 layerNumber		= 32
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_O_M2" {
		 layerNumber		= 32
		 dataTypeNumber		= 7
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_M2" {
		 layerNumber		= 32
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_M3" {
		 layerNumber		= 33
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_O_M3" {
		 layerNumber		= 33
		 dataTypeNumber		= 7
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_M3" {
		 layerNumber		= 33
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_M4" {
		 layerNumber		= 34
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_O_M4" {
		 layerNumber		= 34
		 dataTypeNumber		= 7
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_M4" {
		 layerNumber		= 34
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_M5" {
		 layerNumber		= 35
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_O_M5" {
		 layerNumber		= 35
		 dataTypeNumber		= 7
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawingY_M5" {
		 layerNumber		= 35
		 dataTypeNumber		= 20
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileY_M5" {
		 layerNumber		= 35
		 dataTypeNumber		= 21
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_M5" {
		 layerNumber		= 35
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_M6" {
		 layerNumber		= 36
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_O_M6" {
		 layerNumber		= 36
		 dataTypeNumber		= 7
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawingY_M6" {
		 layerNumber		= 36
		 dataTypeNumber		= 20
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileY_M6" {
		 layerNumber		= 36
		 dataTypeNumber		= 21
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_OY_M6" {
		 layerNumber		= 36
		 dataTypeNumber		= 27
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawingZ_M6" {
		 layerNumber		= 36
		 dataTypeNumber		= 40
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileZ_M6" {
		 layerNumber		= 36
		 dataTypeNumber		= 41
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_M6" {
		 layerNumber		= 36
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_M7" {
		 layerNumber		= 37
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_O_M7" {
		 layerNumber		= 37
		 dataTypeNumber		= 7
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawingY_M7" {
		 layerNumber		= 37
		 dataTypeNumber		= 20
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileY_M7" {
		 layerNumber		= 37
		 dataTypeNumber		= 21
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_OY_M7" {
		 layerNumber		= 37
		 dataTypeNumber		= 27
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawingZ_M7" {
		 layerNumber		= 37
		 dataTypeNumber		= 40
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileZ_M7" {
		 layerNumber		= 37
		 dataTypeNumber		= 41
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_M7" {
		 layerNumber		= 37
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_M8" {
		 layerNumber		= 38
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawingY_M8" {
		 layerNumber		= 38
		 dataTypeNumber		= 20
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileY_M8" {
		 layerNumber		= 38
		 dataTypeNumber		= 21
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawingZ_M8" {
		 layerNumber		= 38
		 dataTypeNumber		= 40
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileZ_M8" {
		 layerNumber		= 38
		 dataTypeNumber		= 41
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_M8" {
		 layerNumber		= 38
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_M9" {
		 layerNumber		= 39
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawingY_M9" {
		 layerNumber		= 39
		 dataTypeNumber		= 20
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileY_M9" {
		 layerNumber		= 39
		 dataTypeNumber		= 21
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawingZ_M9" {
		 layerNumber		= 39
		 dataTypeNumber		= 40
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileZ_M9" {
		 layerNumber		= 39
		 dataTypeNumber		= 41
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_M9" {
		 layerNumber		= 39
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "SRM" {
		 layerNumber		= 50
		 maskName		= "SRM"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "sram1_SRM" {
		 layerNumber		= 50
		 dataTypeNumber		= 11
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "sram2_SRM" {
		 layerNumber		= 50
		 dataTypeNumber		= 12
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "sram3_SRM" {
		 layerNumber		= 50
		 dataTypeNumber		= 13
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "net_VIA1" {
		 layerNumber		= 51
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_VIA1" {
		 layerNumber		= 51
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "net_VIA2" {
		 layerNumber		= 52
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_VIA2" {
		 layerNumber		= 52
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "net_VIA3" {
		 layerNumber		= 53
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_VIA3" {
		 layerNumber		= 53
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawingY_VIA4" {
		 layerNumber		= 54
		 dataTypeNumber		= 20
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "net_VIA4" {
		 layerNumber		= 54
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_VIA4" {
		 layerNumber		= 54
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawingY_VIA5" {
		 layerNumber		= 55
		 dataTypeNumber		= 20
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawingZ_VIA5" {
		 layerNumber		= 55
		 dataTypeNumber		= 40
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "net_VIA5" {
		 layerNumber		= 55
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_VIA5" {
		 layerNumber		= 55
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawingY_VIA6" {
		 layerNumber		= 56
		 dataTypeNumber		= 20
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawingZ_VIA6" {
		 layerNumber		= 56
		 dataTypeNumber		= 40
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "net_VIA6" {
		 layerNumber		= 56
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_VIA6" {
		 layerNumber		= 56
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawingY_VIA7" {
		 layerNumber		= 57
		 dataTypeNumber		= 20
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawingZ_VIA7" {
		 layerNumber		= 57
		 dataTypeNumber		= 40
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "net_VIA7" {
		 layerNumber		= 57
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_VIA7" {
		 layerNumber		= 57
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawingY_VIA8" {
		 layerNumber		= 58
		 dataTypeNumber		= 20
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawingZ_VIA8" {
		 layerNumber		= 58
		 dataTypeNumber		= 40
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "net_VIA8" {
		 layerNumber		= 58
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_VIA8" {
		 layerNumber		= 58
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "ippid_MKR" {
		 layerNumber		= 63
		 dataTypeNumber		= 63
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "VTH_N" {
		 layerNumber		= 67
		 maskName		= "VTH_N"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "mask_VTH_N" {
		 layerNumber		= 67
		 dataTypeNumber		= 81
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_VTH_N" {
		 layerNumber		= 67
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "VTH_P" {
		 layerNumber		= 68
		 maskName		= "VTH_P"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "mask_VTH_P" {
		 layerNumber		= 68
		 dataTypeNumber		= 81
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_VTH_P" {
		 layerNumber		= 68
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "HRI" {
		 layerNumber		= 70
		 maskName		= "HRI"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "noprocessing_HRI" {
		 layerNumber		= 70
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_AP" {
		 layerNumber		= 74
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "boundary_AP" {
		 layerNumber		= 74
		 dataTypeNumber		= 26
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "pin_AP" {
		 layerNumber		= 74
		 dataTypeNumber		= 82
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "net_AP" {
		 layerNumber		= 74
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_AP" {
		 layerNumber		= 74
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "boundary_CB" {
		 layerNumber		= 76
		 dataTypeNumber		= 26
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "pin_CB" {
		 layerNumber		= 76
		 dataTypeNumber		= 82
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "net_CB" {
		 layerNumber		= 76
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_CB" {
		 layerNumber		= 76
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "MKTOPMIM" {
		 layerNumber		= 77
		 maskName		= "MKTOPMIM"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "tile_MKTOPMIM" {
		 layerNumber		= 77
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_MKTOPMIM" {
		 layerNumber		= 77
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "CB2" {
		 layerNumber		= 86
		 maskName		= "CB2"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "boundary_CB2" {
		 layerNumber		= 86
		 dataTypeNumber		= 26
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "pin_CB2" {
		 layerNumber		= 86
		 dataTypeNumber		= 82
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "net_CB2" {
		 layerNumber		= 86
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_CB2" {
		 layerNumber		= 86
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "BOTMIM" {
		 layerNumber		= 88
		 maskName		= "BOTMIM"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "tile_BOTMIM" {
		 layerNumber		= 88
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_BOTMIM" {
		 layerNumber		= 88
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "SOISUB" {
		 layerNumber		= 89
		 maskName		= "SOISUB"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "pin_SOISUB" {
		 layerNumber		= 89
		 dataTypeNumber		= 82
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "net_SOISUB" {
		 layerNumber		= 89
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_SOISUB" {
		 layerNumber		= 89
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "DCO" {
		 layerNumber		= 90
		 maskName		= "DCO"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "mask_DCO" {
		 layerNumber		= 90
		 dataTypeNumber		= 81
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_DCO" {
		 layerNumber		= 90
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "FW" {
		 layerNumber		= 95
		 maskName		= "FW"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "noprocessing_FW" {
		 layerNumber		= 95
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer	 "pm_MKR" {
		 layerNumber		= 106
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer 	 "overlap" {
		 layerNumber		= 107
		 maskName		= "overlap"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "boundary_overlap" {
		 layerNumber		= 107
		 dataTypeNumber		= 26
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "prBoundary" {
		 layerNumber		= 108
		 maskName		= "prBoundary"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "label_prBoundary" {
		 layerNumber		= 108
		 dataTypeNumber		= 25
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "boundary_prBoundary" {
		 layerNumber		= 108
		 dataTypeNumber		= 26
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "LMARK" {
		 layerNumber		= 109
		 maskName		= "LMARK"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "noprocessing_LMARK" {
		 layerNumber		= 109
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer	 "BJT_MKR" {
		 layerNumber		= 110
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "msub_MKR" {
		 layerNumber		= 111
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "rw_MKR" {
		 layerNumber		= 113
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "rp_MKR" {
		 layerNumber		= 115
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "res_M1" {
		 layerNumber		= 116
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "res_M2" {
		 layerNumber		= 116
		 dataTypeNumber		= 2
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "res_M3" {
		 layerNumber		= 116
		 dataTypeNumber		= 3
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "res_M4" {
		 layerNumber		= 116
		 dataTypeNumber		= 4
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "res_M5" {
		 layerNumber		= 116
		 dataTypeNumber		= 5
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "res_M6" {
		 layerNumber		= 116
		 dataTypeNumber		= 6
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "res_M7" {
		 layerNumber		= 116
		 dataTypeNumber		= 7
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "res_M8" {
		 layerNumber		= 116
		 dataTypeNumber		= 8
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "res_M9" {
		 layerNumber		= 116
		 dataTypeNumber		= 9
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "res_OD" {
		 layerNumber		= 116
		 dataTypeNumber		= 18
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "res_PO" {
		 layerNumber		= 116
		 dataTypeNumber		= 19
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "res_AP" {
		 layerNumber		= 116
		 dataTypeNumber		= 20
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer	 "RH_MKR" {
		 layerNumber		= 117
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "excl_MKR" {
		 layerNumber		= 121
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "sdi_MKR" {
		 layerNumber		= 122
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer 	 "text" {
		 layerNumber		= 127
		 maskName		= "text"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "drawing1_text" {
		 layerNumber		= 127
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawing2_text" {
		 layerNumber		= 127
		 dataTypeNumber		= 2
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer	 "pin_M1" {
		 layerNumber		= 131
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "net_M1" {
		 layerNumber		= 131
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer	 "pin_M2" {
		 layerNumber		= 132
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "net_M2" {
		 layerNumber		= 132
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer	 "pin_M3" {
		 layerNumber		= 133
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "net_M3" {
		 layerNumber		= 133
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer	 "pin_M4" {
		 layerNumber		= 134
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "net_M4" {
		 layerNumber		= 134
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer	 "pin_M5" {
		 layerNumber		= 135
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "net_M5" {
		 layerNumber		= 135
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer	 "pin_M6" {
		 layerNumber		= 136
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "net_M6" {
		 layerNumber		= 136
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer	 "pin_M7" {
		 layerNumber		= 137
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "net_M7" {
		 layerNumber		= 137
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer	 "pin_M8" {
		 layerNumber		= 138
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "net_M8" {
		 layerNumber		= 138
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer	 "pin_M9" {
		 layerNumber		= 139
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "net_M9" {
		 layerNumber		= 139
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer	 "VAR_MKR" {
		 layerNumber		= 143
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "ind_MKR" {
		 layerNumber		= 144
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer 	 "esd2" {
		 layerNumber		= 146
		 maskName		= "esd2"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "pin_PO" {
		 layerNumber		= 149
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "net_PO" {
		 layerNumber		= 149
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileNot_M1" {
		 layerNumber		= 150
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileNot_M2" {
		 layerNumber		= 150
		 dataTypeNumber		= 2
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileNot_M3" {
		 layerNumber		= 150
		 dataTypeNumber		= 3
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileNot_M4" {
		 layerNumber		= 150
		 dataTypeNumber		= 4
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileNot_M5" {
		 layerNumber		= 150
		 dataTypeNumber		= 5
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileNot_M6" {
		 layerNumber		= 150
		 dataTypeNumber		= 6
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileNot_M7" {
		 layerNumber		= 150
		 dataTypeNumber		= 7
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileNot_M8" {
		 layerNumber		= 150
		 dataTypeNumber		= 8
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileNot_M9" {
		 layerNumber		= 150
		 dataTypeNumber		= 9
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileNot_OD" {
		 layerNumber		= 150
		 dataTypeNumber		= 20
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileNot_PO" {
		 layerNumber		= 150
		 dataTypeNumber		= 21
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileNot_AP" {
		 layerNumber		= 150
		 dataTypeNumber		= 22
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileNot_BOTMIM" {
		 layerNumber		= 150
		 dataTypeNumber		= 23
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer 	 "POFUSE" {
		 layerNumber		= 156
		 maskName		= "POFUSE"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "fuselink_MKR" {
		 layerNumber		= 156
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer	 "logo_MKR" {
		 layerNumber		= 158
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "rf_MKR" {
		 layerNumber		= 161
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "rf_M1" {
		 layerNumber		= 161
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "rf_M2" {
		 layerNumber		= 161
		 dataTypeNumber		= 2
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "rf_M3" {
		 layerNumber		= 161
		 dataTypeNumber		= 3
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "rf_M4" {
		 layerNumber		= 161
		 dataTypeNumber		= 4
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "rf_M5" {
		 layerNumber		= 161
		 dataTypeNumber		= 5
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "rf_M6" {
		 layerNumber		= 161
		 dataTypeNumber		= 6
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "rf_M7" {
		 layerNumber		= 161
		 dataTypeNumber		= 7
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer	 "sealring_MKR" {
		 layerNumber		= 162
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "csr_MKR" {
		 layerNumber		= 166
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "pin_NW" {
		 layerNumber		= 180
		 dataTypeNumber		= 2
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer	 "sramdmy_MKR" {
		 layerNumber		= 186
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "srampg_MKR" {
		 layerNumber		= 186
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "srmperi_MKR" {
		 layerNumber		= 186
		 dataTypeNumber		= 4
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer	 "boundary_M1" {
		 layerNumber		= 9
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "boundary_M2" {
		 layerNumber		= 10
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "boundary_M3" {
		 layerNumber		= 14
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "boundary_M4" {
		 layerNumber		= 15
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "boundary_M5" {
		 layerNumber		= 19
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "boundary_M6" {
		 layerNumber		= 20
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "boundary_M7" {
		 layerNumber		= 21
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "boundary_M8" {
		 layerNumber		= 22
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "boundary_M9" {
		 layerNumber		= 23
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer 	 "SRC" {
		 layerNumber		= 41
		 maskName		= "SRC"
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
LayerDataType 	 "boundary_AFET" {
		 layerNumber		= 41
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "AFET_N_A_drawing" {
		 layerNumber		= 41
		 dataTypeNumber		= 10
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_AFET_N_A" {
		 layerNumber		= 41
		 dataTypeNumber		= 11
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_AFET_N_A" {
		 layerNumber		= 41
		 dataTypeNumber		= 12
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "AFET_P_A_drawing" {
		 layerNumber		= 41
		 dataTypeNumber		= 20
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_AFET_P_A" {
		 layerNumber		= 41
		 dataTypeNumber		= 21
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_AFET_P_A" {
		 layerNumber		= 41
		 dataTypeNumber		= 22
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "AFET_N_B_drawing" {
		 layerNumber		= 41
		 dataTypeNumber		= 30
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_AFET_N_B" {
		 layerNumber		= 41
		 dataTypeNumber		= 31
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_AFET_N_B" {
		 layerNumber		= 41
		 dataTypeNumber		= 32
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "AFET_P_B_drawing" {
		 layerNumber		= 41
		 dataTypeNumber		= 40
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_AFET_P_B" {
		 layerNumber		= 41
		 dataTypeNumber		= 41
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_AFET_P_B" {
		 layerNumber		= 41
		 dataTypeNumber		= 42
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "plateC_M1" {
		 layerNumber		= 2
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "plateC_M2" {
		 layerNumber		= 2
		 dataTypeNumber		= 2
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "plateC_M3" {
		 layerNumber		= 2
		 dataTypeNumber		= 3
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "plateC_M4" {
		 layerNumber		= 2
		 dataTypeNumber		= 4
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "plateC_M5" {
		 layerNumber		= 2
		 dataTypeNumber		= 5
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "plateC_M6" {
		 layerNumber		= 2
		 dataTypeNumber		= 6
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "plateC_M7" {
		 layerNumber		= 2
		 dataTypeNumber		= 7
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "plateC_M8" {
		 layerNumber		= 2
		 dataTypeNumber		= 8
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "plateC_M9" {
		 layerNumber		= 2
		 dataTypeNumber		= 9
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "fringeC_M1" {
		 layerNumber		= 4
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "fringeC_M2" {
		 layerNumber		= 4
		 dataTypeNumber		= 2
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "fringeC_M3" {
		 layerNumber		= 4
		 dataTypeNumber		= 3
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "fringeC_M4" {
		 layerNumber		= 4
		 dataTypeNumber		= 4
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "fringeC_M5" {
		 layerNumber		= 4
		 dataTypeNumber		= 5
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "fringeC_M6" {
		 layerNumber		= 4
		 dataTypeNumber		= 6
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "fringeC_M7" {
		 layerNumber		= 4
		 dataTypeNumber		= 7
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "fringeC_M8" {
		 layerNumber		= 4
		 dataTypeNumber		= 8
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "fringeC_M9" {
		 layerNumber		= 4
		 dataTypeNumber		= 9
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tileNot_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 24
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "xyprobe_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 37
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "DCAP_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 44
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "waiver_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 46
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "GP_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 55
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "IPFS_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 57
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "IPPS_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 58
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "IPST_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 59
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "IPAL_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 60
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "align_drawing" {
		 layerNumber		= 5
		 dataTypeNumber		= 63
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "Z0_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 69
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "Z1_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 70
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "Z2_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 71
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "Y0_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 72
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "Y1_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 73
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "Y2_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 74
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "Y3_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 75
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "M6_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 76
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "M7_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 77
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "M8_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 78
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "M9_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 79
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "T1_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 87
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "SOIBT_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 110
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "GATED_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 111
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "EDRAM_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 113
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drain_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 116
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "sram1_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 117
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "sram2_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 118
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "wb_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 119
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "fc_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 120
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tp_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 121
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "MSKREG_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 122
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "RET_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 123
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "HPSOI_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 124
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "plateC_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 125
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "NOLDD_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 126
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drmperi_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 127
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "OPCGP_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 128
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "HV_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 129
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "sram3_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 130
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "srmrepair_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 132
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "HPA_MKR_bis" {
		 layerNumber		= 5
		 dataTypeNumber		= 133
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "foxd_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 138
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "nodevice_ddnwpw" {
		 layerNumber		= 5
		 dataTypeNumber		= 140
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "sense_M1" {
		 layerNumber		= 7
		 dataTypeNumber		= 1
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "sense_M2" {
		 layerNumber		= 7
		 dataTypeNumber		= 2
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "sense_M3" {
		 layerNumber		= 7
		 dataTypeNumber		= 3
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "sense_M4" {
		 layerNumber		= 7
		 dataTypeNumber		= 4
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "sense_M5" {
		 layerNumber		= 7
		 dataTypeNumber		= 5
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "sense_M6" {
		 layerNumber		= 7
		 dataTypeNumber		= 6
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "sense_M7" {
		 layerNumber		= 7
		 dataTypeNumber		= 7
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "sense_M8" {
		 layerNumber		= 7
		 dataTypeNumber		= 8
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "sense_M9" {
		 layerNumber		= 7
		 dataTypeNumber		= 9
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_NW2V" {
		 layerNumber		= 42
		 dataTypeNumber		= 3
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_NW2V" {
		 layerNumber		= 42
		 dataTypeNumber		= 4
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "block_PW" {
		 layerNumber		= 42
		 dataTypeNumber		= 12
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_PW" {
		 layerNumber		= 42
		 dataTypeNumber		= 14
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "maskclear_PW" {
		 layerNumber		= 42
		 dataTypeNumber		= 15
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_PW2V" {
		 layerNumber		= 42
		 dataTypeNumber		= 23
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_PW2V" {
		 layerNumber		= 42
		 dataTypeNumber		= 24
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_VTNCELL" {
		 layerNumber		= 42
		 dataTypeNumber		= 33
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_VTNCELL" {
		 layerNumber		= 42
		 dataTypeNumber		= 34
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_NLDD_LP" {
		 layerNumber		= 42
		 dataTypeNumber		= 43
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_NLDD_LP" {
		 layerNumber		= 42
		 dataTypeNumber		= 44
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_PLDD_LP" {
		 layerNumber		= 42
		 dataTypeNumber		= 53
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_PLDD_LP" {
		 layerNumber		= 42
		 dataTypeNumber		= 54
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_NLDDGO2" {
		 layerNumber		= 42
		 dataTypeNumber		= 63
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_NLDDGO2" {
		 layerNumber		= 42
		 dataTypeNumber		= 64
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_PLDDGO2" {
		 layerNumber		= 42
		 dataTypeNumber		= 73
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_PLDDGO2" {
		 layerNumber		= 42
		 dataTypeNumber		= 74
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_PP2V" {
		 layerNumber		= 42
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_PP2V" {
		 layerNumber		= 42
		 dataTypeNumber		= 84
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_VTPCELL" {
		 layerNumber		= 42
		 dataTypeNumber		= 93
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_VTPCELL" {
		 layerNumber		= 42
		 dataTypeNumber		= 94
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_NLDD_GP" {
		 layerNumber		= 42
		 dataTypeNumber		= 103
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_NLDD_GP" {
		 layerNumber		= 42
		 dataTypeNumber		= 104
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_PLDD_GP" {
		 layerNumber		= 42
		 dataTypeNumber		= 113
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_PLDD_GP" {
		 layerNumber		= 42
		 dataTypeNumber		= 114
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_PPPREDOP" {
		 layerNumber		= 42
		 dataTypeNumber		= 133
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_PPPREDOP" {
		 layerNumber		= 42
		 dataTypeNumber		= 134
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_NPPREDOP" {
		 layerNumber		= 42
		 dataTypeNumber		= 143
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_NPPREDOP" {
		 layerNumber		= 42
		 dataTypeNumber		= 144
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_ADSHVTN" {
		 layerNumber		= 42
		 dataTypeNumber		= 154
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "maskclear_ADSHVTN" {
		 layerNumber		= 42
		 dataTypeNumber		= 155
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_ADSHVTP" {
		 layerNumber		= 42
		 dataTypeNumber		= 163
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_ADSHVTP" {
		 layerNumber		= 42
		 dataTypeNumber		= 164
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_ADLVTN" {
		 layerNumber		= 42
		 dataTypeNumber		= 174
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_ADLVTP" {
		 layerNumber		= 42
		 dataTypeNumber		= 184
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_GO2" {
		 layerNumber		= 42
		 dataTypeNumber		= 193
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_GO2" {
		 layerNumber		= 42
		 dataTypeNumber		= 194
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_EBMARK" {
		 layerNumber		= 42
		 dataTypeNumber		= 254
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_PWDRAM" {
		 layerNumber		= 43
		 dataTypeNumber		= 3
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_PWDRAM" {
		 layerNumber		= 43
		 dataTypeNumber		= 4
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "CELLIMP_drawing" {
		 layerNumber		= 43
		 dataTypeNumber		= 10
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_CELLIMP" {
		 layerNumber		= 43
		 dataTypeNumber		= 13
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_CELLIMP" {
		 layerNumber		= 43
		 dataTypeNumber		= 14
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "ELEC1_drawing" {
		 layerNumber		= 43
		 dataTypeNumber		= 20
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_ELEC1" {
		 layerNumber		= 43
		 dataTypeNumber		= 24
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "ELEC2_drawing" {
		 layerNumber		= 43
		 dataTypeNumber		= 30
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_ELEC2" {
		 layerNumber		= 43
		 dataTypeNumber		= 34
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_CTDRAM" {
		 layerNumber		= 43
		 dataTypeNumber		= 44
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_SVTNCELL" {
		 layerNumber		= 45
		 dataTypeNumber		= 3
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_SVTNCELL" {
		 layerNumber		= 45
		 dataTypeNumber		= 4
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_HVTPCELL" {
		 layerNumber		= 45
		 dataTypeNumber		= 13
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_HVTPCELL" {
		 layerNumber		= 45
		 dataTypeNumber		= 14
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "NEXT_drawing" {
		 layerNumber		= 45
		 dataTypeNumber		= 20
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_NEXT" {
		 layerNumber		= 45
		 dataTypeNumber		= 23
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_NEXT" {
		 layerNumber		= 45
		 dataTypeNumber		= 24
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "PEXT_drawing" {
		 layerNumber		= 45
		 dataTypeNumber		= 30
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_PEXT" {
		 layerNumber		= 45
		 dataTypeNumber		= 33
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_PEXT" {
		 layerNumber		= 45
		 dataTypeNumber		= 34
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "NW_DRIFT_drawing" {
		 layerNumber		= 45
		 dataTypeNumber		= 50
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_NW_DRIFT" {
		 layerNumber		= 45
		 dataTypeNumber		= 53
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_NW_DRIFT" {
		 layerNumber		= 45
		 dataTypeNumber		= 54
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "PW_DRIFT_drawing" {
		 layerNumber		= 45
		 dataTypeNumber		= 60
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_PW_DRIFT" {
		 layerNumber		= 45
		 dataTypeNumber		= 63
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_PW_DRIFT" {
		 layerNumber		= 45
		 dataTypeNumber		= 64
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_VTNCELL_GP" {
		 layerNumber		= 46
		 dataTypeNumber		= 3
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_VTNCELL_GP" {
		 layerNumber		= 46
		 dataTypeNumber		= 4
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_VTPCELL_GP" {
		 layerNumber		= 46
		 dataTypeNumber		= 13
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_VTPCELL_GP" {
		 layerNumber		= 46
		 dataTypeNumber		= 14
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_NLDD_HPA" {
		 layerNumber		= 46
		 dataTypeNumber		= 23
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_NLDD_HPA" {
		 layerNumber		= 46
		 dataTypeNumber		= 24
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mask_PLDD_HPA" {
		 layerNumber		= 46
		 dataTypeNumber		= 33
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_PLDD_HPA" {
		 layerNumber		= 46
		 dataTypeNumber		= 34
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawing2_POBIASP" {
		 layerNumber		= 8
		 dataTypeNumber		= 4
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawing2_POBIASM" {
		 layerNumber		= 8
		 dataTypeNumber		= 5
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawing4_POBIASP" {
		 layerNumber		= 8
		 dataTypeNumber		= 6
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawing4_POBIASM" {
		 layerNumber		= 8
		 dataTypeNumber		= 7
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawing6_POBIASP" {
		 layerNumber		= 8
		 dataTypeNumber		= 8
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawing6_POBIASM" {
		 layerNumber		= 8
		 dataTypeNumber		= 9
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "momdmy_MKR" {
		 layerNumber		= 8
		 dataTypeNumber		= 10
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "block_MKR" {
		 layerNumber		= 8
		 dataTypeNumber		= 11
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "label_MKR" {
		 layerNumber		= 8
		 dataTypeNumber		= 12
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "blackbox_MKR" {
		 layerNumber		= 8
		 dataTypeNumber		= 13
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "annotate_M9" {
		 layerNumber		= 8
		 dataTypeNumber		= 14
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "annotate_M1" {
		 layerNumber		= 8
		 dataTypeNumber		= 15
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "annotate_M2" {
		 layerNumber		= 8
		 dataTypeNumber		= 16
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "annotate_M3" {
		 layerNumber		= 8
		 dataTypeNumber		= 17
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "annotate_M4" {
		 layerNumber		= 8
		 dataTypeNumber		= 18
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "annotate_M5" {
		 layerNumber		= 8
		 dataTypeNumber		= 19
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "annotate_M6" {
		 layerNumber		= 8
		 dataTypeNumber		= 20
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "annotate_M7" {
		 layerNumber		= 8
		 dataTypeNumber		= 21
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "annotate_M8" {
		 layerNumber		= 8
		 dataTypeNumber		= 22
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLS_M1" {
		 layerNumber		= 8
		 dataTypeNumber		= 23
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLS_M2" {
		 layerNumber		= 8
		 dataTypeNumber		= 24
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLS_M3" {
		 layerNumber		= 8
		 dataTypeNumber		= 25
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLS_M4" {
		 layerNumber		= 8
		 dataTypeNumber		= 26
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLS_M5" {
		 layerNumber		= 8
		 dataTypeNumber		= 27
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLS_M6" {
		 layerNumber		= 8
		 dataTypeNumber		= 28
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLS_M7" {
		 layerNumber		= 8
		 dataTypeNumber		= 29
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLS_M8" {
		 layerNumber		= 8
		 dataTypeNumber		= 30
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLS_M9" {
		 layerNumber		= 8
		 dataTypeNumber		= 31
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLS_AP" {
		 layerNumber		= 8
		 dataTypeNumber		= 32
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLA_M1" {
		 layerNumber		= 8
		 dataTypeNumber		= 33
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLA_M2" {
		 layerNumber		= 8
		 dataTypeNumber		= 34
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLA_M3" {
		 layerNumber		= 8
		 dataTypeNumber		= 35
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLA_M4" {
		 layerNumber		= 8
		 dataTypeNumber		= 36
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLA_M5" {
		 layerNumber		= 8
		 dataTypeNumber		= 37
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLA_M6" {
		 layerNumber		= 8
		 dataTypeNumber		= 38
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLA_M7" {
		 layerNumber		= 8
		 dataTypeNumber		= 39
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLA_M8" {
		 layerNumber		= 8
		 dataTypeNumber		= 40
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLA_M9" {
		 layerNumber		= 8
		 dataTypeNumber		= 41
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerLA_AP" {
		 layerNumber		= 8
		 dataTypeNumber		= 42
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerL_M1" {
		 layerNumber		= 8
		 dataTypeNumber		= 43
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerL_M2" {
		 layerNumber		= 8
		 dataTypeNumber		= 44
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerL_M3" {
		 layerNumber		= 8
		 dataTypeNumber		= 45
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerL_M4" {
		 layerNumber		= 8
		 dataTypeNumber		= 46
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerL_M5" {
		 layerNumber		= 8
		 dataTypeNumber		= 47
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerL_M6" {
		 layerNumber		= 8
		 dataTypeNumber		= 48
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerL_M7" {
		 layerNumber		= 8
		 dataTypeNumber		= 49
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerL_M8" {
		 layerNumber		= 8
		 dataTypeNumber		= 50
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerL_M9" {
		 layerNumber		= 8
		 dataTypeNumber		= 51
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "markerL_AP" {
		 layerNumber		= 8
		 dataTypeNumber		= 52
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_NDRIFT" {
		 layerNumber		= 8
		 dataTypeNumber		= 53
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_NEXTD_HV" {
		 layerNumber		= 8
		 dataTypeNumber		= 54
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "NDRIFT_drawing" {
		 layerNumber		= 8
		 dataTypeNumber		= 55
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_PDRIFT" {
		 layerNumber		= 8
		 dataTypeNumber		= 56
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "NEXTD_HV_drawing" {
		 layerNumber		= 8
		 dataTypeNumber		= 57
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "PDRIFT_drawing" {
		 layerNumber		= 8
		 dataTypeNumber		= 58
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_NBODY" {
		 layerNumber		= 8
		 dataTypeNumber		= 59
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_PEXTD_HV" {
		 layerNumber		= 8
		 dataTypeNumber		= 60
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "NBODY_drawing" {
		 layerNumber		= 8
		 dataTypeNumber		= 61
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_PBODY" {
		 layerNumber		= 8
		 dataTypeNumber		= 62
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "PEXTD_HV_drawing" {
		 layerNumber		= 8
		 dataTypeNumber		= 63
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "PBODY_drawing" {
		 layerNumber		= 8
		 dataTypeNumber		= 64
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "rf_MKR_bis" {
		 layerNumber		= 8
		 dataTypeNumber		= 65
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "var_pls_MKR" {
		 layerNumber		= 8
		 dataTypeNumber		= 66
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "ebeam_VTH_P_ebeam" {
		 layerNumber		= 8
		 dataTypeNumber		= 67
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "routing45_MKR" {
		 layerNumber		= 8
		 dataTypeNumber		= 68
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "NEMBJT_drawing" {
		 layerNumber		= 8
		 dataTypeNumber		= 69
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_NEMBJT" {
		 layerNumber		= 8
		 dataTypeNumber		= 70
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "PBABJT_drawing" {
		 layerNumber		= 8
		 dataTypeNumber		= 71
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "noprocessing_PBABJT" {
		 layerNumber		= 8
		 dataTypeNumber		= 72
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mtp_MKR" {
		 layerNumber		= 8
		 dataTypeNumber		= 73
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "nogate_MKR" {
		 layerNumber		= 8
		 dataTypeNumber		= 74
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawing1_MKR" {
		 layerNumber		= 8
		 dataTypeNumber		= 75
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawing2_MKR" {
		 layerNumber		= 8
		 dataTypeNumber		= 76
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawing3_MKR" {
		 layerNumber		= 8
		 dataTypeNumber		= 77
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawing4_MKR" {
		 layerNumber		= 8
		 dataTypeNumber		= 78
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawing5_MKR" {
		 layerNumber		= 8
		 dataTypeNumber		= 79
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawing6_MKR" {
		 layerNumber		= 8
		 dataTypeNumber		= 80
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "drawing7_MKR" {
		 layerNumber		= 8
		 dataTypeNumber		= 81
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "pin_CO" {
		 layerNumber		= 8
		 dataTypeNumber		= 82
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "pin_VIA1" {
		 layerNumber		= 8
		 dataTypeNumber		= 83
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "pin_VIA2" {
		 layerNumber		= 8
		 dataTypeNumber		= 84
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "pin_VIA3" {
		 layerNumber		= 8
		 dataTypeNumber		= 85
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "pin_VIA4" {
		 layerNumber		= 8
		 dataTypeNumber		= 86
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "pin_VIA5" {
		 layerNumber		= 8
		 dataTypeNumber		= 87
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "pin_VIA6" {
		 layerNumber		= 8
		 dataTypeNumber		= 88
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "pin_VIA7" {
		 layerNumber		= 8
		 dataTypeNumber		= 89
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "pin_VIA8" {
		 layerNumber		= 8
		 dataTypeNumber		= 90
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "boundary_VIA1" {
		 layerNumber		= 8
		 dataTypeNumber		= 91
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "boundary_VIA2" {
		 layerNumber		= 8
		 dataTypeNumber		= 92
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "boundary_VIA3" {
		 layerNumber		= 8
		 dataTypeNumber		= 93
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "boundary_VIA4" {
		 layerNumber		= 8
		 dataTypeNumber		= 94
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "boundary_VIA5" {
		 layerNumber		= 8
		 dataTypeNumber		= 95
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "boundary_VIA6" {
		 layerNumber		= 8
		 dataTypeNumber		= 96
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "boundary_VIA7" {
		 layerNumber		= 8
		 dataTypeNumber		= 97
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "boundary_VIA8" {
		 layerNumber		= 8
		 dataTypeNumber		= 98
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "HPA_MKR" {
		 layerNumber		= 8
		 dataTypeNumber		= 99
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "blackboxnoM1_MKR" {
		 layerNumber		= 8
		 dataTypeNumber		= 100
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "twopins_MKR" {
		 layerNumber		= 8
		 dataTypeNumber		= 101
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "stplateC_MKR" {
		 layerNumber		= 8
		 dataTypeNumber		= 102
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "signature_POLYACT" {
		 layerNumber		= 8
		 dataTypeNumber		= 103
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "signature_M2TOTOP" {
		 layerNumber		= 8
		 dataTypeNumber		= 104
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mkr_DFM_OK" {
		 layerNumber		= 8
		 dataTypeNumber		= 105
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mkr_ANALOG" {
		 layerNumber		= 8
		 dataTypeNumber		= 106
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "mkr_ACCURATE" {
		 layerNumber		= 8
		 dataTypeNumber		= 107
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "LPSOI_MKR" {
		 layerNumber		= 5
		 dataTypeNumber		= 131
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "VIA5T_drawing" {
		 layerNumber		= 55
		 dataTypeNumber		= 100
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "VIA6T_drawing" {
		 layerNumber		= 56
		 dataTypeNumber		= 100
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "M6T_drawing" {
		 layerNumber		= 36
		 dataTypeNumber		= 100
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_M6T" {
		 layerNumber		= 36
		 dataTypeNumber		= 101
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "M7T_drawing" {
		 layerNumber		= 37
		 dataTypeNumber		= 100
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "white"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
LayerDataType 	 "tile_M7T" {
		 layerNumber		= 37
		 dataTypeNumber		= 101
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "oranger"
		 lineStyle		= "solid"
		 pattern		= "blank"
		 nonMask		= 1
}
Layer	 "dummy_MKR" {
		 layerNumber		= 5
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "dummy_SVTNCELL" {
		 layerNumber		= 45
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "dummy_POBIASP" {
		 layerNumber		= 8
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "dummy_VTNCELL_GP" {
		 layerNumber		= 46
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "dummy_NW2V" {
		 layerNumber		= 42
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "red"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "dummy_sense" {
		 layerNumber		= 7
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "dummy_fringeC" {
		 layerNumber		= 4
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "green"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "dummy_plateC" {
		 layerNumber		= 2
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "dummy_NWpin" {
		 layerNumber		= 180
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "orange"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "dummy_tileNot" {
		 layerNumber		= 150
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "yellow"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "dummy_res" {
		 layerNumber		= 116
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "blue"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "dummy_ippid" {
		 layerNumber		= 63
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
}
Layer	 "dummy_PWDRAM" {
		 layerNumber		= 43
		 visible		= 1
		 selectable		= 1
		 blink			= 0
		 color			= "purple"
		 lineStyle		= "solid"
		 pattern		= "blank"
}


Tile             "unit" {
                 width  = 0.200
                 height = 2.600
}


