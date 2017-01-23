package hex.control.macro;

#if (!neko || haxe_ver >= "3.3")
import haxe.Timer;
import hex.control.async.AsyncCommand;

/**
 * ...
 * @author Francis Bourre
 */
class MockAsyncCommand extends AsyncCommand
{
	static public var lastRequest : Request;
	
	public function execute( ?request : Request ) : Void 
	{
		MockAsyncCommand.lastRequest = request;
		Timer.delay( this._handleComplete, 50 );
	}
}
#end