package hex.log.message;
import hex.domain.Domain;

/**
 * ...
 * @author ...
 */
class DomainObjectMessage extends ObjectMessage implements IDomainMessage 
{

	var domain:Domain;

	public function new(domain:Domain, obj:Dynamic)
	{
		super(obj);
		this.domain = domain;
	}

	public function getDomain():Domain
	{
		return domain;
	}
	
}