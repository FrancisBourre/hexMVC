package hex.service;

/**
 * @author Francis Bourre
 */
interface IService 
{
	function addHandler( eventType : String, handler : ServiceEvent->Void ) : Void;

	function removeHandler( eventType : String, handler : ServiceEvent->Void ) : Void;
		
	function getConfiguration() : ServiceConfiguration;

	function setConfiguration( configuration : ServiceConfiguration ) : Void;
}