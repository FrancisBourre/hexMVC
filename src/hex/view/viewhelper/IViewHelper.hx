package hex.view.viewhelper;

import hex.event.MessageType;
import hex.log.ILogger;
import hex.module.IModule;

/**
 * @author Francis Bourre
 */
interface IViewHelper<ViewType:IView>  
{
	var view( get, set ) : ViewType;
	
	function getOwner() : IModule;
	
	function setOwner( owner : IModule ) : Void;
	
	function getLogger() : ILogger;
	
	function show() : Void;
	
	function hide() : Void;
	
	var visible( get, set ) : Bool;
	
	function release() : Void;
	
	function addHandler<T:haxe.Constraints.Function>( messageType : MessageType, callback : T ) : Void;
	
	function removeHandler<T:haxe.Constraints.Function>( messageType : MessageType, callback : T ) : Void;
}