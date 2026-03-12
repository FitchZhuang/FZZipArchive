//
//  SSZipArchive+FZZip.m
//  FZZipArchive
//
//  Created by FitchZhuang on 2026/3/12.
//

#import "SSZipArchive+FZZip.h"
#import "mz_compat.h"
#import "zconf.h"

@implementation SSZipArchive (FZZip)

+ (nullable NSArray<NSString *> *)filePathsInZipAtPath:(NSString *)zipPath error:(NSError **)error {
    if (!zipPath) {
        if (error) *error = [NSError errorWithDomain:@"SSZipArchive.MemoryRead"
                                                code:-1
                                            userInfo:@{NSLocalizedDescriptionKey:@"zipPath is nil"}];
        return nil;
    }
    
    const char *cPath = [zipPath fileSystemRepresentation];
    unzFile uf = unzOpen(cPath);
    if (!uf) {
        if (error) *error = [NSError errorWithDomain:@"SSZipArchive.MemoryRead"
                                                code:-2
                                            userInfo:@{NSLocalizedDescriptionKey:@"Failed to open ZIP file"}];
        return nil;
    }
    
    NSMutableArray<NSString *> *paths = [NSMutableArray array];
    int err = unzGoToFirstFile(uf);
    while (err == UNZ_OK) {
        unz_file_info64 fileInfo;
        char fileName[256];
        err = unzGetCurrentFileInfo64(uf, &fileInfo, fileName, sizeof(fileName), NULL, 0, NULL, 0);
        if (err != UNZ_OK) break;
        
        // 跳过目录（以 / 结尾的条目）
        if (fileName[strlen(fileName) - 1] != '/') {
            NSString *name = [NSString stringWithUTF8String:fileName];
            if (name) {
                [paths addObject:name];
            }
        }
        
        err = unzGoToNextFile(uf);
    }
    
    unzClose(uf);
    return [paths copy];
}


+ (nullable NSData *)dataWithFileInZipAtPath:(NSString *)zipPath filePath:(nonnull NSString *)filePath error:(NSError **)error {
    if (!zipPath || !filePath) {
        if (error) *error = [NSError errorWithDomain:@"SSZipArchive.MemoryRead"
                                                code:-1
                                            userInfo:@{NSLocalizedDescriptionKey:@"zipPath or fileName is nil"}];
        return nil;
    }
    
    const char *cZipPath = [zipPath fileSystemRepresentation];
    unzFile uf = unzOpen(cZipPath);
    if (!uf) {
        if (error) *error = [NSError errorWithDomain:@"SSZipArchive.MemoryRead"
                                                code:-2
                                            userInfo:@{NSLocalizedDescriptionKey:@"Failed to open ZIP file"}];
        return nil;
    }
    
    int locateResult = unzLocateFile(uf, [filePath UTF8String], 0);
    if (locateResult != UNZ_OK) {
        unzClose(uf);
        if (error) *error = [NSError errorWithDomain:@"SSZipArchive.MemoryRead"
                                                code:-3
                                            userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"File not found in ZIP: %@", filePath]}];
        return nil;
    }
    
    int openResult = unzOpenCurrentFile(uf);
    if (openResult != UNZ_OK) {
        unzClose(uf);
        if (error) *error = [NSError errorWithDomain:@"SSZipArchive.MemoryRead"
                                                code:-4
                                            userInfo:@{NSLocalizedDescriptionKey:@"Failed to open file in ZIP"}];
        return nil;
    }
    
    unz_file_info64 fileInfo;
    unzGetCurrentFileInfo64(uf, &fileInfo, NULL, 0, NULL, 0, NULL, 0);
    
    NSMutableData *data = [NSMutableData dataWithLength:fileInfo.uncompressed_size];
    uLong totalRead = 0;
    const size_t bufferSize = 4096;
    char *buffer = malloc(bufferSize);
    if (!buffer) {
        unzCloseCurrentFile(uf);
        unzClose(uf);
        if (error) *error = [NSError errorWithDomain:@"SSZipArchive.MemoryRead"
                                                code:-5
                                            userInfo:@{NSLocalizedDescriptionKey:@"Failed to allocate buffer"}];
        return nil;
    }
    
    while (totalRead < fileInfo.uncompressed_size) {
        uLong remaining = (uLong)(fileInfo.uncompressed_size - totalRead);
        uLong toRead = MIN(bufferSize, remaining);
        int bytesRead = unzReadCurrentFile(uf, buffer, (unsigned int)toRead);
        if (bytesRead <= 0) {
            break;
        }
        [data replaceBytesInRange:NSMakeRange(totalRead, bytesRead) withBytes:buffer];
        totalRead += bytesRead;
    }
    
    free(buffer);
    unzCloseCurrentFile(uf);
    unzClose(uf);
    
    if (totalRead != fileInfo.uncompressed_size) {
        if (error) *error = [NSError errorWithDomain:@"SSZipArchive.MemoryRead"
                                                code:-6
                                            userInfo:@{NSLocalizedDescriptionKey:@"Incomplete read from ZIP"}];
        return nil;
    }
    
    return data;
}


@end
