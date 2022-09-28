# Template CMakeLists.txt configuration for STM32 MCUS
cmake_minimum_required(VERSION 3.12)
# ##############################################################################
# Edit your MCU information up to the next border
project(sample-g0)
set(PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/PROJECT)

set(MCU_FAMILY STM32G0xx)
set(MCU_MODEL STM32G0B1xx)
set(CPU_PARAMETERS
    -mcpu=cortex-m0plus
    -mthumb
    -mfloat-abi=soft)

set(MCU_LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/STM32G0B1RETX_FLASH.ld)
# ##############################################################################
set(EXECUTABLE ${CMAKE_PROJECT_NAME})
enable_language(C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

# Headers
set(PROJ_INCLUDE_DIRECTORIES
    ${CMAKE_CURRENT_SOURCE_DIR}/inc
    ${CMAKE_CURRENT_SOURCE_DIR}/inc/CMSIS
    ${CMAKE_CURRENT_SOURCE_DIR}/inc/STM32G0xx_HAL_Driver
    ${CMAKE_CURRENT_SOURCE_DIR}/inc/STM32G0xx_HAL_Driver/Legacy)

# Sources
file(GLOB_RECURSE PROJ_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/src/startup_stm32g0b1retx.s
    ${CMAKE_CURRENT_SOURCE_DIR}/src/main.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/stm32g0xx_hal_msp.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/stm32g0xx_it.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/system_stm32g0xx.c

    #HAL
    ${CMAKE_CURRENT_SOURCE_DIR}/src/STM32G0xx_HAL_Driver/stm32g0xx_hal.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/STM32G0xx_HAL_Driver/stm32g0xx_hal_cortex.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/STM32G0xx_HAL_Driver/stm32g0xx_hal_rcc.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/STM32G0xx_HAL_Driver/stm32g0xx_hal_pwr_ex.c
    
    )

# Executable files
add_executable(${EXECUTABLE} ${PROJ_SOURCES})

# Embedded macros(defines)
target_compile_definitions(${EXECUTABLE} PRIVATE ${MCU_MODEL} USE_HAL_DRIVER)

# Add header directories (AFTER add_executable !!)
target_include_directories(${EXECUTABLE} PRIVATE ${PROJ_INCLUDE_DIRECTORIES})

# Compiler and linker options
target_compile_options(${EXECUTABLE} PRIVATE
    ${CPU_PARAMETERS}
    -Wall
    -Wextra
    -Wpedantic
    -Wno-unused-parameter
    $<$<COMPILE_LANGUAGE:CXX>:
        -Wno-volatile
        -Wold-style-cast
        -Wuseless-cast
        -Wsuggest-override>
    $<$<CONFIG:Debug>:-Og -g3 -ggdb>
    $<$<CONFIG:Release>:-Og -g0>)

target_link_options(${EXECUTABLE} PRIVATE
    -T${MCU_LINKER_SCRIPT}
    ${CPU_PARAMETERS}
    -Wl,-Map=${CMAKE_PROJECT_NAME}.map
    --specs=nosys.specs
    -Wl,--start-group
    -lc
    -lm
    -lstdc++
    -lsupc++
    -Wl,--end-group
    -Wl,--print-memory-usage)

add_custom_command(TARGET ${EXECUTABLE} POST_BUILD
    COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${EXECUTABLE}>)

add_custom_command(TARGET ${EXECUTABLE} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O ihex $<TARGET_FILE:${EXECUTABLE}>
    ${EXECUTABLE}.hex
    COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${EXECUTABLE}>
    ${EXECUTABLE}.bin)

