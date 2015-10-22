package hex.module;

import hex.event.IEvent;
import hex.event.IEventDispatcher;
import hex.di.IDependencyInjector;

/**
 * ...
 * @author Francis Bourre
 */
interface IRuntimeConfigurable
{
    function configure( injector : IDependencyInjector, dispatcher : IEventDispatcher<IModuleListener, IEvent>, module : IModule ) : Void;
}
