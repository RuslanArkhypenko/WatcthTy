//
//  ServerManager.h
//  WatcthTy
//
//  Created by Ruslan Arhypenko on 10.08.2018.
//  Copyright © 2018 Ruslan Arhypenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerManager : NSObject

+ (ServerManager *) sharedManager;

- (void) getMoviesWithURL:(NSString*)urlStr OnSuccess:(void(^)(NSArray* movies)) success
                onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

@end
