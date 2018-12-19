//
//  CAPFiles.m
//  GPSTracker
//
//  Created by WeifengYao on 25/11/2016.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPFiles.h"

@implementation CAPFiles
+ (void)createDirectories {
    [CAPFiles createDirectoryAtPath:[CAPFiles cachePath]];
    [CAPFiles createDirectoryAtPath:[CAPFiles dataPath]];
    [CAPFiles createDirectoryAtPath:[CAPFiles tempPath]];
    [CAPFiles createDirectoryAtPath:[CAPFiles notePath]];
}

+ (void)saveData:(NSData *)data toDocumentFile:(NSString *)fileName {
    NSLog(@"%@ saveData: %@", [self class], fileName);
    NSString *path = [self filePath:fileName];
    [data writeToFile:path atomically:YES];
}

+ (NSString *)documentPath {
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *documentDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    [fileManager createDirectoryAtPath:documentDirectory withIntermediateDirectories:YES attributes:nil error:nil];
//    return documentDirectory;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSURL *)documentURL {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [NSURL URLWithString:documentsDirectory];
}

+ (NSString *)cachePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"Cache"];
}

+ (NSURL *)cacheURL {
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //return [NSURL URLWithString:[documentsDirectory stringByAppendingPathComponent:@"Cache"]];
    return [NSURL fileURLWithPath:[self cachePath]];
}

+ (NSURL *)cacheFileURL:(NSString *)fileName {
    return [NSURL fileURLWithPath:[self cacheFilePath:fileName]];
}

+ (NSString *)cacheFilePath:(NSString *)fileName {
    return [[self cachePath] stringByAppendingPathComponent:fileName];
}

+ (void)clearCache {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager subpathsOfDirectoryAtPath:[self cachePath] error:nil];
    NSError *error;
    for(NSString *file in files) {
        [fileManager removeItemAtPath:[self cacheFilePath:file] error:&error];
        if(error) {
            NSLog(@"ERROR: delete cache file at path %@, %@", file, error);
            error = nil;
        }
    }
}

+ (NSString *)dataPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"Data"];
}

+ (NSURL *)dataURL {
    return [NSURL fileURLWithPath:[self dataPath]];
}

+ (NSURL *)dataFileURL:(NSString *)fileName {
    return [NSURL fileURLWithPath:[self dataFilePath:fileName]];
}

+ (NSString *)dataFilePath:(NSString *)fileName {
    return [[self dataPath] stringByAppendingPathComponent:fileName];
}

+ (void)clearData {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager subpathsOfDirectoryAtPath:[self dataPath] error:nil];
    NSError *error;
    for(NSString *file in files) {
        [fileManager removeItemAtPath:[self dataFilePath:file] error:&error];
        if(error) {
            NSLog(@"ERROR: delete file at path %@, %@", file, error);
            error = nil;
        }
    }
}

+ (NSString *)tempPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"Temp"];
}

+ (NSURL *)tempURL {
    return [NSURL fileURLWithPath:[self tempPath]];
}

+ (NSURL *)tempFileURL:(NSString *)fileName {
    return [NSURL fileURLWithPath:[self tempFilePath:fileName]];
}

+ (NSString *)tempFilePath:(NSString *)fileName {
    return [[self tempPath] stringByAppendingPathComponent:fileName];
}

+ (void)clearTemp {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager subpathsOfDirectoryAtPath:[self tempPath] error:nil];
    NSError *error;
    for(NSString *file in files) {
        [fileManager removeItemAtPath:[self tempFilePath:file] error:&error];
        if(error) {
            NSLog(@"ERROR: delete file at path %@, %@", file, error);
            error = nil;
        }
    }
}

+ (NSString *)notePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"Note"];
}

+ (NSURL *)noteURL {
    return [NSURL fileURLWithPath:[self notePath]];
}

+ (NSURL *)noteFileURL:(NSString *)fileName {
    return [NSURL fileURLWithPath:[self noteFilePath:fileName]];
}

+ (NSString *)noteFilePath:(NSString *)fileName {
    return [[self notePath] stringByAppendingPathComponent:fileName];
}

