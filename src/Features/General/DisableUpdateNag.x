#import "../../Utils.h"
#import "../../InstagramHeaders.h"

// Instagram Beta shows a "It's time to update Instagram Beta" / "TestFlight Update
// Available" overlay once the installed beta build is considered outdated. It's driven
// by IGCoreRootTestFlightNagPlugin -> IGTestFlightVersionChecker and presented through
// this Swift view controller (a subclass of the ObjC-visible METANoCodingViewController)
// via an IGPopoverController modal. When it decides it's "blocking" it locks the user
// out of the app entirely — pointless when a specific version is intentionally pinned
// through the tweak. Dismiss it the moment it appears.
%hook _TtC29IGCoreRootTestFlightNagPlugin35TestFlightUpdateNudgeViewController

- (void)viewDidLoad {
    %orig;

    // Hide up front so the overlay never visibly flashes before we can dismiss it.
    if ([SCIUtils getBoolPref:@"disable_update_nag"]) {
        [(UIViewController *)self view].hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    %orig;

    if ([SCIUtils getBoolPref:@"disable_update_nag"]) {
        NSLog(@"[SCInsta] Dismissing TestFlight beta update nag");

        UIViewController *vc = (UIViewController *)self;

        // Presented modally through IGPopoverController — the expected path.
        [vc dismissViewControllerAnimated:NO completion:nil];

        // Fallback in case it was installed as a child VC / bare view instead.
        [vc.view removeFromSuperview];
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
}

%end
