package hex.service.stateless;

import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessServiceMessage
{
	public static var COMPLETE       : MessageType = new MessageType( "onServiceComplete" );
    public static var FAIL 			: MessageType = new MessageType( "onServiceFail" );
    public static var CANCEL         : MessageType = new MessageType( "onServiceCancel" );
	
	function new() 
	{
		
	}
}