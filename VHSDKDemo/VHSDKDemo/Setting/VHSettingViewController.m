//
//  VHSettingViewController.m
//  VHallSDKDemo
//
//  Created by yangyang on 2017/2/13.
//  Copyright © 2017年 vhall. All rights reserved.
//

#import "VHSettingViewController.h"
#import "VHSettingGroup.h"
#import "VHSettingTextFieldItem.h"
#import "VHSettingTableViewCell.h"
#import "VHSettingArrowItem.h"
#import "CustomPickerView.h"
#import <VHLiveSDK/VHallApi.h>
#define MakeColorRGB(hex)  ([UIColor colorWithRed:((hex>>16)&0xff)/255.0 green:((hex>>8)&0xff)/255.0 blue:(hex&0xff)/255.0 alpha:1.0])
@interface VHSettingViewController()<UITableViewDataSource,UITableViewDelegate,CustomPickerViewDataSource,CustomPickerViewDelegate,UITextFieldDelegate>
{
    NSArray * _selectArray;

    VHSettingTextFieldItem *item00,*item01,*item02,*item03;
    VHSettingTextFieldItem *item10,*item11,*item12,*item13,*item14,*item15;
    VHSettingTextFieldItem *item20,*item21,*item22,*item23;
    VHSettingTextFieldItem *item30;

    UISwitch *_noiseSwitch;
}
@property(nonatomic,strong) NSMutableArray *groups;

@property(nonatomic,strong) CustomPickerView    *pickerView;//选择框控件
@property(nonatomic,strong) UITableView         *tableView;
@property(nonatomic,strong) UITextField         *tempTextField;
@end

@implementation VHSettingViewController

//-(instancetype)init
//{
//    return [super initWithStyle:UITableViewStyleGrouped];
//}


-(NSMutableArray *)groups
{
    if (!_groups)
    {
        _groups = [NSMutableArray array];
    }
    return _groups;
}


