package hex.module;

import hex.di.IBasicInjector;
import hex.domain.Domain;
import hex.event.MessageType;
import hex.log.ILogger;
import hex.module.IModule;

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
	
	public function dispatchPublicMessage( messageType : MessageType, ?data : Array<Dynamic> ) : Void
	{
		
	}
	
	public function addHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void
	{
		
	}
	
	public function removeHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void
	{
		
	}
	
	public function getDomain() : Domain 
	{
		return null;
	}
	
	public function getBasicInjector() : IBasicInjector
	{
		return null;
	}
	
	public function getLogger() : ILogger
	{
		return null;
	}
}