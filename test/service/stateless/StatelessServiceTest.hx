package service.stateless;

import hex.data.IParser;
import hex.error.IllegalStateException;
import hex.error.UnsupportedOperationException;
import hex.service.ServiceConfiguration;
import hex.service.ServiceEvent;
import hex.service.stateless.IStatelessServiceListener;
import hex.service.stateless.StatelessServiceEvent;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessServiceTest
{
	public var service : MockStatelessService;
	
	@setUp
    public function setUp() : Void
    {
        this.service = new MockStatelessService();
    }

    @tearDown
    public function tearDown() : Void
    {
        this.service = null;
    }
	
	@test( "Test 'getConfiguration' accessor" )
    public function testGetConfiguration() : Void
    {
        var configuration : ServiceConfiguration = new ServiceConfiguration();

		Assert.assertIsNull( this.service.getConfiguration(), "configuration should be null by default" );
		
		this.service.setConfiguration( configuration );
        Assert.assertEquals( configuration, service.getConfiguration(), "configuration should be retrieved from getter" );
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
	
	@test( "test call" )
	public function testCall() : Void
	{
		Assert.failTrue( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.failTrue( this.service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.failTrue( this.service.hasFailed, "'hasFailed' property should return false" );
		
		service.call();
		Assert.assertTrue( this.service.wasUsed, "'wasUsed' should return true" );
		Assert.assertTrue( this.service.isRunning, "'isRunning' should return true" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.failTrue( this.service.hasFailed, "'hasFailed' property should return false" );
		
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
		
		this.service.addStatelessServiceListener( new MockStatelessServiceListener() );
		this.service.release();
		
		Assert.assertTrue( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.failTrue( this.service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.assertTrue( this.service.isCancelled, "'isCancelled' should return true" );
		Assert.failTrue( this.service.hasFailed, "'hasFailed' property should return false" );
		
		Assert.assertMethodCallThrows( IllegalStateException, this.service.call, [], "service should throw IllegalStateException when called after release" );
	}
	
	@test( "Test handleCancel" )
    public function testHandleCancel() : Void
    {
		var listener 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var handler 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var anotherHandler 	: MockStatelessServiceListener = new MockStatelessServiceListener();
		
		this.service.addStatelessServiceListener( listener );
		this.service.addHandler( StatelessServiceEvent.CANCEL, handler.onStatelessServiceCancel );
		
		Assert.failTrue( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.failTrue( this.service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.failTrue( this.service.hasFailed, "'hasFailed' property should return false" );
		
		service.handleCancel();
		
		Assert.assertTrue( this.service.wasUsed, "'wasUsed' should return true" );
		Assert.failTrue( this.service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.assertTrue( this.service.isCancelled, "'isCancelled' should return true" );
		Assert.failTrue( this.service.hasFailed, "'hasFailed' property should return false" );
		
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
		
		this.service.addStatelessServiceListener( listener );
		this.service.addHandler( StatelessServiceEvent.COMPLETE, handler.onStatelessServiceComplete );
		
		Assert.failTrue( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.failTrue( this.service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.failTrue( this.service.hasFailed, "'hasFailed' property should return false" );
		
		this.service.handleComplete();
		
		Assert.assertTrue( this.service.wasUsed, "'wasUsed' should return true" );
		Assert.failTrue( this.service.isRunning, "'isRunning' should return false" );
		Assert.assertTrue( this.service.hasCompleted, "'hasCompleted' property should return true" );
		Assert.failTrue( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.failTrue( this.service.hasFailed, "'hasFailed' property should return false" );
		
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
		
		this.service.addStatelessServiceListener( listener );
		this.service.addHandler( StatelessServiceEvent.FAIL, handler.onStatelessServiceFail );
		
		Assert.failTrue( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.failTrue( this.service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.failTrue( this.service.hasFailed, "'hasFailed' property should return false" );
		
		this.service.handleFail();
		
		Assert.assertTrue( this.service.wasUsed, "'wasUsed' should return true" );
		Assert.failTrue( this.service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( this.service.isCancelled, "'isCancelled' should return false" );
		Assert.assertTrue( this.service.hasFailed, "'hasFailed' property should return true" );
		
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
		
		service.call_reset();
		
		Assert.failTrue( this.service.wasUsed, "'wasUsed' should return false" );
		Assert.failTrue( this.service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( this.service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( this.service.isCancelled, "'isCancelled' should return false" );
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

private class MockStatelessServiceListener implements IStatelessServiceListener<StatelessServiceEvent>
{
	public var lastEventReceived 					: StatelessServiceEvent;
	public var onStatelessServiceCompleteCallCount 	: Int;
	public var onStatelessServiceFailCallCount 		: Int;
	public var onStatelessServiceCancelCallCount 	: Int;
	
	public function new()
	{
		
	}
	
	public function onStatelessServiceComplete( e : StatelessServiceEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.onStatelessServiceCompleteCallCount++;
	}
	
	public function onStatelessServiceFail( e : StatelessServiceEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.onStatelessServiceFailCallCount++;
	}
	
	public function onStatelessServiceCancel( e : StatelessServiceEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.onStatelessServiceCancelCallCount++;
	}
}