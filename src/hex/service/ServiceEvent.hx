package hex.service;

import hex.event.BasicEvent;

/**
 * ...
 * @author Francis Bourre
 */
class ServiceEvent extends BasicEvent
{
	public function new ( eventType : String, target : IService )
    {
        super( eventType, target );
    }
	
	public function getService() : IService
	{
		return cast target;
	}
}