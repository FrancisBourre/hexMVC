package hex.module;

import haxe.PosInfos;
import hex.di.IDependencyInjector;
import hex.domain.Domain;
import hex.event.MessageType;
import hex.log.ILogger;
import hex.log.ILoggerContext;
import hex.log.LogLevel;
import hex.log.message.IMessage;
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
	
	public function debug(message:Dynamic, ?params:Array<Dynamic>, ?posInfos:PosInfos):Void 
	{
		
	}
	
	public function debugMessage(message:IMessage, ?posInfos:PosInfos):Void 
	{
		
	}
	
	public function info(message:Dynamic, ?params:Array<Dynamic>, ?posInfos:PosInfos):Void 
	{
		
	}
	
	public function infoMessage(message:IMessage, ?posInfos:PosInfos):Void 
	{
		
	}
	
	public function warn(message:Dynamic, ?params:Array<Dynamic>, ?posInfos:PosInfos):Void 
	{
		
	}
	
	public function warnMessage(message:IMessage, ?posInfos:PosInfos):Void 
	{
		
	}
	
	public function error(message:Dynamic, ?params:Array<Dynamic>, ?posInfos:PosInfos):Void 
	{
		
	}
	
	public function errorMessage(message:IMessage, ?posInfos:PosInfos):Void 
	{
		
	}
	
	public function fatal(message:Dynamic, ?params:Array<Dynamic>, ?posInfos:PosInfos):Void 
	{
		
	}
	
	public function fatalMessage(message:IMessage, ?posInfos:PosInfos):Void 
	{
		
	}
	
	public function log(level:LogLevel, message:Dynamic, ?params:Array<Dynamic>, ?posInfos:PosInfos):Void 
	{
		
	}
	
	public function logMessage(level:LogLevel, message:IMessage, ?posInfos:PosInfos):Void 
	{
		
	}
	
	public function getLevel():LogLevel 
	{
		return LogLevel.OFF;
	}
	
	public function getName():String 
	{
		return null;
	}
	
	public function getContext():ILoggerContext 
	{
		return null;
	}
	
}