//
//  CertainMovieViewController.h
//  WatcthTy
//
//  Created by Ruslan Arhypenko on 12.08.2018.
//  Copyright © 2018 Ruslan Arhypenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CertainMovieViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UIImageView *adultImageView;
@property (weak, nonatomic) IBOutlet UILabel *originalLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteAverageLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;

@property (strong, nonatomic) NSMutableArray* certainMovie;

@end
