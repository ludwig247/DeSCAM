####################################################################################################################################
#The following scaling variables (Library scalings, Worst, Best and Nominal scalings) are used only by advanced Flow (adv_AvantiKit)
####################################################################################################################################
# Library scaling
set STM_techPreHFNSMaxTransSizingFactor 0.85
set STM_techPreHFNSMaxCapSizingFactor 0.85
set STM_techPreHFNSMaxFanoutSizingFactor 1
set STM_techPostHFNSMaxTransSizingFactor 0.95
set STM_techPostHFNSMaxCapSizingFactor 0.95
set STM_techPostHFNSMaxFanoutSizingFactor 1

# Worst case scaling (signal)
set STM_techPrerouteScalingFactor(capacitance:signal:WORST) 1.24
set STM_techPrerouteScalingFactor(resistance:signal:WORST) 0.85
set STM_techPostrouteScalingFactor(capacitance:signal:WORST) 1.23
set STM_techPostrouteScalingFactor(resistance:signal:WORST) 1.13

# Worst case scaling (clock)
set STM_techPrerouteScalingFactor(capacitance:clock:WORST) 0.90
set STM_techPostrouteScalingFactor(capacitance:clock:WORST) 0.99

# Best case scaling (signal)
set STM_techPrerouteScalingFactor(capacitance:signal:BEST) 1.22
set STM_techPrerouteScalingFactor(resistance:signal:BEST) 0.65
set STM_techPostrouteScalingFactor(capacitance:signal:BEST) 1.22
set STM_techPostrouteScalingFactor(resistance:signal:BEST) 0.99

# Best case scaling (clock)
set STM_techPrerouteScalingFactor(capacitance:clock:BEST) 1.70
set STM_techPostrouteScalingFactor(capacitance:clock:BEST) 1.74

# Nominal case scaling (signal)
set STM_techPrerouteScalingFactor(capacitance:signal:NOMINAL) 1.04
set STM_techPrerouteScalingFactor(resistance:signal:NOMINAL) 1.00
set STM_techPostrouteScalingFactor(capacitance:signal:NOMINAL) 1.04
set STM_techPostrouteScalingFactor(resistance:signal:NOMINAL) 1.00

# Nominal case scaling (clock)
set STM_techPrerouteScalingFactor(capacitance:clock:NOMINAL) 1.04
set STM_techPostrouteScalingFactor(capacitance:clock:NOMINAL) 1.04

#############################################################################################################################
#The following scaling variables (RCMIN, RCMIN_ASTRO, RCMAX, RCTYP scalings) are used only by MainStream Flow (MDDP specific)
#############################################################################################################################
# RCMAX scaling (signal)
set STM_techPrerouteScalingFactor(capacitance:signal:RCMAX) 1.24
set STM_techPrerouteScalingFactor(resistance:signal:RCMAX) 0.85
set STM_techPostrouteScalingFactor(capacitance:signal:RCMAX) 1.23
set STM_techPostrouteScalingFactor(resistance:signal:RCMAX) 1.13

# RCMAX scaling (clock)
set STM_techPrerouteScalingFactor(capacitance:clock:RCMAX) 0.90
set STM_techPostrouteScalingFactor(capacitance:clock:RCMAX) 0.99

# RCMIN scaling (signal)
set STM_techPrerouteScalingFactor(capacitance:signal:RCMIN) 0.56
set STM_techPrerouteScalingFactor(resistance:signal:RCMIN) 0.65
set STM_techPostrouteScalingFactor(capacitance:signal:RCMIN) 0.60
set STM_techPostrouteScalingFactor(resistance:signal:RCMIN) 0.99

# RCMIN scaling (clock)
set STM_techPrerouteScalingFactor(capacitance:clock:RCMIN) 0.80
set STM_techPostrouteScalingFactor(capacitance:clock:RCMIN) 0.91

# RCMIN_ASTRO scaling (signal)
set STM_techPrerouteScalingFactor(capacitance:signal:RCMIN_ASTRO) 1.22
set STM_techPrerouteScalingFactor(resistance:signal:RCMIN_ASTRO) 0.65
set STM_techPostrouteScalingFactor(capacitance:signal:RCMIN_ASTRO) 1.22
set STM_techPostrouteScalingFactor(resistance:signal:RCMIN_ASTRO) 0.99

