package hex.control.command;

import hex.control.payload.ExecutionPayload;

/**
 * ...
 * @author Francis Bourre
 */
class MockCommand extends BasicCommand
{
	static public var executionCount : UInt;
	
	public function new()
	{
		super();
	}
	
	public function execute( ?request : Request ) : Void 
	{
		MockCommand.executionCount++;
	}
	
	override public function getReturnedExecutionPayload():Array<ExecutionPayload> 
	{
		return [ new ExecutionPayload( "s", String ) ];
	}
}