
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

void UnitySendMessage(const char *,const char *,const char *);

@interface RNUnityBridge : RCTEventEmitter <RCTBridgeModule>
{
  NSMutableDictionary<NSString *,NSString *>* _stringMap;
  NSMutableDictionary<NSString *,NSNumber *>* _doubleMap;
}

- (void)sendUnityEvent:(NSString *)eventName body:(NSString *)body;

- (void)clearValues;
- (void)saveString:(NSString *)value forKey:(NSString *)key;
- (void)saveDouble:(double)value forKey:(NSString *)key;

@end

static RNUnityBridge *g_unityBridge = nil;

static bool g_unityAwake = false;
static bool g_unityStarted = false;

@implementation RNUnityBridge
{
  bool _hasListeners;
}

RCT_EXPORT_MODULE();

- (id)init {
  self = [super init];
  _hasListeners = false;

  _stringMap = [NSMutableDictionary new];
  _doubleMap = [NSMutableDictionary new];
  return self;
}

- (void)startObserving {
  _hasListeners = true;
}

- (void)stopObserving {
  _hasListeners = false;
}

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

- (NSArray<NSString *> *)supportedEvents {
  return @[@"UnityEvent"];
}

- (void)sendUnityEvent:(NSString *)name body:(NSString *)body {
  if (_hasListeners && super.bridge != nil) {
    [self sendEventWithName:@"UnityEvent" body:@{@"name": name, @"body": body}];
  }
}

RCT_EXPORT_METHOD(init:(RCTResponseSenderBlock)callback) {
  g_unityBridge = self;
  callback(@[[NSNull null]]);
}

RCT_EXPORT_METHOD(unitySendMessage:(NSString *)obj method:(NSString *)method message:(NSString *)message) {
  UnitySendMessage([obj UTF8String],[method UTF8String],[message UTF8String]);
}

RCT_EXPORT_METHOD(getUnityStatus:(RCTResponseSenderBlock)callback) {
  g_unityBridge = self;
  NSDictionary *ret = @{
    @"unityAwake": g_unityAwake ? @TRUE : @FALSE,
    @"unityStarted": g_unityStarted ? @TRUE : @FALSE,
  };
  callback(@[[NSNull null],ret]);
}

RCT_EXPORT_METHOD(fetchValues:(RCTResponseSenderBlock)callback) {
  NSDictionary *ret;
  @synchronized(self) {
    ret = @{
      @"stringMap": [NSDictionary dictionaryWithDictionary:_stringMap],
      @"doubleMap": [NSDictionary dictionaryWithDictionary:_doubleMap],
    };
  }
  callback(@[[NSNull null],ret]);
}

RCT_EXPORT_METHOD(clearValues:(RCTResponseSenderBlock)callback) {
  [self clearValues];
  callback(@[[NSNull null]]);
}

- (void)clearValues {
  @synchronized(self) {
    [_stringMap removeAllObjects];
    [_doubleMap removeAllObjects];
  }
}

- (void)saveString:(NSString *)value forKey:(NSString *)key {
  @synchronized(self) {
    [_stringMap setObject:value forKey:key];
  }
}

- (void)saveDouble:(double)value forKey:(NSString *)key {
  @synchronized(self) {
    [_doubleMap setObject:[NSNumber numberWithDouble:value] forKey:key];
  }
}

@end

void _clearValues() {
  [g_unityBridge clearValues];
}

void _sendDouble(const char *key, double value) {
  [g_unityBridge saveDouble:value
    forKey:[NSString stringWithCString:key encoding:NSUTF8StringEncoding]];
}
void _sendString(const char *key,const char *value) {
  [g_unityBridge saveString:[NSString stringWithCString:value encoding:NSUTF8StringEncoding]
    forKey:[NSString stringWithCString:key encoding:NSUTF8StringEncoding]];
}

void _fireEvent(const char *eventName,const char *message) {
  NSString *name = [NSString stringWithCString:eventName encoding:NSUTF8StringEncoding];
  NSString *msg = [NSString stringWithCString:message encoding:NSUTF8StringEncoding];
  if ([name isEqualToString:@"UnityAwake"]) {
    g_unityAwake = true;
  } else if ([name isEqualToString:@"UnityStart"]) {
    g_unityStarted = true;
  }

  [g_unityBridge sendUnityEvent:name body:msg];
}
