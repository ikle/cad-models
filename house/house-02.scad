/*
 * House 02 Model: A house built from profiled timber
 *
 * Copyright (c) 2026 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

bh = 125;	/* beam height		*/
bw = 180;	/* beam wifth		*/
bf = 10;	/* beam facet size	*/
be = 200;	/* beam extension	*/

odw = 1000;	/* outer door width	*/
oww = 600;	/* outer windows width	*/
idw = 800;	/* inner door width	*/

hbh = bh / 2;
hbw = bw / 2;

be2 = 2 * be;
be3 = 3 * be;
be4 = 4 * be;
be5 = 5 * be;

module fxcube (dx, dy, dz, df = bf)
{
	hull () {
		translate ([0, df, 0]) cube ([dx, dy - 2*df, dz]);
		translate ([0, 0, df]) cube ([dx, dy, dz - 2*df]);
	}
}

module fycube (dx, dy, dz, df = bf)
{
	hull () {
		translate ([df, 0, 0]) cube ([dx - 2*df, dy, dz]);
		translate ([0, 0, df]) cube ([dx, dy, dz - 2*df]);
	}
}

module xbeam (x, y, zi, dx, lx = be, rx = be)
{
	length = lx + (dx + bw) + rx;
	z = bh * zi;

	translate ([x - lx, y, z]) fxcube (length, bw, bh);
}

module ybeam (x, y, zi, dy, ly = be, ry = be)
{
	length = ly + (dy + bw) + ry;
	z = hbh + bh * zi;

	translate ([x, y - ly, z]) fycube (bw, length, bh);
}

module BX (lo, hi, x, y, dx, lx = be, rx = be)
{
	for (zi = [lo:hi]) xbeam (x, y, zi, dx, lx, rx);
}

module BY (lo, hi, x, y, dy, ly = be, ry = be)
{
	for (zi = [lo:hi]) ybeam (x, y, zi, dy, ly, ry);
}

module FB (x, y, zi, dx, dy, dz)
{
	z = bh * zi;

	color ([.3, .5, .2, .1]) translate ([x, y, z]) cube ([dx, dy, dz]);
}

gx = 2000 + bw;
gy = 2000 + bw;

x0 = -hbw; x1 = x0 + gx; x2 = x1 + gx; x3 = x2 + gx; x4 = x3 + gx; x5 = x4 + gx;
y0 = -hbw; y1 = y0 + gy; y2 = y1 + gy; y3 = y2 + gy; y4 = y3 + gy;

xa = x2 - gx / 2;
xb = x2 + gx / 2;

/* floors, note: alpha color channel does not work good in prefiew */

// FB (x0, y0, -1, x4 - x0 + bw, y4 - y0 + bw, bh);
// FB (x4, y1, -1, x5 - x4 + bw, y4 - y1 + bw, bh);

// FB (x0, y0, 23, x4 - x0 + bw, y4 - y0 + bw, bh * 1.5);

/* X at Y0 */

fdx = ((x3 - x1 - bw) - (odw + 2 * oww)) / 6;
fbe = fdx - hbw;

xl = x1 + (hbw + fdx + oww + fdx);
xr = x3 - (hbw + fdx + oww + fdx);

BX ( 0, 17, x0, y0, x1 - x0, be, fdx);
BX (18, 22, x0, y0, x4 - x0);

color ([.7, .5, .2, 1]) BX (23, 23, x0, y0, x4 - x0);

BX ( 0, 17, xl, y0, 0, fbe, fbe);
BX ( 0, 17, xr, y0, 0, fbe, fbe);

BX ( 0, 17, x3, y0, x4 - x3, fdx, be);

/* X at Y1 */

BX ( 0, 18, x0, y1, x1 - x0, be, be2);
BX (19, 20, x0, y1, x4 - x0);
BX (21, 22, x0, y1, x5 - x0);

color ([.7, .5, .2, 1]) BX (23, 23, x0, y1, x5 - x0);

BX (24, 34, xb, y1, x4 - xb);

bath_w = (x4 - x3 - bw) - idw;

BX ( 0, 15, x3, y1, x3 - x3, be2, bath_w / 2);
BX (16, 18, x3, y1, x4 - x3, be2);

BX ( 0,  1, x4, y1, x5 - x4, bath_w / 2);
BX ( 2,  7, x4, y1, x4 - x4, bath_w / 2);
BX ( 8,  8, x4, y1, x5 - x4, bath_w / 2);
BX ( 9, 15, x4, y1, x4 - x4, bath_w / 2);

BX ( 2,  7, x5, y1, x5 - x5);

/* X at Y2 */

color ([.7, .5, .2, 1]) BX (23, 23, x1, y2, x5 - x1);

BX (21, 22, x4, y2, x5 - x4);

BX ( 1,  8, x5, y2, 0);

/* X at Y3 */

BX ( 0, 17, x0, y3, x0 - x0, be, be2);
BX (18, 20, x0, y3, x4 - x0);
BX (21, 22, x0, y3, x5 - x0);

color ([.7, .5, .2, 1]) BX (23, 23, x0, y3, x5 - x0);

BX ( 0, 17, x1, y3, x1 - x1, be2, be2);

BX ( 0, 17, x3, y3, x3 - x3, be2, be2);

BX ( 0, 17, x4, y3, x4 - x4, be2, be );

BX ( 1,  8, x5, y3, 0);

/* X at Y4 */

BX ( 0,  1, x0, y4, x5 - x0);
BX ( 2,  7, x0, y4, 0);
BX ( 8,  8, x0, y4, x5 - x0);

BX ( 2,  7, xa, y4, 0);
BX ( 2,  7, xb, y4, 0);
BX ( 2,  7, x4, y4, 0);
BX ( 2,  7, x5, y4, 0);

