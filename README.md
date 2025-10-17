# 3Strands iPhone App

A SwiftUI application that pairs with [3Strands.co](https://3strands.co) to highlight upcoming events, accept advance pick up or delivery orders, and provide a direct “chat with us” email experience with the 3 Strands team.

## Features

- **Upcoming events** – Pulls events from the 3 Strands website (with offline-ready sample data) and lets guests browse details.
- **Order ahead** – Create pickup or delivery orders tied to a specific event, including contact details and custom items.
- **Order history** – Separates upcoming and past orders so guests can review their plans.
- **Chat with the team** – Opens the native mail composer to contact info@3strands.co with fallbacks if Mail is unavailable.

## Project structure

```
ThreeStrandsApp/
├── Features/
│   ├── Chat/
│   ├── Events/
│   └── Orders/
├── Models/
├── Resources/
├── Services/
├── Utilities/
└── ViewModels/
```

Each feature folder contains SwiftUI views specific to that area of the app. Shared data models, services, and utilities live in their respective folders.

## Getting started

1. Open the repository in Xcode 15 or later.
2. Add the `ThreeStrandsApp` folder to a new SwiftUI iOS project or set it as the project’s main source directory.
3. Ensure that `SampleEvents.json` is included in the app target so the bundled sample events are available offline and in previews.
4. Build and run the `ThreeStrandsApp` scheme on iOS 17 or later.

The app will attempt to fetch live events from the WordPress feed at `https://3strands.co/wp-json/wp/v2/events`. If the feed is unavailable, it falls back to the bundled sample events.

## Requirements

- Xcode 15+
- iOS 17+

## Notes

- Mail composer functionality requires running on a physical device or simulator configured with Mail.
- The order service currently stores orders locally. Hook it up to the production ordering system by extending `OrderService.submit` with real networking calls.
