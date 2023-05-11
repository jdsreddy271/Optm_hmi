#ifndef BCU_COMMON_HMI_H
#define BCU_COMMON_HMI_H

#ifdef __cplusplus
extern "C" {
#endif
/*-----------------------------------------------------------------------*
 * Include Headers				           	                             *
 *-----------------------------------------------------------------------*/
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#ifdef APP
#include <linux/can.h>
#include <linux/can/raw.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <netinet/ip.h>
#include <mqueue.h>
#include <stdlib.h>
#include <errno.h>
#include <pthread.h>
#include <sys/socket.h>
#endif
/*-----------------------------------------------------------------------*
 * Macros										                         *
 *-----------------------------------------------------------------------*/

#define BCU_OK						0
#define BCU_NOK						1
#define UNUSED(x)   				(void)(x);
#define BCU_BACKLIGHT_LEVEL_MAX		30
#define BCU_SYSFS_PATH_MAX			512
#define BCU_SYSFS_PATH_LENGTH		256
#define BCU_SYSFS_VALUE_LENGTH		256
/*-----------------------------------------------------------------------*
 * Structure and enum definations				                         *
 *-----------------------------------------------------------------------*/
typedef enum
{
    eState_Shutdown 	= 0,
    eState_Standby 		= 1,
    eState_Active 		= 2,
    eState_Other 		= 3,
}Controller_state_t;


typedef struct
{
    int iCanId;
    int iDataLen;
    unsigned char sData[8];
}sCanMessage_t;

typedef enum
{
    eDrivemode_Echo     = 0,
    eDrivemode_Sport    = 1,
    eDrivemode_Reverse  = 2,
    eDrivemode_Standby  = 3,
    eDrivemode_Crawl  	= 4,
    eDrivemode_City  	= 5,    
    eDrivemode_Invalid  = 6,
}eDrivemode_t;


typedef enum
{
    eStatus_None	     = 0,
    eStatus_Initialised  = 1,
    eStatus_Enabled  	 = 2,
    eStatus_Connected	 = 3,
    eStatus_Other		 = 4,
}eDeviceStatus_t;

typedef enum
{
    eCANID_Frame1     = 0x100,
    eCANID_Frame2     = 0x101,
    eCANID_Frame3     = 0x102,
    eCANID_Frame4     = 0x103,
    eCANID_Frame5     = 0x104,
    eCANID_Frame6     = 0x105,
    eCANID_Frame7     = 0x106,
    eCANID_Frame8     = 0x107,
    eCANID_Frame9     = 0x108,
    eCANID_Frame10    = 0x109,
    eCANID_Frame11    = 0x110,
    eCANID_Frame12    = 0x111,
    eCANID_Frame505   = 0x505,
    eCANID_Frame506   = 0x506,
    eCANID_Frame507   = 0x507,
    eCANID_Frame354   = 0x354,
    eCANID_Frame230   = 0x230,    // Cretera CAN ID's'
    eCANID_Frame231   = 0x231,
    eCANID_Frame232   = 0x232,
    eCANID_Frame233   = 0x233,    
}eCANFrame_t;

typedef enum
{
    ekey_Invalid        = 0,
    ekey_Up			    = 1,
    ekey_Down        	= 2,
    ekey_Left			= 3,
    ekey_Right        	= 4,
    ekey_Ok				= 5,
    ekey_Other			= 6,
}eKey_t;

typedef enum
{
    eModule_Bt			= 1 << 0,
    eModule_Can			= 1 << 1,
    eModule_Led			= 1 << 2,
    eModule_Gsm			= 1 << 3,
    eModule_Gps 		= 1 << 4,
	eModule_Rtc    		= 1 << 5,
    eModule_Gyro		= 1 << 6,
    eModule_Accel		= 1 << 7,
    eModule_Keyboard    = 1 << 8,
    eModule_BackLight	= 1 << 9,
    eModule_LightSensor	= 1 << 10,
}Cluster_Modules_t;

typedef struct
{
    Controller_state_t 	iReqState;
    Controller_state_t  iCurState;
#ifdef APP
    mqd_t 		iEventmq;
#endif
}sController_t;

typedef struct
{
    int 			iXAxis;
    int 			iYAxis;
    int 			iZAxis;
    int		 		iOther;
}sAccelData_t;

typedef struct
{
    int 			iXAxis;
    int 			iYAxis;
    int 			iZAxis;
    int		 		iOther;
}sGyroData_t;

typedef struct
{
    int 			iIllVal;
}sLightSensorData_t;

typedef struct
{
    int iEventId;
    char sData[256];
}sMessage_t;

typedef enum
{
    eEvent_None				= 0,
    eEvent_CanFrame1		= 1,
    eEvent_CanFrame2		= 2,
    eEvent_CanFrame3		= 3,
    eEvent_CanFrame4		= 4,
    eEvent_CanFrame5		= 5,
    eEvent_CanFrame6		= 6,
    eEvent_CanFrame7		= 7,
    eEvent_CanFrame8		= 8,
    eEvent_CanFrame9		= 9,  //Standby Testing
    eEvent_CanFrame10		= 10,
    eEvent_KeyBoard			= 11,
    eEvent_Bt				= 12,
    eEvent_Gsm				= 13,
    eEvent_Gps				= 14,
    eEvent_LightSensor		= 15,
    eEvent_Accel			= 16,
    eEvent_Gyro				= 17,
    eEvent_Nav				= 18, 
    eEvent_CanFrame230		= 19,
    eEvent_CanFrame231		= 20,
    eEvent_CanFrame232		= 21,
    eEvent_CanFrame233		= 22,  
    eEvent_Call				= 23, 
    eEvent_Profile			= 24,       	
}Cluster_Events_t;

typedef enum
{
    eStatus_BeamHighLow			= 1,
    eStatus_LowBat				= 1 << 1,
    eStatus_ChargeOnOff			= 1 << 2,
    eStatus_HazardOnOff			= 1 << 3,
    eStatus_TSLLOnOff			= 1 << 4,
    eStatus_TSLROnOff			= 1 << 5,
    eStatus_ServiceInd			= 1 << 6,
    eStatus_SoftDefault			= 1 << 7,
    eStatus_TCConnected			= 1 << 8,
    eStatus_IgnitionOnoff		= 1 << 9,
    eStatus_BTOnoff	    		= 1 << 10,
    eStatus_BacklightChanged 	= 1 << 11,
}Cluster_Status_t;

typedef enum
{
    eLed_None		   		= -1,
    eLed_SoftFault	   		= 0,
    eLed_Charger  	   		= 1,
    eLed_HighLowBeam  		= 2,
    eLed_TSLL		   		= 3,
    eLed_TSLR	       		= 4,
    eLed_Hazard   	   		= 5,
    eLed_LowBat       		= 6,
    eLed_TCConneted    		= 7,
    eLed_Max		   		= 8,
}eLed_t;

typedef enum
{
    eGPIO_Nav_LSENABLE 			= 0,
    eGPIO_BT_Enable    			= 1,
    eGPIO_BT_RST	  			= 2,
    eGPIO_BL_ENABLE	  			= 3,
    eGPIO_GYRO_ENABLE			= 4,
    eGPIO_GPS_PowerOn			= 5,
    eGPIO_GSM_PowerOn   		= 6,
    eGPIO_GSM_LDO_Enable		= 7,
    eGPIO_GSM_Shutdown	  		= 8,
    eGPIO_USB_HostEnable	  	= 9,
    eGPIO_GSM_SWReady			= 10,
    //	eGPIO_GSM_PowerMonitor	  	= 11,
    //	eGPIO_GSM_Reset			  	= 12,	 // change below line when it is included
    eGPIO_MAX         			= 11,
}eGPIO_t;

typedef enum
{
	eGpioKey1	=0x01,
	eGpioKey2	=0x02,
	eGpioKey3	=0x04,
	eGpioKey4	=0x08,
	eGpioKey5	=0x10,	
}eGPIOKey_t;

#define BCU_GPIO_MAX				eGPIO_MAX

typedef struct
{
    int iOdometer;
    int iCurTrip;
}sCanFrame1_t;

typedef struct
{
    int iSpeed;
    int iDistanceToEmpty;
    int iDriveProfile;
}sCanFrame2_t;

typedef struct
{
    int iStatus;
}sCanFrame3_t;


typedef struct
{
    int iBatteryStatus;
}sCanFrame4_t;

typedef struct
{
    int iBatteryRegenPer;
}sCanFrame6_t;

typedef struct
{
    int iVal;
}sCanFrame9_t;

typedef struct
{
    int iKeyVal;   // refer eKey_t for key value mapping
}sKeyBoard_t;

typedef struct
{
    double dLongitude;
    double dLatitude;
}sGps_t;

typedef struct
{
    int iDir;
    int iDist;
	char sMsg[128] ;    
}sNav_t;

typedef struct
{
	int iPh;
	int iUID;
    int iBtHe;
	int iOdo;
	int iTrip;
	int iBtSt;
	int iDTE;
	char sPrNo[15];
	char sMdNo[15];
	char sFType[10];
	char sMxTrq[10];
	char sRang[10];
	char sBtCy[10];
}sDevData_t;

typedef struct
{
    int  iResp;  
}sAuthenResp_t;

typedef struct
{
    int  iResp;  
}sCallResp_t;

typedef enum 
{
	eDevData        =   1,
	eAuthenData   	=   2,
	eCallResp       =   3
}sMsgType;


typedef struct
{
	char  sMode[16];
  	char  sNum[32];
	char  sMsg[32];
}sCallEvent_t;

typedef struct
{
	char  sMsg[32];
  	char  sNum[32];
}sProfileEvent_t;

typedef struct
{
    char sMsg[256] ;  // Bt data with 128 bytes
}sBtData_t;


typedef struct
{
    int iDriveProfile;
}sCanFrame230_t;

typedef struct
{
    int iSpeed;
}sCanFrame231_t;

#ifdef __cplusplus
}
#endif

#endif  //BCU_COMMON_HMI_H