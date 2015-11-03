package control.command;

import hex.control.async.AsyncCommandEvent;
import hex.control.async.IAsyncCommand;
import hex.control.async.IAsyncCommandListener;
import hex.control.command.CommandExecutor;
import hex.control.command.CommandMapping;
import hex.control.command.ICommandMapping;
import hex.control.payload.ExecutionPayload;
import hex.control.payload.PayloadEvent;
import hex.di.IDependencyInjector;
import hex.event.BasicEvent;
import hex.event.IEvent;
import hex.module.IModule;
import hex.module.Module;
import hex.unittest.assertion.Assert;


/**
 * ...
 * @author Francis Bourre
 */
class CommandExecutorTest
{
	private var _commandExecutor   	: CommandExecutor;
    private var _injector     		: MockDependencyInjectorForMapping;
    private var _module     		: IModule;

    @setUp
    public function setUp() : Void
    {
		this._injector 			= new MockDependencyInjectorForMapping();
		this._module 			= new Module();
        this._commandExecutor 	= new CommandExecutor( this._injector, _module );
    }

    @tearDown
    public function tearDown() : Void
    {
        this._injector 			= null;
		this._module 			= null;
        this._commandExecutor 	= null;
    }
	
	@test( "Test command execution" )
    public function textExcuteCommand() : Void
    {
		var commandMapping : ICommandMapping = new CommandMapping( MockAsyncCommandForTestingExecution );
		
		var listener0 			: ASyncCommandListener 				= new ASyncCommandListener();
		var listener1 			: ASyncCommandListener 				= new ASyncCommandListener();
		var listener2 			: ASyncCommandListener 				= new ASyncCommandListener();
		
		var completeHandlers 	: Array<AsyncCommandEvent->Void> 	= [listener0.onAsyncCommandComplete, listener1.onAsyncCommandComplete, listener2.onAsyncCommandComplete];
		var failHandlers 		: Array<AsyncCommandEvent->Void> 	= [listener0.onAsyncCommandFail, listener1.onAsyncCommandFail, listener2.onAsyncCommandFail];
		var cancelHandlers 		: Array<AsyncCommandEvent->Void> 	= [listener0.onAsyncCommandCancel, listener1.onAsyncCommandCancel, listener2.onAsyncCommandCancel];
		
		commandMapping.withCompleteHandlers( completeHandlers );
		commandMapping.withFailHandlers( failHandlers );
		commandMapping.withCancelHandlers( cancelHandlers );
		
		var mockImplementation 	: MockImplementation 				= new MockImplementation( "mockImplementation" );
		var mockPayload 		: ExecutionPayload 					= new ExecutionPayload( mockImplementation, IMockType, "mockPayload" );
		commandMapping.withPayloads( [mockPayload] );
		
		var stringPayload 				: ExecutionPayload 			= new ExecutionPayload( "test", String, "stringPayload" );
		var anotherMockImplementation 	: MockImplementation 		= new MockImplementation( "anotherMockImplementation" );
		var anotherMockPayload 			: ExecutionPayload 			= new ExecutionPayload( anotherMockImplementation, IMockType, "anotherMockPayload" );
		var payloads 					: Array<ExecutionPayload> 	= [ stringPayload, anotherMockPayload ];
		
		var mockForTriggeringUnmap : MockForTriggeringUnmap = new MockForTriggeringUnmap( commandMapping );
		var event : PayloadEvent = new PayloadEvent( "eventType", this._module, payloads );
		this._commandExecutor.executeCommand( commandMapping, event, mockForTriggeringUnmap.unmap );
		
		Assert.assertEquals( 1, MockAsyncCommandForTestingExecution.executeCallCount, "preExecute should be called once" );
		Assert.assertEquals( 1, MockAsyncCommandForTestingExecution.preExecuteCallCount, "execute should be called once" );
		
		Assert.assertEquals( this._module, MockAsyncCommandForTestingExecution.owner, "owner should be the same" );
		Assert.assertEquals( event, MockAsyncCommandForTestingExecution.event, "event should be the same" );
		
		Assert.assertDeepEquals( event, MockAsyncCommandForTestingExecution.event, "event should be the same" );
		
		Assert.assertDeepEquals( completeHandlers, MockAsyncCommandForTestingExecution.completeHandlers, "complete handlers should be added to async command instance" );
		Assert.assertDeepEquals( failHandlers, MockAsyncCommandForTestingExecution.failHandlers, "fail handlers should be added to async command instance" );
		Assert.assertDeepEquals( cancelHandlers, MockAsyncCommandForTestingExecution.cancelHandlers, "cancel handlers should be added to async command instance" );
		
		Assert.assertEquals( 1, this._injector.getOrCreateNewInstanceCallCount, "'injector.getOrCreateNewInstance' method should be called once" );
		Assert.assertEquals( MockAsyncCommandForTestingExecution, this._injector.getOrCreateNewInstanceCallParameter, "'injector.getOrCreateNewInstance' parameter should be command class" );
		Assert.assertEquals( 1, mockForTriggeringUnmap.unmapCallCount, "unmap handler should be called once" );
		
		Assert.assertDeepEquals( 	[ [mockImplementation, IMockType, "mockPayload"], ["test", String, "stringPayload"], [anotherMockImplementation, IMockType, "anotherMockPayload"] ], 
									this._injector.mappedPayloads,
									"'CommandExecutor.mapPayload' should map right values" );
									
		Assert.assertDeepEquals( 	[ [IMockType, "mockPayload"], [String, "stringPayload"], [IMockType, "anotherMockPayload"] ], 
									this._injector.unmappedPayloads,
									"'CommandExecutor.unmapPayload' should unmap right values" );
	}
}

