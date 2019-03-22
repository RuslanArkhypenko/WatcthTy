//
//  MovieModel+CoreDataProperties.h
//  WatchTy
//
//  Created by Ruslan Arhypenko on 3/22/19.
//  Copyright © 2019 Ruslan Arhypenko. All rights reserved.
//
//

#import "MovieModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MovieModel (CoreDataProperties)

+ (NSFetchRequest<MovieModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSURL *backdropPath;
@property (nullable, nonatomic, copy) NSString *originalLanguage;
@property (nullable, nonatomic, copy) NSString *originalTitle;
@property (nullable, nonatomic, copy) NSString *overview;
@property (nullable, nonatomic, copy) NSURL *posterPath;
@property (nullable, nonatomic, retain) NSData *posterImage;
@property (nullable, nonatomic, copy) NSString *releaseDate;
@property (nonatomic) float voteAverage;
@property (nonatomic) int16_t voteCount;

@end

NS_ASSUME_NONNULL_END
