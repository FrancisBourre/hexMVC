package hex.control.trigger.mock;

import hex.core.IApplicationContext;
import hex.di.IDependencyInjector;
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
	
	public function initialize( context : IApplicationContext ) : Void 
	{
		
	}
	
	@:isVar public var isInitialized( get, null ) : Bool;
	function get_isInitialized() : Bool
	{
		return false;
	}
	
	public function release() : Void 
	{
		
	}

	@:isVar public var isReleased( get, null ) : Bool;
	public function get_isReleased() : Bool
	{
		return false;
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
	
	public function getInjector() : IDependencyInjector
	{
		return null;
	}
	
	public function getLogger() : ILogger
	{
		return null;
	}
}