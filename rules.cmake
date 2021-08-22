macro(set_default_rules)

    if (${target_type} STREQUAL SHARED_LIB)
        set(BUILD_SHARED_LIBS ON)
    else()
        # Defaultne se generuji staticke knihovny
        set(BUILD_SHARED_LIBS OFF)
    endif()

    # Nastaveni vychoziho standardu C++17 pro kompilatory
    set(CMAKE_CXX_STANDARD 17)

    # Pro VS2015 drzim c++17
    if(MSVC)
        if(MSVC_VERSION EQUAL 1900)
            # VS2015
		    set(CMAKE_CXX_STANDARD 14)
        endif()
    endif()

    # Povoleni pro kompilatory pouzit i nizsi standard, pokud neni podporovan C++14
    set(CMAKE_CXX_STANDARD_REQUIRED OFF)

    # Vypnuti moznosti pouziti specifickych rozsireni kompilatoru
    set(CMAKE_CXX_EXTENSIONS OFF)

endmacro()

macro(compiler_options)
 if ((${CMAKE_CXX_COMPILER_ID} STREQUAL Clang) OR (${CMAKE_CXX_COMPILER_ID} STREQUAL AppleClang))
    target_compile_options(${PROJECT_NAME} PUBLIC
        "$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:-pedantic>"
        )
elseif (${CMAKE_CXX_COMPILER_ID} STREQUAL GNU)
    target_compile_options(${PROJECT_NAME} PUBLIC
        "$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:-Wall>"
        "$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:-Wno-psabi>"
        "$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:-pedantic>"
        )
elseif (${CMAKE_CXX_COMPILER_ID} STREQUAL MSVC)
    set(arch_cxx_spec "")
    if (CMAKE_SIZEOF_VOID_P MATCHES 4)
        set(arch_cxx_spec "/arch:IA32")
    else()
        set(arch_cxx_spec "/DWIN64")
    endif()

    target_compile_options(${PROJECT_NAME} PUBLIC
	"$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:/MP>"
	"$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:/W4>"
	"$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:/sdl>"
	"$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:/GR>"
	"$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:${arch_cxx_spec}>"
	"$<$<CONFIG:Debug>:$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:/MDd>>"
	"$<$<CONFIG:MinSizeRel>:$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:/MD>>"
	"$<$<CONFIG:MinSizeRel>:$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:/GL>>"
	"$<$<CONFIG:MinSizeRel>:$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:/Oi>>"
	"$<$<CONFIG:MinSizeRel>:$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:/Gy>>"
	"$<$<CONFIG:Release>:$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:/MD>>"
	"$<$<CONFIG:Release>:$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:/GL>>"
	"$<$<CONFIG:Release>:$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:/Oi>>"
	"$<$<CONFIG:Release>:$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:/Gy>>"
	"$<$<CONFIG:RelWithDebInfo>:$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:/MD>>"
	"$<$<CONFIG:RelWithDebInfo>:$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:/GL>>"
	"$<$<CONFIG:RelWithDebInfo>:$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:/Oi>>"
	"$<$<CONFIG:RelWithDebInfo>:$<$<OR:$<COMPILE_LANGUAGE:CXX>,$<COMPILE_LANGUAGE:C>>:/Gy>>"
        )

     if (NOT DEFINED subsystem_type)
        set(subsystem_type CONSOLE)

        # Kdyz detekuji QT app, automaticky nastavim pouze okno
        if (CMAKE_AUTOMOC)
            set(subsystem_type WINDOWS)
        endif()
     endif()

     if(CMAKE_AUTOMOC OR CMAKE_AUTORCC)
            set_property(GLOBAL PROPERTY AUTOGEN_SOURCE_GROUP "Generated Files")
     endif()

     if (${target_type} STREQUAL STATIC_LIB)
        set(CMAKE_STATIC_LINKER_FLAGS "/LTCG")
     elseif (${target_type} STREQUAL SHARED_LIB)
        #set(CMAKE_SHARED_LINKER_FLAGS "/LTCG")
     elseif (${target_type} STREQUAL APPLICATION)
        set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS_DEBUG "/SUBSYSTEM:${subsystem_type}")
        set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS_RELEASE "/MAP /LTCG:incremental /OPT:REF /OPT:ICF /SUBSYSTEM:${subsystem_type}")
        set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS_MINSIZEREL "/MAP /LTCG:incremental /OPT:REF /OPT:ICF /SUBSYSTEM:${subsystem_type}")
        set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS_RELWITHDEBINFO "/MAP /LTCG:incremental /OPT:REF /OPT:ICF /SUBSYSTEM:${subsystem_type}")
     endif()

