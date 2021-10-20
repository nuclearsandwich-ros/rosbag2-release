# Get package location hint from environment variable (if any)
if(NOT zstd_ROOT_DIR AND DEFINED ENV{zstd_ROOT_DIR})
    set(zstd_ROOT_DIR "$ENV{zstd_ROOT_DIR}" CACHE PATH
            "zstd base directory location (optional, used for nonstandard installation paths)")
endif()

# Search path for nonstandard package locations
if(zstd_ROOT_DIR)
    set(zstd_INCLUDE_PATH PATHS "${zstd_ROOT_DIR}/include" NO_DEFAULT_PATH)
    set(zstd_LIBRARY_PATH PATHS "${zstd_ROOT_DIR}/lib"     NO_DEFAULT_PATH)
else()
    set(zstd_INCLUDE_PATH "")
    set(zstd_LIBRARY_PATH "")
endif()

# Find headers and libraries
find_path(zstd_INCLUDE_DIR NAMES zstd.h PATH_SUFFIXES "zstd" ${zstd_INCLUDE_PATH})
find_library(zstd_LIBRARY  NAMES zstd   PATH_SUFFIXES "zstd" ${zstd_LIBRARY_PATH})

mark_as_advanced(zstd_INCLUDE_DIR zstd_LIBRARY)

# Output variables generation
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(zstd DEFAULT_MSG zstd_LIBRARY zstd_INCLUDE_DIR)

set(zstd_FOUND ${ZSTD_FOUND}) # Enforce case-correctness: Set appropriately cased variable...
unset(ZSTD_FOUND) # ...and unset uppercase variable generated by find_package_handle_standard_args

if(zstd_FOUND)
    set(zstd_INCLUDE_DIRS ${zstd_INCLUDE_DIR})
    set(zstd_LIBRARIES ${zstd_LIBRARY})

    if(NOT TARGET zstd::zstd)
        add_library(zstd::zstd UNKNOWN IMPORTED)
        set_property(TARGET zstd::zstd PROPERTY IMPORTED_LOCATION ${zstd_LIBRARY})
        set_property(TARGET zstd::zstd PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${zstd_INCLUDE_DIR})
    endif()
    list(APPEND zstd_TARGETS zstd::zstd)
elseif(zstd_FIND_REQUIRED)
    message(FATAL_ERROR "Unable to find zstd")
endif()
