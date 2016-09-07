package hex.control.macro;

import haxe.Timer;
import hex.MockDependencyInjector;
import hex.control.Request;
import hex.control.async.AsyncCommand;
import hex.control.async.IAsyncCommand;
import hex.control.async.IAsyncCommandListener;
import hex.control.command.CommandMapping;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.control.macro.IMacroExecutor;
import hex.control.macro.Macro;
import hex.control.macro.MacroExecutor;
import hex.control.payload.ExecutionPayload;
import hex.error.IllegalStateException;
import hex.error.NullPointerException;
import hex.error.VirtualMethodException;
import hex.log.ILogger;
import hex.log.Stringifier;
import hex.module.IModule;
import hex.unittest.assertion.Assert;
import hex.unittest.runner.MethodRunner;

/**
 * ...
 * @author Francis Bourre
 */
class MacroTest
{
	var _macro 			: Macro;
	var _macroExecutor 	: MockMacroExecutor;

    @Before
    public function setUp() : Void
    {
        this._macro 					= new MockMacro();
		this._macroExecutor 			= new MockMacroExecutor();
		this._macro.macroExecutor 		= this._macroExecutor;
		MockCommand.executeCallCount 	= 0;
    }

    @After
    public function tearDown() : Void
    {
        this._macro 		= null;
		this._macroExecutor = null;
    }
	
	@Test( "Test atomic property" )
	public function testIsAtomic() : Void
	{
		Assert.isTrue( this._macro.isAtomic, "'isAtomic' should return true" );

		this._macro.isAtomic = false;
		Assert.isFalse( this._macro.isAtomic, "'isAtomic' should return false" );

		this._macro.isAtomic = true;
		Assert.isTrue( this._macro.isAtomic, "'isAtomic' should return true" );
	}
	
	@Test( "Test parallel and sequence modes" )
	public function testParallelAndSequenceModes() : Void
	{
		Assert.isTrue( this._macro.isInSequenceMode, "'isInSequenceMode' should return true" );
		Assert.isFalse( this._macro.isInParallelMode, "'isInParallelMode' should return false" );

		this._macro.isInSequenceMode = false;
		Assert.isFalse( this._macro.isInSequenceMode, "'isInSequenceMode' should return false" );
		Assert.isTrue( this._macro.isInParallelMode, "'isInParallelMode' should return true" );
		this._macro.isInSequenceMode = true;
		Assert.isTrue( this._macro.isInSequenceMode, "'isInSequenceMode' should return true" );
		Assert.isFalse( this._macro.isInParallelMode, "'isInParallelMode' should return false" );

		this._macro.isInParallelMode = true;
		Assert.isFalse( _macro.isInSequenceMode, "'isInSequenceMode' should return false" );
		Assert.isTrue( _macro.isInParallelMode, "'isInParallelMode' should return true" );
		this._macro.isInParallelMode = false;
		Assert.isTrue( this._macro.isInSequenceMode, "'isInSequenceMode' should return true" );
		Assert.isFalse( this._macro.isInParallelMode, "'isInParallelMode' should return false" );
	}
	
	@Test( "Test preExecute without overriding prepare" )
	public function testPreExecute() : Void
	{
		var myMacro = new MockEmptyMacro();
		
		Assert.isFalse( myMacro.wasUsed, "'wasUsed' property should return false" );
		Assert.isFalse( myMacro.isRunning, "'isRunning' property should return false" );
		Assert.methodCallThrows( NullPointerException, myMacro, myMacro.preExecute, [], "" );
		
		myMacro.macroExecutor = new MockMacroExecutor();
		Assert.isFalse( myMacro.wasUsed, "'wasUsed' property should return false" );
		Assert.isFalse( myMacro.isRunning, "'isRunning' property should return false" );
		Assert.methodCallThrows( VirtualMethodException, myMacro, myMacro.preExecute, [], "" );
		
		Assert.isFalse( myMacro.wasUsed, "'wasUsed' property should return false" );
		Assert.isFalse( myMacro.isRunning, "'isRunning' property should return false" );
		
		Assert.isFalse( this._macro.wasUsed, "'wasUsed' property should return false" );
		Assert.isFalse( this._macro.isRunning, "'isRunning' property should return false" );
		this._macro.preExecute();
		
		Assert.equals( this._macro, this._macroExecutor.listener, "macro should listen macroexecutor" );
		Assert.isTrue( this._macro.wasUsed, "'wasUsed' property should return true" );
		Assert.isTrue( this._macro.isRunning, "'isRunning' property should return true" );
        Assert.methodCallThrows( IllegalStateException, this._macro, this._macro.preExecute,[], "Macro should throw IllegalStateException when calling preExecute method twice" );
	}
	
