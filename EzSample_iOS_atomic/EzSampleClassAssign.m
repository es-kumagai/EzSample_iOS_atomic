//
//  EzSampleObject.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleClassAssign.h"

@interface EzSampleClassAssign ()

@end

@implementation EzSampleClassAssign

- (void)testForAtomicWithOutput:(BOOL)output outputFormat:(NSString*)outputFormat
{
	EzSampleObjectClassValue* value = [[EzSampleObjectClassValue alloc] initWithLabel:EzSampleClassLabelForAtomic];
	
	int number = self.loopCountOfValueForReplaceByAtomic;
	
	value->a = number;
	value->b = number;
	
	if (output) NSLog(outputFormat, @"Property will write.");
	self.valueForReplaceByAtomic = value;
	if (output) NSLog(outputFormat, @"Property did write.");
	
	@autoreleasepool
	{
		// ローカルスコープを定義します。
		{
			if (output) NSLog(outputFormat, @"Property will read.");
			EzSampleObjectClassValue* temp = self.valueForReplaceByAtomic;
			if (output) NSLog(outputFormat, @"Property did read.");
			if (output) NSLog(outputFormat, temp);
			
			if (output) NSLog(@"outputFormat, Will End of local scope.");
		}
		
		if (output) NSLog(outputFormat, @"Did End of local scope.");
		if (output) NSLog(outputFormat, @"Will End of autorelease pool.");
	}
	
	if (output) NSLog(outputFormat, @"End of autorelease pool.");
	
	[value release];
}

- (void)testForNonAtomicWithOutput:(BOOL)output outputFormat:(NSString*)outputFormat
{
	EzSampleObjectClassValue* value = [[EzSampleObjectClassValue alloc] initWithLabel:EzSampleClassLabelForNonAtomic];
	
	int number = self.loopCountOfValueForReplaceByNonAtomic;
	
	value->a = number;
	value->b = number;
	
	if (output) NSLog(outputFormat, @"Property will write.");
	self.valueForReplaceByNonAtomic = value;
	if (output) NSLog(outputFormat, @"Property did write.");
	
	@autoreleasepool
	{
		// ローカルスコープを定義します。
		{
			if (output) NSLog(outputFormat, @"Property will read.");
			EzSampleObjectClassValue* temp = self.valueForReplaceByNonAtomic;
			if (output) NSLog(outputFormat, @"Property did read.");
			if (output) NSLog(outputFormat, temp);
			
			if (output) NSLog(@"outputFormat, Will End of local scope.");
		}
		
		if (output) NSLog(outputFormat, @"Did End of local scope.");
		if (output) NSLog(outputFormat, @"Will End of autorelease pool.");
	}
	
	if (output) NSLog(outputFormat, @"End of autorelease pool.");
	
	[value release];
}

- (void)testForAtomicReadAndNonAtomicWriteWithOutput:(BOOL)output outputFormat:(NSString*)outputFormat
{
	EzSampleObjectClassValue* value = [[EzSampleObjectClassValue alloc] initWithLabel:EzSampleClassLabelForAtomicReadAndNonAtomicWrite];
	
	int number = self.loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite;
	
	value->a = number;
	value->b = number;
	
	if (output) NSLog(outputFormat, @"Property will write.");
	_valueForReplaceByAtomicReadAndNonAtomicWrite = value;
	if (output) NSLog(outputFormat, @"Property did write.");
	
	@autoreleasepool
	{
		// ローカルスコープを定義します。
		{
			if (output) NSLog(outputFormat, @"Property will read.");
			EzSampleObjectClassValue* temp = self.valueForReplaceByAtomicReadAndNonAtomicWrite;
			if (output) NSLog(outputFormat, @"Property did read.");
			if (output) NSLog(outputFormat, temp);
			
			if (output) NSLog(@"outputFormat, Will End of local scope.");
		}
		
		if (output) NSLog(outputFormat, @"Did End of local scope.");
		if (output) NSLog(outputFormat, @"Will End of autorelease pool.");
	}
	
	if (output) NSLog(outputFormat, @"End of autorelease pool.");
	
	[value release];
}

- (EzSampleClassResultState)outputValueForAtomic
{
	return [self outputStructState:self.valueForReplaceByAtomic withLabel:EzSampleClassCLabelForAtomic];
}

- (EzSampleClassResultState)outputValueForNonAtomic
{
	return [self outputStructState:self.valueForReplaceByNonAtomic withLabel:EzSampleClassCLabelForNonAtomic];
}

- (EzSampleClassResultState)outputValueForAtomicReadAndNonAtomicWrite
{
	return [self outputStructState:self.valueForReplaceByAtomicReadAndNonAtomicWrite withLabel:EzSampleClassCLabelForAtomicReadAndNonAtomicWrite];
}

@end
