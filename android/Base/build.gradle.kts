import com.app.version_plugin.*

plugins {
    id("com.android.library")
    id("com.app.version_plugin")
    id("kotlin-kapt")
    id("kotlin-android")
    id("kotlin-parcelize")
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
            jniLibs.srcDirs("libs")
        }
    }
    namespace = "com.app.base"
}

dependencies {
    implementation(fileTree(mapOf("dir" to "libs", "include" to listOf("*.jar", "*.aar"))))
    androidTestImplementation(Dep.androidxTestExtJunit)
    androidTestImplementation(Dep.espressoCore)
    implementation(Dep.coreKtx)
    implementation(Dep.appcompat)
    implementation(Dep.material)
    implementation(Dep.junit)
    api(Dep.activityKtx)
    api(Dep.fragmentKtx)
    api(Dep.lifecycleLiveDataKtx)
    api(Dep.lifecycleViewModelKtx)
    api(Dep.kotlinCoroutinesCore)
    api(Dep.okHttp)
    api(Dep.constraintLayout)
    api(Dep.lifecycleCommonJava8)
    api(Dep.lifecycleExtensions)
    api(Dep.immersionBar)
    api(Dep.immersionBarKtx)
    api(Dep.xPopup)
    api(Dep.glide)
    api(Dep.lottie)
    api(Dep.roundedImageview)
    api(Dep.coil)
    api(Dep.coilGif)
    api(Dep.autoSize)
    api(Dep.agentWebAndroidx)
    api(Dep.backgroundLibrary)
    api(Dep.bannerViewpager)
    api(Dep.viewpagerIndicator)
    api(Dep.xxPermissions)
    api(Dep.pictureSelector)
    api(Dep.ucrop)
    api(Dep.camerax)

    api(Dep.compress)
    api(Dep.magicIndicator)
    api(Dep.flexBox)
    api(Dep.okhttpprofiler)
    api(Dep.shadowLayout)

    api(Dep.header)
    api(Dep.pickerView)
    api(Dep.viewModel)
    api(Dep.viewModelKtx)
    api("org.ccil.cowan.tagsoup:tagsoup:1.2.1")


    api(Dep.kotlinCoroutinesAndroid)
    api(Dep.okHttp)
    api(Dep.Net)
    api(Dep.Interval)
    api(Dep.BRV)
    api(Dep.Serialize)
    api(Dep.Spannable)
    api(Dep.Tooltip)
    api(Dep.LogCat)
    api(Dep.Channel)
    api(Dep.Serialization)
    api(Dep.BRV)
    api(Dep.Chucker)
    api(Dep.Kotlin_Reflect)

}