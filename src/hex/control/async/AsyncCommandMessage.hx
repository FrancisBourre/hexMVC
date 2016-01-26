package hex.control.async;

import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncCommandMessage
{
	public static var COMPLETE       : MessageType = new MessageType( "onAsyncCommandComplete" );
    public static var FAIL           : MessageType = new MessageType( "onAsyncCommandFail" );
    public static var CANCEL         : MessageType = new MessageType( "onAsyncCommandCancel" );

	function new() 
	{
		
	}
}