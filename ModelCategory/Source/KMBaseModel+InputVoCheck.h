//
//  KMBaseModel+InputVoCheck.h
//  
//
//  Created by Shawn on 2019/5/23.
//  Copyright © 2019 Shawn. All rights reserved.
//

#import <KMBaseModel.h>

@protocol KMBaseModelInputVoRequired <NSObject>

@end

@interface KMBaseModel (InputVoCheck)

- (BOOL)validateWithError:(NSError **)error;

@end

@interface NSObject (InputVoCheck)<KMBaseModelInputVoRequired>

@end
