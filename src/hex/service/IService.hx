package hex.service;

import hex.event.IEvent;

/**
 * @author Francis Bourre
 */
interface IService<EventClass:ServiceEvent, ConfigurationClass:ServiceConfiguration> 
{
	function createConfiguration() : Void;
	
	function addHandler( eventType : String, handler : EventClass->Void ) : Void;

	function removeHandler( eventType : String, handler : EventClass->Void ) : Void;
		
	function getConfiguration() : ConfigurationClass;

	function setConfiguration( configuration : ConfigurationClass ) : Void;
}