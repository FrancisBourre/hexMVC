package hex.service;

import hex.event.IEvent;

/**
 * @author Francis Bourre
 */
interface IService<EventClass:ServiceEvent> 
{
	function createConfiguration() : Void;
	
	function addHandler( eventType : String, handler : EventClass->Void ) : Void;

	function removeHandler( eventType : String, handler : EventClass->Void ) : Void;
		
	function getConfiguration() : ServiceConfiguration;

	function setConfiguration( configuration : ServiceConfiguration ) : Void;
}