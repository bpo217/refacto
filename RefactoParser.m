//
//  Renamed.m
//  refacto

#import "RefactoParser.h"

@interface NSString (PathCompare)
- (NSComparisonResult)componentCountCompare:(NSString *)aString;
@end

@implementation NSString (PathCompare)

- (NSComparisonResult)componentCountCompare:(NSString *)aString
{
  int result = NSOrderedSame;
  
  if ([[self pathComponents] count] > [[aString pathComponents] count]) {
    result = NSOrderedAscending;
  } else if ([[self pathComponents] count] < [[aString pathComponents] count]) {
    result = NSOrderedDescending;
  } else {
    if (![[self pathExtension] isEqualToString:@""] &&
        [[aString pathExtension] isEqualToString:@""]) {
      result = NSOrderedAscending;
    } else if ([[self pathExtension] isEqualToString:@""] &&
               ![[aString pathExtension] isEqualToString:@""]) {
      result = NSOrderedDescending;
    }
  }
  
  return result;
}

@end

@interface RefactoParser (Private)

-(NSString *)tutorialString;

-(void)refactor:(NSString *)file;
-(void)rename:(NSString *)file;

-(BOOL)askWithQuestion:(NSString*)question forFile:(NSString *)file;
-(BOOL)shouldAsk;
-(BOOL)shouldChange:(NSString *)fileExt;
-(BOOL)shouldBeCaseInsensitive;
-(BOOL)shouldBeNoFolder;

@end

@implementation RefactoParser

#pragma mark -
#pragma mark Constants

static NSString * const kNoFolderString = @"-nf";
static NSString * const kCaseInsensitiveString = @"-ci";
static NSString * const kAlwaysAskString = @"-a";
static NSString * const kShowHelpString1 = @"-h";
static NSString * const kShowHelpString2 = @"-help";

#pragma mark -
#pragma mark Properties

@synthesize path;
@synthesize s1, s2;
@synthesize options, extensions;
@synthesize changes;

#pragma mark -
#pragma mark Public Initializers

-(id)initWithArgc:(int)argc argv:(const char *[])argv
{
  NSString *secondParam = [NSString stringWithFormat:@"%s",argv[1]];
  
  if (argc > 1 && 
      ([secondParam isEqualToString:kShowHelpString1] || 
       [secondParam isEqualToString:kShowHelpString2]) ) {
    
    NSLog(@"%@", [self tutorialString]);
    return nil;
  }
  
  if (argc < 4) {
    
    NSLog(@"%@", [self tutorialString]);
    return nil;
    
  } else {
    
    self = [super init];
    
    if (self) {
      
      self.path = [[NSFileManager defaultManager] currentDirectoryPath];
      self.options = [NSMutableArray array];
      self.extensions = [NSMutableArray array];
      self.changes = [NSMutableArray array];
      
      //Setup Options and Extensions
      for (int i = 1; i < argc; i++) {
        
        NSString *arg = [NSString stringWithFormat:@"%s", argv[i]];
        
        if (i == 1 || i == 2) {
          switch (i) {
            case 1:
              self.s1 = arg;
              break;
            case 2:
              self.s2 = arg;
              break;
          }
        } else if ([arg caseInsensitiveCompare:kNoFolderString] == NSOrderedSame || 
                   [arg caseInsensitiveCompare:kCaseInsensitiveString] == NSOrderedSame ||
                   [arg caseInsensitiveCompare:kAlwaysAskString] == NSOrderedSame) {
          
          [options addObject:[arg lowercaseString]];
          
        } else {
          [extensions addObject:arg];
        }
      }
    }
    
    return self;
  }
}

#pragma mark -
#pragma mark Public General Methods

-(void)parse
{
  NSFileManager *manager = [NSFileManager defaultManager];
  NSArray *allItems = 
    [[[manager enumeratorAtPath:self.path] allObjects] 
     sortedArrayUsingSelector:@selector(componentCountCompare:)];
  NSEnumerator *dEnum = [allItems reverseObjectEnumerator];
  NSString *file;
  
  NSLog(@"Refactoring...");
  while (file = [dEnum nextObject]) {
    [self refactor:file];
  }
  
  dEnum = [allItems reverseObjectEnumerator];
  
  NSLog(@"Renaming...");
  while (file = [dEnum nextObject]) {
    [self rename:file];
  }
}

#pragma mark -
#pragma mark Private General Methods

-(void)refactor:(NSString *)file
{
  NSFileManager *manager = [NSFileManager defaultManager];
  NSError *error = nil;
  int compareOption = 0;
  BOOL isDir = NO;
    
  if ([self shouldBeCaseInsensitive]) {
    compareOption = NSCaseInsensitiveSearch;
  }

  
  if ([manager fileExistsAtPath:file isDirectory:&isDir] &&
      !isDir && 
      [self shouldChange:[file pathExtension]]) {
    
    NSString *fileContent = 
    [NSString stringWithContentsOfFile:file 
                              encoding:NSUTF8StringEncoding 
                                 error:&error];
    if (error || !fileContent) {
      NSLog(@"Unable to change %@ because:\n*****%@\n*****", 
            file, error);
    } else {
      NSRange wholeFile = NSMakeRange(0, [fileContent length]);
      NSString *newFile = 
        [fileContent stringByReplacingOccurrencesOfString:self.s1 
                                               withString:self.s2 
                                                  options:compareOption 
                                                    range:wholeFile];
      
      if ([self shouldAsk] && 
          [self askWithQuestion:@"Refactor" forFile:file]) {
        [newFile writeToFile:file 
                  atomically:NO 
                    encoding:NSUTF8StringEncoding 
                       error:&error];
        
      } else {
        [newFile writeToFile:file 
                  atomically:NO 
                    encoding:NSUTF8StringEncoding 
                       error:&error];
      }
    }
    
    if (error) {
      NSLog(@"Failed to refactor %@ because:\n*****%@\n*****", 
            file, error);
    }
  }
}

