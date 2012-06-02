//
//  main.m
//  refactory
//
//  Created by Benjamin Olson on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RefactoParser.h"

int main (int argc, const char *argv[])
{
  
  @autoreleasepool
  {
    RefactoParser *parser = [[RefactoParser alloc] initWithArgc:argc argv:argv];
    
    if (parser) {
      [parser parse];
    }
  }
  
  return 0;
}