private class MockForTriggeringUnmap
{
	public var commandMapping : ICommandMapping;
	public var unmapCallCount : Int = 0;
	
	public function new( commandMapping : ICommandMapping )
	{
		this.commandMapping = commandMapping;
	}
	
	public function unmap() : ICommandMapping
	{
		this.unmapCallCount++;
		return this.commandMapping;
	}
}

private class MockAsyncCommandForTestingExecution extends MockAsyncCommand
{
	static public var executeCallCount 		: Int = 0;
	static public var preExecuteCallCount 	: Int = 0;
	
	static public var event 				: IEvent;
	static public var owner 				: IModule;
	
	static public var completeHandlers 		: Array<AsyncCommandEvent->Void> = [];
	static public var failHandlers 			: Array<AsyncCommandEvent->Void> = [];
	static public var cancelHandlers 		: Array<AsyncCommandEvent->Void> = [];
	
	override public function setOwner( owner : IModule ) : Void 
	{
		MockAsyncCommandForTestingExecution.owner = owner;
	}
	
	override public function preExecute() : Void 
	{
		MockAsyncCommandForTestingExecution.preExecuteCallCount++;
	}
	
	override public function execute( ?e : IEvent ) : Void 
	{
		MockAsyncCommandForTestingExecution.executeCallCount++;
		MockAsyncCommandForTestingExecution.event = e;
	}
	
	override public function addCompleteHandler( handler : AsyncCommandEvent->Void ) : Void 
	{
		MockAsyncCommandForTestingExecution.completeHandlers.push( handler );
	}
	
	override public function addFailHandler( handler : AsyncCommandEvent->Void ) : Void 
	{
		MockAsyncCommandForTestingExecution.failHandlers.push( handler );
	}
	
	override public function addCancelHandler( handler : AsyncCommandEvent->Void ) : Void 
	{
		MockAsyncCommandForTestingExecution.cancelHandlers.push( handler );
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

private class MockDependencyInjectorForMapping extends MockDependencyInjector
{
	public var getOrCreateNewInstanceCallCount 		: Int = 0;
	public var getOrCreateNewInstanceCallParameter 	: Class<Dynamic>;
	public var mappedPayloads 						: Array<Array<Dynamic>> = [];
	public var unmappedPayloads 					: Array<Array<Dynamic>> = [];
	
	override public function mapToValue( clazz : Class<Dynamic>, value : Dynamic, ?name : String = '' ) : Void 
	{
		this.mappedPayloads.push( [ value, clazz, name ] );
	}
	
	override public function unmap( type : Class<Dynamic>, name : String = '' ) : Void 
	{
		this.unmappedPayloads.push( [ type, name ] );
	}
	
	override public function getOrCreateNewInstance( type : Class<Dynamic> ) : Dynamic 
	{
		this.getOrCreateNewInstanceCallCount++;
		this.getOrCreateNewInstanceCallParameter = type;
		return Type.createInstance( type, [] );
	}
}

private class MockImplementation implements IMockType
{
	public var name : String;
	
	public function new( name : String )
	{
		this.name = name;
	}
}

private interface IMockType
{
	
}

private class MockDependencyInjector implements IDependencyInjector
{
	public function new()
	{
		
	}
	
	/* INTERFACE hex.di.IDependencyInjector */
	public function hasMapping( type : Class<Dynamic>, name : String = '' ) : Bool 
	{
		return false;
	}
	
	public function hasDirectMapping( type : Class<Dynamic>, name:String = '' ) : Bool 
	{
		return false;
	}
	
	public function satisfies( type : Class<Dynamic>, name : String = '' ) : Bool 
	{
		return false;
	}
	
	public function injectInto( target : Dynamic ) : Void 
	{
		
	}
	
	public function getInstance( type : Class<Dynamic>, name : String = '', targetType : Class<Dynamic> = null ) : Dynamic 
	{
		return null;
	}
	
	public function getOrCreateNewInstance( type : Class<Dynamic> ) : Dynamic 
	{
		return null;
	}
	
	public function instantiateUnmapped( type : Class<Dynamic> ) : Dynamic 
	{
		return null;
	}
	
	public function destroyInstance( instance : Dynamic ) : Void 
	{
		
	}
	
	public function mapToValue( clazz : Class<Dynamic>, value : Dynamic, ?name : String = '' ) : Void 
	{
		
	}
	
	public function mapToType( clazz : Class<Dynamic>, type : Class<Dynamic>, name : String = '' ) : Void 
	{
		
	}
	
	public function mapToSingleton( clazz : Class<Dynamic>, type : Class<Dynamic>, name : String = '' ) : Void 
	{
		
	}
	
	public function unmap( type : Class<Dynamic>, name : String = '' ) : Void 
	{
		
	}
}