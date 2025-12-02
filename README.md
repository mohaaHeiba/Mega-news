# 📰 Mega News - AI-Powered News Aggregator

A sophisticated Flutter application that aggregates news from multiple sources, powered by AI summarization and built with modern architecture principles.

## 🎯 Overview

Mega News is a feature-rich news application that fetches articles from **4 different news APIs in parallel** (not sequentially), providing users with comprehensive news coverage across multiple categories. The app leverages Google Gemini AI for intelligent article summarization and offers a seamless multilingual experience with support for Arabic and English.

## ✨ Key Features

### 📱 Core Features
- **Multi-Source News Aggregation**: Fetches news from 4 different APIs simultaneously
- **AI-Powered Summaries**: Google Gemini AI integration for intelligent article summarization
- **Smart Briefing**: AI-generated briefings for different news categories
- **Text-to-Speech (TTS)**: Listen to articles in both Arabic and English
- **Voice Search**: Speech-to-text functionality for hands-free searching
- **Favorites System**: Save articles and AI summaries for offline reading
- **Dark/Light Theme**: Beautiful UI with theme switching
- **Multilingual Support**: Full Arabic and English localization
- **Category Filtering**: Browse news by category (General, Sports, Technology, Business, Health, Science, Entertainment)
- **Infinite Scroll**: Pagination with smooth loading
- **Background Notifications**: Push notifications for breaking news
- **Share & Open Links**: Share articles and open original sources

### 🤖 AI Features
- **Article Summarization**: Get AI-generated summaries for any article
- **Smart Topic Briefing**: AI-powered briefings for news categories
- **Dual-Language Summaries**: Get summaries in both Arabic and English simultaneously
- **Context-Aware Responses**: AI understands article context and provides relevant insights

## 🏗️ Architecture

### Design Patterns & Principles

#### 1. **MVVM (Model-View-ViewModel) Pattern**
The application follows the MVVM architecture pattern using **GetX** as the state management solution:

- **Model**: Domain entities and data models (`lib/features/*/domain/entities/`, `lib/features/*/data/model/`)
- **View**: UI pages and widgets (`lib/features/*/pages/`, `lib/features/*/widgets/`)
- **ViewModel**: Controllers that manage state and business logic (`lib/features/*/controller/`)

**Example Structure:**
```
features/
  ├── home/
  │   ├── controller/        # ViewModel (Business Logic)
  │   │   └── home_controller.dart
  │   ├── pages/             # View (UI)
  │   │   └── home_page.dart
  │   └── widgets/            # View Components
  │       └── build_articles_list.dart
```

#### 2. **Clean Architecture**
The project implements Clean Architecture with clear separation of concerns:

```
features/
  ├── data/                  # Data Layer
  │   ├── datasources/       # Remote & Local Data Sources
  │   ├── model/             # Data Models (DTOs)
  │   ├── mappers/           # Data Mappers
  │   └── repositories/      # Repository Implementations
  ├── domain/                # Domain Layer (Business Logic)
  │   ├── entities/          # Domain Entities
  │   ├── repositories/      # Repository Interfaces
  │   └── usecases/          # Use Cases
  └── presentation/          # Presentation Layer
      ├── controller/        # ViewModels
      ├── pages/             # Views
      └── widgets/           # UI Components
```

#### 3. **SOLID Principles**

**Single Responsibility Principle (SRP)**
- Each class has a single, well-defined responsibility
- Controllers handle only UI state and user interactions
- Repositories handle only data operations
- Use cases handle specific business logic

**Open/Closed Principle (OCP)**
- Interfaces (`INewsRepository`, `IGeminiRepository`) allow extension without modification
- New data sources can be added by implementing interfaces

**Liskov Substitution Principle (LSP)**
- All implementations can be substituted with their interfaces
- Repository implementations are interchangeable

**Interface Segregation Principle (ISP)**
- Small, focused interfaces (`INewsApiRemoteDataSource`, `IGNewsRemoteDataSource`)
- Clients depend only on methods they use

**Dependency Inversion Principle (DIP)**
- High-level modules depend on abstractions (interfaces)
- Dependency injection via GetX bindings
- Controllers depend on repository interfaces, not implementations

**Example:**
```dart
// High-level module depends on abstraction
class HomeController {
  final INewsRepository newsRepository;  // Interface, not implementation
  
  HomeController({required this.newsRepository});
}

// Dependency injection in bindings
Get.put<HomeController>(
  HomeController(newsRepository: newsRepository),  // Implementation injected
);
```

## 🔌 API Integration

### Parallel API Fetching

The application fetches news from **4 different APIs simultaneously** using `Future.wait()` for optimal performance:

