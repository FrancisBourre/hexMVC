package hex.module.dependency;

import hex.di.IDependencyInjector;
import hex.error.PrivateConstructorException;
import hex.log.Stringifier;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
class RuntimeDependencyChecker
{
    /** @private */
    private function new()
    {
        throw new PrivateConstructorException( "'RuntimeDependecyChecker' class can't be instantiated." );
    }

    static public function check( module : IModule, injector : IDependencyInjector, dependencies : IRuntimeDependencies ) : Void
    {
        if ( dependencies.hasServiceDependencies() )
        {
            var serviceDependencies : Array<Class<Dynamic>> = dependencies.getServiceDependencies();

            var len : Int = serviceDependencies.length;
            while ( --len > -1 )
            {
                var dependency : Class<Dynamic> = serviceDependencies[ len ];

                if ( !injector.hasMapping( dependency ) )
                {
                    throw new RuntimeDependencyException( "'" + dependency + "' class dependency is not available during '" + Stringifier.stringify( module ) + "' initialisation." );
                }

                serviceDependencies.splice( len, 1 );
            }
        }

    }
}
