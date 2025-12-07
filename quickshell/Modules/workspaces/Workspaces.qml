import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import Quickshell 1.0

Item {
    id: root
    height: 36

    property var wsData: Quickshell.readJson("~/.config/quickshell/cache/workspaces.json")
    property var currentWorkspace: Hyprland.activeWorkspace
    property var openWindows: Hyprland.windows

    RowLayout {
        anchors.fill: parent
        spacing: 5

        Repeater {
            model: 30   // Support up to 3 monitors * 10 workspaces
            delegate: Rectangle {
                visible: modelData + 1 <= wsData.monitors.length * 10

                width: 36
                height: 28
                radius: 6

                color: (currentWorkspace == modelData + 1)
                    ? "#ffffff20"
                    : "#00000050"

                border.width: (currentWorkspace == modelData + 1) ? 2 : 1
                border.color: "#ffffff40"

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 4

                    // Show icons of windows assigned to this workspace
                    Repeater {
                        model: openWindows.filter(w => w.workspace.id === modelData + 1)

                        delegate: Image {
                            source: Hyprland.iconForApp(model.app)
                            width: 14
                            height: 14
                            fillMode: Image.PreserveAspectFit
                        }
                    }

                    // Workspace number
                    Text {
                        text: (modelData + 1)
                        font.pixelSize: 12
                        color: "white"
                        opacity: 0.8
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + (modelData + 1))
                }
            }
        }
    }
}
