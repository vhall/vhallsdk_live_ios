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
#import "VHallApi.h"
#define MakeColorRGB(hex)  ([UIColor colorWithRed:((hex>>16)&0xff)/255.0 green:((hex>>8)&0xff)/255.0 blue:(hex&0xff)/255.0 alpha:1.0])
@interface VHSettingViewController()<UITableViewDataSource,UITableViewDelegate,CustomPickerViewDataSource,CustomPickerViewDelegate,UITextFieldDelegate>
{
    NSArray * _selectArray;

    VHSettingTextFieldItem *item0;
    VHSettingTextFieldItem *item1;
    VHSettingTextFieldItem *item2;
    VHSettingTextFieldItem *item3;
    VHSettingTextFieldItem *item4;
    VHSettingTextFieldItem *item5;
    VHSettingTextFieldItem *item6;
    VHSettingTextFieldItem *item7;
    VHSettingTextFieldItem *item8;
    VHSettingTextFieldItem *item9;
    VHSettingTextFieldItem *item10;
    VHSettingTextFieldItem *item11;
    VHSettingTextFieldItem *item12;
    
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
    self.title = @"设置";
    [self setupGroup1];
    [self setupGroup0];
    [self setupGroup2];
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
    __weak typeof(self) weakSelf = self;
    item0 = [VHSettingTextFieldItem  itemWithTitle:@"直播token"];
    item0.text = DEMO_Setting.liveToken;
    item1 = [VHSettingTextFieldItem  itemWithTitle:@"活动ID"];
    item1.text =  DEMO_Setting.activityID;
    item2 = [VHSettingTextFieldItem  itemWithTitle:@"分辨率"];
    item2.text = _selectArray[[DEMO_Setting.videoResolution intValue]];
    item2.operation=^(NSIndexPath *indexPath)
    {
        [weakSelf.tempTextField endEditing:YES];
        [weakSelf.pickerView showPickerView:weakSelf.view];
    };
    item3 = [VHSettingTextFieldItem  itemWithTitle:@"视频码率(kpbs)"];
    item3.text = [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.videoBitRate];
    item4 = [VHSettingTextFieldItem  itemWithTitle:@"视频帧率(fps)"];
    item4.text =  [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.videoCaptureFPS];
    item5 = [VHSettingTextFieldItem  itemWithTitle:@"音频码率(kpbs)"];
    item5.text = [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.audioBitRate];
    VHSettingGroup *group= [VHSettingGroup groupWithItems:@[item0,item1,item2,item3,item4,item5]];
    group.headerTitle = @"发直播设置";
    [self.groups addObject:group];
    
}


-(void)setupGroup1
{
    item6 = [VHSettingTextFieldItem  itemWithTitle:@"活动ID"];
    item6.text=DEMO_Setting.watchActivityID;
    item7 = [VHSettingTextFieldItem  itemWithTitle:@"k值"];
    item7.text =  DEMO_Setting.kValue;
    item8 = [VHSettingTextFieldItem  itemWithTitle:@"缓冲时间"];
    item8.text = [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.bufferTimes];
    VHSettingGroup *group= [VHSettingGroup groupWithItems:@[item6,item7,item8]];
    group.headerTitle = @"观看直播/回放";
    [self.groups addObject:group];
}


-(void)setupGroup2
{
    item9 = [VHSettingTextFieldItem  itemWithTitle:@"用户ID"];
    
    if ([VHallApi isLoggedIn])
    {
        item9.text =  DEMO_Setting.account;
    }else
    {
        item9.text =  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    
    item10 = [VHSettingTextFieldItem  itemWithTitle:@"昵称"];
    
    if ([VHallApi isLoggedIn])
    {
         item10.text = DEMO_Setting.nickName;
    }else
    {
        item10.text = [UIDevice currentDevice].name;
    }
    
    item11 = [VHSettingTextFieldItem  itemWithTitle:@"AppKey"];
    item11.text = DEMO_Setting.appKey;
    item12 = [VHSettingTextFieldItem  itemWithTitle:@"AppSecretKey"];
    item12.text = DEMO_Setting.appSecretKey;

    VHSettingGroup *group= [VHSettingGroup groupWithItems:@[item9,item10,item11,item12]];
    group.headerTitle = @"其他设置";
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




- (void)showKeyboard:(NSNotification *)noti
{
    self.view.transform = CGAffineTransformIdentity;
    UIView *editView = _tempTextField;
    
    CGRect tfRect = [editView.superview convertRect:editView.frame toView:self.view];
    NSValue *value = noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    NSLog(@"%@", value);
    CGRect keyBoardF = [value CGRectValue];
    
    CGFloat animationTime = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGFloat _editMaxY = CGRectGetMaxY(tfRect);
    CGFloat _keyBoardMinY = CGRectGetMinY(keyBoardF);
    NSLog(@"%f %f", _editMaxY, _keyBoardMinY);
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
    [item2 setText:title];
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
                item0.text = DEMO_Setting.liveToken;
            }
                break;
            case 1:
            {
                DEMO_Setting.activityID = text;
                item1.text =  DEMO_Setting.activityID;
            }
                break;
            case 2:
                
                break;
            case 3:
            {
                DEMO_Setting.videoBitRate= [text integerValue];
                item3.text = [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.videoBitRate];
            }
                break;
            case 4:
            {
                DEMO_Setting.videoCaptureFPS = [text integerValue];
                item4.text =  [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.videoCaptureFPS];
            }
                break;
            case 5:
            {
                 DEMO_Setting.audioBitRate = [text integerValue];
                 item5.text = [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.audioBitRate];
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
                item6.text=DEMO_Setting.watchActivityID;
            }
                break;
            case 1:
            {
                DEMO_Setting.kValue = text;
                item7.text =  DEMO_Setting.kValue;
            }
                break;
            case 2:
            {
                DEMO_Setting.bufferTimes = [text integerValue];
                item8.text = [NSString stringWithFormat:@"%ld",(long)DEMO_Setting.bufferTimes];
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
                item11.text = DEMO_Setting.appKey;
            }
                break;
            case 3:
            {
                if(text.length == 32 || text.length == 0)
                    DEMO_Setting.appSecretKey =text;
                else
                    [self showMsg:@"appSecretKey长度错误" afterDelay:1.5];
                item12.text = DEMO_Setting.appSecretKey;
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













