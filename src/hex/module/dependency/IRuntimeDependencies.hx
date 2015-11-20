package hex.module.dependency;

import hex.service.IService;
import hex.service.Service;
import hex.service.ServiceEvent;

/**
 * @author Francis Bourre
 */
interface IRuntimeDependencies
{
    function hasServiceDependencies() : Bool;
    function addServiceDependencies( serviceDependencies : Array<Class<Service>> ) : Void;
    function getServiceDependencies() : Array<Class<Service>>;
}