package hex.view.viewhelper;

import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
class MainViewHelperManagerMessage
{
	inline static public var VIEW_HELPER_MANAGER_CREATION 	= new MessageType( "onViewHelperManagerCreation" );
	inline static public var VIEW_HELPER_MANAGER_RELEASE 	= new MessageType( "onViewHelperManagerRelease" );
	
	function new() 
	{
		
	}
}