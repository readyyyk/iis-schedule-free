//
//  HomeScheduleWidgetExtensionLiveActivity.swift
//  HomeScheduleWidgetExtension
//
//  Created by Vladislav Puzik on 14.06.2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct HomeScheduleWidgetExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct HomeScheduleWidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HomeScheduleWidgetExtensionAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension HomeScheduleWidgetExtensionAttributes {
    fileprivate static var preview: HomeScheduleWidgetExtensionAttributes {
        HomeScheduleWidgetExtensionAttributes(name: "World")
    }
}

extension HomeScheduleWidgetExtensionAttributes.ContentState {
    fileprivate static var smiley: HomeScheduleWidgetExtensionAttributes.ContentState {
        HomeScheduleWidgetExtensionAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: HomeScheduleWidgetExtensionAttributes.ContentState {
         HomeScheduleWidgetExtensionAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: HomeScheduleWidgetExtensionAttributes.preview) {
   HomeScheduleWidgetExtensionLiveActivity()
} contentStates: {
    HomeScheduleWidgetExtensionAttributes.ContentState.smiley
    HomeScheduleWidgetExtensionAttributes.ContentState.starEyes
}
