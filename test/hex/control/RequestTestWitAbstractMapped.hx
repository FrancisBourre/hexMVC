package hex.control;

import hex.config.stateless.StatelessCommandConfig;
import hex.control.command.BasicCommand;
import hex.control.payload.ExecutionPayload;
import hex.event.MessageType;
import hex.module.Module;
import hex.structures.Point;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class RequestTestWitAbstractMapped 
{
	@Test( "Test payloads mapping with abstract" )
	public function testRequestWithAbstract() : Void
	{
		var p = new Point( 3, 5 );
		var module = new MockModule( p );
		
		Assert.equals( 1, MockCommand.executionCount );
		Assert.equals( p, MockCommand.executionPayload );
	}
}

private class MockModule extends Module
{
	static public inline var TEST = new MessageType( 'test' );

	public function new( p : Point )
	{
		super();
		this._addStatelessConfigClasses( [MockCommandConfig] );
		this._dispatchPrivateMessage( TEST, 
			new Request( [new ExecutionPayload( p ).withClassName( 'hex.structures.Point' )] ) );
	}
}

private class MockCommandConfig extends StatelessCommandConfig
{
	override public function configure():Void
	{
		this.map( MockModule.TEST, MockCommand );
	}
}

private class MockCommand extends BasicCommand
{
	static public var executionCount 	: UInt = 0;
	static public var executionPayload	: Point;
	
	@Inject
	public var payload : Point;
	
	public function new()
	{
		super();
	}
	
	public function execute( ?request : Request ) : Void 
	{
		MockCommand.executionCount++;
		MockCommand.executionPayload = this.payload;
	}
}