package hex.config.stateful;

import hex.di.ISpeedInjectorContainer;
import hex.di.error.MissingMappingException;
import hex.config.stateful.IStatefulConfig;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.control.IFrontController;
import hex.di.IDependencyInjector;
import hex.event.IDispatcher;
import hex.event.MessageType;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
class StatefulCommandConfig implements IStatefulConfig implements ISpeedInjectorContainer
{
	var _frontController : IFrontController;
	
	public function new()
	{
		
	}
	
	/**
     * Configure will be invoked after dependencies have been supplied
     */
	public function configure( injector : IDependencyInjector, dispatcher : IDispatcher<{}>, module : IModule ) : Void
	{
		this._frontController = injector.getInstance( IFrontController );
		
		if ( this._frontController == null )
		{
			throw new MissingMappingException( "configure failed to retrieve IFrontController mapping" );
		}
	}
	
	/**
	 * Pair event type to a command class for future calls.
	 * @param	messageType The messageType to bind to command class
	 * @param	command 	The command class to be associated to this messageType
	 * @return
	 */
	public function map( messageType : MessageType, commandClass : Class<ICommand> ) : ICommandMapping
	{
		return this._frontController.map( messageType, commandClass );
	}
}