//
//  DLNAView.m
//  UIModel
//
//  Created by yangyang on 2017/9/3.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "DLNAView.h"
#import "VHDLNAControlDelegate.h"
#import "VHDLNAControl.h"
//#import "DLNAUpnpServer.h"
#import "DeviceTableViewCell.h"
#import "Device.h"
#define DEVICE_CELL_ID @"DeviceCell"
//#import "VHallConst.h"
@interface DLNAView ()<UITableViewDataSource,UITableViewDelegate>
{
    
}

@property(nonatomic,strong) UILabel   *deviceCountLabel;
@property(nonatomic,strong) UILabel   *findDeviceCount;
@property(nonatomic,strong) UILabel   *selectDeviceLabel;
@property(nonatomic,strong) UITableView *deviceTableView;
@property(nonatomic,assign) int       indexRow;
@property(nonatomic,strong) UIButton   *showBtn;
@property(nonatomic,strong) UIButton   *closeBtn;
@property(nonatomic,strong) NSString   *url;
@property(nonatomic,strong) NSArray     *deviceArray;
@end

@implementation DLNAView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.indexRow = -1;
        self.backgroundColor = [UIColor whiteColor];
        _deviceCountLabel = [[UILabel alloc] init];
        [_deviceCountLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_deviceCountLabel];
        
        
        _findDeviceCount = [[UILabel alloc] init];
        [self addSubview:_findDeviceCount];
        
        _selectDeviceLabel = [[UILabel alloc] init];
        [self addSubview:_selectDeviceLabel];
        
        _deviceTableView =[[UITableView alloc] init];
        _deviceTableView.dataSource = self;
        _deviceTableView.delegate = self;
        [self addSubview:_deviceTableView];
         [_deviceTableView registerClass:DeviceTableViewCell.class forCellReuseIdentifier:DEVICE_CELL_ID];
        
        _showBtn = [[UIButton alloc] init];
        [_showBtn setBackgroundColor:[UIColor redColor]];
        [_showBtn setTitle:@"投屏" forState:UIControlStateNormal];
        [_showBtn addTarget:self action:@selector(route:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_showBtn];
        
        
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setBackgroundColor:[UIColor grayColor]];
        [_closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setBackgroundColor:[UIColor blueColor]];
        [self addSubview:_closeBtn];
        
      
    }
    
    return self;
}



//- (void)onChange {
//    int count = (int)[[[DLNAUpnpServer shareServer] getDeviceList] count];
//        _findDeviceCount.text = [[NSString alloc] initWithFormat:@"%d", count];
//    
//    if (count>0) {
//        [_deviceTableView reloadData];
//    }
//}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return   _deviceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceTableViewCell *cell = (DeviceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:DEVICE_CELL_ID forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[DeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DEVICE_CELL_ID];
    }
    
   Device *device = [_deviceArray objectAtIndex:indexPath.row];
    
   cell.titleLabel.text = device.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int index = (int) indexPath.row;
    self.indexRow = index;
    
}


-(void)layoutSubviews
{

    
    [_deviceCountLabel setFrame:CGRectMake(10, 10, 40, 20)];
    [_deviceCountLabel  setText:@"发现设备数:"];
    [_deviceCountLabel  sizeToFit];

    [_findDeviceCount  setFrame:CGRectMake(_deviceCountLabel.right+10, _deviceCountLabel.top, 40, 20)];
    
    
    [_selectDeviceLabel setFrame:CGRectMake(_deviceCountLabel.left, _deviceCountLabel.bottom+10, _deviceCountLabel.width, 20)];
    [_selectDeviceLabel setText:@"选择设备:"];
    
    [_deviceTableView setFrame:CGRectMake(_selectDeviceLabel.left, _selectDeviceLabel.bottom, self.width, self.height - _selectDeviceLabel.bottom-50)];
    
    [_showBtn setFrame:CGRectMake(50, self.height -50, self.width -100, 50)];
    
    [_closeBtn setFrame:CGRectMake(self.width - 60, 10, 50, 30)];
     // [_deviceTableView reloadData];
    
    
    
}
- (void)route:(id)sender
{
    if (NSClassFromString(@"VHDLNAControl"))
    {
        if (self.indexRow ==-1) {
            return;
        }
    [_control playWithDeviceIndex:self.indexRow];
       }
    
   
}


-(VHDLNAControl *)control
{
    
  
    if (!_control) {
        _control=[[VHDLNAControl alloc] init];
        ((VHDLNAControl*)_control).delegate = self;
    }
      return _control;
    
}
-(void)deviceList:(NSArray*)deviceList
{
    _deviceArray =deviceList;
     _findDeviceCount.text = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)_deviceArray.count];
    if (deviceList.count >0 ) {
        
        [_deviceTableView reloadData];
    }
}

-(void)close:(UIButton*)btn
{
    [self removeFromSuperview];
}

@end
