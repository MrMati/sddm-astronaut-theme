// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2024 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: sessionButton
    height: root.font.pointSize
    width: parent.width / 3
    anchors.horizontalCenter: parent.horizontalCenter

    property var selectedSession: selectSession.currentIndex
    property string textConstantSession
    property int loginButtonWidth
    property ComboBox exposeSession: selectSession

    ComboBox {
        id: selectSession
        // important
        // change also in errorMessage
        height: root.font.pointSize * 2
        hoverEnabled: true
        anchors.top: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        Keys.onPressed: {
            if (event.key == Qt.Key_Up && loginButton.state != "enabled" && !popup.opened)
                revealSecret.focus = true,
                revealSecret.state = "focused",
                currentIndex = currentIndex + 1;
            if (event.key == Qt.Key_Up && loginButton.state == "enabled" && !popup.opened)
                loginButton.focus = true,
                loginButton.state = "focused",
                currentIndex = currentIndex + 1;
            if (event.key == Qt.Key_Down && !popup.opened)
                systemButtons.children[0].focus = true,
                systemButtons.children[0].state = "focused",
                currentIndex = currentIndex - 1;
            if ((event.key == Qt.Key_Left || event.key == Qt.Key_Right) && !popup.opened)
                popup.open();
        }

        model: sessionModel
        currentIndex: model.lastIndex
        textRole: "name"

        delegate: ItemDelegate {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            contentItem: Text {
                text: model.name
                font.pointSize: root.font.pointSize * 0.8
                font.family: root.font.family
                color: selectSession.highlightedIndex === index ? root.palette.highlight.hslLightness >= 0.7 ? "#444444" : "white" : root.palette.window.hslLightness >= 0.8 ? root.palette.highlight.hslLightness >= 0.8 ? "#444444" : root.palette.highlight : "white"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            highlighted: parent.highlightedIndex === index
            background: Rectangle {
                color: selectSession.highlightedIndex === index ? root.palette.highlight : "transparent"
                opacity: selectSession.highlightedIndex === index ? 0.8 : 0.4
            }

        }

        indicator {
            visible: false
        }


        contentItem: Text {
            id: displayedItem
            text: (config.TranslateSessionSelection || "Session") + " (" + selectSession.currentText + ")"
            color: root.palette.text
            verticalAlignment: Text.AlignVCenter
            font.pointSize: root.font.pointSize * 0.9
            font.family: root.font.family
            Keys.onReleased: parent.popup.open()
        }

        background: Rectangle {
            id: contentBg
            color: root.palette.alternateBase
            opacity: 0.4
            border.width: parent.visualFocus ? 1 : 0
            border.color: root.palette.alternateBase
            height:  displayedItem.implicitHeight * 1.5
            width: displayedItem.implicitWidth * 1.5
            anchors.centerIn: displayedItem
            radius: config.RoundCorners || 0
        }


        popup: Popup {
            id: popupHandler
            y: parent.height + 20
            x: -parent.x

            width: sessionButton.width
            y: parent.height - 1
            x:  -popupHandler.width/2 + displayedItem.width/2
            // x: config.RightToLeftLayout == "true" ? -loginButtonWidth + displayedItem.width : 0
            implicitHeight: contentItem.implicitHeight
            padding: 10

            contentItem: ListView {
                verticalLayoutDirection: ListView.BottomToTop
                clip: true
                implicitHeight: contentHeight + 20
                model: selectSession.popup.visible ? selectSession.delegateModel : null
                currentIndex: selectSession.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }

            background: Rectangle {
                radius: config.RoundCorners / 2
                color: root.palette.alternateBase
                opacity: 0.4
                layer.enabled: true
            }

            enter: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1 }
            }
            exit: Transition {
                NumberAnimation { property: "opacity"; from: 1; to: 0 }
            }
        }

        states: [
            State {
                name: "pressed"
                when: selectSession.down
                PropertyChanges {
                    //target: displayedItem
                    //color: Qt.darker(root.palette.toolTipBase, 1.1)
                    target: contentBg
                    opacity: 0.8
                }
                PropertyChanges {
                    target: selectSession.background
                    border.color: Qt.darker(root.palette.toolTipBase, 1.1)
                }
            },
            State {
                name: "hovered"
                when: selectSession.hovered
                PropertyChanges {
                    //target: displayedItem
                    //color: Qt.lighter(root.palette.toolTipBase, 1.1)
                    target: contentBg
                    opacity: 0.8
                }
                PropertyChanges {
                    target: selectSession.background
                    border.color: Qt.lighter(root.palette.toolTipBase, 1.1)
                }
            },
            State {
                name: "focused"
                when: selectSession.visualFocus
                PropertyChanges {
                    //target: displayedItem
                    //color: root.palette.toolTipBase
                    target: contentBg
                    opacity: 0.8
                }
                PropertyChanges {
                    target: selectSession.background
                    border.color: root.palette.toolTipBase
                }
            }
        ]

        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color, border.color"
                    duration: 150
                }
            }
        ]

    }
}
