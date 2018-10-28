//
//  MainViewController.h
//  WatcthTy
//
//  Created by Ruslan Arhypenko on 10.08.2018.
//  Copyright © 2018 Ruslan Arhypenko. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MovieCategoryNowPlaying,
    MovieCategoryPopular,
    MovieCategoryTopRated,
    MovieCategoryUpcoming,
    MovieCategorySearch
    
} MovieCategory;


@interface MainViewController : UIViewController

@property (assign, nonatomic) MovieCategory category;

@end
