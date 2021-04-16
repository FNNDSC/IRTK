# removed rview because of error
# /usr/local/bin/src/packages/rview/fltk/bitmaps/landmarks.xbm:27:61: error: narrowing conversion
# of '255' from 'int' to 'char' inside { } [-Wnarrowing]
SUBDIRS(transformation segmentation registration registration2 applications)

IF (BUILD_CARDIAC)
  SUBDIRS(cardiac)
ENDIF (BUILD_CARDIAC)
