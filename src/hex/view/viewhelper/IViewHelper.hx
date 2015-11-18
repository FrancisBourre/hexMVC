package hex.view.viewhelper;

import hex.module.IModule;

/**
 * @author Francis Bourre
 */
interface IViewHelper 
{
	var view( get, set ) : IView;
	
	function getOwner() : IModule;
	
	function setOwner( owner : IModule ) : Void;
	
	function show() : Void;
	
	function hide() : Void;
	
	var visible( get, set ) : Bool;
	
	function release() : Void;
	
	function addEventListener( eventType : String, callback : ViewHelperEvent->Void ) : Void;
	
	function removeEventListener( eventType : String, callback : ViewHelperEvent->Void ) : Void;
}