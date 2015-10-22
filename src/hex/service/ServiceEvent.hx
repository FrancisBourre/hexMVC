package hex.service;

import hex.event.BasicEvent;

/**
 * ...
 * @author Francis Bourre
 */
class ServiceEvent extends BasicEvent
{
    public inline static var SUCCESS       	: String = "onServiceComplete";
    public inline static var ERROR          : String = "onServiceFail";
    public inline static var CANCEL         : String = "onServiceCancel";

    public function new ( eventType : String, target : IService )
    {
        super( eventType, target );
    }
	
	public function getService() : IService
	{
		return cast target;
	}
}