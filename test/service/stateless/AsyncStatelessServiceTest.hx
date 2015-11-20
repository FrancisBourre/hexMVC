package service.stateless;

import hex.data.IParser;
import hex.error.IllegalStateException;
import hex.error.UnsupportedOperationException;
import hex.service.ServiceConfiguration;
import hex.service.ServiceEvent;
import hex.service.stateless.AsyncStatelessService;
import hex.service.stateless.AsyncStatelessServiceEvent;
import hex.service.stateless.IAsyncStatelessServiceListener;
import hex.service.stateless.StatelessServiceEvent;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncStatelessServiceTest
{
	public var service : MockAsyncStatelessService;
	
	@setUp
    public function setUp() : Void
    {
        this.service = new MockAsyncStatelessService();
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
        var configuration : ServiceConfiguration = new ServiceConfiguration();

		Assert.assertIsNull( this.service.getConfiguration(), "configuration should be null by default" );
		
		this.service.setConfiguration( configuration );
        Assert.assertEquals( configuration, service.getConfiguration(), "configuration should be retrieved from getter" );
        Assert.assertEquals( 5000, service.getConfiguration().serviceTimeout, "'serviceTimeout' value should be 5000" );
		
		this.service.timeoutDuration = 100;
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
		
		this.service.addStatelessServiceListener( new MockStatelessServiceListener() );
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
		var listener 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var handler 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var anotherHandler 	: MockStatelessServiceListener = new MockStatelessServiceListener();
		
		this.service.addAsyncStatelessServiceListener( listener );
		this.service.addHandler( StatelessServiceEvent.CANCEL, handler.onStatelessServiceCancel );
		
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
		
		Assert.assertEquals( 1, listener.onStatelessServiceCancelCallCount, "'listener' callback should be triggered once" );
		Assert.assertEquals( 1, handler.onStatelessServiceCancelCallCount, "'handler' callback should be triggered once" );
		
		Assert.assertEquals( this.service, listener.lastEventReceived.target, "'event.target' received by listener should be StatelessService instance" );
		Assert.assertEquals( this.service, handler.lastEventReceived.target, "'event.target' received by handler should be StatelessService instance" );
		
		Assert.assertEquals( StatelessServiceEvent.CANCEL, listener.lastEventReceived.type, "'event.type' received by listener should be StatelessServiceEvent.CANCEL" );
		Assert.assertEquals( StatelessServiceEvent.CANCEL, handler.lastEventReceived.type, "'event.type' received by handler should be StatelessServiceEvent.CANCEL" );
		
		service.addHandler( StatelessServiceEvent.CANCEL, anotherHandler.onStatelessServiceCancel );
		Assert.assertIsNull( anotherHandler.onStatelessServiceCancelCallCount, "'post-handler' callback should not be triggered" );
    }
	
	@test( "Test handleComplete" )
    public function testHandleComplete() : Void
    {
		var listener 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var handler 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var anotherHandler 	: MockStatelessServiceListener = new MockStatelessServiceListener();
		
		this.service.addAsyncStatelessServiceListener( listener );
		this.service.addHandler( StatelessServiceEvent.COMPLETE, handler.onStatelessServiceComplete );
		
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
		
		Assert.assertEquals( 1, listener.onStatelessServiceCompleteCallCount, "'listener' callback should be triggered once" );
		Assert.assertEquals( 1, handler.onStatelessServiceCompleteCallCount, "'handler' callback should be triggered once" );
		
		Assert.assertEquals( this.service, listener.lastEventReceived.target, "'event.target' received by listener should be StatelessService instance" );
		Assert.assertEquals( this.service, handler.lastEventReceived.target, "'event.target' received by handler should be StatelessService instance" );
		
		Assert.assertEquals( StatelessServiceEvent.COMPLETE, listener.lastEventReceived.type, "'event.type' received by listener should be StatelessServiceEvent.COMPLETE" );
		Assert.assertEquals( StatelessServiceEvent.COMPLETE, handler.lastEventReceived.type, "'event.type' received by handler should be StatelessServiceEvent.COMPLETE" );
		
		service.addHandler( StatelessServiceEvent.COMPLETE, anotherHandler.onStatelessServiceComplete );
		Assert.assertIsNull( anotherHandler.onStatelessServiceCompleteCallCount, "'post-handler' callback should not be triggered" );
    }
	
	@test( "Test handleFail" )
    public function testHandleFail() : Void
    {
		var listener 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var handler 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var anotherHandler 	: MockStatelessServiceListener = new MockStatelessServiceListener();
		
		this.service.addAsyncStatelessServiceListener( listener );
		this.service.addHandler( StatelessServiceEvent.FAIL, handler.onStatelessServiceFail );
		
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
		
		Assert.assertEquals( 1, listener.onStatelessServiceFailCallCount, "'listener' callback should be triggered once" );
		Assert.assertEquals( 1, handler.onStatelessServiceFailCallCount, "'handler' callback should be triggered once" );
		
		Assert.assertEquals( this.service, listener.lastEventReceived.target, "'event.target' received by listener should be StatelessService instance" );
		Assert.assertEquals( this.service, handler.lastEventReceived.target, "'event.target' received by handler should be StatelessService instance" );
		
		Assert.assertEquals( StatelessServiceEvent.FAIL, listener.lastEventReceived.type, "'event.type' received by listener should be StatelessServiceEvent.FAIL" );
		Assert.assertEquals( StatelessServiceEvent.FAIL, handler.lastEventReceived.type, "'event.type' received by handler should be StatelessServiceEvent.FAIL" );
		
		this.service.addHandler( StatelessServiceEvent.FAIL, anotherHandler.onStatelessServiceFail );
		Assert.assertIsNull( anotherHandler.onStatelessServiceFailCallCount, "'post-handler' callback should not be triggered" );
    }
	
	@test( "test timeout" )
	public function testTimeout() : Void
	{
		var listener 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var handler 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var anotherHandler 	: MockStatelessServiceListener = new MockStatelessServiceListener();
		
		this.service.addAsyncStatelessServiceListener( listener );
		this.service.addHandler( AsyncStatelessServiceEvent.TIMEOUT, handler.onAsyncStatelessServiceTimeout );
		
		Assert.failTrue( this.service.hasTimeout, "'hasTimeout' property should return false" );
		this.service.timeoutDuration = 0;
		this.service.call();
		Assert.assertTrue( this.service.hasTimeout, "'hasTimeout' property should return true" );
		
		Assert.assertEquals( 1, listener.onAsyncStatelessServiceTimeoutCallCount, "'listener' callback should be triggered once" );
		Assert.assertEquals( 1, handler.onAsyncStatelessServiceTimeoutCallCount, "'handler' callback should be triggered once" );
		
		Assert.assertEquals( this.service, listener.lastEventReceived.target, "'event.target' received by listener should be StatelessService instance" );
		Assert.assertEquals( this.service, handler.lastEventReceived.target, "'event.target' received by handler should be StatelessService instance" );
		
		Assert.assertEquals( AsyncStatelessServiceEvent.TIMEOUT, listener.lastEventReceived.type, "'event.type' received by listener should be StatelessServiceEvent.TIMEOUT" );
		Assert.assertEquals( AsyncStatelessServiceEvent.TIMEOUT, handler.lastEventReceived.type, "'event.type' received by handler should be StatelessServiceEvent.TIMEOUT" );
		
		this.service.addHandler( AsyncStatelessServiceEvent.TIMEOUT, anotherHandler.onAsyncStatelessServiceTimeout );
		Assert.assertIsNull( anotherHandler.onAsyncStatelessServiceTimeoutCallCount, "'post-handler' callback should not be triggered" );
	}
	
	@test( "Test _getRemoteArguments call without override" )
    public function test_getRemoteArgumentsCall() : Void
    {
		Assert.assertMethodCallThrows( UnsupportedOperationException, this.service.call_getRemoteArguments, [], "'_getRemoteArguments' call should throw an exception" );
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

private class MockStatelessServiceListener implements IAsyncStatelessServiceListener<AsyncStatelessServiceEvent>
{
	public var lastEventReceived 						: AsyncStatelessServiceEvent;
	public var onStatelessServiceCompleteCallCount 		: Int;
	public var onStatelessServiceFailCallCount 			: Int;
	public var onStatelessServiceCancelCallCount 		: Int;
	public var onAsyncStatelessServiceTimeoutCallCount 	: Int;
	
	public function new()
	{
		
	}
	
	public function onStatelessServiceComplete( e : AsyncStatelessServiceEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.onStatelessServiceCompleteCallCount++;
	}
	
	public function onStatelessServiceFail( e : AsyncStatelessServiceEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.onStatelessServiceFailCallCount++;
	}
	
	public function onStatelessServiceCancel( e : AsyncStatelessServiceEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.onStatelessServiceCancelCallCount++;
	}
	
	public function onAsyncStatelessServiceTimeout( e : AsyncStatelessServiceEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.onAsyncStatelessServiceTimeoutCallCount++;
	}
}