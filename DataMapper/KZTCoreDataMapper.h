#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "KZTDataMapper.h"


@interface KZTCoreDataMapper : KZTDataMapper

- (instancetype)initWithEntityName:(NSString *)entityName;

- (void)mapPrimaryKeyFromKeyPath:(NSString *)srcKeyPath toKey:(NSString *)destinationKey destinationClass:(Class)destinationClass;

- (void)mapPrimaryKeyFromKeyPath:(NSString *)srcKeyPath toKey:(NSString *)destinationKey transformBlock:(KZTDataMapperValueBlock)block;

- (NSArray *)parseDictionaries:(NSArray *)dictionaries inContext:(NSManagedObjectContext *)context;

@end