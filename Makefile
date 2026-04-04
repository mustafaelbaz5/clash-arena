# ─────────────────────────────────────────────────────────────────────────────
# Makefile — Project Commands
# Usage: make <command>
# Requires: make installed (Windows: choco install make)
# ─────────────────────────────────────────────────────────────────────────────


# ─── Setup ───────────────────────────────────────────────────────────────────
## Install all dependencies
install:
	flutter pub get

## Check outdated and upgrade all packages
update:
	flutter pub outdated
	flutter pub upgrade
	flutter pub upgrade --major-versions

## Run code generation (build_runner) once
generate:
	dart run build_runner build --delete-conflicting-outputs

## Run code generation in watch mode (auto-regenerates on file change)
watch:
	dart run build_runner watch --delete-conflicting-outputs

## Clean project and reinstall dependencies
clean:
	flutter clean && flutter pub get


# ─── Run ─────────────────────────────────────────────────────────────────────

## Run app in development flavor
dev:
	flutter run --flavor development --target lib/main_dev.dart

## Run app in production flavor
prod:
	flutter run --flavor production --target lib/main_prod.dart


# ─── Testing ─────────────────────────────────────────────────────────────────

## Run all tests
test:
	flutter test

## Run all tests with verbose output (shows each test name)
test-verbose:
	flutter test --reporter expanded

## Run all tests with coverage report
test-coverage:
	flutter test --coverage

## Run core layer tests only
test-core:
	flutter test test/core/

## Run features tests only
test-features:
	flutter test test/features/

## Run a specific test file — usage: make test-file FILE=test/core/utils/validators_test.dart
test-file:
	flutter test $(FILE)


# ─── Code Quality ────────────────────────────────────────────────────────────

## Analyze code for warnings and errors
analyze:
	flutter analyze

## Format all dart files in lib/ and test/
format:
	dart format lib/ test/

## Check formatting without applying changes
format-check:
	dart format lib/ test/ --set-exit-if-changed


# ─── Build ───────────────────────────────────────────────────────────────────

## Build debug APK (development)
build-apk-dev:
	flutter build apk --debug --flavor development --target lib/main_dev.dart

## Build release APK (production)
build-apk-prod:
	flutter build apk --release --flavor production --target lib/main_prod.dart --no-tree-shake-icons

## Build release AAB (production) — for Play Store
build-aab-prod:
	flutter build appbundle --release --flavor production --target lib/main_prod.dart --no-tree-shake-icons

## Build release IPA (iOS production)
build-ios-prod:
	flutter build ipa --flavor production --target lib/main_prod.dart


# ─── Distribution ────────────────────────────────────────────────────────────

## Distribute production APK to Firebase App Distribution via Fastlane
distribute-firebase:
	cd android && bundle exec fastlane android release_to_firebase


# ─── Localization ─────────────────────────────────────────────────────────────

## Generate localization files
l10n:
	flutter gen-l10n


# ─── Help ────────────────────────────────────────────────────────────────────

## Show all available commands
help:
	@echo ""
	@echo "Available commands:"
	@echo ""
	@grep -E '^##' Makefile | sed 's/## /  /'
	@echo ""