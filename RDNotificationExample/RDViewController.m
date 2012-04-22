//
//  RDViewController.m
//  RDNotificationExample
//
//  Created by Red Davis on 22/04/2012.
//  Copyright (c) 2012 Red Davis. All rights reserved.
//

#import "RDViewController.h"
#import "RDNotification.h"

@interface RDViewController ()

@end


@implementation RDViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (void)showNotificationAtTop:(id)sender {
    
    RDNotification *notification = [[RDNotification alloc] initWithNotificationType:RDNotificationTypeSuccess];
    notification.text = @"This has been a success";
    [notification showAtTop];
}

- (void)showNotificationAtY:(id)sender {
    
    RDNotification *notification = [[RDNotification alloc] initWithNotificationType:RDNotificationTypeError];
    notification.text = @"This has been a error";
    [notification showAt:100];
}

- (void)showNotificationAboveView:(id)sender {
    
    RDNotification *notification = [[RDNotification alloc] initWithNotificationType:RDNotificationTypeSuccess];
    notification.text = @"This has been a success";
    [notification showAboveView:self.tabBarController.tabBar];
}

@end
