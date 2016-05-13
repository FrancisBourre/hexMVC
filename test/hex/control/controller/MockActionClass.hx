package hex.control.controller;
import hex.control.action.Action;

/**
 * ...
 * @author Francis Bourre
 */
class MockActionClass extends Action<String>
{
	public static var lastExecuteParam : String = null;
	
	public function new() 
	{
		super();
	}
	
	public function execute( s : String ) : Void
	{
		MockActionClass.lastExecuteParam = s;
	}
}