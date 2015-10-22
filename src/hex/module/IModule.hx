package hex.module;

import hex.domain.Domain;
import hex.event.IEvent;
import hex.di.IDependencyInjector;

import hex.domain.Domain;
/**
 * ...
 * @author Francis Bourre
 */
interface IModule
{
    function initialize() : Void;

    var isInitialized( get, null ) : Bool;
	
	function release() : Void;

	var isReleased( get, null ) : Bool;

    function sendExternalEventFromDomain( e : ModuleEvent ) : Void;

    function addHandler( type : String, callback : IEvent->Void ) : Void;

    function removeHandler( type : String, callback : IEvent->Void ) : Void;
}
