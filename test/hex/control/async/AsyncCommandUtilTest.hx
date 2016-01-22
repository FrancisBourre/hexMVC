package hex.control.async;

import hex.control.async.AsyncCommandUtil;
import hex.control.async.AsyncHandler;
import hex.control.async.IAsyncCommand;
import hex.control.async.IAsyncCommandListener;
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
		var listener0 		: ASyncCommandListener = new ASyncCommandListener();
		var listener1 		: ASyncCommandListener = new ASyncCommandListener();
		var listener2 		: ASyncCommandListener = new ASyncCommandListener();
		
		var mockAsyncCommandForTestingListeners : MockAsyncCommandForTestingListeners = new MockAsyncCommandForTestingListeners();
		var listeners : Array<AsyncHandler> = [ new AsyncHandler( listener0, listener0.onAsyncCommandComplete ), 
												new AsyncHandler( listener1, listener1.onAsyncCommandFail), 
												new AsyncHandler( listener2, listener2.onAsyncCommandCancel ) ];
		AsyncCommandUtil.addListenersToAsyncCommand( listeners, mockAsyncCommandForTestingListeners.addCompleteHandler );
		
		Assert.deepEquals( 	[ listener0.onAsyncCommandComplete, listener1.onAsyncCommandFail, listener2.onAsyncCommandCancel ], 
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
	
	override public function addCompleteHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void
	{
		this.scope.push( scope );
		this.callback.push( callback );
	}
}

private class MockAsyncCommand implements IAsyncCommand
{
	public function new()
	{
		
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
	
	public function addCompleteHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void
	{
		
	}
	
	public function removeCompleteHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void 
	{
		
	}
	
	public function addFailHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void 
	{
		
	}
	
	public function removeFailHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void
	{
		
	}
	
	public function addCancelHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void
	{
		
	}
	
	public function removeCancelHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void
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
	
	public function getPayload() : Array<Dynamic> 
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
	
	public function onAsyncCommandComplete( cmd : AsyncCommand ) : Void 
	{
		
	}
	
	public function onAsyncCommandFail( cmd : AsyncCommand ) : Void 
	{
		
	}
	
	public function onAsyncCommandCancel( cmd : AsyncCommand ) : Void 
	{
		
	}
}