//
//  SZQuestionCheckBox.m
//  SZQuestionCheckBox_demo
//
//  Created by 吴三忠 on 16/4/27.
//  Copyright © 2016年 吴三忠. All rights reserved.
//

#import "VHQuestionCheckBox.h"
#import "SZQuestionCell.h"
#import "SZQuestionOptionCell.h"
#import <VHLiveSDK/VHallApi.h>
@interface VHQuestionCheckBox ()

@property (nonatomic, assign) CGFloat titleWidth;
@property (nonatomic, assign) CGFloat OptionWidth;
@property (nonatomic, assign) BOOL complete;
@property (nonatomic, strong) NSArray *tempArray;
@property (nonatomic, strong) NSMutableArray *arrayM;
@property (nonatomic, strong) SZConfigure *configure;
@property (nonatomic, assign) QuestionCheckBoxType chekBoxType;
@property(nonatomic,strong)   UITableView    *tableView;
@property(nonatomic,strong)   UILabel       *waringLabel;//警告label;
@property(nonatomic,strong)  NSMutableArray   *isHaveAnser;//是否回答
@property(nonatomic,strong)  NSMutableArray   *uploadArray;
@end

@implementation VHQuestionCheckBox

- (instancetype)initWithItem:(SZQuestionItem *)questionItem {
    
    SZConfigure *configure = [[SZConfigure alloc] init];
    configure.automaticAddLineNumber=YES;
    return [self initWithItem:questionItem andConfigure:configure];
}

- (instancetype)initWithItem:(SZQuestionItem *)questionItem andConfigure:(SZConfigure *)configure {
    
    return [self initWithItem:questionItem andCheckBoxType:QuestionCheckBoxWithoutHeader andConfigure:configure];
}

- (instancetype)initWithItem:(SZQuestionItem *)questionItem andCheckBoxType:(QuestionCheckBoxType)checkBoxType {
    
    SZConfigure *configure = [[SZConfigure alloc] init];
    return [self initWithItem:questionItem andCheckBoxType:checkBoxType andConfigure:configure];
}


- (instancetype)initWithItem:(SZQuestionItem *)questionItem andCheckBoxType:(QuestionCheckBoxType)checkBoxType andConfigure:(SZConfigure *)configure {
    
    self = [super init];
    
    if (self) {
        self.sourceArray = questionItem.ItemQuestionArray;
        if (configure != nil) self.configure = configure;
        self.chekBoxType = checkBoxType;
    }
    return self;
}




- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    self.tableView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, VHScreenHeight - endFrame.size.height-20);
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
            //CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
                CGPoint offset = CGPointMake(0, -endFrame.size.height/4);
            [self.tableView setContentOffset:offset animated:NO];
        }
    }];
}

#pragma mark 键盘将要隐藏
- (void)keyboardWillHide:(NSNotification *)notification {
    self.tableView.frame = CGRectMake(0, 84, self.tableView.frame.size.width, [UIScreen mainScreen].bounds.size.height-84);
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    self.view.backgroundColor=[UIColor whiteColor];
    _isHaveAnser=[[NSMutableArray alloc] init];
    _uploadArray =[[NSMutableArray alloc] init];
    self.canEdit = YES;
    [self initView];
 
}


-(void)initView
{
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44)];
    [self.view addSubview:topView];
    UIButton *closeBtn =[[UIButton alloc] init];
    closeBtn.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, topView.height/2);
    [closeBtn setImage:[UIImage imageNamed:@"UIModel.bundle/关闭.tiff"] forState:UIControlStateNormal];
    [closeBtn setSize:CGSizeMake(14, 14)];
    [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:closeBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 44, [UIScreen mainScreen].bounds.size.width-10, 40)];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextAlignment:NSTextAlignmentLeft];
//    [label setText:_survey.surveyTitle];
    [self.view addSubview:label];
    CGRect rect = CGRectMake(0.0f, 84, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-84);
    self.tableView = [[UITableView alloc] initWithFrame:rect];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView setTableFooterView:[self tableFootView]];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
}

