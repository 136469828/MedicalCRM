//
//  InfoViewController.m
//  MedicalCRM
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "InfoViewController.h"
#import "UIImageView+WebCache.h"
#import "KeyboardToolBar.h"
#import "NetManger.h"
@interface InfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *titles;
    NetManger *manger;
    UIImageView *userImage;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation InfoViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    userImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-60, 5, 55, 55)];
    [userImage sd_setImageWithURL:[NSURL URLWithString:self.imgUrl]];
    manger = [NetManger shareInstance];
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 35, 20);
        meassageBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [meassageBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [meassageBut addTarget:self action:@selector(updateInfo) forControlEvents:UIControlEventTouchDown];
        [meassageBut setTitle:@"确定" forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
    [self setTableView];
}
#pragma mark -
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -54) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    titles = @[@"头像",@"昵称",@"部门",@"手机号码"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellInfier = @"cell";
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellInfier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // cell控件
    UIImageView *userImg = [[UIImageView alloc] init];
    UILabel *subTitleLabel = [[UILabel alloc] init];
    UILabel *mainLabel = [[UILabel alloc] init];
    UITextField *textFiled = [[UITextField alloc] init];
    UILabel *stetaLabel = [[UILabel alloc] init];
    subTitleLabel.font  = [UIFont systemFontOfSize:15];
    mainLabel.font      = [UIFont systemFontOfSize:15];
    stetaLabel.font     = [UIFont systemFontOfSize:15];
    if (indexPath.row == 0) {
        userImg.frame = CGRectMake(ScreenWidth-60, 5, 55, 55);
//        [userImg sd_setImageWithURL:[NSURL URLWithString:manger.userImg]];
        userImg = userImage;
        userImg.layer.cornerRadius = 8;
        userImg.layer.masksToBounds = YES;
        [cell.contentView addSubview:userImg];
    }// 头像
    else if (indexPath.row == 1)
    {
        textFiled.frame = CGRectMake(ScreenWidth*0.3, 5, ScreenWidth-ScreenWidth*0.3-10, 30);
        textFiled.tag = 999 + indexPath.row;
        textFiled.delegate = self;
        textFiled.font = [UIFont systemFontOfSize:15];
//      textFiled.text = manger.userCnName;
        textFiled.text = self.infos[0];
        [cell.contentView addSubview:textFiled];
    }//用户昵称
    else if (indexPath.row == 2)
    {
        subTitleLabel.frame = CGRectMake(0, 2, ScreenWidth-10, 40);
//        sexStr = subTitleLabel.text;
        subTitleLabel.text = self.infos[1];
        [cell.contentView addSubview:subTitleLabel];
    }// 职务
    else if (indexPath.row == 3)
    {
        textFiled.frame = CGRectMake(ScreenWidth*0.3, 5, ScreenWidth-ScreenWidth*0.3-10, 30);
        textFiled.tag = 999 + indexPath.row;
        //                textFiled.layer.borderWidth = 1;
        //                textFiled.layer.cornerRadius = 5;
        textFiled.delegate = self;
//        textFiled.text = manger.userMobile;
        textFiled.text = self.infos[2];
        textFiled.font = [UIFont systemFontOfSize:15];
        //                textFiled.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [cell.contentView addSubview:textFiled];
        
    }// 手机号码

    [KeyboardToolBar registerKeyboardToolBar:textFiled];
    cell.textLabel.text = titles[indexPath.row];
    textFiled.textAlignment = NSTextAlignmentRight;
    subTitleLabel.textAlignment = NSTextAlignmentRight;
    mainLabel.textAlignment = NSTextAlignmentRight;
    stetaLabel.textAlignment = NSTextAlignmentRight;
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从本地中选取", nil];
        [actionSheet showInView:self.view];
    }
}
// 实现代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            // 拍照
            [self visitCamers];
            break;
        case 1:
            // 打开相册
            [self visitPhotos];
            break;
            
        default:
            break;
    }
}
// 访问摄像头
- (void)visitCamers{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
    }else {
        NSLog(@"该设备无摄像头");
    }
}

// 访问相册
- (void)visitPhotos{
    UIImagePickerController *photoPickerController = [[UIImagePickerController alloc] init];
    photoPickerController.delegate = self;
    photoPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:photoPickerController animated:YES completion:nil];
}
// 读取图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    userImage.image = img;
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 从相册返回
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 图片转64

- (NSString *) image2DataURL: (UIImage *) image
{
    NSLog(@"开始");
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSString *pictureDataString=[data base64Encoding];
    NSLog(@"结束");
    return pictureDataString;
}

#pragma mark - updateInfo
- (void)updateInfo
{
    manger.photoData = [self image2DataURL:userImage.image];
//    NSLog(@"%@",manger.photoData);
    UITextField *textField = (UITextField *)[self.view viewWithTag:1000];
    UITextField *textField2 = (UITextField *)[self.view viewWithTag:1002];
    NSLog(@"%@ %@",textField.text,textField2.text);
    manger.userInfos = @[textField.text,
                         textField2.text];
    [manger loadData:RequestOfAccountUpdate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"update" object:nil];
}
- (void)reloadDatas
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
