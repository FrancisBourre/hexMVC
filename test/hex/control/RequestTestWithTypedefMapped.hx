package hex.control;

import hex.config.stateless.StatelessCommandConfig;
import hex.control.command.BasicCommand;
import hex.control.payload.ExecutionPayload;
import hex.event.MessageType;
import hex.module.Module;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class RequestTestWithTypedefMapped 
{
	@Test( "Test payloads mapping with typedef" )
	public function testRequestWithTypedef() : Void
	{
		var vo = { userName: "test" };
		var module = new MockModule( vo );
		
		Assert.equals( 1, MockCommand.executionCount );
		Assert.equals( vo, MockCommand.executionPayload );
	}
}

private class MockModule extends Module
{
	static public inline var TEST = new MessageType( 'test' );

	public function new( vo : MockTypedef )
	{
		super();
		this._addStatelessConfigClasses( [MockCommandConfig] );
		this._dispatchPrivateMessage( TEST, 
			new Request( [new ExecutionPayload( vo ).withClassName( 'hex.control.MockTypedef' )] ) );
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
	static public var executionPayload	: MockTypedef;
	
	@Inject
	public var payload : MockTypedef;
	
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