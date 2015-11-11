package service.stateless;

import hex.data.IParser;
import hex.error.IllegalStateException;
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
	public var onStatelessServiceSuccessCallCount 	: Int;
	public var onStatelessServiceErrorCallCount 	: Int;
	public var onStatelessServiceCancelCallCount 	: Int;
	
	public function new()
	{
		
	}
	
	public function onStatelessServiceSuccess( e : StatelessServiceEvent ) : Void 
	{
		this.onStatelessServiceSuccessCallCount++;
	}
	
	public function onStatelessServiceError( e : StatelessServiceEvent ) : Void 
	{
		this.onStatelessServiceErrorCallCount++;
	}
	
	public function onStatelessServiceCancel( e : StatelessServiceEvent ) : Void 
	{
		this.onStatelessServiceCancelCallCount++;
	}
}