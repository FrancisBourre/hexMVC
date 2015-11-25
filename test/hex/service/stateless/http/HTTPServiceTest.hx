package hex.service.stateless.http;

import haxe.Http;
import hex.data.IParser;
import hex.error.IllegalStateException;
import hex.service.stateless.AsyncStatelessServiceEventType;
import hex.service.stateless.http.HTTPServiceConfiguration;
import hex.service.stateless.http.HTTPServiceEvent;
import hex.service.stateless.http.IHTTPServiceListener;
import hex.service.stateless.StatelessServiceEventType;
import hex.unittest.assertion.Assert;

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
		Assert.assertEquals( "result", this.service.getResult(), "result getter should provide result setted value" );
	}
	
	@test( "test result accessors with parser" )
	public function testResultWithParser() : Void
	{
		this.service.setParser( new MockParser() );
		this.service.testSetResult( 5 );
		Assert.assertEquals( 6, this.service.getResult(), "result getter should provide result parsed value" );
	}
	
	@test( "Test configuration accessors" )
    public function testConfigurationAccessors() : Void
    {
		var service : MockHTTPService = new MockHTTPService();
        var configuration : HTTPServiceConfiguration = new HTTPServiceConfiguration();

		Assert.assertIsNull( service.getConfiguration(), "configuration should be null by default" );
		
		service.setConfiguration( configuration );
        Assert.assertEquals( configuration, service.getConfiguration(), "configuration should be retrieved from getter" );
        Assert.assertEquals( 5000, service.getConfiguration().serviceTimeout, "'serviceTimeout' value should be 5000" );
		
		service.timeoutDuration = 100;
		Assert.assertEquals( 100, service.getConfiguration().serviceTimeout, "'serviceTimeout' value should be 100" );
    }
	
	@test( "Test timeoutDuration accessors" )
    public function testTimeoutDurationAccessors() : Void
    {
		Assert.assertEquals( 100, service.timeoutDuration, "'serviceTimeout' value should be 100" );
		this.service.timeoutDuration = 200;
		Assert.assertEquals( 200, service.timeoutDuration, "'serviceTimeout' value should be 200" );
		
		this.service.call();
		Assert.assertSetPropertyThrows( IllegalStateException, this.service, "timeoutDuration", 40, "'timeoutDuration' call should throw IllegalStateException" );
	}
	
	@test( "test call" )
	public function testCall() : Void
	{
		Assert.failTrue( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.failTrue( this.service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.failTrue( this.service.hasFailed, "'hasFailed' property should return false" );
		Assert.failTrue( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		service.call();
		
		Assert.assertTrue( this.service.wasUsed, "'wasUsed' should return true" );
		Assert.assertTrue( this.service.isRunning, "'isRunning' should return true" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.failTrue( this.service.hasFailed, "'hasFailed' property should return false" );
		Assert.failTrue( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		Assert.assertMethodCallThrows( IllegalStateException, this.service.call, [], "service called twice should throw IllegalStateException" );
	}
	
	@test( "test release" )
	public function testRelease() : Void
	{
		Assert.failTrue( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.failTrue( this.service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.failTrue( this.service.hasFailed, "'hasFailed' property should return false" );
		Assert.failTrue( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		this.service.release();
		
		Assert.assertTrue( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.failTrue( this.service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.assertTrue( this.service.isCancelled, "'isCancelled' should return true" );
		Assert.failTrue( this.service.hasFailed, "'hasFailed' property should return false" );
		Assert.failTrue( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		Assert.assertMethodCallThrows( IllegalStateException, this.service.call, [], "service should throw IllegalStateException when called after release" );
	}
	
	@test( "Test handleCancel" )
    public function testHandleCancel() : Void
    {
		var listener 		: MockHTTPServiceListener = new MockHTTPServiceListener();
		var handler 		: MockHTTPServiceListener = new MockHTTPServiceListener();
		var anotherHandler 	: MockHTTPServiceListener = new MockHTTPServiceListener();
		
		this.service.addHTTPServiceListener( listener );
		this.service.addHandler( StatelessServiceEventType.CANCEL, handler.onServiceCancel );
		
		Assert.failTrue( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.failTrue( this.service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.failTrue( this.service.hasFailed, "'hasFailed' property should return false" );
		Assert.failTrue( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		service.handleCancel();
		
		Assert.assertTrue( this.service.wasUsed, "'wasUsed' should return true" );
		Assert.failTrue( this.service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.assertTrue( this.service.isCancelled, "'isCancelled' should return true" );
		Assert.failTrue( this.service.hasFailed, "'hasFailed' property should return false" );
		Assert.failTrue( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		Assert.assertTrue( this.service.isCancelled, "'isCancelled' property should return true" );
		Assert.assertMethodCallThrows( IllegalStateException, this.service.handleCancel, [], "StatelessService should throw IllegalStateException when calling cancel twice" );
		
		Assert.assertEquals( 1, listener.onServiceCancelCallCount, "'listener' callback should be triggered once" );
		Assert.assertEquals( 1, handler.onServiceCancelCallCount, "'handler' callback should be triggered once" );
		
		Assert.assertEquals( this.service, listener.lastEventReceived.target, "'event.target' received by listener should be HTTPService instance" );
		Assert.assertEquals( this.service, handler.lastEventReceived.target, "'event.target' received by handler should be HTTPService instance" );
		
		Assert.assertEquals( StatelessServiceEventType.CANCEL, listener.lastEventReceived.type, "'event.type' received by listener should be StatelessServiceEventType.CANCEL" );
		Assert.assertEquals( StatelessServiceEventType.CANCEL, handler.lastEventReceived.type, "'event.type' received by handler should be StatelessServiceEventType.CANCEL" );
		
		service.addHandler( StatelessServiceEventType.CANCEL, anotherHandler.onServiceCancel );
		Assert.assertIsNull( anotherHandler.onServiceCancelCallCount, "'post-handler' callback should not be triggered" );
    }
	
	@test( "Test handleComplete" )
    public function testHandleComplete() : Void
    {
		var listener 		: MockHTTPServiceListener = new MockHTTPServiceListener();
		var handler 		: MockHTTPServiceListener = new MockHTTPServiceListener();
		var anotherHandler 	: MockHTTPServiceListener = new MockHTTPServiceListener();
		
		this.service.addHTTPServiceListener( listener );
		this.service.addHandler( StatelessServiceEventType.COMPLETE, handler.onServiceComplete );
		
		Assert.failTrue( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.failTrue( this.service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.failTrue( this.service.hasFailed, "'hasFailed' property should return false" );
		Assert.failTrue( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		this.service.handleComplete();
		
		Assert.assertTrue( this.service.wasUsed, "'wasUsed' should return true" );
		Assert.failTrue( this.service.isRunning, "'isRunning' should return false" );
		Assert.assertTrue( this.service.hasCompleted, "'hasCompleted' property should return true" );
		Assert.failTrue( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.failTrue( this.service.hasFailed, "'hasFailed' property should return false" );
		Assert.failTrue( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		Assert.assertMethodCallThrows( IllegalStateException, this.service.handleComplete, [], "StatelessService should throw IllegalStateException when calling cancel twice" );
		
		Assert.assertEquals( 1, listener.onServiceCompleteCallCount, "'listener' callback should be triggered once" );
		Assert.assertEquals( 1, handler.onServiceCompleteCallCount, "'handler' callback should be triggered once" );
		
		Assert.assertEquals( this.service, listener.lastEventReceived.target, "'event.target' received by listener should be HTTPService instance" );
		Assert.assertEquals( this.service, handler.lastEventReceived.target, "'event.target' received by handler should be HTTPService instance" );
		
		Assert.assertEquals( StatelessServiceEventType.COMPLETE, listener.lastEventReceived.type, "'event.type' received by listener should be StatelessServiceEventType.COMPLETE" );
		Assert.assertEquals( StatelessServiceEventType.COMPLETE, handler.lastEventReceived.type, "'event.type' received by handler should be StatelessServiceEventType.COMPLETE" );
		
		service.addHandler( StatelessServiceEventType.COMPLETE, anotherHandler.onServiceComplete );
		Assert.assertIsNull( anotherHandler.onServiceCompleteCallCount, "'post-handler' callback should not be triggered" );
    }
	
	@test( "Test handleFail" )
    public function testHandleFail() : Void
    {
		var listener 		: MockHTTPServiceListener = new MockHTTPServiceListener();
		var handler 		: MockHTTPServiceListener = new MockHTTPServiceListener();
		var anotherHandler 	: MockHTTPServiceListener = new MockHTTPServiceListener();
		
		this.service.addHTTPServiceListener( listener );
		this.service.addHandler( StatelessServiceEventType.FAIL, handler.onServiceFail );
		
		Assert.failTrue( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.failTrue( this.service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.failTrue( this.service.hasFailed, "'hasFailed' property should return false" );
		Assert.failTrue( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		this.service.handleFail();
		
		Assert.assertTrue( this.service.wasUsed, "'wasUsed' should return true" );
		Assert.failTrue( this.service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.assertTrue( this.service.hasFailed, "'hasFailed' property should return true" );
		Assert.failTrue( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		Assert.assertMethodCallThrows( IllegalStateException, this.service.handleFail, [], "StatelessService should throw IllegalStateException when calling cancel twice" );
		
		Assert.assertEquals( 1, listener.onServiceFailCallCount, "'listener' callback should be triggered once" );
		Assert.assertEquals( 1, handler.onServiceFailCallCount, "'handler' callback should be triggered once" );
		
		Assert.assertEquals( this.service, listener.lastEventReceived.target, "'event.target' received by listener should be HTTPService instance" );
		Assert.assertEquals( this.service, handler.lastEventReceived.target, "'event.target' received by handler should be HTTPService instance" );
		
		Assert.assertEquals( StatelessServiceEventType.FAIL, listener.lastEventReceived.type, "'event.type' received by listener should be StatelessServiceEventType.FAIL" );
		Assert.assertEquals( StatelessServiceEventType.FAIL, handler.lastEventReceived.type, "'event.type' received by handler should be StatelessServiceEventType.FAIL" );
		
		this.service.addHandler( StatelessServiceEventType.FAIL, anotherHandler.onServiceFail );
		Assert.assertIsNull( anotherHandler.onServiceFailCallCount, "'post-handler' callback should not be triggered" );
    }
	
	@test( "test timeout" )
	public function testTimeout() : Void
	{
		var listener 		: MockHTTPServiceListener = new MockHTTPServiceListener();
		var handler 		: MockHTTPServiceListener = new MockHTTPServiceListener();
		var anotherHandler 	: MockHTTPServiceListener = new MockHTTPServiceListener();
		
		this.service.addHTTPServiceListener( listener );
		this.service.addHandler( AsyncStatelessServiceEventType.TIMEOUT, handler.onServiceTimeout );
		
		Assert.failTrue( this.service.hasTimeout, "'hasTimeout' property should return false" );
		this.service.timeoutDuration = 0;
		this.service.call();
		Assert.assertTrue( this.service.hasTimeout, "'hasTimeout' property should return true" );
		
		Assert.assertEquals( 1, listener.onServiceTimeoutCallCount, "'listener' callback should be triggered once" );
		Assert.assertEquals( 1, handler.onServiceTimeoutCallCount, "'handler' callback should be triggered once" );
		
		Assert.assertEquals( this.service, listener.lastEventReceived.target, "'event.target' received by listener should be HTTPService instance" );
		Assert.assertEquals( this.service, handler.lastEventReceived.target, "'event.target' received by handler should be HTTPService instance" );
		
		Assert.assertEquals( AsyncStatelessServiceEventType.TIMEOUT, listener.lastEventReceived.type, "'event.type' received by listener should be AsyncStatelessServiceEventType.TIMEOUT" );
		Assert.assertEquals( AsyncStatelessServiceEventType.TIMEOUT, handler.lastEventReceived.type, "'event.type' received by handler should be AsyncStatelessServiceEventType.TIMEOUT" );
		
		this.service.addHandler( AsyncStatelessServiceEventType.TIMEOUT, anotherHandler.onServiceTimeout );
		Assert.assertIsNull( anotherHandler.onServiceTimeoutCallCount, "'post-handler' callback should not be triggered" );
	}
	
	@test( "Test _getRemoteArguments call without override" )
    public function test_getRemoteArgumentsCall() : Void
    {
		Assert.assertIsType( this.service.call_getRemoteArguments()[0], Http, "'_getRemoteArguments' call should return an array with HTTP instance" );
	}
	
	@test( "Test _reset call" )
    public function test_resetCall() : Void
    {
		this.service.call();
		
		Assert.assertTrue( this.service.wasUsed, "'wasUsed' should return true" );
		Assert.assertTrue( this.service.isRunning, "'isRunning' should return true" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.failTrue( this.service.hasTimeout, "'hasTimeout' should return false" );
		
		service.call_reset();
		
		Assert.failTrue( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.failTrue( this.service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.failTrue( this.service.hasTimeout, "'hasTimeout' should return false" );
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

private class MockHTTPServiceListener implements IHTTPServiceListener<HTTPServiceEvent>
{
	public var lastEventReceived 						: HTTPServiceEvent;
	public var onServiceCompleteCallCount 				: Int;
	public var onServiceFailCallCount 					: Int;
	public var onServiceCancelCallCount 				: Int;
	public var onServiceTimeoutCallCount 				: Int;
	
	public function new()
	{
		
	}
	
	public function onServiceComplete( e : HTTPServiceEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.onServiceCompleteCallCount++;
	}
	
	public function onServiceFail( e : HTTPServiceEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.onServiceFailCallCount++;
	}
	
	public function onServiceCancel( e : HTTPServiceEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.onServiceCancelCallCount++;
	}
	
	public function onServiceTimeout( e : HTTPServiceEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.onServiceTimeoutCallCount++;
	}
}