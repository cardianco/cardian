#pragma once

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QObject>
#include <QtCore>

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>

#include <QDir>

#include <unordered_map>

namespace cardian::core {
/// @ref https://www.kdab.com/qt-range-based-for-loops-and-structured-bindings/
template <typename T> class QKVRange {
public:
    QKVRange(T &data) : mData{data} {}
    auto begin() { return mData.keyValueBegin(); }
    auto end() { return mData.keyValueEnd(); }

private:
    T &mData;
};
}

namespace cardian::network {
struct replyData {
    uint64_t id;
    QByteArray data;
};

class requestHandler : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantMap running READ running NOTIFY runningChanged FINAL)

    QML_NAMED_ELEMENT(RequestHandler)
    QML_ADDED_IN_MINOR_VERSION(1)
public:
    explicit requestHandler(QObject *parent = nullptr)
        : QObject{parent}, mNum{0} {
        mNetworkManager.setAutoDeleteReplies(true);
    }

    Q_INVOKABLE int getRequest(const QUrl &url) {
        /// TODO: Use a QReply list instead of a single QReply object.
        /// QNetworkManager should be able to handle 8 requests at a time.

        QNetworkRequest req(url);
        req.setTransferTimeout(3000);

        req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

        QNetworkReply *reply = mNetworkManager.get(req);
        mRequestHash[reply].id = ++mNum;

        QObject::connect(reply, &QNetworkReply::readyRead, this, &requestHandler::onReadyRead);
        QObject::connect(reply, &QNetworkReply::finished, this, &requestHandler::onFinished);
        QObject::connect(reply, &QNetworkReply::errorOccurred, this, &requestHandler::onErrorOccurred);

        return mNum;
    }

    Q_INVOKABLE int postRequest(const QUrl &url, const QByteArray &body,
                                 const QVariantMap &extraHeads = QVariantMap(),
                                 int timeout = QNetworkRequest::DefaultTransferTimeoutConstant) {
        /// TODO: Move to another thread
        QNetworkRequest req(url);
        req.setTransferTimeout(timeout);
        req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

        for(const auto &head: core::QKVRange(extraHeads)) {
            req.setRawHeader(head.first.toLatin1(), extraHeads[head.first].toByteArray());
        }

        QNetworkReply *reply = mNetworkManager.post(req, body);
        mRequestHash[reply].id = ++mNum;

        emit runningChanged();

        QObject::connect(reply, &QNetworkReply::readyRead, this, &requestHandler::onReadyRead);
        QObject::connect(reply, &QNetworkReply::finished, this, &requestHandler::onFinished);
        QObject::connect(reply, &QNetworkReply::errorOccurred, this, &requestHandler::onErrorOccurred);

        return mNum;
    }

    QVariantMap running() const {
        QVariantMap map;

        for(const auto &reply: core::QKVRange(mRequestHash)) {
            map[QString::number(reply.second.id)] = reply.first->isRunning();
        }

        return map;
    }

private slots:
    void onReadyRead() {
        QNetworkReply *reply = qobject_cast<QNetworkReply *>(QObject::sender());
        mRequestHash[reply].data.append(reply->readAll());
    }

    void onFinished() {
        QNetworkReply *reply = qobject_cast<QNetworkReply *>(QObject::sender());
        QByteArray buffer = reply->readAll();
        mRequestHash[reply].data.append(buffer);

        emit finished(mRequestHash[reply].data, mRequestHash[reply].id);
        mRequestHash.remove(reply);
        emit runningChanged();
    }

    void onErrorOccurred(QNetworkReply::NetworkError error) {
        QNetworkReply *reply = qobject_cast<QNetworkReply *>(QObject::sender());

        emit errorOccurred(QString("Network Error (Code: %1)").arg(error), mRequestHash[reply].id);
        mRequestHash.remove(reply);
        emit runningChanged();
    }

public slots:
    void abortAll() {
        for(const auto &reply: core::QKVRange(mRequestHash)) {
            emit aborted(reply.second.id);
            reply.first->abort();
        }
        mRequestHash.clear();
    }

signals:
    void runningChanged();
    void errorOccurred(QString errorMessage, int id);
    void finished(QByteArray response, int id);
    void aborted(int id);

private:
    QNetworkAccessManager mNetworkManager;
    QHash<QNetworkReply *, replyData> mRequestHash;

    int mNum;
};
}
