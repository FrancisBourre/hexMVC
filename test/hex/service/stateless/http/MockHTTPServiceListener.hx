package hex.service.stateless.http;

import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
class MockHTTPServiceListener implements IHTTPServiceListener<MockHTTPServiceConfiguration>
{
	public var lastMessageTypeReceived 					: MessageType;
	public var lastServiceReceived 						: MockHTTPService;
	public var onServiceCompleteCallCount 				: Int = 0;
	public var onServiceFailCallCount 					: Int = 0;
	public var onServiceCancelCallCount 				: Int = 0;
	public var onServiceTimeoutCallCount 				: Int = 0;
	
	public function new()
	{
		
	}
	
	public function onServiceComplete( service : IHTTPService<MockHTTPServiceConfiguration> ) : Void 
	{
		this.lastServiceReceived = cast service;
		this.onServiceCompleteCallCount++;
	}
	
	public function onServiceFail( service : IHTTPService<MockHTTPServiceConfiguration> ) : Void 
	{
		this.lastServiceReceived = cast service;
		this.onServiceFailCallCount++;
	}
	
	public function onServiceCancel( service : IHTTPService<MockHTTPServiceConfiguration> ) : Void 
	{
		this.lastServiceReceived = cast service;
		this.onServiceCancelCallCount++;
	}
	
	public function onServiceTimeout( service : IHTTPService<MockHTTPServiceConfiguration> ) : Void 
	{
		this.lastServiceReceived = cast service;
		this.onServiceTimeoutCallCount++;
	}
	
	public function handleMessage( messageType : MessageType, service : MockHTTPService ) : Void 
	{
		this.lastMessageTypeReceived 	= messageType;
		this.lastServiceReceived 		= service;
	}
}