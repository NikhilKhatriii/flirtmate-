# 💖 FlirtMate — AI-Powered Flirt Message Generator

A complete Flutter Android app with **infinite AI-generated pickup lines** using the **free OpenRouter API** (no credit card required).

---

## 🚀 Quick Setup (5 minutes)

### Step 1 — Get Free API Key
1. Go to **https://openrouter.ai** → Sign up (free, no card)
2. Go to **Keys** tab → Create new key → Copy it
3. Open `lib/services/api_service.dart`
4. Replace `YOUR_OPENROUTER_API_KEY_HERE` with your key

### Step 2 — Install Flutter Dependencies
```bash
flutter pub get
```

### Step 3 — Run
```bash
flutter run
```

---

## 📦 Dependencies

| Package | Purpose |
|---|---|
| `provider` | State management |
| `shared_preferences` | Save favorites locally |
| `google_fonts` | Playfair Display + Lato fonts |
| `share_plus` | Share messages |
| `http` | API calls |
| `flutter_animate` | Smooth animations |

---

## 🤖 API Details

- **Provider:** OpenRouter (https://openrouter.ai)
- **Model:** `mistralai/mistral-7b-instruct:free` — **100% Free, no cost ever**
- **Fallback:** Works offline with error state shown gracefully
- **Rate limit:** Free tier is generous for personal use

### Why OpenRouter?
- Truly free — no hidden costs
- No credit card to sign up
- Access to powerful AI models
- Simple REST API

---

## 📱 App Structure

```
lib/
├── main.dart                    # Entry point
├── theme/
│   └── app_theme.dart          # Colors, fonts, Material 3 theme
├── models/
│   └── flirt_category.dart     # FlirtCategory + FavoriteMessage models + 14 categories
├── services/
│   └── api_service.dart        # OpenRouter API integration
├── providers/
│   └── flirt_provider.dart     # State management (ChangeNotifier)
├── screens/
│   ├── splash_screen.dart      # Animated splash with floating hearts
│   ├── category_screen.dart    # 14-category grid picker
│   ├── generator_screen.dart   # AI line generator with swipe + history
│   └── favorites_screen.dart  # Saved lines grouped by category
└── widgets/
    ├── glass_card.dart         # Glassmorphism card widget
    ├── gradient_text.dart      # Gradient text shader widget
    └── shimmer_loading.dart    # Loading animation while AI generates
```

---

## ✨ Features

- **14 flirt styles** — Romantic, Funny, Classy, Shy, Nerdy, Smooth, and more
- **Infinite AI lines** — Every tap generates a brand new, never-repeated line
- **Session history** — Navigate back through previously generated lines
- **Swipe gestures** — Left to generate new, right to go back
- **Favorites** — Save, copy, share, delete; grouped by category
- **Persistent storage** — Favorites saved across app restarts
- **Premium UI/UX** — Glassmorphism cards, gradient text, shimmer loading
- **Material 3** — Full Material You dark theme

---

## 🎨 Design

- **Primary color:** Deep rose `#E91E8C`
- **Background:** Ultra dark `#0D0D1A`
- **Heading font:** Playfair Display (elegant serif)
- **Body font:** Lato (clean sans-serif)
- **Cards:** Glassmorphism with color-matched glows
- **Animations:** `flutter_animate` for staggered entrances and transitions

---

## 🔧 Customization

### Add more categories
In `lib/models/flirt_category.dart`, add to `kCategories`:
```dart
FlirtCategory(
  id: 'your_id',
  name: 'Your Name',
  emoji: '🎯',
  description: 'Short description',
  tagline: 'Catchy tagline',
  gradientColors: [Color(0xFF...), Color(0xFF...)],
  styleHint: 'How AI should write this style',
),
```

### Change AI model
In `lib/services/api_service.dart`:
```dart
// Other free models on OpenRouter:
static const String _model = 'google/gemma-7b-it:free';
static const String _model = 'meta-llama/llama-3-8b-instruct:free';
```

---

## 📋 Min Requirements

- Flutter 3.10+
- Dart 3.0+
- Android SDK 21+ (Android 5.0 Lollipop)
- Internet connection (for AI generation)

