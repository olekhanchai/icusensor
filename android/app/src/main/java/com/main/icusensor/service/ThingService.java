package com.main.icusensor.service;

import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.IBinder;
import androidx.annotation.Nullable;
import com.google.android.things.pio.PeripheralManager;
import com.google.android.things.pio.UartDevice;
import com.google.android.things.pio.UartDeviceCallback;
import com.google.gson.Gson;
import org.greenrobot.eventbus.EventBus;
import org.jam.ChangeInfo;
import org.jam.Diff4J;
import java.io.IOException;
import java.util.Collection;
import java.util.List;
import io.flutter.plugin.common.EventChannel;

public class ThingService extends Service implements EventChannel.StreamHandler {
    final IBinder binder = new ThingBinder();
    UartDeviceCallback callback;
    String retString = "";
    String temp = "";
    String oldString = "";
    UartDevice uart;
    static String callbackString = "";
    static String sendString = "";
    private EventChannel.EventSink thingEventSink;

    @Override
    public void onCreate() {
        super.onCreate();
        final String TAG = ThingService.class.getSimpleName();

        HandlerThread uartBackGround = new HandlerThread("UartBackground");
        uartBackGround.start();
        Handler uartHandelr = new Handler(uartBackGround.getLooper());

        // get Peripheral Manager for managing the gpio.
        PeripheralManager manager = PeripheralManager.getInstance();

        // get available uart pin list.
        // each uart name is UART-# number.
        List<String> uartList = manager.getUartDeviceList();     

        try {
            // get first available a uart.
            // in this case, UART-1 is used.
            uart = manager.openUartDevice(uartList.get(0));
            byte[] buff = new byte[20];
            // baudrate - 115200, 8N1, non hardware flow control
            uart.setBaudrate(115200);
            uart.setDataSize(8);
            uart.setParity(UartDevice.PARITY_NONE);
            uart.setStopBits(1);
            uart.setHardwareFlowControl(UartDevice.HW_FLOW_CONTROL_NONE);

            Thread t = new Thread() {
                public void run() {
                    while(true) {
                        if (!sendString.isEmpty()) {
                            try {
                                String msgSend = sendString;
                                byte[] msgByte = msgSend.getBytes("UTF-8");
                                uart.flush(UartDevice.FLUSH_IN_OUT);
                                uart.write(msgByte, msgByte.length);
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                            sendString="";
                        }
                    }
                }
            };
            t.start();

            callback = new UartDeviceCallback() {
                @Override
                public boolean onUartDeviceDataAvailable(UartDevice uartDevice) {
                    try {
                        temp = "";
                        int length = uartDevice.read(buff, 20);

                        if (length > 0) {
                            temp = new String(buff, 0, length, "UTF-8");
                        }

                        retString += temp;

                        if(retString.contains("ok")) {
                            retString = "";
                            oldString = "";
                            callbackString = "";
                        }

                        if(retString.contains("}") && oldString.isEmpty()) {
                                oldString = retString;
                                retString = "";
                        }
                        if(retString.contains("}") && !oldString.isEmpty()) {
                            callbackString = "";
                            temp = "{";
                            // Diff4J comparator = new Diff4J();
                            // Gson gson = new Gson();
                            // Gson gson2 = new Gson();
                            // Collection<ChangeInfo> diffs = comparator.diff(gson.fromJson(oldString, RetData.class), gson2.fromJson(retString, RetData.class));
                            // for(ChangeInfo c : diffs)
                            // {
                            //     temp += "\""+c.getFieldName()+"\":\""+c.getTo()+"\",";
                            // }
                            temp += "\"result\":\"OK\"}";
                            callbackString = temp;
                            oldString = "";              
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    return true;
                }
            };
            uart.registerUartDeviceCallback(uartHandelr, callback);
        } catch (Exception exception) {
            exception.printStackTrace();
        }
    }

    public void sendUart(String input) {
        sendString = input;
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return binder;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return Service.START_NOT_STICKY;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().unregister(this);
    }  

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        thingEventSink = events;
        //thingEventSink.success(callbackString);
    }

    @Override
    public void onCancel(Object arguments) {
        thingEventSink = null;
    }
 
    public class ThingBinder extends Binder {
        public ThingService getService() {
            return ThingService.this;
        }
    }

}