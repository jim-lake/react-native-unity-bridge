using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

public class ReactBridge : MonoBehaviour {
  public static ReactBridge instance;
  void Awake() {
    instance = this;
    FireEvent("UnityAwake");
  }
  void Start() {
    FireEvent("UnityStart");
  }

#if UNITY_EDITOR || (!UNITY_ANDROID && !UNITY_IPHONE)

  public static void ClearValues() {
    Debug.Log("ReactBridge.ClearValues");
  }
  public static void FireEvent(string eventName,string message = "") {
    Debug.Log("ReactBridge.FireEvent: name: " + eventName + ", messsage: " + message);
  }
  public static void SendDouble(string key,double value) {
    Debug.Log("ReactBridge.SendDouble: key: " + key + ", value: " + value);
  }
  public static void SendString(string key,string value) {
    Debug.Log("ReactBridge.SendString: key: " + key + ", value: " + value);
  }

#elif UNITY_IPHONE

  [DllImport("__Internal")]
  private static extern void _clearValues();
  [DllImport("__Internal")]
  private static extern void _sendDouble(string key, double value);
  [DllImport("__Internal")]
  private static extern void _sendString(string key, string value);
  [DllImport("__Internal")]
  private static extern void _fireEvent(string eventName, string message);

  public static void ClearValues() {
    _clearValues();
  }
  public static void FireEvent(string eventName,string message = "") {
    _fireEvent(eventName,message);
  }
  public static void SendDouble(string key,double value) {
    _sendDouble(key,value);
  }
  public static void SendString(string key,string value) {
    _sendString(key,value);
  }

#elif UNITY_ANDROID

#endif
}
