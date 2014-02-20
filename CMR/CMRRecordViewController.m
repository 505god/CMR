//
//  CMRRecordViewController.m
//  CMR
//
//  Created by comdosoft on 14-1-16.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRRecordViewController.h"
#import "UIView+Custom.h"

#define Space_Height 10
@interface CMRRecordViewController ()

@end

@implementation CMRRecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)dealWithString:(NSString *)string{
    self.modelArray = nil;
    NSString *regTags = @"\\[\\[.*?]]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:string
                                      options:0
                                        range:NSMakeRange(0, [string length])];
    // 用下面的办法来遍历每一条匹配记录
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match rangeAtIndex:0];
        NSString *tagString = [string substringWithRange:matchRange];  // 整个匹配串
        [self.modelArray addObject:tagString];
    }
    [self setProduct];
    CGRect frame = CGRectMake(10, 0, 0, 21);
    [self setUIWithString:string andFrame:frame];
}
-(void)setProduct {
    for (NSString *tagString in self.modelArray) {
        NSRange range = [tagString rangeOfString:@"选项"];
        if (range.location != NSNotFound) {
            NSArray *array = [tagString componentsSeparatedByString:@"-"];
            NSString *str = [array objectAtIndex:1];
            NSString *tempStr1=[str stringByReplacingOccurrencesOfString:@"]]" withString:@""];
            NSArray *array2 = [tempStr1 componentsSeparatedByString:@"||"];
            self.productList = [NSMutableArray arrayWithArray:array2];
        }
    }
}
#pragma mark   ---------初始化控件----------------
-(UILabel *)setLabelWithFrame:(CGRect)frame andText:(NSString *)txt{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:17.0f];
    label.frame = frame;
    label.text = txt;
    return label;
}
-(UIButton *)setButtonWithFrame:(CGRect)frame andTitle:(NSString *)txt {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:txt forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:17];
    [btn setBackgroundImage:[[UIImage imageNamed:@"selected"]stretchableImageWithLeftCapWidth:5 topCapHeight:5]  forState:UIControlStateNormal];
    return btn;
}
-(UITextField *)setTextFieldWithFrame:(CGRect)frame andText:(NSString *)txt {
    UITextField *field = [[UITextField alloc]initWithFrame:frame];
    field.delegate = self;
    [field setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    field.font = [UIFont systemFontOfSize:17];
    field.placeholder = @"输入内容";
    field.backgroundColor = [UIColor clearColor];
    field.text = txt;
    return field;
}
#pragma mark   ---------生成界面UI----------------
-(void)setUIWithString:(NSString *)string andFrame:(CGRect)frame{
    int k_count = 0;
    NSMutableString *mutableString = [NSMutableString stringWithFormat:@"%@",string];
    CGFloat width = 0;
    for (int i=0; i<self.modelArray.count; i++) {
        NSString *tagString = [self.modelArray objectAtIndex:i];
        NSRange range = [mutableString rangeOfString:tagString];
        if (range.location != NSNotFound){
            NSString *str = [mutableString substringWithRange:NSMakeRange(0, range.location)];
            if (str.length>0) {
                width = 300-frame.size.width-frame.origin.x+10;
                NSInteger nn = width/17;
                if (nn>=str.length) {
                    nn=str.length;
                    NSString *txt = [str substringWithRange:NSMakeRange(0, nn)];
                    frame.origin.x +=frame.size.width;
                    frame.size.width = nn*17;
                    frame.origin.y = Space_Height+(21+Space_Height)*k_count;
                    UILabel *label = [self setLabelWithFrame:frame andText:txt];
                    [self.inputView addSubview:label];
                }else {
                    NSString *txt = [str substringWithRange:NSMakeRange(0, nn)];
                    frame.origin.x +=frame.size.width;
                    frame.size.width = nn*17;
                    frame.origin.y = Space_Height+(21+Space_Height)*k_count;
                    UILabel *label = [self setLabelWithFrame:frame andText:txt];
                    [self.inputView addSubview:label];
                    k_count++;
                }
                
                NSString *strrr = [str substringWithRange:NSMakeRange(nn, str.length-nn)];
                if (strrr.length>0) {
                    NSInteger count = strrr.length/17;//17个字符
                    NSInteger left = strrr.length%17;//余数；
                    for (int k=0; k<=count; k++) {
                        if(k==count){
                            NSString *txt = [strrr substringWithRange:NSMakeRange(13*k, left)];
                            frame.origin.x = 10;
                            frame.origin.y = Space_Height+(21+Space_Height)*k_count;
                            frame.size.width = 17*left;
                            UILabel *label = [self setLabelWithFrame:frame andText:txt];
                            [self.inputView addSubview:label];
                        }else {
                            NSString *txt = [strrr substringWithRange:NSMakeRange(17*k, 17)];
                            frame.origin.x = 10;
                            frame.origin.y = Space_Height+(21+Space_Height)*k_count;
                            frame.size.width = 300;
                            UILabel *label = [self setLabelWithFrame:frame andText:txt];
                            [self.inputView addSubview:label];
                            k_count += k;
                        }
                    }
                }
                [mutableString deleteCharactersInRange:NSMakeRange(0, range.location+2)];
                NSString *str1 = [mutableString substringWithRange:NSMakeRange(0, 2)];
                if ([str1 isEqualToString:@"时间"]) {//时间
                    NSString *title = @"";
                    NSRange range_sub = [tagString rangeOfString:@"="];
                    if (range_sub.location != NSNotFound) {
                        NSArray *array = [tagString componentsSeparatedByString:@"="];
                        title=[[array objectAtIndex:1] stringByReplacingOccurrencesOfString:@"]]" withString:@""];
                    }else {
                        title = @"输入时间";
                    }
                    width = frame.size.width+170-10+frame.origin.x;
                    if (width-300>0.0000001) {
                        frame.origin.x = 10;
                        frame.origin.y +=21+Space_Height;
                        k_count++;
                    }else {
                        frame.origin.x += frame.size.width;
                    }
                    frame.size.width = 170;
                    
                    UIButton *btn = [self setButtonWithFrame:frame andTitle:title];
                    btn.tag = 100+i;
                    [btn addTarget:self action:@selector(showTimeViewAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self.inputView addSubview:btn];
                    [self initPickerView];
                }else if ([str1 isEqualToString:@"选项"]){//选项
                    NSRange range_sub = [tagString rangeOfString:@"="];
                    if (range_sub.location != NSNotFound) {
                        NSArray *array = [tagString componentsSeparatedByString:@"="];
                        NSString *str = [array objectAtIndex:1];
                        NSArray *array2 = [str componentsSeparatedByString:@"-"];
                        NSString *title = [array2 objectAtIndex:0];
                        CGFloat title_width = 17*title.length;
                        if (title_width-170<0.00000001) {
                            title_width = 170;
                        }
                        width = frame.size.width+title_width-10+frame.origin.x;
                        if (width-300>0.0000001){
                            frame.origin.x = 10;
                            frame.origin.y +=21+Space_Height;
                            k_count++;
                        }else {
                            frame.origin.x += frame.size.width;
                        }
                        frame.size.width = title_width;
                        UIButton *btn = [self setButtonWithFrame:frame andTitle:title];
                        [btn addTarget:self action:@selector(showproductViewAction:) forControlEvents:UIControlEventTouchUpInside];
                        btn.tag = 100+i;
                        [self.inputView addSubview:btn];
                    }else {
                        width = frame.size.width+170-10+frame.origin.x;
                        if (width-300>0.0000001) {
                            frame.origin.x = 10;
                            frame.origin.y +=21+Space_Height;
                            k_count++;
                        }else {
                            frame.origin.x += frame.size.width;
                        }
                        frame.size.width = 170;
                        UIButton *btn = [self setButtonWithFrame:frame andTitle:@"输入选项"];
                        [btn addTarget:self action:@selector(showproductViewAction:) forControlEvents:UIControlEventTouchUpInside];
                        btn.tag = 100+i;
                        [self.inputView addSubview:btn];
                    }
                    [self initProductPickerView];
                }else {//填空
                    NSString *text = nil;
                    NSRange range_sub = [tagString rangeOfString:@"="];
                    if (range_sub.location != NSNotFound) {
                        NSArray *array = [tagString componentsSeparatedByString:@"="];
                        text = [[array objectAtIndex:1] stringByReplacingOccurrencesOfString:@"]]" withString:@""];
                    }else {
                        text = @"";
                    }
                    width = frame.size.width+170-10+frame.origin.x;
                    if (width-300>0.0000001) {
                        frame.origin.x = 10;
                        frame.origin.y +=21+Space_Height;
                        k_count++;
                    }else {
                        frame.origin.x += frame.size.width;
                    }
                    frame.size.width = 170;
                    UITextField *field = [self setTextFieldWithFrame:frame andText:text];
                    field.tag = 100+i;
                    [self.inputView addSubview:field];
                }
                [mutableString deleteCharactersInRange:NSMakeRange(0, range.length-2)];
                
            }else {
                [mutableString deleteCharactersInRange:NSMakeRange(0, range.location+2)];
                NSString *str1 = [mutableString substringWithRange:NSMakeRange(0, 2)];
                if ([str1 isEqualToString:@"时间"]) {//时间
                    NSString *title = @"";
                    NSRange range_sub = [tagString rangeOfString:@"="];
                    if (range_sub.location != NSNotFound) {
                        NSArray *array = [tagString componentsSeparatedByString:@"="];
                        title=[[array objectAtIndex:1] stringByReplacingOccurrencesOfString:@"]]" withString:@""];
                    }else {
                        title = @"输入时间";
                    }
                    width = frame.size.width+170-10+frame.origin.x;
                    if (width-300>0.0000001) {
                        frame.origin.x = 10;
                        frame.origin.y +=21+Space_Height;
                        k_count++;
                    }else {
                        frame.origin.x += frame.size.width;
                    }
                    frame.size.width = 170;
                    if (frame.origin.y == 0) {
                        frame.origin.y = 5;
                    }
                    UIButton *btn = [self setButtonWithFrame:frame andTitle:title];
                    btn.tag = 100+i;
                    [btn addTarget:self action:@selector(showTimeViewAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self.inputView addSubview:btn];
                    [self initPickerView];
                }else if ([str1 isEqualToString:@"选项"]){//选项
                    NSRange range_sub = [tagString rangeOfString:@"="];
                    if (range_sub.location != NSNotFound) {
                        NSArray *array = [tagString componentsSeparatedByString:@"="];
                        NSString *str = [array objectAtIndex:1];
                        NSArray *array2 = [str componentsSeparatedByString:@"-"];
                        NSString *title = [array2 objectAtIndex:0];
                        CGFloat title_width = 17*title.length;
                        if (title_width-170<0.00000001) {
                            title_width = 170;
                        }
                        width = frame.size.width+title_width-10+frame.origin.x;
                        if (width-300>0.0000001){
                            frame.origin.x = 10;
                            frame.origin.y +=21+Space_Height;
                            k_count++;
                        }else {
                            frame.origin.x += frame.size.width;
                        }
                        if (frame.origin.y == 0) {
                            frame.origin.y = Space_Height;
                        }
                        frame.size.width = title_width;
                        UIButton *btn = [self setButtonWithFrame:frame andTitle:title];
                        [btn addTarget:self action:@selector(showproductViewAction:) forControlEvents:UIControlEventTouchUpInside];
                        btn.tag = 100+i;
                        [self.inputView addSubview:btn];
                    }else {
                        width = frame.size.width+170-10+frame.origin.x;
                        if (width-300>0.0000001) {
                            frame.origin.x = 10;
                            frame.origin.y +=21+Space_Height;
                            k_count++;
                        }else {
                            frame.origin.x += frame.size.width;
                        }
                        frame.size.width = 170;
                        if (frame.origin.y == 0) {
                            frame.origin.y = Space_Height;
                        }
                        UIButton *btn = [self setButtonWithFrame:frame andTitle:@"输入选项"];
                        [btn addTarget:self action:@selector(showproductViewAction:) forControlEvents:UIControlEventTouchUpInside];
                        btn.tag = 100+i;
                        [self.inputView addSubview:btn];
                    }
                    [self initProductPickerView];
                }else {//填空
                    NSString *text = nil;
                    NSRange range_sub = [tagString rangeOfString:@"="];
                    if (range_sub.location != NSNotFound) {
                        NSArray *array = [tagString componentsSeparatedByString:@"="];
                        text = [[array objectAtIndex:1] stringByReplacingOccurrencesOfString:@"]]" withString:@""];
                    }else {
                        text = @"";
                    }
                    width = frame.size.width+170-10+frame.origin.x;
                    if (width-300>0.0000001) {
                        frame.origin.x = 10;
                        frame.origin.y +=21+Space_Height;
                        k_count++;
                    }else {
                        frame.origin.x += frame.size.width;
                    }
                    if (frame.origin.y == 0) {
                        frame.origin.y = Space_Height;
                    }
                    frame.size.width = 170;
                    UITextField *field = [self setTextFieldWithFrame:frame andText:text];
                    field.tag = 100+i;
                    [self.inputView addSubview:field];
                }
                [mutableString deleteCharactersInRange:NSMakeRange(0, range.length-2)];
            }
        }
    }
    if (mutableString.length>0) {
        CGFloat width = 17*mutableString.length+frame.origin.x+frame.size.width-10;
        if (width-300>0.000001) {
            frame.origin.x = 10;
            frame.origin.y +=21;
        }else {
            frame.origin.x += frame.size.width;
        }
        frame.size.width = 17*mutableString.length;
        UILabel *label = [self setLabelWithFrame:frame andText:mutableString];
        [self.inputView addSubview:label];
    }
    if (frame.origin.y+21>131) {
        self.inputView.contentSize = CGSizeMake(320,frame.origin.y+21+Space_Height);
    }else {
        self.inputView.contentSize = CGSizeMake(320,131);
    }
}

-(void)initProductPickerView {
    self.productView.frame = CGRectMake(0, 420, 320, 195);
    [self.productPicker selectRow:0 inComponent:0 animated:YES];
    [self.productPicker reloadAllComponents];
    [self.view addSubview:self.productView];
}
-(void)initPickerView {
    self.timeView.frame = CGRectMake(0, 420, 320, 195);
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.pickerView.date = [NSDate date];
    if (self.types == CMRTypeRemind) {
        self.pickerView.minimumDate = [NSDate date];
    }
    [self.view addSubview:self.timeView];
}

-(void)setAMessage:(CMRMessageObject *)aMessage {
    _aMessage = aMessage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
//重新排版
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSArray *subViews = [self.inputView subviews];
    for (UIView *vv in subViews) {
        [vv removeFromSuperview];
    }
    if (self.types == CMRTypeRemind) {
        self.titleLab.text = @"定时提醒编辑";
    }else {
        self.titleLab.text = @"记录编辑";
    }
    [self.inputView setContentOffset:CGPointMake(0, 0)];
    [self dealWithString:self.modelString];
}
-(NSMutableArray *)productList {
    if (!_productList) {
        _productList = [[NSMutableArray alloc]init];
    }
    return _productList;
}
-(NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc]init];
    }
    return _modelArray;
}
-(NSMutableArray *)rangeArray {
    if (!_rangeArray) {
        _rangeArray = [[NSMutableArray alloc]init];
    }
    return _rangeArray;
}
#pragma mark   ---------button点击事件----------------
//返回
-(IBAction)backAction:(id)sender {
    self.isSuccess = NO;
    NSArray *subViews = [self.inputView subviews];
    for (UIView *vv in subViews) {
         if([vv isKindOfClass:[UITextField class]]){
            UITextField *field = (UITextField *)vv;
            [field resignFirstResponder];
        }
    }
    [self hiddenView:self.productView];
    [self hiddenView:self.timeView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissRecordPopView: andMessage:)]) {
        [self.delegate dismissRecordPopView:self andMessage:nil];
    }
}
//确定
-(IBAction)sureAction:(id)sender {
    NSString *str = @"";
    [self getDataWithStr:self.modelString];
    NSInteger count = self.rangeArray.count;
    int i=0;
    while (i<count) {
        UIView *vv = [self.inputView viewWithTag:100+i];
        if ([vv isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)vv;
            if ([btn.titleLabel.text isEqualToString:@"输入时间"]) {
                str = @"请输入时间!";
                break;
            }else if ([btn.titleLabel.text isEqualToString:@"输入选项"]) {
                str = @"请输入选项!";
                break;
            }
        }else if ([vv isKindOfClass:[UITextField class]]){
            UITextField *field = (UITextField *)vv;
            if (field.text.length==0) {
                str = @"请输入内容!";
                break;
            }else {
                [field resignFirstResponder];
                [self setTextReturn:field];
            }
        }
        i++;
    }

    if (str.length>0) {
        [Utils errorAlert:str];
    }else{
        if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
            [Utils errorAlert:@"暂无网络!"];
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if (self.isEditing == YES) {
                EditInterface *log = [[EditInterface alloc]init];
                self.editInterface = log;
                self.editInterface.delegate = self;
                [self.editInterface getEditInterfaceDelegateWithMessageId:[NSString stringWithFormat:@"%d",[self.aMessage.messageId intValue]] andContent:self.modelString andType:0];
                log = nil;
            }else {
                SendMessageInterface *log = [[SendMessageInterface alloc]init];
                self.sendinterface = log;
                self.sendinterface.delegate = self;
                
                if (self.types == CMRTypeRecord) {
                    [self.sendinterface getSendMessageInterfaceDelegateWithTo_userId:self.to_user_id andContent:self.modelString andType:[NSString stringWithFormat:@"%d",2]];
                }else if (self.types == CMRTypeRemind) {
                    [self.sendinterface getSendMessageInterfaceDelegateWithTo_userId:self.to_user_id andContent:self.modelString andType:[NSString stringWithFormat:@"%d",3]];
                }
                
                log = nil;
            }
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showView:(UIView *)view {
    [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
        CGRect frame = CGRectMake(0, view.frame.origin.y-view.frame.size.height, view.frame.size.width, view.frame.size.height);
        view.frame = frame;
    }
                     completion:nil];
}
-(void)hiddenView:(UIView *)view {
    [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (view.frame.origin.y==420) {
            
        }else {
            CGRect frame = CGRectMake(0, view.frame.origin.y+view.frame.size.height, view.frame.size.width, view.frame.size.height);
            view.frame = frame;
        }
    }
                     completion:nil];
}
static NSInteger btn_tag = 0;
-(void)getDataWithStr:(NSString *)string {
    self.rangeArray = nil;
    NSString *regTags = @"\\[\\[.*?]]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:string
                                      options:0
                                        range:NSMakeRange(0, [string length])];
    self.rangeArray = [NSMutableArray arrayWithArray:matches];
}
#pragma mark   ---------选择时间----------------
-(void)showTimeViewAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.enabled = NO;
    
    NSArray *subViews = [self.inputView subviews];
    for (UIView *vv in subViews) {
        if ([vv isKindOfClass:[UIButton class]]) {
            UIButton *btn_other = (UIButton *)vv;
            if (btn.tag != btn_other.tag) {
                btn_other.enabled = YES;
            }
        }else if([vv isKindOfClass:[UITextField class]]){
            UITextField *field = (UITextField *)vv;
            [field resignFirstResponder];
            if (field.text.length>0) {
                [self setTextReturn:field];
            }
        }
    }
    btn_tag = btn.tag;
    [self hiddenView:self.productView];
    [self showView:self.timeView];
}
-(IBAction)cancelAction:(id)sender {
    UIButton *btn1 = (UIButton *)[self.inputView viewWithTag:btn_tag];
    btn1.enabled = YES;
    [self hiddenView:self.timeView];
}
-(IBAction)saveAction:(id)sender {
    UIButton *btn1 = (UIButton *)[self.inputView viewWithTag:btn_tag];
    btn1.enabled = YES;
    NSString *text = [self.dateFormatter stringFromDate:self.pickerView.date];
    [self hiddenView:self.timeView];
    
    NSArray *subViews = [self.inputView subviews];
    for (UIView *vv in subViews) {
        [vv removeFromSuperview];
    }
    
    [self getDataWithStr:self.modelString];
    NSTextCheckingResult *match = [self.rangeArray objectAtIndex:(btn_tag-100)];
    NSRange matchRange = [match rangeAtIndex:0];
    
    NSMutableString *mutableString = [NSMutableString stringWithFormat:@"%@",self.modelString];
    NSString *str = [mutableString substringWithRange:NSMakeRange(matchRange.location+4, 1)];
    if ([str isEqualToString:@"="]) {
        NSString *str2 = [mutableString substringWithRange:NSMakeRange(matchRange.location+4, mutableString.length-matchRange.location-4)];
        NSRange range2 = [str2 rangeOfString:@"]]"];
        if (range2.location != NSNotFound) {
            [mutableString deleteCharactersInRange:NSMakeRange(matchRange.location+4, range2.location)];
        }
    }
    [mutableString insertString:[NSString stringWithFormat:@"=%@",text] atIndex:matchRange.location+4];
    self.modelString = mutableString;
    [self dealWithString:mutableString];
}

