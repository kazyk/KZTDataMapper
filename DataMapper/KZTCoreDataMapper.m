#import "KZTCoreDataMapper.h"
#import "KZTValueMapping.h"

@interface KZTCoreDataMapper()
@property (nonatomic, copy, readonly) NSString *entityName;
@property (nonatomic) KZTValueMapping *primaryKeyMapping;
@end


@implementation KZTCoreDataMapper

- (instancetype)initWithEntityName:(NSString *)entityName
{
    NSParameterAssert([entityName length]);
    self = [super init];
    if (self) {
        _entityName = [entityName copy];
    }
    return self;
}

- (void)mapPrimaryKeyFromKeyPath:(NSString *)srcKeyPath toKey:(NSString *)destinationKey destinationClass:(Class)destinationClass
{
    [self mapPrimaryKeyFromKeyPath:srcKeyPath toKey:destinationKey transformBlock:[self valueBlockForClass:destinationClass]];
}

- (void)mapPrimaryKeyFromKeyPath:(NSString *)srcKeyPath toKey:(NSString *)destinationKey transformBlock:(KZTDataMapperValueBlock)block
{
    NSParameterAssert([srcKeyPath length] && [destinationKey length]);
    KZTValueMapping *mapp = [[KZTValueMapping alloc] init];
    mapp.srcKeyPath = srcKeyPath;
    mapp.destinationKey = destinationKey;
    mapp.block = block;
    self.primaryKeyMapping = mapp;
}

- (NSArray *)parseDictionaries:(NSArray *)dictionaries inContext:(NSManagedObjectContext *)context
{
    NSAssert(self.primaryKeyMapping != nil, @"primary key mapping is nil");

    //PrimaryKeyのidが同じ既存のオブジェクトを探す。あればそのオブジェクトを更新し、なければ新しいオブジェクトを作る。
    NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K = $ID", self.primaryKeyMapping.destinationKey];
    KZTDataMapperObjectBlock destinationObjectBlock = ^id(id srcObject) {
        id key = [srcObject valueForKeyPath:self.primaryKeyMapping.srcKeyPath];
        fr.predicate = [pred predicateWithSubstitutionVariables:@{@"ID": key}];
        NSArray *result = [context executeFetchRequest:fr error:NULL];
        if ([result count] > 0) {
            return result[0];
        } else {
            id newObj = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:context];
            [self.primaryKeyMapping mapFromObject:srcObject toObject:newObj];
            return newObj;
        }
    };

    return [self parseDictionaries:dictionaries withDestinationObjectBlock:destinationObjectBlock];
}

@end