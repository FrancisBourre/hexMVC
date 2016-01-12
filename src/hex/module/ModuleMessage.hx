package hex.module;

import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
class ModuleMessage
{
	public static var INITIALIZED       : MessageType = new MessageType( "onModuleInitialisation" );
    public static var RELEASED          : MessageType = new MessageType( "onModuleRelease" );
	
	private function new() 
	{
		
	}
}