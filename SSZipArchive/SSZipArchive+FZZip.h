//
//  SSZipArchive+FZZip.h
//  FZZipArchive
//
//  Created by FitchZhuang on 2026/3/12.
//

#import "SSZipArchive.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSZipArchive (FZZip)

/// 获取 ZIP 文件中的所有文件路径列表（不包括目录条目，仅文件）
/// - Parameters:
///   - zipPath:    zip文件路径
+ (nullable NSArray<NSString *> *)filePathsInZipAtPath:(NSString *)zipPath error:(NSError **)error;


/// 从 ZIP 中读取指定文件的内容到内存（不解压到磁盘）
/// - Parameters:
///   - zipPath:    zip文件路径
///   - filePath:   要读取的文件在zip内的文件路径
+ (nullable NSData *)dataWithFileInZipAtPath:(NSString *)zipPath filePath:(NSString *)filePath error:(NSError **)error;


@end

NS_ASSUME_NONNULL_END
