QT += quick
CONFIG += c++17 qmltypes metatypes

# Adding qtquickcompiler only on release mode
CONFIG(release, debug|release): CONFIG += qtquickcompiler

# Workaround for QTBUG-38735
QT_FOR_CONFIG += location-private
qtConfig(geoservices_mapboxgl): QT += sql opengl
qtConfig(geoservices_osm): QT += concurrent

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Third parties
include(third-parties/qomponent/Qomponent/Qomponent.pri)
include(third-parties/veqtor/veqtor/veqtor.pri)
include(third-parties/hive/Hive/Hive.pri)
include(third-parties/qt-aes.pri)
include(third-parties/qtkeychain/qtkeychain.pri)
include(third-parties/sort-filter-proxy-model/SortFilterProxyModel.pri)

SOURCES += \
    main.cpp \
    cryptographic.cpp \
    requesthandler.cpp \
    utils.cpp

HEADERS += \
    cryptographic.h \
    eventmodel.h \
    logger.h \
    requesthandler.h \
    utils.h

contains(DEFINES, QTKEYCHAIN_NO_EXPORT) {
    SOURCES += securekeychain.cpp
    HEADERS += securekeychain.h
}

RESOURCES += qml.qrc

QML_IMPORT_NAME = cardian.core
QML_IMPORT_MAJOR_VERSION = 0

QML_IMPORT_PATH += $${PWD}/..
QML2_IMPORT_PATH += $${PWD}/..

CONFIG(debug, debug|release) { EXE_DIR = $${OUT_PWD}/debug }
else { EXE_DIR = $${OUT_PWD}/release }

#CONFIG += file_copies
#COPIES += qmltypes metatypes

#qmltypes.files = $$files($${OUT_PWD}/$${TARGET}.qmltypes)
#qmltypes.path = $${OUT_PWD}

#metatypes.files = $$files($${OUT_PWD}/$${TARGET}_metatypes.json)
#metatypes.path = $${OUT_PWD}

# Windows executeable icon
win32:RC_ICONS += resources/logo.ico
macx: ICON =  resources/logo.icns

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

android: DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle.properties \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml \
    android/res/values/apptheme.xml \
    android/res/drawable/icon.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

ANDROID_EXTRA_LIBS =
android: include(C:/AndroidKit/sdk/android_openssl/openssl.pri)