1. **GNews API** (`https://gnews.io/api/v4`)
2. **NewsAPI** (`https://newsapi.org/v2`)
3. **NewsData.io** (`https://newsdata.io/api/1`)
4. **Currents API** (`https://api.currentsapi.services/v1`)

**Implementation in `NewsRepositoryImpl`:**

```dart
Future<List<Article>> getTopHeadlines({
  required String category,
  String? language,
  int page = 1,
}) async {
  // All 4 APIs called in PARALLEL, not sequentially
  final results = await Future.wait<List<dynamic>>([
    gNewsSource.getTopHeadlines(...).catchError((_) => []),
    newsApiSource.getTopHeadlines(...).catchError((_) => []),
    newsDataSource.getTopHeadlines(...).catchError((_) => []),
    currentsSource.getLatestNews(...).catchError((_) => []),
  ], eagerError: false);  // Continues even if one API fails

  // Merge and sort results
  final List<Article> articles = [
    ...results[0].map(mapper.fromGNewsModel),
    ...results[1].map(mapper.fromNewsApiModel),
    ...results[2].map(mapper.fromNewsDataModel),
    ...results[3],  // Currents articles
  ];

  articles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  return articles;
}
```

**Benefits:**
- ⚡ **Faster Loading**: All APIs fetch simultaneously instead of waiting for each one
- 🛡️ **Fault Tolerance**: If one API fails, others continue (`eagerError: false`)
- 📊 **Comprehensive Coverage**: More articles from multiple sources
- 🔄 **Automatic Deduplication**: Results sorted by date for better UX

## 🛠️ Tech Stack

### Core Technologies
- **Flutter** 3.9.2+ - Cross-platform framework
- **Dart** - Programming language

### State Management & Navigation
- **GetX** 4.7.2 - State management, dependency injection, and routing
- **GetStorage** 2.1.1 - Local storage

### Networking
- **Dio** 5.9.0 - HTTP client
- **dio_smart_retry** 7.0.1 - Automatic retry mechanism
- **internet_connection_checker_plus** 2.9.1 - Network connectivity

### Backend Services
- **Supabase** 2.10.3 - Backend as a Service (Authentication, Database)
- **Google Gemini AI** (flutter_gemini 3.0.0) - AI summarization

### UI/UX
- **Shimmer** 3.0.1 - Loading placeholders
- **Carousel Slider** 5.1.1 - Image carousels
- **Cached Network Image** 3.4.1 - Image caching
- **Timeago** 3.7.1 - Relative time formatting

### Features
- **Flutter TTS** 4.2.3 - Text-to-speech
- **Speech to Text** 7.3.0 - Voice input
- **Flutter Local Notifications** 19.5.0 - Push notifications
- **Workmanager** 0.9.0+3 - Background tasks
- **URL Launcher** 6.3.2 - Open external links
- **Share Plus** 12.0.1 - Share functionality
- **Permission Handler** 12.0.1 - Runtime permissions

### Development
- **Flutter Dotenv** 6.0.0 - Environment variables
- **Flutter Lints** 5.0.0 - Code quality

## 📁 Project Structure

```
lib/
├── app.dart                    # Main app widget
├── main.dart                   # App entry point
├── core/                       # Core functionality
│   ├── bindings/              # Dependency injection bindings
│   ├── constants/             # App constants (colors, sizes, etc.)
│   ├── custom/                # Custom widgets/utilities
│   ├── errors/                # Error handling classes
│   ├── helper/                # Helper functions
│   ├── layouts/               # App layouts (bottom nav, etc.)
│   ├── network/               # Network client configuration
│   ├── routes/                # App routing
│   ├── services/              # Core services (TTS, STT, Notifications)
│   ├── theme/                 # App themes (light/dark)
│   └── utils/                 # Utility functions
├── features/                   # Feature modules
│   ├── article_detail/        # Article detail screen
│   ├── auth/                  # Authentication (Login, Register)
│   ├── briefing/              # AI briefing feature
│   ├── favorites/             # Saved articles
│   ├── gemini/                # AI integration
│   ├── home/                  # Home screen
│   ├── news/                  # News data layer
│   ├── notifications/         # Push notifications
│   ├── search/                # Search functionality
│   ├── settings/              # Settings & profile
│   └── welcome/               # Welcome screen
├── generated/                  # Generated files
└── l10n/                      # Localization files
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- API Keys for:
  - GNews API
  - NewsAPI
  - NewsData.io
  - Currents API
  - Google Gemini API
  - Supabase (URL and Anon Key)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd mega_news
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Create `.env` file** in the root directory:
   ```env
   GNEWS_API=your_gnews_api_key
   NEWS_API=your_newsapi_key
   NEWS_DATA=your_newsdata_key
   CURRENTS_API=your_currents_api_key
   GEMINI_API=your_gemini_api_key
   SUPABASE_URL=your_supabase_url
   SUPABASE_APIKEY=your_supabase_anon_key
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### API Keys Setup

