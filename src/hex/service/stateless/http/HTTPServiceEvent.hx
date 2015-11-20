package hex.service.stateless.http;

import hex.service.ServiceEvent;

/**
 * ...
 * @author Francis Bourre
 */
class HTTPServiceEvent extends ServiceEvent
{
	public function new( eventType : String, target : HTTPService<HTTPServiceEvent> ) 
	{
		super( eventType, target );
	}
}