-(UIView*)tableFootView
{
    UIView *footView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    self.waringLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, [UIScreen mainScreen].bounds.size.width, 10)];
    self.waringLabel.textAlignment=NSTextAlignmentCenter;
    [self.waringLabel setTextColor:[UIColor redColor]];
    [self.waringLabel setFont:[UIFont systemFontOfSize:14]];
    [footView addSubview:self.waringLabel];
    
    UIButton  *upload= [[UIButton alloc] initWithFrame:CGRectMake(0, self.waringLabel.bottom+5, [UIScreen mainScreen].bounds.size.width, footView.height-self.waringLabel.height-5)];
    [upload setTitle:@"提交" forState:UIControlStateNormal];
    [upload addTarget:self action:@selector(uploadContent) forControlEvents:UIControlEventTouchUpInside];
    upload.titleLabel.textAlignment = NSTextAlignmentCenter;
    [upload setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [footView addSubview:upload];
    
    return footView;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.titleWidth = self.view.frame.size.width - self.configure.titleSideMargin * 2;
    self.OptionWidth = self.view.frame.size.width - self.configure.optionSideMargin * 2 - self.configure.buttonSize - 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isComplete {
    
    [self getResult];
    return self.complete;
}

- (NSArray *)resultArray {
    
    [self getResult];
    return self.tempArray;
}

- (void)getResult {
    
    [self.view endEditing:YES];
    BOOL complete          = true;
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in self.sourceArray)
    {
        
        if ([dict[@"type"] integerValue] == SZQuestionOpenQuestion) {
            NSString *str = dict[@"marked"];
            complete      = (str.length > 0) && complete;
            [arrayM addObject:str.length ? str : @""];
        }
        else {
            NSArray *array = dict[@"marked"];
            complete       = ([array containsObject:@"YES"] || [array containsObject:@"yes"] || [array containsObject:@(1)] || [array containsObject:@"1"]) && complete;
            [arrayM addObject:array];
        }
    }

    int  count =(int)self.sourceArray.count;
    [_isHaveAnser removeAllObjects];
    for (int i=0 ; i<count; i++)
    {
    
        NSDictionary *dict =[self.sourceArray objectAtIndex:i];
        NSMutableDictionary *tempDic=[[NSMutableDictionary alloc] init];
        if ([dict[@"type"] integerValue] == SZQuestionOpenQuestion)
        {
            NSString *str = dict[@"marked"];
            if (str.length > 0)
            {
                [tempDic setValue:@"1" forKey:[NSString stringWithFormat:@"%d",i]];
            }else
            {
                [tempDic setValue:@"0" forKey:[NSString stringWithFormat:@"%d",i]];
            }
        }else
        {
            NSArray *array = dict[@"marked"];
            if ([array containsObject:@"YES"] || [array containsObject:@"yes"] || [array containsObject:@(1)] || [array containsObject:@"1"])
            {
                [tempDic setValue:@"1" forKey:[NSString stringWithFormat:@"%d",i]];
            }else
            {
              [tempDic setValue:@"0" forKey:[NSString stringWithFormat:@"%d",i]];
               
            }
        }
        [_isHaveAnser addObject:tempDic];

    }
    
    self.complete   = complete;
    self.tempArray  = arrayM.copy;
}

