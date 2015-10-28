package hex.config.stateful;

import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.control.IFrontController;
import hex.di.IDependencyInjector;
import hex.error.VirtualMethodException;
import hex.event.IEvent;
import hex.event.IEventDispatcher;
import hex.module.IModule;
import hex.module.IModuleListener;

/**
 * ...
 * @author Francis Bourre
 */
@:rtti
class StatefulCommandConfig implements IStatefulConfig
{
	private var _frontController : IFrontController;
	
	public function new()
	{
		
	}
	
	/**
     * Configure will be invoked after dependencies have been supplied
     */
	public function configure( injector : IDependencyInjector ) : Void
	{
		this._frontController = injector.getInstance( IFrontController );
	}
	
	/**
	 * Pair event type to a command class for future calls.
	 * @param	eventType 	The event type to bind to command class
	 * @param	command 	The command class to be associated to event type
	 * @return
	 */
	public function map( eventType : String, commandClass : Class<ICommand> ) : ICommandMapping
	{
		return this._frontController.map( eventType, commandClass );
	}
}