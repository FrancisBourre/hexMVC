package hex.di.provider;
import hex.di.IDependencyInjector;
import hex.log.ILogger;
import hex.log.LogManager;
import hex.log.message.DomainMessageFactory;

/**
 * ...
 * @author ...
 */
class DomainLoggerProvider implements IDependencyProvider<ILogger> 
{
	var messageFactory:DomainMessageFactory;
	var fallbackLogger:ILogger;

	public function new(messageFactory:DomainMessageFactory, fallbackLogger:ILogger) 
	{
		this.fallbackLogger = fallbackLogger;
		this.messageFactory = messageFactory;
	}
	
	public function destroy():Void 
	{
		messageFactory = null;
	}
	
	public function getResult(injector:IDependencyInjector, target:Class<Dynamic>):ILogger 
	{
		return if (target == null) fallbackLogger
		else LogManager.getLoggerByClass(target, messageFactory);
	}
	
}