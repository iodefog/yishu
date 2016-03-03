//
//  TcpClient.h
//  ConnectTest
//
//  Created by  SmallTask on 13-8-15.
//
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"


@protocol TcpClientDelegate <NSObject>


/**发送到服务器端的数据*/
- (void)didSendDataSuccess:(long)tag;

/**收到服务器端发送的数据*/
- (void)didReciveData:(NSData *)data withTag:(long)tag;

/**socket连接成功*/
- (void)didConnectionSuccess:(NSDictionary *)info;

/**socket连接出现错误*/
- (void)didConnectionError:(NSError *)err;

/** socket读包超时 */
- (void)didReadTimeoutWithTag:(long)tag;

@end



@interface TcpClient : NSObject
{
    NSString    *socketHost;
    NSInteger   socketPort;
    
    GCDAsyncSocket  *asyncSocket;
    id<TcpClientDelegate> delegate;
}

+ (TcpClient *)sharedInstance;

- (void)setDelegate:(id<TcpClientDelegate>)dele;

- (void)setHost:(NSString *)host port:(NSInteger)port;

- (void)connect;

- (void)disconnect;

- (void)read:(long)tag;

/** 读完整数据包 */
- (void)readDataToLength:(NSUInteger)length tag:(long)tag;

/** 拆包的数据 */
- (void)readDataWithBuffer:(NSMutableData *)buffer bufferOffset:(NSUInteger)offset maxLength:(NSUInteger)length tag:(long)tag;

- (void)writeData:(NSData *)data tag:(long)tag;

- (BOOL)isConnected;

- (void)stopConnected;

@end
