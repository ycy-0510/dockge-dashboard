# Dockge Dashboard

A Flutter dashboard client for managing Dockge stacks.

## Architecture

The application uses a layered structure:

- `lib/data`: Dockge Socket.IO services, wire DTO validation, YAML parsers, and repository implementations.
- `lib/domain`: immutable application models, repository contracts, and reusable use cases.
- `lib/ui`: Riverpod view models, feature views, shared presentation state, and theme utilities.
- `lib/core`: low-level connection, storage, and cross-layer infrastructure.

All untyped Socket.IO, JSON-like, and YAML values are validated at the data boundary before they reach domain or UI code. Strict casts, inference, and raw-type checks are enabled in `analysis_options.yaml`.
