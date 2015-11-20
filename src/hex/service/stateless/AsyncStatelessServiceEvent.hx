package hex.service.stateless;
import hex.service.ServiceEvent;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncStatelessServiceEvent extends ServiceEvent
{
	public inline static var TIMEOUT : String = "onStatelessServiceTimeout";
	
	public function new( eventType : String, target : AsyncStatelessService<AsyncStatelessServiceEvent> ) 
	{
		super( eventType, target );
	}
}