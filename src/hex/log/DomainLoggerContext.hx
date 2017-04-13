package hex.log;
import hex.domain.Domain;
import hex.log.ILogger;
import hex.log.ILoggerContext;
import hex.log.message.DomainMessageFactory;
import hex.log.message.IMessageFactory;

/**
 * ...
 * @author ...
 */
class DomainLoggerContext extends LoggerContext
{
	var domain:Domain;
	var defaultMessageFactory:DomainMessageFactory;

	public static function getContext():DomainLoggerContext
	{
		return cast LogManager.getContext();
	}
	
	public function new(domain:Domain)
	{
		super();
		this.domain = domain;
		this.defaultMessageFactory = new DomainMessageFactory(domain);
	}

	override function newInstance(context:LoggerContext, name:String, messageFactory:IMessageFactory):Logger
	{
		if (messageFactory == null)
		{
			messageFactory = defaultMessageFactory;
		}
		return super.newInstance(context, name, messageFactory);
	}

}
