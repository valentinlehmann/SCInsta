#import "../../Utils.h"
#import "../../InstagramHeaders.h"

// Channels dms tab (header)
%hook IGDirectInboxHeaderSectionController
- (id)viewModel {
    if ([[%orig title] isEqualToString:@"Suggested"]) {

        if ([SCIUtils getBoolPref:@"no_suggested_chats"]) {
            NSLog(@"[SCInsta] Hiding suggested chats (header: channels tab)");

            return nil;
        }

    }

    return %orig;
}
%end

// Suggested people to message/follow in the direct inbox ("Suggested" threads).
// Collapse the section by zeroing its cell size when the toggle is enabled.
%hook _TtC45IGDirectInboxSuggestedThreadSectionController45IGDirectInboxSuggestedThreadSectionController
- (CGSize)sizeForViewModel:(id)model {
    if ([SCIUtils getBoolPref:@"no_suggested_dms"]) {
        NSLog(@"[SCInsta] Hiding suggested DMs (inbox suggested threads)");

        return CGSizeZero;
    }

    return %orig;
}
%end