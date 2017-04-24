package hex.log.message;
import hex.domain.Domain;
import hex.domain.TopLevelDomain;
import hex.log.message.IMessage;

/**
 * ...
 * @author ...
 */
class DomainMessageFactory implements IMessageFactory 
{
	var domain:Domain;

	public function new(domain:Domain)
	{
		this.domain = domain;
	}

	public function newMessage(message:String, ?params:Array<Dynamic>):IMessage
	{
		return new DomainMessage(domain, message, params);
	}

	public function newObjectMessage(message:Dynamic):IMessage
	{
		return new DomainObjectMessage(domain, message);
	}
	
}