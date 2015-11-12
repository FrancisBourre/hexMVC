package hex.service.stateless;

import hex.service.ServiceEvent;
import hex.service.IService;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessServiceEvent extends ServiceEvent
{
	public inline static var SUCCESS       	: String = "onStatelessServiceSuccess";
    public inline static var ERROR          : String = "onStatelessServiceError";
    public inline static var CANCEL         : String = "onStatelessServiceCancel";
}