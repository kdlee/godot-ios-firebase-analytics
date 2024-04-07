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
#import <FIRAnalytics.h>


void FirebaseAnalytics::_bind_methods() {
    ClassDB::bind_method(D_METHOD("configure"), &FirebaseAnalytics::configure);
    ClassDB::bind_method(D_METHOD("log_event", "event", "params"), &FirebaseAnalytics::log_event);
}

void FirebaseAnalytics::configure() {
    NSLog(@"FIRApp configure");
    [FIRApp configure];
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

FirebaseAnalytics::FirebaseAnalytics() {
    NSLog(@"initialize FirebaseAnalytics");
}

FirebaseAnalytics::~FirebaseAnalytics() {
    NSLog(@"deinitialize FirebaseAnalytics");
}
