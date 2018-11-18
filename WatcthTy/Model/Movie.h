//
//  PopularMovie.h
//  WatcthTy
//
//  Created by Ruslan Arhypenko on 10.08.2018.
//  Copyright © 2018 Ruslan Arhypenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Movie : NSObject

@property (assign, nonatomic) BOOL adult;
@property (strong, nonatomic) NSURL *backdropPath;
@property (strong, nonatomic) NSString *originalLanguage;
@property (strong, nonatomic) NSString *originalTitle;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *overview;
@property (strong, nonatomic) NSURL *posterPath;
@property (strong, nonatomic) UIImage *posterImage;
@property (strong, nonatomic) NSString *releaseDate;
@property (assign, nonatomic) CGFloat voteAverage;
@property (assign, nonatomic) NSInteger voteCount;

- (id) initWithServerResponse:(NSDictionary *) responseObject;

@end
