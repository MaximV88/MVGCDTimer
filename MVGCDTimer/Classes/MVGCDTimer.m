//
//  GCDTimer.m
//  GCDTimer
//
//  Created by Maxim Vainshtein on 16/12/2017.
//

#import "MVGCDTimer.h"

@interface MVGCDTimer ()
@property (atomic, assign) BOOL running;
@end

@implementation MVGCDTimer
{
    BOOL                _repeats;
    dispatch_queue_t    _queue;
    dispatch_source_t   _timer;
    NSTimeInterval      _interval;
}

+(instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                             repeats:(BOOL)repeats
                               queue:(dispatch_queue_t)queue
                               block:(void (^)(MVGCDTimer *))block
{
    MVGCDTimer *timer = [MVGCDTimer new];
    
    timer->_interval = interval;
    timer->_running = NO;
    timer->_repeats = repeats;
    timer.block = block;
    
    return timer;
}

+(instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      repeats:(BOOL)repeats
                                        queue:(dispatch_queue_t)queue
                                        block:(void (^)(MVGCDTimer *))block
{
    MVGCDTimer *timer = [self timerWithTimeInterval:interval repeats:repeats queue:queue block:block];
    [timer start];
    
    return timer;
}

-(void)start
{
    if (_running)
    {
        return;
    }
    
    if (!_timer)
    {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue ?: DISPATCH_TARGET_QUEUE_DEFAULT);
        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, _interval * NSEC_PER_SEC), [self repeatInterval], NSEC_PER_SEC);
        
        __weak MVGCDTimer* welf = self;
        dispatch_source_set_event_handler(_timer, ^{
           
            // stop repeat before block is called
            if (!_repeats)
            {
                [welf stop];
            }
            
            _block(welf);
            
        });
    }
    
    dispatch_resume(_timer);
    _running = YES;
}

-(void)stop
{
    if (_timer)
    {
        if (!dispatch_testcancel(_timer))
        {
            dispatch_cancel(_timer);
        }
        
        _running = NO;
        _timer = nil;
    }
}

-(void)restart
{
    if (!_timer)
    {
        [self start];
    }
    else
    {
        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, _interval * NSEC_PER_SEC), [self repeatInterval], NSEC_PER_SEC);
    }
}

-(void)restartWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats
{
    _interval = interval;
    _repeats = repeats;
    [self restart];
}

-(NSTimeInterval)repeatInterval
{
    if (_repeats)
    {
        return _interval * NSEC_PER_SEC;
    }
    else
    {
        return DISPATCH_TIME_FOREVER;
    }
}

-(void)dealloc
{
    [self stop];
}

@end
