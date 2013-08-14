#import <Foundation/Foundation.h>

//receives mapping source dictionary and returns destination object.
typedef id (^KZTDataMapperObjectBlock)(NSDictionary *sourceDictionary);

typedef id (^KZTDataMapperValueBlock)(id sourceValue);


@interface KZTDataMapper : NSObject

+ (NSDateFormatter *)defaultDateFormatter;

+ (void)setDefaultDateFormatter:(NSDateFormatter *)dateFormatter;

@property (nonatomic) NSDateFormatter *dateFormatter;

- (void)mapValueFromKeyPath:(NSString *)srcKeyPath toKey:(NSString *)destinationKey destinationClass:(Class)destinationClass;
- (void)mapValueFromKeyPath:(NSString *)srcKeyPath toKey:(NSString *)destinationKey transformBlock:(KZTDataMapperValueBlock)block;

//executes mapping.
- (NSArray *)parseDictionaries:(NSArray *)dictionaries withDestinationObjectBlock:(KZTDataMapperObjectBlock)objectBlock;

//convenience method, creates destination object using [[class alloc] init]
- (NSArray *)parseDictionaries:(NSArray *)dictionaries withDestiationClass:(Class)destinationClass;

- (KZTDataMapperValueBlock)valueBlockForClass:(Class)aClass;

@end