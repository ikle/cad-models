/*
 * Square PGA CPU Storage Tray
 *
 * Copyright (c) 2022-2025 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

$fn = 32;

module c_box (dx, dy, dz, z = 0)
{
	translate ([-dx/2, -dy/2, z]) cube ([dx, dy, dz]);
}

module c_donut (dx, dy, hx, hy, dz, z = 0)
{
	difference () {
		c_box (dx, dy, dz, z);
		c_box (hx, hy, dz + 2, z - 1);
	}
}

module s_box   (w,       h, z = 0)  { c_box   (w, w,             h, z); }
module s_donut (w, hole, h, z = 0)  { c_donut (w, w, hole, hole, h, z); }

module fixer (fw = 1.6, fh = 1.6, fl = 10, lip = 1.6, k = 0.7)
{
	ll = k * fl; fhl = k * fh;

	hull () {
		cube ([fw, fl, fh]);
		rotate (asin (lip/ll))
			translate ([0, 0, fh - fhl]) cube ([fw, ll, fhl]);
	}
}

module s_fixer (w, h, t)
{
	fh = 1.4 * t;
	translate ([w/2, -w/4 - 0.001, h - fh]) fixer (t, fh, 0.245 * w);
}

/*
 * w  -- package width
 * pw -- pin grid width
 * hw -- pin hole width
 * pt -- package thickness
 * pl -- pin length
 * t  -- base thickness
 * wt -- wall thickness
 */
module s_cell (w = 50, pw = 48, hw = 30, pt = 3.4, pl = 3, t = 1.6, wt = 3.2)
{
	union () {
		difference () {
			s_donut (w + 2*wt, hw - 2*t, t + pl + pt, 0);
			s_box (w, pt + 1, t + pl);                 // package
			s_donut (pw, hw, pl + 1, t);               // pin grid
			c_box (w + 2*wt + 1, w/2, pt + 1, t + pl); // fixer hole
			c_box (w/2, w + 2*wt + 1, pt + 1, t + pl); // thumb hole
		}
		s_fixer (w, t + pl + pt, t);			// right fixer
		rotate (180) s_fixer (w, t + pl + pt, t);	// left fixer
	}
}

module s_tray (nx, ny, w, pw, hw, pt, pl, t, wt)
{
	s = w + wt;

	union ()
		for (i = [0:nx-1], j = [0:ny-1])
			translate ([s*i, s*j, 0])
				s_cell (w, pw, hw, pt, pl, t, wt);
}

/*
 * CPU Tray for Socket 5, Socket 7, Socket 370, Socket A
 */
module s_tray_s5 (nx = 2, ny = 2, t = 1.6, wt = 3.2)
{
	s_tray (nx, ny, 50, 48, 30, 3.4, 3, t, wt);
}

scale ([1.008, 1.008, 1.02]) s_tray_s5 (2, 1);

