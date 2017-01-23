package hex.control.async;

#if (!neko || haxe_ver >= "3.3")
/**
 * ...
 * @author Francis Bourre
 */
class MockAsyncCommand extends AsyncCommand
{
	public function execute( ?request : Request ) : Void
	{
		this._handleComplete();
	}
	
	public function fail() : Void
	{
		this._handleFail();
	}
}
#end