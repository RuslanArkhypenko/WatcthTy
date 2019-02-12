//
//  ServerManager.m
//  WatcthTy
//
//  Created by Ruslan Arhypenko on 10.08.2018.
//  Copyright © 2018 Ruslan Arhypenko. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "Movie.h"

@implementation ServerManager

+ (ServerManager *) sharedManager {
    
    static ServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}

- (void) getMoviesWithURL:(NSString *)urlStr OnSuccess:(void(^)(NSArray *movies)) success
                 onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
        NSArray *JSONArray = [responseObject objectForKey:@"results"];
        NSMutableArray *objectsArray = [NSMutableArray array];
        
        for (NSDictionary *dict in JSONArray) {

            Movie *movie = [[Movie alloc] initWithServerResponse:dict];
            [objectsArray addObject:movie];
        }

        if (success) {
            success(objectsArray);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        if (failure) {
            failure(error, operation.response.statusCode);
        }
    }];
}

@end