-(void)initWithView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:)
                                            name:UIKeyboardDidHideNotification object:nil];
    [[UIApplication sharedApplication].keyWindow setBackgroundColor:[UIColor whiteColor]];
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    headerView.backgroundColor=[UIColor blackColor];
    [self.view insertSubview:headerView atIndex:0];
    
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0,20, 44, 44)];
    [back setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:back];

    
    UILabel *title=[[UILabel alloc] init];
    [title setTextColor:[UIColor whiteColor]];
    [title setText:@"参数设置"];
    [title setFont:[UIFont systemFontOfSize:18]];
    [title sizeToFit];
    title.center = CGPointMake(headerView.center.x, 40);
    [headerView addSubview:title];

    _pickerView = [CustomPickerView loadFromXib];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickerView setTitle:@"请选择分辨率"];
    
    _noiseSwitch = [[UISwitch alloc]init];
    [_noiseSwitch addTarget:self action:@selector(noiseSwitch) forControlEvents:UIControlEventValueChanged];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStyleGrouped];
   // tableView.backgroundColor=[UIColor whiteColor];
    _tableView.userInteractionEnabled=YES;
    UIView *header=[[UIView alloc] initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, 30)];
    UILabel *text=[[UILabel alloc] init];
    
    
    [text setText:@"使用聊天、问答等功能必须登录"];
    [text sizeToFit];
    text.center =header.center;
    [text setTextColor:MakeColorRGB(0xd71a27)];
    [text setFont:[UIFont systemFontOfSize:12]];
    text.textAlignment=NSTextAlignmentCenter;
    [header addSubview:text];
    header.backgroundColor=MakeColorRGB(0xefcacc);
    
    UIImageView *brast =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"brast"]];
    [brast setFrame:CGRectMake(text.left , 10, brast.width, brast.height)];
    [header addSubview:brast];
    
    [_tableView setTableHeaderView:header];
    _tableView.dataSource= self;
    _tableView.delegate = self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    if ([_tableView  respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [_tableView reloadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _selectArray = @[@"352X288",@"640X480",@"960X540",@"1280X720"];
    
    //0    1 VHPushTypeSD 2 VHPushTypeHD 3 VHPushTypeUHD
    DEMO_Setting.pushResolution = @"1";//

    self.title = @"设置";
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
    [self initWithView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _pickerView.frame = [UIScreen mainScreen].bounds;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setupGroup0
{
    item00 = [VHSettingTextFieldItem  itemWithTitle:@"活动ID"];
    item00.text=DEMO_Setting.watchActivityID;
    item01 = [VHSettingTextFieldItem  itemWithTitle:@"k值"];
    item01.text =  DEMO_Setting.kValue;
    item02 = [VHSettingTextFieldItem  itemWithTitle:@"缓冲时间"];
    item02.text = [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.bufferTimes];
    item03 = [VHSettingTextFieldItem  itemWithTitle:@"超时时间"];
    item03.text = [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.timeOut];
    VHSettingGroup *group= [VHSettingGroup groupWithItems:@[item00,item01,item02,item03]];
    group.headerTitle = @"观看直播/回放";
    [self.groups addObject:group];
}

-(void)setupGroup1
{
    __weak typeof(self) weakSelf = self;
    item10 = [VHSettingTextFieldItem  itemWithTitle:@"直播token"];
    item10.text = DEMO_Setting.liveToken;
    item11 = [VHSettingTextFieldItem  itemWithTitle:@"活动ID"];
    item11.text =  DEMO_Setting.activityID;
    item12 = [VHSettingTextFieldItem  itemWithTitle:@"分辨率"];
    item12.text = _selectArray[[DEMO_Setting.videoResolution intValue]];
    item12.operation=^(NSIndexPath *indexPath)
    {
        [weakSelf.tempTextField endEditing:YES];
        [weakSelf.pickerView showPickerView:weakSelf.view];
    };
    item13 = [VHSettingTextFieldItem  itemWithTitle:@"视频码率(kpbs)"];
    item13.text = [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.videoBitRate];
    item14 = [VHSettingTextFieldItem  itemWithTitle:@"视频帧率(fps)"];
    item14.text =  [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.videoCaptureFPS];
    item15 = [VHSettingTextFieldItem  itemWithTitle:@"音频码率(kpbs)"];
    item15.text = [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.audioBitRate];
    VHSettingGroup *group= [VHSettingGroup groupWithItems:@[item10,item11,item12,item13,item14,item15]];
    group.headerTitle = @"发直播设置";
    [self.groups addObject:group];
    
}

-(void)setupGroup2
{
    item20 = [VHSettingTextFieldItem  itemWithTitle:@"用户ID"];
    
    if ([VHallApi isLoggedIn])
    {
        item20.text =  DEMO_Setting.account;
    }else
    {
        item20.text =  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    
    item21 = [VHSettingTextFieldItem  itemWithTitle:@"昵称"];
    
    if ([VHallApi isLoggedIn])
    {
         item21.text = DEMO_Setting.nickName;
    }else
    {
        item21.text = [UIDevice currentDevice].name;
    }
    
    item22 = [VHSettingTextFieldItem  itemWithTitle:@"AppKey"];
    item22.text = DEMO_Setting.appKey;
    item23 = [VHSettingTextFieldItem  itemWithTitle:@"AppSecretKey"];
    item23.text = DEMO_Setting.appSecretKey;

    VHSettingGroup *group= [VHSettingGroup groupWithItems:@[item20,item21,item22,item23]];
    group.headerTitle = @"其他设置";
    [self.groups addObject:group];
}
- (void)setupGroup3
{
    __weak typeof(self) weakSelf = self;
    item30 = [VHSettingTextFieldItem  itemWithTitle:@"分辨率"];
    item30.operation=^(NSIndexPath *indexPath)
    {
        [weakSelf.tempTextField endEditing:YES];
    };

    VHSettingGroup *group= [VHSettingGroup groupWithItems:@[item13]];
    group.headerTitle = @"互动直播";
    [self.groups addObject:group];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    VHSettingGroup *group =self.groups[section];
    if(section == 1)
        return group.items.count+1;
    return group.items.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VHSettingGroup *group=self.groups [indexPath.section];
    if(indexPath.section == 1 && indexPath.row == group.items.count)
    {
        static   NSString *Identifier = @"noiseSwitchCell";
        UITableViewCell *noiseSwitchcell =[tableView dequeueReusableCellWithIdentifier:Identifier];
        if (noiseSwitchcell == nil)
            noiseSwitchcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        _noiseSwitch.on = DEMO_Setting.isOpenNoiseSuppresion;
        noiseSwitchcell.textLabel.text = @"音频降噪";
        noiseSwitchcell.textLabel.font = [UIFont systemFontOfSize:14];
        _noiseSwitch.left = self.view.width - 60;
        _noiseSwitch.top = 10;
        [noiseSwitchcell.contentView addSubview:_noiseSwitch];
        
        return noiseSwitchcell;
    }
    else if(indexPath.section == 3 && indexPath.row == 0)
    {
        static   NSString *identifier1 = @"selectedResolutionCell";
        UITableViewCell *resolutionCell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (resolutionCell == nil)
            resolutionCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        resolutionCell.textLabel.text = @"分辨率";
        resolutionCell.textLabel.font = [UIFont systemFontOfSize:14];

        NSArray *titles = @[@"标清",@"清晰",@"流畅"];
        for (int i = 0; i<3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"resolution_normal"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"resolution_Selected"] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.frame = CGRectMake(80+i*80, 0, 80, 50);
            [resolutionCell.contentView addSubview:button];
            button.tag = 10010 + i;
            [button addTarget:self action:@selector(selectedResolution:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == 2) {
                button.selected = YES;
            }
        }
        
        return resolutionCell;
    }
 
    
    __weak typeof(self) weakSelf=self;
    VHSettingTableViewCell *cell =[VHSettingTableViewCell  cellWithTableView:tableView];
    VHSettingItem          *item = group.items[indexPath.row];
    item.indexPath=indexPath;
    cell.item  =item;
    
    cell.inputText= ^(NSString *text)
    {
        if ([text isEqualToString:@""])
        {
            text = nil;
        }
        
        [weakSelf value:text indexPath:indexPath];
    };
    
    cell.changePosition=^(UITextField *textField)
    {
        weakSelf.tempTextField=textField;
    };
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VHSettingGroup *group=self.groups [indexPath.section];
    if(indexPath.section == 1 && indexPath.row == group.items.count)
    {
        return;
    }
    if(indexPath.section == 3 && indexPath.row == 0) {
        return;
    }
    
    VHSettingItem  *item = group.items[indexPath.row];
    if (item.operation)
    {
        item.operation(indexPath);
    }else if ([item isKindOfClass:[VHSettingTextFieldItem class]])
    {
        
    }else if ([item isKindOfClass:[VHSettingArrowItem  class]])
    {
        VHSettingArrowItem *arrowItem = (VHSettingArrowItem*)item;
        if (arrowItem.desVc)
        {
            UIViewController *vc =[[arrowItem.desVc alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    // 取出组模型
    VHSettingGroup *group =  self.groups[section];
    return group.headerTitle;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:   (NSInteger)section{
    // 取出组模型
    VHSettingGroup *group =  self.groups[section];
    return group.footTitle;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     if(section == 0)
         return 32;
    return 15;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

- (void)selectedResolution:(UIButton *)sender {
    
    UIButton *button0 = [self.view viewWithTag:10010];
    button0.selected = NO;
    UIButton *button1 = [self.view viewWithTag:10011];
    button1.selected = NO;
    UIButton *button2 = [self.view viewWithTag:10012];
    button2.selected = NO;

    sender.selected = YES;
    
    //0    1 VHPushTypeSD 2 VHPushTypeHD 3 VHPushTypeUHD
    switch (sender.tag-10010) {
        case 0:     //标清
            DEMO_Setting.pushResolution = @"3";
            break;
        case 1:     //清晰
            DEMO_Setting.pushResolution = @"2";
            break;
        case 2:     //流畅
            DEMO_Setting.pushResolution = @"1";
            break;
    }
}


- (void)showKeyboard:(NSNotification *)noti
{
    self.view.transform = CGAffineTransformIdentity;
    UIView *editView = _tempTextField;
    
    CGRect tfRect = [editView.superview convertRect:editView.frame toView:self.view];
    NSValue *value = noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
//    NSLog(@"%@", value);
    CGRect keyBoardF = [value CGRectValue];
    
    CGFloat animationTime = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGFloat _editMaxY = CGRectGetMaxY(tfRect);
    CGFloat _keyBoardMinY = CGRectGetMinY(keyBoardF);
//    NSLog(@"%f %f", _editMaxY, _keyBoardMinY);
    if (_keyBoardMinY < _editMaxY) {
        CGFloat moveDistance = _editMaxY - _keyBoardMinY;
        [UIView animateWithDuration:animationTime animations:^{
            self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -moveDistance);
        }];
        
    }
}

- (void)hideKeyboard:(NSNotification *)noti
{
    //    NSLog(@"%@", noti);
    //
    [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
    [UIView setAnimationDuration:0.3];
    self.view.transform = CGAffineTransformIdentity;
    
    [UIView commitAnimations];
}


#pragma mark event
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

-(void)back
{


    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)customPickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
{
    NSString * title =_selectArray[row];
    [item12 setText:title];
     DEMO_Setting.videoResolution =  [NSString stringWithFormat:@"%ld",(long)row];
    [_tableView reloadData];
    
}
#pragma mark - CustomPickerViewDataSource
- (NSString*)titleOfRowCustomPickerViewWithRow:(NSInteger)row
{
    NSString * title =_selectArray[row];
    return title;
}

- (NSInteger)numberOfRowsInPickerView
{
    return _selectArray.count;
}

-(void)value:(NSString*)text indexPath:(NSIndexPath*)indexpath
{
    if (indexpath.section == 1)
    {
        switch (indexpath.row)
        {
            case 0:
            {
                if(text.length == 32 || text.length == 0)
                    DEMO_Setting.liveToken = text;
                else
                    [self showMsg:@"Token长度错误" afterDelay:1.5];
                item10.text = DEMO_Setting.liveToken;
            }
                break;
            case 1:
            {
                DEMO_Setting.activityID = text;
                item11.text =  DEMO_Setting.activityID;
            }
                break;
            case 2:
                
                break;
            case 3:
            {
                DEMO_Setting.videoBitRate= [text integerValue];
                item13.text = [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.videoBitRate];
            }
                break;
            case 4:
            {
                DEMO_Setting.videoCaptureFPS = [text integerValue];
                item14.text =  [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.videoCaptureFPS];
            }
                break;
            case 5:
            {
                 DEMO_Setting.audioBitRate = [text integerValue];
                 item15.text = [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.audioBitRate];
            }
                break;
            default:
                break;
        }
    }else if (indexpath.section ==0)
    {
        switch (indexpath.row)
        {
            case 0:
            {
                DEMO_Setting.watchActivityID = text;
                item00.text=DEMO_Setting.watchActivityID;
            }
                break;
            case 1:
            {
                DEMO_Setting.kValue = text;
                item01.text =  DEMO_Setting.kValue;
            }
                break;
            case 2:
            {
                DEMO_Setting.bufferTimes = [text integerValue];
                item02.text = [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.bufferTimes];
            }
                break;
            case 3:
            {
                DEMO_Setting.timeOut = [text integerValue];
                item03.text = [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.timeOut];
            }
                break;
            default:
                break;
        }
    }else if (indexpath.section == 2)
    {
        switch (indexpath.row)
        {
            case 0:
                DEMO_Setting.account =text;
                break;
            case 1:
                DEMO_Setting.nickName =text;
                break;
            case 2:
            {
                if(text.length == 32 || [text hasSuffix:@"00"] || text.length == 0)
                    DEMO_Setting.appKey  =text;
                else
                    [self showMsg:@"appKey 输入错误" afterDelay:1.5];
                item22.text = DEMO_Setting.appKey;
            }
                break;
            case 3:
            {
                if(text.length == 32 || text.length == 0)
                    DEMO_Setting.appSecretKey =text;
                else
                    [self showMsg:@"appSecretKey长度错误" afterDelay:1.5];
                item23.text = DEMO_Setting.appSecretKey;
            }
                break;
            default:
                break;
        }
    }
}

- (void)noiseSwitch
{
    DEMO_Setting.isOpenNoiseSuppresion = _noiseSwitch.on;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
     [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

-(BOOL)shouldAutorotate
{
    return NO;
}
@end













