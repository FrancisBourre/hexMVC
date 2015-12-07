package hex.control;

import hex.collection.LocatorEvent;
import hex.control.command.CommandExecutor;
import hex.control.command.CommandMapping;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.di.IDependencyInjector;
import hex.module.IModule;
import hex.event.IEvent;
import hex.event.IEventListener;
import hex.event.IEventDispatcher;
import hex.collection.Locator;

/**
 * ...
 * @author Francis Bourre
 */
@:rtti
class FrontController extends Locator<String, ICommandMapping, LocatorEvent<String, ICommandMapping>> implements IFrontController
{
    private var _module     		: IModule;
    private var _injector   		: IDependencyInjector;
    private var _facadeDispatcher 	: IEventDispatcher<IEventListener, IEvent>;

    public function new( facadeDispatcher : IEventDispatcher<IEventListener, IEvent>, injector : IDependencyInjector, ?module : IModule )
    {
        super();

        this._facadeDispatcher 		= facadeDispatcher;
        this._injector 				= injector;
        this._module 				= module;
    }

    public function map( eventType : String, commandClass : Class<ICommand> ) : ICommandMapping
    {
        var commandMapping : ICommandMapping = new CommandMapping( commandClass );
        this.register( eventType, commandMapping );
        this._facadeDispatcher.addEventListener( eventType, this._handleEvent );
        return commandMapping;
    }

    public function unmap( eventType : String ) : ICommandMapping
    {
        var commandMapping : ICommandMapping = this.locate( eventType );
        this.unregister( eventType );
        this._facadeDispatcher.removeEventListener( eventType, this._handleEvent );
        return commandMapping;
    }

    private function _handleEvent( e : IEvent ) : Void
    {
        if ( this.isRegisteredWithKey( e.type ) )
        {
            var commandMapping : ICommandMapping    = this.locate( e.type );
            var commandExecutor : CommandExecutor   = new CommandExecutor( this._injector, this._module );

            var mappingRemoval : Void->ICommandMapping  = null;
            if ( commandMapping.isFiredOnce )
            {
                mappingRemoval = this.unmap.bind( e.type );
            }

			e.target = this._facadeDispatcher;
            commandExecutor.executeCommand( commandMapping, e, mappingRemoval );
        }
    }
	
	override function _dispatchRegisterEvent( key : String, element : ICommandMapping ) : Void 
	{
		this._dispatcher.dispatchEvent( new LocatorEvent( LocatorEvent.REGISTER, this, key, element ) );
	}
	
	override function _dispatchUnregisterEvent( key : String ) : Void 
	{
		this._dispatcher.dispatchEvent( new LocatorEvent( LocatorEvent.UNREGISTER, this, key ) );
	}
}
