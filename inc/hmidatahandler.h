#ifndef HMIDATAHANDLER_H
#define HMIDATAHANDLER_H

#include <QObject>

class HmiDataHandler : public QObject
{
    Q_OBJECT

    Q_INVOKABLE void updateSpeed(int i_speed);
    Q_INVOKABLE void updateDistToEmpty(int i_dte);
	Q_INVOKABLE void updateInputEvent(int i_keyVal);
    Q_INVOKABLE void updateOdometer(int i_distance);
    Q_INVOKABLE void updateBleMessage(QString s_msg);	
    Q_INVOKABLE void updateDriveMode(int i_driveMode);	
    Q_INVOKABLE void updateCurrentStatus(int i_status);
	Q_INVOKABLE void updateBatteryLevel(int i_batlevel);
	Q_INVOKABLE void updateBatteryRegenStatus(int i_status);	
	Q_INVOKABLE void updateLocation(double d_long,double d_lat);	
    Q_INVOKABLE void updateCurrentTrip(int i_tripval);
    Q_INVOKABLE void updateBleStatus(int i_status);
    Q_INVOKABLE void updateScreenType(int i_screen);
    Q_INVOKABLE void updateNav(int i_dir, int i_dist, QString sMsg);
	Q_INVOKABLE void updateCallEvent(QString sNum, QString sMsg);
    Q_INVOKABLE void changeColor(int mode) {
        m_color = mode;
        emit colorChanged(mode);
    }

    Q_INVOKABLE void showLeft() {
        m_showLeft = !m_showLeft;
        if(m_showLeft)
            m_showRight = false;

        emit showLeftChanged(m_showLeft);
        emit showRightChanged(m_showRight);
    }

    Q_INVOKABLE void showRight() {
        m_showRight = !m_showRight;

        if (m_showRight)
            m_showLeft = false;

        emit showLeftChanged(m_showLeft);
        emit showRightChanged(m_showRight);
    }

public:
    HmiDataHandler(QObject* parent = nullptr);
    void setBrightnessValue(int brightnessVal);
	Q_INVOKABLE void sendCallResp(int resp);
signals:
    void modeChanged(QString mode, bool isError);
    void speedChanged(int mspeed,double dangle);
    void batteryChanged(int mbattery);
    void colorChanged(int cmode);
    void distanceChanged(int dist);
    void showLeftChanged(bool show);
    void showRightChanged(bool show);
    void dteChanged(int mdte);
    void tripValueChanged(int mtrip);
    void screenChanged(int mscreen);
    void navChanged(int mdir, int mdist,QString smsg);
	void callEvent(QString sNum, QString sMsg);
    void bleStatusChanged(int mstatus);
public slots:
    void slotHmiMessageReceived(const QVariant& frame, int frameType);

private:
    int modeDataCounter = 0;
    int m_speed = 0;
    int m_battery = 0;
    int m_color = 0;
    int m_distance = 0;
    bool m_showLeft = false;
    bool m_showRight = false;
    int m_dte = 0;
    int m_tripval =0;
    int m_drivemode =255;
    int m_screen   = 0;
    int m_dir      = 0;
    int m_dist      = 0;
    int m_blestatus = 0;
	
  QString m_callNum;
  QString m_callMsg;
};

#endif // HMIDATAHANDLER_H