- (void)setCanEdit:(BOOL)canEdit {
    
    _canEdit = canEdit;
    [self.tableView reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

#pragma mark - UITableViewdatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.chekBoxType == QuestionCheckBoxWithHeader ? self.sourceArray.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.chekBoxType == QuestionCheckBoxWithHeader) {
        NSDictionary *dict = self.sourceArray[section];
        if ([dict[@"type"] intValue] == SZQuestionOpenQuestion) {
            return 1;
        }
        else {
            NSArray *optionArray = dict[@"option"];
            return optionArray.count;
        }
    }
    else {
        return self.sourceArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.chekBoxType == QuestionCheckBoxWithHeader) {
        NSDictionary *dict = self.sourceArray[indexPath.section];
        SZQuestionOptionCell *cell = [[SZQuestionOptionCell alloc]
                                      initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"questionOptionCellIdentifier"
                                      andDict:dict
                                      andIndexPath:indexPath
                                      andWidth:self.view.frame.size.width
                                      andConfigure:self.configure];
        __weak typeof(self) weakSelf = self;
        cell.selectOptionButtonBack = ^(NSIndexPath *indexPath, NSDictionary *dict) {
            [weakSelf.arrayM replaceObjectAtIndex:indexPath.section withObject:dict];
            weakSelf.sourceArray = weakSelf.arrayM.copy;
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section];
            [weakSelf.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = self.canEdit;
        return cell;
    }
    else {
        NSDictionary *dict = self.sourceArray[indexPath.row];
        SZQuestionCell *cell = [[SZQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:@"questionCellIdentifier"
                                                             andDict:dict
                                                      andQuestionNum:indexPath.row + 1
                                                            andWidth:self.view.frame.size.width
                                                        andConfigure:self.configure];
        __weak typeof(self) weakSelf = self;
        cell.selectOptionBack = ^(NSInteger index, NSDictionary *dict, BOOL refresh) {
            [weakSelf.arrayM replaceObjectAtIndex:index withObject:dict];
            weakSelf.sourceArray = weakSelf.arrayM.copy;
            if (refresh) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
            }
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = self.canEdit;
        return cell;
    }
}

#pragma mark - UITableViewdelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.chekBoxType == QuestionCheckBoxWithHeader) {
        NSDictionary *dict = self.sourceArray[section];
        NSString *title = self.configure.automaticAddLineNumber ? [NSString stringWithFormat:@"%zd、%@", section + 1, dict[@"title"]] : dict[@"title"];
        CGFloat title_height = [SZQuestionItem heightForString:title
                                                         width:self.titleWidth
                                                      fontSize:self.configure.titleFont
                                                 oneLineHeight:self.configure.oneLineHeight];
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = [UIColor whiteColor];
        UILabel *lbl =({
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.configure.titleSideMargin, 0, self.titleWidth, title_height)];
            lbl.font = [UIFont systemFontOfSize:self.configure.titleFont];
            lbl.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            lbl.numberOfLines = 0;
            lbl.text = title;
            lbl;
        });
        [v addSubview:lbl];
        return v;
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.chekBoxType == QuestionCheckBoxWithHeader) {
        NSDictionary *dict = self.sourceArray[section];
        CGFloat title_height = [SZQuestionItem heightForString:dict[@"title"]
                                                         width:self.titleWidth
                                                      fontSize:self.configure.titleFont
                                                 oneLineHeight:self.configure.oneLineHeight];
        return title_height;
    }
    else {
        return 0;
    }
}

