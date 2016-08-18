//
//  AppDelegate.m
//  掌上调课
//
//  Created by 黄亚男 on 16/3/22.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate ()
/** 开启点击空白处隐藏键盘功能 */
- (void)openTouchOutsideDismissKeyboard;
@end

@implementation AppDelegate
@synthesize cookie;

/** 开启点击空白处隐藏键盘功能 */
- (void)openTouchOutsideDismissKeyboard
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addGesture) name:UIKeyboardDidShowNotification object:nil];
}
- (void)addGesture
{
    [self.window addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappearKeyboard)]];
}
- (void)disappearKeyboard
{
    [self.window endEditing:YES];
    [self.window removeGestureRecognizer:self.window.gestureRecognizers.lastObject];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self openTouchOutsideDismissKeyboard];
    //设定Tabbar的点击后的颜色
    
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    
    //设定Tabbar的颜色
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
