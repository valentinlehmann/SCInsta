#import "../../InstagramHeaders.h"
#import "../../Settings/SCISettingsViewController.h"

// Show SCInsta tweak settings by holding on the settings/more (burger) icon in the profile top bar.
//
// IG's profile nav-bar redesign moved this button into the Swift IGProfileNavigation
// module (class name still "IGBadgedNavigationButton") and renamed its
// accessibilityIdentifier ("profile-more-button" -> "profile-more-bar-button"), so the
// old single-class hook stopped firing. We now (1) hook both the legacy ObjC class and
// the new Swift class, and (2) add a class-agnostic fallback that finds the button by
// identifier on the profile screen. Attach logic lives in SCIUtils (matches either
// identifier, guards against double-attach).

// Legacy ObjC button class
%hook IGBadgedNavigationButton
- (void)didMoveToWindow {
    %orig;
    [SCIUtils attachSettingsShortcutToMoreButton:self];
}
%end

// New Swift button class (IGProfileNavigation.IGBadgedNavigationButton)
%hook _TtC19IGProfileNavigation24IGBadgedNavigationButton
- (void)didMoveToWindow {
    %orig;
    [SCIUtils attachSettingsShortcutToMoreButton:(UIView *)self];
}
%end

// Class-agnostic fallback: locate the more/burger button on the profile screen.
%hook IGProfileViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;

    UIViewController *vc = (UIViewController *)self;
    UIView *root = vc.viewIfLoaded.window ?: vc.viewIfLoaded;
    [SCIUtils attachSettingsShortcutSearchingHierarchy:root];
}
%end

// Quick access to tweak settings by holding on home tab button
%hook IGTabBarButton
- (void)didMoveToSuperview {
    %orig;

    // Only work on home/feed tab
    if (![self.accessibilityIdentifier isEqualToString:@"mainfeed-tab"]) return;
    
    if ([SCIUtils getBoolPref:@"settings_shortcut"]) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPress.minimumPressDuration = 0.3;
        
        // Take precidence over existing gesture recognizers
        for (UIGestureRecognizer *existing in self.gestureRecognizers) {
            [existing requireGestureRecognizerToFail:longPress];
        }
        
        [self addGestureRecognizer:longPress];
    }
}
%new - (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateBegan) return;

    [SCIUtils showSettingsVC:[self window]];
}
%end