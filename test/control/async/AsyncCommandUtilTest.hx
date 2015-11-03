package control.async;

import hex.control.async.AsyncCommandEvent;
import hex.control.async.AsyncCommandUtil;
import hex.control.async.IAsyncCommand;
import hex.control.async.IAsyncCommandListener;
import hex.event.BasicEvent;
import hex.event.IEvent;
import hex.module.IModule;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncCommandUtilTest
{

	@test( "Test addListenersToAsyncCommand" )
    public function testAddListenersToAsyncCommand() : Void
    {
		var listener0 		: ASyncCommandListener = new ASyncCommandListener();
		var listener1 		: ASyncCommandListener = new ASyncCommandListener();
		var listener2 		: ASyncCommandListener = new ASyncCommandListener();
		
		var mockAsyncCommandForTestingListeners : MockAsyncCommandForTestingListeners = new MockAsyncCommandForTestingListeners();
		var listeners : Array<AsyncCommandEvent->Void> = [listener0.onAsyncCommandComplete, listener1.onAsyncCommandFail, listener2.onAsyncCommandCancel];
		AsyncCommandUtil.addListenersToAsyncCommand( listeners, mockAsyncCommandForTestingListeners.addCompleteHandler );
		
		Assert.assertDeepEquals( 	listeners, 
									mockAsyncCommandForTestingListeners.handlers,
									"'CommandExecutor.mapPayload' should unmap right values" );
	}
	
}

private class MockAsyncCommandForTestingListeners extends MockAsyncCommand
{
	public var handlers : Array<AsyncCommandEvent->Void> = [];
	
	override public function addCompleteHandler( handler : AsyncCommandEvent->Void ) : Void 
	{
		this.handlers.push( handler );
	}
}

private class MockAsyncCommand implements IAsyncCommand
{
	public function new()
	{
		
	}
	
	/* INTERFACE hex.control.IAsyncCommand */
	
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
	
	public function addCompleteHandler( handler : AsyncCommandEvent->Void ) : Void 
	{
		
	}
	
	public function removeCompleteHandler( handler : AsyncCommandEvent->Void ) : Void 
	{
		
	}
	
	public function addFailHandler( handler : AsyncCommandEvent->Void ) : Void 
	{
		
	}
	
	public function removeFailHandler( handler : AsyncCommandEvent->Void ) : Void 
	{
		
	}
	
	public function addCancelHandler( handler : AsyncCommandEvent->Void) : Void 
	{
		
	}
	
	public function removeCancelHandler( handler : AsyncCommandEvent->Void ) : Void 
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
	
	public function execute( ?e : IEvent ) : Void 
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
	
	/* INTERFACE hex.control.IAsyncCommandListener */
	
	public function onAsyncCommandComplete( e : BasicEvent ) : Void 
	{
		
	}
	
	public function onAsyncCommandFail( e : BasicEvent ) : Void 
	{
		
	}
	
	public function onAsyncCommandCancel( e : BasicEvent ) : Void 
	{
		
	}
}