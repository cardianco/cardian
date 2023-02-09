import QtQuick 2.15
import QtQuick.Templates 2.15 as T

T.StackView {
    id: control
    topPadding: 5

    component TAnim: PropertyAnimation { property: "opacity"; to: sqa.op; duration: 300 }

    replaceEnter: Transition { TAnim { to:1 } }
    replaceExit: Transition { TAnim { to:0 } }
}
