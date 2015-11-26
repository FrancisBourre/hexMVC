package hex.service.stateless;

import hex.data.IParser;
import hex.error.IllegalStateException;
import hex.error.UnsupportedOperationException;
import hex.service.ServiceConfiguration;
import hex.service.ServiceEvent;
import hex.service.stateless.AsyncStatelessServiceEventType;
import hex.service.stateless.StatelessServiceEventType;
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
		
		Assert.assertMethodCallThrows( IllegalStateException, this.service, this.service.call, [], "service called twice should throw IllegalStateException" );
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
		
		Assert.assertMethodCallThrows( IllegalStateException, this.service, this.service.call, [], "service should throw IllegalStateException when called after release" );
	}
	
	@test( "Test handleCancel" )
    public function testHandleCancel() : Void
    {
		var handler 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var anotherHandler 	: MockStatelessServiceListener = new MockStatelessServiceListener();
		
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
		Assert.assertMethodCallThrows( IllegalStateException, this.service, this.service.handleCancel, [], "StatelessService should throw IllegalStateException when calling cancel twice" );
		
		Assert.assertEquals( 1, handler.onServiceCancelCallCount, "'handler' callback should be triggered once" );
		
		Assert.assertEquals( this.service, handler.lastEventReceived.target, "'event.target' received by handler should be AsyncStatelessService instance" );

		Assert.assertEquals( StatelessServiceEventType.CANCEL, handler.lastEventReceived.type, "'event.type' received by handler should be StatelessServiceEventType.CANCEL" );
		
		service.addHandler( StatelessServiceEventType.CANCEL, anotherHandler.onServiceCancel );
		Assert.assertIsNull( anotherHandler.onServiceCancelCallCount, "'post-handler' callback should not be triggered" );
    }
	
	@test( "Test handleComplete" )
    public function testHandleComplete() : Void
    {
		var handler 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var anotherHandler 	: MockStatelessServiceListener = new MockStatelessServiceListener();
		
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
		
		Assert.assertMethodCallThrows( IllegalStateException, this.service, this.service.handleComplete, [], "StatelessService should throw IllegalStateException when calling cancel twice" );
		
		Assert.assertEquals( 1, handler.onServiceCompleteCallCount, "'handler' callback should be triggered once" );

		Assert.assertEquals( this.service, handler.lastEventReceived.target, "'event.target' received by handler should be AsyncStatelessService instance" );
		
		Assert.assertEquals( StatelessServiceEventType.COMPLETE, handler.lastEventReceived.type, "'event.type' received by handler should be StatelessServiceEventType.COMPLETE" );
		
		service.addHandler( StatelessServiceEventType.COMPLETE, anotherHandler.onServiceComplete );
		Assert.assertIsNull( anotherHandler.onServiceCompleteCallCount, "'post-handler' callback should not be triggered" );
    }
	
	@test( "Test handleFail" )
    public function testHandleFail() : Void
    {
		var handler 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var anotherHandler 	: MockStatelessServiceListener = new MockStatelessServiceListener();
		
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
		
		Assert.assertMethodCallThrows( IllegalStateException, this.service, this.service.handleFail, [], "StatelessService should throw IllegalStateException when calling cancel twice" );

		Assert.assertEquals( 1, handler.onServiceFailCallCount, "'handler' callback should be triggered once" );
		
		Assert.assertEquals( this.service, handler.lastEventReceived.target, "'event.target' received by handler should be AsyncStatelessService instance" );

		Assert.assertEquals( StatelessServiceEventType.FAIL, handler.lastEventReceived.type, "'event.type' received by handler should be StatelessServiceEventType.FAIL" );
		
		this.service.addHandler( StatelessServiceEventType.FAIL, anotherHandler.onServiceFail );
		Assert.assertIsNull( anotherHandler.onServiceFailCallCount, "'post-handler' callback should not be triggered" );
    }
	
	@test( "test timeout" )
	public function testTimeout() : Void
	{
		var handler 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var anotherHandler 	: MockStatelessServiceListener = new MockStatelessServiceListener();
		
		this.service.addHandler( AsyncStatelessServiceEventType.TIMEOUT, handler.onServiceTimeout );
		
		Assert.failTrue( this.service.hasTimeout, "'hasTimeout' property should return false" );
		this.service.timeoutDuration = 0;
		this.service.call();
		Assert.assertTrue( this.service.hasTimeout, "'hasTimeout' property should return true" );

		Assert.assertEquals( 1, handler.onServiceTimeoutCallCount, "'handler' callback should be triggered once" );

		Assert.assertEquals( this.service, handler.lastEventReceived.target, "'event.target' received by handler should be AsyncStatelessService instance" );

		Assert.assertEquals( AsyncStatelessServiceEventType.TIMEOUT, handler.lastEventReceived.type, "'event.type' received by handler should be AsyncStatelessServiceEventType.TIMEOUT" );
		
		this.service.addHandler( AsyncStatelessServiceEventType.TIMEOUT, anotherHandler.onServiceTimeout );
		Assert.assertIsNull( anotherHandler.onServiceTimeoutCallCount, "'post-handler' callback should not be triggered" );
	}
	
	@test( "Test _getRemoteArguments call without override" )
    public function test_getRemoteArgumentsCall() : Void
    {
		Assert.assertMethodCallThrows( UnsupportedOperationException, this.service, this.service.call_getRemoteArguments, [], "'_getRemoteArguments' call should throw an exception" );
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

private class MockStatelessServiceListener
{
	public var lastEventReceived 						: ServiceEvent;
	public var onServiceCompleteCallCount 				: Int;
	public var onServiceFailCallCount 					: Int;
	public var onServiceCancelCallCount 				: Int;
	public var onServiceTimeoutCallCount 				: Int;
	
	public function new()
	{
		
	}
	
	public function onServiceComplete( e : ServiceEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.onServiceCompleteCallCount++;
	}
	
	public function onServiceFail( e : ServiceEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.onServiceFailCallCount++;
	}
	
	public function onServiceCancel( e : ServiceEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.onServiceCancelCallCount++;
	}
	
	public function onServiceTimeout( e : ServiceEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.onServiceTimeoutCallCount++;
	}
}