package hex.control.command;

import hex.control.command.ICommand;
import hex.control.payload.ExecutionPayload;
import hex.di.IInjectorContainer;
import hex.log.ILogger;
import hex.module.IModule;

/**
 * ...
 * @author duke
 */
class BasicCommand implements ICommand implements IInjectorContainer
{
	var _owner : IModule;
	
	public var executeMethodName( default, null ) : String = "execute";

	public function new() 
	{
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
	
	public function getOwner() : IModule 
	{
		return this._owner;
	}
	
	public function setOwner( owner : IModule ) : Void 
	{
		this._owner = owner;
	}
}