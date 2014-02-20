//
//  CMRMessageObject.m
//  CMR
//
//  Created by comdosoft on 14-1-9.
//  Copyright (c) 2014年 CMR. All rights reserved.
//

#import "CMRMessageObject.h"
#import "CMRDataBase.h"

@implementation CMRMessageObject

+(CMRMessageObject*)messageFromDictionary:(NSDictionary*)aDic
{
    CMRMessageObject *msg=[[CMRMessageObject alloc]init];
    [msg setMessageId:[NSNumber numberWithInt:[[aDic objectForKey:kMESSAGE_ID]intValue]]];
    [msg setMessageFrom:[aDic objectForKey:kMESSAGE_FROM]];
    [msg setMessageTo:[aDic objectForKey:kMESSAGE_TO]];
    [msg setMessageContent:[aDic objectForKey:kMESSAGE_CONTENT]];
    [msg setMessageDate:[aDic objectForKey:kMESSAGE_DATE]];
    [msg setMessageType:[NSNumber numberWithInt:[[aDic objectForKey:kMESSAGE_TYPE]intValue]]];
    [msg setMediaType:[NSNumber numberWithInt:[[aDic objectForKey:kMEDIA_TYPE]intValue]]];
    [msg setPath:[aDic objectForKey:KMESSAGE_PATH]];
    if (![[aDic objectForKey:kMESSAGE_STATUS]isKindOfClass:[NSNull class]]) {
        [msg setMessageStatus:[aDic objectForKey:kMESSAGE_STATUS]];
    }
    
    return  msg;
}

@end
