package hex.control.controller;
import hex.control.controller.IController;
import hex.di.IDependencyInjector;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
@:autoBuild( hex.control.controller.ControllerBuilder.build() )
class Controller implements IController
{
	var _module     		: IModule;
    var _injector   		: IDependencyInjector;
	
	public function new( injector : IDependencyInjector, ?module : IModule ) 
	{
		this._injector 				= injector;
        this._module 				= module;
	}
}