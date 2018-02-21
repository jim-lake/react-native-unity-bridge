
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

void UnitySendMessage(const char *,const char *,const char *);

@interface RNUnityBridge : RCTEventEmitter <RCTBridgeModule>
{
    NSMutableDictionary<NSString *,NSString *>* _stringMap;
    NSMutableDictionary<NSString *,NSNumber *>* _doubleMap;
}

- (void)sendUnityEvent:(NSString *)eventName body:(NSString *)body;

- (void)saveString:(NSString *)value forKey:(NSString *)key;

- (void)saveDouble:(double)value forKey:(NSString *)key;

@end

static RNUnityBridge *unityBridge = nil;

@implementation RNUnityBridge
{
  bool hasListeners;
}

RCT_EXPORT_MODULE();

- (id)init {
    self = [super init];
    unityBridge = self;

    _stringMap = [NSMutableDictionary new];
    _doubleMap = [NSMutableDictionary new];
    return self;
}

- (void)startObserving {
    hasListeners = YES;
}

- (void)stopObserving {
    hasListeners = NO;
}

- (NSArray<NSString *> *)supportedEvents {
  return @[@"UnityEvent"];
}

- (void)sendUnityEvent:(NSString *)name body:(NSString *)body {
    if (hasListeners) {
        [self sendEventWithName:@"UnityEvent" body:@{@"name": name, @"body": body}];
    }
}

RCT_EXPORT_METHOD(unitySendMessage:(NSString *)obj method:(NSString *)method message:(NSString *)message) {
  UnitySendMessage([obj UTF8String],[method UTF8String],[message UTF8String]);
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

void _sendDouble(const char *key, double value) {
  [unityBridge saveDouble:value
    forKey:[NSString stringWithCString:key encoding:NSUTF8StringEncoding]];
}
void _sendString(const char *key,const char *value) {
  [unityBridge saveString:[NSString stringWithCString:value encoding:NSUTF8StringEncoding]
    forKey:[NSString stringWithCString:key encoding:NSUTF8StringEncoding]];

}
void _fireEvent(const char *eventName,const char *message) {
    [unityBridge sendUnityEvent:[NSString stringWithCString:eventName encoding:NSUTF8StringEncoding]
      body:[NSString stringWithCString:message encoding:NSUTF8StringEncoding]];
}
