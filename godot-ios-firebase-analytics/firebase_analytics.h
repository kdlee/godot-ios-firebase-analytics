//
//  firebase_analytics.h
//  godot-ios-firebase-analytics
//
//  Created by YamazakiAkio on 2022/02/09.
//

#ifndef firebase_analytics_h
#define firebase_analytics_h

#include "core/version.h"

#if VERSION_MAJOR == 4
#include "core/object/class_db.h"
#else
#include "core/object.h"
#endif

#import <UIKit/UIKit.h>

#import <FirebaseCore/FIRApp.h>
#import <FIRAnalytics.h>
#import <FirebaseOAuthUI/FirebaseOAuthUI.h>
#import <FirebaseAuthUI/FirebaseAuthUI.h>
#import <FirebaseGoogleAuthUI/FUIGoogleAuth.h>

@interface AuthHandler : UITableViewController
@end

class FirebaseAnalytics : public Object {
    GDCLASS(FirebaseAnalytics, Object);

    static FirebaseAnalytics* _singleton;

    FUIAuth* _authUI;
    AuthHandler* _authHandler;

    static void _bind_methods();

public:
    void log_event(String event, Dictionary params);
    void sign_in();
    bool is_signed_in();
    void sign_out();

    static FirebaseAnalytics* get_singleton() { return _singleton; }

    FirebaseAnalytics();
    ~FirebaseAnalytics();
};

#endif /* firebase_analytics_h */
