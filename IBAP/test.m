//
//  test.m
//  IBAP
//
//  Created by CHARU GUPTA on 05/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

#import <Foundation/Foundation.h>
NSFileManager *fileMgr;
NSString *entry;
NSString *documentsDir;
NSDirectoryEnumerator *enumerator;
BOOL isDirectory;

// Create file manager
fileMgr = [NSFileManager defaultManager];

// Path to documents directory
documentsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];

// Change to Documents directory
[fileMgr changeCurrentDirectoryPath:documentsDir];

// Enumerator for docs directory
enumerator = [fileMgr enumeratorAtPath:documentsDir];

// Get each entry (file or folder)
while ((entry = [enumerator nextObject]) != nil)
{
    // File or directory
    if ([fileMgr fileExistsAtPath:entry isDirectory:&isDirectory] && isDirectory)
    NSLog (@"Directory - %@", entry);
    else
    NSLog (@"  File - %@", entry);
}