1. **GNews API**: Sign up at [gnews.io](https://gnews.io)
2. **NewsAPI**: Get key from [newsapi.org](https://newsapi.org)
3. **NewsData.io**: Register at [newsdata.io](https://newsdata.io)
4. **Currents API**: Get key from [currentsapi.services](https://currentsapi.services)
5. **Google Gemini**: Get API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
6. **Supabase**: Create project at [supabase.com](https://supabase.com)

## 🎨 Design Patterns in Detail

### Repository Pattern
Centralized data access with abstraction:
```dart
abstract class INewsRepository {
  Future<List<Article>> getTopHeadlines({...});
  Future<List<Article>> searchNews(String query, {...});
}

class NewsRepositoryImpl implements INewsRepository {
  // Implementation with multiple data sources
}
```

### Use Case Pattern
Business logic encapsulation:
```dart
class GetAiSummaryUseCase {
  final IGeminiRepository _repository;
  
  Future<String> call({
    required String topic,
    required List<Article> articles,
  }) async {
    // Business logic here
  }
}
```

### Dependency Injection
Using GetX bindings for clean dependency management:
```dart
class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    // Setup dependencies
    final apiClient = ApiClient(dio);
    final newsRepository = NewsRepositoryImpl(...);
    
    // Inject controllers
    Get.put<HomeController>(
      HomeController(newsRepository: newsRepository),
    );
  }
}
```

### Error Handling
Custom exception hierarchy:
```dart
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;
}

class NetworkException extends ApiException { ... }
class RateLimitException extends ApiException { ... }
class ServerException extends ApiException { ... }
```

## 🔄 Data Flow

1. **User Action** → View triggers controller method
2. **Controller** → Calls repository/use case
3. **Repository** → Fetches from multiple data sources in parallel
4. **Data Sources** → Make API calls
5. **Mappers** → Convert API models to domain entities
6. **Repository** → Returns unified list of entities
7. **Controller** → Updates reactive state
8. **View** → Rebuilds with new data

## 🌐 Localization

The app supports multiple languages:
- **Arabic** (ar)
- **English** (en)

Localization files are generated using `flutter_intl` and stored in `lib/l10n/`.

## 🎯 Key Features Implementation

### Parallel API Fetching
- Uses `Future.wait()` for concurrent API calls
- Error handling with `catchError` to prevent one failure from breaking the entire flow
- Results merged and sorted by publication date

### AI Integration
- Google Gemini AI for article summarization
- Dual-language summaries (Arabic + English)
- Context-aware prompts for better results

### State Management
- Reactive programming with GetX observables
- Automatic UI updates on state changes
- Efficient memory management with lazy loading

### Offline Support
- Cached network images
- Local storage for favorites
- GetStorage for user preferences

## 📱 Screenshots

### - Welcome Page
<p align="center">
  <img src="https://github.com/user-attachments/assets/cb6729a8-8060-4e5f-b2c0-7c0b6cc19752" width="260"/>
  <img src="https://github.com/user-attachments/assets/02caa8e5-b9f8-43a1-b919-143af18231f2" width="260"/>
  <img src="https://github.com/user-attachments/assets/312eea48-2273-428e-ba75-eb1f777782ae" width="260"/>
  <img src="https://github.com/user-attachments/assets/e0311613-03e9-48c4-9326-3e5a9043d453" width="260"/>
</p>


### - Auth Pages
<p align="center">
  <img src="https://github.com/user-attachments/assets/0c89b6a2-72b6-4266-9f62-8b128b2b9827" width="260"/>
  <img src="https://github.com/user-attachments/assets/cb80b79d-d4a0-493e-8aee-b50f530a480e" width="260"/>
  <img src="https://github.com/user-attachments/assets/dc6c7a39-314b-472a-9554-c981b5593afb" width="260"/>
  <img src="https://github.com/user-attachments/assets/872cfe8a-cecb-40bf-91e2-ab07d4f02331" width="260"/>
</p>


### - Main Pages
<p align="center">
  <img src="https://github.com/user-attachments/assets/495c7c19-7126-4a70-b094-e79d07469888" width="260"/>
  <img src="https://github.com/user-attachments/assets/28e457b3-fe35-484d-b4ff-92e679a069bc" width="260"/>
  <img src="https://github.com/user-attachments/assets/d9d29a02-17f6-4ab2-b5d4-807d1ac0f7ba" width="260"/>
  <img src="https://github.com/user-attachments/assets/bd54a0b0-e768-4799-a3f0-0c844e962606" width="260"/>
  <img src="https://github.com/user-attachments/assets/b030a650-ad98-4e1f-b675-252dca60f6ec" width="260"/>
  <img src="https://github.com/user-attachments/assets/a60f8aa2-a957-4a28-b220-5c0c2a2c6666" width="260"/>
</p>


### - Articles Details Page
<p align="center">
  <img src="https://github.com/user-attachments/assets/e7a50f6f-3a49-44ec-8b14-30a0bef24bb1" width="260"/>
  <img src="https://github.com/user-attachments/assets/0d8047fe-4e75-47ee-88f2-88bed4af53bf" width="260"/>
</p>


### - Search Page
<p align="center">
  <img src="https://github.com/user-attachments/assets/c7193110-bb67-4dfc-a4c7-ef8eb1440262" width="260"/>
  <img src="https://github.com/user-attachments/assets/d196860f-00f4-48d7-b1bb-f27e1c6372eb" width="260"/>
  <img src="https://github.com/user-attachments/assets/babfe62a-f3d5-4436-9a32-17cd1e057ba5" width="260"/>
  <img src="https://github.com/user-attachments/assets/d2322e42-287f-4efe-832e-25452065329b" width="260"/>
  <img src="https://github.com/user-attachments/assets/eb3ceadf-4dd0-494c-a682-9c9c07f5a8c2" width="260"/>
</p>



## 🧪 Testing

*(Add testing information if available)*

## 🤝 Contributing

*(Add contribution guidelines if applicable)*

## 📄 License

*(Add license information)*

## 👥 Authors

*(Add author information)*

---
<!-- 
## ⭐ App Rating & Assessment

### Overall Rating: **9/10** - Excellent Production-Ready App

### Strengths ✅

1. **Architecture Excellence (10/10)**
   - ✅ Clean Architecture implementation
   - ✅ Proper separation of concerns (Data/Domain/Presentation)
   - ✅ SOLID principles followed throughout
   - ✅ MVVM pattern with GetX
   - ✅ Dependency injection properly implemented

2. **Performance (9/10)**
   - ✅ Parallel API fetching (excellent optimization)
   - ✅ Lazy loading for controllers
   - ✅ Image caching
   - ✅ Efficient state management
   - ⚠️ Could benefit from pagination optimization

3. **Code Quality (9/10)**
   - ✅ Well-organized project structure
   - ✅ Clear naming conventions
   - ✅ Error handling with custom exceptions
   - ✅ Repository pattern for data access
   - ✅ Use cases for business logic
   - ⚠️ Some files could use more documentation

4. **Features (9/10)**
   - ✅ Comprehensive feature set
   - ✅ AI integration (Gemini)
   - ✅ Multilingual support
   - ✅ TTS/STT functionality
   - ✅ Background notifications
   - ✅ Favorites system
   - ✅ Theme switching

5. **User Experience (9/10)**
   - ✅ Smooth navigation
   - ✅ Loading states (shimmer effects)
   - ✅ Error handling with user-friendly messages
   - ✅ Infinite scroll
   - ✅ Category filtering
   - ⚠️ Could add pull-to-refresh

6. **Scalability (9/10)**
   - ✅ Modular architecture
   - ✅ Easy to add new features
   - ✅ Interface-based design allows easy swapping
   - ✅ Well-structured for team collaboration

### Areas for Improvement 🔧

<!-- 1. **Testing (6/10)**
   - ⚠️ No visible unit tests
   - ⚠️ No widget tests
   - ⚠️ No integration tests
   - **Recommendation**: Add comprehensive test coverage 

2. **Documentation (7/10)**
   - ⚠️ Code comments could be more extensive
   - ⚠️ API documentation missing
   - **Recommendation**: Add inline documentation and API docs

3. **Error Handling (8/10)**
   - ✅ Custom exceptions implemented
   - ⚠️ Could add more specific error messages
   - ⚠️ Offline mode handling could be improved

4. **Performance Optimizations (8/10)**
   - ✅ Parallel API calls
   - ⚠️ Could implement article caching
   - ⚠️ Could add debouncing for search

5. **Security (8/10)**
   - ✅ Environment variables for API keys
   - ⚠️ Could add API key encryption
   - ⚠️ Could implement certificate pinning

### Final Verdict

**This is a well-architected, production-ready application** that demonstrates:
- Strong understanding of software architecture principles
- Excellent implementation of design patterns
- Modern Flutter development practices
- Performance-conscious coding (parallel API calls)
- User-centric feature development

**The app is NOT perfect, but it's VERY GOOD** and close to production quality. With the addition of:
- Comprehensive testing
- Better documentation
- Minor performance optimizations
- Enhanced error handling

This would be a **perfect 10/10 production application**.

### Recommendation

**Deploy to production** after addressing:
1. Add unit tests for critical business logic
2. Implement article caching for offline support
3. Add pull-to-refresh functionality
4. Enhance error messages for better UX

**Overall: Excellent work! 🎉** -->
