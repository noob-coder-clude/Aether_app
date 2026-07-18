plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-main-application")
}

android {
    namespace = "com.cluvex.aether"
    compileSdk = 34

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.cluvex.aether"
        minSdk = 24
        targetSdk = 34
        versionCode = 3
        versionName = "1.2.0"

        ndk {
            abiFilters.addAll(setOf("arm64-v8a", "armeabi-v7a", "x86_64"))
        }

        multiDexEnabled = true
    }

    buildTypes {
        release {
            // Enable R8 Minification, Code Shrinking & Obfuscation
            isMinifyEnabled = true
            isShrinkResources = true

            // Apply custom ProGuard & R8 optimization rules
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            signingConfig = signingConfigs.getByName("debug")
        }
        debug {
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    packaging {
        resources {
            excludes.add("/META-INF/{AL2.0,LGPL2.1}")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.9.22")
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.11.0")
}
