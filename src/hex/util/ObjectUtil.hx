package hex.util;
import hex.error.IllegalArgumentException;
import hex.ioc.core.ApplicationContext;
import hex.ioc.core.CoreFactory;

/**
 * ...
 * @author Francis Bourre
 */
class ObjectUtil
{
	private function new() 
	{
		
	}
	
	static public function fastEvalFromTarget( target : Dynamic, toEval : String, coreFactory : CoreFactory ) : Dynamic
	{
		var members : Array<String> = toEval.split( "." );
		var result 	: Dynamic;
		
		while ( members.length > 0 )
		{
			var member : String = members.shift();
			result = Reflect.field( target, member );
			
			if ( result == null )
			{
				if ( Std.is( target, ApplicationContext ) && coreFactory.isRegisteredWithKey( member ) )
				{
					result = coreFactory.locate( member );
					if ( members.length > 0 )
					{
						break;
						ObjectUtil.fastEvalFromTarget( target, toEval, coreFactory );
					}
				}
				else
				{
					throw new IllegalArgumentException( "ObjectUtil.fastEvalFromTarget(" + target + ", " + toEval + ", " + coreFactory + ") failed." );
				}
			}
			
			target = result;
		}
		
		return target;
	}
	
}