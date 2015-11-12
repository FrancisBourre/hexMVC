package hex.service.stateless;

import hex.service.ServiceEvent;
import hex.service.IService;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessServiceEvent extends ServiceEvent
{
	public inline static var COMPLETE       : String = "onStatelessServiceComplete";
    public inline static var FAIL 			: String = "onStatelessServiceFail";
    public inline static var CANCEL         : String = "onStatelessServiceCancel";
}