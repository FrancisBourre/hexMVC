package hex.control.async;

import hex.control.async.AsyncCommand;
import hex.control.async.AsyncCommandEvent;
import hex.control.async.IAsyncCommandListener;
import hex.domain.Domain;
import hex.error.IllegalStateException;
import hex.error.VirtualMethodException;
import hex.event.BasicEvent;
import hex.event.IEvent;
import hex.module.IModule;
import hex.module.ModuleEvent;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncCommandTest
{
	private var _asyncCommand : MockAsyncCommand;

    @setUp
    public function setUp() : Void
    {
        this._asyncCommand = new MockAsyncCommand();
    }

    @tearDown
    public function tearDown() : Void
    {
        this._asyncCommand = null;
    }
	
	@test( "Test preExecute" )
    public function testCallPreExecuteTwice() : Void
    {
		Assert.isFalse( this._asyncCommand.wasUsed, "'wasUsed' property should return false" );
		Assert.isFalse( this._asyncCommand.isRunning, "'isRunning' property should return false" );
		
		this._asyncCommand.preExecute();
		Assert.isTrue( this._asyncCommand.wasUsed, "'wasUsed' property should return true" );
		Assert.isTrue( this._asyncCommand.isRunning, "'isRunning' property should return true" );
        Assert.methodCallThrows( IllegalStateException, this._asyncCommand, this._asyncCommand.preExecute,[], "AsyncCommand should throw IllegalStateException when calling preExecute method twice" );
    }
	
	@test( "Test get payload" )
    public function testGetPayload() : Void
    {
		Assert.isNull( this._asyncCommand.getPayload(), "'getPayload' should return null" );
    }
	
	@test( "Test owner" )
    public function testGetOwner() : Void
    {
		Assert.isNull( this._asyncCommand.getOwner(), "'getOwner' should return null" );
		
		var module : MockModule = new MockModule();
		this._asyncCommand.setOwner( module );
		Assert.equals( module, this._asyncCommand.getOwner(), "'getOwner' should return defined owner" );
    }
	
	@test( "Test execute" )
    public function testExecute() : Void
    {
		var asyncCommand : AsyncCommand = new AsyncCommand();
		Assert.methodCallThrows( VirtualMethodException, asyncCommand, asyncCommand.execute, [], "'execute' should throw VirtualMethodException" );
    }
	
	@test( "Test cancel" )
    public function testCancel() : Void
    {
		var listener 		: MockAsyncCommandListener = new MockAsyncCommandListener();
		var handler 		: MockAsyncCommandListener = new MockAsyncCommandListener();
		var anotherHandler 	: MockAsyncCommandListener = new MockAsyncCommandListener();
		
		this._asyncCommand.addAsyncCommandListener( listener );
		this._asyncCommand.addCancelHandler( handler.onAsyncCommandCancel );
		
		Assert.isFalse( this._asyncCommand.isCancelled, "'isCancelled' property should return false" );
		this._asyncCommand.cancel();
		Assert.isTrue( this._asyncCommand.isCancelled, "'isCancelled' property should return true" );
		Assert.methodCallThrows( IllegalStateException, this._asyncCommand, this._asyncCommand.cancel, [], "AsyncCommand should throw IllegalStateException when calling cancel twice" );
		
		Assert.equals( 1, listener.cancelCallbackCount, "'listener' callback should be triggered once" );
		Assert.equals( 1, handler.cancelCallbackCount, "'handler' callback should be triggered once" );
		
		Assert.equals( this._asyncCommand, listener.lastEventReceived.target, "'event.target' received by listener should be asyncCommand instance" );
		Assert.equals( this._asyncCommand, handler.lastEventReceived.target, "'event.target' received by handler should be asyncCommand instance" );
		
		Assert.equals( AsyncCommandEvent.CANCEL, listener.lastEventReceived.type, "'event.type' received by listener should be AsyncCommandEvent.CANCEL" );
		Assert.equals( AsyncCommandEvent.CANCEL, handler.lastEventReceived.type, "'event.type' received by handler should be AsyncCommandEvent.CANCEL" );
		
		this._asyncCommand.addCancelHandler( anotherHandler.onAsyncCommandCancel );
		Assert.equals( 1, anotherHandler.cancelCallbackCount, "'post-handler' callback should be triggered once" );
		Assert.equals( this._asyncCommand, anotherHandler.lastEventReceived.target, "'event.target' received by post-handler should be asyncCommand instance" );
		Assert.equals( AsyncCommandEvent.CANCEL, anotherHandler.lastEventReceived.type, "'event.type' received by post-handler should be AsyncCommandEvent.CANCEL" );
    }
	
	@test( "Test complete" )
    public function testComplete() : Void
    {
		var listener 		: MockAsyncCommandListener = new MockAsyncCommandListener();
		var handler 		: MockAsyncCommandListener = new MockAsyncCommandListener();
		var anotherHandler 	: MockAsyncCommandListener = new MockAsyncCommandListener();
		
		this._asyncCommand.addAsyncCommandListener( listener );
		this._asyncCommand.addCompleteHandler( handler.onAsyncCommandComplete );
		
		Assert.isFalse( this._asyncCommand.hasCompleted, "'hasCompleted' property should return false" );
		this._asyncCommand.execute();
		Assert.isTrue( this._asyncCommand.hasCompleted, "'hasCompleted' property should return true" );
		Assert.methodCallThrows( IllegalStateException, this._asyncCommand, this._asyncCommand.execute, [], "AsyncCommand should throw IllegalStateException when calling execute twice" );
		
		Assert.equals( 1, listener.completeCallbackCount, "'listener' callback should be triggered once" );
		Assert.equals( 1, handler.completeCallbackCount, "'handler' callback should be triggered once" );
		
		Assert.equals( this._asyncCommand, listener.lastEventReceived.target, "'event.target' received by listener should be asyncCommand instance" );
		Assert.equals( this._asyncCommand, handler.lastEventReceived.target, "'event.target' received by handler should be asyncCommand instance" );
		
		Assert.equals( AsyncCommandEvent.COMPLETE, listener.lastEventReceived.type, "'event.type' received by listener should be AsyncCommandEvent.COMPLETE" );
		Assert.equals( AsyncCommandEvent.COMPLETE, handler.lastEventReceived.type, "'event.type' received by handler should be AsyncCommandEvent.COMPLETE" );
		
		this._asyncCommand.addCompleteHandler( anotherHandler.onAsyncCommandComplete );
		Assert.equals( 1, anotherHandler.completeCallbackCount, "'post-handler' callback should be triggered once" );
		Assert.equals( this._asyncCommand, anotherHandler.lastEventReceived.target, "'event.target' received by post-handler should be asyncCommand instance" );
		Assert.equals( AsyncCommandEvent.COMPLETE, anotherHandler.lastEventReceived.type, "'event.type' received by post-handler should be AsyncCommandEvent.COMPLETE" );
	}
	
	@test( "Test fail" )
    public function testFail() : Void
    {
		var listener 		: MockAsyncCommandListener = new MockAsyncCommandListener();
		var handler 		: MockAsyncCommandListener = new MockAsyncCommandListener();
		var anotherHandler 	: MockAsyncCommandListener = new MockAsyncCommandListener();
		
		this._asyncCommand.addAsyncCommandListener( listener );
		this._asyncCommand.addFailHandler( handler.onAsyncCommandFail );
		
		Assert.isFalse( this._asyncCommand.hasFailed, "'hasFailed' property should return false" );
		this._asyncCommand.fail();
		Assert.isTrue( this._asyncCommand.hasFailed, "'hasFailed' property should return true" );
		Assert.methodCallThrows( IllegalStateException, this._asyncCommand, this._asyncCommand.fail, [], "AsyncCommand should throw IllegalStateException when failing twice" );
		
		Assert.equals( 1, listener.failCallbackCount, "'listener' callback should be triggered once" );
		Assert.equals( 1, handler.failCallbackCount, "'handler' callback should be triggered once" );
		
		Assert.equals( this._asyncCommand, listener.lastEventReceived.target, "'event.target' received by listener should be asyncCommand instance" );
		Assert.equals( this._asyncCommand, handler.lastEventReceived.target, "'event.target' received by handler should be asyncCommand instance" );
		
		Assert.equals( AsyncCommandEvent.FAIL, listener.lastEventReceived.type, "'event.type' received by listener should be AsyncCommandEvent.FAIL" );
		Assert.equals( AsyncCommandEvent.FAIL, handler.lastEventReceived.type, "'event.type' received by handler should be AsyncCommandEvent.FAIL" );
		
		this._asyncCommand.addFailHandler( anotherHandler.onAsyncCommandFail );
		Assert.equals( 1, anotherHandler.failCallbackCount, "'post-handler' callback should be triggered once" );
		Assert.equals( this._asyncCommand, anotherHandler.lastEventReceived.target, "'event.target' received by post-handler should be asyncCommand instance" );
		Assert.equals( AsyncCommandEvent.FAIL, anotherHandler.lastEventReceived.type, "'event.type' received by post-handler should be AsyncCommandEvent.FAIL" );
	}
}

