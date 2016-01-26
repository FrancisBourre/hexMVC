package hex.service.stateless;

import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncStatelessServiceMessage
{
	public static var TIMEOUT = new MessageType( "onServiceTimeout" );
	
	function new() 
	{
		
	}
}