#pragma once

#include <keychain.h>
#include <QObject>
#include <QtQml>

namespace cardian::core {
using credentialReader = QKeychain::ReadPasswordJob;
using credentialWriter = QKeychain::WritePasswordJob;
using credentialRemover = QKeychain::DeletePasswordJob;

class secureKeyChain: public QObject, public QQmlParserStatus {
    Q_OBJECT
    Q_PROPERTY(QVariantMap cache READ cache NOTIFY cacheChanged FINAL)

    QML_NAMED_ELEMENT(SecureKeyChain)
    QML_ADDED_IN_MINOR_VERSION(1)
public:
    secureKeyChain(QObject *parent = nullptr): QObject(parent) {}

    void classBegin() override {}
    void componentComplete() override {
        /**
         * @abstract In this section, we connect all QML-side declared properties to the "propertyChanged()" slot.
         *  The signal names are a mix of the signal code, the property name and the "Changed()" string.
         */
        initProperties();

        int num = metaObject()->propertyCount();
        for(int i = metaObject()->propertyOffset(); i < num; ++i) {
            QMetaProperty mp = metaObject()->property(i);
            if(mp.isWritable() && !mp.isConstant()) {
                QByteArray signalName = QT_STRINGIFY(QSIGNAL_CODE) + QByteArray(mp.name()) + "Changed()";
                connect(this, signalName.constData(), this, SLOT(propertyChanged()));
            }
        }
    }

    QVariantMap cache() const { return mCache; }

public slots:
    bool writeKey(const QString &key, const QString &data) {
        /// Skip if the key is already saved
        if(mCache[key] == data) return false;

        credentialWriter *writer = new credentialWriter(service, this);
        connect(writer, &credentialWriter::finished, this, &secureKeyChain::writerFinished);

        writer->setKey(key);
        writer->setTextData(data);
        writer->setAutoDelete(true);
        writer->start();

        return true;
    }

    void removeKey(const QString &key) {
        credentialRemover *remover = new credentialRemover(service, this);

        connect(remover, &credentialRemover::finished, this, &secureKeyChain::removerFinished);

        remover->setKey(key);
        remover->setAutoDelete(true);
        remover->start();
    }

    QVariant readKey(const QString &key) {
        if(mCache.contains(key)) return mCache[key];

        credentialReader *reader = new credentialReader(service, this);
        connect(reader, &credentialReader::finished, this, &secureKeyChain::readerFinished);

        reader->setKey(key);
        reader->setAutoDelete(true);
        reader->start();

        return QVariant{}; /// Return undefined
    }

    void setKeyToProperty(const QString &key) {
        readKey(key);
        connect(this, &secureKeyChain::keyRestored, this, [&](const QString& key, const QString& value){
            setProperty(key.toLatin1(), value);
        });
    }

private slots:
    void propertyChanged() {
        QMetaMethod metaMethod = sender()->metaObject()->method(senderSignalIndex());
        QByteArray name = metaMethod.name().chopped(7);
        QVariant prop = property(name.constData());

#if QT_VERSION_MAJOR < 6
        bool isString = prop.type() == QVariant::String;
#else
        bool isString = prop.typeId() == QMetaType::User;
#endif
        if(isString) writeKey(name, prop.toString());
    }

    void initProperties() {
        /// @brief Initialize properties with keys data, if keys are exist.
        int num = metaObject()->propertyCount();
        for(int i = metaObject()->propertyOffset(); i < num; ++i) {
            QMetaProperty mp = metaObject()->property(i);

            if(!mp.isConstant() && mp.isWritable()) {
                setKeyToProperty(mp.name());
            }
        }
    }

    void writerFinished() {
        credentialWriter *writer = qobject_cast<credentialWriter *>(QObject::sender());
        QString key = writer->key();

        if(writer->error()) emit error(tr("Writing key{%1} failed: %2").arg(key, writer->errorString()));
        else emit keyStored(key);
        writer->deleteLater();
    }

    void readerFinished() {
        credentialReader *reader = qobject_cast<credentialReader *>(QObject::sender());
        QString key = reader->key();

        if(reader->error()) emit error(tr("Reading key{%1} failed: %2").arg(key, reader->errorString()));
        else {
            emit keyRestored(key, reader->textData());

            mCache[key] = reader->textData();
            emit cacheChanged();
        }
        reader->deleteLater();
    }

    void removerFinished() {
        credentialRemover *remover = qobject_cast<credentialRemover *>(QObject::sender());
        QString key = remover->key();

        if(remover->error()) emit error(tr("Removing key failed: %1").arg(qPrintable(remover->errorString())));
        else {
            emit keyRemoved(key);

            mCache.remove(key);
            emit cacheChanged();
        }
        remover->deleteLater();
    }

signals:
    void keyStored(const QString& key);
    void keyRestored(const QString& key, const QString& value);
    void keyRemoved(const QString& key);
    void error(const QString& errorText);
    void cacheChanged();

private:
    const QString service = QLatin1String("cardian.app.keystore");
    QVariantMap mCache;
};
}
