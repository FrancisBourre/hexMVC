package hex.control.macro;

#if (!neko || haxe_ver >= "3.3")
import haxe.Timer;
import hex.control.async.AsyncCommand;

/**
 * ...
 * @author Francis Bourre
 */
class MockBasicAsyncCommand extends AsyncCommand
{
	override public function execute() : Void
	{
		Timer.delay( this._handleComplete, 50 );
	}
}
#end