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
  
import java.util.Arrays;
import java.util.List;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import java.util.Random;

public class MainActivity extends FlutterActivity {

    private static final String THINGSCALLBACK_CHANNEL = "icusensor.odroidm1.io/thingscallback";
    private static final String THINGSIO_CHANNEL = "icusensor.odroidm1.io/thingsio";
    
    HashMap<String, String> retData ;
    HashMap<String, String> retError ;
    double temp = 35 ;
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    
    retError = new HashMap<String, String>();
    retData = new HashMap<String, String>();
    initMap();
     

    new EventChannel(flutterEngine.getDartExecutor(), THINGSCALLBACK_CHANNEL).setStreamHandler(
        new StreamHandler() {   
            @Override
            public void onListen(Object arguments, EventSink events) {  
               
            }

            @Override
            public void onCancel(Object arguments) {
                 
            }
        }
        );


    new MethodChannel(flutterEngine.getDartExecutor(), THINGSIO_CHANNEL).setMethodCallHandler(
        new MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, Result result) {
                if (call.method.equals("UartSendRecieve")) {  
                  
                    String msgSend =  call.arguments(); 
                    //Log.d("UartSend", "msg - " + msgSend);  

                  Handler handler = new Handler();
                    handler.postDelayed(new Runnable() {
                        public void run() { 
                            try { 
                                 //  Log.d("onUart", "msg - " + retString);
                                   ////--------------------------------------
                                 //  processString(retString);
                   
                                 Random rand = new Random(); 
                                 //generate random values from 0-24
                                 // int int_random = rand.nextInt(upperbound); 
                                // double double_random=rand.nextDouble();
                                temp -= 1;
                                if (temp < 23){
                                    if (temp < 18)
                                    {
                                        temp = 33;
                                        retData.put("ValTemp",String.format("%.02f", temp));
                                        retData.put("ConSfPwmTemp", "127");
                                    }else{
                                        double t = 25;
                                        retData.put("ValTemp",String.format("%.02f", t));
                                        retData.put("ConSfPwmTemp", "0");
                                    }    
                                }else{
                                    retData.put("ValTemp",String.format("%.02f", temp));
                                    retData.put("ConSfPwmTemp", "127");
                                }

                               // double myTemp = 18 + rand.nextDouble() * (25 - 18);
                                double myO2 = 20 + rand.nextDouble() * (25 - 20);
                                double myCo2 = 400+ rand.nextDouble() * (900 - 400);
                                double myHu = 60 + rand.nextDouble() * (70 - 60);
                                

                                 //retData.put("ValTemp",String.format("%.02f", myTemp));
                                 retData.put("TargetTemp", "25");   
                                 retData.put("ConStateTemp", "1");
                                 retData.put("ConTimerTemp", "0");
                                 retData.put("ConMode1Temp", "0");
                                 retData.put("ConMode2Temp", "0");
                                 retData.put("ConElapsTemp", "0");
                             //    retData.put("ConSfPwmTemp", "0");
                                 retData.put("ValO2", String.format("%.02f", myO2));
                                 retData.put("TargetO2", "30");
                                 retData.put("ConStateO2", "2");
                                 retData.put("HysteresisO2", "5");
                                 retData.put("ValCo2", String.format("%02f", myCo2));
                                 retData.put("TargetCo2", "400");
                                 retData.put("HysteresisCo2", String.format("%.02f", myHu));
                                 retData.put("ValHumi", "60");

                                  // Log.d(TAG, "MESSAGE return start: " );
                                   ////------------------------------------------------- 
                                     runOnUiThread(new Runnable() {
                                        @Override
                                        public void run() { 
                                             result.success(retData); 
                                        }
                                    });
                          }catch (Exception e) {
                                e.printStackTrace();
                                result.error("UartSendRecieve", "ERR_MSG_PARAMETER", retError);
                            }
                   }
                   }, 100);  
                } 
                else if (call.method.equals("UartSend")) {  
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

    private void initMap(){
        ////
        retError.put("Error", "1"); 
        ////
        retData.put("Error", "0");
        retData.put("GainTemp", "1");
        retData.put("OffsetTemp", "0");
        retData.put("GainO2", "1");
        retData.put("OffsetO2", "0");
        retData.put("GainCo2", "1");
        retData.put("OffsetCo2", "0");
        retData.put("GainHumi", "1");
        retData.put("OffsetHumi", "0");
        retData.put("ValTemp","25");
        retData.put("TargetTemp", "25");
        retData.put("HysteresisTemp", "2");
        retData.put("ValO2", "20");
        retData.put("TargetO2", "30");
        retData.put("HysteresisO2", "5");
        retData.put("ValCo2", "500");
        retData.put("TargetCo2", "400");
        retData.put("HysteresisCo2", "50");
        retData.put("ValHumi", "60");
        retData.put("TargetHumi", "50");
        retData.put("HysteresisHumi", "5");
        retData.put("ConStateTemp", "1");
        retData.put("ConTimerTemp", "0");
        retData.put("ConMode1Temp", "0");
        retData.put("ConMode2Temp", "0");
        retData.put("ConElapsTemp", "0");
        retData.put("ConSfPwmTemp", "0");
        retData.put("ConInvTemp", "0");
        retData.put("ConStateO2", "0");
        retData.put("ConTimerO2", "0");
        retData.put("ConMode1O2", "0");
        retData.put("ConMode2O2", "0");
        retData.put("ConElapsO2", "0");
        retData.put("ConSfPwmO2", "0");
        retData.put("ConInvO2", "0");
        retData.put("ConStateCo2", "0");
        retData.put("ConTimerCo2", "0");
        retData.put("ConMode1Co2", "0");
        retData.put("ConMode2Co2", "0");
        retData.put("ConElapsCo2", "0");
        retData.put("ConSfPwmCo2", "0");
        retData.put("ConInvCo2", "0");
        retData.put("ConStateHumi", "0");
        retData.put("ConTimerHumi", "0");
        retData.put("ConMode1Humi", "0");
        retData.put("ConMode2Humi", "0");
        retData.put("ConElapsHumi", "0");
        retData.put("ConSfPwmHumi", "0");
        retData.put("ConInvHumi", "0");
        retData.put("ConStateLight", "0");
        retData.put("ConTimerLight","0");
        retData.put("ConMode1Light", "0");
        retData.put("ConMode2Light", "0");
        retData.put("ConElapsLight", "0");
        retData.put("ConStateUvc", "0");
        retData.put("ConTimerUvc", "0");
        retData.put("ConMode1Uvc", "0");
        retData.put("ConMode2Uvc", "0");
        retData.put("ConElapsUvc", "0");
        retData.put("ConStateNebu", "0");
        retData.put("ConTimerNebu", "0");
        retData.put("ConMode1Nebu", "0");
        retData.put("ConMode2Nebu", "0");
        retData.put("ConElapsNebu", "0"); 
        retData.put("ConStateIron", "0");
        retData.put("ConTimerIron", "0");
        retData.put("ConMode1Iron", "0");
        retData.put("ConMode2Iron", "0");
        retData.put("ConElapsIron", "0");
        retData.put("RgbRed", "127");
        retData.put("RgbGreen","127");
        retData.put("RgbBlue", "127");
        retData.put("RgbBright", "127");
        retData.put("FanTemp", "64");
        retData.put("FanO2", "127");
        retData.put("FanHumi", "0");
        retData.put("DatatimeYear", "0");
        retData.put("DatatimeMonth", "0");
        retData.put("DatatimeDay", "0");
        retData.put("DatatimeHour", "0");
        retData.put("DatatimeMinite", "0");
        retData.put("DatatimeSeconde", "0");
        retData.put("Thermal0", "31");
        retData.put("Thermal1", "32");
        retData.put("Thermal2","33");
        retData.put("Thermal3","34");
    }
 
}

 
 