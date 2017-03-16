package hex.control.trigger.mock;

import haxe.Timer;
import hex.control.trigger.Command;

/**
 * ...
 * @author Francis Bourre
 */
class MockGetUserAge extends Command<UInt>
{
	@Inject
	public var getAge : Void->UInt;
	
	public function new() 
	{
		super();
	}
	
	override public function execute() : Void 
	{
		Timer.delay( this._complete.bind( getAge() ), 50 );
	}
}