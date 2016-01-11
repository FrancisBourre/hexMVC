package hex.control.command;

import hex.control.command.ICommand;
import hex.error.VirtualMethodException;
import hex.event.IEvent;
import hex.module.IModule;


/**
 * ...
 * @author duke
 */
class BasicCommand implements ICommand
{
	private var _owner:IModule;

	public function new() 
	{
		
	}
	
	public function execute(?e:IEvent):Void 
	{
		throw new VirtualMethodException("Override");
	}
	
	public function getPayload():Array<Dynamic> 
	{
		return null;
	}
	
	public function getOwner():IModule 
	{
		return this._owner;
	}
	
	public function setOwner(owner:IModule):Void 
	{
		this._owner = owner;
	}
	
}