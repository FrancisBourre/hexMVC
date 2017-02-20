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
class RequestTestWithEnumMapped 
{
	@Test( "Test payloads mapping with enum" )
	public function testRequestWithEnum() : Void
	{
		var e = MockEnum.TEST;
		var module = new MockModule( e );
		
		Assert.equals( 1, MockCommand.executionCount );
		Assert.equals( e, MockCommand.executionPayload );
	}
}

private class MockModule extends Module
{
	static public inline var TEST = new MessageType( 'test' );

	public function new( e : MockEnum )
	{
		super();
		this._addStatelessConfigClasses( [MockCommandConfig] );
		this._dispatchPrivateMessage( TEST, 
			new Request( [new ExecutionPayload( e ).withClassName( 'hex.control.MockEnum' )] ) );
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
	static public var executionPayload	: MockEnum;
	
	@Inject
	public var payload : MockEnum;
	
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