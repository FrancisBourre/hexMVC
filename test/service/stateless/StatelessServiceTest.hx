package service.stateless;

import hex.data.IParser;
import hex.error.IllegalStateException;
import hex.error.UnsupportedOperationException;
import hex.service.ServiceEvent;
import hex.service.stateless.IStatelessServiceListener;
import hex.service.stateless.StatelessServiceEvent;
import hex.unittest.assertion.Assert;
import service.AbstractServiceTest;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessServiceTest extends AbstractServiceTest
{
	@test( "test result accessors" )
	public function testResult() : Void
	{
		var service : MockStatelessService = new MockStatelessService();
		service.result = "result";
		Assert.assertEquals( "result", service.result, "result getter should provide result setted value" );
	}
	
	@test( "test result accessors with parser" )
	public function testResultWithParser() : Void
	{
		var service : MockStatelessService = new MockStatelessService();
		service.setParser( new MockParser() );
		service.result = 5;
		Assert.assertEquals( 6, service.result, "result getter should provide result parsed value" );
	}
	
	@test( "test call" )
	public function testCall() : Void
	{
		var service : MockStatelessService = new MockStatelessService();
		Assert.failTrue( service.wasUsed, "'wasUsed' should return false" );
		Assert.failTrue( service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( service.isCancelled, "'isCancelled' should return false" );
		
		service.call();
		Assert.assertTrue( service.wasUsed, "'wasUsed' should return true" );
		Assert.assertTrue( service.isRunning, "'isRunning' should return true" );
		Assert.failTrue( service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( service.isCancelled, "'isCancelled' should return false" );
		
		Assert.assertMethodCallThrows( IllegalStateException, service.call, [], "service called twice should throw IllegalStateException" );
	}
	
	@test( "test release" )
	public function testRelease() : Void
	{
		var service : MockStatelessService = new MockStatelessService();
		Assert.failTrue( service.wasUsed, "'wasUsed' should return false" );
		Assert.failTrue( service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( service.isCancelled, "'isCancelled' should return false" );
		
		service.addStatelessServiceListener( new MockStatelessServiceListener() );
		service.release();
		
		Assert.assertTrue( service.wasUsed, "'wasUsed' should return false" );
		Assert.failTrue( service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( service.hasCompleted, "'hasCompleted' should return false" );
		Assert.assertTrue( service.isCancelled, "'isCancelled' should return true" );
		
		Assert.assertMethodCallThrows( IllegalStateException, service.call, [], "service should throw IllegalStateException when called after release" );
	}
	
	@test( "Test handleCancel" )
    public function testHandleCancel() : Void
    {
		var service 		: MockStatelessService 			= new MockStatelessService();
		
		var listener 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var handler 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var anotherHandler 	: MockStatelessServiceListener = new MockStatelessServiceListener();
		
		service.addStatelessServiceListener( listener );
		service.addHandler( StatelessServiceEvent.CANCEL, handler.onStatelessServiceCancel );
		
		Assert.failTrue( service.isCancelled, "'isCancelled' property should return false" );
		service.handleCancel();
		Assert.assertTrue( service.isCancelled, "'isCancelled' property should return true" );
		Assert.assertMethodCallThrows( IllegalStateException, service.handleCancel, [], "StatelessService should throw IllegalStateException when calling cancel twice" );
		
		Assert.assertEquals( 1, listener.onStatelessServiceCancelCallCount, "'listener' callback should be triggered once" );
		Assert.assertEquals( 1, handler.onStatelessServiceCancelCallCount, "'handler' callback should be triggered once" );
		
		Assert.assertEquals( service, listener.lastEventReceived.target, "'event.target' received by listener should be StatelessService instance" );
		Assert.assertEquals( service, handler.lastEventReceived.target, "'event.target' received by handler should be StatelessService instance" );
		
		Assert.assertEquals( StatelessServiceEvent.CANCEL, listener.lastEventReceived.type, "'event.type' received by listener should be StatelessServiceEvent.CANCEL" );
		Assert.assertEquals( StatelessServiceEvent.CANCEL, handler.lastEventReceived.type, "'event.type' received by handler should be StatelessServiceEvent.CANCEL" );
		
		service.addHandler( StatelessServiceEvent.CANCEL, anotherHandler.onStatelessServiceCancel );
		Assert.assertIsNull( anotherHandler.onStatelessServiceCancelCallCount, "'post-handler' callback should not be triggered" );
    }
	
	@test( "Test handleComplete" )
    public function testHandleComplete() : Void
    {
		var service 		: MockStatelessService 			= new MockStatelessService();
		
		var listener 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var handler 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var anotherHandler 	: MockStatelessServiceListener = new MockStatelessServiceListener();
		
		service.addStatelessServiceListener( listener );
		service.addHandler( StatelessServiceEvent.COMPLETE, handler.onStatelessServiceComplete );
		
		Assert.failTrue( service.hasCompleted, "'hasCompleted' property should return false" );
		service.handleComplete();
		Assert.assertTrue( service.hasCompleted, "'hasCompleted' property should return true" );
		Assert.assertMethodCallThrows( IllegalStateException, service.handleComplete, [], "StatelessService should throw IllegalStateException when calling cancel twice" );
		
		Assert.assertEquals( 1, listener.onStatelessServiceCompleteCallCount, "'listener' callback should be triggered once" );
		Assert.assertEquals( 1, handler.onStatelessServiceCompleteCallCount, "'handler' callback should be triggered once" );
		
		Assert.assertEquals( service, listener.lastEventReceived.target, "'event.target' received by listener should be StatelessService instance" );
		Assert.assertEquals( service, handler.lastEventReceived.target, "'event.target' received by handler should be StatelessService instance" );
		
		Assert.assertEquals( StatelessServiceEvent.COMPLETE, listener.lastEventReceived.type, "'event.type' received by listener should be StatelessServiceEvent.COMPLETE" );
		Assert.assertEquals( StatelessServiceEvent.COMPLETE, handler.lastEventReceived.type, "'event.type' received by handler should be StatelessServiceEvent.COMPLETE" );
		
		service.addHandler( StatelessServiceEvent.COMPLETE, anotherHandler.onStatelessServiceComplete );
		Assert.assertIsNull( anotherHandler.onStatelessServiceCompleteCallCount, "'post-handler' callback should not be triggered" );
    }
	
	@test( "Test handleFail" )
    public function testHandleFail() : Void
    {
		var service 		: MockStatelessService 			= new MockStatelessService();
		
		var listener 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var handler 		: MockStatelessServiceListener = new MockStatelessServiceListener();
		var anotherHandler 	: MockStatelessServiceListener = new MockStatelessServiceListener();
		
		service.addStatelessServiceListener( listener );
		service.addHandler( StatelessServiceEvent.FAIL, handler.onStatelessServiceFail );
		
		Assert.failTrue( service.hasFailed, "'hasFailed' property should return false" );
		service.handleFail();
		Assert.assertTrue( service.hasFailed, "'hasFailed' property should return true" );
		Assert.assertMethodCallThrows( IllegalStateException, service.handleFail, [], "StatelessService should throw IllegalStateException when calling cancel twice" );
		
		Assert.assertEquals( 1, listener.onStatelessServiceFailCallCount, "'listener' callback should be triggered once" );
		Assert.assertEquals( 1, handler.onStatelessServiceFailCallCount, "'handler' callback should be triggered once" );
		
		Assert.assertEquals( service, listener.lastEventReceived.target, "'event.target' received by listener should be StatelessService instance" );
		Assert.assertEquals( service, handler.lastEventReceived.target, "'event.target' received by handler should be StatelessService instance" );
		
		Assert.assertEquals( StatelessServiceEvent.FAIL, listener.lastEventReceived.type, "'event.type' received by listener should be StatelessServiceEvent.FAIL" );
		Assert.assertEquals( StatelessServiceEvent.FAIL, handler.lastEventReceived.type, "'event.type' received by handler should be StatelessServiceEvent.FAIL" );
		
		service.addHandler( StatelessServiceEvent.FAIL, anotherHandler.onStatelessServiceFail );
		Assert.assertIsNull( anotherHandler.onStatelessServiceFailCallCount, "'post-handler' callback should not be triggered" );
    }
	
	@test( "Test _getRemoteArguments call without override" )
    public function test_getRemoteArgumentsCall() : Void
    {
		var service : MockStatelessService = new MockStatelessService();
		Assert.assertMethodCallThrows( UnsupportedOperationException, service.call_getRemoteArguments, [], "'_getRemoteArguments' call should throw an exception" );
	}
	
	@test( "Test _reset call" )
    public function test_resetCall() : Void
    {
		var service : MockStatelessService = new MockStatelessService();
		service.call();
		
		Assert.assertTrue( service.wasUsed, "'wasUsed' should return true" );
		Assert.assertTrue( service.isRunning, "'isRunning' should return true" );
		Assert.failTrue( service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( service.isCancelled, "'isCancelled' should return false" );
		
		service.call_reset();
		
		Assert.failTrue( service.wasUsed, "'wasUsed' should return false" );
		Assert.failTrue( service.isRunning, "'isRunning' should return false" );
		Assert.failTrue( service.hasCompleted, "'hasCompleted' should return false" );
		Assert.failTrue( service.isCancelled, "'isCancelled' should return false" );
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

private class MockStatelessServiceListener implements IStatelessServiceListener
{
	public var lastEventReceived 					: StatelessServiceEvent;
	public var onStatelessServiceCompleteCallCount 	: Int;
	public var onStatelessServiceFailCallCount 		: Int;
	public var onStatelessServiceCancelCallCount 	: Int;
	
	public function new()
	{
		
	}
	
	public function onStatelessServiceComplete( e : ServiceEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.onStatelessServiceCompleteCallCount++;
	}
	
	public function onStatelessServiceFail( e : ServiceEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.onStatelessServiceFailCallCount++;
	}
	
	public function onStatelessServiceCancel( e : ServiceEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.onStatelessServiceCancelCallCount++;
	}
}