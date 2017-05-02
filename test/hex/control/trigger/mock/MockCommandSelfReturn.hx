package hex.control.trigger.mock;
import hex.control.async.Nothing;
import hex.control.trigger.Command;

/**
 * ...
 * @author 
 */
class MockCommandSelfReturn extends Command<MockCommandSelfReturn>
{

	override public function execute():Void 
	{
		_complete(this);
	}
	
}