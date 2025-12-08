import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import qs.Common

PanelWindow {
    id: root

    property bool shouldBeVisible: false

    width: 320
    height: 360
    visible: shouldBeVisible

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell:calendar:popout"
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    // ✅ Simple anchoring - just anchor to the appropriate edge
    anchors {
        top: SettingsData.topBarPosition === "top"
        bottom: SettingsData.topBarPosition === "bottom"
        left: SettingsData.topBarPosition === "left"
        right: SettingsData.topBarPosition === "right"
    }

    // ✅ Add margins to offset from the bar
    margins {
        top: SettingsData.topBarPosition === "top" ? (SettingsData.topBarHeight + SettingsData.topBarTopMargin + 8) : 0
        bottom: SettingsData.topBarPosition === "bottom" ? (SettingsData.topBarHeight + SettingsData.topBarTopMargin + 8) : 0
        left: SettingsData.topBarPosition === "left" ? (SettingsData.topBarHeight + SettingsData.topBarLeftMargin + 8) : 0
        right: SettingsData.topBarPosition === "right" ? (SettingsData.topBarHeight + SettingsData.topBarRightMargin + 8) : 0
    }

    function toggle() { shouldBeVisible = !shouldBeVisible }
    function show()   { shouldBeVisible = true }
    function hide()   { shouldBeVisible = false }

    // Date logic
    property var today: new Date()
    property int currentYear: today.getFullYear()
    property int currentMonth: today.getMonth()
    property int currentDay: today.getDate()

    property int viewYear: currentYear
    property int viewMonth: currentMonth

    function daysInMonth(y, m)     { return new Date(y, m + 1, 0).getDate() }
    function firstWeekday(y, m)    { return new Date(y, m, 1).getDay() }

    property int firstDayOfWeek: 0
    property int firstDayOffset: {
        var fd = firstWeekday(viewYear, viewMonth)
        var x = fd - firstDayOfWeek
        return x < 0 ? x + 7 : x
    }
    property int totalDays: daysInMonth(viewYear, viewMonth)

    Rectangle {
        anchors.fill: parent
        radius: 14
        color: Theme.surfaceContainer
        border.width: 1
        border.color: Theme.outline
    }

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        Row {
            width: parent.width
            spacing: 8
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                text: "<"
                width: 32
                onClicked: {
                    viewMonth--
                    if (viewMonth < 0) { viewMonth = 11; viewYear-- }
                }
            }

            Text {
                text: {
                    const names = [
                        "January","February","March","April","May","June",
                        "July","August","September","October","November","December"
                    ]
                    return names[viewMonth] + " " + viewYear
                }
                font.pixelSize: 16
                font.bold: true
                color: Theme.surfaceText
                width: parent.width - 96
                horizontalAlignment: Text.AlignHCenter
            }

            Button {
                text: ">"
                width: 32
                onClicked: {
                    viewMonth++
                    if (viewMonth > 11) { viewMonth = 0; viewYear++ }
                }
            }
        }

        Row {
            width: parent.width
            spacing: 4

            property var dayNames: ["Su","Mo","Tu","We","Th","Fr","Sa"]

            Repeater {
                model: 7

                delegate: Text {
                    text: parent.dayNames[index]
                    font.pixelSize: 12
                    color: Theme.outlineButton
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width / 7
                }
            }
        }

        Grid {
            id: daysGrid
            columns: 7
            rowSpacing: 4
            columnSpacing: 4
            width: parent.width

            Repeater {
                model: 42

                Rectangle {
                    readonly property int dayNumber: index - root.firstDayOffset + 1
                    readonly property bool isCurrentMonthDay: dayNumber > 0 && dayNumber <= root.totalDays
                    readonly property bool isToday:
                        isCurrentMonthDay &&
                        root.viewYear === root.currentYear &&
                        root.viewMonth === root.currentMonth &&
                        dayNumber === root.currentDay

                    width: daysGrid.width / 7 - daysGrid.columnSpacing
                    height: 34
                    radius: 8

                    color: {
                        if (!isCurrentMonthDay) return "transparent"
                        if (isToday) return Theme.primary
                        return Theme.widgetBaseBackgroundColor
                    }

                    border.width: isToday ? 0 : 1
                    border.color: isToday ? "transparent" : Theme.outline

                    opacity: isCurrentMonthDay ? 1 : 0

                    Text {
                        anchors.centerIn: parent
                        text: isCurrentMonthDay ? dayNumber : ""
                        font.pixelSize: 13
                        font.bold: isToday
                        color: isToday ? Theme.onPrimary : Theme.surfaceText
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: isCurrentMonthDay
                        onClicked: {
                            root.hide()
                        }
                    }
                }
            }
        }
    }
}