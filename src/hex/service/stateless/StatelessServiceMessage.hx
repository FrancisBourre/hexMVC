package hex.service.stateless;

import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessServiceMessage
{
	public static var COMPLETE       = new MessageType( "onServiceComplete" );
    public static var FAIL 			= new MessageType( "onServiceFail" );
    public static var CANCEL         = new MessageType( "onServiceCancel" );
	
	function new() 
	{
		
	}
}