package hex.service.stateless;

import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncStatelessServiceMessage
{
	public static var TIMEOUT : MessageType = new MessageType( "onServiceTimeout" );
	
	private function new() 
	{
		
	}
}