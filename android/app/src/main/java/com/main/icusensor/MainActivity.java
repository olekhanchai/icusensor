package com.main.icusensor;

import io.flutter.embedding.android.FlutterActivity;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle; 
import android.os.Handler;
import android.os.HandlerThread;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugins.GeneratedPluginRegistrant;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;

import java.io.File;
import java.io.FileNotFoundException;
import java.lang.reflect.Method;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.Objects;

import android.util.Log;

import com.main.icusensor.service.PushNotificationService;
import com.main.icusensor.service.ThingService;
import java.util.Arrays;
import java.util.List;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class MainActivity extends FlutterActivity {

    private static final String THINGSCALLBACK_CHANNEL = "icusensor.odroidm1.io/thingscallback";
    private static final String THINGSIO_CHANNEL = "icusensor.odroidm1.io/thingsio";
    private ThingService thingService = new ThingService();
    //private PushNotificationService pushService = new PushNotificationService();
    HashMap<String, String> retError ;
  
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine); 
    retError = new HashMap<String, String>();
    Intent thing = new Intent(getApplicationContext(), ThingService.class);
    //Intent push = new Intent(getApplicationContext(), PushNotificationService.class);
    startService(thing);
    //startService(push);
    new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), THINGSCALLBACK_CHANNEL).setStreamHandler(thingService);
    new MethodChannel(flutterEngine.getDartExecutor(), THINGSIO_CHANNEL).setMethodCallHandler(
        new MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, Result result) {
            if (call.method.equals("UartSend")) {  
                String msgSend =  call.arguments();  
                try {  
                  
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() { 
                            result.success(0);
                        }
                    });       
                  }catch (Exception e) {
                    e.printStackTrace();
                    result.error("UartSend", "ERR_MSG_PARAMETER", retError); 
                }
                
                }
                else {
                    result.notImplemented();
                }
            }
        }

        
   );
  }
}

 
 