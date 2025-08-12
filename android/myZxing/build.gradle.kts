import com.app.version_plugin.*

plugins {
    id("com.android.library")
    id("com.app.version_plugin")
    id("kotlin-android")

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

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = "11"
    }
    namespace = "com.base.myzxing"


}

dependencies {
    implementation(fileTree(mapOf("dir" to "libs", "include" to listOf("*.jar", "*.aar"))))
    androidTestImplementation(Dep.androidxTestExtJunit)
    androidTestImplementation(Dep.espressoCore)
    implementation(Dep.coreKtx)
    implementation(Dep.appcompat)
    implementation(Dep.material)
    implementation(Dep.junit)
    api("com.google.zxing:core:3.3.3")

    api("androidx.camera:camera-core:1.1.0-rc02")
    api("androidx.camera:camera-camera2:1.1.0-rc02")
    api("androidx.camera:camera-lifecycle:1.1.0-rc02")
    api("androidx.camera:camera-view:1.1.0-rc02")



}