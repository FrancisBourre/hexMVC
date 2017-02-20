package hex.event;

import hex.control.async.AsyncCommand;
import hex.di.IInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class MockAsyncCommand extends AsyncCommand
{
	@Inject
	public var data : MockValueObject;
	
	override public function execute() : Void
    {
		this.data.value += "!";
		this._handleComplete();
	}
}
