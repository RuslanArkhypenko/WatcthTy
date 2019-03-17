//
//  PopularMovie.m
//  WatcthTy
//
//  Created by Ruslan Arhypenko on 10.08.2018.
//  Copyright © 2018 Ruslan Arhypenko. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id) initWithServerResponse: (NSDictionary *) responseObject {

    self = [super init];
    if (self) {
        
        self.backdropPath = [NSURL URLWithString:[NSString stringWithFormat:@"https://image.tmdb.org/t/p/w500%@", [responseObject objectForKey:@"backdrop_path"]]];
        self.originalLanguage = [responseObject objectForKey:@"original_language"];
        self.originalTitle = [responseObject objectForKey:@"original_title"];
        self.overview = [responseObject objectForKey:@"overview"];
        self.posterPath = [NSURL URLWithString:[NSString stringWithFormat:@"https://image.tmdb.org/t/p/w500%@", [responseObject objectForKey:@"poster_path"]]];
        self.releaseDate = [responseObject objectForKey:@"release_date"];
        self.title = [responseObject objectForKey:@"title"];
        self.voteAverage = [[responseObject objectForKey:@"vote_average"] floatValue];
        self.voteCount = [[responseObject objectForKey:@"vote_count"] integerValue];
    }
    return self;
}

@end
