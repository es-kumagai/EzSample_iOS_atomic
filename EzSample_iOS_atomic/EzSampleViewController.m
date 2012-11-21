//
//  EzSampleViewController.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleViewController.h"
#import "EzSampleObject.h"

@interface EzSampleViewController ()

- (void)EzCheck:(EzSampleObject*)object;
- (void)EzCheckDone:(EzSampleObject*)object;

@end

@implementation EzSampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
	EzSampleObject* object = [[EzSampleObject alloc] init];
	
	[object start];
	
	[self performSelectorInBackground:@selector(EzCheck:) withObject:object];
}

- (void)EzCheck:(EzSampleObject *)object
{
	NSUInteger step = 10000;
	
	while (step--)
	{
		[EzSampleObject outputStructState:object.valueForReplaceByAtomic withLabel:@"CHECK-ATOMIC"];
		[EzSampleObject outputStructState:object.valueForReplaceByNonAtomic withLabel:@"CHECK-NONATOMIC"];
		[EzSampleObject outputStructState:object.valueForReplaceByAtomicReadAndNonAtomicWrite withLabel:@"CHECK-(R)ATOMIC-(W)NONATOMIC"];
	}
	
	[self EzCheckDone:object];
}

- (void)EzCheckDone:(EzSampleObject *)object
{
	[object stop];
	
	[NSThread sleepForTimeInterval:1.0];
	
	NSLog(@"loopCountOfValueForReplaceByNonAtomic = %d", object.loopCountOfValueForReplaceByNonAtomic);
	NSLog(@"loopCountOfValueForReplaceByAtomic = %d", object.loopCountOfValueForReplaceByAtomic);
	NSLog(@"loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite = %d", object.loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite);
}

@end
