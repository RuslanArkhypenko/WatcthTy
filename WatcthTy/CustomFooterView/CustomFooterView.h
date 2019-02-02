//
//  CustomFooterView.h
//  WatchTy
//
//  Created by Ruslan Arhypenko on 1/31/19.
//  Copyright © 2019 Ruslan Arhypenko. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomFooterView : UICollectionReusableView

@property (assign, nonatomic) BOOL isAnimatingFinal;

- (void)setTransform:(CGAffineTransform)inTransform scaleFactor:(CGFloat)scaleFactor;

- (void)prepareInitialAnimation;

- (void)startAnimate;

- (void)stopAnimate;

- (void)animateFinal;

@end

NS_ASSUME_NONNULL_END
