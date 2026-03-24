# Schéma de la Base de Données — Yuka Clone

## Architecture

```mermaid
graph LR
    A["📱 App Flutter"] -->|Auth| B["🗄 PocketBase"]
    A -->|Produits| C["🌐 Open Food Facts API"]
    B -->|SQLite| D["💾 pb_data/"]
```

---

## PocketBase — Collection `users`

```mermaid
erDiagram
    users {
        string id PK "ID auto-généré"
        string email UK "Email unique"
        string name "Nom complet"
        string password "Hash bcrypt"
        string passwordConfirm "Confirmation (création)"
        bool verified "Email vérifié"
        datetime created "Date création"
        datetime updated "Date mise à jour"
    }
```

| Champ | Type | Contraintes | Description |
|-------|------|-------------|-------------|
| `id` | `string` | PK, auto | Identifiant unique |
| `email` | `string` | UNIQUE, NOT NULL | Email de connexion |
| `name` | `string` | NOT NULL | Nom affiché |
| `password` | `string` | NOT NULL, bcrypt | Mot de passe hashé |
| `verified` | `bool` | default: false | Vérification email |
| `created` | `datetime` | auto | Date de création |
| `updated` | `datetime` | auto | Dernière modification |

---

## Open Food Facts API — Modèle `Product`

```mermaid
erDiagram
    Product {
        string barcode PK "Code-barres EAN"
        string name "Nom du produit"
        string altName "Nom alternatif"
        string picture "URL image"
        string quantity "Ex: 200g"
    }

    Product ||--o{ Brand : "a"
    Product ||--o| NutriScore : "a"
    Product ||--o| NovaScore : "a"
    Product ||--o| GreenScore : "a"
    Product ||--o{ Ingredient : "contient"
    Product ||--o{ Allergen : "contient"
    Product ||--o{ Additive : "contient"
    Product ||--o| NutrientLevels : "a"
    Product ||--o| NutritionFacts : "a"

    Brand {
        string name "Nom de la marque"
    }

    NutrientLevels {
        string salt "low/moderate/high"
        string saturatedFat "low/moderate/high"
        string sugars "low/moderate/high"
        string fat "low/moderate/high"
    }

    NutritionFacts {
        string servingSize "Taille de portion"
    }

    NutritionFacts ||--o| Nutriment_energy : "énergie"
    NutritionFacts ||--o| Nutriment_fat : "lipides"
    NutritionFacts ||--o| Nutriment_saturatedFat : "acides gras saturés"
    NutritionFacts ||--o| Nutriment_carbohydrate : "glucides"
    NutritionFacts ||--o| Nutriment_sugar : "sucres"
    NutritionFacts ||--o| Nutriment_fiber : "fibres"
    NutritionFacts ||--o| Nutriment_proteins : "protéines"
    NutritionFacts ||--o| Nutriment_salt : "sel"
    NutritionFacts ||--o| Nutriment_sodium : "sodium"

    Nutriment_energy {
        string unit "kcal ou kJ"
        float per100g "Valeur pour 100g"
        float perServing "Valeur par portion"
    }
```

---

## Données en mémoire (runtime)

```mermaid
erDiagram
    FavoritesManager {
        list favorites "Liste de Product"
    }

    FavoritesManager ||--o{ Product : "contient (pas de doublons)"

    ScanHistory {
        list scans "Liste de Product"
    }

    ScanHistory ||--o{ Product : "contient (avec doublons)"
```

> **Note :** Les favoris et l'historique de scan sont stockés en mémoire (dans des singletons Dart). Ils ne sont pas persistés dans PocketBase.

---

## Flux de données

```mermaid
sequenceDiagram
    participant U as Utilisateur
    participant A as App Flutter
    participant PB as PocketBase
    participant OFF as Open Food Facts

    U->>A: Email + Mot de passe
    A->>PB: POST /api/collections/users/auth-with-password
    PB-->>A: Token JWT

    U->>A: Scanne code-barres
    A->>OFF: GET /v2/getProduct?barcode=XXX
    OFF-->>A: JSON produit complet
    A->>A: Ajoute à l'historique (mémoire)

    U->>A: Tap ⭐ favori
    A->>A: FavoritesManager.toggleFavorite()
```
