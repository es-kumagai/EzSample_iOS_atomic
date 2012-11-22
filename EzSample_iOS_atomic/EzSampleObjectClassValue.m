//
//  EzSampleObjectClassValue.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleObjectClassValue.h"
#import "EzSampleObjectProtocol.h"

@implementation EzSampleObjectClassValue

- (id)copyWithZone:(NSZone *)zone
{
	EzPostLog(@"A value for '%@' was copyed.", _label);
	
	EzSampleObjectClassValue* result = [[EzSampleObjectClassValue allocWithZone:zone] initWithLabel:_label];
	
	result->a = a;
	result->b = b;
	
	return result;
}

- (id)initWithLabel:(NSString *)label
{
	self = [super init];
	
	if (self)
	{
		_label = [label copy];
	}
	
	return self;
}

- (void)dealloc
{
	EzPostLog(@"A value for '%@' was deallocated.", _label);
	
	[super dealloc];
}

- (id)autorelease
{
	EzPostLog(@"A value for '%@' was add to autorelease pool.", _label);
	
	return [super autorelease];
}

- (id)retain
{
	EzPostLog(@"A value for '%@' was retained.", _label);
	
	return [super retain];
}

- (oneway void)release
{
	EzPostLog(@"A value for '%@' was released.", _label);

	[super release];
}

@end
