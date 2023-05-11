#ifndef CONSTANTS_H
#define CONSTANTS_H

#define QUEUE_NAME   "/CanRx"
#define QUEUE_PERMISSIONS 0660
#define MAX_MESSAGES 100
#define MAX_MSG_SIZE 512
#define MSG_BUFFER_SIZE MAX_MSG_SIZE + 10


#include <QVariant>

typedef struct
{
    int iOdometer;
    int iCurTrip;
}UICanFrame1_t;
Q_DECLARE_METATYPE(UICanFrame1_t)

typedef struct
{
    int iSpeed;
    int iDistanceToEmpty;
    int iDriveProfile;
}UICanFrame2_t;
Q_DECLARE_METATYPE(UICanFrame2_t)

typedef struct
{
    int iStatus;
}UICanFrame3_t;
Q_DECLARE_METATYPE(UICanFrame3_t)

typedef struct
{
    int iBatteryStatus;
}UICanFrame4_t;
Q_DECLARE_METATYPE(UICanFrame4_t)

typedef struct
{
    int iBatteryRegenPer;
}UICanFrame6_t;
Q_DECLARE_METATYPE(UICanFrame6_t)

typedef struct
{
    int iKeyVal;
}UIKeyBoard_t;
Q_DECLARE_METATYPE(UIKeyBoard_t)

typedef struct
{
    double dLongitude;
    double dLatitude;
}UILocation_t;
Q_DECLARE_METATYPE(UILocation_t)

typedef struct
{
    int iDir;
    int iDist;
    char sMsg[128];
}UINav_t;
Q_DECLARE_METATYPE(UINav_t)

typedef struct
{
    char sMode[16];	
    char sNum[32];
	char sMsg[32];
}UICallEvent_t;
Q_DECLARE_METATYPE(UICallEvent_t)

typedef struct
{
    int iStatus;
}UIBleStatusEvent_t;
Q_DECLARE_METATYPE(UIBleStatusEvent_t)

//cretara
typedef struct
{
    int iDriveProfile;
}UICanFrame230_t;
Q_DECLARE_METATYPE(UICanFrame230_t)

typedef struct
{
    int iSpeed;
}UICanFrame231_t;
Q_DECLARE_METATYPE(UICanFrame231_t)


typedef struct
{
    int iStatus;
}UIBatStatus_t;
Q_DECLARE_METATYPE(UIBatStatus_t)

class UIMetaRegister
{
public:
    UIMetaRegister()
    {
        qRegisterMetaType<UICanFrame1_t>();
        qRegisterMetaType<UICanFrame2_t>();
        qRegisterMetaType<UICanFrame6_t>();
        qRegisterMetaType<UIKeyBoard_t>();
        qRegisterMetaType<UILocation_t>();
        qRegisterMetaType<UICanFrame230_t>();
		qRegisterMetaType<UICanFrame231_t>();
        qRegisterMetaType<UICallEvent_t>();
        qRegisterMetaType<UIBatStatus_t>();        
        qRegisterMetaType<UIBleStatusEvent_t>();
        qRegisterMetaType<UINav_t>();
    }
};
#endif // CONSTANTS_H
