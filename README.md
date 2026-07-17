# Dockge Dashboard

A Flutter dashboard client for managing Dockge stacks.

## Architecture

The application uses feature-first vertical slices:

```text
lib/
├── app/                  # App shell, routing, shared infrastructure and UI
├── features/
│   ├── auth/             # Models, services and views for authentication
│   ├── composerize/      # Docker command conversion slice
│   ├── dashboard/        # Dashboard models, services, views and widgets
│   └── stacks/           # Stack models, services, views and widgets
└── main.dart             # Bootstrap and dependency overrides
```

Feature state, business rules, data access, and UI components stay inside their owning slice. `app/` only contains application composition, navigation, the shared Dockge transport and storage infrastructure, and presentation utilities used by multiple features. Runtime visual resources use Flutter's root `assets/` convention; tool configuration remains at the project root.

Views coordinate rendering and UI-only interactions. Riverpod models own presentation state, while services own data access and reusable business operations. Untyped Socket.IO, JSON-like, and YAML values are validated before reaching views. Strict casts, inference, and raw-type checks are enabled in `analysis_options.yaml`.
