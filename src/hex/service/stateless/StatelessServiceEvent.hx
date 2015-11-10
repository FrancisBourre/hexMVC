package hex.service.stateless;

import hex.event.BasicEvent;
import hex.service.stateless.StatelessService;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessServiceEvent extends BasicEvent
{
    public inline static var SUCCESS       	: String = "onStatelessServiceSuccess";
    public inline static var ERROR          : String = "onStatelessServiceError";
    public inline static var CANCEL         : String = "onStatelessServiceCancel";
	
	public inline static var TIMEOUT 		: String = "onStatelessServiceTimeout";

    public function new ( eventType : String, target : StatelessService )
    {
        super( eventType, target );
    }
	
	public function getStatelessService() : StatelessService
	{
		return cast target;
	}
}