	@Test( "Test addComand" )
	public function testAddCommand() : Void
	{
		this._macroExecutor.returnedMapping = new CommandMapping( MockCommand );
		var commandMapping : ICommandMapping = this._macro.add( MockCommand );
		Assert.equals( this._macroExecutor.returnedMapping, commandMapping, "command mapping should be returned when command class is added" );
		Assert.equals( MockCommand, this._macroExecutor.lastCommandClassAdded, "command class should be passed to macroexecutor" );
	}
	
	@Test( "Test addMapping" )
	public function testAddMapping() : Void
	{
		this._macroExecutor.returnedMapping = new CommandMapping( MockCommand );
		
		var mappingToAdd = new CommandMapping( MockCommand );
		var commandMapping : ICommandMapping = this._macro.addMapping( mappingToAdd );
		Assert.equals( this._macroExecutor.returnedMapping, commandMapping, "command mapping should be returned when mapping is added" );
		Assert.equals( mappingToAdd, this._macroExecutor.lastMappingAdded, "mapping added should be passed to macroexecutor" );
	}
	
	@Test( "Test execute empty macro" )
	public function testExecuteEmptyMacro() : Void
	{
		var myMacro = new MockEmptyMacroWithPrepareOverriden();
		myMacro.macroExecutor = this._macroExecutor;
		
		Assert.methodCallThrows( IllegalStateException, myMacro, myMacro.execute, [], "Macro should throw IllegalStateException when calling execute without calling preExecute before" );
		
		var request = new Request();
		myMacro.preExecute( request );
		myMacro.execute( request );
		Assert.equals( request, this._macroExecutor.requestPassedDuringExecution, "request passed to execute should be passed to macroexecutor" );
	}
	
	@Test( "Test execute triggers 'handleComplete'" )
	public function testExecuteTriggersHandleComplet() : Void
	{
		this._macroExecutor.hasNextCommandMappingReturnValue 	= false;
		this._macroExecutor.hasRunEveryCommandReturnValue 		= true;
		
		this._macro.preExecute();
		this._macro.execute();
		
		Assert.isFalse( this._macro.isCancelled, "'isCancelled' property should return false" );
		Assert.isFalse( this._macro.hasFailed, "'hasFailed' property should return false" );
		Assert.isFalse( this._macro.isRunning, "'isRunning' property should return false" );
		Assert.isTrue( this._macro.wasUsed, "'wasUsed' property should return true" );
		Assert.isTrue( this._macro.hasCompleted, "'hasCompleted' property should return true" );
	}
	
	@Test( "Test with guards approved" )
	public function testWithGuardsApproved() : Void
	{
		var myMacro = new MockEmptyMacroWithPrepareOverriden();
		var macroExecutor = new MacroExecutor();
		macroExecutor.injector = new MockDependencyInjector();
		myMacro.macroExecutor = macroExecutor;

		myMacro.preExecute();
		myMacro.add( MockCommand ).withGuards( [thatWillBeApproved] );
		myMacro.execute();
		
		Assert.isTrue( myMacro.hasCompleted, "'hasCompleted' property should return true" );
		Assert.isFalse( myMacro.hasFailed, "'hasFailed' property should return false" );
		Assert.isFalse( myMacro.isCancelled, "'isCancelled' property should return false" );
	}
	
	public function thatWillBeApproved() : Bool
	{
		return true;
	}
	
