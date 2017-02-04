package hex.control;

import hex.config.stateless.StatelessCommandConfig;
import hex.control.command.BasicCommand;
import hex.control.guard.IGuard;
import hex.control.payload.ExecutionPayload;
import hex.event.MessageType;
import hex.module.Module;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class RequestTestWithGuard 
{
	@Test
	public function testRequestWithGuard() : Void
	{
		var arr : Array<Int> = [ 1, 2, 3 ];
		var module = new MockModule( arr );
		
		Assert.equals( 1, MockCommand.executionCount );
		Assert.equals( arr, MockCommand.executionPayload );
		
		Assert.equals( 0, MockCommandRefused.executionCount );
		Assert.isNull( MockCommandRefused.executionPayload );
	}
}

private class MockModule extends Module
{
	static public inline var TEST 			= new MessageType( 'test' );
	static public inline var TEST_REFUSED 	= new MessageType( 'testRefused' );
	
	public function new( arr : Array<Int> )
	{
		super();
		this._addStatelessConfigClasses( [MockCommandConfig] );
		
		this._dispatchPrivateMessage( TEST, new Request( [new ExecutionPayload( arr, null, 'name' ).withClassName( 'Array<Int>' )] ) );
		this._dispatchPrivateMessage( TEST_REFUSED, new Request( [new ExecutionPayload( arr, null, 'name' ).withClassName( 'Array<Int>' )] ) );
	}
}

private class MockCommandConfig extends StatelessCommandConfig
{
	override public function configure():Void
	{
		this.map( MockModule.TEST, MockCommand ).withGuard( MockGuard );
		this.map( MockModule.TEST_REFUSED, MockCommandRefused ).withGuard( AnotherMockGuard );
	}
}

private class MockGuard implements IGuard
{
	@Inject( 'name' )
	public var collection : Array<Int>;
	
	public function new(){}
	
	public function approve() : Bool
	{
		return this.collection.length == 3;
	}
}

private class AnotherMockGuard implements IGuard
{
	@Inject( 'name' )
	public var collection : Array<Int>;
	
	public function new(){}
	
	public function approve() : Bool
	{
		return this.collection.length == 0;
	}
}

private class MockCommand extends BasicCommand
{
	static public var executionCount 	: UInt = 0;
	static public var executionPayload	: Array<Int>;
	
	@Inject( 'name' )
	public var collection : Array<Int>;
	
	public function new()
	{
		super();
	}
	
	public function execute( ?request : Request ) : Void 
	{
		MockCommand.executionCount++;
		MockCommand.executionPayload = this.collection;
	}
}

private class MockCommandRefused extends MockCommand
{
	static public var executionCount 	: UInt = 0;
	static public var executionPayload	: Array<Int>;
	
	public function new()
	{
		super();
	}
	
	override public function execute( ?request : Request ) : Void 
	{
		MockCommandRefused.executionCount++;
		MockCommandRefused.executionPayload = this.collection;
	}
}