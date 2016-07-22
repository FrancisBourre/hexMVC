package hex.view;

/**
 * ...
 * @author Francis Bourre
 */
class BasicView implements IView
{
	public function new() 
	{
		this.visible = true;
	}
	
	@:isVar public var visible( get, set ) : Bool;
	
	function get_visible() : Bool 
	{
		return visible;
	}
	
	function set_visible( value : Bool ) : Bool 
	{
		return visible = value;
	}
}