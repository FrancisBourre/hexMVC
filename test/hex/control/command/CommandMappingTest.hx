package hex.control.command;

import hex.control.async.AsyncHandler;
import hex.control.async.IAsyncCommand;
import hex.control.command.CommandMapping;
import hex.control.command.ICommand;
import hex.control.payload.ExecutionPayload;
import hex.log.ILogger;
import hex.module.IModule;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class CommandMappingTest
{
	var _commandMapping : CommandMapping;

    @Before
    public function setUp() : Void
    {
        this._commandMapping = new CommandMapping( MockCommand );
    }

    @After
    public function tearDown() : Void
    {
        this._commandMapping = null;
    }
	
	@Test( "Test getCommandClass" )
    public function testGetCommandClass() : Void
    {
        Assert.equals( MockCommand, this._commandMapping.getCommandClass(), "Command class should be the same" );
    }
	
	@Test( "Test guards" )
    public function testGuards() : Void
    {
        Assert.isFalse( this._commandMapping.hasGuard, "hasGuard should return false" );
		this._commandMapping.withGuards( [1, 2, 3] );
		Assert.isTrue( this._commandMapping.hasGuard, "hasGuard should return true" );
		Assert.deepEquals( [1, 2, 3], this._commandMapping.getGuards(), "guards should be the same" );
    }
	
	@Test( "Test isFiredOnce" )
    public function testIsFireOnce() : Void
    {
        Assert.isFalse( this._commandMapping.isFiredOnce, "isFiredOnce should return false" );
		this._commandMapping.once();
		Assert.isTrue( this._commandMapping.isFiredOnce, "isFiredOnce should return true" );
    }
	
	@Test( "Test payloads" )
    public function testPayloads() : Void
    {
        Assert.isFalse( this._commandMapping.hasPayload, "hasPayload should return false" );
		
		var stringPayload0 	= new ExecutionPayload( "test0", String, "stringPayload0" );
		var stringPayload1 	= new ExecutionPayload( "test1", String, "stringPayload1" );
		var stringPayload2 	= new ExecutionPayload( "test2", String, "stringPayload2" );
		this._commandMapping.withPayloads( [stringPayload0, stringPayload1, stringPayload2] );
		
		Assert.isTrue( this._commandMapping.hasPayload, "hasPayload should return true" );
		Assert.deepEquals( [stringPayload0, stringPayload1, stringPayload2], this._commandMapping.getPayloads(), "payloads should be the same" );
    }
	
	@Test( "Test complete handlers" )
    public function testCompleteHandlers() : Void
    {
        Assert.isFalse( this._commandMapping.hasCompleteHandler, "hasCompleteHandler should return false" );
		
		var listener0 = new MockAsyncCommandListener();
		var listener1 = new MockAsyncCommandListener();
		var listener2 = new MockAsyncCommandListener();
		
		var completeHandler0 	= new AsyncHandler( listener0.handler );
		var completeHandler1 	= new AsyncHandler( listener1.handler );
		var completeHandler2 	= new AsyncHandler( listener2.handler );
		
		this._commandMapping.withCompleteHandlers( completeHandler0 ).withCompleteHandlers( completeHandler1 ).withCompleteHandlers( completeHandler2 );
		
		Assert.isTrue( this._commandMapping.hasCompleteHandler, "hasCompleteHandler should return true" );
		Assert.deepEquals( [completeHandler0, completeHandler1, completeHandler2], this._commandMapping.getCompleteHandlers(), "getCompleteHandlers should be the same" );
    }
	
	@Test( "Test fail handlers" )
    public function testFailHandlers() : Void
    {
        Assert.isFalse( this._commandMapping.hasFailHandler, "hasFailHandler should return false" );
		
		var listener0 = new MockAsyncCommandListener();
		var listener1 = new MockAsyncCommandListener();
		var listener2 = new MockAsyncCommandListener();
		
		var failHandler0 	= new AsyncHandler( listener0.handler );
		var failHandler1 	= new AsyncHandler( listener1.handler );
		var failHandler2 	= new AsyncHandler( listener2.handler );
		this._commandMapping.withFailHandlers( failHandler0 ).withFailHandlers( failHandler1 ).withFailHandlers( failHandler2 );
		
		Assert.isTrue( this._commandMapping.hasFailHandler, "hasFailHandler should return true" );
		Assert.deepEquals( [failHandler0, failHandler1, failHandler2], this._commandMapping.getFailHandlers(), "getFailHandlers should be the same" );
    }
	
	@Test( "Test cancel handlers" )
    public function testCancelHandlers() : Void
    {
        Assert.isFalse( this._commandMapping.hasCancelHandler, "hasCancelHandler should return false" );
		
		var listener0 = new MockAsyncCommandListener();
		var listener1 = new MockAsyncCommandListener();
		var listener2 = new MockAsyncCommandListener();
		
		var cancelHandler0 	= new AsyncHandler( listener0.handler );
		var cancelHandler1 	= new AsyncHandler( listener1.handler );
		var cancelHandler2 	= new AsyncHandler( listener2.handler );
		this._commandMapping.withCancelHandlers( cancelHandler0 ).withCancelHandlers( cancelHandler1 ).withCancelHandlers( cancelHandler2 );
		
		Assert.isTrue( this._commandMapping.hasCancelHandler, "hasCancelHandler should return true" );
		Assert.deepEquals( [cancelHandler0, cancelHandler1, cancelHandler2], this._commandMapping.getCancelHandlers(), "getCancelHandlers should be the same" );
    }
	
	@Test( "Test mappingResults" )
    public function testMappingResults() : Void
    {
        Assert.isFalse( this._commandMapping.hasMappingResult, "'hasMappingResult' should return false" );
		
		var mapping 		= new CommandMapping( MockCommand );
		var anotherMapping 	= new CommandMapping( MockCommand );
		
		Assert.equals( this._commandMapping, this._commandMapping.withMappingResults( [ mapping, anotherMapping ] ), "CommandMapping returned should be the same" );
		Assert.isTrue( this._commandMapping.hasMappingResult, "'hasMappingResult' should return true" );
    }
	
	@Test( "Test setLastCommandInstance" )
    public function testSetLastCommandInstance() : Void
    {
		Assert.isNull( this._commandMapping.getPayloadResult(), "'getPayloadResult' should return null" );
		
		var command = new MockCommand();
		var mapping = new CommandMapping( MockCommand );
		this._commandMapping.withMappingResults( [mapping] );
		Assert.isNull( this._commandMapping.getPayloadResult(), "'getPayloadResult' should return null" );
		
		mapping.setLastCommandInstance( command );
		Assert.deepEquals( MockCommand.returnedExecutionPayload, this._commandMapping.getPayloadResult(), "'getPayloadResult' should return right payloads from last command instance" );
	}
}

private class MockAsyncCommandListener
{
	public function new ()
	{
		
	}
	
	public function handler( command : IAsyncCommand ) : Void
	{
		
	}
}

private class MockCommand implements ICommand
{
	public static var returnedExecutionPayload : Array<ExecutionPayload> = [ new ExecutionPayload( "s", String ) ];
	
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
		return MockCommand.returnedExecutionPayload;
	}
	
	public function getOwner() : IModule 
	{
		return null;
	}
	
	public function setOwner( owner : IModule ) : Void 
	{
		
	}
}