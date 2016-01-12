package hex.control.macro;

import haxe.Timer;
import hex.control.async.AsyncCommand;
import hex.control.async.IAsyncCommand;
import hex.control.async.IAsyncCommandListener;
import hex.control.command.CommandMapping;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.control.macro.IMacroExecutor;
import hex.control.macro.Macro;
import hex.control.macro.MacroExecutor;
import hex.control.Request;
import hex.error.IllegalStateException;
import hex.error.NullPointerException;
import hex.error.VirtualMethodException;
import hex.log.Stringifier;
import hex.MockDependencyInjector;
import hex.module.IModule;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class MacroTest
{
	private var _macro 			: Macro;
	private var _macroExecutor 	: MockMacroExecutor;

    @setUp
    public function setUp() : Void
    {
        this._macro 					= new MockMacro();
		this._macroExecutor 			= new MockMacroExecutor();
		this._macro.macroExecutor 		= this._macroExecutor;
		MockCommand.executeCallCount 	= 0;
    }

    @tearDown
    public function tearDown() : Void
    {
        this._macro 		= null;
		this._macroExecutor = null;
    }
	
	@test( "Test atomic property" )
	public function testIsAtomic() : Void
	{
		Assert.isTrue( this._macro.isAtomic, "'isAtomic' should return true" );

		this._macro.isAtomic = false;
		Assert.isFalse( this._macro.isAtomic, "'isAtomic' should return false" );

		this._macro.isAtomic = true;
		Assert.isTrue( this._macro.isAtomic, "'isAtomic' should return true" );
	}
	
	@test( "Test parallel and sequence modes" )
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
	
	@test( "Test preExecute without overriding prepare" )
	public function testPreExecute() : Void
	{
		var myMacro : MockEmptyMacro = new MockEmptyMacro();
		
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
	
	@test( "Test addComand" )
	public function testAddCommand() : Void
	{
		this._macroExecutor.returnedMapping = new CommandMapping( MockCommand );
		var commandMapping : ICommandMapping = this._macro.add( MockCommand );
		Assert.equals( this._macroExecutor.returnedMapping, commandMapping, "command mapping should be returned when command class is added" );
		Assert.equals( MockCommand, this._macroExecutor.lastCommandClassAdded, "command class should be passed to macroexecutor" );
	}
	
	@test( "Test addMapping" )
	public function testAddMapping() : Void
	{
		this._macroExecutor.returnedMapping = new CommandMapping( MockCommand );
		
		var mappingToAdd : CommandMapping = new CommandMapping( MockCommand );
		var commandMapping : ICommandMapping = this._macro.addMapping( mappingToAdd );
		Assert.equals( this._macroExecutor.returnedMapping, commandMapping, "command mapping should be returned when mapping is added" );
		Assert.equals( mappingToAdd, this._macroExecutor.lastMappingAdded, "mapping added should be passed to macroexecutor" );
	}
	
	@test( "Test execute empty macro" )
	public function testExecuteEmptyMacro() : Void
	{
		var myMacro : MockEmptyMacroWithPrepareOverriden = new MockEmptyMacroWithPrepareOverriden();
		myMacro.macroExecutor = this._macroExecutor;
		
		Assert.methodCallThrows( IllegalStateException, myMacro, myMacro.execute, [], "Macro should throw IllegalStateException when calling execute without calling preExecute before" );
		myMacro.preExecute();
		
		var request : Request = new Request();
		myMacro.execute( request );
		Assert.equals( request, this._macroExecutor.requestPassedDuringExecution, "request passed to execute should be passed to macroexecutor" );
		
		var anotherRequest : Request = new Request();
		myMacro.execute( anotherRequest );
		Assert.equals( anotherRequest, this._macroExecutor.requestPassedDuringExecution, "request passed to execute should be passed to macroexecutor" );
	}
	
	@test( "Test execute triggers 'handleComplete'" )
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
	
	@test( "Test with guards approved" )
	public function testWithGuardsApproved() : Void
	{
		var myMacro : MockEmptyMacroWithPrepareOverriden = new MockEmptyMacroWithPrepareOverriden();
		var macroExecutor : MacroExecutor = new MacroExecutor();
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
	
	@test( "Test with guards refused" )
	public function testWithGuardsRefused() : Void
	{
		var myMacro : MockEmptyMacroWithPrepareOverriden = new MockEmptyMacroWithPrepareOverriden();
		var macroExecutor : MacroExecutor = new MacroExecutor();
		macroExecutor.injector = new MockDependencyInjector();
		myMacro.macroExecutor = macroExecutor;

		myMacro.preExecute();
		myMacro.add( MockCommand ).withGuards( [thatWillBeRefused] );
		myMacro.execute();
		
		Assert.isTrue( myMacro.hasFailed, "'hasFailed' property should return true" );
		Assert.isFalse( myMacro.hasCompleted, "'hasCompleted' property should return false" );
		Assert.isFalse( myMacro.isCancelled, "'isCancelled' property should return false" );
	}
	
	@test( "Test parallel mode" )
	public function testParallelMode() : Void
	{
		var myMacro : MockEmptyMacroWithPrepareOverriden = new MockEmptyMacroWithPrepareOverriden();
		var macroExecutor : MacroExecutor = new MacroExecutor();
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
	
	@test( "Test sequence mode" )
	public function testSequenceMode() : Void
	{
		var myMacro : MockEmptyMacroWithPrepareOverriden = new MockEmptyMacroWithPrepareOverriden();
		var macroExecutor : MacroExecutor = new MacroExecutor();
		macroExecutor.injector = new MockDependencyInjector();
		myMacro.macroExecutor = macroExecutor;
		
		myMacro.isInSequenceMode = true;
		myMacro.preExecute();
		myMacro.add( MockAsyncCommand );
		myMacro.add( MockCommand );
		
		Assert.equals( 0, MockCommand.executeCallCount, "'execute' method shoud not been called" );
		myMacro.execute();
		Assert.equals( 0, MockCommand.executeCallCount, "'execute' method shoud not been called" );
	}
	
	public function thatWillBeRefused() : Bool
	{
		return false;
	}
}

private class MockAsyncCommand extends AsyncCommand
{
	override public function execute( ?request : Request ) : Void 
	{
		Timer.delay( this._handleComplete, 50 );
	}
}

private class MockCommand implements ICommand
{
	private var _owner : IModule;
	
	static public var executeCallCount : Int = 0;
	
	public function new()
	{
		
	}
	
	/* INTERFACE hex.control.command.ICommand */
	
	public function execute( ?request : Request ) : Void 
	{
		MockCommand.executeCallCount++;
	}
	
	public function getPayload() : Array<Dynamic> 
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
	override private function _prepare() : Void
	{
		
	}
}

private class MockMacro extends Macro
{
	override private function _prepare() : Void
	{
		this.add( MockAsyncCommand );
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
	
	public var subCommandIndex( get, null ) : Int;
	function get_subCommandIndex() : Int 
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