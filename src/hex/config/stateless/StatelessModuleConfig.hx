package hex.config.stateless;

import hex.control.IFrontController;
import hex.control.command.ICommand;
import hex.di.IDependencyInjector;
import hex.di.IInjectorContainer;
import hex.error.VirtualMethodException;
import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessModuleConfig implements IStatelessConfig implements IInjectorContainer
{
	@Inject
	public var injector : IDependencyInjector;
	
	@Inject
	public var frontController : IFrontController;
	
	public function new() 
	{
		
	}
	
	public function configure() : Void 
	{
		throw new VirtualMethodException( this + ".configure must be overridden" );
	}
	
	public function mapCommand( messageType : MessageType, commandClass : Class<ICommand> ) : ICommandMapping
	{
		return this.frontController.map( messageType, commandClass );
	}
	
	public function mapController<ControllerType>( controllerInterface : Class<ControllerType>, controllerClass : Class<ControllerType>,  name : String = "" ) : Void
	{
		var instance : Dynamic = this.injector.instantiateUnmapped( controllerClass );
		this.injector.mapToValue( controllerInterface, instance, name );
	}
	
	public function mapModel<ModelType>( modelInterface : Class<ModelType>, modelClass : Class<ModelType>,  name : String = "" ) : Void
	{
		var instance : Dynamic = this.injector.instantiateUnmapped( modelClass );
		this.injector.mapToValue( modelInterface, instance, name );
		this.injector.mapToValue( Type.resolveClass( Type.getClassName( modelInterface ) + "RO" ), instance );
	}
}