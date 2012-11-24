//
//  EzSampleObjectClassValue.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleObjectClassValue.h"
#import "EzSampleObjectProtocol.h"

static __unsafe_unretained NSThread* EzSampleObjectClassValueLogTargetThread = nil;
static BOOL EzSampleObjectClassValueLoggingForce = NO;

static NSUInteger EzSampleObjectClassValueSerialNumber = 0;
static NSLock* EzSampleObjectClassValueSerialNumberLock = nil;

#define EzSampleObjectClassValueLogging(message,...) [[self class] logging:[NSString stringWithFormat:message, ##__VA_ARGS__]]

@interface EzSampleObjectClassValue ()

+ (void)logging:(NSString*)message;

@end

@implementation EzSampleObjectClassValue

+ (void)load
{
	EzSampleObjectClassValueSerialNumberLock = [[NSLock alloc] init];
}

+ (void)logging:(NSString *)message
{
	NSThread* currentThread = [NSThread currentThread];
	
	if (EzSampleObjectClassValueLoggingForce || currentThread == [[self class] logTargetThread])
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

+ (void)setLoggingForce:(BOOL)force
{
	EzSampleObjectClassValueLoggingForce = force;
}

+ (BOOL)loggingForce
{
	return EzSampleObjectClassValueLoggingForce;
}

- (id)copyWithZone:(NSZone *)zone
{
	EzSampleObjectClassValueLogging(@"%@: #%u : copyed.", _label, _serial);
	
	EzSampleObjectClassValue* result = [[[self class] allocWithZone:zone] initWithLabel:_label];
	
	result->a = a;
	result->b = b;
	result->valid = valid;
	
	return result;
}

- (id)initWithLabel:(NSString *)label
{
	self = [super init];
	
	if (self)
	{
		valid = 0;
		
		_label = [label copy];
		EzSampleObjectClassValueSerialNumber++;
		
		[EzSampleObjectClassValueSerialNumberLock lock];
		
		_serial = ++EzSampleObjectClassValueSerialNumber;
		
		[EzSampleObjectClassValueSerialNumberLock unlock];

		EzSampleObjectClassValueLogging(@"%@: #%u : allocated.", _label, _serial);
	}
	
	return self;
}

- (void)dealloc
{
	valid = -1;
	
	EzSampleObjectClassValueLogging(@"%@: #%u : deallocated.", _label, _serial);
	
	if (_label != nil)
	{
		[_label release];
	
		_label = nil;
	}
	
	[super dealloc];
}

- (id)autorelease
{
	EzSampleObjectClassValueLogging(@"%@: #%u : call autorelease.", _label, _serial);
	
	return [super autorelease];
}

- (id)retain
{
//	if ([_label isEqualToString:@"ATOMIC"])
//	{
//		NSLog(@"[%p] %@: #%u : retained.", [NSThread currentThread], _label, _serial);
//	}
	EzSampleObjectClassValueLogging(@"%@: #%u : retained.", _label, _serial);
	
	return [super retain];
}

- (oneway void)release
{
	EzSampleObjectClassValueLogging(@"%@: #%u : released.", _label, _serial);

	[super release];
}

@end
