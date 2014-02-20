//
//  CMRRecentListCell.m
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRRecentListCell.h"
//头像大小
#define HEAD_SIZE 0.0f
//间距
#define INSETS 8.0f

#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width

@implementation CMRRecentListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        _userHead =[[UIImageView alloc]initWithFrame:CGRectZero];
        _userNickname=[[UILabel alloc]initWithFrame:CGRectZero];
        _messageConent=[[UILabel alloc]initWithFrame:CGRectZero];
        _timeLable=[[UILabel alloc]initWithFrame:CGRectZero];
        _cellBkg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MessageListCellBkg"]];
        _bageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"contact_message"]];
        _bageNumber=[[UILabel alloc]initWithFrame:CGRectZero];
//        [_bageNumber setText:@"1"];
//        [_userHead.layer setCornerRadius:8.0f];
//        [_userHead.layer setMasksToBounds:YES];
        
        [_userNickname setFont:[UIFont boldSystemFontOfSize:15]];
        [_userNickname setBackgroundColor:[UIColor clearColor]];
        [_messageConent setFont:[UIFont systemFontOfSize:13]];
        [_messageConent setTextColor:[UIColor lightGrayColor]];
        [_messageConent setBackgroundColor:[UIColor clearColor]];
        
        [_timeLable setTextColor:[UIColor lightGrayColor]];
        [_timeLable setFont:[UIFont systemFontOfSize:12]];
        [_timeLable setBackgroundColor:[UIColor clearColor]];
        
        [_bageNumber setBackgroundColor:[UIColor clearColor]];
        [_bageNumber setTextAlignment:NSTextAlignmentCenter];
        [_bageNumber setTextColor:[UIColor whiteColor]];
        [_bageNumber setFont:[UIFont boldSystemFontOfSize:12]];
        
        // [self.contentView addSubview:_cellBkg];
        [self setBackgroundView:_cellBkg];
        [self.contentView addSubview:_userHead];
        [self.contentView addSubview:_userNickname];
        [self.contentView addSubview:_messageConent];
        [self.contentView addSubview:_timeLable];
        [self.contentView addSubview:_bageView];
        [_bageView addSubview:_bageNumber];
        //[self setAccessoryView:_timeLable];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews {
    [super layoutSubviews];
    
//    [_userHead setFrame:CGRectMake(INSETS, (CELL_HEIGHT-HEAD_SIZE)/2,HEAD_SIZE , HEAD_SIZE)];
//    [_userNickname setFrame:CGRectMake(2*INSETS+HEAD_SIZE, (CELL_HEIGHT-HEAD_SIZE)/2, (CELL_WIDTH-HEAD_SIZE-INSETS*3), (CELL_HEIGHT-3*INSETS)/2)];
    [_userNickname setFrame:CGRectMake(2*INSETS, INSETS, (CELL_WIDTH-INSETS*2), 20)];
//    [_messageConent setFrame:CGRectMake(2*INSETS+HEAD_SIZE, (CELL_HEIGHT-HEAD_SIZE)/2+_userNickname.frame.size.height+INSETS, (CELL_WIDTH-HEAD_SIZE-INSETS*3), (CELL_HEIGHT-3*INSETS)/2)];
    [_messageConent setFrame:CGRectMake(2*INSETS, INSETS+_userNickname.frame.size.height, (CELL_WIDTH-INSETS*2), 20)];
