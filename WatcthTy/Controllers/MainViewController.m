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

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuItem;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *watchtyButton;
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@property (strong, nonatomic) UISearchBar* searchBar;

@property (strong, nonatomic) NSMutableArray* movieArray;
@property (assign, nonatomic) int page;
@property (assign, nonatomic) BOOL isEditing;
@property (strong, nonatomic) NSString* urlString;

@end

NSString* const searchURLStr = @"https://api.themoviedb.org/3/search/movie?api_key=aab05fc1571edde344c20998b3c38ddc&language=en-US";
NSString* const nowPlayingURLStr = @"https://api.themoviedb.org/3/movie/now_playing?api_key=aab05fc1571edde344c20998b3c38ddc&language=en-US";
NSString* const popularURLStr = @"https://api.themoviedb.org/3/movie/popular?api_key=aab05fc1571edde344c20998b3c38ddc&language=en-US";
NSString* const topRatedURLStr = @"https://api.themoviedb.org/3/movie/top_rated?api_key=aab05fc1571edde344c20998b3c38ddc&language=en-US";
NSString* const upcomingURLStr = @"https://api.themoviedb.org/3/movie/upcoming?api_key=aab05fc1571edde344c20998b3c38ddc&language=en-US";

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];

    self.movieArray = [NSMutableArray array];
    [self configureMenuItem];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    [self.refreshControl addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    self.page = 1;
    
    [self setChoosenCategory];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.movieArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCollectionViewCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCell" forIndexPath:indexPath];
        
    Movie* movie = [self.movieArray objectAtIndex:indexPath.row];
        
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", movie.title];
    cell.voteCountLabel.text = [NSString stringWithFormat:@"%i", (int)movie.voteCount];
    cell.voteAverageLabel.text = [NSString stringWithFormat:@"%.1f", movie.voteAverage];
        
    NSURLRequest* posterPathRequest = [NSURLRequest requestWithURL:movie.posterPath];
        
    [cell.posterImageView
    setImageWithURLRequest:posterPathRequest
    placeholderImage:nil
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    
        cell.posterImageView.image = image;
        movie.posterImage = image;
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"error = %@", [error localizedDescription]);
             
    }];
        
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(MovieCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row  == self.movieArray.count - 1) {

        NSString* requestStr = [NSString stringWithFormat:@"%@&page=%i", self.urlString, self.page];
        [self getDataFromServerFromServer:requestStr];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
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
    NSString* searchString = [NSString stringWithFormat:@"%@&query=%@", searchURLStr, searchText];
    NSString* requestStr = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [self getDataFromServerFromServer:requestStr];
    self.urlString = requestStr;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UICollectionViewCell*)cell {
    
    NSIndexPath* indexPath = [self.collectionView indexPathForCell:cell];

    CertainMovieViewController *vc = [segue destinationViewController];
    vc.certainMovie = [NSMutableArray array];
    [vc.certainMovie addObject:[self.movieArray objectAtIndex:indexPath.item]];
}

#pragma mark - Actions

- (void) refreshAction:(UIRefreshControl*) sender {

    self.page = 1;
    [self.movieArray removeAllObjects];
    [self getDataFromServerFromServer:self.urlString];
    [self.refreshControl endRefreshing];
}

- (IBAction)watchtyAction:(UIButton *)sender {

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    if (self.movieArray.count > 0) {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}

#pragma mark - API

- (void)getDataFromServerFromServer:(NSString*)urlStr {
  
    [[ServerManager sharedManager] getMoviesWithURL:urlStr OnSuccess:^(NSArray *movies) {
        
        [self.movieArray addObjectsFromArray:movies];
        self.page += 1;
        
        [self.collectionView reloadData];
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"ERROR: %@", [error localizedDescription]);
    }];
}

- (void)setChoosenCategory {

    self.page = 1;
    
    switch (self.category) {
        case MovieCategoryNowPlaying: {
            [self.watchtyButton setTitle:@"Now Playing" forState:UIControlStateNormal];
            [self getDataFromServerFromServer:nowPlayingURLStr];
            self.urlString = nowPlayingURLStr;
            break;}
            
        case MovieCategoryPopular: {
            [self.watchtyButton setTitle:@"Popular" forState:UIControlStateNormal];
            [self getDataFromServerFromServer:popularURLStr];
            self.urlString = popularURLStr;
            break;}
            
        case MovieCategoryTopRated: {
            [self.watchtyButton setTitle:@"Top Rated" forState:UIControlStateNormal];
            [self getDataFromServerFromServer:topRatedURLStr];
            self.urlString = topRatedURLStr;
            break;}
            
        case MovieCategoryUpcoming: {
            [self.watchtyButton setTitle:@"Upcoming" forState:UIControlStateNormal];
            [self getDataFromServerFromServer:upcomingURLStr];
            self.urlString = upcomingURLStr;
            break;}
   
        case MovieCategorySearch: {
            [self setSearchBar];
            [self.searchBar becomeFirstResponder];
            break;}
    }
}

- (void)configureMenuItem {
    
    self.menuItem.target = self.revealViewController;
    self.menuItem.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)setSearchBar {
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 1.5 * 44, 44)];

    UIView *wrapView = [[UIView alloc] initWithFrame:self.searchBar.frame];
    self.searchBar.delegate = self;
    self.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
    [wrapView addSubview:self.searchBar];
    self.navigationItem.titleView = wrapView;
}

@end
