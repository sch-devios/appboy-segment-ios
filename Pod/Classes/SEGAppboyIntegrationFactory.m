#import "SEGAppboyIntegrationFactory.h"
#import "SEGAppboyIntegration.h"
#import "SEGAppboyIntegrationOptions.h"
#if defined(__has_include) && __has_include(<Appboy_iOS_SDK/AppboyKit.h>)
#import <Appboy_iOS_SDK/AppboyKit.h>
#else
#import "Appboy-iOS-SDK/AppboyKit.h"
#endif

@interface SEGAppboyIntegrationFactory ()

@property NSDictionary *savedPushPayload;
@property (readwrite) SEGAppboyHelper *appboyHelper;

@end

@implementation SEGAppboyIntegrationFactory

+ (instancetype)instance
{
  static dispatch_once_t once;
  static SEGAppboyIntegrationFactory *sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (id)init {
  if (self = [super init]) {
    self.appboyHelper = [[SEGAppboyHelper alloc] init];
  }
  return self;
}

- (id<SEGIntegration>)createWithSettings:(NSDictionary *)settings forAnalytics:(SEGAnalytics *)analytics
{
  return [[SEGAppboyIntegration alloc] initWithSettings:settings integrationOptions:self.integrationOptions];
}

- (NSString *)key
{
  return @"Appboy";
}

- (void)saveLaunchOptions:(NSDictionary *)launchOptions {
  NSDictionary *pushPayLoad = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
  if (pushPayLoad != nil && pushPayLoad.count > 0) {
    self.savedPushPayload = [pushPayLoad copy];
  }
}

- (void)saveRemoteNotification:(NSDictionary *)userInfo {
  self.savedPushPayload = [userInfo copy];
}

- (NSDictionary *) getPushPayload {
  return self.savedPushPayload;
}

@end
