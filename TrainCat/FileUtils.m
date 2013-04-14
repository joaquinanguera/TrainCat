//
//  FileUtils.m
//  TrainCat
//
//  Created by Alankar Misra on 14/04/13.
//
//

#import "FileUtils.h"

@implementation FileUtils

+(BOOL) fileExists:(NSString *)fileName
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *fileInResourcesFolder = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
	return [fileManager fileExistsAtPath:fileInResourcesFolder];
}

@end
