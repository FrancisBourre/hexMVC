package hex.control.macro;

import haxe.Timer;
import hex.MockDependencyInjector;
import hex.control.Request;
import hex.control.async.AsyncCommand;
import hex.control.async.IAsyncCommand;
import hex.control.async.IAsyncCommandListener;
import hex.control.command.BasicCommand;
import hex.control.command.CommandMapping;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.control.macro.IMacroExecutor;
import hex.control.macro.MacroExecutor;
import hex.control.payload.ExecutionPayload;
import hex.error.IllegalStateException;
import hex.log.ILogger;
import hex.module.IModule;
import hex.module.MockModule;
import hex.unittest.assertion.Assert;
import hex.unittest.runner.MethodRunner;

/**
 * ...
 * @author Francis Bourre
 */
class MacroExecutorTest
{
	var _macroExecutor 		: MacroExecutor;
    var _injector     		: MockDependencyInjectorForMapping;
    var _module     		: IModule;
    var _mockMacro     		: MockMacroListener;

    @Before
    public function setUp() : Void
    {
		this._injector 			= new MockDependencyInjectorForMapping();
		this._module 			= new MockModule();
        this._macroExecutor 	= new MacroExecutor();
        this._mockMacro 		= new MockMacroListener( this._macroExecutor );
		this._macroExecutor.setAsyncCommandListener( this._mockMacro );
		
		this._macroExecutor.injector = this._injector;
    }

    @After
    public function tearDown() : Void
    {
		this._injector 			= null;
		this._module 			= null;
        this._macroExecutor 	= null;
        this._mockMacro 		= null;
    }
	
	@Test( "Test commandIndex" )
    public function testCommandIndex() : Void
    {
		Assert.equals( 0, this._macroExecutor.commandIndex, "'commandIndex' should return 0" );
		this._macroExecutor.add( MockAsyncCommand );
		this._macroExecutor.executeNextCommand();
		Assert.equals( 1, this._macroExecutor.commandIndex, "'commandIndex' should return 1" );
	}
	
	@Test( "Test hasNextCommandMapping" )
    public function testHasNextCommandMapping() : Void
    {
		Assert.isFalse( this._macroExecutor.hasNextCommandMapping, "'hasNextCommandMapping' should return false" );
		this._macroExecutor.add( MockAsyncCommand );
		Assert.isTrue( this._macroExecutor.hasNextCommandMapping, "'hasNextCommandMapping' should return true" );
		this._macroExecutor.executeNextCommand();
		Assert.isFalse( this._macroExecutor.hasNextCommandMapping, "'hasNextCommandMapping' should return false" );
	}
	
	@Async( "Test hasRunEveryCommand" )
    public function testHasRunEveryCommand() : Void
    {
		Assert.isTrue( this._macroExecutor.hasRunEveryCommand, "'hasRunEveryCommand' should return true" );
		this._macroExecutor.add( MockCommand );
		Assert.isFalse( this._macroExecutor.hasRunEveryCommand, "'hasRunEveryCommand' should return false" );
		this._macroExecutor.executeNextCommand();
		Assert.isTrue( this._macroExecutor.hasRunEveryCommand, "'hasRunEveryCommand' should return true" );
		this._macroExecutor.add( MockAsyncCommand );
		Assert.isFalse( this._macroExecutor.hasRunEveryCommand, "'hasRunEveryCommand' should return false" );
		this._macroExecutor.executeNextCommand();
		Timer.delay( MethodRunner.asyncHandler( this._onTestHasRunEveryCommand ), 100 );
	}
	
	@Test( "Test executeNextCommand" )
    public function testExecuteNextCommand() : Void
    {
		this._macroExecutor.add( MockCommand );
		this._macroExecutor.add( MockAsyncCommand );
		var command : ICommand = this._macroExecutor.executeNextCommand();
		Assert.isInstanceOf( command, MockCommand, "command should be typed 'MockCommand'" );
		command = this._macroExecutor.executeNextCommand();
		Assert.isInstanceOf( command, MockAsyncCommand, "command should be typed 'MockCommand'" );
	}
	
	@Test( "Test asyncCommandCalled" )
    public function testAsyncCommandCalled() : Void
    {
		Assert.methodCallThrows( IllegalStateException, this._macroExecutor, this._macroExecutor.asyncCommandCalled, [ new AsyncCommand() ], "asyncCommandCalled should throw IllegalStateException" );
	}
	
	function _onTestHasRunEveryCommand() : Void
	{
		Assert.isTrue( this._macroExecutor.hasRunEveryCommand, "'hasRunEveryCommand' should return true" );
	}
	
	@Test( "Test add" )
    public function testAdd() : Void
    {
		Assert.isFalse( this._macroExecutor.hasNextCommandMapping, "'hasNextCommandMapping' should return false" );
		
		var commandMapping : ICommandMapping = this._macroExecutor.add( MockAsyncCommand );
		Assert.equals( MockAsyncCommand, commandMapping.getCommandClass(), "'add' should return expected mapping with right same command class" );
		Assert.equals( 0, this._macroExecutor.commandIndex, "'commandIndex' should return 0" );
		Assert.isTrue( this._macroExecutor.hasNextCommandMapping, "'hasNextCommandMapping' should return true" );
		Assert.isFalse( this._macroExecutor.hasRunEveryCommand, "'hasRunEveryCommand' should return false" );
	}
	
