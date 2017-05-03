package hex.control.trigger.mock;
import hex.control.async.Nothing;
import hex.control.trigger.MacroCommand;

/**
 * ...
 * @author 
 */
class MockMacroCommandWithChildCommand extends MacroCommand<Nothing>
{

	public var commandSelfReturn:MockCommandSelfReturn;
	
	override function _prepare():Void 
	{
		add(MockCommandSelfReturn).withCompleteHandler(function(command){
			commandSelfReturn = command;
		});
	}
	
}