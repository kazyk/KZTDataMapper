#import <Foundation/Foundation.h>
#import "KZTDataMapper.h"


@interface KZTValueMapping : NSObject

@property (copy, nonatomic) NSString *srcKeyPath;
@property (copy, nonatomic) NSString *destinationKey;
@property (copy, nonatomic) KZTDataMapperValueBlock block;

- (void)mapFromObject:(id)src toObject:(id)dst;

@end
