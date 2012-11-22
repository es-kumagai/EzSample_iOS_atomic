//
//  EzSampleObjectClassValue.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleObjectClassValue.h"
#import "EzSampleObjectProtocol.h"

static __weak NSThread* EzSampleObjectClassValueLogTargetThread = nil;

#define EzSampleObjectClassValueLogging(message,...) [[self class] logging:[[NSString alloc] initWithFormat:message, ##__VA_ARGS__]]

@interface EzSampleObjectClassValue ()

+ (void)logging:(NSString*)message;

@end

@implementation EzSampleObjectClassValue

+ (void)logging:(NSString *)message
{
	if ([NSThread currentThread] == [[self class] logTargetThread])
	{
		NSLog(@"%@", message);
	}
}

+ (void)setLogTargetThread:(NSThread *)targetThread
{
	@synchronized (EzSampleObjectClassValueLogTargetThread)
	{
		EzSampleObjectClassValueLogTargetThread = targetThread;
	}
}

+ (NSThread*)logTargetThread
{
	@synchronized (EzSampleObjectClassValueLogTargetThread)
	{
		return EzSampleObjectClassValueLogTargetThread;
	}
}

- (id)copyWithZone:(NSZone *)zone
{
	EzSampleObjectClassValueLogging(@"%@: copyed.", _label);
	
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
	EzSampleObjectClassValueLogging(@"%@: deallocated.", _label);
	
	[super dealloc];
}

- (id)autorelease
{
	EzSampleObjectClassValueLogging(@"%@: call autorelease.", _label);
	
	return [super autorelease];
}

- (id)retain
{
	EzSampleObjectClassValueLogging(@"%@: retained.", _label);
	
	return [super retain];
}

- (oneway void)release
{
	EzSampleObjectClassValueLogging(@"%@: released.", _label);

	[super release];
}

@end