	@Test( "Test add mapping" )
    public function testAddMapping() : Void
    {
		Assert.isFalse( this._macroExecutor.hasNextCommandMapping, "'hasNextCommandMapping' should return false" );
		
		var commandMapping = new CommandMapping( MockAsyncCommand );
		var returnedCommandMapping : ICommandMapping = this._macroExecutor.addMapping( commandMapping );
		Assert.equals( commandMapping, returnedCommandMapping, "'addMapping' should return ethe same command mapping" );
		Assert.equals( 0, this._macroExecutor.commandIndex, "'commandIndex' should return 0" );
		Assert.isTrue( this._macroExecutor.hasNextCommandMapping, "'hasNextCommandMapping' should return true" );
		Assert.isFalse( this._macroExecutor.hasRunEveryCommand, "'hasRunEveryCommand' should return false" );
	}
	
	@Test( "Test command execution" )
    public function testExecuteCommand() : Void
    {
		var commandMapping = new CommandMapping( MockAsyncCommandForTestingExecution );
		
		var listener0 			= new ASyncCommandListener();
		var listener1 			= new ASyncCommandListener();
		var listener2 			= new ASyncCommandListener();
		
		var completeHandlers 	: Array<AsyncCommand->Void> 	= [ listener0.onAsyncCommandComplete, listener1.onAsyncCommandComplete, listener2.onAsyncCommandComplete, this._mockMacro.onAsyncCommandComplete ];
		var failHandlers 		: Array<AsyncCommand->Void> 	= [ listener0.onAsyncCommandFail, listener1.onAsyncCommandFail, listener2.onAsyncCommandFail, this._mockMacro.onAsyncCommandFail ];
		var cancelHandlers 		: Array<AsyncCommand->Void> 	= [ listener0.onAsyncCommandCancel, listener1.onAsyncCommandCancel, listener2.onAsyncCommandCancel, this._mockMacro.onAsyncCommandCancel ];
		
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
		commandMapping.withPayloads( [mockPayload] );
		
		var stringPayload 				= new ExecutionPayload( "test", String, "stringPayload" );
		var anotherMockImplementation 	= new MockImplementation( "anotherMockImplementation" );
		var anotherMockPayload 			= new ExecutionPayload( anotherMockImplementation, IMockType, "anotherMockPayload" );
		var payloads 					: Array<ExecutionPayload> 	= [ stringPayload, anotherMockPayload ];
		
		var request = new Request( payloads );
		var command : ICommand = this._macroExecutor.executeCommand( commandMapping, request );
		
		Assert.isNotNull( command, "'command' should not be null" );
		Assert.isInstanceOf( command, MockAsyncCommandForTestingExecution, "'command' shouldbe typed 'MockAsyncCommandForTestingExecution'" );
		
		Assert.equals( 1, MockAsyncCommandForTestingExecution.executeCallCount, "preExecute should be called once" );
		Assert.equals( 1, MockAsyncCommandForTestingExecution.preExecuteCallCount, "execute should be called once" );
		
		Assert.equals( request, MockAsyncCommandForTestingExecution.request, "request should be the same" );
		
		Assert.deepEquals( request, MockAsyncCommandForTestingExecution.request, "request should be the same" );
		
		Assert.arrayContainsElementsFrom( completeHandlers, MockAsyncCommandForTestingExecution.completeHandlers, "complete handlers should be added to async command instance" );
		Assert.arrayContainsElementsFrom( failHandlers, MockAsyncCommandForTestingExecution.failHandlers, "fail handlers should be added to async command instance" );
		Assert.arrayContainsElementsFrom( cancelHandlers, MockAsyncCommandForTestingExecution.cancelHandlers, "cancel handlers should be added to async command instance" );
		
		Assert.equals( 1, this._injector.getOrCreateNewInstanceCallCount, "'injector.getOrCreateNewInstance' method should be called once" );
		Assert.equals( MockAsyncCommandForTestingExecution, this._injector.getOrCreateNewInstanceCallParameter, "'injector.getOrCreateNewInstance' parameter should be command class" );
		
		Assert.deepEquals( 	[ [mockImplementation, IMockType, "mockPayload"], ["test", String, "stringPayload"], [anotherMockImplementation, IMockType, "anotherMockPayload"] ], 
									this._injector.mappedPayloads,
									"'CommandExecutor.mapPayload' should map right values" );
									
		Assert.deepEquals( 	[ [IMockType, "mockPayload"], [String, "stringPayload"], [IMockType, "anotherMockPayload"] ], 
									this._injector.unmappedPayloads,
									"'CommandExecutor.unmapPayload' should unmap right values" );
	}
	
