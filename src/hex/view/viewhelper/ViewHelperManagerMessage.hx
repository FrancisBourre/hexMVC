package hex.view.viewhelper;

import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
class ViewHelperManagerMessage
{
	static public var VIEW_HELPER_CREATION 	= new MessageType( "onViewHelperCreation" );
	static public var VIEW_HELPER_RELEASE 	= new MessageType( "onViewHelperRelease" );
	
	function new() 
	{
		
	}
}