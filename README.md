# flirtplay






📁 Structure des dossiers
lib/
├── main.dart
├── app/
│   ├── app.dart                    # Configuration principale de l'app
│   └── routes/
│       └── app_routes.dart         # Gestion des routes
├── core/
│   ├── constants/
│   │   ├── app_colors.dart         # Couleurs de l'app
│   │   ├── app_strings.dart        # Textes statiques
│   │   └── app_theme.dart          # Thème global
│   ├── utils/
│   │   └── extensions.dart         # Extensions utiles
│   └── widgets/
│       ├── animated_button.dart    # Bouton avec animation
│       ├── gradient_background.dart # Background gradient
│       └── confetti_widget.dart    # Widget confettis
├── features/
│   ├── home/
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   └── home_page.dart
│   │   │   └── widgets/
│   │   │       └── home_content.dart
│   │   └── domain/
│   │       └── entities/
│   └── game/
│       ├── data/
│       │   ├── models/
│       │   │   ├── challenge_model.dart
│       │   │   └── game_result_model.dart
│       │   └── repositories/
│       │       └── game_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── challenge.dart
│       │   │   └── game_result.dart
│       │   ├── repositories/
│       │   │   └── game_repository.dart
│       │   └── usecases/
│       │       ├── get_random_challenge.dart
│       │       └── get_random_penalty.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── game_bloc.dart
│           │   ├── game_event.dart
│           │   └── game_state.dart
│           ├── pages/
│           │   └── game_page.dart
│           └── widgets/
│               ├── challenge_card.dart
│               ├── result_card.dart
│               ├── progress_bar.dart
│               └── action_buttons.dart
└── shared/
├── data/
│   └── game_data.dart          # Données des défis/gages
└── services/
└── animation_service.dart   # Service pour animations




