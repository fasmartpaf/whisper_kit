#import <Flutter/Flutter.h>

#if __has_include(<whisper_kit/whisper_kit-Swift.h>)
#import <whisper_kit/whisper_kit-Swift.h>
#else
// Support project import fallback
#if __has_include("whisper_kit-Swift.h")
#import "whisper_kit-Swift.h"
#else
@import whisper_kit.Swift;
#endif
#endif

// Note: WhisperKitPlugin is defined in Swift (WhisperKitPlugin.swift)
// The Swift compiler automatically generates the Objective-C interface
// No manual @interface declaration needed here