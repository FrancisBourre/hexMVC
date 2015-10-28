package hex.control;

import hex.control.command.CommandExecutor;
import hex.control.command.CommandMapping;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.di.IDependencyInjector;
import hex.module.IModule;
import hex.event.IEvent;
import hex.event.IEventListener;
import hex.event.IEventDispatcher;
import hex.collection.BaseLocator;

/**
 * ...
 * @author Francis Bourre
 */
@:rtti
class FrontController extends BaseLocator<String, ICommandMapping> implements IFrontController
{
    private var _module     : IModule;
    private var _injector   : IDependencyInjector;
    private var _dispatcher : IEventDispatcher<IEventListener, IEvent>;

    public function new( dispatcher : IEventDispatcher<IEventListener, IEvent>, injector : IDependencyInjector, ?module : IModule )
    {
        super();

        this._dispatcher        = dispatcher;
        this._injector          = injector;
        this._module            = module;
    }

    public function map( eventType : String, commandClass : Class<ICommand> ) : ICommandMapping
    {
        var commandMapping : ICommandMapping = new CommandMapping( commandClass );
        this.register( eventType, commandMapping );
        this._dispatcher.addEventListener( eventType, this._handleEvent );
        return commandMapping;
    }

    public function unmap( eventType : String ) : ICommandMapping
    {
        var commandMapping : ICommandMapping = this.locate( eventType );
        this.unregister( eventType );
        this._dispatcher.removeEventListener( eventType, this._handleEvent );
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

			e.target = this._dispatcher;
            commandExecutor.executeCommand( e, commandMapping, mappingRemoval );
        }
    }
}