endif()
endmacro()

macro(set_default_settings_app)
    # Nastavim _dbg postfix pro jmeno aplikace kompilovane pod DEBUG
    set_target_properties(${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX "_dbg")

    set(build_dir ${CMAKE_SOURCE_DIR}/build)

    # Definuji jmeno adresare pro vysledek kompilace
    set(output_subdir "undefined")
    if (CMAKE_SIZEOF_VOID_P MATCHES 4)
        set(output_subdir ${build_dir}/win32)
    elseif (CMAKE_SIZEOF_VOID_P MATCHES 8)
        set(output_subdir ${build_dir}/x64)
    endif()

    # Vytvorim adresare (u MSVC bych nemusel, ale pro GNU musim)
    add_custom_command(TARGET ${PROJECT_NAME} PRE_BUILD COMMAND ${CMAKE_COMMAND} -E make_directory ${output_subdir})

    # Nastavim jmeno adresare pro vysledek kompilace
    set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${output_subdir})
    set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG ${output_subdir})
    set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE ${output_subdir})
    set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL ${output_subdir})
    set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO ${output_subdir})

    # Nastaveni hlavniho projektu v MSVC solution
    if (${CMAKE_CXX_COMPILER_ID} STREQUAL MSVC)
        set_property( DIRECTORY PROPERTY VS_STARTUP_PROJECT ${PROJECT_NAME} )
    endif()

    # Nastaveni parametru kompilatoru
    compiler_options()

    set(SRC_PREFIX_PATH ".." CACHE STRING "Path to dependencies")

    # Nastavim cesty pro include
    if (NOT CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
        # testovaci aplikace
        target_include_directories(${PROJECT_NAME}
            PRIVATE "${SRC_PREFIX_PATH}/dev/src"           # cesta k zdrojovym souborum testovane aplikace/knihovny
            PRIVATE "${SRC_PREFIX_PATH}/dev/res"           # cesta k zdrojovym souborum testovane aplikace/knihovny
            PRIVATE "${SRC_PREFIX_PATH}/${main_prj_name}"  # cesta k hlavickovym souborum testovane knihovny
            PRIVATE src                                    # cesta k souborum testovaci aplikace
        )
    else()
        # standardni aplikace
        target_include_directories(${PROJECT_NAME}
            PRIVATE dev/src
            PRIVATE dev/res
        )
    endif()
endmacro()

macro(set_default_settings_lib)
    # Nastaveni hlavniho projektu v MSVC solution
    if (${CMAKE_CXX_COMPILER_ID} STREQUAL MSVC)
        set_property( DIRECTORY PROPERTY VS_STARTUP_PROJECT ${PROJECT_NAME} )
    endif()

    # Nastaveni parametru kompilatoru
    compiler_options()

    target_include_directories(${PROJECT_NAME}
        PUBLIC .
        PUBLIC ${PROJECT_NAME}    # vyhledove bude zruseno
    )
endmacro()

macro(set_default_settings)
    if (${target_type} STREQUAL STATIC_LIB)
        set_default_settings_lib()
    else()
        set_default_settings_app()
    endif()
endmacro()

# Funkce vytvori seznam cest adresaru zdrojovych souboru odpovidajicích regularnimu vyrazu
function(
    get_sub_dir_list # Nazev funkce
    in_src_list      # Vstupni list zdrojovych souboru
    reg_expr         # Regularni vyraz pro filtrování vstupnich zdrojovych souboru
    out_path_list    # Vystupni list cest adresaru, kde se nachazi vyfiltrovane soubory
    )
    # Deklarace a inicializace promennych
    set(dir_path_list "")
    set(filter_src_list ${in_src_list})

    # Filtrovani zdrojovych souboru
    list(FILTER filter_src_list INCLUDE REGEX ${reg_expr})

    # Vytvoreni listu cest adresaru, kde se nachazeji filtrovane zdrojove soubory
    foreach(src_file ${filter_src_list})
        get_filename_component(dir_path ${src_file} PATH)
        list(APPEND dir_path_list ${dir_path})
    endforeach()

    # Odstraneni duplicitnich cest adresaru
    list(REMOVE_DUPLICATES dir_path_list)

    # Nastaveni listu cest adresaru na vystupni list
    set(${out_path_list} ${dir_path_list} PARENT_SCOPE)
endfunction()

# Funkce vygeneruje z predavanych souboru '.fbs' soubory '*_generated.h'
function(
    set_flatbuffers_process # Nazev funkce
    out_dir                 # Zadani vystupni adresare pro vygenerovane soubory
    file_fbs_list           # Vstupni list souboru '.fbs'
    generated_h_list        # Vystupni list vygenerovanych souboru '*_generated.h'
    )
    # Testovani neprazdnosti vstupniho listu se soubory '.fbs'
    if(file_fbs_list)
        string(TOLOWER ${CMAKE_HOST_SYSTEM_PROCESSOR} host_system_processor_lc)
        file(GLOB flat_cmd "${CMAKE_SOURCE_DIR}/dep/flatbuffers/dev/bin/${host_system_processor_lc}/flatc*")
        message(STATUS "CMakeTools - (${PROJECT_NAME}) - Check for flatc for CMAKE_HOST_SYSTEM_PROCESSOR: ${CMAKE_HOST_SYSTEM_PROCESSOR}")
        if(EXISTS ${flat_cmd})
            message(STATUS "CMakeTools - (${PROJECT_NAME}) - Check for flatc: ${flat_cmd} -- found")
        else()
            message(FATAL_ERROR "CMakeTools - (${PROJECT_NAME}) - Check for flatc: NOT FOUND!")
        endif()
        # Nastaveni parametru prikazu pro flatbuffers
        set(flat_args --gen-object-api --scoped-enums --object-suffix _t --cpp)
        # Projdou se vsechny soubory obsazene ve vstupni listu se soubory '*.fbs'
        foreach(file_fbs IN LISTS file_fbs_list)
            string(REGEX REPLACE "\\.fbs$" "_generated.h" file_fbs_h ${file_fbs})
            get_sub_dir_list("${file_fbs}" ".+\\.fbs$" file_fbs_path)
            string(REPLACE "${file_fbs_path}" "${out_dir}" file_fbs_h ${file_fbs_h})

            # Vylouceni zdrojoveho souboru ze zpracování AUTOMOC, AUTOUIC a AUTORCC (pro Qt).
            set_property(SOURCE ${file_fbs_h} PROPERTY SKIP_AUTOGEN ON)

            # Prvotni generovani prislusneho souboru '*_generated.h' z '*.fbs' souboru.
            string(REPLACE "${CMAKE_BINARY_DIR}" "" info_msg ${file_fbs_h})
            message(STATUS "CMakeTools - (${PROJECT_NAME}) - Generating ${info_msg}")
            execute_process(
                COMMAND
                ${flat_cmd}
                ${flat_args}
                -o ${out_dir}
                ${file_fbs}
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            )

            # Nastaveni souboru '*_generated.h' u projektu, ze se jedna o generovany soubor
            # Po zmene '*.fbs' souboru, dojde k pregenerovani prislusneho souboru '*_generated.h'
            add_custom_command(
                OUTPUT ${file_fbs_h}
                COMMAND
                ${flat_cmd}
                ${flat_args}
                -o ${out_dir}
                ${file_fbs}
                DEPENDS ${file_fbs}
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            )

            # Pridani vygenerovaneho '*_generated.h' do prubezneho listu
            list(APPEND file_fbs_h_list ${file_fbs_h})
        endforeach()
    endif()
    # Prednani prubezne vygenerovanych soubory '*_generated.h' do vystupniho listu
    set(${generated_h_list} ${file_fbs_h_list} PARENT_SCOPE)
endfunction()

macro(add_flatbuffer_files)
    file(
        GLOB_RECURSE com_fbs_header_list
            "${PROJECT_NAME}/*.fbs" # lib
    )

    file(
        GLOB_RECURSE fbs_source_list
            "dev/src/*.fbs"         # app, lib
    )

    if (${target_type} STREQUAL APPLICATION)
        target_sources(${PROJECT_NAME} PRIVATE
            ${fbs_source_list}
        )
    else()
        target_sources(${PROJECT_NAME} PRIVATE
            ${fbs_source_list}
            ${com_fbs_header_list}
        )
    endif()

    # Vystupni adresar pro vygenerovane soubory
    set(out_gen_dir "${CMAKE_BINARY_DIR}/fbs_generated/${PROJECT_NAME}")

    set(all_fbs_list ${com_fbs_header_list} ${fbs_source_list})

    # Nastaveni processu generovani souboru '*_generated.h' ze souboru '*.fbs'
    set_flatbuffers_process(${out_gen_dir} "${all_fbs_list}" all_fbs_h_list )

    # Vlozeni vygenerovanych souboru '_generated.h' do projektu
    target_sources(${PROJECT_NAME} PRIVATE ${all_fbs_h_list})
    source_group("Generated Files" FILES ${all_fbs_h_list})

    # Pridani cesty adresare k adresari, kde se nachazeji vygenerovane soubory '*_genarated.h'
    add_depend_flatbuffer_files()
endmacro()

macro(add_module_files)
    file(
        GLOB_RECURSE com_header_list
            "${PROJECT_NAME}/*.h*"  # lib
    )

    file(
        GLOB_RECURSE source_list
            "src/*.h*"              # test
            "dev/src/*.h*"          # app, lib
            "src/*.c*"              # test
            "dev/src/*.c*"          # app, lib
            "dev/src/*.ui"          # QT: app, lib
            "dev/src/*.qrc"         # QT: app, lib
            "${PROJECT_NAME}/*.ui"  # QT: app, lib
    )

    file(
        GLOB_RECURSE resources_list
            "dev/res/*.rc"          # app, lib
            "dev/res/*.h"           # app, lib
            "dev/res/*.xpm"         # app, lib
            "dev/res/*.png"         # app, lib
            "dev/res/*.svg"         # app, lib
            "dev/res/*.ico"         # app, lib
            "dev/res/*.ts"          # app, lib
            "dev/res/*.wav"         # app, lib
            "dev/res/*.css"         # app, lib
            "dev/res/*.qss"         # app, lib
            "dev/res/*.html"        # app, lib
            "dev/res/*.tpl"         # app, lib
            "dev/res/*.sql"         # app, lib
            "dev/res/*.aps"         # app, lib
            "dev/res/*.rb"          # app, lib
            "dev/res/*.bmp"         # app, lib
            "dev/res/*.qrc"         # QT: app, lib
    )

    if (CMAKE_AUTOUIC)
        get_sub_dir_list("${source_list}" ".+\\.ui$" path_list)  # Vyhledani cest adresaru umistenych '.ui' souboru
        set(CMAKE_AUTOUIC_SEARCH_PATHS ${path_list})  # Nastaveni cest pro AUTOUIC, kde se vyskytuji '.ui' soubory
    endif()

    foreach(resource IN LISTS resources_list)
        source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}/dev" FILES "${resource}")
    endforeach()

    if (${target_type} STREQUAL APPLICATION)
        add_executable(${PROJECT_NAME}
            ${source_list}
            ${resources_list}
        )
    else()
        add_library(${PROJECT_NAME}
            ${source_list}
            ${com_header_list}
            ${resources_list}
        )
    endif()

    # Pokud je definovana promenna 'set(CMAKETOOLS_FLATBUFFERS ON)', aktivuje se pouziti flatbuffers
    if(CMAKETOOLS_FLATBUFFERS)
        add_flatbuffer_files()
    endif()
