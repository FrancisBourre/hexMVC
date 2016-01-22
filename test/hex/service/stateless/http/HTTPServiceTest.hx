package hex.service.stateless.http;

import haxe.Http;
import hex.data.IParser;
import hex.error.IllegalStateException;
import hex.event.MessageType;
import hex.service.stateless.http.HTTPServiceConfiguration;
import hex.unittest.assertion.Assert;
import js.Browser;

/**
 * ...
 * @author Francis Bourre
 */
class HTTPServiceTest
{
	public var service : MockHTTPService;
	
	@setUp
    public function setUp() : Void
    {
        this.service = new MockHTTPService();
		this.service.createConfiguration();
    }

    @tearDown
    public function tearDown() : Void
    {
		this.service.release();
        this.service = null;
    }
	
	@test( "test result accessors" )
	public function testResult() : Void
	{
		this.service.testSetResult( "result" );
		Assert.equals( "result", this.service.getResult(), "result getter should provide result setted value" );
	}
	
	@test( "test result accessors with parser" )
	public function testResultWithParser() : Void
	{
		this.service.setParser( new MockParser() );
		this.service.testSetResult( 5 );
		Assert.equals( 6, this.service.getResult(), "result getter should provide result parsed value" );
	}
	
	@test( "Test configuration accessors" )
    public function testConfigurationAccessors() : Void
    {
		var service : MockHTTPService = new MockHTTPService();
        var configuration : MockHTTPServiceConfiguration = new MockHTTPServiceConfiguration();

		Assert.isNull( service.getConfiguration(), "configuration should be null by default" );
		
		service.setConfiguration( configuration );
        Assert.equals( configuration, service.getConfiguration(), "configuration should be retrieved from getter" );
        Assert.equals( 5000, service.getConfiguration().serviceTimeout, "'serviceTimeout' value should be 5000" );
		
		service.timeoutDuration = 100;
		Assert.equals( 100, service.getConfiguration().serviceTimeout, "'serviceTimeout' value should be 100" );
    }
	
	@test( "Test timeoutDuration accessors" )
    public function testTimeoutDurationAccessors() : Void
    {
		Assert.equals( 100, service.timeoutDuration, "'serviceTimeout' value should be 100" );
		this.service.timeoutDuration = 200;
		Assert.equals( 200, service.timeoutDuration, "'serviceTimeout' value should be 200" );
		
		#if js
		if ( Browser.supported )
		{
		#end
		
		this.service.call();
		Assert.setPropertyThrows( IllegalStateException, this.service, "timeoutDuration", 40, "'timeoutDuration' call should throw IllegalStateException" );
		
		#if js
		}
		#end
	}
	
