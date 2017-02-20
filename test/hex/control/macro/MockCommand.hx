package hex.control.macro;

import hex.control.command.ICommand;
import hex.control.payload.ExecutionPayload;
import hex.log.ILogger;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
class MockCommand implements ICommand
{
	var _owner : IModule;
	
	public var executeMethodName( default, null ) : String = "execute";
	
	static public var executeCallCount : Int = 0;
	
	public function new()
	{
		
	}
	
	public function getLogger() : ILogger
	{
		return this.getOwner().getLogger();
	}
	
	public function execute() : Void
	{
		MockCommand.executeCallCount++;
	}
	
	public function getResult() : Array<Dynamic> 
	{
		return null;
	}
	
	public function getReturnedExecutionPayload() : Array<ExecutionPayload>
	{
		return null;
	}
	
	public function getOwner() : IModule 
	{
		return _owner;
	}
	
	public function setOwner( owner : IModule ) : Void 
	{
		this._owner = owner;
	}
}