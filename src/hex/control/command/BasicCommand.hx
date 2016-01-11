package hex.control.command;

import hex.control.command.ICommand;
import hex.control.Request;
import hex.error.VirtualMethodException;
import hex.module.IModule;

/**
 * ...
 * @author duke
 */
class BasicCommand implements ICommand
{
	private var _owner : IModule;

	public function new() 
	{
		
	}
	
	public function execute( ?request : Request ) : Void 
	{
		throw new VirtualMethodException( this + ".execute must be overridden" );
	}
	
	public function getPayload() : Array<Dynamic> 
	{
		return null;
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