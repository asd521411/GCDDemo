//
//  ViewController.m
//  GCDDemo
//
//  Created by 草帽~小子 on 2019/5/6.
//  Copyright © 2019 OnePiece. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //DISPATCH_QUEUE_SERIAL串行，DISPATCH_QUEUE_CONCURRENT并行
    dispatch_queue_t queue = dispatch_queue_create("com.OnePiece.GCDDemoQueue", DISPATCH_QUEUE_CONCURRENT);
    //获得主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //获得全局并发队列
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //同步
    dispatch_sync(queue, ^{
        
    });
    //异步
    dispatch_async(queue, ^{
        
    });
    //[self syncSerial];
    //[self syncConcurrent];
    //[self asyncConcurrent];
    //[self asyncSerial];
    //[self syncMain];
    //使用 NSThread 的 detachNewThreadSelector 方法会创建线程，并自动启动线程执行
    //[NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
    //[self asyncMain];
    //[self communication];
    //[self barrier];
    //[self after];
    //[self once];
    //[self apply];
    //[self groupNotify];
    //dispatch_group_notify和dispatch_group_enter都可以实现在队列组执行之后实现相应操作，比如刷新主界面UI，但是dispatch_group_notify在异步的时候并没有在所有队列都执行后在执行dispatch_group_notify（下面[self groupNotify1]），而dispatch_group_enter可以
    //[self groupNotify1];
    //[self syncEnter];
    //[self asyncEnter];
    [self semaphoreSync];
    
    
    
    
    
    
    
    // Do any additional setup after loading the view.
}

#warning 记少不记多:只有异步串行、异步并行才开新线程

/**
 * 同步执行 + 串行队列
 * 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)syncSerial {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncSerial---begin");
    dispatch_queue_t queue = dispatch_queue_create("syncSerial", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        // 追加任务1
        NSLog(@"任务1开始");
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"任务1结束");
    });
    dispatch_sync(queue, ^{
        // 追加任务2
        NSLog(@"任务2开始");
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"任务2结束");
    });
    dispatch_sync(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"syncSerial---end");
}

/**
 * 同步执行 + 并发队列
 * 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncConcurrent {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncConcurrent---begin");
    dispatch_queue_t queue = dispatch_queue_create("syncConcurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        // 追加任务1
        NSLog(@"任务1开始");
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"任务1结束");
    });
    
    dispatch_sync(queue, ^{
        // 追加任务2
        NSLog(@"任务2开始");
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"任务2结束");
    });
    
    // 追加任务3
    dispatch_async(queue, ^{
        // 追加任务3
        NSLog(@"任务3开始");
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"任务3结束");
    });
    NSLog(@"syncConcurrent---end");
    
}


/**
 * 异步执行 + 并发队列
 * 特点：可以开启多个线程，任务交替（同时）执行。
 */
- (void)asyncConcurrent {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncConcurrent---begin");
    dispatch_queue_t queue = dispatch_queue_create("asyncConcurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        // 追加任务1
        NSLog(@"任务1开始");
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"任务1结束");
    });
    
    dispatch_async(queue, ^{
        // 追加任务2
        NSLog(@"任务2开始");
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"任务2结束");
    });

    dispatch_async(queue, ^{
        // 追加任务3
        NSLog(@"任务3开始");
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"任务3结束");
    });
    
    NSLog(@"asyncConcurrent---end");
}

/**
 * 异步执行 + 串行队列
 * 特点：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)asyncSerial {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncSerial---begin");
    dispatch_queue_t queue = dispatch_queue_create("asyncSerial", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"asyncSerial---end");
    
}

/**
 * 同步执行 + 主队列
 * 特点(主线程调用)：互等卡主不执行。
 * 特点(其他线程调用)：不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncMain {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"syncMain---end");
}

/**
 * 异步执行 + 主队列
 * 特点：只在主线程中执行任务，执行完一个任务，再执行下一个任务
 */
- (void)asyncMain {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"asyncMain---end");
}

/**
 * 线程间通信
 */
- (void)communication {
    // 获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        // 异步追加任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        
        // 回到主线程
        dispatch_async(mainQueue, ^{
            // 追加在主线程中执行的任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        });
    });
}

/**
 * 栅栏方法 dispatch_barrier_async
 */
- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_barrier_async(queue, ^{
        // 追加任务 barrier
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务4
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
}

/**
 * 延时执行方法 dispatch_after
 */
- (void)after {
    NSLog(@"currentThread---%@", [NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 2.0秒后异步追加任务代码到主队列，并开始执行
        NSLog(@"after---%@",[NSThread currentThread]);  // 打印当前线程
    });
}

/**
 * 一次性代码（只执行一次）dispatch_once
 */
- (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
    });
}

/**
 * 快速迭代方法 dispatch_apply
 */
- (void)apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"apply---begin");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd---%@",index, [NSThread currentThread]);
    });
    NSLog(@"apply---end");
}

/**
 * 队列组 dispatch_group_notify
 */
- (void)groupNotify {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务
        NSLog(@"任务执行完毕");
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"group---end");
    });
}

- (void)groupNotify1 {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_async(group, queue1, ^{
#warning 用同步，异步不正常
        dispatch_sync(queue1, ^{
            // 追加任务1
            for (int i = 0; i < 2; ++i) {
                [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
            }
        });
        dispatch_sync(queue1, ^{
             // 追加任务2
            for (int i = 0; i < 2; ++i) {
                [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
            }
        });
    });
    
    dispatch_group_async(group, queue1, ^{
        dispatch_sync(queue1, ^{
            // 追加任务3
            for (int i = 0; i < 2; ++i) {
                [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
            }
        });
        dispatch_sync(queue1, ^{
            // 追加任务4
            for (int i = 0; i < 2; ++i) {
                [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
                NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
            }
        });
    });
//    //等待上面的任务全部完成后，会往下继续执行 （会阻塞当前线程）
//    dispatch_group_wait(group1, DISPATCH_TIME_FOREVER);
    
    //等待上面的任务全部完成后，会收到通知执行block中的代码 （不会阻塞线程）
    dispatch_group_notify(group, queue1, ^{
        NSLog(@"全部任务执行完成");
    });
    
}

- (void)syncEnter {
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group1 = dispatch_group_create();
    
    dispatch_group_enter(group1);
    dispatch_sync(queue1, ^{
        for (NSInteger i =0; i<3; i++) {
            sleep(1);
            NSLog(@"%@-同步任务执行-:%ld",@"任务1",(long)i);
            
        }
        dispatch_group_leave(group1);
    });
    
    dispatch_group_enter(group1);
    dispatch_sync(queue1, ^{
        for (NSInteger i =0; i<3; i++) {
            sleep(1);
            NSLog(@"%@-同步任务执行-:%ld",@"任务2",(long)i);
            
        }
        dispatch_group_leave(group1);
    });
    
//    //等待上面的任务全部完成后，会往下继续执行 （会阻塞当前线程）
//    dispatch_group_wait(group2, DISPATCH_TIME_FOREVER);
    
    //等待上面的任务全部完成后，会收到通知执行block中的代码 （不会阻塞线程）
    dispatch_group_notify(group1, queue1, ^{
        NSLog(@"Method2-全部任务执行完成");
    });
}

- (void)asyncEnter {
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group1 = dispatch_group_create();
    
    dispatch_group_enter(group1);
    dispatch_async(queue1, ^{
        for (NSInteger i =0; i<3; i++) {
            sleep(1);
            NSLog(@"%@-异步任务执行-:%ld",@"任务1",(long)i);
            
        }
        dispatch_group_leave(group1);
    });
    
    dispatch_group_enter(group1);
    dispatch_async(queue1, ^{
        for (NSInteger i =0; i<3; i++) {
            sleep(1);
            NSLog(@"%@-异步任务执行-:%ld",@"任务2",(long)i);
            
        }
        dispatch_group_leave(group1);
    });
    
//    //等待上面的任务全部完成后，会往下继续执行 （会阻塞当前线程）
//    dispatch_group_wait(group2, DISPATCH_TIME_FOREVER);
    
    //等待上面的任务全部完成后，会收到通知执行block中的代码 （不会阻塞线程）
    dispatch_group_notify(group1, queue1, ^{
        NSLog(@"Method2-全部任务执行完成");
    });
}

/**
 * semaphore 线程同步
 */
- (void)semaphoreSync {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block int number = 0;
    dispatch_async(queue, ^{
        // 追加任务1
        NSLog(@"任务开始");
        [NSThread sleepForTimeInterval:5];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        number = 100;
        dispatch_semaphore_signal(semaphore);
    });
    NSLog(@"肘子======");
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"semaphore---end,number = %zd",number);
}





@end
