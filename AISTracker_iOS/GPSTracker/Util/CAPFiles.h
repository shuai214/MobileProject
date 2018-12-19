//
//  CAPFiles.h
//  GPSTracker
//
//  Created by WeifengYao on 25/11/2016.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAPFiles : NSObject
+ (void)createDirectories;

+ (NSURL *)documentURL;
+ (NSString *)documentPath;
+ (void)saveData:(NSData *)data toDocumentFile:(NSString *)fileName;


+ (NSURL *)cacheURL;
+ (NSString *)cachePath;
+ (NSURL *)cacheFileURL:(NSString *)fileName;
+ (NSString *)cacheFilePath:(NSString *)fileName;
+ (void)clearCache;


+ (NSString *)dataPath;
+ (NSURL *)dataURL;
+ (NSURL *)dataFileURL:(NSString *)fileName;
+ (NSString *)dataFilePath:(NSString *)fileName;
+ (void)clearData;

+ (NSString *)tempPath;
+ (NSURL *)tempURL;
+ (NSURL *)tempFileURL:(NSString *)fileName;
+ (NSString *)tempFilePath:(NSString *)fileName;
+ (void)clearTemp;

+ (NSString *)notePath;
+ (NSURL *)noteURL;
+ (NSURL *)noteFileURL:(NSString *)fileName;
+ (NSString *)noteFilePath:(NSString *)fileName;
+ (void)clearNote;

+ (NSURL *)fileURL:(NSString *)fileName;
+ (NSString *)filePath:(NSString *)fileName;
+ (BOOL)deleteAtURL:(NSURL *)fileURL;
+ (BOOL)deleteAtPath:(NSString *)filePath;
+ (BOOL)copyFileAtURL:(NSURL *)srcURL toURL:(NSURL *)dstURL;
+ (BOOL)copyFileAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;
+ (BOOL)moveFileAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;

+ (BOOL)isExistedAtURL:(NSURL *)fileURL;
+ (BOOL)isExistedAtPath:(NSString *)filePath;

+ (NSString *)createDirectory:(NSString *)directoryName;
+ (NSString *)createDirectoryAtPath:(NSString *)path;

+ (NSArray *)listFilesAtDocumentDir:(NSString *)directoryName;
+ (NSArray *)listFilesAtURL:(NSURL *)directoryURL;
+ (NSArray *)listFilesAtPath:(NSString *)directoryPath;

+ (unsigned long long)sizeAtURL:(NSURL *)fileURL;
+ (unsigned long long)sizeAtPath:(NSString *)filePath;
+ (nullable NSDate *)modificationDateAtPath:(NSString *)filePath;
+ (NSTimeInterval)createdTimeAtURL:(NSURL *)fileURL;
+ (NSTimeInterval)createdTimeAtPath:(NSString *)filePath;
@end
