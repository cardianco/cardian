QT += core

!contains(ANDROID_ABIS, arm64-v8a):!contains(ANDROID_ABIS, armeabi-v7a) {
    message(Using intel aes)
    DEFINES += USE_INTEL_AES_IF_AVAILABLE
}

QMAKE_CXXFLAGS += -maes

HEADERS += \
    $${PWD}/Qt-AES/qaesencryption.h \
    $${PWD}/Qt-AES/aesni/aesni-key-init.h \
    $${PWD}/Qt-AES/aesni/aesni-key-exp.h \
    $${PWD}/Qt-AES/aesni/aesni-enc-ecb.h \
    $${PWD}/Qt-AES/aesni/aesni-enc-cbc.h

SOURCES += \
    $${PWD}/Qt-AES/qaesencryption.cpp
