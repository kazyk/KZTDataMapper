#import "DataMapperTests.h"
#import "KZTDataMapper.h"
#import "KZTCoreDataMapper.h"
#import "AppDelegate.h"

@interface SampleObject : NSObject
@property (nonatomic) NSString *string;
@property (nonatomic) NSNumber *number;
@property (nonatomic) id obj;
@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger integer;
@end

@implementation SampleObject
@end


@interface NSManagedObject(SampleEntity)
@property (nonatomic) NSNumber *entityID;
@property (nonatomic) NSString *title;
@end

@implementation NSManagedObject(SampleEntity)
@dynamic entityID, title;
@end


@implementation DataMapperTests

- (void)testNormalObject
{
    id src = @[
            @{
                    @"string": @"STRING",
                    @"number": @123,
                    @"nnname": @"nnnameeee",
                    @"integer": @456,
            }
    ];

    KZTDataMapper *mapper = [[KZTDataMapper alloc] init];
    [mapper mapValueFromKeyPath:@"string" toKey:@"string" destinationClass:[NSString class]];
    [mapper mapValueFromKeyPath:@"number" toKey:@"number" destinationClass:[NSNumber class]];
    [mapper mapValueFromKeyPath:@"nnname" toKey:@"name" destinationClass:[NSString class]];
    [mapper mapValueFromKeyPath:@"integer" toKey:@"integer" destinationClass:[NSNumber class]];

    NSArray *result = [mapper parseDictionaries:src withDestiationClass:[SampleObject class]];

    STAssertEquals([result count], (NSUInteger)1, @"");
    STAssertTrue([result[0] isKindOfClass:[SampleObject class]], @"");
    SampleObject *obj = result[0];
    STAssertEqualObjects(obj.string, @"STRING", @"");
    STAssertEqualObjects(obj.number, @123, @"");
    STAssertNil(obj.obj, @"");
    STAssertEqualObjects(obj.name, @"nnnameeee", @"");
    STAssertEquals(obj.integer, 456, @"");
}

- (void)testCoreDataObject
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *all = [NSFetchRequest fetchRequestWithEntityName:@"SampleEntity"];

    KZTCoreDataMapper *mapper = [[KZTCoreDataMapper alloc] initWithEntityName:@"SampleEntity"];
    [mapper mapPrimaryKeyFromKeyPath:@"id" toKey:@"entityID" destinationClass:[NSNumber class]];

    id src1 = @[
            @{
                    @"id": @1000,
                    @"title": @"title",
            },
            @{
                    @"id": @2000,
                    @"title": @"title",
            },
    ];

    NSArray *result1 = [mapper parseDictionaries:src1 inContext:context];
    STAssertEquals([result1 count], (NSUInteger)2, @"");
    STAssertEqualObjects([result1[0] entityID], @1000, @"");
    STAssertEqualObjects([result1[1] entityID], @2000, @"");
    STAssertEquals([[context executeFetchRequest:all error:NULL] count], (NSUInteger)2, @"");

    id src2 = @[
            @{
                    @"id": @3000,
                    @"title": @"title",
            },
            @{
                    @"id": @1000,
                    @"title": @"hoge",
            },
    ];

    NSArray *result2 = [mapper parseDictionaries:src2 inContext:context];
    STAssertEquals([result2 count], (NSUInteger)2, @"");
    STAssertEqualObjects([result2[0] entityID], @3000, @"");
    STAssertEqualObjects([result2[1] entityID], @1000, @"");
    STAssertEquals([[context executeFetchRequest:all error:NULL] count], (NSUInteger)3, @"");
}

@end