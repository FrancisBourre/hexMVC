package hex.config.stateless;

import hex.config.stateless.IStatelessConfig;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.control.IFrontController;
import hex.error.VirtualMethodException;

/**
 * ...
 * @author Francis Bourre
 */
@:rtti
class StatelessCommandConfig implements IStatelessConfig
{
	@inject
	private var frontController : IFrontController;

	public function new() 
	{
		
	}
	
	/**
     * Configure will be invoked after dependencies have been supplied
     */
	public function configure() : Void 
	{
		throw new VirtualMethodException( "'configure' is not implemented" );
	}
	
	/**
	 * Pair event type to a command class for future calls.
	 * @param	eventType 	The event type to bind to command class
	 * @param	command 	The command class to be associated to event type
	 * @return
	 */
	public function map( eventType : String, commandClass : Class<ICommand> ) : ICommandMapping
	{
		return this.frontController.map( eventType, commandClass );
	}
}