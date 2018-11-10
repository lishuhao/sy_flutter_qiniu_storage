#import "SyFlutterQiniuStoragePlugin.h"
#import <QiniuSDK.h>

@interface SyFlutterQiniuStoragePlugin() <FlutterStreamHandler>

@property BOOL isCanceled;
@property FlutterEventSink eventSink;

@end

@implementation SyFlutterQiniuStoragePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    NSString *eventChannelName  = @"sy_flutter_qiniu_storage_event";
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"sy_flutter_qiniu_storage"
            binaryMessenger:[registrar messenger]];
    
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:eventChannelName binaryMessenger:registrar.messenger];
  SyFlutterQiniuStoragePlugin* instance = [[SyFlutterQiniuStoragePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    [eventChannel setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if ([@"upload" isEqualToString:call.method]){
      [self upload:call result:result];
  } else if ([@"cancelUpload" isEqualToString:call.method]){
      [self cancelUpload:call result:result];
  }else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)upload:(FlutterMethodCall*)call result:(FlutterResult)result{
    self.isCanceled = FALSE;
    
    NSString *filepath = call.arguments[@"filepath"];
    NSString *key = call.arguments[@"key"];
    NSString *token = call.arguments[@"token"];
    
    QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"progress %f",percent);
        self.eventSink(@(percent));
    } params:nil checkCrc:NO cancellationSignal:^BOOL{
        return self.isCanceled;
    }];
    
    QNUploadManager *manager = [[QNUploadManager alloc] init];
    [manager putFile:filepath key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"info %@", info);
        NSLog(@"resp %@",resp);
        result(@(info.isOK));
    } option:(QNUploadOption *) opt];
}

- (void)cancelUpload:(FlutterMethodCall*)call result:(FlutterResult)result{
    self.isCanceled = TRUE;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    self.isCanceled = TRUE;
    self.eventSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    self.isCanceled = FALSE;
    self.eventSink = events;
    return nil;
}

@end
