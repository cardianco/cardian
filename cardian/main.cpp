#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QFile>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    /// BUG: qnanopainter will not function properly if started with QML preview
    /// * need to add following line (maybe an OpenGL 3 bug).
    QGuiApplication::setAttribute(Qt::AA_UseSoftwareOpenGL);

    QGuiApplication app(argc, argv);

    app.setApplicationDisplayName("Cardian");
    app.setOrganizationDomain("https://smr76.github.io");
    app.setOrganizationName("smr");
    app.setApplicationName("Cardian");

    QQmlApplicationEngine engine;

    // Path to Snow White QML theme
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
