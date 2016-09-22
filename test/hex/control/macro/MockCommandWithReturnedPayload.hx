package hex.control.macro;

import hex.control.command.BasicCommand;
import hex.control.payload.ExecutionPayload;

/**
 * ...
 * @author Francis Bourre
 */
class MockCommandWithReturnedPayload extends BasicCommand
{
	public function new()
	{
		super();
	}
	
	public function execute( ?request : Request ) : Void 
	{
		
	}
	
	override public function getReturnedExecutionPayload():Array<ExecutionPayload> 
	{
		return [ new ExecutionPayload( "s", String ) ];
	}
}