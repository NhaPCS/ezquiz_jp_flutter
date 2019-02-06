package com.nhapcs.ezquizflutter;

import android.os.Bundle;

import com.google.android.gms.ads.MobileAds;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    MobileAds.initialize(this, "ca-app-pub-9000513260892268~5481777220");
    GeneratedPluginRegistrant.registerWith(this);
  }
}