#pragma mark   ---------选择项目----------------

-(void)showproductViewAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.enabled = NO;
    NSArray *subViews = [self.inputView subviews];
    for (UIView *vv in subViews) {
        if ([vv isKindOfClass:[UIButton class]]) {
            UIButton *btn_other = (UIButton *)vv;
            if (btn.tag != btn_other.tag) {
                btn_other.enabled = YES;
            }
        }else if([vv isKindOfClass:[UITextField class]]){
            UITextField *field = (UITextField *)vv;
            [field resignFirstResponder];
            if (field.text.length>0) {
                [self setTextReturn:field];
            }
        }
    }
    btn_tag = btn.tag;
    [self hiddenView:self.timeView];
    [self showView:self.productView];
}
-(IBAction)cancelproductAction:(id)sender {
    UIButton *btn2 = (UIButton *)[self.inputView viewWithTag:btn_tag];
    btn2.enabled = YES;
    [self hiddenView:self.productView];
}
-(IBAction)saveproductAction:(id)sender {
    UIButton *btn2 = (UIButton *)[self.inputView viewWithTag:btn_tag];
    btn2.enabled = YES;
    NSString *title = [self.productList objectAtIndex:[self.productPicker selectedRowInComponent:0]];
    [self hiddenView:self.productView];
    
    NSArray *subViews = [self.inputView subviews];
    for (UIView *vv in subViews) {
        [vv removeFromSuperview];
    }
    [self getDataWithStr:self.modelString];
    NSTextCheckingResult *match = [self.rangeArray objectAtIndex:(btn_tag-100)];
    NSRange matchRange = [match rangeAtIndex:0];
    
    NSMutableString *mutableString = [NSMutableString stringWithFormat:@"%@",self.modelString];

    NSString *str = [mutableString substringWithRange:NSMakeRange(matchRange.location+4, 1)];
    if ([str isEqualToString:@"="]){
        NSString *str2 = [mutableString substringWithRange:NSMakeRange(matchRange.location+4, mutableString.length-matchRange.location-4)];
        NSRange range_sub2 = [str2 rangeOfString:@"-"];
        if (range_sub2.location != NSNotFound) {
            [mutableString deleteCharactersInRange:NSMakeRange(matchRange.location+4, range_sub2.location)];
        }
    }
    [mutableString insertString:[NSString stringWithFormat:@"=%@",title] atIndex:matchRange.location+4];
    self.modelString = mutableString;
    [self dealWithString:mutableString];
}
#pragma mark   ---------输入内容----------------
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSArray *subViews = [self.inputView subviews];
    for (UIView *vv in subViews) {
        if ([vv isKindOfClass:[UIButton class]]) {
            UIButton *btn_other = (UIButton *)vv;
                btn_other.enabled = YES;
        }else if([vv isKindOfClass:[UITextField class]]){
            UITextField *field = (UITextField *)vv;
            if(field.tag != textField.tag){
                [field resignFirstResponder];
                if (field.text.length>0) {
                    [self setTextReturn:field];
                }
            }
        }
    }
    [self hiddenView:self.timeView];
    [self hiddenView:self.productView];
}

