plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Firebase
    id("org.jetbrains.kotlin.android") // Ensure correct Kotlin plugin
    id("dev.flutter.flutter-gradle-plugin") // Flutter Plugin
}

android {
    namespace = "com.example.login"
    compileSdk = 35 // Updated to latest stable version

    defaultConfig {
        applicationId = "com.example.login"
        minSdk = 23
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17" // Match with Java 17 for better performance
    }

    ndkVersion = "27.0.12077973"
}

flutter {
    source = "../.."
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib:2.1.0") // ✅ Correct Kotlin version
    implementation("androidx.core:core-ktx:1.12.0") // Latest AndroidX core
    implementation("com.google.firebase:firebase-auth-ktx:22.2.0") // Firebase Auth
    implementation("com.google.firebase:firebase-firestore-ktx:24.10.0") // Firestore
}
