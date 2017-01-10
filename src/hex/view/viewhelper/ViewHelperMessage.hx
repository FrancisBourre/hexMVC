package hex.view.viewhelper;

import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
class ViewHelperMessage
{
	inline static public var INIT 			= new MessageType( "onInit" );
	inline static public var RELEASE 		= new MessageType( "onRelease" );
	inline static public var ATTACH_VIEW 	= new MessageType( "onAttachView" );
	inline static public var REMOVE_VIEW 	= new MessageType( "onRemoveView" );
	
	function new() 
	{
		
	}
}