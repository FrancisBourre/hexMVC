package hex.module;

import hex.domain.Domain;
import hex.event.MessageType;

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

    function sendMessageFromDomain( messageType : MessageType, data : Array<Dynamic> ) : Void;

    function addHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void;

    function removeHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void;
	
	function getDomain() : Domain;
}
