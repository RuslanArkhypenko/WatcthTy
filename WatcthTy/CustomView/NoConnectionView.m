//
//  NoConnectionView.m
//  WatchTy
//
//  Created by Ruslan Arhypenko on 11/8/18.
//  Copyright © 2018 Ruslan Arhypenko. All rights reserved.
//

#import "NoConnectionView.h"

@interface NoConnectionView ()

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation NoConnectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self Reinit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self Reinit];
    }
    return self;
}

- (void) Reinit {
    
    [[NSBundle mainBundle] loadNibNamed:@"NoConnectionView" owner:self options:nil];
    [self addSubview:self.view];
    self.view.frame = self.bounds;
    [self.activityIndicator startAnimating];
}
@end
