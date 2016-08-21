package hex.control.async;

import hex.control.async.AsyncCommandUtil;
import hex.control.async.AsyncHandler;
import hex.control.async.IAsyncCommand;
import hex.control.async.IAsyncCommandListener;
import hex.control.payload.ExecutionPayload;
import hex.log.ILogger;
import hex.module.IModule;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncCommandUtilTest
{

	@Test( "Test addListenersToAsyncCommand" )
    public function testAddListenersToAsyncCommand() : Void
    {
		var listener0 		= new ASyncCommandListener();
		var listener1 		= new ASyncCommandListener();
		var listener2 		= new ASyncCommandListener();
		
		var mockAsyncCommandForTestingListeners = new MockAsyncCommandForTestingListeners();
		var listeners : Array<AsyncHandler> = [ new AsyncHandler( listener0, listener0.onAsyncCommandComplete ), 
												new AsyncHandler( listener1, listener1.onAsyncCommandFail), 
												new AsyncHandler( listener2, listener2.onAsyncCommandCancel ) ];
		AsyncCommandUtil.addListenersToAsyncCommand( listeners, mockAsyncCommandForTestingListeners.addCompleteHandler );
		
		var a : Array<hex.control.async.AsyncCommand -> Void> = [ listener0.onAsyncCommandComplete, listener1.onAsyncCommandFail, listener2.onAsyncCommandCancel ];

		Assert.arrayContainsElementsFrom( 	a, 
							mockAsyncCommandForTestingListeners.callback,
							"'CommandExecutor.mapPayload' should map right callbacks" );
							
		Assert.deepEquals( 	[ listener0, listener1, listener2 ], 
							mockAsyncCommandForTestingListeners.scope,
							"'CommandExecutor.mapPayload' should map right scopes" );
	}
	
}

private class MockAsyncCommandForTestingListeners extends MockAsyncCommand
{
	public var scope 	: Array<Dynamic> 			= [];
	public var callback : Array<AsyncCommand->Void> = [];
	
	override public function addCompleteHandler( scope : Dynamic, callback : IAsyncCommand->Void ) : Void
	{
		this.scope.push( scope );
		this.callback.push( callback );
	}
}

private class MockAsyncCommand implements IAsyncCommand
{
	public var executeMethodName( default, null ) : String = "execute";
	
	public function new()
	{
		
	}
	
	public function getLogger() : ILogger
	{
		return this.getOwner().getLogger();
	}
	
	public function preExecute() : Void 
	{
		
	}
	
	public function cancel() : Void 
	{
		
	}
	
	public function addAsyncCommandListener( listener : IAsyncCommandListener ) : Void 
	{
		
	}
	
	public function removeAsyncCommandListener( listener : IAsyncCommandListener ) : Void 
	{
		
	}
	
	public function addCompleteHandler( scope : Dynamic, callback : IAsyncCommand->Void ) : Void
	{
		
	}
	
	public function removeCompleteHandler( scope : Dynamic, callback : IAsyncCommand->Void ) : Void 
	{
		
	}
	
	public function addFailHandler( scope : Dynamic, callback : IAsyncCommand->Void ) : Void 
	{
		
	}
	
	public function removeFailHandler( scope : Dynamic, callback : IAsyncCommand->Void ) : Void
	{
		
	}
	
	public function addCancelHandler( scope : Dynamic, callback : IAsyncCommand->Void ) : Void
	{
		
	}
	
	public function removeCancelHandler( scope : Dynamic, callback : IAsyncCommand->Void ) : Void
	{
		
	}
	
	public function handleComplete() : Void 
	{
		
	}
	
	public function handleFail() : Void 
	{
		
	}
	
	public function handleCancel() : Void 
	{
		
	}
	
	public function execute( ?request : Request ) : Void 
	{
		
	}
	
	public function getResult() : Array<Dynamic> 
	{
		return null;
	}
	public function getReturnedExecutionPayload() : Array<ExecutionPayload>
	{
		return null;
	}
	
	public function getOwner() : IModule 
	{
		return null;
	}
	
	public function setOwner( owner : IModule ) : Void 
	{
		
	}
	
	public var wasUsed( get, null ) : Bool;
	public function get_wasUsed() : Bool
    {
        return false;
    }

	public var isRunning( get, null ) : Bool;
	public function get_isRunning() : Bool
    {
        return false;
    }

	public var hasCompleted( get, null ) : Bool;
	public function get_hasCompleted() : Bool
    {
        return false;
    }

	public var hasFailed( get, null ) : Bool;
	public function get_hasFailed() : Bool
    {
        return false;
    }

	public var isCancelled( get, null ) : Bool;
	public function get_isCancelled() : Bool
    {
        return false;
    }
}

private class ASyncCommandListener implements IAsyncCommandListener
{
	public function new()
	{
		
	}
	
	public function onAsyncCommandComplete( cmd : IAsyncCommand ) : Void 
	{
		
	}
	
	public function onAsyncCommandFail( cmd : IAsyncCommand ) : Void 
	{
		
	}
	
	public function onAsyncCommandCancel( cmd : IAsyncCommand ) : Void 
	{
		
	}
}