package hex.control.command;

import hex.control.command.ICommand;
import hex.control.payload.ExecutionPayload;
import hex.di.IInjectorContainer;
import hex.error.VirtualMethodException;
import hex.log.ILogger;
import hex.module.IContextModule;

/**
 * ...
 * @author duke
 */
class BasicCommand implements ICommand implements IInjectorContainer
{
	var _owner : IContextModule;

	public function new() 
	{
	}
	
	public function execute() : Void
	{
		throw new VirtualMethodException();
	}
	
	public function getResult() : Array<Dynamic> 
	{
		return null;
	}
	
	public function getReturnedExecutionPayload() : Array<ExecutionPayload>
	{
		return null;
	}
	
	public function getLogger() : ILogger 
	{
		return this._owner.getLogger();
	}
	
	public function getOwner() : IContextModule 
	{
		return this._owner;
	}
	
	public function setOwner( owner : IContextModule ) : Void 
	{
		this._owner = owner;
	}
}