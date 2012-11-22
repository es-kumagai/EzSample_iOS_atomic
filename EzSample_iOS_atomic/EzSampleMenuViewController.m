//
//  EzSampleMenuViewController.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/22.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleMenuViewController.h"

#import "EzSampleObject.h"
#import "EzSampleObjectCustomProperties.h"
#import "EzSampleObjectCustomPropertiesWithSynchronized.h"
#import "EzSampleObjectCustomPropertiesWithAtomicAndSynchronized.h"
#import "EzSampleLongLong.h"
#import "EzSampleLongLongOverrideAtomicGetter.h"
#import "EzSampleLong.h"
#import "EzSampleClass.h"

@interface EzSampleMenuViewController ()

- (void)EzPushTestButton:(UIButton*)button withTestInstance:(id<EzSampleObjectProtocol>)testInstance;

@end

@implementation EzSampleMenuViewController

- (void)setMenuButtonsEnabled:(NSNumber*)menuButtonsEnabled
{
	BOOL enabled = menuButtonsEnabled.boolValue;
	
	for (UIButton* button in self.menuButtons)
	{
		button.enabled = enabled;
	}
}

- (NSNumber*)menuButtonsEnabled
{
	return [[NSNumber alloc] initWithBool:((UIButton*)self.menuButtons[0]).enabled];
}

- (void)EzPushTestButton:(UIButton *)button withTestInstance:(id<EzSampleObjectProtocol>)testInstance
{
	EzPostClear;
	EzPostLog([button titleForState:UIControlStateNormal]);
	
	[self.delegate EzSampleMenuViewController:self testButtonForTestInstancePushed:testInstance];
}

- (IBAction)pushTestButtonForClassInstanceWithPropertyAtomicityBySynthesize:(UIButton*)sender
{
	[self EzPushTestButton:sender withTestInstance:[[EzSampleClass alloc] init]];
}

- (IBAction)pushTestButtonForLongWithPropertyAtomicityBySynthesize:(UIButton*)sender
{
	[self EzPushTestButton:sender withTestInstance:[[EzSampleLong alloc] init]];
}

- (IBAction)pushTestButtonForLongLongWithPropertyAtomicityBySynthesizeButOverrideGetterWithoutAtomicity:(UIButton*)sender
{
	[self EzPushTestButton:sender withTestInstance:[[EzSampleLongLongOverrideAtomicGetter alloc] init]];
}

- (IBAction)pushTestButtonForLongLongWithPropertyAtomicityBySynthesize:(UIButton*)sender
{
	[self EzPushTestButton:sender withTestInstance:[[EzSampleLongLong alloc] init]];
}

- (IBAction)pushTestButtonForStructWithPropertyAtomicityBySynthesize:(UIButton*)sender
{
	[self EzPushTestButton:sender withTestInstance:[[EzSampleObject alloc] init]];
}

- (IBAction)pushTestButtonForStructWithPropertyAtomicityByCustomImplementWithNoSynchronized:(UIButton*)sender
{
	[self EzPushTestButton:sender withTestInstance:[[EzSampleObjectCustomProperties alloc] init]];
}

- (IBAction)pushTestButtonForStructWithSynchronizedSelf:(UIButton*)sender
{
	[self EzPushTestButton:sender withTestInstance:[[EzSampleObjectCustomPropertiesWithSynchronized alloc] init]];
}

- (IBAction)pushTestButtonForStructWithAtomicityInGetterAndSynchronizedSelfInSetter:(UIButton*)sender
{
	[self EzPushTestButton:sender withTestInstance:[[EzSampleObjectCustomPropertiesWithAtomicAndSynchronized alloc] init]];
}

@end
