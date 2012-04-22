//
//  RDNotification.m
//  RDNotification
//
//  Created by Red Davis on 11/04/2012.
//  Copyright (c) 2012 Red Davis. All rights reserved.
//

#import "RDNotification.h"
#import <QuartzCore/QuartzCore.h>
#import "RDNotificationViewController.h"


@interface RDNotification ()

@property (nonatomic, readonly) UIImage *backgroundImage;
@property (nonatomic, readonly) UIImage *defaultIcon;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, readonly) CGRect screenBounds;

- (void)setupTextLabel;
- (void)setupIcon;
- (void)setupObserver;
- (void)setIconImage;
- (void)animateIn;
- (void)animateOutWithDelay:(CGFloat)delay;
- (void)notificationTapped:(id)sender;

@end


CGFloat const kIconAndTextPadding = 5;

@implementation RDNotification

@synthesize notificationType;
@synthesize text;
@synthesize icon;
@synthesize iconImageView;
@synthesize defaultIcon;
@synthesize textLabel;
@synthesize window;
@synthesize screenBounds;

#pragma mark - Intialization

- (id)initWithNotificationType:(RDNotificationType)type {
    
    self = [self init];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.notificationType = type;
        [self setupIcon];
        [self setupTextLabel];
        [self setupObserver];
    }
    
    return self;
}

#pragma mark -

- (void)drawRect:(CGRect)rect {
    
    [[self.backgroundImage stretchableImageWithLeftCapWidth:5 topCapHeight:0] drawInRect:rect];
}

#pragma mark - View manangement

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self setIconImage];
    
    self.textLabel.text = self.text;
    
    CGFloat textLabelMaxWidth = self.frame.size.width - self.iconImageView.image.size.width - kIconAndTextPadding;
    CGSize textLabelSize = [self.textLabel.text sizeWithFont:self.textLabel.font constrainedToSize:CGSizeMake(textLabelMaxWidth, self.frame.size.height)];
    CGFloat textLabelYAxis = floorf(self.frame.size.height/2.0 - textLabelSize.height/2.0);
    CGFloat textLabelXAxis = floorf((self.frame.size.width - textLabelSize.width)/2 + kIconAndTextPadding*2);
    
    self.textLabel.frame = CGRectMake(textLabelXAxis, textLabelYAxis, textLabelSize.width, textLabelSize.height);

    CGFloat iconXAxis = floorf(textLabelXAxis - self.iconImageView.image.size.width - kIconAndTextPadding);
    CGFloat iconYAxis = floorf(self.frame.size.height/2.0 - self.iconImageView.image.size.height/2.0);
    self.iconImageView.frame = CGRectMake(iconXAxis, iconYAxis, self.iconImageView.image.size.width, self.iconImageView.image.size.height);
}

- (void)setupTextLabel {
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    self.textLabel.textAlignment = UITextAlignmentCenter;
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.textLabel];
}

- (void)setupIcon {
    
    self.iconImageView = [[UIImageView alloc] init];
    [self addSubview:self.iconImageView];
}

- (void)setIconImage {
    
    if (self.icon) {
        self.iconImageView.image = self.icon;
    }
    else {
        self.iconImageView.image = self.defaultIcon;
    }
}

#pragma mark - Helpers

- (UIImage *)backgroundImage {
    
    UIImage *image = nil;
    switch (self.notificationType) {
        case RDNotificationTypeError:
            image = [UIImage imageNamed:@"NotificationError.png"];
            break;
        case RDNotificationTypeSuccess:
            image = [UIImage imageNamed:@"NotificationSuccess.png"];
            break;
    }
            
    return image;
}

- (UIImage *)defaultIcon {
    
    UIImage *image = nil;
    switch (self.notificationType) {
        case RDNotificationTypeError:
            image = [UIImage imageNamed:@"NotificationIconError.png"];
            break;
            
        case RDNotificationTypeSuccess:
            image = [UIImage imageNamed:@"NotificationIconSuccess.png"];
            break;
    }

    return image;
}

- (CGRect)screenBounds {
    
    return [UIScreen mainScreen].bounds;
}

#pragma mark - Observers

- (void)setupObserver {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notificationTapped:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)notificationTapped:(UITapGestureRecognizer *)sender {
    
    [self animateOutWithDelay:0];
}

#pragma mark - Animation

- (void)animateIn {
    
    CGFloat newViewXAxis = floorf((self.screenBounds.size.width - self.frame.size.width) / 2.0);
    [UIView animateWithDuration:0.4 animations:^{
        
        self.frame = CGRectMake(newViewXAxis, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(animateOutWithDelay:) userInfo:nil repeats:NO];
    }];
}

- (void)animateOutWithDelay:(CGFloat)delay {
    
    [UIView animateWithDuration:0.4 delay:delay options:0 animations:^{
        
        self.frame = CGRectMake(self.screenBounds.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
       
        self.window = nil;
    }];
}

#pragma mark - Display notification

- (void)showAt:(CGFloat)yAxis {
        
    RDNotificationViewController *controller = [[RDNotificationViewController alloc] init];
    [controller.view addSubview:self];
    
    CGFloat viewWidth = floorf(self.screenBounds.size.width * 0.94);
    CGFloat viewXAxis = -viewWidth;
    self.frame = CGRectMake(viewXAxis, 0, viewWidth, self.backgroundImage.size.height);
    
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, yAxis, self.screenBounds.size.width, self.backgroundImage.size.height + 20)];
    self.window.windowLevel = UIWindowLevelStatusBar;
    self.window.rootViewController = controller;
    
    [self.window makeKeyAndVisible];
    [self animateIn];
}

- (void)showAboveView:(UIView *)view {

    CGFloat position = view.frame.origin.y - self.backgroundImage.size.height - 44;
    [self showAt:position];
}

- (void)showAtTop {
    
    [self showAt:22];
}

@end
