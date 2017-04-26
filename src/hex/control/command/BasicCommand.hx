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

	@Inject
	@Optional(true)
	public var logger:ILogger;
	
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
		return (logger == null) ? _owner.getLogger() : logger;
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