package hex.log.message;
import hex.domain.Domain;

/**
 * ...
 * @author ...
 */
class DomainMessage extends ParameterizedMessage implements IDomainMessage 
{

	var domain:Domain;

	public function new(domain:Domain, message:String, params:Array<Dynamic>)
	{
		super(message, params);
		this.domain = domain;
	}

	public function getDomain():Domain
	{
		return domain;
	}
	
}