package hex.service.stateless;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessServiceEventType
{
	public inline static var COMPLETE       : String = "onServiceComplete";
    public inline static var FAIL 			: String = "onServiceFail";
    public inline static var CANCEL         : String = "onServiceCancel";
	
	private function new() 
	{
		
	}
}