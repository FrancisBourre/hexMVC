package hex.control;

import hex.config.stateless.StatelessCommandConfig;
import hex.control.command.BasicCommand;
import hex.control.guard.IGuard;
import hex.control.payload.ExecutionPayload;
import hex.di.IInjectorContainer;
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
		var module = new MockModule();
		Assert.equals( 1, MockCommand.executionCount );
	}
}

private class MockModule extends Module
{
	static public inline var TEST = new MessageType( 'test' );
	
	public function new()
	{
		super();
		this._addStatelessConfigClasses( [MockCommandConfig] );
		var arr : Array<Int> = [ 1, 2, 3 ];
		var request = new Request( [new ExecutionPayload( arr, null, 'name' ).withClassName( 'Array<Int>' )] );
		this._dispatchPrivateMessage( TEST, [ request ] );
	}
}

private class MockCommandConfig extends StatelessCommandConfig
{
	override public function configure():Void
	{
		this.map( MockModule.TEST, MockCommand ).withGuard( MockGuard );
	}
}

private class MockGuard implements IGuard implements IInjectorContainer
{
	@Inject( 'name' )
	public var collection : Array<Int>;
	
	public function approve() : Bool
	{
		return this.collection.length == 3;
	}
}

private class MockCommand extends BasicCommand
{
	static public var executionCount : UInt = 0;
	
	public function new()
	{
		super();
	}
	
	public function execute( ?request : Request ) : Void 
	{
		MockCommand.executionCount++;
	}
}