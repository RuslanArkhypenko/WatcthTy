//
//  MainViewController.m
//  WatcthTy
//
//  Created by Ruslan Arhypenko on 10.08.2018.
//  Copyright © 2018 Ruslan Arhypenko. All rights reserved.
//

#import "MainViewController.h"
#import "MovieCollectionViewCell.h"
#import "ServerManager.h"
#import "Movie.h"
#import "UIImageView+AFNetworking.h"
#import "CertainMovieViewController.h"
#import "SWRevealViewController.h"
#import "Reachability.h"
#import "NoConnectionView.h"
#import "MenuTableViewController.h"
#import "CustomFooterView.h"

typedef enum {
    MovieCategoryNowPlaying,
    MovieCategoryPopular,
    MovieCategoryTopRated,
    MovieCategoryUpcoming,
    MovieCategorySearch
    
} MovieCategory;

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UICollectionViewDelegateFlowLayout, SWRevealViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuItem;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *watchtyButton;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *movieArray;
@property (assign, nonatomic) int page;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) Reachability *internetReachability;
@property (strong, nonatomic) NSString *pickedLanguage;
@property (strong, nonatomic) CustomFooterView* footerView;
@property (assign, nonatomic) BOOL isLoading;

@end

NSString *searchURLStr = @"https://api.themoviedb.org/3/search/movie?api_key=aab05fc1571edde344c20998b3c38ddc";
NSString *nowPlayingURLStr = @"https://api.themoviedb.org/3/movie/now_playing?api_key=aab05fc1571edde344c20998b3c38ddc";
NSString *popularURLStr = @"https://api.themoviedb.org/3/movie/popular?api_key=aab05fc1571edde344c20998b3c38ddc";
NSString *topRatedURLStr = @"https://api.themoviedb.org/3/movie/top_rated?api_key=aab05fc1571edde344c20998b3c38ddc";
NSString *upcomingURLStr = @"https://api.themoviedb.org/3/movie/upcoming?api_key=aab05fc1571edde344c20998b3c38ddc";

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    self.movieArray = [NSMutableArray array];
    [self configureMenuItem];
    [self.watchtyButton addTarget:self action:@selector(watchtyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setRefreshCntrl];

    self.page = 1;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataLanguageNotification:)
                                                 name:DataLanguageDidChangedNotification
                                               object:nil];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"RefreshFooterView"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reacgabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self logReachability:self.internetReachability];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.movieArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCell" forIndexPath:indexPath];
        
    Movie *movie = [self.movieArray objectAtIndex:indexPath.row];
        
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", movie.title];
    cell.voteCountLabel.text = [NSString stringWithFormat:@"%i", (int)movie.voteCount];
    cell.voteAverageLabel.text = [NSString stringWithFormat:@"%.1f", movie.voteAverage];
    cell.posterImageView.image = nil;
        
    NSURLRequest* posterPathRequest = [NSURLRequest requestWithURL:movie.posterPath];
        
    [cell.posterImageView
    setImageWithURLRequest:posterPathRequest
    placeholderImage:nil
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    
        movie.posterImage = image;
        cell.posterImageView.image = image;
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"error = %@", [error localizedDescription]);
             
    }];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row  == self.movieArray.count - 1) {
        
        NSString *urlString = [NSString stringWithFormat:@"%@&page=%i", self.urlString, self.page];
        [self getDataFromServer:urlString];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    if (self.isLoading) {
        return CGSizeZero;
    }
    
    return CGSizeMake(collectionView.bounds.size.width, 55);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionFooter) {
        
        CustomFooterView *customFooterView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"RefreshFooterView" forIndexPath:indexPath];
        self.footerView = customFooterView;
        self.footerView.backgroundColor = [UIColor clearColor];
        return customFooterView;
    } else {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    if (elementKind == UICollectionElementKindSectionFooter) {
        [self.footerView prepareInitialAnimation];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {

    if (elementKind == UICollectionElementKindSectionFooter) {
        [self.footerView stopAnimate];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat threshold = 100.0;
    CGFloat contentOffset = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat diffHeight = contentHeight - contentOffset;
    CGFloat frameHeight = scrollView.bounds.size.height;
    CGFloat triggerThreshold = ((diffHeight - frameHeight))/(threshold);
    triggerThreshold =  MIN(triggerThreshold, 0.0);
    CGFloat pullRatio  = MIN(fabs(triggerThreshold), 1.0);
    [self.footerView setTransform:CGAffineTransformIdentity scaleFactor:pullRatio];
    if (pullRatio >= 1) {
        [self.footerView animateFinal];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    CGFloat contentOffset = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat diffHeight = contentHeight - contentOffset;
    CGFloat frameHeight = scrollView.bounds.size.height;
    CGFloat pullHeight  = fabs(diffHeight - frameHeight);
    if (pullHeight == 0.0) {
        if (self.footerView.isAnimatingFinal) {
            
            self.isLoading = true;
            [self.footerView startAnimate];
            NSString *urlString = [NSString stringWithFormat:@"%@&page=%i", self.urlString, self.page];
            [self getDataFromServer:urlString];
            self.isLoading = false;
        }
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
   
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
   
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    self.page = 1;
    [self.movieArray removeAllObjects];
    [self.collectionView reloadData];
    NSString *escapedString = [searchText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *searchString = [NSString stringWithFormat:@"%@&language=%@&query=%@", searchURLStr, self.pickedLanguage, escapedString];
    self.urlString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [self getDataFromServer:self.urlString];
}

#pragma mark - SWRevealViewControllerDelegate

- (void)revealControllerPanGestureBegan:(SWRevealViewController *)revealController {
    
    [self.searchBar resignFirstResponder];
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position {

    if (position == FrontViewPositionLeft) {
        [self.searchBar becomeFirstResponder];
        [self.searchBar setShowsCancelButton:YES animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UICollectionViewCell *)cell {
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];

    CertainMovieViewController *vc = [segue destinationViewController];
    vc.certainMovie = [NSMutableArray array];
    [vc.certainMovie addObject:[self.movieArray objectAtIndex:indexPath.item]];
}

#pragma mark - Actions

- (void)refreshAction:(UIRefreshControl *) sender {

    self.page = 1;
    [self.movieArray removeAllObjects];
    [self getDataFromServer:self.urlString];
    [self.refreshControl endRefreshing];
}

- (void)watchtyAction:(UIButton *)sender {

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    if (self.movieArray.count > 0) {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}

#pragma mark - Notifications

- (void)reacgabilityChanged:(NSNotification *)notification {

    Reachability *reachability = [notification object];
    [self logReachability:reachability];
}

- (void)logReachability:(Reachability *)reachability {

    if (reachability.isReachable) {
        NSLog(@"Reachable");
        self.navigationItem.titleView = self.watchtyButton;
        [self setChoosenCategory];
        
        if (self.movieArray.count < 1 && self.category != MovieCategorySearch) {
            
            NSString *urlString = [NSString stringWithFormat:@"%@&page=%i", self.urlString, self.page];
            [self getDataFromServer:urlString];
        }
        
    } else {
        NSLog(@"Not reachable");
        NoConnectionView *noConnectionView = [[NoConnectionView alloc] initWithFrame:CGRectMake(0, 0, 180, 36)];
        self.navigationItem.titleView = noConnectionView;
    }
}

- (void)dataLanguageNotification:(NSNotification *) notification {
    
    NSLog(@"receiveTestNotification userInfo = %@", notification.userInfo);
    
    self.pickedLanguage = [notification.userInfo objectForKey:@"DataLanguageUserInfoKey"];
    [self.movieArray removeAllObjects];
    [self.collectionView reloadData];
    [self setChoosenCategory];
    self.page = 1;
    NSString *urlString = [NSString stringWithFormat:@"%@&page=%i", self.urlString, self.page];
    [self getDataFromServer:urlString];
}

#pragma mark - API

- (void)getDataFromServer:(NSString *)urlStr {
    
    [[ServerManager sharedManager] getMoviesWithURL:urlStr OnSuccess:^(NSArray *movies) {
        
        if (self.category == MovieCategorySearch) {
            
            NSArray *array = [NSArray arrayWithArray:movies];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title beginswith %@", self.searchBar.text];
            NSArray *sortedArray = [array filteredArrayUsingPredicate:predicate];
            [self.movieArray addObjectsFromArray:sortedArray];
        } else {
            [self.movieArray addObjectsFromArray:movies];
        }
        
        self.page += 1;
        [self.collectionView reloadData];
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"ERROR: %@", [error localizedDescription]);
    }];
}

- (void)setChoosenCategory {
  
    self.pickedLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"PickedLanguageKeyValue"];
    
    switch (self.category) {
        case MovieCategoryNowPlaying: {
            [self.watchtyButton setTitle:@"Now Playing" forState:UIControlStateNormal];
            self.urlString = [NSString stringWithFormat:@"%@&language=%@", nowPlayingURLStr, self.pickedLanguage];
            break;}
            
        case MovieCategoryPopular: {
            [self.watchtyButton setTitle:@"Popular" forState:UIControlStateNormal];
            self.urlString = [NSString stringWithFormat:@"%@&language=%@", popularURLStr, self.pickedLanguage];
            break;}
            
        case MovieCategoryTopRated: {
            [self.watchtyButton setTitle:@"Top Rated" forState:UIControlStateNormal];
            self.urlString = [NSString stringWithFormat:@"%@&language=%@", topRatedURLStr, self.pickedLanguage];
            break;}
            
        case MovieCategoryUpcoming: {
            [self.watchtyButton setTitle:@"Upcoming" forState:UIControlStateNormal];
            self.urlString = [NSString stringWithFormat:@"%@&language=%@", upcomingURLStr, self.pickedLanguage];
            break;}
            
        case MovieCategorySearch: {
             [self setSearchBar];
            break;}
    }
}

- (void)configureMenuItem {
    
    self.menuItem.target = self.revealViewController;
    self.menuItem.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.delegate = self;
}

- (void)setSearchBar {
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 1.5 * 44, 44)];
    
    UIView *wrapView = [[UIView alloc] initWithFrame:self.searchBar.frame];
    self.searchBar.delegate = self;
    self.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
    [wrapView addSubview:self.searchBar];
    self.navigationItem.titleView = wrapView;
}

- (void)setRefreshCntrl {
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    [self.refreshControl addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
}

@end
