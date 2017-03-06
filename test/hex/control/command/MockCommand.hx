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
	
	override public function execute() : Void
	{
		MockCommand.executionCount++;
	}
	
	override public function getReturnedExecutionPayload():Array<ExecutionPayload> 
	{
		return [ new ExecutionPayload( "s", String ) ];
	}
}