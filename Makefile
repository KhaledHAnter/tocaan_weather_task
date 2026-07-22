.PHONY: l10n
l10n:
	dart run easy_localization:generate -S assets/lang -f keys -O lib/generated -o locale_keys.g.dart && make format

.PHONY: codegen
codegen:
	dart run build_runner build --delete-conflicting-outputs && make format

.PHONY: app-icons
app-icons:
	dart run flutter_launcher_icons

.PHONY: app-splash
app-splash:
	dart run flutter_native_splash:create

.PHONY: apk
apk:
	flutter build apk --release

.PHONY: appbundle
appbundle:
	flutter build appbundle --release

.PHONY: ios
ios:
	flutter build ipa --release

.PHONY: format
format:
	dart format lib test --set-exit-if-changed && flutter analyze

.PHONY: lint
lint:
	dart run custom_lint

.PHONY: check
check: format lint

.PHONY: test
test:
	flutter test

.PHONY: clean
clean:
	flutter clean ; flutter pub get

.PHONY: pods
pods:
	cd ios ; pod install ; cd ..
