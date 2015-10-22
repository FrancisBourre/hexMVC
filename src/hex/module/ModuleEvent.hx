package hex.module;

import hex.event.BasicEvent;

/**
 * ...
 * @author Francis Bourre
 */
class ModuleEvent extends BasicEvent
{
    public inline static var INITIALIZED       : String = "onModuleInitialisation";
    public inline static var RELEASED          : String = "onModuleRelease";

    public function new ( eventType : String, target : IModule )
    {
        super( type, target );
    }
	
	public function getModule() : IModule
	{
		return cast target;
	}
}
