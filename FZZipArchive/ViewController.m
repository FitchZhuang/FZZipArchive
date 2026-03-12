//
//  ViewController.m
//  FZZipArchive
//
//  Created by 庄慧钰 on 2026/3/12.
//

#import "ViewController.h"
#import "SSZipArchive+FZZip.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (IBAction)readZip:(id)sender {
    NSString *zipPath = [NSBundle.mainBundle pathForResource:@"demo" ofType:@"zip"];
    NSError *err;
    NSArray *paths = [SSZipArchive filePathsInZipAtPath:zipPath error:&err];
    if (err) {
        NSLog(@"Load zip file error: %@", err.localizedDescription);
        return;
    }
    
    NSLog(@"File paths in zip: %@", paths);
    
    for (NSString *filePath in paths) {
        // 去掉mac系统会出现的.DS_Store等隐藏文件
        if ([filePath.lastPathComponent hasPrefix:@"."]) {
            continue;
        }
        NSData *fileData = [SSZipArchive dataWithFileInZipAtPath:zipPath filePath:filePath error:&err];
        if (err) {
            NSLog(@"Load file with path: %@, error: %@", filePath, err.localizedDescription);
            continue;
        }
        if ([filePath.pathExtension isEqualToString:@"txt"]) {
            NSString *text = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
            self.textLabel.text = text;
            NSLog(@"File path: %@. Content: %@", filePath, text);
        }
        else if ([filePath.pathExtension isEqualToString:@"png"]) {
            self.imageView.image = [UIImage imageWithData:fileData];
            NSLog(@"File path: %@. Image bytes: %ld", filePath, fileData.length);
        }
    }
}


@end
