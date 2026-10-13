# Loving Brain — Master Engineering & Coding Standards

This document establishes the definitive coding, architecture, and workflow rules for **Loving Brain (V2)**. Any code written for this project must look, feel, and function exactly as if written by the primary author. Consistency, precision, and adherence to established patterns are mandatory.

---

## 1. Environment & Tooling Prerequisites

- **Flutter SDK Path:** Always invoke Flutter and Dart commands using the project-configured Flutter 3.47 SDK:
  ```bash
  /Users/imac/Documents/flutter_versions/flutter_3_47/bin/flutter <command>
  ```
  *(Never use the global system `flutter` if it points to an older Dart SDK).*
- **Code Generation:** When Freezed states or models are modified:
  ```bash
  /Users/imac/Documents/flutter_versions/flutter_3_47/bin/flutter pub run build_runner build --delete-conflicting-outputs
  ```
- **Asset Generation:** Managed via `flutter_gen`:
  ```bash
  /Users/imac/Documents/flutter_versions/flutter_3_47/bin/flutter packages pub run build_runner build
  ```
- **Formatting:** Always run `dart format lib/` before committing code.
- **Git Staging:** **MANDATORY:** Immediately stage any newly created file with `git add <file_path>` upon creation.

---

## 2. Architecture & Directory Structure

Follow feature-driven Clean Architecture with BLoC/Cubit and Repository pattern:

```text
lib/
├── ui/                         # Feature modules
│   └── {feature_name}/
│       ├── {feature_name}_screen.dart   # Main screen (MUST be StatefulWidget)
│       ├── bloc/
│       │   ├── {feature_name}_cubit.dart
│       │   ├── {feature_name}_state.dart
│       │   └── {feature_name}_state.freezed.dart
│       ├── widgets/            # Feature-specific private widgets
│       └── sheets/             # Feature-specific bottom sheets / modals
├── ui/widget/                  # Centralized shared reusable UI components
│   ├── app_button.dart         # Standard primary/secondary buttons
│   ├── base_button.dart        # Circular icon/back buttons
│   ├── app_text_field.dart     # Standard styled text inputs
│   ├── app_dialogs.dart        # Popups and alerts
│   └── status_pill.dart        # Status indicators & badges
├── repo/                       # Singleton data repositories (Firestore / APIs)
├── model/                      # Freezed / JSON serializable data models
├── router/                     # Navigation
│   ├── route_paths.dart        # Central route path constants
│   └── app_router.dart         # GoRouter setup with auth redirects
├── other/                      # App theme, colors, extensions, prefs
│   ├── app_color.dart          # Canonical color palette tokens
│   ├── app_extentions.dart     # String, Widget, num, and Context extensions
│   ├── preferances.dart        # SharedPreferences singleton helper
│   ├── snack_bar.dart          # Centralized notification / snackbar utility
│   └── app_theme.dart          # Light/Dark ThemeData
├── provider.dart               # Centralized global MultiBlocProvider list
└── gen/                        # Generated assets (assets.gen.dart)
```

---

## 3. Strict Coding Style & TypeScript/Dart Conventions

### 3.1 Explicit Typing (Zero `var`)
- **NEVER use `var`** or omit types.
- Always specify explicit return types (`void`, `Widget`, `Future<void>`, `String`).
- Always specify explicit parameter types (`void submit(String email)` not `void submit(email)`).
- Always specify variable types (`final String token = ...`, `final int count = 0`).

### 3.2 Naming Conventions
- **Files:** `snake_case.dart` (e.g., `calm_plan_screen.dart`, `sleep_forecast_cubit.dart`).
- **Classes:** `PascalCase` (e.g., `CalmPlanScreen`, `TodayCubit`).
- **Variables & Functions:** `camelCase` (e.g., `isSubmitting`, `onPlanTap()`).
- **Constants:** `camelCase` (e.g., `primaryColor`, `defaultTimeout`).
- **Private Members:** `_camelCase` (e.g., `_subscription`, `_buildHeader()`).

---

## 4. State Management (BLoC + Cubit + Freezed)

### 4.1 State Definitions
- States must use `@freezed` with immutable properties.
- State class files: `{feature}_state.dart` and generated `{feature}_state.freezed.dart`.
- **ApiResultStatus in State (CRITICAL):**
  - **Declare WITHOUT generic type parameter**: Use plain `ApiResultStatus`, never `ApiResultStatus<T>`.
  - **Always default to initial:** `@Default(ApiResultStatus.initial()) ApiResultStatus someStatus`.
  - **Store real data directly in separate fields:** e.g., `List<Item> items`, `ChildModel? childModel`. Never nest UI lists inside `ApiResultStatus`.

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';

