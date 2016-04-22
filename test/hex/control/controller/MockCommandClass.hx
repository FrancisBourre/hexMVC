package hex.control.controller;

import hex.control.command.BasicCommand;

/**
 * ...
 * @author Francis Bourre
 */
class MockCommandClass extends BasicCommand
{
	public static var lastExecuteParam : String = null;
	
	public function new() 
	{
		super();
	}
	
	public function execute( s : String ) : Void
	{
		MockCommandClass.lastExecuteParam = s;
	}
}