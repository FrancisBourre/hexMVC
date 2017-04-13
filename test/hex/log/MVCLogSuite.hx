package hex.log;

/**
 * ...
 * @author ...
 */
class MVCLogSuite 
{
	@Suite( "Logging" )
    public var list : Array<Class<Dynamic>> = [
		DomainLoggerProviderTest,
		DomainFilterTest
	];
}