package hex.control.async;

/**
 * ...
 * @author Francis Bourre
 */
class MockAsyncCommand extends AsyncCommand
{
	override public function execute() : Void
	{
		this._handleComplete();
	}
	
	public function fail() : Void
	{
		this._handleFail();
	}
}