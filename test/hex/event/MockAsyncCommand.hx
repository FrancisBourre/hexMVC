package hex.event;

import haxe.web.Request;
import hex.control.async.AsyncCommand;
import hex.di.IInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class MockAsyncCommand extends AsyncCommand implements IInjectorContainer
{
	@Inject
	public var data : MockValueObject;
	
	public function execute( ?request : Request ) : Void
    {
		this.data.value += "!";
		this._handleComplete();
	}
}