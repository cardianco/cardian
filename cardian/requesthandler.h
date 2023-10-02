#pragma once

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QObject>
#include <QtCore>

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>

#include <QDir>

namespace cardian::network {
class requestHandler : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool running READ running NOTIFY runningChanged)
    Q_PROPERTY(Status status READ status NOTIFY statusChanged RESET resetStatus)
    QML_NAMED_ELEMENT(RequestHandler)
    QML_ADDED_IN_MINOR_VERSION(1)
public:
    enum Status {
        Error = -1, None, Pending, Running, Completed,
    };
    Q_ENUM(Status)

    explicit requestHandler(QObject *parent = nullptr)
        : QObject{parent}, mReply(nullptr), mRunning(false), mStatus(Status::None) {
        mNetworkManager.setAutoDeleteReplies(true);
    }

    Q_INVOKABLE bool getRequest(const QUrl &url) {
        /// TODO: Use a QReply list instead of a single QReply object.
        /// QNetworkManager should be able to handle 8 requests at a time.
        if(mReply && mReply->isRunning()) return false;

        QNetworkRequest req(url);
        req.setTransferTimeout(3000);
        mBuffer.clear();

        setStatus(Status::None);
        req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

        mReply = mNetworkManager.get(req);
        setStatus(Status::Pending);

        QObject::connect(mReply, &QNetworkReply::readyRead, this, &requestHandler::onReadyRead);
        QObject::connect(mReply, &QNetworkReply::finished, this, &requestHandler::onFinished);
        QObject::connect(mReply, &QNetworkReply::errorOccurred, this, &requestHandler::onErrorOccurred);

        return true;
    }

    Q_INVOKABLE bool postRequest(const QUrl &url, const QByteArray &body,
                                 const QVariantMap &extraHeads = QVariantMap()) {
        /// TODO: Move to another thread
        if(mReply && mReply->isRunning()) return false;

        QNetworkRequest req(url);
        req.setTransferTimeout(3000);
        mBuffer.clear();

        setStatus(Status::None);
        req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

        for(const auto &head: extraHeads.keys()) {
            req.setRawHeader(head.toLatin1(), extraHeads[head].toByteArray());
        }

        mReply = mNetworkManager.post(req, body);
        setStatus(Status::Pending);

        QObject::connect(mReply, &QNetworkReply::readyRead, this, &requestHandler::onReadyRead);
        QObject::connect(mReply, &QNetworkReply::finished, this, &requestHandler::onFinished);
        QObject::connect(mReply, &QNetworkReply::errorOccurred, this, &requestHandler::onErrorOccurred);

        return true;
    }

    bool running() const { return mRunning; }
    void setRunning(bool arunning) {
        if (mRunning == arunning) return;
        mRunning = arunning;
        emit runningChanged();
    }

    const Status& status() const { return mStatus; }
    void setStatus(const Status& newStatus) {
        if(mStatus == newStatus) return;
        mStatus = newStatus;
        emit statusChanged();
        setRunning(newStatus == Pending || newStatus == Running);
    }

private slots:
    void onReadyRead() {
        mBuffer.append(mReply->readAll());
        setStatus(Status::Running);
    }

    void onFinished() {
        mBuffer.append(mReply->readAll());
        setStatus(Status::Completed);
        emit finished(mBuffer);
        mReply = nullptr;
    }

    void onErrorOccurred(QNetworkReply::NetworkError error) {
        setStatus(Status::Error);
        emit errorOccurred(QString("Network Error (Code: %1)").arg(error));
    }

public slots:
    void abort() {
        if(mReply) mReply->abort();
        emit aborted();
        setStatus(Status::None);
    }

    void resetStatus() {
        setStatus(Status::None);
    }

signals:
    void runningChanged();
    void statusChanged();

    void errorOccurred(QString errorMessage);
    void finished(QByteArray response);
    void aborted();

private:
    QNetworkAccessManager mNetworkManager;
    QNetworkReply *mReply;
    QByteArray mBuffer;

    bool mRunning;
    Status mStatus;
};
}
