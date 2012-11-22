//
//  EzSampleMenuViewController.h
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/22.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EzSampleMenuViewControllerDelegate.h"

@interface EzSampleMenuViewController : UIViewController

@property (nonatomic,readonly,strong) IBOutletCollection(UIButton) NSArray* menuButtons;
@property (nonatomic,readwrite,strong) NSNumber* menuButtonsEnabled;

@property (nonatomic,readwrite,weak) id<EzSampleMenuViewControllerDelegate> delegate;

- (IBAction)pushTestButtonForStructWithPropertyAtomicityBySynthesize;
- (IBAction)pushTestButtonForStructWithPropertyAtomicityByCustomImplementWithNoSynchronized:(id)sender;
- (IBAction)pushTestButtonForStructWithSynchronizedSelf;
- (IBAction)pushTestButtonForStructWithAtomicityInGetterAndSynchronizedSelfInSetter;
- (IBAction)pushTestButtonForLongLongWithPropertyAtomicityBySynthesize;
- (IBAction)pushTestButtonForLongLongWithPropertyAtomicityBySynthesizeButOverrideGetterWithoutAtomicity;
- (IBAction)pushTestButtonForLongWithPropertyAtomicityBySynthesize;
- (IBAction)pushTestButtonForClassInstanceWithPropertyAtomicityBySynthesize;

@end
