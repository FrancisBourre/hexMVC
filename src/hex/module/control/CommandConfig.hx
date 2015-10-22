package hex.module.control;

import hex.control.ICommand;
import hex.control.ICommandMapping;
import hex.control.IFrontController;
import hex.event.IEventDispatcher;
import hex.module.IModule;
import hex.di.IDependencyInjector;
import hex.module.IRuntimeConfigurable;

/**
 * ...
 * @author Francis Bourre
 */
class CommandConfig implements IRuntimeConfigurable
{
	@inject
	public var frontController : IFrontController;

	public function new() 
	{
		
	}
	
	/**
     * Configure will be invoked after dependencies have been supplied
     */
	public function configure( injector : IDependencyInjector, dispatcher : IEventDispatcher<IModuleListener, IEvent>, module : IModule ) : Void 
	{
		
	}
	
	/**
	 * Pair event type to a command class for future calls.
	 * @param	eventType 	The event type to bind to command class
	 * @param	command 	The command class to be associated to event type
	 * @return
	 */
	public function map( eventType : String, command : ICommand ) : ICommandMapping
	{
		return this.frontController.map( eventType, command );
	}
}