//
//  CoreDataManager.h
//  WatchTy
//
//  Created by Ruslan Arhypenko on 3/21/19.
//  Copyright © 2019 Ruslan Arhypenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

+ (CoreDataManager *) sharedManager;

- (void)saveContext;

@end

NS_ASSUME_NONNULL_END
