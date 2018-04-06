package com.jimlake;

import android.util.Log;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter;

import com.unity3d.player.UnityPlayer;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class RNUnityBridgeModule extends ReactContextBaseJavaModule {
  private static final String TAG = "RNUnityBridgeModule";

  private static RNUnityBridgeModule instance = null;
  private static boolean unityAwake = false;
  private static boolean unityStarted = false;

  private static ConcurrentHashMap<String,String> stringMap = new ConcurrentHashMap<String,String>();
  private static ConcurrentHashMap<String,Double> doubleMap = new ConcurrentHashMap<String,Double>();

  private final ReactApplicationContext reactContext;

  public RNUnityBridgeModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNUnityBridge";
  }

  @ReactMethod
  public void init(final Callback callback) {
    RNUnityBridgeModule.instance = this;
    callback.invoke((Object)null);
  }

  @ReactMethod
  public void unitySendMessage(final String obj,final String method, final String message) {
    UnityPlayer.UnitySendMessage(obj,method,message);
  }

  @ReactMethod
  public void getUnityStatus(final Callback callback) {
    RNUnityBridgeModule.instance = this;

    final WritableMap map = new WritableNativeMap();
    map.putBoolean("unityAwake",RNUnityBridgeModule.unityAwake);
    map.putBoolean("unityStarted",RNUnityBridgeModule.unityStarted);
    callback.invoke((Object)null,map);
  }

  @ReactMethod
  public void fetchValues(final Callback callback) {
    final WritableMap sMap = new WritableNativeMap();
    final WritableMap dMap = new WritableNativeMap();

    for (Map.Entry<String,String> entry : stringMap.entrySet()) {
      sMap.putString(entry.getKey(),entry.getValue());
    }
    for (Map.Entry<String,Double> entry : doubleMap.entrySet()) {
      dMap.putDouble(entry.getKey(),entry.getValue());
    }

    final WritableMap map = new WritableNativeMap();
    map.putMap("stringMap",sMap);
    map.putMap("doubleMap",dMap);
    callback.invoke((Object)null,map);
  }

  @ReactMethod
  public void clearValues(final Callback callback) {
    RNUnityBridgeModule.ClearValues();
    callback.invoke((Object)null);
  }

  public static void FireEvent(final String name,final String body) {
    if (name.equals("UnityAwake")) {
      RNUnityBridgeModule.unityAwake = true;
    } else if (name.equals("UnityStart")) {
      RNUnityBridgeModule.unityStarted = true;
    }

    if (RNUnityBridgeModule.instance != null) {
      final WritableMap map = new WritableNativeMap();
      map.putString("name",name);
      map.putString("body",body);

      RNUnityBridgeModule.instance.getReactApplicationContext()
        .getJSModule(RCTDeviceEventEmitter.class)
        .emit("UnityEvent", map);
    }
  }
  public static void ClearValues() {
    doubleMap.clear();
    stringMap.clear();
  }
  public static void SendDouble(final String key, final double value) {
    doubleMap.put(key,value);
  }
  public static void SendString(final String key, final String value) {
    stringMap.put(key,value);
  }
}