endmacro()

macro(add_depend_flatbuffer_files)
    # Pridani cesty adresare k adresari, kde se nachazeji vygenerovane soubory '*_genarated.h'
    target_include_directories(${PROJECT_NAME}
        PUBLIC "${CMAKE_BINARY_DIR}/fbs_generated/"
    )
endmacro()

macro(add_test_module_files)
    file(
       GLOB_RECURSE common_test_src
            "src/*.h*"        # test
            "src/*.c*"        # test
    )

    add_executable(${PROJECT_NAME}
        ${common_test_src}
    )

    # Pokud je definovana promenna 'set(CMAKETOOLS_FLATBUFFERS ON)', aktivuje se pouziti flatbuffers
    if(CMAKETOOLS_FLATBUFFERS)
        add_depend_flatbuffer_files()
    endif()
endmacro()

# Vytvori strukturu slozek zdrojovych souboru projektu podle adresarove struktury
macro(set_source_group_tree)
    if (NOT ${PROJECT_NAME} MATCHES "_test$")
        source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}/dev" FILES ${source_list} ${fbs_source_list})
        source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${com_header_list} ${com_fbs_header_list})
    else()
        source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" FILES ${common_test_src})
    endif()
endmacro()

macro(set_link_libraries com_list)
    foreach(com ${com_list})
        target_link_libraries(${PROJECT_NAME} ${com})
    endforeach()

    # Kdyz detekuji QT app, automaticky linkuji Qt5::WinMain
    if (CMAKE_AUTOMOC)
        if (WIN32)
            #target_link_libraries(${PROJECT_NAME} Qt5::WinMain)
        endif()
        if (MSVC)
            # Nastaveni 'Keyword' pro lepší integraci QT
            set_property(TARGET ${PROJECT_NAME} PROPERTY VS_GLOBAL_KEYWORD "Qt4VSv1.0")
        endif()
    endif()
endmacro()

macro(add_test_project)
    # Povolim podporu ctest
    enable_testing ()

    # Definuji jmeno hlavniho projektu
    set(main_prj_name ${PROJECT_NAME})

    # Generuji test project
    if (CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
        add_subdirectory(test ${PROJECT_NAME}_test)
    endif()
endmacro()

