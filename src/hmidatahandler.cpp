#include <QDebug>
#include <QTimer>
#include <QVariant>
#include "hmidatahandler.h"
#include "constants.h"

#ifdef APP
#include "bcu_common.h"
#include "bcu_cluster_controller.h"
#else
#include "bcu_common_hmi.h"
#endif

HmiDataHandler::HmiDataHandler(QObject *parent): QObject(parent)

{
  m_callNum = "";
  m_callMsg = "";
#ifndef APP
        // Creating single shot time and trigger after 5Sec
        QTimer::singleShot(5000,this,[&]()   //this is lambda function
        {
 //           updateScreenType(0);
            navChanged(0,500,QString("Head south on Church Road"));
            updateOdometer(100);
            updateDistToEmpty(40);
            updateBatteryLevel(100);
            updateBleMessage("Full scale test 0- 240");
            updateSpeed(240);
            showLeft();
            updateBleStatus(1);

        });

        QTimer::singleShot(25000,this,[&]()
        {
  //          updateScreenType(1);
            navChanged(1,700,QString("Head south on Church Road"));
            updateBleMessage("Full scale test back to 0");
            updateSpeed(0);
            updateCurrentTrip(5);
            updateOdometer(150);
            updateDistToEmpty(30);
            updateBatteryLevel(100);
            showRight();
            updateBleStatus(0);

        });

        QTimer::singleShot(45000,this,[&]()
        {
//            updateScreenType(0);
            navChanged(3,100,QString("Head south on Church Road"));
            updateBleMessage("go to 30");
            updateSpeed(30);
            updateCurrentTrip(10);
            updateOdometer(200);
            updateDistToEmpty(20);
            updateBatteryLevel(40);
                        showLeft();
        });

        QTimer::singleShot(50000,this,[&]()
        {
            updateBleMessage("Changed to 80");
            navChanged(4,1000,QString("Head south on Church Road"));
            updateSpeed(80);
            updateCurrentTrip(15);
            updateOdometer(225);
            updateDistToEmpty(5);
            updateBatteryLevel(20);
            showRight();
            updateBleStatus(1);
        });

        QTimer::singleShot(10000, this, [&]() {
          updateCallEvent("+911234567890", "Mr. Xyz");
        });

        QTimer::singleShot(25000, this, [&]() {
          updateCallEvent("+916789012345", "Mr. ABC");
        });

        QTimer::singleShot(40000, this, [&]() {
          updateCallEvent("+914528958484", "Mr.Lmop");
        });
#endif
}


void HmiDataHandler::slotHmiMessageReceived(const QVariant &frame, int frameType)
{
#ifdef APP
    switch (frameType) 
	{
		case eEvent_CanFrame1:
		{
			UICanFrame1_t f = frame.value<UICanFrame1_t>();
			updateOdometer(f.iOdometer);
            updateCurrentTrip(f.iCurTrip);
		}
		break;
		case eEvent_CanFrame2:
		{
			UICanFrame2_t f = frame.value<UICanFrame2_t>();
			updateSpeed(f.iSpeed);
			updateDriveMode(f.iDriveProfile);
			updateDistToEmpty(f.iDistanceToEmpty);
		}
		break;
		case eEvent_CanFrame3:
		{
			UICanFrame3_t f = frame.value<UICanFrame3_t>();
			updateCurrentStatus(f.iStatus);
		}
		break;
		case eEvent_CanFrame302:			
		case eEvent_CanFrame4:
		{
			UIBatStatus_t f = frame.value<UIBatStatus_t>();
			updateBatteryLevel(f.iStatus);
		}
			break;
		case eEvent_CanFrame5:
			//UICanFrame1_t f = frame.value<UICanFrame1_t>();
			break;
		case eEvent_CanFrame6:
		{
			UICanFrame6_t f = frame.value<UICanFrame6_t>();
			updateBatteryRegenStatus(f.iBatteryRegenPer);
		}
			break;
		case eEvent_KeyBoard:
		{
			UIKeyBoard_t f = frame.value<UIKeyBoard_t>();
			updateInputEvent(f.iKeyVal);
		}
		break;

		case eEvent_Gps:
		{
			UILocation_t f = frame.value<UILocation_t>();
			updateLocation(f.dLongitude,f.dLatitude);
		}
		break;
		case eEvent_Bt:
		{
			qDebug() << "Data to be Displayed: "<<frame;
			updateBleMessage(frame.toString());
		}
        break;
        case eEvent_Nav:
        {
            UINav_t f = frame.value<UINav_t>();
            qDebug() << "Nav data: dir : "<< f.iDir << "dir : " << f.iDist ;
            updateNav(f.iDir,f.iDist,f.sMsg);
        }
        break;
		case eEvent_CanFrame230:
		{
			UICanFrame230_t f = frame.value<UICanFrame230_t>();
			updateDriveMode(f.iDriveProfile);
		}
		break; 
		case eEvent_CanFrame231:
		{
			UICanFrame231_t f = frame.value<UICanFrame231_t>();
			updateSpeed(f.iSpeed);
		}
		break; 
		case eEvent_Call:
		{
    		UICallEvent_t f = frame.value<UICallEvent_t>();
   			updateCallEvent(f.sNum, f.sMsg);
		}
        break;

        case eEvent_BleStatus:
        {
            UIBleStatusEvent_t f = frame.value<UIBleStatusEvent_t>();
            updateBleStatus(f.iStatus);
        }
        break;       
        default:
        break;
    }
#endif
}

