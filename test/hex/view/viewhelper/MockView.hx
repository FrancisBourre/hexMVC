package hex.view.viewhelper;

/**
 * ...
 * @author Francis Bourre
 */
class MockView implements IView
{
	public function new()
	{

	}

	@:isVar
	public var visible( get, set ) : Bool;

	public function get_visible() : Bool
	{
		return false;
	}

	public function set_visible( visible : Bool ) : Bool
	{
		return visible;
	}
}