+ (void)clearNote {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager subpathsOfDirectoryAtPath:[self notePath] error:nil];
    NSError *error;
    for(NSString *file in files) {
        [fileManager removeItemAtPath:[self noteFilePath:file] error:&error];
        if(error) {
            NSLog(@"ERROR: delete file at path %@, %@", file, error);
            error = nil;
        }
    }
}

+ (NSString *)filePath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+ (NSURL *)fileURL:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    return [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:fileName]];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *documentDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    [fileManager createDirectoryAtPath:documentDirectory withIntermediateDirectories:YES attributes:nil error:nil];
//    NSString *path = [documentDirectory stringByAppendingPathComponent:fileName];
//    return [NSURL URLWithString:path];
}

+ (BOOL)deleteAtURL:(NSURL *)fileURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL result = [fileManager removeItemAtURL:fileURL error:&error];
    if(error) {
        NSLog(@"ERROR: delete at URL %@, %@", fileURL, error);
    }
    return result;
}

+ (BOOL)deleteAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL result = [fileManager removeItemAtPath:filePath error:&error];
    if(error) {
        NSLog(@"ERROR: delete file at path %@, %@", filePath, error);
    }
    return result;
}

+ (BOOL)isExistedAtURL:(NSURL *)fileURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:[fileURL path]];
}

+ (BOOL)isExistedAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

+ (NSString *)createDirectory:(NSString *)directoryName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *directoryPath = [documentsPath stringByAppendingPathComponent:directoryName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:directoryPath]) {
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"Directory %@ has existed.", directoryPath);
    }
    return directoryPath;
}

+ (NSString *)createDirectoryAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSLog(@"Directory %@ has existed.", path);
    } else {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

+ (NSArray *)listFilesAtDocumentDir:(NSString *)directoryName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *directoryPath = [documentsPath stringByAppendingPathComponent:directoryName];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:directoryPath error:nil];
    
    return files;
}

+ (NSArray *)listFilesAtURL:(NSURL *)directoryURL {
    return [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:[directoryURL path] error:nil];
}

+ (NSArray *)listFilesAtPath:(NSString *)directoryPath {
    return [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:directoryPath error:nil];
}

+ (BOOL)copyFileAtPath:(NSString *)srcPath toPath:(NSString *)dstPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL result = [fileManager copyItemAtPath:srcPath toPath:dstPath error:&error];
    if(error) {
        NSLog(@"Copy %@ to %@ ERROR: %@", srcPath, dstPath, error);
    }
    return result;
}

+ (BOOL)copyFileAtURL:(NSURL *)srcURL toURL:(NSURL *)dstURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL result = [fileManager copyItemAtURL:srcURL toURL:dstURL error:&error];
    if(error) {
        NSLog(@"Copy %@ to %@ ERROR: %@", srcURL, dstURL, error);
    }
    return result;
}

+ (BOOL)moveFileAtPath:(NSString *)srcPath toPath:(NSString *)dstPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL result = [fileManager moveItemAtPath:srcPath toPath:dstPath error:&error];
    if(error) {
        NSLog(@"Move %@ to %@ ERROR: %@", srcPath, dstPath, error);
    }
    return result;
}

+ (NSTimeInterval)createdTimeAtURL:(NSURL *)fileURL {
    return [self createdTimeAtPath:fileURL.path];
}

+ (NSTimeInterval)createdTimeAtPath:(NSString *)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        NSDate *date = [[manager attributesOfItemAtPath:filePath error:nil] fileCreationDate];
        return date.timeIntervalSince1970;
    }
    return 0;
}

+ (unsigned long long)sizeAtURL:(NSURL *)fileURL {
    return [self sizeAtPath:[fileURL path]];
}

+ (nullable NSDate *)modificationDateAtPath:(NSString *)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileModificationDate];
    }
    return nil;
}

+ (unsigned long long)sizeAtPath:(NSString *)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//+ (NSTimeInterval)createdTimeAtPath:(NSString *)filePath {
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSDictionary *fileAttributes = [fileManager fileAttributesAtPath:filePath traverseLink:YES];
//    if (fileAttributes != nil) {
//        NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
//        NSDate *creationDate = [fileAttributes objectForKey:NSFileCreationDate];
//        NSString *fileOwner = [fileAttributes objectForKey:NSFileOwnerAccountName];
//        NSDate *modifiedDate = [fileAttributes objectForKey:NSFileModificationDate];
//    }
//    return 0;
//}
@end
