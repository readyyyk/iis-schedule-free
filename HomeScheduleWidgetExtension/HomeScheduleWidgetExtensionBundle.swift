//
//  HomeScheduleWidgetExtensionBundle.swift
//  HomeScheduleWidgetExtension
//
//  Created by Vladislav Puzik on 14.06.2025.
//

import WidgetKit
import SwiftUI

@main   
struct HomeScheduleWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        ScheduleWidget()
        NearestLessonLockScreenWidget()
    }
}
