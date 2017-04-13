package hex.log.layout;
import hex.log.LogEvent;
import hex.log.message.IDomainMessage;

/**
 * ...
 * @author ...
 */
class DomainLayout implements ILayout 
{

	public function new() 
	{
	}
	
	public function toString(message:LogEvent):String 
	{
		return if (Std.is(message.message, IDomainMessage)) 
		{
			'${(cast (message.message, IDomainMessage)).getDomain().getName()} - ${message.logger.getName()} - ${message.level} - ${message.message.getFormattedMessage()}';
		}
		else
		{
			'${message.logger.getName()} - ${message.level} - ${message.message.getFormattedMessage()}';
		}
		
	}
	
}