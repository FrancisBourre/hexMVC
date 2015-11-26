package hex.service;

import hex.event.BasicEvent;

/**
 * ...
 * @author Francis Bourre
 */
class ServiceEvent extends BasicEvent
{
	public function new ( eventType : String, target : Dynamic )
    {
        super( eventType, target );
    }
	
	public function getService() : Dynamic
	{
		return cast target;
	}
	
	override public function clone():BasicEvent 
	{
		return new ServiceEvent(this.type, this.target) ;
	}
}