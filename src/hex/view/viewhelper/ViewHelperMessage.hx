package hex.view.viewhelper;
import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
class ViewHelperMessage
{
	static public var INIT 			= new MessageType( "onInit" );
	static public var RELEASE 		= new MessageType( "onRelease" );
	static public var ATTACH_VIEW 	= new MessageType( "onAttachView" );
	static public var REMOVE_VIEW 	= new MessageType( "onRemoveView" );
	
	function new() 
	{
		
	}
}