void HmiDataHandler::updateInputEvent(int i_keyVal)
{
	(void)(i_keyVal);
}

void HmiDataHandler::updateLocation(double d_long,double d_lat)
{
	(void)(d_long);
	(void)(d_lat);	
}


void HmiDataHandler::updateBleMessage(QString s_msg)
{
    emit modeChanged(s_msg,false);
}


void HmiDataHandler::updateDriveMode(int i_mode)
{
    if(m_drivemode != i_mode)
    {
        QString sMode;
        switch(i_mode)
        {
            case 1:
                sMode = "\tSport Mode";
            break;
            case 2:
                sMode = "\tReverse Mode";
            break;
            case 5:
                sMode = "\tCiti Mode";
            break;					
            case 0:
            default:
                sMode = "\tEco Mode";
            break;
        }
        emit modeChanged(sMode,false);
    }
}


void HmiDataHandler::updateCurrentStatus(int i_Status)
{
(void)(i_Status);
#if 0
    QString sMode;
	switch(i_Status)
	{
		case 1:
			sMode = "Sport Mode";		
		break;
		case 2:
			sMode = "Reverse Mode";		
		break;
		case 0:		
		default:
			sMode = "Eco Mode";		
		break;
	}

    emit modeChanged(sMode, true);
#endif
}


void HmiDataHandler::updateSpeed(int i_speed)
{
    if (i_speed <= 240)
    {
        double d_angle = 0;
        m_speed = i_speed;
        d_angle = (m_speed)*253/240;

        qDebug() << m_speed<< " : "<< d_angle;
        emit speedChanged(m_speed,d_angle);  // sending speed to qml by emitting signal
     }
}

void HmiDataHandler::updateBatteryLevel(int i_batlevel)
{
    if (i_batlevel <= 100)
    {
        m_battery = i_batlevel;
        emit batteryChanged(m_battery);
     }
}


void HmiDataHandler::updateDistToEmpty(int i_dte)
{
    m_dte = i_dte;

    emit dteChanged(m_dte);
}


void HmiDataHandler::updateCurrentTrip(int i_tripval)
{
    m_tripval = i_tripval;
    emit tripValueChanged(m_tripval);
}

void HmiDataHandler::updateOdometer(int i_distance)
{
	m_distance = i_distance;

	emit distanceChanged(m_distance);
}

void HmiDataHandler::updateBatteryRegenStatus(int i_Regen)
{
	(void)(i_Regen);
}

void HmiDataHandler::updateScreenType(int i_screen)
{
    emit screenChanged(i_screen);
}

void HmiDataHandler::updateNav(int i_dir, int i_dist,QString sMsg)
{
    m_dist = i_dist;
    m_dir  = i_dir;
    emit navChanged(i_dir,i_dist,sMsg);
}


void HmiDataHandler:: updateBleStatus(int i_status)
{
    m_blestatus = i_status;
    emit bleStatusChanged(i_status);
}

void HmiDataHandler::setBrightnessValue(int brightnessVal)
{
	(void)(brightnessVal);
#if 0
#ifndef TEST_APP
    if(currentBrightnessValue() != brightnessVal)
        Bcu_Cluster_Controller_Display_Set_Brightness(brightnessVal);
#else
    (void)(brightnessVal);
    qDebug() << "setBrightnessVlue";
#endif
#endif
}

void HmiDataHandler::sendCallResp(int resp)
{
#ifndef TEST_APP
	Bcu_Cluster_Controller_CallResp(resp);
#else
    (void)(resp);
#endif
}
void HmiDataHandler::updateCallEvent(QString sNum, QString sMsg) {
      qDebug() << "updateCallEvent";
  m_callNum = sNum;
  m_callMsg = sMsg;
  emit callEvent(sNum, sMsg);
}
