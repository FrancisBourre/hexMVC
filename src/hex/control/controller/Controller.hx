package hex.control.controller;

import hex.control.controller.IController;
import hex.di.IDependencyInjector;
import hex.di.IInjectorContainer;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
@:autoBuild( hex.control.controller.ControllerBuilder.build() )
class Controller implements IController implements IInjectorContainer
{
	@Inject
	public var module     		: IModule;
	
	@Inject
    public var injector   		: IDependencyInjector;
	
	function new() 
	{

	}
}