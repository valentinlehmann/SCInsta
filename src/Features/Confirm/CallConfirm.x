#import "../../Utils.h"

%hook IGDirectThreadCallButtonsCoordinator
// Voice Call — IG dropped the sender argument (was _didTapAudioButton:)
- (void)_didTapAudioButton {
    if ([SCIUtils getBoolPref:@"call_confirm"]) {
        NSLog(@"[SCInsta] Call confirm triggered");

        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}

// Video Call — IG dropped the sender argument (was _didTapVideoButton:)
- (void)_didTapVideoButton {
    if ([SCIUtils getBoolPref:@"call_confirm"]) {
        NSLog(@"[SCInsta] Call confirm triggered");

        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end