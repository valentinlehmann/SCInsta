#import "../../Utils.h"

// Surface Instagram's built-in "Accounts you don't follow back" category in the
// Following list. IG already ships the whole feature — the server-side
// "not_following" sort and the category UI — but hides it behind a rollout test
// group. Flipping both gates makes it appear natively; the server still does the
// actual filtering, so it works across the full (paginated) following list.
//
// Gate 1: the network data source's test-group check.
%hook IGUserListNetworkDataSource
- (BOOL)_isInAFollowBackTestGroup {
    if ([SCIUtils getBoolPref:@"show_dont_follow_back_category"]) {
        return YES;
    }

    return %orig;
}
%end

// Gate 2: the follow-list view controller's UI "design enabled" flag (a plain ivar
// with no setter, so force it before the view builds its category chips).
%hook IGFollowListViewController
- (void)viewDidLoad {
    if ([SCIUtils getBoolPref:@"show_dont_follow_back_category"]) {
        MSHookIvar<BOOL>(self, "_isAccountsYouDontFollowBackDesignEnabled") = YES;
    }

    %orig;
}
%end
