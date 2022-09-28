set(CMAKE_SYSTEM_NAME generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(TOOLCHAIN_PREFIX arm-none-eabi-)
set(CFLAGS "-fdata-sections -ffunction-sections --specs=nano.specs -Wl,--gc-sections")
set(CPPFLAGS "-fno-rtti -fno-exceptions -fno-threadsafe-statics")

set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}gcc ${CFLAGS})
set(CMAKE_ASM_COMPILER ${CMAKE_C_COMPILER})
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}g++ ${CFLAGS} ${CPP_FLAGS})
set(CMAKE_OBJCOPY ${TOOLCHAIN_PREFIX}objcopy)
set(CMAKE_SIZE ${TOOLCHAIN_PREFIX}size)

set(CMAKE_EXECUTABLE_SUFFIX_ASM ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_C ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_CXX ".elf")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

