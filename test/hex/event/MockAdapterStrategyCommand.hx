package hex.event;

import haxe.Timer;
import hex.control.async.AsyncCommand;

/**
 * ...
 * @author Francis Bourre
 */
class MockAdapterStrategyCommand extends AsyncCommand
{
	public function new() 
	{
		super();
	}

	@Inject
	public var message : String;

	override public function execute() : Void
	{
		Timer.delay( this.testAsyncCallback, 50 );
	}
	
	override public function getResult() : Array<Dynamic> 
	{
		return [ message ];
	}

	function testAsyncCallback() : Void
	{
		this._handleComplete();
	}
}