package hex.module.dependency;

import hex.service.Service;

/**
 * @author Francis Bourre
 */
interface IRuntimeDependencies
{
    function hasServiceDependencies() : Bool;
    function addServiceDependencies( serviceDependencies : Array<Class<Service>> ) : Void;
    function getServiceDependencies() : Array<Class<Service>>;
}