package hex.control.trigger;

import hex.di.IDependencyInjector;
import hex.di.IInjectorContainer;
import hex.module.IContextModule;

/**
 * @author Francis Bourre
 */
#if !macro
@:autoBuild( hex.control.trigger.CommandTriggerBuilder.build() )
#end
interface ICommandTrigger extends IInjectorContainer
{
	var module     : IContextModule;
    var injector   : IDependencyInjector;
}