package hex.module;

import hex.event.IEventListener;

/**
 * @author Francis Bourre
 */
interface IModuleListener extends IEventListener
{
	function onModuleInitialisation( e : ModuleEvent ) : Void;
	function onModuleRelease( e : ModuleEvent ) : Void;
}