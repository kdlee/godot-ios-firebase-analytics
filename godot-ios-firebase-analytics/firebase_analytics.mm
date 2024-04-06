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

#import <FirebaseCore/FIRApp.h>

void FirebaseAnalytics::_bind_methods() {
    ClassDB::bind_method(D_METHOD("configure"), &FirebaseAnalytics::configure);
}

void FirebaseAnalytics::configure() {
    NSLog(@"FIRApp configure");
    [FIRApp configure];
}

FirebaseAnalytics::FirebaseAnalytics() {
    NSLog(@"initialize FirebaseAnalytics");
}

FirebaseAnalytics::~FirebaseAnalytics() {
    NSLog(@"deinitialize FirebaseAnalytics");
}
