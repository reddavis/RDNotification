//
//  RDNotification.h
//  RDNotification
//
//  Created by Red Davis on 11/04/2012.
//  Copyright (c) 2012 Red Davis. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    RDNotificationTypeSuccess,
    RDNotificationTypeError
} RDNotificationType;


@interface RDNotification : UIView

@property (nonatomic, assign) RDNotificationType notificationType;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, assign) CGFloat animationTime;
@property (nonatomic, assign) CGFloat animationPauseTime;

- (id)initWithNotificationType:(RDNotificationType)type;
- (void)showAt:(CGFloat)yAxis;
- (void)showAboveView:(UIView *)view;
- (void)showAtTop;

@end
