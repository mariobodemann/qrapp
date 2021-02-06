cmake_minimum_required(VERSION 3.10.2)

project("qr")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11 -Wall -Werror -Os")

add_library(native_app_glue STATIC
        ${CMAKE_ANDROID_NDK}/sources/android/native_app_glue/android_native_app_glue.c)

include_directories(${CMAKE_ANDROID_NDK}/sources/android/native_app_glue/)

add_library(qr SHARED app.cpp)

find_library(log-lib log)
target_link_libraries(qr ${log-lib})

set_property(TARGET qr APPEND_STRING PROPERTY LINK_FLAGS " -u ANativeActivity_onCreate")

target_link_libraries(qr
        android
        native_app_glue
        log)

