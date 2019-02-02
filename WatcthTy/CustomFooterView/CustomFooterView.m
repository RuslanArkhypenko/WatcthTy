//
//  CustomFooterView.m
//  WatchTy
//
//  Created by Ruslan Arhypenko on 1/31/19.
//  Copyright © 2019 Ruslan Arhypenko. All rights reserved.
//

#import "CustomFooterView.h"

@interface CustomFooterView()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refreshControlIndicator;
@property (assign, nonatomic) CGAffineTransform currentTransform;

@end

@implementation CustomFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
        
    [self prepareInitialAnimation];
}

- (void)setTransform:(CGAffineTransform)inTransform scaleFactor:(CGFloat)scaleFactor {
    
    if (self.isAnimatingFinal) {
        return;
    }
    
    self.currentTransform = inTransform;
}

////reset the animation
- (void)prepareInitialAnimation {
    
    self.isAnimatingFinal = false;
    [self.refreshControlIndicator stopAnimating];
    self.refreshControlIndicator.transform = CGAffineTransformMakeScale(0.0, 0.0);
}

- (void)startAnimate {
    self.isAnimatingFinal = true;
    [self.refreshControlIndicator startAnimating];
}

- (void)stopAnimate {
    self.isAnimatingFinal = false;
    [self.refreshControlIndicator stopAnimating];
}

//final animation to display loading
- (void)animateFinal {
    if (self.isAnimatingFinal) {
        return;
    }
    self.isAnimatingFinal = true;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.refreshControlIndicator.transform = CGAffineTransformIdentity;
    }];
}

@end
