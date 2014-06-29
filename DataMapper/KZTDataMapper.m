#import "KZTDataMapper.h"
#import "KZTValueMapping.h"

static NSDateFormatter *defaultDateFormatter = nil;



@interface KZTDataMapper ()
@property (readonly, nonatomic) NSMutableArray *mappings;
@end

@implementation KZTDataMapper

- (id)init
{
    self = [super init];
    if (self) {
        _mappings = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSDateFormatter *)defaultDateFormatter
{
    return defaultDateFormatter;
}

+ (void)setDefaultDateFormatter:(NSDateFormatter *)dateFormatter
{
    defaultDateFormatter = dateFormatter;
}

- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter) {
        return _dateFormatter;
    }
    return [[self class] defaultDateFormatter];
}

- (void)mapValueFromKeyPath:(NSString *)srcKeyPath toKey:(NSString *)destinationKey destinationClass:(Class)destinationClass
{
    [self mapValueFromKeyPath:srcKeyPath toKey:destinationKey transformBlock:[self valueBlockForClass:destinationClass]];
}

- (void)mapValueFromKeyPath:(NSString *)srcKeyPath toKey:(NSString *)destinationKey transformBlock:(KZTDataMapperValueBlock)block
{
    NSParameterAssert([srcKeyPath length] && [destinationKey length]);
    KZTValueMapping *mapp = [[KZTValueMapping alloc] init];
    mapp.srcKeyPath = srcKeyPath;
    mapp.destinationKey = destinationKey;
    mapp.block = block;
    [self.mappings addObject:mapp];
}

- (NSArray *)parseDictionaries:(NSArray *)dictionaries withDestinationObjectBlock:(KZTDataMapperObjectBlock)objectBlock
{
    NSParameterAssert(objectBlock);

    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[dictionaries count]];
    for (NSDictionary *dict in dictionaries) {
        id destObj = objectBlock(dict);
        for (KZTValueMapping *map in self.mappings) {
            [map mapFromObject:dict toObject:destObj];
        }
        [result addObject:destObj];
    }
    return result;
}

- (NSArray *)parseDictionaries:(NSArray *)dictionaries withDestiationClass:(Class)destinationClass
{
    NSParameterAssert(destinationClass);

    return [self parseDictionaries:dictionaries withDestinationObjectBlock:^(NSDictionary *sourceDictionary) {
        return [[destinationClass alloc] init];
    }];
}

- (KZTDataMapperValueBlock)valueBlockForClass:(Class)aClass
{
    if (aClass == [NSString class]) {
        return ^id(id sourceValue) {
            return [sourceValue description];
        };
    } else if (aClass == [NSNumber class]) {
        return ^id(id sourceValue) {
            if ([sourceValue isKindOfClass:[NSNumber class]]) {
                return sourceValue;
            }
            return nil;
        };
    } else if (aClass == [NSDate class]) {
        __weak typeof(self) wself = self;
        return ^id(id sourceValue) {
            if ([sourceValue isKindOfClass:[NSString class]]) {
                return [wself.dateFormatter dateFromString:sourceValue];
            }
            return nil;
        };
    } else if (aClass == [NSURL class]) {
        return ^id(id sourceValue) {
            if ([sourceValue isKindOfClass:[NSURL class]]) {
                return sourceValue;
            } else if ([sourceValue isKindOfClass:[NSString class]]) {
                return [NSURL URLWithString:sourceValue];
            }
            return nil;
        };
    }
    return nil;
}

@end