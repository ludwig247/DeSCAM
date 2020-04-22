  #################################################################################
  # Library Modifications
  #
  # Apply library modifications here after the libraries are loaded.
  #################################################################################
        ##############################
        # SET DONT_USE LIBRARY CELLS #
        ##############################
        source ../TECH/dontUseCells
        source ../TECH/delayCells
        source ../TECH/lowDriveCells
  #
  set suppress_errors_backup $suppress_errors
  append suppress_errors { UID-109}
  set_dont_use [concat $STM_techDontUseCellList $STM_techDelayCellList $STM_techLowDriveCellsList]
  set suppress_errors $suppress_errors_backup

