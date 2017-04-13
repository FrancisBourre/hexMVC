package hex.log.message;
import hex.domain.Domain;
/**
 * @author ...
 */


interface IDomainMessage extends IMessage
{
	function getDomain():Domain;
}
