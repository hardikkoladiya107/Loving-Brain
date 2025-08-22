# Keep Stripe SDK classes
-keep class com.stripe.android.** { *; }
-keep class com.reactnativestripesdk.** { *; }

# Ignore warnings about push provisioning (if unused)
-dontwarn com.stripe.android.pushProvisioning.**
-dontwarn com.reactnativestripesdk.pushprovisioning.**