/**
 *  返回各个Cell的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.chekBoxType == QuestionCheckBoxWithHeader) {
        
        NSDictionary *dict = self.sourceArray[indexPath.section];
        if ([dict[@"type"] intValue] == SZQuestionOpenQuestion) {
            
            return self.configure.oneLineHeight;
        }
        else {
            
            NSArray *optionArray = dict[@"option"];
            NSString *optionString = [NSString stringWithFormat:@"M、%@", optionArray[indexPath.row]];
            CGFloat option_height = [SZQuestionItem heightForString:optionString width:self.OptionWidth fontSize:self.configure.optionFont oneLineHeight:self.configure.oneLineHeight];
            return option_height;
        }
    }
    else {
        
        CGFloat topDistance = (indexPath.row == 0 ? self.configure.topDistance : 0);
        NSDictionary *dict = self.sourceArray[indexPath.row];
        
        if ([dict[@"type"] intValue] == SZQuestionOpenQuestion) {
            
            CGFloat title_height = [SZQuestionItem heightForString:dict[@"title"]
                                                             width:self.titleWidth
                                                          fontSize:self.configure.titleFont
                                                     oneLineHeight:self.configure.oneLineHeight];
            if (self.configure.answerFrameFixedHeight && self.configure.answerFrameUseTextView == YES) {
                return title_height + self.configure.answerFrameFixedHeight + 10 + topDistance;
            }
            if ([dict[@"marked"] length] > 0) {
                CGFloat answer_width = self.view.frame.size.width - self.configure.optionSideMargin * 2;
                CGFloat answer_height = [SZQuestionItem heightForString:dict[@"marked"] width:answer_width - 10 fontSize:self.configure.optionFont oneLineHeight:self.configure.oneLineHeight];
                if (self.configure.answerFrameLimitHeight && answer_height > self.configure.answerFrameLimitHeight && self.configure.answerFrameUseTextView == YES) {
                    return title_height + self.configure.answerFrameLimitHeight + 10 + topDistance;
                }
                return title_height + answer_height + 10 + topDistance;
            }
            return title_height + self.configure.oneLineHeight + topDistance;
        }
        else {
            
            CGFloat title_height = [SZQuestionItem heightForString:dict[@"title"]
                                                             width:self.titleWidth
                                                          fontSize:self.configure.titleFont
                                                     oneLineHeight:self.configure.oneLineHeight];
            CGFloat option_height = 0;
            for (NSString *str in dict[@"option"]) {
                NSString *optionString = [NSString stringWithFormat:@"M、%@", str];
                option_height += [SZQuestionItem heightForString:optionString width:self.OptionWidth fontSize:self.configure.optionFont oneLineHeight:self.configure.oneLineHeight];
            }
            return title_height + option_height + topDistance;
        }
    }
}

#pragma mark - 懒加载

- (NSMutableArray *)arrayM {
    
    if (_arrayM == nil) {
        _arrayM = [[NSMutableArray alloc] initWithArray:self.sourceArray];
    }
    return _arrayM;
}


#pragma mark action //检测必填选项
-(void)uploadContent
{
    //[self getResult];
    if (self.isComplete)
    {
        [_waringLabel setText:nil];
        [self uploadDataMethod];
        
    }else
    {

        [_waringLabel setText:nil];

        for (int i = 0 ; i<_survey.questionArray.count; i++)
        {
            VHallSurveyQuestion *question = [_survey.questionArray objectAtIndex:i];
            NSDictionary *resultDic = [_isHaveAnser objectAtIndex:i];
            if (question.isMustSelect && [[resultDic objectForKey:[NSString stringWithFormat:@"%ld",i]] isEqualToString:@"0"])
            {
                [_waringLabel setText:[NSString stringWithFormat:@"第%ld题为必填题，请填写完整在提交!",i+1]];
                    return;
            }
        }
        [self uploadDataMethod];
        
    }
}

-(void)uploadDataMethod
{
   

    
    for (int i =0 ; i<self.sourceArray.count; i++)
    {   NSMutableDictionary *dic =nil;
        NSDictionary *questionAnswer = [self.sourceArray objectAtIndex:i];
        VHallSurveyQuestion *question = [_survey.questionArray objectAtIndex:i];
        if ([questionAnswer[@"type"] integerValue] == SZQuestionOpenQuestion)
        {
            NSString *str = questionAnswer[@"marked"];
            if (str.length >0)
            {
                dic =[[ NSMutableDictionary alloc] init];
                [dic setValue:str forKey:@"answer"];
                [dic setValue:[NSString stringWithFormat:@"%ld",question.questionId] forKey:@"ques_id"];

            }else
            {
                continue;
            }
            [_uploadArray addObject:dic];
        }else
        {
            NSArray *array = questionAnswer[@"marked"];
          __block  NSString *str = nil;
           if ([array containsObject:@"YES"] || [array containsObject:@"yes"] || [array containsObject:@(1)] || [array containsObject:@"1"])
            {
                str=[[NSMutableString alloc] init];
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj boolValue] == YES)
                    {   NSString *answer = [question.quesionSelectArray objectAtIndex:idx];
                        if (str.length ==0)
                        {
                            str = answer;

                        }else
                        {
                            NSString *tempStr =[NSString stringWithFormat:@"|%@",answer];
                            str=[NSString stringWithFormat:@"%@%@",str,tempStr];
                        }
                    }
                }];



                 dic =[[ NSMutableDictionary alloc] init];
                [dic setValue:str forKey:@"answer"];
                [dic setValue:[NSString stringWithFormat:@"%ld",question.questionId] forKey:@"ques_id"];
                [_uploadArray addObject:dic];
            }

        }


    }
     [self uploadDataWithArray:_uploadArray];
}

-(void)uploadDataWithArray:(NSArray*)dataArray
{
    __weak typeof(self) weakSelf =self;
    [_survey sendMsg:dataArray success:^{
         [weakSelf showMsg:@"提交成功" afterDelay:2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [weakSelf closeVC];
        });
       
       
    } failed:^(NSDictionary *failedData) {
        NSString* code = [NSString stringWithFormat:@"%@", failedData[@"code"]];
        [weakSelf showMsg:failedData[@"content"] afterDelay:2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf closeVC];
        });
    }];
}

#pragma mark 禁止转屏 
-(BOOL)shouldAutorotate
{
    return NO;
}

- (void)viewDidLayoutSubviews
{


}
#pragma mark event
-(void)closeVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
