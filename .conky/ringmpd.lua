require 'cairo'

function conky_my_ring()
    --if conky_window==nil then return end
    local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
    local cr=cairo_create(cs)
	-- ring (cr, 'time', '%S', 60, 0x00FF00, 1, 0xccFFcc, 1, 100, 100, 50, 15, 0, 360);
	ring(cr, 'mpd_percent', '', 100, 0xffffff, 0.1, 0xffffff, 0.6, 0, 384, 175, 20, 0, 180)
	cairo_destroy(cr)
end
