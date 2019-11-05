* 
* ******************************************************************************
* *                                                                            *
* *                   Copyright (C) 2004-2011, Nangate Inc.                    *
* *                           All rights reserved.                             *
* *                                                                            *
* * Nangate and the Nangate logo are trademarks of Nangate Inc.                *
* *                                                                            *
* * All trademarks, logos, software marks, and trade names (collectively the   *
* * "Marks") in this program are proprietary to Nangate or other respective    *
* * owners that have granted Nangate the right and license to use such Marks.  *
* * You are not permitted to use the Marks without the prior written consent   *
* * of Nangate or such third party that may own the Marks.                     *
* *                                                                            *
* * This file has been provided pursuant to a License Agreement containing     *
* * restrictions on its use. This file contains valuable trade secrets and     *
* * proprietary information of Nangate Inc., and is protected by U.S. and      *
* * international laws and/or treaties.                                        *
* *                                                                            *
* * The copyright notice(s) in this file does not indicate actual or intended  *
* * publication of this file.                                                  *
* *                                                                            *
* *     NGLibraryCreator, v2010.08-HR32-SP3-2010-08-05 - build 1009061800      *
* *                                                                            *
* ******************************************************************************
* 
* 
* Running on brazil06.nangate.com.br for user Giancarlo Franciscatto (gfr).
* Local time is now Tue, 4 Jan 2011, 14:44:42.
* Main process id is 1680.
*
********************************************************************************
*                                                                              *
* Cellname:   HEADER_X4.                                                       *
*                                                                              *
* Technology: NCSU FreePDK 45nm.                                               *
* Format:     Cdl.                                                             *
*                                                                              *
* Written on brazil06.nangate.com.br for user Giancarlo Franciscatto (gfr)     *
* at 14:44:42 on Tue, 4 Jan 2011.                                              *
*                                                                              *
********************************************************************************
.SUBCKT HEADER_X4 VSS VDD SLEEP VVDD 
*.PININFO VSS:G VDD:P SLEEP:I VVDD:P 
M_M0 N_VVDD_M0_d N_SLEEP_M0_g N_VDD_M0_s VDD PMOS_VTL W=0.540000U L=0.050000U
c_1 VSS 0 4.05828e-17
C_x_PM_HEADER_X4%VDD_c0 VDD VSS 3.4842e-17
C_x_PM_HEADER_X4%VDD_c1 x_PM_HEADER_X4%VDD_6 VSS 1.09852e-17
C_x_PM_HEADER_X4%VDD_c2 N_VDD_M0_s VSS 4.10245e-17
R_x_PM_HEADER_X4%VDD_r3 x_PM_HEADER_X4%VDD_6 VDD 0.167647
R_x_PM_HEADER_X4%VDD_r4 x_PM_HEADER_X4%VDD_2 x_PM_HEADER_X4%VDD_6 0.250237
R_x_PM_HEADER_X4%VDD_r5 x_PM_HEADER_X4%VDD_2 N_VDD_M0_s 0.581875
C_x_PM_HEADER_X4%SLEEP_c0 x_PM_HEADER_X4%SLEEP_8 VSS 1.54128e-17
C_x_PM_HEADER_X4%SLEEP_c1 x_PM_HEADER_X4%SLEEP_5 VSS 3.05992e-17
C_x_PM_HEADER_X4%SLEEP_c2 N_SLEEP_M0_g VSS 9.59549e-17
C_x_PM_HEADER_X4%SLEEP_c3 x_PM_HEADER_X4%SLEEP_1 VSS 1.3451e-17
R_x_PM_HEADER_X4%SLEEP_r4 x_PM_HEADER_X4%SLEEP_9 x_PM_HEADER_X4%SLEEP_11 25.0012
R_x_PM_HEADER_X4%SLEEP_r5 x_PM_HEADER_X4%SLEEP_8 x_PM_HEADER_X4%SLEEP_9 0.125601
R_x_PM_HEADER_X4%SLEEP_r6 x_PM_HEADER_X4%SLEEP_5 x_PM_HEADER_X4%SLEEP_8 0.105619
R_x_PM_HEADER_X4%SLEEP_r7 x_PM_HEADER_X4%SLEEP_5 SLEEP 0.268235
R_x_PM_HEADER_X4%SLEEP_r8 x_PM_HEADER_X4%SLEEP_1 x_PM_HEADER_X4%SLEEP_11 5.34012
R_x_PM_HEADER_X4%SLEEP_r9 x_PM_HEADER_X4%SLEEP_1 N_SLEEP_M0_g 86.58
C_x_PM_HEADER_X4%VVDD_c0 VVDD VSS 9.72984e-17
R_x_PM_HEADER_X4%VVDD_r1 VVDD N_VVDD_M0_d 1.61952
.ENDS 

********************************************************************************
*
* END
*
********************************************************************************
