plugins {
    id("java-gradle-plugin")
    id("org.jetbrains.kotlin.jvm") version "1.7.10"
}

repositories {
    google()
    mavenCentral()
    gradlePluginPortal()
}

java {
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
}

dependencies {
    implementation(gradleApi())
    implementation("org.jetbrains.kotlin:kotlin-gradle-plugin:1.7.10")
}

gradlePlugin {
    plugins {
        create("version") {
            id = "com.app.version_plugin"
            implementationClass = "com.app.version_plugin.VersionPlugin"
        }
    }
}