	@Test( "Test with guards refused" )
	public function testWithGuardsRefused() : Void
	{
		var myMacro = new MockEmptyMacroWithPrepareOverriden();
		var macroExecutor = new MacroExecutor();
		macroExecutor.injector = new MockDependencyInjector();
		myMacro.macroExecutor = macroExecutor;

		myMacro.preExecute();
		myMacro.add( MockCommand ).withGuards( [thatWillBeRefused] );
		myMacro.execute();
		
		Assert.isTrue( myMacro.hasFailed, "'hasFailed' property should return true" );
		Assert.isFalse( myMacro.hasCompleted, "'hasCompleted' property should return false" );
		Assert.isFalse( myMacro.isCancelled, "'isCancelled' property should return false" );
	}
	
	@Test( "Test parallel mode" )
	public function testParallelMode() : Void
	{
		var myMacro = new MockEmptyMacroWithPrepareOverriden();
		var macroExecutor = new MacroExecutor();
		macroExecutor.injector = new MockDependencyInjector();
		myMacro.macroExecutor = macroExecutor;
		
		myMacro.isInParallelMode = true;
		myMacro.preExecute();
		myMacro.add( MockAsyncCommand );
		myMacro.add( MockCommand );
		
		Assert.equals( 0, MockCommand.executeCallCount, "'execute' method shoud not been called" );
		myMacro.execute();
		Assert.equals( 1, MockCommand.executeCallCount, "'execute' method shoud have been called once" );
	}
	
	@Async( "Test sequence mode" )
	public function testSequenceMode() : Void
	{
		var myMacro = new MockEmptyMacroWithPrepareOverriden();
		var macroExecutor = new MacroExecutor();
		macroExecutor.injector = new MockDependencyInjector();
		myMacro.macroExecutor = macroExecutor;
		
		myMacro.isInSequenceMode = true;
		myMacro.preExecute();
		myMacro.add( MockAsyncCommand );
		myMacro.add( MockCommand );
		
		Assert.equals( 0, MockCommand.executeCallCount, "'execute' method shoud not been called" );
		myMacro.addCompleteHandler( MethodRunner.asyncHandler( this._onTestSequenceModeComplete, [ myMacro ] ) );
		myMacro.execute();
		Assert.equals( 0, MockCommand.executeCallCount, "'execute' method should not been called" );
	}
	
	function _onTestSequenceModeComplete( command : AsyncCommand, myMacro : Macro ) : Void
	{
		Assert.equals( 1, MockCommand.executeCallCount, "'execute' method should have been called" );
	}
	
	@Async( "Test add command after first run" )
	public function testAddCommandAfterFirstRun() : Void
	{
		var myMacro = new MockMacroWithHandler();
		var macroExecutor = new MacroExecutor();
		macroExecutor.injector = new MockDependencyInjector();
		myMacro.macroExecutor = macroExecutor;
		
		myMacro.addCompleteHandler( MethodRunner.asyncHandler( this._onMacroWithHandlerComplete, [ myMacro ] ) );
		
		myMacro.isInSequenceMode = true;
		myMacro.preExecute();
		
		MockCommand.executeCallCount = 0;
		myMacro.execute();
		
	}
	
	function _onMacroWithHandlerComplete( command : AsyncCommand, myMacro : Macro ) : Void
	{
		Assert.equals( 1, MockCommand.executeCallCount, "the MockCommand should be executed once when it's added during running" );
	}
	
	public function thatWillBeRefused() : Bool
	{
		return false;
	}
	
	@Async( "Test commands get request passed to macro" )
	public function testCommandsGetRequestPassedToMacro() : Void
	{
		MockCommand.lastRequest = null;
		MockAsyncCommand.lastRequest = null;
		
		var myMacro = new MockMacro();
		var macroExecutor = new MacroExecutor();
		macroExecutor.injector = new MockDependencyInjector();
		myMacro.macroExecutor = macroExecutor;
		
		var request = new Request();
		myMacro.addCompleteHandler( MethodRunner.asyncHandler( this._onMacroWithRequestComplete, [ request ] ) );
		
		myMacro.preExecute( request );
		myMacro.execute( request );
		
		Assert.equals( request, MockAsyncCommand.lastRequest, "request should be the same" );
	}
	
	function _onMacroWithRequestComplete( command : AsyncCommand, request : Request ) : Void
	{
		Assert.equals( request, MockCommand.lastRequest, "request should be the same" );
	}
	