part 'feature_state.freezed.dart';

@freezed
class FeatureState with _$FeatureState {
  const factory FeatureState({
    @Default(false) bool isLoading,
    @Default([]) List<ChildModel> children,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
    @Default(ApiResultStatus.initial()) ApiResultStatus saveStatus,
  }) = _FeatureState;
}
```

### 4.2 Cubit Architecture
- Every Cubit must implement:
  1. **`init()`**: Emits initial state, initializes data, starts listeners.
  2. **`changeProps()`**: Central state emitter. Never call `emit()` directly in other methods.
- **CRITICAL Rule for `changeProps()`:**
  - All `ApiResultStatus` parameters **MUST** default to `ApiResultStatus.initial()` when null.
  - Required syntax: `saveStatus: saveStatus ?? ApiResultStatus.initial()`
  - **NEVER** write `saveStatus: saveStatus ?? state.saveStatus` (avoids stale listener triggers).
- **Stream Subscriptions:**
  - Save subscriptions in private fields: `StreamSubscription<T>? _subscription;`
  - Cancel prior subscription before re-subscribing: `_subscription?.cancel();`
  - Cancel subscriptions in `close()`:
    ```dart
    @override
    Future<void> close() {
      _subscription?.cancel();
      return super.close();
    }
    ```

```dart
class FeatureCubit extends Cubit<FeatureState> {
  FeatureCubit() : super(const FeatureState());

  StreamSubscription<List<ChildModel>>? _childSubscription;

  void init() {
    emit(const FeatureState());
    _loadData();
  }

  void changeProps({
    bool? isLoading,
    List<ChildModel>? children,
    ApiResultStatus? fetchStatus,
    ApiResultStatus? saveStatus,
  }) {
    emit(state.copyWith(
      isLoading: isLoading ?? state.isLoading,
      children: children ?? state.children,
      fetchStatus: fetchStatus ?? ApiResultStatus.initial(),
      saveStatus: saveStatus ?? ApiResultStatus.initial(),
    ));
  }

  Future<void> _loadData() async {
    changeProps(fetchStatus: const ApiResultStatus.loading());
    final ApiResultStatus<List<ChildModel>> result = await ChildRepo.instance.getChildren();
    if (result is Data<List<ChildModel>>) {
      changeProps(
        children: result.data,
        fetchStatus: result,
      );
    } else if (result is Error<List<ChildModel>>) {
      changeProps(fetchStatus: result);
    }
  }
}
```

---

## 5. UI & Screen Construction Patterns

### 5.1 Full Screen Structure
- **Screens MUST be `StatefulWidget`** (never `StatelessWidget` for full routes).
- **BlocConsumer wraps Scaffold directly:** The consumer is outside `Scaffold`, never inside its body.
- **`initState` Setup:** Always initialize Cubits inside `WidgetsBinding.instance.addPostFrameCallback`.
- **ApiResultStatus is ONLY for listeners:**
  - In `listener`: Use `whenOrNull(loading: ..., data: ..., error: ...)` for `EasyLoading` and `showSnackBar()`.
  - In `builder`: **NEVER check ApiResultStatus**. Render data directly from state (`state.children.isEmpty ? EmptyView() : ListView(...)`).

```dart
class FeatureScreen extends StatefulWidget {
  const FeatureScreen({super.key});

