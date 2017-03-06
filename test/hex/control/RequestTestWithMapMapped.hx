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
class RequestTestWithMapMapped 
{
	@Test( "Test payloads mapping with Map" )
	public function testRequestWithMap() : Void
	{
		var vo = new Map<String, Int>();
		var module = new MockModule( vo );
		
		Assert.equals( 1, MockCommand.executionCount );
		Assert.equals( vo, MockCommand.executionPayload );
	}
}

private class MockModule extends Module
{
	static public inline var TEST = new MessageType( 'test' );

	public function new( vo : Map<String, Int> )
	{
		super();
		this._addStatelessConfigClasses( [MockCommandConfig] );
		this._dispatchPrivateMessage( TEST, 
			new Request( [new ExecutionPayload( vo ).withClassName( 'Map<String, Int>' )] ) );
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
	static public var executionPayload	: Map<String, Int>;
	
	@Inject
	public var payload : Map<String, Int>;
	
	public function new()
	{
		super();
	}
	
	override public function execute() : Void
	{
		MockCommand.executionCount++;
		MockCommand.executionPayload = this.payload;
	}
}