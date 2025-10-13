import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

// 1. key.properties 읽는 로직을 plugins 블록 아래로 이동
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.aiwriting_collection"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        // 3. Java 버전을 17로 통일
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        // 3. Java 버전을 17로 통일
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.aiwriting_collection"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        // debug 설정은 기본값을 사용하므로 별도로 추가할 필요가 없습니다.
        create("release") {
            if (keystoreProperties["storeFile"] != null) {
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
            }
        }
    }

    buildTypes {
        // 2. 누락되었던 debug 설정을 명시적으로 추가
        getByName("debug") {
            // 디버그 빌드는 기본 debug 서명을 사용합니다.
            signingConfig = signingConfigs.getByName("debug")
        }
        getByName("release") {
            // 릴리즈 빌드는 위에서 정의한 release 서명을 사용합니다.
            signingConfig = signingConfigs.getByName("release")
            // 릴리즈 빌드 시 코드 난독화 및 최적화를 활성화할 수 있습니다.
            // isMinifyEnabled = true
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}