  @override
  State<FeatureScreen> createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeatureCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeatureCubit, FeatureState>(
      listener: (BuildContext context, FeatureState state) {
        state.saveStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) {
            EasyLoading.dismiss();
            showSnackBar(
              message: LocaleKeys.profileUpdatedSuccessfully.tr(),
              type: SnackBarType.SUCCESS,
            );
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
      builder: (BuildContext context, FeatureState state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: SafeArea(
            child: state.children.isEmpty
                ? const EmptyStateWidget()
                : ListView.builder(
                    itemCount: state.children.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ChildCard(child: state.children[index]);
                    },
                  ),
          ),
        );
      },
    );
  }
}
```

---

## 6. Layout, Styling & UI Extensions

Always use project extension methods from `lib/other/app_extentions.dart` and tokens from `lib/other/app_color.dart`.

### 6.1 Responsive Units (ScreenUtil)
- Always use `.w`, `.h`, `.sp`, `.r` for dimensions and font sizes.
- **NEVER use raw unscaled double literals** for dimensions:
  - Correct: `24.w`, `16.h`, `14.sp`, `12.r`
  - Incorrect: `width: 24`, `fontSize: 14`

### 6.2 Spacing & Padding Extensions
- **Vertical spacing:** `16.spaceH` (translates to `SizedBox(height: 16.h)`).
- **Horizontal spacing:** `12.spaceW` (translates to `SizedBox(width: 12.w)`).
- **Widget padding:** `myWidget.appPadding(left: 20.r, right: 20.r, top: 10.h)` or `EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h)`.

### 6.3 Typography Extensions
- Use string extension `.appText()`:
  - Standard body text (Quicksand):
    ```dart
    "My heading".appText(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: darkBlue,
    )
    ```
  - Editorial / Title text (Fraunces):
    ```dart
    "Understand patterns.".appText(
      fraunces: true,
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: primaryColor,
    )
    ```

### 6.4 Color Palette & Opacity
- Primary brand: `primaryColor` (`0xFFF06D4D`)
- Secondary brand: `secondaryColor` (`0xFF665FCE`)
- Text & Neutrals: `darkBlue`, `greyColor`, `greyColor9`
- Backgrounds: `const Color(0xFFFEF8F4)` (warm paper tint)
- **Opacity standard:** Always use `.withValues(alpha: 0.1)` instead of deprecated `.withOpacity()`.

### 6.5 Assets (FlutterGen & V2 Assets)
- All V2 icons live under `assets/v2/icons/` as SVGs:
  ```dart
  Assets.v2.icons.icBack.svg(width: 24.w, height: 24.w)
  ```
- All V2 background images live under `assets/v2/images/`:
  ```dart
  AssetImage(Assets.v2.images.imgBg.path)
  ```

---

## 7. Repositories & Data Layer

- **Singleton Pattern:** Always create repositories as singletons:
  ```dart
  class ChildRepo {
    ChildRepo._();
    static final ChildRepo _instance = ChildRepo._();
    factory ChildRepo() => _instance;
    static ChildRepo get instance => _instance;

    Future<ApiResultStatus<List<ChildModel>>> getChildren() async {
      try {
        final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('children').get();
        final List<ChildModel> list = snapshot.docs
            .map((doc) => ChildModel.fromJson(doc.data() as Map<String, dynamic>, doc.reference))
            .toList();
        return ApiResultStatus.data(data: list);
      } catch (e) {
        return ApiResultStatus.error(error: Exception(e.toString()));
      }
    }
  }
  ```
- All async database / API operations belong in repositories, **never directly inside Cubits or UI widgets**.
- Always wrap repository calls in `try/catch` and return `ApiResultStatus<T>`.

---

## 8. Localization & User Copy

- **EasyLocalization** is mandatory for all user-facing strings:
  ```dart
  LocaleKeys.saveChanges.tr()
  ```
- **Translation File (`assets/translations/en.json`):**
  - **MANDATORY:** Always append new translation keys at the **VERY END** of `en.json`. Never insert them in the middle of existing keys.
  - After modifying `en.json`, regenerate `locale_keys.g.dart`:
    ```bash
    /Users/imac/Documents/flutter_versions/flutter_3_47/bin/flutter pub run easy_localization:generate -S assets/translations -O lib/generated -o locale_keys.g.dart -f keys
    ```

---

## 9. User Feedback & Dialogs

- **Snackbar Feedback:** Always use the centralized `showSnackBar()` helper:
  ```dart
  showSnackBar(
    message: LocaleKeys.itemSaved.tr(),
    type: SnackBarType.SUCCESS, // or SnackBarType.ERROR, SnackBarType.None
  );
  ```
  *(Never call `ScaffoldMessenger.of(context).showSnackBar()` directly).*
- **Loading Overlay:** Always use `EasyLoading.show()` and `EasyLoading.dismiss()`.

---

## 10. Verification & Quality Assurance Checklist

Before declaring any feature, refactor, or fix complete:

1. [ ] **Analyze:** Run `/Users/imac/Documents/flutter_versions/flutter_3_47/bin/flutter analyze --no-fatal-infos` — **0 errors**.
2. [ ] **Tests:** Run `/Users/imac/Documents/flutter_versions/flutter_3_47/bin/flutter test` — all tests must pass.
3. [ ] **Format:** Run `dart format lib/` across all touched files.
4. [ ] **Git Stage:** Ensure all new files are staged immediately (`git add`).
5. [ ] **Style Check:** Verify no `var`, explicit typing present, responsive units used (`.w`, `.h`, `.sp`), and `appText()` utilized.
