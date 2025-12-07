import QtQuick 2.15
import QtQuick.Controls 2.15
import "../.."  // access Common/SettingsData.qml

Item {
    id: root
    property string widgetId

    // Load saved position (fallback 100,100)
    x: SettingsData.getWidgetX(widgetId)
    y: SettingsData.getWidgetY(widgetId)

    width: childrenRect.width
    height: childrenRect.height

    DragHandler {
        id: dragger
        target: root
        onActiveChanged: {
            if (!active) {
                SettingsData.setWidgetPosition(widgetId, root.x, root.y)
                SettingsData.saveSettings()
            }
        }
    }

    // DarkMatter blur + shadow visuals
    Rectangle {
        anchors.fill: parent
        radius: 22
        color: Qt.rgba(0,0,0,0.20)
        border.color: Qt.rgba(1,1,1,0.15)
        border.width: 1

        layer.enabled: true
        layer.effect: DropShadow {
            radius: 24
            samples: 32
            color: "#00000055"
            spread: 0.25
        }
    }

    // Real widget inserted from DesktopWidgets.qml
}
