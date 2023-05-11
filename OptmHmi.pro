#Copyright (C) 2022 Optm Media Solutions
QT += widgets qml quick
TARGET = optm_hmi
TEMPLATE = app
CONFIG += qtquickcompiler c++11

DEFINES = TEST_APP
#DEFINES = APP

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS
QML_IMPORT_PATH = /qml
# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

INCLUDEPATH += $$PWD/inc
contains(DEFINES, APP){
INCLUDEPATH += $$PWD/../../common/inc
INCLUDEPATH += $$PWD/../../lib/hal
INCLUDEPATH += $$PWD/../../lib/controller
INCLUDEPATH += $$PWD/../../thirdparty/jansson/src

LIBS += -L$$PWD/../../lib/controller/ -lcontroller
LIBS += -L$$PWD/../../lib/hal/ -lhal
LIBS += -L$$PWD/../../thirdparty/jansson/ -ljannson
LIBS += -lsysfs
}

LIBS += -lrt
SOURCES += \
	src/platformcomm.cpp\
        src/hmidatahandler.cpp \
	src/main.cpp

HEADERS += \
    inc/platformcomm.h  \
    inc/hmidatahandler.h \
    inc/constants.h \
    
    
RESOURCES += \
    ui.qrc

