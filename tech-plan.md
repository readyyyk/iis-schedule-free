# Technical Plan Usage Guide

✅ Tasks are checked off as they are completed in code.

This document breaks down the app into features, each with actionable tasks, important notes ("Dont forget"), and manual check steps. Use it to:
- Track development progress by checking off tasks.
- Reference important implementation details and reminders.
- Manually verify each feature after implementation using the provided checklists.

---

## Feature 1: API Integration & Data Models

### Tasks

1. [x] Set up networking layer using URLSession and Combine
2. [x] Implement API calls for:
    - Get group schedule
    - Get all groups
    - Get current week
3. [x] Define Codable data models for all relevant API responses
4. [ ] Implement error handling and retries

### Dont forget

- Map the 4-week cycle logic using `weekNumber` arrays in lessons
- Handle offline mode and API errors gracefully
- Use background threads for network calls

### How to check manually?

1. Run the app and select a group
2. Check if schedule loads and matches the web version
3. Turn off internet and verify offline handling

---

## Feature 2: Local Storage & Caching

### Tasks

1. [ ] Set up App Group container for shared storage
2. [ ] Implement caching of schedule and current week data
3. [ ] Invalidate cache on schedule update, user request, or week change
4. [ ] Store last fetch date and week number

### Dont forget

- Use UserDefaults or CoreData as appropriate
- Ensure widgets and app share the same cache
- Handle cache invalidation on week change

### How to check manually?

1. Fetch schedule, then go offline
2. Relaunch app and widgets, verify data is shown from cache
3. Change week, verify cache updates

---

## Feature 3: Minimal App UI (SwiftUI)

### Tasks

1. [x] Create onboarding flow for group selection
    - [x] Add full-text search for group selection (search bar, case-insensitive)
2. [ ] Implement main screen: today's schedule
3. [ ] Add week navigation (4-week cycle)
4. [ ] Add settings screen (change group, manual refresh)
5. [ ] Implement error and empty states
6. [ ] Support only dark mode

### Dont forget

- Use MVVM architecture
- Centralize schedule logic for week/day filtering
- Keep UI minimal and clean

### How to check manually?

1. Launch app, complete onboarding
2. View today's schedule, navigate weeks
3. Change group in settings, verify update

---

## Feature 4: Lockscreen Widget (WidgetKit)

### Tasks

1. [ ] Set up WidgetKit extension
2. [ ] Implement timeline provider for next lesson logic
3. [ ] Display next lesson info (subject, time, location)
4. [ ] Use App Group to read cached schedule
5. [ ] Handle widget updates as time passes and week changes

### Dont forget

- Filter lessons by current day and week in 4-week cycle
- Optimize for smallest widget size
- Test timeline updates

### How to check manually?

1. Add lockscreen widget
2. Check next lesson info updates as time passes
3. Change week/group, verify widget updates

---

## Feature 5: Home Screen Widget (WidgetKit)

### Tasks

1. [ ] Implement medium-size widget for today's schedule
2. [ ] List all lessons for today, filtered by current week
3. [ ] Add tap action to open app
4. [ ] Use App Group for data
5. [ ] Handle background refresh

### Dont forget

- Match widget design to app UI
- Ensure data is up to date with background refresh
- Handle empty/holiday days

### How to check manually?

1. Add home screen widget
2. Verify today's schedule is shown
3. Tap widget, check app opens

---

## Feature 6: Background Updates

### Tasks

1. [ ] Implement background fetch for schedule and week number
2. [ ] Schedule periodic updates for widgets and app
3. [ ] Handle iOS background task limitations
4. [ ] Test update triggers (time, week change)

### Dont forget

- Use BGTaskScheduler for background fetch
- Respect iOS background execution limits
- Ensure widgets refresh after data update

### How to check manually?

1. Wait for scheduled background update
2. Check if app and widgets show fresh data
3. Manually trigger update in settings, verify result 