	@test( "test call" )
	public function testCall() : Void
	{
		Assert.isFalse( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.isFalse( this.service.isRunning, "'isRunning' should return false" );
		Assert.isFalse( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.isFalse( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.isFalse( this.service.hasFailed, "'hasFailed' property should return false" );
		Assert.isFalse( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		#if js
		if ( Browser.supported )
		{
		#end
		
		service.call();
		
		Assert.isTrue( this.service.wasUsed, "'wasUsed' should return true" );
		Assert.isTrue( this.service.isRunning, "'isRunning' should return true" );
		Assert.isFalse( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.isFalse( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.isFalse( this.service.hasFailed, "'hasFailed' property should return false" );
		Assert.isFalse( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		Assert.methodCallThrows( IllegalStateException, this.service, this.service.call, [], "service called twice should throw IllegalStateException" );
		
		#if js
		}
		#end
	}
	
	@test( "test release" )
	public function testRelease() : Void
	{
		Assert.isFalse( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.isFalse( this.service.isRunning, "'isRunning' should return false" );
		Assert.isFalse( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.isFalse( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.isFalse( this.service.hasFailed, "'hasFailed' property should return false" );
		Assert.isFalse( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		this.service.release();
		
		Assert.isTrue( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.isFalse( this.service.isRunning, "'isRunning' should return false" );
		Assert.isFalse( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.isTrue( this.service.isCancelled, "'isCancelled' should return true" );
		Assert.isFalse( this.service.hasFailed, "'hasFailed' property should return false" );
		Assert.isFalse( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		Assert.methodCallThrows( IllegalStateException, this.service, this.service.call, [], "service should throw IllegalStateException when called after release" );
	}
	
	@test( "Test handleCancel" )
    public function testHandleCancel() : Void
    {
		var listener 		: MockHTTPServiceListener = new MockHTTPServiceListener();
		var handler 		: MockHTTPServiceListener = new MockHTTPServiceListener();
		var anotherHandler 	: MockHTTPServiceListener = new MockHTTPServiceListener();
		var anotherListener : MockHTTPServiceListener = new MockHTTPServiceListener();
		
		this.service.addHTTPServiceListener( listener );
		this.service.addHTTPServiceListener( anotherListener );
		this.service.addHandler( StatelessServiceMessage.CANCEL, handler, handler.onServiceCancel );
		
		Assert.isFalse( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.isFalse( this.service.isRunning, "'isRunning' should return false" );
		Assert.isFalse( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.isFalse( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.isFalse( this.service.hasFailed, "'hasFailed' property should return false" );
		Assert.isFalse( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		service.handleCancel();
		
		Assert.isTrue( this.service.wasUsed, "'wasUsed' should return true" );
		Assert.isFalse( this.service.isRunning, "'isRunning' should return false" );
		Assert.isFalse( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.isTrue( this.service.isCancelled, "'isCancelled' should return true" );
		Assert.isFalse( this.service.hasFailed, "'hasFailed' property should return false" );
		Assert.isFalse( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		Assert.isTrue( this.service.isCancelled, "'isCancelled' property should return true" );
		Assert.methodCallThrows( IllegalStateException, this.service, this.service.handleCancel, [], "StatelessService should throw IllegalStateException when calling cancel twice" );
		
		Assert.equals( 1, listener.onServiceCancelCallCount, "'listener' callback should be triggered once" );
		Assert.equals( 1, handler.onServiceCancelCallCount, "'handler' callback should be triggered once" );
		
		Assert.equals( this.service, listener.lastServiceReceived, "service received by listener should be HTTPService instance" );
		Assert.equals( this.service, handler.lastServiceReceived, "service received by handler should be HTTPService instance" );
		
		//Assert.equals( StatelessServiceMessage.CANCEL, anotherListener.lastMessageTypeReceived, "'event.type' received by listener should be AsyncStatelessServiceMessage.CANCEL" );
		
		service.addHandler( StatelessServiceMessage.CANCEL, anotherHandler, anotherHandler.onServiceCancel );
		Assert.equals( 0, anotherHandler.onServiceCancelCallCount, "'post-handler' callback should not be triggered" );
    }
	
	@test( "Test handleComplete" )
    public function testHandleComplete() : Void
    {
		var listener 		: MockHTTPServiceListener = new MockHTTPServiceListener();
		var handler 		: MockHTTPServiceListener = new MockHTTPServiceListener();
		var anotherHandler 	: MockHTTPServiceListener = new MockHTTPServiceListener();
		var anotherListener : MockHTTPServiceListener = new MockHTTPServiceListener();
		
		this.service.addHTTPServiceListener( listener );
		this.service.addHTTPServiceListener( anotherListener );
		this.service.addHandler( StatelessServiceMessage.COMPLETE, handler, handler.onServiceComplete );
		
		Assert.isFalse( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.isFalse( this.service.isRunning, "'isRunning' should return false" );
		Assert.isFalse( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.isFalse( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.isFalse( this.service.hasFailed, "'hasFailed' property should return false" );
		Assert.isFalse( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		this.service.handleComplete();
		
		Assert.isTrue( this.service.wasUsed, "'wasUsed' should return true" );
		Assert.isFalse( this.service.isRunning, "'isRunning' should return false" );
		Assert.isTrue( this.service.hasCompleted, "'hasCompleted' property should return true" );
		Assert.isFalse( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.isFalse( this.service.hasFailed, "'hasFailed' property should return false" );
		Assert.isFalse( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		Assert.methodCallThrows( IllegalStateException, this.service, this.service.handleComplete, [], "StatelessService should throw IllegalStateException when calling cancel twice" );
		
		Assert.equals( 1, listener.onServiceCompleteCallCount, "'listener' callback should be triggered once" );
		Assert.equals( 1, handler.onServiceCompleteCallCount, "'handler' callback should be triggered once" );
		
		Assert.equals( this.service, listener.lastServiceReceived, "service received by listener should be HTTPService instance" );
		Assert.equals( this.service, handler.lastServiceReceived, "service received by handler should be HTTPService instance" );
		
		//Assert.equals( StatelessServiceMessage.COMPLETE, anotherListener.lastMessageTypeReceived, "'event.type' received by listener should be StatelessServiceMessage.COMPLETE" );
		
		service.addHandler( StatelessServiceMessage.COMPLETE, anotherHandler, anotherHandler.onServiceComplete );
		Assert.equals( 0, anotherHandler.onServiceCompleteCallCount, "'post-handler' callback should not be triggered" );
    }
	
	@test( "Test handleFail" )
    public function testHandleFail() : Void
    {
		var listener 		: MockHTTPServiceListener = new MockHTTPServiceListener();
		var handler 		: MockHTTPServiceListener = new MockHTTPServiceListener();
		var anotherHandler 	: MockHTTPServiceListener = new MockHTTPServiceListener();
		var anotherListener : MockHTTPServiceListener = new MockHTTPServiceListener();
		
		this.service.addHTTPServiceListener( listener );
		this.service.addHTTPServiceListener( anotherListener );
		this.service.addHandler( StatelessServiceMessage.FAIL, handler, handler.onServiceFail );
		
		Assert.isFalse( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.isFalse( this.service.isRunning, "'isRunning' should return false" );
		Assert.isFalse( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.isFalse( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.isFalse( this.service.hasFailed, "'hasFailed' property should return false" );
		Assert.isFalse( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		this.service.handleFail();
		
		Assert.isTrue( this.service.wasUsed, "'wasUsed' should return true" );
		Assert.isFalse( this.service.isRunning, "'isRunning' should return false" );
		Assert.isFalse( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.isFalse( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.isTrue( this.service.hasFailed, "'hasFailed' property should return true" );
		Assert.isFalse( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		Assert.methodCallThrows( IllegalStateException, this.service, this.service.handleFail, [], "StatelessService should throw IllegalStateException when calling cancel twice" );
		
		Assert.equals( 1, listener.onServiceFailCallCount, "'listener' callback should be triggered once" );
		Assert.equals( 1, handler.onServiceFailCallCount, "'handler' callback should be triggered once" );
		
		Assert.equals( this.service, listener.lastServiceReceived, "'event.target' received by listener should be HTTPService instance" );
		Assert.equals( this.service, handler.lastServiceReceived, "'event.target' received by handler should be HTTPService instance" );
		
		//Assert.equals( StatelessServiceMessage.FAIL, anotherListener.lastMessageTypeReceived, "'event.type' received by listener should be StatelessServiceMessage.FAIL" );
		
		this.service.addHandler( StatelessServiceMessage.FAIL, anotherHandler, anotherHandler.onServiceFail );
		Assert.equals( 0, anotherHandler.onServiceFailCallCount, "'post-handler' callback should not be triggered" );
    }
	
	@test( "test timeout" )
	public function testTimeout() : Void
	{
		var listener 		: MockHTTPServiceListener = new MockHTTPServiceListener();
		var handler 		: MockHTTPServiceListener = new MockHTTPServiceListener();
		var anotherHandler 	: MockHTTPServiceListener = new MockHTTPServiceListener();
		var anotherListener : MockHTTPServiceListener = new MockHTTPServiceListener();
		
		this.service.addHTTPServiceListener( listener );
		this.service.addHTTPServiceListener( anotherListener );
		this.service.addHandler( AsyncStatelessServiceMessage.TIMEOUT, handler, handler.onServiceTimeout );
		
		Assert.isFalse( this.service.hasTimeout, "'hasTimeout' property should return false" );
		this.service.timeoutDuration = 0;
		
		#if js
		if ( Browser.supported )
		{
		#end
		
		this.service.call();
		Assert.isTrue( this.service.hasTimeout, "'hasTimeout' property should return true" );
		
		Assert.equals( 1, listener.onServiceTimeoutCallCount, "'listener' callback should be triggered once" );
		Assert.equals( 1, handler.onServiceTimeoutCallCount, "'handler' callback should be triggered once" );
		
		Assert.equals( this.service, listener.lastServiceReceived, "'event.target' received by listener should be HTTPService instance" );
		Assert.equals( this.service, handler.lastServiceReceived, "'event.target' received by handler should be HTTPService instance" );
		
		//Assert.equals( AsyncStatelessServiceMessage.TIMEOUT, anotherListener.lastMessageTypeReceived, "'event.type' received by listener should be AsyncStatelessServiceMessage.TIMEOUT" );
		
		this.service.addHandler( AsyncStatelessServiceMessage.TIMEOUT, anotherHandler, anotherHandler.onServiceTimeout );
		Assert.equals( 0, anotherHandler.onServiceTimeoutCallCount, "'post-handler' callback should not be triggered" );
		
		#if js
		}
		#end
	}
	
	@test( "Test _getRemoteArguments call without override" )
    public function test_getRemoteArgumentsCall() : Void
    {
		Assert.isInstanceOf( this.service.call_getRemoteArguments()[0], Http, "'_getRemoteArguments' call should return an array with HTTP instance" );
	}
	
	@test( "Test _reset call" )
    public function test_resetCall() : Void
    {
		#if js
		if ( Browser.supported )
		{
		#end
		
		this.service.call();
		
		Assert.isTrue( this.service.wasUsed, "'wasUsed' should return true" );
		Assert.isTrue( this.service.isRunning, "'isRunning' should return true" );
		Assert.isFalse( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.isFalse( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.isFalse( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		service.call_reset();
		
		Assert.isFalse( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.isFalse( this.service.isRunning, "'isRunning' should return false" );
		Assert.isFalse( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.isFalse( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.isFalse( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		#if js
		}
		#end
	}
}

private class MockParser implements IParser
{
	public function new()
	{
		
	}

	public function parse( serializedContent : Dynamic, target : Dynamic = null) : Dynamic 
	{
		return serializedContent + 1;
	}
}