//    [_timeLable setFrame:CGRectMake(CELL_WIDTH-110, (CELL_HEIGHT-HEAD_SIZE)/2, 180, (CELL_HEIGHT-3*INSETS)/2)];
    [_timeLable setFrame:CGRectMake(CELL_WIDTH-110, INSETS, 180, 15)];
    
    [_bageNumber setFrame:CGRectMake(0,0, 25, 25)];
    [_bageView setFrame:CGRectMake(5, 5, 10, 10)];
    _cellBkg.frame=self.contentView.frame;
}
-(NSString *)getContentfronMessage:(NSString *)string {
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
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
        [tempArray addObject:tagString];
    }
    NSMutableString *contentString = [NSMutableString stringWithFormat:@"%@",string];
    if (tempArray.count>0) {
        for (int i=0; i<tempArray.count; i++) {
            NSString *tagString = [tempArray objectAtIndex:i];
            NSMutableString *mutableString = [NSMutableString stringWithFormat:@"%@",tagString];
            NSRange range0 = [contentString rangeOfString:tagString];
            if (range0.location != NSNotFound) {
                NSRange range = [mutableString rangeOfString:@"时间"];
                if (range.location != NSNotFound) {
                    NSRange range1 = [mutableString rangeOfString:@"="];
                    if (range1.location != NSNotFound) {
                        NSString *tempStr1=[mutableString stringByReplacingOccurrencesOfString:@"[[" withString:@""];
                        NSString *tempStr2=[tempStr1 stringByReplacingOccurrencesOfString:@"]]" withString:@""];
                        NSArray *array = [tempStr2 componentsSeparatedByString:@"="];
                        NSString *d_str = [array objectAtIndex:1];
                        [contentString replaceCharactersInRange:range0 withString:d_str];
                    }
                }else {
                    NSRange range2 = [mutableString rangeOfString:@"选项"];
                    if (range2.location != NSNotFound) {
                        NSRange range3 = [mutableString rangeOfString:@"="];
                        if (range3.location != NSNotFound){
                            NSString *tempStr1=[mutableString stringByReplacingOccurrencesOfString:@"[[" withString:@""];
                            NSString *tempStr2=[tempStr1 stringByReplacingOccurrencesOfString:@"]]" withString:@""];
                            NSArray *array = [tempStr2 componentsSeparatedByString:@"="];
                            NSString *d_str = [array objectAtIndex:1];
                            NSArray *array2 = [d_str componentsSeparatedByString:@"-"];
                            NSString *dd_str = [array2 objectAtIndex:0];
                            [contentString replaceCharactersInRange:range0 withString:dd_str];
                        }
                    }else {
                        NSRange range4 = [mutableString rangeOfString:@"填空"];
                        if (range4.location != NSNotFound) {
                            NSRange range5 = [mutableString rangeOfString:@"="];
                            if (range5.location != NSNotFound) {
                                NSString *tempStr1=[mutableString stringByReplacingOccurrencesOfString:@"[[" withString:@""];
                                NSString *tempStr2=[tempStr1 stringByReplacingOccurrencesOfString:@"]]" withString:@""];
                                NSArray *array = [tempStr2 componentsSeparatedByString:@"="];
                                NSString *d_str = [array objectAtIndex:1];
                                [contentString replaceCharactersInRange:range0 withString:d_str];
                            }
                        }
                    }
                }
            }
        }
    }
    return contentString;
}

-(void)setUnionObject:(CMRMessageUserUnionObject*)aUnionObj
{
    [_userNickname setText:aUnionObj.user.name];
    NSString *origin = aUnionObj.message.messageContent;
    if (![origin isKindOfClass:[NSNull class]] && origin.length>0) {
        NSRange range = [origin rangeOfString:@"[["];
        if (range.location != NSNotFound) {
            NSRange range2 = [origin rangeOfString:@"]]"];
            if (range2.location != NSNotFound) {
                NSString *content = [self getContentfronMessage:aUnionObj.message.messageContent];
                [_messageConent setText:content];
            }else {
                [_messageConent setText:origin];
            }
        }else {
            [_messageConent setText:origin];
        }
    }else {
        [_messageConent setText:@""];
    }
    
    [_timeLable setText:aUnionObj.message.messageDate];
//    [self setHeadImage:aUnionObj.user.userHead];
    
    if ([aUnionObj.message.messageStatus intValue]==1) {
        [_bageView setHidden:NO];
    }else {
        [_bageView setHidden:YES];
    }
}
//-(void)setHeadImage:(NSString*)imageURL
//{
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://116.255.202.113:3002%@",imageURL]];
//    [_userHead setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserHeaderImageBox"]];
//}

@end
