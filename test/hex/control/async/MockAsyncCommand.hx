package hex.control.async;

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