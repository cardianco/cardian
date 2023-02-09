#pragma once

#include <QtCore>
#include <QObject>
#include <QString>
#include <QCryptographicHash>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "third-parties/Qt-AES/qaesencryption.h"

namespace caralarm::core {
class cryptographic : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_NAMED_ELEMENT(Crypt)
    QML_ADDED_IN_MINOR_VERSION(1)
public:
    explicit cryptographic(QObject* parent = nullptr)
        : QObject{parent},
          mSha256(QCryptographicHash::Sha256),
          mAes256(QAESEncryption::AES_256, QAESEncryption::CBC) {}

    Q_INVOKABLE QByteArray sha256Hex(const QByteArray &data) {
        mSha256.addData(data);
        return mSha256.result().toHex();
    }

    Q_INVOKABLE QByteArray aesEncrypt(const QByteArray &key, const QByteArray &data) {
        return mAes256.encode(data, key);
    }

    Q_INVOKABLE QByteArray aesDecrypt(const QByteArray &key, const QByteArray &data) {
        return mAes256.encode(data, key);
    }

    Q_INVOKABLE QString random256Hex() const {
        QByteArray rand = QString::number(QRandomGenerator::system()->generate()).toLocal8Bit();
        return QCryptographicHash::hash(rand, QCryptographicHash::Sha256).toHex();
    }
signals:

private:
    QCryptographicHash mSha256;
    QAESEncryption mAes256;
};
}