# RCMIN_ASTRO scaling (clock)
set STM_techPrerouteScalingFactor(capacitance:clock:RCMIN_ASTRO) 1.70
set STM_techPostrouteScalingFactor(capacitance:clock:RCMIN_ASTRO) 1.74

# RCTYP scaling (signal)
set STM_techPrerouteScalingFactor(capacitance:signal:RCTYP) 1.04
set STM_techPrerouteScalingFactor(resistance:signal:RCTYP) 1.00
set STM_techPostrouteScalingFactor(capacitance:signal:RCTYP) 1.04
set STM_techPostrouteScalingFactor(resistance:signal:RCTYP) 1.00

# RCTYP scaling (clock)
set STM_techPrerouteScalingFactor(capacitance:clock:RCTYP) 1.04
set STM_techPostrouteScalingFactor(capacitance:clock:RCTYP) 1.04


#############################################################################




# Max length
set STM_techMaxLength "500"

# Power/Ground net name
set STM_techPowerName "vdd"
set STM_techGroundName "gnd"

# Power/Ground pin name
set STM_techPowerPinName "vdd"
set STM_techGroundPinName "gnd"

# Split Power/Ground pin name
set STM_techSplitPowerPinName "vdds"
set STM_techSplitGroundPinName "gnds"

# Macro info
set STM_techMacroHorKeepout "19.20"
set STM_techMacroVerKeepout "9.60" 
set STM_techMacroMinArea 200

# Low drive cells scaling
set STM_techLowDriveMaxCapScaling 0.5
set STM_techLowDriveMaxTransScaling 0.5

if { ![info exists env(ICCKITROOT)] } {
	source $env(ADV_AVANTITECHNOKITROOT)/COMMON/dont_use_cells.tcl
	source $env(ADV_AVANTITECHNOKITROOT)/COMMON/delay_cells.tcl
	source $env(ADV_AVANTITECHNOKITROOT)/COMMON/low_drive_cells.tcl
}

# Ignored routing layers in RC computation
set STM_techIgnoredLayers "AP"

# Double spacing rules
array set STM_techDoubleSpacingRule {M7 0.80 M3 0.20 M4 0.20 M5 0.20 M1 0.18 M6 0.80 M2 0.20}

if { ![info exists env(ICCKITROOT)] } {
# set_parameter -name zrDebug91936 -value 1 -module droute
}


# Xtalk
set STM_XtalkThreshold 0.4
set STM_XtalkThreshold_belowHigh 0.30
set STM_XtalkThreshold_aboveLow  0.30

######################################################################################
#The following variables are used only by MainStream Flow (MDDP specific)
######################################################################################
# Non-used layers
set STM_minRoutingLayer      "M1"
set STM_maxRoutingLayer      "M7"
# Library scaling
set STM_prerouteMaxTransSizingFactor  0.90
set STM_prerouteMaxCapSizingFactor    0.90
set STM_postrouteMaxTransSizingFactor 0.95
set STM_postrouteMaxCapSizingFactor   0.95
# SI threshold
set STM_staticNoiseThreshold     0.30
set STM_xtalkPreventionThreshold 0.40

# Power grid
# set STM_powerStripes(<power type>:<direction>:<attribute>) <value>
#   <power type>: ground | power | ground2power | ground_retention | power_retention | ground2ground_retention | power2power_retention |-
#   <direction> : horizontal | vertical | -
#   <attribute> : name | width | step | layer | spacing | min_layer | max_layer | row_height
set STM_powerStripes(ground:-:name) "gnd"
set STM_powerStripes(power:-:name)  "vdd"
set STM_powerStripes(ground_retention:-:name) "gndo"
set STM_powerStripes(power_retention:-:name)  "vddo"
set STM_powerStripes(ground_split:-:name) "gnds"
set STM_powerStripes(power_split:-:name)  "vdds"