	@Test( "Test request is available from prepare method" )
	public function testRequestIsAvailableFromPrepareMethod() : Void
	{
		MockCommand.lastRequest = null;
		MockAsyncCommand.lastRequest = null;
		
		var myMacro = new MockEmptyMacroWithPrepareOverriden();
		var macroExecutor = new MacroExecutor();
		macroExecutor.injector = new MockDependencyInjector();
		myMacro.macroExecutor = macroExecutor;
		
		var request = new Request();
		myMacro.preExecute( request );
		
		Assert.equals( request, myMacro.requestPassedDuringExecution, "request should be available from prepare" );
	}
}

private class MockAsyncCommand extends AsyncCommand
{
	static public var lastRequest : Request;
	
	public function execute( ?request : Request ) : Void 
	{
		MockAsyncCommand.lastRequest = request;
		Timer.delay( this._handleComplete, 50 );
	}
}

private class MockCommand implements ICommand
{
	static public var lastRequest : Request;
	var _owner : IModule;
	
	public var executeMethodName( default, null ) : String = "execute";
	
	static public var executeCallCount : Int = 0;
	
	public function new()
	{
		
	}
	
	public function getLogger() : ILogger
	{
		return this.getOwner().getLogger();
	}
	
	public function execute( ?request : Request ) : Void 
	{
		MockCommand.lastRequest = request;
		MockCommand.executeCallCount++;
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
		return _owner;
	}
	
	public function setOwner( owner : IModule ) : Void 
	{
		this._owner = owner;
	}
}

private class MockEmptyMacro extends Macro
{
	
}

private class MockEmptyMacroWithPrepareOverriden extends Macro
{
	public var requestPassedDuringExecution	: Request;
	
	override function _prepare() : Void
	{
		this.requestPassedDuringExecution = this._request;
	}
}

private class MockMacro extends Macro
{
	override function _prepare() : Void
	{
		this.add( MockAsyncCommand );
		this.add( MockCommand );
	}
}

private class MockMacroWithHandler extends Macro
{
	override function _prepare():Void 
	{
		this.add( MockAsyncCommand ).withCompleteHandlers( this.onCommandComplete );
	}
	
	function onCommandComplete( command: IAsyncCommand ) : Void
	{
		this.add( MockCommand );
	}
}

private class MockMacroExecutor implements IMacroExecutor
{
	public var requestPassedDuringExecution		: Request;
	public var returnedMapping					: ICommandMapping;
	public var lastCommandClassAdded 			: Class<ICommand>;
	public var lastMappingAdded 				: ICommandMapping;
	
	public var listener 						: IAsyncCommandListener;
	
	
	public var hasRunEveryCommandReturnValue 	: Bool = false;
	public var hasNextCommandMappingReturnValue : Bool = true;
	
	public function new()
	{
		
	}
	
	public function add( commandClass : Class<ICommand> ) : ICommandMapping 
	{
		this.lastCommandClassAdded = commandClass;
		return this.returnedMapping;
	}
	
	public function executeNextCommand( ?request : Request ) : ICommand 
	{
		this.requestPassedDuringExecution = request;
		return null;
	}
	
	public var hasNextCommandMapping( get, null ) : Bool;
	function get_hasNextCommandMapping() : Bool 
	{
		return this.hasNextCommandMappingReturnValue;
	}
	
	public function setAsyncCommandListener( listener : IAsyncCommandListener ) : Void 
	{
		this.listener = listener;
	}
	
	public function asyncCommandCalled( asyncCommand : IAsyncCommand ) : Void 
	{
		
	}
	
	public var hasRunEveryCommand( get, null ) : Bool;
	function get_hasRunEveryCommand() : Bool 
	{
		return this.hasRunEveryCommandReturnValue;
	}
	
	public var commandIndex( get, null ) : Int;
	function get_commandIndex() : Int 
	{
		return 0;
	}
	
	public function addMapping( mapping : ICommandMapping ) : ICommandMapping 
	{
		this.lastMappingAdded = mapping;
		return returnedMapping;
	}
	
	public function toString() : String
	{
		return Stringifier.stringify( this );
	}
}