#pragma mark   ---------pickerDelegate----------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerVieww numberOfRowsInComponent:(NSInteger)component{
    return self.productList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerVieww titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *title = [self.productList objectAtIndex:row];
    return title;
}

- (void)pickerView:(UIPickerView *)pickerVieww didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
}

#pragma mark   ---------SendMessageInterfaceDelegate----------------
-(void)getSendMessageInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.isSuccess = YES;
            NSDictionary *dic = [result objectForKey:@"message"];
            CMRMessageObject *msg = [CMRMessageObject messageFromDictionary:dic];
            if (self.delegate && [self.delegate respondsToSelector:@selector(dismissRecordPopView: andMessage:)]) {
                [self.delegate dismissRecordPopView:self andMessage:msg];
            }
        });
    });
}
-(void)getSendMessageInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils errorAlert:errorMsg];
}

#pragma mark   ---------EditInterfaceDelegate----------------
-(void)getEditInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.isSuccess = YES;
            NSDictionary *dic = [result objectForKey:@"message"];
            CMRMessageObject *msg = [CMRMessageObject messageFromDictionary:dic];
            if (self.delegate && [self.delegate respondsToSelector:@selector(dismissRecordPopView: andMessage:)]) {
                [self.delegate dismissRecordPopView:self andMessage:msg];
            }
        });
    });
}
-(void)getEditInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils errorAlert:errorMsg];
}

#pragma mark   ---------UITextFieldDelegate----------------
-(void)setTextReturn:(UITextField *)textField {
    [self getDataWithStr:self.modelString];
    NSTextCheckingResult *match = [self.rangeArray objectAtIndex:(textField.tag-100)];
    NSRange matchRange = [match rangeAtIndex:0];
    
    NSMutableString *mutableString = [NSMutableString stringWithFormat:@"%@",self.modelString];
    NSString *str = [mutableString substringWithRange:NSMakeRange(matchRange.location+4, 1)];
    if ([str isEqualToString:@"="]) {
        NSString *str2 = [mutableString substringWithRange:NSMakeRange(matchRange.location+4, mutableString.length-matchRange.location-4)];
        NSRange range2 = [str2 rangeOfString:@"]]"];
        if (range2.location != NSNotFound) {
            [mutableString deleteCharactersInRange:NSMakeRange(matchRange.location+4, range2.location)];
        }
    }
    [mutableString insertString:[NSString stringWithFormat:@"=%@",textField.text] atIndex:matchRange.location+4];
    self.modelString = mutableString;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //点击键盘return键搜索
    [textField resignFirstResponder];
    [self setTextReturn:textField];
    return YES;
}
@end
