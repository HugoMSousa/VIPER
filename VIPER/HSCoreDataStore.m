//
//  Copyright (C) 2014 Hugo Sousa.
//
//  Permission is hereby granted, free of charge, to any person obtaining a 
//  copy of this software and associated documentation files (the "Software"), 
//  to deal in the Software without restriction, including without limitation 
//  the rights to use, copy, modify, merge, publish, distribute, sublicense, 
//  and/or sell copies of the Software, and to permit persons to whom the 
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in 
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//  DEALINGS IN THE SOFTWARE.
//
//
//  HSCoreDataStore.m
//  VIPER
//
//  Created by Hugo Sousa on 26/7/14.
//

#import "HSCoreDataStore.h"


@interface HSCoreDataStore ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end


@implementation HSCoreDataStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        _managedObjectModel = [self _configureMainMOM];
        [self _configurePSCWithMOM:_managedObjectModel];
        [self _configureMOCWithPSC:_persistentStoreCoordinator];
        
    }
    return self;
}

#pragma mark - Public Methods
- (void)fetchEntriesWithPredicate:(NSPredicate *)predicate
                  sortDescriptors:(NSArray *)sortDescriptors
                completionHandler:(HSDataStoreFetchCompletionHandler)completionHandler
{
#warning TODO CORE DATA FETCH ITEM
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@""];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [self.managedObjectContext performBlock:[self _executeFetchRequest:fetchRequest completionHandler:completionHandler]];
}

/*- (HSManagedTvShow *)newTvShow
{
    NSEntityDescription *entityDescription =
        [NSEntityDescription entityForName:@""
                    inManagedObjectContext:self.managedObjectContext];
    HSManagedTvShow *newItem = (HSManagedTvShow *)[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    return newItem;
}*/

- (void)save
{
    [self.managedObjectContext save:NULL];
}

#pragma mark - Private Methods
- (NSManagedObjectModel *)_configureMainMOM
{
    return [NSManagedObjectModel mergedModelFromBundles:nil];;
}

- (void)_configurePSCWithMOM:(NSManagedObjectModel *)managedObjectModel
{
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    NSError *error;
    NSURL *documentDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption: @YES,
                               NSInferMappingModelAutomaticallyOption: @YES };
    NSURL *storeURL = [documentDir URLByAppendingPathComponent:@"VIPER.sqlite"];
    
    [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:storeURL
                                                        options:options
                                                          error:&error];
}

- (void)_configureMOCWithPSC:(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];;
    self.managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    self.managedObjectContext.undoManager = nil;
}

- (void)_fetchWithRequest:(NSFetchRequest *)fetchRequest
{

}

- (void (^)())_executeFetchRequest:(NSFetchRequest *)fetchRequest
                 completionHandler:(HSDataStoreFetchCompletionHandler)completionHandler
{
    return ^() {
        NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest
                                                                    error:NULL];
        if (completionHandler) {
            completionHandler(results);
        }
    };
}
@end
