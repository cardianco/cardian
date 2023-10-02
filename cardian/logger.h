#pragma once

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QObject>
#include <QtCore>

#include <QJsonDocument>
#include <QVariant>
#include <QFile>

namespace cardian::core {
class logger : public QObject {
    Q_OBJECT
    QML_SINGLETON
    QML_NAMED_ELEMENT(Logger)
    QML_ADDED_IN_MINOR_VERSION(1)
public:
    enum LogType {
        Debug   = QtMsgType::QtDebugMsg,
        Warning = QtMsgType::QtWarningMsg,
        Critical= QtMsgType::QtCriticalMsg,
        Fatal   = QtMsgType::QtFatalMsg,
        Info    = QtMsgType::QtInfoMsg,
    };
    Q_ENUM(LogType)

    static logger *create(QQmlEngine * = nullptr, QJSEngine * = nullptr) {
        static logger sLogger;
        return &sLogger;
    }

private slots:
    static void qtLogMessageHandler(QtMsgType type, const QMessageLogContext &, const QString &msg) {
        emit create(nullptr, nullptr)->log(msg, LogType(type));
    }

signals:
    void log(const QString &message, LogType type);

private:
    explicit logger(QObject *parent = nullptr): QObject{parent} {
        qInstallMessageHandler(qtLogMessageHandler);
    }
};
}

