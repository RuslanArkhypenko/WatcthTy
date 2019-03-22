//
//  MovieModel+CoreDataProperties.m
//  WatchTy
//
//  Created by Ruslan Arhypenko on 3/22/19.
//  Copyright © 2019 Ruslan Arhypenko. All rights reserved.
//
//

#import "MovieModel+CoreDataProperties.h"

@implementation MovieModel (CoreDataProperties)

+ (NSFetchRequest<MovieModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"MovieModel"];
}

@dynamic title;
@dynamic backdropPath;
@dynamic originalLanguage;
@dynamic originalTitle;
@dynamic overview;
@dynamic posterPath;
@dynamic posterImage;
@dynamic releaseDate;
@dynamic voteAverage;
@dynamic voteCount;

@end
