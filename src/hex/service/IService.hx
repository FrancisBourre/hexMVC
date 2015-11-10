package hex.service;

import hex.event.IEvent;

/**
 * @author Francis Bourre
 */
interface IService 
{
	function addHandler( eventType : String, handler : IEvent->Void ) : Void;

	function removeHandler( eventType : String, handler : IEvent->Void ) : Void;
		
	function getConfiguration() : ServiceConfiguration;

	function setConfiguration( configuration : ServiceConfiguration ) : Void;
}