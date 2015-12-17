package hex.module;

import hex.domain.Domain;
import hex.event.IEvent;
import hex.module.IModule;
import hex.module.ModuleEvent;

/**
 * ...
 * @author Francis Bourre
 */
class MockModule implements IModule
{
	public function new() 
	{
		
	}
	
	public function initialize() : Void 
	{
		this.isInitialized = true;
	}
	
	
	@:isVar public var isInitialized( get, null ) : Bool;
	public function get_isInitialized() : Bool 
	{
		return this.isInitialized;
	}
	
	public function release() : Void 
	{
		this.isReleased = true;
	}
	
	@:isVar public var isReleased( get, null ) : Bool;
	public function get_isReleased() : Bool 
	{
		return this.isReleased;
	}
	
	public function sendExternalEventFromDomain( e : ModuleEvent ) : Void 
	{
		
	}
	
	public function addHandler( type : String, callback : IEvent->Void ) : Void 
	{
		
	}
	
	public function removeHandler( type : String, callback : IEvent->Void ) : Void 
	{
		
	}
	
	public function getDomain() : Domain 
	{
		return null;
	}
}