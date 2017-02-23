package hex.control.command;
import hex.domain.DomainUtil;

#if (!neko || haxe_ver >= "3.3")
import hex.MockDependencyInjector;
import hex.control.Request;
import hex.control.async.AsyncCommand;
import hex.control.async.IAsyncCommand;
import hex.control.async.IAsyncCommandListener;
import hex.control.command.CommandExecutor;
import hex.control.command.CommandMapping;
import hex.control.command.ICommandMapping;
import hex.control.payload.ExecutionPayload;
import hex.di.Injector;
import hex.domain.Domain;
import hex.module.IModule;
import hex.module.MockModule;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class CommandExecutorTest
{
	var _commandExecutor   	: CommandExecutor;
    var _injector     		: MockDependencyInjectorForMapping;
    var _module     		: IModule;

    @Before
    public function setUp() : Void
    {
		this._injector 			= new MockDependencyInjectorForMapping();
		this._module 			= new MockModule();
        this._commandExecutor 	= new CommandExecutor( this._injector, _module );
    }

    @After
    public function tearDown() : Void
    {
        this._injector 			= null;
		this._module 			= null;
        this._commandExecutor 	= null;
    }
	
	@Test( "Test command execution" )
    public function textExecuteCommand() : Void
    {
		var commandMapping = new CommandMapping( MockAsyncCommandForTestingExecution );
		
		var listener0 			= new ASyncCommandListener();
		var listener1 			= new ASyncCommandListener();
		var listener2 			= new ASyncCommandListener();
		
		var completeHandlers 	: Array<AsyncCommand->Void> 	= [listener0.onAsyncCommandComplete, listener1.onAsyncCommandComplete, listener2.onAsyncCommandComplete];
		var failHandlers 		: Array<AsyncCommand->Void> 	= [listener0.onAsyncCommandFail, listener1.onAsyncCommandFail, listener2.onAsyncCommandFail];
		var cancelHandlers 		: Array<AsyncCommand->Void> 	= [listener0.onAsyncCommandCancel, listener1.onAsyncCommandCancel, listener2.onAsyncCommandCancel];
		
		commandMapping	.withCompleteHandler( listener0.onAsyncCommandComplete )
						.withCompleteHandler( listener1.onAsyncCommandComplete )
						.withCompleteHandler( listener2.onAsyncCommandComplete );
						
		commandMapping	.withFailHandler( listener0.onAsyncCommandFail )
						.withFailHandler( listener1.onAsyncCommandFail )
						.withFailHandler( listener2.onAsyncCommandFail );
						
		commandMapping	.withCancelHandler( listener0.onAsyncCommandCancel )
						.withCancelHandler( listener1.onAsyncCommandCancel )
						.withCancelHandler( listener2.onAsyncCommandCancel );
		
		var mockImplementation 	= new MockImplementation( "mockImplementation" );
		var mockPayload 		= new ExecutionPayload( mockImplementation, IMockType, "mockPayload" );
		commandMapping.withPayload( mockPayload );
		
		var stringPayload 				= new ExecutionPayload( "test", String, "stringPayload" );
		var anotherMockImplementation 	= new MockImplementation( "anotherMockImplementation" );
		var anotherMockPayload 			= new ExecutionPayload( anotherMockImplementation, IMockType, "anotherMockPayload" );
		var payloads 					: Array<ExecutionPayload> 	= [ stringPayload, anotherMockPayload ];
		
		var mockForTriggeringUnmap = new MockForTriggeringUnmap( commandMapping );
		//var event = new PayloadEvent( "eventType", this._module, payloads );
		var request = new Request( payloads );
		this._commandExecutor.executeCommand( commandMapping, request, mockForTriggeringUnmap.unmap );
		
		Assert.equals( 1, MockAsyncCommandForTestingExecution.executeCallCount, "preExecute should be called once" );
		Assert.equals( 1, MockAsyncCommandForTestingExecution.preExecuteCallCount, "execute should be called once" );
		
		Assert.equals( this._module, MockAsyncCommandForTestingExecution.owner, "owner should be the same" );
		
		Assert.arrayContainsElementsFrom( completeHandlers, MockAsyncCommandForTestingExecution.completeHandlers, "complete handlers should be added to async command instance" );
		Assert.arrayContainsElementsFrom( failHandlers, MockAsyncCommandForTestingExecution.failHandlers, "fail handlers should be added to async command instance" );
		Assert.arrayContainsElementsFrom( cancelHandlers, MockAsyncCommandForTestingExecution.cancelHandlers, "cancel handlers should be added to async command instance" );
		
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
	
	@Test( "Test command execution with mapping results" )
    public function textExecuteCommandWithMappingResults() : Void
    {
		var mapping = new CommandMapping( MockCommand );
		var mappingWithMappingResults = new CommandMapping( MockCommandUsingMappingResults ).withMappingResult( mapping );
		
		var request = new Request();
		this._commandExecutor.executeCommand( mapping, request );
		this._commandExecutor.executeCommand( mappingWithMappingResults, request );
		
		Assert.deepEquals( 	[ ["s", String, ""] ], this._injector.mappedPayloads, "'CommandExecutor.mapPayload' should map right values" );
	}
	
	@Test( "Test guard injection approved" )
    public function testGuardInjectionApproved() : Void
    {
		MockCommand.executionCount = 0;
		
		var injector = new Injector();
		var domain = DomainUtil.getDomain( "testGuardInjectionApproved" );
		injector.mapToValue( Domain, domain );
		var commandExecutor = new CommandExecutor( injector, this._module );
		var cm = new CommandMapping( MockCommand ).withGuard( MockGuardForCommandExecutorTest );
		commandExecutor.executeCommand( cm );
		
		Assert.equals( 1, MockCommand.executionCount, "command should have been called once" );
	}
	
	@Test( "Test guard injection refused" )
    public function testGuardInjectionRefused() : Void
    {
		MockCommand.executionCount = 0;
		
		var injector = new Injector();
		var domain = DomainUtil.getDomain( "testGuardInjectionRefused" );
		injector.mapToValue( Domain, domain );
		var commandExecutor = new CommandExecutor( injector, this._module );
		var cm = new CommandMapping( MockCommand ).withGuard( MockGuardForCommandExecutorTest );
		commandExecutor.executeCommand( cm );
		
		Assert.equals( 0, MockCommand.executionCount, "command should not have been called" );
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

private class ASyncCommandListener implements IAsyncCommandListener
{
	public function new()
	{
		
	}
	
	public function onAsyncCommandComplete( command : IAsyncCommand ) : Void 
	{
		
	}
	
	public function onAsyncCommandFail( command : IAsyncCommand ) : Void 
	{
		
	}
	
	public function onAsyncCommandCancel( command : IAsyncCommand ) : Void 
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
	
	override public function getOrCreateNewInstance<T>( type : Class<Dynamic> ) : T 
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
#end