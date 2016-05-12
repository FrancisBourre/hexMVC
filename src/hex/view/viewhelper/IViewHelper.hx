package hex.view.viewhelper;

import hex.event.MessageType;
import hex.log.ILogger;
import hex.module.IModule;

/**
 * @author Francis Bourre
 */
interface IViewHelper 
{
	var view( get, set ) : IView;
	
	function getOwner() : IModule;
	
	function setOwner( owner : IModule ) : Void;
	
	function getLogger() : ILogger;
	
	function show() : Void;
	
	function hide() : Void;
	
	var visible( get, set ) : Bool;
	
	function release() : Void;
	
	function addHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void;
	
	function removeHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void;
}