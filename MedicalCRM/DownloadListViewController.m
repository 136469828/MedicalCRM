//
//  DownloadListViewController.m
//  MedicalCRM
//
//  Created by admin on 16/9/3.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "DownloadListViewController.h"

@interface DownloadListViewController ()<NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *lab;
/**
 *  用来写数据的文件句柄对象
 */
@property (nonatomic, strong) NSFileHandle *writeHandle;

/**
 *  文件的总长度
 */
@property (nonatomic, assign) long long totalLength;
/**
 *  当前已经写入的总大小
 */
@property (nonatomic, assign) long long  currentLength;
/**
 *  连接对象
 */
@property (nonatomic, strong) NSURLConnection *connection;
@end

@implementation DownloadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)downLoadBtn:(UIButton *)sender
{
    // 状态取反
    sender.selected = !sender.isSelected;
    
    // 断点续传
    // 断点下载
    
    if (sender.selected) { // 继续（开始）下载
        // 1.URL
        //        NSURL* url = [NSURL URLWithString:@"http://localhost:8080/shudai99/resources/The_Fixer.mp4"];
        NSURL* url = [NSURL URLWithString:_downloadurl];
        // 2.请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        // 设置请求头
        NSString *range = [NSString stringWithFormat:@"bytes=%lld-", self.currentLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        // 3.下载
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    } else { // 暂停
        
        [self.connection cancel];
        self.connection = nil;
    }
}


#pragma mark - NSURLConnectionDataDelegate代理方法

/**
 *  请求失败时调用（请求超时、网络异常）
 *
 *  @param error      错误原因
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}
/**
 *  1.接收到服务器的响应就会调用
 *
 *  @param response   响应
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // 如果文件已经存在，不执行以下操作
    if (self.currentLength) return;
    // 文件路径
    NSString* ceches = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* filepath = [ceches stringByAppendingPathComponent:response.suggestedFilename];
    
    // 创建一个空的文件到沙盒中
    NSFileManager* mgr = [NSFileManager defaultManager];
    [mgr createFileAtPath:filepath contents:nil attributes:nil];
    NSLog(@"%@",filepath);
    // 创建一个用来写数据的文件句柄对象
    self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:filepath];
    
    // 获得文件的总大小
    self.totalLength = response.expectedContentLength;
    
}
/**
 *  2.当接收到服务器返回的实体数据时调用（具体内容，这个方法可能会被调用多次）
 *
 *  @param data       这次返回的数据
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 移动到文件的最后面
    [self.writeHandle seekToEndOfFile];
    
    // 将数据写入沙盒
    [self.writeHandle writeData:data];
    
    // 累计写入文件的长度
    self.currentLength += data.length;
    
    // 下载进度
    self.progress.progress = (double)self.currentLength / self.totalLength;
    
    float progress = (double)self.currentLength / self.totalLength;
    self.lab.text = [NSString stringWithFormat:@"当前下载进度:%.0f%%",progress*100];
}
/**
 *  3.加载完毕后调用（服务器的数据已经完全返回后）
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[[UIAlertView alloc] initWithTitle:@"下载完成" message:@"已成功下载文件" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil] show];
    self.currentLength = 0;
    self.totalLength = 0;
    
    // 关闭文件
    [self.writeHandle closeFile];
    self.writeHandle = nil;
    self.btn.hidden = YES;
}
@end