-(void)rename:(NSString *)file
{
  NSFileManager *manager = [NSFileManager defaultManager];
  NSString *newFile;
  int compareOption = 0;
  BOOL isDir = NO;
  NSError *error = nil;
  
  if ([self shouldBeCaseInsensitive]) {
    compareOption = NSCaseInsensitiveSearch;
  }
  
  if ([[file pathExtension] isEqualToString:@""]) {
    
    newFile = 
      [file stringByReplacingOccurrencesOfString:self.s1 
                                      withString:self.s2 
                                         options:compareOption 
                                           range:[file rangeOfString:[file lastPathComponent] 
                                                             options:NSBackwardsSearch]]; 
  } else {
    
    NSRange extRange = [file rangeOfString:[file pathExtension] 
                                   options:NSBackwardsSearch];
    NSRange lastCompRange = [file rangeOfString:[file lastPathComponent] options:NSBackwardsSearch];
    NSRange replaceRange = NSMakeRange([file length] - lastCompRange.length, 
                                       lastCompRange.length - extRange.length);
    
    newFile = [file stringByReplacingOccurrencesOfString:self.s1 
                                              withString:self.s2 
                                                 options:compareOption 
                                                   range:replaceRange];
  }

  
  if ([manager fileExistsAtPath:file isDirectory:&isDir] && 
      ![file isEqualToString:newFile]) {    
    if (isDir && ![self shouldBeNoFolder]) {
      if ([self shouldAsk] && [self askWithQuestion:@"Rename" forFile:file]) {
        [manager moveItemAtPath:file toPath:newFile error:&error];
      } else {
        [manager moveItemAtPath:file toPath:newFile error:&error];
      }
    } else if (!isDir && [self shouldChange:[file pathExtension]]) {
      if ([self shouldAsk] && [self askWithQuestion:@"Rename" forFile:file]) {
        [manager moveItemAtPath:file toPath:newFile error:&error];
      } else {
        [manager moveItemAtPath:file toPath:newFile error:&error];
      }
    }
    
    if (error) {
      NSLog(@"Failed to Rename %@ to %@ because:\n*****%@\n*****", file, newFile, error);
    }
  }
}

-(NSString *)tutorialString
{
  return (@"\n\nProper Usage is: refacto findString changeString <file extensions> <options>\n\n"
  "File extensions are not optional.  \nIn order for any files to be renamed "
  "or refactored, you must list at least one file extension.\n\n"
  "Options:\n"
  "\t-a : Ask for confirmation to refactor or rename a file.\n"
  "\t-nf : Do not rename folders or subfolders\n"
  "\t-ci : Case Insenitive.  Will change all versions of findString\n\n");
}

-(BOOL)shouldChange:(NSString *)fileExt
{
  BOOL shouldChange = NO;
  
  for (NSString *ext in self.extensions) {
    if ([fileExt isEqualToString:ext]) {
      shouldChange = YES;
      break;
    }
  }
  
  return shouldChange;
}

-(BOOL)askWithQuestion:(NSString*)question forFile:(NSString *)file
{
  BOOL change = NO;
  BOOL keepAsking = YES;
  int size = 2;
    
  while (keepAsking) {
    char input[size];
    
    NSLog(@"%@ %@? (Y|y,N|n): ", question, file);
    fgets(input, size, stdin);
    input[1] = '\0';
    
    if (input[0] == 'y' || input[0] == 'Y') {
      change = YES;
      keepAsking = NO;
    } else if (input[0] == 'n' || input[0] == 'N') {
      keepAsking = NO;
    } else {
      NSLog(@"Invalid answer.");
    }
    
    int flush;
    while ((flush = getchar()) != '\n' && flush != EOF);
  }
  
  return change;
}

-(BOOL)shouldAsk
{
  BOOL ask = NO;
  
  for (NSString *option in self.options) {
    if ([option isEqualToString:kAlwaysAskString]) {
      ask = YES;
      break;
    }
  }
  
  return ask;
}

-(BOOL)shouldBeCaseInsensitive
{
  BOOL ci = NO;
  
  for (NSString *option in self.options) {
    if ([option isEqualToString:kCaseInsensitiveString]) {
      ci = YES;
      break;
    } 
  }
  
  return ci;
}

-(BOOL)shouldBeNoFolder
{
  BOOL nf = NO;
  
  for (NSString *option in self.options) {
    if ([option isEqualToString:kNoFolderString]) {
      nf = YES;
      break;
    } 
  }
  
  return nf;
}



@end
