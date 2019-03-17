//
//  CertainMovieViewController.m
//  WatcthTy
//
//  Created by Ruslan Arhypenko on 12.08.2018.
//  Copyright © 2018 Ruslan Arhypenko. All rights reserved.
//

#import "CertainMovieViewController.h"
#import "Movie.h"
#import <UserNotifications/UserNotifications.h>

@interface CertainMovieViewController () <UNUserNotificationCenterDelegate>

@property (strong, nonatomic)UNUserNotificationCenter *center;

@end

@implementation CertainMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    
    self.center = [UNUserNotificationCenter currentNotificationCenter];
    self.center.delegate = self;
    
    [self addBarButtonItem];
    [self fillViewWithData];
}

- (void)fillViewWithData {
    
    Movie *movie = [self.certainMovie firstObject];
    
    self.posterImageView.image = movie.posterImage;
    
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

- (void)addBarButtonItem {
    
    UIButton* toCoreDataButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [toCoreDataButton setImage:[UIImage imageNamed:@"watchLater30x30.png"] forState:UIControlStateNormal];
    [toCoreDataButton addTarget:self action:@selector(addMovieToCoreData:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* toCoreDataItem = [[UIBarButtonItem alloc] initWithCustomView:toCoreDataButton];
    
    self.navigationItem.rightBarButtonItem = toCoreDataItem;
}

- (void)addMovieToCoreData:(UIBarButtonItem*)sender {
    
    Movie *movie = [self.certainMovie firstObject];
    
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.body = [NSString stringWithFormat:@"%@ added to Favourite", movie.title];
    content.sound = [UNNotificationSound defaultSound];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"MovieToCoreDataUserNotification" content:content trigger:trigger];
    
    [self.center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Something went wrong: %@",error);
        }
    }];
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
}

@end
