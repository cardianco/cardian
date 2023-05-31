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
    QML_SINGLETON
    QML_NAMED_ELEMENT(EventModel)
    QML_ADDED_IN_MINOR_VERSION(1)
public:
    enum Roles { EId = Qt::UserRole + 1, EUTC, EType, ETitle, EText };

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
        if(index && index < mEventList.count()) {
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
    void pushFront(const QString &text, const QString &title = "", long long utc = 0, int type = 0) {
        pushFront(mEventList.count(), text, title, utc, type);
    }

    void pushFront(long long id, const QString &text, const QString &title = "", long long utc = 0, int type = 0) {
        beginInsertRows(QModelIndex(), 0, 0);
        mEventList.append({id, utc, type, text, title});
        endInsertRows();
    }

private:
    QList<eventData> mEventList;
};
}