/* X at Y4, floor 2 */

BX (21, 21, x0, y4, 0);
BX (22, 22, x0, y4, x5 - x0);
color ([.7, .5, .2, 1]) BX (23, 23, x0, y4, x5 - x0);
BX (24, 24, x0, y4, x4 - x0);
BX (25, 31, x0, y4, 0);
BX (32, 32, x0, y4, x4 - x0);

BX (25, 31, xa, y4, 0);
BX (51, 52, xa, y4, xb - xa);

BX (25, 31, xb, y4, 0);

BX (21, 21, x4, y4, x5 - x4);
BX (25, 31, x4, y4, 0);

/* Y at X0 */

wbe = (y3 - y1 - bw) / 5;

color ([.7, .5, .2, 1]) BY (-1, -1, x0, y0, y4 - y0);

BY ( 0,  0, x0, y0, y4 - y0);
BY ( 1,  5, x0, y0, y3 - y0);
BY ( 6, 16, x0, y0, y1 - y0, be, wbe);
BY (17, 20, x0, y0, y3 - y0);

BY (21, 22, x0, y0, y4 - y0);
color ([.7, .5, .2, 1]) BY (23, 23, x0, y0, y4 - y0);
BY (24, 30, x0, y0, y3 - y0);
BY (31, 31, x0, y0, y4 - y0);
BY (32, 32, x0, y0, y4 - y0, be2, be2);
BY (33, 34, x0, y0, y4 - y0, be3, be3);

BY ( 6,  6, x0, y3, y3 - y3, wbe, be);
BY ( 7,  7, x0, y3, y4 - y3, wbe, be);
BY ( 8, 16, x0, y3, y3 - y3, wbe, be);

BY ( 1,  6, x0, y4, y4 - y4);
BY (24, 30, x0, y4, y4 - y4);

/* Y at X1 */

color ([.7, .5, .2, 1]) BY (-1, -1, x1, y0, y3 - y0);

BY ( 0, 18, x1, y0, y0 - y0, be , be2);
BY (19, 21, x1, y0, y3 - y0);

BY ( 0, 17, x1, y1, y1 - y1, be2, be2);
BY (18, 18, x1, y1, y3 - y1, be2, be );

BY ( 0, 17, x1, y3, y3 - y3, be3, be );

/* Y at XA */

color ([.7, .5, .2, 1]) BY (23, 23, xa, y0, y4 - y0);

BY (49, 50, xa, y0, y4 - y0, be3, be3);

BY (21, 21, xa, y1, 0);
BY (24, 33, xa, y1, 0);
BY (34, 34, xa, y1, y3 - y1);
BY (35, 48, xa, y1, 0);

BY (21, 21, xa, y3, y4 - y3);
BY (24, 33, xa, y3, 0);
BY (35, 48, xa, y3, 0);

BY ( 0,  7, xa, y4, 0);
BY (22, 22, xa, y4, 0);
BY (24, 31, xa, y4, 0);

/* Y at X2 */

BY (24, 52, x2, y0, 0);
BY (53, 53, x2, y0, y3);
BY (54, 54, x2, y0, y4 - y0, be2, be2);
BY (55, 56, x2, y0, y4 - y0, be3, be3);

/* Y at XB */

color ([.7, .5, .2, 1]) BY (23, 23, xb, y0, y4 - y0);

BY (49, 50, xb, y0, y4 - y0, be3, be3);

BY (21, 21, xb, y1, 0);
BY (24, 33, xb, y1, 0);
BY (34, 34, xb, y1, y3 - y1);
BY (35, 48, xb, y1, 0);

BY (21, 21, xb, y3, y4 - y3);
BY (24, 33, xb, y3, 0);
BY (35, 48, xb, y3, 0);

BY ( 0,  7, xb, y4, 0);
BY (22, 22, xb, y4, 0);
BY (24, 31, xb, y4, 0);

/* Y at X3 */

color ([.7, .5, .2, 1]) BY (-1, -1, x3, y0, y3 - y0);

bww = (x3 - x1 - bw) - (idw + be2);

BY ( 0, 14, x3, y0, y1 - y0, be, be2);
BY (15, 21, x3, y0, y3 - y0);

BY ( 0, 14, x3, y3, y3 - y3, bww);

/* Y at X4 */

color ([.7, .5, .2, 1]) BY (-1, -1, x4, y0, y3 - y0);

rdw = 1000;

BY ( 0, 17, x4, y0, y1 - y0, be, rdw);
BY (18, 20, x4, y0, y3 - y0);

BY (21, 22, x4, y0, y4 - y0);
color ([.7, .5, .2, 1]) BY (23, 23, x4, y0, y4 - y0);
BY (24, 30, x4, y0, y3 - y0);
BY (31, 31, x4, y0, y4 - y0);
BY (32, 32, x4, y0, y4 - y0, be2, be2);
BY (33, 34, x4, y0, y4 - y0, be3, be3);

BY ( 0, 17, x4, y3, y3 - y3, (y3 - y1 - bw) - (rdw + odw));

BY ( 0,  7, x4, y4, y4 - y4);
BY (24, 30, x4, y4, y4 - y4);

/* Y at X5 */

BY ( 0,  1, x5, y1, y4 - y1);
BY ( 2,  7, x5, y1, y1 - y1);
BY ( 8,  8, x5, y1, y4 - y1);

BY (21, 21, x5, y1, y4 - y1, be2, be2);
BY (22, 23, x5, y1, y4 - y1, be3, be3);

BY ( 2,  7, x5, y2, 0);
BY ( 2,  7, x5, y3, 0);

