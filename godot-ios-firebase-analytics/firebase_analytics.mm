//
//  firebase_analytics.m
//  godot-ios-firebase-analytics
//
//  Created by YamazakiAkio on 2022/02/09.
//

#include "firebase_analytics.h"

#import <Foundation/Foundation.h>

#if VERSION_MAJOR == 4
#include "core/object/class_db.h"
#include "core/config/project_settings.h"
#else
#include "core/class_db.h"
#include "core/project_settings.h"
#endif


@interface AuthHandler () <FUIAuthDelegate, NSURLSessionDataDelegate>

@end

@implementation AuthHandler {
}

#pragma mark - FUIAuthDelegate methods

- (void)authUI:(FUIAuth *)authUI didSignInWithUser:(nullable FIRUser *)user error:(nullable NSError *)error {
    NSLog(@"[AuthUI] didSignInWithUser");
    if (error) {
        Dictionary d;
        d["success"] = false;
        d["err_code"] = error.code;
        if (error.code == FUIAuthErrorCodeUserCancelledSignIn) {
            d["err_reason"] = "user_cancel";
        }
        else {
            NSError *detailedError = error.userInfo[NSUnderlyingErrorKey];
            d["err_reason"] = detailedError.localizedDescription;
        }
        FirebaseAnalytics::get_singleton()->emit_signal("on_sign_in", d);
    }
    else {
        [user getIDTokenForcingRefresh:YES completion:^(NSString *_Nullable idToken, NSError *_Nullable error) {
            NSLog(@"[AuthUI] id_token=%@", idToken);
            Dictionary d;
            if (error) {
                NSLog(@"[AuthUI] get token error");
                d["success"] = false;
                d["err_code"] = error.code;
            }
            else {
                d["success"] = true;
                d["providerID"] = user.providerID;
                d["email"] = user.email;
                d["uid"] = user.uid;
                d["displayName"] = user.displayName;
                d["id_token"] = idToken;
            }
            FirebaseAnalytics::get_singleton()->emit_signal("on_sign_in", d);
        }];
    }
}

- (void)showAlert:(NSString *)message {
  UIAlertController *alert =
      [UIAlertController alertControllerWithTitle:@"Error"
                                          message:message
                                   preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction* closeButton =
      [UIAlertAction actionWithTitle:@"Close"
                               style:UIAlertActionStyleDefault
                             handler:nil];
  [alert addAction:closeButton];
  [self presentViewController:alert animated:YES completion:nil];

}

@end


FirebaseAnalytics* FirebaseAnalytics::_singleton = nullptr;


void FirebaseAnalytics::_bind_methods() {
    ADD_SIGNAL(MethodInfo("on_sign_in"));
    ADD_SIGNAL(MethodInfo("on_sign_out"));

    ClassDB::bind_method(D_METHOD("log_event", "event", "params"), &FirebaseAnalytics::log_event);
    ClassDB::bind_method(D_METHOD("sign_in"), &FirebaseAnalytics::sign_in);
    ClassDB::bind_method(D_METHOD("is_signed_in"), &FirebaseAnalytics::is_signed_in);
    ClassDB::bind_method(D_METHOD("sign_out"), &FirebaseAnalytics::sign_out);
}

void FirebaseAnalytics::log_event(String event, Dictionary params) {
    NSMutableDictionary *nsDictionary = [NSMutableDictionary dictionary];

    Array keys = params.keys();
    int size = keys.size();
    for (int i = 0; i < size; ++i) {
        String key = keys[i];
        String value = params[key];
        NSString *nsKey = [NSString stringWithUTF8String:key.utf8().get_data()];
        NSString *nsValue = [NSString stringWithUTF8String:value.utf8().get_data()];
        [nsDictionary setValue:nsValue forKey:nsKey];
    }

    [FIRAnalytics logEventWithName:[NSString stringWithUTF8String:event.utf8().get_data()] parameters:nsDictionary];
}

void FirebaseAnalytics::sign_in() {
    UIViewController *root_controller = [[UIApplication sharedApplication] delegate].window.rootViewController;
    UINavigationController* avc = [_authUI authViewController];
    [root_controller presentViewController:avc animated:YES completion:nil];
}

bool FirebaseAnalytics::is_signed_in() {
    return [_authUI.auth currentUser] != nullptr;
}

void FirebaseAnalytics::sign_out() {
    [_authUI signOutWithError:nullptr];
    emit_signal("on_sign_out");
}


FirebaseAnalytics::FirebaseAnalytics() {
    NSLog(@"initialize FirebaseAnalytics");
    _singleton = this;

    [FIRApp configure];
    _authUI = [FUIAuth defaultAuthUI];
    _authHandler = [[AuthHandler alloc] init];
    _authUI.delegate = _authHandler;
    NSArray<id<FUIAuthProvider>> *providers = @[
        [[FUIGoogleAuth alloc] initWithAuthUI:_authUI],
        // [[FUIFacebookAuth alloc] init],
        // [[FUITwitterAuth alloc] init],
        // [[FUIPhoneAuth alloc] initWithAuthUI:[FUIAuth defaultAuthUI]]
        [FUIOAuth appleAuthProvider],
    ];
    _authUI.providers = providers;
}

FirebaseAnalytics::~FirebaseAnalytics() {
    NSLog(@"deinitialize FirebaseAnalytics");
    _singleton = nullptr;
}
