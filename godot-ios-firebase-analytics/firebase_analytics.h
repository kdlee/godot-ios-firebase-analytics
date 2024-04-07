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


class FirebaseAnalytics : public Object {
    GDCLASS(FirebaseAnalytics, Object);

    static void _bind_methods();

public:

    void configure();
    void log_event(String event, Dictionary params);

    FirebaseAnalytics();
    ~FirebaseAnalytics();
};

#endif /* firebase_analytics_h */
