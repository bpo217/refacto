//
//  Renamed.h
//  refacto

#import <Foundation/Foundation.h>

@interface RefactoParser : NSObject
{
@private
  NSString *path;
  NSString *s1;
  NSString *s2;
  NSMutableArray *options;
  NSMutableArray *extensions;
  NSMutableArray *changes;
}

@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSString *s1;
@property (nonatomic, retain) NSString *s2;
@property (nonatomic, retain) NSMutableArray *options;
@property (nonatomic, retain) NSMutableArray *extensions;

//Currently Unused.  Plan on adding each change into this array,
//Then Log it after parsing completion. 
@property (nonatomic, retain) NSMutableArray *changes;

-(id)initWithArgc:(int)argc argv:(const char *[])argv;

-(void)parse;

@end
