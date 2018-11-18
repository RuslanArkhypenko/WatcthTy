//
//  MenuTableViewController.m
//  WatcthTy
//
//  Created by Ruslan Arhypenko on 22.08.2018.
//  Copyright © 2018 Ruslan Arhypenko. All rights reserved.
//

#import "MenuTableViewController.h"
#import "MainViewController.h"
#import "SWRevealViewController.h"

NSString* const DataLanguageDidChangedNotification = @"DataLanguageDidChangedNotification";
NSString* const DataLanguageUserInfoKey = @"DataLanguageUserInfoKey";

@interface MenuTableViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSDictionary *pickerDict;
@property (strong, nonatomic) NSString *pickedLanguage;

@end

NSString* const NSUserDefaultsPickedLanguageKeyValue = @"PickedLanguageKeyValue";
NSString* const NSUserDefaultsPickerSelectedRowKeyValue = @"PickerSelectedRowKeyValue";

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.tableView.backgroundView addSubview:blurEffectView];
    
    self.pickerDict = [NSDictionary dictionaryWithObjectsAndKeys:@"en", @"English",
                                                                 @"de", @"Deutsch",
                                                                 @"ru", @"Русский", nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.pickedLanguage) {
        
        [self.pickerView selectRow:[[NSUserDefaults standardUserDefaults] integerForKey:NSUserDefaultsPickerSelectedRowKeyValue] inComponent:0 animated:NO];
    }
}

#pragma mark - UIPickerViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    [self customCellSelection:cell];
    return cell;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [[self.pickerDict allKeys] count];
}

#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *pickerLabel = (UILabel*)view;
    
    if (!pickerLabel) {
        
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.font = [UIFont systemFontOfSize:20];
        pickerLabel.textAlignment=NSTextAlignmentCenter;
        pickerLabel.textColor = [UIColor whiteColor];
    }
    [pickerLabel setText:[[self.pickerDict allKeys] objectAtIndex:row]];
    
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.pickedLanguage = [NSString stringWithFormat:@"%@", [[self.pickerDict allValues] objectAtIndex:row]];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.pickedLanguage forKey:NSUserDefaultsPickedLanguageKeyValue];
    [[NSUserDefaults standardUserDefaults] setInteger:row forKey:NSUserDefaultsPickerSelectedRowKeyValue];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary* userInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:self.pickedLanguage, @"DataLanguageUserInfoKey", nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:DataLanguageDidChangedNotification
                                                        object:nil
                                                      userInfo:userInfoDict];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    UINavigationController *navVC = (UINavigationController *)segue.destinationViewController;
    MainViewController *vc = (MainViewController *)navVC.topViewController;
    vc.category = indexPath.row;
}

- (void)customCellSelection:(UITableViewCell*)cell {
    
    UIView *customColorView = [[UIView alloc] init];
    customColorView.backgroundColor = [UIColor colorWithRed:0/255.0
                                                      green:225/255.0
                                                       blue:118/255.0
                                                      alpha:0.75];
    cell.selectedBackgroundView =  customColorView;
}

@end
