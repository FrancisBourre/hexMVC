package hex.config.stateful;

import hex.di.IDependencyInjector;

/**
 * ...
 * @author Francis Bourre
 */
interface IStatefulConfig
{
    function configure( injector : IDependencyInjector ) : Void;
}
