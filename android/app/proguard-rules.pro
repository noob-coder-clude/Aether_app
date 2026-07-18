# R8 / ProGuard rules for Aether Android Client

# Keep Flutter Wrapper Classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.provider.** { *; }

# Keep Aether Native Bridge & Services
-keep class com.cluvex.aether.** { *; }
-keepclassmembers class com.cluvex.aether.** { *; }

# Preserve Annotations & Metadata for Performance
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod

# Optimize R8 Processing
-optimizationpasses 5
-allowaccessmodification
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
