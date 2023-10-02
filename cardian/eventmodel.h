#pragma once

#include <QtQml>
#include <QtCore>
#include <QObject>
#include <QAbstractItemModel>
#include <QHash>

namespace cardian::models {
struct eventData {
    long long id, utc;
    int type;
    QString title, text;
};

class eventListModel: public QAbstractListModel {
    Q_OBJECT
    QML_NAMED_ELEMENT(EventModel)
    QML_ADDED_IN_MINOR_VERSION(1)
public:
    enum Roles { EId = Qt::UserRole + 1, EUTC, EType, ETitle, EText };

    /**
     * @brief get
     * @param index
     * @return Data at index `index` as QVariant.
     */
    Q_INVOKABLE QVariant get(int index) const {
        const auto &data = mEventList.at(index);
        return QVariantMap{
            {"id",    data.id   },
            {"utc",   data.utc  },
            {"type",  data.type },
            {"title", data.title},
            {"text",  data.text },
        };
    }

    /**
     * @brief first
     * @return First item or undefined.
     */
    Q_INVOKABLE QVariant first() const {
        return mEventList.empty() ? QVariant{} : get(0);
    }

    /**
     * @brief last
     * @return Last item or undefined.
     */
    Q_INVOKABLE QVariant last() const {
        return mEventList.empty() ?
                   QVariant{} : get(mEventList.count() - 1);
    }

    int rowCount(const QModelIndex & parent) const override {
        Q_UNUSED(parent)
        return mEventList.count();
    }

    QHash<int, QByteArray> roleNames() const override {
        return {
            {EId,    "id"   }, {EUTC,   "utc"  },
            {EType,  "type" }, {ETitle, "title"},
            {EText,  "text" }
        };
    }

    QVariant data(const QModelIndex & mindex, int role) const override {
        const auto &index = mindex.row();
        if(0 <= index && index < mEventList.count()) {
            const auto &data = mEventList[index];
            switch (role) {
                case Roles::EId:    return data.id;
                case Roles::EUTC:   return data.utc;
                case Roles::EType:  return data.type;
                case Roles::ETitle: return data.title;
                case Roles::EText:  return data.text;
            }
        }
        return QVariant{};
    }

public slots:
    void clear() {
        beginRemoveRows(QModelIndex(), 0, mEventList.count() - 1);
        mEventList.clear();
        endRemoveRows();
    }

    void prepend(const QString &text, const QString &title = "", long long utc = 0, int type = 0) {
        prepend(mEventList.count(), text, title, utc, type);
    }

    void prepend(long long id, const QString &text, const QString &title = "", long long utc = 0, int type = 0) {
        beginInsertRows(QModelIndex(), 0, 0);
        mEventList.append({id, utc, type, text, title});
        endInsertRows();
    }

    void append(const QString &text, const QString &title = "", long long utc = 0, int type = 0) {
        append(mEventList.count(), text, title, utc, type);
    }

    void append(long long id, const QString &text, const QString &title = "", long long utc = 0, int type = 0) {
        beginInsertRows(QModelIndex(), mEventList.count(), mEventList.count());
        mEventList.append({id, utc, type, text, title});
        endInsertRows();
    }

private:
    QList<eventData> mEventList;
};
}
