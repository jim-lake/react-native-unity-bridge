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
let g_unityAwake = false;
let g_unityStarted = false;

g_unityEventEmitter.addListener('UnityEvent',(e) => {
  if (e.name == 'UnityAwake') {
    g_unityAwake = true;
  } else if (e.name == 'UnityStart') {
    g_unityStarted = true;
  }
  g_eventEmitter.emit(e.name,e.body);
});

RNUnityBridge.getUnityStatus((err,result) => {
  if (!err && result) {
    g_unityAwake = result.unityAwake;
    g_unityStarted = result.unityStarted;
    if (g_unityAwake) {
      g_eventEmitter.emit('UnityAwake');
    }
    if (g_unityStarted) {
      g_eventEmitter.emit('UnityStart');
    }
  }
});

function once(event,callback) {
  g_eventEmitter.once(event,callback);
}
function on(event,callback) {
  g_eventEmitter.on(event,callback);
}
function removeListener(event,callback) {
  g_eventEmitter.removeListener(event,callback);
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

function clearValues(done) {
  if (!done) {
    done = function() {};
  }
  RNUnityBridge.clearValues((err) => {
    g_cachedDoubleMap = {};
    g_cachedStringMap = {};
    done(err);
  });
}

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

function isAwake() {
  return g_unityAwake;
}
function isStarted() {
  return g_unityStarted;
}

export default {
  once,
  on,
  removeListener,
  sendMessage,
  clearValues,
  fetchValues,
  setFetchInterval,
  getCachedString,
  getCachedDouble,
  isAwake,
  isStarted,
};
