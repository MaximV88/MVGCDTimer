//
//  MVGCDTimer.h
//  MVGCDTimer
//
//  Created by Maxim Vainshtein on 16/12/2017.
//

#import <Foundation/Foundation.h>

/**
 *  Timer that runs with GCD.
 */
@interface MVGCDTimer : NSObject
@property (atomic, assign, readonly) BOOL running;

/// Called each trigger.
@property (atomic, copy) void(^block)(MVGCDTimer*);

/**
 *  Returns a GCD timer for given input.
 *
 *  @param  interval    Interval between repeating triggers.
 *  @param  repeats     Whether to repeat timer after trigger.
 *  @param  queue       Queue for which the trigger will call the block. nil will default to DISPATCH_TARGET_QUEUE_DEFAULT.
 *  @param  block       Block that is called per trigger.
 */
+(instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                             repeats:(BOOL)repeats
                               queue:(dispatch_queue_t)queue
                               block:(void(^)(MVGCDTimer* timer))block;

/**
 *  Returns a GCD timer for given input.
 *  Timer will be started immidiatly.
 *
 *  @param  interval    Interval between repeating triggers.
 *  @param  repeats     Whether to repeat timer after trigger.
 *  @param  queue       Queue for which the trigger will call the block. nil will default to DISPATCH_TARGET_QUEUE_DEFAULT.
 *  @param  block       Block that is called per trigger.
 */
+(instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      repeats:(BOOL)repeats
                                        queue:(dispatch_queue_t)queue
                                        block:(void(^)(MVGCDTimer* timer))block;

/// Starts timer.
-(void)start;

/// Stops timer.
-(void)stop;

/// Restarts timer for given parameters (restarts timer for trigger).
-(void)restart;

/// Restarts timer with updated parameters.
-(void)restartWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats;

@end
