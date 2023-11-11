#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>

int main(int argc, char *argv[]) {
#if QT_VERSION_MAJOR < 6
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
#ifndef QT_NO_DEBUG
    /// BUG: qnanopainter will not function properly if started with QML preview
    /// * need to add following line (maybe an OpenGL 3 bug).
    QGuiApplication::setAttribute(Qt::AA_UseSoftwareOpenGL);
#endif

#ifdef Q_OS_ANDROID
    qputenv("QT_SCALE_FACTOR", "1.3");
#endif

    QGuiApplication app(argc, argv);

    app.setApplicationDisplayName("Cardian");
    app.setOrganizationDomain("https://smr.best");
    app.setOrganizationName("smr");
    app.setApplicationName("Cardian");
    app.setWindowIcon(QIcon("qrc:/resources/logo.ico"));

    QQmlApplicationEngine engine;

    // Path to Hive QtQuick Controls style
    engine.addImportPath("qrc:/");

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
