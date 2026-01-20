#import "WhisperKitPlugin.h"
#import "../src/main.h"
#import <Foundation/Foundation.h>

@interface WhisperKitPlugin (CPPIntegration)
@end

@implementation WhisperKitPlugin (CPPIntegration)

- (NSString *)processAudioWithModel:(NSString *)audioPath modelPath:(NSString *)modelPath options:(NSDictionary *)options {
    // Convert NSString to C strings
    const char *audioPathCStr = [audioPath UTF8String];
    const char *modelPathCStr = [modelPath UTF8String];

    // Create JSON request dictionary
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    requestDict[@"model"] = modelPath;
    requestDict[@"audio"] = audioPath;
    requestDict[@"threads"] = options[@"threads"] ?: @(4);
    requestDict[@"language"] = options[@"language"] ?: @"auto";
    requestDict[@"is_verbose"] = options[@"isVerbose"] ?: @(NO);
    requestDict[@"is_translate"] = options[@"isTranslate"] ?: @(NO);
    requestDict[@"is_no_timestamps"] = options[@"isNoTimestamps"] ?: @(NO);
    requestDict[@"is_special_tokens"] = options[@"isSpecialTokens"] ?: @(NO);
    requestDict[@"split_on_word"] = options[@"splitOnWord"] ?: @(NO);

    // Convert to JSON string
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDict options:0 error:&jsonError];
    if (jsonError) {
        NSLog(@"JSON serialization error: %@", jsonError.localizedDescription);
        return nil;
    }

    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    const char *jsonCStr = [jsonString UTF8String];

    // Make a mutable copy for the C function
    char *jsonMutable = strdup(jsonCStr);

    // Call the C++ function (declare extern to avoid name collision)
    extern char *request(char *);
    char *result = request(jsonMutable);

    // Convert result back to NSString
    NSString *resultString = nil;
    if (result) {
        resultString = [NSString stringWithUTF8String:result];
        free(result); // Don't forget to free the allocated memory
    }

    free(jsonMutable);
    return resultString;
}

@end