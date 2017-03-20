package hex.control.trigger;

import hex.di.IDependencyInjector;
import hex.di.IInjectorContainer;
import hex.module.IModule;

/**
 * @author Francis Bourre
 */
#if !macro
@:autoBuild( hex.control.trigger.CommandTriggerBuilder.build() )
#end
interface ICommandTrigger extends IInjectorContainer
{
	var module     : IModule;
    var injector   : IDependencyInjector;
}