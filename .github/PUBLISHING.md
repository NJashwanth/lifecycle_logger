# Publishing Guide (Maintainers)

This project publishes to pub.dev from GitHub Actions.

## Workflow

- Workflow file: `.github/workflows/publish.yml`
- Trigger: push to `main` (and manual `workflow_dispatch`)
- Checks before publish:
  - `flutter pub get`
  - `flutter analyze`
  - `flutter test`
- Publish behavior:
  - Reads `name` and `version` from `pubspec.yaml`
  - Skips publish if that exact version already exists on pub.dev
  - Publishes with `dart pub publish --force` when version is new

## One-time setup on pub.dev

1. Open package admin page:
   - `https://pub.dev/packages/lifecycle_logger/admin`
2. Enable publishing from GitHub Actions.
3. Set repository to:
   - `NJashwanth/lifecycle_logger`
4. Enable publishing from push events.
5. Optional: enable `workflow_dispatch` publishing.
6. Do not enable Google Cloud service account unless you specifically need that flow.

## One-time setup in GitHub

- Ensure workflow has:
  - `permissions.id-token: write`
- Ensure branch protection allows workflow to run on `main` pushes.

## Release process

1. Update `version:` in `pubspec.yaml`.
2. Update `CHANGELOG.md`.
3. Merge to `main`.
4. Verify workflow run in GitHub Actions.
5. Confirm new version appears on pub.dev.

## Troubleshooting

- "Version already exists" behavior is expected; bump `version:` and push again.
- If pub.dev rejects publishing permissions, re-check trusted publisher settings on the package admin page.
- If checks fail (`analyze`/`test`), fix locally and push again.
