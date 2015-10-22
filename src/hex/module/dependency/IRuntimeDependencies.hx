package hex.module.dependency;

import hex.service.IService;

/**
 * @author Francis Bourre
 */
interface IRuntimeDependencies 
{
    function hasServiceDependencies() : Bool;
    function addServiceDependencies( serviceDependencies : Array<Class<IService>> ) : Void;
    function getServiceDependencies() : Array<Class<IService>>;
}