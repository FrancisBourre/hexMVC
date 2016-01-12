package hex.view.viewhelper;
import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
class ViewHelperMessage
{
	static public var INIT 			: MessageType = new MessageType( "onInit" );
	static public var RELEASE 		: MessageType = new MessageType( "onRelease" );
	static public var ATTACH_VIEW 	: MessageType = new MessageType( "onAttachView" );
	static public var REMOVE_VIEW 	: MessageType = new MessageType( "onRemoveView" );
	
	private function new() 
	{
		
	}
}