#
set STM_powerStripes(ground:vertical:width)  4.5
set STM_powerStripes(ground:vertical:step)  20.8
set STM_powerStripes(ground:vertical:layer) "M6"
#
set STM_powerStripes(ground:horizontal:width)  4.5
set STM_powerStripes(ground:horizontal:step)  20.8
set STM_powerStripes(ground:horizontal:layer) "M7"
#
set STM_powerStripes(power:vertical:width)  4.5
set STM_powerStripes(power:vertical:step)  20.8
set STM_powerStripes(power:vertical:layer) "M6"
#
set STM_powerStripes(power:horizontal:width)  4.5
set STM_powerStripes(power:horizontal:step)  20.8
set STM_powerStripes(power:horizontal:layer) "M7"
#
set STM_powerStripes(ground_retention:vertical:width)  1.5
set STM_powerStripes(ground_retention:vertical:step)  20.8
set STM_powerStripes(ground_retention:vertical:layer) "M6"
#
set STM_powerStripes(ground_retention:horizontal:width)  1.5
set STM_powerStripes(ground_retention:horizontal:step)  20.8
set STM_powerStripes(ground_retention:horizontal:layer) "M7"
#
set STM_powerStripes(power_retention:vertical:width)  1.5
set STM_powerStripes(power_retention:vertical:step)  20.8
set STM_powerStripes(power_retention:vertical:layer) "M6"
#
set STM_powerStripes(power_retention:horizontal:width)  1.5
set STM_powerStripes(power_retention:horizontal:step)  20.8
set STM_powerStripes(power_retention:horizontal:layer) "M7"
#
set STM_powerStripes(ground_split:vertical:width)  0.4
set STM_powerStripes(ground_split:vertical:step)  20.8
set STM_powerStripes(ground_split:vertical:layer) "M6"
#
set STM_powerStripes(ground_split:horizontal:width)  0.4
set STM_powerStripes(ground_split:horizontal:step)  20.8
set STM_powerStripes(ground_split:horizontal:layer) "M7"
#
set STM_powerStripes(power_split:vertical:width)  0.4
set STM_powerStripes(power_split:vertical:step)  20.8
set STM_powerStripes(power_split:vertical:layer) "M6"
#
set STM_powerStripes(power_split:horizontal:width)  0.4
set STM_powerStripes(power_split:horizontal:step)  20.8
set STM_powerStripes(power_split:horizontal:layer) "M7"
#
set STM_powerStripes(ground2power:vertical:spacing)   10.4
set STM_powerStripes(ground2power:horizontal:spacing) 10.4
#
set STM_powerStripes(ground2ground_retention:vertical:spacing) 3.5
set STM_powerStripes(ground2ground_retention:horizontal:spacing) 3.5
#
set STM_powerStripes(power2power_retention:vertical:spacing) 3.5
set STM_powerStripes(power2power_retention:horizontal:spacing) 3.5
#
set STM_powerStripes(ground2ground_split:vertical:spacing)   2.95
set STM_powerStripes(ground2ground_split:horizontal:spacing) 2.95
#
set STM_powerStripes(ground2power_split:vertical:spacing)   3.75
set STM_powerStripes(ground2power_split:horizontal:spacing) 3.75
#
set STM_powerStripes(-:vertical:min_layer)   "M1"
set STM_powerStripes(-:horizontal:min_layer) "M6"
set STM_powerStripes(-:vertical:max_layer)   "M7"
set STM_powerStripes(-:horizontal:max_layer) "M7"
#
set STM_powerStripes(-:-:row_height) 2.60


# Physical guidelines (used for power grid & rows)
# set STM_offset(<type>:<direction>) <value>
#   <type> : power_stripes | row
#   <direction> : horizontal (<-> Y) | vertical (<-> X)
set STM_offset(power_stripes:horizontal) 2 ; # Values: 1 | 2              (i)
set STM_offset(power_stripes:vertical)   2 ; # Values: 1 | 2              (k)
set STM_offset(row:horizontal)           5 ; # Values: 1 | 2 | 3 | 4 | 5  (j)
set STM_offset(row:vertical)             0 ; # Values: 0


# Core Switches
set STM_SWCTRLMasterName       "SW65_LH_VDDCTRL"
set STM_SWSwitchMasterName     "SW65_LH_VDDSWITCH"
set STM_SWCornerMasterName     "SW65_LH_CORNER"
set STM_SWAntiCornerMasterName "SW65_LH_ANTICORNER"
set STM_SWFillerNameList       "SW65_50_DECAPVDDO64 SW65_50_DECAPVDDO32 SW65_50_DECAPVDDO16 SW65_LH_FILLERCELL8 SW65_LH_FILLERCELL4 SW65_LH_FILLERCELL2"
set STM_SWSwitchNbNearController "50"


# Layers which enables to identify HVT, LVT and GP process
set STM_layers(HVT) { VTH_P VTH_N }
set STM_layers(LVT) { VTL_P VTL_N }
set STM_layers(GP)  { DCO }

