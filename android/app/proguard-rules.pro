# ----------------------------------------------------------
# FLUTTER PLUGINS
# ----------------------------------------------------------
# This ONE line saves all Flutter plugins
-keep class io.flutter.plugins.** { *; }

# ----------------------------------------------------------
# GOOGLE PLAY SERVICES (CRITICAL FOR RELEASE MODE)
# ----------------------------------------------------------
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }
-keep class com.google.android.gms.tasks.** { *; }
-keep class com.google.android.gms.ads.identifier.** { *; }
-keep class com.android.installreferrer.** { *; }

# ----------------------------------------------------------
# WARNING SUPPRESSION
# ----------------------------------------------------------
-dontwarn com.google.android.gms.**

# ----------------------------------------------------------
# FLUTTER LOCAL NOTIFICATIONS
# ----------------------------------------------------------
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver
-keep class com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver
-dontwarn com.dexterous.flutterlocalnotifications.**

# ----------------------------------------------------------
# GSON & REFLECTION FIXES (FIXES "Missing type parameter" CRASH)
# ----------------------------------------------------------
# 1. Keep "Signature" so GSON can see Generic Types (e.g., List<String>)
-keepattributes Signature

# 2. Keep Annotations (often used by serialization libraries)
-keepattributes *Annotation*

# 3. Keep GSON library classes
-keep class com.google.gson.** { *; }
-keep class sun.misc.Unsafe { *; }

# 4. Keep the models inside the notification plugin so GSON can fill them
-keep class com.dexterous.flutterlocalnotifications.models.** { *; }

# ----------------------------------------------------------
# FACEBOOK SDK RULES
# ----------------------------------------------------------
-keep class com.facebook.** { *; }
-keep interface com.facebook.** { *; }
-keep enum com.facebook.** { *; }
-dontwarn com.facebook.**
-keep class com.facebook_app_events.** { *; }