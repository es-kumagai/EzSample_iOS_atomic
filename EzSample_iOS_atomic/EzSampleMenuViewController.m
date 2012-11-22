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

- (IBAction)pushTestButtonForClassInstanceWithPropertyAtomicityBySynthesize
{
	id<EzSampleObjectProtocol> instance = [[EzSampleClass alloc] init];
	
	[self.delegate EzSampleMenuViewController:self testButtonForTestInstancePushed:instance];
}

- (IBAction)pushTestButtonForLongWithPropertyAtomicityBySynthesize
{
	id<EzSampleObjectProtocol> instance = [[EzSampleLong alloc] init];
	
	[self.delegate EzSampleMenuViewController:self testButtonForTestInstancePushed:instance];
}

- (IBAction)pushTestButtonForLongLongWithPropertyAtomicityBySynthesizeButOverrideGetterWithoutAtomicity
{
	id<EzSampleObjectProtocol> instance = [[EzSampleLongLongOverrideAtomicGetter alloc] init];
	
	[self.delegate EzSampleMenuViewController:self testButtonForTestInstancePushed:instance];
}

- (IBAction)pushTestButtonForLongLongWithPropertyAtomicityBySynthesize
{
	id<EzSampleObjectProtocol> instance = [[EzSampleLongLong alloc] init];
	
	[self.delegate EzSampleMenuViewController:self testButtonForTestInstancePushed:instance];
}

- (IBAction)pushTestButtonForStructWithPropertyAtomicityBySynthesize
{
	id<EzSampleObjectProtocol> instance = [[EzSampleObject alloc] init];
	
	[self.delegate EzSampleMenuViewController:self testButtonForTestInstancePushed:instance];
}

- (IBAction)pushTestButtonForStructWithPropertyAtomicityByCustomImplementWithNoSynchronized:(id)sender
{
	id<EzSampleObjectProtocol> instance = [[EzSampleObjectCustomProperties alloc] init];
	
	[self.delegate EzSampleMenuViewController:self testButtonForTestInstancePushed:instance];
}

- (IBAction)pushTestButtonForStructWithSynchronizedSelf
{
	id<EzSampleObjectProtocol> instance = [[EzSampleObjectCustomPropertiesWithSynchronized alloc] init];
	
	[self.delegate EzSampleMenuViewController:self testButtonForTestInstancePushed:instance];
}

- (IBAction)pushTestButtonForStructWithAtomicityInGetterAndSynchronizedSelfInSetter
{
	id<EzSampleObjectProtocol> instance = [[EzSampleObjectCustomPropertiesWithAtomicAndSynchronized alloc] init];
	
	[self.delegate EzSampleMenuViewController:self testButtonForTestInstancePushed:instance];
}

@end
