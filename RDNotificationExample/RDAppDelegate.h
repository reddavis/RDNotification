//
//  RDAppDelegate.h
//  RDNotificationExample
//
//  Created by Red Davis on 22/04/2012.
//  Copyright (c) 2012 Red Davis. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RDAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@end
