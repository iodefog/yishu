//
//  TcpClient.m
//  ConnectTest
//
//  Created by  SmallTask on 13-8-15.
//
//

#import "TcpClient.h"
#import "GCDAsyncSocket.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

#import <Security/Security.h>
#import <CommonCrypto/CommonCrypto.h>

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_INFO;

#define USE_SECURE_CONNECTION 0
#define ENABLE_BACKGROUNDING  1

@implementation TcpClient

+ (TcpClient *)sharedInstance;
{
    static TcpClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TcpClient alloc] init];
    });
    
    return sharedInstance;
}

- (void)setHost:(NSString *)host port:(NSInteger)port
{
    socketHost = host;
    socketPort = port;
}

- (void)setDelegate:(id<TcpClientDelegate>)dele
{
    delegate = dele;
}

- (void)connect
{
    DDLogInfo(@"%@", THIS_METHOD);
	
	// Setup our socket (GCDAsyncSocket).
	// The socket will invoke our delegate methods using the usual delegate paradigm.
	// However, it will invoke the delegate methods on a specified GCD delegate dispatch queue.
	//
	// Now we can configure the delegate dispatch queue however we want.
	// We could use a dedicated dispatch queue for easy parallelization.
	// Or we could simply use the dispatch queue for the main thread.
	//
	// The best approach for your application will depend upon convenience, requirements and performance.
	//
	// For this simple example, we're just going to use the main thread.
	
//	dispatch_queue_t mainQueue = dispatch_get_main_queue();
	dispatch_queue_t mainQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
	asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    
    [asyncSocket setAutoDisconnectOnClosedReadStream:NO];
	
#if USE_SECURE_CONNECTION
	{
        DDLogInfo(@"Connecting to \"%@\" on port %zi...", socketHost, socketPort);
        
        NSError *error = nil;
        if (![asyncSocket connectToHost:socketHost onPort:socketPort withTimeout:5 error:&error])
        {
            DDLogError(@"Error connecting: %@", error);
        }
	}
#else
	{
		NSError *error = nil;
		if (![asyncSocket connectToHost:socketHost onPort:socketPort withTimeout:3 error:&error])
		{
			DDLogError(@"Error connecting: %@", error);
            [delegate didConnectionError:error];
		}
	}
#endif

}

- (void)disconnect
{
    [asyncSocket setDelegate:nil];
    [asyncSocket disconnect];
}

- (void)writeData:(NSData *)data tag:(long)tag
{
    [asyncSocket writeData:data withTimeout:10 tag:tag];
}

- (void)read:(long)tag
{
    if (tag == 0) {
        [asyncSocket readDataWithTimeout:-1 tag:tag];
    } else {
        [asyncSocket readDataWithTimeout:-1 tag:tag];
    }
}

- (void)readDataToLength:(NSUInteger)length tag:(long)tag
{
    if (tag == 1000) {
        [asyncSocket readDataToLength:length withTimeout:-1 tag:tag];
    } else {
        [asyncSocket readDataToLength:length withTimeout:-1 tag:tag];
    }
    
}

