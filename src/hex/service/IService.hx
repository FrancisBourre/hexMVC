package hex.service;

import hex.event.MessageType;

/**
 * @author Francis Bourre
 */
interface IService
{
	function createConfiguration() : Void;
	
	function addHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void;

	function removeHandler( messageType : MessageType, scope : Dynamic, callback : Dynamic ) : Void;
		
	function getConfiguration() : ServiceConfiguration;

	function setConfiguration( configuration : ServiceConfiguration ) : Void;
	
	function removeAllListeners():Void;
}