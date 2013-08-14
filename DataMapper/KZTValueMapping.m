#import "KZTValueMapping.h"



@implementation KZTValueMapping

- (void)mapFromObject:(id)src toObject:(id)dst
{
    id val = [src valueForKeyPath:self.srcKeyPath];
    if (val == [NSNull null]) {
        val = nil;
    }
    if (self.block) {
        val = self.block(val);
    }
    [dst setValue:val forKey:self.destinationKey];
}

@end

