package hex.view.viewhelper;

import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
class ViewHelperManagerMessage
{
	static public var VIEW_HELPER_CREATION 	: MessageType = new MessageType( "onViewHelperCreation" );
	static public var VIEW_HELPER_RELEASE 	: MessageType = new MessageType( "onViewHelperRelease" );
	
	private function new() 
	{
		
	}
}