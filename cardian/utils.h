#pragma once

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QObject>
#include <QtCore>

#include <QJsonDocument>
#include <QVariant>
#include <QFile>

namespace caralarm::core {
class utils : public QObject {
    Q_OBJECT
    QML_SINGLETON
    QML_NAMED_ELEMENT(Utils)
    QML_ADDED_IN_MINOR_VERSION(1)
public:
    explicit utils(QObject *parent = nullptr);

    /**
     * @brief readJsonFile
     *  This method reads a json file and returns it as a variation.
     * @param url File url.
     * @return QVariant (javascript object)
     */
    Q_INVOKABLE QVariant readJsonFile(const QUrl &url) const {
        QFile file(url.path());

        if(file.open(QFile::ReadOnly)) {
            QJsonParseError error;
            QJsonDocument doc = QJsonDocument::fromJson(file.readAll(), &error);
            file.close();

            if(error.error == QJsonParseError::NoError) {
                return doc.toVariant();
            }
        }

        return QJsonValue::Undefined;
    }

    /**
     * @brief readJsonFileProperty
     *  This method reads a json property from a file and returns it as a variation.
     * @param url File url
     * @param property
     * @return QVariant (javascript object)
     */
    Q_INVOKABLE QVariant readJsonFileProperty(const QUrl &url, const QString &property) const {
        static QRegularExpression regex("(\\[|\\]|\\.)"); // static clazy
        QFile file(url.path());

        if(file.open(QFile::ReadOnly)) {
            QJsonParseError error;
            QJsonDocument doc = QJsonDocument::fromJson(file.readAll(), &error);
            file.close();

            QStringList properties = property.split(regex, Qt::SkipEmptyParts);
            QJsonValue jsonValue = doc.object();

            for(const auto &property : properties) {
                if(jsonValue.isUndefined()) {
                    return QJsonValue::Undefined;
                }
                if(property.length() && property[0].isDigit()) { // if it's array index
                    jsonValue = jsonValue[property.toLongLong()];
                } else { // if it's property
                    jsonValue = jsonValue[property];
                }
            }

            return jsonValue.toVariant();
        }

        return QJsonValue::Undefined;
    }

public slots:
    /**
     * @brief setApplicationLocale
     *  Set application custom locale.
     * @param locale
     */
    void setApplicationLocale(const QString &locale = "c") {
        QLocale::setDefault(QLocale(locale));
    }
signals:

};
}

