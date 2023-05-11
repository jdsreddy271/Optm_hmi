
#ifdef APP
#include "bcu_cluster_controller.h"
#endif
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <QDebug>
#include <QString>
#include <QEvent>
#include <QTimer>
#include <QVariant>
#include "platformcomm.h"
#include "constants.h"

PlatformComm::PlatformComm(QObject *parent):QThread(parent)
{

}

PlatformComm::~PlatformComm()
{
    qDebug() <<"Thread Destroyed.";
}

void PlatformComm::run()
{

	qDebug() << __FUNCTION__ ;
#ifdef APP
    struct mq_attr attr;
    char buffer[MSG_BUFFER_SIZE];
    sController_t	hCont;

    int currentProfile = 0;
    int distanceToEmpty = 0;

    hCont.iReqState = eState_Standby;
    //hCont.iReqState = eState_Active;
    attr.mq_flags = 0;
    attr.mq_maxmsg = MAX_MESSAGES;
    attr.mq_msgsize = MAX_MSG_SIZE;
    attr.mq_curmsgs = 0;

    hCont.iEventmq = mq_open (QUEUE_NAME, O_RDWR | O_CREAT, QUEUE_PERMISSIONS, &attr);

    Bcu_Cluster_Controller_Init(&hCont);

    if(hCont.iEventmq != -1)
    {
        while (1)
        {
            int iRetCode = mq_receive (hCont.iEventmq, (char *)buffer, MSG_BUFFER_SIZE, NULL);
            if (iRetCode >= 0)
            {
                sMessage_t sMsg = {0, ""};
                memcpy ((char *)&sMsg, (char *)buffer, sizeof(sMessage_t));

                QVariant frameValue;
                switch (sMsg.iEventId)
				{
					case eEvent_CanFrame1 :
					{
                        sCanFrame1_t* sParam = (sCanFrame1_t*)sMsg.sData;
                        if(sParam)
						{
							UICanFrame1_t frame;
                            frame.iOdometer = sParam->iOdometer;
                            frame.iCurTrip = sParam->iCurTrip;
							frameValue.setValue(frame);
                            emit HmiMessageReceived(frameValue, sMsg.iEventId);
						}
					}
                    break;
					case eEvent_CanFrame2:
					{
                        sCanFrame2_t* sParam = (sCanFrame2_t*)sMsg.sData;
                        if(sParam)
						{
                            qDebug() <<"PROFILE = " << sParam->iDriveProfile;

							UICanFrame2_t frame;
                            frame.iSpeed = sParam->iSpeed;
                            frame.iDriveProfile = sParam->iDriveProfile;
                            frame.iDistanceToEmpty = sParam->iDistanceToEmpty;
							frameValue.setValue(frame);
                            emit HmiMessageReceived(frameValue, sMsg.iEventId);

                            if(sParam->iDriveProfile == eDrivemode_Standby)
							{
								frame.iDriveProfile = currentProfile;
								frame.iSpeed = 0;
								frame.iDistanceToEmpty = distanceToEmpty;
								frameValue.setValue(frame);
                                emit HmiMessageReceived(frameValue, sMsg.iEventId);
							}
							else
							{
                                currentProfile = sParam->iDriveProfile;
                                distanceToEmpty = sParam->iDistanceToEmpty;
							}
						}
					}
                    break;
					case eEvent_CanFrame3:
					{
                        sCanFrame3_t* sParam = (sCanFrame3_t*)sMsg.sData;
                        if(sParam)
						{
							UICanFrame3_t frame;
                            frame.iStatus = sParam->iStatus;
							frameValue.setValue(frame);
                            emit HmiMessageReceived(frameValue, sMsg.iEventId);
						}
					}
                    break;
					case eEvent_CanFrame4:
					case eEvent_CanFrame302:
					{
                        sBatStatus_t* sParam = (sBatStatus_t*)sMsg.sData;
                        if(sParam)
						{
							UIBatStatus_t frame;
                            frame.iStatus = sParam->iStatus;
							frameValue.setValue(frame);
                            emit HmiMessageReceived(frameValue, sMsg.iEventId);
						}
					}
                    break;

					case eEvent_CanFrame6:
					{
                        sCanFrame6_t* sParam = (sCanFrame6_t*)sMsg.sData;
                        if(sParam)
						{
							UICanFrame6_t frame;
                            frame.iBatteryRegenPer = sParam->iBatteryRegenPer;
							frameValue.setValue(frame);
                            emit HmiMessageReceived(frameValue, sMsg.iEventId);
						}
					}
					break;
					case eEvent_KeyBoard:
					{
                        sKeyBoard_t* sParam = (sKeyBoard_t*)sMsg.sData;
                        if(sParam)
						{
							UIKeyBoard_t keyval;
                            keyval.iKeyVal = sParam->iKeyVal;
							frameValue.setValue(keyval);
                            emit HmiMessageReceived(frameValue, sMsg.iEventId);
						}
					}
                    break;
					case eEvent_Gps:
					{
                        sGps_t*  sParam = (sGps_t*)sMsg.sData;
                        if(sParam)
						{
							qDebug() <<"Gps = ";
                            UILocation_t frame;
                            frame.dLongitude = sParam->dLongitude;
                            frame.dLatitude = sParam->dLatitude;
                            frameValue.setValue(frame);
                            emit HmiMessageReceived(frameValue, sMsg.iEventId);


						}
					}
                    break;
					case eEvent_Bt:
					{
                        sBtData_t* sParam = (sBtData_t*)sMsg.sData;
                        if(sParam)
						{
                            frameValue.setValue(QString(sParam->sMsg));
                            emit HmiMessageReceived(frameValue, sMsg.iEventId);
						}

					}
                    break;
                    case eEvent_Nav:
                    {
                        sNav_t* sParam = (sNav_t*)sMsg.sData;
                        if(sParam)
                        {
                            UINav_t frame;
                            frame.iDir = sParam->iDir;
                            frame.iDist = sParam->iDist;
                            snprintf(frame.sMsg, 128,"%s",sParam->sMsg);
                            frameValue.setValue(frame);
                            emit HmiMessageReceived(frameValue, sMsg.iEventId);
                        }

                    }
                    break;
					case eEvent_CanFrame230:
					{
                        sCanFrame230_t* sParam = (sCanFrame230_t*)sMsg.sData;
                        if(sParam)
						{
                            qDebug() <<"PROFILE = " << sParam->iDriveProfile;

							UICanFrame230_t frame;
                            if(sParam->iDriveProfile == eDrivemode_Standby)
							{
								frame.iDriveProfile = currentProfile;							}
							else
							{
								frame.iDriveProfile = sParam->iDriveProfile;
                                currentProfile = sParam->iDriveProfile;
							}
							frameValue.setValue(frame);
							emit HmiMessageReceived(frameValue, sMsg.iEventId);								
							
						}
					}
                    break;
					case eEvent_CanFrame231:
					{
                        sCanFrame231_t* sParam = (sCanFrame231_t*)sMsg.sData;
                        if(sParam)
						{
							UICanFrame231_t frame;
                            frame.iSpeed = sParam->iSpeed;
                            
                            if(currentProfile == eDrivemode_Standby)
							{
								frame.iSpeed = 0;
							}
							
							frameValue.setValue(frame);
                            emit HmiMessageReceived(frameValue, sMsg.iEventId);
						}
					}
                    break;
					case eEvent_Call:
					{
                        sCallEvent_t* sParam = (sCallEvent_t*)sMsg.sData;
                        if(sParam)
						{
							UICallEvent_t frame;
                            snprintf(frame.sMsg, 32,"%s",sParam->sMsg);
                            snprintf(frame.sNum, 32,"%s",sParam->sNum);
							frameValue.setValue(frame);
                            emit HmiMessageReceived(frameValue, sMsg.iEventId);
						}
					}
                    break;
                    case eEvent_BleStatus:
                    {
                        sBleStatusEvent_t* sParam = (sBleStatusEvent_t*)sMsg.sData;
                        if(sParam)
                        {
                            UIBleStatusEvent_t frame;
                            frame.iStatus = sParam->iStatus;
                            frameValue.setValue(frame);
                            emit HmiMessageReceived(frameValue, sMsg.iEventId);
                        }
                    }
                    break;
					case eEvent_CanFrame5:			
					case eEvent_CanFrame7:
                    case eEvent_CanFrame8:
                    break;
					case eEvent_CanFrame9:
					{
						int iRval = BCU_NOK;
                        sCanFrame9_t* sParam = (sCanFrame9_t*)sMsg.sData;
                        if(sParam)
						{
							if(sParam->iVal == 1)
							{
								iRval=Bcu_Cluster_Controller_Can_Reset();
								if(iRval==BCU_OK)
								{
                                    QTimer::singleShot(10000, this, [&]() {
                                        hCont.iReqState = eState_Standby;
                                        Bcu_Cluster_Controller_Init(&hCont);
                                    });


								}
								else
								{
									printf("Can Reset Failed:\n");
								}
							}
							else if(sParam->iVal == 0)
							{
								hCont.iReqState = eState_Active;
								Bcu_Cluster_Controller_Init(&hCont);
							}
						}
					}
					break;
					case eEvent_CanFrame10:
					default:
                    break;
                }
            }
            else				
            {
                perror ("CanRx: mq_receive failed");
                sleep(1);
            }
		
        }
    }
#else
    {
        while(1)
        {
            QThread::sleep(100);
        }
    }
#endif
}
