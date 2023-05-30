import QtQuick 2.15
import QtQuick.Templates 2.15 as T

T.StackView {
    id: control
    topPadding: 5

    component OpacityAnim: OpacityAnimator { to: 0; duration: 300 }

    replaceEnter: Transition { OpacityAnim { to: 1 } }
    replaceExit: Transition { OpacityAnim { to: 0 } }
}
