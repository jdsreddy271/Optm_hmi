#ifndef PLATFORMCOMM_H
#define PLATFORMCOMM_H
#include <mqueue.h>
#include "constants.h"

#include <QObject>
#include <QThread>

class PlatformComm : public QThread
{

    Q_OBJECT

public:
    PlatformComm(QObject* parent = nullptr);
    ~PlatformComm();

protected:
     void run() override;

Q_SIGNALS:
     void HmiMessageReceived(const QVariant& frame, int frameType);
};

#endif // PLATFORMCOMM_H
