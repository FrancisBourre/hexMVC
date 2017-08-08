package hex.module;

import hex.log.ILogger;
import hex.di.IDependencyInjector;
import hex.core.ICoreFactory;
import hex.event.MessageType;

import hex.core.IApplicationContext;
import hex.domain.Domain;

/**
 * ...
 * @author Francis Bourre
 */
class MockApplicationContext implements IApplicationContext
{
	public function new() 
	{
		
	}
	
	public function getName() : String 
	{
		return null;
	}
	
	public function getDomain() : Domain 
	{
		return null;
	}
	
	public function dispatch( messageType : MessageType, ?data : Array<Dynamic> ) : Void 
	{
		
	}
	
	public function getCoreFactory() : ICoreFactory 
	{
		return null;
	}
	
	public function getInjector() : IDependencyInjector 
	{
		return null;
	}
	
	public var isInitialized( get, null ) : Bool;
	function get_isInitialized() : Bool 
	{
		return isInitialized;
	}
	
	public var isReleased( get, null ) : Bool;
	function get_isReleased() : Bool 
	{
		return isReleased;
	}
	
	public function initialize( context : IApplicationContext ) : Void 
	{
		
	}
	
	public function release():Void 
	{
		
	}
	
	public function getLogger() : ILogger 
	{
		return null;
	}
}