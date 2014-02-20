//
//  NameViewController.m
//  CMR
//
//  Created by comdosoft on 14-2-18.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "NameViewController.h"
#import "ContactObject.h"
@interface NameViewController ()

@end

@implementation NameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)setUI {
    UIButton *l_button = [[UIButton alloc] init];
//  [l_button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//	[l_button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
	[l_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[l_button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	l_button.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:14.0];
	l_button.titleLabel.textAlignment = NSTextAlignmentCenter;
	l_button.frame = CGRectMake(0, 0, 50, 30);
	[l_button setTitle:@"完成" forState:UIControlStateNormal];
    
	[l_button addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *l_barButtonItem_edit = [[UIBarButtonItem alloc] initWithCustomView:l_button];
    self.sureBtn = l_barButtonItem_edit;
    
    self.navigationItem.rightBarButtonItem = self.sureBtn;
}
- (void)sureBtnAction:(id)sender  {
    [self.nameTxt resignFirstResponder];
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NameInterface *log = [[NameInterface alloc]init];
        self.nameInter = log;
        self.nameInter.delegate = self;
        [self.nameInter getNameInterfaceDelegateWithID:[NSString stringWithFormat:@"%@",self.person.localID] andName:self.nameTxt.text andType:self.d_label.text];
        log = nil;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.nameTxt setText:self.txyString];
    
    NSString *destription_str = [self.title substringWithRange:NSMakeRange(0, self.title.length-2)];
    self.d_label.text = destription_str;
    
    if (platform>=7.0) {
        AppDelegate *appDel = [AppDelegate shareIntance];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.view.frame = CGRectMake(0, 0, 320, appDel.window.frame.size.height-64);
    }
    [self setUI];
    [self initBackBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.nameTxt];
}
//返回
-(void)initBackBtn {
    UIButton *l_button_left = [Utils initSimpleButton:CGRectMake(0, 0, 30, 30)
                                                title:@""
                                          normalImage:@"backBtn.png"
                                          highlighted:@"backBtn.png"];
	[l_button_left addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *l_barButtonItem_left = [[UIBarButtonItem alloc] initWithCustomView:l_button_left];
	self.navigationItem.leftBarButtonItem = l_barButtonItem_left;
}
-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.nameTxt becomeFirstResponder];
    [self.sureBtn setEnabled:NO];
}
-(void)textFieldChanged:(NSNotification *)sender {
    [CMRDataService shared].isEditing = YES;
    [self.sureBtn setEnabled:YES];
}
-(void)setPerson:(ContactObject *)person {
    _person = person;
}
-(void)setDetail_index:(NSIndexPath *)detail_index {
    _detail_index = detail_index;
}
-(void)setTxyString:(NSString *)txyString {
    _txyString = txyString;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getNameInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *aDic = [result objectForKey:@"person"];
            ContactObject *contact = [ContactObject userFromDictionary:aDic];
            [[CMRDataService shared].temp_contact replaceObjectAtIndex:self.detail_index.row withObject:contact];
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}
-(void)getNameInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utils errorAlert:errorMsg];
}
@end
