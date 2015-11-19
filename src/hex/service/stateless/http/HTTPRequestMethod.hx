package hex.service.stateless.http;

/**
 * @author Francis Bourre
 */
@:enum
abstract HTTPRequestMethod( String )
{
	var GET = "GET";
	var POST = "POST";
}