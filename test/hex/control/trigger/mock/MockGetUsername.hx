package hex.control.trigger.mock;

import haxe.Timer;
import hex.control.trigger.Command;

/**
 * ...
 * @author Francis Bourre
 */
class MockGetUsername extends Command<String>
{
	public function new() 
	{
		super();
	}
	
	override public function execute() : Void 
	{
		Timer.delay( this._complete.bind( 'John Doe' ), 50 );
	}
}