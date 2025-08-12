import com.app.version_plugin.*
import java.text.SimpleDateFormat
import java.util.Date


plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.app.version_plugin")
    id("kotlin-android")
    id("kotlin-kapt")
    id("kotlinx-serialization")
}

android {
    compileSdk = BuildConfig.compileSdkVersion

    defaultConfig {
        applicationId = "com.manle.phone.android.yaodian"
        minSdk = BuildConfig.minSdkVersion
        targetSdk = BuildConfig.targetSdkVersion
        versionCode = BuildConfig.versionCode
        versionName = BuildConfig.versionName
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        multiDexEnabled = true
        ndk {
            abiFilters.addAll(mutableSetOf("arm64-v8a","x86_64"))
        }
    }
    signingConfigs {
        create("keystore") {
            storeFile = file("android.jks")
            storePassword = "bbdtek"
            keyAlias = "yaodian_manle_beijing"
            keyPassword = "bbdtek"
        }
    }
    buildTypes {
        val signConfig = signingConfigs.getByName("keystore")
        debug {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            signingConfig = signConfig
        }
        release {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            signingConfig = signConfig
        }
    }
    applicationVariants.all {
        outputs.all {
            if (this is com.android.build.gradle.internal.api.ApkVariantOutputImpl) {
                val dateText = SimpleDateFormat("yyyyMMddHHmmss").format(Date())
                outputFileName = if (buildType.name == "release") {
                    "MedicineStore-v${versionName}-${dateText}.apk"
                } else {
                    "debug-v${versionName}-${dateText}.apk"
                }
            }

        }
    }

    androidComponents {}
    buildFeatures {
        dataBinding = true
        viewBinding = true
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = "11"
    }
    sourceSets {
        getByName("main") {
            res.srcDirs(
                "src/main/res",
                "src/main/res/layouts",
                "src/main/res/layouts/activity",
                "src/main/res/layouts/pop",
                "src/main/res/layouts/adapter",
                "src/main/res/layouts/fragment",
                "src/main/res/layouts/view",
            )
        }
    }
    lint {
        abortOnError = false
        checkReleaseBuilds = false
    }
    namespace = "com.manle.phone.android.yaodian"

}
dependencies {
    implementation(fileTree(mapOf("dir" to "libs", "include" to listOf("*.jar", "*.aar"))))
    androidTestImplementation(Dep.androidxTestExtJunit)
    androidTestImplementation(Dep.espressoCore)
    implementation(Dep.coreKtx)
    implementation(Dep.appcompat)
    implementation(Dep.material)
    implementation(Dep.junit)
    api(Dep.Serialization)
    implementation(project(":Base"))
    implementation(project(":update_app"))
    implementation(files("libs/quick_login_android_5.9.6.aar"))
    implementation(project(":myZxing"))
    implementation("com.tencent.mm.opensdk:wechat-sdk-android:+")
    implementation("com.github.wendux:DSBridge-Android:3.0.0")
}
