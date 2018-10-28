//
//  MenuTableViewController.m
//  WatcthTy
//
//  Created by Ruslan Arhypenko on 22.08.2018.
//  Copyright © 2018 Ruslan Arhypenko. All rights reserved.
//

#import "MenuTableViewController.h"
#import "MainViewController.h"

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.tableView.backgroundView addSubview:blurEffectView];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)cell {
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    UINavigationController* navVC = (UINavigationController*)segue.destinationViewController;
    MainViewController* vc = (MainViewController*)navVC.topViewController;
    
    switch (indexPath.row) {
        case 0:
            vc.category = MovieCategoryNowPlaying;
            NSLog(@"MovieCategoryNowPlaying");
            break;
            
        case 1:
            vc.category = MovieCategoryPopular;
            NSLog(@"MovieCategoryPopular");
            break;
            
        case 2:
            vc.category = MovieCategoryTopRated;
            NSLog(@"MovieCategoryTopRated");
            break;
        
        case 3:
            vc.category = MovieCategoryUpcoming;
            NSLog(@"MovieCategoryUpcoming");
            break;
        
        case 4:
            vc.category = MovieCategorySearch;
            NSLog(@"MovieCategorySearch");
            break;
        default:
            break;
    }
}

@end
