//
//  CertainMovieViewController.m
//  WatcthTy
//
//  Created by Ruslan Arhypenko on 12.08.2018.
//  Copyright © 2018 Ruslan Arhypenko. All rights reserved.
//

#import "CertainMovieViewController.h"
#import "Movie.h"

@interface CertainMovieViewController ()

@end

@implementation CertainMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    
    Movie *movie = [self.certainMovie firstObject];

    self.posterImageView.image = movie.posterImage;

    if (movie.adult) {
        self.adultImageView.image = nil;
    } else {
        self.adultImageView.image = [UIImage imageNamed:@"18plus"];
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = [NSString stringWithFormat:@"%@", movie.title];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
    
    self.originalLanguageLabel.text = [NSString stringWithFormat:@"%@", movie.originalLanguage];
    self.releaseDateLabel.text = [NSString stringWithFormat:@"%@", movie.releaseDate];
    self.voteAverageLabel.text = [NSString stringWithFormat:@"%.1f", movie.voteAverage];
    self.voteCountLabel.text = [NSString stringWithFormat:@"%i", (int)movie.voteCount];
    self.overviewLabel.text = [NSString stringWithFormat:@"%@", movie.overview];
    [self.overviewLabel sizeToFit];
}

@end
