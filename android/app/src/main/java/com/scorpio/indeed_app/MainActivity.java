package com.scorpio.indeed_app;

import android.os.Bundle;
import android.os.PersistableBundle;
import android.app.NotificationManager;
import android.content.Context;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.plugins.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.embedding.android.FlutterFragmentActivity;
public class MainActivity extends  FlutterFragmentActivity {
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        GeneratedPluginRegistrant.registerWith(this.getFlutterEngine());
//    }
    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        // Removing All Notifications
        closeAllNotifications();}
    @Override
    protected void onResume() {
        super.onResume();

        // Removing All Notifications
        closeAllNotifications();
    }

    private void closeAllNotifications() {
        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.cancelAll();
    }
}
