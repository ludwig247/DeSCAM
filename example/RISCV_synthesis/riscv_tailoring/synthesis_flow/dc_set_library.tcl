set OSU_FREEPDK [format "%s%s"  [getenv "SCAM_HOME"] "/example/StandardCellLibraries/FreePDK45/osu_soc/lib/files"]
set search_path [concat  $search_path $OSU_FREEPDK]
set alib_library_analysis_path $OSU_FREEPDK

set link_library [set target_library [concat  [list gscl45nm.db] [list dw_foundation.sldb]]]
set target_library "gscl45nm.db"
define_design_lib work -path ./dc_work


