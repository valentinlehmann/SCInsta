#import "../../Utils.h"

// Legacy hook (for non ai voices interface)
// IG extended this delegate callback with aiVoiceEffect/sendButtonType args.
%hook IGDirectThreadViewController
- (void)voiceRecordViewController:(id)arg1 didRecordAudioClipWithURL:(id)arg2 waveform:(id)arg3 duration:(CGFloat)arg4 entryPoint:(NSInteger)arg5 aiVoiceEffectApplied:(BOOL)arg6 aiVoiceEffectType:(NSInteger)arg7 sendButtonTypeTapped:(NSInteger)arg8 {
    if ([SCIUtils getBoolPref:@"voice_message_confirm"]) {
        NSLog(@"[SCInsta] DM audio message confirm triggered");

        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end

// Workaround until I can figure out how to stop long press recording from automatically sending
// IG moved this to IGDirectComposerButtonController and renamed it _didLongPressVoiceMessageButton:
%hook IGDirectComposerButtonController
- (void)_didLongPressVoiceMessageButton:(id)arg1 {
    if ([SCIUtils getBoolPref:@"voice_message_confirm"]) {
        return;
    } else {
        return %orig;
    }
}
%end

// Demangled name: IGDirectAIVoiceUIKit.CompactBarContentView
%hook _TtC20IGDirectAIVoiceUIKitP33_5754F7617E0D924F9A84EFA352BBD29A21CompactBarContentView
- (void)didTapSend {
    if ([SCIUtils getBoolPref:@"voice_message_confirm"]) {
        NSLog(@"[SCInsta] DM audio message confirm triggered");

        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end