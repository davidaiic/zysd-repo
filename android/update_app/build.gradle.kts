import com.app.version_plugin.*

plugins {
    id("com.android.library")
    id("com.app.version_plugin")
    id("kotlin-kapt")
    id("kotlin-android")
    id("kotlinx-serialization")

}

android {
    compileSdk = BuildConfig.compileSdkVersion

    defaultConfig {
        minSdk = BuildConfig.minSdkVersion
        targetSdk = BuildConfig.targetSdkVersion

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        consumerProguardFiles("consumer-rules.pro")
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
    buildFeatures {
        dataBinding = true
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = "11"
    }
    namespace = "com.vector.update_app"

}

dependencies {
    implementation(fileTree(mapOf("dir" to "libs", "include" to listOf("*.jar", "*.aar"))))
    androidTestImplementation(Dep.androidxTestExtJunit)
    androidTestImplementation(Dep.espressoCore)
    implementation(Dep.coreKtx)
    implementation(Dep.appcompat)
    implementation(Dep.material)
    implementation(Dep.junit)
    implementation("com.squareup.okhttp3:okhttp:4.3.1")
    implementation("org.greenrobot:eventbus:3.1.1")


}