# Project Plan: BSUIR Schedule Widget App

## 1. Requirements & Goals
- **Purpose:**
  - Provide iPhone lockscreen widget with info about the nearest lesson today.
  - Provide home screen widget with today's schedule.
  - Minimal in-app interface to view the schedule.
- **Target Platform:** iOS (latest version, with WidgetKit support)
- **Users:** BSUIR students.
- **Data Source:** https://iis.bsuir.by public API (see `api-description.md`)
- **Schedule Specifics:**
  - The schedule repeats every 4 weeks (4-week cycle). All schedule logic must account for this cycle when determining the current day's lessons and the next lesson.

## 2. Feature List
- **Lockscreen Widget:**
  - Shows the next (nearest) lesson for today, taking into account the 4-week cycle.
  - Updates automatically as time passes.
- **Home Screen Widget:**
  - Shows the full schedule for today, based on the current week in the 4-week cycle.
  - Tap to open the app for more details.
- **Minimal App UI:**
  - Simple list of today's schedule, calculated for the current week in the 4-week cycle.
  - Option to view full week and navigate between weeks.
  - Settings: select group.
- **Onboarding:**
  - First launch: select group.
- **Caching:**
  - Store schedule locally for offline use.
- **Background Updates:**
  - Fetch new data periodically.

## 3. Technical Stack
- **Language:** Swift
- **Frameworks:**
  - SwiftUI (UI)
  - WidgetKit (widgets)
  - URLSession (networking)
  - Combine (reactive updates)
  - Codable (JSON parsing)
  - UserDefaults/CoreData (local storage)

## 4. API Integration
- **Endpoints to Use:**
  - Get group schedule: `/api/v1/schedule?studentGroup={groupNumber}`
  - Get all groups: `/api/v1/student-groups`
  - Get teacher schedule: `/api/v1/employees/schedule/{urlId}`
  - Get all teachers: `/api/v1/employees/all`
  - Get current week: `/api/v1/schedule/current-week` (use to determine the current week in the 4-week cycle)
- **Networking Layer:**
  - Create a service to fetch and parse schedule data.
  - Handle errors, retries, and offline mode.
- **Data Models:**
  - Map JSON to Swift structs (Codable).
  - **Model the 4-week cycle:** Each lesson has a `weekNumber` array; use this to determine if a lesson is scheduled for the current week.

## 5. App Architecture
- **MVVM (Model-View-ViewModel)**
- **Shared code between app and widgets (using App Groups for data sharing).**
- **Schedule Logic:**
  - Centralize logic for determining today's lessons and the next lesson, based on the current week in the 4-week cycle.

## 6. Widget Development
- **Lockscreen Widget:**
  - Smallest size, shows next lesson (subject, time, location) for today, considering the 4-week cycle.
  - Timeline provider for updating as time passes and as the week changes.
- **Home Screen Widget:**
  - Medium size: list of today's lessons (2x2), filtered by the current week in the 4-week cycle.
  - Tap to open app.
- **Widget Data Source:**
  - Use shared storage (App Group) for schedule data.
  - Background refresh to keep data up to date and to update the week number.

## 7. UI/UX Design
- **Minimal, clean design.**
- **Only dark mode support.**
- **Onboarding flow:**
  - Group selection.
- **Settings:**
  - Change group, manual refresh.
- **Schedule Navigation:**
  - Allow users to view the schedule for any week (considering the 4-week cycle).

## 8. Local Storage & Caching
- **Store last fetched schedule in App Group container.**
- **Cache current week number and date of retrieval.**
- **Invalidate cache on schedule update, user request, or week change.**

## 9. Milestones & Timeline
1. Project setup, API integration, data models (1 week)
   - Ensure data models and logic support the 4-week cycle.
2. Minimal app UI (1 week)
   - Display schedule for today and allow navigation by week in the 4-week cycle.
3. WidgetKit integration: lockscreen widget (1 week)
   - Show next lesson for today, considering the 4-week cycle.
4. Home screen widget (1 week)
   - Show today's schedule for the current week in the cycle.
5. Onboarding & settings (1 week)
6. Caching, background updates (1 week)

---
This plan provides a step-by-step guide to building the BSUIR schedule widget app, from requirements to App Store release, with full support for the 4-week repeating schedule cycle. 
