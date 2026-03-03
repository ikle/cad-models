/*
 * Radio Components Storage Cell
 *
 * Copyright (c) 2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

use <MCAD/boxes.scad>

module hook (width = 5, height = 5, jump = 1, flange = 0.1)
{
	W = width;
	H = height;
	J = jump;
	T = flange;

	R  = W * W / (8*J) + J/2;
	D  = 2 * R;
	T2 = 2 * T;

	difference () {
		translate ([0, J - R, 0])
			union () {
				cylinder (h = H, r = R);
				sphere (R);
			}
		translate ([-R-T, -D, -R-T])
			cube ([D + T2, D, H + D + T2], false);
	}
}

module rbox (length = 30, width = 10, height = 2, radius = 7)
{
	L = length;
	W = width;
	H = height;
	R = radius;
	D = 2*R;

	BW = W - R;
	BL = L;

	SW = R;
	SL = L - D;
	SX = W/2 - SW;

	translate ([-W/2, -BL/2, -H/2]) cube ([BW, BL, H], false);
	translate ([SX,   -SL/2, -H/2]) cube ([SW, SL, H], false);

	difference () {
		union () {
			translate ([SX, +SL/2, -H/2]) cylinder (h = H, r = R);
			translate ([SX, -SL/2, -H/2]) cylinder (h = H, r = R);
		}
		translate ([-W/2-D, -L, -H]) cube ([D, 2*L, 2*H], false);
	}
}

module tbox (base1 = 25, base2 = 30, width = 30, height = 2, flange = 0.1)
{
	L1 = base1;
	L2 = base2;
	W  = width;
	H  = height;
	T  = flange;

	pts = [
		[-W, L1/2], [0, L2/2], [T, L2/2 - T],
		[T, T - L2/2], [0, -L2/2], [-W, -L1/2]
	];

	linear_extrude (height = H)
		polygon (pts);
}

module arm (width = 40, depth = 5, length = 10, thickness = 1, radius = 1)
{
	W = width;
	D = depth;
	L = length;
	T = thickness;
	R = radius;

	BW = D + L;

	translate ([BW/2 - D, 0, T/2]) rbox (W, BW, T, L * 2/3);

	/* hook */

	HL = W - 2*L;
	HW = (R + T) + T/2;

	translate ([L - T/2, 0, T/2])
		rotate ([0, -90, 0])
			translate ([HW/2, 0, 0])
				rbox (HL, HW, T, R + T);
}

module cell (width = 40, depth = 60, height = 15, thickness = 1, radius = .5,
	     arm = 6)
{
	W = width;
	D = depth;
	H = height;
	T = thickness;
	R = radius;

	HW = H/2;
	HH = H/3;
	HJ = T;

	difference () {
		union () {
			roundedBox ([D, W, H], R + T, true);
			translate ([D/2 - HW/2, 0, 0])
				rbox (W + 2*HJ, HW, H, R + T);
			translate ([D/2 - HW, 0, -H/2])
				tbox (W, W + 2*HJ, HW, H);
		}
		translate ([0, 0, T])
		roundedBox ([D - 2 * T, W - 2 * T, H], R, true);
	}

	translate ([0, +W/2, H/6]) hook (HW, HH, HJ);
	translate ([0, -W/2, H/6]) rotate ([0, 0, 180]) hook (HW, HH, HJ);

	AW = W + 2*HJ;
	AD = R + T;

	translate ([D/2, 0, -H/2]) arm (AW, AD, arm, T, R);
}

// $fa = 1; $fs = 0.4;
$fn = 32;

cell (40, 60, 15, 1, .5, 6);
