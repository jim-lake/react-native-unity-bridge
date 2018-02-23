'use strict';

import ReactNative from 'react-native';
import EventEmitter from 'events';

const {
  StyleSheet,
  Text,
  View,
  TouchableHighlight,
  NativeEventEmitter,
  NativeModules,
} = ReactNative;

const { RNUnityBridge } = NativeModules;

const g_eventEmitter = new EventEmitter();

const g_unityEventEmitter = new NativeEventEmitter(RNUnityBridge);

g_unityEventEmitter.addListener('UnityEvent',(e) => {
  g_eventEmitter.emit(e.name,e.body);
});

function on(event,callback) {
  eventEmitter.on(event,callback);
}
function removeListener(event,callback) {
  eventEmitter.removeListener(event,callback);
}

function sendMessage(obj,method,message) {
  if (typeof message == 'object') {
    message = JSON.stringify(message);
  } else if (typeof message != 'string') {
    message = message.toString();
  }

  RNUnityBridge.unitySendMessage(obj,method,message);
}

let g_cachedStringMap = {};
let g_cachedDoubleMap = {};

function fetchValues(done) {
  if (!done) {
    done = function() {};
  }
  RNUnityBridge.fetchValues((err,results) => {
    if (!err && results) {
      g_cachedDoubleMap = results.doubleMap;
      g_cachedStringMap = results.stringMap;
    }
    done(err,results);
  });
}

let g_fetchInterval;
function setFetchInterval(timeout) {
  if (g_fetchInterval) {
    clearInterval(g_fetchInterval);
  }
  g_fetchInterval = setInterval(fetchValues,timeout);
}

function getCachedString(key,default_value) {
  let ret = default_value;
  if (key in g_cachedStringMap) {
    ret = g_cachedStringMap[key];
  }
  return ret;
}

function getCachedDouble(key,default_value) {
  let ret = default_value;
  if (key in g_cachedDoubleMap) {
    ret = g_cachedDoubleMap[key];
  }
  return ret;
}

export default {
  on,
  removeListener,
  sendMessage,
  fetchValues,
  setFetchInterval,
  getCachedString,
  getCachedDouble,
};
