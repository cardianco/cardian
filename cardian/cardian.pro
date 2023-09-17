QT += quick
CONFIG += c++17 qmltypes

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

#ANDROID_ABIS="x86_64"
ANDROID_ABIS="arm64-v8a"

# Third parties
include(third-parties/qomponent/Qomponent/Qomponent.pri)
include(third-parties/hive/Hive/Hive.pri)
include(third-parties/veqtor/veqtor/veqtor.pri)
include(third-parties/qt-aes.pri)

SOURCES += \
        main.cpp \
        cryptographic.cpp \
        requesthandler.cpp \
        utils.cpp

RESOURCES += qml.qrc

QML_IMPORT_NAME = cardian
QML_IMPORT_MAJOR_VERSION = 0

QML_IMPORT_PATH += $${PWD}/..
QML2_IMPORT_PATH += $${PWD}/..

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    cryptographic.h \
    eventmodel.h \
    requesthandler.h \
    utils.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle.properties \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
