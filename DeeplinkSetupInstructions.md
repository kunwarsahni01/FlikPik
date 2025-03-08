# YouTube Deeplink Setup Instructions

To enable the FlikPik app to open trailers directly in the YouTube app, you need to add the `youtube` URL scheme to your Info.plist file.

## Steps:

1. Open your project in Xcode
2. Find the Info.plist file (usually in the main app target)
3. Add the following entries:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>youtube</string>
</array>
```

If you already have an LSApplicationQueriesSchemes array in your Info.plist, just add the `youtube` string to it.

## What this does:

This tells iOS that your app will try to open URLs with the `youtube://` scheme, which allows deep linking directly into the YouTube app. Without this declaration, iOS will not allow your app to open these URLs starting in iOS 9+.

## Testing:

After adding this to your Info.plist:
1. Build and run the app
2. Go to a movie with trailers
3. Tap on a trailer
4. The YouTube app should open directly to the trailer (if installed)
5. If the YouTube app is not installed, it will fallback to opening the video in a web browser