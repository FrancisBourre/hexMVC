package hex.control.trigger.mock;

import haxe.Timer;
import hex.control.trigger.Command;

/**
 * ...
 * @author Francis Bourre
 */
class MockGetUserPrivilege extends Command<Bool>
{
	public function new() 
	{
		super();
	}
	
	override public function execute() : Void 
	{
		Timer.delay( this._complete.bind( true ), 50 );
	}
}