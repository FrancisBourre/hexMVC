package hex.module;

import haxe.PosInfos;
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
	var _logger : ILogger;

	public function new() 
	{
		this._logger = new MockLogger();
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
	
	public function getInjector() : IDependencyInjector
	{
		return null;
	}
	
	public function getLogger() : ILogger
	{
		return this._logger;
	}
}

private class MockLogger implements ILogger
{

	public function new() 
	{

	}
	
	public function clear() : Void
	{
		
	}
	
	public function debug( o : Dynamic, ?posInfos : PosInfos ) : Void
	{
		
	}
	
	public function info( o : Dynamic, ?posInfos : PosInfos ) : Void
	{
		
	}
	
	public function warn( o : Dynamic, ?posInfos : PosInfos ) : Void
	{
		
	}
	
	public function error( o : Dynamic, ?posInfos : PosInfos ) : Void
	{
		
	}
	
	public function fatal( o : Dynamic, ?posInfos : PosInfos ) : Void
	{
		
	}
	
	public function getDomain() : Domain
	{
		return null;
	}
}