private class MockAsyncCommand extends AsyncCommand
{
	override public function execute( ?e : IEvent ) : Void
	{
		this._handleComplete();
	}
	
	public function fail() : Void
	{
		this._handleFail();
	}
}

private class MockAsyncCommandListener implements IAsyncCommandListener
{
	public var lastEventReceived 		: AsyncCommandEvent;
	public var completeCallbackCount 	: Int = 0;
	public var failCallbackCount 		: Int = 0;
	public var cancelCallbackCount 		: Int = 0;
	
	public function new()
	{
		
	}
	
	/* INTERFACE hex.control.IAsyncCommandListener */
	
	public function onAsyncCommandComplete( e : BasicEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.completeCallbackCount++;
	}
	
	public function onAsyncCommandFail( e : BasicEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.failCallbackCount++;
	}
	
	public function onAsyncCommandCancel( e : BasicEvent ) : Void 
	{
		this.lastEventReceived = cast e;
		this.cancelCallbackCount++;
	}
}


private class MockModule implements IModule
{
	public function new()
	{
		
	}
	
	/* INTERFACE hex.module.IModule */
	
	public function initialize():Void 
	{
		
	}
	
	public var isInitialized( get, null ) : Bool;
	public function get_isInitialized():Bool 
	{
		return false;
	}
	
	public function release():Void 
	{
		
	}
	
	public var isReleased( get, null ) : Bool;
	public function get_isReleased() : Bool 
	{
		return false;
	}
	
	public function sendExternalEventFromDomain( e : ModuleEvent ) : Void 
	{
		
	}
	
	public function addHandler( type : String, callback : IEvent->Void ) : Void 
	{
		
	}
	
	public function removeHandler( type : String, callback : IEvent->Void) : Void 
	{
		
	}
	
	public function getDomain() : Domain 
	{
		return null;
	}
}