	@Test( "Test command execution with approved guards" )
    public function testExecuteCommandWithApprovedGuards() : Void
    {
		var commandMapping = new CommandMapping( MockCommand ).withGuards( [thatWillBeApproved] );
		var command : ICommand = this._macroExecutor.executeCommand( commandMapping );
		Assert.isNotNull( command, "'command' should not be null" );
		Assert.isInstanceOf( command, MockCommand, "'command' shouldbe typed 'MockCommand'" );
	}
	
	@Test( "Test command execution with refused guards" )
    public function testExecuteCommandWithRefusedGuards() : Void
    {
		var failListener = new MockMacroFailListener();
		this._macroExecutor.setAsyncCommandListener( failListener );
		
		var commandMapping = new CommandMapping( MockCommand ).withGuards( [thatWillBeRefused] );
		var command : ICommand = this._macroExecutor.executeCommand( commandMapping );
		Assert.isNull( command, "'command' should be null" );
		Assert.equals( 1, failListener.onAsyncCommandFailCallCount, "'onAsyncCommandFail' method should be called once" );
	}
	
	public function thatWillBeApproved() : Bool
	{
		return true;
	}

	public function thatWillBeRefused() : Bool
	{
		return false;
	}
	
	@Test( "Test command execution with mapping results" )
    public function textExecuteCommandWithMappingResults() : Void
    {
		var mapping : ICommandMapping = this._macroExecutor.add( MockCommandWithReturnedPayload );
		var mappingWithMappingResults : ICommandMapping = this._macroExecutor.add( MockCommandUsingMappingResults ).withMappingResults( [ mapping ] );
		
		var request = new Request();
		this._macroExecutor.executeCommand( mapping, request );
		this._macroExecutor.executeCommand( mappingWithMappingResults, request );
		
		Assert.deepEquals( 	[ ["s", String, ""] ], this._injector.mappedPayloads, "'CommandExecutor.mapPayload' should map right values" );
	}
}

private class MockCommandWithReturnedPayload extends BasicCommand
{
	public function new()
	{
		super();
	}
	
	public function execute( ?request : Request ) : Void 
	{
		
	}
	
	override public function getReturnedExecutionPayload():Array<ExecutionPayload> 
	{
		return [ new ExecutionPayload( "s", String ) ];
	}
}

private class MockCommandUsingMappingResults extends BasicCommand
{
	@Inject
	public var value : String;
	
	public function new()
	{
		super();
	}
	
	public function execute( ?request : Request ) : Void 
	{
		
	}
}

private class MockAsyncCommandForTestingExecution extends MockAsyncCommand
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
	
	override public function preExecute( ?request : Request ) : Void 
	{
		MockAsyncCommandForTestingExecution.preExecuteCallCount++;
	}
	
	override public function execute( ?request : Request ) : Void 
	{
		MockAsyncCommandForTestingExecution.executeCallCount++;
		MockAsyncCommandForTestingExecution.request = request;
	}
	
	override public function addCompleteHandler( callback : AsyncCommand->Void ) : Void
	{
		MockAsyncCommandForTestingExecution.completeHandlers.push( callback );
	}
	
	override public function addFailHandler( callback : AsyncCommand->Void ) : Void
	{
		MockAsyncCommandForTestingExecution.failHandlers.push( callback );
	}
	
	override public function addCancelHandler( callback : AsyncCommand->Void ) : Void
	{
		MockAsyncCommandForTestingExecution.cancelHandlers.push( callback );
	}
}

private class MockAsyncCommand extends AsyncCommand
{
	public function execute( ?request : Request ) : Void 
	{
		Timer.delay( this._handleComplete, 50 );
	}
}

private class MockCommand implements ICommand
{
	var _owner : IModule;
	
	public var executeMethodName( default, null ) : String = "execute";
	
	public function new()
	{
		
	}
	
	public function getLogger() : ILogger
	{
		return this.getOwner().getLogger();
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
		return this._owner;
	}
	
	public function setOwner( owner : IModule ) : Void 
	{
		this._owner = owner;
	}
}

private class MockMacroFailListener extends ASyncCommandListener
{
	public var onAsyncCommandFailCallCount : Int = 0;
	public var failCommand : IAsyncCommand;
	
	override public function onAsyncCommandFail( cmd : IAsyncCommand ) : Void 
	{
		this.onAsyncCommandFailCallCount++;
		this.failCommand = cmd;
	}
}

private class MockMacroListener extends ASyncCommandListener
{
	var _macroExecutor : IMacroExecutor;
	
	public function new( macroExecutor : IMacroExecutor )
	{
		this._macroExecutor = macroExecutor;
		super();
	}
	
	override public function onAsyncCommandComplete( cmd : IAsyncCommand ) : Void
	{
		this._macroExecutor.asyncCommandCalled( cmd );
	}
	
	override public function onAsyncCommandFail( cmd : IAsyncCommand ) : Void
	{
		this._macroExecutor.asyncCommandCalled( cmd );
	}
	
	override public function onAsyncCommandCancel( cmd : IAsyncCommand ) : Void 
	{
		this._macroExecutor.asyncCommandCalled( cmd );
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