# Via master for split tie preroute
set STM_splitTiePreroute(via1_master) "AVNT_via1_HV"
set STM_splitTiePreroute(via2_master) "AVNT_via2"

######################################################################################
#The following variables are used only by advanced Flow (adv_AvantiKit)
######################################################################################


# Placement
set STM_fillerCaps {HS65_LH_FILLERPFOP64 HS65_LH_FILLERPFOP32 HS65_LH_FILLERPFOP16 HS65_LH_FILLERPFOP12 HS65_LH_FILLERPFOP9 HS65_LH_FILLERPFOP8 HS65_LH_FILLERPFP4 HS65_LH_FILLERPFP3 HS65_LH_FILLERPFP2 HS65_LH_FILLERPFP1}

set STM_fillerHVT {HS65_LH_FILLERPFOP64 HS65_LH_FILLERPFOP32 HS65_LH_FILLERPFOP16 HS65_LH_FILLERPFOP12 HS65_LH_FILLERPFOP9 HS65_LH_FILLERPFOP8 HS65_LH_FILLERPFP4 HS65_LH_FILLERPFP3 HS65_LH_FILLERPFP2 HS65_LH_FILLERPFP1}
set STM_fillerLVT {HS65_LL_FILLERPFOP64 HS65_LL_FILLERPFOP32 HS65_LL_FILLERPFOP16 HS65_LL_FILLERPFOP12 HS65_LL_FILLERPFOP9 HS65_LL_FILLERPFOP8 HS65_LL_FILLERPFP4 HS65_LL_FILLERPFP3 HS65_LL_FILLERPFP2 HS65_LL_FILLERPFP1}
set STM_fillerSVT {HS65_LS_FILLERPFOP64 HS65_LS_FILLERPFOP32 HS65_LS_FILLERPFOP16 HS65_LS_FILLERPFOP12 HS65_LS_FILLERPFOP9 HS65_LS_FILLERPFOP8 HS65_LS_FILLERPFP4 HS65_LS_FILLERPFP3 HS65_LS_FILLERPFP2 HS65_LS_FILLERPFP1}

set STM_fillerTies {HS65_LS_FILLERNPWPFP3}

set STM_AntennaCell {HS65_LS_ANTPROT3}





######################################################################################
#The following variables are used only by MainStream Flow (MDDP specific)
######################################################################################


#----------------------------------------------------
# Clock Tree Synthesis
#----------------------------------------------------

# Clock Tree Synthesis parameters (Used for CTS based on SDC or ATTX)
# The following parameters are set to default values and should be tuned depending on design and implementation specificities

set STM_ctsMaxFanout      40                                  ; # Default max fanout for CTS

# Clock Tree Synthesis parameters (Only used for CTS based on SDC)
set STM_ctsMaxTransition  0.250                            ; # Default max transition (if clock transition not specified in SDC)
set STM_ctsSkewPercentage 0.10                          ; # Skew = <STM_ctsSkewPercentage>% of max insertion delay (<=> max clock latency)
set STM_ctsSkew           0.100                                ; # Default skew (if max clock latency not specified in SDC)
set STM_ctsRoutingRule    "timing_driven_spacing_double_vias"             ; # Default routing rule - # Values: timing_driven_spacing (soft double spacing) | ctsdoubleSpacing (hard double spacing) | ctsdoubleSpacingdoubleVia (hard double spacing + double vias) | timing_driven_spacing_double_vias (soft double spacing + double vias except for via1)
set STM_ctsBuffers        "HS65_LH_CNBFX38 HS65_LH_CNBFX55 HS65_LH_CNBFX62" ; # Default list of buffers
set STM_ctsInverters      ""                                  ; # Default list of inverters
set STM_ctsRoutingLayers "M4 M5 M6 M7"
set STM_ctsAllowedCells "HS65_.*_CNHLS.* HS65_.*_CAP.* HS65_.*_CNAND2.* HS65_.*_CNBF.* HS65_.*_CNIV.* HS65_.*_CNMUX.* HS65_.*_CNNAND2.* HS65_.*_CNNOR2.* HS65_.*_CNOR.* HS65_.*_CNSDFPRQT.* HS65_.*_CNXOR2.*" ; # List given by library team

#----------------------------------------------------
# Specific cells
#----------------------------------------------------

