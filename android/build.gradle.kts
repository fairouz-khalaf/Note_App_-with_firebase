import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

// ضروري لإضافة الـ classpath
buildscript {
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.3.0") // متوافق مع Gradle 8.10.2
        classpath("com.google.gms:google-services:4.4.2") // Firebase
    }
}

// إعداد مسار جديد لمجلد build (اختياري)
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)

    // تأكد من تقييم مشروع app أولاً
    evaluationDependsOn(":app")
}

// مهمة لتنظيف المشروع
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
