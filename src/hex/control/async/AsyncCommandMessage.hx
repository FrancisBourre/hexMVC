package hex.control.async;

import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncCommandMessage
{
	public static var COMPLETE       = new MessageType( "onAsyncCommandComplete" );
    public static var FAIL           = new MessageType( "onAsyncCommandFail" );
    public static var CANCEL         = new MessageType( "onAsyncCommandCancel" );

	function new() 
	{
		
	}
}