- (void)readDataWithBuffer:(NSMutableData *)buffer
               bufferOffset:(NSUInteger)offset
                  maxLength:(NSUInteger)length
                        tag:(long)tag
{
    [asyncSocket readDataToLength:length withTimeout:-1 buffer:buffer bufferOffset:offset tag:tag];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Socket Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark 连接主机
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	DDLogInfo(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    dispatch_async(dispatch_get_main_queue(), ^{
        [delegate didConnectionSuccess:nil];
    });

    //	DDLogInfo(@"localHost :%@ port:%hu", [sock localHost], [sock localPort]);
//    [self read];
	
#if USE_SECURE_CONNECTION
	{
		// Connected to secure server (HTTPS)
      
#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
		{
			// Backgrounding doesn't seem to be supported on the simulator yet
			
			[sock performBlock:^{
				if ([sock enableBackgroundingOnSocket])
					DDLogInfo(@"Enabled backgrounding on socket");
				else
					DDLogWarn(@"Enabling backgrounding failed!");
			}];
		}
#endif
		
		// Configure SSL/TLS settings
		NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
		
		// If you simply want to ensure that the remote host's certificate is valid,
		// then you can use an empty dictionary.
		
		// If you know the name of the remote host, then you should specify the name here.
		//
		// NOTE:
		// You should understand the security implications if you do not specify the peer name.
		// Please see the documentation for the startTLS method in GCDAsyncSocket.h for a full discussion.
		
		[settings setObject:socketHost
					 forKey:(NSString *)kCFStreamSSLPeerName];
		
		// To connect to a test server, with a self-signed certificate, use settings similar to this:
		
        // Allow expired certificates
        [settings setObject:[NSNumber numberWithBool:YES]
                     forKey:(NSString *)kCFStreamSSLAllowsExpiredCertificates];

        // Allow self-signed certificates
        [settings setObject:[NSNumber numberWithBool:YES]
                     forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];

        // In fact, don't even validate the certificate chain
        [settings setObject:[NSNumber numberWithBool:NO]
                     forKey:(NSString *)kCFStreamSSLValidatesCertificateChain];
        
        
        // Read .p12 file
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cert.p12" ofType:nil];
        NSData *pkcs12data = [[NSData alloc] initWithContentsOfFile:path];
        CFArrayRef keyref = NULL;
        OSStatus sanityChesk = SecPKCS12Import((__bridge CFDataRef)pkcs12data,
                                               (__bridge CFDictionaryRef)[NSDictionary
                                                                          dictionaryWithObject:@"hangcom"
                                                                          forKey:(__bridge id)kSecImportExportPassphrase],
                                               &keyref);
        if (sanityChesk != noErr) {
            NSLog(@"Error while importing pkcs12 [%d]", sanityChesk);
        } else
            NSLog(@"Success opening p12 certificate.");
        
        // Identity
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(keyref, 0);
        SecIdentityRef identityRef = (SecIdentityRef)CFDictionaryGetValue(identityDict,
                                                                          kSecImportItemIdentity);
        
        // Cert
        SecCertificateRef cert = NULL;
        OSStatus status = SecIdentityCopyCertificate(identityRef, &cert);
        if (status)
            NSLog(@"SecIdentityCopyCertificate failed.");
        
        // the certificates array, containing the identity then the root certificate
        NSArray *myCerts = [[NSArray alloc] initWithObjects:(__bridge id)identityRef, (__bridge id)cert, nil];
        [settings setObject:myCerts forKey:(NSString *)kCFStreamSSLCertificates];
		
		DDLogInfo(@"Starting TLS with settings:\n%@", settings);
		
		[sock startTLS:settings];
		
		// You can also pass nil to the startTLS method, which is the same as passing an empty dictionary.
		// Again, you should understand the security implications of doing so.
		// Please see the documentation for the startTLS method in GCDAsyncSocket.h for a full discussion.
		
	}
#else
	{
		// Connected to normal server (HTTP)
		
#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
		{
			// Backgrounding doesn't seem to be supported on the simulator yet
			
			[sock performBlock:^{
				if ([sock enableBackgroundingOnSocket])
					DDLogInfo(@"Enabled backgrounding on socket");
				else
					DDLogWarn(@"Enabling backgrounding failed!");
			}];
		}
#endif
	}
#endif
    
}

#pragma mark 发送数据
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	DDLogInfo(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
//    NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
    dispatch_async(dispatch_get_main_queue(), ^{
        [delegate didSendDataSuccess:tag];
    });
}

#pragma mark 读到数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	DDLogInfo(@"socket:%p didReadData:withTag:%ld", sock, tag);
//	NSLog(@"socket:%p didReadData:withTag:%ld", sock, tag);
    dispatch_async(dispatch_get_main_queue(), ^{
        //
        [delegate didReciveData:data withTag:tag];
    });
}

#pragma mark 连接主机失败
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	DDLogInfo(@"socketDidDisconnect:%p withError: %@", sock, err);
    dispatch_async(dispatch_get_main_queue(), ^{
        [delegate didConnectionError:err];
    });
}

#pragma mark 连接超时
/**
 *  读超时
 *
 *  @param elapsed 读取的已用时间
 *  @param length  获取到的长度
 *
 *  @return >0 继续等待 <0 超时
 */
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{
    if (elapsed > 10 * 3) {
        if (tag > 0) {
            [delegate didReadTimeoutWithTag:tag];
        }
        
        NSLog(@"读取的真的失败了 --- %ld", tag);
        return -1;
    }
    if (length == 0) {
        return 10;
    } else {
        return 10;
    }
}

/**
 *  发送超时
 *
 *  @param elapsed 发送的已用时间
 *  @param length  获取到的长度
 *
 *  @return >0 继续等待 <0 超时
 */
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    if (elapsed > 10 * 3) {
        if (tag > 0) {
            [delegate didReadTimeoutWithTag:tag];
        }
        
        NSLog(@"发送的真的失败了--- %ld", tag);
        return -1;
    }
    
    if (length == 0) {
        
        return 10;
    } else {
        
        return 10;
    }
}

- (BOOL)isConnected
{
    return asyncSocket.isConnected;
}

- (void)stopConnected
{
    [asyncSocket disconnect];
}

@end