# Fillercells
# STM_fillercellInsertionMethodology = <method>:<type>:<vt>:<min width>
#   method   : std | vt | vt_dco
#   type     : metal | no_metal | fillercap
#   vt       : HVT | SVT | LVT
#   min width: <float> | -
set STM_fillercellInsertionMethodology "vt_dco:no_metal:SVT:0.401"
set STM_fillercell(fillercap)  "HS65_50_DECAP64 HS65_50_DECAP32 HS65_50_DECAP16 HS65_50_DECAP12 HS65_50_DECAP9"
set STM_fillercell(metal)  ""
set STM_fillercell(LP_LVT) "HS65_LL_FILLERPFOP64 HS65_LL_FILLERPFOP32 HS65_LL_FILLERPFOP16 HS65_LL_FILLERPFOP12 HS65_LL_FILLERPFOP9 HS65_LL_FILLERPFOP8 HS65_LL_FILLERPFP4 HS65_LL_FILLERPFP3 HS65_LL_FILLERPFP2 HS65_LL_FILLERPFP1"
set STM_fillercell(LP_SVT) "HS65_LS_FILLERPFOP64 HS65_LS_FILLERPFOP32 HS65_LS_FILLERPFOP16 HS65_LS_FILLERPFOP12 HS65_LS_FILLERPFOP9 HS65_LS_FILLERPFOP8 HS65_LS_FILLERPFP4 HS65_LS_FILLERPFP3 HS65_LS_FILLERPFP2 HS65_LS_FILLERPFP1"
set STM_fillercell(LP_HVT) "HS65_LH_FILLERPFOP64 HS65_LH_FILLERPFOP32 HS65_LH_FILLERPFOP16 HS65_LH_FILLERPFOP12 HS65_LH_FILLERPFOP9 HS65_LH_FILLERPFOP8 HS65_LH_FILLERPFP4 HS65_LH_FILLERPFP3 HS65_LH_FILLERPFP2 HS65_LH_FILLERPFP1"
set STM_fillercell(GP_LVT) ""
set STM_fillercell(GP_SVT) "HS65_GS_FILLERPFOP64 HS65_GS_FILLERPFOP32 HS65_GS_FILLERPFOP16 HS65_GS_FILLERPFOP12 HS65_GS_FILLERPFOP9 HS65_GS_FILLERPFOP8 HS65_GS_FILLERPFP4 HS65_GS_FILLERPFP3 HS65_GS_FILLERPFP2 HS65_GS_FILLERPFP1"
set STM_fillercell(GP_HVT) "HS65_GH_FILLERPFOP64 HS65_GH_FILLERPFOP32 HS65_GH_FILLERPFOP16 HS65_GH_FILLERPFOP12 HS65_GH_FILLERPFOP9 HS65_GH_FILLERPFOP8 HS65_GH_FILLERPFP4 HS65_GH_FILLERPFP3 HS65_GH_FILLERPFP2 HS65_GH_FILLERPFP1"

# Fillerties
set STM_fillerties "HS65_LS_FILLERNPWPFP3"
set STM_splitFillerties "HS65_LH_FILLERSNPWPFP3"
set STM_fillertiesStep 83.2

# Diode
set STM_antennaCell "HS65_LS_ANTPROT3"

# Isolation Cell
set STM_defaultIsolationCell "HS65_LH_ISOOR2X9"

#----------------------------------------------------
# Floorplan
#----------------------------------------------------

# Follow pins (preroute standard cells)
# set STM_followPins(<direction>:<attribute>) <value>
#   <direction> : horizontal (<-> Y) | vertical (<-> X)
#   <attribute> : offset | step | size
set STM_followPins(vertical:offset)    1.81
set STM_followPins(horizontal:offset)  0.00
set STM_followPins(vertical:step)     20
set STM_followPins(horizontal:step)   10
set STM_followPins(vertical:size)      1.0
set STM_followPins(horizontal:size)    1.0

# Specific to top designs
set STM_io2core(top)    8
set STM_io2core(bottom) 8
set STM_io2core(left)   8
set STM_io2core(right)  8

# Specific to block designs
set STM_boundaryIsolationCell(input)  "HS65_LH_CNBFX55"
set STM_boundaryIsolationCell(output) "HS65_LH_CNBFX55"

# Others
set STM_offsetBlockage 5


set STM_pnetOptions(partial) ""


#----------------------------------------------------
# Others
#----------------------------------------------------
set STM_cellHeight 13
set STM_pitch       0.2
set STM_grouteDefaultVia(via1) 52 ; # contact code

