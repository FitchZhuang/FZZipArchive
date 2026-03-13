# FZZipArchive



基于SSZipArchive-2.4.3，新增了SSZipArchive+FZZip类别，增加下面2个方法：

```objc
// 获取 ZIP 文件中的所有文件路径列表（不包括目录条目，仅文件）
+ (nullable NSArray<NSString *> *)filePathsInZipAtPath:(NSString *)zipPath error:(NSError **)error;

// 从 ZIP 中读取指定文件的内容到内存（不解压到磁盘）
+ (nullable NSData *)dataWithFileInZipAtPath:(NSString *)zipPath fileName:(NSString *)filePath error:(NSError **)error;
```



可直接替换SSZipArchive使用



cocoapods集成：

`pod 'FZZipArchive'`
