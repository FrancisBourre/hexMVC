package hex.control.command;

import hex.control.async.AsyncCommand;
import hex.control.async.AsyncHandler;
import hex.control.async.IAsyncCommandListener;
import hex.control.command.CommandExecutor;
import hex.control.command.CommandMapping;
import hex.control.command.ICommandMapping;
import hex.control.payload.ExecutionPayload;
import hex.control.Request;
import hex.MockDependencyInjector;
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
		
		var completeHandlers 	: Array<AsyncCommand->Void> 	= [listener0.onAsyncCommandComplete, listener1.onAsyncCommandComplete, listener2.onAsyncCommandComplete];
		var failHandlers 		: Array<AsyncCommand->Void> 	= [listener0.onAsyncCommandFail, listener1.onAsyncCommandFail, listener2.onAsyncCommandFail];
		var cancelHandlers 		: Array<AsyncCommand->Void> 	= [listener0.onAsyncCommandCancel, listener1.onAsyncCommandCancel, listener2.onAsyncCommandCancel];
		
		commandMapping	.withCompleteHandlers( new AsyncHandler( listener0, listener0.onAsyncCommandComplete ) )
						.withCompleteHandlers( new AsyncHandler( listener1, listener1.onAsyncCommandComplete ) )
						.withCompleteHandlers( new AsyncHandler( listener2, listener2.onAsyncCommandComplete ) );
						
		commandMapping	.withFailHandlers( new AsyncHandler( listener0, listener0.onAsyncCommandFail ) )
						.withFailHandlers( new AsyncHandler( listener1, listener1.onAsyncCommandFail ) )
						.withFailHandlers( new AsyncHandler( listener2, listener2.onAsyncCommandFail ) );
						
		commandMapping	.withCancelHandlers( new AsyncHandler( listener0, listener0.onAsyncCommandCancel ) )
						.withCancelHandlers( new AsyncHandler( listener1, listener1.onAsyncCommandCancel ) )
						.withCancelHandlers( new AsyncHandler( listener2, listener2.onAsyncCommandCancel ) );
		
		var mockImplementation 	: MockImplementation 				= new MockImplementation( "mockImplementation" );
		var mockPayload 		: ExecutionPayload 					= new ExecutionPayload( mockImplementation, IMockType, "mockPayload" );
		commandMapping.withPayloads( [mockPayload] );
		
		var stringPayload 				: ExecutionPayload 			= new ExecutionPayload( "test", String, "stringPayload" );
		var anotherMockImplementation 	: MockImplementation 		= new MockImplementation( "anotherMockImplementation" );
		var anotherMockPayload 			: ExecutionPayload 			= new ExecutionPayload( anotherMockImplementation, IMockType, "anotherMockPayload" );
		var payloads 					: Array<ExecutionPayload> 	= [ stringPayload, anotherMockPayload ];
		
		var mockForTriggeringUnmap : MockForTriggeringUnmap = new MockForTriggeringUnmap( commandMapping );
		//var event : PayloadEvent = new PayloadEvent( "eventType", this._module, payloads );
		var request : Request = new Request( payloads );
		this._commandExecutor.executeCommand( commandMapping, request, mockForTriggeringUnmap.unmap );
		
		Assert.equals( 1, MockAsyncCommandForTestingExecution.executeCallCount, "preExecute should be called once" );
		Assert.equals( 1, MockAsyncCommandForTestingExecution.preExecuteCallCount, "execute should be called once" );
		
		Assert.equals( this._module, MockAsyncCommandForTestingExecution.owner, "owner should be the same" );
		Assert.equals( request, MockAsyncCommandForTestingExecution.request, "event should be the same" );
		
		Assert.deepEquals( request, MockAsyncCommandForTestingExecution.request, "event should be the same" );
		
		Assert.arrayContains( completeHandlers, MockAsyncCommandForTestingExecution.completeHandlers, "complete handlers should be added to async command instance" );
		Assert.arrayContains( failHandlers, MockAsyncCommandForTestingExecution.failHandlers, "fail handlers should be added to async command instance" );
		Assert.arrayContains( cancelHandlers, MockAsyncCommandForTestingExecution.cancelHandlers, "cancel handlers should be added to async command instance" );
		
		Assert.equals( 1, this._injector.getOrCreateNewInstanceCallCount, "'injector.getOrCreateNewInstance' method should be called once" );
		Assert.equals( MockAsyncCommandForTestingExecution, this._injector.getOrCreateNewInstanceCallParameter, "'injector.getOrCreateNewInstance' parameter should be command class" );
		Assert.equals( 1, mockForTriggeringUnmap.unmapCallCount, "unmap handler should be called once" );
		
		Assert.deepEquals( 	[ [mockImplementation, IMockType, "mockPayload"], ["test", String, "stringPayload"], [anotherMockImplementation, IMockType, "anotherMockPayload"] ], 
									this._injector.mappedPayloads,
									"'CommandExecutor.mapPayload' should map right values" );
									
		Assert.deepEquals( 	[ [IMockType, "mockPayload"], [String, "stringPayload"], [IMockType, "anotherMockPayload"] ], 
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

private class MockAsyncCommandForTestingExecution extends AsyncCommand
{
	static public var executeCallCount 		: Int = 0;
	static public var preExecuteCallCount 	: Int = 0;
	
	static public var request 				: Request;
	static public var owner 				: IModule;
	
	static public var completeHandlers 		: Array<AsyncCommand->Void> = [];
	static public var failHandlers 			: Array<AsyncCommand->Void> = [];
	static public var cancelHandlers 		: Array<AsyncCommand->Void> = [];
	
	override public function setOwner( owner : IModule ) : Void 
	{
		MockAsyncCommandForTestingExecution.owner = owner;
	}
	
	override public function preExecute() : Void 
	{
		MockAsyncCommandForTestingExecution.preExecuteCallCount++;
	}
	
	override public function execute( ?request : Request ) : Void 
	{
		MockAsyncCommandForTestingExecution.executeCallCount++;
		MockAsyncCommandForTestingExecution.request = request;
	}
	
	override public function addCompleteHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void
	{
		MockAsyncCommandForTestingExecution.completeHandlers.push( callback );
	}
	
	override public function addFailHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void
	{
		MockAsyncCommandForTestingExecution.failHandlers.push( callback );
	}
	
	override public function addCancelHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void
	{
		MockAsyncCommandForTestingExecution.cancelHandlers.push( callback );
	}
}

private class ASyncCommandListener implements IAsyncCommandListener
{
	public function new()
	{
		
	}
	
	public function onAsyncCommandComplete( command : AsyncCommand ) : Void 
	{
		
	}
	
	public function onAsyncCommandFail( command : AsyncCommand ) : Void 
	{
		
	}
	
	public function onAsyncCommandCancel( command : AsyncCommand ) : Void 
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